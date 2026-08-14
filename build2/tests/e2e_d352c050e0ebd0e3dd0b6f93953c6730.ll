; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/treemap_stdlib.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/treemap_stdlib.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.TreeMap$int$int" = type { ptr, ptr, i32 }
%"class.TreeMap$String$int" = type { ptr, ptr, i32 }
%"class.TreeSet$int" = type { ptr, ptr, i32 }
%"class.TreeSetNode$int" = type { ptr, i32, ptr, ptr, i32 }
%"class.TreeNode$int$int" = type { ptr, i32, i32, ptr, ptr, i32 }
%"class.TreeNode$String$int" = type { ptr, ptr, i32, ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"TreeMap$int$int.vtable" = private constant [366 x ptr] [ptr @"TreeMap$int$int.freeSubtree", ptr null, ptr @"TreeMap$int$int.nodeHeight", ptr @"TreeMap$int$int.fixHeight", ptr @"TreeMap$int$int.balance", ptr @"TreeMap$int$int.rotateRight", ptr @"TreeMap$int$int.rotateLeft", ptr @"TreeMap$int$int.insertNode", ptr null, ptr null, ptr null, ptr @"TreeMap$int$int.size", ptr @"TreeMap$int$int.isEmpty", ptr @"TreeMap$int$int.put", ptr @"TreeMap$int$int.find", ptr @"TreeMap$int$int.get", ptr @"TreeMap$int$int.containsKey", ptr @"TreeMap$int$int.fillKeys", ptr @"TreeMap$int$int.fillValues", ptr @"TreeMap$int$int.keyArray", ptr @"TreeMap$int$int.valueArray", ptr @"TreeMap$int$int.zeroKey", ptr @"TreeMap$int$int.firstKey", ptr @"TreeMap$int$int.lastKey", ptr @"TreeMap$int$int.floorKey", ptr @"TreeMap$int$int.ceilingKey", ptr @"TreeMap$int$int.higherKey", ptr @"TreeMap$int$int.lowerKey", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeMap$int$int.~TreeMap$int$int"]
@"TreeSetNode$int.vtable" = private constant [366 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"TreeSet$int.vtable" = private constant [366 x ptr] [ptr @"TreeSet$int.freeSubtree", ptr @"TreeSet$int.add", ptr @"TreeSet$int.nodeHeight", ptr @"TreeSet$int.fixHeight", ptr @"TreeSet$int.balance", ptr @"TreeSet$int.rotateRight", ptr @"TreeSet$int.rotateLeft", ptr @"TreeSet$int.insertNode", ptr @"TreeSet$int.contains", ptr @"TreeSet$int.fill", ptr @"TreeSet$int.toArray", ptr @"TreeSet$int.size", ptr @"TreeSet$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeSet$int.~TreeSet$int"]
@"TreeNode$int$int.vtable" = private constant [366 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"TreeMap$String$int.vtable" = private constant [366 x ptr] [ptr @"TreeMap$String$int.freeSubtree", ptr null, ptr @"TreeMap$String$int.nodeHeight", ptr @"TreeMap$String$int.fixHeight", ptr @"TreeMap$String$int.balance", ptr @"TreeMap$String$int.rotateRight", ptr @"TreeMap$String$int.rotateLeft", ptr @"TreeMap$String$int.insertNode", ptr null, ptr null, ptr null, ptr @"TreeMap$String$int.size", ptr @"TreeMap$String$int.isEmpty", ptr @"TreeMap$String$int.put", ptr @"TreeMap$String$int.find", ptr @"TreeMap$String$int.get", ptr @"TreeMap$String$int.containsKey", ptr @"TreeMap$String$int.fillKeys", ptr @"TreeMap$String$int.fillValues", ptr @"TreeMap$String$int.keyArray", ptr @"TreeMap$String$int.valueArray", ptr @"TreeMap$String$int.zeroKey", ptr @"TreeMap$String$int.firstKey", ptr @"TreeMap$String$int.lastKey", ptr @"TreeMap$String$int.floorKey", ptr @"TreeMap$String$int.ceilingKey", ptr @"TreeMap$String$int.higherKey", ptr @"TreeMap$String$int.lowerKey", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeMap$String$int.~TreeMap$String$int"]
@"TreeNode$String$int.vtable" = private constant [366 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [366 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [52 x i8] c"size=%d g2=%d g5=%d g8=%d has3=%d has8=%d gNone=%d\0A\00", align 1
@.strdata = private constant [7 x i8] c"banana\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [6 x i8] c"apple\00"
@.strobj.2 = private global %String { i64 5, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [7 x i8] c"cherry\00"
@.strobj.4 = private global %String { i64 6, ptr @.strdata.3, i64 0 }
@.str.5 = private unnamed_addr constant [40 x i8] c"str size=%d apple=%d cherry=%d hasX=%d\0A\00", align 1
@.strdata.6 = private constant [6 x i8] c"apple\00"
@.strobj.7 = private global %String { i64 5, ptr @.strdata.6, i64 0 }
@.strdata.8 = private constant [7 x i8] c"cherry\00"
@.strobj.9 = private global %String { i64 6, ptr @.strdata.8, i64 0 }
@.strdata.10 = private constant [2 x i8] c"x\00"
@.strobj.11 = private global %String { i64 1, ptr @.strdata.10, i64 0 }
@.str.12 = private unnamed_addr constant [29 x i8] c"set size=%d has5=%d has7=%d\0A\00", align 1
@.panic = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1409:33  in TreeSet$int.freeSubtree\0A\00", align 1
@.panic.13 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1410:33  in TreeSet$int.freeSubtree\0A\00", align 1
@.panic.14 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1411:17  in TreeSet$int.freeSubtree\0A\00", align 1
@.panic.15 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1419:17  in TreeSet$int.nodeHeight\0A\00", align 1
@.panic.16 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1422:17  in TreeSet$int.fixHeight\0A\00", align 1
@.panic.17 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1423:17  in TreeSet$int.fixHeight\0A\00", align 1
@.panic.18 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:41  in TreeSet$int.fixHeight\0A\00", align 1
@.panic.19 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:69  in TreeSet$int.fixHeight\0A\00", align 1
@.panic.20 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$int.balance\0A\00", align 1
@.panic.21 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$int.balance\0A\00", align 1
@.panic.22 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1430:17  in TreeSet$int.rotateRight\0A\00", align 1
@.panic.23 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$int.rotateRight\0A\00", align 1
@.panic.24 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$int.rotateRight\0A\00", align 1
@.panic.25 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1432:25  in TreeSet$int.rotateRight\0A\00", align 1
@.panic.26 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1438:17  in TreeSet$int.rotateLeft\0A\00", align 1
@.panic.27 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$int.rotateLeft\0A\00", align 1
@.panic.28 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$int.rotateLeft\0A\00", align 1
@.panic.29 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1440:24  in TreeSet$int.rotateLeft\0A\00", align 1
@.panic.30 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1450:17  in TreeSet$int.insertNode\0A\00", align 1
@.panic.31 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$int.insertNode\0A\00", align 1
@.panic.32 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$int.insertNode\0A\00", align 1
@.panic.33 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$int.insertNode\0A\00", align 1
@.panic.34 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$int.insertNode\0A\00", align 1
@.panic.35 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:21  in TreeSet$int.insertNode\0A\00", align 1
@.panic.36 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$int.insertNode\0A\00", align 1
@.panic.37 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$int.insertNode\0A\00", align 1
@.panic.38 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:21  in TreeSet$int.insertNode\0A\00", align 1
@.panic.39 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$int.insertNode\0A\00", align 1
@.panic.40 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$int.insertNode\0A\00", align 1
@.panic.41 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1472:21  in TreeSet$int.contains\0A\00", align 1
@.panic.42 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:38  in TreeSet$int.contains\0A\00", align 1
@.panic.43 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:63  in TreeSet$int.contains\0A\00", align 1
@.panic.44 = private unnamed_addr constant [88 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1480:17  in TreeSet$int.fill\0A\00", align 1
@.fail = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1481:24  in TreeSet$int.fill\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.45 = private unnamed_addr constant [88 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1481:24  in TreeSet$int.fill\0A\00", align 1
@.panic.46 = private unnamed_addr constant [88 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1483:17  in TreeSet$int.fill\0A\00", align 1
@.panic.47 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1219:33  in TreeMap$int$int.freeSubtree\0A\00", align 1
@.panic.48 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1220:33  in TreeMap$int$int.freeSubtree\0A\00", align 1
@.panic.49 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1221:17  in TreeMap$int$int.freeSubtree\0A\00", align 1
@.panic.50 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1231:17  in TreeMap$int$int.nodeHeight\0A\00", align 1
@.panic.51 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1234:17  in TreeMap$int$int.fixHeight\0A\00", align 1
@.panic.52 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1235:17  in TreeMap$int$int.fixHeight\0A\00", align 1
@.panic.53 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1236:41  in TreeMap$int$int.fixHeight\0A\00", align 1
@.panic.54 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1236:69  in TreeMap$int$int.fixHeight\0A\00", align 1
@.panic.55 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1239:17  in TreeMap$int$int.balance\0A\00", align 1
@.panic.56 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1239:17  in TreeMap$int$int.balance\0A\00", align 1
@.panic.57 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1242:17  in TreeMap$int$int.rotateRight\0A\00", align 1
@.panic.58 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1243:24  in TreeMap$int$int.rotateRight\0A\00", align 1
@.panic.59 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1243:24  in TreeMap$int$int.rotateRight\0A\00", align 1
@.panic.60 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1244:25  in TreeMap$int$int.rotateRight\0A\00", align 1
@.panic.61 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1250:17  in TreeMap$int$int.rotateLeft\0A\00", align 1
@.panic.62 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1251:25  in TreeMap$int$int.rotateLeft\0A\00", align 1
@.panic.63 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1251:25  in TreeMap$int$int.rotateLeft\0A\00", align 1
@.panic.64 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1252:24  in TreeMap$int$int.rotateLeft\0A\00", align 1
@.panic.65 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1262:17  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.66 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1263:42  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.67 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1265:31  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.68 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1265:31  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.69 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1267:32  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.70 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1267:32  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.71 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:21  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.72 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:66  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.73 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:66  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.74 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:21  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.75 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:68  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.76 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:68  in TreeMap$int$int.insertNode\0A\00", align 1
@.panic.77 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1284:21  in TreeMap$int$int.find\0A\00", align 1
@.panic.78 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1286:38  in TreeMap$int$int.find\0A\00", align 1
@.panic.79 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1286:63  in TreeMap$int$int.find\0A\00", align 1
@.panic.80 = private unnamed_addr constant [91 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1292:34  in TreeMap$int$int.get\0A\00", align 1
@.fail.81 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1294:17  in TreeMap$int$int.get\0A\00", align 1
@.faila.82 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.83 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.84 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1301:17  in TreeMap$int$int.fillKeys\0A\00", align 1
@.fail.85 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1302:24  in TreeMap$int$int.fillKeys\0A\00", align 1
@.faila.86 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.87 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.88 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1302:24  in TreeMap$int$int.fillKeys\0A\00", align 1
@.panic.89 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1304:17  in TreeMap$int$int.fillKeys\0A\00", align 1
@.panic.90 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1308:17  in TreeMap$int$int.fillValues\0A\00", align 1
@.fail.91 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1309:24  in TreeMap$int$int.fillValues\0A\00", align 1
@.faila.92 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.93 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.94 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1309:24  in TreeMap$int$int.fillValues\0A\00", align 1
@.panic.95 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1311:17  in TreeMap$int$int.fillValues\0A\00", align 1
@.fail.96 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1325:17  in TreeMap$int$int.zeroKey\0A\00", align 1
@.faila.97 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.98 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.99 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1332:17  in TreeMap$int$int.firstKey\0A\00", align 1
@.panic.100 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1332:48  in TreeMap$int$int.firstKey\0A\00", align 1
@.panic.101 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1333:17  in TreeMap$int$int.firstKey\0A\00", align 1
@.panic.102 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1338:17  in TreeMap$int$int.lastKey\0A\00", align 1
@.panic.103 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1338:49  in TreeMap$int$int.lastKey\0A\00", align 1
@.panic.104 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1339:17  in TreeMap$int$int.lastKey\0A\00", align 1
@.panic.105 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1345:21  in TreeMap$int$int.floorKey\0A\00", align 1
@.panic.106 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1346:35  in TreeMap$int$int.floorKey\0A\00", align 1
@.panic.107 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1347:38  in TreeMap$int$int.floorKey\0A\00", align 1
@.panic.108 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1347:75  in TreeMap$int$int.floorKey\0A\00", align 1
@.panic.109 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1350:17  in TreeMap$int$int.floorKey\0A\00", align 1
@.panic.110 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1356:21  in TreeMap$int$int.ceilingKey\0A\00", align 1
@.panic.111 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1357:35  in TreeMap$int$int.ceilingKey\0A\00", align 1
@.panic.112 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1358:38  in TreeMap$int$int.ceilingKey\0A\00", align 1
@.panic.113 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1358:76  in TreeMap$int$int.ceilingKey\0A\00", align 1
@.panic.114 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1361:17  in TreeMap$int$int.ceilingKey\0A\00", align 1
@.panic.115 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1367:21  in TreeMap$int$int.higherKey\0A\00", align 1
@.panic.116 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1368:50  in TreeMap$int$int.higherKey\0A\00", align 1
@.panic.117 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1368:75  in TreeMap$int$int.higherKey\0A\00", align 1
@.panic.118 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1371:17  in TreeMap$int$int.higherKey\0A\00", align 1
@.panic.119 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1377:21  in TreeMap$int$int.lowerKey\0A\00", align 1
@.panic.120 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1378:50  in TreeMap$int$int.lowerKey\0A\00", align 1
@.panic.121 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1378:76  in TreeMap$int$int.lowerKey\0A\00", align 1
@.panic.122 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1381:17  in TreeMap$int$int.lowerKey\0A\00", align 1
@.panic.123 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1219:33  in TreeMap$String$int.freeSubtree\0A\00", align 1
@.panic.124 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1220:33  in TreeMap$String$int.freeSubtree\0A\00", align 1
@.panic.125 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1221:17  in TreeMap$String$int.freeSubtree\0A\00", align 1
@.panic.126 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1231:17  in TreeMap$String$int.nodeHeight\0A\00", align 1
@.panic.127 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1234:17  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.128 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1235:17  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.129 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1236:41  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.130 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1236:69  in TreeMap$String$int.fixHeight\0A\00", align 1
@.panic.131 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1239:17  in TreeMap$String$int.balance\0A\00", align 1
@.panic.132 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1239:17  in TreeMap$String$int.balance\0A\00", align 1
@.panic.133 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1242:17  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.134 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1243:24  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.135 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1243:24  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.136 = private unnamed_addr constant [102 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1244:25  in TreeMap$String$int.rotateRight\0A\00", align 1
@.panic.137 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1250:17  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.138 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1251:25  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.139 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1251:25  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.140 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1252:24  in TreeMap$String$int.rotateLeft\0A\00", align 1
@.panic.141 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1262:17  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.142 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1263:42  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.143 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1265:31  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.144 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1265:31  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.145 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1267:32  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.146 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1267:32  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.147 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:21  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.148 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:66  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.149 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1272:66  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.150 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:21  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.151 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:68  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.152 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1276:68  in TreeMap$String$int.insertNode\0A\00", align 1
@.panic.153 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1284:21  in TreeMap$String$int.find\0A\00", align 1
@.panic.154 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1286:38  in TreeMap$String$int.find\0A\00", align 1
@.panic.155 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1286:63  in TreeMap$String$int.find\0A\00", align 1
@.panic.156 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1292:34  in TreeMap$String$int.get\0A\00", align 1
@.fail.157 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1294:17  in TreeMap$String$int.get\0A\00", align 1
@.faila.158 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.159 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.160 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1301:17  in TreeMap$String$int.fillKeys\0A\00", align 1
@.fail.161 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1302:24  in TreeMap$String$int.fillKeys\0A\00", align 1
@.faila.162 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.163 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.164 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1302:24  in TreeMap$String$int.fillKeys\0A\00", align 1
@.panic.165 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1304:17  in TreeMap$String$int.fillKeys\0A\00", align 1
@.panic.166 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1308:17  in TreeMap$String$int.fillValues\0A\00", align 1
@.fail.167 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1309:24  in TreeMap$String$int.fillValues\0A\00", align 1
@.faila.168 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.169 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.170 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1309:24  in TreeMap$String$int.fillValues\0A\00", align 1
@.panic.171 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1311:17  in TreeMap$String$int.fillValues\0A\00", align 1
@.fail.172 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1325:17  in TreeMap$String$int.zeroKey\0A\00", align 1
@.faila.173 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.174 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.175 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1332:17  in TreeMap$String$int.firstKey\0A\00", align 1
@.panic.176 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1332:48  in TreeMap$String$int.firstKey\0A\00", align 1
@.panic.177 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1333:17  in TreeMap$String$int.firstKey\0A\00", align 1
@.panic.178 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1338:17  in TreeMap$String$int.lastKey\0A\00", align 1
@.panic.179 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1338:49  in TreeMap$String$int.lastKey\0A\00", align 1
@.panic.180 = private unnamed_addr constant [98 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1339:17  in TreeMap$String$int.lastKey\0A\00", align 1
@.panic.181 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1345:21  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.182 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1346:35  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.183 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1347:38  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.184 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1347:75  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.185 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1350:17  in TreeMap$String$int.floorKey\0A\00", align 1
@.panic.186 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1356:21  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.187 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1357:35  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.188 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1358:38  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.189 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1358:76  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.190 = private unnamed_addr constant [101 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1361:17  in TreeMap$String$int.ceilingKey\0A\00", align 1
@.panic.191 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1367:21  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.192 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1368:50  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.193 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1368:75  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.194 = private unnamed_addr constant [100 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1371:17  in TreeMap$String$int.higherKey\0A\00", align 1
@.panic.195 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1377:21  in TreeMap$String$int.lowerKey\0A\00", align 1
@.panic.196 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1378:50  in TreeMap$String$int.lowerKey\0A\00", align 1
@.panic.197 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1378:76  in TreeMap$String$int.lowerKey\0A\00", align 1
@.panic.198 = private unnamed_addr constant [99 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1381:17  in TreeMap$String$int.lowerKey\0A\00", align 1
@.strdata.5509 = private constant [1 x i8] zeroinitializer
@.strobj.5510 = private global %String { i64 0, ptr @.strdata.5509, i64 0 }
@.strdata.5511 = private constant [1 x i8] zeroinitializer
@.strobj.5512 = private global %String { i64 0, ptr @.strdata.5511, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
  %sm = alloca ptr, align 8
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
  %"TreeMap$int$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeMap$int$int", ptr null, i64 1) to i64))
  call void @"TreeMap$int$int.TreeMap$int$int"(ptr %"TreeMap$int$int.obj")
  store ptr %"TreeMap$int$int.obj", ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8
  call void @"TreeMap$int$int.put"(ptr %m1, i32 5, i32 50)
  %m2 = load ptr, ptr %m, align 8
  call void @"TreeMap$int$int.put"(ptr %m2, i32 2, i32 20)
  %m3 = load ptr, ptr %m, align 8
  call void @"TreeMap$int$int.put"(ptr %m3, i32 8, i32 80)
  %m4 = load ptr, ptr %m, align 8
  call void @"TreeMap$int$int.put"(ptr %m4, i32 2, i32 22)
  %m5 = load ptr, ptr %m, align 8
  %16 = call i32 @"TreeMap$int$int.size"(ptr %m5)
  %m6 = load ptr, ptr %m, align 8
  %17 = call i32 @"TreeMap$int$int.get"(ptr %m6, i32 2)
  %m7 = load ptr, ptr %m, align 8
  %18 = call i32 @"TreeMap$int$int.get"(ptr %m7, i32 5)
  %m8 = load ptr, ptr %m, align 8
  %19 = call i32 @"TreeMap$int$int.get"(ptr %m8, i32 8)
  %m9 = load ptr, ptr %m, align 8
  %20 = call i32 @"TreeMap$int$int.containsKey"(ptr %m9, i32 3)
  %m10 = load ptr, ptr %m, align 8
  %21 = call i32 @"TreeMap$int$int.containsKey"(ptr %m10, i32 8)
  %m11 = load ptr, ptr %m, align 8
  %22 = call i32 @"TreeMap$int$int.get"(ptr %m11, i32 99)
  %23 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17, i32 %18, i32 %19, i32 %20, i32 %21, i32 %22)
  %"TreeMap$String$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeMap$String$int", ptr null, i64 1) to i64))
  call void @"TreeMap$String$int.TreeMap$String$int"(ptr %"TreeMap$String$int.obj")
  store ptr %"TreeMap$String$int.obj", ptr %sm, align 8
  %sm12 = load ptr, ptr %sm, align 8
  call void @"TreeMap$String$int.put"(ptr %sm12, ptr @.strobj, i32 2)
  %sm13 = load ptr, ptr %sm, align 8
  call void @"TreeMap$String$int.put"(ptr %sm13, ptr @.strobj.2, i32 1)
  %sm14 = load ptr, ptr %sm, align 8
  call void @"TreeMap$String$int.put"(ptr %sm14, ptr @.strobj.4, i32 3)
  %sm15 = load ptr, ptr %sm, align 8
  %24 = call i32 @"TreeMap$String$int.size"(ptr %sm15)
  %sm16 = load ptr, ptr %sm, align 8
  %25 = call i32 @"TreeMap$String$int.get"(ptr %sm16, ptr @.strobj.7)
  %sm17 = load ptr, ptr %sm, align 8
  %26 = call i32 @"TreeMap$String$int.get"(ptr %sm17, ptr @.strobj.9)
  %sm18 = load ptr, ptr %sm, align 8
  %27 = call i32 @"TreeMap$String$int.containsKey"(ptr %sm18, ptr @.strobj.11)
  %28 = call i32 (ptr, ...) @printf(ptr @.str.5, i32 %24, i32 %25, i32 %26, i32 %27)
  %"TreeSet$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeSet$int", ptr null, i64 1) to i64))
  call void @"TreeSet$int.TreeSet$int"(ptr %"TreeSet$int.obj")
  store ptr %"TreeSet$int.obj", ptr %s, align 8
  %s19 = load ptr, ptr %s, align 8
  call void @"TreeSet$int.add"(ptr %s19, i32 5)
  %s20 = load ptr, ptr %s, align 8
  call void @"TreeSet$int.add"(ptr %s20, i32 5)
  %s21 = load ptr, ptr %s, align 8
  call void @"TreeSet$int.add"(ptr %s21, i32 1)
  %s22 = load ptr, ptr %s, align 8
  call void @"TreeSet$int.add"(ptr %s22, i32 9)
  %s23 = load ptr, ptr %s, align 8
  %29 = call i32 @"TreeSet$int.size"(ptr %s23)
  %s24 = load ptr, ptr %s, align 8
  %30 = call i32 @"TreeSet$int.contains"(ptr %s24, i32 5)
  %s25 = load ptr, ptr %s, align 8
  %31 = call i32 @"TreeSet$int.contains"(ptr %s25, i32 7)
  %32 = call i32 (ptr, ...) @printf(ptr @.str.12, i32 %29, i32 %30, i32 %31)
  ret i32 0
}

define internal void @"TreeSet$int.TreeSet$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 0
  store ptr @"TreeSet$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %root = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %root, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeSet$int.~TreeSet$int"(ptr %0) {
entry:
  %root = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  call void @"TreeSet$int.freeSubtree"(ptr %0, ptr %root1)
  %root2 = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %root2, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeSet$int.freeSubtree"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %n2, i32 0, i32 2
  %left3 = load ptr, ptr %left, align 8, !tbaa !0
  call void @"TreeSet$int.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.13)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %n4, i32 0, i32 3
  %right7 = load ptr, ptr %right, align 8, !tbaa !0
  call void @"TreeSet$int.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.14)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$int", ptr %n8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [366 x ptr], ptr %vtbl, i64 0, i64 365
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %7 = icmp ne ptr %dtor.fn, null
  br i1 %7, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %nullrecv.ok10
  call void %dtor.fn(ptr %n8)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %nullrecv.ok10
  call void @__polaron_free(ptr %n8)
  ret void
}

define internal void @"TreeSet$int.add"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  %root = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  %root1 = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root1, align 8, !tbaa !0
  %value3 = load i32, ptr %value, align 4
  %2 = call ptr @"TreeSet$int.insertNode"(ptr %0, ptr %root2, i32 %value3)
  store ptr %2, ptr %root, align 8, !tbaa !0
  ret void
}

define internal i32 @"TreeSet$int.nodeHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  call void @__polaron_panic(ptr @.panic.15)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %height = getelementptr inbounds %"class.TreeSetNode$int", ptr %n2, i32 0, i32 4
  %height3 = load i32, ptr %height, align 4, !tbaa !4
  ret i32 %height3
}

define internal void @"TreeSet$int.fixHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rh = alloca i32, align 4
  %lh = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.16)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeSet$int.nodeHeight"(ptr %0, ptr %left2)
  store i32 %3, ptr %lh, align 4
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.17)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeSet$int.nodeHeight"(ptr %0, ptr %right6)
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
  call void @__polaron_panic(ptr @.panic.18)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeSetNode$int", ptr %n9, i32 0, i32 4
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !4
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.19)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %height16 = getelementptr inbounds %"class.TreeSetNode$int", ptr %n13, i32 0, i32 4
  %rh17 = load i32, ptr %rh, align 4
  %11 = add i32 %rh17, 1
  store i32 %11, ptr %height16, align 4, !tbaa !4
  br label %if.end
}

define internal i32 @"TreeSet$int.balance"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.20)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeSet$int.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.21)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeSet$int.nodeHeight"(ptr %0, ptr %right6)
  %6 = sub i32 %3, %5
  ret i32 %6
}

