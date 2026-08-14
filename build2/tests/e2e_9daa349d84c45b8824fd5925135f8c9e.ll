; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/trie_graph.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/trie_graph.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Trie = type { ptr, ptr, ptr, i32, i32 }
%class.Graph = type { ptr, i32, ptr, ptr }
%"class.Queue$int" = type { ptr, ptr, i32, i32 }
%class.DivideByZeroException = type { ptr }
%"class.ArrayList$int" = type { ptr, ptr, i32 }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$int" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"Queue$int.vtable" = private constant [349 x ptr] [ptr @"Queue$int.enqueue", ptr @"Queue$int.dequeue", ptr @"Queue$int.peek", ptr @"Queue$int.toArray", ptr @"Queue$int.size", ptr @"Queue$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Queue$int.~Queue$int"]
@"ArrayList$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$int.toArray", ptr @"ArrayList$int.size", ptr @"ArrayList$int.isEmpty", ptr null, ptr null, ptr null, ptr @"ArrayList$int.get", ptr null, ptr null, ptr null, ptr @"ArrayList$int.remove", ptr null, ptr null, ptr @"ArrayList$int.add", ptr @"ArrayList$int.ensureCapacity", ptr @"ArrayList$int.set", ptr @"ArrayList$int.indexOf", ptr @"ArrayList$int.contains", ptr @"ArrayList$int.removeAt", ptr @"ArrayList$int.insertAt", ptr @"ArrayList$int.clear", ptr @"ArrayList$int.forEach", ptr @"ArrayList$int.filter", ptr @"ArrayList$int.any", ptr @"ArrayList$int.all", ptr @"ArrayList$int.count", ptr @"ArrayList$int.sortedBy", ptr @"ArrayList$int.mergeSortRange", ptr @"ArrayList$int.find", ptr @"ArrayList$int.min", ptr @"ArrayList$int.max", ptr @"ArrayList$int.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$int.~ArrayList$int"]
@"ArrayListIterator$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$int.hasNext", ptr @"ArrayListIterator$int.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Trie.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Trie.contains, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Trie.ensure, ptr @Trie.insert, ptr @Trie.startsWith, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Graph.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Graph.addEdge, ptr @Graph.distance, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [4 x i8] c"cat\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [4 x i8] c"car\00"
@.strobj.2 = private global %String { i64 3, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [4 x i8] c"dog\00"
@.strobj.4 = private global %String { i64 3, ptr @.strdata.3, i64 0 }
@.str = private unnamed_addr constant [42 x i8] c"cat=%d ca=%d pre=%d cab=%d d03=%d d05=%d\0A\00", align 1
@.strdata.5 = private constant [4 x i8] c"cat\00"
@.strobj.6 = private global %String { i64 3, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [3 x i8] c"ca\00"
@.strobj.8 = private global %String { i64 2, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [3 x i8] c"ca\00"
@.strobj.10 = private global %String { i64 2, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [4 x i8] c"cab\00"
@.strobj.12 = private global %String { i64 3, ptr @.strdata.11, i64 0 }
@.contract = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.Queue$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.13 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.Queue$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.14 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.Queue$int\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.15 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.16 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.17 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.Queue$int\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:712:35  in Queue$int.enqueue\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.18 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:712:35  in Queue$int.enqueue\0A\00", align 1
@.faila.19 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.20 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.21 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:718:74  in Queue$int.enqueue\0A\00", align 1
@.faila.22 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.23 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.24 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.enqueue\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.25 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.26 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.27 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.enqueue\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.28 = private unnamed_addr constant [107 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.enqueue\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.29 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.30 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.31 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.enqueue\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.32 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:722:17  in Queue$int.dequeue\0A\00", align 1
@.faila.33 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.34 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.35 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.dequeue\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.36 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.37 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.38 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.dequeue\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.39 = private unnamed_addr constant [107 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.dequeue\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.40 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.41 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.42 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.dequeue\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.43 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:727:46  in Queue$int.peek\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:731:28  in Queue$int.toArray\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:731:28  in Queue$int.toArray\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.892 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.ArrayList$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.893 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.894 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.895 = private unnamed_addr constant [135 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.ArrayList$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.896 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$int.add\0A\00", align 1
@.faila.897 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.898 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.899 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$int.add\0A\00", align 1
@.faila.900 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.901 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.902 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$int.add\0A\00", align 1
@.faila.903 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.904 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.905 = private unnamed_addr constant [121 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$int.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.906 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.907 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.908 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.909 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.910 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$int.ensureCapacity\0A\00", align 1
@.faila.911 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.912 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.913 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$int.ensureCapacity\0A\00", align 1
@.faila.914 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.915 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.916 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.917 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.918 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.919 = private unnamed_addr constant [136 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.920 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$int.get\0A\00", align 1
@.faila.921 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.922 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.923 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$int.get\0A\00", align 1
@.faila.924 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.925 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.926 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$int.set\0A\00", align 1
@.faila.927 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.928 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.929 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.930 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$int.set\0A\00", align 1
@.faila.931 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.932 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.933 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.934 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$int.indexOf\0A\00", align 1
@.faila.935 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.936 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.937 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$int.removeAt\0A\00", align 1
@.faila.938 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.939 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.940 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.941 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.942 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.943 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.944 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$int.removeAt\0A\00", align 1
@.faila.945 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.946 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.947 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$int.removeAt\0A\00", align 1
@.faila.948 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.949 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.950 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.951 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.952 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.953 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.954 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$int.insertAt\0A\00", align 1
@.faila.955 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.956 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.957 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.958 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.959 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.960 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.961 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$int.insertAt\0A\00", align 1
@.faila.962 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.963 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.964 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$int.insertAt\0A\00", align 1
@.faila.965 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.966 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.967 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$int.insertAt\0A\00", align 1
@.faila.968 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.969 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.970 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$int.insertAt\0A\00", align 1
@.faila.971 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.972 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.973 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$int.insertAt\0A\00", align 1
@.faila.974 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.975 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.976 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.977 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.978 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.979 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.980 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.981 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.982 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.983 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.984 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$int.toArray\0A\00", align 1
@.faila.985 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.986 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.987 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$int.toArray\0A\00", align 1
@.faila.988 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.989 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.990 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$int.forEach\0A\00", align 1
@.faila.991 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.992 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.993 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$int.filter\0A\00", align 1
@.faila.994 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.995 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.996 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$int.filter\0A\00", align 1
@.faila.997 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.998 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.999 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$int.any\0A\00", align 1
@.faila.1000 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1001 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1002 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$int.all\0A\00", align 1
@.faila.1003 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1004 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1005 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$int.count\0A\00", align 1
@.faila.1006 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1007 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1008 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$int.sortedBy\0A\00", align 1
@.faila.1009 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1010 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1011 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$int.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1012 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1013 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1014 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1015 = private unnamed_addr constant [136 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1016 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1017 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1018 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1019 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1020 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1021 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1022 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1023 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1024 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1025 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1026 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1027 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1028 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1029 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1030 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1031 = private unnamed_addr constant [136 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1032 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1033 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1034 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1035 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1036 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1037 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1038 = private unnamed_addr constant [136 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1039 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1040 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1041 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1042 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1043 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1044 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1045 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1046 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1047 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1048 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1049 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1050 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1051 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1052 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1053 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1054 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1055 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1056 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1057 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1058 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1059 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1060 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1061 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1062 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1063 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1064 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1065 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1066 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1067 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1068 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1069 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1070 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1071 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1072 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$int.mergeSortRange\0A\00", align 1
@.faila.1073 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1074 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1075 = private unnamed_addr constant [136 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$int.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1076 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$int.find\0A\00", align 1
@.faila.1077 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1078 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1079 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$int.find\0A\00", align 1
@.faila.1080 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1081 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1082 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$int.min\0A\00", align 1
@.faila.1083 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1084 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1085 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$int.min\0A\00", align 1
@.faila.1086 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1087 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1088 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$int.min\0A\00", align 1
@.faila.1089 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1090 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1091 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$int.max\0A\00", align 1
@.faila.1092 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1093 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1094 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$int.max\0A\00", align 1
@.faila.1095 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1096 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1097 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$int.max\0A\00", align 1
@.faila.1098 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1099 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1318 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1319 = private global %String { i64 16, ptr @.strdata.1318, i64 0 }
@.strdata.1320 = private constant [17 x i8] c"division by zero\00"
@.strobj.1321 = private global %String { i64 16, ptr @.strdata.1320, i64 0 }
@.fail.1496 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1755:73  in Trie.ensure\0A\00", align 1
@.faila.1497 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1498 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1499 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1755:73  in Trie.ensure\0A\00", align 1
@.faila.1500 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1501 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1502 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1756:68  in Trie.ensure\0A\00", align 1
@.faila.1503 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1504 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1505 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1756:68  in Trie.ensure\0A\00", align 1
@.faila.1506 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1507 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1508 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1766:21  in Trie.insert\0A\00", align 1
@.faila.1509 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1510 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1511 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1768:50  in Trie.insert\0A\00", align 1
@.faila.1512 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1513 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1514 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1771:26  in Trie.insert\0A\00", align 1
@.faila.1515 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1516 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1517 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1773:35  in Trie.insert\0A\00", align 1
@.faila.1518 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1519 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1520 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1780:21  in Trie.contains\0A\00", align 1
@.faila.1521 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1522 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1523 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1781:26  in Trie.contains\0A\00", align 1
@.faila.1524 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1525 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1526 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1783:17  in Trie.contains\0A\00", align 1
@.faila.1527 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1528 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1529 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1789:21  in Trie.startsWith\0A\00", align 1
@.faila.1530 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1531 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1532 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1790:26  in Trie.startsWith\0A\00", align 1
@.faila.1533 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1534 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1535 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1814:68  in Graph.distance\0A\00", align 1
@.faila.1536 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1537 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1538 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1816:27  in Graph.distance\0A\00", align 1
@.faila.1539 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1540 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1541 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1824:25  in Graph.distance\0A\00", align 1
@.faila.1542 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1543 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1544 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1825:37  in Graph.distance\0A\00", align 1
@.faila.1545 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1546 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1547 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1825:37  in Graph.distance\0A\00", align 1
@.faila.1548 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1549 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1550 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1830:17  in Graph.distance\0A\00", align 1
@.faila.1551 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1552 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5319 = private constant [1 x i8] zeroinitializer
@.strobj.5320 = private global %String { i64 0, ptr @.strdata.5319, i64 0 }
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %t = alloca ptr, align 8
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
  %Trie.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Trie, ptr null, i64 1) to i64))
  call void @Trie.Trie(ptr %Trie.obj)
  store ptr %Trie.obj, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  call void @Trie.insert(ptr %t1, ptr @.strobj)
  %t2 = load ptr, ptr %t, align 8
  call void @Trie.insert(ptr %t2, ptr @.strobj.2)
  %t3 = load ptr, ptr %t, align 8
  call void @Trie.insert(ptr %t3, ptr @.strobj.4)
  %Graph.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Graph, ptr null, i64 1) to i64))
  call void @Graph.Graph(ptr %Graph.obj, i32 6)
  store ptr %Graph.obj, ptr %g, align 8
  %g4 = load ptr, ptr %g, align 8
  call void @Graph.addEdge(ptr %g4, i32 0, i32 1)
  %g5 = load ptr, ptr %g, align 8
  call void @Graph.addEdge(ptr %g5, i32 1, i32 2)
  %g6 = load ptr, ptr %g, align 8
  call void @Graph.addEdge(ptr %g6, i32 2, i32 3)
  %g7 = load ptr, ptr %g, align 8
  call void @Graph.addEdge(ptr %g7, i32 0, i32 4)
  %g8 = load ptr, ptr %g, align 8
  call void @Graph.addEdge(ptr %g8, i32 4, i32 3)
  %t9 = load ptr, ptr %t, align 8
  %16 = call i32 @Trie.contains(ptr %t9, ptr @.strobj.6)
  %t10 = load ptr, ptr %t, align 8
  %17 = call i32 @Trie.contains(ptr %t10, ptr @.strobj.8)
  %t11 = load ptr, ptr %t, align 8
  %18 = call i32 @Trie.startsWith(ptr %t11, ptr @.strobj.10)
  %t12 = load ptr, ptr %t, align 8
  %19 = call i32 @Trie.contains(ptr %t12, ptr @.strobj.12)
  %g13 = load ptr, ptr %g, align 8
  %20 = call i32 @Graph.distance(ptr %g13, i32 0, i32 3)
  %g14 = load ptr, ptr %g, align 8
  %21 = call i32 @Graph.distance(ptr %g14, i32 0, i32 5)
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21)
  ret i32 0
}

define internal void @"Queue$int.Queue$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 0
  store ptr @"Queue$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head, align 4, !tbaa !4
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.13, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  %head13 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head14 = load i32, ptr %head13, align 4, !tbaa !4
  %7 = icmp sge i32 %head14, 0
  %8 = zext i1 %7 to i32
  %contract.ok15 = icmp ne i32 %8, 0
  br i1 %contract.ok15, label %contract.cont17, label %contract.fail16

contract.fail16:                                  ; preds = %contract.cont12
  %head18 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head19 = load i32, ptr %head18, align 4, !tbaa !4
  %contract.l20 = sext i32 %head19 to i64
  call void @__polaron_fail(ptr @.contract.14, ptr @.cl.15, i64 %contract.l20, ptr @.cr.16, i64 0, i32 1)
  unreachable

contract.cont17:                                  ; preds = %contract.cont12
  %head21 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head22 = load i32, ptr %head21, align 4, !tbaa !4
  %data23 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data24 = load ptr, ptr %data23, align 8, !tbaa !0
  %len25 = load i64, ptr %data24, align 8
  %9 = trunc i64 %len25 to i32
  %10 = icmp slt i32 %head22, %9
  %11 = zext i1 %10 to i32
  %contract.ok26 = icmp ne i32 %11, 0
  br i1 %contract.ok26, label %contract.cont28, label %contract.fail27

contract.fail27:                                  ; preds = %contract.cont17
  call void @__polaron_fail(ptr @.contract.17, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont28:                                  ; preds = %contract.cont17
  ret void
}

define internal void @"Queue$int.~Queue$int"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"Queue$int.enqueue"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown59 = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %7 = icmp sge i32 %head6, 0
  %8 = zext i1 %7 to i32
  %inv.assume7 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %9 = trunc i64 %len12 to i32
  %10 = icmp slt i32 %head9, %9
  %11 = zext i1 %10 to i32
  %inv.assume13 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume13)
  %count14 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %data16 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data17 = load ptr, ptr %data16, align 8, !tbaa !0
  %len18 = load i64, ptr %data17, align 8
  %12 = trunc i64 %len18 to i32
  %13 = icmp sge i32 %count15, %12
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data19 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data20 = load ptr, ptr %data19, align 8, !tbaa !0
  %len21 = load i64, ptr %data20, align 8
  %15 = trunc i64 %len21 to i32
  %16 = mul i32 %15, 2
  %17 = sext i32 %16 to i64
  %18 = mul i64 %17, 4
  %19 = add i64 8, %18
  %arr = call ptr @__polaron_malloc(i64 %19)
  store i64 %17, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %20 = call ptr @memset(ptr %arr.data, i32 0, i64 %18)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %for.end, %entry
  %data47 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head49 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head50 = load i32, ptr %head49, align 4, !tbaa !4
  %count51 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %21 = add i32 %head50, %count52
  %data53 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data54 = load ptr, ptr %data53, align 8, !tbaa !0
  %len55 = load i64, ptr %data54, align 8
  %22 = trunc i64 %len55 to i32
  %23 = icmp eq i32 %22, 0
  %24 = icmp eq i32 %21, -2147483648
  %25 = icmp eq i32 %22, -1
  %26 = and i1 %24, %25
  %27 = or i1 %23, %26
  br i1 %27, label %div.bad56, label %div.ok57

for.cond:                                         ; preds = %for.update, %if.then
  %i22 = load i32, ptr %i, align 4
  %count23 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count24 = load i32, ptr %count23, align 4, !tbaa !4
  %28 = icmp slt i32 %i22, %count24
  %29 = zext i1 %28 to i32
  br i1 %28, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger25 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %30 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %bigger25, align 8
  %arr.oob = icmp uge i64 %30, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok39
  %31 = load i32, ptr %i, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data42 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data43 = load ptr, ptr %data42, align 8, !tbaa !0
  call void @__polaron_free(ptr %data43)
  %data44 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %bigger45 = load ptr, ptr %bigger, align 8
  store ptr %bigger45, ptr %data44, align 8, !tbaa !0
  %head46 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head46, align 4, !tbaa !4
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %30, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data27 = getelementptr i8, ptr %bigger25, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data27, i64 %30
  %data28 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data29 = load ptr, ptr %data28, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head30 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head31 = load i32, ptr %head30, align 4, !tbaa !4
  %i32 = load i32, ptr %i, align 4
  %33 = add i32 %head31, %i32
  %data33 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0
  %len35 = load i64, ptr %data34, align 8
  %34 = trunc i64 %len35 to i32
  %35 = icmp eq i32 %34, 0
  %36 = icmp eq i32 %33, -2147483648
  %37 = icmp eq i32 %34, -1
  %38 = and i1 %36, %37
  %39 = or i1 %35, %38
  br i1 %39, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %40 = srem i32 %33, %34
  %41 = sext i32 %40 to i64
  %arr.len36 = load i64, ptr %data29, align 8
  %arr.oob37 = icmp uge i64 %41, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !8

idx.bad38:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.18, ptr @.faila.19, i64 %41, ptr @.failb.20, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %div.ok
  %arr.data40 = getelementptr i8, ptr %data29, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %41
  %elem = load i32, ptr %arr.elem41, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

div.bad56:                                        ; preds = %if.end
  %exc58 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc58)
  store ptr %exc58, ptr %exc.thrown59, align 8
  call void @_CxxThrowException(ptr %exc.thrown59, ptr @_TI1PEAX)
  unreachable

div.ok57:                                         ; preds = %if.end
  %42 = srem i32 %21, %22
  %43 = sext i32 %42 to i64
  %arr.len60 = load i64, ptr %data48, align 8
  %arr.oob61 = icmp uge i64 %43, %arr.len60
  br i1 %arr.oob61, label %idx.bad62, label %idx.ok63, !prof !8

idx.bad62:                                        ; preds = %div.ok57
  call void @__polaron_fail(ptr @.fail.21, ptr @.faila.22, i64 %43, ptr @.failb.23, i64 %arr.len60, i32 70)
  unreachable

idx.ok63:                                         ; preds = %div.ok57
  %arr.data64 = getelementptr i8, ptr %data48, i64 8
  %arr.elem65 = getelementptr inbounds i32, ptr %arr.data64, i64 %43
  %item66 = load i32, ptr %item, align 4
  store i32 %item66, ptr %arr.elem65, align 4
  %count67 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count68 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count69 = load i32, ptr %count68, align 4, !tbaa !4
  %44 = add i32 %count69, 1
  store i32 %44, ptr %count67, align 4, !tbaa !4
  %count70 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count71 = load i32, ptr %count70, align 4, !tbaa !4
  %45 = icmp sge i32 %count71, 0
  %46 = zext i1 %45 to i32
  %contract.ok = icmp ne i32 %46, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok63
  %count72 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count73 = load i32, ptr %count72, align 4, !tbaa !4
  %contract.l = sext i32 %count73 to i64
  call void @__polaron_fail(ptr @.contract.24, ptr @.cl.25, i64 %contract.l, ptr @.cr.26, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok63
  %count74 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count75 = load i32, ptr %count74, align 4, !tbaa !4
  %data76 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data77 = load ptr, ptr %data76, align 8, !tbaa !0
  %len78 = load i64, ptr %data77, align 8
  %47 = trunc i64 %len78 to i32
  %48 = icmp sle i32 %count75, %47
  %49 = zext i1 %48 to i32
  %contract.ok79 = icmp ne i32 %49, 0
  br i1 %contract.ok79, label %contract.cont81, label %contract.fail80

contract.fail80:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.27, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont81:                                  ; preds = %contract.cont
  %head82 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head83 = load i32, ptr %head82, align 4, !tbaa !4
  %50 = icmp sge i32 %head83, 0
  %51 = zext i1 %50 to i32
  %contract.ok84 = icmp ne i32 %51, 0
  br i1 %contract.ok84, label %contract.cont86, label %contract.fail85

contract.fail85:                                  ; preds = %contract.cont81
  %head87 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head88 = load i32, ptr %head87, align 4, !tbaa !4
  %contract.l89 = sext i32 %head88 to i64
  call void @__polaron_fail(ptr @.contract.28, ptr @.cl.29, i64 %contract.l89, ptr @.cr.30, i64 0, i32 1)
  unreachable

contract.cont86:                                  ; preds = %contract.cont81
  %head90 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head91 = load i32, ptr %head90, align 4, !tbaa !4
  %data92 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data93 = load ptr, ptr %data92, align 8, !tbaa !0
  %len94 = load i64, ptr %data93, align 8
  %52 = trunc i64 %len94 to i32
  %53 = icmp slt i32 %head91, %52
  %54 = zext i1 %53 to i32
  %contract.ok95 = icmp ne i32 %54, 0
  br i1 %contract.ok95, label %contract.cont97, label %contract.fail96

contract.fail96:                                  ; preds = %contract.cont86
  call void @__polaron_fail(ptr @.contract.31, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont97:                                  ; preds = %contract.cont86
  ret void
}

define internal i32 @"Queue$int.dequeue"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %v = alloca i32, align 4
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %6 = icmp sge i32 %head6, 0
  %7 = zext i1 %6 to i32
  %inv.assume7 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %head9, %8
  %10 = zext i1 %9 to i32
  %inv.assume13 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume13)
  %data14 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head16 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head17 = load i32, ptr %head16, align 4, !tbaa !4
  %11 = sext i32 %head17 to i64
  %arr.len = load i64, ptr %data15, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.32, ptr @.faila.33, i64 %11, ptr @.failb.34, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data15, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %11
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %v, align 4
  %head18 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head19 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head20 = load i32, ptr %head19, align 4, !tbaa !4
  %12 = add i32 %head20, 1
  %data21 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %13 = trunc i64 %len23 to i32
  %14 = icmp eq i32 %13, 0
  %15 = icmp eq i32 %12, -2147483648
  %16 = icmp eq i32 %13, -1
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
  %19 = srem i32 %12, %13
  store i32 %19, ptr %head18, align 4, !tbaa !4
  %count24 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count25 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count26 = load i32, ptr %count25, align 4, !tbaa !4
  %20 = sub i32 %count26, 1
  store i32 %20, ptr %count24, align 4, !tbaa !4
  %v27 = load i32, ptr %v, align 4
  %count28 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %21 = icmp sge i32 %count29, 0
  %22 = zext i1 %21 to i32
  %contract.ok = icmp ne i32 %22, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %div.ok
  %count30 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %contract.l = sext i32 %count31 to i64
  call void @__polaron_fail(ptr @.contract.35, ptr @.cl.36, i64 %contract.l, ptr @.cr.37, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %div.ok
  %count32 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %data34 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data35 = load ptr, ptr %data34, align 8, !tbaa !0
  %len36 = load i64, ptr %data35, align 8
  %23 = trunc i64 %len36 to i32
  %24 = icmp sle i32 %count33, %23
  %25 = zext i1 %24 to i32
  %contract.ok37 = icmp ne i32 %25, 0
  br i1 %contract.ok37, label %contract.cont39, label %contract.fail38

contract.fail38:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.38, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont39:                                  ; preds = %contract.cont
  %head40 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head41 = load i32, ptr %head40, align 4, !tbaa !4
  %26 = icmp sge i32 %head41, 0
  %27 = zext i1 %26 to i32
  %contract.ok42 = icmp ne i32 %27, 0
  br i1 %contract.ok42, label %contract.cont44, label %contract.fail43

contract.fail43:                                  ; preds = %contract.cont39
  %head45 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head46 = load i32, ptr %head45, align 4, !tbaa !4
  %contract.l47 = sext i32 %head46 to i64
  call void @__polaron_fail(ptr @.contract.39, ptr @.cl.40, i64 %contract.l47, ptr @.cr.41, i64 0, i32 1)
  unreachable

contract.cont44:                                  ; preds = %contract.cont39
  %head48 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head49 = load i32, ptr %head48, align 4, !tbaa !4
  %data50 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0
  %len52 = load i64, ptr %data51, align 8
  %28 = trunc i64 %len52 to i32
  %29 = icmp slt i32 %head49, %28
  %30 = zext i1 %29 to i32
  %contract.ok53 = icmp ne i32 %30, 0
  br i1 %contract.ok53, label %contract.cont55, label %contract.fail54

contract.fail54:                                  ; preds = %contract.cont44
  call void @__polaron_fail(ptr @.contract.42, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont55:                                  ; preds = %contract.cont44
  ret i32 %v27
}

define internal i32 @"Queue$int.peek"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %6 = icmp sge i32 %head6, 0
  %7 = zext i1 %6 to i32
  %inv.assume7 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %head9, %8
  %10 = zext i1 %9 to i32
  %inv.assume13 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume13)
  %data14 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head16 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head17 = load i32, ptr %head16, align 4, !tbaa !4
  %11 = sext i32 %head17 to i64
  %arr.len = load i64, ptr %data15, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 %11, ptr @.failb.45, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data15, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %11
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @"Queue$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %6 = icmp sge i32 %head6, 0
  %7 = zext i1 %6 to i32
  %inv.assume7 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %head9, %8
  %10 = zext i1 %9 to i32
  %inv.assume13 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume13)
  %count14 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %11 = sext i32 %count15 to i64
  %12 = mul i64 %11, 4
  %13 = add i64 8, %12
  %arr = call ptr @__polaron_malloc(i64 %13)
  store i64 %11, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %14 = call ptr @memset(ptr %arr.data, i32 0, i64 %12)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %15 = icmp slt i32 %i16, %count18
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out19 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %17 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %out19, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok33
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out36 = load ptr, ptr %out, align 8
  ret ptr %out36

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 %17, ptr @.failb.48, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %out19, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data21, i64 %17
  %data22 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head24 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head25 = load i32, ptr %head24, align 4, !tbaa !4
  %i26 = load i32, ptr %i, align 4
  %20 = add i32 %head25, %i26
  %data27 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0
  %len29 = load i64, ptr %data28, align 8
  %21 = trunc i64 %len29 to i32
  %22 = icmp eq i32 %21, 0
  %23 = icmp eq i32 %20, -2147483648
  %24 = icmp eq i32 %21, -1
  %25 = and i1 %23, %24
  %26 = or i1 %22, %25
  br i1 %26, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %27 = srem i32 %20, %21
  %28 = sext i32 %27 to i64
  %arr.len30 = load i64, ptr %data23, align 8
  %arr.oob31 = icmp uge i64 %28, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

idx.bad32:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 %28, ptr @.failb.51, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %div.ok
  %arr.data34 = getelementptr i8, ptr %data23, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %28
  %elem = load i32, ptr %arr.elem35, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @"Queue$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %6 = icmp sge i32 %head6, 0
  %7 = zext i1 %6 to i32
  %inv.assume7 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %head9, %8
  %10 = zext i1 %9 to i32
  %inv.assume13 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume13)
  %count14 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  ret i32 %count15
}

