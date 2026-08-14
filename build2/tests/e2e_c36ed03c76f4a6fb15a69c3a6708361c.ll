; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_more.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_more.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.Multiset$String" = type { ptr, ptr }
%"class.RingBuffer$int" = type { ptr, ptr, i32, i32, i32 }
%"class.LinkedHashMap$String$int" = type { ptr, ptr, ptr }
%class.DivideByZeroException = type { ptr }
%"class.HashMap$String$int" = type { ptr, ptr, ptr, ptr, i32, i32 }
%"class.ArrayList$String" = type { ptr, ptr, i32 }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$String" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"RingBuffer$int.vtable" = private constant [352 x ptr] [ptr @"RingBuffer$int.push", ptr @"RingBuffer$int.pop", ptr @"RingBuffer$int.peek", ptr @"RingBuffer$int.size", ptr @"RingBuffer$int.isEmpty", ptr @"RingBuffer$int.isFull", ptr @"RingBuffer$int.capacity", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayListIterator$String.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$String.hasNext", ptr @"ArrayListIterator$String.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$String.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$String.size", ptr @"ArrayList$String.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.toArray", ptr @"ArrayList$String.add", ptr @"ArrayList$String.count", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.get", ptr null, ptr null, ptr null, ptr @"ArrayList$String.remove", ptr null, ptr null, ptr null, ptr @"ArrayList$String.ensureCapacity", ptr @"ArrayList$String.set", ptr @"ArrayList$String.indexOf", ptr @"ArrayList$String.contains", ptr @"ArrayList$String.removeAt", ptr @"ArrayList$String.insertAt", ptr @"ArrayList$String.clear", ptr @"ArrayList$String.forEach", ptr @"ArrayList$String.filter", ptr @"ArrayList$String.any", ptr @"ArrayList$String.all", ptr @"ArrayList$String.sortedBy", ptr @"ArrayList$String.mergeSortRange", ptr @"ArrayList$String.find", ptr @"ArrayList$String.min", ptr @"ArrayList$String.max", ptr @"ArrayList$String.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.~ArrayList$String"]
@"Multiset$String.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Multiset$String.add", ptr @"Multiset$String.count", ptr @"Multiset$String.distinct", ptr @"Multiset$String.total", ptr @"Multiset$String.keys", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"HashMap$String$int.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr @"HashMap$String$int.size", ptr @"HashMap$String$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$int.slotFor", ptr @"HashMap$String$int.grow", ptr @"HashMap$String$int.put", ptr @"HashMap$String$int.get", ptr @"HashMap$String$int.containsKey", ptr @"HashMap$String$int.getOrDefault", ptr @"HashMap$String$int.merge", ptr @"HashMap$String$int.remove", ptr @"HashMap$String$int.keyArray", ptr @"HashMap$String$int.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$int.~HashMap$String$int"]
@"LinkedHashMap$String$int.vtable" = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr @"LinkedHashMap$String$int.size", ptr @"LinkedHashMap$String$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"LinkedHashMap$String$int.put", ptr @"LinkedHashMap$String$int.get", ptr @"LinkedHashMap$String$int.containsKey", ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"LinkedHashMap$String$int.keysInOrder", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [2 x i8] c"x\00"
@.strobj = private global %String { i64 1, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c"x\00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c"y\00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [2 x i8] c"z\00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [2 x i8] c"a\00"
@.strobj.8 = private global %String { i64 1, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [2 x i8] c"z\00"
@.strobj.10 = private global %String { i64 1, ptr @.strdata.9, i64 0 }
@.str = private unnamed_addr constant [52 x i8] c"cx=%d ctotal=%d rbpeek=%d rbfull=%d lmk0=%s lmz=%d\0A\00", align 1
@.strdata.11 = private constant [2 x i8] c"x\00"
@.strobj.12 = private global %String { i64 1, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [2 x i8] c"z\00"
@.strobj.14 = private global %String { i64 1, ptr @.strdata.13, i64 0 }
@.contract = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:1621:34  in RingBuffer$int.RingBuffer$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.15 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:1622:34  in RingBuffer$int.RingBuffer$int\0A   |  invariant this.count <= this.cap;\0A\00", align 1
@.cl.16 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.17 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.18 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:1623:33  in RingBuffer$int.RingBuffer$int\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.19 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.20 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.21 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:1624:33  in RingBuffer$int.RingBuffer$int\0A   |  invariant this.head < this.cap;\0A\00", align 1
@.cl.22 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.23 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.24 = private unnamed_addr constant [135 x i8] c"contract violated: invariant\0A  --> <prelude>:1625:41  in RingBuffer$int.RingBuffer$int\0A   |  invariant this.buf.length() == this.cap;\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1638:32  in RingBuffer$int.push\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.25 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:1621:34  in RingBuffer$int.push\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.26 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.27 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.28 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:1622:34  in RingBuffer$int.push\0A   |  invariant this.count <= this.cap;\0A\00", align 1
@.cl.29 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.30 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.31 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:1623:33  in RingBuffer$int.push\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.32 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.33 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.34 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:1624:33  in RingBuffer$int.push\0A   |  invariant this.head < this.cap;\0A\00", align 1
@.cl.35 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.36 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.37 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:1625:41  in RingBuffer$int.push\0A   |  invariant this.buf.length() == this.cap;\0A\00", align 1
@.fail.38 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1644:17  in RingBuffer$int.pop\0A\00", align 1
@.faila.39 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.40 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.41 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:1621:34  in RingBuffer$int.pop\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.42 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.43 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.44 = private unnamed_addr constant [117 x i8] c"contract violated: invariant\0A  --> <prelude>:1622:34  in RingBuffer$int.pop\0A   |  invariant this.count <= this.cap;\0A\00", align 1
@.cl.45 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.46 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.47 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:1623:33  in RingBuffer$int.pop\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.48 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.49 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.50 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:1624:33  in RingBuffer$int.pop\0A   |  invariant this.head < this.cap;\0A\00", align 1
@.cl.51 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.52 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.fail.53 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1649:46  in RingBuffer$int.peek\0A\00", align 1
@.faila.54 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.55 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.101 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1611:74  in Multiset$String.total\0A\00", align 1
@.faila.102 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.103 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.104 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.105 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.106 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.107 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.108 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.109 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.110 = private unnamed_addr constant [143 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.111 = private unnamed_addr constant [145 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.112 = private unnamed_addr constant [143 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.113 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$String$int.slotFor\0A\00", align 1
@.faila.114 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.115 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.116 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$String$int.slotFor\0A\00", align 1
@.faila.117 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.118 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.119 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$String$int.grow\0A\00", align 1
@.faila.120 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.121 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.122 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$String$int.grow\0A\00", align 1
@.faila.123 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.124 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.125 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$String$int.grow\0A\00", align 1
@.faila.126 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.127 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.128 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$String$int.grow\0A\00", align 1
@.faila.129 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.130 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.131 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$int.grow\0A\00", align 1
@.faila.132 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.133 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.134 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$int.grow\0A\00", align 1
@.faila.135 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.136 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.137 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$int.grow\0A\00", align 1
@.faila.138 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.139 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.140 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$int.grow\0A\00", align 1
@.faila.141 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.142 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.143 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.144 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.145 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.146 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.147 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.148 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.149 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.150 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.151 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.152 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$String$int.put\0A\00", align 1
@.faila.153 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.154 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.155 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$String$int.put\0A\00", align 1
@.faila.156 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.157 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.158 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$String$int.put\0A\00", align 1
@.faila.159 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.160 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.161 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$String$int.put\0A\00", align 1
@.faila.162 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.163 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.164 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.165 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.166 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.167 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.168 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.169 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.170 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.171 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.172 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.173 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$String$int.get\0A\00", align 1
@.faila.174 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.175 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.176 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$String$int.containsKey\0A\00", align 1
@.faila.177 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.178 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.179 = private unnamed_addr constant [102 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$String$int.getOrDefault\0A\00", align 1
@.faila.180 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.181 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.182 = private unnamed_addr constant [102 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$String$int.getOrDefault\0A\00", align 1
@.faila.183 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.184 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.185 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$String$int.merge\0A\00", align 1
@.faila.186 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.187 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.188 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$String$int.merge\0A\00", align 1
@.faila.189 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.190 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.191 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$String$int.merge\0A\00", align 1
@.faila.192 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.193 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.194 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$String$int.merge\0A\00", align 1
@.faila.195 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.196 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.197 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$int.merge\0A\00", align 1
@.faila.198 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.199 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.200 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$int.merge\0A\00", align 1
@.faila.201 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.202 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.203 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.204 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.205 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.206 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.207 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.208 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.209 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.210 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.211 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.212 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$String$int.remove\0A\00", align 1
@.faila.213 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.214 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.215 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.216 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.217 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.218 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.219 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.220 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.221 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.222 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$String$int.remove\0A\00", align 1
@.faila.223 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.224 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.225 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$String$int.remove\0A\00", align 1
@.faila.226 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.227 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.228 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$String$int.remove\0A\00", align 1
@.faila.229 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.230 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.231 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$String$int.remove\0A\00", align 1
@.faila.232 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.233 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.234 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$String$int.remove\0A\00", align 1
@.faila.235 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.236 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.237 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.238 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.239 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.240 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.241 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.242 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.243 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.244 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$String$int.keyArray\0A\00", align 1
@.faila.245 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.246 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.247 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$int.keyArray\0A\00", align 1
@.faila.248 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.249 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.250 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$int.keyArray\0A\00", align 1
@.faila.251 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.252 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.253 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$String$int.valueArray\0A\00", align 1
@.faila.254 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.255 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.256 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$int.valueArray\0A\00", align 1
@.faila.257 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.258 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.259 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$int.valueArray\0A\00", align 1
@.faila.260 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.261 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.262 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.263 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.264 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.265 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.266 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.267 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.268 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.269 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.270 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.271 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.272 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$String.add\0A\00", align 1
@.faila.273 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.274 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.275 = private unnamed_addr constant [124 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$String.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.276 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.277 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.278 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.279 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.280 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.281 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.282 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.283 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.284 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.285 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.286 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.287 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.288 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.289 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.290 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$String.get\0A\00", align 1
@.faila.291 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.292 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.293 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$String.get\0A\00", align 1
@.faila.294 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.295 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.296 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$String.set\0A\00", align 1
@.faila.297 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.298 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.299 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.300 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$String.set\0A\00", align 1
@.faila.301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.303 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.304 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$String.indexOf\0A\00", align 1
@.faila.305 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.306 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.307 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$String.removeAt\0A\00", align 1
@.faila.308 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.309 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.310 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.311 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.312 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.313 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.314 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.315 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.316 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.317 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.318 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.319 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.320 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.321 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.322 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.323 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.324 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$String.insertAt\0A\00", align 1
@.faila.325 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.326 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.327 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.328 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.329 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.330 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.331 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.332 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.333 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.334 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.335 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.336 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.337 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.338 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.339 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.340 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.341 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.342 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.343 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$String.insertAt\0A\00", align 1
@.faila.344 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.345 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.346 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.347 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.348 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.349 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.350 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.351 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.352 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.353 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.354 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.355 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.356 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.357 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.358 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.359 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.360 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$String.forEach\0A\00", align 1
@.faila.361 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.362 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.363 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$String.filter\0A\00", align 1
@.faila.364 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.365 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.366 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$String.filter\0A\00", align 1
@.faila.367 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.368 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.369 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$String.any\0A\00", align 1
@.faila.370 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.371 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.372 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$String.all\0A\00", align 1
@.faila.373 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.374 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.375 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$String.count\0A\00", align 1
@.faila.376 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.377 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.378 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$String.sortedBy\0A\00", align 1
@.faila.379 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.380 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.381 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.382 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.383 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.384 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.385 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.386 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.387 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.388 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.389 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.390 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.391 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.392 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.393 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.394 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.395 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.396 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.397 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.398 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.399 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.400 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.401 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.402 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.403 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.404 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.405 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.406 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.407 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.408 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.409 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.410 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.411 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.412 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.413 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.414 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.415 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.416 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.417 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.418 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.419 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.420 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.421 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.422 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.423 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.424 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.425 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.426 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.427 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.428 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.429 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.430 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.431 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.432 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.433 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.434 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.435 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.436 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.437 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.438 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.439 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.440 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.441 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.442 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.443 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.444 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.445 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.446 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$String.find\0A\00", align 1
@.faila.447 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.448 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.449 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$String.find\0A\00", align 1
@.faila.450 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.451 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.452 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$String.min\0A\00", align 1
@.faila.453 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.454 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.455 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$String.min\0A\00", align 1
@.faila.456 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.457 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.458 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$String.min\0A\00", align 1
@.faila.459 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.460 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.461 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$String.max\0A\00", align 1
@.faila.462 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.463 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.464 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$String.max\0A\00", align 1
@.faila.465 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.466 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.467 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$String.max\0A\00", align 1
@.faila.468 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.469 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1528 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1529 = private global %String { i64 16, ptr @.strdata.1528, i64 0 }
@.strdata.1530 = private constant [17 x i8] c"division by zero\00"
@.strobj.1531 = private global %String { i64 16, ptr @.strdata.1530, i64 0 }
@.strdata.5529 = private constant [1 x i8] zeroinitializer
@.strobj.5530 = private global %String { i64 0, ptr @.strdata.5529, i64 0 }
@.strdata.5531 = private constant [1 x i8] zeroinitializer
@.strobj.5532 = private global %String { i64 0, ptr @.strdata.5531, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %ks = alloca ptr, align 8
  %lm = alloca ptr, align 8
  %rb = alloca ptr, align 8
  %c = alloca ptr, align 8
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
  %"Multiset$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Multiset$String", ptr null, i64 1) to i64))
  call void @"Multiset$String.Multiset$String"(ptr %"Multiset$String.obj")
  store ptr %"Multiset$String.obj", ptr %c, align 8
  %c1 = load ptr, ptr %c, align 8
  call void @"Multiset$String.add"(ptr %c1, ptr @.strobj)
  %c2 = load ptr, ptr %c, align 8
  call void @"Multiset$String.add"(ptr %c2, ptr @.strobj.2)
  %c3 = load ptr, ptr %c, align 8
  call void @"Multiset$String.add"(ptr %c3, ptr @.strobj.4)
  %"RingBuffer$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.RingBuffer$int", ptr null, i64 1) to i64))
  call void @"RingBuffer$int.RingBuffer$int"(ptr %"RingBuffer$int.obj", i32 3)
  store ptr %"RingBuffer$int.obj", ptr %rb, align 8
  %rb4 = load ptr, ptr %rb, align 8
  call void @"RingBuffer$int.push"(ptr %rb4, i32 1)
  %rb5 = load ptr, ptr %rb, align 8
  call void @"RingBuffer$int.push"(ptr %rb5, i32 2)
  %rb6 = load ptr, ptr %rb, align 8
  call void @"RingBuffer$int.push"(ptr %rb6, i32 3)
  %rb7 = load ptr, ptr %rb, align 8
  call void @"RingBuffer$int.push"(ptr %rb7, i32 4)
  %"LinkedHashMap$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.LinkedHashMap$String$int", ptr null, i64 1) to i64))
  call void @"LinkedHashMap$String$int.LinkedHashMap$String$int"(ptr %"LinkedHashMap$String$int.obj")
  store ptr %"LinkedHashMap$String$int.obj", ptr %lm, align 8
  %lm8 = load ptr, ptr %lm, align 8
  call void @"LinkedHashMap$String$int.put"(ptr %lm8, ptr @.strobj.6, i32 1)
  %lm9 = load ptr, ptr %lm, align 8
  call void @"LinkedHashMap$String$int.put"(ptr %lm9, ptr @.strobj.8, i32 2)
  %lm10 = load ptr, ptr %lm, align 8
  call void @"LinkedHashMap$String$int.put"(ptr %lm10, ptr @.strobj.10, i32 9)
  %lm11 = load ptr, ptr %lm, align 8
  %16 = call ptr @"LinkedHashMap$String$int.keysInOrder"(ptr %lm11)
  store ptr %16, ptr %ks, align 8
  %c12 = load ptr, ptr %c, align 8
  %17 = call i32 @"Multiset$String.count"(ptr %c12, ptr @.strobj.12)
  %c13 = load ptr, ptr %c, align 8
  %18 = call i32 @"Multiset$String.total"(ptr %c13)
  %rb14 = load ptr, ptr %rb, align 8
  %19 = call i32 @"RingBuffer$int.peek"(ptr %rb14)
  %rb15 = load ptr, ptr %rb, align 8
  %20 = call i32 @"RingBuffer$int.isFull"(ptr %rb15)
  %ks16 = load ptr, ptr %ks, align 8
  %21 = call ptr @"ArrayList$String.get"(ptr %ks16, i32 0)
  %str.data = getelementptr inbounds %String, ptr %21, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %lm17 = load ptr, ptr %lm, align 8
  %22 = call i32 @"LinkedHashMap$String$int.get"(ptr %lm17, ptr @.strobj.14)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %18, i32 %19, i32 %20, ptr %data, i32 %22)
  call void @__polaron_str_free(ptr %21)
  ret i32 0
}

