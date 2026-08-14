; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_lifetime.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collection_lifetime.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.ArrayList$String" = type { ptr, ptr, i32 }
%"class.HashMap$String$int" = type { ptr, ptr, ptr, ptr, i32, i32 }
%"class.HashSet$String" = type { ptr, ptr, ptr, i32, i32 }
%"class.Stack$int" = type { ptr, ptr, i32 }
%"class.Queue$int" = type { ptr, ptr, i32, i32 }
%"class.Deque$int" = type { ptr, ptr, i32, i32 }
%"class.PriorityQueue$int" = type { ptr, ptr, i32 }
%"class.LinkedList$String" = type { ptr, ptr, ptr, ptr, i32 }
%"class.TreeMap$String$int" = type { ptr, ptr, i32 }
%"class.TreeSet$String" = type { ptr, ptr, i32 }
%"class.TreeSetNode$String" = type { ptr, ptr, ptr, ptr, i32 }
%"class.TreeNode$String$int" = type { ptr, ptr, i32, ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%"class.LinkedNode$String" = type { ptr, ptr, %WeakSlot, ptr }
%WeakSlot = type { ptr, ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$String" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"TreeSetNode$String.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"TreeSet$String.vtable" = private constant [371 x ptr] [ptr @"TreeSet$String.freeSubtree", ptr @"TreeSet$String.add", ptr @"TreeSet$String.nodeHeight", ptr @"TreeSet$String.fixHeight", ptr @"TreeSet$String.balance", ptr @"TreeSet$String.rotateRight", ptr @"TreeSet$String.rotateLeft", ptr @"TreeSet$String.insertNode", ptr @"TreeSet$String.contains", ptr @"TreeSet$String.fill", ptr @"TreeSet$String.toArray", ptr @"TreeSet$String.size", ptr @"TreeSet$String.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeSet$String.~TreeSet$String"]
@"Queue$int.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Queue$int.toArray", ptr @"Queue$int.size", ptr @"Queue$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Queue$int.peek", ptr @"Queue$int.enqueue", ptr @"Queue$int.dequeue", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Queue$int.~Queue$int"]
@"ArrayListIterator$String.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$String.hasNext", ptr @"ArrayListIterator$String.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"TreeMap$String$int.vtable" = private constant [371 x ptr] [ptr @"TreeMap$String$int.freeSubtree", ptr null, ptr @"TreeMap$String$int.nodeHeight", ptr @"TreeMap$String$int.fixHeight", ptr @"TreeMap$String$int.balance", ptr @"TreeMap$String$int.rotateRight", ptr @"TreeMap$String$int.rotateLeft", ptr @"TreeMap$String$int.insertNode", ptr null, ptr null, ptr null, ptr @"TreeMap$String$int.size", ptr @"TreeMap$String$int.isEmpty", ptr @"TreeMap$String$int.put", ptr @"TreeMap$String$int.find", ptr @"TreeMap$String$int.get", ptr @"TreeMap$String$int.containsKey", ptr @"TreeMap$String$int.fillKeys", ptr @"TreeMap$String$int.fillValues", ptr @"TreeMap$String$int.keyArray", ptr @"TreeMap$String$int.valueArray", ptr @"TreeMap$String$int.zeroKey", ptr @"TreeMap$String$int.firstKey", ptr @"TreeMap$String$int.lastKey", ptr @"TreeMap$String$int.floorKey", ptr @"TreeMap$String$int.ceilingKey", ptr @"TreeMap$String$int.higherKey", ptr @"TreeMap$String$int.lowerKey", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeMap$String$int.~TreeMap$String$int"]
@"TreeNode$String$int.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"Stack$int.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Stack$int.toArray", ptr @"Stack$int.size", ptr @"Stack$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Stack$int.push", ptr @"Stack$int.pop", ptr @"Stack$int.peek", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Stack$int.~Stack$int"]
@"PriorityQueue$int.vtable" = private constant [371 x ptr] [ptr null, ptr @"PriorityQueue$int.add", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"PriorityQueue$int.size", ptr @"PriorityQueue$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"PriorityQueue$int.peek", ptr null, ptr null, ptr @"PriorityQueue$int.poll", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"PriorityQueue$int.~PriorityQueue$int"]
@"LinkedList$String.vtable" = private constant [371 x ptr] [ptr null, ptr @"LinkedList$String.add", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"LinkedList$String.toArray", ptr @"LinkedList$String.size", ptr @"LinkedList$String.isEmpty", ptr null, ptr null, ptr @"LinkedList$String.get", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"LinkedList$String.removeFirst", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"LinkedList$String.~LinkedList$String"]
@"LinkedNode$String.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"HashSet$String.vtable" = private constant [371 x ptr] [ptr null, ptr @"HashSet$String.add", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$String.contains", ptr null, ptr @"HashSet$String.toArray", ptr @"HashSet$String.size", ptr @"HashSet$String.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$String.slotFor", ptr @"HashSet$String.grow", ptr @"HashSet$String.remove", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$String.~HashSet$String"]
@"HashMap$String$int.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$int.size", ptr @"HashMap$String$int.isEmpty", ptr @"HashMap$String$int.put", ptr null, ptr @"HashMap$String$int.get", ptr @"HashMap$String$int.containsKey", ptr null, ptr null, ptr @"HashMap$String$int.keyArray", ptr @"HashMap$String$int.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$int.slotFor", ptr @"HashMap$String$int.grow", ptr @"HashMap$String$int.remove", ptr @"HashMap$String$int.getOrDefault", ptr @"HashMap$String$int.merge", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$int.~HashMap$String$int"]
@"Deque$int.vtable" = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.toArray", ptr @"Deque$int.size", ptr @"Deque$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.removeFirst", ptr null, ptr @"Deque$int.grow", ptr null, ptr null, ptr null, ptr @"Deque$int.addLast", ptr @"Deque$int.addFirst", ptr @"Deque$int.removeLast", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.~Deque$int"]
@"ArrayList$String.vtable" = private constant [371 x ptr] [ptr null, ptr @"ArrayList$String.add", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.contains", ptr null, ptr @"ArrayList$String.toArray", ptr @"ArrayList$String.size", ptr @"ArrayList$String.isEmpty", ptr null, ptr @"ArrayList$String.find", ptr @"ArrayList$String.get", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.remove", ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.ensureCapacity", ptr @"ArrayList$String.set", ptr @"ArrayList$String.indexOf", ptr @"ArrayList$String.removeAt", ptr @"ArrayList$String.insertAt", ptr @"ArrayList$String.clear", ptr @"ArrayList$String.forEach", ptr @"ArrayList$String.filter", ptr @"ArrayList$String.any", ptr @"ArrayList$String.all", ptr @"ArrayList$String.count", ptr @"ArrayList$String.sortedBy", ptr @"ArrayList$String.mergeSortRange", ptr @"ArrayList$String.min", ptr @"ArrayList$String.max", ptr @"ArrayList$String.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.~ArrayList$String"]
@Object.vtable = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [371 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [6 x i8] c"alpha\00"
@.strobj = private global %String { i64 5, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [5 x i8] c"beta\00"
@.strobj.2 = private global %String { i64 4, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [6 x i8] c"alpha\00"
@.strobj.4 = private global %String { i64 5, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [5 x i8] c"beta\00"
@.strobj.6 = private global %String { i64 4, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [6 x i8] c"alpha\00"
@.strobj.8 = private global %String { i64 5, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [5 x i8] c"beta\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [6 x i8] c"alpha\00"
@.strobj.12 = private global %String { i64 5, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [5 x i8] c"beta\00"
@.strobj.14 = private global %String { i64 4, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [6 x i8] c"alpha\00"
@.strobj.16 = private global %String { i64 5, ptr @.strdata.15, i64 0 }
@.strdata.17 = private constant [5 x i8] c"beta\00"
@.strobj.18 = private global %String { i64 4, ptr @.strdata.17, i64 0 }
@.strdata.19 = private constant [6 x i8] c"alpha\00"
@.strobj.20 = private global %String { i64 5, ptr @.strdata.19, i64 0 }
@.strdata.21 = private constant [5 x i8] c"beta\00"
@.strobj.22 = private global %String { i64 4, ptr @.strdata.21, i64 0 }
@.str = private unnamed_addr constant [16 x i8] c"sizes=%d ok=%d\0A\00", align 1
@.panic = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1409:33  in TreeSet$String.freeSubtree\0A\00", align 1
@.panic.23 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1410:33  in TreeSet$String.freeSubtree\0A\00", align 1
@.panic.24 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1411:17  in TreeSet$String.freeSubtree\0A\00", align 1
@.panic.25 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1419:17  in TreeSet$String.nodeHeight\0A\00", align 1
@.panic.26 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1422:17  in TreeSet$String.fixHeight\0A\00", align 1
@.panic.27 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1423:17  in TreeSet$String.fixHeight\0A\00", align 1
@.panic.28 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:41  in TreeSet$String.fixHeight\0A\00", align 1
@.panic.29 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:69  in TreeSet$String.fixHeight\0A\00", align 1
@.panic.30 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$String.balance\0A\00", align 1
@.panic.31 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$String.balance\0A\00", align 1
@.panic.32 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1430:17  in TreeSet$String.rotateRight\0A\00", align 1
@.panic.33 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$String.rotateRight\0A\00", align 1
@.panic.34 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$String.rotateRight\0A\00", align 1
@.panic.35 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1432:25  in TreeSet$String.rotateRight\0A\00", align 1
@.panic.36 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1438:17  in TreeSet$String.rotateLeft\0A\00", align 1
@.panic.37 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$String.rotateLeft\0A\00", align 1
@.panic.38 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$String.rotateLeft\0A\00", align 1
@.panic.39 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1440:24  in TreeSet$String.rotateLeft\0A\00", align 1
@.panic.40 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1450:17  in TreeSet$String.insertNode\0A\00", align 1
@.panic.41 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$String.insertNode\0A\00", align 1
@.panic.42 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$String.insertNode\0A\00", align 1
@.panic.43 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$String.insertNode\0A\00", align 1
@.panic.44 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$String.insertNode\0A\00", align 1
@.panic.45 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:21  in TreeSet$String.insertNode\0A\00", align 1
@.panic.46 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$String.insertNode\0A\00", align 1
@.panic.47 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$String.insertNode\0A\00", align 1
@.panic.48 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:21  in TreeSet$String.insertNode\0A\00", align 1
@.panic.49 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$String.insertNode\0A\00", align 1
@.panic.50 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$String.insertNode\0A\00", align 1
@.panic.51 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1472:21  in TreeSet$String.contains\0A\00", align 1
@.panic.52 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:38  in TreeSet$String.contains\0A\00", align 1
@.panic.53 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:63  in TreeSet$String.contains\0A\00", align 1
@.panic.54 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1480:17  in TreeSet$String.fill\0A\00", align 1
@.fail = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1481:24  in TreeSet$String.fill\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.55 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1481:24  in TreeSet$String.fill\0A\00", align 1
@.panic.56 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1483:17  in TreeSet$String.fill\0A\00", align 1
@.panic.57 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1219:33  in TreeMap$String$int.freeSubtree\0A\00", align 1
@.panic.58 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1220:33  in TreeMap$String$int.freeSubtree\0A\00", align 1
@.panic.59 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1221:17  in TreeMap$String$int.freeSubtree\0A\00", align 1
@.panic.60 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1231:17  in TreeMap$String$int.nodeHeight\0A\00", align 1
@.panic.61 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1234:17  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.62 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1235:17  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.63 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1236:41  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.64 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1236:69  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.65 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1239:17  in TreeMap$String$int.balance\0A\00", align 1
@.panic.66 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1239:17  in TreeMap$String$int.balance\0A\00", align 1
@.panic.67 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1242:17  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.68 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1243:24  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.69 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1243:24  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.70 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1244:25  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.71 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1250:17  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.72 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1251:25  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.73 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1251:25  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.74 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1252:24  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.75 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1262:17  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.76 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1263:42  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.77 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1265:31  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.78 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1265:31  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.79 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1267:32  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.80 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1267:32  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.81 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:21  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.82 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:66  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.83 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:66  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.84 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:21  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.85 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:68  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.86 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:68  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.87 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1284:21  in TreeMap$String$int.find\0A\00", align 1
@.panic.88 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1286:38  in TreeMap$String$int.find\0A\00", align 1
@.panic.89 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1286:63  in TreeMap$String$int.find\0A\00", align 1
@.panic.90 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1292:34  in TreeMap$String$int.get\0A\00", align 1
@.fail.91 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1294:17  in TreeMap$String$int.get\0A\00", align 1
@.faila.92 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.93 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.94 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1301:17  in TreeMap$String$int.fillKeys\0A\00", align 1
@.fail.95 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1302:24  in TreeMap$String$int.fillKeys\0A\00", align 1
@.faila.96 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.97 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.98 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1302:24  in TreeMap$String$int.fillKeys\0A\00", align 1
@.panic.99 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1304:17  in TreeMap$String$int.fillKeys\0A\00", align 1
@.panic.100 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1308:17  in TreeMap$String$int.fillValues\0A\00", align 1
@.fail.101 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1309:24  in TreeMap$String$int.fillValues\0A\00", align 1
@.faila.102 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.103 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.104 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1309:24  in TreeMap$String$int.fillValues\0A\00", align 1
@.panic.105 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1311:17  in TreeMap$String$int.fillValues\0A\00", align 1
@.fail.106 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1325:17  in TreeMap$String$int.zeroKey\0A\00", align 1
@.faila.107 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.108 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.109 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1332:17  in TreeMap$String$int.firstKey\0A\00", align 1
@.panic.110 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1332:48  in TreeMap$String$int.firstKey\0A\00", align 1
@.panic.111 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1333:17  in TreeMap$String$int.firstKey\0A\00", align 1
@.panic.112 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1338:17  in TreeMap$String$int.lastKey\0A\00", align 1
@.panic.113 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1338:49  in TreeMap$String$int.lastKey\0A\00", align 1
@.panic.114 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1339:17  in TreeMap$String$int.lastKey\0A\00", align 1
@.panic.115 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1345:21  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.116 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1346:35  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.117 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1347:38  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.118 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1347:75  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.119 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1350:17  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.120 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1356:21  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.121 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1357:35  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.122 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1358:38  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.123 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1358:76  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.124 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1361:17  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.125 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1367:21  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.126 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1368:50  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.127 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1368:75  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.128 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1371:17  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.129 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1377:21  in TreeMap$String$int.lowerKey\0A\00", align 1
@.panic.130 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1378:50  in TreeMap$String$int.lowerKey\0A\00", align 1
@.panic.131 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1378:76  in TreeMap$String$int.lowerKey\0A\00", align 1
@.panic.132 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1381:17  in TreeMap$String$int.lowerKey\0A\00", align 1
@.contract = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:666:34  in Stack$int.Stack$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.133 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:667:34  in Stack$int.Stack$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.134 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:675:78  in Stack$int.push\0A\00", align 1
@.faila.135 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.136 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.137 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:675:78  in Stack$int.push\0A\00", align 1
@.faila.138 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.139 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.140 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:679:39  in Stack$int.push\0A\00", align 1
@.faila.141 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.142 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.143 = private unnamed_addr constant [105 x i8] c"contract violated: invariant\0A  --> <prelude>:666:34  in Stack$int.push\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.144 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.145 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.146 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:667:34  in Stack$int.push\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.147 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:684:17  in Stack$int.pop\0A\00", align 1
@.faila.148 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.149 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.150 = private unnamed_addr constant [104 x i8] c"contract violated: invariant\0A  --> <prelude>:666:34  in Stack$int.pop\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.151 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.152 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.153 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:667:34  in Stack$int.pop\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.154 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:686:46  in Stack$int.peek\0A\00", align 1
@.faila.155 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.156 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.157 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:689:71  in Stack$int.toArray\0A\00", align 1
@.faila.158 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.159 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.160 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:689:71  in Stack$int.toArray\0A\00", align 1
@.faila.161 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.162 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.163 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.Queue$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.164 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.165 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.166 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.Queue$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.167 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.Queue$int\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.168 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.169 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.170 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.Queue$int\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.171 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:712:35  in Queue$int.enqueue\0A\00", align 1
@.faila.172 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.173 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.174 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:712:35  in Queue$int.enqueue\0A\00", align 1
@.faila.175 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.176 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.177 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:718:74  in Queue$int.enqueue\0A\00", align 1
@.faila.178 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.179 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.180 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.enqueue\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.181 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.182 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.183 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.enqueue\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.184 = private unnamed_addr constant [107 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.enqueue\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.185 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.186 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.187 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.enqueue\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.188 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:722:17  in Queue$int.dequeue\0A\00", align 1
@.faila.189 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.190 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.191 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.dequeue\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.192 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.193 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.194 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.dequeue\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.195 = private unnamed_addr constant [107 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.dequeue\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.196 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.197 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.198 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.dequeue\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.199 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:727:46  in Queue$int.peek\0A\00", align 1
@.faila.200 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.201 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.202 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:731:28  in Queue$int.toArray\0A\00", align 1
@.faila.203 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.204 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.205 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:731:28  in Queue$int.toArray\0A\00", align 1
@.faila.206 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.207 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.208 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1504:78  in PriorityQueue$int.add\0A\00", align 1
@.faila.209 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.210 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.211 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1504:78  in PriorityQueue$int.add\0A\00", align 1
@.faila.212 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.213 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.214 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1508:39  in PriorityQueue$int.add\0A\00", align 1
@.faila.215 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.216 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.217 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1513:21  in PriorityQueue$int.add\0A\00", align 1
@.faila.218 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.219 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.220 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1513:21  in PriorityQueue$int.add\0A\00", align 1
@.faila.221 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.222 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.223 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1514:21  in PriorityQueue$int.add\0A\00", align 1
@.faila.224 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.225 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.226 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1515:34  in PriorityQueue$int.add\0A\00", align 1
@.faila.227 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.228 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.229 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1515:34  in PriorityQueue$int.add\0A\00", align 1
@.faila.230 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.231 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.232 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1516:39  in PriorityQueue$int.add\0A\00", align 1
@.faila.233 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.234 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.235 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1520:46  in PriorityQueue$int.peek\0A\00", align 1
@.faila.236 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.237 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.238 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1522:17  in PriorityQueue$int.poll\0A\00", align 1
@.faila.239 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.240 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.241 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1524:30  in PriorityQueue$int.poll\0A\00", align 1
@.faila.242 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.243 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.244 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1524:30  in PriorityQueue$int.poll\0A\00", align 1
@.faila.245 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.246 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.247 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1530:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.248 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.249 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.250 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1530:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.251 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.252 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.253 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1533:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.254 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.255 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.256 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1533:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.257 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.258 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.259 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1537:21  in PriorityQueue$int.poll\0A\00", align 1
@.faila.260 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.261 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.262 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1538:34  in PriorityQueue$int.poll\0A\00", align 1
@.faila.263 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.264 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.265 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1538:34  in PriorityQueue$int.poll\0A\00", align 1
@.faila.266 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.267 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.268 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1539:41  in PriorityQueue$int.poll\0A\00", align 1
@.faila.269 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.270 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.271 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:838:39  in LinkedList$String.add\0A\00", align 1
@.panic.272 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:843:59  in LinkedList$String.get\0A\00", align 1
@.panic.273 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:844:17  in LinkedList$String.get\0A\00", align 1
@.panic.274 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:848:17  in LinkedList$String.removeFirst\0A\00", align 1
@.panic.275 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:849:27  in LinkedList$String.removeFirst\0A\00", align 1
@.panic.276 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:851:17  in LinkedList$String.removeFirst\0A\00", align 1
@.fail.277 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:858:71  in LinkedList$String.toArray\0A\00", align 1
@.faila.278 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.279 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.280 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:858:71  in LinkedList$String.toArray\0A\00", align 1
@.panic.281 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:858:88  in LinkedList$String.toArray\0A\00", align 1
@.fail.282 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1133:17  in HashSet$String.slotFor\0A\00", align 1
@.faila.283 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.284 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.285 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1134:21  in HashSet$String.slotFor\0A\00", align 1
@.faila.286 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.287 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.288 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1148:21  in HashSet$String.grow\0A\00", align 1
@.faila.289 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.290 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.291 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1148:49  in HashSet$String.grow\0A\00", align 1
@.faila.292 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.293 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.294 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1156:17  in HashSet$String.add\0A\00", align 1
@.faila.295 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.296 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.297 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1157:34  in HashSet$String.add\0A\00", align 1
@.faila.298 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.299 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.300 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1158:35  in HashSet$String.add\0A\00", align 1
@.faila.301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.303 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1163:17  in HashSet$String.contains\0A\00", align 1
@.faila.304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.306 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1167:17  in HashSet$String.remove\0A\00", align 1
@.faila.307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.309 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1169:30  in HashSet$String.remove\0A\00", align 1
@.faila.310 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.311 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.312 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1172:17  in HashSet$String.remove\0A\00", align 1
@.faila.313 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.314 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.315 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1173:21  in HashSet$String.remove\0A\00", align 1
@.faila.316 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.317 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.318 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1174:34  in HashSet$String.remove\0A\00", align 1
@.faila.319 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.320 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.321 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:21  in HashSet$String.toArray\0A\00", align 1
@.faila.322 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.323 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.324 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:53  in HashSet$String.toArray\0A\00", align 1
@.faila.325 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.326 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.327 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:53  in HashSet$String.toArray\0A\00", align 1
@.faila.328 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.329 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.646 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.647 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.648 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.649 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.650 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.651 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.652 = private unnamed_addr constant [143 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.653 = private unnamed_addr constant [145 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.654 = private unnamed_addr constant [143 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.HashMap$String$int\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.655 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$String$int.slotFor\0A\00", align 1
@.faila.656 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.657 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.658 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$String$int.slotFor\0A\00", align 1
@.faila.659 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.660 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.661 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$String$int.grow\0A\00", align 1
@.faila.662 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.663 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.664 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$String$int.grow\0A\00", align 1
@.faila.665 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.666 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.667 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$String$int.grow\0A\00", align 1
@.faila.668 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.669 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.670 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$String$int.grow\0A\00", align 1
@.faila.671 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.672 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.673 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$int.grow\0A\00", align 1
@.faila.674 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.675 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.676 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$int.grow\0A\00", align 1
@.faila.677 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.678 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.679 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$int.grow\0A\00", align 1
@.faila.680 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.681 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.682 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$int.grow\0A\00", align 1
@.faila.683 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.684 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.685 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.686 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.687 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.688 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.689 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.690 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.691 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.692 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.693 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.694 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$String$int.put\0A\00", align 1
@.faila.695 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.696 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.697 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$String$int.put\0A\00", align 1
@.faila.698 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.699 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.700 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$String$int.put\0A\00", align 1
@.faila.701 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.702 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.703 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$String$int.put\0A\00", align 1
@.faila.704 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.705 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.706 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.707 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.708 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.709 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.710 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.711 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.712 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.713 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.714 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.715 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$String$int.get\0A\00", align 1
@.faila.716 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.717 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.718 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$String$int.containsKey\0A\00", align 1
@.faila.719 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.720 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.721 = private unnamed_addr constant [102 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$String$int.getOrDefault\0A\00", align 1
@.faila.722 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.723 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.724 = private unnamed_addr constant [102 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$String$int.getOrDefault\0A\00", align 1
@.faila.725 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.726 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.727 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$String$int.merge\0A\00", align 1
@.faila.728 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.729 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.730 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$String$int.merge\0A\00", align 1
@.faila.731 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.732 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.733 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$String$int.merge\0A\00", align 1
@.faila.734 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.735 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.736 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$String$int.merge\0A\00", align 1
@.faila.737 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.738 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.739 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$int.merge\0A\00", align 1
@.faila.740 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.741 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.742 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$int.merge\0A\00", align 1
@.faila.743 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.744 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.745 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.746 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.747 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.748 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.749 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.750 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.751 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$int.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.752 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$int.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.753 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.754 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$String$int.remove\0A\00", align 1
@.faila.755 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.756 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.757 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.758 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.759 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.760 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.761 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.762 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.763 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.764 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$String$int.remove\0A\00", align 1
@.faila.765 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.766 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.767 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$String$int.remove\0A\00", align 1
@.faila.768 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.769 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.770 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$String$int.remove\0A\00", align 1
@.faila.771 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.772 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.773 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$String$int.remove\0A\00", align 1
@.faila.774 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.775 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.776 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$String$int.remove\0A\00", align 1
@.faila.777 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.778 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.779 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.780 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.781 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.782 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.783 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.784 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.785 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.786 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$String$int.keyArray\0A\00", align 1
@.faila.787 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.788 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.789 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$int.keyArray\0A\00", align 1
@.faila.790 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.791 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.792 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$int.keyArray\0A\00", align 1
@.faila.793 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.794 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.795 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$String$int.valueArray\0A\00", align 1
@.faila.796 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.797 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.798 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$int.valueArray\0A\00", align 1
@.faila.799 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.800 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.801 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$int.valueArray\0A\00", align 1
@.faila.802 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.803 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1120 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:749:31  in Deque$int.grow\0A\00", align 1
@.faila.1121 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1122 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1123 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:749:31  in Deque$int.grow\0A\00", align 1
@.faila.1124 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1125 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1126 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:757:74  in Deque$int.addLast\0A\00", align 1
@.faila.1127 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1128 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1129 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:763:38  in Deque$int.addFirst\0A\00", align 1
@.faila.1130 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1131 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1132 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:767:17  in Deque$int.removeFirst\0A\00", align 1
@.faila.1133 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1134 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1135 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:774:17  in Deque$int.removeLast\0A\00", align 1
@.faila.1136 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1137 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1138 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:779:28  in Deque$int.toArray\0A\00", align 1
@.faila.1139 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1140 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1141 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:779:28  in Deque$int.toArray\0A\00", align 1
@.faila.1142 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1143 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1560 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1561 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1562 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1563 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1564 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1565 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1566 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1567 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1568 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1569 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1570 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$String.add\0A\00", align 1
@.faila.1571 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1572 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1573 = private unnamed_addr constant [124 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$String.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1574 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1575 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1576 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1577 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1578 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1579 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1580 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1581 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1582 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1583 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1584 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1585 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1586 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1587 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1588 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$String.get\0A\00", align 1
@.faila.1589 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1590 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1591 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$String.get\0A\00", align 1
@.faila.1592 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1593 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1594 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$String.set\0A\00", align 1
@.faila.1595 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1596 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1597 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1598 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$String.set\0A\00", align 1
@.faila.1599 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1600 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1601 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1602 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$String.indexOf\0A\00", align 1
@.faila.1603 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1604 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1605 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1606 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1607 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1608 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1609 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1610 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1611 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1612 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1613 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1614 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1615 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1616 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1617 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1618 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1619 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1620 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1621 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1622 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1623 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1624 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1625 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1626 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1627 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1628 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1629 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1630 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1631 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1632 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1633 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1634 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1635 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1636 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1637 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1638 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1639 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1640 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1641 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1642 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1643 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1644 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1645 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1646 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1647 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1648 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1649 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1650 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1651 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1652 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1653 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1654 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1655 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1656 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1657 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1658 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$String.forEach\0A\00", align 1
@.faila.1659 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1660 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1661 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$String.filter\0A\00", align 1
@.faila.1662 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1663 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1664 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$String.filter\0A\00", align 1
@.faila.1665 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1666 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1667 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$String.any\0A\00", align 1
@.faila.1668 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1669 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1670 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$String.all\0A\00", align 1
@.faila.1671 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1672 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1673 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$String.count\0A\00", align 1
@.faila.1674 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1675 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1676 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$String.sortedBy\0A\00", align 1
@.faila.1677 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1678 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1679 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1680 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1681 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1682 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1683 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1684 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1685 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1686 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1687 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1688 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1689 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1690 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1691 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1692 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1693 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1694 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1695 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1696 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1699 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1700 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1701 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1702 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1703 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1704 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1705 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1706 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1707 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1708 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1709 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1710 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1711 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1712 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1713 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1714 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1715 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1716 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1717 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1718 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1719 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1720 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1721 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1722 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1723 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1724 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1725 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1726 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1727 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1728 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1729 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1730 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1731 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1732 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1733 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1734 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1735 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1736 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1737 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1738 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1739 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1740 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1741 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1742 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1743 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1744 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$String.find\0A\00", align 1
@.faila.1745 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1746 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1747 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$String.find\0A\00", align 1
@.faila.1748 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1749 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1750 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$String.min\0A\00", align 1
@.faila.1751 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1752 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1753 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$String.min\0A\00", align 1
@.faila.1754 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1755 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1756 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$String.min\0A\00", align 1
@.faila.1757 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1758 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1759 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$String.max\0A\00", align 1
@.faila.1760 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1761 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1762 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$String.max\0A\00", align 1
@.faila.1763 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1764 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1765 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$String.max\0A\00", align 1
@.faila.1766 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1767 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1778 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1779 = private global %String { i64 16, ptr @.strdata.1778, i64 0 }
@.strdata.1780 = private constant [17 x i8] c"division by zero\00"
@.strobj.1781 = private global %String { i64 16, ptr @.strdata.1780, i64 0 }
@.strdata.5780 = private constant [1 x i8] zeroinitializer
@.strobj.5781 = private global %String { i64 0, ptr @.strdata.5780, i64 0 }
@.strdata.5782 = private constant [1 x i8] zeroinitializer
@.strobj.5783 = private global %String { i64 0, ptr @.strdata.5782, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %tset = alloca ptr, align 8
  %tree = alloca ptr, align 8
  %linked = alloca ptr, align 8
  %pq = alloca ptr, align 8
  %deque = alloca ptr, align 8
  %queue = alloca ptr, align 8
  %stack = alloca ptr, align 8
  %set = alloca ptr, align 8
  %map = alloca ptr, align 8
  %list = alloca ptr, align 8
  %rounds = alloca i32, align 4
  %n = alloca i32, align 4
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
  store i32 0, ptr %n, align 4
  store i32 0, ptr %rounds, align 4
  br label %while.cond

while.cond:                                       ; preds = %dtor.free105, %argv.end
  %rounds1 = load i32, ptr %rounds, align 4
  %16 = icmp slt i32 %rounds1, 200
  %17 = zext i1 %16 to i32
  br i1 %16, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr %list, align 8
  %list2 = load ptr, ptr %list, align 8
  call void @"ArrayList$String.add"(ptr %list2, ptr @.strobj)
  %list3 = load ptr, ptr %list, align 8
  call void @"ArrayList$String.add"(ptr %list3, ptr @.strobj.2)
  %n4 = load i32, ptr %n, align 4
  %list5 = load ptr, ptr %list, align 8
  %18 = call i32 @"ArrayList$String.size"(ptr %list5)
  %19 = add i32 %n4, %18
  store i32 %19, ptr %n, align 4
  %list6 = load ptr, ptr %list, align 8
  call void @__polaron_check_live(ptr %list6)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$String", ptr %list6, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [371 x ptr], ptr %vtbl, i64 0, i64 370
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %20 = icmp ne ptr %dtor.fn, null
  br i1 %20, label %dtor.call, label %dtor.free

while.end:                                        ; preds = %while.cond
  %n107 = load i32, ptr %n, align 4
  %n108 = load i32, ptr %n, align 4
  %21 = icmp eq i32 %n108, 4000
  %22 = zext i1 %21 to i32
  %tern.c = icmp ne i32 %22, 0
  br i1 %tern.c, label %tern.then, label %tern.else

dtor.call:                                        ; preds = %while.body
  call void %dtor.fn(ptr %list6)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %while.body
  call void @__polaron_free(ptr %list6)
  %"HashMap$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$String$int", ptr null, i64 1) to i64))
  call void @"HashMap$String$int.HashMap$String$int"(ptr %"HashMap$String$int.obj")
  store ptr %"HashMap$String$int.obj", ptr %map, align 8
  %map7 = load ptr, ptr %map, align 8
  call void @"HashMap$String$int.put"(ptr %map7, ptr @.strobj.4, i32 1)
  %map8 = load ptr, ptr %map, align 8
  call void @"HashMap$String$int.put"(ptr %map8, ptr @.strobj.6, i32 2)
  %n9 = load i32, ptr %n, align 4
  %map10 = load ptr, ptr %map, align 8
  %23 = call i32 @"HashMap$String$int.size"(ptr %map10)
  %24 = add i32 %n9, %23
  store i32 %24, ptr %n, align 4
  %map11 = load ptr, ptr %map, align 8
  call void @__polaron_check_live(ptr %map11)
  %vtbl.addr12 = getelementptr inbounds %"class.HashMap$String$int", ptr %map11, i32 0, i32 0
  %vtbl13 = load ptr, ptr %vtbl.addr12, align 8, !tbaa !0
  %dtor.slot14 = getelementptr [371 x ptr], ptr %vtbl13, i64 0, i64 370
  %dtor.fn15 = load ptr, ptr %dtor.slot14, align 8
  %25 = icmp ne ptr %dtor.fn15, null
  br i1 %25, label %dtor.call16, label %dtor.free17

dtor.call16:                                      ; preds = %dtor.free
  call void %dtor.fn15(ptr %map11)
  br label %dtor.free17

dtor.free17:                                      ; preds = %dtor.call16, %dtor.free
  call void @__polaron_free(ptr %map11)
  %"HashSet$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashSet$String", ptr null, i64 1) to i64))
  call void @"HashSet$String.HashSet$String"(ptr %"HashSet$String.obj")
  store ptr %"HashSet$String.obj", ptr %set, align 8
  %set18 = load ptr, ptr %set, align 8
  call void @"HashSet$String.add"(ptr %set18, ptr @.strobj.8)
  %set19 = load ptr, ptr %set, align 8
  call void @"HashSet$String.add"(ptr %set19, ptr @.strobj.10)
  %n20 = load i32, ptr %n, align 4
  %set21 = load ptr, ptr %set, align 8
  %26 = call i32 @"HashSet$String.size"(ptr %set21)
  %27 = add i32 %n20, %26
  store i32 %27, ptr %n, align 4
  %set22 = load ptr, ptr %set, align 8
  call void @__polaron_check_live(ptr %set22)
  %vtbl.addr23 = getelementptr inbounds %"class.HashSet$String", ptr %set22, i32 0, i32 0
  %vtbl24 = load ptr, ptr %vtbl.addr23, align 8, !tbaa !0
  %dtor.slot25 = getelementptr [371 x ptr], ptr %vtbl24, i64 0, i64 370
  %dtor.fn26 = load ptr, ptr %dtor.slot25, align 8
  %28 = icmp ne ptr %dtor.fn26, null
  br i1 %28, label %dtor.call27, label %dtor.free28

dtor.call27:                                      ; preds = %dtor.free17
  call void %dtor.fn26(ptr %set22)
  br label %dtor.free28

dtor.free28:                                      ; preds = %dtor.call27, %dtor.free17
  call void @__polaron_free(ptr %set22)
  %"Stack$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Stack$int", ptr null, i64 1) to i64))
  call void @"Stack$int.Stack$int"(ptr %"Stack$int.obj")
  store ptr %"Stack$int.obj", ptr %stack, align 8
  %stack29 = load ptr, ptr %stack, align 8
  call void @"Stack$int.push"(ptr %stack29, i32 1)
  %stack30 = load ptr, ptr %stack, align 8
  call void @"Stack$int.push"(ptr %stack30, i32 2)
  %n31 = load i32, ptr %n, align 4
  %stack32 = load ptr, ptr %stack, align 8
  %29 = call i32 @"Stack$int.size"(ptr %stack32)
  %30 = add i32 %n31, %29
  store i32 %30, ptr %n, align 4
  %stack33 = load ptr, ptr %stack, align 8
  call void @__polaron_check_live(ptr %stack33)
  %vtbl.addr34 = getelementptr inbounds %"class.Stack$int", ptr %stack33, i32 0, i32 0
  %vtbl35 = load ptr, ptr %vtbl.addr34, align 8, !tbaa !0
  %dtor.slot36 = getelementptr [371 x ptr], ptr %vtbl35, i64 0, i64 370
  %dtor.fn37 = load ptr, ptr %dtor.slot36, align 8
  %31 = icmp ne ptr %dtor.fn37, null
  br i1 %31, label %dtor.call38, label %dtor.free39

dtor.call38:                                      ; preds = %dtor.free28
  call void %dtor.fn37(ptr %stack33)
  br label %dtor.free39

dtor.free39:                                      ; preds = %dtor.call38, %dtor.free28
  call void @__polaron_free(ptr %stack33)
  %"Queue$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Queue$int", ptr null, i64 1) to i64))
  call void @"Queue$int.Queue$int"(ptr %"Queue$int.obj")
  store ptr %"Queue$int.obj", ptr %queue, align 8
  %queue40 = load ptr, ptr %queue, align 8
  call void @"Queue$int.enqueue"(ptr %queue40, i32 1)
  %queue41 = load ptr, ptr %queue, align 8
  call void @"Queue$int.enqueue"(ptr %queue41, i32 2)
  %n42 = load i32, ptr %n, align 4
  %queue43 = load ptr, ptr %queue, align 8
  %32 = call i32 @"Queue$int.size"(ptr %queue43)
  %33 = add i32 %n42, %32
  store i32 %33, ptr %n, align 4
  %queue44 = load ptr, ptr %queue, align 8
  call void @__polaron_check_live(ptr %queue44)
  %vtbl.addr45 = getelementptr inbounds %"class.Queue$int", ptr %queue44, i32 0, i32 0
  %vtbl46 = load ptr, ptr %vtbl.addr45, align 8, !tbaa !0
  %dtor.slot47 = getelementptr [371 x ptr], ptr %vtbl46, i64 0, i64 370
  %dtor.fn48 = load ptr, ptr %dtor.slot47, align 8
  %34 = icmp ne ptr %dtor.fn48, null
  br i1 %34, label %dtor.call49, label %dtor.free50

dtor.call49:                                      ; preds = %dtor.free39
  call void %dtor.fn48(ptr %queue44)
  br label %dtor.free50

dtor.free50:                                      ; preds = %dtor.call49, %dtor.free39
  call void @__polaron_free(ptr %queue44)
  %"Deque$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Deque$int", ptr null, i64 1) to i64))
  call void @"Deque$int.Deque$int"(ptr %"Deque$int.obj")
  store ptr %"Deque$int.obj", ptr %deque, align 8
  %deque51 = load ptr, ptr %deque, align 8
  call void @"Deque$int.addLast"(ptr %deque51, i32 1)
  %deque52 = load ptr, ptr %deque, align 8
  call void @"Deque$int.addLast"(ptr %deque52, i32 2)
  %n53 = load i32, ptr %n, align 4
  %deque54 = load ptr, ptr %deque, align 8
  %35 = call i32 @"Deque$int.size"(ptr %deque54)
  %36 = add i32 %n53, %35
  store i32 %36, ptr %n, align 4
  %deque55 = load ptr, ptr %deque, align 8
  call void @__polaron_check_live(ptr %deque55)
  %vtbl.addr56 = getelementptr inbounds %"class.Deque$int", ptr %deque55, i32 0, i32 0
  %vtbl57 = load ptr, ptr %vtbl.addr56, align 8, !tbaa !0
  %dtor.slot58 = getelementptr [371 x ptr], ptr %vtbl57, i64 0, i64 370
  %dtor.fn59 = load ptr, ptr %dtor.slot58, align 8
  %37 = icmp ne ptr %dtor.fn59, null
  br i1 %37, label %dtor.call60, label %dtor.free61

dtor.call60:                                      ; preds = %dtor.free50
  call void %dtor.fn59(ptr %deque55)
  br label %dtor.free61

dtor.free61:                                      ; preds = %dtor.call60, %dtor.free50
  call void @__polaron_free(ptr %deque55)
  %"PriorityQueue$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.PriorityQueue$int", ptr null, i64 1) to i64))
  call void @"PriorityQueue$int.PriorityQueue$int"(ptr %"PriorityQueue$int.obj")
  store ptr %"PriorityQueue$int.obj", ptr %pq, align 8
  %pq62 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq62, i32 2)
  %pq63 = load ptr, ptr %pq, align 8
  call void @"PriorityQueue$int.add"(ptr %pq63, i32 1)
  %n64 = load i32, ptr %n, align 4
  %pq65 = load ptr, ptr %pq, align 8
  %38 = call i32 @"PriorityQueue$int.size"(ptr %pq65)
  %39 = add i32 %n64, %38
  store i32 %39, ptr %n, align 4
  %pq66 = load ptr, ptr %pq, align 8
  call void @__polaron_check_live(ptr %pq66)
  %vtbl.addr67 = getelementptr inbounds %"class.PriorityQueue$int", ptr %pq66, i32 0, i32 0
  %vtbl68 = load ptr, ptr %vtbl.addr67, align 8, !tbaa !0
  %dtor.slot69 = getelementptr [371 x ptr], ptr %vtbl68, i64 0, i64 370
  %dtor.fn70 = load ptr, ptr %dtor.slot69, align 8
  %40 = icmp ne ptr %dtor.fn70, null
  br i1 %40, label %dtor.call71, label %dtor.free72