define internal i32 @"Queue$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %head = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head6 = load i32, ptr %head, align 4, !tbaa !4
  %6 = icmp sge i32 %head6, 0
  %7 = zext i1 %6 to i32
  %inv.assume7 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume7)
  %head8 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %8 = trunc i64 %len12 to i32
  %9 = icmp slt i32 %head9, %8
  %10 = zext i1 %9 to i32
  %inv.assume13 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume13)
  %count14 = getelementptr inbounds %"class.Queue$int", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %11 = icmp eq i32 %count15, 0
  %12 = zext i1 %11 to i32
  ret i32 %12
}

define internal void @"ArrayList$int.ArrayList$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.892, ptr @.cl.893, i64 %contract.l, ptr @.cr.894, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.895, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$int.~ArrayList$int"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"ArrayList$int.add"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %7 = trunc i64 %len12 to i32
  %8 = icmp sge i32 %count9, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %10 = trunc i64 %len15 to i32
  %11 = mul i32 %10, 2
  %12 = sext i32 %11 to i64
  %13 = mul i64 %12, 4
  %14 = add i64 8, %13
  %arr = call ptr @__polaron_malloc(i64 %14)
  store i64 %12, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %15 = call ptr @memset(ptr %arr.data, i32 0, i64 %13)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %for.end, %entry
  %data35 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count37 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count38 = load i32, ptr %count37, align 4, !tbaa !4
  %16 = sext i32 %count38 to i64
  %arr.len39 = load i64, ptr %data36, align 8
  %arr.oob40 = icmp uge i64 %16, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  %data31 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  call void @__polaron_free(ptr %data32)
  %data33 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %bigger34 = load ptr, ptr %bigger, align 8
  store ptr %bigger34, ptr %data33, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.896, ptr @.faila.897, i64 %19, ptr @.failb.898, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data21, i64 %19
  %data22 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %22 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %22, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.899, ptr @.faila.900, i64 %22, ptr @.failb.901, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 %22
  %elem = load i32, ptr %arr.elem30, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

