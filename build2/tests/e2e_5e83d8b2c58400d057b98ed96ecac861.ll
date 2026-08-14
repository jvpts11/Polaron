; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.WeightedGraph = type { ptr, ptr, i32 }
%class.LruCache = type { ptr, i32, i32, i32, i32, ptr, ptr, ptr, ptr, ptr }
%"class.HashMap$int$int" = type { ptr, ptr, ptr, ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"HashMap$int$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$int$int.size", ptr @"HashMap$int$int.isEmpty", ptr @"HashMap$int$int.slotFor", ptr @"HashMap$int$int.grow", ptr @"HashMap$int$int.put", ptr @"HashMap$int$int.get", ptr @"HashMap$int$int.containsKey", ptr @"HashMap$int$int.getOrDefault", ptr @"HashMap$int$int.merge", ptr @"HashMap$int$int.remove", ptr @"HashMap$int$int.keyArray", ptr @"HashMap$int$int.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$int$int.~HashMap$int$int"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@WeightedGraph.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @WeightedGraph.addEdge, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @WeightedGraph.dijkstra, ptr @WeightedGraph.mstWeight, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@LruCache.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @LruCache.put, ptr @LruCache.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @LruCache.contains, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @LruCache.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @LruCache.unlink, ptr @LruCache.pushHead, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [28 x i8] c"dist=%d,%d,%d,%d,%d mst=%d\0A\00", align 1
@.fail = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol:17:41  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol:17:41  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol:17:41  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol:17:41  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [128 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/graph_lru.pol:17:41  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.13 = private unnamed_addr constant [36 x i8] c"g1=%d miss2=%d g3=%d g1b=%d cnt=%d\0A\00", align 1
@.contract.56 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$int.HashMap$int$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.57 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.58 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.59 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$int.HashMap$int$int\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.60 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.61 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.62 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$int.HashMap$int$int\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.63 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$int.HashMap$int$int\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.64 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$int.HashMap$int$int\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.65 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$int$int.slotFor\0A\00", align 1
@.faila.66 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.67 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.68 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$int$int.slotFor\0A\00", align 1
@.faila.69 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.70 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.71 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$int$int.grow\0A\00", align 1
@.faila.72 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.73 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.74 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$int$int.grow\0A\00", align 1
@.faila.75 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.76 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.77 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$int$int.grow\0A\00", align 1
@.faila.78 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.79 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.80 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$int$int.grow\0A\00", align 1
@.faila.81 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.82 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.83 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$int$int.grow\0A\00", align 1
@.faila.84 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.85 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.86 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$int$int.grow\0A\00", align 1
@.faila.87 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.88 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.89 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$int$int.grow\0A\00", align 1
@.faila.90 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.91 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.92 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$int$int.grow\0A\00", align 1
@.faila.93 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.94 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.95 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$int.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.96 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.97 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.98 = private unnamed_addr constant [117 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$int.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.99 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.100 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.101 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$int.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.102 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$int.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.103 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$int.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.104 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$int$int.put\0A\00", align 1
@.faila.105 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.106 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.107 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$int$int.put\0A\00", align 1
@.faila.108 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.109 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.110 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$int$int.put\0A\00", align 1
@.faila.111 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.112 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.113 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$int$int.put\0A\00", align 1
@.faila.114 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.115 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.116 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$int.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.117 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.118 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.119 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$int.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.120 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.121 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.122 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$int.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.123 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$int.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.124 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$int.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.125 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$int$int.get\0A\00", align 1
@.faila.126 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.127 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.128 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$int$int.containsKey\0A\00", align 1
@.faila.129 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.130 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.131 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$int$int.getOrDefault\0A\00", align 1
@.faila.132 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.133 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.134 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$int$int.getOrDefault\0A\00", align 1
@.faila.135 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.136 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.137 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$int$int.merge\0A\00", align 1
@.faila.138 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.139 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.140 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$int$int.merge\0A\00", align 1
@.faila.141 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.142 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.143 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$int$int.merge\0A\00", align 1
@.faila.144 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.145 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.146 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$int$int.merge\0A\00", align 1
@.faila.147 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.148 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.149 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$int$int.merge\0A\00", align 1
@.faila.150 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.151 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.152 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$int$int.merge\0A\00", align 1
@.faila.153 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.154 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.155 = private unnamed_addr constant [112 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$int.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.156 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.157 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.158 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$int.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.159 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.160 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.161 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$int$int.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.162 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$int$int.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.163 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$int.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.164 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$int$int.remove\0A\00", align 1
@.faila.165 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.166 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.167 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.168 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.169 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.170 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.171 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.172 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.173 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.174 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$int$int.remove\0A\00", align 1
@.faila.175 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.176 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.177 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$int$int.remove\0A\00", align 1
@.faila.178 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.179 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.180 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$int$int.remove\0A\00", align 1
@.faila.181 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.182 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.183 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$int$int.remove\0A\00", align 1
@.faila.184 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.185 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.186 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$int$int.remove\0A\00", align 1
@.faila.187 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.188 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.189 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$int$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.190 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.191 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.192 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$int$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.193 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.194 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.195 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$int$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.196 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$int$int.keyArray\0A\00", align 1
@.faila.197 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.198 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.199 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$int$int.keyArray\0A\00", align 1
@.faila.200 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.201 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.202 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$int$int.keyArray\0A\00", align 1
@.faila.203 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.204 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.205 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$int$int.valueArray\0A\00", align 1
@.faila.206 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.207 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.208 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$int$int.valueArray\0A\00", align 1
@.faila.209 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.210 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.211 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$int$int.valueArray\0A\00", align 1
@.faila.212 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.213 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1683 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2176:85  in WeightedGraph.WeightedGraph\0A\00", align 1
@.faila.1684 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1685 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1686 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2179:42  in WeightedGraph.addEdge\0A\00", align 1
@.faila.1687 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1688 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1689 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2180:42  in WeightedGraph.addEdge\0A\00", align 1
@.faila.1690 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1691 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1692 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2187:68  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1693 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1694 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1695 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2188:27  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1696 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1697 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1698 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2193:25  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1699 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1700 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1701 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2193:25  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1702 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1703 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1704 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2193:67  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1705 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1706 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1707 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2197:36  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1708 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1709 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1710 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2199:29  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1711 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1712 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1713 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2200:29  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1714 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1715 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1716 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2200:29  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1717 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1718 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1719 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2200:29  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1720 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1721 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1722 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2200:91  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1723 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1724 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1725 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2200:91  in WeightedGraph.dijkstra\0A\00", align 1
@.faila.1726 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1727 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1728 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2210:67  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1729 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1730 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1731 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2211:24  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1732 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1733 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1734 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2217:25  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1735 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1736 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1737 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2217:25  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1738 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1739 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1740 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2217:64  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1741 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1742 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1743 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2221:34  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1744 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1745 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1746 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2222:31  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1747 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1748 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1749 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2224:29  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1750 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1751 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1752 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2225:29  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1753 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1754 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1755 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2225:29  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1756 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1757 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1758 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2225:77  in WeightedGraph.mstWeight\0A\00", align 1
@.faila.1759 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1760 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1761 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2257:17  in LruCache.unlink\0A\00", align 1
@.faila.1762 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1763 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1764 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2258:17  in LruCache.unlink\0A\00", align 1
@.faila.1765 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1766 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1767 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2259:45  in LruCache.unlink\0A\00", align 1
@.faila.1768 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1769 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1770 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2260:47  in LruCache.unlink\0A\00", align 1
@.faila.1771 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1772 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1773 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2264:30  in LruCache.pushHead\0A\00", align 1
@.faila.1774 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1775 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1776 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2265:30  in LruCache.pushHead\0A\00", align 1
@.faila.1777 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1778 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1779 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2266:61  in LruCache.pushHead\0A\00", align 1
@.faila.1780 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1781 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1782 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2276:17  in LruCache.get\0A\00", align 1
@.faila.1783 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1784 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1785 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2282:34  in LruCache.put\0A\00", align 1
@.faila.1786 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1787 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1788 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2293:42  in LruCache.put\0A\00", align 1
@.faila.1789 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1790 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1791 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2296:30  in LruCache.put\0A\00", align 1
@.faila.1792 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1793 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1794 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2297:30  in LruCache.put\0A\00", align 1
@.faila.1795 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1796 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5321 = private constant [1 x i8] zeroinitializer
@.strobj.5322 = private global %String { i64 0, ptr @.strdata.5321, i64 0 }
@.strdata.5323 = private constant [1 x i8] zeroinitializer
@.strobj.5324 = private global %String { i64 0, ptr @.strdata.5323, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %g146 = alloca i32, align 4
  %c = alloca ptr, align 8
  %d = alloca ptr, align 8
  %g = alloca ptr, align 8
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
  %WeightedGraph.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.WeightedGraph, ptr null, i64 1) to i64))
  call void @WeightedGraph.WeightedGraph(ptr %WeightedGraph.obj, i32 5)
  store ptr %WeightedGraph.obj, ptr %g, align 8
  %g1 = load ptr, ptr %g, align 8
  call void @WeightedGraph.addEdge(ptr %g1, i32 0, i32 1, i32 4)
  %g2 = load ptr, ptr %g, align 8
  call void @WeightedGraph.addEdge(ptr %g2, i32 0, i32 2, i32 1)
  %g3 = load ptr, ptr %g, align 8
  call void @WeightedGraph.addEdge(ptr %g3, i32 2, i32 1, i32 2)
  %g4 = load ptr, ptr %g, align 8
  call void @WeightedGraph.addEdge(ptr %g4, i32 1, i32 3, i32 1)
  %g5 = load ptr, ptr %g, align 8
  call void @WeightedGraph.addEdge(ptr %g5, i32 2, i32 3, i32 5)
  %g6 = load ptr, ptr %g, align 8
  call void @WeightedGraph.addEdge(ptr %g6, i32 3, i32 4, i32 3)
  %g7 = load ptr, ptr %g, align 8
  %16 = call ptr @WeightedGraph.dijkstra(ptr %g7, i32 0)
  store ptr %16, ptr %d, align 8
  %d8 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %d8, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data9 = getelementptr i8, ptr %d8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  %d10 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len11 = load i64, ptr %d10, align 8
  %arr.oob12 = icmp uge i64 1, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %d10, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 1
  %elem17 = load i32, ptr %arr.elem16, align 4
  %d18 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len19 = load i64, ptr %d18, align 8
  %arr.oob20 = icmp uge i64 2, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok14
  %arr.data23 = getelementptr i8, ptr %d18, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 2
  %elem25 = load i32, ptr %arr.elem24, align 4
  %d26 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len27 = load i64, ptr %d26, align 8
  %arr.oob28 = icmp uge i64 3, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

idx.bad29:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %idx.ok22
  %arr.data31 = getelementptr i8, ptr %d26, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 3
  %elem33 = load i32, ptr %arr.elem32, align 4
  %d34 = load ptr, ptr %d, align 8, !nonnull !0, !dereferenceable !1
  %arr.len35 = load i64, ptr %d34, align 8
  %arr.oob36 = icmp uge i64 4, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !2

idx.bad37:                                        ; preds = %idx.ok30
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 4, ptr @.failb.12, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %idx.ok30
  %arr.data39 = getelementptr i8, ptr %d34, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 4
  %elem41 = load i32, ptr %arr.elem40, align 4
  %g42 = load ptr, ptr %g, align 8
  %17 = call i32 @WeightedGraph.mstWeight(ptr %g42)
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %elem, i32 %elem17, i32 %elem25, i32 %elem33, i32 %elem41, i32 %17)
  %LruCache.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.LruCache, ptr null, i64 1) to i64))
  call void @LruCache.LruCache(ptr %LruCache.obj, i32 2)
  store ptr %LruCache.obj, ptr %c, align 8
  %c43 = load ptr, ptr %c, align 8
  call void @LruCache.put(ptr %c43, i32 1, i32 10)
  %c44 = load ptr, ptr %c, align 8
  call void @LruCache.put(ptr %c44, i32 2, i32 20)
  %c45 = load ptr, ptr %c, align 8
  %19 = call i32 @LruCache.get(ptr %c45, i32 1)
  store i32 %19, ptr %g146, align 4
  %c47 = load ptr, ptr %c, align 8
  call void @LruCache.put(ptr %c47, i32 3, i32 30)
  %g148 = load i32, ptr %g146, align 4
  %c49 = load ptr, ptr %c, align 8
  %20 = call i32 @LruCache.get(ptr %c49, i32 2)
  %c50 = load ptr, ptr %c, align 8
  %21 = call i32 @LruCache.get(ptr %c50, i32 3)
  %c51 = load ptr, ptr %c, align 8
  %22 = call i32 @LruCache.get(ptr %c51, i32 1)
  %c52 = load ptr, ptr %c, align 8
  %23 = call i32 @LruCache.count(ptr %c52)
  %24 = call i32 (ptr, ...) @printf(ptr @.str.13, i32 %g148, i32 %20, i32 %21, i32 %22, i32 %23)
  ret i32 0
}