dtor.call71:                                      ; preds = %dtor.free61
  call void %dtor.fn70(ptr %pq66)
  br label %dtor.free72

dtor.free72:                                      ; preds = %dtor.call71, %dtor.free61
  call void @__polaron_free(ptr %pq66)
  %"LinkedList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.LinkedList$String", ptr null, i64 1) to i64))
  call void @"LinkedList$String.LinkedList$String"(ptr %"LinkedList$String.obj")
  store ptr %"LinkedList$String.obj", ptr %linked, align 8
  %linked73 = load ptr, ptr %linked, align 8
  call void @"LinkedList$String.add"(ptr %linked73, ptr @.strobj.12)
  %linked74 = load ptr, ptr %linked, align 8
  call void @"LinkedList$String.add"(ptr %linked74, ptr @.strobj.14)
  %n75 = load i32, ptr %n, align 4
  %linked76 = load ptr, ptr %linked, align 8
  %41 = call i32 @"LinkedList$String.size"(ptr %linked76)
  %42 = add i32 %n75, %41
  store i32 %42, ptr %n, align 4
  %linked77 = load ptr, ptr %linked, align 8
  call void @__polaron_check_live(ptr %linked77)
  %rgnfield.nodes = getelementptr inbounds %"class.LinkedList$String", ptr %linked77, i32 0, i32 1
  %rgnfield.block = load ptr, ptr %rgnfield.nodes, align 8, !tbaa !0
  %43 = icmp ne ptr %rgnfield.block, null
  br i1 %43, label %rgnfield.live, label %rgnfield.done

rgnfield.live:                                    ; preds = %dtor.free72
  call void @__polaron_region_teardown(ptr %rgnfield.block)
  call void @__polaron_region_release(ptr %rgnfield.block)
  store ptr null, ptr %rgnfield.nodes, align 8, !tbaa !0
  br label %rgnfield.done

rgnfield.done:                                    ; preds = %rgnfield.live, %dtor.free72
  %vtbl.addr78 = getelementptr inbounds %"class.LinkedList$String", ptr %linked77, i32 0, i32 0
  %vtbl79 = load ptr, ptr %vtbl.addr78, align 8, !tbaa !0
  %dtor.slot80 = getelementptr [371 x ptr], ptr %vtbl79, i64 0, i64 370
  %dtor.fn81 = load ptr, ptr %dtor.slot80, align 8
  %44 = icmp ne ptr %dtor.fn81, null
  br i1 %44, label %dtor.call82, label %dtor.free83

dtor.call82:                                      ; preds = %rgnfield.done
  call void %dtor.fn81(ptr %linked77)
  br label %dtor.free83

