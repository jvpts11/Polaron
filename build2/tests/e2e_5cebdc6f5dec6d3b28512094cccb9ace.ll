; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/object_collections.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/object_collections.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Box = type { ptr, i32 }
%class.Node = type { ptr, i32, ptr }
%"class.ArrayList$Node" = type { ptr, ptr, i32 }
%"class.HashMap$int$Box" = type { ptr, ptr, ptr, ptr, i32, i32 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$Node" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Box.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Node.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"HashMap$int$Box.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$int$Box.size", ptr @"HashMap$int$Box.isEmpty", ptr @"HashMap$int$Box.slotFor", ptr @"HashMap$int$Box.grow", ptr @"HashMap$int$Box.put", ptr @"HashMap$int$Box.get", ptr @"HashMap$int$Box.containsKey", ptr @"HashMap$int$Box.getOrDefault", ptr @"HashMap$int$Box.merge", ptr @"HashMap$int$Box.remove", ptr @"HashMap$int$Box.keyArray", ptr @"HashMap$int$Box.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$int$Box.~HashMap$int$Box"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$Node.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$Node.toArray", ptr @"ArrayList$Node.size", ptr @"ArrayList$Node.isEmpty", ptr null, ptr null, ptr null, ptr @"ArrayList$Node.get", ptr null, ptr null, ptr null, ptr @"ArrayList$Node.remove", ptr null, ptr null, ptr @"ArrayList$Node.add", ptr @"ArrayList$Node.ensureCapacity", ptr @"ArrayList$Node.set", ptr @"ArrayList$Node.indexOf", ptr @"ArrayList$Node.contains", ptr @"ArrayList$Node.removeAt", ptr @"ArrayList$Node.insertAt", ptr @"ArrayList$Node.clear", ptr @"ArrayList$Node.forEach", ptr @"ArrayList$Node.filter", ptr @"ArrayList$Node.any", ptr @"ArrayList$Node.all", ptr @"ArrayList$Node.count", ptr @"ArrayList$Node.sortedBy", ptr @"ArrayList$Node.mergeSortRange", ptr @"ArrayList$Node.find", ptr @"ArrayList$Node.min", ptr @"ArrayList$Node.max", ptr @"ArrayList$Node.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$Node.~ArrayList$Node"]
@"ArrayListIterator$Node.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$Node.hasNext", ptr @"ArrayListIterator$Node.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [39 x i8] c"kids=%d k0=%d k1=%d mapv7=%d mapv9=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.contract.198 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$Box.HashMap$int$Box\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.199 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.200 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.201 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$Box.HashMap$int$Box\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.202 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.203 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.204 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$Box.HashMap$int$Box\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.205 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$Box.HashMap$int$Box\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.206 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$Box.HashMap$int$Box\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.207 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$int$Box.slotFor\0A\00", align 1
@.faila.208 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.209 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.210 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$int$Box.slotFor\0A\00", align 1
@.faila.211 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.212 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.213 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$int$Box.grow\0A\00", align 1
@.faila.214 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.215 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.216 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$int$Box.grow\0A\00", align 1
@.faila.217 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.218 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.219 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$int$Box.grow\0A\00", align 1
@.faila.220 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.221 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.222 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$int$Box.grow\0A\00", align 1
@.faila.223 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.224 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.225 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$int$Box.grow\0A\00", align 1
@.faila.226 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.227 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.228 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$int$Box.grow\0A\00", align 1
@.faila.229 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.230 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.231 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$int$Box.grow\0A\00", align 1
@.faila.232 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.233 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.234 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$int$Box.grow\0A\00", align 1
@.faila.235 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.236 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.237 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$Box.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.238 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.239 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.240 = private unnamed_addr constant [117 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$Box.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.241 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.242 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.243 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$Box.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.244 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$Box.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.245 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$Box.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.246 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$int$Box.put\0A\00", align 1
@.faila.247 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.248 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.249 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$int$Box.put\0A\00", align 1
@.faila.250 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.251 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.252 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$int$Box.put\0A\00", align 1
@.faila.253 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.254 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.255 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$int$Box.put\0A\00", align 1
@.faila.256 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.257 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.258 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$Box.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.259 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.260 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.261 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$Box.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.262 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.263 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.264 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$Box.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.265 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$Box.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.266 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$Box.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.267 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$int$Box.get\0A\00", align 1
@.faila.268 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.269 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.270 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$int$Box.containsKey\0A\00", align 1
@.faila.271 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.272 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.273 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$int$Box.getOrDefault\0A\00", align 1
@.faila.274 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.275 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.276 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$int$Box.getOrDefault\0A\00", align 1
@.faila.277 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.278 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.279 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$int$Box.merge\0A\00", align 1
@.faila.280 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.281 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.282 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$int$Box.merge\0A\00", align 1
@.faila.283 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.284 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.285 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$int$Box.merge\0A\00", align 1
@.faila.286 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.287 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.288 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$int$Box.merge\0A\00", align 1
@.faila.289 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.290 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.291 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$int$Box.merge\0A\00", align 1
@.faila.292 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.293 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.294 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$int$Box.merge\0A\00", align 1
@.faila.295 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.296 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.297 = private unnamed_addr constant [112 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$Box.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.298 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.299 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.300 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$Box.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.301 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.302 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.303 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$Box.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.304 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$Box.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.305 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$Box.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.306 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$int$Box.remove\0A\00", align 1
@.faila.307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.309 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$Box.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.310 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.311 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.312 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$Box.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.313 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.314 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.315 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$Box.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.316 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$int$Box.remove\0A\00", align 1
@.faila.317 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.318 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.319 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$int$Box.remove\0A\00", align 1
@.faila.320 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.321 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.322 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$int$Box.remove\0A\00", align 1
@.faila.323 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.324 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.325 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$int$Box.remove\0A\00", align 1
@.faila.326 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.327 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.328 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$int$Box.remove\0A\00", align 1
@.faila.329 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.330 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.331 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$Box.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.332 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.333 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.334 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$Box.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.335 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.336 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.337 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$Box.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.338 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$int$Box.keyArray\0A\00", align 1
@.faila.339 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.340 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.341 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$int$Box.keyArray\0A\00", align 1
@.faila.342 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.343 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.344 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$int$Box.keyArray\0A\00", align 1
@.faila.345 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.346 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.347 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$int$Box.valueArray\0A\00", align 1
@.faila.348 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.349 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.350 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$int$Box.valueArray\0A\00", align 1
@.faila.351 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.352 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.353 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$int$Box.valueArray\0A\00", align 1
@.faila.354 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.355 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1454 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.ArrayList$Node\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1455 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1456 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1457 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.ArrayList$Node\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1458 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Node.add\0A\00", align 1
@.faila.1459 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1460 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1461 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Node.add\0A\00", align 1
@.faila.1462 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1463 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1464 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$Node.add\0A\00", align 1
@.faila.1465 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1466 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1467 = private unnamed_addr constant [122 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$Node.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1468 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1469 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1470 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1471 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1472 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Node.ensureCapacity\0A\00", align 1
@.faila.1473 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1474 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1475 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Node.ensureCapacity\0A\00", align 1
@.faila.1476 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1477 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1478 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1479 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1480 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1481 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1482 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$Node.get\0A\00", align 1
@.faila.1483 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1484 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1485 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$Node.get\0A\00", align 1
@.faila.1486 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1487 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1488 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$Node.set\0A\00", align 1
@.faila.1489 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1490 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1491 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1492 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$Node.set\0A\00", align 1
@.faila.1493 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1494 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1495 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1496 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$Node.indexOf\0A\00", align 1
@.faila.1497 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1498 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1499 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$Node.removeAt\0A\00", align 1
@.faila.1500 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1501 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1502 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1503 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1504 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1505 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1506 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Node.removeAt\0A\00", align 1
@.faila.1507 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1508 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1509 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Node.removeAt\0A\00", align 1
@.faila.1510 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1511 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1512 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1513 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1514 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1515 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1516 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$Node.insertAt\0A\00", align 1
@.faila.1517 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1518 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1519 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1520 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1521 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1522 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1523 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Node.insertAt\0A\00", align 1
@.faila.1524 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1525 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1526 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Node.insertAt\0A\00", align 1
@.faila.1527 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1528 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1529 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Node.insertAt\0A\00", align 1
@.faila.1530 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1531 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1532 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Node.insertAt\0A\00", align 1
@.faila.1533 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1534 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1535 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$Node.insertAt\0A\00", align 1
@.faila.1536 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1537 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1538 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1539 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1540 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1541 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1542 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1543 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1544 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1545 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1546 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Node.toArray\0A\00", align 1
@.faila.1547 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1548 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1549 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Node.toArray\0A\00", align 1
@.faila.1550 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1551 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1552 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$Node.forEach\0A\00", align 1
@.faila.1553 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1554 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1555 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$Node.filter\0A\00", align 1
@.faila.1556 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1557 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1558 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$Node.filter\0A\00", align 1
@.faila.1559 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1560 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1561 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$Node.any\0A\00", align 1
@.faila.1562 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1563 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1564 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$Node.all\0A\00", align 1
@.faila.1565 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1566 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1567 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$Node.count\0A\00", align 1
@.faila.1568 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1569 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1570 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$Node.sortedBy\0A\00", align 1
@.faila.1571 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1572 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1573 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Node.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1574 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1575 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1576 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1577 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1578 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1579 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1580 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1581 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1582 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1583 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1584 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1585 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1586 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1587 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1588 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1589 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1590 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1591 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1592 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1593 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1594 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1595 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1596 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1597 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1598 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1599 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1600 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1601 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1602 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1603 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1604 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1605 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1606 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1607 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1608 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1609 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1610 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1611 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1612 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1613 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1614 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1615 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1616 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1617 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1618 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1619 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1620 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1621 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1622 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1623 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1624 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1625 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1626 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1627 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1628 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1629 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1630 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1631 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1632 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1633 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1634 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Node.mergeSortRange\0A\00", align 1
@.faila.1635 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1636 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1637 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Node.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1638 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$Node.find\0A\00", align 1
@.faila.1639 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1640 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1641 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$Node.find\0A\00", align 1
@.faila.1642 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1643 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1644 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$Node.min\0A\00", align 1
@.faila.1645 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1646 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1647 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$Node.min\0A\00", align 1
@.faila.1648 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1649 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1650 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$Node.min\0A\00", align 1
@.faila.1651 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1652 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1653 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$Node.max\0A\00", align 1
@.faila.1654 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1655 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1656 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$Node.max\0A\00", align 1
@.faila.1657 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1658 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1659 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$Node.max\0A\00", align 1
@.faila.1660 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1661 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1670 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1671 = private global %String { i64 16, ptr @.strdata.1670, i64 0 }
@.strdata.1672 = private constant [17 x i8] c"division by zero\00"
@.strobj.1673 = private global %String { i64 16, ptr @.strdata.1672, i64 0 }
@.strdata.5671 = private constant [1 x i8] zeroinitializer
@.strobj.5672 = private global %String { i64 0, ptr @.strdata.5671, i64 0 }
@.strdata.5673 = private constant [1 x i8] zeroinitializer
@.strobj.5674 = private global %String { i64 0, ptr @.strdata.5673, i64 0 }

define internal void @Box.Box(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 0
  store ptr @Box.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %x1 = load i32, ptr %x, align 4
  store i32 %x1, ptr %v, align 4, !tbaa !4
  ret void
}

define internal void @Node.Node(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 0
  store ptr @Node.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %kids = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  store ptr null, ptr %kids, align 8, !tbaa !0
  %id = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 1
  %i1 = load i32, ptr %i, align 4
  store i32 %i1, ptr %id, align 4, !tbaa !4
  %kids2 = getelementptr inbounds %class.Node, ptr %0, i32 0, i32 2
  %"ArrayList$Node.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  call void @"ArrayList$Node.ArrayList$Node"(ptr %"ArrayList$Node.obj")
  store ptr %"ArrayList$Node.obj", ptr %kids2, align 8, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %m = alloca ptr, align 8
  %root = alloca ptr, align 8
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
  %Node.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj, i32 1)
  store ptr %Node.obj, ptr %root, align 8
  %root1 = load ptr, ptr %root, align 8
  %kids = getelementptr inbounds %class.Node, ptr %root1, i32 0, i32 2
  %kids2 = load ptr, ptr %kids, align 8, !tbaa !0
  %Node.obj3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj3, i32 2)
  call void @"ArrayList$Node.add"(ptr %kids2, ptr %Node.obj3)
  call void @__polaron_check_live(ptr %Node.obj3)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %Node.obj3, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %16 = icmp ne ptr %dtor.fn, null
  br i1 %16, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %Node.obj3)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  call void @__polaron_free(ptr %Node.obj3)
  %root4 = load ptr, ptr %root, align 8
  %kids5 = getelementptr inbounds %class.Node, ptr %root4, i32 0, i32 2
  %kids6 = load ptr, ptr %kids5, align 8, !tbaa !0
  %Node.obj7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  call void @Node.Node(ptr %Node.obj7, i32 3)
  call void @"ArrayList$Node.add"(ptr %kids6, ptr %Node.obj7)
  call void @__polaron_check_live(ptr %Node.obj7)
  %vtbl.addr8 = getelementptr inbounds %class.Node, ptr %Node.obj7, i32 0, i32 0
  %vtbl9 = load ptr, ptr %vtbl.addr8, align 8, !tbaa !0
  %dtor.slot10 = getelementptr [349 x ptr], ptr %vtbl9, i64 0, i64 348
  %dtor.fn11 = load ptr, ptr %dtor.slot10, align 8
  %17 = icmp ne ptr %dtor.fn11, null
  br i1 %17, label %dtor.call12, label %dtor.free13

dtor.call12:                                      ; preds = %dtor.free
  call void %dtor.fn11(ptr %Node.obj7)
  br label %dtor.free13

dtor.free13:                                      ; preds = %dtor.call12, %dtor.free
  call void @__polaron_free(ptr %Node.obj7)
  %"HashMap$int$Box.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$int$Box", ptr null, i64 1) to i64))
  call void @"HashMap$int$Box.HashMap$int$Box"(ptr %"HashMap$int$Box.obj")
  store ptr %"HashMap$int$Box.obj", ptr %m, align 8
  %m14 = load ptr, ptr %m, align 8
  %Box.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  call void @Box.Box(ptr %Box.obj, i32 70)
  call void @"HashMap$int$Box.put"(ptr %m14, i32 7, ptr %Box.obj)
  call void @__polaron_check_live(ptr %Box.obj)
  %vtbl.addr15 = getelementptr inbounds %class.Box, ptr %Box.obj, i32 0, i32 0
  %vtbl16 = load ptr, ptr %vtbl.addr15, align 8, !tbaa !0
  %dtor.slot17 = getelementptr [349 x ptr], ptr %vtbl16, i64 0, i64 348
  %dtor.fn18 = load ptr, ptr %dtor.slot17, align 8
  %18 = icmp ne ptr %dtor.fn18, null
  br i1 %18, label %dtor.call19, label %dtor.free20

dtor.call19:                                      ; preds = %dtor.free13
  call void %dtor.fn18(ptr %Box.obj)
  br label %dtor.free20

dtor.free20:                                      ; preds = %dtor.call19, %dtor.free13
  call void @__polaron_free(ptr %Box.obj)
  %m21 = load ptr, ptr %m, align 8
  %Box.obj22 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  call void @Box.Box(ptr %Box.obj22, i32 90)
  call void @"HashMap$int$Box.put"(ptr %m21, i32 9, ptr %Box.obj22)
  call void @__polaron_check_live(ptr %Box.obj22)
  %vtbl.addr23 = getelementptr inbounds %class.Box, ptr %Box.obj22, i32 0, i32 0
  %vtbl24 = load ptr, ptr %vtbl.addr23, align 8, !tbaa !0
  %dtor.slot25 = getelementptr [349 x ptr], ptr %vtbl24, i64 0, i64 348
  %dtor.fn26 = load ptr, ptr %dtor.slot25, align 8
  %19 = icmp ne ptr %dtor.fn26, null
  br i1 %19, label %dtor.call27, label %dtor.free28

dtor.call27:                                      ; preds = %dtor.free20
  call void %dtor.fn26(ptr %Box.obj22)
  br label %dtor.free28

dtor.free28:                                      ; preds = %dtor.call27, %dtor.free20
  call void @__polaron_free(ptr %Box.obj22)
  %root29 = load ptr, ptr %root, align 8
  %kids30 = getelementptr inbounds %class.Node, ptr %root29, i32 0, i32 2
  %kids31 = load ptr, ptr %kids30, align 8, !tbaa !0
  %20 = call i32 @"ArrayList$Node.size"(ptr %kids31)
  %root32 = load ptr, ptr %root, align 8
  %kids33 = getelementptr inbounds %class.Node, ptr %root32, i32 0, i32 2
  %kids34 = load ptr, ptr %kids33, align 8, !tbaa !0
  %21 = call ptr @"ArrayList$Node.get"(ptr %kids34, i32 0)
  %id = getelementptr inbounds %class.Node, ptr %21, i32 0, i32 1
  %id35 = load i32, ptr %id, align 4, !tbaa !4
  %root36 = load ptr, ptr %root, align 8
  %kids37 = getelementptr inbounds %class.Node, ptr %root36, i32 0, i32 2
  %kids38 = load ptr, ptr %kids37, align 8, !tbaa !0
  %22 = call ptr @"ArrayList$Node.get"(ptr %kids38, i32 1)
  %id39 = getelementptr inbounds %class.Node, ptr %22, i32 0, i32 1
  %id40 = load i32, ptr %id39, align 4, !tbaa !4
  %m41 = load ptr, ptr %m, align 8
  %23 = call ptr @"HashMap$int$Box.get"(ptr %m41, i32 7)
  %v = getelementptr inbounds %class.Box, ptr %23, i32 0, i32 1
  %v42 = load i32, ptr %v, align 4, !tbaa !4
  %m43 = load ptr, ptr %m, align 8
  %24 = call ptr @"HashMap$int$Box.get"(ptr %m43, i32 9)
  %v44 = getelementptr inbounds %class.Box, ptr %24, i32 0, i32 1
  %v45 = load i32, ptr %v44, align 4, !tbaa !4
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %20, i32 %id35, i32 %id40, i32 %v42, i32 %v45)
  ret i32 0
}

define internal void @"HashMap$int$Box.HashMap$int$Box"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 0
  store ptr @"HashMap$int$Box.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !0
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !0
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !4
  %keys1 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %keys1, align 8, !tbaa !0
  %values2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 64)
  store ptr %arr3, ptr %values2, align 8, !tbaa !0
  %used5 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %count8 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.198, ptr @.cl.199, i64 %contract.l, ptr @.cr.200, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !4
  %cap14 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %cap21 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !4
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.201, ptr @.cl.202, i64 %contract.l23, ptr @.cr.203, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !0
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.204, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !0
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.205, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !0
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.206, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$int$Box.~HashMap$int$Box"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys1 = load ptr, ptr %keys, align 8, !tbaa !0
  call void @__polaron_free(ptr %keys1)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !0
  %ae.len = load i64, ptr %values2, align 8
  %arr.data = getelementptr i8, ptr %values2, i64 8
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
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %ae.el, i32 0, i32 0
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
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used3 = load ptr, ptr %used, align 8, !tbaa !0
  call void @__polaron_free(ptr %used3)
  ret void

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next
}

define internal i32 @"HashMap$int$Box.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !4
  %15 = sub i32 %cap21, 1
  store i32 %15, ptr %mask, align 4
  %key22 = load i32, ptr %key, align 4
  %16 = sext i32 %key22 to i64
  %17 = trunc i64 %16 to i32
  %mask23 = load i32, ptr %mask, align 4
  %18 = and i32 %17, %mask23
  store i32 %18, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %used24 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %19 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys28 = load ptr, ptr %keys27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %20 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %keys28, align 8
  %arr.oob31 = icmp uge i64 %20, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

while.end:                                        ; preds = %idx.ok
  %i41 = load i32, ptr %i, align 4
  ret i32 %i41

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.207, ptr @.faila.208, i64 %19, ptr @.failb.209, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.210, ptr @.faila.211, i64 %20, ptr @.failb.212, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %keys28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %20
  %elem36 = load i32, ptr %arr.elem35, align 4
  %key37 = load i32, ptr %key, align 4
  %24 = icmp eq i32 %elem36, %key37
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok33
  %i38 = load i32, ptr %i, align 4
  ret i32 %i38

if.end:                                           ; preds = %idx.ok33
  %i39 = load i32, ptr %i, align 4
  %26 = add i32 %i39, 1
  %mask40 = load i32, ptr %mask, align 4
  %27 = and i32 %26, %mask40
  store i32 %27, ptr %i, align 4
  br label %while.cond
}

define internal void @"HashMap$int$Box.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !4
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !0
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !0
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !4
  %keys30 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !4
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 4
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !0
  %values33 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 8
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !0
  %used38 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !4
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !0
  %cap43 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
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
  %oldK117 = load ptr, ptr %oldK, align 8
  call void @__polaron_free(ptr %oldK117)
  %oldV118 = load ptr, ptr %oldV, align 8
  %ae.len = load i64, ptr %oldV118, align 8
  %arr.data119 = getelementptr i8, ptr %oldV118, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.213, ptr @.faila.214, i64 %30, ptr @.failb.215, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.216, ptr @.faila.217, i64 %36, ptr @.failb.218, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %if.then
  %arr.data56 = getelementptr i8, ptr %oldK50, i64 8
  %arr.elem57 = getelementptr inbounds i32, ptr %arr.data56, i64 %36
  %elem58 = load i32, ptr %arr.elem57, align 4
  %37 = sext i32 %elem58 to i64
  %38 = trunc i64 %37 to i32
  %mask59 = load i32, ptr %mask, align 4
  %39 = and i32 %38, %mask59
  store i32 %39, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok55
  %used60 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
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
  %used72 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used73 = load ptr, ptr %used72, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %43 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %used73, align 8
  %arr.oob76 = icmp uge i64 %43, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad65:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.219, ptr @.faila.220, i64 %40, ptr @.failb.221, i64 %arr.len63, i32 70)
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
  call void @__polaron_fail(ptr @.fail.222, ptr @.faila.223, i64 %43, ptr @.failb.224, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %while.end
  %arr.data79 = getelementptr i8, ptr %used73, i64 8
  %arr.elem80 = getelementptr inbounds i8, ptr %arr.data79, i64 %43
  store i8 1, ptr %arr.elem80, align 1
  %keys81 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys82 = load ptr, ptr %keys81, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i83 = load i32, ptr %i, align 4
  %47 = sext i32 %i83 to i64
  %arr.len84 = load i64, ptr %keys82, align 8
  %arr.oob85 = icmp uge i64 %47, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !8

idx.bad86:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.225, ptr @.faila.226, i64 %47, ptr @.failb.227, i64 %arr.len84, i32 70)
  unreachable