define internal void @"RingBuffer$int.RingBuffer$int"(ptr %0, i32 %1) {
entry:
  %capacity = alloca i32, align 4
  store i32 %1, ptr %capacity, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 0
  store ptr @"RingBuffer$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %buf, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %capacity1 = load i32, ptr %capacity, align 4
  store i32 %capacity1, ptr %cap, align 4, !tbaa !4
  %buf2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %capacity3 = load i32, ptr %capacity, align 4
  %2 = sext i32 %capacity3 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %buf2, align 8, !tbaa !0
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head, align 4, !tbaa !4
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  %count4 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %6 = icmp sge i32 %count5, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %contract.l = sext i32 %count7 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %8 = icmp sle i32 %count9, %cap11
  %9 = zext i1 %8 to i32
  %contract.ok12 = icmp ne i32 %9, 0
  br i1 %contract.ok12, label %contract.cont14, label %contract.fail13

contract.fail13:                                  ; preds = %contract.cont
  %count15 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %cap17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %contract.l19 = sext i32 %count16 to i64
  %contract.r = sext i32 %cap18 to i64
  call void @__polaron_fail(ptr @.contract.15, ptr @.cl.16, i64 %contract.l19, ptr @.cr.17, i64 %contract.r, i32 1)
  unreachable

contract.cont14:                                  ; preds = %contract.cont
  %head20 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head21 = load i32, ptr %head20, align 4, !tbaa !4
  %10 = icmp sge i32 %head21, 0
  %11 = zext i1 %10 to i32
  %contract.ok22 = icmp ne i32 %11, 0
  br i1 %contract.ok22, label %contract.cont24, label %contract.fail23

contract.fail23:                                  ; preds = %contract.cont14
  %head25 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head26 = load i32, ptr %head25, align 4, !tbaa !4
  %contract.l27 = sext i32 %head26 to i64
  call void @__polaron_fail(ptr @.contract.18, ptr @.cl.19, i64 %contract.l27, ptr @.cr.20, i64 0, i32 1)
  unreachable

contract.cont24:                                  ; preds = %contract.cont14
  %head28 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head29 = load i32, ptr %head28, align 4, !tbaa !4
  %cap30 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !4
  %12 = icmp slt i32 %head29, %cap31
  %13 = zext i1 %12 to i32
  %contract.ok32 = icmp ne i32 %13, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont24
  %head35 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head36 = load i32, ptr %head35, align 4, !tbaa !4
  %cap37 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !4
  %contract.l39 = sext i32 %head36 to i64
  %contract.r40 = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.21, ptr @.cl.22, i64 %contract.l39, ptr @.cr.23, i64 %contract.r40, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont24
  %buf41 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf42 = load ptr, ptr %buf41, align 8, !tbaa !0
  %len = load i64, ptr %buf42, align 8
  %14 = trunc i64 %len to i32
  %cap43 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap44
  %16 = zext i1 %15 to i32
  %contract.ok45 = icmp ne i32 %16, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.24, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret void
}