define internal void @"HashMap$int$int.HashMap$int$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 0
  store ptr @"HashMap$int$int.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !3
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !3
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !3
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !7
  %keys1 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %keys1, align 8, !tbaa !3
  %values2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 32)
  store ptr %arr3, ptr %values2, align 8, !tbaa !3
  %used5 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !3
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !7
  %count8 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !7
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.56, ptr @.cl.57, i64 %contract.l, ptr @.cr.58, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !7
  %cap14 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !7
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !7
  %cap21 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !7
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.59, ptr @.cl.60, i64 %contract.l23, ptr @.cr.61, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !3
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.62, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !3
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.63, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !3
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !7
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.64, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$int$int.~HashMap$int$int"(ptr %0) {
entry:
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys1 = load ptr, ptr %keys, align 8, !tbaa !3
  call void @__polaron_free(ptr %keys1)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !3
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used3 = load ptr, ptr %used, align 8, !tbaa !3
  call void @__polaron_free(ptr %used3)
  ret void
}

define internal i32 @"HashMap$int$int.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !7
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
  %used24 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i26 = load i32, ptr %i, align 4
  %19 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys28 = load ptr, ptr %keys27, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i29 = load i32, ptr %i, align 4
  %20 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %keys28, align 8
  %arr.oob31 = icmp uge i64 %20, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

while.end:                                        ; preds = %idx.ok
  %i41 = load i32, ptr %i, align 4
  ret i32 %i41

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.65, ptr @.faila.66, i64 %19, ptr @.failb.67, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.68, ptr @.faila.69, i64 %20, ptr @.failb.70, i64 %arr.len30, i32 70)
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

define internal void @"HashMap$int$int.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !7
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !3
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !3
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !3
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !7
  %keys30 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !7
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 4
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !3
  %values33 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !7
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 4
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !3
  %used38 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !7
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !3
  %cap43 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !7
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
  %oldU47 = load ptr, ptr %oldU, align 8, !nonnull !0, !dereferenceable !1
  %j48 = load i32, ptr %j, align 4
  %30 = sext i32 %j48 to i64
  %arr.len = load i64, ptr %oldU47, align 8
  %arr.oob = icmp uge i64 %30, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %31 = load i32, ptr %j, align 4
  %32 = add i32 %31, 1
  store i32 %32, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %oldK117 = load ptr, ptr %oldK, align 8
  call void @__polaron_free(ptr %oldK117)
  %oldV118 = load ptr, ptr %oldV, align 8
  call void @__polaron_free(ptr %oldV118)
  %oldU119 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU119)
  %count120 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count121 = load i32, ptr %count120, align 4, !tbaa !7
  %33 = icmp sge i32 %count121, 0
  %34 = zext i1 %33 to i32
  %contract.ok = icmp ne i32 %34, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.71, ptr @.faila.72, i64 %30, ptr @.failb.73, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data49 = getelementptr i8, ptr %oldU47, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data49, i64 %30
  %elem = load i8, ptr %arr.elem, align 1
  %35 = sext i8 %elem to i32
  %36 = icmp ne i32 %35, 0
  %37 = zext i1 %36 to i32
  br i1 %36, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %oldK50 = load ptr, ptr %oldK, align 8, !nonnull !0, !dereferenceable !1
  %j51 = load i32, ptr %j, align 4
  %38 = sext i32 %j51 to i64
  %arr.len52 = load i64, ptr %oldK50, align 8
  %arr.oob53 = icmp uge i64 %38, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !2

if.end:                                           ; preds = %idx.ok113, %idx.ok
  br label %for.update

idx.bad54:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.74, ptr @.faila.75, i64 %38, ptr @.failb.76, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %if.then
  %arr.data56 = getelementptr i8, ptr %oldK50, i64 8
  %arr.elem57 = getelementptr inbounds i32, ptr %arr.data56, i64 %38
  %elem58 = load i32, ptr %arr.elem57, align 4
  %39 = sext i32 %elem58 to i64
  %40 = trunc i64 %39 to i32
  %mask59 = load i32, ptr %mask, align 4
  %41 = and i32 %40, %mask59
  store i32 %41, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok55
  %used60 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used61 = load ptr, ptr %used60, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i62 = load i32, ptr %i, align 4
  %42 = sext i32 %i62 to i64
  %arr.len63 = load i64, ptr %used61, align 8
  %arr.oob64 = icmp uge i64 %42, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !2

while.body:                                       ; preds = %idx.ok66
  %i70 = load i32, ptr %i, align 4
  %43 = add i32 %i70, 1
  %mask71 = load i32, ptr %mask, align 4
  %44 = and i32 %43, %mask71
  store i32 %44, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %idx.ok66
  %used72 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used73 = load ptr, ptr %used72, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i74 = load i32, ptr %i, align 4
  %45 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %used73, align 8
  %arr.oob76 = icmp uge i64 %45, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad65:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.77, ptr @.faila.78, i64 %42, ptr @.failb.79, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %while.cond
  %arr.data67 = getelementptr i8, ptr %used61, i64 8
  %arr.elem68 = getelementptr inbounds i8, ptr %arr.data67, i64 %42
  %elem69 = load i8, ptr %arr.elem68, align 1
  %46 = sext i8 %elem69 to i32
  %47 = icmp ne i32 %46, 0
  %48 = zext i1 %47 to i32
  br i1 %47, label %while.body, label %while.end

idx.bad77:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.80, ptr @.faila.81, i64 %45, ptr @.failb.82, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %while.end
  %arr.data79 = getelementptr i8, ptr %used73, i64 8
  %arr.elem80 = getelementptr inbounds i8, ptr %arr.data79, i64 %45
  store i8 1, ptr %arr.elem80, align 1
  %keys81 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys82 = load ptr, ptr %keys81, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i83 = load i32, ptr %i, align 4
  %49 = sext i32 %i83 to i64
  %arr.len84 = load i64, ptr %keys82, align 8
  %arr.oob85 = icmp uge i64 %49, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !2

idx.bad86:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.83, ptr @.faila.84, i64 %49, ptr @.failb.85, i64 %arr.len84, i32 70)
  unreachable

idx.ok87:                                         ; preds = %idx.ok78
  %arr.data88 = getelementptr i8, ptr %keys82, i64 8
  %arr.elem89 = getelementptr inbounds i32, ptr %arr.data88, i64 %49
  %oldK90 = load ptr, ptr %oldK, align 8, !nonnull !0, !dereferenceable !1
  %j91 = load i32, ptr %j, align 4
  %50 = sext i32 %j91 to i64
  %arr.len92 = load i64, ptr %oldK90, align 8
  %arr.oob93 = icmp uge i64 %50, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !2