define internal ptr @"TreeSet$int.rotateRight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %1, ptr %y, align 8
  %y1 = load ptr, ptr %y, align 8
  %2 = icmp eq ptr %y1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.22)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %y1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.23)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeSetNode$int", ptr %y3, i32 0, i32 2
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.24)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %x7, i32 0, i32 3
  %right10 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right10, ptr %left6, align 8, !tbaa !0
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.25)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %right14 = getelementptr inbounds %"class.TreeSetNode$int", ptr %x11, i32 0, i32 3
  %y15 = load ptr, ptr %y, align 8
  store ptr %y15, ptr %right14, align 8, !tbaa !0
  %y16 = load ptr, ptr %y, align 8
  call void @"TreeSet$int.fixHeight"(ptr %0, ptr %y16)
  %x17 = load ptr, ptr %x, align 8
  call void @"TreeSet$int.fixHeight"(ptr %0, ptr %x17)
  %x18 = load ptr, ptr %x, align 8
  ret ptr %x18
}

define internal ptr @"TreeSet$int.rotateLeft"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %2 = icmp eq ptr %x1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.26)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %x1, i32 0, i32 3
  %right2 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.27)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeSetNode$int", ptr %x3, i32 0, i32 3
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.28)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %y7, i32 0, i32 2
  %left10 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left10, ptr %right6, align 8, !tbaa !0
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.29)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %left14 = getelementptr inbounds %"class.TreeSetNode$int", ptr %y11, i32 0, i32 2
  %x15 = load ptr, ptr %x, align 8
  store ptr %x15, ptr %left14, align 8, !tbaa !0
  %x16 = load ptr, ptr %x, align 8
  call void @"TreeSet$int.fixHeight"(ptr %0, ptr %x16)
  %y17 = load ptr, ptr %y, align 8
  call void @"TreeSet$int.fixHeight"(ptr %0, ptr %y17)
  %y18 = load ptr, ptr %y, align 8
  ret ptr %y18
}