dtor.free83:                                      ; preds = %dtor.call82, %rgnfield.done
  call void @__polaron_free(ptr %linked77)
  %"TreeMap$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeMap$String$int", ptr null, i64 1) to i64))
  call void @"TreeMap$String$int.TreeMap$String$int"(ptr %"TreeMap$String$int.obj")
  store ptr %"TreeMap$String$int.obj", ptr %tree, align 8
  %tree84 = load ptr, ptr %tree, align 8
  call void @"TreeMap$String$int.put"(ptr %tree84, ptr @.strobj.16, i32 1)
  %tree85 = load ptr, ptr %tree, align 8
  call void @"TreeMap$String$int.put"(ptr %tree85, ptr @.strobj.18, i32 2)
  %n86 = load i32, ptr %n, align 4
  %tree87 = load ptr, ptr %tree, align 8
  %45 = call i32 @"TreeMap$String$int.size"(ptr %tree87)
  %46 = add i32 %n86, %45
  store i32 %46, ptr %n, align 4
  %tree88 = load ptr, ptr %tree, align 8
  call void @__polaron_check_live(ptr %tree88)
  %vtbl.addr89 = getelementptr inbounds %"class.TreeMap$String$int", ptr %tree88, i32 0, i32 0
  %vtbl90 = load ptr, ptr %vtbl.addr89, align 8, !tbaa !0
  %dtor.slot91 = getelementptr [371 x ptr], ptr %vtbl90, i64 0, i64 370
  %dtor.fn92 = load ptr, ptr %dtor.slot91, align 8
  %47 = icmp ne ptr %dtor.fn92, null
  br i1 %47, label %dtor.call93, label %dtor.free94

dtor.call93:                                      ; preds = %dtor.free83
  call void %dtor.fn92(ptr %tree88)
  br label %dtor.free94

dtor.free94:                                      ; preds = %dtor.call93, %dtor.free83
  call void @__polaron_free(ptr %tree88)
  %"TreeSet$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeSet$String", ptr null, i64 1) to i64))
  call void @"TreeSet$String.TreeSet$String"(ptr %"TreeSet$String.obj")
  store ptr %"TreeSet$String.obj", ptr %tset, align 8
  %tset95 = load ptr, ptr %tset, align 8
  call void @"TreeSet$String.add"(ptr %tset95, ptr @.strobj.20)
  %tset96 = load ptr, ptr %tset, align 8
  call void @"TreeSet$String.add"(ptr %tset96, ptr @.strobj.22)
  %n97 = load i32, ptr %n, align 4
  %tset98 = load ptr, ptr %tset, align 8
  %48 = call i32 @"TreeSet$String.size"(ptr %tset98)
  %49 = add i32 %n97, %48
  store i32 %49, ptr %n, align 4
  %tset99 = load ptr, ptr %tset, align 8
  call void @__polaron_check_live(ptr %tset99)
  %vtbl.addr100 = getelementptr inbounds %"class.TreeSet$String", ptr %tset99, i32 0, i32 0
  %vtbl101 = load ptr, ptr %vtbl.addr100, align 8, !tbaa !0
  %dtor.slot102 = getelementptr [371 x ptr], ptr %vtbl101, i64 0, i64 370
  %dtor.fn103 = load ptr, ptr %dtor.slot102, align 8
  %50 = icmp ne ptr %dtor.fn103, null
  br i1 %50, label %dtor.call104, label %dtor.free105

dtor.call104:                                     ; preds = %dtor.free94
  call void %dtor.fn103(ptr %tset99)
  br label %dtor.free105

dtor.free105:                                     ; preds = %dtor.call104, %dtor.free94
  call void @__polaron_free(ptr %tset99)
  %rounds106 = load i32, ptr %rounds, align 4
  %51 = add i32 %rounds106, 1
  store i32 %51, ptr %rounds, align 4
  br label %while.cond

tern.then:                                        ; preds = %while.end
  br label %tern.end

tern.else:                                        ; preds = %while.end
  br label %tern.end

tern.end:                                         ; preds = %tern.else, %tern.then
  %tern = phi i32 [ 1, %tern.then ], [ 0, %tern.else ]
  %52 = call i32 (ptr, ...) @printf(ptr @.str, i32 %n107, i32 %tern)
  ret i32 0
}

define internal void @"TreeSet$String.TreeSet$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 0
  store ptr @"TreeSet$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %root = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %root, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeSet$String.~TreeSet$String"(ptr %0) {
entry:
  %root = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  call void @"TreeSet$String.freeSubtree"(ptr %0, ptr %root1)
  %root2 = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %root2, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeSet$String.freeSubtree"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %n2 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n2, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %n2, i32 0, i32 2
  %left3 = load ptr, ptr %left, align 8, !tbaa !0
  call void @"TreeSet$String.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.23)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %n4, i32 0, i32 3
  %right7 = load ptr, ptr %right, align 8, !tbaa !0
  call void @"TreeSet$String.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.24)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$String", ptr %n8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [371 x ptr], ptr %vtbl, i64 0, i64 370
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %7 = icmp ne ptr %dtor.fn, null
  br i1 %7, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %nullrecv.ok10
  call void %dtor.fn(ptr %n8)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %nullrecv.ok10
  %value.sfree = getelementptr inbounds %"class.TreeSetNode$String", ptr %n8, i32 0, i32 1
  %8 = load ptr, ptr %value.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %8)
  call void @__polaron_free(ptr %n8)
  ret void
}

define internal void @"TreeSet$String.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %value = alloca ptr, align 8
  store ptr %1, ptr %value, align 8
  %root = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  %root1 = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root1, align 8, !tbaa !0
  %value3 = load ptr, ptr %value, align 8
  %2 = call ptr @"TreeSet$String.insertNode"(ptr %0, ptr %root2, ptr %value3)
  store ptr %2, ptr %root, align 8, !tbaa !0
  ret void
}

define internal i32 @"TreeSet$String.nodeHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %n2 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n2, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.25)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %height = getelementptr inbounds %"class.TreeSetNode$String", ptr %n2, i32 0, i32 4
  %height3 = load i32, ptr %height, align 4, !tbaa !4
  ret i32 %height3
}

define internal void @"TreeSet$String.fixHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rh = alloca i32, align 4
  %lh = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.26)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeSet$String.nodeHeight"(ptr %0, ptr %left2)
  store i32 %3, ptr %lh, align 4
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.27)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeSet$String.nodeHeight"(ptr %0, ptr %right6)
  store i32 %5, ptr %rh, align 4
  %lh7 = load i32, ptr %lh, align 4
  %rh8 = load i32, ptr %rh, align 4
  %6 = icmp sgt i32 %lh7, %rh8
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.else

if.then:                                          ; preds = %nullrecv.ok5
  %n9 = load ptr, ptr %n, align 8
  %8 = icmp eq ptr %n9, null
  br i1 %8, label %nullrecv10, label %nullrecv.ok11

if.else:                                          ; preds = %nullrecv.ok5
  %n13 = load ptr, ptr %n, align 8
  %9 = icmp eq ptr %n13, null
  br i1 %9, label %nullrecv14, label %nullrecv.ok15

if.end:                                           ; preds = %nullrecv.ok15, %nullrecv.ok11
  ret void

nullrecv10:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.28)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeSetNode$String", ptr %n9, i32 0, i32 4
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !4
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.29)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %height16 = getelementptr inbounds %"class.TreeSetNode$String", ptr %n13, i32 0, i32 4
  %rh17 = load i32, ptr %rh, align 4
  %11 = add i32 %rh17, 1
  store i32 %11, ptr %height16, align 4, !tbaa !4
  br label %if.end
}

define internal i32 @"TreeSet$String.balance"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.30)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeSet$String.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.31)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeSet$String.nodeHeight"(ptr %0, ptr %right6)
  %6 = sub i32 %3, %5
  ret i32 %6
}

define internal ptr @"TreeSet$String.rotateRight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %1, ptr %y, align 8
  %y1 = load ptr, ptr %y, align 8
  %2 = icmp eq ptr %y1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.32)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %y1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.33)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeSetNode$String", ptr %y3, i32 0, i32 2
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.34)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %x7, i32 0, i32 3
  %right10 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right10, ptr %left6, align 8, !tbaa !0
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.35)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %right14 = getelementptr inbounds %"class.TreeSetNode$String", ptr %x11, i32 0, i32 3
  %y15 = load ptr, ptr %y, align 8
  store ptr %y15, ptr %right14, align 8, !tbaa !0
  %y16 = load ptr, ptr %y, align 8
  call void @"TreeSet$String.fixHeight"(ptr %0, ptr %y16)
  %x17 = load ptr, ptr %x, align 8
  call void @"TreeSet$String.fixHeight"(ptr %0, ptr %x17)
  %x18 = load ptr, ptr %x, align 8
  ret ptr %x18
}

define internal ptr @"TreeSet$String.rotateLeft"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %2 = icmp eq ptr %x1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.36)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %x1, i32 0, i32 3
  %right2 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.37)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeSetNode$String", ptr %x3, i32 0, i32 3
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.38)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %y7, i32 0, i32 2
  %left10 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left10, ptr %right6, align 8, !tbaa !0
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.39)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %left14 = getelementptr inbounds %"class.TreeSetNode$String", ptr %y11, i32 0, i32 2
  %x15 = load ptr, ptr %x, align 8
  store ptr %x15, ptr %left14, align 8, !tbaa !0
  %x16 = load ptr, ptr %x, align 8
  call void @"TreeSet$String.fixHeight"(ptr %0, ptr %x16)
  %y17 = load ptr, ptr %y, align 8
  call void @"TreeSet$String.fixHeight"(ptr %0, ptr %y17)
  %y18 = load ptr, ptr %y, align 8
  ret ptr %y18
}

define internal ptr @"TreeSet$String.insertNode"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2) {
entry:
  %bf = alloca i32, align 4
  %c = alloca i32, align 4
  %value = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store ptr %2, ptr %value, align 8
  %node1 = load ptr, ptr %node, align 8
  %3 = icmp eq ptr %node1, null
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %5 = add i32 %count3, 1
  store i32 %5, ptr %count, align 4, !tbaa !4
  %"TreeSetNode$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeSetNode$String", ptr null, i64 1) to i64))
  %value4 = load ptr, ptr %value, align 8
  call void @"TreeSetNode$String.TreeSetNode$String"(ptr %"TreeSetNode$String.obj", ptr %value4)
  ret ptr %"TreeSetNode$String.obj"

if.end:                                           ; preds = %entry
  %value5 = load ptr, ptr %value, align 8
  %node6 = load ptr, ptr %node, align 8
  %6 = icmp eq ptr %node6, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.40)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %value7 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node6, i32 0, i32 1
  %value8 = load ptr, ptr %value7, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %value5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data9 = getelementptr inbounds %String, ptr %value8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %7 = call i32 @strcmp(ptr %data, ptr %data10)
  store i32 %7, ptr %c, align 4
  %c11 = load i32, ptr %c, align 4
  %8 = icmp eq i32 %c11, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then12, label %if.end13

if.then12:                                        ; preds = %nullrecv.ok
  %node14 = load ptr, ptr %node, align 8
  ret ptr %node14

if.end13:                                         ; preds = %nullrecv.ok
  %c15 = load i32, ptr %c, align 4
  %10 = icmp slt i32 %c15, 0
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then16, label %if.else

if.then16:                                        ; preds = %if.end13
  %node18 = load ptr, ptr %node, align 8
  %12 = icmp eq ptr %node18, null
  br i1 %12, label %nullrecv19, label %nullrecv.ok20

if.else:                                          ; preds = %if.end13
  %node27 = load ptr, ptr %node, align 8
  %13 = icmp eq ptr %node27, null
  br i1 %13, label %nullrecv28, label %nullrecv.ok29

if.end17:                                         ; preds = %nullrecv.ok32, %nullrecv.ok23
  %node36 = load ptr, ptr %node, align 8
  call void @"TreeSet$String.fixHeight"(ptr %0, ptr %node36)
  %node37 = load ptr, ptr %node, align 8
  %14 = call i32 @"TreeSet$String.balance"(ptr %0, ptr %node37)
  store i32 %14, ptr %bf, align 4
  %bf38 = load i32, ptr %bf, align 4
  %15 = icmp sgt i32 %bf38, 1
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then39, label %if.end40

nullrecv19:                                       ; preds = %if.then16
  call void @__polaron_panic(ptr @.panic.41)
  unreachable

nullrecv.ok20:                                    ; preds = %if.then16
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %node18, i32 0, i32 2
  %node21 = load ptr, ptr %node, align 8
  %17 = icmp eq ptr %node21, null
  br i1 %17, label %nullrecv22, label %nullrecv.ok23

nullrecv22:                                       ; preds = %nullrecv.ok20
  call void @__polaron_panic(ptr @.panic.42)
  unreachable

nullrecv.ok23:                                    ; preds = %nullrecv.ok20
  %left24 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node21, i32 0, i32 2
  %left25 = load ptr, ptr %left24, align 8, !tbaa !0
  %value26 = load ptr, ptr %value, align 8
  %18 = call ptr @"TreeSet$String.insertNode"(ptr %0, ptr %left25, ptr %value26)
  store ptr %18, ptr %left, align 8, !tbaa !0
  br label %if.end17

nullrecv28:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.43)
  unreachable

nullrecv.ok29:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %node27, i32 0, i32 3
  %node30 = load ptr, ptr %node, align 8
  %19 = icmp eq ptr %node30, null
  br i1 %19, label %nullrecv31, label %nullrecv.ok32

nullrecv31:                                       ; preds = %nullrecv.ok29
  call void @__polaron_panic(ptr @.panic.44)
  unreachable

nullrecv.ok32:                                    ; preds = %nullrecv.ok29
  %right33 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node30, i32 0, i32 3
  %right34 = load ptr, ptr %right33, align 8, !tbaa !0
  %value35 = load ptr, ptr %value, align 8
  %20 = call ptr @"TreeSet$String.insertNode"(ptr %0, ptr %right34, ptr %value35)
  store ptr %20, ptr %right, align 8, !tbaa !0
  br label %if.end17

if.then39:                                        ; preds = %if.end17
  %node41 = load ptr, ptr %node, align 8
  %21 = icmp eq ptr %node41, null
  br i1 %21, label %nullrecv42, label %nullrecv.ok43

if.end40:                                         ; preds = %if.end17
  %bf58 = load i32, ptr %bf, align 4
  %22 = icmp slt i32 %bf58, -1
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then59, label %if.end60

nullrecv42:                                       ; preds = %if.then39
  call void @__polaron_panic(ptr @.panic.45)
  unreachable

nullrecv.ok43:                                    ; preds = %if.then39
  %left44 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node41, i32 0, i32 2
  %left45 = load ptr, ptr %left44, align 8, !tbaa !0
  %24 = call i32 @"TreeSet$String.balance"(ptr %0, ptr %left45)
  %25 = icmp slt i32 %24, 0
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then46, label %if.end47

if.then46:                                        ; preds = %nullrecv.ok43
  %node48 = load ptr, ptr %node, align 8
  %27 = icmp eq ptr %node48, null
  br i1 %27, label %nullrecv49, label %nullrecv.ok50

if.end47:                                         ; preds = %nullrecv.ok54, %nullrecv.ok43
  %node57 = load ptr, ptr %node, align 8
  %28 = call ptr @"TreeSet$String.rotateRight"(ptr %0, ptr %node57)
  ret ptr %28

nullrecv49:                                       ; preds = %if.then46
  call void @__polaron_panic(ptr @.panic.46)
  unreachable

nullrecv.ok50:                                    ; preds = %if.then46
  %left51 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node48, i32 0, i32 2
  %node52 = load ptr, ptr %node, align 8
  %29 = icmp eq ptr %node52, null
  br i1 %29, label %nullrecv53, label %nullrecv.ok54

nullrecv53:                                       ; preds = %nullrecv.ok50
  call void @__polaron_panic(ptr @.panic.47)
  unreachable

nullrecv.ok54:                                    ; preds = %nullrecv.ok50
  %left55 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node52, i32 0, i32 2
  %left56 = load ptr, ptr %left55, align 8, !tbaa !0
  %30 = call ptr @"TreeSet$String.rotateLeft"(ptr %0, ptr %left56)
  store ptr %30, ptr %left51, align 8, !tbaa !0
  br label %if.end47

if.then59:                                        ; preds = %if.end40
  %node61 = load ptr, ptr %node, align 8
  %31 = icmp eq ptr %node61, null
  br i1 %31, label %nullrecv62, label %nullrecv.ok63

if.end60:                                         ; preds = %if.end40
  %node78 = load ptr, ptr %node, align 8
  ret ptr %node78

nullrecv62:                                       ; preds = %if.then59
  call void @__polaron_panic(ptr @.panic.48)
  unreachable

nullrecv.ok63:                                    ; preds = %if.then59
  %right64 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node61, i32 0, i32 3
  %right65 = load ptr, ptr %right64, align 8, !tbaa !0
  %32 = call i32 @"TreeSet$String.balance"(ptr %0, ptr %right65)
  %33 = icmp sgt i32 %32, 0
  %34 = zext i1 %33 to i32
  br i1 %33, label %if.then66, label %if.end67

if.then66:                                        ; preds = %nullrecv.ok63
  %node68 = load ptr, ptr %node, align 8
  %35 = icmp eq ptr %node68, null
  br i1 %35, label %nullrecv69, label %nullrecv.ok70

if.end67:                                         ; preds = %nullrecv.ok74, %nullrecv.ok63
  %node77 = load ptr, ptr %node, align 8
  %36 = call ptr @"TreeSet$String.rotateLeft"(ptr %0, ptr %node77)
  ret ptr %36

nullrecv69:                                       ; preds = %if.then66
  call void @__polaron_panic(ptr @.panic.49)
  unreachable

nullrecv.ok70:                                    ; preds = %if.then66
  %right71 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node68, i32 0, i32 3
  %node72 = load ptr, ptr %node, align 8
  %37 = icmp eq ptr %node72, null
  br i1 %37, label %nullrecv73, label %nullrecv.ok74

nullrecv73:                                       ; preds = %nullrecv.ok70
  call void @__polaron_panic(ptr @.panic.50)
  unreachable

nullrecv.ok74:                                    ; preds = %nullrecv.ok70
  %right75 = getelementptr inbounds %"class.TreeSetNode$String", ptr %node72, i32 0, i32 3
  %right76 = load ptr, ptr %right75, align 8, !tbaa !0
  %38 = call ptr @"TreeSet$String.rotateRight"(ptr %0, ptr %right76)
  store ptr %38, ptr %right71, align 8, !tbaa !0
  br label %if.end67
}

define internal i32 @"TreeSet$String.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %cur = alloca ptr, align 8
  %value = alloca ptr, align 8
  store ptr %1, ptr %value, align 8
  %root = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end12, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %value3 = load ptr, ptr %value, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  ret i32 0

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.51)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %value5 = getelementptr inbounds %"class.TreeSetNode$String", ptr %cur4, i32 0, i32 1
  %value6 = load ptr, ptr %value5, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %value3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %value6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %5 = call i32 @strcmp(ptr %data, ptr %data8)
  store i32 %5, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c9, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  ret i32 1

if.end:                                           ; preds = %nullrecv.ok
  %c10 = load i32, ptr %c, align 4
  %8 = icmp slt i32 %c10, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then11, label %if.else

if.then11:                                        ; preds = %if.end
  %cur13 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur13, null
  br i1 %10, label %nullrecv14, label %nullrecv.ok15

if.else:                                          ; preds = %if.end
  %cur17 = load ptr, ptr %cur, align 8
  %11 = icmp eq ptr %cur17, null
  br i1 %11, label %nullrecv18, label %nullrecv.ok19

if.end12:                                         ; preds = %nullrecv.ok19, %nullrecv.ok15
  br label %while.cond

nullrecv14:                                       ; preds = %if.then11
  call void @__polaron_panic(ptr @.panic.52)
  unreachable

nullrecv.ok15:                                    ; preds = %if.then11
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %cur13, i32 0, i32 2
  %left16 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left16, ptr %cur, align 8
  br label %if.end12

nullrecv18:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.53)
  unreachable

nullrecv.ok19:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %cur17, i32 0, i32 3
  %right20 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right20, ptr %cur, align 8
  br label %if.end12
}

define internal i32 @"TreeSet$String.fill"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
entry:
  %i = alloca i32, align 4
  %idx = alloca i32, align 4
  %out = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store ptr %2, ptr %out, align 8
  store i32 %3, ptr %idx, align 4
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %idx2 = load i32, ptr %idx, align 4
  ret i32 %idx2

if.end:                                           ; preds = %entry
  %node3 = load ptr, ptr %node, align 8
  %6 = icmp eq ptr %node3, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.54)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %node3, i32 0, i32 2
  %left4 = load ptr, ptr %left, align 8, !tbaa !0
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeSet$String.fill"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
  store i32 %7, ptr %i, align 4
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i8 = load i32, ptr %i, align 4
  %8 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %out7, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %nullrecv.ok
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %8, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.55)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %value = getelementptr inbounds %"class.TreeSetNode$String", ptr %node9, i32 0, i32 1
  %value12 = load ptr, ptr %value, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %value12)
  %10 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy, ptr %arr.elem, align 8
  %i13 = load i32, ptr %i, align 4
  %11 = add i32 %i13, 1
  store i32 %11, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %12 = icmp eq ptr %node14, null
  br i1 %12, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.56)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %node14, i32 0, i32 3
  %right17 = load ptr, ptr %right, align 8, !tbaa !0
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %13 = call i32 @"TreeSet$String.fill"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %13
}