define internal void @"RingBuffer$int.push"(ptr nonnull align 8 dereferenceable(32) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown39 = alloca ptr, align 8
  %tail = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp sle i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %6 = icmp sge i32 %head6, 0
  %7 = zext i1 %6 to i32
  %inv.assume7 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %8 = icmp slt i32 %head9, %cap11
  %9 = zext i1 %8 to i32
  %inv.assume12 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %10 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap15
  %12 = zext i1 %11 to i32
  %inv.assume16 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume16)
  %head17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head18 = load i32, ptr %head17, align 4, !tbaa !4
  %count19 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %13 = add i32 %head18, %count20
  %cap21 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !4
  %14 = icmp eq i32 %cap22, 0
  %15 = icmp eq i32 %13, -2147483648
  %16 = icmp eq i32 %cap22, -1
  %17 = and i1 %15, %16
  %18 = or i1 %14, %17
  br i1 %18, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %19 = srem i32 %13, %cap22
  store i32 %19, ptr %tail, align 4
  %buf23 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf24 = load ptr, ptr %buf23, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %tail25 = load i32, ptr %tail, align 4
  %20 = sext i32 %tail25 to i64
  %arr.len = load i64, ptr %buf24, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %20, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %buf24, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %20
  %item26 = load i32, ptr %item, align 4
  store i32 %item26, ptr %arr.elem, align 4
  %count27 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %cap29 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap30 = load i32, ptr %cap29, align 4, !tbaa !4
  %21 = icmp eq i32 %count28, %cap30
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then, label %if.else

if.then:                                          ; preds = %idx.ok
  %head31 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head32 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head33 = load i32, ptr %head32, align 4, !tbaa !4
  %23 = add i32 %head33, 1
  %cap34 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %24 = icmp eq i32 %cap35, 0
  %25 = icmp eq i32 %23, -2147483648
  %26 = icmp eq i32 %cap35, -1
  %27 = and i1 %25, %26
  %28 = or i1 %24, %27
  br i1 %28, label %div.bad36, label %div.ok37

if.else:                                          ; preds = %idx.ok
  %count40 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count41 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count42 = load i32, ptr %count41, align 4, !tbaa !4
  %29 = add i32 %count42, 1
  store i32 %29, ptr %count40, align 4, !tbaa !4
  br label %if.end

if.end:                                           ; preds = %if.else, %div.ok37
  %count43 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count44 = load i32, ptr %count43, align 4, !tbaa !4
  %30 = icmp sge i32 %count44, 0
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

div.bad36:                                        ; preds = %if.then
  %exc38 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc38)
  store ptr %exc38, ptr %exc.thrown39, align 8
  call void @_CxxThrowException(ptr %exc.thrown39, ptr @_TI1PEAX)
  unreachable

div.ok37:                                         ; preds = %if.then
  %32 = srem i32 %23, %cap35
  store i32 %32, ptr %head31, align 4, !tbaa !4
  br label %if.end