define internal ptr @"TreeSet$int.insertNode"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2) {
entry:
  %bf = alloca i32, align 4
  %c = alloca i32, align 4
  %value = alloca i32, align 4
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store i32 %2, ptr %value, align 4
  %node1 = load ptr, ptr %node, align 8
  %3 = icmp eq ptr %node1, null
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %5 = add i32 %count3, 1
  store i32 %5, ptr %count, align 4, !tbaa !4
  %"TreeSetNode$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeSetNode$int", ptr null, i64 1) to i64))
  %value4 = load i32, ptr %value, align 4
  call void @"TreeSetNode$int.TreeSetNode$int"(ptr %"TreeSetNode$int.obj", i32 %value4)
  ret ptr %"TreeSetNode$int.obj"

if.end:                                           ; preds = %entry
  %value5 = load i32, ptr %value, align 4
  %node6 = load ptr, ptr %node, align 8
  %6 = icmp eq ptr %node6, null
  br i1 %6, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.30)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %value7 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node6, i32 0, i32 1
  %value8 = load i32, ptr %value7, align 4, !tbaa !4
  %7 = icmp slt i32 %value5, %value8
  %8 = icmp sgt i32 %value5, %value8
  %9 = select i1 %8, i32 1, i32 0
  %10 = select i1 %7, i32 -1, i32 %9
  store i32 %10, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %11 = icmp eq i32 %c9, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then10, label %if.end11

if.then10:                                        ; preds = %nullrecv.ok
  %node12 = load ptr, ptr %node, align 8
  ret ptr %node12

if.end11:                                         ; preds = %nullrecv.ok
  %c13 = load i32, ptr %c, align 4
  %13 = icmp slt i32 %c13, 0
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then14, label %if.else

if.then14:                                        ; preds = %if.end11
  %node16 = load ptr, ptr %node, align 8
  %15 = icmp eq ptr %node16, null
  br i1 %15, label %nullrecv17, label %nullrecv.ok18

if.else:                                          ; preds = %if.end11
  %node25 = load ptr, ptr %node, align 8
  %16 = icmp eq ptr %node25, null
  br i1 %16, label %nullrecv26, label %nullrecv.ok27

if.end15:                                         ; preds = %nullrecv.ok30, %nullrecv.ok21
  %node34 = load ptr, ptr %node, align 8
  call void @"TreeSet$int.fixHeight"(ptr %0, ptr %node34)
  %node35 = load ptr, ptr %node, align 8
  %17 = call i32 @"TreeSet$int.balance"(ptr %0, ptr %node35)
  store i32 %17, ptr %bf, align 4
  %bf36 = load i32, ptr %bf, align 4
  %18 = icmp sgt i32 %bf36, 1
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then37, label %if.end38

nullrecv17:                                       ; preds = %if.then14
  call void @__polaron_panic(ptr @.panic.31)
  unreachable

nullrecv.ok18:                                    ; preds = %if.then14
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %node16, i32 0, i32 2
  %node19 = load ptr, ptr %node, align 8
  %20 = icmp eq ptr %node19, null
  br i1 %20, label %nullrecv20, label %nullrecv.ok21

nullrecv20:                                       ; preds = %nullrecv.ok18
  call void @__polaron_panic(ptr @.panic.32)
  unreachable

nullrecv.ok21:                                    ; preds = %nullrecv.ok18
  %left22 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node19, i32 0, i32 2
  %left23 = load ptr, ptr %left22, align 8, !tbaa !0
  %value24 = load i32, ptr %value, align 4
  %21 = call ptr @"TreeSet$int.insertNode"(ptr %0, ptr %left23, i32 %value24)
  store ptr %21, ptr %left, align 8, !tbaa !0
  br label %if.end15