define internal ptr @"TreeSet$String.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 8
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !0
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeSet$String.fill"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal i32 @"TreeSet$String.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"TreeSet$String.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"TreeSetNode$String.TreeSetNode$String"(ptr %0, ptr %1) {
entry:
  %v = alloca ptr, align 8
  store ptr %1, ptr %v, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$String", ptr %0, i32 0, i32 0
  store ptr @"TreeSetNode$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %value = getelementptr inbounds %"class.TreeSetNode$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %value, align 8, !tbaa !0
  %value1 = getelementptr inbounds %"class.TreeSetNode$String", ptr %0, i32 0, i32 1
  %v2 = load ptr, ptr %v, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %v2)
  %2 = load ptr, ptr %value1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %value1, align 8, !tbaa !0
  %left = getelementptr inbounds %"class.TreeSetNode$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %"class.TreeSetNode$String", ptr %0, i32 0, i32 3
  store ptr null, ptr %right, align 8, !tbaa !0
  %height = getelementptr inbounds %"class.TreeSetNode$String", ptr %0, i32 0, i32 4
  store i32 1, ptr %height, align 4, !tbaa !4
  ret void
}

define internal void @"TreeMap$String$int.TreeMap$String$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 0
  store ptr @"TreeMap$String$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %root, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeMap$String$int.~TreeMap$String$int"(ptr %0) {
entry:
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  call void @"TreeMap$String$int.freeSubtree"(ptr %0, ptr %root1)
  %root2 = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %root2, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeMap$String$int.freeSubtree"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %n2 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n2, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.57)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %n2, i32 0, i32 3
  %left3 = load ptr, ptr %left, align 8, !tbaa !0
  call void @"TreeMap$String$int.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.58)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %n4, i32 0, i32 4
  %right7 = load ptr, ptr %right, align 8, !tbaa !0
  call void @"TreeMap$String$int.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.59)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeNode$String$int", ptr %n8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [371 x ptr], ptr %vtbl, i64 0, i64 370
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %7 = icmp ne ptr %dtor.fn, null
  br i1 %7, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %nullrecv.ok10
  call void %dtor.fn(ptr %n8)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %nullrecv.ok10
  %key.sfree = getelementptr inbounds %"class.TreeNode$String$int", ptr %n8, i32 0, i32 1
  %8 = load ptr, ptr %key.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %8)
  call void @__polaron_free(ptr %n8)
  ret void
}

define internal void @"TreeMap$String$int.put"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root1, align 8, !tbaa !0
  %key3 = load ptr, ptr %key, align 8
  %value4 = load i32, ptr %value, align 4
  %3 = call ptr @"TreeMap$String$int.insertNode"(ptr %0, ptr %root2, ptr %key3, i32 %value4)
  store ptr %3, ptr %root, align 8, !tbaa !0
  ret void
}

define internal i32 @"TreeMap$String$int.nodeHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %n2 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n2, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.60)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %height = getelementptr inbounds %"class.TreeNode$String$int", ptr %n2, i32 0, i32 5
  %height3 = load i32, ptr %height, align 4, !tbaa !4
  ret i32 %height3
}

define internal void @"TreeMap$String$int.fixHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rh = alloca i32, align 4
  %lh = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.61)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %n1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeMap$String$int.nodeHeight"(ptr %0, ptr %left2)
  store i32 %3, ptr %lh, align 4
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.62)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %n3, i32 0, i32 4
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeMap$String$int.nodeHeight"(ptr %0, ptr %right6)
  store i32 %5, ptr %rh, align 4
  %lh7 = load i32, ptr %lh, align 4
  %rh8 = load i32, ptr %rh, align 4
  %6 = icmp sgt i32 %lh7, %rh8
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.else

if.then:                                          ; preds = %nullrecv.ok5
  %n9 = load ptr, ptr %n, align 8
  %8 = icmp eq ptr %n9, null
  br i1 %8, label %nullrecv10, label %nullrecv.ok11

if.else:                                          ; preds = %nullrecv.ok5
  %n13 = load ptr, ptr %n, align 8
  %9 = icmp eq ptr %n13, null
  br i1 %9, label %nullrecv14, label %nullrecv.ok15

if.end:                                           ; preds = %nullrecv.ok15, %nullrecv.ok11
  ret void

nullrecv10:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.63)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeNode$String$int", ptr %n9, i32 0, i32 5
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !4
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.64)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %height16 = getelementptr inbounds %"class.TreeNode$String$int", ptr %n13, i32 0, i32 5
  %rh17 = load i32, ptr %rh, align 4
  %11 = add i32 %rh17, 1
  store i32 %11, ptr %height16, align 4, !tbaa !4
  br label %if.end
}

define internal i32 @"TreeMap$String$int.balance"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.65)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %n1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeMap$String$int.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.66)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %n3, i32 0, i32 4
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeMap$String$int.nodeHeight"(ptr %0, ptr %right6)
  %6 = sub i32 %3, %5
  ret i32 %6
}

define internal ptr @"TreeMap$String$int.rotateRight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %1, ptr %y, align 8
  %y1 = load ptr, ptr %y, align 8
  %2 = icmp eq ptr %y1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.67)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %y1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.68)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeNode$String$int", ptr %y3, i32 0, i32 3
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.69)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %x7, i32 0, i32 4
  %right10 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right10, ptr %left6, align 8, !tbaa !0
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.70)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %right14 = getelementptr inbounds %"class.TreeNode$String$int", ptr %x11, i32 0, i32 4
  %y15 = load ptr, ptr %y, align 8
  store ptr %y15, ptr %right14, align 8, !tbaa !0
  %y16 = load ptr, ptr %y, align 8
  call void @"TreeMap$String$int.fixHeight"(ptr %0, ptr %y16)
  %x17 = load ptr, ptr %x, align 8
  call void @"TreeMap$String$int.fixHeight"(ptr %0, ptr %x17)
  %x18 = load ptr, ptr %x, align 8
  ret ptr %x18
}

define internal ptr @"TreeMap$String$int.rotateLeft"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %2 = icmp eq ptr %x1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.71)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %x1, i32 0, i32 4
  %right2 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.72)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeNode$String$int", ptr %x3, i32 0, i32 4
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.73)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %y7, i32 0, i32 3
  %left10 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left10, ptr %right6, align 8, !tbaa !0
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.74)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %left14 = getelementptr inbounds %"class.TreeNode$String$int", ptr %y11, i32 0, i32 3
  %x15 = load ptr, ptr %x, align 8
  store ptr %x15, ptr %left14, align 8, !tbaa !0
  %x16 = load ptr, ptr %x, align 8
  call void @"TreeMap$String$int.fixHeight"(ptr %0, ptr %x16)
  %y17 = load ptr, ptr %y, align 8
  call void @"TreeMap$String$int.fixHeight"(ptr %0, ptr %y17)
  %y18 = load ptr, ptr %y, align 8
  ret ptr %y18
}

define internal ptr @"TreeMap$String$int.insertNode"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
entry:
  %bf = alloca i32, align 4
  %c = alloca i32, align 4
  %value = alloca i32, align 4
  %key = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store ptr %2, ptr %key, align 8
  store i32 %3, ptr %value, align 4
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %6 = add i32 %count3, 1
  store i32 %6, ptr %count, align 4, !tbaa !4
  %"TreeNode$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeNode$String$int", ptr null, i64 1) to i64))
  %key4 = load ptr, ptr %key, align 8
  %value5 = load i32, ptr %value, align 4
  call void @"TreeNode$String$int.TreeNode$String$int"(ptr %"TreeNode$String$int.obj", ptr %key4, i32 %value5)
  ret ptr %"TreeNode$String$int.obj"

if.end:                                           ; preds = %entry
  %key6 = load ptr, ptr %key, align 8
  %node7 = load ptr, ptr %node, align 8
  %7 = icmp eq ptr %node7, null
  br i1 %7, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.75)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %key8 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node7, i32 0, i32 1
  %key9 = load ptr, ptr %key8, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %key6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data10 = getelementptr inbounds %String, ptr %key9, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %8 = call i32 @strcmp(ptr %data, ptr %data11)
  store i32 %8, ptr %c, align 4
  %c12 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c12, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then13, label %if.end14

if.then13:                                        ; preds = %nullrecv.ok
  %node15 = load ptr, ptr %node, align 8
  %11 = icmp eq ptr %node15, null
  br i1 %11, label %nullrecv16, label %nullrecv.ok17

if.end14:                                         ; preds = %nullrecv.ok
  %c21 = load i32, ptr %c, align 4
  %12 = icmp slt i32 %c21, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then22, label %if.else

nullrecv16:                                       ; preds = %if.then13
  call void @__polaron_panic(ptr @.panic.76)
  unreachable

nullrecv.ok17:                                    ; preds = %if.then13
  %value18 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node15, i32 0, i32 2
  %value19 = load i32, ptr %value, align 4
  store i32 %value19, ptr %value18, align 4, !tbaa !4
  %node20 = load ptr, ptr %node, align 8
  ret ptr %node20

if.then22:                                        ; preds = %if.end14
  %node24 = load ptr, ptr %node, align 8
  %14 = icmp eq ptr %node24, null
  br i1 %14, label %nullrecv25, label %nullrecv.ok26

if.else:                                          ; preds = %if.end14
  %node34 = load ptr, ptr %node, align 8
  %15 = icmp eq ptr %node34, null
  br i1 %15, label %nullrecv35, label %nullrecv.ok36

if.end23:                                         ; preds = %nullrecv.ok39, %nullrecv.ok29
  %node44 = load ptr, ptr %node, align 8
  call void @"TreeMap$String$int.fixHeight"(ptr %0, ptr %node44)
  %node45 = load ptr, ptr %node, align 8
  %16 = call i32 @"TreeMap$String$int.balance"(ptr %0, ptr %node45)
  store i32 %16, ptr %bf, align 4
  %bf46 = load i32, ptr %bf, align 4
  %17 = icmp sgt i32 %bf46, 1
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then47, label %if.end48

nullrecv25:                                       ; preds = %if.then22
  call void @__polaron_panic(ptr @.panic.77)
  unreachable

nullrecv.ok26:                                    ; preds = %if.then22
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %node24, i32 0, i32 3
  %node27 = load ptr, ptr %node, align 8
  %19 = icmp eq ptr %node27, null
  br i1 %19, label %nullrecv28, label %nullrecv.ok29

nullrecv28:                                       ; preds = %nullrecv.ok26
  call void @__polaron_panic(ptr @.panic.78)
  unreachable

nullrecv.ok29:                                    ; preds = %nullrecv.ok26
  %left30 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node27, i32 0, i32 3
  %left31 = load ptr, ptr %left30, align 8, !tbaa !0
  %key32 = load ptr, ptr %key, align 8
  %value33 = load i32, ptr %value, align 4
  %20 = call ptr @"TreeMap$String$int.insertNode"(ptr %0, ptr %left31, ptr %key32, i32 %value33)
  store ptr %20, ptr %left, align 8, !tbaa !0
  br label %if.end23

nullrecv35:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.79)
  unreachable

nullrecv.ok36:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %node34, i32 0, i32 4
  %node37 = load ptr, ptr %node, align 8
  %21 = icmp eq ptr %node37, null
  br i1 %21, label %nullrecv38, label %nullrecv.ok39

nullrecv38:                                       ; preds = %nullrecv.ok36
  call void @__polaron_panic(ptr @.panic.80)
  unreachable

nullrecv.ok39:                                    ; preds = %nullrecv.ok36
  %right40 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node37, i32 0, i32 4
  %right41 = load ptr, ptr %right40, align 8, !tbaa !0
  %key42 = load ptr, ptr %key, align 8
  %value43 = load i32, ptr %value, align 4
  %22 = call ptr @"TreeMap$String$int.insertNode"(ptr %0, ptr %right41, ptr %key42, i32 %value43)
  store ptr %22, ptr %right, align 8, !tbaa !0
  br label %if.end23

if.then47:                                        ; preds = %if.end23
  %node49 = load ptr, ptr %node, align 8
  %23 = icmp eq ptr %node49, null
  br i1 %23, label %nullrecv50, label %nullrecv.ok51

if.end48:                                         ; preds = %if.end23
  %bf66 = load i32, ptr %bf, align 4
  %24 = icmp slt i32 %bf66, -1
  %25 = zext i1 %24 to i32
  br i1 %24, label %if.then67, label %if.end68

nullrecv50:                                       ; preds = %if.then47
  call void @__polaron_panic(ptr @.panic.81)
  unreachable

nullrecv.ok51:                                    ; preds = %if.then47
  %left52 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node49, i32 0, i32 3
  %left53 = load ptr, ptr %left52, align 8, !tbaa !0
  %26 = call i32 @"TreeMap$String$int.balance"(ptr %0, ptr %left53)
  %27 = icmp slt i32 %26, 0
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then54, label %if.end55

if.then54:                                        ; preds = %nullrecv.ok51
  %node56 = load ptr, ptr %node, align 8
  %29 = icmp eq ptr %node56, null
  br i1 %29, label %nullrecv57, label %nullrecv.ok58

if.end55:                                         ; preds = %nullrecv.ok62, %nullrecv.ok51
  %node65 = load ptr, ptr %node, align 8
  %30 = call ptr @"TreeMap$String$int.rotateRight"(ptr %0, ptr %node65)
  ret ptr %30

nullrecv57:                                       ; preds = %if.then54
  call void @__polaron_panic(ptr @.panic.82)
  unreachable

nullrecv.ok58:                                    ; preds = %if.then54
  %left59 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node56, i32 0, i32 3
  %node60 = load ptr, ptr %node, align 8
  %31 = icmp eq ptr %node60, null
  br i1 %31, label %nullrecv61, label %nullrecv.ok62

nullrecv61:                                       ; preds = %nullrecv.ok58
  call void @__polaron_panic(ptr @.panic.83)
  unreachable

nullrecv.ok62:                                    ; preds = %nullrecv.ok58
  %left63 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node60, i32 0, i32 3
  %left64 = load ptr, ptr %left63, align 8, !tbaa !0
  %32 = call ptr @"TreeMap$String$int.rotateLeft"(ptr %0, ptr %left64)
  store ptr %32, ptr %left59, align 8, !tbaa !0
  br label %if.end55

if.then67:                                        ; preds = %if.end48
  %node69 = load ptr, ptr %node, align 8
  %33 = icmp eq ptr %node69, null
  br i1 %33, label %nullrecv70, label %nullrecv.ok71

if.end68:                                         ; preds = %if.end48
  %node86 = load ptr, ptr %node, align 8
  ret ptr %node86

nullrecv70:                                       ; preds = %if.then67
  call void @__polaron_panic(ptr @.panic.84)
  unreachable

nullrecv.ok71:                                    ; preds = %if.then67
  %right72 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node69, i32 0, i32 4
  %right73 = load ptr, ptr %right72, align 8, !tbaa !0
  %34 = call i32 @"TreeMap$String$int.balance"(ptr %0, ptr %right73)
  %35 = icmp sgt i32 %34, 0
  %36 = zext i1 %35 to i32
  br i1 %35, label %if.then74, label %if.end75

if.then74:                                        ; preds = %nullrecv.ok71
  %node76 = load ptr, ptr %node, align 8
  %37 = icmp eq ptr %node76, null
  br i1 %37, label %nullrecv77, label %nullrecv.ok78

if.end75:                                         ; preds = %nullrecv.ok82, %nullrecv.ok71
  %node85 = load ptr, ptr %node, align 8
  %38 = call ptr @"TreeMap$String$int.rotateLeft"(ptr %0, ptr %node85)
  ret ptr %38

nullrecv77:                                       ; preds = %if.then74
  call void @__polaron_panic(ptr @.panic.85)
  unreachable

nullrecv.ok78:                                    ; preds = %if.then74
  %right79 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node76, i32 0, i32 4
  %node80 = load ptr, ptr %node, align 8
  %39 = icmp eq ptr %node80, null
  br i1 %39, label %nullrecv81, label %nullrecv.ok82

nullrecv81:                                       ; preds = %nullrecv.ok78
  call void @__polaron_panic(ptr @.panic.86)
  unreachable

nullrecv.ok82:                                    ; preds = %nullrecv.ok78
  %right83 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node80, i32 0, i32 4
  %right84 = load ptr, ptr %right83, align 8, !tbaa !0
  %40 = call ptr @"TreeMap$String$int.rotateRight"(ptr %0, ptr %right84)
  store ptr %40, ptr %right79, align 8, !tbaa !0
  br label %if.end75
}

define internal ptr @"TreeMap$String$int.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %cur = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end13, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load ptr, ptr %key, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  ret ptr null

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.87)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 1
  %key6 = load ptr, ptr %key5, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %key3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %key6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %5 = call i32 @strcmp(ptr %data, ptr %data8)
  store i32 %5, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %6 = icmp eq i32 %c9, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur10 = load ptr, ptr %cur, align 8
  ret ptr %cur10

if.end:                                           ; preds = %nullrecv.ok
  %c11 = load i32, ptr %c, align 4
  %8 = icmp slt i32 %c11, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then12, label %if.else

if.then12:                                        ; preds = %if.end
  %cur14 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur14, null
  br i1 %10, label %nullrecv15, label %nullrecv.ok16

if.else:                                          ; preds = %if.end
  %cur18 = load ptr, ptr %cur, align 8
  %11 = icmp eq ptr %cur18, null
  br i1 %11, label %nullrecv19, label %nullrecv.ok20

if.end13:                                         ; preds = %nullrecv.ok20, %nullrecv.ok16
  br label %while.cond

nullrecv15:                                       ; preds = %if.then12
  call void @__polaron_panic(ptr @.panic.88)
  unreachable

nullrecv.ok16:                                    ; preds = %if.then12
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur14, i32 0, i32 3
  %left17 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left17, ptr %cur, align 8
  br label %if.end13

nullrecv19:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.89)
  unreachable

nullrecv.ok20:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur18, i32 0, i32 4
  %right21 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right21, ptr %cur, align 8
  br label %if.end13
}

define internal i32 @"TreeMap$String$int.get"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %z = alloca i32, align 4
  %zero = alloca ptr, align 8
  %n = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %key1 = load ptr, ptr %key, align 8
  %2 = call ptr @"TreeMap$String$int.find"(ptr %0, ptr %key1)
  store ptr %2, ptr %n, align 8
  %n2 = load ptr, ptr %n, align 8
  %3 = icmp ne ptr %n2, null
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %n3 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n3, null
  br i1 %5, label %nullrecv, label %nullrecv.ok

if.end:                                           ; preds = %entry
  %arr = call ptr @__polaron_malloc(i64 12)
  store i64 1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 4)
  store ptr %arr, ptr %zero, align 8
  %zero5 = load ptr, ptr %zero, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %zero5, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

nullrecv:                                         ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.90)
  unreachable

nullrecv.ok:                                      ; preds = %if.then
  %value = getelementptr inbounds %"class.TreeNode$String$int", ptr %n3, i32 0, i32 2
  %value4 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value4

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.91, ptr @.faila.92, i64 0, ptr @.failb.93, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data6 = getelementptr i8, ptr %zero5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %z, align 4
  %zero7 = load ptr, ptr %zero, align 8
  call void @__polaron_free(ptr %zero7)
  %z8 = load i32, ptr %z, align 4
  ret i32 %z8
}

define internal i32 @"TreeMap$String$int.containsKey"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %key1 = load ptr, ptr %key, align 8
  %2 = call ptr @"TreeMap$String$int.find"(ptr %0, ptr %key1)
  %3 = icmp ne ptr %2, null
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @"TreeMap$String$int.fillKeys"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
entry:
  %i = alloca i32, align 4
  %idx = alloca i32, align 4
  %out = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store ptr %2, ptr %out, align 8
  store i32 %3, ptr %idx, align 4
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %idx2 = load i32, ptr %idx, align 4
  ret i32 %idx2

if.end:                                           ; preds = %entry
  %node3 = load ptr, ptr %node, align 8
  %6 = icmp eq ptr %node3, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.94)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %node3, i32 0, i32 3
  %left4 = load ptr, ptr %left, align 8, !tbaa !0
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeMap$String$int.fillKeys"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
  store i32 %7, ptr %i, align 4
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i8 = load i32, ptr %i, align 4
  %8 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %out7, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %nullrecv.ok
  call void @__polaron_fail(ptr @.fail.95, ptr @.faila.96, i64 %8, ptr @.failb.97, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.98)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %key = getelementptr inbounds %"class.TreeNode$String$int", ptr %node9, i32 0, i32 1
  %key12 = load ptr, ptr %key, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %key12)
  %10 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy, ptr %arr.elem, align 8
  %i13 = load i32, ptr %i, align 4
  %11 = add i32 %i13, 1
  store i32 %11, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %12 = icmp eq ptr %node14, null
  br i1 %12, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.99)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %node14, i32 0, i32 4
  %right17 = load ptr, ptr %right, align 8, !tbaa !0
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %13 = call i32 @"TreeMap$String$int.fillKeys"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %13
}

define internal i32 @"TreeMap$String$int.fillValues"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
entry:
  %i = alloca i32, align 4
  %idx = alloca i32, align 4
  %out = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store ptr %2, ptr %out, align 8
  store i32 %3, ptr %idx, align 4
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %idx2 = load i32, ptr %idx, align 4
  ret i32 %idx2

if.end:                                           ; preds = %entry
  %node3 = load ptr, ptr %node, align 8
  %6 = icmp eq ptr %node3, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.100)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %node3, i32 0, i32 3
  %left4 = load ptr, ptr %left, align 8, !tbaa !0
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeMap$String$int.fillValues"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
  store i32 %7, ptr %i, align 4
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i8 = load i32, ptr %i, align 4
  %8 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %out7, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %nullrecv.ok
  call void @__polaron_fail(ptr @.fail.101, ptr @.faila.102, i64 %8, ptr @.failb.103, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.104)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %value = getelementptr inbounds %"class.TreeNode$String$int", ptr %node9, i32 0, i32 2
  %value12 = load i32, ptr %value, align 4, !tbaa !4
  store i32 %value12, ptr %arr.elem, align 4
  %i13 = load i32, ptr %i, align 4
  %10 = add i32 %i13, 1
  store i32 %10, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %11 = icmp eq ptr %node14, null
  br i1 %11, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.105)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %node14, i32 0, i32 4
  %right17 = load ptr, ptr %right, align 8, !tbaa !0
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %12 = call i32 @"TreeMap$String$int.fillValues"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %12
}