idx.bad41:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.902, ptr @.faila.903, i64 %16, ptr @.failb.904, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %if.end
  %arr.data43 = getelementptr i8, ptr %data36, i64 8
  %arr.elem44 = getelementptr inbounds i32, ptr %arr.data43, i64 %16
  %item45 = load i32, ptr %item, align 4
  store i32 %item45, ptr %arr.elem44, align 4
  %count46 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count47 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count48 = load i32, ptr %count47, align 4, !tbaa !4
  %23 = add i32 %count48, 1
  store i32 %23, ptr %count46, align 4, !tbaa !4
  %count49 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count50 = load i32, ptr %count49, align 4, !tbaa !4
  %old51 = load i32, ptr %old, align 4
  %24 = add i32 %old51, 1
  %25 = icmp eq i32 %count50, %24
  %26 = zext i1 %25 to i32
  %contract.ok = icmp ne i32 %26, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok42
  call void @__polaron_fail(ptr @.contract.905, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok42
  %count52 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %27 = icmp sge i32 %count53, 0
  %28 = zext i1 %27 to i32
  %contract.ok54 = icmp ne i32 %28, 0
  br i1 %contract.ok54, label %contract.cont56, label %contract.fail55

contract.fail55:                                  ; preds = %contract.cont
  %count57 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count58 = load i32, ptr %count57, align 4, !tbaa !4
  %contract.l = sext i32 %count58 to i64
  call void @__polaron_fail(ptr @.contract.906, ptr @.cl.907, i64 %contract.l, ptr @.cr.908, i64 0, i32 1)
  unreachable

contract.cont56:                                  ; preds = %contract.cont
  %count59 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %data61 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data62 = load ptr, ptr %data61, align 8, !tbaa !0
  %len63 = load i64, ptr %data62, align 8
  %29 = trunc i64 %len63 to i32
  %30 = icmp sle i32 %count60, %29
  %31 = zext i1 %30 to i32
  %contract.ok64 = icmp ne i32 %31, 0
  br i1 %contract.ok64, label %contract.cont66, label %contract.fail65

contract.fail65:                                  ; preds = %contract.cont56
  call void @__polaron_fail(ptr @.contract.909, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont66:                                  ; preds = %contract.cont56
  ret void
}

define internal void @"ArrayList$int.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !0
  %len9 = load i64, ptr %data8, align 8
  %7 = trunc i64 %len9 to i32
  %8 = icmp sgt i32 %n6, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n10 = load i32, ptr %n, align 4
  %10 = sext i32 %n10 to i64
  %11 = mul i64 %10, 4
  %12 = add i64 8, %11
  %arr = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %13 = call ptr @memset(ptr %arr.data, i32 0, i64 %11)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %for.end, %entry
  %count30 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %14 = icmp sge i32 %count31, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  %data26 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  call void @__polaron_free(ptr %data27)
  %data28 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %bigger29 = load ptr, ptr %bigger, align 8
  store ptr %bigger29, ptr %data28, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.910, ptr @.faila.911, i64 %18, ptr @.failb.912, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.913, ptr @.faila.914, i64 %21, ptr @.failb.915, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %21
  %elem = load i32, ptr %arr.elem25, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

contract.fail:                                    ; preds = %if.end
  %count32 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %contract.l = sext i32 %count33 to i64
  call void @__polaron_fail(ptr @.contract.916, ptr @.cl.917, i64 %contract.l, ptr @.cr.918, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count34 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count35 = load i32, ptr %count34, align 4, !tbaa !4
  %data36 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0
  %len38 = load i64, ptr %data37, align 8
  %22 = trunc i64 %len38 to i32
  %23 = icmp sle i32 %count35, %22
  %24 = zext i1 %23 to i32
  %contract.ok39 = icmp ne i32 %24, 0
  br i1 %contract.ok39, label %contract.cont41, label %contract.fail40

contract.fail40:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.919, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont41:                                  ; preds = %contract.cont
  ret void
}

define internal i32 @"ArrayList$int.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.920, ptr @.faila.921, i64 %13, ptr @.failb.922, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %13
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.923, ptr @.faila.924, i64 %14, ptr @.failb.925, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds i32, ptr %arr.data22, i64 %14
  %elem24 = load i32, ptr %arr.elem23, align 4
  ret i32 %elem24
}

define internal void @"ArrayList$int.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %item = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i32 %2, ptr %item, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data21 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %15 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %data22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.926, ptr @.faila.927, i64 %14, ptr @.failb.928, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %14
  %item15 = load i32, ptr %item, align 4
  store i32 %item15, ptr %arr.elem, align 4
  %count16 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %data18 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0
  %len20 = load i64, ptr %data19, align 8
  %16 = trunc i64 %len20 to i32
  %17 = icmp sle i32 %count17, %16
  %18 = zext i1 %17 to i32
  %contract.ok = icmp ne i32 %18, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.929, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.930, ptr @.faila.931, i64 %15, ptr @.failb.932, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %if.end
  %arr.data28 = getelementptr i8, ptr %data22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %15
  %item30 = load i32, ptr %item, align 4
  store i32 %item30, ptr %arr.elem29, align 4
  %count31 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %data33 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0
  %len35 = load i64, ptr %data34, align 8
  %19 = trunc i64 %len35 to i32
  %20 = icmp sle i32 %count32, %19
  %21 = zext i1 %20 to i32
  %contract.ok36 = icmp ne i32 %21, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.contract.933, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %idx.ok27
  ret void
}

define internal i32 @"ArrayList$int.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.934, ptr @.faila.935, i64 %9, ptr @.failb.936, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %9
  %elem = load i32, ptr %arr.elem, align 4
  %item12 = load i32, ptr %item, align 4
  %12 = icmp eq i32 %elem, %item12
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i13 = load i32, ptr %i, align 4
  ret i32 %i13

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$int.contains"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load i32, ptr %item, align 4
  %7 = call i32 @"ArrayList$int.indexOf"(ptr %0, i32 %item6)
  %8 = icmp sge i32 %7, 0
  %9 = zext i1 %8 to i32
  ret i32 %9
}

define internal void @"ArrayList$int.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.937, ptr @.faila.938, i64 %13, ptr @.failb.939, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %13
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %oob, align 4
  %count15 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %14 = icmp sge i32 %count16, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.940, ptr @.cl.941, i64 %contract.l, ptr @.cr.942, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %data21 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %16 = trunc i64 %len23 to i32
  %17 = icmp sle i32 %count20, %16
  %18 = zext i1 %17 to i32
  %contract.ok24 = icmp ne i32 %18, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.943, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %19 = sub i32 %count30, 1
  %20 = icmp slt i32 %j28, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j33 = load i32, ptr %j, align 4
  %22 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %22, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

for.update:                                       ; preds = %idx.ok46
  %23 = load i32, ptr %j, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count50 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count51 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %25 = sub i32 %count52, 1
  store i32 %25, ptr %count50, align 4, !tbaa !4
  %count53 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count54 = load i32, ptr %count53, align 4, !tbaa !4
  %26 = icmp sge i32 %count54, 0
  %27 = zext i1 %26 to i32
  %contract.ok55 = icmp ne i32 %27, 0
  br i1 %contract.ok55, label %contract.cont57, label %contract.fail56

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.944, ptr @.faila.945, i64 %22, ptr @.failb.946, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %22
  %data40 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j42 = load i32, ptr %j, align 4
  %28 = add i32 %j42, 1
  %29 = sext i32 %28 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %29, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.947, ptr @.faila.948, i64 %29, ptr @.failb.949, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %data41, i64 8
  %arr.elem48 = getelementptr inbounds i32, ptr %arr.data47, i64 %29
  %elem49 = load i32, ptr %arr.elem48, align 4
  store i32 %elem49, ptr %arr.elem39, align 4
  br label %for.update