contract.fail:                                    ; preds = %if.end
  %count45 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count46 = load i32, ptr %count45, align 4, !tbaa !4
  %contract.l = sext i32 %count46 to i64
  call void @__polaron_fail(ptr @.contract.25, ptr @.cl.26, i64 %contract.l, ptr @.cr.27, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count47 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count48 = load i32, ptr %count47, align 4, !tbaa !4
  %cap49 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap50 = load i32, ptr %cap49, align 4, !tbaa !4
  %33 = icmp sle i32 %count48, %cap50
  %34 = zext i1 %33 to i32
  %contract.ok51 = icmp ne i32 %34, 0
  br i1 %contract.ok51, label %contract.cont53, label %contract.fail52

contract.fail52:                                  ; preds = %contract.cont
  %count54 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %cap56 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap57 = load i32, ptr %cap56, align 4, !tbaa !4
  %contract.l58 = sext i32 %count55 to i64
  %contract.r = sext i32 %cap57 to i64
  call void @__polaron_fail(ptr @.contract.28, ptr @.cl.29, i64 %contract.l58, ptr @.cr.30, i64 %contract.r, i32 1)
  unreachable

contract.cont53:                                  ; preds = %contract.cont
  %head59 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head60 = load i32, ptr %head59, align 4, !tbaa !4
  %35 = icmp sge i32 %head60, 0
  %36 = zext i1 %35 to i32
  %contract.ok61 = icmp ne i32 %36, 0
  br i1 %contract.ok61, label %contract.cont63, label %contract.fail62

contract.fail62:                                  ; preds = %contract.cont53
  %head64 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head65 = load i32, ptr %head64, align 4, !tbaa !4
  %contract.l66 = sext i32 %head65 to i64
  call void @__polaron_fail(ptr @.contract.31, ptr @.cl.32, i64 %contract.l66, ptr @.cr.33, i64 0, i32 1)
  unreachable

contract.cont63:                                  ; preds = %contract.cont53
  %head67 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head68 = load i32, ptr %head67, align 4, !tbaa !4
  %cap69 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap70 = load i32, ptr %cap69, align 4, !tbaa !4
  %37 = icmp slt i32 %head68, %cap70
  %38 = zext i1 %37 to i32
  %contract.ok71 = icmp ne i32 %38, 0
  br i1 %contract.ok71, label %contract.cont73, label %contract.fail72

contract.fail72:                                  ; preds = %contract.cont63
  %head74 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head75 = load i32, ptr %head74, align 4, !tbaa !4
  %cap76 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap77 = load i32, ptr %cap76, align 4, !tbaa !4
  %contract.l78 = sext i32 %head75 to i64
  %contract.r79 = sext i32 %cap77 to i64
  call void @__polaron_fail(ptr @.contract.34, ptr @.cl.35, i64 %contract.l78, ptr @.cr.36, i64 %contract.r79, i32 1)
  unreachable

contract.cont73:                                  ; preds = %contract.cont63
  %buf80 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf81 = load ptr, ptr %buf80, align 8, !tbaa !0
  %len82 = load i64, ptr %buf81, align 8
  %39 = trunc i64 %len82 to i32
  %cap83 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap84 = load i32, ptr %cap83, align 4, !tbaa !4
  %40 = icmp eq i32 %39, %cap84
  %41 = zext i1 %40 to i32
  %contract.ok85 = icmp ne i32 %41, 0
  br i1 %contract.ok85, label %contract.cont87, label %contract.fail86

contract.fail86:                                  ; preds = %contract.cont73
  call void @__polaron_fail(ptr @.contract.37, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont87:                                  ; preds = %contract.cont73
  ret void
}

define internal i32 @"RingBuffer$int.pop"(ptr nonnull align 8 dereferenceable(32) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %v = alloca i32, align 4
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %5 = icmp sge i32 %head6, 0
  %6 = zext i1 %5 to i32
  %inv.assume7 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %7 = icmp slt i32 %head9, %cap11
  %8 = zext i1 %7 to i32
  %inv.assume12 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %9 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap15
  %11 = zext i1 %10 to i32
  %inv.assume16 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume16)
  %buf17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf18 = load ptr, ptr %buf17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head19 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head20 = load i32, ptr %head19, align 4, !tbaa !4
  %12 = sext i32 %head20 to i64
  %arr.len = load i64, ptr %buf18, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.38, ptr @.faila.39, i64 %12, ptr @.failb.40, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %buf18, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %v, align 4
  %head21 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head22 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head23 = load i32, ptr %head22, align 4, !tbaa !4
  %13 = add i32 %head23, 1
  %cap24 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap25 = load i32, ptr %cap24, align 4, !tbaa !4
  %14 = icmp eq i32 %cap25, 0
  %15 = icmp eq i32 %13, -2147483648
  %16 = icmp eq i32 %cap25, -1
  %17 = and i1 %15, %16
  %18 = or i1 %14, %17
  br i1 %18, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %19 = srem i32 %13, %cap25
  store i32 %19, ptr %head21, align 4, !tbaa !4
  %count26 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count27 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %20 = sub i32 %count28, 1
  store i32 %20, ptr %count26, align 4, !tbaa !4
  %v29 = load i32, ptr %v, align 4
  %count30 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %21 = icmp sge i32 %count31, 0
  %22 = zext i1 %21 to i32
  %contract.ok = icmp ne i32 %22, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %div.ok
  %count32 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %contract.l = sext i32 %count33 to i64
  call void @__polaron_fail(ptr @.contract.41, ptr @.cl.42, i64 %contract.l, ptr @.cr.43, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %div.ok
  %count34 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count35 = load i32, ptr %count34, align 4, !tbaa !4
  %cap36 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap37 = load i32, ptr %cap36, align 4, !tbaa !4
  %23 = icmp sle i32 %count35, %cap37
  %24 = zext i1 %23 to i32
  %contract.ok38 = icmp ne i32 %24, 0
  br i1 %contract.ok38, label %contract.cont40, label %contract.fail39

contract.fail39:                                  ; preds = %contract.cont
  %count41 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count42 = load i32, ptr %count41, align 4, !tbaa !4
  %cap43 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %contract.l45 = sext i32 %count42 to i64
  %contract.r = sext i32 %cap44 to i64
  call void @__polaron_fail(ptr @.contract.44, ptr @.cl.45, i64 %contract.l45, ptr @.cr.46, i64 %contract.r, i32 1)
  unreachable

contract.cont40:                                  ; preds = %contract.cont
  %head46 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head47 = load i32, ptr %head46, align 4, !tbaa !4
  %25 = icmp sge i32 %head47, 0
  %26 = zext i1 %25 to i32
  %contract.ok48 = icmp ne i32 %26, 0
  br i1 %contract.ok48, label %contract.cont50, label %contract.fail49

contract.fail49:                                  ; preds = %contract.cont40
  %head51 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head52 = load i32, ptr %head51, align 4, !tbaa !4
  %contract.l53 = sext i32 %head52 to i64
  call void @__polaron_fail(ptr @.contract.47, ptr @.cl.48, i64 %contract.l53, ptr @.cr.49, i64 0, i32 1)
  unreachable

contract.cont50:                                  ; preds = %contract.cont40
  %head54 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head55 = load i32, ptr %head54, align 4, !tbaa !4
  %cap56 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap57 = load i32, ptr %cap56, align 4, !tbaa !4
  %27 = icmp slt i32 %head55, %cap57
  %28 = zext i1 %27 to i32
  %contract.ok58 = icmp ne i32 %28, 0
  br i1 %contract.ok58, label %contract.cont60, label %contract.fail59

contract.fail59:                                  ; preds = %contract.cont50
  %head61 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head62 = load i32, ptr %head61, align 4, !tbaa !4
  %cap63 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap64 = load i32, ptr %cap63, align 4, !tbaa !4
  %contract.l65 = sext i32 %head62 to i64
  %contract.r66 = sext i32 %cap64 to i64
  call void @__polaron_fail(ptr @.contract.50, ptr @.cl.51, i64 %contract.l65, ptr @.cr.52, i64 %contract.r66, i32 1)
  unreachable

contract.cont60:                                  ; preds = %contract.cont50
  ret i32 %v29
}

define internal i32 @"RingBuffer$int.peek"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %5 = icmp sge i32 %head6, 0
  %6 = zext i1 %5 to i32
  %inv.assume7 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %7 = icmp slt i32 %head9, %cap11
  %8 = zext i1 %7 to i32
  %inv.assume12 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %9 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap15
  %11 = zext i1 %10 to i32
  %inv.assume16 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume16)
  %buf17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf18 = load ptr, ptr %buf17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head19 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head20 = load i32, ptr %head19, align 4, !tbaa !4
  %12 = sext i32 %head20 to i64
  %arr.len = load i64, ptr %buf18, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.53, ptr @.faila.54, i64 %12, ptr @.failb.55, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %buf18, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"RingBuffer$int.size"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %5 = icmp sge i32 %head6, 0
  %6 = zext i1 %5 to i32
  %inv.assume7 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %7 = icmp slt i32 %head9, %cap11
  %8 = zext i1 %7 to i32
  %inv.assume12 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %9 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap15
  %11 = zext i1 %10 to i32
  %inv.assume16 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume16)
  %count17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  ret i32 %count18
}

define internal i32 @"RingBuffer$int.isEmpty"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %5 = icmp sge i32 %head6, 0
  %6 = zext i1 %5 to i32
  %inv.assume7 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %7 = icmp slt i32 %head9, %cap11
  %8 = zext i1 %7 to i32
  %inv.assume12 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %9 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap15
  %11 = zext i1 %10 to i32
  %inv.assume16 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume16)
  %count17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %12 = icmp eq i32 %count18, 0
  %13 = zext i1 %12 to i32
  ret i32 %13
}

define internal i32 @"RingBuffer$int.isFull"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %5 = icmp sge i32 %head6, 0
  %6 = zext i1 %5 to i32
  %inv.assume7 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %7 = icmp slt i32 %head9, %cap11
  %8 = zext i1 %7 to i32
  %inv.assume12 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %9 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap15
  %11 = zext i1 %10 to i32
  %inv.assume16 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume16)
  %count17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %cap19 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap20 = load i32, ptr %cap19, align 4, !tbaa !4
  %12 = icmp eq i32 %count18, %cap20
  %13 = zext i1 %12 to i32
  ret i32 %13
}

define internal i32 @"RingBuffer$int.capacity"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %5 = icmp sge i32 %head6, 0
  %6 = zext i1 %5 to i32
  %inv.assume7 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %cap10 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %7 = icmp slt i32 %head9, %cap11
  %8 = zext i1 %7 to i32
  %inv.assume12 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume12)
  %buf = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 1
  %buf13 = load ptr, ptr %buf, align 8, !tbaa !0
  %len = load i64, ptr %buf13, align 8
  %9 = trunc i64 %len to i32
  %cap14 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap15
  %11 = zext i1 %10 to i32
  %inv.assume16 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume16)
  %cap17 = getelementptr inbounds %"class.RingBuffer$int", ptr %0, i32 0, i32 4
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  ret i32 %cap18
}

define internal void @"Multiset$String.Multiset$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 0
  store ptr @"Multiset$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %counts = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %counts, align 8, !tbaa !0
  %counts1 = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %"HashMap$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$String$int", ptr null, i64 1) to i64))
  call void @"HashMap$String$int.HashMap$String$int"(ptr %"HashMap$String$int.obj")
  store ptr %"HashMap$String$int.obj", ptr %counts1, align 8, !tbaa !0
  ret void
}

define internal void @"Multiset$String.add"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %counts = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts1 = load ptr, ptr %counts, align 8, !tbaa !0
  %item2 = load ptr, ptr %item, align 8
  %2 = call i32 @"HashMap$String$int.containsKey"(ptr %counts1, ptr %item2)
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %counts3 = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts4 = load ptr, ptr %counts3, align 8, !tbaa !0
  %item5 = load ptr, ptr %item, align 8
  %counts6 = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts7 = load ptr, ptr %counts6, align 8, !tbaa !0
  %item8 = load ptr, ptr %item, align 8
  %4 = call i32 @"HashMap$String$int.get"(ptr %counts7, ptr %item8)
  %5 = add i32 %4, 1
  call void @"HashMap$String$int.put"(ptr %counts4, ptr %item5, i32 %5)
  br label %if.end

if.else:                                          ; preds = %entry
  %counts9 = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts10 = load ptr, ptr %counts9, align 8, !tbaa !0
  %item11 = load ptr, ptr %item, align 8
  call void @"HashMap$String$int.put"(ptr %counts10, ptr %item11, i32 1)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define internal i32 @"Multiset$String.count"(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %counts = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts1 = load ptr, ptr %counts, align 8, !tbaa !0
  %item2 = load ptr, ptr %item, align 8
  %2 = call i32 @"HashMap$String$int.containsKey"(ptr %counts1, ptr %item2)
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %counts3 = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts4 = load ptr, ptr %counts3, align 8, !tbaa !0
  %item5 = load ptr, ptr %item, align 8
  %4 = call i32 @"HashMap$String$int.get"(ptr %counts4, ptr %item5)
  ret i32 %4

if.end:                                           ; preds = %entry
  ret i32 0
}

define internal i32 @"Multiset$String.distinct"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %counts = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts1 = load ptr, ptr %counts, align 8, !tbaa !0
  %1 = call i32 @"HashMap$String$int.size"(ptr %counts1)
  ret i32 %1
}