define internal ptr @"TreeMap$String$int.keyArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 8
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !0
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeMap$String$int.fillKeys"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal ptr @"TreeMap$String$int.valueArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !0
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeMap$String$int.fillValues"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal ptr @"TreeMap$String$int.zeroKey"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %ae.i = alloca i64, align 8
  %z = alloca ptr, align 8
  %zero = alloca ptr, align 8
  %arr = call ptr @__polaron_malloc(i64 16)
  store i64 1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 8)
  store ptr %arr, ptr %zero, align 8
  %zero1 = load ptr, ptr %zero, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %zero1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.106, ptr @.faila.107, i64 0, ptr @.failb.108, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %zero1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data2, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %z, align 8
  %zero3 = load ptr, ptr %zero, align 8
  %ae.len = load i64, ptr %zero3, align 8
  %arr.data4 = getelementptr i8, ptr %zero3, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

ae.cond:                                          ; preds = %ae.next, %idx.ok
  %ae.iv = load i64, ptr %ae.i, align 8
  %2 = icmp ult i64 %ae.iv, %ae.len
  br i1 %2, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data4, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %3 = icmp ne ptr %ae.el, null
  br i1 %3, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %4 = add i64 %ae.iv, 1
  store i64 %4, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %zero3)
  %z5 = load ptr, ptr %z, align 8
  %strcpy6 = call ptr @__polaron_str_copy(ptr %z5)
  %5 = load ptr, ptr %z, align 8
  call void @__polaron_str_free(ptr %5)
  ret ptr %strcpy6
}

define internal ptr @"TreeMap$String$int.firstKey"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %cur = alloca ptr, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  %1 = icmp eq ptr %root1, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = call ptr @"TreeMap$String$int.zeroKey"(ptr %0)
  %strcpy = call ptr @__polaron_str_copy(ptr %3)
  call void @__polaron_str_free(ptr %3)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %root2 = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root3 = load ptr, ptr %root2, align 8, !tbaa !0
  store ptr %root3, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %nullrecv.ok8, %if.end
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.body:                                       ; preds = %nullrecv.ok
  %cur6 = load ptr, ptr %cur, align 8
  %5 = icmp eq ptr %cur6, null
  br i1 %5, label %nullrecv7, label %nullrecv.ok8

while.end:                                        ; preds = %nullrecv.ok
  %cur11 = load ptr, ptr %cur, align 8
  %6 = icmp eq ptr %cur11, null
  br i1 %6, label %nullrecv12, label %nullrecv.ok13

nullrecv:                                         ; preds = %while.cond
  call void @__polaron_panic(ptr @.panic.109)
  unreachable

nullrecv.ok:                                      ; preds = %while.cond
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 3
  %left5 = load ptr, ptr %left, align 8, !tbaa !0
  %7 = icmp ne ptr %left5, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

nullrecv7:                                        ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.110)
  unreachable

nullrecv.ok8:                                     ; preds = %while.body
  %left9 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur6, i32 0, i32 3
  %left10 = load ptr, ptr %left9, align 8, !tbaa !0
  store ptr %left10, ptr %cur, align 8
  br label %while.cond

nullrecv12:                                       ; preds = %while.end
  call void @__polaron_panic(ptr @.panic.111)
  unreachable

nullrecv.ok13:                                    ; preds = %while.end
  %key = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur11, i32 0, i32 1
  %key14 = load ptr, ptr %key, align 8, !tbaa !0
  %strcpy15 = call ptr @__polaron_str_copy(ptr %key14)
  ret ptr %strcpy15
}

define internal ptr @"TreeMap$String$int.lastKey"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %cur = alloca ptr, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  %1 = icmp eq ptr %root1, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = call ptr @"TreeMap$String$int.zeroKey"(ptr %0)
  %strcpy = call ptr @__polaron_str_copy(ptr %3)
  call void @__polaron_str_free(ptr %3)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %root2 = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root3 = load ptr, ptr %root2, align 8, !tbaa !0
  store ptr %root3, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %nullrecv.ok8, %if.end
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.body:                                       ; preds = %nullrecv.ok
  %cur6 = load ptr, ptr %cur, align 8
  %5 = icmp eq ptr %cur6, null
  br i1 %5, label %nullrecv7, label %nullrecv.ok8

while.end:                                        ; preds = %nullrecv.ok
  %cur11 = load ptr, ptr %cur, align 8
  %6 = icmp eq ptr %cur11, null
  br i1 %6, label %nullrecv12, label %nullrecv.ok13

nullrecv:                                         ; preds = %while.cond
  call void @__polaron_panic(ptr @.panic.112)
  unreachable

nullrecv.ok:                                      ; preds = %while.cond
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 4
  %right5 = load ptr, ptr %right, align 8, !tbaa !0
  %7 = icmp ne ptr %right5, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

nullrecv7:                                        ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.113)
  unreachable

nullrecv.ok8:                                     ; preds = %while.body
  %right9 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur6, i32 0, i32 4
  %right10 = load ptr, ptr %right9, align 8, !tbaa !0
  store ptr %right10, ptr %cur, align 8
  br label %while.cond

nullrecv12:                                       ; preds = %while.end
  call void @__polaron_panic(ptr @.panic.114)
  unreachable

nullrecv.ok13:                                    ; preds = %while.end
  %key = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur11, i32 0, i32 1
  %key14 = load ptr, ptr %key, align 8, !tbaa !0
  %strcpy15 = call ptr @__polaron_str_copy(ptr %key14)
  ret ptr %strcpy15
}

define internal ptr @"TreeMap$String$int.floorKey"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  store ptr null, ptr %best, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end17, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load ptr, ptr %key, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best27 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best27, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then28, label %if.end29

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.115)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 1
  %key6 = load ptr, ptr %key5, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %key3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %key6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %7 = call i32 @strcmp(ptr %data, ptr %data8)
  store i32 %7, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %8 = icmp eq i32 %c9, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur10 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur10, null
  br i1 %10, label %nullrecv11, label %nullrecv.ok12

if.end:                                           ; preds = %nullrecv.ok
  %c15 = load i32, ptr %c, align 4
  %11 = icmp slt i32 %c15, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then16, label %if.else

nullrecv11:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.116)
  unreachable

nullrecv.ok12:                                    ; preds = %if.then
  %key13 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur10, i32 0, i32 1
  %key14 = load ptr, ptr %key13, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %key14)
  ret ptr %strcpy

if.then16:                                        ; preds = %if.end
  %cur18 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur18, null
  br i1 %13, label %nullrecv19, label %nullrecv.ok20

if.else:                                          ; preds = %if.end
  %cur22 = load ptr, ptr %cur, align 8
  store ptr %cur22, ptr %best, align 8
  %cur23 = load ptr, ptr %cur, align 8
  %14 = icmp eq ptr %cur23, null
  br i1 %14, label %nullrecv24, label %nullrecv.ok25

if.end17:                                         ; preds = %nullrecv.ok25, %nullrecv.ok20
  br label %while.cond

nullrecv19:                                       ; preds = %if.then16
  call void @__polaron_panic(ptr @.panic.117)
  unreachable

nullrecv.ok20:                                    ; preds = %if.then16
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur18, i32 0, i32 3
  %left21 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left21, ptr %cur, align 8
  br label %if.end17

nullrecv24:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.118)
  unreachable

nullrecv.ok25:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur23, i32 0, i32 4
  %right26 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right26, ptr %cur, align 8
  br label %if.end17

if.then28:                                        ; preds = %while.end
  %15 = call ptr @"TreeMap$String$int.zeroKey"(ptr %0)
  %strcpy30 = call ptr @__polaron_str_copy(ptr %15)
  call void @__polaron_str_free(ptr %15)
  ret ptr %strcpy30

if.end29:                                         ; preds = %while.end
  %best31 = load ptr, ptr %best, align 8
  %16 = icmp eq ptr %best31, null
  br i1 %16, label %nullrecv32, label %nullrecv.ok33

nullrecv32:                                       ; preds = %if.end29
  call void @__polaron_panic(ptr @.panic.119)
  unreachable

nullrecv.ok33:                                    ; preds = %if.end29
  %key34 = getelementptr inbounds %"class.TreeNode$String$int", ptr %best31, i32 0, i32 1
  %key35 = load ptr, ptr %key34, align 8, !tbaa !0
  %strcpy36 = call ptr @__polaron_str_copy(ptr %key35)
  ret ptr %strcpy36
}

define internal ptr @"TreeMap$String$int.ceilingKey"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  store ptr null, ptr %best, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end17, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load ptr, ptr %key, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best27 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best27, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then28, label %if.end29

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.120)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 1
  %key6 = load ptr, ptr %key5, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %key3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %key6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %7 = call i32 @strcmp(ptr %data, ptr %data8)
  store i32 %7, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %8 = icmp eq i32 %c9, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur10 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur10, null
  br i1 %10, label %nullrecv11, label %nullrecv.ok12

if.end:                                           ; preds = %nullrecv.ok
  %c15 = load i32, ptr %c, align 4
  %11 = icmp sgt i32 %c15, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then16, label %if.else

nullrecv11:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.121)
  unreachable

nullrecv.ok12:                                    ; preds = %if.then
  %key13 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur10, i32 0, i32 1
  %key14 = load ptr, ptr %key13, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %key14)
  ret ptr %strcpy

if.then16:                                        ; preds = %if.end
  %cur18 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur18, null
  br i1 %13, label %nullrecv19, label %nullrecv.ok20

if.else:                                          ; preds = %if.end
  %cur22 = load ptr, ptr %cur, align 8
  store ptr %cur22, ptr %best, align 8
  %cur23 = load ptr, ptr %cur, align 8
  %14 = icmp eq ptr %cur23, null
  br i1 %14, label %nullrecv24, label %nullrecv.ok25

if.end17:                                         ; preds = %nullrecv.ok25, %nullrecv.ok20
  br label %while.cond

nullrecv19:                                       ; preds = %if.then16
  call void @__polaron_panic(ptr @.panic.122)
  unreachable

nullrecv.ok20:                                    ; preds = %if.then16
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur18, i32 0, i32 4
  %right21 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right21, ptr %cur, align 8
  br label %if.end17

nullrecv24:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.123)
  unreachable

nullrecv.ok25:                                    ; preds = %if.else
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur23, i32 0, i32 3
  %left26 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left26, ptr %cur, align 8
  br label %if.end17

if.then28:                                        ; preds = %while.end
  %15 = call ptr @"TreeMap$String$int.zeroKey"(ptr %0)
  %strcpy30 = call ptr @__polaron_str_copy(ptr %15)
  call void @__polaron_str_free(ptr %15)
  ret ptr %strcpy30

if.end29:                                         ; preds = %while.end
  %best31 = load ptr, ptr %best, align 8
  %16 = icmp eq ptr %best31, null
  br i1 %16, label %nullrecv32, label %nullrecv.ok33

nullrecv32:                                       ; preds = %if.end29
  call void @__polaron_panic(ptr @.panic.124)
  unreachable

nullrecv.ok33:                                    ; preds = %if.end29
  %key34 = getelementptr inbounds %"class.TreeNode$String$int", ptr %best31, i32 0, i32 1
  %key35 = load ptr, ptr %key34, align 8, !tbaa !0
  %strcpy36 = call ptr @__polaron_str_copy(ptr %key35)
  ret ptr %strcpy36
}

define internal ptr @"TreeMap$String$int.higherKey"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  store ptr null, ptr %best, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load ptr, ptr %key, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best19 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best19, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then20, label %if.end21

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.125)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 1
  %key6 = load ptr, ptr %key5, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %key3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %key6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %7 = call i32 @strcmp(ptr %data, ptr %data8)
  store i32 %7, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %8 = icmp slt i32 %c9, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.else

if.then:                                          ; preds = %nullrecv.ok
  %cur10 = load ptr, ptr %cur, align 8
  store ptr %cur10, ptr %best, align 8
  %cur11 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur11, null
  br i1 %10, label %nullrecv12, label %nullrecv.ok13

if.else:                                          ; preds = %nullrecv.ok
  %cur15 = load ptr, ptr %cur, align 8
  %11 = icmp eq ptr %cur15, null
  br i1 %11, label %nullrecv16, label %nullrecv.ok17

if.end:                                           ; preds = %nullrecv.ok17, %nullrecv.ok13
  br label %while.cond

nullrecv12:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.126)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur11, i32 0, i32 3
  %left14 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left14, ptr %cur, align 8
  br label %if.end

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.127)
  unreachable

nullrecv.ok17:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur15, i32 0, i32 4
  %right18 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right18, ptr %cur, align 8
  br label %if.end

if.then20:                                        ; preds = %while.end
  %12 = call ptr @"TreeMap$String$int.zeroKey"(ptr %0)
  %strcpy = call ptr @__polaron_str_copy(ptr %12)
  call void @__polaron_str_free(ptr %12)
  ret ptr %strcpy

if.end21:                                         ; preds = %while.end
  %best22 = load ptr, ptr %best, align 8
  %13 = icmp eq ptr %best22, null
  br i1 %13, label %nullrecv23, label %nullrecv.ok24

nullrecv23:                                       ; preds = %if.end21
  call void @__polaron_panic(ptr @.panic.128)
  unreachable

nullrecv.ok24:                                    ; preds = %if.end21
  %key25 = getelementptr inbounds %"class.TreeNode$String$int", ptr %best22, i32 0, i32 1
  %key26 = load ptr, ptr %key25, align 8, !tbaa !0
  %strcpy27 = call ptr @__polaron_str_copy(ptr %key26)
  ret ptr %strcpy27
}

define internal ptr @"TreeMap$String$int.lowerKey"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %root = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  store ptr null, ptr %best, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load ptr, ptr %key, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best19 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best19, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then20, label %if.end21

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.129)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 1
  %key6 = load ptr, ptr %key5, align 8, !tbaa !0
  %str.data = getelementptr inbounds %String, ptr %key3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %key6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %7 = call i32 @strcmp(ptr %data, ptr %data8)
  store i32 %7, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %8 = icmp sgt i32 %c9, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.else

if.then:                                          ; preds = %nullrecv.ok
  %cur10 = load ptr, ptr %cur, align 8
  store ptr %cur10, ptr %best, align 8
  %cur11 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur11, null
  br i1 %10, label %nullrecv12, label %nullrecv.ok13

if.else:                                          ; preds = %nullrecv.ok
  %cur15 = load ptr, ptr %cur, align 8
  %11 = icmp eq ptr %cur15, null
  br i1 %11, label %nullrecv16, label %nullrecv.ok17

if.end:                                           ; preds = %nullrecv.ok17, %nullrecv.ok13
  br label %while.cond

nullrecv12:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.130)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur11, i32 0, i32 4
  %right14 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right14, ptr %cur, align 8
  br label %if.end

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.131)
  unreachable

nullrecv.ok17:                                    ; preds = %if.else
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur15, i32 0, i32 3
  %left18 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left18, ptr %cur, align 8
  br label %if.end

if.then20:                                        ; preds = %while.end
  %12 = call ptr @"TreeMap$String$int.zeroKey"(ptr %0)
  %strcpy = call ptr @__polaron_str_copy(ptr %12)
  call void @__polaron_str_free(ptr %12)
  ret ptr %strcpy

if.end21:                                         ; preds = %while.end
  %best22 = load ptr, ptr %best, align 8
  %13 = icmp eq ptr %best22, null
  br i1 %13, label %nullrecv23, label %nullrecv.ok24

nullrecv23:                                       ; preds = %if.end21
  call void @__polaron_panic(ptr @.panic.132)
  unreachable

nullrecv.ok24:                                    ; preds = %if.end21
  %key25 = getelementptr inbounds %"class.TreeNode$String$int", ptr %best22, i32 0, i32 1
  %key26 = load ptr, ptr %key25, align 8, !tbaa !0
  %strcpy27 = call ptr @__polaron_str_copy(ptr %key26)
  ret ptr %strcpy27
}

define internal i32 @"TreeMap$String$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"TreeMap$String$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeMap$String$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"TreeNode$String$int.TreeNode$String$int"(ptr %0, ptr %1, i32 %2) {
entry:
  %v = alloca i32, align 4
  %k = alloca ptr, align 8
  store ptr %1, ptr %k, align 8
  store i32 %2, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 0
  store ptr @"TreeNode$String$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %key = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %key, align 8, !tbaa !0
  %key1 = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 1
  %k2 = load ptr, ptr %k, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %k2)
  %3 = load ptr, ptr %key1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %key1, align 8, !tbaa !0
  %value = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 2
  %v3 = load i32, ptr %v, align 4
  store i32 %v3, ptr %value, align 4, !tbaa !4
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 4
  store ptr null, ptr %right, align 8, !tbaa !0
  %height = getelementptr inbounds %"class.TreeNode$String$int", ptr %0, i32 0, i32 5
  store i32 1, ptr %height, align 4, !tbaa !4
  ret void
}

define internal void @"Stack$int.Stack$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 0
  store ptr @"Stack$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.133, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"Stack$int.~Stack$int"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"Stack$int.push"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len10 = load i64, ptr %data9, align 8
  %7 = trunc i64 %len10 to i32
  %8 = icmp sge i32 %count7, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data11 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !0
  %len13 = load i64, ptr %data12, align 8
  %10 = trunc i64 %len13 to i32
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
  %data33 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count35 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %16 = sext i32 %count36 to i64
  %arr.len37 = load i64, ptr %data34, align 8
  %arr.oob38 = icmp uge i64 %16, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i14 = load i32, ptr %i, align 4
  %count15 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %17 = icmp slt i32 %i14, %count16
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger17 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i18 = load i32, ptr %i, align 4
  %19 = sext i32 %i18 to i64
  %arr.len = load i64, ptr %bigger17, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok26
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data29 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data30 = load ptr, ptr %data29, align 8, !tbaa !0
  call void @__polaron_free(ptr %data30)
  %data31 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %bigger32 = load ptr, ptr %bigger, align 8
  store ptr %bigger32, ptr %data31, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.134, ptr @.faila.135, i64 %19, ptr @.failb.136, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data19 = getelementptr i8, ptr %bigger17, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data19, i64 %19
  %data20 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i22 = load i32, ptr %i, align 4
  %22 = sext i32 %i22 to i64
  %arr.len23 = load i64, ptr %data21, align 8
  %arr.oob24 = icmp uge i64 %22, %arr.len23
  br i1 %arr.oob24, label %idx.bad25, label %idx.ok26, !prof !8

idx.bad25:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.137, ptr @.faila.138, i64 %22, ptr @.failb.139, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok
  %arr.data27 = getelementptr i8, ptr %data21, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 %22
  %elem = load i32, ptr %arr.elem28, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

idx.bad39:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.140, ptr @.faila.141, i64 %16, ptr @.failb.142, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %if.end
  %arr.data41 = getelementptr i8, ptr %data34, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %16
  %item43 = load i32, ptr %item, align 4
  store i32 %item43, ptr %arr.elem42, align 4
  %count44 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count45 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count46 = load i32, ptr %count45, align 4, !tbaa !4
  %23 = add i32 %count46, 1
  store i32 %23, ptr %count44, align 4, !tbaa !4
  %count47 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count48 = load i32, ptr %count47, align 4, !tbaa !4
  %24 = icmp sge i32 %count48, 0
  %25 = zext i1 %24 to i32
  %contract.ok = icmp ne i32 %25, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok40
  %count49 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count50 = load i32, ptr %count49, align 4, !tbaa !4
  %contract.l = sext i32 %count50 to i64
  call void @__polaron_fail(ptr @.contract.143, ptr @.cl.144, i64 %contract.l, ptr @.cr.145, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok40
  %count51 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %data53 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data54 = load ptr, ptr %data53, align 8, !tbaa !0
  %len55 = load i64, ptr %data54, align 8
  %26 = trunc i64 %len55 to i32
  %27 = icmp sle i32 %count52, %26
  %28 = zext i1 %27 to i32
  %contract.ok56 = icmp ne i32 %28, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

contract.fail57:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.146, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %contract.cont
  ret void
}

define internal i32 @"Stack$int.pop"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count7 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = sub i32 %count8, 1
  store i32 %6, ptr %count6, align 4, !tbaa !4
  %data9 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count11 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %7 = sext i32 %count12 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.147, ptr @.faila.148, i64 %7, ptr @.failb.149, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %7
  %elem = load i32, ptr %arr.elem, align 4
  %count13 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count14 = load i32, ptr %count13, align 4, !tbaa !4
  %8 = icmp sge i32 %count14, 0
  %9 = zext i1 %8 to i32
  %contract.ok = icmp ne i32 %9, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count15 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %contract.l = sext i32 %count16 to i64
  call void @__polaron_fail(ptr @.contract.150, ptr @.cl.151, i64 %contract.l, ptr @.cr.152, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %data19 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data20 = load ptr, ptr %data19, align 8, !tbaa !0
  %len21 = load i64, ptr %data20, align 8
  %10 = trunc i64 %len21 to i32
  %11 = icmp sle i32 %count18, %10
  %12 = zext i1 %11 to i32
  %contract.ok22 = icmp ne i32 %12, 0
  br i1 %contract.ok22, label %contract.cont24, label %contract.fail23

contract.fail23:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.153, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont24:                                  ; preds = %contract.cont
  ret i32 %elem
}