contract.fail56:                                  ; preds = %for.end
  %count58 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count59 = load i32, ptr %count58, align 4, !tbaa !4
  %contract.l60 = sext i32 %count59 to i64
  call void @__polaron_fail(ptr @.contract.950, ptr @.cl.951, i64 %contract.l60, ptr @.cr.952, i64 0, i32 1)
  unreachable

contract.cont57:                                  ; preds = %for.end
  %count61 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count62 = load i32, ptr %count61, align 4, !tbaa !4
  %data63 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !0
  %len65 = load i64, ptr %data64, align 8
  %30 = trunc i64 %len65 to i32
  %31 = icmp sle i32 %count62, %30
  %32 = zext i1 %31 to i32
  %contract.ok66 = icmp ne i32 %32, 0
  br i1 %contract.ok66, label %contract.cont68, label %contract.fail67

contract.fail67:                                  ; preds = %contract.cont57
  call void @__polaron_fail(ptr @.contract.953, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont68:                                  ; preds = %contract.cont57
  ret void
}

define internal void @"ArrayList$int.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i32 %2, ptr %item, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count28 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %data30 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0
  %len32 = load i64, ptr %data31, align 8
  %15 = trunc i64 %len32 to i32
  %16 = icmp sge i32 %count29, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then33, label %if.end34

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.954, ptr @.faila.955, i64 %14, ptr @.failb.956, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %14
  %item15 = load i32, ptr %item, align 4
  store i32 %item15, ptr %arr.elem, align 4
  %count16 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %18 = icmp sge i32 %count17, 0
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count18 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !4
  %contract.l = sext i32 %count19 to i64
  call void @__polaron_fail(ptr @.contract.957, ptr @.cl.958, i64 %contract.l, ptr @.cr.959, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %data22 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0
  %len24 = load i64, ptr %data23, align 8
  %20 = trunc i64 %len24 to i32
  %21 = icmp sle i32 %count21, %20
  %22 = zext i1 %21 to i32
  %contract.ok25 = icmp ne i32 %22, 0
  br i1 %contract.ok25, label %contract.cont27, label %contract.fail26

contract.fail26:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.960, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont27:                                  ; preds = %contract.cont
  ret void

if.then33:                                        ; preds = %if.end
  %data35 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0
  %len37 = load i64, ptr %data36, align 8
  %23 = trunc i64 %len37 to i32
  %24 = mul i32 %23, 2
  %25 = sext i32 %24 to i64
  %26 = mul i64 %25, 4
  %27 = add i64 8, %26
  %arr = call ptr @__polaron_malloc(i64 %27)
  store i64 %25, ptr %arr, align 8
  %arr.data38 = getelementptr i8, ptr %arr, i64 8
  %28 = call ptr @memset(ptr %arr.data38, i32 0, i64 %26)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

if.end34:                                         ; preds = %for.end, %if.end
  %count63 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count64 = load i32, ptr %count63, align 4, !tbaa !4
  store i32 %count64, ptr %j, align 4
  br label %for.cond65

for.cond:                                         ; preds = %for.update, %if.then33
  %k39 = load i32, ptr %k, align 4
  %count40 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %29 = icmp slt i32 %k39, %count41
  %30 = zext i1 %29 to i32
  br i1 %29, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger42 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k43 = load i32, ptr %k, align 4
  %31 = sext i32 %k43 to i64
  %arr.len44 = load i64, ptr %bigger42, align 8
  %arr.oob45 = icmp uge i64 %31, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !8

for.update:                                       ; preds = %idx.ok56
  %32 = load i32, ptr %k, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data59 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !0
  call void @__polaron_free(ptr %data60)
  %data61 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %bigger62 = load ptr, ptr %bigger, align 8
  store ptr %bigger62, ptr %data61, align 8, !tbaa !0
  br label %if.end34

idx.bad46:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.961, ptr @.faila.962, i64 %31, ptr @.failb.963, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body
  %arr.data48 = getelementptr i8, ptr %bigger42, i64 8
  %arr.elem49 = getelementptr inbounds i32, ptr %arr.data48, i64 %31
  %data50 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k52 = load i32, ptr %k, align 4
  %34 = sext i32 %k52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %34, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.964, ptr @.faila.965, i64 %34, ptr @.failb.966, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %data51, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %34
  %elem = load i32, ptr %arr.elem58, align 4
  store i32 %elem, ptr %arr.elem49, align 4
  br label %for.update

for.cond65:                                       ; preds = %for.update67, %if.end34
  %j69 = load i32, ptr %j, align 4
  %i70 = load i32, ptr %i, align 4
  %35 = icmp sgt i32 %j69, %i70
  %36 = zext i1 %35 to i32
  br i1 %35, label %for.body66, label %for.end68

for.body66:                                       ; preds = %for.cond65
  %data71 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data72 = load ptr, ptr %data71, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j73 = load i32, ptr %j, align 4
  %37 = sext i32 %j73 to i64
  %arr.len74 = load i64, ptr %data72, align 8
  %arr.oob75 = icmp uge i64 %37, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !8

for.update67:                                     ; preds = %idx.ok86
  %38 = load i32, ptr %j, align 4
  %39 = sub i32 %38, 1
  store i32 %39, ptr %j, align 4
  br label %for.cond65

for.end68:                                        ; preds = %for.cond65
  %data90 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i92 = load i32, ptr %i, align 4
  %40 = sext i32 %i92 to i64
  %arr.len93 = load i64, ptr %data91, align 8
  %arr.oob94 = icmp uge i64 %40, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !8

idx.bad76:                                        ; preds = %for.body66
  call void @__polaron_fail(ptr @.fail.967, ptr @.faila.968, i64 %37, ptr @.failb.969, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %for.body66
  %arr.data78 = getelementptr i8, ptr %data72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %37
  %data80 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data81 = load ptr, ptr %data80, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j82 = load i32, ptr %j, align 4
  %41 = sub i32 %j82, 1
  %42 = sext i32 %41 to i64
  %arr.len83 = load i64, ptr %data81, align 8
  %arr.oob84 = icmp uge i64 %42, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !8

idx.bad85:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.970, ptr @.faila.971, i64 %42, ptr @.failb.972, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok77
  %arr.data87 = getelementptr i8, ptr %data81, i64 8
  %arr.elem88 = getelementptr inbounds i32, ptr %arr.data87, i64 %42
  %elem89 = load i32, ptr %arr.elem88, align 4
  store i32 %elem89, ptr %arr.elem79, align 4
  br label %for.update67

idx.bad95:                                        ; preds = %for.end68
  call void @__polaron_fail(ptr @.fail.973, ptr @.faila.974, i64 %40, ptr @.failb.975, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %for.end68
  %arr.data97 = getelementptr i8, ptr %data91, i64 8
  %arr.elem98 = getelementptr inbounds i32, ptr %arr.data97, i64 %40
  %item99 = load i32, ptr %item, align 4
  store i32 %item99, ptr %arr.elem98, align 4
  %count100 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count101 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count102 = load i32, ptr %count101, align 4, !tbaa !4
  %43 = add i32 %count102, 1
  store i32 %43, ptr %count100, align 4, !tbaa !4
  %count103 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count104 = load i32, ptr %count103, align 4, !tbaa !4
  %44 = icmp sge i32 %count104, 0
  %45 = zext i1 %44 to i32
  %contract.ok105 = icmp ne i32 %45, 0
  br i1 %contract.ok105, label %contract.cont107, label %contract.fail106

contract.fail106:                                 ; preds = %idx.ok96
  %count108 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count109 = load i32, ptr %count108, align 4, !tbaa !4
  %contract.l110 = sext i32 %count109 to i64
  call void @__polaron_fail(ptr @.contract.976, ptr @.cl.977, i64 %contract.l110, ptr @.cr.978, i64 0, i32 1)
  unreachable

contract.cont107:                                 ; preds = %idx.ok96
  %count111 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count112 = load i32, ptr %count111, align 4, !tbaa !4
  %data113 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data114 = load ptr, ptr %data113, align 8, !tbaa !0
  %len115 = load i64, ptr %data114, align 8
  %46 = trunc i64 %len115 to i32
  %47 = icmp sle i32 %count112, %46
  %48 = zext i1 %47 to i32
  %contract.ok116 = icmp ne i32 %48, 0
  br i1 %contract.ok116, label %contract.cont118, label %contract.fail117

contract.fail117:                                 ; preds = %contract.cont107
  call void @__polaron_fail(ptr @.contract.979, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont118:                                 ; preds = %contract.cont107
  ret void
}

define internal i32 @"ArrayList$int.remove"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load i32, ptr %item, align 4
  %7 = call i32 @"ArrayList$int.indexOf"(ptr %0, i32 %item6)
  store i32 %7, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %8 = icmp slt i32 %i7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %i8 = load i32, ptr %i, align 4
  call void @"ArrayList$int.removeAt"(ptr %0, i32 %i8)
  ret i32 1
}

define internal void @"ArrayList$int.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.980, ptr @.cl.981, i64 %contract.l, ptr @.cr.982, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.983, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = sext i32 %count7 to i64
  %7 = mul i64 %6, 4
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
  %count9 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.984, ptr @.faila.985, i64 %12, ptr @.failb.986, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.987, ptr @.faila.988, i64 %15, ptr @.failb.989, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %15
  %elem = load i32, ptr %arr.elem22, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @"ArrayList$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$int.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.990, ptr @.faila.991, i64 %10, ptr @.failb.992, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  call void %code(ptr %env, i32 %elem)
  br label %for.update
}

define internal ptr @"ArrayList$int.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  call void @"ArrayList$int.ArrayList$int"(ptr %"ArrayList$int.obj")
  store ptr %"ArrayList$int.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$int.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.993, ptr @.faila.994, i64 %10, ptr @.failb.995, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %13 = call i32 %code(ptr %env, i32 %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out16 = load ptr, ptr %out, align 8
  %data17 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.996, ptr @.faila.997, i64 %15, ptr @.failb.998, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %15
  %elem26 = load i32, ptr %arr.elem25, align 4
  call void @"ArrayList$int.add"(ptr %out16, i32 %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$int.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.999, ptr @.faila.1000, i64 %10, ptr @.failb.1001, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %13 = call i32 %code(ptr %env, i32 %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 1

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$int.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1002, ptr @.faila.1003, i64 %10, ptr @.failb.1004, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %13 = call i32 %code(ptr %env, i32 %elem)
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$int.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1005, ptr @.faila.1006, i64 %10, ptr @.failb.1007, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %13 = call i32 %code(ptr %env, i32 %elem)
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

define internal ptr @"ArrayList$int.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  call void @"ArrayList$int.ArrayList$int"(ptr %"ArrayList$int.obj")
  store ptr %"ArrayList$int.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$int.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %12 = call i32 @"ArrayList$int.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1008, ptr @.faila.1009, i64 %9, ptr @.failb.1010, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %9
  %elem = load i32, ptr %arr.elem, align 4
  call void @"ArrayList$int.add"(ptr %out12, i32 %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$int.size"(ptr %out17)
  %16 = sext i32 %15 to i64
  %17 = mul i64 %16, 4
  %18 = add i64 8, %17
  %arr = call ptr @__polaron_malloc(i64 %18)
  store i64 %16, ptr %arr, align 8
  %arr.data18 = getelementptr i8, ptr %arr, i64 8
  %19 = call ptr @memset(ptr %arr.data18, i32 0, i64 %17)
  store ptr %arr, ptr %scratch, align 8
  %out19 = load ptr, ptr %out, align 8
  %scratch20 = load ptr, ptr %scratch, align 8
  %out21 = load ptr, ptr %out, align 8
  %20 = call i32 @"ArrayList$int.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$int.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  call void @__polaron_free(ptr %scratch23)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  %out24 = load ptr, ptr %out, align 8
  %count25 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count26 = load i32, ptr %count25, align 4, !tbaa !4
  %22 = icmp sge i32 %count26, 0
  %23 = zext i1 %22 to i32
  %contract.ok = icmp ne i32 %23, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %if.end
  %count27 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %contract.l = sext i32 %count28 to i64
  call void @__polaron_fail(ptr @.contract.1011, ptr @.cl.1012, i64 %contract.l, ptr @.cr.1013, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count29 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %data31 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  %len33 = load i64, ptr %data32, align 8
  %24 = trunc i64 %len33 to i32
  %25 = icmp sle i32 %count30, %24
  %26 = zext i1 %25 to i32
  %contract.ok34 = icmp ne i32 %26, 0
  br i1 %contract.ok34, label %contract.cont36, label %contract.fail35

contract.fail35:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1014, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont36:                                  ; preds = %contract.cont
  ret ptr %out24
}

define internal void @"ArrayList$int.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %q = alloca i32, align 4
  %key = alloca i32, align 4
  %p = alloca i32, align 4
  %compare = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca ptr, align 8
  store ptr %1, ptr %tmp, align 8
  store i32 %2, ptr %lo, align 4
  store i32 %3, ptr %hi, align 4
  store ptr %4, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.1015, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  ret void

if.then15:                                        ; preds = %if.end
  %lo17 = load i32, ptr %lo, align 4
  %18 = add i32 %lo17, 1
  store i32 %18, ptr %p, align 4
  br label %for.cond

if.end16:                                         ; preds = %if.end
  %lo77 = load i32, ptr %lo, align 4
  %hi78 = load i32, ptr %hi, align 4
  %19 = add i32 %lo77, %hi78
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
  %data20 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok64
  %p68 = load i32, ptr %p, align 4
  %26 = add i32 %p68, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count69 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count70 = load i32, ptr %count69, align 4, !tbaa !4
  %data71 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data72 = load ptr, ptr %data71, align 8, !tbaa !0
  %len73 = load i64, ptr %data72, align 8
  %27 = trunc i64 %len73 to i32
  %28 = icmp sle i32 %count70, %27
  %29 = zext i1 %28 to i32
  %contract.ok74 = icmp ne i32 %29, 0
  br i1 %contract.ok74, label %contract.cont76, label %contract.fail75

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1016, ptr @.faila.1017, i64 %25, ptr @.failb.1018, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %25
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %key, align 4
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
  %data38 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q40 = load i32, ptr %q, align 4
  %33 = add i32 %q40, 1
  %34 = sext i32 %33 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %34, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

while.end:                                        ; preds = %sc.end
  %data58 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data59 = load ptr, ptr %data58, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q60 = load i32, ptr %q, align 4
  %35 = add i32 %q60, 1
  %36 = sext i32 %35 to i64
  %arr.len61 = load i64, ptr %data59, align 8
  %arr.oob62 = icmp uge i64 %36, %arr.len61
  br i1 %arr.oob62, label %idx.bad63, label %idx.ok64, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %37 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %37, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1019, ptr @.faila.1020, i64 %38, ptr @.failb.1021, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %sc.rhs
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %38
  %elem36 = load i32, ptr %arr.elem35, align 4
  %key37 = load i32, ptr %key, align 4
  %40 = call i32 %code(ptr %env, i32 %elem36, i32 %key37)
  %41 = icmp sgt i32 %40, 0
  %42 = zext i1 %41 to i32
  %sc.b = icmp ne i32 %42, 0
  br label %sc.end

idx.bad43:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1022, ptr @.faila.1023, i64 %34, ptr @.failb.1024, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %34
  %data47 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q49 = load i32, ptr %q, align 4
  %43 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %43, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !8

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.1025, ptr @.faila.1026, i64 %43, ptr @.failb.1027, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %data48, i64 8
  %arr.elem55 = getelementptr inbounds i32, ptr %arr.data54, i64 %43
  %elem56 = load i32, ptr %arr.elem55, align 4
  store i32 %elem56, ptr %arr.elem46, align 4
  %q57 = load i32, ptr %q, align 4
  %44 = sub i32 %q57, 1
  store i32 %44, ptr %q, align 4
  br label %while.cond

idx.bad63:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1028, ptr @.faila.1029, i64 %36, ptr @.failb.1030, i64 %arr.len61, i32 70)
  unreachable

idx.ok64:                                         ; preds = %while.end
  %arr.data65 = getelementptr i8, ptr %data59, i64 8
  %arr.elem66 = getelementptr inbounds i32, ptr %arr.data65, i64 %36
  %key67 = load i32, ptr %key, align 4
  store i32 %key67, ptr %arr.elem66, align 4
  br label %for.update

contract.fail75:                                  ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.1031, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont76:                                  ; preds = %for.end
  ret void

div.bad:                                          ; preds = %if.end16
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end16
  %45 = sdiv i32 %19, 2
  store i32 %45, ptr %mid, align 4
  %tmp79 = load ptr, ptr %tmp, align 8
  %lo80 = load i32, ptr %lo, align 4
  %mid81 = load i32, ptr %mid, align 4
  %compare82 = load ptr, ptr %compare, align 8
  call void @"ArrayList$int.mergeSortRange"(ptr %0, ptr %tmp79, i32 %lo80, i32 %mid81, ptr %compare82)
  %tmp83 = load ptr, ptr %tmp, align 8
  %mid84 = load i32, ptr %mid, align 4
  %46 = add i32 %mid84, 1
  %hi85 = load i32, ptr %hi, align 4
  %compare86 = load ptr, ptr %compare, align 8
  call void @"ArrayList$int.mergeSortRange"(ptr %0, ptr %tmp83, i32 %46, i32 %hi85, ptr %compare86)
  %compare87 = load ptr, ptr %compare, align 8
  %code88 = load ptr, ptr %compare87, align 8
  %47 = getelementptr ptr, ptr %compare87, i32 1
  %env89 = load ptr, ptr %47, align 8
  %data90 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid92 = load i32, ptr %mid, align 4
  %48 = sext i32 %mid92 to i64
  %arr.len93 = load i64, ptr %data91, align 8
  %arr.oob94 = icmp uge i64 %48, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !8

idx.bad95:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1032, ptr @.faila.1033, i64 %48, ptr @.failb.1034, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %div.ok
  %arr.data97 = getelementptr i8, ptr %data91, i64 8
  %arr.elem98 = getelementptr inbounds i32, ptr %arr.data97, i64 %48
  %elem99 = load i32, ptr %arr.elem98, align 4
  %data100 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data101 = load ptr, ptr %data100, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid102 = load i32, ptr %mid, align 4
  %49 = add i32 %mid102, 1
  %50 = sext i32 %49 to i64
  %arr.len103 = load i64, ptr %data101, align 8
  %arr.oob104 = icmp uge i64 %50, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !8

idx.bad105:                                       ; preds = %idx.ok96
  call void @__polaron_fail(ptr @.fail.1035, ptr @.faila.1036, i64 %50, ptr @.failb.1037, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %idx.ok96
  %arr.data107 = getelementptr i8, ptr %data101, i64 8
  %arr.elem108 = getelementptr inbounds i32, ptr %arr.data107, i64 %50
  %elem109 = load i32, ptr %arr.elem108, align 4
  %51 = call i32 %code88(ptr %env89, i32 %elem99, i32 %elem109)
  %52 = icmp sle i32 %51, 0
  %53 = zext i1 %52 to i32
  br i1 %52, label %if.then110, label %if.end111

if.then110:                                       ; preds = %idx.ok106
  %count112 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !4
  %data114 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data115 = load ptr, ptr %data114, align 8, !tbaa !0
  %len116 = load i64, ptr %data115, align 8
  %54 = trunc i64 %len116 to i32
  %55 = icmp sle i32 %count113, %54
  %56 = zext i1 %55 to i32
  %contract.ok117 = icmp ne i32 %56, 0
  br i1 %contract.ok117, label %contract.cont119, label %contract.fail118

if.end111:                                        ; preds = %idx.ok106
  %lo120 = load i32, ptr %lo, align 4
  store i32 %lo120, ptr %i, align 4
  %mid121 = load i32, ptr %mid, align 4
  %57 = add i32 %mid121, 1
  store i32 %57, ptr %j, align 4
  %lo122 = load i32, ptr %lo, align 4
  store i32 %lo122, ptr %k, align 4
  br label %while.cond123

contract.fail118:                                 ; preds = %if.then110
  call void @__polaron_fail(ptr @.contract.1038, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont119:                                 ; preds = %if.then110
  ret void

while.cond123:                                    ; preds = %if.end159, %if.end111
  %i126 = load i32, ptr %i, align 4
  %mid127 = load i32, ptr %mid, align 4
  %58 = icmp sle i32 %i126, %mid127
  %59 = zext i1 %58 to i32
  %sc.a128 = icmp ne i32 %59, 0
  br i1 %sc.a128, label %sc.rhs129, label %sc.end130

while.body124:                                    ; preds = %sc.end130
  %compare135 = load ptr, ptr %compare, align 8
  %code136 = load ptr, ptr %compare135, align 8
  %60 = getelementptr ptr, ptr %compare135, i32 1
  %env137 = load ptr, ptr %60, align 8
  %data138 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data139 = load ptr, ptr %data138, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i140 = load i32, ptr %i, align 4
  %61 = sext i32 %i140 to i64
  %arr.len141 = load i64, ptr %data139, align 8
  %arr.oob142 = icmp uge i64 %61, %arr.len141
  br i1 %arr.oob142, label %idx.bad143, label %idx.ok144, !prof !8

while.end125:                                     ; preds = %sc.end130
  br label %while.cond199

sc.rhs129:                                        ; preds = %while.cond123
  %j131 = load i32, ptr %j, align 4
  %hi132 = load i32, ptr %hi, align 4
  %62 = icmp sle i32 %j131, %hi132
  %63 = zext i1 %62 to i32
  %sc.b133 = icmp ne i32 %63, 0
  br label %sc.end130

sc.end130:                                        ; preds = %sc.rhs129, %while.cond123
  %sc134 = phi i1 [ false, %while.cond123 ], [ %sc.b133, %sc.rhs129 ]
  %64 = zext i1 %sc134 to i32
  br i1 %sc134, label %while.body124, label %while.end125

idx.bad143:                                       ; preds = %while.body124
  call void @__polaron_fail(ptr @.fail.1039, ptr @.faila.1040, i64 %61, ptr @.failb.1041, i64 %arr.len141, i32 70)
  unreachable

idx.ok144:                                        ; preds = %while.body124
  %arr.data145 = getelementptr i8, ptr %data139, i64 8
  %arr.elem146 = getelementptr inbounds i32, ptr %arr.data145, i64 %61
  %elem147 = load i32, ptr %arr.elem146, align 4
  %data148 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data149 = load ptr, ptr %data148, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j150 = load i32, ptr %j, align 4
  %65 = sext i32 %j150 to i64
  %arr.len151 = load i64, ptr %data149, align 8
  %arr.oob152 = icmp uge i64 %65, %arr.len151
  br i1 %arr.oob152, label %idx.bad153, label %idx.ok154, !prof !8

idx.bad153:                                       ; preds = %idx.ok144
  call void @__polaron_fail(ptr @.fail.1042, ptr @.faila.1043, i64 %65, ptr @.failb.1044, i64 %arr.len151, i32 70)
  unreachable

idx.ok154:                                        ; preds = %idx.ok144
  %arr.data155 = getelementptr i8, ptr %data149, i64 8
  %arr.elem156 = getelementptr inbounds i32, ptr %arr.data155, i64 %65
  %elem157 = load i32, ptr %arr.elem156, align 4
  %66 = call i32 %code136(ptr %env137, i32 %elem147, i32 %elem157)
  %67 = icmp sle i32 %66, 0
  %68 = zext i1 %67 to i32
  br i1 %67, label %if.then158, label %if.else

if.then158:                                       ; preds = %idx.ok154
  %tmp160 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k161 = load i32, ptr %k, align 4
  %69 = sext i32 %k161 to i64
  %arr.len162 = load i64, ptr %tmp160, align 8
  %arr.oob163 = icmp uge i64 %69, %arr.len162
  br i1 %arr.oob163, label %idx.bad164, label %idx.ok165, !prof !8

if.else:                                          ; preds = %idx.ok154
  %tmp179 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k180 = load i32, ptr %k, align 4
  %70 = sext i32 %k180 to i64
  %arr.len181 = load i64, ptr %tmp179, align 8
  %arr.oob182 = icmp uge i64 %70, %arr.len181
  br i1 %arr.oob182, label %idx.bad183, label %idx.ok184, !prof !8

if.end159:                                        ; preds = %idx.ok193, %idx.ok174
  %k198 = load i32, ptr %k, align 4
  %71 = add i32 %k198, 1
  store i32 %71, ptr %k, align 4
  br label %while.cond123

idx.bad164:                                       ; preds = %if.then158
  call void @__polaron_fail(ptr @.fail.1045, ptr @.faila.1046, i64 %69, ptr @.failb.1047, i64 %arr.len162, i32 70)
  unreachable

idx.ok165:                                        ; preds = %if.then158
  %arr.data166 = getelementptr i8, ptr %tmp160, i64 8
  %arr.elem167 = getelementptr inbounds i32, ptr %arr.data166, i64 %69
  %data168 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data169 = load ptr, ptr %data168, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i170 = load i32, ptr %i, align 4
  %72 = sext i32 %i170 to i64
  %arr.len171 = load i64, ptr %data169, align 8
  %arr.oob172 = icmp uge i64 %72, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !8

idx.bad173:                                       ; preds = %idx.ok165
  call void @__polaron_fail(ptr @.fail.1048, ptr @.faila.1049, i64 %72, ptr @.failb.1050, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %idx.ok165
  %arr.data175 = getelementptr i8, ptr %data169, i64 8
  %arr.elem176 = getelementptr inbounds i32, ptr %arr.data175, i64 %72
  %elem177 = load i32, ptr %arr.elem176, align 4
  store i32 %elem177, ptr %arr.elem167, align 4
  %i178 = load i32, ptr %i, align 4
  %73 = add i32 %i178, 1
  store i32 %73, ptr %i, align 4
  br label %if.end159

idx.bad183:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1051, ptr @.faila.1052, i64 %70, ptr @.failb.1053, i64 %arr.len181, i32 70)
  unreachable

idx.ok184:                                        ; preds = %if.else
  %arr.data185 = getelementptr i8, ptr %tmp179, i64 8
  %arr.elem186 = getelementptr inbounds i32, ptr %arr.data185, i64 %70
  %data187 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data188 = load ptr, ptr %data187, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j189 = load i32, ptr %j, align 4
  %74 = sext i32 %j189 to i64
  %arr.len190 = load i64, ptr %data188, align 8
  %arr.oob191 = icmp uge i64 %74, %arr.len190
  br i1 %arr.oob191, label %idx.bad192, label %idx.ok193, !prof !8

idx.bad192:                                       ; preds = %idx.ok184
  call void @__polaron_fail(ptr @.fail.1054, ptr @.faila.1055, i64 %74, ptr @.failb.1056, i64 %arr.len190, i32 70)
  unreachable

idx.ok193:                                        ; preds = %idx.ok184
  %arr.data194 = getelementptr i8, ptr %data188, i64 8
  %arr.elem195 = getelementptr inbounds i32, ptr %arr.data194, i64 %74
  %elem196 = load i32, ptr %arr.elem195, align 4
  store i32 %elem196, ptr %arr.elem186, align 4
  %j197 = load i32, ptr %j, align 4
  %75 = add i32 %j197, 1
  store i32 %75, ptr %j, align 4
  br label %if.end159

while.cond199:                                    ; preds = %idx.ok218, %while.end125
  %i202 = load i32, ptr %i, align 4
  %mid203 = load i32, ptr %mid, align 4
  %76 = icmp sle i32 %i202, %mid203
  %77 = zext i1 %76 to i32
  br i1 %76, label %while.body200, label %while.end201

while.body200:                                    ; preds = %while.cond199
  %tmp204 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k205 = load i32, ptr %k, align 4
  %78 = sext i32 %k205 to i64
  %arr.len206 = load i64, ptr %tmp204, align 8
  %arr.oob207 = icmp uge i64 %78, %arr.len206
  br i1 %arr.oob207, label %idx.bad208, label %idx.ok209, !prof !8

while.end201:                                     ; preds = %while.cond199
  br label %while.cond224

idx.bad208:                                       ; preds = %while.body200
  call void @__polaron_fail(ptr @.fail.1057, ptr @.faila.1058, i64 %78, ptr @.failb.1059, i64 %arr.len206, i32 70)
  unreachable

idx.ok209:                                        ; preds = %while.body200
  %arr.data210 = getelementptr i8, ptr %tmp204, i64 8
  %arr.elem211 = getelementptr inbounds i32, ptr %arr.data210, i64 %78
  %data212 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data213 = load ptr, ptr %data212, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i214 = load i32, ptr %i, align 4
  %79 = sext i32 %i214 to i64
  %arr.len215 = load i64, ptr %data213, align 8
  %arr.oob216 = icmp uge i64 %79, %arr.len215
  br i1 %arr.oob216, label %idx.bad217, label %idx.ok218, !prof !8

idx.bad217:                                       ; preds = %idx.ok209
  call void @__polaron_fail(ptr @.fail.1060, ptr @.faila.1061, i64 %79, ptr @.failb.1062, i64 %arr.len215, i32 70)
  unreachable

idx.ok218:                                        ; preds = %idx.ok209
  %arr.data219 = getelementptr i8, ptr %data213, i64 8
  %arr.elem220 = getelementptr inbounds i32, ptr %arr.data219, i64 %79
  %elem221 = load i32, ptr %arr.elem220, align 4
  store i32 %elem221, ptr %arr.elem211, align 4
  %i222 = load i32, ptr %i, align 4
  %80 = add i32 %i222, 1
  store i32 %80, ptr %i, align 4
  %k223 = load i32, ptr %k, align 4
  %81 = add i32 %k223, 1
  store i32 %81, ptr %k, align 4
  br label %while.cond199

while.cond224:                                    ; preds = %idx.ok243, %while.end201
  %j227 = load i32, ptr %j, align 4
  %hi228 = load i32, ptr %hi, align 4
  %82 = icmp sle i32 %j227, %hi228
  %83 = zext i1 %82 to i32
  br i1 %82, label %while.body225, label %while.end226

while.body225:                                    ; preds = %while.cond224
  %tmp229 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k230 = load i32, ptr %k, align 4
  %84 = sext i32 %k230 to i64
  %arr.len231 = load i64, ptr %tmp229, align 8
  %arr.oob232 = icmp uge i64 %84, %arr.len231
  br i1 %arr.oob232, label %idx.bad233, label %idx.ok234, !prof !8

while.end226:                                     ; preds = %while.cond224
  %lo249 = load i32, ptr %lo, align 4
  store i32 %lo249, ptr %t, align 4
  br label %for.cond250

idx.bad233:                                       ; preds = %while.body225
  call void @__polaron_fail(ptr @.fail.1063, ptr @.faila.1064, i64 %84, ptr @.failb.1065, i64 %arr.len231, i32 70)
  unreachable

idx.ok234:                                        ; preds = %while.body225
  %arr.data235 = getelementptr i8, ptr %tmp229, i64 8
  %arr.elem236 = getelementptr inbounds i32, ptr %arr.data235, i64 %84
  %data237 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data238 = load ptr, ptr %data237, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j239 = load i32, ptr %j, align 4
  %85 = sext i32 %j239 to i64
  %arr.len240 = load i64, ptr %data238, align 8
  %arr.oob241 = icmp uge i64 %85, %arr.len240
  br i1 %arr.oob241, label %idx.bad242, label %idx.ok243, !prof !8

idx.bad242:                                       ; preds = %idx.ok234
  call void @__polaron_fail(ptr @.fail.1066, ptr @.faila.1067, i64 %85, ptr @.failb.1068, i64 %arr.len240, i32 70)
  unreachable

idx.ok243:                                        ; preds = %idx.ok234
  %arr.data244 = getelementptr i8, ptr %data238, i64 8
  %arr.elem245 = getelementptr inbounds i32, ptr %arr.data244, i64 %85
  %elem246 = load i32, ptr %arr.elem245, align 4
  store i32 %elem246, ptr %arr.elem236, align 4
  %j247 = load i32, ptr %j, align 4
  %86 = add i32 %j247, 1
  store i32 %86, ptr %j, align 4
  %k248 = load i32, ptr %k, align 4
  %87 = add i32 %k248, 1
  store i32 %87, ptr %k, align 4
  br label %while.cond224

for.cond250:                                      ; preds = %for.update252, %while.end226
  %t254 = load i32, ptr %t, align 4
  %hi255 = load i32, ptr %hi, align 4
  %88 = icmp sle i32 %t254, %hi255
  %89 = zext i1 %88 to i32
  br i1 %88, label %for.body251, label %for.end253

for.body251:                                      ; preds = %for.cond250
  %data256 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data257 = load ptr, ptr %data256, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %t258 = load i32, ptr %t, align 4
  %90 = sext i32 %t258 to i64
  %arr.len259 = load i64, ptr %data257, align 8
  %arr.oob260 = icmp uge i64 %90, %arr.len259
  br i1 %arr.oob260, label %idx.bad261, label %idx.ok262, !prof !8

for.update252:                                    ; preds = %idx.ok270
  %t274 = load i32, ptr %t, align 4
  %91 = add i32 %t274, 1
  store i32 %91, ptr %t, align 4
  br label %for.cond250

for.end253:                                       ; preds = %for.cond250
  %count275 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count276 = load i32, ptr %count275, align 4, !tbaa !4
  %data277 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data278 = load ptr, ptr %data277, align 8, !tbaa !0
  %len279 = load i64, ptr %data278, align 8
  %92 = trunc i64 %len279 to i32
  %93 = icmp sle i32 %count276, %92
  %94 = zext i1 %93 to i32
  %contract.ok280 = icmp ne i32 %94, 0
  br i1 %contract.ok280, label %contract.cont282, label %contract.fail281

idx.bad261:                                       ; preds = %for.body251
  call void @__polaron_fail(ptr @.fail.1069, ptr @.faila.1070, i64 %90, ptr @.failb.1071, i64 %arr.len259, i32 70)
  unreachable

idx.ok262:                                        ; preds = %for.body251
  %arr.data263 = getelementptr i8, ptr %data257, i64 8
  %arr.elem264 = getelementptr inbounds i32, ptr %arr.data263, i64 %90
  %tmp265 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %t266 = load i32, ptr %t, align 4
  %95 = sext i32 %t266 to i64
  %arr.len267 = load i64, ptr %tmp265, align 8
  %arr.oob268 = icmp uge i64 %95, %arr.len267
  br i1 %arr.oob268, label %idx.bad269, label %idx.ok270, !prof !8

idx.bad269:                                       ; preds = %idx.ok262
  call void @__polaron_fail(ptr @.fail.1072, ptr @.faila.1073, i64 %95, ptr @.failb.1074, i64 %arr.len267, i32 70)
  unreachable

idx.ok270:                                        ; preds = %idx.ok262
  %arr.data271 = getelementptr i8, ptr %tmp265, i64 8
  %arr.elem272 = getelementptr inbounds i32, ptr %arr.data271, i64 %95
  %elem273 = load i32, ptr %arr.elem272, align 4
  store i32 %elem273, ptr %arr.elem264, align 4
  br label %for.update252

contract.fail281:                                 ; preds = %for.end253
  call void @__polaron_fail(ptr @.contract.1075, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont282:                                 ; preds = %for.end253
  ret void
}

define internal %__polaron_variant @"ArrayList$int.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1076, ptr @.faila.1077, i64 %10, ptr @.failb.1078, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %13 = call i32 %code(ptr %env, i32 %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1079, ptr @.faila.1080, i64 %15, ptr @.failb.1081, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %15
  %elem22 = load i32, ptr %arr.elem21, align 4
  %var.enc.i = zext i32 %elem22 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.i, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$int.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca i32, align 4
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1082, ptr @.faila.1083, i64 0, ptr @.failb.1084, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %best, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %best37 = load i32, ptr %best, align 4
  %var.enc.i = zext i32 %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.i, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1085, ptr @.faila.1086, i64 %12, ptr @.failb.1087, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %12
  %elem23 = load i32, ptr %arr.elem22, align 4
  %best24 = load i32, ptr %best, align 4
  %15 = call i32 %code(ptr %env, i32 %elem23, i32 %best24)
  %16 = icmp slt i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %18 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %18, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1088, ptr @.faila.1089, i64 %18, ptr @.failb.1090, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %18
  %elem36 = load i32, ptr %arr.elem35, align 4
  store i32 %elem36, ptr %best, align 4
  br label %if.end26
}

define internal %__polaron_variant @"ArrayList$int.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca i32, align 4
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1091, ptr @.faila.1092, i64 0, ptr @.failb.1093, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %best, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
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
  %best37 = load i32, ptr %best, align 4
  %var.enc.i = zext i32 %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.i, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1094, ptr @.faila.1095, i64 %12, ptr @.failb.1096, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %12
  %elem23 = load i32, ptr %arr.elem22, align 4
  %best24 = load i32, ptr %best, align 4
  %15 = call i32 %code(ptr %env, i32 %elem23, i32 %best24)
  %16 = icmp sgt i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %18 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %18, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1097, ptr @.faila.1098, i64 %18, ptr @.failb.1099, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %18
  %elem36 = load i32, ptr %arr.elem35, align 4
  store i32 %elem36, ptr %best, align 4
  br label %if.end26
}

define internal ptr @"ArrayList$int.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$int", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$int.ArrayListIterator$int"(ptr %"ArrayListIterator$int.obj", ptr %0)
  ret ptr %"ArrayListIterator$int.obj"
}

define internal void @"ArrayListIterator$int.ArrayListIterator$int"(ptr %0, ptr %1) {
entry:
  %"ArrayList$int.copy" = alloca %"class.ArrayList$int", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$int.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$int", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.ArrayList$int", ptr %"ArrayList$int.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %"ArrayList$int.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$int.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  %9 = call ptr @memcpy(ptr %"ArrayList$int.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %"class.ArrayList$int", ptr %list3, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len5, 4
  %13 = add i64 8, %12
  %arr.copy6 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy6, ptr %11, i64 %13)
  %15 = getelementptr inbounds %"class.ArrayList$int", ptr %"ArrayList$int.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %15, align 8, !tbaa !0
  store ptr %"ArrayList$int.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$int.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$int.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal i32 @"ArrayListIterator$int.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca i32, align 4
  %list = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call i32 @"ArrayList$int.get"(ptr %list1, i32 %pos2)
  store i32 %1, ptr %value, align 4
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$int", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !4
  %value6 = load i32, ptr %value, align 4
  ret i32 %value6
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1319)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1321)
  ret ptr %strcpy
}