idx.ok87:                                         ; preds = %idx.ok78
  %arr.data88 = getelementptr i8, ptr %keys82, i64 8
  %arr.elem89 = getelementptr inbounds i32, ptr %arr.data88, i64 %47
  %oldK90 = load ptr, ptr %oldK, align 8, !nonnull !6, !dereferenceable !7
  %j91 = load i32, ptr %j, align 4
  %48 = sext i32 %j91 to i64
  %arr.len92 = load i64, ptr %oldK90, align 8
  %arr.oob93 = icmp uge i64 %48, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !8

idx.bad94:                                        ; preds = %idx.ok87
  call void @__polaron_fail(ptr @.fail.228, ptr @.faila.229, i64 %48, ptr @.failb.230, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok87
  %arr.data96 = getelementptr i8, ptr %oldK90, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 %48
  %elem98 = load i32, ptr %arr.elem97, align 4
  store i32 %elem98, ptr %arr.elem89, align 4
  %values99 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values100 = load ptr, ptr %values99, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i101 = load i32, ptr %i, align 4
  %49 = sext i32 %i101 to i64
  %arr.len102 = load i64, ptr %values100, align 8
  %arr.oob103 = icmp uge i64 %49, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !8

idx.bad104:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.231, ptr @.faila.232, i64 %49, ptr @.failb.233, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %idx.ok95
  %arr.data106 = getelementptr i8, ptr %values100, i64 8
  %arr.elem107 = getelementptr inbounds ptr, ptr %arr.data106, i64 %49
  %oldV108 = load ptr, ptr %oldV, align 8, !nonnull !6, !dereferenceable !7
  %j109 = load i32, ptr %j, align 4
  %50 = sext i32 %j109 to i64
  %arr.len110 = load i64, ptr %oldV108, align 8
  %arr.oob111 = icmp uge i64 %50, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !8

idx.bad112:                                       ; preds = %idx.ok105
  call void @__polaron_fail(ptr @.fail.234, ptr @.faila.235, i64 %50, ptr @.failb.236, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %idx.ok105
  %arr.data114 = getelementptr i8, ptr %oldV108, i64 8
  %arr.elem115 = getelementptr inbounds ptr, ptr %arr.data114, i64 %50
  %elem116 = load ptr, ptr %arr.elem115, align 8
  %Box.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  %51 = call ptr @memcpy(ptr %Box.copy, ptr %elem116, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy, ptr %arr.elem107, align 8
  br label %if.end

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %52 = icmp ult i64 %ae.iv, %ae.len
  br i1 %52, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data119, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %53 = icmp ne ptr %ae.el, null
  br i1 %53, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %54 = icmp ne ptr %dtor.fn, null
  br i1 %54, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %55 = add i64 %ae.iv, 1
  store i64 %55, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %oldV118)
  %oldU120 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU120)
  %count121 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count122 = load i32, ptr %count121, align 4, !tbaa !4
  %56 = icmp sge i32 %count122, 0
  %57 = zext i1 %56 to i32
  %contract.ok = icmp ne i32 %57, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

contract.fail:                                    ; preds = %ae.end
  %count123 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count124 = load i32, ptr %count123, align 4, !tbaa !4
  %contract.l = sext i32 %count124 to i64
  call void @__polaron_fail(ptr @.contract.237, ptr @.cl.238, i64 %contract.l, ptr @.cr.239, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %ae.end
  %count125 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !4
  %cap127 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !4
  %58 = icmp slt i32 %count126, %cap128
  %59 = zext i1 %58 to i32
  %contract.ok129 = icmp ne i32 %59, 0
  br i1 %contract.ok129, label %contract.cont131, label %contract.fail130

contract.fail130:                                 ; preds = %contract.cont
  %count132 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count133 = load i32, ptr %count132, align 4, !tbaa !4
  %cap134 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !4
  %contract.l136 = sext i32 %count133 to i64
  %contract.r = sext i32 %cap135 to i64
  call void @__polaron_fail(ptr @.contract.240, ptr @.cl.241, i64 %contract.l136, ptr @.cr.242, i64 %contract.r, i32 1)
  unreachable

contract.cont131:                                 ; preds = %contract.cont
  %keys137 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys138 = load ptr, ptr %keys137, align 8, !tbaa !0
  %len139 = load i64, ptr %keys138, align 8
  %60 = trunc i64 %len139 to i32
  %cap140 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap141 = load i32, ptr %cap140, align 4, !tbaa !4
  %61 = icmp eq i32 %60, %cap141
  %62 = zext i1 %61 to i32
  %contract.ok142 = icmp ne i32 %62, 0
  br i1 %contract.ok142, label %contract.cont144, label %contract.fail143

contract.fail143:                                 ; preds = %contract.cont131
  call void @__polaron_fail(ptr @.contract.243, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont144:                                 ; preds = %contract.cont131
  %values145 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values146 = load ptr, ptr %values145, align 8, !tbaa !0
  %len147 = load i64, ptr %values146, align 8
  %63 = trunc i64 %len147 to i32
  %cap148 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap149 = load i32, ptr %cap148, align 4, !tbaa !4
  %64 = icmp eq i32 %63, %cap149
  %65 = zext i1 %64 to i32
  %contract.ok150 = icmp ne i32 %65, 0
  br i1 %contract.ok150, label %contract.cont152, label %contract.fail151

contract.fail151:                                 ; preds = %contract.cont144
  call void @__polaron_fail(ptr @.contract.244, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont152:                                 ; preds = %contract.cont144
  %used153 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used154 = load ptr, ptr %used153, align 8, !tbaa !0
  %len155 = load i64, ptr %used154, align 8
  %66 = trunc i64 %len155 to i32
  %cap156 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap157 = load i32, ptr %cap156, align 4, !tbaa !4
  %67 = icmp eq i32 %66, %cap157
  %68 = zext i1 %67 to i32
  %contract.ok158 = icmp ne i32 %68, 0
  br i1 %contract.ok158, label %contract.cont160, label %contract.fail159

contract.fail159:                                 ; preds = %contract.cont152
  call void @__polaron_fail(ptr @.contract.245, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont160:                                 ; preds = %contract.cont152
  ret void
}

define internal void @"HashMap$int$Box.put"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2) {
entry:
  %i = alloca i32, align 4
  %Box.copy = alloca %class.Box, align 8
  %value = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %3 = call ptr @memcpy(ptr %Box.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy, ptr %value, align 8
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$int$Box.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load i32, ptr %key, align 4
  %22 = call i32 @"HashMap$int$Box.slotFor"(ptr %0, i32 %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.246, ptr @.faila.247, i64 %23, ptr @.failb.248, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %used26, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %23
  %elem = load i8, ptr %arr.elem, align 1
  %24 = sext i8 %elem to i32
  %25 = icmp eq i32 %24, 0
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then28, label %if.end29

if.then28:                                        ; preds = %idx.ok
  %used30 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %28 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %28, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.249, ptr @.faila.250, i64 %27, ptr @.failb.251, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %29 = add i32 %count41, 1
  store i32 %29, ptr %count39, align 4, !tbaa !4
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.252, ptr @.faila.253, i64 %28, ptr @.failb.254, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %28
  %key51 = load i32, ptr %key, align 4
  store i32 %key51, ptr %arr.elem50, align 4
  %values52 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %30 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %30, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.255, ptr @.faila.256, i64 %30, ptr @.failb.257, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %30
  %value61 = load ptr, ptr %value, align 8
  %Box.copy62 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  %31 = call ptr @memcpy(ptr %Box.copy62, ptr %value61, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy62, ptr %arr.elem60, align 8
  %count63 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count64 = load i32, ptr %count63, align 4, !tbaa !4
  %32 = icmp sge i32 %count64, 0
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count65 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count66 = load i32, ptr %count65, align 4, !tbaa !4
  %contract.l = sext i32 %count66 to i64
  call void @__polaron_fail(ptr @.contract.258, ptr @.cl.259, i64 %contract.l, ptr @.cr.260, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count67 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count68 = load i32, ptr %count67, align 4, !tbaa !4
  %cap69 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap70 = load i32, ptr %cap69, align 4, !tbaa !4
  %34 = icmp slt i32 %count68, %cap70
  %35 = zext i1 %34 to i32
  %contract.ok71 = icmp ne i32 %35, 0
  br i1 %contract.ok71, label %contract.cont73, label %contract.fail72

contract.fail72:                                  ; preds = %contract.cont
  %count74 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count75 = load i32, ptr %count74, align 4, !tbaa !4
  %cap76 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap77 = load i32, ptr %cap76, align 4, !tbaa !4
  %contract.l78 = sext i32 %count75 to i64
  %contract.r = sext i32 %cap77 to i64
  call void @__polaron_fail(ptr @.contract.261, ptr @.cl.262, i64 %contract.l78, ptr @.cr.263, i64 %contract.r, i32 1)
  unreachable

contract.cont73:                                  ; preds = %contract.cont
  %keys79 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys80 = load ptr, ptr %keys79, align 8, !tbaa !0
  %len81 = load i64, ptr %keys80, align 8
  %36 = trunc i64 %len81 to i32
  %cap82 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap83 = load i32, ptr %cap82, align 4, !tbaa !4
  %37 = icmp eq i32 %36, %cap83
  %38 = zext i1 %37 to i32
  %contract.ok84 = icmp ne i32 %38, 0
  br i1 %contract.ok84, label %contract.cont86, label %contract.fail85

contract.fail85:                                  ; preds = %contract.cont73
  call void @__polaron_fail(ptr @.contract.264, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont86:                                  ; preds = %contract.cont73
  %values87 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values88 = load ptr, ptr %values87, align 8, !tbaa !0
  %len89 = load i64, ptr %values88, align 8
  %39 = trunc i64 %len89 to i32
  %cap90 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap91 = load i32, ptr %cap90, align 4, !tbaa !4
  %40 = icmp eq i32 %39, %cap91
  %41 = zext i1 %40 to i32
  %contract.ok92 = icmp ne i32 %41, 0
  br i1 %contract.ok92, label %contract.cont94, label %contract.fail93

contract.fail93:                                  ; preds = %contract.cont86
  call void @__polaron_fail(ptr @.contract.265, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont94:                                  ; preds = %contract.cont86
  %used95 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used96 = load ptr, ptr %used95, align 8, !tbaa !0
  %len97 = load i64, ptr %used96, align 8
  %42 = trunc i64 %len97 to i32
  %cap98 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap99 = load i32, ptr %cap98, align 4, !tbaa !4
  %43 = icmp eq i32 %42, %cap99
  %44 = zext i1 %43 to i32
  %contract.ok100 = icmp ne i32 %44, 0
  br i1 %contract.ok100, label %contract.cont102, label %contract.fail101

contract.fail101:                                 ; preds = %contract.cont94
  call void @__polaron_fail(ptr @.contract.266, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont102:                                 ; preds = %contract.cont94
  ret void
}

define internal ptr @"HashMap$int$Box.get"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load i32, ptr %key, align 4
  %15 = call i32 @"HashMap$int$Box.slotFor"(ptr %0, i32 %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.267, ptr @.faila.268, i64 %16, ptr @.failb.269, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %16
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem
}

define internal i32 @"HashMap$int$Box.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load i32, ptr %key, align 4
  %15 = call i32 @"HashMap$int$Box.slotFor"(ptr %0, i32 %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.270, ptr @.faila.271, i64 %16, ptr @.failb.272, i64 %arr.len, i32 70)
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

define internal ptr @"HashMap$int$Box.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %Box.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  %3 = call ptr @memcpy(ptr %Box.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy, ptr %defaultValue, align 8
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load i32, ptr %key, align 4
  %17 = call i32 @"HashMap$int$Box.slotFor"(ptr %0, i32 %key20)
  store i32 %17, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %18 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.273, ptr @.faila.274, i64 %18, ptr @.failb.275, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used22, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %18
  %elem = load i8, ptr %arr.elem, align 1
  %19 = sext i8 %elem to i32
  %20 = icmp ne i32 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %values24 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %22 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %values25, align 8
  %arr.oob28 = icmp uge i64 %22, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !8

if.end:                                           ; preds = %idx.ok
  %defaultValue34 = load ptr, ptr %defaultValue, align 8
  ret ptr %defaultValue34

idx.bad29:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.276, ptr @.faila.277, i64 %22, ptr @.failb.278, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds ptr, ptr %arr.data31, i64 %22
  %elem33 = load ptr, ptr %arr.elem32, align 8
  ret ptr %elem33
}

define internal void @"HashMap$int$Box.merge"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %Box.copy = alloca %class.Box, align 8
  %value = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %4 = call ptr @memcpy(ptr %Box.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy, ptr %value, align 8
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %7 = icmp slt i32 %count3, %cap4
  %8 = zext i1 %7 to i32
  %inv.assume5 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %9 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap8
  %11 = zext i1 %10 to i32
  %inv.assume9 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %12 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap13
  %14 = zext i1 %13 to i32
  %inv.assume14 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %15 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %16 = icmp eq i32 %15, %cap18
  %17 = zext i1 %16 to i32
  %inv.assume19 = icmp ne i32 %17, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %18 = add i32 %count21, 1
  %19 = mul i32 %18, 4
  %cap22 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %20 = mul i32 %cap23, 3
  %21 = icmp sge i32 %19, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$int$Box.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load i32, ptr %key, align 4
  %23 = call i32 @"HashMap$int$Box.slotFor"(ptr %0, i32 %key24)
  store i32 %23, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %24 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %24, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.279, ptr @.faila.280, i64 %24, ptr @.failb.281, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %used26, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %24
  %elem = load i8, ptr %arr.elem, align 1
  %25 = sext i8 %elem to i32
  %26 = icmp eq i32 %25, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then28, label %if.else

if.then28:                                        ; preds = %idx.ok
  %used30 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %28 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %28, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.else:                                          ; preds = %idx.ok
  %values63 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values64 = load ptr, ptr %values63, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i65 = load i32, ptr %i, align 4
  %29 = sext i32 %i65 to i64
  %arr.len66 = load i64, ptr %values64, align 8
  %arr.oob67 = icmp uge i64 %29, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !8

if.end29:                                         ; preds = %idx.ok79, %idx.ok58
  %count84 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count85 = load i32, ptr %count84, align 4, !tbaa !4
  %30 = icmp sge i32 %count85, 0
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.282, ptr @.faila.283, i64 %28, ptr @.failb.284, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %28
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %32 = add i32 %count41, 1
  store i32 %32, ptr %count39, align 4, !tbaa !4
  %keys42 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %33 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %33, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.285, ptr @.faila.286, i64 %33, ptr @.failb.287, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %33
  %key51 = load i32, ptr %key, align 4
  store i32 %key51, ptr %arr.elem50, align 4
  %values52 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %34 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %34, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.288, ptr @.faila.289, i64 %34, ptr @.failb.290, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %34
  %value61 = load ptr, ptr %value, align 8
  %Box.copy62 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  %35 = call ptr @memcpy(ptr %Box.copy62, ptr %value61, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy62, ptr %arr.elem60, align 8
  br label %if.end29

idx.bad68:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.291, ptr @.faila.292, i64 %29, ptr @.failb.293, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %if.else
  %arr.data70 = getelementptr i8, ptr %values64, i64 8
  %arr.elem71 = getelementptr inbounds ptr, ptr %arr.data70, i64 %29
  %combine72 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine72, align 8
  %36 = getelementptr ptr, ptr %combine72, i32 1
  %env = load ptr, ptr %36, align 8
  %values73 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values74 = load ptr, ptr %values73, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i75 = load i32, ptr %i, align 4
  %37 = sext i32 %i75 to i64
  %arr.len76 = load i64, ptr %values74, align 8
  %arr.oob77 = icmp uge i64 %37, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !8

idx.bad78:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.294, ptr @.faila.295, i64 %37, ptr @.failb.296, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok69
  %arr.data80 = getelementptr i8, ptr %values74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %37
  %elem82 = load ptr, ptr %arr.elem81, align 8
  %value83 = load ptr, ptr %value, align 8
  %38 = call ptr %code(ptr %env, ptr %elem82, ptr %value83)
  store ptr %38, ptr %arr.elem71, align 8
  br label %if.end29

contract.fail:                                    ; preds = %if.end29
  %count86 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count87 = load i32, ptr %count86, align 4, !tbaa !4
  %contract.l = sext i32 %count87 to i64
  call void @__polaron_fail(ptr @.contract.297, ptr @.cl.298, i64 %contract.l, ptr @.cr.299, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count88 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count89 = load i32, ptr %count88, align 4, !tbaa !4
  %cap90 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap91 = load i32, ptr %cap90, align 4, !tbaa !4
  %39 = icmp slt i32 %count89, %cap91
  %40 = zext i1 %39 to i32
  %contract.ok92 = icmp ne i32 %40, 0
  br i1 %contract.ok92, label %contract.cont94, label %contract.fail93

contract.fail93:                                  ; preds = %contract.cont
  %count95 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count96 = load i32, ptr %count95, align 4, !tbaa !4
  %cap97 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap98 = load i32, ptr %cap97, align 4, !tbaa !4
  %contract.l99 = sext i32 %count96 to i64
  %contract.r = sext i32 %cap98 to i64
  call void @__polaron_fail(ptr @.contract.300, ptr @.cl.301, i64 %contract.l99, ptr @.cr.302, i64 %contract.r, i32 1)
  unreachable

contract.cont94:                                  ; preds = %contract.cont
  %keys100 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys101 = load ptr, ptr %keys100, align 8, !tbaa !0
  %len102 = load i64, ptr %keys101, align 8
  %41 = trunc i64 %len102 to i32
  %cap103 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap104 = load i32, ptr %cap103, align 4, !tbaa !4
  %42 = icmp eq i32 %41, %cap104
  %43 = zext i1 %42 to i32
  %contract.ok105 = icmp ne i32 %43, 0
  br i1 %contract.ok105, label %contract.cont107, label %contract.fail106

contract.fail106:                                 ; preds = %contract.cont94
  call void @__polaron_fail(ptr @.contract.303, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont107:                                 ; preds = %contract.cont94
  %values108 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values109 = load ptr, ptr %values108, align 8, !tbaa !0
  %len110 = load i64, ptr %values109, align 8
  %44 = trunc i64 %len110 to i32
  %cap111 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap112 = load i32, ptr %cap111, align 4, !tbaa !4
  %45 = icmp eq i32 %44, %cap112
  %46 = zext i1 %45 to i32
  %contract.ok113 = icmp ne i32 %46, 0
  br i1 %contract.ok113, label %contract.cont115, label %contract.fail114

contract.fail114:                                 ; preds = %contract.cont107
  call void @__polaron_fail(ptr @.contract.304, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont115:                                 ; preds = %contract.cont107
  %used116 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used117 = load ptr, ptr %used116, align 8, !tbaa !0
  %len118 = load i64, ptr %used117, align 8
  %47 = trunc i64 %len118 to i32
  %cap119 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap120 = load i32, ptr %cap119, align 4, !tbaa !4
  %48 = icmp eq i32 %47, %cap120
  %49 = zext i1 %48 to i32
  %contract.ok121 = icmp ne i32 %49, 0
  br i1 %contract.ok121, label %contract.cont123, label %contract.fail122

contract.fail122:                                 ; preds = %contract.cont115
  call void @__polaron_fail(ptr @.contract.305, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont123:                                 ; preds = %contract.cont115
  ret void
}

define internal i32 @"HashMap$int$Box.remove"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %rv = alloca ptr, align 8
  %Box.copy = alloca %class.Box, align 8
  %rk = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load i32, ptr %key, align 4
  %15 = call i32 @"HashMap$int$Box.slotFor"(ptr %0, i32 %key20)
  store i32 %15, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %16 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.306, ptr @.faila.307, i64 %16, ptr @.failb.308, i64 %arr.len, i32 70)
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
  %count24 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !4
  %20 = icmp sge i32 %count25, 0
  %21 = zext i1 %20 to i32
  %contract.ok = icmp ne i32 %21, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !4
  %22 = sub i32 %cap49, 1
  store i32 %22, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %23 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %23, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.309, ptr @.cl.310, i64 %contract.l, ptr @.cr.311, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %cap30 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !4
  %24 = icmp slt i32 %count29, %cap31
  %25 = zext i1 %24 to i32
  %contract.ok32 = icmp ne i32 %25, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %cap37 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !4
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.312, ptr @.cl.313, i64 %contract.l39, ptr @.cr.314, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !0
  %len42 = load i64, ptr %used41, align 8
  %26 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %27 = icmp eq i32 %26, %cap44
  %28 = zext i1 %27 to i32
  %contract.ok45 = icmp ne i32 %28, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.315, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.316, ptr @.faila.317, i64 %23, ptr @.failb.318, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %23
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count61 = load i32, ptr %count60, align 4, !tbaa !4
  %29 = sub i32 %count61, 1
  store i32 %29, ptr %count59, align 4, !tbaa !4
  %i62 = load i32, ptr %i, align 4
  %30 = add i32 %i62, 1
  %mask63 = load i32, ptr %mask, align 4
  %31 = and i32 %30, %mask63
  store i32 %31, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok100, %idx.ok56
  %used64 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j66 = load i32, ptr %j, align 4
  %32 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %32, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !8

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %33 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %33, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

while.end:                                        ; preds = %idx.ok70
  %count110 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count111 = load i32, ptr %count110, align 4, !tbaa !4
  %34 = icmp sge i32 %count111, 0
  %35 = zext i1 %34 to i32
  %contract.ok112 = icmp ne i32 %35, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.319, ptr @.faila.320, i64 %32, ptr @.failb.321, i64 %arr.len67, i32 70)
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
  call void @__polaron_fail(ptr @.fail.322, ptr @.faila.323, i64 %33, ptr @.failb.324, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds i32, ptr %arr.data81, i64 %33
  %elem83 = load i32, ptr %arr.elem82, align 4
  store i32 %elem83, ptr %rk, align 4
  %values84 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j86 = load i32, ptr %j, align 4
  %39 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %39, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.325, ptr @.faila.326, i64 %39, ptr @.failb.327, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds ptr, ptr %arr.data91, i64 %39
  %elem93 = load ptr, ptr %arr.elem92, align 8
  %40 = call ptr @memcpy(ptr %Box.copy, ptr %elem93, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy, ptr %rv, align 8
  %used94 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j96 = load i32, ptr %j, align 4
  %41 = sext i32 %j96 to i64
  %arr.len97 = load i64, ptr %used95, align 8
  %arr.oob98 = icmp uge i64 %41, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.328, ptr @.faila.329, i64 %41, ptr @.failb.330, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %used95, i64 8
  %arr.elem102 = getelementptr inbounds i8, ptr %arr.data101, i64 %41
  store i8 0, ptr %arr.elem102, align 1
  %count103 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count104 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count105 = load i32, ptr %count104, align 4, !tbaa !4
  %42 = sub i32 %count105, 1
  store i32 %42, ptr %count103, align 4, !tbaa !4
  %rk106 = load i32, ptr %rk, align 4
  %rv107 = load ptr, ptr %rv, align 8
  call void @"HashMap$int$Box.put"(ptr %0, i32 %rk106, ptr %rv107)
  %j108 = load i32, ptr %j, align 4
  %43 = add i32 %j108, 1
  %mask109 = load i32, ptr %mask, align 4
  %44 = and i32 %43, %mask109
  store i32 %44, ptr %j, align 4
  br label %while.cond

contract.fail113:                                 ; preds = %while.end
  %count115 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count116 = load i32, ptr %count115, align 4, !tbaa !4
  %contract.l117 = sext i32 %count116 to i64
  call void @__polaron_fail(ptr @.contract.331, ptr @.cl.332, i64 %contract.l117, ptr @.cr.333, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %while.end
  %count118 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !4
  %cap120 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !4
  %45 = icmp slt i32 %count119, %cap121
  %46 = zext i1 %45 to i32
  %contract.ok122 = icmp ne i32 %46, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont114
  %count125 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !4
  %cap127 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !4
  %contract.l129 = sext i32 %count126 to i64
  %contract.r130 = sext i32 %cap128 to i64
  call void @__polaron_fail(ptr @.contract.334, ptr @.cl.335, i64 %contract.l129, ptr @.cr.336, i64 %contract.r130, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont114
  %used131 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used132 = load ptr, ptr %used131, align 8, !tbaa !0
  %len133 = load i64, ptr %used132, align 8
  %47 = trunc i64 %len133 to i32
  %cap134 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !4
  %48 = icmp eq i32 %47, %cap135
  %49 = zext i1 %48 to i32
  %contract.ok136 = icmp ne i32 %49, 0
  br i1 %contract.ok136, label %contract.cont138, label %contract.fail137

contract.fail137:                                 ; preds = %contract.cont124
  call void @__polaron_fail(ptr @.contract.337, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont138:                                 ; preds = %contract.cont124
  ret i32 1
}

define internal ptr @"HashMap$int$Box.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %14 = sext i32 %count21 to i64
  %15 = mul i64 %14, 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.338, ptr @.faila.339, i64 %20, ptr @.failb.340, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.341, ptr @.faila.342, i64 %26, ptr @.failb.343, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.344, ptr @.faila.345, i64 %27, ptr @.failb.346, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %keys38, i64 8
  %arr.elem45 = getelementptr inbounds i32, ptr %arr.data44, i64 %27
  %elem46 = load i32, ptr %arr.elem45, align 4
  store i32 %elem46, ptr %arr.elem36, align 4
  %j47 = load i32, ptr %j, align 4
  %28 = add i32 %j47, 1
  store i32 %28, ptr %j, align 4
  br label %if.end
}

define internal ptr @"HashMap$int$Box.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.347, ptr @.faila.348, i64 %20, ptr @.failb.349, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.350, ptr @.faila.351, i64 %26, ptr @.failb.352, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.353, ptr @.faila.354, i64 %27, ptr @.failb.355, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %values38, i64 8
  %arr.elem45 = getelementptr inbounds ptr, ptr %arr.data44, i64 %27
  %elem46 = load ptr, ptr %arr.elem45, align 8
  %Box.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  %28 = call ptr @memcpy(ptr %Box.copy, ptr %elem46, i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  store ptr %Box.copy, ptr %arr.elem36, align 8
  %j47 = load i32, ptr %j, align 4
  %29 = add i32 %j47, 1
  store i32 %29, ptr %j, align 4
  br label %if.end
}

define internal i32 @"HashMap$int$Box.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  ret i32 %count21
}

define internal i32 @"HashMap$int$Box.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$Box", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %14 = icmp eq i32 %count21, 0
  %15 = zext i1 %14 to i32
  ret i32 %15
}

define internal void @"ArrayList$Node.ArrayList$Node"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$Node.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.1454, ptr @.cl.1455, i64 %contract.l, ptr @.cr.1456, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1457, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$Node.~ArrayList$Node"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %ae.el, i32 0, i32 0
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

define internal void @"ArrayList$Node.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %i17 = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Node.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Node, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %5 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %4, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %"class.ArrayList$Node", ptr %4, i32 0, i32 1
  %7 = load ptr, ptr %6, align 8, !tbaa !0
  %arr.len = load i64, ptr %7, align 8
  %8 = mul i64 %arr.len, 8
  %9 = add i64 8, %8
  %arr.copy = call ptr @__polaron_malloc(i64 %9)
  %10 = call ptr @memcpy(ptr %arr.copy, ptr %7, i64 %9)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %17, %arrdup.cont ]
  %11 = icmp slt i64 %i, %arr.len
  br i1 %11, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %12 = mul i64 %i, 8
  %13 = add i64 8, %12
  %14 = getelementptr i8, ptr %arr.copy, i64 %13
  %elem = load ptr, ptr %14, align 8
  %15 = icmp eq ptr %elem, null
  br i1 %15, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Node.copy1, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy1, ptr %14, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %17 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %18 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %18, align 8, !tbaa !0
  %19 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %19, align 8, !tbaa !0
  store ptr %Node.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %20 = icmp sge i32 %count2, 0
  %21 = zext i1 %20 to i32
  %inv.assume = icmp ne i32 %21, 0
  call void @llvm.assume(i1 %inv.assume)
  %count3 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count3, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data5, align 8
  %22 = trunc i64 %len to i32
  %23 = icmp sle i32 %count4, %22
  %24 = zext i1 %23 to i32
  %inv.assume6 = icmp ne i32 %24, 0
  call void @llvm.assume(i1 %inv.assume6)
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  store i32 %count8, ptr %old, align 4
  %count9 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %data11 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !0
  %len13 = load i64, ptr %data12, align 8
  %25 = trunc i64 %len13 to i32
  %26 = icmp sge i32 %count10, %25
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %arrdup.done
  %data14 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0
  %len16 = load i64, ptr %data15, align 8
  %28 = trunc i64 %len16 to i32
  %29 = mul i32 %28, 2
  %30 = sext i32 %29 to i64
  %31 = mul i64 %30, 8
  %32 = add i64 8, %31
  %arr = call ptr @__polaron_malloc(i64 %32)
  store i64 %30, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %33 = call ptr @memset(ptr %arr.data, i32 0, i64 %31)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i17, align 4
  br label %for.cond

if.end:                                           ; preds = %ae.end, %arrdup.done
  %data52 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data53 = load ptr, ptr %data52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count54 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %34 = sext i32 %count55 to i64
  %arr.len56 = load i64, ptr %data53, align 8
  %arr.oob57 = icmp uge i64 %34, %arr.len56
  br i1 %arr.oob57, label %idx.bad58, label %idx.ok59, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i18 = load i32, ptr %i17, align 4
  %count19 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %35 = icmp slt i32 %i18, %count20
  %36 = zext i1 %35 to i32
  br i1 %35, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger21 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i22 = load i32, ptr %i17, align 4
  %37 = sext i32 %i22 to i64
  %arr.len23 = load i64, ptr %bigger21, align 8
  %arr.oob = icmp uge i64 %37, %arr.len23
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %arrdup.done43
  %38 = load i32, ptr %i17, align 4
  %39 = add i32 %38, 1
  store i32 %39, ptr %i17, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data47 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0
  %ae.len = load i64, ptr %data48, align 8
  %arr.data49 = getelementptr i8, ptr %data48, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1458, ptr @.faila.1459, i64 %37, ptr @.failb.1460, i64 %arr.len23, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data24 = getelementptr i8, ptr %bigger21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data24, i64 %37
  %data25 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data26 = load ptr, ptr %data25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i17, align 4
  %40 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %data26, align 8
  %arr.oob29 = icmp uge i64 %40, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !8

idx.bad30:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1461, ptr @.faila.1462, i64 %40, ptr @.failb.1463, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok
  %arr.data32 = getelementptr i8, ptr %data26, i64 8
  %arr.elem33 = getelementptr inbounds ptr, ptr %arr.data32, i64 %40
  %elem34 = load ptr, ptr %arr.elem33, align 8
  %Node.copy35 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %41 = call ptr @memcpy(ptr %Node.copy35, ptr %elem34, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %42 = getelementptr inbounds %class.Node, ptr %elem34, i32 0, i32 2
  %43 = load ptr, ptr %42, align 8, !tbaa !0
  %"ArrayList$Node.copy36" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %44 = call ptr @memcpy(ptr %"ArrayList$Node.copy36", ptr %43, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %45 = getelementptr inbounds %"class.ArrayList$Node", ptr %43, i32 0, i32 1
  %46 = load ptr, ptr %45, align 8, !tbaa !0
  %arr.len37 = load i64, ptr %46, align 8
  %47 = mul i64 %arr.len37, 8
  %48 = add i64 8, %47
  %arr.copy38 = call ptr @__polaron_malloc(i64 %48)
  %49 = call ptr @memcpy(ptr %arr.copy38, ptr %46, i64 %48)
  br label %arrdup.head39

arrdup.head39:                                    ; preds = %arrdup.cont42, %idx.ok31
  %i44 = phi i64 [ 0, %idx.ok31 ], [ %56, %arrdup.cont42 ]
  %50 = icmp slt i64 %i44, %arr.len37
  br i1 %50, label %arrdup.body40, label %arrdup.done43

arrdup.body40:                                    ; preds = %arrdup.head39
  %51 = mul i64 %i44, 8
  %52 = add i64 8, %51
  %53 = getelementptr i8, ptr %arr.copy38, i64 %52
  %elem45 = load ptr, ptr %53, align 8
  %54 = icmp eq ptr %elem45, null
  br i1 %54, label %arrdup.cont42, label %arrdup.copy41

arrdup.copy41:                                    ; preds = %arrdup.body40
  %Node.copy46 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %55 = call ptr @memcpy(ptr %Node.copy46, ptr %elem45, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy46, ptr %53, align 8
  br label %arrdup.cont42

arrdup.cont42:                                    ; preds = %arrdup.copy41, %arrdup.body40
  %56 = add i64 %i44, 1
  br label %arrdup.head39

arrdup.done43:                                    ; preds = %arrdup.head39
  %57 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy36", i32 0, i32 1
  store ptr %arr.copy38, ptr %57, align 8, !tbaa !0
  %58 = getelementptr inbounds %class.Node, ptr %Node.copy35, i32 0, i32 2
  store ptr %"ArrayList$Node.copy36", ptr %58, align 8, !tbaa !0
  store ptr %Node.copy35, ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %59 = icmp ult i64 %ae.iv, %ae.len
  br i1 %59, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data49, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %60 = icmp ne ptr %ae.el, null
  br i1 %60, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %61 = icmp ne ptr %dtor.fn, null
  br i1 %61, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %62 = add i64 %ae.iv, 1
  store i64 %62, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data48)
  %data50 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %bigger51 = load ptr, ptr %bigger, align 8
  store ptr %bigger51, ptr %data50, align 8, !tbaa !0
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

idx.bad58:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1464, ptr @.faila.1465, i64 %34, ptr @.failb.1466, i64 %arr.len56, i32 70)
  unreachable

idx.ok59:                                         ; preds = %if.end
  %arr.data60 = getelementptr i8, ptr %data53, i64 8
  %arr.elem61 = getelementptr inbounds ptr, ptr %arr.data60, i64 %34
  %item62 = load ptr, ptr %item, align 8
  %Node.copy63 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %63 = call ptr @memcpy(ptr %Node.copy63, ptr %item62, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %64 = getelementptr inbounds %class.Node, ptr %item62, i32 0, i32 2
  %65 = load ptr, ptr %64, align 8, !tbaa !0
  %"ArrayList$Node.copy64" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %66 = call ptr @memcpy(ptr %"ArrayList$Node.copy64", ptr %65, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %67 = getelementptr inbounds %"class.ArrayList$Node", ptr %65, i32 0, i32 1
  %68 = load ptr, ptr %67, align 8, !tbaa !0
  %arr.len65 = load i64, ptr %68, align 8
  %69 = mul i64 %arr.len65, 8
  %70 = add i64 8, %69
  %arr.copy66 = call ptr @__polaron_malloc(i64 %70)
  %71 = call ptr @memcpy(ptr %arr.copy66, ptr %68, i64 %70)
  br label %arrdup.head67

arrdup.head67:                                    ; preds = %arrdup.cont70, %idx.ok59
  %i72 = phi i64 [ 0, %idx.ok59 ], [ %78, %arrdup.cont70 ]
  %72 = icmp slt i64 %i72, %arr.len65
  br i1 %72, label %arrdup.body68, label %arrdup.done71

arrdup.body68:                                    ; preds = %arrdup.head67
  %73 = mul i64 %i72, 8
  %74 = add i64 8, %73
  %75 = getelementptr i8, ptr %arr.copy66, i64 %74
  %elem73 = load ptr, ptr %75, align 8
  %76 = icmp eq ptr %elem73, null
  br i1 %76, label %arrdup.cont70, label %arrdup.copy69

arrdup.copy69:                                    ; preds = %arrdup.body68
  %Node.copy74 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %77 = call ptr @memcpy(ptr %Node.copy74, ptr %elem73, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy74, ptr %75, align 8
  br label %arrdup.cont70

arrdup.cont70:                                    ; preds = %arrdup.copy69, %arrdup.body68
  %78 = add i64 %i72, 1
  br label %arrdup.head67

arrdup.done71:                                    ; preds = %arrdup.head67
  %79 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy64", i32 0, i32 1
  store ptr %arr.copy66, ptr %79, align 8, !tbaa !0
  %80 = getelementptr inbounds %class.Node, ptr %Node.copy63, i32 0, i32 2
  store ptr %"ArrayList$Node.copy64", ptr %80, align 8, !tbaa !0
  store ptr %Node.copy63, ptr %arr.elem61, align 8
  %count75 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count76 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count77 = load i32, ptr %count76, align 4, !tbaa !4
  %81 = add i32 %count77, 1
  store i32 %81, ptr %count75, align 4, !tbaa !4
  %count78 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count79 = load i32, ptr %count78, align 4, !tbaa !4
  %old80 = load i32, ptr %old, align 4
  %82 = add i32 %old80, 1
  %83 = icmp eq i32 %count79, %82
  %84 = zext i1 %83 to i32
  %contract.ok = icmp ne i32 %84, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %arrdup.done71
  call void @__polaron_fail(ptr @.contract.1467, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %arrdup.done71
  %count81 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count82 = load i32, ptr %count81, align 4, !tbaa !4
  %85 = icmp sge i32 %count82, 0
  %86 = zext i1 %85 to i32
  %contract.ok83 = icmp ne i32 %86, 0
  br i1 %contract.ok83, label %contract.cont85, label %contract.fail84

contract.fail84:                                  ; preds = %contract.cont
  %count86 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count87 = load i32, ptr %count86, align 4, !tbaa !4
  %contract.l = sext i32 %count87 to i64
  call void @__polaron_fail(ptr @.contract.1468, ptr @.cl.1469, i64 %contract.l, ptr @.cr.1470, i64 0, i32 1)
  unreachable

contract.cont85:                                  ; preds = %contract.cont
  %count88 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count89 = load i32, ptr %count88, align 4, !tbaa !4
  %data90 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0
  %len92 = load i64, ptr %data91, align 8
  %87 = trunc i64 %len92 to i32
  %88 = icmp sle i32 %count89, %87
  %89 = zext i1 %88 to i32
  %contract.ok93 = icmp ne i32 %89, 0
  br i1 %contract.ok93, label %contract.cont95, label %contract.fail94

contract.fail94:                                  ; preds = %contract.cont85
  call void @__polaron_fail(ptr @.contract.1471, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont95:                                  ; preds = %contract.cont85
  ret void
}

define internal void @"ArrayList$Node.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count35 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %14 = icmp sge i32 %count36, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
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

for.update:                                       ; preds = %arrdup.done
  %19 = load i32, ptr %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data30 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0
  %ae.len = load i64, ptr %data31, align 8
  %arr.data32 = getelementptr i8, ptr %data31, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1472, ptr @.faila.1473, i64 %18, ptr @.failb.1474, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1475, ptr @.faila.1476, i64 %21, ptr @.failb.1477, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %21
  %elem = load ptr, ptr %arr.elem25, align 8
  %Node.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %22 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %23 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %24 = load ptr, ptr %23, align 8, !tbaa !0
  %"ArrayList$Node.copy" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %25 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %24, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %"class.ArrayList$Node", ptr %24, i32 0, i32 1
  %27 = load ptr, ptr %26, align 8, !tbaa !0
  %arr.len26 = load i64, ptr %27, align 8
  %28 = mul i64 %arr.len26, 8
  %29 = add i64 8, %28
  %arr.copy = call ptr @__polaron_malloc(i64 %29)
  %30 = call ptr @memcpy(ptr %arr.copy, ptr %27, i64 %29)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok23
  %i27 = phi i64 [ 0, %idx.ok23 ], [ %37, %arrdup.cont ]
  %31 = icmp slt i64 %i27, %arr.len26
  br i1 %31, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %32 = mul i64 %i27, 8
  %33 = add i64 8, %32
  %34 = getelementptr i8, ptr %arr.copy, i64 %33
  %elem28 = load ptr, ptr %34, align 8
  %35 = icmp eq ptr %elem28, null
  br i1 %35, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %36 = call ptr @memcpy(ptr %Node.copy29, ptr %elem28, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy29, ptr %34, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %37 = add i64 %i27, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %38 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %38, align 8, !tbaa !0
  %39 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %39, align 8, !tbaa !0
  store ptr %Node.copy, ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %40 = icmp ult i64 %ae.iv, %ae.len
  br i1 %40, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data32, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %41 = icmp ne ptr %ae.el, null
  br i1 %41, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %42 = icmp ne ptr %dtor.fn, null
  br i1 %42, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %43 = add i64 %ae.iv, 1
  store i64 %43, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data31)
  %data33 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %bigger34 = load ptr, ptr %bigger, align 8
  store ptr %bigger34, ptr %data33, align 8, !tbaa !0
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

contract.fail:                                    ; preds = %if.end
  %count37 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count38 = load i32, ptr %count37, align 4, !tbaa !4
  %contract.l = sext i32 %count38 to i64
  call void @__polaron_fail(ptr @.contract.1478, ptr @.cl.1479, i64 %contract.l, ptr @.cr.1480, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count39 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count40 = load i32, ptr %count39, align 4, !tbaa !4
  %data41 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data42 = load ptr, ptr %data41, align 8, !tbaa !0
  %len43 = load i64, ptr %data42, align 8
  %44 = trunc i64 %len43 to i32
  %45 = icmp sle i32 %count40, %44
  %46 = zext i1 %45 to i32
  %contract.ok44 = icmp ne i32 %46, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1481, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Node.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1482, ptr @.faila.1483, i64 %13, ptr @.failb.1484, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1485, ptr @.faila.1486, i64 %14, ptr @.failb.1487, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %14
  %elem24 = load ptr, ptr %arr.elem23, align 8
  ret ptr %elem24
}

define internal void @"ArrayList$Node.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %3 = call ptr @memcpy(ptr %Node.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %class.Node, ptr %2, i32 0, i32 2
  %5 = load ptr, ptr %4, align 8, !tbaa !0
  %6 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %5, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %7 = getelementptr inbounds %"class.ArrayList$Node", ptr %5, i32 0, i32 1
  %8 = load ptr, ptr %7, align 8, !tbaa !0
  %arr.len = load i64, ptr %8, align 8
  %9 = mul i64 %arr.len, 8
  %10 = add i64 8, %9
  %arr.copy = call ptr @__polaron_malloc(i64 %10)
  %11 = call ptr @memcpy(ptr %arr.copy, ptr %8, i64 %10)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i1 = phi i64 [ 0, %entry ], [ %18, %arrdup.cont ]
  %12 = icmp slt i64 %i1, %arr.len
  br i1 %12, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %13 = mul i64 %i1, 8
  %14 = add i64 8, %13
  %15 = getelementptr i8, ptr %arr.copy, i64 %14
  %elem = load ptr, ptr %15, align 8
  %16 = icmp eq ptr %elem, null
  br i1 %16, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %17 = call ptr @memcpy(ptr %Node.copy2, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy2, ptr %15, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %18 = add i64 %i1, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %19 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %19, align 8, !tbaa !0
  %20 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %20, align 8, !tbaa !0
  store ptr %Node.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %21 = icmp sge i32 %count3, 0
  %22 = zext i1 %21 to i32
  %inv.assume = icmp ne i32 %22, 0
  call void @llvm.assume(i1 %inv.assume)
  %count4 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data6 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data6, align 8
  %23 = trunc i64 %len to i32
  %24 = icmp sle i32 %count5, %23
  %25 = zext i1 %24 to i32
  %inv.assume7 = icmp ne i32 %25, 0
  call void @llvm.assume(i1 %inv.assume7)
  %i8 = load i32, ptr %i, align 4
  %26 = icmp slt i32 %i8, 0
  %27 = zext i1 %26 to i32
  %sc.a = icmp ne i32 %27, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %arrdup.done
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %28 = icmp sge i32 %i9, %count11
  %29 = zext i1 %28 to i32
  %sc.b = icmp ne i32 %29, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %arrdup.done
  %sc = phi i1 [ true, %arrdup.done ], [ %sc.b, %sc.rhs ]
  %30 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data12 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data14 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0
  %len16 = load i64, ptr %data15, align 8
  %31 = trunc i64 %len16 to i32
  %32 = sext i32 %31 to i64
  %arr.len17 = load i64, ptr %data13, align 8
  %arr.oob = icmp uge i64 %32, %arr.len17
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data36 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i38 = load i32, ptr %i, align 4
  %33 = sext i32 %i38 to i64
  %arr.len39 = load i64, ptr %data37, align 8
  %arr.oob40 = icmp uge i64 %33, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1488, ptr @.faila.1489, i64 %32, ptr @.failb.1490, i64 %arr.len17, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data13, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %32
  %item18 = load ptr, ptr %item, align 8
  %Node.copy19 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %34 = call ptr @memcpy(ptr %Node.copy19, ptr %item18, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %class.Node, ptr %item18, i32 0, i32 2
  %36 = load ptr, ptr %35, align 8, !tbaa !0
  %"ArrayList$Node.copy20" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %37 = call ptr @memcpy(ptr %"ArrayList$Node.copy20", ptr %36, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %38 = getelementptr inbounds %"class.ArrayList$Node", ptr %36, i32 0, i32 1
  %39 = load ptr, ptr %38, align 8, !tbaa !0
  %arr.len21 = load i64, ptr %39, align 8
  %40 = mul i64 %arr.len21, 8
  %41 = add i64 8, %40
  %arr.copy22 = call ptr @__polaron_malloc(i64 %41)
  %42 = call ptr @memcpy(ptr %arr.copy22, ptr %39, i64 %41)
  br label %arrdup.head23

arrdup.head23:                                    ; preds = %arrdup.cont26, %idx.ok
  %i28 = phi i64 [ 0, %idx.ok ], [ %49, %arrdup.cont26 ]
  %43 = icmp slt i64 %i28, %arr.len21
  br i1 %43, label %arrdup.body24, label %arrdup.done27

arrdup.body24:                                    ; preds = %arrdup.head23
  %44 = mul i64 %i28, 8
  %45 = add i64 8, %44
  %46 = getelementptr i8, ptr %arr.copy22, i64 %45
  %elem29 = load ptr, ptr %46, align 8
  %47 = icmp eq ptr %elem29, null
  br i1 %47, label %arrdup.cont26, label %arrdup.copy25

arrdup.copy25:                                    ; preds = %arrdup.body24
  %Node.copy30 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %48 = call ptr @memcpy(ptr %Node.copy30, ptr %elem29, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy30, ptr %46, align 8
  br label %arrdup.cont26

arrdup.cont26:                                    ; preds = %arrdup.copy25, %arrdup.body24
  %49 = add i64 %i28, 1
  br label %arrdup.head23

arrdup.done27:                                    ; preds = %arrdup.head23
  %50 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy20", i32 0, i32 1
  store ptr %arr.copy22, ptr %50, align 8, !tbaa !0
  %51 = getelementptr inbounds %class.Node, ptr %Node.copy19, i32 0, i32 2
  store ptr %"ArrayList$Node.copy20", ptr %51, align 8, !tbaa !0
  store ptr %Node.copy19, ptr %arr.elem, align 8
  %count31 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %data33 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0
  %len35 = load i64, ptr %data34, align 8
  %52 = trunc i64 %len35 to i32
  %53 = icmp sle i32 %count32, %52
  %54 = zext i1 %53 to i32
  %contract.ok = icmp ne i32 %54, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %arrdup.done27
  call void @__polaron_fail(ptr @.contract.1491, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %arrdup.done27
  ret void

idx.bad41:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1492, ptr @.faila.1493, i64 %33, ptr @.failb.1494, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %if.end
  %arr.data43 = getelementptr i8, ptr %data37, i64 8
  %arr.elem44 = getelementptr inbounds ptr, ptr %arr.data43, i64 %33
  %item45 = load ptr, ptr %item, align 8
  %Node.copy46 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %55 = call ptr @memcpy(ptr %Node.copy46, ptr %item45, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %56 = getelementptr inbounds %class.Node, ptr %item45, i32 0, i32 2
  %57 = load ptr, ptr %56, align 8, !tbaa !0
  %"ArrayList$Node.copy47" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %58 = call ptr @memcpy(ptr %"ArrayList$Node.copy47", ptr %57, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %59 = getelementptr inbounds %"class.ArrayList$Node", ptr %57, i32 0, i32 1
  %60 = load ptr, ptr %59, align 8, !tbaa !0
  %arr.len48 = load i64, ptr %60, align 8
  %61 = mul i64 %arr.len48, 8
  %62 = add i64 8, %61
  %arr.copy49 = call ptr @__polaron_malloc(i64 %62)
  %63 = call ptr @memcpy(ptr %arr.copy49, ptr %60, i64 %62)
  br label %arrdup.head50

arrdup.head50:                                    ; preds = %arrdup.cont53, %idx.ok42
  %i55 = phi i64 [ 0, %idx.ok42 ], [ %70, %arrdup.cont53 ]
  %64 = icmp slt i64 %i55, %arr.len48
  br i1 %64, label %arrdup.body51, label %arrdup.done54

arrdup.body51:                                    ; preds = %arrdup.head50
  %65 = mul i64 %i55, 8
  %66 = add i64 8, %65
  %67 = getelementptr i8, ptr %arr.copy49, i64 %66
  %elem56 = load ptr, ptr %67, align 8
  %68 = icmp eq ptr %elem56, null
  br i1 %68, label %arrdup.cont53, label %arrdup.copy52

arrdup.copy52:                                    ; preds = %arrdup.body51
  %Node.copy57 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %69 = call ptr @memcpy(ptr %Node.copy57, ptr %elem56, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy57, ptr %67, align 8
  br label %arrdup.cont53

arrdup.cont53:                                    ; preds = %arrdup.copy52, %arrdup.body51
  %70 = add i64 %i55, 1
  br label %arrdup.head50

arrdup.done54:                                    ; preds = %arrdup.head50
  %71 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy47", i32 0, i32 1
  store ptr %arr.copy49, ptr %71, align 8, !tbaa !0
  %72 = getelementptr inbounds %class.Node, ptr %Node.copy46, i32 0, i32 2
  store ptr %"ArrayList$Node.copy47", ptr %72, align 8, !tbaa !0
  store ptr %Node.copy46, ptr %arr.elem44, align 8
  %count58 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count59 = load i32, ptr %count58, align 4, !tbaa !4
  %data60 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data61 = load ptr, ptr %data60, align 8, !tbaa !0
  %len62 = load i64, ptr %data61, align 8
  %73 = trunc i64 %len62 to i32
  %74 = icmp sle i32 %count59, %73
  %75 = zext i1 %74 to i32
  %contract.ok63 = icmp ne i32 %75, 0
  br i1 %contract.ok63, label %contract.cont65, label %contract.fail64

contract.fail64:                                  ; preds = %arrdup.done54
  call void @__polaron_fail(ptr @.contract.1495, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont65:                                  ; preds = %arrdup.done54
  ret void
}

define internal i32 @"ArrayList$Node.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i7 = alloca i32, align 4
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Node.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Node, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %5 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %4, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %"class.ArrayList$Node", ptr %4, i32 0, i32 1
  %7 = load ptr, ptr %6, align 8, !tbaa !0
  %arr.len = load i64, ptr %7, align 8
  %8 = mul i64 %arr.len, 8
  %9 = add i64 8, %8
  %arr.copy = call ptr @__polaron_malloc(i64 %9)
  %10 = call ptr @memcpy(ptr %arr.copy, ptr %7, i64 %9)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %17, %arrdup.cont ]
  %11 = icmp slt i64 %i, %arr.len
  br i1 %11, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %12 = mul i64 %i, 8
  %13 = add i64 8, %12
  %14 = getelementptr i8, ptr %arr.copy, i64 %13
  %elem = load ptr, ptr %14, align 8
  %15 = icmp eq ptr %elem, null
  br i1 %15, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Node.copy1, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy1, ptr %14, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %17 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %18 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %18, align 8, !tbaa !0
  %19 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %19, align 8, !tbaa !0
  store ptr %Node.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %20 = icmp sge i32 %count2, 0
  %21 = zext i1 %20 to i32
  %inv.assume = icmp ne i32 %21, 0
  call void @llvm.assume(i1 %inv.assume)
  %count3 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count3, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data5, align 8
  %22 = trunc i64 %len to i32
  %23 = icmp sle i32 %count4, %22
  %24 = zext i1 %23 to i32
  %inv.assume6 = icmp ne i32 %24, 0
  call void @llvm.assume(i1 %inv.assume6)
  store i32 0, ptr %i7, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %arrdup.done
  %i8 = load i32, ptr %i7, align 4
  %count9 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %25 = icmp slt i32 %i8, %count10
  %26 = zext i1 %25 to i32
  br i1 %25, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data11 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i13 = load i32, ptr %i7, align 4
  %27 = sext i32 %i13 to i64
  %arr.len14 = load i64, ptr %data12, align 8
  %arr.oob = icmp uge i64 %27, %arr.len14
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %28 = load i32, ptr %i7, align 4
  %29 = add i32 %28, 1
  store i32 %29, ptr %i7, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1496, ptr @.faila.1497, i64 %27, ptr @.failb.1498, i64 %arr.len14, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data12, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %27
  %elem15 = load ptr, ptr %arr.elem, align 8
  %item16 = load ptr, ptr %item, align 8
  %30 = call i32 @Object.equalsKey(ptr %elem15, ptr %item16)
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i17 = load i32, ptr %i7, align 4
  ret i32 %i17

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$Node.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Node.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Node, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %5 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %4, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %"class.ArrayList$Node", ptr %4, i32 0, i32 1
  %7 = load ptr, ptr %6, align 8, !tbaa !0
  %arr.len = load i64, ptr %7, align 8
  %8 = mul i64 %arr.len, 8
  %9 = add i64 8, %8
  %arr.copy = call ptr @__polaron_malloc(i64 %9)
  %10 = call ptr @memcpy(ptr %arr.copy, ptr %7, i64 %9)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %17, %arrdup.cont ]
  %11 = icmp slt i64 %i, %arr.len
  br i1 %11, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %12 = mul i64 %i, 8
  %13 = add i64 8, %12
  %14 = getelementptr i8, ptr %arr.copy, i64 %13
  %elem = load ptr, ptr %14, align 8
  %15 = icmp eq ptr %elem, null
  br i1 %15, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Node.copy1, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy1, ptr %14, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %17 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %18 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %18, align 8, !tbaa !0
  %19 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %19, align 8, !tbaa !0
  store ptr %Node.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %20 = icmp sge i32 %count2, 0
  %21 = zext i1 %20 to i32
  %inv.assume = icmp ne i32 %21, 0
  call void @llvm.assume(i1 %inv.assume)
  %count3 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count3, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data5, align 8
  %22 = trunc i64 %len to i32
  %23 = icmp sle i32 %count4, %22
  %24 = zext i1 %23 to i32
  %inv.assume6 = icmp ne i32 %24, 0
  call void @llvm.assume(i1 %inv.assume6)
  %item7 = load ptr, ptr %item, align 8
  %25 = call i32 @"ArrayList$Node.indexOf"(ptr %0, ptr %item7)
  %26 = icmp sge i32 %25, 0
  %27 = zext i1 %26 to i32
  ret i32 %27
}

define internal void @"ArrayList$Node.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca ptr, align 8
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %i31 = load i32, ptr %i, align 4
  store i32 %i31, ptr %j, align 4
  br label %for.cond

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1499, ptr @.faila.1500, i64 %13, ptr @.failb.1501, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %14 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %15 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %16 = load ptr, ptr %15, align 8, !tbaa !0
  %17 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %16, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %18 = getelementptr inbounds %"class.ArrayList$Node", ptr %16, i32 0, i32 1
  %19 = load ptr, ptr %18, align 8, !tbaa !0
  %arr.len15 = load i64, ptr %19, align 8
  %20 = mul i64 %arr.len15, 8
  %21 = add i64 8, %20
  %arr.copy = call ptr @__polaron_malloc(i64 %21)
  %22 = call ptr @memcpy(ptr %arr.copy, ptr %19, i64 %21)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok
  %i16 = phi i64 [ 0, %idx.ok ], [ %29, %arrdup.cont ]
  %23 = icmp slt i64 %i16, %arr.len15
  br i1 %23, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %24 = mul i64 %i16, 8
  %25 = add i64 8, %24
  %26 = getelementptr i8, ptr %arr.copy, i64 %25
  %elem17 = load ptr, ptr %26, align 8
  %27 = icmp eq ptr %elem17, null
  br i1 %27, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy18 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %28 = call ptr @memcpy(ptr %Node.copy18, ptr %elem17, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy18, ptr %26, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %29 = add i64 %i16, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %30 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %30, align 8, !tbaa !0
  %31 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %31, align 8, !tbaa !0
  store ptr %Node.copy, ptr %oob, align 8
  %count19 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %32 = icmp sge i32 %count20, 0
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %arrdup.done
  %count21 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count22 = load i32, ptr %count21, align 4, !tbaa !4
  %contract.l = sext i32 %count22 to i64
  call void @__polaron_fail(ptr @.contract.1502, ptr @.cl.1503, i64 %contract.l, ptr @.cr.1504, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %arrdup.done
  %count23 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count24 = load i32, ptr %count23, align 4, !tbaa !4
  %data25 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data26 = load ptr, ptr %data25, align 8, !tbaa !0
  %len27 = load i64, ptr %data26, align 8
  %34 = trunc i64 %len27 to i32
  %35 = icmp sle i32 %count24, %34
  %36 = zext i1 %35 to i32
  %contract.ok28 = icmp ne i32 %36, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1505, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j32 = load i32, ptr %j, align 4
  %count33 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %37 = sub i32 %count34, 1
  %38 = icmp slt i32 %j32, %37
  %39 = zext i1 %38 to i32
  br i1 %38, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data35 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j37 = load i32, ptr %j, align 4
  %40 = sext i32 %j37 to i64
  %arr.len38 = load i64, ptr %data36, align 8
  %arr.oob39 = icmp uge i64 %40, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !8

for.update:                                       ; preds = %arrdup.done62
  %41 = load i32, ptr %j, align 4
  %42 = add i32 %41, 1
  store i32 %42, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count66 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count67 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count68 = load i32, ptr %count67, align 4, !tbaa !4
  %43 = sub i32 %count68, 1
  store i32 %43, ptr %count66, align 4, !tbaa !4
  %count69 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count70 = load i32, ptr %count69, align 4, !tbaa !4
  %44 = icmp sge i32 %count70, 0
  %45 = zext i1 %44 to i32
  %contract.ok71 = icmp ne i32 %45, 0
  br i1 %contract.ok71, label %contract.cont73, label %contract.fail72

idx.bad40:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1506, ptr @.faila.1507, i64 %40, ptr @.failb.1508, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %for.body
  %arr.data42 = getelementptr i8, ptr %data36, i64 8
  %arr.elem43 = getelementptr inbounds ptr, ptr %arr.data42, i64 %40
  %data44 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data45 = load ptr, ptr %data44, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j46 = load i32, ptr %j, align 4
  %46 = add i32 %j46, 1
  %47 = sext i32 %46 to i64
  %arr.len47 = load i64, ptr %data45, align 8
  %arr.oob48 = icmp uge i64 %47, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !8

idx.bad49:                                        ; preds = %idx.ok41
  call void @__polaron_fail(ptr @.fail.1509, ptr @.faila.1510, i64 %47, ptr @.failb.1511, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %idx.ok41
  %arr.data51 = getelementptr i8, ptr %data45, i64 8
  %arr.elem52 = getelementptr inbounds ptr, ptr %arr.data51, i64 %47
  %elem53 = load ptr, ptr %arr.elem52, align 8
  %Node.copy54 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %48 = call ptr @memcpy(ptr %Node.copy54, ptr %elem53, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %49 = getelementptr inbounds %class.Node, ptr %elem53, i32 0, i32 2
  %50 = load ptr, ptr %49, align 8, !tbaa !0
  %"ArrayList$Node.copy55" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %51 = call ptr @memcpy(ptr %"ArrayList$Node.copy55", ptr %50, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %52 = getelementptr inbounds %"class.ArrayList$Node", ptr %50, i32 0, i32 1
  %53 = load ptr, ptr %52, align 8, !tbaa !0
  %arr.len56 = load i64, ptr %53, align 8
  %54 = mul i64 %arr.len56, 8
  %55 = add i64 8, %54
  %arr.copy57 = call ptr @__polaron_malloc(i64 %55)
  %56 = call ptr @memcpy(ptr %arr.copy57, ptr %53, i64 %55)
  br label %arrdup.head58

arrdup.head58:                                    ; preds = %arrdup.cont61, %idx.ok50
  %i63 = phi i64 [ 0, %idx.ok50 ], [ %63, %arrdup.cont61 ]
  %57 = icmp slt i64 %i63, %arr.len56
  br i1 %57, label %arrdup.body59, label %arrdup.done62

arrdup.body59:                                    ; preds = %arrdup.head58
  %58 = mul i64 %i63, 8
  %59 = add i64 8, %58
  %60 = getelementptr i8, ptr %arr.copy57, i64 %59
  %elem64 = load ptr, ptr %60, align 8
  %61 = icmp eq ptr %elem64, null
  br i1 %61, label %arrdup.cont61, label %arrdup.copy60

arrdup.copy60:                                    ; preds = %arrdup.body59
  %Node.copy65 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %62 = call ptr @memcpy(ptr %Node.copy65, ptr %elem64, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy65, ptr %60, align 8
  br label %arrdup.cont61

arrdup.cont61:                                    ; preds = %arrdup.copy60, %arrdup.body59
  %63 = add i64 %i63, 1
  br label %arrdup.head58

arrdup.done62:                                    ; preds = %arrdup.head58
  %64 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy55", i32 0, i32 1
  store ptr %arr.copy57, ptr %64, align 8, !tbaa !0
  %65 = getelementptr inbounds %class.Node, ptr %Node.copy54, i32 0, i32 2
  store ptr %"ArrayList$Node.copy55", ptr %65, align 8, !tbaa !0
  store ptr %Node.copy54, ptr %arr.elem43, align 8
  br label %for.update

contract.fail72:                                  ; preds = %for.end
  %count74 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count75 = load i32, ptr %count74, align 4, !tbaa !4
  %contract.l76 = sext i32 %count75 to i64
  call void @__polaron_fail(ptr @.contract.1512, ptr @.cl.1513, i64 %contract.l76, ptr @.cr.1514, i64 0, i32 1)
  unreachable

contract.cont73:                                  ; preds = %for.end
  %count77 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count78 = load i32, ptr %count77, align 4, !tbaa !4
  %data79 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data80 = load ptr, ptr %data79, align 8, !tbaa !0
  %len81 = load i64, ptr %data80, align 8
  %66 = trunc i64 %len81 to i32
  %67 = icmp sle i32 %count78, %66
  %68 = zext i1 %67 to i32
  %contract.ok82 = icmp ne i32 %68, 0
  br i1 %contract.ok82, label %contract.cont84, label %contract.fail83

contract.fail83:                                  ; preds = %contract.cont73
  call void @__polaron_fail(ptr @.contract.1515, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont84:                                  ; preds = %contract.cont73
  ret void
}

define internal void @"ArrayList$Node.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %j = alloca i32, align 4
  %ae.i = alloca i64, align 8
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %3 = call ptr @memcpy(ptr %Node.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %class.Node, ptr %2, i32 0, i32 2
  %5 = load ptr, ptr %4, align 8, !tbaa !0
  %6 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %5, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %7 = getelementptr inbounds %"class.ArrayList$Node", ptr %5, i32 0, i32 1
  %8 = load ptr, ptr %7, align 8, !tbaa !0
  %arr.len = load i64, ptr %8, align 8
  %9 = mul i64 %arr.len, 8
  %10 = add i64 8, %9
  %arr.copy = call ptr @__polaron_malloc(i64 %10)
  %11 = call ptr @memcpy(ptr %arr.copy, ptr %8, i64 %10)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i1 = phi i64 [ 0, %entry ], [ %18, %arrdup.cont ]
  %12 = icmp slt i64 %i1, %arr.len
  br i1 %12, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %13 = mul i64 %i1, 8
  %14 = add i64 8, %13
  %15 = getelementptr i8, ptr %arr.copy, i64 %14
  %elem = load ptr, ptr %15, align 8
  %16 = icmp eq ptr %elem, null
  br i1 %16, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy2 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %17 = call ptr @memcpy(ptr %Node.copy2, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy2, ptr %15, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %18 = add i64 %i1, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %19 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %19, align 8, !tbaa !0
  %20 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %20, align 8, !tbaa !0
  store ptr %Node.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %21 = icmp sge i32 %count3, 0
  %22 = zext i1 %21 to i32
  %inv.assume = icmp ne i32 %22, 0
  call void @llvm.assume(i1 %inv.assume)
  %count4 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data6 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data6, align 8
  %23 = trunc i64 %len to i32
  %24 = icmp sle i32 %count5, %23
  %25 = zext i1 %24 to i32
  %inv.assume7 = icmp ne i32 %25, 0
  call void @llvm.assume(i1 %inv.assume7)
  %i8 = load i32, ptr %i, align 4
  %26 = icmp slt i32 %i8, 0
  %27 = zext i1 %26 to i32
  %sc.a = icmp ne i32 %27, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %arrdup.done
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %28 = icmp sgt i32 %i9, %count11
  %29 = zext i1 %28 to i32
  %sc.b = icmp ne i32 %29, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %arrdup.done
  %sc = phi i1 [ true, %arrdup.done ], [ %sc.b, %sc.rhs ]
  %30 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data12 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data14 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0
  %len16 = load i64, ptr %data15, align 8
  %31 = trunc i64 %len16 to i32
  %32 = sext i32 %31 to i64
  %arr.len17 = load i64, ptr %data13, align 8
  %arr.oob = icmp uge i64 %32, %arr.len17
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count43 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count44 = load i32, ptr %count43, align 4, !tbaa !4
  %data45 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data46 = load ptr, ptr %data45, align 8, !tbaa !0
  %len47 = load i64, ptr %data46, align 8
  %33 = trunc i64 %len47 to i32
  %34 = icmp sge i32 %count44, %33
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then48, label %if.end49

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1516, ptr @.faila.1517, i64 %32, ptr @.failb.1518, i64 %arr.len17, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data13, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %32
  %item18 = load ptr, ptr %item, align 8
  %Node.copy19 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %36 = call ptr @memcpy(ptr %Node.copy19, ptr %item18, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %37 = getelementptr inbounds %class.Node, ptr %item18, i32 0, i32 2
  %38 = load ptr, ptr %37, align 8, !tbaa !0
  %"ArrayList$Node.copy20" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %39 = call ptr @memcpy(ptr %"ArrayList$Node.copy20", ptr %38, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %40 = getelementptr inbounds %"class.ArrayList$Node", ptr %38, i32 0, i32 1
  %41 = load ptr, ptr %40, align 8, !tbaa !0
  %arr.len21 = load i64, ptr %41, align 8
  %42 = mul i64 %arr.len21, 8
  %43 = add i64 8, %42
  %arr.copy22 = call ptr @__polaron_malloc(i64 %43)
  %44 = call ptr @memcpy(ptr %arr.copy22, ptr %41, i64 %43)
  br label %arrdup.head23

arrdup.head23:                                    ; preds = %arrdup.cont26, %idx.ok
  %i28 = phi i64 [ 0, %idx.ok ], [ %51, %arrdup.cont26 ]
  %45 = icmp slt i64 %i28, %arr.len21
  br i1 %45, label %arrdup.body24, label %arrdup.done27

arrdup.body24:                                    ; preds = %arrdup.head23
  %46 = mul i64 %i28, 8
  %47 = add i64 8, %46
  %48 = getelementptr i8, ptr %arr.copy22, i64 %47
  %elem29 = load ptr, ptr %48, align 8
  %49 = icmp eq ptr %elem29, null
  br i1 %49, label %arrdup.cont26, label %arrdup.copy25

arrdup.copy25:                                    ; preds = %arrdup.body24
  %Node.copy30 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %50 = call ptr @memcpy(ptr %Node.copy30, ptr %elem29, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy30, ptr %48, align 8
  br label %arrdup.cont26

arrdup.cont26:                                    ; preds = %arrdup.copy25, %arrdup.body24
  %51 = add i64 %i28, 1
  br label %arrdup.head23

arrdup.done27:                                    ; preds = %arrdup.head23
  %52 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy20", i32 0, i32 1
  store ptr %arr.copy22, ptr %52, align 8, !tbaa !0
  %53 = getelementptr inbounds %class.Node, ptr %Node.copy19, i32 0, i32 2
  store ptr %"ArrayList$Node.copy20", ptr %53, align 8, !tbaa !0
  store ptr %Node.copy19, ptr %arr.elem, align 8
  %count31 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %54 = icmp sge i32 %count32, 0
  %55 = zext i1 %54 to i32
  %contract.ok = icmp ne i32 %55, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %arrdup.done27
  %count33 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %contract.l = sext i32 %count34 to i64
  call void @__polaron_fail(ptr @.contract.1519, ptr @.cl.1520, i64 %contract.l, ptr @.cr.1521, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %arrdup.done27
  %count35 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %data37 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %56 = trunc i64 %len39 to i32
  %57 = icmp sle i32 %count36, %56
  %58 = zext i1 %57 to i32
  %contract.ok40 = icmp ne i32 %58, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1522, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %contract.cont
  ret void

if.then48:                                        ; preds = %if.end
  %data50 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0
  %len52 = load i64, ptr %data51, align 8
  %59 = trunc i64 %len52 to i32
  %60 = mul i32 %59, 2
  %61 = sext i32 %60 to i64
  %62 = mul i64 %61, 8
  %63 = add i64 8, %62
  %arr = call ptr @__polaron_malloc(i64 %63)
  store i64 %61, ptr %arr, align 8
  %arr.data53 = getelementptr i8, ptr %arr, i64 8
  %64 = call ptr @memset(ptr %arr.data53, i32 0, i64 %62)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

if.end49:                                         ; preds = %ae.end, %if.end
  %count92 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count93 = load i32, ptr %count92, align 4, !tbaa !4
  store i32 %count93, ptr %j, align 4
  br label %for.cond94

for.cond:                                         ; preds = %for.update, %if.then48
  %k54 = load i32, ptr %k, align 4
  %count55 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count56 = load i32, ptr %count55, align 4, !tbaa !4
  %65 = icmp slt i32 %k54, %count56
  %66 = zext i1 %65 to i32
  br i1 %65, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger57 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k58 = load i32, ptr %k, align 4
  %67 = sext i32 %k58 to i64
  %arr.len59 = load i64, ptr %bigger57, align 8
  %arr.oob60 = icmp uge i64 %67, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !8

for.update:                                       ; preds = %arrdup.done83
  %68 = load i32, ptr %k, align 4
  %69 = add i32 %68, 1
  store i32 %69, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data87 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data88 = load ptr, ptr %data87, align 8, !tbaa !0
  %ae.len = load i64, ptr %data88, align 8
  %arr.data89 = getelementptr i8, ptr %data88, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad61:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1523, ptr @.faila.1524, i64 %67, ptr @.failb.1525, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %for.body
  %arr.data63 = getelementptr i8, ptr %bigger57, i64 8
  %arr.elem64 = getelementptr inbounds ptr, ptr %arr.data63, i64 %67
  %data65 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data66 = load ptr, ptr %data65, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k67 = load i32, ptr %k, align 4
  %70 = sext i32 %k67 to i64
  %arr.len68 = load i64, ptr %data66, align 8
  %arr.oob69 = icmp uge i64 %70, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !8

idx.bad70:                                        ; preds = %idx.ok62
  call void @__polaron_fail(ptr @.fail.1526, ptr @.faila.1527, i64 %70, ptr @.failb.1528, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %idx.ok62
  %arr.data72 = getelementptr i8, ptr %data66, i64 8
  %arr.elem73 = getelementptr inbounds ptr, ptr %arr.data72, i64 %70
  %elem74 = load ptr, ptr %arr.elem73, align 8
  %Node.copy75 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %71 = call ptr @memcpy(ptr %Node.copy75, ptr %elem74, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %72 = getelementptr inbounds %class.Node, ptr %elem74, i32 0, i32 2
  %73 = load ptr, ptr %72, align 8, !tbaa !0
  %"ArrayList$Node.copy76" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %74 = call ptr @memcpy(ptr %"ArrayList$Node.copy76", ptr %73, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %75 = getelementptr inbounds %"class.ArrayList$Node", ptr %73, i32 0, i32 1
  %76 = load ptr, ptr %75, align 8, !tbaa !0
  %arr.len77 = load i64, ptr %76, align 8
  %77 = mul i64 %arr.len77, 8
  %78 = add i64 8, %77
  %arr.copy78 = call ptr @__polaron_malloc(i64 %78)
  %79 = call ptr @memcpy(ptr %arr.copy78, ptr %76, i64 %78)
  br label %arrdup.head79

arrdup.head79:                                    ; preds = %arrdup.cont82, %idx.ok71
  %i84 = phi i64 [ 0, %idx.ok71 ], [ %86, %arrdup.cont82 ]
  %80 = icmp slt i64 %i84, %arr.len77
  br i1 %80, label %arrdup.body80, label %arrdup.done83

arrdup.body80:                                    ; preds = %arrdup.head79
  %81 = mul i64 %i84, 8
  %82 = add i64 8, %81
  %83 = getelementptr i8, ptr %arr.copy78, i64 %82
  %elem85 = load ptr, ptr %83, align 8
  %84 = icmp eq ptr %elem85, null
  br i1 %84, label %arrdup.cont82, label %arrdup.copy81

arrdup.copy81:                                    ; preds = %arrdup.body80
  %Node.copy86 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %85 = call ptr @memcpy(ptr %Node.copy86, ptr %elem85, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy86, ptr %83, align 8
  br label %arrdup.cont82

arrdup.cont82:                                    ; preds = %arrdup.copy81, %arrdup.body80
  %86 = add i64 %i84, 1
  br label %arrdup.head79

arrdup.done83:                                    ; preds = %arrdup.head79
  %87 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy76", i32 0, i32 1
  store ptr %arr.copy78, ptr %87, align 8, !tbaa !0
  %88 = getelementptr inbounds %class.Node, ptr %Node.copy75, i32 0, i32 2
  store ptr %"ArrayList$Node.copy76", ptr %88, align 8, !tbaa !0
  store ptr %Node.copy75, ptr %arr.elem64, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %89 = icmp ult i64 %ae.iv, %ae.len
  br i1 %89, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data89, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %90 = icmp ne ptr %ae.el, null
  br i1 %90, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %91 = icmp ne ptr %dtor.fn, null
  br i1 %91, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %92 = add i64 %ae.iv, 1
  store i64 %92, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data88)
  %data90 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %bigger91 = load ptr, ptr %bigger, align 8
  store ptr %bigger91, ptr %data90, align 8, !tbaa !0
  br label %if.end49

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

for.cond94:                                       ; preds = %for.update96, %if.end49
  %j98 = load i32, ptr %j, align 4
  %i99 = load i32, ptr %i, align 4
  %93 = icmp sgt i32 %j98, %i99
  %94 = zext i1 %93 to i32
  br i1 %93, label %for.body95, label %for.end97

for.body95:                                       ; preds = %for.cond94
  %data100 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data101 = load ptr, ptr %data100, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j102 = load i32, ptr %j, align 4
  %95 = sext i32 %j102 to i64
  %arr.len103 = load i64, ptr %data101, align 8
  %arr.oob104 = icmp uge i64 %95, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !8

for.update96:                                     ; preds = %arrdup.done127
  %96 = load i32, ptr %j, align 4
  %97 = sub i32 %96, 1
  store i32 %97, ptr %j, align 4
  br label %for.cond94

for.end97:                                        ; preds = %for.cond94
  %data131 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data132 = load ptr, ptr %data131, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i133 = load i32, ptr %i, align 4
  %98 = sext i32 %i133 to i64
  %arr.len134 = load i64, ptr %data132, align 8
  %arr.oob135 = icmp uge i64 %98, %arr.len134
  br i1 %arr.oob135, label %idx.bad136, label %idx.ok137, !prof !8

idx.bad105:                                       ; preds = %for.body95
  call void @__polaron_fail(ptr @.fail.1529, ptr @.faila.1530, i64 %95, ptr @.failb.1531, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %for.body95
  %arr.data107 = getelementptr i8, ptr %data101, i64 8
  %arr.elem108 = getelementptr inbounds ptr, ptr %arr.data107, i64 %95
  %data109 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data110 = load ptr, ptr %data109, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j111 = load i32, ptr %j, align 4
  %99 = sub i32 %j111, 1
  %100 = sext i32 %99 to i64
  %arr.len112 = load i64, ptr %data110, align 8
  %arr.oob113 = icmp uge i64 %100, %arr.len112
  br i1 %arr.oob113, label %idx.bad114, label %idx.ok115, !prof !8

idx.bad114:                                       ; preds = %idx.ok106
  call void @__polaron_fail(ptr @.fail.1532, ptr @.faila.1533, i64 %100, ptr @.failb.1534, i64 %arr.len112, i32 70)
  unreachable

idx.ok115:                                        ; preds = %idx.ok106
  %arr.data116 = getelementptr i8, ptr %data110, i64 8
  %arr.elem117 = getelementptr inbounds ptr, ptr %arr.data116, i64 %100
  %elem118 = load ptr, ptr %arr.elem117, align 8
  %Node.copy119 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %101 = call ptr @memcpy(ptr %Node.copy119, ptr %elem118, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %102 = getelementptr inbounds %class.Node, ptr %elem118, i32 0, i32 2
  %103 = load ptr, ptr %102, align 8, !tbaa !0
  %"ArrayList$Node.copy120" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %104 = call ptr @memcpy(ptr %"ArrayList$Node.copy120", ptr %103, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %105 = getelementptr inbounds %"class.ArrayList$Node", ptr %103, i32 0, i32 1
  %106 = load ptr, ptr %105, align 8, !tbaa !0
  %arr.len121 = load i64, ptr %106, align 8
  %107 = mul i64 %arr.len121, 8
  %108 = add i64 8, %107
  %arr.copy122 = call ptr @__polaron_malloc(i64 %108)
  %109 = call ptr @memcpy(ptr %arr.copy122, ptr %106, i64 %108)
  br label %arrdup.head123

arrdup.head123:                                   ; preds = %arrdup.cont126, %idx.ok115
  %i128 = phi i64 [ 0, %idx.ok115 ], [ %116, %arrdup.cont126 ]
  %110 = icmp slt i64 %i128, %arr.len121
  br i1 %110, label %arrdup.body124, label %arrdup.done127

arrdup.body124:                                   ; preds = %arrdup.head123
  %111 = mul i64 %i128, 8
  %112 = add i64 8, %111
  %113 = getelementptr i8, ptr %arr.copy122, i64 %112
  %elem129 = load ptr, ptr %113, align 8
  %114 = icmp eq ptr %elem129, null
  br i1 %114, label %arrdup.cont126, label %arrdup.copy125

arrdup.copy125:                                   ; preds = %arrdup.body124
  %Node.copy130 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %115 = call ptr @memcpy(ptr %Node.copy130, ptr %elem129, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy130, ptr %113, align 8
  br label %arrdup.cont126

arrdup.cont126:                                   ; preds = %arrdup.copy125, %arrdup.body124
  %116 = add i64 %i128, 1
  br label %arrdup.head123

arrdup.done127:                                   ; preds = %arrdup.head123
  %117 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy120", i32 0, i32 1
  store ptr %arr.copy122, ptr %117, align 8, !tbaa !0
  %118 = getelementptr inbounds %class.Node, ptr %Node.copy119, i32 0, i32 2
  store ptr %"ArrayList$Node.copy120", ptr %118, align 8, !tbaa !0
  store ptr %Node.copy119, ptr %arr.elem108, align 8
  br label %for.update96

idx.bad136:                                       ; preds = %for.end97
  call void @__polaron_fail(ptr @.fail.1535, ptr @.faila.1536, i64 %98, ptr @.failb.1537, i64 %arr.len134, i32 70)
  unreachable

idx.ok137:                                        ; preds = %for.end97
  %arr.data138 = getelementptr i8, ptr %data132, i64 8
  %arr.elem139 = getelementptr inbounds ptr, ptr %arr.data138, i64 %98
  %item140 = load ptr, ptr %item, align 8
  %Node.copy141 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %119 = call ptr @memcpy(ptr %Node.copy141, ptr %item140, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %120 = getelementptr inbounds %class.Node, ptr %item140, i32 0, i32 2
  %121 = load ptr, ptr %120, align 8, !tbaa !0
  %"ArrayList$Node.copy142" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %122 = call ptr @memcpy(ptr %"ArrayList$Node.copy142", ptr %121, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %123 = getelementptr inbounds %"class.ArrayList$Node", ptr %121, i32 0, i32 1
  %124 = load ptr, ptr %123, align 8, !tbaa !0
  %arr.len143 = load i64, ptr %124, align 8
  %125 = mul i64 %arr.len143, 8
  %126 = add i64 8, %125
  %arr.copy144 = call ptr @__polaron_malloc(i64 %126)
  %127 = call ptr @memcpy(ptr %arr.copy144, ptr %124, i64 %126)
  br label %arrdup.head145

arrdup.head145:                                   ; preds = %arrdup.cont148, %idx.ok137
  %i150 = phi i64 [ 0, %idx.ok137 ], [ %134, %arrdup.cont148 ]
  %128 = icmp slt i64 %i150, %arr.len143
  br i1 %128, label %arrdup.body146, label %arrdup.done149

arrdup.body146:                                   ; preds = %arrdup.head145
  %129 = mul i64 %i150, 8
  %130 = add i64 8, %129
  %131 = getelementptr i8, ptr %arr.copy144, i64 %130
  %elem151 = load ptr, ptr %131, align 8
  %132 = icmp eq ptr %elem151, null
  br i1 %132, label %arrdup.cont148, label %arrdup.copy147

arrdup.copy147:                                   ; preds = %arrdup.body146
  %Node.copy152 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %133 = call ptr @memcpy(ptr %Node.copy152, ptr %elem151, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy152, ptr %131, align 8
  br label %arrdup.cont148

arrdup.cont148:                                   ; preds = %arrdup.copy147, %arrdup.body146
  %134 = add i64 %i150, 1
  br label %arrdup.head145

arrdup.done149:                                   ; preds = %arrdup.head145
  %135 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy142", i32 0, i32 1
  store ptr %arr.copy144, ptr %135, align 8, !tbaa !0
  %136 = getelementptr inbounds %class.Node, ptr %Node.copy141, i32 0, i32 2
  store ptr %"ArrayList$Node.copy142", ptr %136, align 8, !tbaa !0
  store ptr %Node.copy141, ptr %arr.elem139, align 8
  %count153 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count154 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count155 = load i32, ptr %count154, align 4, !tbaa !4
  %137 = add i32 %count155, 1
  store i32 %137, ptr %count153, align 4, !tbaa !4
  %count156 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count157 = load i32, ptr %count156, align 4, !tbaa !4
  %138 = icmp sge i32 %count157, 0
  %139 = zext i1 %138 to i32
  %contract.ok158 = icmp ne i32 %139, 0
  br i1 %contract.ok158, label %contract.cont160, label %contract.fail159

contract.fail159:                                 ; preds = %arrdup.done149
  %count161 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count162 = load i32, ptr %count161, align 4, !tbaa !4
  %contract.l163 = sext i32 %count162 to i64
  call void @__polaron_fail(ptr @.contract.1538, ptr @.cl.1539, i64 %contract.l163, ptr @.cr.1540, i64 0, i32 1)
  unreachable

contract.cont160:                                 ; preds = %arrdup.done149
  %count164 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count165 = load i32, ptr %count164, align 4, !tbaa !4
  %data166 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data167 = load ptr, ptr %data166, align 8, !tbaa !0
  %len168 = load i64, ptr %data167, align 8
  %140 = trunc i64 %len168 to i32
  %141 = icmp sle i32 %count165, %140
  %142 = zext i1 %141 to i32
  %contract.ok169 = icmp ne i32 %142, 0
  br i1 %contract.ok169, label %contract.cont171, label %contract.fail170

contract.fail170:                                 ; preds = %contract.cont160
  call void @__polaron_fail(ptr @.contract.1541, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont171:                                 ; preds = %contract.cont160
  ret void
}

define internal i32 @"ArrayList$Node.remove"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i8 = alloca i32, align 4
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Node.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Node, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %5 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %4, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %"class.ArrayList$Node", ptr %4, i32 0, i32 1
  %7 = load ptr, ptr %6, align 8, !tbaa !0
  %arr.len = load i64, ptr %7, align 8
  %8 = mul i64 %arr.len, 8
  %9 = add i64 8, %8
  %arr.copy = call ptr @__polaron_malloc(i64 %9)
  %10 = call ptr @memcpy(ptr %arr.copy, ptr %7, i64 %9)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %17, %arrdup.cont ]
  %11 = icmp slt i64 %i, %arr.len
  br i1 %11, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %12 = mul i64 %i, 8
  %13 = add i64 8, %12
  %14 = getelementptr i8, ptr %arr.copy, i64 %13
  %elem = load ptr, ptr %14, align 8
  %15 = icmp eq ptr %elem, null
  br i1 %15, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy1 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Node.copy1, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy1, ptr %14, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %17 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %18 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %18, align 8, !tbaa !0
  %19 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %19, align 8, !tbaa !0
  store ptr %Node.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %20 = icmp sge i32 %count2, 0
  %21 = zext i1 %20 to i32
  %inv.assume = icmp ne i32 %21, 0
  call void @llvm.assume(i1 %inv.assume)
  %count3 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count3, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data5, align 8
  %22 = trunc i64 %len to i32
  %23 = icmp sle i32 %count4, %22
  %24 = zext i1 %23 to i32
  %inv.assume6 = icmp ne i32 %24, 0
  call void @llvm.assume(i1 %inv.assume6)
  %item7 = load ptr, ptr %item, align 8
  %25 = call i32 @"ArrayList$Node.indexOf"(ptr %0, ptr %item7)
  store i32 %25, ptr %i8, align 4
  %i9 = load i32, ptr %i8, align 4
  %26 = icmp slt i32 %i9, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %arrdup.done
  ret i32 0

if.end:                                           ; preds = %arrdup.done
  %i10 = load i32, ptr %i8, align 4
  call void @"ArrayList$Node.removeAt"(ptr %0, i32 %i10)
  ret i32 1
}

define internal void @"ArrayList$Node.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.1542, ptr @.cl.1543, i64 %contract.l, ptr @.cr.1544, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1545, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Node.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
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
  %count9 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
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

for.update:                                       ; preds = %arrdup.done
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out27 = load ptr, ptr %out, align 8
  ret ptr %out27

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1546, ptr @.faila.1547, i64 %12, ptr @.failb.1548, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1549, ptr @.faila.1550, i64 %15, ptr @.failb.1551, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %15
  %elem = load ptr, ptr %arr.elem22, align 8
  %Node.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %18 = load ptr, ptr %17, align 8, !tbaa !0
  %"ArrayList$Node.copy" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %19 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %18, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %20 = getelementptr inbounds %"class.ArrayList$Node", ptr %18, i32 0, i32 1
  %21 = load ptr, ptr %20, align 8, !tbaa !0
  %arr.len23 = load i64, ptr %21, align 8
  %22 = mul i64 %arr.len23, 8
  %23 = add i64 8, %22
  %arr.copy = call ptr @__polaron_malloc(i64 %23)
  %24 = call ptr @memcpy(ptr %arr.copy, ptr %21, i64 %23)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok20
  %i24 = phi i64 [ 0, %idx.ok20 ], [ %31, %arrdup.cont ]
  %25 = icmp slt i64 %i24, %arr.len23
  br i1 %25, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %26 = mul i64 %i24, 8
  %27 = add i64 8, %26
  %28 = getelementptr i8, ptr %arr.copy, i64 %27
  %elem25 = load ptr, ptr %28, align 8
  %29 = icmp eq ptr %elem25, null
  br i1 %29, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy26 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %30 = call ptr @memcpy(ptr %Node.copy26, ptr %elem25, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy26, ptr %28, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %31 = add i64 %i24, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %32 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %32, align 8, !tbaa !0
  %33 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %33, align 8, !tbaa !0
  store ptr %Node.copy, ptr %arr.elem, align 8
  br label %for.update
}

define internal i32 @"ArrayList$Node.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$Node.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$Node.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1552, ptr @.faila.1553, i64 %10, ptr @.failb.1554, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  call void %code(ptr %env, ptr %elem)
  br label %for.update
}

define internal ptr @"ArrayList$Node.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Node.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  call void @"ArrayList$Node.ArrayList$Node"(ptr %"ArrayList$Node.obj")
  store ptr %"ArrayList$Node.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$Node.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1555, ptr @.faila.1556, i64 %10, ptr @.failb.1557, i64 %arr.len, i32 70)
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
  %data17 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1558, ptr @.faila.1559, i64 %15, ptr @.failb.1560, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %15
  %elem26 = load ptr, ptr %arr.elem25, align 8
  call void @"ArrayList$Node.add"(ptr %out16, ptr %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$Node.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1561, ptr @.faila.1562, i64 %10, ptr @.failb.1563, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Node.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1564, ptr @.faila.1565, i64 %10, ptr @.failb.1566, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Node.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1567, ptr @.faila.1568, i64 %10, ptr @.failb.1569, i64 %arr.len, i32 70)
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

define internal ptr @"ArrayList$Node.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Node.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  call void @"ArrayList$Node.ArrayList$Node"(ptr %"ArrayList$Node.obj")
  store ptr %"ArrayList$Node.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$Node.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %12 = call i32 @"ArrayList$Node.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1570, ptr @.faila.1571, i64 %9, ptr @.failb.1572, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  call void @"ArrayList$Node.add"(ptr %out12, ptr %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$Node.size"(ptr %out17)
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
  %20 = call i32 @"ArrayList$Node.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Node.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  %ae.len = load i64, ptr %scratch23, align 8
  %arr.data24 = getelementptr i8, ptr %scratch23, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

if.end:                                           ; preds = %ae.end, %for.end
  %out25 = load ptr, ptr %out, align 8
  %count26 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
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
  %vtbl.addr = getelementptr inbounds %class.Node, ptr %ae.el, i32 0, i32 0
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
  %count28 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %contract.l = sext i32 %count29 to i64
  call void @__polaron_fail(ptr @.contract.1573, ptr @.cl.1574, i64 %contract.l, ptr @.cr.1575, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count30 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %data32 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %len34 = load i64, ptr %data33, align 8
  %28 = trunc i64 %len34 to i32
  %29 = icmp sle i32 %count31, %28
  %30 = zext i1 %29 to i32
  %contract.ok35 = icmp ne i32 %30, 0
  br i1 %contract.ok35, label %contract.cont37, label %contract.fail36

contract.fail36:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1576, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont37:                                  ; preds = %contract.cont
  ret ptr %out25
}

define internal void @"ArrayList$Node.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %i148 = alloca i32, align 4
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %q = alloca i32, align 4
  %key = alloca ptr, align 8
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %p = alloca i32, align 4
  %compare = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca ptr, align 8
  store ptr %1, ptr %tmp, align 8
  store i32 %2, ptr %lo, align 4
  store i32 %3, ptr %hi, align 4
  store ptr %4, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.1577, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  ret void

if.then15:                                        ; preds = %if.end
  %lo17 = load i32, ptr %lo, align 4
  %18 = add i32 %lo17, 1
  store i32 %18, ptr %p, align 4
  br label %for.cond

if.end16:                                         ; preds = %if.end
  %lo104 = load i32, ptr %lo, align 4
  %hi105 = load i32, ptr %hi, align 4
  %19 = add i32 %lo104, %hi105
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
  %data20 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %arrdup.done91
  %p95 = load i32, ptr %p, align 4
  %26 = add i32 %p95, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count96 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count97 = load i32, ptr %count96, align 4, !tbaa !4
  %data98 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data99 = load ptr, ptr %data98, align 8, !tbaa !0
  %len100 = load i64, ptr %data99, align 8
  %27 = trunc i64 %len100 to i32
  %28 = icmp sle i32 %count97, %27
  %29 = zext i1 %28 to i32
  %contract.ok101 = icmp ne i32 %29, 0
  br i1 %contract.ok101, label %contract.cont103, label %contract.fail102

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1578, ptr @.faila.1579, i64 %25, ptr @.failb.1580, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %25
  %elem = load ptr, ptr %arr.elem, align 8
  %30 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %32 = load ptr, ptr %31, align 8, !tbaa !0
  %33 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %32, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %34 = getelementptr inbounds %"class.ArrayList$Node", ptr %32, i32 0, i32 1
  %35 = load ptr, ptr %34, align 8, !tbaa !0
  %arr.len23 = load i64, ptr %35, align 8
  %36 = mul i64 %arr.len23, 8
  %37 = add i64 8, %36
  %arr.copy = call ptr @__polaron_malloc(i64 %37)
  %38 = call ptr @memcpy(ptr %arr.copy, ptr %35, i64 %37)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok
  %i = phi i64 [ 0, %idx.ok ], [ %45, %arrdup.cont ]
  %39 = icmp slt i64 %i, %arr.len23
  br i1 %39, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %40 = mul i64 %i, 8
  %41 = add i64 8, %40
  %42 = getelementptr i8, ptr %arr.copy, i64 %41
  %elem24 = load ptr, ptr %42, align 8
  %43 = icmp eq ptr %elem24, null
  br i1 %43, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy25 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %44 = call ptr @memcpy(ptr %Node.copy25, ptr %elem24, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy25, ptr %42, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %45 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %46 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %46, align 8, !tbaa !0
  %47 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %47, align 8, !tbaa !0
  store ptr %Node.copy, ptr %key, align 8
  %p26 = load i32, ptr %p, align 4
  %48 = sub i32 %p26, 1
  store i32 %48, ptr %q, align 4
  br label %while.cond

while.cond:                                       ; preds = %arrdup.done68, %arrdup.done
  %q27 = load i32, ptr %q, align 4
  %lo28 = load i32, ptr %lo, align 4
  %49 = icmp sge i32 %q27, %lo28
  %50 = zext i1 %49 to i32
  %sc.a = icmp ne i32 %50, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %data41 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data42 = load ptr, ptr %data41, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q43 = load i32, ptr %q, align 4
  %51 = add i32 %q43, 1
  %52 = sext i32 %51 to i64
  %arr.len44 = load i64, ptr %data42, align 8
  %arr.oob45 = icmp uge i64 %52, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !8

while.end:                                        ; preds = %sc.end
  %data73 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q75 = load i32, ptr %q, align 4
  %53 = add i32 %q75, 1
  %54 = sext i32 %53 to i64
  %arr.len76 = load i64, ptr %data74, align 8
  %arr.oob77 = icmp uge i64 %54, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare29 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare29, align 8
  %55 = getelementptr ptr, ptr %compare29, i32 1
  %env = load ptr, ptr %55, align 8
  %data30 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q32 = load i32, ptr %q, align 4
  %56 = sext i32 %q32 to i64
  %arr.len33 = load i64, ptr %data31, align 8
  %arr.oob34 = icmp uge i64 %56, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

sc.end:                                           ; preds = %idx.ok36, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok36 ]
  %57 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad35:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1581, ptr @.faila.1582, i64 %56, ptr @.failb.1583, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %sc.rhs
  %arr.data37 = getelementptr i8, ptr %data31, i64 8
  %arr.elem38 = getelementptr inbounds ptr, ptr %arr.data37, i64 %56
  %elem39 = load ptr, ptr %arr.elem38, align 8
  %key40 = load ptr, ptr %key, align 8
  %58 = call i32 %code(ptr %env, ptr %elem39, ptr %key40)
  %59 = icmp sgt i32 %58, 0
  %60 = zext i1 %59 to i32
  %sc.b = icmp ne i32 %60, 0
  br label %sc.end

idx.bad46:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1584, ptr @.faila.1585, i64 %52, ptr @.failb.1586, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %while.body
  %arr.data48 = getelementptr i8, ptr %data42, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 %52
  %data50 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q52 = load i32, ptr %q, align 4
  %61 = sext i32 %q52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %61, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.1587, ptr @.faila.1588, i64 %61, ptr @.failb.1589, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %data51, i64 8
  %arr.elem58 = getelementptr inbounds ptr, ptr %arr.data57, i64 %61
  %elem59 = load ptr, ptr %arr.elem58, align 8
  %Node.copy60 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %62 = call ptr @memcpy(ptr %Node.copy60, ptr %elem59, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %63 = getelementptr inbounds %class.Node, ptr %elem59, i32 0, i32 2
  %64 = load ptr, ptr %63, align 8, !tbaa !0
  %"ArrayList$Node.copy61" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %65 = call ptr @memcpy(ptr %"ArrayList$Node.copy61", ptr %64, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %66 = getelementptr inbounds %"class.ArrayList$Node", ptr %64, i32 0, i32 1
  %67 = load ptr, ptr %66, align 8, !tbaa !0
  %arr.len62 = load i64, ptr %67, align 8
  %68 = mul i64 %arr.len62, 8
  %69 = add i64 8, %68
  %arr.copy63 = call ptr @__polaron_malloc(i64 %69)
  %70 = call ptr @memcpy(ptr %arr.copy63, ptr %67, i64 %69)
  br label %arrdup.head64

arrdup.head64:                                    ; preds = %arrdup.cont67, %idx.ok56
  %i69 = phi i64 [ 0, %idx.ok56 ], [ %77, %arrdup.cont67 ]
  %71 = icmp slt i64 %i69, %arr.len62
  br i1 %71, label %arrdup.body65, label %arrdup.done68

arrdup.body65:                                    ; preds = %arrdup.head64
  %72 = mul i64 %i69, 8
  %73 = add i64 8, %72
  %74 = getelementptr i8, ptr %arr.copy63, i64 %73
  %elem70 = load ptr, ptr %74, align 8
  %75 = icmp eq ptr %elem70, null
  br i1 %75, label %arrdup.cont67, label %arrdup.copy66

arrdup.copy66:                                    ; preds = %arrdup.body65
  %Node.copy71 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %76 = call ptr @memcpy(ptr %Node.copy71, ptr %elem70, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy71, ptr %74, align 8
  br label %arrdup.cont67

arrdup.cont67:                                    ; preds = %arrdup.copy66, %arrdup.body65
  %77 = add i64 %i69, 1
  br label %arrdup.head64

arrdup.done68:                                    ; preds = %arrdup.head64
  %78 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy61", i32 0, i32 1
  store ptr %arr.copy63, ptr %78, align 8, !tbaa !0
  %79 = getelementptr inbounds %class.Node, ptr %Node.copy60, i32 0, i32 2
  store ptr %"ArrayList$Node.copy61", ptr %79, align 8, !tbaa !0
  store ptr %Node.copy60, ptr %arr.elem49, align 8
  %q72 = load i32, ptr %q, align 4
  %80 = sub i32 %q72, 1
  store i32 %80, ptr %q, align 4
  br label %while.cond

idx.bad78:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1590, ptr @.faila.1591, i64 %54, ptr @.failb.1592, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %while.end
  %arr.data80 = getelementptr i8, ptr %data74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %54
  %key82 = load ptr, ptr %key, align 8
  %Node.copy83 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %81 = call ptr @memcpy(ptr %Node.copy83, ptr %key82, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %82 = getelementptr inbounds %class.Node, ptr %key82, i32 0, i32 2
  %83 = load ptr, ptr %82, align 8, !tbaa !0
  %"ArrayList$Node.copy84" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %84 = call ptr @memcpy(ptr %"ArrayList$Node.copy84", ptr %83, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %85 = getelementptr inbounds %"class.ArrayList$Node", ptr %83, i32 0, i32 1
  %86 = load ptr, ptr %85, align 8, !tbaa !0
  %arr.len85 = load i64, ptr %86, align 8
  %87 = mul i64 %arr.len85, 8
  %88 = add i64 8, %87
  %arr.copy86 = call ptr @__polaron_malloc(i64 %88)
  %89 = call ptr @memcpy(ptr %arr.copy86, ptr %86, i64 %88)
  br label %arrdup.head87

arrdup.head87:                                    ; preds = %arrdup.cont90, %idx.ok79
  %i92 = phi i64 [ 0, %idx.ok79 ], [ %96, %arrdup.cont90 ]
  %90 = icmp slt i64 %i92, %arr.len85
  br i1 %90, label %arrdup.body88, label %arrdup.done91

arrdup.body88:                                    ; preds = %arrdup.head87
  %91 = mul i64 %i92, 8
  %92 = add i64 8, %91
  %93 = getelementptr i8, ptr %arr.copy86, i64 %92
  %elem93 = load ptr, ptr %93, align 8
  %94 = icmp eq ptr %elem93, null
  br i1 %94, label %arrdup.cont90, label %arrdup.copy89

arrdup.copy89:                                    ; preds = %arrdup.body88
  %Node.copy94 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %95 = call ptr @memcpy(ptr %Node.copy94, ptr %elem93, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy94, ptr %93, align 8
  br label %arrdup.cont90

arrdup.cont90:                                    ; preds = %arrdup.copy89, %arrdup.body88
  %96 = add i64 %i92, 1
  br label %arrdup.head87

arrdup.done91:                                    ; preds = %arrdup.head87
  %97 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy84", i32 0, i32 1
  store ptr %arr.copy86, ptr %97, align 8, !tbaa !0
  %98 = getelementptr inbounds %class.Node, ptr %Node.copy83, i32 0, i32 2
  store ptr %"ArrayList$Node.copy84", ptr %98, align 8, !tbaa !0
  store ptr %Node.copy83, ptr %arr.elem81, align 8
  br label %for.update

contract.fail102:                                 ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.1593, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont103:                                 ; preds = %for.end
  ret void

div.bad:                                          ; preds = %if.end16
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end16
  %99 = sdiv i32 %19, 2
  store i32 %99, ptr %mid, align 4
  %tmp106 = load ptr, ptr %tmp, align 8
  %lo107 = load i32, ptr %lo, align 4
  %mid108 = load i32, ptr %mid, align 4
  %compare109 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Node.mergeSortRange"(ptr %0, ptr %tmp106, i32 %lo107, i32 %mid108, ptr %compare109)
  %tmp110 = load ptr, ptr %tmp, align 8
  %mid111 = load i32, ptr %mid, align 4
  %100 = add i32 %mid111, 1
  %hi112 = load i32, ptr %hi, align 4
  %compare113 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Node.mergeSortRange"(ptr %0, ptr %tmp110, i32 %100, i32 %hi112, ptr %compare113)
  %compare114 = load ptr, ptr %compare, align 8
  %code115 = load ptr, ptr %compare114, align 8
  %101 = getelementptr ptr, ptr %compare114, i32 1
  %env116 = load ptr, ptr %101, align 8
  %data117 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data118 = load ptr, ptr %data117, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid119 = load i32, ptr %mid, align 4
  %102 = sext i32 %mid119 to i64
  %arr.len120 = load i64, ptr %data118, align 8
  %arr.oob121 = icmp uge i64 %102, %arr.len120
  br i1 %arr.oob121, label %idx.bad122, label %idx.ok123, !prof !8

idx.bad122:                                       ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1594, ptr @.faila.1595, i64 %102, ptr @.failb.1596, i64 %arr.len120, i32 70)
  unreachable

idx.ok123:                                        ; preds = %div.ok
  %arr.data124 = getelementptr i8, ptr %data118, i64 8
  %arr.elem125 = getelementptr inbounds ptr, ptr %arr.data124, i64 %102
  %elem126 = load ptr, ptr %arr.elem125, align 8
  %data127 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data128 = load ptr, ptr %data127, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid129 = load i32, ptr %mid, align 4
  %103 = add i32 %mid129, 1
  %104 = sext i32 %103 to i64
  %arr.len130 = load i64, ptr %data128, align 8
  %arr.oob131 = icmp uge i64 %104, %arr.len130
  br i1 %arr.oob131, label %idx.bad132, label %idx.ok133, !prof !8

idx.bad132:                                       ; preds = %idx.ok123
  call void @__polaron_fail(ptr @.fail.1597, ptr @.faila.1598, i64 %104, ptr @.failb.1599, i64 %arr.len130, i32 70)
  unreachable

idx.ok133:                                        ; preds = %idx.ok123
  %arr.data134 = getelementptr i8, ptr %data128, i64 8
  %arr.elem135 = getelementptr inbounds ptr, ptr %arr.data134, i64 %104
  %elem136 = load ptr, ptr %arr.elem135, align 8
  %105 = call i32 %code115(ptr %env116, ptr %elem126, ptr %elem136)
  %106 = icmp sle i32 %105, 0
  %107 = zext i1 %106 to i32
  br i1 %106, label %if.then137, label %if.end138

if.then137:                                       ; preds = %idx.ok133
  %count139 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count140 = load i32, ptr %count139, align 4, !tbaa !4
  %data141 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data142 = load ptr, ptr %data141, align 8, !tbaa !0
  %len143 = load i64, ptr %data142, align 8
  %108 = trunc i64 %len143 to i32
  %109 = icmp sle i32 %count140, %108
  %110 = zext i1 %109 to i32
  %contract.ok144 = icmp ne i32 %110, 0
  br i1 %contract.ok144, label %contract.cont146, label %contract.fail145

if.end138:                                        ; preds = %idx.ok133
  %lo147 = load i32, ptr %lo, align 4
  store i32 %lo147, ptr %i148, align 4
  %mid149 = load i32, ptr %mid, align 4
  %111 = add i32 %mid149, 1
  store i32 %111, ptr %j, align 4
  %lo150 = load i32, ptr %lo, align 4
  store i32 %lo150, ptr %k, align 4
  br label %while.cond151

contract.fail145:                                 ; preds = %if.then137
  call void @__polaron_fail(ptr @.contract.1600, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont146:                                 ; preds = %if.then137
  ret void

while.cond151:                                    ; preds = %if.end187, %if.end138
  %i154 = load i32, ptr %i148, align 4
  %mid155 = load i32, ptr %mid, align 4
  %112 = icmp sle i32 %i154, %mid155
  %113 = zext i1 %112 to i32
  %sc.a156 = icmp ne i32 %113, 0
  br i1 %sc.a156, label %sc.rhs157, label %sc.end158

while.body152:                                    ; preds = %sc.end158
  %compare163 = load ptr, ptr %compare, align 8
  %code164 = load ptr, ptr %compare163, align 8
  %114 = getelementptr ptr, ptr %compare163, i32 1
  %env165 = load ptr, ptr %114, align 8
  %data166 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data167 = load ptr, ptr %data166, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i168 = load i32, ptr %i148, align 4
  %115 = sext i32 %i168 to i64
  %arr.len169 = load i64, ptr %data167, align 8
  %arr.oob170 = icmp uge i64 %115, %arr.len169
  br i1 %arr.oob170, label %idx.bad171, label %idx.ok172, !prof !8

while.end153:                                     ; preds = %sc.end158
  br label %while.cond251

sc.rhs157:                                        ; preds = %while.cond151
  %j159 = load i32, ptr %j, align 4
  %hi160 = load i32, ptr %hi, align 4
  %116 = icmp sle i32 %j159, %hi160
  %117 = zext i1 %116 to i32
  %sc.b161 = icmp ne i32 %117, 0
  br label %sc.end158

sc.end158:                                        ; preds = %sc.rhs157, %while.cond151
  %sc162 = phi i1 [ false, %while.cond151 ], [ %sc.b161, %sc.rhs157 ]
  %118 = zext i1 %sc162 to i32
  br i1 %sc162, label %while.body152, label %while.end153

idx.bad171:                                       ; preds = %while.body152
  call void @__polaron_fail(ptr @.fail.1601, ptr @.faila.1602, i64 %115, ptr @.failb.1603, i64 %arr.len169, i32 70)
  unreachable

idx.ok172:                                        ; preds = %while.body152
  %arr.data173 = getelementptr i8, ptr %data167, i64 8
  %arr.elem174 = getelementptr inbounds ptr, ptr %arr.data173, i64 %115
  %elem175 = load ptr, ptr %arr.elem174, align 8
  %data176 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data177 = load ptr, ptr %data176, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j178 = load i32, ptr %j, align 4
  %119 = sext i32 %j178 to i64
  %arr.len179 = load i64, ptr %data177, align 8
  %arr.oob180 = icmp uge i64 %119, %arr.len179
  br i1 %arr.oob180, label %idx.bad181, label %idx.ok182, !prof !8

idx.bad181:                                       ; preds = %idx.ok172
  call void @__polaron_fail(ptr @.fail.1604, ptr @.faila.1605, i64 %119, ptr @.failb.1606, i64 %arr.len179, i32 70)
  unreachable

idx.ok182:                                        ; preds = %idx.ok172
  %arr.data183 = getelementptr i8, ptr %data177, i64 8
  %arr.elem184 = getelementptr inbounds ptr, ptr %arr.data183, i64 %119
  %elem185 = load ptr, ptr %arr.elem184, align 8
  %120 = call i32 %code164(ptr %env165, ptr %elem175, ptr %elem185)
  %121 = icmp sle i32 %120, 0
  %122 = zext i1 %121 to i32
  br i1 %121, label %if.then186, label %if.else

if.then186:                                       ; preds = %idx.ok182
  %tmp188 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k189 = load i32, ptr %k, align 4
  %123 = sext i32 %k189 to i64
  %arr.len190 = load i64, ptr %tmp188, align 8
  %arr.oob191 = icmp uge i64 %123, %arr.len190
  br i1 %arr.oob191, label %idx.bad192, label %idx.ok193, !prof !8

if.else:                                          ; preds = %idx.ok182
  %tmp219 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k220 = load i32, ptr %k, align 4
  %124 = sext i32 %k220 to i64
  %arr.len221 = load i64, ptr %tmp219, align 8
  %arr.oob222 = icmp uge i64 %124, %arr.len221
  br i1 %arr.oob222, label %idx.bad223, label %idx.ok224, !prof !8

if.end187:                                        ; preds = %arrdup.done245, %arrdup.done214
  %k250 = load i32, ptr %k, align 4
  %125 = add i32 %k250, 1
  store i32 %125, ptr %k, align 4
  br label %while.cond151

idx.bad192:                                       ; preds = %if.then186
  call void @__polaron_fail(ptr @.fail.1607, ptr @.faila.1608, i64 %123, ptr @.failb.1609, i64 %arr.len190, i32 70)
  unreachable

idx.ok193:                                        ; preds = %if.then186
  %arr.data194 = getelementptr i8, ptr %tmp188, i64 8
  %arr.elem195 = getelementptr inbounds ptr, ptr %arr.data194, i64 %123
  %data196 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data197 = load ptr, ptr %data196, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i198 = load i32, ptr %i148, align 4
  %126 = sext i32 %i198 to i64
  %arr.len199 = load i64, ptr %data197, align 8
  %arr.oob200 = icmp uge i64 %126, %arr.len199
  br i1 %arr.oob200, label %idx.bad201, label %idx.ok202, !prof !8

idx.bad201:                                       ; preds = %idx.ok193
  call void @__polaron_fail(ptr @.fail.1610, ptr @.faila.1611, i64 %126, ptr @.failb.1612, i64 %arr.len199, i32 70)
  unreachable

idx.ok202:                                        ; preds = %idx.ok193
  %arr.data203 = getelementptr i8, ptr %data197, i64 8
  %arr.elem204 = getelementptr inbounds ptr, ptr %arr.data203, i64 %126
  %elem205 = load ptr, ptr %arr.elem204, align 8
  %Node.copy206 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %127 = call ptr @memcpy(ptr %Node.copy206, ptr %elem205, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %128 = getelementptr inbounds %class.Node, ptr %elem205, i32 0, i32 2
  %129 = load ptr, ptr %128, align 8, !tbaa !0
  %"ArrayList$Node.copy207" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %130 = call ptr @memcpy(ptr %"ArrayList$Node.copy207", ptr %129, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %131 = getelementptr inbounds %"class.ArrayList$Node", ptr %129, i32 0, i32 1
  %132 = load ptr, ptr %131, align 8, !tbaa !0
  %arr.len208 = load i64, ptr %132, align 8
  %133 = mul i64 %arr.len208, 8
  %134 = add i64 8, %133
  %arr.copy209 = call ptr @__polaron_malloc(i64 %134)
  %135 = call ptr @memcpy(ptr %arr.copy209, ptr %132, i64 %134)
  br label %arrdup.head210

arrdup.head210:                                   ; preds = %arrdup.cont213, %idx.ok202
  %i215 = phi i64 [ 0, %idx.ok202 ], [ %142, %arrdup.cont213 ]
  %136 = icmp slt i64 %i215, %arr.len208
  br i1 %136, label %arrdup.body211, label %arrdup.done214

arrdup.body211:                                   ; preds = %arrdup.head210
  %137 = mul i64 %i215, 8
  %138 = add i64 8, %137
  %139 = getelementptr i8, ptr %arr.copy209, i64 %138
  %elem216 = load ptr, ptr %139, align 8
  %140 = icmp eq ptr %elem216, null
  br i1 %140, label %arrdup.cont213, label %arrdup.copy212

arrdup.copy212:                                   ; preds = %arrdup.body211
  %Node.copy217 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %141 = call ptr @memcpy(ptr %Node.copy217, ptr %elem216, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy217, ptr %139, align 8
  br label %arrdup.cont213

arrdup.cont213:                                   ; preds = %arrdup.copy212, %arrdup.body211
  %142 = add i64 %i215, 1
  br label %arrdup.head210

arrdup.done214:                                   ; preds = %arrdup.head210
  %143 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy207", i32 0, i32 1
  store ptr %arr.copy209, ptr %143, align 8, !tbaa !0
  %144 = getelementptr inbounds %class.Node, ptr %Node.copy206, i32 0, i32 2
  store ptr %"ArrayList$Node.copy207", ptr %144, align 8, !tbaa !0
  store ptr %Node.copy206, ptr %arr.elem195, align 8
  %i218 = load i32, ptr %i148, align 4
  %145 = add i32 %i218, 1
  store i32 %145, ptr %i148, align 4
  br label %if.end187

idx.bad223:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1613, ptr @.faila.1614, i64 %124, ptr @.failb.1615, i64 %arr.len221, i32 70)
  unreachable

idx.ok224:                                        ; preds = %if.else
  %arr.data225 = getelementptr i8, ptr %tmp219, i64 8
  %arr.elem226 = getelementptr inbounds ptr, ptr %arr.data225, i64 %124
  %data227 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data228 = load ptr, ptr %data227, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j229 = load i32, ptr %j, align 4
  %146 = sext i32 %j229 to i64
  %arr.len230 = load i64, ptr %data228, align 8
  %arr.oob231 = icmp uge i64 %146, %arr.len230
  br i1 %arr.oob231, label %idx.bad232, label %idx.ok233, !prof !8

idx.bad232:                                       ; preds = %idx.ok224
  call void @__polaron_fail(ptr @.fail.1616, ptr @.faila.1617, i64 %146, ptr @.failb.1618, i64 %arr.len230, i32 70)
  unreachable

idx.ok233:                                        ; preds = %idx.ok224
  %arr.data234 = getelementptr i8, ptr %data228, i64 8
  %arr.elem235 = getelementptr inbounds ptr, ptr %arr.data234, i64 %146
  %elem236 = load ptr, ptr %arr.elem235, align 8
  %Node.copy237 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %147 = call ptr @memcpy(ptr %Node.copy237, ptr %elem236, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %148 = getelementptr inbounds %class.Node, ptr %elem236, i32 0, i32 2
  %149 = load ptr, ptr %148, align 8, !tbaa !0
  %"ArrayList$Node.copy238" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %150 = call ptr @memcpy(ptr %"ArrayList$Node.copy238", ptr %149, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %151 = getelementptr inbounds %"class.ArrayList$Node", ptr %149, i32 0, i32 1
  %152 = load ptr, ptr %151, align 8, !tbaa !0
  %arr.len239 = load i64, ptr %152, align 8
  %153 = mul i64 %arr.len239, 8
  %154 = add i64 8, %153
  %arr.copy240 = call ptr @__polaron_malloc(i64 %154)
  %155 = call ptr @memcpy(ptr %arr.copy240, ptr %152, i64 %154)
  br label %arrdup.head241

arrdup.head241:                                   ; preds = %arrdup.cont244, %idx.ok233
  %i246 = phi i64 [ 0, %idx.ok233 ], [ %162, %arrdup.cont244 ]
  %156 = icmp slt i64 %i246, %arr.len239
  br i1 %156, label %arrdup.body242, label %arrdup.done245

arrdup.body242:                                   ; preds = %arrdup.head241
  %157 = mul i64 %i246, 8
  %158 = add i64 8, %157
  %159 = getelementptr i8, ptr %arr.copy240, i64 %158
  %elem247 = load ptr, ptr %159, align 8
  %160 = icmp eq ptr %elem247, null
  br i1 %160, label %arrdup.cont244, label %arrdup.copy243

arrdup.copy243:                                   ; preds = %arrdup.body242
  %Node.copy248 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %161 = call ptr @memcpy(ptr %Node.copy248, ptr %elem247, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy248, ptr %159, align 8
  br label %arrdup.cont244

arrdup.cont244:                                   ; preds = %arrdup.copy243, %arrdup.body242
  %162 = add i64 %i246, 1
  br label %arrdup.head241

arrdup.done245:                                   ; preds = %arrdup.head241
  %163 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy238", i32 0, i32 1
  store ptr %arr.copy240, ptr %163, align 8, !tbaa !0
  %164 = getelementptr inbounds %class.Node, ptr %Node.copy237, i32 0, i32 2
  store ptr %"ArrayList$Node.copy238", ptr %164, align 8, !tbaa !0
  store ptr %Node.copy237, ptr %arr.elem226, align 8
  %j249 = load i32, ptr %j, align 4
  %165 = add i32 %j249, 1
  store i32 %165, ptr %j, align 4
  br label %if.end187

while.cond251:                                    ; preds = %arrdup.done282, %while.end153
  %i254 = load i32, ptr %i148, align 4
  %mid255 = load i32, ptr %mid, align 4
  %166 = icmp sle i32 %i254, %mid255
  %167 = zext i1 %166 to i32
  br i1 %166, label %while.body252, label %while.end253

while.body252:                                    ; preds = %while.cond251
  %tmp256 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k257 = load i32, ptr %k, align 4
  %168 = sext i32 %k257 to i64
  %arr.len258 = load i64, ptr %tmp256, align 8
  %arr.oob259 = icmp uge i64 %168, %arr.len258
  br i1 %arr.oob259, label %idx.bad260, label %idx.ok261, !prof !8

while.end253:                                     ; preds = %while.cond251
  br label %while.cond288

idx.bad260:                                       ; preds = %while.body252
  call void @__polaron_fail(ptr @.fail.1619, ptr @.faila.1620, i64 %168, ptr @.failb.1621, i64 %arr.len258, i32 70)
  unreachable

idx.ok261:                                        ; preds = %while.body252
  %arr.data262 = getelementptr i8, ptr %tmp256, i64 8
  %arr.elem263 = getelementptr inbounds ptr, ptr %arr.data262, i64 %168
  %data264 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data265 = load ptr, ptr %data264, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i266 = load i32, ptr %i148, align 4
  %169 = sext i32 %i266 to i64
  %arr.len267 = load i64, ptr %data265, align 8
  %arr.oob268 = icmp uge i64 %169, %arr.len267
  br i1 %arr.oob268, label %idx.bad269, label %idx.ok270, !prof !8

idx.bad269:                                       ; preds = %idx.ok261
  call void @__polaron_fail(ptr @.fail.1622, ptr @.faila.1623, i64 %169, ptr @.failb.1624, i64 %arr.len267, i32 70)
  unreachable

idx.ok270:                                        ; preds = %idx.ok261
  %arr.data271 = getelementptr i8, ptr %data265, i64 8
  %arr.elem272 = getelementptr inbounds ptr, ptr %arr.data271, i64 %169
  %elem273 = load ptr, ptr %arr.elem272, align 8
  %Node.copy274 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %170 = call ptr @memcpy(ptr %Node.copy274, ptr %elem273, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %171 = getelementptr inbounds %class.Node, ptr %elem273, i32 0, i32 2
  %172 = load ptr, ptr %171, align 8, !tbaa !0
  %"ArrayList$Node.copy275" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %173 = call ptr @memcpy(ptr %"ArrayList$Node.copy275", ptr %172, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %174 = getelementptr inbounds %"class.ArrayList$Node", ptr %172, i32 0, i32 1
  %175 = load ptr, ptr %174, align 8, !tbaa !0
  %arr.len276 = load i64, ptr %175, align 8
  %176 = mul i64 %arr.len276, 8
  %177 = add i64 8, %176
  %arr.copy277 = call ptr @__polaron_malloc(i64 %177)
  %178 = call ptr @memcpy(ptr %arr.copy277, ptr %175, i64 %177)
  br label %arrdup.head278

arrdup.head278:                                   ; preds = %arrdup.cont281, %idx.ok270
  %i283 = phi i64 [ 0, %idx.ok270 ], [ %185, %arrdup.cont281 ]
  %179 = icmp slt i64 %i283, %arr.len276
  br i1 %179, label %arrdup.body279, label %arrdup.done282

arrdup.body279:                                   ; preds = %arrdup.head278
  %180 = mul i64 %i283, 8
  %181 = add i64 8, %180
  %182 = getelementptr i8, ptr %arr.copy277, i64 %181
  %elem284 = load ptr, ptr %182, align 8
  %183 = icmp eq ptr %elem284, null
  br i1 %183, label %arrdup.cont281, label %arrdup.copy280

arrdup.copy280:                                   ; preds = %arrdup.body279
  %Node.copy285 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %184 = call ptr @memcpy(ptr %Node.copy285, ptr %elem284, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy285, ptr %182, align 8
  br label %arrdup.cont281

arrdup.cont281:                                   ; preds = %arrdup.copy280, %arrdup.body279
  %185 = add i64 %i283, 1
  br label %arrdup.head278

arrdup.done282:                                   ; preds = %arrdup.head278
  %186 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy275", i32 0, i32 1
  store ptr %arr.copy277, ptr %186, align 8, !tbaa !0
  %187 = getelementptr inbounds %class.Node, ptr %Node.copy274, i32 0, i32 2
  store ptr %"ArrayList$Node.copy275", ptr %187, align 8, !tbaa !0
  store ptr %Node.copy274, ptr %arr.elem263, align 8
  %i286 = load i32, ptr %i148, align 4
  %188 = add i32 %i286, 1
  store i32 %188, ptr %i148, align 4
  %k287 = load i32, ptr %k, align 4
  %189 = add i32 %k287, 1
  store i32 %189, ptr %k, align 4
  br label %while.cond251

while.cond288:                                    ; preds = %arrdup.done319, %while.end253
  %j291 = load i32, ptr %j, align 4
  %hi292 = load i32, ptr %hi, align 4
  %190 = icmp sle i32 %j291, %hi292
  %191 = zext i1 %190 to i32
  br i1 %190, label %while.body289, label %while.end290

while.body289:                                    ; preds = %while.cond288
  %tmp293 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k294 = load i32, ptr %k, align 4
  %192 = sext i32 %k294 to i64
  %arr.len295 = load i64, ptr %tmp293, align 8
  %arr.oob296 = icmp uge i64 %192, %arr.len295
  br i1 %arr.oob296, label %idx.bad297, label %idx.ok298, !prof !8

while.end290:                                     ; preds = %while.cond288
  %lo325 = load i32, ptr %lo, align 4
  store i32 %lo325, ptr %t, align 4
  br label %for.cond326

idx.bad297:                                       ; preds = %while.body289
  call void @__polaron_fail(ptr @.fail.1625, ptr @.faila.1626, i64 %192, ptr @.failb.1627, i64 %arr.len295, i32 70)
  unreachable

idx.ok298:                                        ; preds = %while.body289
  %arr.data299 = getelementptr i8, ptr %tmp293, i64 8
  %arr.elem300 = getelementptr inbounds ptr, ptr %arr.data299, i64 %192
  %data301 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data302 = load ptr, ptr %data301, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j303 = load i32, ptr %j, align 4
  %193 = sext i32 %j303 to i64
  %arr.len304 = load i64, ptr %data302, align 8
  %arr.oob305 = icmp uge i64 %193, %arr.len304
  br i1 %arr.oob305, label %idx.bad306, label %idx.ok307, !prof !8

idx.bad306:                                       ; preds = %idx.ok298
  call void @__polaron_fail(ptr @.fail.1628, ptr @.faila.1629, i64 %193, ptr @.failb.1630, i64 %arr.len304, i32 70)
  unreachable

idx.ok307:                                        ; preds = %idx.ok298
  %arr.data308 = getelementptr i8, ptr %data302, i64 8
  %arr.elem309 = getelementptr inbounds ptr, ptr %arr.data308, i64 %193
  %elem310 = load ptr, ptr %arr.elem309, align 8
  %Node.copy311 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %194 = call ptr @memcpy(ptr %Node.copy311, ptr %elem310, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %195 = getelementptr inbounds %class.Node, ptr %elem310, i32 0, i32 2
  %196 = load ptr, ptr %195, align 8, !tbaa !0
  %"ArrayList$Node.copy312" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %197 = call ptr @memcpy(ptr %"ArrayList$Node.copy312", ptr %196, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %198 = getelementptr inbounds %"class.ArrayList$Node", ptr %196, i32 0, i32 1
  %199 = load ptr, ptr %198, align 8, !tbaa !0
  %arr.len313 = load i64, ptr %199, align 8
  %200 = mul i64 %arr.len313, 8
  %201 = add i64 8, %200
  %arr.copy314 = call ptr @__polaron_malloc(i64 %201)
  %202 = call ptr @memcpy(ptr %arr.copy314, ptr %199, i64 %201)
  br label %arrdup.head315

arrdup.head315:                                   ; preds = %arrdup.cont318, %idx.ok307
  %i320 = phi i64 [ 0, %idx.ok307 ], [ %209, %arrdup.cont318 ]
  %203 = icmp slt i64 %i320, %arr.len313
  br i1 %203, label %arrdup.body316, label %arrdup.done319

arrdup.body316:                                   ; preds = %arrdup.head315
  %204 = mul i64 %i320, 8
  %205 = add i64 8, %204
  %206 = getelementptr i8, ptr %arr.copy314, i64 %205
  %elem321 = load ptr, ptr %206, align 8
  %207 = icmp eq ptr %elem321, null
  br i1 %207, label %arrdup.cont318, label %arrdup.copy317

arrdup.copy317:                                   ; preds = %arrdup.body316
  %Node.copy322 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %208 = call ptr @memcpy(ptr %Node.copy322, ptr %elem321, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy322, ptr %206, align 8
  br label %arrdup.cont318

arrdup.cont318:                                   ; preds = %arrdup.copy317, %arrdup.body316
  %209 = add i64 %i320, 1
  br label %arrdup.head315

arrdup.done319:                                   ; preds = %arrdup.head315
  %210 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy312", i32 0, i32 1
  store ptr %arr.copy314, ptr %210, align 8, !tbaa !0
  %211 = getelementptr inbounds %class.Node, ptr %Node.copy311, i32 0, i32 2
  store ptr %"ArrayList$Node.copy312", ptr %211, align 8, !tbaa !0
  store ptr %Node.copy311, ptr %arr.elem300, align 8
  %j323 = load i32, ptr %j, align 4
  %212 = add i32 %j323, 1
  store i32 %212, ptr %j, align 4
  %k324 = load i32, ptr %k, align 4
  %213 = add i32 %k324, 1
  store i32 %213, ptr %k, align 4
  br label %while.cond288

for.cond326:                                      ; preds = %for.update328, %while.end290
  %t330 = load i32, ptr %t, align 4
  %hi331 = load i32, ptr %hi, align 4
  %214 = icmp sle i32 %t330, %hi331
  %215 = zext i1 %214 to i32
  br i1 %214, label %for.body327, label %for.end329

for.body327:                                      ; preds = %for.cond326
  %data332 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data333 = load ptr, ptr %data332, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %t334 = load i32, ptr %t, align 4
  %216 = sext i32 %t334 to i64
  %arr.len335 = load i64, ptr %data333, align 8
  %arr.oob336 = icmp uge i64 %216, %arr.len335
  br i1 %arr.oob336, label %idx.bad337, label %idx.ok338, !prof !8

for.update328:                                    ; preds = %arrdup.done358
  %t362 = load i32, ptr %t, align 4
  %217 = add i32 %t362, 1
  store i32 %217, ptr %t, align 4
  br label %for.cond326

for.end329:                                       ; preds = %for.cond326
  %count363 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count364 = load i32, ptr %count363, align 4, !tbaa !4
  %data365 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data366 = load ptr, ptr %data365, align 8, !tbaa !0
  %len367 = load i64, ptr %data366, align 8
  %218 = trunc i64 %len367 to i32
  %219 = icmp sle i32 %count364, %218
  %220 = zext i1 %219 to i32
  %contract.ok368 = icmp ne i32 %220, 0
  br i1 %contract.ok368, label %contract.cont370, label %contract.fail369

idx.bad337:                                       ; preds = %for.body327
  call void @__polaron_fail(ptr @.fail.1631, ptr @.faila.1632, i64 %216, ptr @.failb.1633, i64 %arr.len335, i32 70)
  unreachable

idx.ok338:                                        ; preds = %for.body327
  %arr.data339 = getelementptr i8, ptr %data333, i64 8
  %arr.elem340 = getelementptr inbounds ptr, ptr %arr.data339, i64 %216
  %tmp341 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %t342 = load i32, ptr %t, align 4
  %221 = sext i32 %t342 to i64
  %arr.len343 = load i64, ptr %tmp341, align 8
  %arr.oob344 = icmp uge i64 %221, %arr.len343
  br i1 %arr.oob344, label %idx.bad345, label %idx.ok346, !prof !8

idx.bad345:                                       ; preds = %idx.ok338
  call void @__polaron_fail(ptr @.fail.1634, ptr @.faila.1635, i64 %221, ptr @.failb.1636, i64 %arr.len343, i32 70)
  unreachable

idx.ok346:                                        ; preds = %idx.ok338
  %arr.data347 = getelementptr i8, ptr %tmp341, i64 8
  %arr.elem348 = getelementptr inbounds ptr, ptr %arr.data347, i64 %221
  %elem349 = load ptr, ptr %arr.elem348, align 8
  %Node.copy350 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %222 = call ptr @memcpy(ptr %Node.copy350, ptr %elem349, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %223 = getelementptr inbounds %class.Node, ptr %elem349, i32 0, i32 2
  %224 = load ptr, ptr %223, align 8, !tbaa !0
  %"ArrayList$Node.copy351" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %225 = call ptr @memcpy(ptr %"ArrayList$Node.copy351", ptr %224, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %226 = getelementptr inbounds %"class.ArrayList$Node", ptr %224, i32 0, i32 1
  %227 = load ptr, ptr %226, align 8, !tbaa !0
  %arr.len352 = load i64, ptr %227, align 8
  %228 = mul i64 %arr.len352, 8
  %229 = add i64 8, %228
  %arr.copy353 = call ptr @__polaron_malloc(i64 %229)
  %230 = call ptr @memcpy(ptr %arr.copy353, ptr %227, i64 %229)
  br label %arrdup.head354

arrdup.head354:                                   ; preds = %arrdup.cont357, %idx.ok346
  %i359 = phi i64 [ 0, %idx.ok346 ], [ %237, %arrdup.cont357 ]
  %231 = icmp slt i64 %i359, %arr.len352
  br i1 %231, label %arrdup.body355, label %arrdup.done358

arrdup.body355:                                   ; preds = %arrdup.head354
  %232 = mul i64 %i359, 8
  %233 = add i64 8, %232
  %234 = getelementptr i8, ptr %arr.copy353, i64 %233
  %elem360 = load ptr, ptr %234, align 8
  %235 = icmp eq ptr %elem360, null
  br i1 %235, label %arrdup.cont357, label %arrdup.copy356

arrdup.copy356:                                   ; preds = %arrdup.body355
  %Node.copy361 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %236 = call ptr @memcpy(ptr %Node.copy361, ptr %elem360, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy361, ptr %234, align 8
  br label %arrdup.cont357

arrdup.cont357:                                   ; preds = %arrdup.copy356, %arrdup.body355
  %237 = add i64 %i359, 1
  br label %arrdup.head354

arrdup.done358:                                   ; preds = %arrdup.head354
  %238 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy351", i32 0, i32 1
  store ptr %arr.copy353, ptr %238, align 8, !tbaa !0
  %239 = getelementptr inbounds %class.Node, ptr %Node.copy350, i32 0, i32 2
  store ptr %"ArrayList$Node.copy351", ptr %239, align 8, !tbaa !0
  store ptr %Node.copy350, ptr %arr.elem340, align 8
  br label %for.update328

contract.fail369:                                 ; preds = %for.end329
  call void @__polaron_fail(ptr @.contract.1637, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont370:                                 ; preds = %for.end329
  ret void
}

define internal %__polaron_variant @"ArrayList$Node.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1638, ptr @.faila.1639, i64 %10, ptr @.failb.1640, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1641, ptr @.faila.1642, i64 %15, ptr @.failb.1643, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %15
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %var.enc.p = ptrtoint ptr %elem22 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$Node.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i13 = alloca i32, align 4
  %best = alloca ptr, align 8
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1644, ptr @.faila.1645, i64 0, ptr @.failb.1646, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %9 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %12 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %11, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %13 = getelementptr inbounds %"class.ArrayList$Node", ptr %11, i32 0, i32 1
  %14 = load ptr, ptr %13, align 8, !tbaa !0
  %arr.len10 = load i64, ptr %14, align 8
  %15 = mul i64 %arr.len10, 8
  %16 = add i64 8, %15
  %arr.copy = call ptr @__polaron_malloc(i64 %16)
  %17 = call ptr @memcpy(ptr %arr.copy, ptr %14, i64 %16)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok
  %i = phi i64 [ 0, %idx.ok ], [ %24, %arrdup.cont ]
  %18 = icmp slt i64 %i, %arr.len10
  br i1 %18, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %19 = mul i64 %i, 8
  %20 = add i64 8, %19
  %21 = getelementptr i8, ptr %arr.copy, i64 %20
  %elem11 = load ptr, ptr %21, align 8
  %22 = icmp eq ptr %elem11, null
  br i1 %22, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %23 = call ptr @memcpy(ptr %Node.copy12, ptr %elem11, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy12, ptr %21, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %24 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %25 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %25, align 8, !tbaa !0
  %26 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %26, align 8, !tbaa !0
  store ptr %Node.copy, ptr %best, align 8
  store i32 1, ptr %i13, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %arrdup.done
  %i14 = load i32, ptr %i13, align 4
  %count15 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %27 = icmp slt i32 %i14, %count16
  %28 = zext i1 %27 to i32
  br i1 %27, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare17 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare17, align 8
  %29 = getelementptr ptr, ptr %compare17, i32 1
  %env = load ptr, ptr %29, align 8
  %data18 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i13, align 4
  %30 = sext i32 %i20 to i64
  %arr.len21 = load i64, ptr %data19, align 8
  %arr.oob22 = icmp uge i64 %30, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

for.update:                                       ; preds = %if.end30
  %31 = load i32, ptr %i13, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %i13, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best53 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best53 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad23:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1647, ptr @.faila.1648, i64 %30, ptr @.failb.1649, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %for.body
  %arr.data25 = getelementptr i8, ptr %data19, i64 8
  %arr.elem26 = getelementptr inbounds ptr, ptr %arr.data25, i64 %30
  %elem27 = load ptr, ptr %arr.elem26, align 8
  %best28 = load ptr, ptr %best, align 8
  %33 = call i32 %code(ptr %env, ptr %elem27, ptr %best28)
  %34 = icmp slt i32 %33, 0
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then29, label %if.end30

if.then29:                                        ; preds = %idx.ok24
  %data31 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i33 = load i32, ptr %i13, align 4
  %36 = sext i32 %i33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %36, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

if.end30:                                         ; preds = %vcopy.done, %idx.ok24
  br label %for.update

idx.bad36:                                        ; preds = %if.then29
  call void @__polaron_fail(ptr @.fail.1650, ptr @.faila.1651, i64 %36, ptr @.failb.1652, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %if.then29
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %36
  %elem40 = load ptr, ptr %arr.elem39, align 8
  %37 = load ptr, ptr %best, align 8
  %38 = icmp eq ptr %elem40, %37
  br i1 %38, label %vcopy.done, label %vcopy

vcopy:                                            ; preds = %idx.ok37
  %39 = getelementptr inbounds %class.Node, ptr %37, i32 0, i32 1
  %40 = getelementptr inbounds %class.Node, ptr %37, i32 0, i32 2
  %41 = load ptr, ptr %40, align 8, !tbaa !0
  %42 = icmp eq ptr %41, null
  br i1 %42, label %freefld.cont, label %freefld

vcopy.done:                                       ; preds = %arrdup.done48, %idx.ok37
  br label %if.end30

freefld:                                          ; preds = %vcopy
  %43 = getelementptr inbounds %"class.ArrayList$Node", ptr %41, i32 0, i32 1
  %44 = load ptr, ptr %43, align 8, !tbaa !0
  call void @__polaron_free(ptr %44)
  %45 = getelementptr inbounds %"class.ArrayList$Node", ptr %41, i32 0, i32 2
  call void @__polaron_free(ptr %41)
  br label %freefld.cont

freefld.cont:                                     ; preds = %freefld, %vcopy
  %46 = call ptr @memcpy(ptr %37, ptr %elem40, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %47 = getelementptr inbounds %class.Node, ptr %elem40, i32 0, i32 2
  %48 = load ptr, ptr %47, align 8, !tbaa !0
  %"ArrayList$Node.copy41" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %49 = call ptr @memcpy(ptr %"ArrayList$Node.copy41", ptr %48, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %50 = getelementptr inbounds %"class.ArrayList$Node", ptr %48, i32 0, i32 1
  %51 = load ptr, ptr %50, align 8, !tbaa !0
  %arr.len42 = load i64, ptr %51, align 8
  %52 = mul i64 %arr.len42, 8
  %53 = add i64 8, %52
  %arr.copy43 = call ptr @__polaron_malloc(i64 %53)
  %54 = call ptr @memcpy(ptr %arr.copy43, ptr %51, i64 %53)
  br label %arrdup.head44

arrdup.head44:                                    ; preds = %arrdup.cont47, %freefld.cont
  %i49 = phi i64 [ 0, %freefld.cont ], [ %65, %arrdup.cont47 ]
  %55 = icmp slt i64 %i49, %arr.len42
  br i1 %55, label %arrdup.body45, label %arrdup.done48

arrdup.body45:                                    ; preds = %arrdup.head44
  %56 = mul i64 %i49, 8
  %57 = add i64 8, %56
  %58 = getelementptr i8, ptr %arr.copy43, i64 %57
  %elem50 = load ptr, ptr %58, align 8
  %59 = icmp eq ptr %elem50, null
  br i1 %59, label %arrdup.cont47, label %arrdup.copy46

arrdup.copy46:                                    ; preds = %arrdup.body45
  %Node.copy51 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %60 = call ptr @memcpy(ptr %Node.copy51, ptr %elem50, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %61 = getelementptr inbounds %class.Node, ptr %elem50, i32 0, i32 2
  %62 = load ptr, ptr %61, align 8, !tbaa !0
  %"ArrayList$Node.copy52" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %63 = call ptr @memcpy(ptr %"ArrayList$Node.copy52", ptr %62, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %64 = getelementptr inbounds %class.Node, ptr %Node.copy51, i32 0, i32 2
  store ptr %"ArrayList$Node.copy52", ptr %64, align 8, !tbaa !0
  store ptr %Node.copy51, ptr %58, align 8
  br label %arrdup.cont47

arrdup.cont47:                                    ; preds = %arrdup.copy46, %arrdup.body45
  %65 = add i64 %i49, 1
  br label %arrdup.head44

arrdup.done48:                                    ; preds = %arrdup.head44
  %66 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy41", i32 0, i32 1
  store ptr %arr.copy43, ptr %66, align 8, !tbaa !0
  %67 = getelementptr inbounds %class.Node, ptr %37, i32 0, i32 2
  store ptr %"ArrayList$Node.copy41", ptr %67, align 8, !tbaa !0
  br label %vcopy.done
}

define internal %__polaron_variant @"ArrayList$Node.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i13 = alloca i32, align 4
  %best = alloca ptr, align 8
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %Node.copy = alloca %class.Node, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1653, ptr @.faila.1654, i64 0, ptr @.failb.1655, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %9 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %12 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %11, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %13 = getelementptr inbounds %"class.ArrayList$Node", ptr %11, i32 0, i32 1
  %14 = load ptr, ptr %13, align 8, !tbaa !0
  %arr.len10 = load i64, ptr %14, align 8
  %15 = mul i64 %arr.len10, 8
  %16 = add i64 8, %15
  %arr.copy = call ptr @__polaron_malloc(i64 %16)
  %17 = call ptr @memcpy(ptr %arr.copy, ptr %14, i64 %16)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %idx.ok
  %i = phi i64 [ 0, %idx.ok ], [ %24, %arrdup.cont ]
  %18 = icmp slt i64 %i, %arr.len10
  br i1 %18, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %19 = mul i64 %i, 8
  %20 = add i64 8, %19
  %21 = getelementptr i8, ptr %arr.copy, i64 %20
  %elem11 = load ptr, ptr %21, align 8
  %22 = icmp eq ptr %elem11, null
  br i1 %22, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Node.copy12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %23 = call ptr @memcpy(ptr %Node.copy12, ptr %elem11, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  store ptr %Node.copy12, ptr %21, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %24 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %25 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %25, align 8, !tbaa !0
  %26 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy", ptr %26, align 8, !tbaa !0
  store ptr %Node.copy, ptr %best, align 8
  store i32 1, ptr %i13, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %arrdup.done
  %i14 = load i32, ptr %i13, align 4
  %count15 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %27 = icmp slt i32 %i14, %count16
  %28 = zext i1 %27 to i32
  br i1 %27, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare17 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare17, align 8
  %29 = getelementptr ptr, ptr %compare17, i32 1
  %env = load ptr, ptr %29, align 8
  %data18 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i13, align 4
  %30 = sext i32 %i20 to i64
  %arr.len21 = load i64, ptr %data19, align 8
  %arr.oob22 = icmp uge i64 %30, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

for.update:                                       ; preds = %if.end30
  %31 = load i32, ptr %i13, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %i13, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best53 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best53 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad23:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1656, ptr @.faila.1657, i64 %30, ptr @.failb.1658, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %for.body
  %arr.data25 = getelementptr i8, ptr %data19, i64 8
  %arr.elem26 = getelementptr inbounds ptr, ptr %arr.data25, i64 %30
  %elem27 = load ptr, ptr %arr.elem26, align 8
  %best28 = load ptr, ptr %best, align 8
  %33 = call i32 %code(ptr %env, ptr %elem27, ptr %best28)
  %34 = icmp sgt i32 %33, 0
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then29, label %if.end30

if.then29:                                        ; preds = %idx.ok24
  %data31 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i33 = load i32, ptr %i13, align 4
  %36 = sext i32 %i33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %36, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

if.end30:                                         ; preds = %vcopy.done, %idx.ok24
  br label %for.update

idx.bad36:                                        ; preds = %if.then29
  call void @__polaron_fail(ptr @.fail.1659, ptr @.faila.1660, i64 %36, ptr @.failb.1661, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %if.then29
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %36
  %elem40 = load ptr, ptr %arr.elem39, align 8
  %37 = load ptr, ptr %best, align 8
  %38 = icmp eq ptr %elem40, %37
  br i1 %38, label %vcopy.done, label %vcopy

vcopy:                                            ; preds = %idx.ok37
  %39 = getelementptr inbounds %class.Node, ptr %37, i32 0, i32 1
  %40 = getelementptr inbounds %class.Node, ptr %37, i32 0, i32 2
  %41 = load ptr, ptr %40, align 8, !tbaa !0
  %42 = icmp eq ptr %41, null
  br i1 %42, label %freefld.cont, label %freefld

vcopy.done:                                       ; preds = %arrdup.done48, %idx.ok37
  br label %if.end30

freefld:                                          ; preds = %vcopy
  %43 = getelementptr inbounds %"class.ArrayList$Node", ptr %41, i32 0, i32 1
  %44 = load ptr, ptr %43, align 8, !tbaa !0
  call void @__polaron_free(ptr %44)
  %45 = getelementptr inbounds %"class.ArrayList$Node", ptr %41, i32 0, i32 2
  call void @__polaron_free(ptr %41)
  br label %freefld.cont

freefld.cont:                                     ; preds = %freefld, %vcopy
  %46 = call ptr @memcpy(ptr %37, ptr %elem40, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %47 = getelementptr inbounds %class.Node, ptr %elem40, i32 0, i32 2
  %48 = load ptr, ptr %47, align 8, !tbaa !0
  %"ArrayList$Node.copy41" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %49 = call ptr @memcpy(ptr %"ArrayList$Node.copy41", ptr %48, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %50 = getelementptr inbounds %"class.ArrayList$Node", ptr %48, i32 0, i32 1
  %51 = load ptr, ptr %50, align 8, !tbaa !0
  %arr.len42 = load i64, ptr %51, align 8
  %52 = mul i64 %arr.len42, 8
  %53 = add i64 8, %52
  %arr.copy43 = call ptr @__polaron_malloc(i64 %53)
  %54 = call ptr @memcpy(ptr %arr.copy43, ptr %51, i64 %53)
  br label %arrdup.head44

arrdup.head44:                                    ; preds = %arrdup.cont47, %freefld.cont
  %i49 = phi i64 [ 0, %freefld.cont ], [ %65, %arrdup.cont47 ]
  %55 = icmp slt i64 %i49, %arr.len42
  br i1 %55, label %arrdup.body45, label %arrdup.done48

arrdup.body45:                                    ; preds = %arrdup.head44
  %56 = mul i64 %i49, 8
  %57 = add i64 8, %56
  %58 = getelementptr i8, ptr %arr.copy43, i64 %57
  %elem50 = load ptr, ptr %58, align 8
  %59 = icmp eq ptr %elem50, null
  br i1 %59, label %arrdup.cont47, label %arrdup.copy46

arrdup.copy46:                                    ; preds = %arrdup.body45
  %Node.copy51 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %60 = call ptr @memcpy(ptr %Node.copy51, ptr %elem50, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %61 = getelementptr inbounds %class.Node, ptr %elem50, i32 0, i32 2
  %62 = load ptr, ptr %61, align 8, !tbaa !0
  %"ArrayList$Node.copy52" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %63 = call ptr @memcpy(ptr %"ArrayList$Node.copy52", ptr %62, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %64 = getelementptr inbounds %class.Node, ptr %Node.copy51, i32 0, i32 2
  store ptr %"ArrayList$Node.copy52", ptr %64, align 8, !tbaa !0
  store ptr %Node.copy51, ptr %58, align 8
  br label %arrdup.cont47

arrdup.cont47:                                    ; preds = %arrdup.copy46, %arrdup.body45
  %65 = add i64 %i49, 1
  br label %arrdup.head44

arrdup.done48:                                    ; preds = %arrdup.head44
  %66 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy41", i32 0, i32 1
  store ptr %arr.copy43, ptr %66, align 8, !tbaa !0
  %67 = getelementptr inbounds %class.Node, ptr %37, i32 0, i32 2
  store ptr %"ArrayList$Node.copy41", ptr %67, align 8, !tbaa !0
  br label %vcopy.done
}

define internal ptr @"ArrayList$Node.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Node", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$Node.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$Node", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$Node.ArrayListIterator$Node"(ptr %"ArrayListIterator$Node.obj", ptr %0)
  ret ptr %"ArrayListIterator$Node.obj"
}

define internal void @"ArrayListIterator$Node.ArrayListIterator$Node"(ptr %0, ptr %1) {
entry:
  %"ArrayList$Node.copy" = alloca %"class.ArrayList$Node", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$Node.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$Node", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %18, %arrdup.cont ]
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
  %Node.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %13 = call ptr @memcpy(ptr %Node.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %14 = getelementptr inbounds %class.Node, ptr %elem, i32 0, i32 2
  %15 = load ptr, ptr %14, align 8, !tbaa !0
  %"ArrayList$Node.copy1" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %"ArrayList$Node.copy1", ptr %15, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %class.Node, ptr %Node.copy, i32 0, i32 2
  store ptr %"ArrayList$Node.copy1", ptr %17, align 8, !tbaa !0
  store ptr %Node.copy, ptr %11, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %18 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %19 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %19, align 8, !tbaa !0
  store ptr %"ArrayList$Node.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$Node.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 1
  store ptr null, ptr %list2, align 8, !tbaa !0
  %list3 = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 1
  %list4 = load ptr, ptr %list, align 8
  %"ArrayList$Node.copy5" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %20 = call ptr @memcpy(ptr %"ArrayList$Node.copy5", ptr %list4, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %21 = getelementptr inbounds %"class.ArrayList$Node", ptr %list4, i32 0, i32 1
  %22 = load ptr, ptr %21, align 8, !tbaa !0
  %arr.len6 = load i64, ptr %22, align 8
  %23 = mul i64 %arr.len6, 8
  %24 = add i64 8, %23
  %arr.copy7 = call ptr @__polaron_malloc(i64 %24)
  %25 = call ptr @memcpy(ptr %arr.copy7, ptr %22, i64 %24)
  br label %arrdup.head8

arrdup.head8:                                     ; preds = %arrdup.cont11, %arrdup.done
  %i13 = phi i64 [ 0, %arrdup.done ], [ %36, %arrdup.cont11 ]
  %26 = icmp slt i64 %i13, %arr.len6
  br i1 %26, label %arrdup.body9, label %arrdup.done12

arrdup.body9:                                     ; preds = %arrdup.head8
  %27 = mul i64 %i13, 8
  %28 = add i64 8, %27
  %29 = getelementptr i8, ptr %arr.copy7, i64 %28
  %elem14 = load ptr, ptr %29, align 8
  %30 = icmp eq ptr %elem14, null
  br i1 %30, label %arrdup.cont11, label %arrdup.copy10

arrdup.copy10:                                    ; preds = %arrdup.body9
  %Node.copy15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %31 = call ptr @memcpy(ptr %Node.copy15, ptr %elem14, i64 ptrtoint (ptr getelementptr (%class.Node, ptr null, i64 1) to i64))
  %32 = getelementptr inbounds %class.Node, ptr %elem14, i32 0, i32 2
  %33 = load ptr, ptr %32, align 8, !tbaa !0
  %"ArrayList$Node.copy16" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %34 = call ptr @memcpy(ptr %"ArrayList$Node.copy16", ptr %33, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Node", ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %class.Node, ptr %Node.copy15, i32 0, i32 2
  store ptr %"ArrayList$Node.copy16", ptr %35, align 8, !tbaa !0
  store ptr %Node.copy15, ptr %29, align 8
  br label %arrdup.cont11

arrdup.cont11:                                    ; preds = %arrdup.copy10, %arrdup.body9
  %36 = add i64 %i13, 1
  br label %arrdup.head8

arrdup.done12:                                    ; preds = %arrdup.head8
  %37 = getelementptr inbounds %"class.ArrayList$Node", ptr %"ArrayList$Node.copy5", i32 0, i32 1
  store ptr %arr.copy7, ptr %37, align 8, !tbaa !0
  store ptr %"ArrayList$Node.copy5", ptr %list3, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$Node.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$Node.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$Node.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call ptr @"ArrayList$Node.get"(ptr %list1, i32 %pos2)
  store ptr %1, ptr %value, align 8
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$Node", ptr %0, i32 0, i32 2
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1671)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1673)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5672)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5674)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

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