define internal i32 @"Stack$int.peek"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %data6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data7 = load ptr, ptr %data6, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count8 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %6 = sub i32 %count9, 1
  %7 = sext i32 %6 to i64
  %arr.len = load i64, ptr %data7, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.154, ptr @.faila.155, i64 %7, ptr @.failb.156, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %7
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @"Stack$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
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
  %count9 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.157, ptr @.faila.158, i64 %12, ptr @.failb.159, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.160, ptr @.faila.161, i64 %15, ptr @.failb.162, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %15
  %elem = load i32, ptr %arr.elem22, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @"Stack$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"Stack$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.Stack$int", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
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
  call void @__polaron_fail(ptr @.contract.163, ptr @.cl.164, i64 %contract.l, ptr @.cr.165, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.166, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.167, ptr @.cl.168, i64 %contract.l20, ptr @.cr.169, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.170, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.171, ptr @.faila.172, i64 %30, ptr @.failb.173, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.174, ptr @.faila.175, i64 %41, ptr @.failb.176, i64 %arr.len36, i32 70)
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
  call void @__polaron_fail(ptr @.fail.177, ptr @.faila.178, i64 %43, ptr @.failb.179, i64 %arr.len60, i32 70)
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
  call void @__polaron_fail(ptr @.contract.180, ptr @.cl.181, i64 %contract.l, ptr @.cr.182, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.183, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.184, ptr @.cl.185, i64 %contract.l89, ptr @.cr.186, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.187, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.188, ptr @.faila.189, i64 %11, ptr @.failb.190, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.191, ptr @.cl.192, i64 %contract.l, ptr @.cr.193, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.194, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.195, ptr @.cl.196, i64 %contract.l47, ptr @.cr.197, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.198, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.199, ptr @.faila.200, i64 %11, ptr @.failb.201, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.202, ptr @.faila.203, i64 %17, ptr @.failb.204, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.205, ptr @.faila.206, i64 %28, ptr @.failb.207, i64 %arr.len30, i32 70)
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

define internal void @"PriorityQueue$int.PriorityQueue$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 0
  store ptr @"PriorityQueue$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %heap, align 8, !tbaa !0
  %heap1 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %heap1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"PriorityQueue$int.~PriorityQueue$int"(ptr %0) {
entry:
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap1 = load ptr, ptr %heap, align 8, !tbaa !0
  call void @__polaron_free(ptr %heap1)
  ret void
}

define internal void @"PriorityQueue$int.add"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %tmp = alloca i32, align 4
  %parent = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca i32, align 4
  store i32 %1, ptr %item, align 4
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap2 = load ptr, ptr %heap, align 8, !tbaa !0
  %len = load i64, ptr %heap2, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp sge i32 %count1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %heap3 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap4 = load ptr, ptr %heap3, align 8, !tbaa !0
  %len5 = load i64, ptr %heap4, align 8
  %5 = trunc i64 %len5 to i32
  %6 = mul i32 %5, 2
  %7 = sext i32 %6 to i64
  %8 = mul i64 %7, 4
  %9 = add i64 8, %8
  %arr = call ptr @__polaron_malloc(i64 %9)
  store i64 %7, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %10 = call ptr @memset(ptr %arr.data, i32 0, i64 %8)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %j, align 4
  br label %for.cond

if.end:                                           ; preds = %for.end, %entry
  %heap25 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap26 = load ptr, ptr %heap25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count27 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %11 = sext i32 %count28 to i64
  %arr.len29 = load i64, ptr %heap26, align 8
  %arr.oob30 = icmp uge i64 %11, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %j6 = load i32, ptr %j, align 4
  %count7 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %12 = icmp slt i32 %j6, %count8
  %13 = zext i1 %12 to i32
  br i1 %12, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger9 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %j10 = load i32, ptr %j, align 4
  %14 = sext i32 %j10 to i64
  %arr.len = load i64, ptr %bigger9, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok18
  %15 = load i32, ptr %j, align 4
  %16 = add i32 %15, 1
  store i32 %16, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %heap21 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap22 = load ptr, ptr %heap21, align 8, !tbaa !0
  call void @__polaron_free(ptr %heap22)
  %heap23 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %bigger24 = load ptr, ptr %bigger, align 8
  store ptr %bigger24, ptr %heap23, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.208, ptr @.faila.209, i64 %14, ptr @.failb.210, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %bigger9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %14
  %heap12 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap13 = load ptr, ptr %heap12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j14 = load i32, ptr %j, align 4
  %17 = sext i32 %j14 to i64
  %arr.len15 = load i64, ptr %heap13, align 8
  %arr.oob16 = icmp uge i64 %17, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !8

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.211, ptr @.faila.212, i64 %17, ptr @.failb.213, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %heap13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %17
  %elem = load i32, ptr %arr.elem20, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

idx.bad31:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.214, ptr @.faila.215, i64 %11, ptr @.failb.216, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %if.end
  %arr.data33 = getelementptr i8, ptr %heap26, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %11
  %item35 = load i32, ptr %item, align 4
  store i32 %item35, ptr %arr.elem34, align 4
  %count36 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count37 = load i32, ptr %count36, align 4, !tbaa !4
  store i32 %count37, ptr %i, align 4
  %count38 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count39 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count40 = load i32, ptr %count39, align 4, !tbaa !4
  %18 = add i32 %count40, 1
  store i32 %18, ptr %count38, align 4, !tbaa !4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok100, %idx.ok32
  %i41 = load i32, ptr %i, align 4
  %19 = icmp sgt i32 %i41, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i42 = load i32, ptr %i, align 4
  %21 = sub i32 %i42, 1
  %22 = icmp eq i32 %21, -2147483648
  %23 = and i1 %22, false
  %24 = or i1 false, %23
  br i1 %24, label %div.bad, label %div.ok

while.end:                                        ; preds = %if.then63, %while.cond
  ret void

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %25 = sdiv i32 %21, 2
  store i32 %25, ptr %parent, align 4
  %heap43 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap44 = load ptr, ptr %heap43, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i45 = load i32, ptr %i, align 4
  %26 = sext i32 %i45 to i64
  %arr.len46 = load i64, ptr %heap44, align 8
  %arr.oob47 = icmp uge i64 %26, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !8

idx.bad48:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.217, ptr @.faila.218, i64 %26, ptr @.failb.219, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %div.ok
  %arr.data50 = getelementptr i8, ptr %heap44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %26
  %elem52 = load i32, ptr %arr.elem51, align 4
  %heap53 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap54 = load ptr, ptr %heap53, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent55 = load i32, ptr %parent, align 4
  %27 = sext i32 %parent55 to i64
  %arr.len56 = load i64, ptr %heap54, align 8
  %arr.oob57 = icmp uge i64 %27, %arr.len56
  br i1 %arr.oob57, label %idx.bad58, label %idx.ok59, !prof !8

idx.bad58:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.220, ptr @.faila.221, i64 %27, ptr @.failb.222, i64 %arr.len56, i32 70)
  unreachable

idx.ok59:                                         ; preds = %idx.ok49
  %arr.data60 = getelementptr i8, ptr %heap54, i64 8
  %arr.elem61 = getelementptr inbounds i32, ptr %arr.data60, i64 %27
  %elem62 = load i32, ptr %arr.elem61, align 4
  %28 = icmp slt i32 %elem52, %elem62
  %29 = icmp sgt i32 %elem52, %elem62
  %30 = select i1 %29, i32 1, i32 0
  %31 = select i1 %28, i32 -1, i32 %30
  %32 = icmp sge i32 %31, 0
  %33 = zext i1 %32 to i32
  br i1 %32, label %if.then63, label %if.end64

if.then63:                                        ; preds = %idx.ok59
  br label %while.end

if.end64:                                         ; preds = %idx.ok59
  %heap65 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap66 = load ptr, ptr %heap65, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i67 = load i32, ptr %i, align 4
  %34 = sext i32 %i67 to i64
  %arr.len68 = load i64, ptr %heap66, align 8
  %arr.oob69 = icmp uge i64 %34, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !8

idx.bad70:                                        ; preds = %if.end64
  call void @__polaron_fail(ptr @.fail.223, ptr @.faila.224, i64 %34, ptr @.failb.225, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %if.end64
  %arr.data72 = getelementptr i8, ptr %heap66, i64 8
  %arr.elem73 = getelementptr inbounds i32, ptr %arr.data72, i64 %34
  %elem74 = load i32, ptr %arr.elem73, align 4
  store i32 %elem74, ptr %tmp, align 4
  %heap75 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap76 = load ptr, ptr %heap75, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i77 = load i32, ptr %i, align 4
  %35 = sext i32 %i77 to i64
  %arr.len78 = load i64, ptr %heap76, align 8
  %arr.oob79 = icmp uge i64 %35, %arr.len78
  br i1 %arr.oob79, label %idx.bad80, label %idx.ok81, !prof !8

idx.bad80:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.226, ptr @.faila.227, i64 %35, ptr @.failb.228, i64 %arr.len78, i32 70)
  unreachable

idx.ok81:                                         ; preds = %idx.ok71
  %arr.data82 = getelementptr i8, ptr %heap76, i64 8
  %arr.elem83 = getelementptr inbounds i32, ptr %arr.data82, i64 %35
  %heap84 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap85 = load ptr, ptr %heap84, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent86 = load i32, ptr %parent, align 4
  %36 = sext i32 %parent86 to i64
  %arr.len87 = load i64, ptr %heap85, align 8
  %arr.oob88 = icmp uge i64 %36, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok81
  call void @__polaron_fail(ptr @.fail.229, ptr @.faila.230, i64 %36, ptr @.failb.231, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok81
  %arr.data91 = getelementptr i8, ptr %heap85, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 %36
  %elem93 = load i32, ptr %arr.elem92, align 4
  store i32 %elem93, ptr %arr.elem83, align 4
  %heap94 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap95 = load ptr, ptr %heap94, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent96 = load i32, ptr %parent, align 4
  %37 = sext i32 %parent96 to i64
  %arr.len97 = load i64, ptr %heap95, align 8
  %arr.oob98 = icmp uge i64 %37, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.232, ptr @.faila.233, i64 %37, ptr @.failb.234, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %heap95, i64 8
  %arr.elem102 = getelementptr inbounds i32, ptr %arr.data101, i64 %37
  %tmp103 = load i32, ptr %tmp, align 4
  store i32 %tmp103, ptr %arr.elem102, align 4
  %parent104 = load i32, ptr %parent, align 4
  store i32 %parent104, ptr %i, align 4
  br label %while.cond
}

define internal i32 @"PriorityQueue$int.peek"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap1 = load ptr, ptr %heap, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %heap1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.235, ptr @.faila.236, i64 0, ptr @.failb.237, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %heap1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"PriorityQueue$int.poll"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %tmp = alloca i32, align 4
  %smallest = alloca i32, align 4
  %r = alloca i32, align 4
  %l = alloca i32, align 4
  %i = alloca i32, align 4
  %top = alloca i32, align 4
  %heap = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap1 = load ptr, ptr %heap, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %heap1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.238, ptr @.faila.239, i64 0, ptr @.failb.240, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %heap1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %top, align 4
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %1 = sub i32 %count3, 1
  store i32 %1, ptr %count, align 4, !tbaa !4
  %heap4 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap5 = load ptr, ptr %heap4, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len6 = load i64, ptr %heap5, align 8
  %arr.oob7 = icmp uge i64 0, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.241, ptr @.faila.242, i64 0, ptr @.failb.243, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %heap5, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 0
  %heap12 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap13 = load ptr, ptr %heap12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count14 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %2 = sext i32 %count15 to i64
  %arr.len16 = load i64, ptr %heap13, align 8
  %arr.oob17 = icmp uge i64 %2, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.244, ptr @.faila.245, i64 %2, ptr @.failb.246, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok9
  %arr.data20 = getelementptr i8, ptr %heap13, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %2
  %elem22 = load i32, ptr %arr.elem21, align 4
  store i32 %elem22, ptr %arr.elem11, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok120, %idx.ok19
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %i23 = load i32, ptr %i, align 4
  %3 = mul i32 2, %i23
  %4 = add i32 %3, 1
  store i32 %4, ptr %l, align 4
  %i24 = load i32, ptr %i, align 4
  %5 = mul i32 2, %i24
  %6 = add i32 %5, 2
  store i32 %6, ptr %r, align 4
  %i25 = load i32, ptr %i, align 4
  store i32 %i25, ptr %smallest, align 4
  %l26 = load i32, ptr %l, align 4
  %count27 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %7 = icmp slt i32 %l26, %count28
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.end:                                        ; preds = %if.then83, %while.cond
  %top125 = load i32, ptr %top, align 4
  ret i32 %top125

sc.rhs:                                           ; preds = %while.body
  %heap29 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap30 = load ptr, ptr %heap29, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %l31 = load i32, ptr %l, align 4
  %9 = sext i32 %l31 to i64
  %arr.len32 = load i64, ptr %heap30, align 8
  %arr.oob33 = icmp uge i64 %9, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !8

sc.end:                                           ; preds = %idx.ok45, %while.body
  %sc = phi i1 [ false, %while.body ], [ %sc.b, %idx.ok45 ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad34:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.247, ptr @.faila.248, i64 %9, ptr @.failb.249, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %sc.rhs
  %arr.data36 = getelementptr i8, ptr %heap30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %9
  %elem38 = load i32, ptr %arr.elem37, align 4
  %heap39 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap40 = load ptr, ptr %heap39, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest41 = load i32, ptr %smallest, align 4
  %11 = sext i32 %smallest41 to i64
  %arr.len42 = load i64, ptr %heap40, align 8
  %arr.oob43 = icmp uge i64 %11, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !8

idx.bad44:                                        ; preds = %idx.ok35
  call void @__polaron_fail(ptr @.fail.250, ptr @.faila.251, i64 %11, ptr @.failb.252, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok35
  %arr.data46 = getelementptr i8, ptr %heap40, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 %11
  %elem48 = load i32, ptr %arr.elem47, align 4
  %12 = icmp slt i32 %elem38, %elem48
  %13 = icmp sgt i32 %elem38, %elem48
  %14 = select i1 %13, i32 1, i32 0
  %15 = select i1 %12, i32 -1, i32 %14
  %16 = icmp slt i32 %15, 0
  %17 = zext i1 %16 to i32
  %sc.b = icmp ne i32 %17, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %l49 = load i32, ptr %l, align 4
  store i32 %l49, ptr %smallest, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %r50 = load i32, ptr %r, align 4
  %count51 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %18 = icmp slt i32 %r50, %count52
  %19 = zext i1 %18 to i32
  %sc.a53 = icmp ne i32 %19, 0
  br i1 %sc.a53, label %sc.rhs54, label %sc.end55

sc.rhs54:                                         ; preds = %if.end
  %heap56 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap57 = load ptr, ptr %heap56, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r58 = load i32, ptr %r, align 4
  %20 = sext i32 %r58 to i64
  %arr.len59 = load i64, ptr %heap57, align 8
  %arr.oob60 = icmp uge i64 %20, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !8

sc.end55:                                         ; preds = %idx.ok72, %if.end
  %sc77 = phi i1 [ false, %if.end ], [ %sc.b76, %idx.ok72 ]
  %21 = zext i1 %sc77 to i32
  br i1 %sc77, label %if.then78, label %if.end79

idx.bad61:                                        ; preds = %sc.rhs54
  call void @__polaron_fail(ptr @.fail.253, ptr @.faila.254, i64 %20, ptr @.failb.255, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %sc.rhs54
  %arr.data63 = getelementptr i8, ptr %heap57, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 %20
  %elem65 = load i32, ptr %arr.elem64, align 4
  %heap66 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap67 = load ptr, ptr %heap66, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest68 = load i32, ptr %smallest, align 4
  %22 = sext i32 %smallest68 to i64
  %arr.len69 = load i64, ptr %heap67, align 8
  %arr.oob70 = icmp uge i64 %22, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !8

idx.bad71:                                        ; preds = %idx.ok62
  call void @__polaron_fail(ptr @.fail.256, ptr @.faila.257, i64 %22, ptr @.failb.258, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok62
  %arr.data73 = getelementptr i8, ptr %heap67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %22
  %elem75 = load i32, ptr %arr.elem74, align 4
  %23 = icmp slt i32 %elem65, %elem75
  %24 = icmp sgt i32 %elem65, %elem75
  %25 = select i1 %24, i32 1, i32 0
  %26 = select i1 %23, i32 -1, i32 %25
  %27 = icmp slt i32 %26, 0
  %28 = zext i1 %27 to i32
  %sc.b76 = icmp ne i32 %28, 0
  br label %sc.end55

if.then78:                                        ; preds = %sc.end55
  %r80 = load i32, ptr %r, align 4
  store i32 %r80, ptr %smallest, align 4
  br label %if.end79

if.end79:                                         ; preds = %if.then78, %sc.end55
  %smallest81 = load i32, ptr %smallest, align 4
  %i82 = load i32, ptr %i, align 4
  %29 = icmp eq i32 %smallest81, %i82
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then83, label %if.end84

if.then83:                                        ; preds = %if.end79
  br label %while.end

if.end84:                                         ; preds = %if.end79
  %heap85 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap86 = load ptr, ptr %heap85, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i87 = load i32, ptr %i, align 4
  %31 = sext i32 %i87 to i64
  %arr.len88 = load i64, ptr %heap86, align 8
  %arr.oob89 = icmp uge i64 %31, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !8

idx.bad90:                                        ; preds = %if.end84
  call void @__polaron_fail(ptr @.fail.259, ptr @.faila.260, i64 %31, ptr @.failb.261, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %if.end84
  %arr.data92 = getelementptr i8, ptr %heap86, i64 8
  %arr.elem93 = getelementptr inbounds i32, ptr %arr.data92, i64 %31
  %elem94 = load i32, ptr %arr.elem93, align 4
  store i32 %elem94, ptr %tmp, align 4
  %heap95 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap96 = load ptr, ptr %heap95, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i97 = load i32, ptr %i, align 4
  %32 = sext i32 %i97 to i64
  %arr.len98 = load i64, ptr %heap96, align 8
  %arr.oob99 = icmp uge i64 %32, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !8

idx.bad100:                                       ; preds = %idx.ok91
  call void @__polaron_fail(ptr @.fail.262, ptr @.faila.263, i64 %32, ptr @.failb.264, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok91
  %arr.data102 = getelementptr i8, ptr %heap96, i64 8
  %arr.elem103 = getelementptr inbounds i32, ptr %arr.data102, i64 %32
  %heap104 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap105 = load ptr, ptr %heap104, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest106 = load i32, ptr %smallest, align 4
  %33 = sext i32 %smallest106 to i64
  %arr.len107 = load i64, ptr %heap105, align 8
  %arr.oob108 = icmp uge i64 %33, %arr.len107
  br i1 %arr.oob108, label %idx.bad109, label %idx.ok110, !prof !8

idx.bad109:                                       ; preds = %idx.ok101
  call void @__polaron_fail(ptr @.fail.265, ptr @.faila.266, i64 %33, ptr @.failb.267, i64 %arr.len107, i32 70)
  unreachable

idx.ok110:                                        ; preds = %idx.ok101
  %arr.data111 = getelementptr i8, ptr %heap105, i64 8
  %arr.elem112 = getelementptr inbounds i32, ptr %arr.data111, i64 %33
  %elem113 = load i32, ptr %arr.elem112, align 4
  store i32 %elem113, ptr %arr.elem103, align 4
  %heap114 = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 1
  %heap115 = load ptr, ptr %heap114, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %smallest116 = load i32, ptr %smallest, align 4
  %34 = sext i32 %smallest116 to i64
  %arr.len117 = load i64, ptr %heap115, align 8
  %arr.oob118 = icmp uge i64 %34, %arr.len117
  br i1 %arr.oob118, label %idx.bad119, label %idx.ok120, !prof !8

idx.bad119:                                       ; preds = %idx.ok110
  call void @__polaron_fail(ptr @.fail.268, ptr @.faila.269, i64 %34, ptr @.failb.270, i64 %arr.len117, i32 70)
  unreachable

idx.ok120:                                        ; preds = %idx.ok110
  %arr.data121 = getelementptr i8, ptr %heap115, i64 8
  %arr.elem122 = getelementptr inbounds i32, ptr %arr.data121, i64 %34
  %tmp123 = load i32, ptr %tmp, align 4
  store i32 %tmp123, ptr %arr.elem122, align 4
  %smallest124 = load i32, ptr %smallest, align 4
  store i32 %smallest124, ptr %i, align 4
  br label %while.cond
}

define internal i32 @"PriorityQueue$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"PriorityQueue$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.PriorityQueue$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"LinkedList$String.LinkedList$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 0
  store ptr @"LinkedList$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %nodes = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 1
  %region = call ptr @__polaron_region_acquire(i64 4544)
  call void @__polaron_region_init(ptr %region, i64 1, i64 4096, i64 0)
  store ptr %region, ptr %nodes, align 8, !tbaa !0
  %head = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %head, align 8, !tbaa !0
  %tail = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  store ptr null, ptr %tail, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"LinkedList$String.~LinkedList$String"(ptr %0) {
entry:
  %head = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %head, align 8, !tbaa !0
  %tail = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  store ptr null, ptr %tail, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %rgn.field = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 1
  %1 = load ptr, ptr %rgn.field, align 8, !tbaa !0
  call void @__polaron_region_teardown(ptr %1)
  call void @__polaron_region_release(ptr %1)
  store ptr null, ptr %rgn.field, align 8, !tbaa !0
  ret void
}

define internal void @"LinkedList$String.add"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %node = alloca ptr, align 8
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %rgn.field = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 1
  %region = load ptr, ptr %rgn.field, align 8, !tbaa !0
  %rgn.slot = call ptr @__polaron_region_new(ptr %region, i64 ptrtoint (ptr getelementptr (%"class.LinkedNode$String", ptr null, i64 1) to i64))
  %next.winit = getelementptr inbounds %"class.LinkedNode$String", ptr %rgn.slot, i32 0, i32 2
  %2 = getelementptr inbounds %WeakSlot, ptr %next.winit, i32 0, i32 0
  store ptr null, ptr %2, align 8
  %3 = getelementptr inbounds %WeakSlot, ptr %next.winit, i32 0, i32 1
  store ptr null, ptr %3, align 8
  %whead.winit = getelementptr inbounds %"class.LinkedNode$String", ptr %rgn.slot, i32 0, i32 3
  store ptr null, ptr %whead.winit, align 8, !tbaa !0
  %item1 = load ptr, ptr %item, align 8
  call void @"LinkedNode$String.LinkedNode$String"(ptr %rgn.slot, ptr %item1)
  %rgn.field2 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 1
  %region3 = load ptr, ptr %rgn.field2, align 8, !tbaa !0
  call void @__polaron_region_track(ptr %region3, ptr %rgn.slot, ptr @"LinkedNode$String.__rgndtor")
  store ptr %rgn.slot, ptr %node, align 8
  %tail = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  %tail4 = load ptr, ptr %tail, align 8, !tbaa !0
  %4 = icmp eq ptr %tail4, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %head = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  %node5 = load ptr, ptr %node, align 8
  store ptr %node5, ptr %head, align 8, !tbaa !0
  %tail6 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  %node7 = load ptr, ptr %node, align 8
  store ptr %node7, ptr %tail6, align 8, !tbaa !0
  br label %if.end

if.else:                                          ; preds = %entry
  %tail8 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  %tail9 = load ptr, ptr %tail8, align 8, !tbaa !0
  %6 = icmp eq ptr %tail9, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

if.end:                                           ; preds = %weak.done, %if.then
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count13 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count14 = load i32, ptr %count13, align 4, !tbaa !4
  %7 = add i32 %count14, 1
  store i32 %7, ptr %count, align 4, !tbaa !4
  ret void

nullrecv:                                         ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.271)
  unreachable

nullrecv.ok:                                      ; preds = %if.else
  %next = getelementptr inbounds %"class.LinkedNode$String", ptr %tail9, i32 0, i32 2
  %node10 = load ptr, ptr %node, align 8
  call void @__polaron_weak_unlink(ptr %next, i64 32)
  %8 = icmp ne ptr %node10, null
  br i1 %8, label %weak.link, label %weak.done

weak.link:                                        ; preds = %nullrecv.ok
  call void @__polaron_weak_link(ptr %next, ptr %node10, i64 32)
  br label %weak.done

weak.done:                                        ; preds = %weak.link, %nullrecv.ok
  %tail11 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  %node12 = load ptr, ptr %node, align 8
  store ptr %node12, ptr %tail11, align 8, !tbaa !0
  br label %if.end
}

define internal ptr @"LinkedList$String.get"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %cur = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %head = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  %head1 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head1, ptr %cur, align 8
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j2 = load i32, ptr %j, align 4
  %i3 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %j2, %i3
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

for.update:                                       ; preds = %nullrecv.ok
  %5 = load i32, ptr %j, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %cur6 = load ptr, ptr %cur, align 8
  %7 = icmp eq ptr %cur6, null
  br i1 %7, label %nullrecv7, label %nullrecv.ok8

nullrecv:                                         ; preds = %for.body
  call void @__polaron_panic(ptr @.panic.272)
  unreachable

nullrecv.ok:                                      ; preds = %for.body
  %next = getelementptr inbounds %"class.LinkedNode$String", ptr %cur4, i32 0, i32 2
  %next5 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next5, ptr %cur, align 8
  br label %for.update

nullrecv7:                                        ; preds = %for.end
  call void @__polaron_panic(ptr @.panic.273)
  unreachable

nullrecv.ok8:                                     ; preds = %for.end
  %value = getelementptr inbounds %"class.LinkedNode$String", ptr %cur6, i32 0, i32 1
  %value9 = load ptr, ptr %value, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %value9)
  ret ptr %strcpy
}

define internal ptr @"LinkedList$String.removeFirst"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %v = alloca ptr, align 8
  %node = alloca ptr, align 8
  %head = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  %head1 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head1, ptr %node, align 8
  %node2 = load ptr, ptr %node, align 8
  %1 = icmp eq ptr %node2, null
  br i1 %1, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.274)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %value = getelementptr inbounds %"class.LinkedNode$String", ptr %node2, i32 0, i32 1
  %value3 = load ptr, ptr %value, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %value3)
  store ptr %strcpy, ptr %v, align 8
  %head4 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  %node5 = load ptr, ptr %node, align 8
  %2 = icmp eq ptr %node5, null
  br i1 %2, label %nullrecv6, label %nullrecv.ok7