define internal void @Trie.Trie(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 0
  store ptr @Trie.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %next = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  store ptr null, ptr %next, align 8, !tbaa !0
  %isWord = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 2
  store ptr null, ptr %isWord, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 4
  store i32 8, ptr %cap, align 4, !tbaa !4
  %next1 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 840)
  store i64 208, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 832)
  store ptr %arr, ptr %next1, align 8, !tbaa !0
  %isWord2 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 8)
  store ptr %arr3, ptr %isWord2, align 8, !tbaa !0
  %nodes = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 3
  store i32 1, ptr %nodes, align 4, !tbaa !4
  ret void
}

define internal void @Trie.ensure(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %i23 = alloca i32, align 4
  %i = alloca i32, align 4
  %nw = alloca ptr, align 8
  %nn = alloca ptr, align 8
  %nc = alloca i32, align 4
  %nodes = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 3
  %nodes1 = load i32, ptr %nodes, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 4
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = icmp slt i32 %nodes1, %cap2
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap3 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap3, align 4, !tbaa !4
  %3 = mul i32 %cap4, 2
  store i32 %3, ptr %nc, align 4
  %nc5 = load i32, ptr %nc, align 4
  %4 = mul i32 %nc5, 26
  %5 = sext i32 %4 to i64
  %6 = mul i64 %5, 4
  %7 = add i64 8, %6
  %arr = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %8 = call ptr @memset(ptr %arr.data, i32 0, i64 %6)
  store ptr %arr, ptr %nn, align 8
  %nc6 = load i32, ptr %nc, align 4
  %9 = sext i32 %nc6 to i64
  %10 = mul i64 %9, 1
  %11 = add i64 8, %10
  %arr7 = call ptr @__polaron_malloc(i64 %11)
  store i64 %9, ptr %arr7, align 8
  %arr.data8 = getelementptr i8, ptr %arr7, i64 8
  %12 = call ptr @memset(ptr %arr.data8, i32 0, i64 %10)
  store ptr %arr7, ptr %nw, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %if.end
  %i9 = load i32, ptr %i, align 4
  %cap10 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %13 = mul i32 %cap11, 26
  %14 = icmp slt i32 %i9, %13
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nn12 = load ptr, ptr %nn, align 8, !nonnull !6, !dereferenceable !7
  %i13 = load i32, ptr %i, align 4
  %16 = sext i32 %i13 to i64
  %arr.len = load i64, ptr %nn12, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok20
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i23, align 4
  br label %for.cond24

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1496, ptr @.faila.1497, i64 %16, ptr @.failb.1498, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data14 = getelementptr i8, ptr %nn12, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data14, i64 %16
  %next = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next15 = load ptr, ptr %next, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %19 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %next15, align 8
  %arr.oob18 = icmp uge i64 %19, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1499, ptr @.faila.1500, i64 %19, ptr @.failb.1501, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %next15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %19
  %elem = load i32, ptr %arr.elem22, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond24:                                       ; preds = %for.update26, %for.end
  %i28 = load i32, ptr %i23, align 4
  %cap29 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 4
  %cap30 = load i32, ptr %cap29, align 4, !tbaa !4
  %20 = icmp slt i32 %i28, %cap30
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body25, label %for.end27

for.body25:                                       ; preds = %for.cond24
  %nw31 = load ptr, ptr %nw, align 8, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i23, align 4
  %22 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %nw31, align 8
  %arr.oob34 = icmp uge i64 %22, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

for.update26:                                     ; preds = %idx.ok44
  %23 = load i32, ptr %i23, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %i23, align 4
  br label %for.cond24

for.end27:                                        ; preds = %for.cond24
  %next48 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %nn49 = load ptr, ptr %nn, align 8
  store ptr %nn49, ptr %next48, align 8, !tbaa !0
  %isWord50 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 2
  %nw51 = load ptr, ptr %nw, align 8
  store ptr %nw51, ptr %isWord50, align 8, !tbaa !0
  %cap52 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 4
  %nc53 = load i32, ptr %nc, align 4
  store i32 %nc53, ptr %cap52, align 4, !tbaa !4
  ret void

idx.bad35:                                        ; preds = %for.body25
  call void @__polaron_fail(ptr @.fail.1502, ptr @.faila.1503, i64 %22, ptr @.failb.1504, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %for.body25
  %arr.data37 = getelementptr i8, ptr %nw31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %22
  %isWord = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 2
  %isWord39 = load ptr, ptr %isWord, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i40 = load i32, ptr %i23, align 4
  %25 = sext i32 %i40 to i64
  %arr.len41 = load i64, ptr %isWord39, align 8
  %arr.oob42 = icmp uge i64 %25, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

idx.bad43:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.1505, ptr @.faila.1506, i64 %25, ptr @.failb.1507, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok36
  %arr.data45 = getelementptr i8, ptr %isWord39, i64 8
  %arr.elem46 = getelementptr inbounds i8, ptr %arr.data45, i64 %25
  %elem47 = load i8, ptr %arr.elem46, align 1
  %26 = zext i8 %elem47 to i32
  %27 = trunc i32 %26 to i8
  store i8 %27, ptr %arr.elem38, align 1
  br label %for.update26
}

define internal void @Trie.insert(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %node = alloca i32, align 4
  %word = alloca ptr, align 8
  store ptr %1, ptr %word, align 8
  store i32 0, ptr %node, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %word2 = load ptr, ptr %word, align 8
  %str.len = getelementptr inbounds %String, ptr %word2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %word3 = load ptr, ptr %word, align 8
  %i4 = load i32, ptr %i, align 4
  %5 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %word3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = sub i32 %6, 97
  store i32 %7, ptr %c, align 4
  %next = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next5 = load ptr, ptr %next, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node6 = load i32, ptr %node, align 4
  %8 = mul i32 %node6, 26
  %c7 = load i32, ptr %c, align 4
  %9 = add i32 %8, %c7
  %10 = sext i32 %9 to i64
  %arr.len = load i64, ptr %next5, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok29
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %isWord = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 2
  %isWord33 = load ptr, ptr %isWord, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node34 = load i32, ptr %node, align 4
  %13 = sext i32 %node34 to i64
  %arr.len35 = load i64, ptr %isWord33, align 8
  %arr.oob36 = icmp uge i64 %13, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !8

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1508, ptr @.faila.1509, i64 %10, ptr @.failb.1510, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %next5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %14 = icmp eq i32 %elem, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  call void @Trie.ensure(ptr %0)
  %next8 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next9 = load ptr, ptr %next8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node10 = load i32, ptr %node, align 4
  %16 = mul i32 %node10, 26
  %c11 = load i32, ptr %c, align 4
  %17 = add i32 %16, %c11
  %18 = sext i32 %17 to i64
  %arr.len12 = load i64, ptr %next9, align 8
  %arr.oob13 = icmp uge i64 %18, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !8

if.end:                                           ; preds = %idx.ok15, %idx.ok
  %next22 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next23 = load ptr, ptr %next22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node24 = load i32, ptr %node, align 4
  %19 = mul i32 %node24, 26
  %c25 = load i32, ptr %c, align 4
  %20 = add i32 %19, %c25
  %21 = sext i32 %20 to i64
  %arr.len26 = load i64, ptr %next23, align 8
  %arr.oob27 = icmp uge i64 %21, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !8

idx.bad14:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1511, ptr @.faila.1512, i64 %18, ptr @.failb.1513, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %if.then
  %arr.data16 = getelementptr i8, ptr %next9, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %18
  %nodes = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 3
  %nodes18 = load i32, ptr %nodes, align 4, !tbaa !4
  store i32 %nodes18, ptr %arr.elem17, align 4
  %nodes19 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 3
  %nodes20 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 3
  %nodes21 = load i32, ptr %nodes20, align 4, !tbaa !4
  %22 = add i32 %nodes21, 1
  store i32 %22, ptr %nodes19, align 4, !tbaa !4
  br label %if.end

idx.bad28:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1514, ptr @.faila.1515, i64 %21, ptr @.failb.1516, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %if.end
  %arr.data30 = getelementptr i8, ptr %next23, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %21
  %elem32 = load i32, ptr %arr.elem31, align 4
  store i32 %elem32, ptr %node, align 4
  br label %for.update

idx.bad37:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1517, ptr @.faila.1518, i64 %13, ptr @.failb.1519, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %for.end
  %arr.data39 = getelementptr i8, ptr %isWord33, i64 8
  %arr.elem40 = getelementptr inbounds i8, ptr %arr.data39, i64 %13
  store i8 1, ptr %arr.elem40, align 1
  ret void
}

define internal i32 @Trie.contains(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %node = alloca i32, align 4
  %word = alloca ptr, align 8
  store ptr %1, ptr %word, align 8
  store i32 0, ptr %node, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %word2 = load ptr, ptr %word, align 8
  %str.len = getelementptr inbounds %String, ptr %word2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %word3 = load ptr, ptr %word, align 8
  %i4 = load i32, ptr %i, align 4
  %5 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %word3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = sub i32 %6, 97
  store i32 %7, ptr %c, align 4
  %next = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next5 = load ptr, ptr %next, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node6 = load i32, ptr %node, align 4
  %8 = mul i32 %node6, 26
  %c7 = load i32, ptr %c, align 4
  %9 = add i32 %8, %c7
  %10 = sext i32 %9 to i64
  %arr.len = load i64, ptr %next5, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok15
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %isWord = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 2
  %isWord19 = load ptr, ptr %isWord, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node20 = load i32, ptr %node, align 4
  %13 = sext i32 %node20 to i64
  %arr.len21 = load i64, ptr %isWord19, align 8
  %arr.oob22 = icmp uge i64 %13, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1520, ptr @.faila.1521, i64 %10, ptr @.failb.1522, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %next5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %14 = icmp eq i32 %elem, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  %next8 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next9 = load ptr, ptr %next8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node10 = load i32, ptr %node, align 4
  %16 = mul i32 %node10, 26
  %c11 = load i32, ptr %c, align 4
  %17 = add i32 %16, %c11
  %18 = sext i32 %17 to i64
  %arr.len12 = load i64, ptr %next9, align 8
  %arr.oob13 = icmp uge i64 %18, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !8

idx.bad14:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1523, ptr @.faila.1524, i64 %18, ptr @.failb.1525, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %if.end
  %arr.data16 = getelementptr i8, ptr %next9, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %18
  %elem18 = load i32, ptr %arr.elem17, align 4
  store i32 %elem18, ptr %node, align 4
  br label %for.update

idx.bad23:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1526, ptr @.faila.1527, i64 %13, ptr @.failb.1528, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %for.end
  %arr.data25 = getelementptr i8, ptr %isWord19, i64 8
  %arr.elem26 = getelementptr inbounds i8, ptr %arr.data25, i64 %13
  %elem27 = load i8, ptr %arr.elem26, align 1
  %19 = zext i8 %elem27 to i32
  ret i32 %19
}

define internal i32 @Trie.startsWith(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %i = alloca i32, align 4
  %node = alloca i32, align 4
  %prefix = alloca ptr, align 8
  store ptr %1, ptr %prefix, align 8
  store i32 0, ptr %node, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %prefix2 = load ptr, ptr %prefix, align 8
  %str.len = getelementptr inbounds %String, ptr %prefix2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %prefix3 = load ptr, ptr %prefix, align 8
  %i4 = load i32, ptr %i, align 4
  %5 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %prefix3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = sub i32 %6, 97
  store i32 %7, ptr %c, align 4
  %next = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next5 = load ptr, ptr %next, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node6 = load i32, ptr %node, align 4
  %8 = mul i32 %node6, 26
  %c7 = load i32, ptr %c, align 4
  %9 = add i32 %8, %c7
  %10 = sext i32 %9 to i64
  %arr.len = load i64, ptr %next5, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok15
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1529, ptr @.faila.1530, i64 %10, ptr @.failb.1531, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %next5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %elem = load i32, ptr %arr.elem, align 4
  %13 = icmp eq i32 %elem, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  %next8 = getelementptr inbounds %class.Trie, ptr %0, i32 0, i32 1
  %next9 = load ptr, ptr %next8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %node10 = load i32, ptr %node, align 4
  %15 = mul i32 %node10, 26
  %c11 = load i32, ptr %c, align 4
  %16 = add i32 %15, %c11
  %17 = sext i32 %16 to i64
  %arr.len12 = load i64, ptr %next9, align 8
  %arr.oob13 = icmp uge i64 %17, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !8

idx.bad14:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1532, ptr @.faila.1533, i64 %17, ptr @.failb.1534, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %if.end
  %arr.data16 = getelementptr i8, ptr %next9, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %17
  %elem18 = load i32, ptr %arr.elem17, align 4
  store i32 %elem18, ptr %node, align 4
  br label %for.update
}

define internal void @Graph.Graph(ptr %0, i32 %1) {
entry:
  %vertices = alloca i32, align 4
  store i32 %1, ptr %vertices, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 0
  store ptr @Graph.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %eu = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 2
  store ptr null, ptr %eu, align 8, !tbaa !0
  %ev = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 3
  store ptr null, ptr %ev, align 8, !tbaa !0
  %n = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 1
  %vertices1 = load i32, ptr %vertices, align 4
  store i32 %vertices1, ptr %n, align 4, !tbaa !4
  %eu2 = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 2
  %"ArrayList$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  call void @"ArrayList$int.ArrayList$int"(ptr %"ArrayList$int.obj")
  store ptr %"ArrayList$int.obj", ptr %eu2, align 8, !tbaa !0
  %ev3 = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 3
  %"ArrayList$int.obj4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$int", ptr null, i64 1) to i64))
  call void @"ArrayList$int.ArrayList$int"(ptr %"ArrayList$int.obj4")
  store ptr %"ArrayList$int.obj4", ptr %ev3, align 8, !tbaa !0
  ret void
}