nullrecv26:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.33)
  unreachable

nullrecv.ok27:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %node25, i32 0, i32 3
  %node28 = load ptr, ptr %node, align 8
  %22 = icmp eq ptr %node28, null
  br i1 %22, label %nullrecv29, label %nullrecv.ok30

nullrecv29:                                       ; preds = %nullrecv.ok27
  call void @__polaron_panic(ptr @.panic.34)
  unreachable

nullrecv.ok30:                                    ; preds = %nullrecv.ok27
  %right31 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node28, i32 0, i32 3
  %right32 = load ptr, ptr %right31, align 8, !tbaa !0
  %value33 = load i32, ptr %value, align 4
  %23 = call ptr @"TreeSet$int.insertNode"(ptr %0, ptr %right32, i32 %value33)
  store ptr %23, ptr %right, align 8, !tbaa !0
  br label %if.end15

if.then37:                                        ; preds = %if.end15
  %node39 = load ptr, ptr %node, align 8
  %24 = icmp eq ptr %node39, null
  br i1 %24, label %nullrecv40, label %nullrecv.ok41

if.end38:                                         ; preds = %if.end15
  %bf56 = load i32, ptr %bf, align 4
  %25 = icmp slt i32 %bf56, -1
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then57, label %if.end58

nullrecv40:                                       ; preds = %if.then37
  call void @__polaron_panic(ptr @.panic.35)
  unreachable

nullrecv.ok41:                                    ; preds = %if.then37
  %left42 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node39, i32 0, i32 2
  %left43 = load ptr, ptr %left42, align 8, !tbaa !0
  %27 = call i32 @"TreeSet$int.balance"(ptr %0, ptr %left43)
  %28 = icmp slt i32 %27, 0
  %29 = zext i1 %28 to i32
  br i1 %28, label %if.then44, label %if.end45

if.then44:                                        ; preds = %nullrecv.ok41
  %node46 = load ptr, ptr %node, align 8
  %30 = icmp eq ptr %node46, null
  br i1 %30, label %nullrecv47, label %nullrecv.ok48

if.end45:                                         ; preds = %nullrecv.ok52, %nullrecv.ok41
  %node55 = load ptr, ptr %node, align 8
  %31 = call ptr @"TreeSet$int.rotateRight"(ptr %0, ptr %node55)
  ret ptr %31

nullrecv47:                                       ; preds = %if.then44
  call void @__polaron_panic(ptr @.panic.36)
  unreachable

nullrecv.ok48:                                    ; preds = %if.then44
  %left49 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node46, i32 0, i32 2
  %node50 = load ptr, ptr %node, align 8
  %32 = icmp eq ptr %node50, null
  br i1 %32, label %nullrecv51, label %nullrecv.ok52

nullrecv51:                                       ; preds = %nullrecv.ok48
  call void @__polaron_panic(ptr @.panic.37)
  unreachable

nullrecv.ok52:                                    ; preds = %nullrecv.ok48
  %left53 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node50, i32 0, i32 2
  %left54 = load ptr, ptr %left53, align 8, !tbaa !0
  %33 = call ptr @"TreeSet$int.rotateLeft"(ptr %0, ptr %left54)
  store ptr %33, ptr %left49, align 8, !tbaa !0
  br label %if.end45

if.then57:                                        ; preds = %if.end38
  %node59 = load ptr, ptr %node, align 8
  %34 = icmp eq ptr %node59, null
  br i1 %34, label %nullrecv60, label %nullrecv.ok61

if.end58:                                         ; preds = %if.end38
  %node76 = load ptr, ptr %node, align 8
  ret ptr %node76

nullrecv60:                                       ; preds = %if.then57
  call void @__polaron_panic(ptr @.panic.38)
  unreachable

nullrecv.ok61:                                    ; preds = %if.then57
  %right62 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node59, i32 0, i32 3
  %right63 = load ptr, ptr %right62, align 8, !tbaa !0
  %35 = call i32 @"TreeSet$int.balance"(ptr %0, ptr %right63)
  %36 = icmp sgt i32 %35, 0
  %37 = zext i1 %36 to i32
  br i1 %36, label %if.then64, label %if.end65

if.then64:                                        ; preds = %nullrecv.ok61
  %node66 = load ptr, ptr %node, align 8
  %38 = icmp eq ptr %node66, null
  br i1 %38, label %nullrecv67, label %nullrecv.ok68

if.end65:                                         ; preds = %nullrecv.ok72, %nullrecv.ok61
  %node75 = load ptr, ptr %node, align 8
  %39 = call ptr @"TreeSet$int.rotateLeft"(ptr %0, ptr %node75)
  ret ptr %39

nullrecv67:                                       ; preds = %if.then64
  call void @__polaron_panic(ptr @.panic.39)
  unreachable

nullrecv.ok68:                                    ; preds = %if.then64
  %right69 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node66, i32 0, i32 3
  %node70 = load ptr, ptr %node, align 8
  %40 = icmp eq ptr %node70, null
  br i1 %40, label %nullrecv71, label %nullrecv.ok72

nullrecv71:                                       ; preds = %nullrecv.ok68
  call void @__polaron_panic(ptr @.panic.40)
  unreachable

nullrecv.ok72:                                    ; preds = %nullrecv.ok68
  %right73 = getelementptr inbounds %"class.TreeSetNode$int", ptr %node70, i32 0, i32 3
  %right74 = load ptr, ptr %right73, align 8, !tbaa !0
  %41 = call ptr @"TreeSet$int.rotateRight"(ptr %0, ptr %right74)
  store ptr %41, ptr %right69, align 8, !tbaa !0
  br label %if.end65
}

define internal i32 @"TreeSet$int.contains"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  %cur = alloca ptr, align 8
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  %root = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end10, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %value3 = load i32, ptr %value, align 4
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  ret i32 0

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.41)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %value5 = getelementptr inbounds %"class.TreeSetNode$int", ptr %cur4, i32 0, i32 1
  %value6 = load i32, ptr %value5, align 4, !tbaa !4
  %5 = icmp slt i32 %value3, %value6
  %6 = icmp sgt i32 %value3, %value6
  %7 = select i1 %6, i32 1, i32 0
  %8 = select i1 %5, i32 -1, i32 %7
  store i32 %8, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c7, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  ret i32 1

if.end:                                           ; preds = %nullrecv.ok
  %c8 = load i32, ptr %c, align 4
  %11 = icmp slt i32 %c8, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then9, label %if.else

if.then9:                                         ; preds = %if.end
  %cur11 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur11, null
  br i1 %13, label %nullrecv12, label %nullrecv.ok13

if.else:                                          ; preds = %if.end
  %cur15 = load ptr, ptr %cur, align 8
  %14 = icmp eq ptr %cur15, null
  br i1 %14, label %nullrecv16, label %nullrecv.ok17

if.end10:                                         ; preds = %nullrecv.ok17, %nullrecv.ok13
  br label %while.cond

nullrecv12:                                       ; preds = %if.then9
  call void @__polaron_panic(ptr @.panic.42)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then9
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %cur11, i32 0, i32 2
  %left14 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left14, ptr %cur, align 8
  br label %if.end10

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.43)
  unreachable

nullrecv.ok17:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %cur15, i32 0, i32 3
  %right18 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right18, ptr %cur, align 8
  br label %if.end10
}

define internal i32 @"TreeSet$int.fill"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
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
  call void @__polaron_panic(ptr @.panic.44)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %node3, i32 0, i32 2
  %left4 = load ptr, ptr %left, align 8, !tbaa !0
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeSet$int.fill"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
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
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.45)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %value = getelementptr inbounds %"class.TreeSetNode$int", ptr %node9, i32 0, i32 1
  %value12 = load i32, ptr %value, align 4, !tbaa !4
  store i32 %value12, ptr %arr.elem, align 4
  %i13 = load i32, ptr %i, align 4
  %10 = add i32 %i13, 1
  store i32 %10, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %11 = icmp eq ptr %node14, null
  br i1 %11, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.46)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %node14, i32 0, i32 3
  %right17 = load ptr, ptr %right, align 8, !tbaa !0
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %12 = call i32 @"TreeSet$int.fill"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %12
}

define internal ptr @"TreeSet$int.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !0
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeSet$int.fill"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal i32 @"TreeSet$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"TreeSet$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"TreeSetNode$int.TreeSetNode$int"(ptr %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$int", ptr %0, i32 0, i32 0
  store ptr @"TreeSetNode$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %value = getelementptr inbounds %"class.TreeSetNode$int", ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4
  store i32 %v1, ptr %value, align 4, !tbaa !4
  %left = getelementptr inbounds %"class.TreeSetNode$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %"class.TreeSetNode$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %right, align 8, !tbaa !0
  %height = getelementptr inbounds %"class.TreeSetNode$int", ptr %0, i32 0, i32 4
  store i32 1, ptr %height, align 4, !tbaa !4
  ret void
}

define internal void @"TreeMap$int$int.TreeMap$int$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 0
  store ptr @"TreeMap$int$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %root, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeMap$int$int.~TreeMap$int$int"(ptr %0) {
entry:
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  call void @"TreeMap$int$int.freeSubtree"(ptr %0, ptr %root1)
  %root2 = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %root2, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"TreeMap$int$int.freeSubtree"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  call void @__polaron_panic(ptr @.panic.47)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %n2, i32 0, i32 3
  %left3 = load ptr, ptr %left, align 8, !tbaa !0
  call void @"TreeMap$int$int.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.48)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %n4, i32 0, i32 4
  %right7 = load ptr, ptr %right, align 8, !tbaa !0
  call void @"TreeMap$int$int.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.49)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeNode$int$int", ptr %n8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [366 x ptr], ptr %vtbl, i64 0, i64 365
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %7 = icmp ne ptr %dtor.fn, null
  br i1 %7, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %nullrecv.ok10
  call void %dtor.fn(ptr %n8)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %nullrecv.ok10
  call void @__polaron_free(ptr %n8)
  ret void
}

define internal void @"TreeMap$int$int.put"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %value = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  store i32 %2, ptr %value, align 4
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root1, align 8, !tbaa !0
  %key3 = load i32, ptr %key, align 4
  %value4 = load i32, ptr %value, align 4
  %3 = call ptr @"TreeMap$int$int.insertNode"(ptr %0, ptr %root2, i32 %key3, i32 %value4)
  store ptr %3, ptr %root, align 8, !tbaa !0
  ret void
}