define internal i32 @"Multiset$String.total"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %i = alloca i32, align 4
  %sum = alloca i32, align 4
  %tallies = alloca ptr, align 8
  %counts = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts1 = load ptr, ptr %counts, align 8, !tbaa !0
  %1 = call ptr @"HashMap$String$int.valueArray"(ptr %counts1)
  store ptr %1, ptr %tallies, align 8
  store i32 0, ptr %sum, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %tallies3 = load ptr, ptr %tallies, align 8
  %len = load i64, ptr %tallies3, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %i2, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sum4 = load i32, ptr %sum, align 4
  %tallies5 = load ptr, ptr %tallies, align 8, !nonnull !6, !dereferenceable !7
  %i6 = load i32, ptr %i, align 4
  %5 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %tallies5, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sum7 = load i32, ptr %sum, align 4
  ret i32 %sum7

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.101, ptr @.faila.102, i64 %5, ptr @.failb.103, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %tallies5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  %8 = add i32 %sum4, %elem
  store i32 %8, ptr %sum, align 4
  br label %for.update
}

define internal ptr @"Multiset$String.keys"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %counts = getelementptr inbounds %"class.Multiset$String", ptr %0, i32 0, i32 1
  %counts1 = load ptr, ptr %counts, align 8, !tbaa !0
  %1 = call ptr @"HashMap$String$int.keyArray"(ptr %counts1)
  ret ptr %1
}

define internal void @"HashMap$String$int.HashMap$String$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 0
  store ptr @"HashMap$String$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !0
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !0
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !4
  %keys1 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %keys1, align 8, !tbaa !0
  %values2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 32)
  store ptr %arr3, ptr %values2, align 8, !tbaa !0
  %used5 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %count8 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.104, ptr @.cl.105, i64 %contract.l, ptr @.cr.106, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !4
  %cap14 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %cap21 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !4
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.107, ptr @.cl.108, i64 %contract.l23, ptr @.cr.109, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !0
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.110, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !0
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.111, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !0
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.112, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$String$int.~HashMap$String$int"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
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
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !0
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used3 = load ptr, ptr %used, align 8, !tbaa !0
  call void @__polaron_free(ptr %used3)
  ret void
}

define internal i32 @"HashMap$String$int.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
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
  %used24 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %19 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.113, ptr @.faila.114, i64 %19, ptr @.failb.115, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.116, ptr @.faila.117, i64 %20, ptr @.failb.118, i64 %arr.len30, i32 70)
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

define internal void @"HashMap$String$int.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !4
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !0
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !0
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !4
  %keys30 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !4
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 8
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !0
  %values33 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 4
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !0
  %used38 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !4
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !0
  %cap43 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
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
  %ae.len = load i64, ptr %oldK117, align 8
  %arr.data118 = getelementptr i8, ptr %oldK117, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.119, ptr @.faila.120, i64 %30, ptr @.failb.121, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.122, ptr @.faila.123, i64 %36, ptr @.failb.124, i64 %arr.len52, i32 70)
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
  %used60 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
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
  %used72 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used73 = load ptr, ptr %used72, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %43 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %used73, align 8
  %arr.oob76 = icmp uge i64 %43, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad65:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.125, ptr @.faila.126, i64 %40, ptr @.failb.127, i64 %arr.len63, i32 70)
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
  call void @__polaron_fail(ptr @.fail.128, ptr @.faila.129, i64 %43, ptr @.failb.130, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %while.end
  %arr.data79 = getelementptr i8, ptr %used73, i64 8
  %arr.elem80 = getelementptr inbounds i8, ptr %arr.data79, i64 %43
  store i8 1, ptr %arr.elem80, align 1
  %keys81 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys82 = load ptr, ptr %keys81, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i83 = load i32, ptr %i, align 4
  %47 = sext i32 %i83 to i64
  %arr.len84 = load i64, ptr %keys82, align 8
  %arr.oob85 = icmp uge i64 %47, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !8

idx.bad86:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.131, ptr @.faila.132, i64 %47, ptr @.failb.133, i64 %arr.len84, i32 70)
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
  call void @__polaron_fail(ptr @.fail.134, ptr @.faila.135, i64 %48, ptr @.failb.136, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok87
  %arr.data96 = getelementptr i8, ptr %oldK90, i64 8
  %arr.elem97 = getelementptr inbounds ptr, ptr %arr.data96, i64 %48
  %elem98 = load ptr, ptr %arr.elem97, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem98)
  %49 = load ptr, ptr %arr.elem89, align 8
  call void @__polaron_str_free(ptr %49)
  store ptr %strcpy, ptr %arr.elem89, align 8
  %values99 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values100 = load ptr, ptr %values99, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i101 = load i32, ptr %i, align 4
  %50 = sext i32 %i101 to i64
  %arr.len102 = load i64, ptr %values100, align 8
  %arr.oob103 = icmp uge i64 %50, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !8

idx.bad104:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.137, ptr @.faila.138, i64 %50, ptr @.failb.139, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %idx.ok95
  %arr.data106 = getelementptr i8, ptr %values100, i64 8
  %arr.elem107 = getelementptr inbounds i32, ptr %arr.data106, i64 %50
  %oldV108 = load ptr, ptr %oldV, align 8, !nonnull !6, !dereferenceable !7
  %j109 = load i32, ptr %j, align 4
  %51 = sext i32 %j109 to i64
  %arr.len110 = load i64, ptr %oldV108, align 8
  %arr.oob111 = icmp uge i64 %51, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !8