define internal void @Graph.addEdge(ptr nonnull align 8 dereferenceable(32) %0, i32 %1, i32 %2) {
entry:
  %v = alloca i32, align 4
  %u = alloca i32, align 4
  store i32 %1, ptr %u, align 4
  store i32 %2, ptr %v, align 4
  %eu = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 2
  %eu1 = load ptr, ptr %eu, align 8, !tbaa !0
  %u2 = load i32, ptr %u, align 4
  call void @"ArrayList$int.add"(ptr %eu1, i32 %u2)
  %ev = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 3
  %ev3 = load ptr, ptr %ev, align 8, !tbaa !0
  %v4 = load i32, ptr %v, align 4
  call void @"ArrayList$int.add"(ptr %ev3, i32 %v4)
  ret void
}

define internal i32 @Graph.distance(ptr nonnull align 8 dereferenceable(32) %0, i32 %1, i32 %2) {
entry:
  %a = alloca i32, align 4
  %i20 = alloca i32, align 4
  %u = alloca i32, align 4
  %q = alloca ptr, align 8
  %i = alloca i32, align 4
  %dist = alloca ptr, align 8
  %dst = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 %1, ptr %src, align 4
  store i32 %2, ptr %dst, align 4
  %n = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  %3 = sext i32 %n1 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %dist, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 1
  %n4 = load i32, ptr %n3, align 4, !tbaa !4
  %7 = icmp slt i32 %i2, %n4
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %dist5 = load ptr, ptr %dist, align 8, !nonnull !6, !dereferenceable !7
  %i6 = load i32, ptr %i, align 4
  %9 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %dist5, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %"Queue$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Queue$int", ptr null, i64 1) to i64))
  call void @"Queue$int.Queue$int"(ptr %"Queue$int.obj")
  store ptr %"Queue$int.obj", ptr %q, align 8
  %dist8 = load ptr, ptr %dist, align 8, !nonnull !6, !dereferenceable !7
  %src9 = load i32, ptr %src, align 4
  %12 = sext i32 %src9 to i64
  %arr.len10 = load i64, ptr %dist8, align 8
  %arr.oob11 = icmp uge i64 %12, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1535, ptr @.faila.1536, i64 %9, ptr @.failb.1537, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %dist5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 %9
  store i32 -1, ptr %arr.elem, align 4
  br label %for.update