define internal i32 @"TreeMap$int$int.nodeHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  call void @__polaron_panic(ptr @.panic.50)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %height = getelementptr inbounds %"class.TreeNode$int$int", ptr %n2, i32 0, i32 5
  %height3 = load i32, ptr %height, align 4, !tbaa !4
  ret i32 %height3
}

define internal void @"TreeMap$int$int.fixHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rh = alloca i32, align 4
  %lh = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.51)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %n1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeMap$int$int.nodeHeight"(ptr %0, ptr %left2)
  store i32 %3, ptr %lh, align 4
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.52)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %n3, i32 0, i32 4
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeMap$int$int.nodeHeight"(ptr %0, ptr %right6)
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
  call void @__polaron_panic(ptr @.panic.53)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeNode$int$int", ptr %n9, i32 0, i32 5
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !4
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.54)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %height16 = getelementptr inbounds %"class.TreeNode$int$int", ptr %n13, i32 0, i32 5
  %rh17 = load i32, ptr %rh, align 4
  %11 = add i32 %rh17, 1
  store i32 %11, ptr %height16, align 4, !tbaa !4
  br label %if.end
}

define internal i32 @"TreeMap$int$int.balance"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.55)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %n1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeMap$int$int.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.56)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %n3, i32 0, i32 4
  %right6 = load ptr, ptr %right, align 8, !tbaa !0
  %5 = call i32 @"TreeMap$int$int.nodeHeight"(ptr %0, ptr %right6)
  %6 = sub i32 %3, %5
  ret i32 %6
}

define internal ptr @"TreeMap$int$int.rotateRight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %1, ptr %y, align 8
  %y1 = load ptr, ptr %y, align 8
  %2 = icmp eq ptr %y1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.57)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %y1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.58)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeNode$int$int", ptr %y3, i32 0, i32 3
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.59)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %x7, i32 0, i32 4
  %right10 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right10, ptr %left6, align 8, !tbaa !0
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.60)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %right14 = getelementptr inbounds %"class.TreeNode$int$int", ptr %x11, i32 0, i32 4
  %y15 = load ptr, ptr %y, align 8
  store ptr %y15, ptr %right14, align 8, !tbaa !0
  %y16 = load ptr, ptr %y, align 8
  call void @"TreeMap$int$int.fixHeight"(ptr %0, ptr %y16)
  %x17 = load ptr, ptr %x, align 8
  call void @"TreeMap$int$int.fixHeight"(ptr %0, ptr %x17)
  %x18 = load ptr, ptr %x, align 8
  ret ptr %x18
}

define internal ptr @"TreeMap$int$int.rotateLeft"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %2 = icmp eq ptr %x1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.61)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %x1, i32 0, i32 4
  %right2 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.62)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeNode$int$int", ptr %x3, i32 0, i32 4
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.63)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %y7, i32 0, i32 3
  %left10 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left10, ptr %right6, align 8, !tbaa !0
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.64)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %left14 = getelementptr inbounds %"class.TreeNode$int$int", ptr %y11, i32 0, i32 3
  %x15 = load ptr, ptr %x, align 8
  store ptr %x15, ptr %left14, align 8, !tbaa !0
  %x16 = load ptr, ptr %x, align 8
  call void @"TreeMap$int$int.fixHeight"(ptr %0, ptr %x16)
  %y17 = load ptr, ptr %y, align 8
  call void @"TreeMap$int$int.fixHeight"(ptr %0, ptr %y17)
  %y18 = load ptr, ptr %y, align 8
  ret ptr %y18
}

define internal ptr @"TreeMap$int$int.insertNode"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3) {
entry:
  %bf = alloca i32, align 4
  %c = alloca i32, align 4
  %value = alloca i32, align 4
  %key = alloca i32, align 4
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  store i32 %2, ptr %key, align 4
  store i32 %3, ptr %value, align 4
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %6 = add i32 %count3, 1
  store i32 %6, ptr %count, align 4, !tbaa !4
  %"TreeNode$int$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeNode$int$int", ptr null, i64 1) to i64))
  %key4 = load i32, ptr %key, align 4
  %value5 = load i32, ptr %value, align 4
  call void @"TreeNode$int$int.TreeNode$int$int"(ptr %"TreeNode$int$int.obj", i32 %key4, i32 %value5)
  ret ptr %"TreeNode$int$int.obj"

if.end:                                           ; preds = %entry
  %key6 = load i32, ptr %key, align 4
  %node7 = load ptr, ptr %node, align 8
  %7 = icmp eq ptr %node7, null
  br i1 %7, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.65)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %key8 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node7, i32 0, i32 1
  %key9 = load i32, ptr %key8, align 4, !tbaa !4
  %8 = icmp slt i32 %key6, %key9
  %9 = icmp sgt i32 %key6, %key9
  %10 = select i1 %9, i32 1, i32 0
  %11 = select i1 %8, i32 -1, i32 %10
  store i32 %11, ptr %c, align 4
  %c10 = load i32, ptr %c, align 4
  %12 = icmp eq i32 %c10, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then11, label %if.end12

if.then11:                                        ; preds = %nullrecv.ok
  %node13 = load ptr, ptr %node, align 8
  %14 = icmp eq ptr %node13, null
  br i1 %14, label %nullrecv14, label %nullrecv.ok15

if.end12:                                         ; preds = %nullrecv.ok
  %c19 = load i32, ptr %c, align 4
  %15 = icmp slt i32 %c19, 0
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then20, label %if.else

nullrecv14:                                       ; preds = %if.then11
  call void @__polaron_panic(ptr @.panic.66)
  unreachable

nullrecv.ok15:                                    ; preds = %if.then11
  %value16 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node13, i32 0, i32 2
  %value17 = load i32, ptr %value, align 4
  store i32 %value17, ptr %value16, align 4, !tbaa !4
  %node18 = load ptr, ptr %node, align 8
  ret ptr %node18

if.then20:                                        ; preds = %if.end12
  %node22 = load ptr, ptr %node, align 8
  %17 = icmp eq ptr %node22, null
  br i1 %17, label %nullrecv23, label %nullrecv.ok24

if.else:                                          ; preds = %if.end12
  %node32 = load ptr, ptr %node, align 8
  %18 = icmp eq ptr %node32, null
  br i1 %18, label %nullrecv33, label %nullrecv.ok34

if.end21:                                         ; preds = %nullrecv.ok37, %nullrecv.ok27
  %node42 = load ptr, ptr %node, align 8
  call void @"TreeMap$int$int.fixHeight"(ptr %0, ptr %node42)
  %node43 = load ptr, ptr %node, align 8
  %19 = call i32 @"TreeMap$int$int.balance"(ptr %0, ptr %node43)
  store i32 %19, ptr %bf, align 4
  %bf44 = load i32, ptr %bf, align 4
  %20 = icmp sgt i32 %bf44, 1
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then45, label %if.end46

nullrecv23:                                       ; preds = %if.then20
  call void @__polaron_panic(ptr @.panic.67)
  unreachable

nullrecv.ok24:                                    ; preds = %if.then20
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %node22, i32 0, i32 3
  %node25 = load ptr, ptr %node, align 8
  %22 = icmp eq ptr %node25, null
  br i1 %22, label %nullrecv26, label %nullrecv.ok27

nullrecv26:                                       ; preds = %nullrecv.ok24
  call void @__polaron_panic(ptr @.panic.68)
  unreachable

nullrecv.ok27:                                    ; preds = %nullrecv.ok24
  %left28 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node25, i32 0, i32 3
  %left29 = load ptr, ptr %left28, align 8, !tbaa !0
  %key30 = load i32, ptr %key, align 4
  %value31 = load i32, ptr %value, align 4
  %23 = call ptr @"TreeMap$int$int.insertNode"(ptr %0, ptr %left29, i32 %key30, i32 %value31)
  store ptr %23, ptr %left, align 8, !tbaa !0
  br label %if.end21

nullrecv33:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.69)
  unreachable

nullrecv.ok34:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %node32, i32 0, i32 4
  %node35 = load ptr, ptr %node, align 8
  %24 = icmp eq ptr %node35, null
  br i1 %24, label %nullrecv36, label %nullrecv.ok37

nullrecv36:                                       ; preds = %nullrecv.ok34
  call void @__polaron_panic(ptr @.panic.70)
  unreachable

nullrecv.ok37:                                    ; preds = %nullrecv.ok34
  %right38 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node35, i32 0, i32 4
  %right39 = load ptr, ptr %right38, align 8, !tbaa !0
  %key40 = load i32, ptr %key, align 4
  %value41 = load i32, ptr %value, align 4
  %25 = call ptr @"TreeMap$int$int.insertNode"(ptr %0, ptr %right39, i32 %key40, i32 %value41)
  store ptr %25, ptr %right, align 8, !tbaa !0
  br label %if.end21

if.then45:                                        ; preds = %if.end21
  %node47 = load ptr, ptr %node, align 8
  %26 = icmp eq ptr %node47, null
  br i1 %26, label %nullrecv48, label %nullrecv.ok49

if.end46:                                         ; preds = %if.end21
  %bf64 = load i32, ptr %bf, align 4
  %27 = icmp slt i32 %bf64, -1
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then65, label %if.end66

nullrecv48:                                       ; preds = %if.then45
  call void @__polaron_panic(ptr @.panic.71)
  unreachable

nullrecv.ok49:                                    ; preds = %if.then45
  %left50 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node47, i32 0, i32 3
  %left51 = load ptr, ptr %left50, align 8, !tbaa !0
  %29 = call i32 @"TreeMap$int$int.balance"(ptr %0, ptr %left51)
  %30 = icmp slt i32 %29, 0
  %31 = zext i1 %30 to i32
  br i1 %30, label %if.then52, label %if.end53

if.then52:                                        ; preds = %nullrecv.ok49
  %node54 = load ptr, ptr %node, align 8
  %32 = icmp eq ptr %node54, null
  br i1 %32, label %nullrecv55, label %nullrecv.ok56

if.end53:                                         ; preds = %nullrecv.ok60, %nullrecv.ok49
  %node63 = load ptr, ptr %node, align 8
  %33 = call ptr @"TreeMap$int$int.rotateRight"(ptr %0, ptr %node63)
  ret ptr %33

nullrecv55:                                       ; preds = %if.then52
  call void @__polaron_panic(ptr @.panic.72)
  unreachable

nullrecv.ok56:                                    ; preds = %if.then52
  %left57 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node54, i32 0, i32 3
  %node58 = load ptr, ptr %node, align 8
  %34 = icmp eq ptr %node58, null
  br i1 %34, label %nullrecv59, label %nullrecv.ok60

nullrecv59:                                       ; preds = %nullrecv.ok56
  call void @__polaron_panic(ptr @.panic.73)
  unreachable