idx.bad112:                                       ; preds = %idx.ok105
  call void @__polaron_fail(ptr @.fail.140, ptr @.faila.141, i64 %51, ptr @.failb.142, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %idx.ok105
  %arr.data114 = getelementptr i8, ptr %oldV108, i64 8
  %arr.elem115 = getelementptr inbounds i32, ptr %arr.data114, i64 %51
  %elem116 = load i32, ptr %arr.elem115, align 4
  store i32 %elem116, ptr %arr.elem107, align 4
  br label %if.end

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %52 = icmp ult i64 %ae.iv, %ae.len
  br i1 %52, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data118, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %53 = icmp ne ptr %ae.el, null
  br i1 %53, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %54 = add i64 %ae.iv, 1
  store i64 %54, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %oldK117)
  %oldV119 = load ptr, ptr %oldV, align 8
  call void @__polaron_free(ptr %oldV119)
  %oldU120 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU120)
  %count121 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count122 = load i32, ptr %count121, align 4, !tbaa !4
  %55 = icmp sge i32 %count122, 0
  %56 = zext i1 %55 to i32
  %contract.ok = icmp ne i32 %56, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %ae.end
  %count123 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count124 = load i32, ptr %count123, align 4, !tbaa !4
  %contract.l = sext i32 %count124 to i64
  call void @__polaron_fail(ptr @.contract.143, ptr @.cl.144, i64 %contract.l, ptr @.cr.145, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %ae.end
  %count125 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !4
  %cap127 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !4
  %57 = icmp slt i32 %count126, %cap128
  %58 = zext i1 %57 to i32
  %contract.ok129 = icmp ne i32 %58, 0
  br i1 %contract.ok129, label %contract.cont131, label %contract.fail130

contract.fail130:                                 ; preds = %contract.cont
  %count132 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count133 = load i32, ptr %count132, align 4, !tbaa !4
  %cap134 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !4
  %contract.l136 = sext i32 %count133 to i64
  %contract.r = sext i32 %cap135 to i64
  call void @__polaron_fail(ptr @.contract.146, ptr @.cl.147, i64 %contract.l136, ptr @.cr.148, i64 %contract.r, i32 1)
  unreachable

contract.cont131:                                 ; preds = %contract.cont
  %keys137 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys138 = load ptr, ptr %keys137, align 8, !tbaa !0
  %len139 = load i64, ptr %keys138, align 8
  %59 = trunc i64 %len139 to i32
  %cap140 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap141 = load i32, ptr %cap140, align 4, !tbaa !4
  %60 = icmp eq i32 %59, %cap141
  %61 = zext i1 %60 to i32
  %contract.ok142 = icmp ne i32 %61, 0
  br i1 %contract.ok142, label %contract.cont144, label %contract.fail143

contract.fail143:                                 ; preds = %contract.cont131
  call void @__polaron_fail(ptr @.contract.149, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont144:                                 ; preds = %contract.cont131
  %values145 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values146 = load ptr, ptr %values145, align 8, !tbaa !0
  %len147 = load i64, ptr %values146, align 8
  %62 = trunc i64 %len147 to i32
  %cap148 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap149 = load i32, ptr %cap148, align 4, !tbaa !4
  %63 = icmp eq i32 %62, %cap149
  %64 = zext i1 %63 to i32
  %contract.ok150 = icmp ne i32 %64, 0
  br i1 %contract.ok150, label %contract.cont152, label %contract.fail151

contract.fail151:                                 ; preds = %contract.cont144
  call void @__polaron_fail(ptr @.contract.150, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont152:                                 ; preds = %contract.cont144
  %used153 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used154 = load ptr, ptr %used153, align 8, !tbaa !0
  %len155 = load i64, ptr %used154, align 8
  %65 = trunc i64 %len155 to i32
  %cap156 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap157 = load i32, ptr %cap156, align 4, !tbaa !4
  %66 = icmp eq i32 %65, %cap157
  %67 = zext i1 %66 to i32
  %contract.ok158 = icmp ne i32 %67, 0
  br i1 %contract.ok158, label %contract.cont160, label %contract.fail159

contract.fail159:                                 ; preds = %contract.cont152
  call void @__polaron_fail(ptr @.contract.151, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont160:                                 ; preds = %contract.cont152
  ret void
}

define internal void @"HashMap$String$int.put"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %value = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %16 = add i32 %count21, 1
  %17 = mul i32 %16, 4
  %cap22 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %18 = mul i32 %cap23, 3
  %19 = icmp sge i32 %17, %18
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$String$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %21 = call i32 @"HashMap$String$int.slotFor"(ptr %0, ptr %key24)
  store i32 %21, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %22 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %22, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.152, ptr @.faila.153, i64 %22, ptr @.failb.154, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %26 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %26, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %27 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %27, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.155, ptr @.faila.156, i64 %26, ptr @.failb.157, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %26
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %28 = add i32 %count41, 1
  store i32 %28, ptr %count39, align 4, !tbaa !4
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.158, ptr @.faila.159, i64 %27, ptr @.failb.160, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %27
  %key51 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key51)
  %29 = load ptr, ptr %arr.elem50, align 8
  call void @__polaron_str_free(ptr %29)
  store ptr %strcpy, ptr %arr.elem50, align 8
  %values52 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %30 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %30, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.161, ptr @.faila.162, i64 %30, ptr @.failb.163, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %30
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  %count62 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count63 = load i32, ptr %count62, align 4, !tbaa !4
  %31 = icmp sge i32 %count63, 0
  %32 = zext i1 %31 to i32
  %contract.ok = icmp ne i32 %32, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count64 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count65 = load i32, ptr %count64, align 4, !tbaa !4
  %contract.l = sext i32 %count65 to i64
  call void @__polaron_fail(ptr @.contract.164, ptr @.cl.165, i64 %contract.l, ptr @.cr.166, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count66 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count67 = load i32, ptr %count66, align 4, !tbaa !4
  %cap68 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap69 = load i32, ptr %cap68, align 4, !tbaa !4
  %33 = icmp slt i32 %count67, %cap69
  %34 = zext i1 %33 to i32
  %contract.ok70 = icmp ne i32 %34, 0
  br i1 %contract.ok70, label %contract.cont72, label %contract.fail71

contract.fail71:                                  ; preds = %contract.cont
  %count73 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count74 = load i32, ptr %count73, align 4, !tbaa !4
  %cap75 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap76 = load i32, ptr %cap75, align 4, !tbaa !4
  %contract.l77 = sext i32 %count74 to i64
  %contract.r = sext i32 %cap76 to i64
  call void @__polaron_fail(ptr @.contract.167, ptr @.cl.168, i64 %contract.l77, ptr @.cr.169, i64 %contract.r, i32 1)
  unreachable

contract.cont72:                                  ; preds = %contract.cont
  %keys78 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys79 = load ptr, ptr %keys78, align 8, !tbaa !0
  %len80 = load i64, ptr %keys79, align 8
  %35 = trunc i64 %len80 to i32
  %cap81 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap82 = load i32, ptr %cap81, align 4, !tbaa !4
  %36 = icmp eq i32 %35, %cap82
  %37 = zext i1 %36 to i32
  %contract.ok83 = icmp ne i32 %37, 0
  br i1 %contract.ok83, label %contract.cont85, label %contract.fail84

contract.fail84:                                  ; preds = %contract.cont72
  call void @__polaron_fail(ptr @.contract.170, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont85:                                  ; preds = %contract.cont72
  %values86 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values87 = load ptr, ptr %values86, align 8, !tbaa !0
  %len88 = load i64, ptr %values87, align 8
  %38 = trunc i64 %len88 to i32
  %cap89 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !4
  %39 = icmp eq i32 %38, %cap90
  %40 = zext i1 %39 to i32
  %contract.ok91 = icmp ne i32 %40, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont85
  call void @__polaron_fail(ptr @.contract.171, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont85
  %used94 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !0
  %len96 = load i64, ptr %used95, align 8
  %41 = trunc i64 %len96 to i32
  %cap97 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap98 = load i32, ptr %cap97, align 4, !tbaa !4
  %42 = icmp eq i32 %41, %cap98
  %43 = zext i1 %42 to i32
  %contract.ok99 = icmp ne i32 %43, 0
  br i1 %contract.ok99, label %contract.cont101, label %contract.fail100

contract.fail100:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.172, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont101:                                 ; preds = %contract.cont93
  ret void
}

define internal i32 @"HashMap$String$int.get"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$int.slotFor"(ptr %0, ptr %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.173, ptr @.faila.174, i64 %16, ptr @.failb.175, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %16
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"HashMap$String$int.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$int.slotFor"(ptr %0, ptr %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.176, ptr @.faila.177, i64 %16, ptr @.failb.178, i64 %arr.len, i32 70)
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

define internal i32 @"HashMap$String$int.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %defaultValue, align 4
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$String$int.slotFor"(ptr %0, ptr %key20)
  store i32 %16, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.179, ptr @.faila.180, i64 %17, ptr @.failb.181, i64 %arr.len, i32 70)
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
  %values24 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %21 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %values25, align 8
  %arr.oob28 = icmp uge i64 %21, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !8

if.end:                                           ; preds = %idx.ok
  %defaultValue34 = load i32, ptr %defaultValue, align 4
  ret i32 %defaultValue34

idx.bad29:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.182, ptr @.faila.183, i64 %21, ptr @.failb.184, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 %21
  %elem33 = load i32, ptr %arr.elem32, align 4
  ret i32 %elem33
}

define internal void @"HashMap$String$int.merge"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %value = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$String$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %22 = call i32 @"HashMap$String$int.slotFor"(ptr %0, ptr %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.185, ptr @.faila.186, i64 %23, ptr @.failb.187, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.else:                                          ; preds = %idx.ok
  %values62 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values63 = load ptr, ptr %values62, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i64 = load i32, ptr %i, align 4
  %28 = sext i32 %i64 to i64
  %arr.len65 = load i64, ptr %values63, align 8
  %arr.oob66 = icmp uge i64 %28, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !8

if.end29:                                         ; preds = %idx.ok78, %idx.ok58
  %count83 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count84 = load i32, ptr %count83, align 4, !tbaa !4
  %29 = icmp sge i32 %count84, 0
  %30 = zext i1 %29 to i32
  %contract.ok = icmp ne i32 %30, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.188, ptr @.faila.189, i64 %27, ptr @.failb.190, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %31 = add i32 %count41, 1
  store i32 %31, ptr %count39, align 4, !tbaa !4
  %keys42 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %32 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %32, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.191, ptr @.faila.192, i64 %32, ptr @.failb.193, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %32
  %key51 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key51)
  %33 = load ptr, ptr %arr.elem50, align 8
  call void @__polaron_str_free(ptr %33)
  store ptr %strcpy, ptr %arr.elem50, align 8
  %values52 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %34 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %34, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.194, ptr @.faila.195, i64 %34, ptr @.failb.196, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %34
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  br label %if.end29

idx.bad67:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.197, ptr @.faila.198, i64 %28, ptr @.failb.199, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %if.else
  %arr.data69 = getelementptr i8, ptr %values63, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 %28
  %combine71 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine71, align 8
  %35 = getelementptr ptr, ptr %combine71, i32 1
  %env = load ptr, ptr %35, align 8
  %values72 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values73 = load ptr, ptr %values72, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %36 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %values73, align 8
  %arr.oob76 = icmp uge i64 %36, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad77:                                        ; preds = %idx.ok68
  call void @__polaron_fail(ptr @.fail.200, ptr @.faila.201, i64 %36, ptr @.failb.202, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %idx.ok68
  %arr.data79 = getelementptr i8, ptr %values73, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %36
  %elem81 = load i32, ptr %arr.elem80, align 4
  %value82 = load i32, ptr %value, align 4
  %37 = call i32 %code(ptr %env, i32 %elem81, i32 %value82)
  store i32 %37, ptr %arr.elem70, align 4
  br label %if.end29

contract.fail:                                    ; preds = %if.end29
  %count85 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count86 = load i32, ptr %count85, align 4, !tbaa !4
  %contract.l = sext i32 %count86 to i64
  call void @__polaron_fail(ptr @.contract.203, ptr @.cl.204, i64 %contract.l, ptr @.cr.205, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count87 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count88 = load i32, ptr %count87, align 4, !tbaa !4
  %cap89 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !4
  %38 = icmp slt i32 %count88, %cap90
  %39 = zext i1 %38 to i32
  %contract.ok91 = icmp ne i32 %39, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont
  %count94 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count95 = load i32, ptr %count94, align 4, !tbaa !4
  %cap96 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap97 = load i32, ptr %cap96, align 4, !tbaa !4
  %contract.l98 = sext i32 %count95 to i64
  %contract.r = sext i32 %cap97 to i64
  call void @__polaron_fail(ptr @.contract.206, ptr @.cl.207, i64 %contract.l98, ptr @.cr.208, i64 %contract.r, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont
  %keys99 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys100 = load ptr, ptr %keys99, align 8, !tbaa !0
  %len101 = load i64, ptr %keys100, align 8
  %40 = trunc i64 %len101 to i32
  %cap102 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap103 = load i32, ptr %cap102, align 4, !tbaa !4
  %41 = icmp eq i32 %40, %cap103
  %42 = zext i1 %41 to i32
  %contract.ok104 = icmp ne i32 %42, 0
  br i1 %contract.ok104, label %contract.cont106, label %contract.fail105

contract.fail105:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.209, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont106:                                 ; preds = %contract.cont93
  %values107 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values108 = load ptr, ptr %values107, align 8, !tbaa !0
  %len109 = load i64, ptr %values108, align 8
  %43 = trunc i64 %len109 to i32
  %cap110 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap111 = load i32, ptr %cap110, align 4, !tbaa !4
  %44 = icmp eq i32 %43, %cap111
  %45 = zext i1 %44 to i32
  %contract.ok112 = icmp ne i32 %45, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

contract.fail113:                                 ; preds = %contract.cont106
  call void @__polaron_fail(ptr @.contract.210, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %contract.cont106
  %used115 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used116 = load ptr, ptr %used115, align 8, !tbaa !0
  %len117 = load i64, ptr %used116, align 8
  %46 = trunc i64 %len117 to i32
  %cap118 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap119 = load i32, ptr %cap118, align 4, !tbaa !4
  %47 = icmp eq i32 %46, %cap119
  %48 = zext i1 %47 to i32
  %contract.ok120 = icmp ne i32 %48, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont114
  call void @__polaron_fail(ptr @.contract.211, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont122:                                 ; preds = %contract.cont114
  ret void
}

define internal i32 @"HashMap$String$int.remove"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %rv = alloca i32, align 4
  %rk = alloca ptr, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$int.slotFor"(ptr %0, ptr %key20)
  store i32 %15, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %16 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.212, ptr @.faila.213, i64 %16, ptr @.failb.214, i64 %arr.len, i32 70)
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
  %count24 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !4
  %20 = icmp sge i32 %count25, 0
  %21 = zext i1 %20 to i32
  %contract.ok = icmp ne i32 %21, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !4
  %22 = sub i32 %cap49, 1
  store i32 %22, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %23 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %23, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.215, ptr @.cl.216, i64 %contract.l, ptr @.cr.217, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %cap30 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !4
  %24 = icmp slt i32 %count29, %cap31
  %25 = zext i1 %24 to i32
  %contract.ok32 = icmp ne i32 %25, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %cap37 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !4
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.218, ptr @.cl.219, i64 %contract.l39, ptr @.cr.220, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !0
  %len42 = load i64, ptr %used41, align 8
  %26 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %27 = icmp eq i32 %26, %cap44
  %28 = zext i1 %27 to i32
  %contract.ok45 = icmp ne i32 %28, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.221, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.222, ptr @.faila.223, i64 %23, ptr @.failb.224, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %23
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
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
  %used64 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j66 = load i32, ptr %j, align 4
  %32 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %32, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !8

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %33 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %33, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

while.end:                                        ; preds = %idx.ok70
  %count110 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count111 = load i32, ptr %count110, align 4, !tbaa !4
  %34 = icmp sge i32 %count111, 0
  %35 = zext i1 %34 to i32
  %contract.ok112 = icmp ne i32 %35, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.225, ptr @.faila.226, i64 %32, ptr @.failb.227, i64 %arr.len67, i32 70)
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
  call void @__polaron_fail(ptr @.fail.228, ptr @.faila.229, i64 %33, ptr @.failb.230, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds ptr, ptr %arr.data81, i64 %33
  %elem83 = load ptr, ptr %arr.elem82, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem83)
  store ptr %strcpy, ptr %rk, align 8
  %values84 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j86 = load i32, ptr %j, align 4
  %39 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %39, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.231, ptr @.faila.232, i64 %39, ptr @.failb.233, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 %39
  %elem93 = load i32, ptr %arr.elem92, align 4
  store i32 %elem93, ptr %rv, align 4
  %used94 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j96 = load i32, ptr %j, align 4
  %40 = sext i32 %j96 to i64
  %arr.len97 = load i64, ptr %used95, align 8
  %arr.oob98 = icmp uge i64 %40, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.234, ptr @.faila.235, i64 %40, ptr @.failb.236, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %used95, i64 8
  %arr.elem102 = getelementptr inbounds i8, ptr %arr.data101, i64 %40
  store i8 0, ptr %arr.elem102, align 1
  %count103 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count104 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count105 = load i32, ptr %count104, align 4, !tbaa !4
  %41 = sub i32 %count105, 1
  store i32 %41, ptr %count103, align 4, !tbaa !4
  %rk106 = load ptr, ptr %rk, align 8
  %rv107 = load i32, ptr %rv, align 4
  call void @"HashMap$String$int.put"(ptr %0, ptr %rk106, i32 %rv107)
  %j108 = load i32, ptr %j, align 4
  %42 = add i32 %j108, 1
  %mask109 = load i32, ptr %mask, align 4
  %43 = and i32 %42, %mask109
  store i32 %43, ptr %j, align 4
  %44 = load ptr, ptr %rk, align 8
  call void @__polaron_str_free(ptr %44)
  br label %while.cond

contract.fail113:                                 ; preds = %while.end
  %count115 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count116 = load i32, ptr %count115, align 4, !tbaa !4
  %contract.l117 = sext i32 %count116 to i64
  call void @__polaron_fail(ptr @.contract.237, ptr @.cl.238, i64 %contract.l117, ptr @.cr.239, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %while.end
  %count118 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !4
  %cap120 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !4
  %45 = icmp slt i32 %count119, %cap121
  %46 = zext i1 %45 to i32
  %contract.ok122 = icmp ne i32 %46, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont114
  %count125 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !4
  %cap127 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !4
  %contract.l129 = sext i32 %count126 to i64
  %contract.r130 = sext i32 %cap128 to i64
  call void @__polaron_fail(ptr @.contract.240, ptr @.cl.241, i64 %contract.l129, ptr @.cr.242, i64 %contract.r130, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont114
  %used131 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used132 = load ptr, ptr %used131, align 8, !tbaa !0
  %len133 = load i64, ptr %used132, align 8
  %47 = trunc i64 %len133 to i32
  %cap134 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !4
  %48 = icmp eq i32 %47, %cap135
  %49 = zext i1 %48 to i32
  %contract.ok136 = icmp ne i32 %49, 0
  br i1 %contract.ok136, label %contract.cont138, label %contract.fail137

contract.fail137:                                 ; preds = %contract.cont124
  call void @__polaron_fail(ptr @.contract.243, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont138:                                 ; preds = %contract.cont124
  ret i32 1
}

define internal ptr @"HashMap$String$int.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.244, ptr @.faila.245, i64 %20, ptr @.failb.246, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.247, ptr @.faila.248, i64 %26, ptr @.failb.249, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.250, ptr @.faila.251, i64 %27, ptr @.failb.252, i64 %arr.len40, i32 70)
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

define internal ptr @"HashMap$String$int.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.253, ptr @.faila.254, i64 %20, ptr @.failb.255, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.256, ptr @.faila.257, i64 %26, ptr @.failb.258, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.259, ptr @.faila.260, i64 %27, ptr @.failb.261, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %values38, i64 8
  %arr.elem45 = getelementptr inbounds i32, ptr %arr.data44, i64 %27
  %elem46 = load i32, ptr %arr.elem45, align 4
  store i32 %elem46, ptr %arr.elem36, align 4
  %j47 = load i32, ptr %j, align 4
  %28 = add i32 %j47, 1
  store i32 %28, ptr %j, align 4
  br label %if.end
}

define internal i32 @"HashMap$String$int.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  ret i32 %count21
}

define internal i32 @"HashMap$String$int.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %14 = icmp eq i32 %count21, 0
  %15 = zext i1 %14 to i32
  ret i32 %15
}

define internal void @"LinkedHashMap$String$int.LinkedHashMap$String$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 0
  store ptr @"LinkedHashMap$String$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %map = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %map, align 8, !tbaa !0
  %order = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %order, align 8, !tbaa !0
  %map1 = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %"HashMap$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$String$int", ptr null, i64 1) to i64))
  call void @"HashMap$String$int.HashMap$String$int"(ptr %"HashMap$String$int.obj")
  store ptr %"HashMap$String$int.obj", ptr %map1, align 8, !tbaa !0
  %order2 = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 2
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr %order2, align 8, !tbaa !0
  ret void
}