idx.bad12:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1538, ptr @.faila.1539, i64 %12, ptr @.failb.1540, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %for.end
  %arr.data14 = getelementptr i8, ptr %dist8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %12
  store i32 0, ptr %arr.elem15, align 4
  %q16 = load ptr, ptr %q, align 8
  %src17 = load i32, ptr %src, align 4
  call void @"Queue$int.enqueue"(ptr %q16, i32 %src17)
  br label %while.cond

while.cond:                                       ; preds = %for.end24, %idx.ok13
  %q18 = load ptr, ptr %q, align 8
  %13 = call i32 @"Queue$int.isEmpty"(ptr %q18)
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %q19 = load ptr, ptr %q, align 8
  %16 = call i32 @"Queue$int.dequeue"(ptr %q19)
  store i32 %16, ptr %u, align 4
  store i32 0, ptr %i20, align 4
  br label %for.cond21

while.end:                                        ; preds = %while.cond
  %dist72 = load ptr, ptr %dist, align 8, !nonnull !6, !dereferenceable !7
  %dst73 = load i32, ptr %dst, align 4
  %17 = sext i32 %dst73 to i64
  %arr.len74 = load i64, ptr %dist72, align 8
  %arr.oob75 = icmp uge i64 %17, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !8

for.cond21:                                       ; preds = %for.update23, %while.body
  %i25 = load i32, ptr %i20, align 4
  %eu = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 2
  %eu26 = load ptr, ptr %eu, align 8, !tbaa !0
  %18 = call i32 @"ArrayList$int.size"(ptr %eu26)
  %19 = icmp slt i32 %i25, %18
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  store i32 -1, ptr %a, align 4
  %eu27 = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 2
  %eu28 = load ptr, ptr %eu27, align 8, !tbaa !0
  %i29 = load i32, ptr %i20, align 4
  %21 = call i32 @"ArrayList$int.get"(ptr %eu28, i32 %i29)
  %u30 = load i32, ptr %u, align 4
  %22 = icmp eq i32 %21, %u30
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then, label %if.else