nullrecv.ok60:                                    ; preds = %nullrecv.ok56
  %left61 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node58, i32 0, i32 3
  %left62 = load ptr, ptr %left61, align 8, !tbaa !0
  %35 = call ptr @"TreeMap$int$int.rotateLeft"(ptr %0, ptr %left62)
  store ptr %35, ptr %left57, align 8, !tbaa !0
  br label %if.end53

if.then65:                                        ; preds = %if.end46
  %node67 = load ptr, ptr %node, align 8
  %36 = icmp eq ptr %node67, null
  br i1 %36, label %nullrecv68, label %nullrecv.ok69

if.end66:                                         ; preds = %if.end46
  %node84 = load ptr, ptr %node, align 8
  ret ptr %node84

nullrecv68:                                       ; preds = %if.then65
  call void @__polaron_panic(ptr @.panic.74)
  unreachable

nullrecv.ok69:                                    ; preds = %if.then65
  %right70 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node67, i32 0, i32 4
  %right71 = load ptr, ptr %right70, align 8, !tbaa !0
  %37 = call i32 @"TreeMap$int$int.balance"(ptr %0, ptr %right71)
  %38 = icmp sgt i32 %37, 0
  %39 = zext i1 %38 to i32
  br i1 %38, label %if.then72, label %if.end73

if.then72:                                        ; preds = %nullrecv.ok69
  %node74 = load ptr, ptr %node, align 8
  %40 = icmp eq ptr %node74, null
  br i1 %40, label %nullrecv75, label %nullrecv.ok76

if.end73:                                         ; preds = %nullrecv.ok80, %nullrecv.ok69
  %node83 = load ptr, ptr %node, align 8
  %41 = call ptr @"TreeMap$int$int.rotateLeft"(ptr %0, ptr %node83)
  ret ptr %41

nullrecv75:                                       ; preds = %if.then72
  call void @__polaron_panic(ptr @.panic.75)
  unreachable

nullrecv.ok76:                                    ; preds = %if.then72
  %right77 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node74, i32 0, i32 4
  %node78 = load ptr, ptr %node, align 8
  %42 = icmp eq ptr %node78, null
  br i1 %42, label %nullrecv79, label %nullrecv.ok80

nullrecv79:                                       ; preds = %nullrecv.ok76
  call void @__polaron_panic(ptr @.panic.76)
  unreachable

nullrecv.ok80:                                    ; preds = %nullrecv.ok76
  %right81 = getelementptr inbounds %"class.TreeNode$int$int", ptr %node78, i32 0, i32 4
  %right82 = load ptr, ptr %right81, align 8, !tbaa !0
  %43 = call ptr @"TreeMap$int$int.rotateRight"(ptr %0, ptr %right82)
  store ptr %43, ptr %right77, align 8, !tbaa !0
  br label %if.end73
}

define internal ptr @"TreeMap$int$int.find"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  %cur = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end11, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load i32, ptr %key, align 4
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  ret ptr null

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.77)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 1
  %key6 = load i32, ptr %key5, align 4, !tbaa !4
  %5 = icmp slt i32 %key3, %key6
  %6 = icmp sgt i32 %key3, %key6
  %7 = select i1 %6, i32 1, i32 0
  %8 = select i1 %5, i32 -1, i32 %7
  store i32 %8, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c7, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur8 = load ptr, ptr %cur, align 8
  ret ptr %cur8

if.end:                                           ; preds = %nullrecv.ok
  %c9 = load i32, ptr %c, align 4
  %11 = icmp slt i32 %c9, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then10, label %if.else

if.then10:                                        ; preds = %if.end
  %cur12 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur12, null
  br i1 %13, label %nullrecv13, label %nullrecv.ok14

if.else:                                          ; preds = %if.end
  %cur16 = load ptr, ptr %cur, align 8
  %14 = icmp eq ptr %cur16, null
  br i1 %14, label %nullrecv17, label %nullrecv.ok18

if.end11:                                         ; preds = %nullrecv.ok18, %nullrecv.ok14
  br label %while.cond

nullrecv13:                                       ; preds = %if.then10
  call void @__polaron_panic(ptr @.panic.78)
  unreachable

nullrecv.ok14:                                    ; preds = %if.then10
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur12, i32 0, i32 3
  %left15 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left15, ptr %cur, align 8
  br label %if.end11

nullrecv17:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.79)
  unreachable

nullrecv.ok18:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur16, i32 0, i32 4
  %right19 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right19, ptr %cur, align 8
  br label %if.end11
}

define internal i32 @"TreeMap$int$int.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %z = alloca i32, align 4
  %zero = alloca ptr, align 8
  %n = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %key1 = load i32, ptr %key, align 4
  %2 = call ptr @"TreeMap$int$int.find"(ptr %0, i32 %key1)
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
  call void @__polaron_panic(ptr @.panic.80)
  unreachable

nullrecv.ok:                                      ; preds = %if.then
  %value = getelementptr inbounds %"class.TreeNode$int$int", ptr %n3, i32 0, i32 2
  %value4 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value4

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.81, ptr @.faila.82, i64 0, ptr @.failb.83, i64 %arr.len, i32 70)
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

define internal i32 @"TreeMap$int$int.containsKey"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %key1 = load i32, ptr %key, align 4
  %2 = call ptr @"TreeMap$int$int.find"(ptr %0, i32 %key1)
  %3 = icmp ne ptr %2, null
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal i32 @"TreeMap$int$int.fillKeys"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
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
  call void @__polaron_panic(ptr @.panic.84)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %node3, i32 0, i32 3
  %left4 = load ptr, ptr %left, align 8, !tbaa !0
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeMap$int$int.fillKeys"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
  store i32 %7, ptr %i, align 4
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i8 = load i32, ptr %i, align 4
  %8 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %out7, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %nullrecv.ok
  call void @__polaron_fail(ptr @.fail.85, ptr @.faila.86, i64 %8, ptr @.failb.87, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.88)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %key = getelementptr inbounds %"class.TreeNode$int$int", ptr %node9, i32 0, i32 1
  %key12 = load i32, ptr %key, align 4, !tbaa !4
  store i32 %key12, ptr %arr.elem, align 4
  %i13 = load i32, ptr %i, align 4
  %10 = add i32 %i13, 1
  store i32 %10, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %11 = icmp eq ptr %node14, null
  br i1 %11, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.89)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %node14, i32 0, i32 4
  %right17 = load ptr, ptr %right, align 8, !tbaa !0
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %12 = call i32 @"TreeMap$int$int.fillKeys"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %12
}

define internal i32 @"TreeMap$int$int.fillValues"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
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
  call void @__polaron_panic(ptr @.panic.90)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %node3, i32 0, i32 3
  %left4 = load ptr, ptr %left, align 8, !tbaa !0
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeMap$int$int.fillValues"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
  store i32 %7, ptr %i, align 4
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i8 = load i32, ptr %i, align 4
  %8 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %out7, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %nullrecv.ok
  call void @__polaron_fail(ptr @.fail.91, ptr @.faila.92, i64 %8, ptr @.failb.93, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.94)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %value = getelementptr inbounds %"class.TreeNode$int$int", ptr %node9, i32 0, i32 2
  %value12 = load i32, ptr %value, align 4, !tbaa !4
  store i32 %value12, ptr %arr.elem, align 4
  %i13 = load i32, ptr %i, align 4
  %10 = add i32 %i13, 1
  store i32 %10, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %11 = icmp eq ptr %node14, null
  br i1 %11, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.95)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %node14, i32 0, i32 4
  %right17 = load ptr, ptr %right, align 8, !tbaa !0
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %12 = call i32 @"TreeMap$int$int.fillValues"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %12
}

define internal ptr @"TreeMap$int$int.keyArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !0
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeMap$int$int.fillKeys"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal ptr @"TreeMap$int$int.valueArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !0
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeMap$int$int.fillValues"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal i32 @"TreeMap$int$int.zeroKey"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %z = alloca i32, align 4
  %zero = alloca ptr, align 8
  %arr = call ptr @__polaron_malloc(i64 12)
  store i64 1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 4)
  store ptr %arr, ptr %zero, align 8
  %zero1 = load ptr, ptr %zero, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %zero1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.96, ptr @.faila.97, i64 0, ptr @.failb.98, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %zero1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data2, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %z, align 4
  %zero3 = load ptr, ptr %zero, align 8
  call void @__polaron_free(ptr %zero3)
  %z4 = load i32, ptr %z, align 4
  ret i32 %z4
}

define internal i32 @"TreeMap$int$int.firstKey"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %cur = alloca ptr, align 8
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  %1 = icmp eq ptr %root1, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = call i32 @"TreeMap$int$int.zeroKey"(ptr %0)
  ret i32 %3

if.end:                                           ; preds = %entry
  %root2 = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_panic(ptr @.panic.99)
  unreachable

nullrecv.ok:                                      ; preds = %while.cond
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 3
  %left5 = load ptr, ptr %left, align 8, !tbaa !0
  %7 = icmp ne ptr %left5, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

nullrecv7:                                        ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.100)
  unreachable

nullrecv.ok8:                                     ; preds = %while.body
  %left9 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur6, i32 0, i32 3
  %left10 = load ptr, ptr %left9, align 8, !tbaa !0
  store ptr %left10, ptr %cur, align 8
  br label %while.cond

nullrecv12:                                       ; preds = %while.end
  call void @__polaron_panic(ptr @.panic.101)
  unreachable

nullrecv.ok13:                                    ; preds = %while.end
  %key = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur11, i32 0, i32 1
  %key14 = load i32, ptr %key, align 4, !tbaa !4
  ret i32 %key14
}

define internal i32 @"TreeMap$int$int.lastKey"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %cur = alloca ptr, align 8
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  %1 = icmp eq ptr %root1, null
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %3 = call i32 @"TreeMap$int$int.zeroKey"(ptr %0)
  ret i32 %3

if.end:                                           ; preds = %entry
  %root2 = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_panic(ptr @.panic.102)
  unreachable

nullrecv.ok:                                      ; preds = %while.cond
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 4
  %right5 = load ptr, ptr %right, align 8, !tbaa !0
  %7 = icmp ne ptr %right5, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

nullrecv7:                                        ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.103)
  unreachable

nullrecv.ok8:                                     ; preds = %while.body
  %right9 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur6, i32 0, i32 4
  %right10 = load ptr, ptr %right9, align 8, !tbaa !0
  store ptr %right10, ptr %cur, align 8
  br label %while.cond