nullrecv6:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.275)
  unreachable

nullrecv.ok7:                                     ; preds = %nullrecv.ok
  %next = getelementptr inbounds %"class.LinkedNode$String", ptr %node5, i32 0, i32 2
  %next8 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next8, ptr %head4, align 8, !tbaa !0
  %head9 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  %head10 = load ptr, ptr %head9, align 8, !tbaa !0
  %3 = icmp eq ptr %head10, null
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok7
  %tail = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 3
  store ptr null, ptr %tail, align 8, !tbaa !0
  br label %if.end

if.end:                                           ; preds = %if.then, %nullrecv.ok7
  %node11 = load ptr, ptr %node, align 8
  %5 = icmp eq ptr %node11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.276)
  unreachable

nullrecv.ok13:                                    ; preds = %if.end
  call void @__polaron_check_live(ptr %node11)
  call void @"LinkedNode$String.__rgndtor"(ptr %node11)
  %rgn.field = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 1
  %region = load ptr, ptr %rgn.field, align 8, !tbaa !0
  call void @__polaron_region_free(ptr %region, ptr %node11, i64 ptrtoint (ptr getelementptr (%"class.LinkedNode$String", ptr null, i64 1) to i64))
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count14 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %6 = sub i32 %count15, 1
  store i32 %6, ptr %count, align 4, !tbaa !4
  %v16 = load ptr, ptr %v, align 8
  %strcpy17 = call ptr @__polaron_str_copy(ptr %v16)
  %7 = load ptr, ptr %v, align 8
  call void @__polaron_str_free(ptr %7)
  ret ptr %strcpy17
}

define internal ptr @"LinkedList$String.toArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %cur = alloca ptr, align 8
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 8
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %head = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 2
  %head2 = load ptr, ptr %head, align 8, !tbaa !0
  store ptr %head2, ptr %cur, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %count4 = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %5 = icmp slt i32 %i3, %count5
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out6 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %out6, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %nullrecv.ok13
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out15 = load ptr, ptr %out, align 8
  ret ptr %out15

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.277, ptr @.faila.278, i64 %7, ptr @.failb.279, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %out6, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data8, i64 %7
  %cur9 = load ptr, ptr %cur, align 8
  %10 = icmp eq ptr %cur9, null
  br i1 %10, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.280)
  unreachable

nullrecv.ok:                                      ; preds = %idx.ok
  %value = getelementptr inbounds %"class.LinkedNode$String", ptr %cur9, i32 0, i32 1
  %value10 = load ptr, ptr %value, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %value10)
  %11 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %11)
  store ptr %strcpy, ptr %arr.elem, align 8
  %cur11 = load ptr, ptr %cur, align 8
  %12 = icmp eq ptr %cur11, null
  br i1 %12, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.281)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok
  %next = getelementptr inbounds %"class.LinkedNode$String", ptr %cur11, i32 0, i32 2
  %next14 = load ptr, ptr %next, align 8, !tbaa !0
  store ptr %next14, ptr %cur, align 8
  br label %for.update
}

define internal i32 @"LinkedList$String.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"LinkedList$String.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.LinkedList$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"LinkedNode$String.LinkedNode$String"(ptr %0, ptr %1) {
entry:
  %v = alloca ptr, align 8
  store ptr %1, ptr %v, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.LinkedNode$String", ptr %0, i32 0, i32 0
  store ptr @"LinkedNode$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %value = getelementptr inbounds %"class.LinkedNode$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %value, align 8, !tbaa !0
  %value1 = getelementptr inbounds %"class.LinkedNode$String", ptr %0, i32 0, i32 1
  %v2 = load ptr, ptr %v, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %v2)
  %2 = load ptr, ptr %value1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %value1, align 8, !tbaa !0
  %next = getelementptr inbounds %"class.LinkedNode$String", ptr %0, i32 0, i32 2
  call void @__polaron_weak_unlink(ptr %next, i64 32)
  br i1 false, label %weak.link, label %weak.done

weak.link:                                        ; preds = %entry
  call void @__polaron_weak_link(ptr %next, ptr null, i64 32)
  br label %weak.done

weak.done:                                        ; preds = %weak.link, %entry
  ret void
}

define internal void @"HashSet$String.HashSet$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 0
  store ptr @"HashSet$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %elems, align 8, !tbaa !0
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %used, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  store i32 8, ptr %cap, align 4, !tbaa !4
  %elems1 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %elems1, align 8, !tbaa !0
  %used2 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 8)
  store ptr %arr3, ptr %used2, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"HashSet$String.~HashSet$String"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %elems1 = load ptr, ptr %elems, align 8, !tbaa !0
  %ae.len = load i64, ptr %elems1, align 8
  %arr.data = getelementptr i8, ptr %elems1, i64 8
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
  call void @__polaron_free(ptr %elems1)
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used2 = load ptr, ptr %used, align 8, !tbaa !0
  call void @__polaron_free(ptr %used2)
  ret void
}

define internal i32 @"HashSet$String.slotFor"(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %value = alloca ptr, align 8
  store ptr %1, ptr %value, align 8
  %cap = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = sub i32 %cap1, 1
  store i32 %2, ptr %mask, align 4
  %value2 = load ptr, ptr %value, align 8
  %3 = call i64 @__polaron_str_hash_obj(ptr %value2)
  %4 = trunc i64 %3 to i32
  %mask3 = load i32, ptr %mask, align 4
  %5 = and i32 %4, %mask3
  store i32 %5, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %6 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %elems6 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %7 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %elems6, align 8
  %arr.oob9 = icmp uge i64 %7, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !8

while.end:                                        ; preds = %idx.ok
  %i21 = load i32, ptr %i, align 4
  ret i32 %i21

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.282, ptr @.faila.283, i64 %6, ptr @.failb.284, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.cond
  %arr.data = getelementptr i8, ptr %used4, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %6
  %elem = load i8, ptr %arr.elem, align 1
  %8 = sext i8 %elem to i32
  %9 = icmp ne i32 %8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

idx.bad10:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.285, ptr @.faila.286, i64 %7, ptr @.failb.287, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %while.body
  %arr.data12 = getelementptr i8, ptr %elems6, i64 8
  %arr.elem13 = getelementptr inbounds ptr, ptr %arr.data12, i64 %7
  %elem14 = load ptr, ptr %arr.elem13, align 8
  %value15 = load ptr, ptr %value, align 8
  %str.data = getelementptr inbounds %String, ptr %elem14, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data16 = getelementptr inbounds %String, ptr %value15, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %11 = call i32 @strcmp(ptr %data, ptr %data17)
  %12 = icmp eq i32 %11, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok11
  %i18 = load i32, ptr %i, align 4
  ret i32 %i18

if.end:                                           ; preds = %idx.ok11
  %i19 = load i32, ptr %i, align 4
  %14 = add i32 %i19, 1
  %mask20 = load i32, ptr %mask, align 4
  %15 = and i32 %14, %mask20
  store i32 %15, ptr %i, align 4
  br label %while.cond
}

define internal void @"HashSet$String.grow"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %ae.i = alloca i64, align 8
  %j = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldE = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %cap = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  store i32 %cap1, ptr %oldCap, align 4
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %elems2 = load ptr, ptr %elems, align 8, !tbaa !0
  store ptr %elems2, ptr %oldE, align 8
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used3 = load ptr, ptr %used, align 8, !tbaa !0
  store ptr %used3, ptr %oldU, align 8
  %cap4 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %oldCap5 = load i32, ptr %oldCap, align 4
  %1 = mul i32 %oldCap5, 2
  store i32 %1, ptr %cap4, align 4, !tbaa !4
  %elems6 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %cap7 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %2 = sext i32 %cap8 to i64
  %3 = mul i64 %2, 8
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %elems6, align 8, !tbaa !0
  %used9 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %cap10 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %6 = sext i32 %cap11 to i64
  %7 = mul i64 %6, 1
  %8 = add i64 8, %7
  %arr12 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr12, align 8
  %arr.data13 = getelementptr i8, ptr %arr12, i64 8
  %9 = call ptr @memset(ptr %arr.data13, i32 0, i64 %7)
  store ptr %arr12, ptr %used9, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j14 = load i32, ptr %j, align 4
  %oldCap15 = load i32, ptr %oldCap, align 4
  %10 = icmp slt i32 %j14, %oldCap15
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %oldU16 = load ptr, ptr %oldU, align 8, !nonnull !6, !dereferenceable !7
  %j17 = load i32, ptr %j, align 4
  %12 = sext i32 %j17 to i64
  %arr.len = load i64, ptr %oldU16, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %13 = load i32, ptr %j, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %oldE28 = load ptr, ptr %oldE, align 8
  %ae.len = load i64, ptr %oldE28, align 8
  %arr.data29 = getelementptr i8, ptr %oldE28, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.288, ptr @.faila.289, i64 %12, ptr @.failb.290, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data18 = getelementptr i8, ptr %oldU16, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data18, i64 %12
  %elem = load i8, ptr %arr.elem, align 1
  %15 = sext i8 %elem to i32
  %16 = icmp ne i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %oldE19 = load ptr, ptr %oldE, align 8, !nonnull !6, !dereferenceable !7
  %j20 = load i32, ptr %j, align 4
  %18 = sext i32 %j20 to i64
  %arr.len21 = load i64, ptr %oldE19, align 8
  %arr.oob22 = icmp uge i64 %18, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

if.end:                                           ; preds = %idx.ok24, %idx.ok
  br label %for.update

idx.bad23:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.291, ptr @.faila.292, i64 %18, ptr @.failb.293, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %if.then
  %arr.data25 = getelementptr i8, ptr %oldE19, i64 8
  %arr.elem26 = getelementptr inbounds ptr, ptr %arr.data25, i64 %18
  %elem27 = load ptr, ptr %arr.elem26, align 8
  call void @"HashSet$String.add"(ptr %0, ptr %elem27)
  br label %if.end

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %19 = icmp ult i64 %ae.iv, %ae.len
  br i1 %19, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data29, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %20 = icmp ne ptr %ae.el, null
  br i1 %20, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %21 = add i64 %ae.iv, 1
  store i64 %21, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %oldE28)
  %oldU30 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU30)
  ret void
}

define internal void @"HashSet$String.add"(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %value = alloca ptr, align 8
  store ptr %1, ptr %value, align 8
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = add i32 %count1, 1
  %3 = mul i32 %2, 4
  %cap = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = mul i32 %cap2, 3
  %5 = icmp sge i32 %3, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashSet$String.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %value3 = load ptr, ptr %value, align 8
  %7 = call i32 @"HashSet$String.slotFor"(ptr %0, ptr %value3)
  store i32 %7, ptr %i, align 4
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %8 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.294, ptr @.faila.295, i64 %8, ptr @.failb.296, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %used4, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %8
  %elem = load i8, ptr %arr.elem, align 1
  %9 = sext i8 %elem to i32
  %10 = icmp eq i32 %9, 0
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then6, label %if.end7

if.then6:                                         ; preds = %idx.ok
  %used8 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used9 = load ptr, ptr %used8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %used9, align 8
  %arr.oob12 = icmp uge i64 %12, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !8

if.end7:                                          ; preds = %idx.ok22, %idx.ok
  ret void

idx.bad13:                                        ; preds = %if.then6
  call void @__polaron_fail(ptr @.fail.297, ptr @.faila.298, i64 %12, ptr @.failb.299, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %if.then6
  %arr.data15 = getelementptr i8, ptr %used9, i64 8
  %arr.elem16 = getelementptr inbounds i8, ptr %arr.data15, i64 %12
  store i8 1, ptr %arr.elem16, align 1
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %elems17 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i18 = load i32, ptr %i, align 4
  %13 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %elems17, align 8
  %arr.oob20 = icmp uge i64 %13, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !8

idx.bad21:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.300, ptr @.faila.301, i64 %13, ptr @.failb.302, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok14
  %arr.data23 = getelementptr i8, ptr %elems17, i64 8
  %arr.elem24 = getelementptr inbounds ptr, ptr %arr.data23, i64 %13
  %value25 = load ptr, ptr %value, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %value25)
  %14 = load ptr, ptr %arr.elem24, align 8
  call void @__polaron_str_free(ptr %14)
  store ptr %strcpy, ptr %arr.elem24, align 8
  %count26 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count27 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %15 = add i32 %count28, 1
  store i32 %15, ptr %count26, align 4, !tbaa !4
  br label %if.end7
}

define internal i32 @"HashSet$String.contains"(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %value = alloca ptr, align 8
  store ptr %1, ptr %value, align 8
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used1 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %value2 = load ptr, ptr %value, align 8
  %2 = call i32 @"HashSet$String.slotFor"(ptr %0, ptr %value2)
  %3 = sext i32 %2 to i64
  %arr.len = load i64, ptr %used1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.303, ptr @.faila.304, i64 %3, ptr @.failb.305, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %3
  %elem = load i8, ptr %arr.elem, align 1
  %4 = sext i8 %elem to i32
  %5 = icmp ne i32 %4, 0
  %6 = zext i1 %5 to i32
  ret i32 %6
}

define internal i32 @"HashSet$String.remove"(ptr nonnull align 8 dereferenceable(32) %0, ptr %1) {
entry:
  %re = alloca ptr, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %value = alloca ptr, align 8
  store ptr %1, ptr %value, align 8
  %value1 = load ptr, ptr %value, align 8
  %2 = call i32 @"HashSet$String.slotFor"(ptr %0, ptr %value1)
  store i32 %2, ptr %i, align 4
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used2 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i3 = load i32, ptr %i, align 4
  %3 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %used2, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.306, ptr @.faila.307, i64 %3, ptr @.failb.308, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used2, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %3
  %elem = load i8, ptr %arr.elem, align 1
  %4 = sext i8 %elem to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  %cap = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %7 = sub i32 %cap4, 1
  store i32 %7, ptr %mask, align 4
  %used5 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used6 = load ptr, ptr %used5, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %used6, align 8
  %arr.oob9 = icmp uge i64 %8, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !8

idx.bad10:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.309, ptr @.faila.310, i64 %8, ptr @.failb.311, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %if.end
  %arr.data12 = getelementptr i8, ptr %used6, i64 8
  %arr.elem13 = getelementptr inbounds i8, ptr %arr.data12, i64 %8
  store i8 0, ptr %arr.elem13, align 1
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count14 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %9 = sub i32 %count15, 1
  store i32 %9, ptr %count, align 4, !tbaa !4
  %i16 = load i32, ptr %i, align 4
  %10 = add i32 %i16, 1
  %mask17 = load i32, ptr %mask, align 4
  %11 = and i32 %10, %mask17
  store i32 %11, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok43, %idx.ok11
  %used18 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used19 = load ptr, ptr %used18, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j20 = load i32, ptr %j, align 4
  %12 = sext i32 %j20 to i64
  %arr.len21 = load i64, ptr %used19, align 8
  %arr.oob22 = icmp uge i64 %12, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

while.body:                                       ; preds = %idx.ok24
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %elems28 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j29 = load i32, ptr %j, align 4
  %13 = sext i32 %j29 to i64
  %arr.len30 = load i64, ptr %elems28, align 8
  %arr.oob31 = icmp uge i64 %13, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

while.end:                                        ; preds = %idx.ok24
  ret i32 1

idx.bad23:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.312, ptr @.faila.313, i64 %12, ptr @.failb.314, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %while.cond
  %arr.data25 = getelementptr i8, ptr %used19, i64 8
  %arr.elem26 = getelementptr inbounds i8, ptr %arr.data25, i64 %12
  %elem27 = load i8, ptr %arr.elem26, align 1
  %14 = sext i8 %elem27 to i32
  %15 = icmp ne i32 %14, 0
  %16 = zext i1 %15 to i32
  br i1 %15, label %while.body, label %while.end

idx.bad32:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.315, ptr @.faila.316, i64 %13, ptr @.failb.317, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %elems28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %13
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem36)
  store ptr %strcpy, ptr %re, align 8
  %used37 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used38 = load ptr, ptr %used37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j39 = load i32, ptr %j, align 4
  %17 = sext i32 %j39 to i64
  %arr.len40 = load i64, ptr %used38, align 8
  %arr.oob41 = icmp uge i64 %17, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.318, ptr @.faila.319, i64 %17, ptr @.failb.320, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok33
  %arr.data44 = getelementptr i8, ptr %used38, i64 8
  %arr.elem45 = getelementptr inbounds i8, ptr %arr.data44, i64 %17
  store i8 0, ptr %arr.elem45, align 1
  %count46 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count47 = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count48 = load i32, ptr %count47, align 4, !tbaa !4
  %18 = sub i32 %count48, 1
  store i32 %18, ptr %count46, align 4, !tbaa !4
  %re49 = load ptr, ptr %re, align 8
  call void @"HashSet$String.add"(ptr %0, ptr %re49)
  %j50 = load i32, ptr %j, align 4
  %19 = add i32 %j50, 1
  %mask51 = load i32, ptr %mask, align 4
  %20 = and i32 %19, %mask51
  store i32 %20, ptr %j, align 4
  %21 = load ptr, ptr %re, align 8
  call void @__polaron_str_free(ptr %21)
  br label %while.cond
}

define internal ptr @"HashSet$String.toArray"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 8
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %j, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %cap = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 4
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %i2, %cap3
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %7 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out25 = load ptr, ptr %out, align 8
  ret ptr %out25

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.321, ptr @.faila.322, i64 %7, ptr @.failb.323, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data6 = getelementptr i8, ptr %used4, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data6, i64 %7
  %elem = load i8, ptr %arr.elem, align 1
  %10 = sext i8 %elem to i32
  %11 = icmp ne i32 %10, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %j8 = load i32, ptr %j, align 4
  %13 = sext i32 %j8 to i64
  %arr.len9 = load i64, ptr %out7, align 8
  %arr.oob10 = icmp uge i64 %13, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !8