define internal void @"LinkedHashMap$String$int.put"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  %map = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %map1 = load ptr, ptr %map, align 8, !tbaa !0
  %key2 = load ptr, ptr %key, align 8
  %3 = call i32 @"HashMap$String$int.containsKey"(ptr %map1, ptr %key2)
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %order = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 2
  %order3 = load ptr, ptr %order, align 8, !tbaa !0
  %key4 = load ptr, ptr %key, align 8
  call void @"ArrayList$String.add"(ptr %order3, ptr %key4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %map5 = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %map6 = load ptr, ptr %map5, align 8, !tbaa !0
  %key7 = load ptr, ptr %key, align 8
  %value8 = load i32, ptr %value, align 4
  call void @"HashMap$String$int.put"(ptr %map6, ptr %key7, i32 %value8)
  ret void
}

define internal i32 @"LinkedHashMap$String$int.get"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %map = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %map1 = load ptr, ptr %map, align 8, !tbaa !0
  %key2 = load ptr, ptr %key, align 8
  %2 = call i32 @"HashMap$String$int.get"(ptr %map1, ptr %key2)
  ret i32 %2
}

define internal i32 @"LinkedHashMap$String$int.containsKey"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %map = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %map1 = load ptr, ptr %map, align 8, !tbaa !0
  %key2 = load ptr, ptr %key, align 8
  %2 = call i32 @"HashMap$String$int.containsKey"(ptr %map1, ptr %key2)
  ret i32 %2
}