nullrecv12:                                       ; preds = %while.end
  call void @__polaron_panic(ptr @.panic.104)
  unreachable

nullrecv.ok13:                                    ; preds = %while.end
  %key = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur11, i32 0, i32 1
  %key14 = load i32, ptr %key, align 4, !tbaa !4
  ret i32 %key14
}

define internal i32 @"TreeMap$int$int.floorKey"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  store ptr null, ptr %best, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end15, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load i32, ptr %key, align 4
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best25 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best25, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then26, label %if.end27

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.105)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 1
  %key6 = load i32, ptr %key5, align 4, !tbaa !4
  %7 = icmp slt i32 %key3, %key6
  %8 = icmp sgt i32 %key3, %key6
  %9 = select i1 %8, i32 1, i32 0
  %10 = select i1 %7, i32 -1, i32 %9
  store i32 %10, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %11 = icmp eq i32 %c7, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur8 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur8, null
  br i1 %13, label %nullrecv9, label %nullrecv.ok10

if.end:                                           ; preds = %nullrecv.ok
  %c13 = load i32, ptr %c, align 4
  %14 = icmp slt i32 %c13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then14, label %if.else

nullrecv9:                                        ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.106)
  unreachable

nullrecv.ok10:                                    ; preds = %if.then
  %key11 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur8, i32 0, i32 1
  %key12 = load i32, ptr %key11, align 4, !tbaa !4
  ret i32 %key12

if.then14:                                        ; preds = %if.end
  %cur16 = load ptr, ptr %cur, align 8
  %16 = icmp eq ptr %cur16, null
  br i1 %16, label %nullrecv17, label %nullrecv.ok18

if.else:                                          ; preds = %if.end
  %cur20 = load ptr, ptr %cur, align 8
  store ptr %cur20, ptr %best, align 8
  %cur21 = load ptr, ptr %cur, align 8
  %17 = icmp eq ptr %cur21, null
  br i1 %17, label %nullrecv22, label %nullrecv.ok23

if.end15:                                         ; preds = %nullrecv.ok23, %nullrecv.ok18
  br label %while.cond

nullrecv17:                                       ; preds = %if.then14
  call void @__polaron_panic(ptr @.panic.107)
  unreachable

nullrecv.ok18:                                    ; preds = %if.then14
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur16, i32 0, i32 3
  %left19 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left19, ptr %cur, align 8
  br label %if.end15

nullrecv22:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.108)
  unreachable

nullrecv.ok23:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur21, i32 0, i32 4
  %right24 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right24, ptr %cur, align 8
  br label %if.end15

if.then26:                                        ; preds = %while.end
  %18 = call i32 @"TreeMap$int$int.zeroKey"(ptr %0)
  ret i32 %18

if.end27:                                         ; preds = %while.end
  %best28 = load ptr, ptr %best, align 8
  %19 = icmp eq ptr %best28, null
  br i1 %19, label %nullrecv29, label %nullrecv.ok30

nullrecv29:                                       ; preds = %if.end27
  call void @__polaron_panic(ptr @.panic.109)
  unreachable

nullrecv.ok30:                                    ; preds = %if.end27
  %key31 = getelementptr inbounds %"class.TreeNode$int$int", ptr %best28, i32 0, i32 1
  %key32 = load i32, ptr %key31, align 4, !tbaa !4
  ret i32 %key32
}

define internal i32 @"TreeMap$int$int.ceilingKey"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !0
  store ptr %root1, ptr %cur, align 8
  store ptr null, ptr %best, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end15, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %2 = icmp ne ptr %cur2, null
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %key3 = load i32, ptr %key, align 4
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best25 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best25, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then26, label %if.end27

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.110)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 1
  %key6 = load i32, ptr %key5, align 4, !tbaa !4
  %7 = icmp slt i32 %key3, %key6
  %8 = icmp sgt i32 %key3, %key6
  %9 = select i1 %8, i32 1, i32 0
  %10 = select i1 %7, i32 -1, i32 %9
  store i32 %10, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %11 = icmp eq i32 %c7, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  %cur8 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur8, null
  br i1 %13, label %nullrecv9, label %nullrecv.ok10

if.end:                                           ; preds = %nullrecv.ok
  %c13 = load i32, ptr %c, align 4
  %14 = icmp sgt i32 %c13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then14, label %if.else

nullrecv9:                                        ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.111)
  unreachable

nullrecv.ok10:                                    ; preds = %if.then
  %key11 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur8, i32 0, i32 1
  %key12 = load i32, ptr %key11, align 4, !tbaa !4
  ret i32 %key12

if.then14:                                        ; preds = %if.end
  %cur16 = load ptr, ptr %cur, align 8
  %16 = icmp eq ptr %cur16, null
  br i1 %16, label %nullrecv17, label %nullrecv.ok18

if.else:                                          ; preds = %if.end
  %cur20 = load ptr, ptr %cur, align 8
  store ptr %cur20, ptr %best, align 8
  %cur21 = load ptr, ptr %cur, align 8
  %17 = icmp eq ptr %cur21, null
  br i1 %17, label %nullrecv22, label %nullrecv.ok23

if.end15:                                         ; preds = %nullrecv.ok23, %nullrecv.ok18
  br label %while.cond

nullrecv17:                                       ; preds = %if.then14
  call void @__polaron_panic(ptr @.panic.112)
  unreachable

nullrecv.ok18:                                    ; preds = %if.then14
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur16, i32 0, i32 4
  %right19 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right19, ptr %cur, align 8
  br label %if.end15

nullrecv22:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.113)
  unreachable

nullrecv.ok23:                                    ; preds = %if.else
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur21, i32 0, i32 3
  %left24 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left24, ptr %cur, align 8
  br label %if.end15

if.then26:                                        ; preds = %while.end
  %18 = call i32 @"TreeMap$int$int.zeroKey"(ptr %0)
  ret i32 %18

if.end27:                                         ; preds = %while.end
  %best28 = load ptr, ptr %best, align 8
  %19 = icmp eq ptr %best28, null
  br i1 %19, label %nullrecv29, label %nullrecv.ok30

nullrecv29:                                       ; preds = %if.end27
  call void @__polaron_panic(ptr @.panic.114)
  unreachable

nullrecv.ok30:                                    ; preds = %if.end27
  %key31 = getelementptr inbounds %"class.TreeNode$int$int", ptr %best28, i32 0, i32 1
  %key32 = load i32, ptr %key31, align 4, !tbaa !4
  ret i32 %key32
}

define internal i32 @"TreeMap$int$int.higherKey"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
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
  %key3 = load i32, ptr %key, align 4
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best17 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best17, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then18, label %if.end19

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.115)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 1
  %key6 = load i32, ptr %key5, align 4, !tbaa !4
  %7 = icmp slt i32 %key3, %key6
  %8 = icmp sgt i32 %key3, %key6
  %9 = select i1 %8, i32 1, i32 0
  %10 = select i1 %7, i32 -1, i32 %9
  store i32 %10, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %11 = icmp slt i32 %c7, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then, label %if.else

if.then:                                          ; preds = %nullrecv.ok
  %cur8 = load ptr, ptr %cur, align 8
  store ptr %cur8, ptr %best, align 8
  %cur9 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur9, null
  br i1 %13, label %nullrecv10, label %nullrecv.ok11

if.else:                                          ; preds = %nullrecv.ok
  %cur13 = load ptr, ptr %cur, align 8
  %14 = icmp eq ptr %cur13, null
  br i1 %14, label %nullrecv14, label %nullrecv.ok15

if.end:                                           ; preds = %nullrecv.ok15, %nullrecv.ok11
  br label %while.cond

nullrecv10:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.116)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur9, i32 0, i32 3
  %left12 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left12, ptr %cur, align 8
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.117)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur13, i32 0, i32 4
  %right16 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right16, ptr %cur, align 8
  br label %if.end

if.then18:                                        ; preds = %while.end
  %15 = call i32 @"TreeMap$int$int.zeroKey"(ptr %0)
  ret i32 %15

if.end19:                                         ; preds = %while.end
  %best20 = load ptr, ptr %best, align 8
  %16 = icmp eq ptr %best20, null
  br i1 %16, label %nullrecv21, label %nullrecv.ok22

nullrecv21:                                       ; preds = %if.end19
  call void @__polaron_panic(ptr @.panic.118)
  unreachable

nullrecv.ok22:                                    ; preds = %if.end19
  %key23 = getelementptr inbounds %"class.TreeNode$int$int", ptr %best20, i32 0, i32 1
  %key24 = load i32, ptr %key23, align 4, !tbaa !4
  ret i32 %key24
}

define internal i32 @"TreeMap$int$int.lowerKey"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  %best = alloca ptr, align 8
  %cur = alloca ptr, align 8
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %root = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 1
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
  %key3 = load i32, ptr %key, align 4
  %cur4 = load ptr, ptr %cur, align 8
  %4 = icmp eq ptr %cur4, null
  br i1 %4, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  %best17 = load ptr, ptr %best, align 8
  %5 = icmp eq ptr %best17, null
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then18, label %if.end19

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.119)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %key5 = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur4, i32 0, i32 1
  %key6 = load i32, ptr %key5, align 4, !tbaa !4
  %7 = icmp slt i32 %key3, %key6
  %8 = icmp sgt i32 %key3, %key6
  %9 = select i1 %8, i32 1, i32 0
  %10 = select i1 %7, i32 -1, i32 %9
  store i32 %10, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %11 = icmp sgt i32 %c7, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then, label %if.else

if.then:                                          ; preds = %nullrecv.ok
  %cur8 = load ptr, ptr %cur, align 8
  store ptr %cur8, ptr %best, align 8
  %cur9 = load ptr, ptr %cur, align 8
  %13 = icmp eq ptr %cur9, null
  br i1 %13, label %nullrecv10, label %nullrecv.ok11

if.else:                                          ; preds = %nullrecv.ok
  %cur13 = load ptr, ptr %cur, align 8
  %14 = icmp eq ptr %cur13, null
  br i1 %14, label %nullrecv14, label %nullrecv.ok15

if.end:                                           ; preds = %nullrecv.ok15, %nullrecv.ok11
  br label %while.cond

nullrecv10:                                       ; preds = %if.then
  call void @__polaron_panic(ptr @.panic.120)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur9, i32 0, i32 4
  %right12 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right12, ptr %cur, align 8
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.121)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %cur13, i32 0, i32 3
  %left16 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left16, ptr %cur, align 8
  br label %if.end

if.then18:                                        ; preds = %while.end
  %15 = call i32 @"TreeMap$int$int.zeroKey"(ptr %0)
  ret i32 %15