if.end:                                           ; preds = %idx.ok20, %idx.ok
  br label %for.update

idx.bad11:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.324, ptr @.faila.325, i64 %13, ptr @.failb.326, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %if.then
  %arr.data13 = getelementptr i8, ptr %out7, i64 8
  %arr.elem14 = getelementptr inbounds ptr, ptr %arr.data13, i64 %13
  %elems = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 1
  %elems15 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %14 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %elems15, align 8
  %arr.oob18 = icmp uge i64 %14, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.327, ptr @.faila.328, i64 %14, ptr @.failb.329, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok12
  %arr.data21 = getelementptr i8, ptr %elems15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %14
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem23)
  %15 = load ptr, ptr %arr.elem14, align 8
  call void @__polaron_str_free(ptr %15)
  store ptr %strcpy, ptr %arr.elem14, align 8
  %j24 = load i32, ptr %j, align 4
  %16 = add i32 %j24, 1
  store i32 %16, ptr %j, align 4
  br label %if.end
}

define internal i32 @"HashSet$String.size"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"HashSet$String.isEmpty"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.HashSet$String", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
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
  call void @__polaron_fail(ptr @.contract.646, ptr @.cl.647, i64 %contract.l, ptr @.cr.648, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.649, ptr @.cl.650, i64 %contract.l23, ptr @.cr.651, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.652, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.653, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.654, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.655, ptr @.faila.656, i64 %19, ptr @.failb.657, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.658, ptr @.faila.659, i64 %20, ptr @.failb.660, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.661, ptr @.faila.662, i64 %30, ptr @.failb.663, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.664, ptr @.faila.665, i64 %36, ptr @.failb.666, i64 %arr.len52, i32 70)
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
  call void @__polaron_fail(ptr @.fail.667, ptr @.faila.668, i64 %40, ptr @.failb.669, i64 %arr.len63, i32 70)
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
  call void @__polaron_fail(ptr @.fail.670, ptr @.faila.671, i64 %43, ptr @.failb.672, i64 %arr.len75, i32 70)
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
  call void @__polaron_fail(ptr @.fail.673, ptr @.faila.674, i64 %47, ptr @.failb.675, i64 %arr.len84, i32 70)
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
  call void @__polaron_fail(ptr @.fail.676, ptr @.faila.677, i64 %48, ptr @.failb.678, i64 %arr.len92, i32 70)
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
  call void @__polaron_fail(ptr @.fail.679, ptr @.faila.680, i64 %50, ptr @.failb.681, i64 %arr.len102, i32 70)
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
  call void @__polaron_fail(ptr @.fail.682, ptr @.faila.683, i64 %51, ptr @.failb.684, i64 %arr.len110, i32 70)
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
  call void @__polaron_fail(ptr @.contract.685, ptr @.cl.686, i64 %contract.l, ptr @.cr.687, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.688, ptr @.cl.689, i64 %contract.l136, ptr @.cr.690, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.691, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.692, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.693, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.694, ptr @.faila.695, i64 %22, ptr @.failb.696, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.697, ptr @.faila.698, i64 %26, ptr @.failb.699, i64 %arr.len33, i32 70)
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
  call void @__polaron_fail(ptr @.fail.700, ptr @.faila.701, i64 %27, ptr @.failb.702, i64 %arr.len45, i32 70)
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
  call void @__polaron_fail(ptr @.fail.703, ptr @.faila.704, i64 %30, ptr @.failb.705, i64 %arr.len55, i32 70)
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
  call void @__polaron_fail(ptr @.contract.706, ptr @.cl.707, i64 %contract.l, ptr @.cr.708, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.709, ptr @.cl.710, i64 %contract.l77, ptr @.cr.711, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.712, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.713, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.714, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.715, ptr @.faila.716, i64 %16, ptr @.failb.717, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.718, ptr @.faila.719, i64 %16, ptr @.failb.720, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.721, ptr @.faila.722, i64 %17, ptr @.failb.723, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.724, ptr @.faila.725, i64 %21, ptr @.failb.726, i64 %arr.len27, i32 70)
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
  call void @__polaron_fail(ptr @.fail.727, ptr @.faila.728, i64 %23, ptr @.failb.729, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.730, ptr @.faila.731, i64 %27, ptr @.failb.732, i64 %arr.len33, i32 70)
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
  call void @__polaron_fail(ptr @.fail.733, ptr @.faila.734, i64 %32, ptr @.failb.735, i64 %arr.len45, i32 70)
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
  call void @__polaron_fail(ptr @.fail.736, ptr @.faila.737, i64 %34, ptr @.failb.738, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %34
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  br label %if.end29

idx.bad67:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.739, ptr @.faila.740, i64 %28, ptr @.failb.741, i64 %arr.len65, i32 70)
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
  call void @__polaron_fail(ptr @.fail.742, ptr @.faila.743, i64 %36, ptr @.failb.744, i64 %arr.len75, i32 70)
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
  call void @__polaron_fail(ptr @.contract.745, ptr @.cl.746, i64 %contract.l, ptr @.cr.747, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.748, ptr @.cl.749, i64 %contract.l98, ptr @.cr.750, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.751, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.752, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.753, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.754, ptr @.faila.755, i64 %16, ptr @.failb.756, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.757, ptr @.cl.758, i64 %contract.l, ptr @.cr.759, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.760, ptr @.cl.761, i64 %contract.l39, ptr @.cr.762, i64 %contract.r, i32 1)
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
  call void @__polaron_fail(ptr @.contract.763, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.764, ptr @.faila.765, i64 %23, ptr @.failb.766, i64 %arr.len53, i32 70)
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
  call void @__polaron_fail(ptr @.fail.767, ptr @.faila.768, i64 %32, ptr @.failb.769, i64 %arr.len67, i32 70)
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
  call void @__polaron_fail(ptr @.fail.770, ptr @.faila.771, i64 %33, ptr @.failb.772, i64 %arr.len77, i32 70)
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
  call void @__polaron_fail(ptr @.fail.773, ptr @.faila.774, i64 %39, ptr @.failb.775, i64 %arr.len87, i32 70)
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
  call void @__polaron_fail(ptr @.fail.776, ptr @.faila.777, i64 %40, ptr @.failb.778, i64 %arr.len97, i32 70)
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
  call void @__polaron_fail(ptr @.contract.779, ptr @.cl.780, i64 %contract.l117, ptr @.cr.781, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.782, ptr @.cl.783, i64 %contract.l129, ptr @.cr.784, i64 %contract.r130, i32 1)
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
  call void @__polaron_fail(ptr @.contract.785, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.786, ptr @.faila.787, i64 %20, ptr @.failb.788, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.789, ptr @.faila.790, i64 %26, ptr @.failb.791, i64 %arr.len31, i32 70)
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
  call void @__polaron_fail(ptr @.fail.792, ptr @.faila.793, i64 %27, ptr @.failb.794, i64 %arr.len40, i32 70)
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
  call void @__polaron_fail(ptr @.fail.795, ptr @.faila.796, i64 %20, ptr @.failb.797, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.798, ptr @.faila.799, i64 %26, ptr @.failb.800, i64 %arr.len31, i32 70)
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
  call void @__polaron_fail(ptr @.fail.801, ptr @.faila.802, i64 %27, ptr @.failb.803, i64 %arr.len40, i32 70)
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

define internal void @"Deque$int.Deque$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 0
  store ptr @"Deque$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head, align 4, !tbaa !4
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"Deque$int.~Deque$int"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"Deque$int.grow"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data2 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %count1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %data3 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data3, align 8, !tbaa !0
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %10 = icmp slt i32 %i6, %count8
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger9 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %bigger9, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok22
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data25 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data26 = load ptr, ptr %data25, align 8, !tbaa !0
  call void @__polaron_free(ptr %data26)
  %data27 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %bigger28 = load ptr, ptr %bigger, align 8
  store ptr %bigger28, ptr %data27, align 8, !tbaa !0
  %head29 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %head29, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1120, ptr @.faila.1121, i64 %12, ptr @.failb.1122, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %bigger9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %12
  %data12 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head14 = load i32, ptr %head, align 4, !tbaa !4
  %i15 = load i32, ptr %i, align 4
  %15 = add i32 %head14, %i15
  %data16 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data17 = load ptr, ptr %data16, align 8, !tbaa !0
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
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !8

idx.bad21:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1123, ptr @.faila.1124, i64 %23, ptr @.failb.1125, i64 %arr.len19, i32 70)
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
  %data1 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head2 = load i32, ptr %head, align 4, !tbaa !4
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count3 = load i32, ptr %count, align 4, !tbaa !4
  %2 = add i32 %head2, %count3
  %data4 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data4, align 8, !tbaa !0
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
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1126, ptr @.faila.1127, i64 %10, ptr @.failb.1128, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %10
  %item6 = load i32, ptr %item, align 4
  store i32 %item6, ptr %arr.elem, align 4
  %count7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count8 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %11 = add i32 %count9, 1
  store i32 %11, ptr %count7, align 4, !tbaa !4
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
  %head2 = load i32, ptr %head1, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data3 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data3, align 8
  %2 = trunc i64 %len to i32
  %3 = add i32 %head2, %2
  %4 = sub i32 %3, 1
  %data4 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data5 = load ptr, ptr %data4, align 8, !tbaa !0
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
  store i32 %11, ptr %head, align 4, !tbaa !4
  %data7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head9 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head10 = load i32, ptr %head9, align 4, !tbaa !4
  %12 = sext i32 %head10 to i64
  %arr.len = load i64, ptr %data8, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1129, ptr @.faila.1130, i64 %12, ptr @.failb.1131, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %data8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %12
  %item11 = load i32, ptr %item, align 4
  store i32 %item11, ptr %arr.elem, align 4
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count12 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count13 = load i32, ptr %count12, align 4, !tbaa !4
  %13 = add i32 %count13, 1
  store i32 %13, ptr %count, align 4, !tbaa !4
  ret void
}

define internal i32 @"Deque$int.removeFirst"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %v = alloca i32, align 4
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head2 = load i32, ptr %head, align 4, !tbaa !4
  %1 = sext i32 %head2 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %1, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1132, ptr @.faila.1133, i64 %1, ptr @.failb.1134, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %1
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %v, align 4
  %head3 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head4 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head5 = load i32, ptr %head4, align 4, !tbaa !4
  %2 = add i32 %head5, 1
  %data6 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data7 = load ptr, ptr %data6, align 8, !tbaa !0
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
  store i32 %9, ptr %head3, align 4, !tbaa !4
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count8 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %10 = sub i32 %count9, 1
  store i32 %10, ptr %count, align 4, !tbaa !4
  %v10 = load i32, ptr %v, align 4
  ret i32 %v10
}

define internal i32 @"Deque$int.removeLast"(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count2 = load i32, ptr %count1, align 4, !tbaa !4
  %1 = sub i32 %count2, 1
  store i32 %1, ptr %count, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data3 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head4 = load i32, ptr %head, align 4, !tbaa !4
  %count5 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count6 = load i32, ptr %count5, align 4, !tbaa !4
  %2 = add i32 %head4, %count6
  %data7 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !0
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
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1135, ptr @.faila.1136, i64 %10, ptr @.failb.1137, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
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
  %count4 = load i32, ptr %count3, align 4, !tbaa !4
  %5 = icmp slt i32 %i2, %count4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out5 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i6 = load i32, ptr %i, align 4
  %7 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %out5, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok16
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out19 = load ptr, ptr %out, align 8
  ret ptr %out19

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1138, ptr @.faila.1139, i64 %7, ptr @.failb.1140, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %out5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 %7
  %data = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %head = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 2
  %head9 = load i32, ptr %head, align 4, !tbaa !4
  %i10 = load i32, ptr %i, align 4
  %10 = add i32 %head9, %i10
  %data11 = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 1
  %data12 = load ptr, ptr %data11, align 8, !tbaa !0
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
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !8

idx.bad15:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1141, ptr @.faila.1142, i64 %18, ptr @.failb.1143, i64 %arr.len13, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"Deque$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.Deque$int", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
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
  call void @__polaron_fail(ptr @.contract.1560, ptr @.cl.1561, i64 %contract.l, ptr @.cr.1562, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1563, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1564, ptr @.faila.1565, i64 %19, ptr @.failb.1566, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1567, ptr @.faila.1568, i64 %22, ptr @.failb.1569, i64 %arr.len25, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1570, ptr @.faila.1571, i64 %16, ptr @.failb.1572, i64 %arr.len40, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1573, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1574, ptr @.cl.1575, i64 %contract.l, ptr @.cr.1576, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1577, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1578, ptr @.faila.1579, i64 %18, ptr @.failb.1580, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1581, ptr @.faila.1582, i64 %21, ptr @.failb.1583, i64 %arr.len20, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1584, ptr @.cl.1585, i64 %contract.l, ptr @.cr.1586, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1587, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1588, ptr @.faila.1589, i64 %13, ptr @.failb.1590, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1591, ptr @.faila.1592, i64 %14, ptr @.failb.1593, i64 %arr.len18, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1594, ptr @.faila.1595, i64 %14, ptr @.failb.1596, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1597, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1598, ptr @.faila.1599, i64 %15, ptr @.failb.1600, i64 %arr.len24, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1601, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1602, ptr @.faila.1603, i64 %9, ptr @.failb.1604, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1605, ptr @.faila.1606, i64 %13, ptr @.failb.1607, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1608, ptr @.cl.1609, i64 %contract.l, ptr @.cr.1610, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1611, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1612, ptr @.faila.1613, i64 %23, ptr @.failb.1614, i64 %arr.len34, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1615, ptr @.faila.1616, i64 %30, ptr @.failb.1617, i64 %arr.len43, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1618, ptr @.cl.1619, i64 %contract.l61, ptr @.cr.1620, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1621, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1622, ptr @.faila.1623, i64 %14, ptr @.failb.1624, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1625, ptr @.cl.1626, i64 %contract.l, ptr @.cr.1627, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1628, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1629, ptr @.faila.1630, i64 %32, ptr @.failb.1631, i64 %arr.len44, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1632, ptr @.faila.1633, i64 %35, ptr @.failb.1634, i64 %arr.len53, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1635, ptr @.faila.1636, i64 %42, ptr @.failb.1637, i64 %arr.len76, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1638, ptr @.faila.1639, i64 %47, ptr @.failb.1640, i64 %arr.len85, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1641, ptr @.faila.1642, i64 %45, ptr @.failb.1643, i64 %arr.len96, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1644, ptr @.cl.1645, i64 %contract.l114, ptr @.cr.1646, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1647, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1648, ptr @.cl.1649, i64 %contract.l, ptr @.cr.1650, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1651, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1652, ptr @.faila.1653, i64 %12, ptr @.failb.1654, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1655, ptr @.faila.1656, i64 %15, ptr @.failb.1657, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1658, ptr @.faila.1659, i64 %10, ptr @.failb.1660, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1661, ptr @.faila.1662, i64 %10, ptr @.failb.1663, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1664, ptr @.faila.1665, i64 %15, ptr @.failb.1666, i64 %arr.len20, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1667, ptr @.faila.1668, i64 %10, ptr @.failb.1669, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1670, ptr @.faila.1671, i64 %10, ptr @.failb.1672, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1673, ptr @.faila.1674, i64 %10, ptr @.failb.1675, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1676, ptr @.faila.1677, i64 %9, ptr @.failb.1678, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1679, ptr @.cl.1680, i64 %contract.l, ptr @.cr.1681, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1682, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.1683, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1684, ptr @.faila.1685, i64 %25, ptr @.failb.1686, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1687, ptr @.faila.1688, i64 %38, ptr @.failb.1689, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1690, ptr @.faila.1691, i64 %34, ptr @.failb.1692, i64 %arr.len41, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1693, ptr @.faila.1694, i64 %43, ptr @.failb.1695, i64 %arr.len50, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1696, ptr @.faila.1697, i64 %36, ptr @.failb.1698, i64 %arr.len62, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1699, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1700, ptr @.faila.1701, i64 %51, ptr @.failb.1702, i64 %arr.len95, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1703, ptr @.faila.1704, i64 %53, ptr @.failb.1705, i64 %arr.len105, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1706, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1707, ptr @.faila.1708, i64 %64, ptr @.failb.1709, i64 %arr.len143, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1710, ptr @.faila.1711, i64 %68, ptr @.failb.1712, i64 %arr.len153, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1713, ptr @.faila.1714, i64 %72, ptr @.failb.1715, i64 %arr.len164, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1716, ptr @.faila.1717, i64 %75, ptr @.failb.1718, i64 %arr.len173, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1719, ptr @.faila.1720, i64 %73, ptr @.failb.1721, i64 %arr.len184, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1722, ptr @.faila.1723, i64 %78, ptr @.failb.1724, i64 %arr.len193, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1725, ptr @.faila.1726, i64 %83, ptr @.failb.1727, i64 %arr.len210, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1728, ptr @.faila.1729, i64 %84, ptr @.failb.1730, i64 %arr.len219, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1731, ptr @.faila.1732, i64 %90, ptr @.failb.1733, i64 %arr.len236, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1734, ptr @.faila.1735, i64 %91, ptr @.failb.1736, i64 %arr.len245, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1737, ptr @.faila.1738, i64 %97, ptr @.failb.1739, i64 %arr.len265, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1740, ptr @.faila.1741, i64 %102, ptr @.failb.1742, i64 %arr.len273, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1743, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.1744, ptr @.faila.1745, i64 %10, ptr @.failb.1746, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1747, ptr @.faila.1748, i64 %15, ptr @.failb.1749, i64 %arr.len16, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1750, ptr @.faila.1751, i64 0, ptr @.failb.1752, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1753, ptr @.faila.1754, i64 %12, ptr @.failb.1755, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1756, ptr @.faila.1757, i64 %19, ptr @.failb.1758, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1759, ptr @.faila.1760, i64 0, ptr @.failb.1761, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1762, ptr @.faila.1763, i64 %12, ptr @.failb.1764, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1765, ptr @.faila.1766, i64 %19, ptr @.failb.1767, i64 %arr.len30, i32 70)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1779)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1781)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5781)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5783)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare void @__polaron_region_teardown(ptr)

declare void @__polaron_region_release(ptr)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare void @__polaron_str_free(ptr)

declare i32 @strcmp(ptr, ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @__polaron_str_copy(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare noalias ptr @__polaron_region_acquire(i64)

declare void @__polaron_region_init(ptr, i64, i64, i64)

declare noalias ptr @__polaron_region_new(ptr, i64)

define internal void @"LinkedNode$String.__rgndtor"(ptr %0) {
entry:
  %next.wunlink = getelementptr inbounds %"class.LinkedNode$String", ptr %0, i32 0, i32 2
  call void @__polaron_weak_unlink(ptr %next.wunlink, i64 32)
  %whead = getelementptr inbounds %"class.LinkedNode$String", ptr %0, i32 0, i32 3
  call void @__polaron_weak_nullify(ptr %whead)
  ret void
}

define internal void @__polaron_weak_unlink(ptr %0, i64 %1) {
entry:
  %2 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 1
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 0
  %5 = load ptr, ptr %4, align 8
  %6 = icmp eq ptr %5, null
  br i1 %6, label %clear, label %has

has:                                              ; preds = %entry
  %7 = getelementptr i8, ptr %5, i64 %1
  %8 = load ptr, ptr %7, align 8
  %9 = icmp eq ptr %8, %0
  br i1 %9, label %first, label %scan

first:                                            ; preds = %has
  store ptr %3, ptr %7, align 8
  br label %clear

scan:                                             ; preds = %advance, %has
  %10 = phi ptr [ %8, %has ], [ %12, %advance ]
  %11 = getelementptr inbounds %WeakSlot, ptr %10, i32 0, i32 1
  %12 = load ptr, ptr %11, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %clear, label %advance

found:                                            ; preds = %advance
  %14 = getelementptr inbounds %WeakSlot, ptr %10, i32 0, i32 1
  store ptr %3, ptr %14, align 8
  br label %clear

advance:                                          ; preds = %scan
  %15 = icmp eq ptr %12, %0
  br i1 %15, label %found, label %scan

clear:                                            ; preds = %found, %scan, %first, %entry
  %16 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 0
  store ptr null, ptr %16, align 8
  %17 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 1
  store ptr null, ptr %17, align 8
  br label %done

done:                                             ; preds = %clear
  ret void
}

define internal void @__polaron_weak_nullify(ptr %0) {
entry:
  %1 = load ptr, ptr %0, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %2 = phi ptr [ %1, %entry ], [ %5, %body ]
  %3 = icmp eq ptr %2, null
  br i1 %3, label %done, label %body

body:                                             ; preds = %loop
  %4 = getelementptr inbounds %WeakSlot, ptr %2, i32 0, i32 1
  %5 = load ptr, ptr %4, align 8
  %6 = getelementptr inbounds %WeakSlot, ptr %2, i32 0, i32 0
  store ptr null, ptr %6, align 8
  %7 = getelementptr inbounds %WeakSlot, ptr %2, i32 0, i32 1
  store ptr null, ptr %7, align 8
  br label %loop

done:                                             ; preds = %loop
  store ptr null, ptr %0, align 8
  ret void
}

declare void @__polaron_region_track(ptr, ptr, ptr)

define internal void @__polaron_weak_link(ptr %0, ptr %1, i64 %2) {
entry:
  %3 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 0
  store ptr %1, ptr %3, align 8
  %4 = getelementptr i8, ptr %1, i64 %2
  %5 = getelementptr inbounds %WeakSlot, ptr %0, i32 0, i32 1
  %6 = load ptr, ptr %4, align 8
  store ptr %6, ptr %5, align 8
  store ptr %0, ptr %4, align 8
  ret void
}

declare void @__polaron_region_free(ptr, ptr, i64)

declare i64 @__polaron_str_hash_obj(ptr)

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