for.update23:                                     ; preds = %if.end52
  %24 = load i32, ptr %i20, align 4
  %25 = add i32 %24, 1
  store i32 %25, ptr %i20, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  br label %while.cond

if.then:                                          ; preds = %for.body22
  %ev = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 3
  %ev31 = load ptr, ptr %ev, align 8, !tbaa !0
  %i32 = load i32, ptr %i20, align 4
  %26 = call i32 @"ArrayList$int.get"(ptr %ev31, i32 %i32)
  store i32 %26, ptr %a, align 4
  br label %if.end

if.else:                                          ; preds = %for.body22
  %ev33 = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 3
  %ev34 = load ptr, ptr %ev33, align 8, !tbaa !0
  %i35 = load i32, ptr %i20, align 4
  %27 = call i32 @"ArrayList$int.get"(ptr %ev34, i32 %i35)
  %u36 = load i32, ptr %u, align 4
  %28 = icmp eq i32 %27, %u36
  %29 = zext i1 %28 to i32
  br i1 %28, label %if.then37, label %if.end38

if.end:                                           ; preds = %if.end38, %if.then
  %a42 = load i32, ptr %a, align 4
  %30 = icmp sge i32 %a42, 0
  %31 = zext i1 %30 to i32
  %sc.a = icmp ne i32 %31, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

if.then37:                                        ; preds = %if.else
  %eu39 = getelementptr inbounds %class.Graph, ptr %0, i32 0, i32 2
  %eu40 = load ptr, ptr %eu39, align 8, !tbaa !0
  %i41 = load i32, ptr %i20, align 4
  %32 = call i32 @"ArrayList$int.get"(ptr %eu40, i32 %i41)
  store i32 %32, ptr %a, align 4
  br label %if.end38

if.end38:                                         ; preds = %if.then37, %if.else
  br label %if.end

sc.rhs:                                           ; preds = %if.end
  %dist43 = load ptr, ptr %dist, align 8, !nonnull !6, !dereferenceable !7
  %a44 = load i32, ptr %a, align 4
  %33 = sext i32 %a44 to i64
  %arr.len45 = load i64, ptr %dist43, align 8
  %arr.oob46 = icmp uge i64 %33, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

sc.end:                                           ; preds = %idx.ok48, %if.end
  %sc = phi i1 [ false, %if.end ], [ %sc.b, %idx.ok48 ]
  %34 = zext i1 %sc to i32
  br i1 %sc, label %if.then51, label %if.end52

idx.bad47:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1541, ptr @.faila.1542, i64 %33, ptr @.failb.1543, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %sc.rhs
  %arr.data49 = getelementptr i8, ptr %dist43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %33
  %elem = load i32, ptr %arr.elem50, align 4
  %35 = icmp slt i32 %elem, 0
  %36 = zext i1 %35 to i32
  %sc.b = icmp ne i32 %36, 0
  br label %sc.end

if.then51:                                        ; preds = %sc.end
  %dist53 = load ptr, ptr %dist, align 8, !nonnull !6, !dereferenceable !7
  %a54 = load i32, ptr %a, align 4
  %37 = sext i32 %a54 to i64
  %arr.len55 = load i64, ptr %dist53, align 8
  %arr.oob56 = icmp uge i64 %37, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

if.end52:                                         ; preds = %idx.ok66, %sc.end
  br label %for.update23

idx.bad57:                                        ; preds = %if.then51
  call void @__polaron_fail(ptr @.fail.1544, ptr @.faila.1545, i64 %37, ptr @.failb.1546, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %if.then51
  %arr.data59 = getelementptr i8, ptr %dist53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %37
  %dist61 = load ptr, ptr %dist, align 8, !nonnull !6, !dereferenceable !7
  %u62 = load i32, ptr %u, align 4
  %38 = sext i32 %u62 to i64
  %arr.len63 = load i64, ptr %dist61, align 8
  %arr.oob64 = icmp uge i64 %38, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !8

idx.bad65:                                        ; preds = %idx.ok58
  call void @__polaron_fail(ptr @.fail.1547, ptr @.faila.1548, i64 %38, ptr @.failb.1549, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %idx.ok58
  %arr.data67 = getelementptr i8, ptr %dist61, i64 8
  %arr.elem68 = getelementptr inbounds i32, ptr %arr.data67, i64 %38
  %elem69 = load i32, ptr %arr.elem68, align 4
  %39 = add i32 %elem69, 1
  store i32 %39, ptr %arr.elem60, align 4
  %q70 = load ptr, ptr %q, align 8
  %a71 = load i32, ptr %a, align 4
  call void @"Queue$int.enqueue"(ptr %q70, i32 %a71)
  br label %if.end52

idx.bad76:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1550, ptr @.faila.1551, i64 %17, ptr @.failb.1552, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %while.end
  %arr.data78 = getelementptr i8, ptr %dist72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %17
  %elem80 = load i32, ptr %arr.elem79, align 4
  ret i32 %elem80
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5320)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

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