if.end19:                                         ; preds = %while.end
  %best20 = load ptr, ptr %best, align 8
  %16 = icmp eq ptr %best20, null
  br i1 %16, label %nullrecv21, label %nullrecv.ok22

nullrecv21:                                       ; preds = %if.end19
  call void @__polaron_panic(ptr @.panic.122)
  unreachable

nullrecv.ok22:                                    ; preds = %if.end19
  %key23 = getelementptr inbounds %"class.TreeNode$int$int", ptr %best20, i32 0, i32 1
  %key24 = load i32, ptr %key23, align 4, !tbaa !4
  ret i32 %key24
}

define internal i32 @"TreeMap$int$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"TreeMap$int$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeMap$int$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"TreeNode$int$int.TreeNode$int$int"(ptr %0, i32 %1, i32 %2) {
entry:
  %v = alloca i32, align 4
  %k = alloca i32, align 4
  store i32 %1, ptr %k, align 4
  store i32 %2, ptr %v, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeNode$int$int", ptr %0, i32 0, i32 0
  store ptr @"TreeNode$int$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %key = getelementptr inbounds %"class.TreeNode$int$int", ptr %0, i32 0, i32 1
  %k1 = load i32, ptr %k, align 4
  store i32 %k1, ptr %key, align 4, !tbaa !4
  %value = getelementptr inbounds %"class.TreeNode$int$int", ptr %0, i32 0, i32 2
  %v2 = load i32, ptr %v, align 4
  store i32 %v2, ptr %value, align 4, !tbaa !4
  %left = getelementptr inbounds %"class.TreeNode$int$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %left, align 8, !tbaa !0
  %right = getelementptr inbounds %"class.TreeNode$int$int", ptr %0, i32 0, i32 4
  store ptr null, ptr %right, align 8, !tbaa !0
  %height = getelementptr inbounds %"class.TreeNode$int$int", ptr %0, i32 0, i32 5
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
  call void @__polaron_panic(ptr @.panic.123)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %n2, i32 0, i32 3
  %left3 = load ptr, ptr %left, align 8, !tbaa !0
  call void @"TreeMap$String$int.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.124)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %n4, i32 0, i32 4
  %right7 = load ptr, ptr %right, align 8, !tbaa !0
  call void @"TreeMap$String$int.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.125)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeNode$String$int", ptr %n8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [366 x ptr], ptr %vtbl, i64 0, i64 365
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
  call void @__polaron_panic(ptr @.panic.126)
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
  call void @__polaron_panic(ptr @.panic.127)
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
  call void @__polaron_panic(ptr @.panic.128)
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
  call void @__polaron_panic(ptr @.panic.129)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeNode$String$int", ptr %n9, i32 0, i32 5
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !4
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.130)
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
  call void @__polaron_panic(ptr @.panic.131)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %n1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  %3 = call i32 @"TreeMap$String$int.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.132)
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
  call void @__polaron_panic(ptr @.panic.133)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %y1, i32 0, i32 3
  %left2 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.134)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeNode$String$int", ptr %y3, i32 0, i32 3
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.135)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %x7, i32 0, i32 4
  %right10 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right10, ptr %left6, align 8, !tbaa !0
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.136)
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
  call void @__polaron_panic(ptr @.panic.137)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %x1, i32 0, i32 4
  %right2 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.138)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeNode$String$int", ptr %x3, i32 0, i32 4
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.139)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %y7, i32 0, i32 3
  %left10 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left10, ptr %right6, align 8, !tbaa !0
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.140)
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
  call void @__polaron_panic(ptr @.panic.141)
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
  call void @__polaron_panic(ptr @.panic.142)
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
  call void @__polaron_panic(ptr @.panic.143)
  unreachable

nullrecv.ok26:                                    ; preds = %if.then22
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %node24, i32 0, i32 3
  %node27 = load ptr, ptr %node, align 8
  %19 = icmp eq ptr %node27, null
  br i1 %19, label %nullrecv28, label %nullrecv.ok29

nullrecv28:                                       ; preds = %nullrecv.ok26
  call void @__polaron_panic(ptr @.panic.144)
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
  call void @__polaron_panic(ptr @.panic.145)
  unreachable

nullrecv.ok36:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %node34, i32 0, i32 4
  %node37 = load ptr, ptr %node, align 8
  %21 = icmp eq ptr %node37, null
  br i1 %21, label %nullrecv38, label %nullrecv.ok39

nullrecv38:                                       ; preds = %nullrecv.ok36
  call void @__polaron_panic(ptr @.panic.146)
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
  call void @__polaron_panic(ptr @.panic.147)
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
  call void @__polaron_panic(ptr @.panic.148)
  unreachable

nullrecv.ok58:                                    ; preds = %if.then54
  %left59 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node56, i32 0, i32 3
  %node60 = load ptr, ptr %node, align 8
  %31 = icmp eq ptr %node60, null
  br i1 %31, label %nullrecv61, label %nullrecv.ok62

nullrecv61:                                       ; preds = %nullrecv.ok58
  call void @__polaron_panic(ptr @.panic.149)
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
  call void @__polaron_panic(ptr @.panic.150)
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
  call void @__polaron_panic(ptr @.panic.151)
  unreachable

nullrecv.ok78:                                    ; preds = %if.then74
  %right79 = getelementptr inbounds %"class.TreeNode$String$int", ptr %node76, i32 0, i32 4
  %node80 = load ptr, ptr %node, align 8
  %39 = icmp eq ptr %node80, null
  br i1 %39, label %nullrecv81, label %nullrecv.ok82

nullrecv81:                                       ; preds = %nullrecv.ok78
  call void @__polaron_panic(ptr @.panic.152)
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
  call void @__polaron_panic(ptr @.panic.153)
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
  call void @__polaron_panic(ptr @.panic.154)
  unreachable

nullrecv.ok16:                                    ; preds = %if.then12
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur14, i32 0, i32 3
  %left17 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left17, ptr %cur, align 8
  br label %if.end13

nullrecv19:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.155)
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
  call void @__polaron_panic(ptr @.panic.156)
  unreachable

nullrecv.ok:                                      ; preds = %if.then
  %value = getelementptr inbounds %"class.TreeNode$String$int", ptr %n3, i32 0, i32 2
  %value4 = load i32, ptr %value, align 4, !tbaa !4
  ret i32 %value4

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.157, ptr @.faila.158, i64 0, ptr @.failb.159, i64 %arr.len, i32 70)
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
  call void @__polaron_panic(ptr @.panic.160)
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
  call void @__polaron_fail(ptr @.fail.161, ptr @.faila.162, i64 %8, ptr @.failb.163, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.164)
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
  call void @__polaron_panic(ptr @.panic.165)
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
  call void @__polaron_panic(ptr @.panic.166)
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
  call void @__polaron_fail(ptr @.fail.167, ptr @.faila.168, i64 %8, ptr @.failb.169, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %nullrecv.ok
  %arr.data = getelementptr i8, ptr %out7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.170)
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
  call void @__polaron_panic(ptr @.panic.171)
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
  call void @__polaron_fail(ptr @.fail.172, ptr @.faila.173, i64 0, ptr @.failb.174, i64 %arr.len, i32 70)
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
  call void @__polaron_panic(ptr @.panic.175)
  unreachable

nullrecv.ok:                                      ; preds = %while.cond
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 3
  %left5 = load ptr, ptr %left, align 8, !tbaa !0
  %7 = icmp ne ptr %left5, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

nullrecv7:                                        ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.176)
  unreachable

nullrecv.ok8:                                     ; preds = %while.body
  %left9 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur6, i32 0, i32 3
  %left10 = load ptr, ptr %left9, align 8, !tbaa !0
  store ptr %left10, ptr %cur, align 8
  br label %while.cond

nullrecv12:                                       ; preds = %while.end
  call void @__polaron_panic(ptr @.panic.177)
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
  call void @__polaron_panic(ptr @.panic.178)
  unreachable

nullrecv.ok:                                      ; preds = %while.cond
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur4, i32 0, i32 4
  %right5 = load ptr, ptr %right, align 8, !tbaa !0
  %7 = icmp ne ptr %right5, null
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

nullrecv7:                                        ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.179)
  unreachable

nullrecv.ok8:                                     ; preds = %while.body
  %right9 = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur6, i32 0, i32 4
  %right10 = load ptr, ptr %right9, align 8, !tbaa !0
  store ptr %right10, ptr %cur, align 8
  br label %while.cond

nullrecv12:                                       ; preds = %while.end
  call void @__polaron_panic(ptr @.panic.180)
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
  call void @__polaron_panic(ptr @.panic.181)
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
  call void @__polaron_panic(ptr @.panic.182)
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
  call void @__polaron_panic(ptr @.panic.183)
  unreachable

nullrecv.ok20:                                    ; preds = %if.then16
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur18, i32 0, i32 3
  %left21 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left21, ptr %cur, align 8
  br label %if.end17

nullrecv24:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.184)
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
  call void @__polaron_panic(ptr @.panic.185)
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
  call void @__polaron_panic(ptr @.panic.186)
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
  call void @__polaron_panic(ptr @.panic.187)
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
  call void @__polaron_panic(ptr @.panic.188)
  unreachable

nullrecv.ok20:                                    ; preds = %if.then16
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur18, i32 0, i32 4
  %right21 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right21, ptr %cur, align 8
  br label %if.end17

nullrecv24:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.189)
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
  call void @__polaron_panic(ptr @.panic.190)
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
  call void @__polaron_panic(ptr @.panic.191)
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
  call void @__polaron_panic(ptr @.panic.192)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then
  %left = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur11, i32 0, i32 3
  %left14 = load ptr, ptr %left, align 8, !tbaa !0
  store ptr %left14, ptr %cur, align 8
  br label %if.end

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.193)
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
  call void @__polaron_panic(ptr @.panic.194)
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
  call void @__polaron_panic(ptr @.panic.195)
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
  call void @__polaron_panic(ptr @.panic.196)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then
  %right = getelementptr inbounds %"class.TreeNode$String$int", ptr %cur11, i32 0, i32 4
  %right14 = load ptr, ptr %right, align 8, !tbaa !0
  store ptr %right14, ptr %cur, align 8
  br label %if.end

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.197)
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
  call void @__polaron_panic(ptr @.panic.198)
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5510)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5512)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @memset(ptr, i32, i64)

declare void @__polaron_str_free(ptr)

declare i32 @strcmp(ptr, ptr)

declare ptr @__polaron_str_copy(ptr)

declare ptr @memcpy(ptr, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