define internal i32 @"LinkedHashMap$String$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %map = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %map1 = load ptr, ptr %map, align 8, !tbaa !0
  %1 = call i32 @"HashMap$String$int.size"(ptr %map1)
  ret i32 %1
}

define internal i32 @"LinkedHashMap$String$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %map = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 1
  %map1 = load ptr, ptr %map, align 8, !tbaa !0
  %1 = call i32 @"HashMap$String$int.size"(ptr %map1)
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"LinkedHashMap$String$int.keysInOrder"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %order = getelementptr inbounds %"class.LinkedHashMap$String$int", ptr %0, i32 0, i32 2
  %order1 = load ptr, ptr %order, align 8, !tbaa !0
  ret ptr %order1
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
  call void @__polaron_fail(ptr @.contract.262, ptr @.cl.263, i64 %contract.l, ptr @.cr.264, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.265, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.266, ptr @.faila.267, i64 %19, ptr @.failb.268, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.269, ptr @.faila.270, i64 %22, ptr @.failb.271, i64 %arr.len25, i32 70)
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
  call void @__polaron_fail(ptr @.fail.272, ptr @.faila.273, i64 %16, ptr @.failb.274, i64 %arr.len40, i32 70)
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
  call void @__polaron_fail(ptr @.contract.275, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.276, ptr @.cl.277, i64 %contract.l, ptr @.cr.278, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.279, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.280, ptr @.faila.281, i64 %18, ptr @.failb.282, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.283, ptr @.faila.284, i64 %21, ptr @.failb.285, i64 %arr.len20, i32 70)
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
  call void @__polaron_fail(ptr @.contract.286, ptr @.cl.287, i64 %contract.l, ptr @.cr.288, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.289, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.290, ptr @.faila.291, i64 %13, ptr @.failb.292, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.293, ptr @.faila.294, i64 %14, ptr @.failb.295, i64 %arr.len18, i32 70)
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
  call void @__polaron_fail(ptr @.fail.296, ptr @.faila.297, i64 %14, ptr @.failb.298, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.299, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.300, ptr @.faila.301, i64 %15, ptr @.failb.302, i64 %arr.len24, i32 70)
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
  call void @__polaron_fail(ptr @.contract.303, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.304, ptr @.faila.305, i64 %9, ptr @.failb.306, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.307, ptr @.faila.308, i64 %13, ptr @.failb.309, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.310, ptr @.cl.311, i64 %contract.l, ptr @.cr.312, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.313, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.314, ptr @.faila.315, i64 %23, ptr @.failb.316, i64 %arr.len34, i32 70)
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
  call void @__polaron_fail(ptr @.fail.317, ptr @.faila.318, i64 %30, ptr @.failb.319, i64 %arr.len43, i32 70)
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
  call void @__polaron_fail(ptr @.contract.320, ptr @.cl.321, i64 %contract.l61, ptr @.cr.322, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.323, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.324, ptr @.faila.325, i64 %14, ptr @.failb.326, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.327, ptr @.cl.328, i64 %contract.l, ptr @.cr.329, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.330, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.331, ptr @.faila.332, i64 %32, ptr @.failb.333, i64 %arr.len44, i32 70)
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
  call void @__polaron_fail(ptr @.fail.334, ptr @.faila.335, i64 %35, ptr @.failb.336, i64 %arr.len53, i32 70)
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
  call void @__polaron_fail(ptr @.fail.337, ptr @.faila.338, i64 %42, ptr @.failb.339, i64 %arr.len76, i32 70)
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
  call void @__polaron_fail(ptr @.fail.340, ptr @.faila.341, i64 %47, ptr @.failb.342, i64 %arr.len85, i32 70)
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
  call void @__polaron_fail(ptr @.fail.343, ptr @.faila.344, i64 %45, ptr @.failb.345, i64 %arr.len96, i32 70)
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
  call void @__polaron_fail(ptr @.contract.346, ptr @.cl.347, i64 %contract.l114, ptr @.cr.348, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.349, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.350, ptr @.cl.351, i64 %contract.l, ptr @.cr.352, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.353, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.354, ptr @.faila.355, i64 %12, ptr @.failb.356, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.357, ptr @.faila.358, i64 %15, ptr @.failb.359, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.fail.360, ptr @.faila.361, i64 %10, ptr @.failb.362, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.363, ptr @.faila.364, i64 %10, ptr @.failb.365, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.366, ptr @.faila.367, i64 %15, ptr @.failb.368, i64 %arr.len20, i32 70)
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
  call void @__polaron_fail(ptr @.fail.369, ptr @.faila.370, i64 %10, ptr @.failb.371, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.372, ptr @.faila.373, i64 %10, ptr @.failb.374, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.375, ptr @.faila.376, i64 %10, ptr @.failb.377, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.378, ptr @.faila.379, i64 %9, ptr @.failb.380, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.381, ptr @.cl.382, i64 %contract.l, ptr @.cr.383, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.384, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.385, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.386, ptr @.faila.387, i64 %25, ptr @.failb.388, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.389, ptr @.faila.390, i64 %38, ptr @.failb.391, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.392, ptr @.faila.393, i64 %34, ptr @.failb.394, i64 %arr.len41, i32 70)
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
  call void @__polaron_fail(ptr @.fail.395, ptr @.faila.396, i64 %43, ptr @.failb.397, i64 %arr.len50, i32 70)
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
  call void @__polaron_fail(ptr @.fail.398, ptr @.faila.399, i64 %36, ptr @.failb.400, i64 %arr.len62, i32 70)
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
  call void @__polaron_fail(ptr @.contract.401, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.402, ptr @.faila.403, i64 %51, ptr @.failb.404, i64 %arr.len95, i32 70)
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
  call void @__polaron_fail(ptr @.fail.405, ptr @.faila.406, i64 %53, ptr @.failb.407, i64 %arr.len105, i32 70)
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
  call void @__polaron_fail(ptr @.contract.408, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.409, ptr @.faila.410, i64 %64, ptr @.failb.411, i64 %arr.len143, i32 70)
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
  call void @__polaron_fail(ptr @.fail.412, ptr @.faila.413, i64 %68, ptr @.failb.414, i64 %arr.len153, i32 70)
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
  call void @__polaron_fail(ptr @.fail.415, ptr @.faila.416, i64 %72, ptr @.failb.417, i64 %arr.len164, i32 70)
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
  call void @__polaron_fail(ptr @.fail.418, ptr @.faila.419, i64 %75, ptr @.failb.420, i64 %arr.len173, i32 70)
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
  call void @__polaron_fail(ptr @.fail.421, ptr @.faila.422, i64 %73, ptr @.failb.423, i64 %arr.len184, i32 70)
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
  call void @__polaron_fail(ptr @.fail.424, ptr @.faila.425, i64 %78, ptr @.failb.426, i64 %arr.len193, i32 70)
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
  call void @__polaron_fail(ptr @.fail.427, ptr @.faila.428, i64 %83, ptr @.failb.429, i64 %arr.len210, i32 70)
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
  call void @__polaron_fail(ptr @.fail.430, ptr @.faila.431, i64 %84, ptr @.failb.432, i64 %arr.len219, i32 70)
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
  call void @__polaron_fail(ptr @.fail.433, ptr @.faila.434, i64 %90, ptr @.failb.435, i64 %arr.len236, i32 70)
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
  call void @__polaron_fail(ptr @.fail.436, ptr @.faila.437, i64 %91, ptr @.failb.438, i64 %arr.len245, i32 70)
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
  call void @__polaron_fail(ptr @.fail.439, ptr @.faila.440, i64 %97, ptr @.failb.441, i64 %arr.len265, i32 70)
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
  call void @__polaron_fail(ptr @.fail.442, ptr @.faila.443, i64 %102, ptr @.failb.444, i64 %arr.len273, i32 70)
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
  call void @__polaron_fail(ptr @.contract.445, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.446, ptr @.faila.447, i64 %10, ptr @.failb.448, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.449, ptr @.faila.450, i64 %15, ptr @.failb.451, i64 %arr.len16, i32 70)
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
  call void @__polaron_fail(ptr @.fail.452, ptr @.faila.453, i64 0, ptr @.failb.454, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.455, ptr @.faila.456, i64 %12, ptr @.failb.457, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.fail.458, ptr @.faila.459, i64 %19, ptr @.failb.460, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.461, ptr @.faila.462, i64 0, ptr @.failb.463, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.464, ptr @.faila.465, i64 %12, ptr @.failb.466, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.fail.467, ptr @.faila.468, i64 %19, ptr @.failb.469, i64 %arr.len30, i32 70)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1529)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1531)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5530)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5532)
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

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare void @__polaron_free(ptr)

declare i64 @__polaron_str_hash_obj(ptr)

declare i32 @strcmp(ptr, ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @memcpy(ptr, ptr, i64)

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