idx.bad94:                                        ; preds = %idx.ok87
  call void @__polaron_fail(ptr @.fail.86, ptr @.faila.87, i64 %50, ptr @.failb.88, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok87
  %arr.data96 = getelementptr i8, ptr %oldK90, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 %50
  %elem98 = load i32, ptr %arr.elem97, align 4
  store i32 %elem98, ptr %arr.elem89, align 4
  %values99 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values100 = load ptr, ptr %values99, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i101 = load i32, ptr %i, align 4
  %51 = sext i32 %i101 to i64
  %arr.len102 = load i64, ptr %values100, align 8
  %arr.oob103 = icmp uge i64 %51, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !2

idx.bad104:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.89, ptr @.faila.90, i64 %51, ptr @.failb.91, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %idx.ok95
  %arr.data106 = getelementptr i8, ptr %values100, i64 8
  %arr.elem107 = getelementptr inbounds i32, ptr %arr.data106, i64 %51
  %oldV108 = load ptr, ptr %oldV, align 8, !nonnull !0, !dereferenceable !1
  %j109 = load i32, ptr %j, align 4
  %52 = sext i32 %j109 to i64
  %arr.len110 = load i64, ptr %oldV108, align 8
  %arr.oob111 = icmp uge i64 %52, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !2

idx.bad112:                                       ; preds = %idx.ok105
  call void @__polaron_fail(ptr @.fail.92, ptr @.faila.93, i64 %52, ptr @.failb.94, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %idx.ok105
  %arr.data114 = getelementptr i8, ptr %oldV108, i64 8
  %arr.elem115 = getelementptr inbounds i32, ptr %arr.data114, i64 %52
  %elem116 = load i32, ptr %arr.elem115, align 4
  store i32 %elem116, ptr %arr.elem107, align 4
  br label %if.end

contract.fail:                                    ; preds = %for.end
  %count122 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count123 = load i32, ptr %count122, align 4, !tbaa !7
  %contract.l = sext i32 %count123 to i64
  call void @__polaron_fail(ptr @.contract.95, ptr @.cl.96, i64 %contract.l, ptr @.cr.97, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %for.end
  %count124 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count125 = load i32, ptr %count124, align 4, !tbaa !7
  %cap126 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap127 = load i32, ptr %cap126, align 4, !tbaa !7
  %53 = icmp slt i32 %count125, %cap127
  %54 = zext i1 %53 to i32
  %contract.ok128 = icmp ne i32 %54, 0
  br i1 %contract.ok128, label %contract.cont130, label %contract.fail129

contract.fail129:                                 ; preds = %contract.cont
  %count131 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count132 = load i32, ptr %count131, align 4, !tbaa !7
  %cap133 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap134 = load i32, ptr %cap133, align 4, !tbaa !7
  %contract.l135 = sext i32 %count132 to i64
  %contract.r = sext i32 %cap134 to i64
  call void @__polaron_fail(ptr @.contract.98, ptr @.cl.99, i64 %contract.l135, ptr @.cr.100, i64 %contract.r, i32 1)
  unreachable

contract.cont130:                                 ; preds = %contract.cont
  %keys136 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys137 = load ptr, ptr %keys136, align 8, !tbaa !3
  %len138 = load i64, ptr %keys137, align 8
  %55 = trunc i64 %len138 to i32
  %cap139 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap140 = load i32, ptr %cap139, align 4, !tbaa !7
  %56 = icmp eq i32 %55, %cap140
  %57 = zext i1 %56 to i32
  %contract.ok141 = icmp ne i32 %57, 0
  br i1 %contract.ok141, label %contract.cont143, label %contract.fail142

contract.fail142:                                 ; preds = %contract.cont130
  call void @__polaron_fail(ptr @.contract.101, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont143:                                 ; preds = %contract.cont130
  %values144 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values145 = load ptr, ptr %values144, align 8, !tbaa !3
  %len146 = load i64, ptr %values145, align 8
  %58 = trunc i64 %len146 to i32
  %cap147 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap148 = load i32, ptr %cap147, align 4, !tbaa !7
  %59 = icmp eq i32 %58, %cap148
  %60 = zext i1 %59 to i32
  %contract.ok149 = icmp ne i32 %60, 0
  br i1 %contract.ok149, label %contract.cont151, label %contract.fail150

contract.fail150:                                 ; preds = %contract.cont143
  call void @__polaron_fail(ptr @.contract.102, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont151:                                 ; preds = %contract.cont143
  %used152 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used153 = load ptr, ptr %used152, align 8, !tbaa !3
  %len154 = load i64, ptr %used153, align 8
  %61 = trunc i64 %len154 to i32
  %cap155 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap156 = load i32, ptr %cap155, align 4, !tbaa !7
  %62 = icmp eq i32 %61, %cap156
  %63 = zext i1 %62 to i32
  %contract.ok157 = icmp ne i32 %63, 0
  br i1 %contract.ok157, label %contract.cont159, label %contract.fail158

contract.fail158:                                 ; preds = %contract.cont151
  call void @__polaron_fail(ptr @.contract.103, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont159:                                 ; preds = %contract.cont151
  ret void
}

define internal void @"HashMap$int$int.put"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %value = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  store i32 %2, ptr %value, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
  %16 = add i32 %count21, 1
  %17 = mul i32 %16, 4
  %cap22 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !7
  %18 = mul i32 %cap23, 3
  %19 = icmp sge i32 %17, %18
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$int$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load i32, ptr %key, align 4
  %21 = call i32 @"HashMap$int$int.slotFor"(ptr %0, i32 %key24)
  store i32 %21, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %22 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %22, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.104, ptr @.faila.105, i64 %22, ptr @.failb.106, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i32 = load i32, ptr %i, align 4
  %26 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %26, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i44 = load i32, ptr %i, align 4
  %27 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %27, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.107, ptr @.faila.108, i64 %26, ptr @.failb.109, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %26
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !7
  %28 = add i32 %count41, 1
  store i32 %28, ptr %count39, align 4, !tbaa !7
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.110, ptr @.faila.111, i64 %27, ptr @.failb.112, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %27
  %key51 = load i32, ptr %key, align 4
  store i32 %key51, ptr %arr.elem50, align 4
  %values52 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i54 = load i32, ptr %i, align 4
  %29 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %29, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.113, ptr @.faila.114, i64 %29, ptr @.failb.115, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %29
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  %count62 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count63 = load i32, ptr %count62, align 4, !tbaa !7
  %30 = icmp sge i32 %count63, 0
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count64 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count65 = load i32, ptr %count64, align 4, !tbaa !7
  %contract.l = sext i32 %count65 to i64
  call void @__polaron_fail(ptr @.contract.116, ptr @.cl.117, i64 %contract.l, ptr @.cr.118, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count66 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count67 = load i32, ptr %count66, align 4, !tbaa !7
  %cap68 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap69 = load i32, ptr %cap68, align 4, !tbaa !7
  %32 = icmp slt i32 %count67, %cap69
  %33 = zext i1 %32 to i32
  %contract.ok70 = icmp ne i32 %33, 0
  br i1 %contract.ok70, label %contract.cont72, label %contract.fail71

contract.fail71:                                  ; preds = %contract.cont
  %count73 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count74 = load i32, ptr %count73, align 4, !tbaa !7
  %cap75 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap76 = load i32, ptr %cap75, align 4, !tbaa !7
  %contract.l77 = sext i32 %count74 to i64
  %contract.r = sext i32 %cap76 to i64
  call void @__polaron_fail(ptr @.contract.119, ptr @.cl.120, i64 %contract.l77, ptr @.cr.121, i64 %contract.r, i32 1)
  unreachable

contract.cont72:                                  ; preds = %contract.cont
  %keys78 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys79 = load ptr, ptr %keys78, align 8, !tbaa !3
  %len80 = load i64, ptr %keys79, align 8
  %34 = trunc i64 %len80 to i32
  %cap81 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap82 = load i32, ptr %cap81, align 4, !tbaa !7
  %35 = icmp eq i32 %34, %cap82
  %36 = zext i1 %35 to i32
  %contract.ok83 = icmp ne i32 %36, 0
  br i1 %contract.ok83, label %contract.cont85, label %contract.fail84

contract.fail84:                                  ; preds = %contract.cont72
  call void @__polaron_fail(ptr @.contract.122, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont85:                                  ; preds = %contract.cont72
  %values86 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values87 = load ptr, ptr %values86, align 8, !tbaa !3
  %len88 = load i64, ptr %values87, align 8
  %37 = trunc i64 %len88 to i32
  %cap89 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !7
  %38 = icmp eq i32 %37, %cap90
  %39 = zext i1 %38 to i32
  %contract.ok91 = icmp ne i32 %39, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont85
  call void @__polaron_fail(ptr @.contract.123, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont85
  %used94 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !3
  %len96 = load i64, ptr %used95, align 8
  %40 = trunc i64 %len96 to i32
  %cap97 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap98 = load i32, ptr %cap97, align 4, !tbaa !7
  %41 = icmp eq i32 %40, %cap98
  %42 = zext i1 %41 to i32
  %contract.ok99 = icmp ne i32 %42, 0
  br i1 %contract.ok99, label %contract.cont101, label %contract.fail100

contract.fail100:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.124, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont101:                                 ; preds = %contract.cont93
  ret void
}

define internal i32 @"HashMap$int$int.get"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %key22 = load i32, ptr %key, align 4
  %15 = call i32 @"HashMap$int$int.slotFor"(ptr %0, i32 %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.125, ptr @.faila.126, i64 %16, ptr @.failb.127, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %16
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"HashMap$int$int.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %key22 = load i32, ptr %key, align 4
  %15 = call i32 @"HashMap$int$int.slotFor"(ptr %0, i32 %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.128, ptr @.faila.129, i64 %16, ptr @.failb.130, i64 %arr.len, i32 70)
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

define internal i32 @"HashMap$int$int.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  store i32 %2, ptr %defaultValue, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load i32, ptr %key, align 4
  %16 = call i32 @"HashMap$int$int.slotFor"(ptr %0, i32 %key20)
  store i32 %16, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.131, ptr @.faila.132, i64 %17, ptr @.failb.133, i64 %arr.len, i32 70)
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
  %values24 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i26 = load i32, ptr %i, align 4
  %21 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %values25, align 8
  %arr.oob28 = icmp uge i64 %21, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

if.end:                                           ; preds = %idx.ok
  %defaultValue34 = load i32, ptr %defaultValue, align 4
  ret i32 %defaultValue34

idx.bad29:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.134, ptr @.faila.135, i64 %21, ptr @.failb.136, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 %21
  %elem33 = load i32, ptr %arr.elem32, align 4
  ret i32 %elem33
}

define internal void @"HashMap$int$int.merge"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, i32 %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %value = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  store i32 %2, ptr %value, align 4
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !7
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$int$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load i32, ptr %key, align 4
  %22 = call i32 @"HashMap$int$int.slotFor"(ptr %0, i32 %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.137, ptr @.faila.138, i64 %23, ptr @.failb.139, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

if.else:                                          ; preds = %idx.ok
  %values62 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values63 = load ptr, ptr %values62, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i64 = load i32, ptr %i, align 4
  %28 = sext i32 %i64 to i64
  %arr.len65 = load i64, ptr %values63, align 8
  %arr.oob66 = icmp uge i64 %28, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !2

if.end29:                                         ; preds = %idx.ok78, %idx.ok58
  %count83 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count84 = load i32, ptr %count83, align 4, !tbaa !7
  %29 = icmp sge i32 %count84, 0
  %30 = zext i1 %29 to i32
  %contract.ok = icmp ne i32 %30, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.140, ptr @.faila.141, i64 %27, ptr @.failb.142, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !7
  %31 = add i32 %count41, 1
  store i32 %31, ptr %count39, align 4, !tbaa !7
  %keys42 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i44 = load i32, ptr %i, align 4
  %32 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %32, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.143, ptr @.faila.144, i64 %32, ptr @.failb.145, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %32
  %key51 = load i32, ptr %key, align 4
  store i32 %key51, ptr %arr.elem50, align 4
  %values52 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i54 = load i32, ptr %i, align 4
  %33 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %33, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.146, ptr @.faila.147, i64 %33, ptr @.failb.148, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %33
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  br label %if.end29

idx.bad67:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.149, ptr @.faila.150, i64 %28, ptr @.failb.151, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %if.else
  %arr.data69 = getelementptr i8, ptr %values63, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 %28
  %combine71 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine71, align 8
  %34 = getelementptr ptr, ptr %combine71, i32 1
  %env = load ptr, ptr %34, align 8
  %values72 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values73 = load ptr, ptr %values72, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i74 = load i32, ptr %i, align 4
  %35 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %values73, align 8
  %arr.oob76 = icmp uge i64 %35, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !2

idx.bad77:                                        ; preds = %idx.ok68
  call void @__polaron_fail(ptr @.fail.152, ptr @.faila.153, i64 %35, ptr @.failb.154, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %idx.ok68
  %arr.data79 = getelementptr i8, ptr %values73, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %35
  %elem81 = load i32, ptr %arr.elem80, align 4
  %value82 = load i32, ptr %value, align 4
  %36 = call i32 %code(ptr %env, i32 %elem81, i32 %value82)
  store i32 %36, ptr %arr.elem70, align 4
  br label %if.end29

contract.fail:                                    ; preds = %if.end29
  %count85 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count86 = load i32, ptr %count85, align 4, !tbaa !7
  %contract.l = sext i32 %count86 to i64
  call void @__polaron_fail(ptr @.contract.155, ptr @.cl.156, i64 %contract.l, ptr @.cr.157, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count87 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count88 = load i32, ptr %count87, align 4, !tbaa !7
  %cap89 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !7
  %37 = icmp slt i32 %count88, %cap90
  %38 = zext i1 %37 to i32
  %contract.ok91 = icmp ne i32 %38, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont
  %count94 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count95 = load i32, ptr %count94, align 4, !tbaa !7
  %cap96 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap97 = load i32, ptr %cap96, align 4, !tbaa !7
  %contract.l98 = sext i32 %count95 to i64
  %contract.r = sext i32 %cap97 to i64
  call void @__polaron_fail(ptr @.contract.158, ptr @.cl.159, i64 %contract.l98, ptr @.cr.160, i64 %contract.r, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont
  %keys99 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys100 = load ptr, ptr %keys99, align 8, !tbaa !3
  %len101 = load i64, ptr %keys100, align 8
  %39 = trunc i64 %len101 to i32
  %cap102 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap103 = load i32, ptr %cap102, align 4, !tbaa !7
  %40 = icmp eq i32 %39, %cap103
  %41 = zext i1 %40 to i32
  %contract.ok104 = icmp ne i32 %41, 0
  br i1 %contract.ok104, label %contract.cont106, label %contract.fail105

contract.fail105:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.161, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont106:                                 ; preds = %contract.cont93
  %values107 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values108 = load ptr, ptr %values107, align 8, !tbaa !3
  %len109 = load i64, ptr %values108, align 8
  %42 = trunc i64 %len109 to i32
  %cap110 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap111 = load i32, ptr %cap110, align 4, !tbaa !7
  %43 = icmp eq i32 %42, %cap111
  %44 = zext i1 %43 to i32
  %contract.ok112 = icmp ne i32 %44, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

contract.fail113:                                 ; preds = %contract.cont106
  call void @__polaron_fail(ptr @.contract.162, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %contract.cont106
  %used115 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used116 = load ptr, ptr %used115, align 8, !tbaa !3
  %len117 = load i64, ptr %used116, align 8
  %45 = trunc i64 %len117 to i32
  %cap118 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap119 = load i32, ptr %cap118, align 4, !tbaa !7
  %46 = icmp eq i32 %45, %cap119
  %47 = zext i1 %46 to i32
  %contract.ok120 = icmp ne i32 %47, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont114
  call void @__polaron_fail(ptr @.contract.163, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont122:                                 ; preds = %contract.cont114
  ret void
}

define internal i32 @"HashMap$int$int.remove"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %rv = alloca i32, align 4
  %rk = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load i32, ptr %key, align 4
  %15 = call i32 @"HashMap$int$int.slotFor"(ptr %0, i32 %key20)
  store i32 %15, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i23 = load i32, ptr %i, align 4
  %16 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.164, ptr @.faila.165, i64 %16, ptr @.failb.166, i64 %arr.len, i32 70)
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
  %count24 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !7
  %20 = icmp sge i32 %count25, 0
  %21 = zext i1 %20 to i32
  %contract.ok = icmp ne i32 %21, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !7
  %22 = sub i32 %cap49, 1
  store i32 %22, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i52 = load i32, ptr %i, align 4
  %23 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %23, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !7
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.167, ptr @.cl.168, i64 %contract.l, ptr @.cr.169, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !7
  %cap30 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !7
  %24 = icmp slt i32 %count29, %cap31
  %25 = zext i1 %24 to i32
  %contract.ok32 = icmp ne i32 %25, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !7
  %cap37 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !7
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.170, ptr @.cl.171, i64 %contract.l39, ptr @.cr.172, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !3
  %len42 = load i64, ptr %used41, align 8
  %26 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !7
  %27 = icmp eq i32 %26, %cap44
  %28 = zext i1 %27 to i32
  %contract.ok45 = icmp ne i32 %28, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.173, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.174, ptr @.faila.175, i64 %23, ptr @.failb.176, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %23
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count61 = load i32, ptr %count60, align 4, !tbaa !7
  %29 = sub i32 %count61, 1
  store i32 %29, ptr %count59, align 4, !tbaa !7
  %i62 = load i32, ptr %i, align 4
  %30 = add i32 %i62, 1
  %mask63 = load i32, ptr %mask, align 4
  %31 = and i32 %30, %mask63
  store i32 %31, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok100, %idx.ok56
  %used64 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j66 = load i32, ptr %j, align 4
  %32 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %32, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !2

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j76 = load i32, ptr %j, align 4
  %33 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %33, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !2

while.end:                                        ; preds = %idx.ok70
  %count110 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count111 = load i32, ptr %count110, align 4, !tbaa !7
  %34 = icmp sge i32 %count111, 0
  %35 = zext i1 %34 to i32
  %contract.ok112 = icmp ne i32 %35, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.177, ptr @.faila.178, i64 %32, ptr @.failb.179, i64 %arr.len67, i32 70)
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
  call void @__polaron_fail(ptr @.fail.180, ptr @.faila.181, i64 %33, ptr @.failb.182, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds i32, ptr %arr.data81, i64 %33
  %elem83 = load i32, ptr %arr.elem82, align 4
  store i32 %elem83, ptr %rk, align 4
  %values84 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j86 = load i32, ptr %j, align 4
  %39 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %39, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !2

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.183, ptr @.faila.184, i64 %39, ptr @.failb.185, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 %39
  %elem93 = load i32, ptr %arr.elem92, align 4
  store i32 %elem93, ptr %rv, align 4
  %used94 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j96 = load i32, ptr %j, align 4
  %40 = sext i32 %j96 to i64
  %arr.len97 = load i64, ptr %used95, align 8
  %arr.oob98 = icmp uge i64 %40, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !2

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.186, ptr @.faila.187, i64 %40, ptr @.failb.188, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %used95, i64 8
  %arr.elem102 = getelementptr inbounds i8, ptr %arr.data101, i64 %40
  store i8 0, ptr %arr.elem102, align 1
  %count103 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count104 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count105 = load i32, ptr %count104, align 4, !tbaa !7
  %41 = sub i32 %count105, 1
  store i32 %41, ptr %count103, align 4, !tbaa !7
  %rk106 = load i32, ptr %rk, align 4
  %rv107 = load i32, ptr %rv, align 4
  call void @"HashMap$int$int.put"(ptr %0, i32 %rk106, i32 %rv107)
  %j108 = load i32, ptr %j, align 4
  %42 = add i32 %j108, 1
  %mask109 = load i32, ptr %mask, align 4
  %43 = and i32 %42, %mask109
  store i32 %43, ptr %j, align 4
  br label %while.cond

contract.fail113:                                 ; preds = %while.end
  %count115 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count116 = load i32, ptr %count115, align 4, !tbaa !7
  %contract.l117 = sext i32 %count116 to i64
  call void @__polaron_fail(ptr @.contract.189, ptr @.cl.190, i64 %contract.l117, ptr @.cr.191, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %while.end
  %count118 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !7
  %cap120 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !7
  %44 = icmp slt i32 %count119, %cap121
  %45 = zext i1 %44 to i32
  %contract.ok122 = icmp ne i32 %45, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont114
  %count125 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !7
  %cap127 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !7
  %contract.l129 = sext i32 %count126 to i64
  %contract.r130 = sext i32 %cap128 to i64
  call void @__polaron_fail(ptr @.contract.192, ptr @.cl.193, i64 %contract.l129, ptr @.cr.194, i64 %contract.r130, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont114
  %used131 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used132 = load ptr, ptr %used131, align 8, !tbaa !3
  %len133 = load i64, ptr %used132, align 8
  %46 = trunc i64 %len133 to i32
  %cap134 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !7
  %47 = icmp eq i32 %46, %cap135
  %48 = zext i1 %47 to i32
  %contract.ok136 = icmp ne i32 %48, 0
  br i1 %contract.ok136, label %contract.cont138, label %contract.fail137

contract.fail137:                                 ; preds = %contract.cont124
  call void @__polaron_fail(ptr @.contract.195, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont138:                                 ; preds = %contract.cont124
  ret i32 1
}

define internal ptr @"HashMap$int$int.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
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
  %cap23 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !7
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %20 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out48 = load ptr, ptr %out, align 8
  ret ptr %out48

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.196, ptr @.faila.197, i64 %20, ptr @.failb.198, i64 %arr.len, i32 70)
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
  %out29 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %j30 = load i32, ptr %j, align 4
  %26 = sext i32 %j30 to i64
  %arr.len31 = load i64, ptr %out29, align 8
  %arr.oob32 = icmp uge i64 %26, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

if.end:                                           ; preds = %idx.ok43, %idx.ok
  br label %for.update

idx.bad33:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.199, ptr @.faila.200, i64 %26, ptr @.failb.201, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.202, ptr @.faila.203, i64 %27, ptr @.failb.204, i64 %arr.len40, i32 70)
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

define internal ptr @"HashMap$int$int.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
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
  %cap23 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !7
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %20 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out48 = load ptr, ptr %out, align 8
  ret ptr %out48

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.205, ptr @.faila.206, i64 %20, ptr @.failb.207, i64 %arr.len, i32 70)
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
  %out29 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %j30 = load i32, ptr %j, align 4
  %26 = sext i32 %j30 to i64
  %arr.len31 = load i64, ptr %out29, align 8
  %arr.oob32 = icmp uge i64 %26, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

if.end:                                           ; preds = %idx.ok43, %idx.ok
  br label %for.update

idx.bad33:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.208, ptr @.faila.209, i64 %26, ptr @.failb.210, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.211, ptr @.faila.212, i64 %27, ptr @.failb.213, i64 %arr.len40, i32 70)
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

define internal i32 @"HashMap$int$int.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
  ret i32 %count21
}

define internal i32 @"HashMap$int$int.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %cap = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !3
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !7
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !3
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !7
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !3
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !7
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$int$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
  %14 = icmp eq i32 %count21, 0
  %15 = zext i1 %14 to i32
  ret i32 %15
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal void @WeightedGraph.WeightedGraph(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %vertices = alloca i32, align 4
  store i32 %1, ptr %vertices, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 0
  store ptr @WeightedGraph.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %adj = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  store ptr null, ptr %adj, align 8, !tbaa !3
  %n = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %vertices1 = load i32, ptr %vertices, align 4
  store i32 %vertices1, ptr %n, align 4, !tbaa !7
  %adj2 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  %vertices3 = load i32, ptr %vertices, align 4
  %vertices4 = load i32, ptr %vertices, align 4
  %2 = mul i32 %vertices3, %vertices4
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %adj2, align 8, !tbaa !3
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i5 = load i32, ptr %i, align 4
  %vertices6 = load i32, ptr %vertices, align 4
  %vertices7 = load i32, ptr %vertices, align 4
  %7 = mul i32 %vertices6, %vertices7
  %8 = icmp slt i32 %i5, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %adj8 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  %adj9 = load ptr, ptr %adj8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %10 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %adj9, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1683, ptr @.faila.1684, i64 %10, ptr @.failb.1685, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %adj9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %10
  store i32 -1, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @WeightedGraph.addEdge(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, i32 %3) {
entry:
  %w = alloca i32, align 4
  %v = alloca i32, align 4
  %u = alloca i32, align 4
  store i32 %1, ptr %u, align 4
  store i32 %2, ptr %v, align 4
  store i32 %3, ptr %w, align 4
  %adj = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  %adj1 = load ptr, ptr %adj, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %u2 = load i32, ptr %u, align 4
  %n = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n3 = load i32, ptr %n, align 4, !tbaa !7
  %4 = mul i32 %u2, %n3
  %v4 = load i32, ptr %v, align 4
  %5 = add i32 %4, %v4
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %adj1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1686, ptr @.faila.1687, i64 %6, ptr @.failb.1688, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %adj1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %w5 = load i32, ptr %w, align 4
  store i32 %w5, ptr %arr.elem, align 4
  %adj6 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  %adj7 = load ptr, ptr %adj6, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %v8 = load i32, ptr %v, align 4
  %n9 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n10 = load i32, ptr %n9, align 4, !tbaa !7
  %7 = mul i32 %v8, %n10
  %u11 = load i32, ptr %u, align 4
  %8 = add i32 %7, %u11
  %9 = sext i32 %8 to i64
  %arr.len12 = load i64, ptr %adj7, align 8
  %arr.oob13 = icmp uge i64 %9, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1689, ptr @.faila.1690, i64 %9, ptr @.failb.1691, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %adj7, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %9
  %w18 = load i32, ptr %w, align 4
  store i32 %w18, ptr %arr.elem17, align 4
  ret void
}

define internal ptr @WeightedGraph.dijkstra(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %w = alloca i32, align 4
  %v = alloca i32, align 4
  %i29 = alloca i32, align 4
  %best = alloca i32, align 4
  %u = alloca i32, align 4
  %iter = alloca i32, align 4
  %i = alloca i32, align 4
  %visited = alloca ptr, align 8
  %dist = alloca ptr, align 8
  %INF = alloca i32, align 4
  %src = alloca i32, align 4
  store i32 %1, ptr %src, align 4
  store i32 1000000000, ptr %INF, align 4
  %n = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  %2 = sext i32 %n1 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %dist, align 8
  %n2 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n3 = load i32, ptr %n2, align 4, !tbaa !7
  %6 = sext i32 %n3 to i64
  %7 = mul i64 %6, 1
  %8 = add i64 8, %7
  %arr4 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %9 = call ptr @memset(ptr %arr.data5, i32 0, i64 %7)
  store ptr %arr4, ptr %visited, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %n7 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n8 = load i32, ptr %n7, align 4, !tbaa !7
  %10 = icmp slt i32 %i6, %n8
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %dist9 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %dist9, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dist13 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %src14 = load i32, ptr %src, align 4
  %15 = sext i32 %src14 to i64
  %arr.len15 = load i64, ptr %dist13, align 8
  %arr.oob16 = icmp uge i64 %15, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1692, ptr @.faila.1693, i64 %12, ptr @.failb.1694, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %dist9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %12
  %INF12 = load i32, ptr %INF, align 4
  store i32 %INF12, ptr %arr.elem, align 4
  br label %for.update

idx.bad17:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1695, ptr @.faila.1696, i64 %15, ptr @.failb.1697, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %for.end
  %arr.data19 = getelementptr i8, ptr %dist13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %15
  store i32 0, ptr %arr.elem20, align 4
  store i32 0, ptr %iter, align 4
  br label %for.cond21

for.cond21:                                       ; preds = %for.update23, %idx.ok18
  %iter25 = load i32, ptr %iter, align 4
  %n26 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n27 = load i32, ptr %n26, align 4, !tbaa !7
  %16 = icmp slt i32 %iter25, %n27
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  store i32 -1, ptr %u, align 4
  %INF28 = load i32, ptr %INF, align 4
  store i32 %INF28, ptr %best, align 4
  store i32 0, ptr %i29, align 4
  br label %for.cond30

for.update23:                                     ; preds = %if.end67
  %18 = load i32, ptr %iter, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %iter, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  %dist156 = load ptr, ptr %dist, align 8
  ret ptr %dist156

for.cond30:                                       ; preds = %for.update32, %for.body22
  %i34 = load i32, ptr %i29, align 4
  %n35 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n36 = load i32, ptr %n35, align 4, !tbaa !7
  %20 = icmp slt i32 %i34, %n36
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body31, label %for.end33

for.body31:                                       ; preds = %for.cond30
  %visited37 = load ptr, ptr %visited, align 8, !nonnull !0, !dereferenceable !1
  %i38 = load i32, ptr %i29, align 4
  %22 = sext i32 %i38 to i64
  %arr.len39 = load i64, ptr %visited37, align 8
  %arr.oob40 = icmp uge i64 %22, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !2

for.update32:                                     ; preds = %if.end
  %23 = load i32, ptr %i29, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %i29, align 4
  br label %for.cond30

for.end33:                                        ; preds = %for.cond30
  %u65 = load i32, ptr %u, align 4
  %25 = icmp eq i32 %u65, -1
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then66, label %if.else

idx.bad41:                                        ; preds = %for.body31
  call void @__polaron_fail(ptr @.fail.1698, ptr @.faila.1699, i64 %22, ptr @.failb.1700, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %for.body31
  %arr.data43 = getelementptr i8, ptr %visited37, i64 8
  %arr.elem44 = getelementptr inbounds i8, ptr %arr.data43, i64 %22
  %elem = load i8, ptr %arr.elem44, align 1
  %27 = zext i8 %elem to i32
  %28 = icmp eq i32 %27, 0
  %29 = zext i1 %28 to i32
  %sc.a = icmp ne i32 %29, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %idx.ok42
  %dist45 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %i46 = load i32, ptr %i29, align 4
  %30 = sext i32 %i46 to i64
  %arr.len47 = load i64, ptr %dist45, align 8
  %arr.oob48 = icmp uge i64 %30, %arr.len47
  br i1 %arr.oob48, label %idx.bad49, label %idx.ok50, !prof !2

sc.end:                                           ; preds = %idx.ok50, %idx.ok42
  %sc = phi i1 [ false, %idx.ok42 ], [ %sc.b, %idx.ok50 ]
  %31 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad49:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1701, ptr @.faila.1702, i64 %30, ptr @.failb.1703, i64 %arr.len47, i32 70)
  unreachable

idx.ok50:                                         ; preds = %sc.rhs
  %arr.data51 = getelementptr i8, ptr %dist45, i64 8
  %arr.elem52 = getelementptr inbounds i32, ptr %arr.data51, i64 %30
  %elem53 = load i32, ptr %arr.elem52, align 4
  %best54 = load i32, ptr %best, align 4
  %32 = icmp slt i32 %elem53, %best54
  %33 = zext i1 %32 to i32
  %sc.b = icmp ne i32 %33, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %dist55 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %i56 = load i32, ptr %i29, align 4
  %34 = sext i32 %i56 to i64
  %arr.len57 = load i64, ptr %dist55, align 8
  %arr.oob58 = icmp uge i64 %34, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

if.end:                                           ; preds = %idx.ok60, %sc.end
  br label %for.update32

idx.bad59:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1704, ptr @.faila.1705, i64 %34, ptr @.failb.1706, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %if.then
  %arr.data61 = getelementptr i8, ptr %dist55, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 %34
  %elem63 = load i32, ptr %arr.elem62, align 4
  store i32 %elem63, ptr %best, align 4
  %i64 = load i32, ptr %i29, align 4
  store i32 %i64, ptr %u, align 4
  br label %if.end

if.then66:                                        ; preds = %for.end33
  %n68 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n69 = load i32, ptr %n68, align 4, !tbaa !7
  store i32 %n69, ptr %iter, align 4
  br label %if.end67

if.else:                                          ; preds = %for.end33
  %visited70 = load ptr, ptr %visited, align 8, !nonnull !0, !dereferenceable !1
  %u71 = load i32, ptr %u, align 4
  %35 = sext i32 %u71 to i64
  %arr.len72 = load i64, ptr %visited70, align 8
  %arr.oob73 = icmp uge i64 %35, %arr.len72
  br i1 %arr.oob73, label %idx.bad74, label %idx.ok75, !prof !2

if.end67:                                         ; preds = %for.end81, %if.then66
  br label %for.update23

idx.bad74:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1707, ptr @.faila.1708, i64 %35, ptr @.failb.1709, i64 %arr.len72, i32 70)
  unreachable

idx.ok75:                                         ; preds = %if.else
  %arr.data76 = getelementptr i8, ptr %visited70, i64 8
  %arr.elem77 = getelementptr inbounds i8, ptr %arr.data76, i64 %35
  store i8 1, ptr %arr.elem77, align 1
  store i32 0, ptr %v, align 4
  br label %for.cond78

for.cond78:                                       ; preds = %for.update80, %idx.ok75
  %v82 = load i32, ptr %v, align 4
  %n83 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n84 = load i32, ptr %n83, align 4, !tbaa !7
  %36 = icmp slt i32 %v82, %n84
  %37 = zext i1 %36 to i32
  br i1 %36, label %for.body79, label %for.end81

for.body79:                                       ; preds = %for.cond78
  %adj = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  %adj85 = load ptr, ptr %adj, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %u86 = load i32, ptr %u, align 4
  %n87 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n88 = load i32, ptr %n87, align 4, !tbaa !7
  %38 = mul i32 %u86, %n88
  %v89 = load i32, ptr %v, align 4
  %39 = add i32 %38, %v89
  %40 = sext i32 %39 to i64
  %arr.len90 = load i64, ptr %adj85, align 8
  %arr.oob91 = icmp uge i64 %40, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !2

for.update80:                                     ; preds = %if.end137
  %41 = load i32, ptr %v, align 4
  %42 = add i32 %41, 1
  store i32 %42, ptr %v, align 4
  br label %for.cond78

for.end81:                                        ; preds = %for.cond78
  br label %if.end67

idx.bad92:                                        ; preds = %for.body79
  call void @__polaron_fail(ptr @.fail.1710, ptr @.faila.1711, i64 %40, ptr @.failb.1712, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %for.body79
  %arr.data94 = getelementptr i8, ptr %adj85, i64 8
  %arr.elem95 = getelementptr inbounds i32, ptr %arr.data94, i64 %40
  %elem96 = load i32, ptr %arr.elem95, align 4
  store i32 %elem96, ptr %w, align 4
  %w97 = load i32, ptr %w, align 4
  %43 = icmp sge i32 %w97, 0
  %44 = zext i1 %43 to i32
  %sc.a98 = icmp ne i32 %44, 0
  br i1 %sc.a98, label %sc.rhs99, label %sc.end100

sc.rhs99:                                         ; preds = %idx.ok93
  %visited101 = load ptr, ptr %visited, align 8, !nonnull !0, !dereferenceable !1
  %v102 = load i32, ptr %v, align 4
  %45 = sext i32 %v102 to i64
  %arr.len103 = load i64, ptr %visited101, align 8
  %arr.oob104 = icmp uge i64 %45, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !2

sc.end100:                                        ; preds = %idx.ok106, %idx.ok93
  %sc111 = phi i1 [ false, %idx.ok93 ], [ %sc.b110, %idx.ok106 ]
  %46 = zext i1 %sc111 to i32
  %sc.a112 = icmp ne i32 %46, 0
  br i1 %sc.a112, label %sc.rhs113, label %sc.end114

idx.bad105:                                       ; preds = %sc.rhs99
  call void @__polaron_fail(ptr @.fail.1713, ptr @.faila.1714, i64 %45, ptr @.failb.1715, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %sc.rhs99
  %arr.data107 = getelementptr i8, ptr %visited101, i64 8
  %arr.elem108 = getelementptr inbounds i8, ptr %arr.data107, i64 %45
  %elem109 = load i8, ptr %arr.elem108, align 1
  %47 = zext i8 %elem109 to i32
  %48 = icmp eq i32 %47, 0
  %49 = zext i1 %48 to i32
  %sc.b110 = icmp ne i32 %49, 0
  br label %sc.end100

sc.rhs113:                                        ; preds = %sc.end100
  %dist115 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %u116 = load i32, ptr %u, align 4
  %50 = sext i32 %u116 to i64
  %arr.len117 = load i64, ptr %dist115, align 8
  %arr.oob118 = icmp uge i64 %50, %arr.len117
  br i1 %arr.oob118, label %idx.bad119, label %idx.ok120, !prof !2

sc.end114:                                        ; preds = %idx.ok130, %sc.end100
  %sc135 = phi i1 [ false, %sc.end100 ], [ %sc.b134, %idx.ok130 ]
  %51 = zext i1 %sc135 to i32
  br i1 %sc135, label %if.then136, label %if.end137

idx.bad119:                                       ; preds = %sc.rhs113
  call void @__polaron_fail(ptr @.fail.1716, ptr @.faila.1717, i64 %50, ptr @.failb.1718, i64 %arr.len117, i32 70)
  unreachable

idx.ok120:                                        ; preds = %sc.rhs113
  %arr.data121 = getelementptr i8, ptr %dist115, i64 8
  %arr.elem122 = getelementptr inbounds i32, ptr %arr.data121, i64 %50
  %elem123 = load i32, ptr %arr.elem122, align 4
  %w124 = load i32, ptr %w, align 4
  %52 = add i32 %elem123, %w124
  %dist125 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %v126 = load i32, ptr %v, align 4
  %53 = sext i32 %v126 to i64
  %arr.len127 = load i64, ptr %dist125, align 8
  %arr.oob128 = icmp uge i64 %53, %arr.len127
  br i1 %arr.oob128, label %idx.bad129, label %idx.ok130, !prof !2

idx.bad129:                                       ; preds = %idx.ok120
  call void @__polaron_fail(ptr @.fail.1719, ptr @.faila.1720, i64 %53, ptr @.failb.1721, i64 %arr.len127, i32 70)
  unreachable

idx.ok130:                                        ; preds = %idx.ok120
  %arr.data131 = getelementptr i8, ptr %dist125, i64 8
  %arr.elem132 = getelementptr inbounds i32, ptr %arr.data131, i64 %53
  %elem133 = load i32, ptr %arr.elem132, align 4
  %54 = icmp slt i32 %52, %elem133
  %55 = zext i1 %54 to i32
  %sc.b134 = icmp ne i32 %55, 0
  br label %sc.end114

if.then136:                                       ; preds = %sc.end114
  %dist138 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %v139 = load i32, ptr %v, align 4
  %56 = sext i32 %v139 to i64
  %arr.len140 = load i64, ptr %dist138, align 8
  %arr.oob141 = icmp uge i64 %56, %arr.len140
  br i1 %arr.oob141, label %idx.bad142, label %idx.ok143, !prof !2

if.end137:                                        ; preds = %idx.ok151, %sc.end114
  br label %for.update80

idx.bad142:                                       ; preds = %if.then136
  call void @__polaron_fail(ptr @.fail.1722, ptr @.faila.1723, i64 %56, ptr @.failb.1724, i64 %arr.len140, i32 70)
  unreachable

idx.ok143:                                        ; preds = %if.then136
  %arr.data144 = getelementptr i8, ptr %dist138, i64 8
  %arr.elem145 = getelementptr inbounds i32, ptr %arr.data144, i64 %56
  %dist146 = load ptr, ptr %dist, align 8, !nonnull !0, !dereferenceable !1
  %u147 = load i32, ptr %u, align 4
  %57 = sext i32 %u147 to i64
  %arr.len148 = load i64, ptr %dist146, align 8
  %arr.oob149 = icmp uge i64 %57, %arr.len148
  br i1 %arr.oob149, label %idx.bad150, label %idx.ok151, !prof !2

idx.bad150:                                       ; preds = %idx.ok143
  call void @__polaron_fail(ptr @.fail.1725, ptr @.faila.1726, i64 %57, ptr @.failb.1727, i64 %arr.len148, i32 70)
  unreachable

idx.ok151:                                        ; preds = %idx.ok143
  %arr.data152 = getelementptr i8, ptr %dist146, i64 8
  %arr.elem153 = getelementptr inbounds i32, ptr %arr.data152, i64 %57
  %elem154 = load i32, ptr %arr.elem153, align 4
  %w155 = load i32, ptr %w, align 4
  %58 = add i32 %elem154, %w155
  store i32 %58, ptr %arr.elem145, align 4
  br label %if.end137
}

define internal i32 @WeightedGraph.mstWeight(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %w = alloca i32, align 4
  %v = alloca i32, align 4
  %i28 = alloca i32, align 4
  %best = alloca i32, align 4
  %u = alloca i32, align 4
  %iter = alloca i32, align 4
  %total = alloca i32, align 4
  %i = alloca i32, align 4
  %inMst = alloca ptr, align 8
  %key = alloca ptr, align 8
  %INF = alloca i32, align 4
  store i32 1000000000, ptr %INF, align 4
  %n = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  %1 = sext i32 %n1 to i64
  %2 = mul i64 %1, 4
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %key, align 8
  %n2 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n3 = load i32, ptr %n2, align 4, !tbaa !7
  %5 = sext i32 %n3 to i64
  %6 = mul i64 %5, 1
  %7 = add i64 8, %6
  %arr4 = call ptr @__polaron_malloc(i64 %7)
  store i64 %5, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %8 = call ptr @memset(ptr %arr.data5, i32 0, i64 %6)
  store ptr %arr4, ptr %inMst, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %n7 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n8 = load i32, ptr %n7, align 4, !tbaa !7
  %9 = icmp slt i32 %i6, %n8
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %key9 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %11 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %key9, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %key13 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %arr.len14 = load i64, ptr %key13, align 8
  %arr.oob15 = icmp uge i64 0, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1728, ptr @.faila.1729, i64 %11, ptr @.failb.1730, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %key9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %11
  %INF12 = load i32, ptr %INF, align 4
  store i32 %INF12, ptr %arr.elem, align 4
  br label %for.update

idx.bad16:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.1731, ptr @.faila.1732, i64 0, ptr @.failb.1733, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %for.end
  %arr.data18 = getelementptr i8, ptr %key13, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 0
  store i32 0, ptr %arr.elem19, align 4
  store i32 0, ptr %total, align 4
  store i32 0, ptr %iter, align 4
  br label %for.cond20

for.cond20:                                       ; preds = %for.update22, %idx.ok17
  %iter24 = load i32, ptr %iter, align 4
  %n25 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n26 = load i32, ptr %n25, align 4, !tbaa !7
  %14 = icmp slt i32 %iter24, %n26
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body21, label %for.end23

for.body21:                                       ; preds = %for.cond20
  store i32 -1, ptr %u, align 4
  %INF27 = load i32, ptr %INF, align 4
  store i32 %INF27, ptr %best, align 4
  store i32 0, ptr %i28, align 4
  br label %for.cond29

for.update22:                                     ; preds = %if.end66
  %16 = load i32, ptr %iter, align 4
  %17 = add i32 %16, 1
  store i32 %17, ptr %iter, align 4
  br label %for.cond20

for.end23:                                        ; preds = %for.cond20
  %total147 = load i32, ptr %total, align 4
  ret i32 %total147

for.cond29:                                       ; preds = %for.update31, %for.body21
  %i33 = load i32, ptr %i28, align 4
  %n34 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n35 = load i32, ptr %n34, align 4, !tbaa !7
  %18 = icmp slt i32 %i33, %n35
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body30, label %for.end32

for.body30:                                       ; preds = %for.cond29
  %inMst36 = load ptr, ptr %inMst, align 8, !nonnull !0, !dereferenceable !1
  %i37 = load i32, ptr %i28, align 4
  %20 = sext i32 %i37 to i64
  %arr.len38 = load i64, ptr %inMst36, align 8
  %arr.oob39 = icmp uge i64 %20, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !2

for.update31:                                     ; preds = %if.end
  %21 = load i32, ptr %i28, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i28, align 4
  br label %for.cond29

for.end32:                                        ; preds = %for.cond29
  %u64 = load i32, ptr %u, align 4
  %23 = icmp eq i32 %u64, -1
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then65, label %if.else

idx.bad40:                                        ; preds = %for.body30
  call void @__polaron_fail(ptr @.fail.1734, ptr @.faila.1735, i64 %20, ptr @.failb.1736, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %for.body30
  %arr.data42 = getelementptr i8, ptr %inMst36, i64 8
  %arr.elem43 = getelementptr inbounds i8, ptr %arr.data42, i64 %20
  %elem = load i8, ptr %arr.elem43, align 1
  %25 = zext i8 %elem to i32
  %26 = icmp eq i32 %25, 0
  %27 = zext i1 %26 to i32
  %sc.a = icmp ne i32 %27, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %idx.ok41
  %key44 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %i45 = load i32, ptr %i28, align 4
  %28 = sext i32 %i45 to i64
  %arr.len46 = load i64, ptr %key44, align 8
  %arr.oob47 = icmp uge i64 %28, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

sc.end:                                           ; preds = %idx.ok49, %idx.ok41
  %sc = phi i1 [ false, %idx.ok41 ], [ %sc.b, %idx.ok49 ]
  %29 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad48:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1737, ptr @.faila.1738, i64 %28, ptr @.failb.1739, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %sc.rhs
  %arr.data50 = getelementptr i8, ptr %key44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %28
  %elem52 = load i32, ptr %arr.elem51, align 4
  %best53 = load i32, ptr %best, align 4
  %30 = icmp slt i32 %elem52, %best53
  %31 = zext i1 %30 to i32
  %sc.b = icmp ne i32 %31, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %key54 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %i55 = load i32, ptr %i28, align 4
  %32 = sext i32 %i55 to i64
  %arr.len56 = load i64, ptr %key54, align 8
  %arr.oob57 = icmp uge i64 %32, %arr.len56
  br i1 %arr.oob57, label %idx.bad58, label %idx.ok59, !prof !2

if.end:                                           ; preds = %idx.ok59, %sc.end
  br label %for.update31

idx.bad58:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1740, ptr @.faila.1741, i64 %32, ptr @.failb.1742, i64 %arr.len56, i32 70)
  unreachable

idx.ok59:                                         ; preds = %if.then
  %arr.data60 = getelementptr i8, ptr %key54, i64 8
  %arr.elem61 = getelementptr inbounds i32, ptr %arr.data60, i64 %32
  %elem62 = load i32, ptr %arr.elem61, align 4
  store i32 %elem62, ptr %best, align 4
  %i63 = load i32, ptr %i28, align 4
  store i32 %i63, ptr %u, align 4
  br label %if.end

if.then65:                                        ; preds = %for.end32
  %n67 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n68 = load i32, ptr %n67, align 4, !tbaa !7
  store i32 %n68, ptr %iter, align 4
  br label %if.end66

if.else:                                          ; preds = %for.end32
  %inMst69 = load ptr, ptr %inMst, align 8, !nonnull !0, !dereferenceable !1
  %u70 = load i32, ptr %u, align 4
  %33 = sext i32 %u70 to i64
  %arr.len71 = load i64, ptr %inMst69, align 8
  %arr.oob72 = icmp uge i64 %33, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !2

if.end66:                                         ; preds = %for.end90, %if.then65
  br label %for.update22

idx.bad73:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1743, ptr @.faila.1744, i64 %33, ptr @.failb.1745, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %if.else
  %arr.data75 = getelementptr i8, ptr %inMst69, i64 8
  %arr.elem76 = getelementptr inbounds i8, ptr %arr.data75, i64 %33
  store i8 1, ptr %arr.elem76, align 1
  %total77 = load i32, ptr %total, align 4
  %key78 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %u79 = load i32, ptr %u, align 4
  %34 = sext i32 %u79 to i64
  %arr.len80 = load i64, ptr %key78, align 8
  %arr.oob81 = icmp uge i64 %34, %arr.len80
  br i1 %arr.oob81, label %idx.bad82, label %idx.ok83, !prof !2

idx.bad82:                                        ; preds = %idx.ok74
  call void @__polaron_fail(ptr @.fail.1746, ptr @.faila.1747, i64 %34, ptr @.failb.1748, i64 %arr.len80, i32 70)
  unreachable

idx.ok83:                                         ; preds = %idx.ok74
  %arr.data84 = getelementptr i8, ptr %key78, i64 8
  %arr.elem85 = getelementptr inbounds i32, ptr %arr.data84, i64 %34
  %elem86 = load i32, ptr %arr.elem85, align 4
  %35 = add i32 %total77, %elem86
  store i32 %35, ptr %total, align 4
  store i32 0, ptr %v, align 4
  br label %for.cond87

for.cond87:                                       ; preds = %for.update89, %idx.ok83
  %v91 = load i32, ptr %v, align 4
  %n92 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n93 = load i32, ptr %n92, align 4, !tbaa !7
  %36 = icmp slt i32 %v91, %n93
  %37 = zext i1 %36 to i32
  br i1 %36, label %for.body88, label %for.end90

for.body88:                                       ; preds = %for.cond87
  %adj = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 1
  %adj94 = load ptr, ptr %adj, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %u95 = load i32, ptr %u, align 4
  %n96 = getelementptr inbounds %class.WeightedGraph, ptr %0, i32 0, i32 2
  %n97 = load i32, ptr %n96, align 4, !tbaa !7
  %38 = mul i32 %u95, %n97
  %v98 = load i32, ptr %v, align 4
  %39 = add i32 %38, %v98
  %40 = sext i32 %39 to i64
  %arr.len99 = load i64, ptr %adj94, align 8
  %arr.oob100 = icmp uge i64 %40, %arr.len99
  br i1 %arr.oob100, label %idx.bad101, label %idx.ok102, !prof !2

for.update89:                                     ; preds = %if.end137
  %41 = load i32, ptr %v, align 4
  %42 = add i32 %41, 1
  store i32 %42, ptr %v, align 4
  br label %for.cond87

for.end90:                                        ; preds = %for.cond87
  br label %if.end66

idx.bad101:                                       ; preds = %for.body88
  call void @__polaron_fail(ptr @.fail.1749, ptr @.faila.1750, i64 %40, ptr @.failb.1751, i64 %arr.len99, i32 70)
  unreachable

idx.ok102:                                        ; preds = %for.body88
  %arr.data103 = getelementptr i8, ptr %adj94, i64 8
  %arr.elem104 = getelementptr inbounds i32, ptr %arr.data103, i64 %40
  %elem105 = load i32, ptr %arr.elem104, align 4
  store i32 %elem105, ptr %w, align 4
  %w106 = load i32, ptr %w, align 4
  %43 = icmp sge i32 %w106, 0
  %44 = zext i1 %43 to i32
  %sc.a107 = icmp ne i32 %44, 0
  br i1 %sc.a107, label %sc.rhs108, label %sc.end109

sc.rhs108:                                        ; preds = %idx.ok102
  %inMst110 = load ptr, ptr %inMst, align 8, !nonnull !0, !dereferenceable !1
  %v111 = load i32, ptr %v, align 4
  %45 = sext i32 %v111 to i64
  %arr.len112 = load i64, ptr %inMst110, align 8
  %arr.oob113 = icmp uge i64 %45, %arr.len112
  br i1 %arr.oob113, label %idx.bad114, label %idx.ok115, !prof !2

sc.end109:                                        ; preds = %idx.ok115, %idx.ok102
  %sc120 = phi i1 [ false, %idx.ok102 ], [ %sc.b119, %idx.ok115 ]
  %46 = zext i1 %sc120 to i32
  %sc.a121 = icmp ne i32 %46, 0
  br i1 %sc.a121, label %sc.rhs122, label %sc.end123

idx.bad114:                                       ; preds = %sc.rhs108
  call void @__polaron_fail(ptr @.fail.1752, ptr @.faila.1753, i64 %45, ptr @.failb.1754, i64 %arr.len112, i32 70)
  unreachable

idx.ok115:                                        ; preds = %sc.rhs108
  %arr.data116 = getelementptr i8, ptr %inMst110, i64 8
  %arr.elem117 = getelementptr inbounds i8, ptr %arr.data116, i64 %45
  %elem118 = load i8, ptr %arr.elem117, align 1
  %47 = zext i8 %elem118 to i32
  %48 = icmp eq i32 %47, 0
  %49 = zext i1 %48 to i32
  %sc.b119 = icmp ne i32 %49, 0
  br label %sc.end109

sc.rhs122:                                        ; preds = %sc.end109
  %w124 = load i32, ptr %w, align 4
  %key125 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %v126 = load i32, ptr %v, align 4
  %50 = sext i32 %v126 to i64
  %arr.len127 = load i64, ptr %key125, align 8
  %arr.oob128 = icmp uge i64 %50, %arr.len127
  br i1 %arr.oob128, label %idx.bad129, label %idx.ok130, !prof !2

sc.end123:                                        ; preds = %idx.ok130, %sc.end109
  %sc135 = phi i1 [ false, %sc.end109 ], [ %sc.b134, %idx.ok130 ]
  %51 = zext i1 %sc135 to i32
  br i1 %sc135, label %if.then136, label %if.end137

idx.bad129:                                       ; preds = %sc.rhs122
  call void @__polaron_fail(ptr @.fail.1755, ptr @.faila.1756, i64 %50, ptr @.failb.1757, i64 %arr.len127, i32 70)
  unreachable

idx.ok130:                                        ; preds = %sc.rhs122
  %arr.data131 = getelementptr i8, ptr %key125, i64 8
  %arr.elem132 = getelementptr inbounds i32, ptr %arr.data131, i64 %50
  %elem133 = load i32, ptr %arr.elem132, align 4
  %52 = icmp slt i32 %w124, %elem133
  %53 = zext i1 %52 to i32
  %sc.b134 = icmp ne i32 %53, 0
  br label %sc.end123

if.then136:                                       ; preds = %sc.end123
  %key138 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %v139 = load i32, ptr %v, align 4
  %54 = sext i32 %v139 to i64
  %arr.len140 = load i64, ptr %key138, align 8
  %arr.oob141 = icmp uge i64 %54, %arr.len140
  br i1 %arr.oob141, label %idx.bad142, label %idx.ok143, !prof !2

if.end137:                                        ; preds = %idx.ok143, %sc.end123
  br label %for.update89

idx.bad142:                                       ; preds = %if.then136
  call void @__polaron_fail(ptr @.fail.1758, ptr @.faila.1759, i64 %54, ptr @.failb.1760, i64 %arr.len140, i32 70)
  unreachable

idx.ok143:                                        ; preds = %if.then136
  %arr.data144 = getelementptr i8, ptr %key138, i64 8
  %arr.elem145 = getelementptr inbounds i32, ptr %arr.data144, i64 %54
  %w146 = load i32, ptr %w, align 4
  store i32 %w146, ptr %arr.elem145, align 4
  br label %if.end137
}

define internal void @LruCache.LruCache(ptr %0, i32 %1) {
entry:
  %capacity = alloca i32, align 4
  store i32 %1, ptr %capacity, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 0
  store ptr @LruCache.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %keys = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 5
  store ptr null, ptr %keys, align 8, !tbaa !3
  %vals = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 6
  store ptr null, ptr %vals, align 8, !tbaa !3
  %prev = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 7
  store ptr null, ptr %prev, align 8, !tbaa !3
  %next = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 8
  store ptr null, ptr %next, align 8, !tbaa !3
  %slotByKey = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  store ptr null, ptr %slotByKey, align 8, !tbaa !3
  %cap = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 1
  %capacity1 = load i32, ptr %capacity, align 4
  store i32 %capacity1, ptr %cap, align 4, !tbaa !7
  %size = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 2
  store i32 0, ptr %size, align 4, !tbaa !7
  %head = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 3
  store i32 -1, ptr %head, align 4, !tbaa !7
  %tail = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 4
  store i32 -1, ptr %tail, align 4, !tbaa !7
  %keys2 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 5
  %capacity3 = load i32, ptr %capacity, align 4
  %2 = sext i32 %capacity3 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %keys2, align 8, !tbaa !3
  %vals4 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 6
  %capacity5 = load i32, ptr %capacity, align 4
  %6 = sext i32 %capacity5 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr6 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %9 = call ptr @memset(ptr %arr.data7, i32 0, i64 %7)
  store ptr %arr6, ptr %vals4, align 8, !tbaa !3
  %prev8 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 7
  %capacity9 = load i32, ptr %capacity, align 4
  %10 = sext i32 %capacity9 to i64
  %11 = mul i64 %10, 4
  %12 = add i64 8, %11
  %arr10 = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr10, align 8
  %arr.data11 = getelementptr i8, ptr %arr10, i64 8
  %13 = call ptr @memset(ptr %arr.data11, i32 0, i64 %11)
  store ptr %arr10, ptr %prev8, align 8, !tbaa !3
  %next12 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 8
  %capacity13 = load i32, ptr %capacity, align 4
  %14 = sext i32 %capacity13 to i64
  %15 = mul i64 %14, 4
  %16 = add i64 8, %15
  %arr14 = call ptr @__polaron_malloc(i64 %16)
  store i64 %14, ptr %arr14, align 8
  %arr.data15 = getelementptr i8, ptr %arr14, i64 8
  %17 = call ptr @memset(ptr %arr.data15, i32 0, i64 %15)
  store ptr %arr14, ptr %next12, align 8, !tbaa !3
  %slotByKey16 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %"HashMap$int$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$int$int", ptr null, i64 1) to i64))
  call void @"HashMap$int$int.HashMap$int$int"(ptr %"HashMap$int$int.obj")
  store ptr %"HashMap$int$int.obj", ptr %slotByKey16, align 8, !tbaa !3
  ret void
}

define internal void @LruCache.unlink(ptr nonnull align 8 dereferenceable(64) %0, i32 %1) {
entry:
  %nx = alloca i32, align 4
  %p = alloca i32, align 4
  %s = alloca i32, align 4
  store i32 %1, ptr %s, align 4
  %prev = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 7
  %prev1 = load ptr, ptr %prev, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s2 = load i32, ptr %s, align 4
  %2 = sext i32 %s2 to i64
  %arr.len = load i64, ptr %prev1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1761, ptr @.faila.1762, i64 %2, ptr @.failb.1763, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %prev1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %p, align 4
  %next = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 8
  %next3 = load ptr, ptr %next, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s4 = load i32, ptr %s, align 4
  %3 = sext i32 %s4 to i64
  %arr.len5 = load i64, ptr %next3, align 8
  %arr.oob6 = icmp uge i64 %3, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1764, ptr @.faila.1765, i64 %3, ptr @.failb.1766, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %next3, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 %3
  %elem11 = load i32, ptr %arr.elem10, align 4
  store i32 %elem11, ptr %nx, align 4
  %p12 = load i32, ptr %p, align 4
  %4 = icmp ne i32 %p12, -1
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.else

if.then:                                          ; preds = %idx.ok8
  %next13 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 8
  %next14 = load ptr, ptr %next13, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %p15 = load i32, ptr %p, align 4
  %6 = sext i32 %p15 to i64
  %arr.len16 = load i64, ptr %next14, align 8
  %arr.oob17 = icmp uge i64 %6, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

if.else:                                          ; preds = %idx.ok8
  %head = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 3
  %nx23 = load i32, ptr %nx, align 4
  store i32 %nx23, ptr %head, align 4, !tbaa !7
  br label %if.end

if.end:                                           ; preds = %if.else, %idx.ok19
  %nx24 = load i32, ptr %nx, align 4
  %7 = icmp ne i32 %nx24, -1
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then25, label %if.else26

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1767, ptr @.faila.1768, i64 %6, ptr @.failb.1769, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %next14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %6
  %nx22 = load i32, ptr %nx, align 4
  store i32 %nx22, ptr %arr.elem21, align 4
  br label %if.end

if.then25:                                        ; preds = %if.end
  %prev28 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 7
  %prev29 = load ptr, ptr %prev28, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %nx30 = load i32, ptr %nx, align 4
  %9 = sext i32 %nx30 to i64
  %arr.len31 = load i64, ptr %prev29, align 8
  %arr.oob32 = icmp uge i64 %9, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

if.else26:                                        ; preds = %if.end
  %tail = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 4
  %p38 = load i32, ptr %p, align 4
  store i32 %p38, ptr %tail, align 4, !tbaa !7
  br label %if.end27

if.end27:                                         ; preds = %if.else26, %idx.ok34
  ret void

idx.bad33:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1770, ptr @.faila.1771, i64 %9, ptr @.failb.1772, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then25
  %arr.data35 = getelementptr i8, ptr %prev29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %9
  %p37 = load i32, ptr %p, align 4
  store i32 %p37, ptr %arr.elem36, align 4
  br label %if.end27
}

define internal void @LruCache.pushHead(ptr nonnull align 8 dereferenceable(64) %0, i32 %1) {
entry:
  %s = alloca i32, align 4
  store i32 %1, ptr %s, align 4
  %prev = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 7
  %prev1 = load ptr, ptr %prev, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s2 = load i32, ptr %s, align 4
  %2 = sext i32 %s2 to i64
  %arr.len = load i64, ptr %prev1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1773, ptr @.faila.1774, i64 %2, ptr @.failb.1775, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %prev1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  store i32 -1, ptr %arr.elem, align 4
  %next = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 8
  %next3 = load ptr, ptr %next, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s4 = load i32, ptr %s, align 4
  %3 = sext i32 %s4 to i64
  %arr.len5 = load i64, ptr %next3, align 8
  %arr.oob6 = icmp uge i64 %3, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1776, ptr @.faila.1777, i64 %3, ptr @.failb.1778, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %next3, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 %3
  %head = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 3
  %head11 = load i32, ptr %head, align 4, !tbaa !7
  store i32 %head11, ptr %arr.elem10, align 4
  %head12 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 3
  %head13 = load i32, ptr %head12, align 4, !tbaa !7
  %4 = icmp ne i32 %head13, -1
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok8
  %prev14 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 7
  %prev15 = load ptr, ptr %prev14, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %head16 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 3
  %head17 = load i32, ptr %head16, align 4, !tbaa !7
  %6 = sext i32 %head17 to i64
  %arr.len18 = load i64, ptr %prev15, align 8
  %arr.oob19 = icmp uge i64 %6, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !2

if.end:                                           ; preds = %idx.ok21, %idx.ok8
  %head25 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 3
  %s26 = load i32, ptr %s, align 4
  store i32 %s26, ptr %head25, align 4, !tbaa !7
  %tail = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 4
  %tail27 = load i32, ptr %tail, align 4, !tbaa !7
  %7 = icmp eq i32 %tail27, -1
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then28, label %if.end29

idx.bad20:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1779, ptr @.faila.1780, i64 %6, ptr @.failb.1781, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.then
  %arr.data22 = getelementptr i8, ptr %prev15, i64 8
  %arr.elem23 = getelementptr inbounds i32, ptr %arr.data22, i64 %6
  %s24 = load i32, ptr %s, align 4
  store i32 %s24, ptr %arr.elem23, align 4
  br label %if.end

if.then28:                                        ; preds = %if.end
  %tail30 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 4
  %s31 = load i32, ptr %s, align 4
  store i32 %s31, ptr %tail30, align 4, !tbaa !7
  br label %if.end29

if.end29:                                         ; preds = %if.then28, %if.end
  ret void
}

define internal i32 @LruCache.get(ptr nonnull align 8 dereferenceable(64) %0, i32 %1) {
entry:
  %s = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %slotByKey = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey1 = load ptr, ptr %slotByKey, align 8, !tbaa !3
  %key2 = load i32, ptr %key, align 4
  %2 = call i32 @"HashMap$int$int.containsKey"(ptr %slotByKey1, i32 %key2)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 -1

if.end:                                           ; preds = %entry
  %slotByKey3 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey4 = load ptr, ptr %slotByKey3, align 8, !tbaa !3
  %key5 = load i32, ptr %key, align 4
  %5 = call i32 @"HashMap$int$int.get"(ptr %slotByKey4, i32 %key5)
  store i32 %5, ptr %s, align 4
  %s6 = load i32, ptr %s, align 4
  call void @LruCache.unlink(ptr %0, i32 %s6)
  %s7 = load i32, ptr %s, align 4
  call void @LruCache.pushHead(ptr %0, i32 %s7)
  %vals = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 6
  %vals8 = load ptr, ptr %vals, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s9 = load i32, ptr %s, align 4
  %6 = sext i32 %s9 to i64
  %arr.len = load i64, ptr %vals8, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1782, ptr @.faila.1783, i64 %6, ptr @.failb.1784, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %vals8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @LruCache.contains(ptr nonnull align 8 dereferenceable(64) %0, i32 %1) {
entry:
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  %slotByKey = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey1 = load ptr, ptr %slotByKey, align 8, !tbaa !3
  %key2 = load i32, ptr %key, align 4
  %2 = call i32 @"HashMap$int$int.containsKey"(ptr %slotByKey1, i32 %key2)
  ret i32 %2
}

define internal void @LruCache.put(ptr nonnull align 8 dereferenceable(64) %0, i32 %1, i32 %2) {
entry:
  %s11 = alloca i32, align 4
  %s = alloca i32, align 4
  %value = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %1, ptr %key, align 4
  store i32 %2, ptr %value, align 4
  %slotByKey = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey1 = load ptr, ptr %slotByKey, align 8, !tbaa !3
  %key2 = load i32, ptr %key, align 4
  %3 = call i32 @"HashMap$int$int.containsKey"(ptr %slotByKey1, i32 %key2)
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %slotByKey3 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey4 = load ptr, ptr %slotByKey3, align 8, !tbaa !3
  %key5 = load i32, ptr %key, align 4
  %5 = call i32 @"HashMap$int$int.get"(ptr %slotByKey4, i32 %key5)
  store i32 %5, ptr %s, align 4
  %vals = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 6
  %vals6 = load ptr, ptr %vals, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s7 = load i32, ptr %s, align 4
  %6 = sext i32 %s7 to i64
  %arr.len = load i64, ptr %vals6, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %entry
  store i32 0, ptr %s11, align 4
  %size = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 2
  %size12 = load i32, ptr %size, align 4, !tbaa !7
  %cap = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 1
  %cap13 = load i32, ptr %cap, align 4, !tbaa !7
  %7 = icmp slt i32 %size12, %cap13
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then14, label %if.else

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1785, ptr @.faila.1786, i64 %6, ptr @.failb.1787, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %vals6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %value8 = load i32, ptr %value, align 4
  store i32 %value8, ptr %arr.elem, align 4
  %s9 = load i32, ptr %s, align 4
  call void @LruCache.unlink(ptr %0, i32 %s9)
  %s10 = load i32, ptr %s, align 4
  call void @LruCache.pushHead(ptr %0, i32 %s10)
  ret void

if.then14:                                        ; preds = %if.end
  %size16 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 2
  %size17 = load i32, ptr %size16, align 4, !tbaa !7
  store i32 %size17, ptr %s11, align 4
  %size18 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 2
  %size19 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 2
  %size20 = load i32, ptr %size19, align 4, !tbaa !7
  %9 = add i32 %size20, 1
  store i32 %9, ptr %size18, align 4, !tbaa !7
  br label %if.end15

if.else:                                          ; preds = %if.end
  %tail = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 4
  %tail21 = load i32, ptr %tail, align 4, !tbaa !7
  store i32 %tail21, ptr %s11, align 4
  %slotByKey22 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey23 = load ptr, ptr %slotByKey22, align 8, !tbaa !3
  %keys = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 5
  %keys24 = load ptr, ptr %keys, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s25 = load i32, ptr %s11, align 4
  %10 = sext i32 %s25 to i64
  %arr.len26 = load i64, ptr %keys24, align 8
  %arr.oob27 = icmp uge i64 %10, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

if.end15:                                         ; preds = %idx.ok29, %if.then14
  %keys33 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 5
  %keys34 = load ptr, ptr %keys33, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s35 = load i32, ptr %s11, align 4
  %11 = sext i32 %s35 to i64
  %arr.len36 = load i64, ptr %keys34, align 8
  %arr.oob37 = icmp uge i64 %11, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad28:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1788, ptr @.faila.1789, i64 %10, ptr @.failb.1790, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %if.else
  %arr.data30 = getelementptr i8, ptr %keys24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %10
  %elem = load i32, ptr %arr.elem31, align 4
  %12 = call i32 @"HashMap$int$int.remove"(ptr %slotByKey23, i32 %elem)
  %s32 = load i32, ptr %s11, align 4
  call void @LruCache.unlink(ptr %0, i32 %s32)
  br label %if.end15

idx.bad38:                                        ; preds = %if.end15
  call void @__polaron_fail(ptr @.fail.1791, ptr @.faila.1792, i64 %11, ptr @.failb.1793, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %if.end15
  %arr.data40 = getelementptr i8, ptr %keys34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %11
  %key42 = load i32, ptr %key, align 4
  store i32 %key42, ptr %arr.elem41, align 4
  %vals43 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 6
  %vals44 = load ptr, ptr %vals43, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s45 = load i32, ptr %s11, align 4
  %13 = sext i32 %s45 to i64
  %arr.len46 = load i64, ptr %vals44, align 8
  %arr.oob47 = icmp uge i64 %13, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

idx.bad48:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.1794, ptr @.faila.1795, i64 %13, ptr @.failb.1796, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok39
  %arr.data50 = getelementptr i8, ptr %vals44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %13
  %value52 = load i32, ptr %value, align 4
  store i32 %value52, ptr %arr.elem51, align 4
  %slotByKey53 = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 9
  %slotByKey54 = load ptr, ptr %slotByKey53, align 8, !tbaa !3
  %key55 = load i32, ptr %key, align 4
  %s56 = load i32, ptr %s11, align 4
  call void @"HashMap$int$int.put"(ptr %slotByKey54, i32 %key55, i32 %s56)
  %s57 = load i32, ptr %s11, align 4
  call void @LruCache.pushHead(ptr %0, i32 %s57)
  ret void
}

define internal i32 @LruCache.count(ptr nonnull align 8 dereferenceable(64) %0) {
entry:
  %size = getelementptr inbounds %class.LruCache, ptr %0, i32 0, i32 2
  %size1 = load i32, ptr %size, align 4, !tbaa !7
  ret i32 %size1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5322)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5324)
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

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
