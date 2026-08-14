; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_wide_hash.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/struct_wide_hash.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Wide = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%"class.TreeSet$Wide" = type { ptr, ptr, i32 }
%"class.HashMap$Wide$int" = type { ptr, ptr, ptr, ptr, i32, i32 }
%"class.TreeSetNode$Wide" = type { ptr, ptr, ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"TreeSetNode$Wide.vtable" = private constant [357 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"TreeSet$Wide.vtable" = private constant [357 x ptr] [ptr @"TreeSet$Wide.freeSubtree", ptr @"TreeSet$Wide.add", ptr @"TreeSet$Wide.nodeHeight", ptr @"TreeSet$Wide.fixHeight", ptr @"TreeSet$Wide.balance", ptr @"TreeSet$Wide.rotateRight", ptr @"TreeSet$Wide.rotateLeft", ptr @"TreeSet$Wide.insertNode", ptr @"TreeSet$Wide.contains", ptr @"TreeSet$Wide.fill", ptr @"TreeSet$Wide.toArray", ptr @"TreeSet$Wide.size", ptr @"TreeSet$Wide.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeSet$Wide.~TreeSet$Wide"]
@"HashMap$Wide$int.vtable" = private constant [357 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$Wide$int.size", ptr @"HashMap$Wide$int.isEmpty", ptr null, ptr null, ptr null, ptr @"HashMap$Wide$int.slotFor", ptr @"HashMap$Wide$int.grow", ptr @"HashMap$Wide$int.put", ptr @"HashMap$Wide$int.get", ptr @"HashMap$Wide$int.containsKey", ptr @"HashMap$Wide$int.getOrDefault", ptr @"HashMap$Wide$int.merge", ptr @"HashMap$Wide$int.remove", ptr @"HashMap$Wide$int.keyArray", ptr @"HashMap$Wide$int.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$Wide$int.~HashMap$Wide$int"]
@Object.vtable = private constant [357 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [16 x i8] c"got=%d size=%d\0A\00", align 1
@.panic = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1409:33  in TreeSet$Wide.freeSubtree\0A\00", align 1
@.panic.1 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1410:33  in TreeSet$Wide.freeSubtree\0A\00", align 1
@.panic.2 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1411:17  in TreeSet$Wide.freeSubtree\0A\00", align 1
@.panic.3 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1419:17  in TreeSet$Wide.nodeHeight\0A\00", align 1
@.panic.4 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1422:17  in TreeSet$Wide.fixHeight\0A\00", align 1
@.panic.5 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1423:17  in TreeSet$Wide.fixHeight\0A\00", align 1
@.panic.6 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:41  in TreeSet$Wide.fixHeight\0A\00", align 1
@.panic.7 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:69  in TreeSet$Wide.fixHeight\0A\00", align 1
@.panic.8 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$Wide.balance\0A\00", align 1
@.panic.9 = private unnamed_addr constant [92 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$Wide.balance\0A\00", align 1
@.panic.10 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1430:17  in TreeSet$Wide.rotateRight\0A\00", align 1
@.panic.11 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$Wide.rotateRight\0A\00", align 1
@.panic.12 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$Wide.rotateRight\0A\00", align 1
@.panic.13 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1432:25  in TreeSet$Wide.rotateRight\0A\00", align 1
@.panic.14 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1438:17  in TreeSet$Wide.rotateLeft\0A\00", align 1
@.panic.15 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$Wide.rotateLeft\0A\00", align 1
@.panic.16 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$Wide.rotateLeft\0A\00", align 1
@.panic.17 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1440:24  in TreeSet$Wide.rotateLeft\0A\00", align 1
@.panic.18 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1450:17  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.19 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.20 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.21 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.22 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.23 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:21  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.24 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.25 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.26 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:21  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.27 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.28 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$Wide.insertNode\0A\00", align 1
@.panic.29 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1472:21  in TreeSet$Wide.contains\0A\00", align 1
@.panic.30 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:38  in TreeSet$Wide.contains\0A\00", align 1
@.panic.31 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:63  in TreeSet$Wide.contains\0A\00", align 1
@.panic.32 = private unnamed_addr constant [89 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1480:17  in TreeSet$Wide.fill\0A\00", align 1
@.fail = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1481:24  in TreeSet$Wide.fill\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.33 = private unnamed_addr constant [89 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1481:24  in TreeSet$Wide.fill\0A\00", align 1
@.panic.34 = private unnamed_addr constant [89 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1483:17  in TreeSet$Wide.fill\0A\00", align 1
@.contract.393 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Wide$int.HashMap$Wide$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.394 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.395 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.396 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Wide$int.HashMap$Wide$int\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.397 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.398 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.399 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Wide$int.HashMap$Wide$int\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.400 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Wide$int.HashMap$Wide$int\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.401 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Wide$int.HashMap$Wide$int\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.402 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$Wide$int.slotFor\0A\00", align 1
@.faila.403 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.404 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.405 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$Wide$int.slotFor\0A\00", align 1
@.faila.406 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.407 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.408 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.409 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.410 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.411 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.412 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.413 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.414 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.415 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.416 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.417 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.418 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.419 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.420 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.421 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.422 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.423 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.424 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.425 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.426 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.427 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.428 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.429 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$Wide$int.grow\0A\00", align 1
@.faila.430 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.431 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.432 = private unnamed_addr constant [112 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Wide$int.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.433 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.434 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.435 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Wide$int.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.436 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.437 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.438 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Wide$int.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.439 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Wide$int.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.440 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Wide$int.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.441 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$Wide$int.put\0A\00", align 1
@.faila.442 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.443 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.444 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$Wide$int.put\0A\00", align 1
@.faila.445 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.446 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.447 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$Wide$int.put\0A\00", align 1
@.faila.448 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.449 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.450 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$Wide$int.put\0A\00", align 1
@.faila.451 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.452 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.453 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Wide$int.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.454 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.455 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.456 = private unnamed_addr constant [117 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Wide$int.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.457 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.458 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.459 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Wide$int.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.460 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Wide$int.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.461 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Wide$int.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.462 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$Wide$int.get\0A\00", align 1
@.faila.463 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.464 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.465 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$Wide$int.containsKey\0A\00", align 1
@.faila.466 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.467 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.468 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$Wide$int.getOrDefault\0A\00", align 1
@.faila.469 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.470 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.471 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$Wide$int.getOrDefault\0A\00", align 1
@.faila.472 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.473 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.474 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$Wide$int.merge\0A\00", align 1
@.faila.475 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.476 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.477 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$Wide$int.merge\0A\00", align 1
@.faila.478 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.479 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.480 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$Wide$int.merge\0A\00", align 1
@.faila.481 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.482 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.483 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$Wide$int.merge\0A\00", align 1
@.faila.484 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.485 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.486 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$Wide$int.merge\0A\00", align 1
@.faila.487 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.488 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.489 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$Wide$int.merge\0A\00", align 1
@.faila.490 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.491 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.492 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Wide$int.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.493 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.494 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.495 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Wide$int.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.496 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.497 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.498 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Wide$int.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.499 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Wide$int.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.500 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Wide$int.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.501 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$Wide$int.remove\0A\00", align 1
@.faila.502 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.503 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.504 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Wide$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.505 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.506 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.507 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Wide$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.508 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.509 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.510 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Wide$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.511 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$Wide$int.remove\0A\00", align 1
@.faila.512 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.513 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.514 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$Wide$int.remove\0A\00", align 1
@.faila.515 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.516 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.517 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$Wide$int.remove\0A\00", align 1
@.faila.518 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.519 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.520 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$Wide$int.remove\0A\00", align 1
@.faila.521 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.522 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.523 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$Wide$int.remove\0A\00", align 1
@.faila.524 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.525 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.526 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Wide$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.527 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.528 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.529 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Wide$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.530 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.531 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.532 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Wide$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.533 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$Wide$int.keyArray\0A\00", align 1
@.faila.534 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.535 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.536 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$Wide$int.keyArray\0A\00", align 1
@.faila.537 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.538 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.539 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$Wide$int.keyArray\0A\00", align 1
@.faila.540 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.541 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.542 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$Wide$int.valueArray\0A\00", align 1
@.faila.543 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.544 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.545 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$Wide$int.valueArray\0A\00", align 1
@.faila.546 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.547 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.548 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$Wide$int.valueArray\0A\00", align 1
@.faila.549 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.550 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5501 = private constant [1 x i8] zeroinitializer
@.strobj.5502 = private global %String { i64 0, ptr @.strdata.5501, i64 0 }
@.strdata.5503 = private constant [1 x i8] zeroinitializer
@.strobj.5504 = private global %String { i64 0, ptr @.strdata.5503, i64 0 }

define internal void @Wide.Wide(ptr %0, i32 %1, i32 %2) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  store i32 %2, ptr %b, align 4
  %f1 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %a1 = load i32, ptr %a, align 4
  %b2 = load i32, ptr %b, align 4
  %3 = mul i32 %b2, 1
  %4 = add i32 %a1, %3
  store i32 %4, ptr %f1, align 4, !tbaa !0
  %f2 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %a3 = load i32, ptr %a, align 4
  %b4 = load i32, ptr %b, align 4
  %5 = mul i32 %b4, 2
  %6 = add i32 %a3, %5
  store i32 %6, ptr %f2, align 4, !tbaa !0
  %f3 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %a5 = load i32, ptr %a, align 4
  %b6 = load i32, ptr %b, align 4
  %7 = mul i32 %b6, 3
  %8 = add i32 %a5, %7
  store i32 %8, ptr %f3, align 4, !tbaa !0
  %f4 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %a7 = load i32, ptr %a, align 4
  %b8 = load i32, ptr %b, align 4
  %9 = mul i32 %b8, 4
  %10 = add i32 %a7, %9
  store i32 %10, ptr %f4, align 4, !tbaa !0
  %f5 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %a9 = load i32, ptr %a, align 4
  %b10 = load i32, ptr %b, align 4
  %11 = mul i32 %b10, 5
  %12 = add i32 %a9, %11
  store i32 %12, ptr %f5, align 4, !tbaa !0
  %f6 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %a11 = load i32, ptr %a, align 4
  %b12 = load i32, ptr %b, align 4
  %13 = mul i32 %b12, 6
  %14 = add i32 %a11, %13
  store i32 %14, ptr %f6, align 4, !tbaa !0
  %f7 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %a13 = load i32, ptr %a, align 4
  %b14 = load i32, ptr %b, align 4
  %15 = mul i32 %b14, 7
  %16 = add i32 %a13, %15
  store i32 %16, ptr %f7, align 4, !tbaa !0
  %f8 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %a15 = load i32, ptr %a, align 4
  %b16 = load i32, ptr %b, align 4
  %17 = mul i32 %b16, 8
  %18 = add i32 %a15, %17
  store i32 %18, ptr %f8, align 4, !tbaa !0
  %f9 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %a17 = load i32, ptr %a, align 4
  %b18 = load i32, ptr %b, align 4
  %19 = mul i32 %b18, 9
  %20 = add i32 %a17, %19
  store i32 %20, ptr %f9, align 4, !tbaa !0
  %f10 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %a19 = load i32, ptr %a, align 4
  %b20 = load i32, ptr %b, align 4
  %21 = mul i32 %b20, 10
  %22 = add i32 %a19, %21
  store i32 %22, ptr %f10, align 4, !tbaa !0
  %f11 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %a21 = load i32, ptr %a, align 4
  %b22 = load i32, ptr %b, align 4
  %23 = mul i32 %b22, 11
  %24 = add i32 %a21, %23
  store i32 %24, ptr %f11, align 4, !tbaa !0
  %f12 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %a23 = load i32, ptr %a, align 4
  %b24 = load i32, ptr %b, align 4
  %25 = mul i32 %b24, 12
  %26 = add i32 %a23, %25
  store i32 %26, ptr %f12, align 4, !tbaa !0
  %f13 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %a25 = load i32, ptr %a, align 4
  %b26 = load i32, ptr %b, align 4
  %27 = mul i32 %b26, 13
  %28 = add i32 %a25, %27
  store i32 %28, ptr %f13, align 4, !tbaa !0
  %f14 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %a27 = load i32, ptr %a, align 4
  %b28 = load i32, ptr %b, align 4
  %29 = mul i32 %b28, 14
  %30 = add i32 %a27, %29
  store i32 %30, ptr %f14, align 4, !tbaa !0
  %f15 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %a29 = load i32, ptr %a, align 4
  %b30 = load i32, ptr %b, align 4
  %31 = mul i32 %b30, 15
  %32 = add i32 %a29, %31
  store i32 %32, ptr %f15, align 4, !tbaa !0
  %f16 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %a31 = load i32, ptr %a, align 4
  %b32 = load i32, ptr %b, align 4
  %33 = mul i32 %b32, 16
  %34 = add i32 %a31, %33
  store i32 %34, ptr %f16, align 4, !tbaa !0
  %f17 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %a33 = load i32, ptr %a, align 4
  %b34 = load i32, ptr %b, align 4
  %35 = mul i32 %b34, 17
  %36 = add i32 %a33, %35
  store i32 %36, ptr %f17, align 4, !tbaa !0
  %f18 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %a35 = load i32, ptr %a, align 4
  %b36 = load i32, ptr %b, align 4
  %37 = mul i32 %b36, 18
  %38 = add i32 %a35, %37
  store i32 %38, ptr %f18, align 4, !tbaa !0
  %f19 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %a37 = load i32, ptr %a, align 4
  %b38 = load i32, ptr %b, align 4
  %39 = mul i32 %b38, 19
  %40 = add i32 %a37, %39
  store i32 %40, ptr %f19, align 4, !tbaa !0
  %f20 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %a39 = load i32, ptr %a, align 4
  %b40 = load i32, ptr %b, align 4
  %41 = mul i32 %b40, 20
  %42 = add i32 %a39, %41
  store i32 %42, ptr %f20, align 4, !tbaa !0
  %f21 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 20
  %a41 = load i32, ptr %a, align 4
  %b42 = load i32, ptr %b, align 4
  %43 = mul i32 %b42, 21
  %44 = add i32 %a41, %43
  store i32 %44, ptr %f21, align 4, !tbaa !0
  %f22 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 21
  %a43 = load i32, ptr %a, align 4
  %b44 = load i32, ptr %b, align 4
  %45 = mul i32 %b44, 22
  %46 = add i32 %a43, %45
  store i32 %46, ptr %f22, align 4, !tbaa !0
  %f23 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 22
  %a45 = load i32, ptr %a, align 4
  %b46 = load i32, ptr %b, align 4
  %47 = mul i32 %b46, 23
  %48 = add i32 %a45, %47
  store i32 %48, ptr %f23, align 4, !tbaa !0
  %f24 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 23
  %a47 = load i32, ptr %a, align 4
  %b48 = load i32, ptr %b, align 4
  %49 = mul i32 %b48, 24
  %50 = add i32 %a47, %49
  store i32 %50, ptr %f24, align 4, !tbaa !0
  %f25 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 24
  %a49 = load i32, ptr %a, align 4
  %b50 = load i32, ptr %b, align 4
  %51 = mul i32 %b50, 25
  %52 = add i32 %a49, %51
  store i32 %52, ptr %f25, align 4, !tbaa !0
  %f26 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 25
  %a51 = load i32, ptr %a, align 4
  %b52 = load i32, ptr %b, align 4
  %53 = mul i32 %b52, 26
  %54 = add i32 %a51, %53
  store i32 %54, ptr %f26, align 4, !tbaa !0
  ret void
}

define internal i32 @Wide.equalsKey(ptr nonnull align 4 dereferenceable(104) %0, ptr %1) {
entry:
  %Wide.copy = alloca %class.Wide, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %other, align 8
  %f1 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %f11 = load i32, ptr %f1, align 4, !tbaa !0
  %other2 = load ptr, ptr %other, align 8
  %f13 = getelementptr inbounds %class.Wide, ptr %other2, i32 0, i32 0
  %f14 = load i32, ptr %f13, align 4, !tbaa !0
  %3 = icmp eq i32 %f11, %f14
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %f2 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %f25 = load i32, ptr %f2, align 4, !tbaa !0
  %other6 = load ptr, ptr %other, align 8
  %f27 = getelementptr inbounds %class.Wide, ptr %other6, i32 0, i32 1
  %f28 = load i32, ptr %f27, align 4, !tbaa !0
  %5 = icmp eq i32 %f25, %f28
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  %sc.a9 = icmp ne i32 %7, 0
  br i1 %sc.a9, label %sc.rhs10, label %sc.end11

sc.rhs10:                                         ; preds = %sc.end
  %f3 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %f312 = load i32, ptr %f3, align 4, !tbaa !0
  %other13 = load ptr, ptr %other, align 8
  %f314 = getelementptr inbounds %class.Wide, ptr %other13, i32 0, i32 2
  %f315 = load i32, ptr %f314, align 4, !tbaa !0
  %8 = icmp eq i32 %f312, %f315
  %9 = zext i1 %8 to i32
  %sc.b16 = icmp ne i32 %9, 0
  br label %sc.end11

sc.end11:                                         ; preds = %sc.rhs10, %sc.end
  %sc17 = phi i1 [ false, %sc.end ], [ %sc.b16, %sc.rhs10 ]
  %10 = zext i1 %sc17 to i32
  %sc.a18 = icmp ne i32 %10, 0
  br i1 %sc.a18, label %sc.rhs19, label %sc.end20

sc.rhs19:                                         ; preds = %sc.end11
  %f4 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %f421 = load i32, ptr %f4, align 4, !tbaa !0
  %other22 = load ptr, ptr %other, align 8
  %f423 = getelementptr inbounds %class.Wide, ptr %other22, i32 0, i32 3
  %f424 = load i32, ptr %f423, align 4, !tbaa !0
  %11 = icmp eq i32 %f421, %f424
  %12 = zext i1 %11 to i32
  %sc.b25 = icmp ne i32 %12, 0
  br label %sc.end20

sc.end20:                                         ; preds = %sc.rhs19, %sc.end11
  %sc26 = phi i1 [ false, %sc.end11 ], [ %sc.b25, %sc.rhs19 ]
  %13 = zext i1 %sc26 to i32
  %sc.a27 = icmp ne i32 %13, 0
  br i1 %sc.a27, label %sc.rhs28, label %sc.end29

sc.rhs28:                                         ; preds = %sc.end20
  %f5 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %f530 = load i32, ptr %f5, align 4, !tbaa !0
  %other31 = load ptr, ptr %other, align 8
  %f532 = getelementptr inbounds %class.Wide, ptr %other31, i32 0, i32 4
  %f533 = load i32, ptr %f532, align 4, !tbaa !0
  %14 = icmp eq i32 %f530, %f533
  %15 = zext i1 %14 to i32
  %sc.b34 = icmp ne i32 %15, 0
  br label %sc.end29

sc.end29:                                         ; preds = %sc.rhs28, %sc.end20
  %sc35 = phi i1 [ false, %sc.end20 ], [ %sc.b34, %sc.rhs28 ]
  %16 = zext i1 %sc35 to i32
  %sc.a36 = icmp ne i32 %16, 0
  br i1 %sc.a36, label %sc.rhs37, label %sc.end38

sc.rhs37:                                         ; preds = %sc.end29
  %f6 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %f639 = load i32, ptr %f6, align 4, !tbaa !0
  %other40 = load ptr, ptr %other, align 8
  %f641 = getelementptr inbounds %class.Wide, ptr %other40, i32 0, i32 5
  %f642 = load i32, ptr %f641, align 4, !tbaa !0
  %17 = icmp eq i32 %f639, %f642
  %18 = zext i1 %17 to i32
  %sc.b43 = icmp ne i32 %18, 0
  br label %sc.end38

sc.end38:                                         ; preds = %sc.rhs37, %sc.end29
  %sc44 = phi i1 [ false, %sc.end29 ], [ %sc.b43, %sc.rhs37 ]
  %19 = zext i1 %sc44 to i32
  %sc.a45 = icmp ne i32 %19, 0
  br i1 %sc.a45, label %sc.rhs46, label %sc.end47

sc.rhs46:                                         ; preds = %sc.end38
  %f7 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %f748 = load i32, ptr %f7, align 4, !tbaa !0
  %other49 = load ptr, ptr %other, align 8
  %f750 = getelementptr inbounds %class.Wide, ptr %other49, i32 0, i32 6
  %f751 = load i32, ptr %f750, align 4, !tbaa !0
  %20 = icmp eq i32 %f748, %f751
  %21 = zext i1 %20 to i32
  %sc.b52 = icmp ne i32 %21, 0
  br label %sc.end47

sc.end47:                                         ; preds = %sc.rhs46, %sc.end38
  %sc53 = phi i1 [ false, %sc.end38 ], [ %sc.b52, %sc.rhs46 ]
  %22 = zext i1 %sc53 to i32
  %sc.a54 = icmp ne i32 %22, 0
  br i1 %sc.a54, label %sc.rhs55, label %sc.end56

sc.rhs55:                                         ; preds = %sc.end47
  %f8 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %f857 = load i32, ptr %f8, align 4, !tbaa !0
  %other58 = load ptr, ptr %other, align 8
  %f859 = getelementptr inbounds %class.Wide, ptr %other58, i32 0, i32 7
  %f860 = load i32, ptr %f859, align 4, !tbaa !0
  %23 = icmp eq i32 %f857, %f860
  %24 = zext i1 %23 to i32
  %sc.b61 = icmp ne i32 %24, 0
  br label %sc.end56

sc.end56:                                         ; preds = %sc.rhs55, %sc.end47
  %sc62 = phi i1 [ false, %sc.end47 ], [ %sc.b61, %sc.rhs55 ]
  %25 = zext i1 %sc62 to i32
  %sc.a63 = icmp ne i32 %25, 0
  br i1 %sc.a63, label %sc.rhs64, label %sc.end65

sc.rhs64:                                         ; preds = %sc.end56
  %f9 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %f966 = load i32, ptr %f9, align 4, !tbaa !0
  %other67 = load ptr, ptr %other, align 8
  %f968 = getelementptr inbounds %class.Wide, ptr %other67, i32 0, i32 8
  %f969 = load i32, ptr %f968, align 4, !tbaa !0
  %26 = icmp eq i32 %f966, %f969
  %27 = zext i1 %26 to i32
  %sc.b70 = icmp ne i32 %27, 0
  br label %sc.end65

sc.end65:                                         ; preds = %sc.rhs64, %sc.end56
  %sc71 = phi i1 [ false, %sc.end56 ], [ %sc.b70, %sc.rhs64 ]
  %28 = zext i1 %sc71 to i32
  %sc.a72 = icmp ne i32 %28, 0
  br i1 %sc.a72, label %sc.rhs73, label %sc.end74

sc.rhs73:                                         ; preds = %sc.end65
  %f10 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %f1075 = load i32, ptr %f10, align 4, !tbaa !0
  %other76 = load ptr, ptr %other, align 8
  %f1077 = getelementptr inbounds %class.Wide, ptr %other76, i32 0, i32 9
  %f1078 = load i32, ptr %f1077, align 4, !tbaa !0
  %29 = icmp eq i32 %f1075, %f1078
  %30 = zext i1 %29 to i32
  %sc.b79 = icmp ne i32 %30, 0
  br label %sc.end74

sc.end74:                                         ; preds = %sc.rhs73, %sc.end65
  %sc80 = phi i1 [ false, %sc.end65 ], [ %sc.b79, %sc.rhs73 ]
  %31 = zext i1 %sc80 to i32
  %sc.a81 = icmp ne i32 %31, 0
  br i1 %sc.a81, label %sc.rhs82, label %sc.end83

sc.rhs82:                                         ; preds = %sc.end74
  %f1184 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %f1185 = load i32, ptr %f1184, align 4, !tbaa !0
  %other86 = load ptr, ptr %other, align 8
  %f1187 = getelementptr inbounds %class.Wide, ptr %other86, i32 0, i32 10
  %f1188 = load i32, ptr %f1187, align 4, !tbaa !0
  %32 = icmp eq i32 %f1185, %f1188
  %33 = zext i1 %32 to i32
  %sc.b89 = icmp ne i32 %33, 0
  br label %sc.end83

sc.end83:                                         ; preds = %sc.rhs82, %sc.end74
  %sc90 = phi i1 [ false, %sc.end74 ], [ %sc.b89, %sc.rhs82 ]
  %34 = zext i1 %sc90 to i32
  %sc.a91 = icmp ne i32 %34, 0
  br i1 %sc.a91, label %sc.rhs92, label %sc.end93

sc.rhs92:                                         ; preds = %sc.end83
  %f12 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %f1294 = load i32, ptr %f12, align 4, !tbaa !0
  %other95 = load ptr, ptr %other, align 8
  %f1296 = getelementptr inbounds %class.Wide, ptr %other95, i32 0, i32 11
  %f1297 = load i32, ptr %f1296, align 4, !tbaa !0
  %35 = icmp eq i32 %f1294, %f1297
  %36 = zext i1 %35 to i32
  %sc.b98 = icmp ne i32 %36, 0
  br label %sc.end93

sc.end93:                                         ; preds = %sc.rhs92, %sc.end83
  %sc99 = phi i1 [ false, %sc.end83 ], [ %sc.b98, %sc.rhs92 ]
  %37 = zext i1 %sc99 to i32
  %sc.a100 = icmp ne i32 %37, 0
  br i1 %sc.a100, label %sc.rhs101, label %sc.end102

sc.rhs101:                                        ; preds = %sc.end93
  %f13103 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %f13104 = load i32, ptr %f13103, align 4, !tbaa !0
  %other105 = load ptr, ptr %other, align 8
  %f13106 = getelementptr inbounds %class.Wide, ptr %other105, i32 0, i32 12
  %f13107 = load i32, ptr %f13106, align 4, !tbaa !0
  %38 = icmp eq i32 %f13104, %f13107
  %39 = zext i1 %38 to i32
  %sc.b108 = icmp ne i32 %39, 0
  br label %sc.end102

sc.end102:                                        ; preds = %sc.rhs101, %sc.end93
  %sc109 = phi i1 [ false, %sc.end93 ], [ %sc.b108, %sc.rhs101 ]
  %40 = zext i1 %sc109 to i32
  %sc.a110 = icmp ne i32 %40, 0
  br i1 %sc.a110, label %sc.rhs111, label %sc.end112

sc.rhs111:                                        ; preds = %sc.end102
  %f14113 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %f14114 = load i32, ptr %f14113, align 4, !tbaa !0
  %other115 = load ptr, ptr %other, align 8
  %f14116 = getelementptr inbounds %class.Wide, ptr %other115, i32 0, i32 13
  %f14117 = load i32, ptr %f14116, align 4, !tbaa !0
  %41 = icmp eq i32 %f14114, %f14117
  %42 = zext i1 %41 to i32
  %sc.b118 = icmp ne i32 %42, 0
  br label %sc.end112

sc.end112:                                        ; preds = %sc.rhs111, %sc.end102
  %sc119 = phi i1 [ false, %sc.end102 ], [ %sc.b118, %sc.rhs111 ]
  %43 = zext i1 %sc119 to i32
  %sc.a120 = icmp ne i32 %43, 0
  br i1 %sc.a120, label %sc.rhs121, label %sc.end122

sc.rhs121:                                        ; preds = %sc.end112
  %f15 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %f15123 = load i32, ptr %f15, align 4, !tbaa !0
  %other124 = load ptr, ptr %other, align 8
  %f15125 = getelementptr inbounds %class.Wide, ptr %other124, i32 0, i32 14
  %f15126 = load i32, ptr %f15125, align 4, !tbaa !0
  %44 = icmp eq i32 %f15123, %f15126
  %45 = zext i1 %44 to i32
  %sc.b127 = icmp ne i32 %45, 0
  br label %sc.end122

sc.end122:                                        ; preds = %sc.rhs121, %sc.end112
  %sc128 = phi i1 [ false, %sc.end112 ], [ %sc.b127, %sc.rhs121 ]
  %46 = zext i1 %sc128 to i32
  %sc.a129 = icmp ne i32 %46, 0
  br i1 %sc.a129, label %sc.rhs130, label %sc.end131

sc.rhs130:                                        ; preds = %sc.end122
  %f16 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %f16132 = load i32, ptr %f16, align 4, !tbaa !0
  %other133 = load ptr, ptr %other, align 8
  %f16134 = getelementptr inbounds %class.Wide, ptr %other133, i32 0, i32 15
  %f16135 = load i32, ptr %f16134, align 4, !tbaa !0
  %47 = icmp eq i32 %f16132, %f16135
  %48 = zext i1 %47 to i32
  %sc.b136 = icmp ne i32 %48, 0
  br label %sc.end131

sc.end131:                                        ; preds = %sc.rhs130, %sc.end122
  %sc137 = phi i1 [ false, %sc.end122 ], [ %sc.b136, %sc.rhs130 ]
  %49 = zext i1 %sc137 to i32
  %sc.a138 = icmp ne i32 %49, 0
  br i1 %sc.a138, label %sc.rhs139, label %sc.end140

sc.rhs139:                                        ; preds = %sc.end131
  %f17 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %f17141 = load i32, ptr %f17, align 4, !tbaa !0
  %other142 = load ptr, ptr %other, align 8
  %f17143 = getelementptr inbounds %class.Wide, ptr %other142, i32 0, i32 16
  %f17144 = load i32, ptr %f17143, align 4, !tbaa !0
  %50 = icmp eq i32 %f17141, %f17144
  %51 = zext i1 %50 to i32
  %sc.b145 = icmp ne i32 %51, 0
  br label %sc.end140

sc.end140:                                        ; preds = %sc.rhs139, %sc.end131
  %sc146 = phi i1 [ false, %sc.end131 ], [ %sc.b145, %sc.rhs139 ]
  %52 = zext i1 %sc146 to i32
  %sc.a147 = icmp ne i32 %52, 0
  br i1 %sc.a147, label %sc.rhs148, label %sc.end149

sc.rhs148:                                        ; preds = %sc.end140
  %f18 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %f18150 = load i32, ptr %f18, align 4, !tbaa !0
  %other151 = load ptr, ptr %other, align 8
  %f18152 = getelementptr inbounds %class.Wide, ptr %other151, i32 0, i32 17
  %f18153 = load i32, ptr %f18152, align 4, !tbaa !0
  %53 = icmp eq i32 %f18150, %f18153
  %54 = zext i1 %53 to i32
  %sc.b154 = icmp ne i32 %54, 0
  br label %sc.end149

sc.end149:                                        ; preds = %sc.rhs148, %sc.end140
  %sc155 = phi i1 [ false, %sc.end140 ], [ %sc.b154, %sc.rhs148 ]
  %55 = zext i1 %sc155 to i32
  %sc.a156 = icmp ne i32 %55, 0
  br i1 %sc.a156, label %sc.rhs157, label %sc.end158

sc.rhs157:                                        ; preds = %sc.end149
  %f19 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %f19159 = load i32, ptr %f19, align 4, !tbaa !0
  %other160 = load ptr, ptr %other, align 8
  %f19161 = getelementptr inbounds %class.Wide, ptr %other160, i32 0, i32 18
  %f19162 = load i32, ptr %f19161, align 4, !tbaa !0
  %56 = icmp eq i32 %f19159, %f19162
  %57 = zext i1 %56 to i32
  %sc.b163 = icmp ne i32 %57, 0
  br label %sc.end158

sc.end158:                                        ; preds = %sc.rhs157, %sc.end149
  %sc164 = phi i1 [ false, %sc.end149 ], [ %sc.b163, %sc.rhs157 ]
  %58 = zext i1 %sc164 to i32
  %sc.a165 = icmp ne i32 %58, 0
  br i1 %sc.a165, label %sc.rhs166, label %sc.end167

sc.rhs166:                                        ; preds = %sc.end158
  %f20 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %f20168 = load i32, ptr %f20, align 4, !tbaa !0
  %other169 = load ptr, ptr %other, align 8
  %f20170 = getelementptr inbounds %class.Wide, ptr %other169, i32 0, i32 19
  %f20171 = load i32, ptr %f20170, align 4, !tbaa !0
  %59 = icmp eq i32 %f20168, %f20171
  %60 = zext i1 %59 to i32
  %sc.b172 = icmp ne i32 %60, 0
  br label %sc.end167

sc.end167:                                        ; preds = %sc.rhs166, %sc.end158
  %sc173 = phi i1 [ false, %sc.end158 ], [ %sc.b172, %sc.rhs166 ]
  %61 = zext i1 %sc173 to i32
  %sc.a174 = icmp ne i32 %61, 0
  br i1 %sc.a174, label %sc.rhs175, label %sc.end176

sc.rhs175:                                        ; preds = %sc.end167
  %f21 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 20
  %f21177 = load i32, ptr %f21, align 4, !tbaa !0
  %other178 = load ptr, ptr %other, align 8
  %f21179 = getelementptr inbounds %class.Wide, ptr %other178, i32 0, i32 20
  %f21180 = load i32, ptr %f21179, align 4, !tbaa !0
  %62 = icmp eq i32 %f21177, %f21180
  %63 = zext i1 %62 to i32
  %sc.b181 = icmp ne i32 %63, 0
  br label %sc.end176

sc.end176:                                        ; preds = %sc.rhs175, %sc.end167
  %sc182 = phi i1 [ false, %sc.end167 ], [ %sc.b181, %sc.rhs175 ]
  %64 = zext i1 %sc182 to i32
  %sc.a183 = icmp ne i32 %64, 0
  br i1 %sc.a183, label %sc.rhs184, label %sc.end185

sc.rhs184:                                        ; preds = %sc.end176
  %f22 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 21
  %f22186 = load i32, ptr %f22, align 4, !tbaa !0
  %other187 = load ptr, ptr %other, align 8
  %f22188 = getelementptr inbounds %class.Wide, ptr %other187, i32 0, i32 21
  %f22189 = load i32, ptr %f22188, align 4, !tbaa !0
  %65 = icmp eq i32 %f22186, %f22189
  %66 = zext i1 %65 to i32
  %sc.b190 = icmp ne i32 %66, 0
  br label %sc.end185

sc.end185:                                        ; preds = %sc.rhs184, %sc.end176
  %sc191 = phi i1 [ false, %sc.end176 ], [ %sc.b190, %sc.rhs184 ]
  %67 = zext i1 %sc191 to i32
  %sc.a192 = icmp ne i32 %67, 0
  br i1 %sc.a192, label %sc.rhs193, label %sc.end194

sc.rhs193:                                        ; preds = %sc.end185
  %f23 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 22
  %f23195 = load i32, ptr %f23, align 4, !tbaa !0
  %other196 = load ptr, ptr %other, align 8
  %f23197 = getelementptr inbounds %class.Wide, ptr %other196, i32 0, i32 22
  %f23198 = load i32, ptr %f23197, align 4, !tbaa !0
  %68 = icmp eq i32 %f23195, %f23198
  %69 = zext i1 %68 to i32
  %sc.b199 = icmp ne i32 %69, 0
  br label %sc.end194

sc.end194:                                        ; preds = %sc.rhs193, %sc.end185
  %sc200 = phi i1 [ false, %sc.end185 ], [ %sc.b199, %sc.rhs193 ]
  %70 = zext i1 %sc200 to i32
  %sc.a201 = icmp ne i32 %70, 0
  br i1 %sc.a201, label %sc.rhs202, label %sc.end203

sc.rhs202:                                        ; preds = %sc.end194
  %f24 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 23
  %f24204 = load i32, ptr %f24, align 4, !tbaa !0
  %other205 = load ptr, ptr %other, align 8
  %f24206 = getelementptr inbounds %class.Wide, ptr %other205, i32 0, i32 23
  %f24207 = load i32, ptr %f24206, align 4, !tbaa !0
  %71 = icmp eq i32 %f24204, %f24207
  %72 = zext i1 %71 to i32
  %sc.b208 = icmp ne i32 %72, 0
  br label %sc.end203

sc.end203:                                        ; preds = %sc.rhs202, %sc.end194
  %sc209 = phi i1 [ false, %sc.end194 ], [ %sc.b208, %sc.rhs202 ]
  %73 = zext i1 %sc209 to i32
  %sc.a210 = icmp ne i32 %73, 0
  br i1 %sc.a210, label %sc.rhs211, label %sc.end212

sc.rhs211:                                        ; preds = %sc.end203
  %f25213 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 24
  %f25214 = load i32, ptr %f25213, align 4, !tbaa !0
  %other215 = load ptr, ptr %other, align 8
  %f25216 = getelementptr inbounds %class.Wide, ptr %other215, i32 0, i32 24
  %f25217 = load i32, ptr %f25216, align 4, !tbaa !0
  %74 = icmp eq i32 %f25214, %f25217
  %75 = zext i1 %74 to i32
  %sc.b218 = icmp ne i32 %75, 0
  br label %sc.end212

sc.end212:                                        ; preds = %sc.rhs211, %sc.end203
  %sc219 = phi i1 [ false, %sc.end203 ], [ %sc.b218, %sc.rhs211 ]
  %76 = zext i1 %sc219 to i32
  %sc.a220 = icmp ne i32 %76, 0
  br i1 %sc.a220, label %sc.rhs221, label %sc.end222

sc.rhs221:                                        ; preds = %sc.end212
  %f26 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 25
  %f26223 = load i32, ptr %f26, align 4, !tbaa !0
  %other224 = load ptr, ptr %other, align 8
  %f26225 = getelementptr inbounds %class.Wide, ptr %other224, i32 0, i32 25
  %f26226 = load i32, ptr %f26225, align 4, !tbaa !0
  %77 = icmp eq i32 %f26223, %f26226
  %78 = zext i1 %77 to i32
  %sc.b227 = icmp ne i32 %78, 0
  br label %sc.end222

sc.end222:                                        ; preds = %sc.rhs221, %sc.end212
  %sc228 = phi i1 [ false, %sc.end212 ], [ %sc.b227, %sc.rhs221 ]
  %79 = zext i1 %sc228 to i32
  ret i32 %79
}

define internal i64 @Wide.hash(ptr nonnull align 4 dereferenceable(104) %0) {
entry:
  %f1 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %f11 = load i32, ptr %f1, align 4, !tbaa !0
  %1 = sext i32 %f11 to i64
  %2 = add i64 527, %1
  %3 = mul i64 %2, 31
  %f2 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %f22 = load i32, ptr %f2, align 4, !tbaa !0
  %4 = sext i32 %f22 to i64
  %5 = add i64 %3, %4
  %6 = mul i64 %5, 31
  %f3 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %f33 = load i32, ptr %f3, align 4, !tbaa !0
  %7 = sext i32 %f33 to i64
  %8 = add i64 %6, %7
  %9 = mul i64 %8, 31
  %f4 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %f44 = load i32, ptr %f4, align 4, !tbaa !0
  %10 = sext i32 %f44 to i64
  %11 = add i64 %9, %10
  %12 = mul i64 %11, 31
  %f5 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %f55 = load i32, ptr %f5, align 4, !tbaa !0
  %13 = sext i32 %f55 to i64
  %14 = add i64 %12, %13
  %15 = mul i64 %14, 31
  %f6 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %f66 = load i32, ptr %f6, align 4, !tbaa !0
  %16 = sext i32 %f66 to i64
  %17 = add i64 %15, %16
  %18 = mul i64 %17, 31
  %f7 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %f77 = load i32, ptr %f7, align 4, !tbaa !0
  %19 = sext i32 %f77 to i64
  %20 = add i64 %18, %19
  %21 = mul i64 %20, 31
  %f8 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %f88 = load i32, ptr %f8, align 4, !tbaa !0
  %22 = sext i32 %f88 to i64
  %23 = add i64 %21, %22
  %24 = mul i64 %23, 31
  %f9 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %f99 = load i32, ptr %f9, align 4, !tbaa !0
  %25 = sext i32 %f99 to i64
  %26 = add i64 %24, %25
  %27 = mul i64 %26, 31
  %f10 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %f1010 = load i32, ptr %f10, align 4, !tbaa !0
  %28 = sext i32 %f1010 to i64
  %29 = add i64 %27, %28
  %30 = mul i64 %29, 31
  %f1111 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %f1112 = load i32, ptr %f1111, align 4, !tbaa !0
  %31 = sext i32 %f1112 to i64
  %32 = add i64 %30, %31
  %33 = mul i64 %32, 31
  %f12 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %f1213 = load i32, ptr %f12, align 4, !tbaa !0
  %34 = sext i32 %f1213 to i64
  %35 = add i64 %33, %34
  %36 = mul i64 %35, 31
  %f13 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %f1314 = load i32, ptr %f13, align 4, !tbaa !0
  %37 = sext i32 %f1314 to i64
  %38 = add i64 %36, %37
  %39 = mul i64 %38, 31
  %f14 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %f1415 = load i32, ptr %f14, align 4, !tbaa !0
  %40 = sext i32 %f1415 to i64
  %41 = add i64 %39, %40
  %42 = mul i64 %41, 31
  %f15 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %f1516 = load i32, ptr %f15, align 4, !tbaa !0
  %43 = sext i32 %f1516 to i64
  %44 = add i64 %42, %43
  %45 = mul i64 %44, 31
  %f16 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %f1617 = load i32, ptr %f16, align 4, !tbaa !0
  %46 = sext i32 %f1617 to i64
  %47 = add i64 %45, %46
  %48 = mul i64 %47, 31
  %f17 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %f1718 = load i32, ptr %f17, align 4, !tbaa !0
  %49 = sext i32 %f1718 to i64
  %50 = add i64 %48, %49
  %51 = mul i64 %50, 31
  %f18 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %f1819 = load i32, ptr %f18, align 4, !tbaa !0
  %52 = sext i32 %f1819 to i64
  %53 = add i64 %51, %52
  %54 = mul i64 %53, 31
  %f19 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %f1920 = load i32, ptr %f19, align 4, !tbaa !0
  %55 = sext i32 %f1920 to i64
  %56 = add i64 %54, %55
  %57 = mul i64 %56, 31
  %f20 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %f2021 = load i32, ptr %f20, align 4, !tbaa !0
  %58 = sext i32 %f2021 to i64
  %59 = add i64 %57, %58
  %60 = mul i64 %59, 31
  %f21 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 20
  %f2122 = load i32, ptr %f21, align 4, !tbaa !0
  %61 = sext i32 %f2122 to i64
  %62 = add i64 %60, %61
  %63 = mul i64 %62, 31
  %f2223 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 21
  %f2224 = load i32, ptr %f2223, align 4, !tbaa !0
  %64 = sext i32 %f2224 to i64
  %65 = add i64 %63, %64
  %66 = mul i64 %65, 31
  %f23 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 22
  %f2325 = load i32, ptr %f23, align 4, !tbaa !0
  %67 = sext i32 %f2325 to i64
  %68 = add i64 %66, %67
  %69 = mul i64 %68, 31
  %f24 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 23
  %f2426 = load i32, ptr %f24, align 4, !tbaa !0
  %70 = sext i32 %f2426 to i64
  %71 = add i64 %69, %70
  %72 = mul i64 %71, 31
  %f25 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 24
  %f2527 = load i32, ptr %f25, align 4, !tbaa !0
  %73 = sext i32 %f2527 to i64
  %74 = add i64 %72, %73
  %75 = mul i64 %74, 31
  %f26 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 25
  %f2628 = load i32, ptr %f26, align 4, !tbaa !0
  %76 = sext i32 %f2628 to i64
  %77 = add i64 %75, %76
  ret i64 %77
}

define internal i32 @Wide.compareTo(ptr nonnull align 4 dereferenceable(104) %0, ptr %1) {
entry:
  %Wide.copy = alloca %class.Wide, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %other, align 8
  %f1 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %f11 = load i32, ptr %f1, align 4, !tbaa !0
  %other2 = load ptr, ptr %other, align 8
  %f13 = getelementptr inbounds %class.Wide, ptr %other2, i32 0, i32 0
  %f14 = load i32, ptr %f13, align 4, !tbaa !0
  %3 = icmp slt i32 %f11, %f14
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 -1

if.end:                                           ; preds = %entry
  %f15 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 0
  %f16 = load i32, ptr %f15, align 4, !tbaa !0
  %other7 = load ptr, ptr %other, align 8
  %f18 = getelementptr inbounds %class.Wide, ptr %other7, i32 0, i32 0
  %f19 = load i32, ptr %f18, align 4, !tbaa !0
  %5 = icmp sgt i32 %f16, %f19
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then10, label %if.end11

if.then10:                                        ; preds = %if.end
  ret i32 1

if.end11:                                         ; preds = %if.end
  %f2 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %f212 = load i32, ptr %f2, align 4, !tbaa !0
  %other13 = load ptr, ptr %other, align 8
  %f214 = getelementptr inbounds %class.Wide, ptr %other13, i32 0, i32 1
  %f215 = load i32, ptr %f214, align 4, !tbaa !0
  %7 = icmp slt i32 %f212, %f215
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then16, label %if.end17

if.then16:                                        ; preds = %if.end11
  ret i32 -1

if.end17:                                         ; preds = %if.end11
  %f218 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 1
  %f219 = load i32, ptr %f218, align 4, !tbaa !0
  %other20 = load ptr, ptr %other, align 8
  %f221 = getelementptr inbounds %class.Wide, ptr %other20, i32 0, i32 1
  %f222 = load i32, ptr %f221, align 4, !tbaa !0
  %9 = icmp sgt i32 %f219, %f222
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end17
  ret i32 1

if.end24:                                         ; preds = %if.end17
  %f3 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %f325 = load i32, ptr %f3, align 4, !tbaa !0
  %other26 = load ptr, ptr %other, align 8
  %f327 = getelementptr inbounds %class.Wide, ptr %other26, i32 0, i32 2
  %f328 = load i32, ptr %f327, align 4, !tbaa !0
  %11 = icmp slt i32 %f325, %f328
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then29, label %if.end30

if.then29:                                        ; preds = %if.end24
  ret i32 -1

if.end30:                                         ; preds = %if.end24
  %f331 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 2
  %f332 = load i32, ptr %f331, align 4, !tbaa !0
  %other33 = load ptr, ptr %other, align 8
  %f334 = getelementptr inbounds %class.Wide, ptr %other33, i32 0, i32 2
  %f335 = load i32, ptr %f334, align 4, !tbaa !0
  %13 = icmp sgt i32 %f332, %f335
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then36, label %if.end37

if.then36:                                        ; preds = %if.end30
  ret i32 1

if.end37:                                         ; preds = %if.end30
  %f4 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %f438 = load i32, ptr %f4, align 4, !tbaa !0
  %other39 = load ptr, ptr %other, align 8
  %f440 = getelementptr inbounds %class.Wide, ptr %other39, i32 0, i32 3
  %f441 = load i32, ptr %f440, align 4, !tbaa !0
  %15 = icmp slt i32 %f438, %f441
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then42, label %if.end43

if.then42:                                        ; preds = %if.end37
  ret i32 -1

if.end43:                                         ; preds = %if.end37
  %f444 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 3
  %f445 = load i32, ptr %f444, align 4, !tbaa !0
  %other46 = load ptr, ptr %other, align 8
  %f447 = getelementptr inbounds %class.Wide, ptr %other46, i32 0, i32 3
  %f448 = load i32, ptr %f447, align 4, !tbaa !0
  %17 = icmp sgt i32 %f445, %f448
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then49, label %if.end50

if.then49:                                        ; preds = %if.end43
  ret i32 1

if.end50:                                         ; preds = %if.end43
  %f5 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %f551 = load i32, ptr %f5, align 4, !tbaa !0
  %other52 = load ptr, ptr %other, align 8
  %f553 = getelementptr inbounds %class.Wide, ptr %other52, i32 0, i32 4
  %f554 = load i32, ptr %f553, align 4, !tbaa !0
  %19 = icmp slt i32 %f551, %f554
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then55, label %if.end56

if.then55:                                        ; preds = %if.end50
  ret i32 -1

if.end56:                                         ; preds = %if.end50
  %f557 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 4
  %f558 = load i32, ptr %f557, align 4, !tbaa !0
  %other59 = load ptr, ptr %other, align 8
  %f560 = getelementptr inbounds %class.Wide, ptr %other59, i32 0, i32 4
  %f561 = load i32, ptr %f560, align 4, !tbaa !0
  %21 = icmp sgt i32 %f558, %f561
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then62, label %if.end63

if.then62:                                        ; preds = %if.end56
  ret i32 1

if.end63:                                         ; preds = %if.end56
  %f6 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %f664 = load i32, ptr %f6, align 4, !tbaa !0
  %other65 = load ptr, ptr %other, align 8
  %f666 = getelementptr inbounds %class.Wide, ptr %other65, i32 0, i32 5
  %f667 = load i32, ptr %f666, align 4, !tbaa !0
  %23 = icmp slt i32 %f664, %f667
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then68, label %if.end69

if.then68:                                        ; preds = %if.end63
  ret i32 -1

if.end69:                                         ; preds = %if.end63
  %f670 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 5
  %f671 = load i32, ptr %f670, align 4, !tbaa !0
  %other72 = load ptr, ptr %other, align 8
  %f673 = getelementptr inbounds %class.Wide, ptr %other72, i32 0, i32 5
  %f674 = load i32, ptr %f673, align 4, !tbaa !0
  %25 = icmp sgt i32 %f671, %f674
  %26 = zext i1 %25 to i32
  br i1 %25, label %if.then75, label %if.end76

if.then75:                                        ; preds = %if.end69
  ret i32 1

if.end76:                                         ; preds = %if.end69
  %f7 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %f777 = load i32, ptr %f7, align 4, !tbaa !0
  %other78 = load ptr, ptr %other, align 8
  %f779 = getelementptr inbounds %class.Wide, ptr %other78, i32 0, i32 6
  %f780 = load i32, ptr %f779, align 4, !tbaa !0
  %27 = icmp slt i32 %f777, %f780
  %28 = zext i1 %27 to i32
  br i1 %27, label %if.then81, label %if.end82

if.then81:                                        ; preds = %if.end76
  ret i32 -1

if.end82:                                         ; preds = %if.end76
  %f783 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 6
  %f784 = load i32, ptr %f783, align 4, !tbaa !0
  %other85 = load ptr, ptr %other, align 8
  %f786 = getelementptr inbounds %class.Wide, ptr %other85, i32 0, i32 6
  %f787 = load i32, ptr %f786, align 4, !tbaa !0
  %29 = icmp sgt i32 %f784, %f787
  %30 = zext i1 %29 to i32
  br i1 %29, label %if.then88, label %if.end89

if.then88:                                        ; preds = %if.end82
  ret i32 1

if.end89:                                         ; preds = %if.end82
  %f8 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %f890 = load i32, ptr %f8, align 4, !tbaa !0
  %other91 = load ptr, ptr %other, align 8
  %f892 = getelementptr inbounds %class.Wide, ptr %other91, i32 0, i32 7
  %f893 = load i32, ptr %f892, align 4, !tbaa !0
  %31 = icmp slt i32 %f890, %f893
  %32 = zext i1 %31 to i32
  br i1 %31, label %if.then94, label %if.end95

if.then94:                                        ; preds = %if.end89
  ret i32 -1

if.end95:                                         ; preds = %if.end89
  %f896 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 7
  %f897 = load i32, ptr %f896, align 4, !tbaa !0
  %other98 = load ptr, ptr %other, align 8
  %f899 = getelementptr inbounds %class.Wide, ptr %other98, i32 0, i32 7
  %f8100 = load i32, ptr %f899, align 4, !tbaa !0
  %33 = icmp sgt i32 %f897, %f8100
  %34 = zext i1 %33 to i32
  br i1 %33, label %if.then101, label %if.end102

if.then101:                                       ; preds = %if.end95
  ret i32 1

if.end102:                                        ; preds = %if.end95
  %f9 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %f9103 = load i32, ptr %f9, align 4, !tbaa !0
  %other104 = load ptr, ptr %other, align 8
  %f9105 = getelementptr inbounds %class.Wide, ptr %other104, i32 0, i32 8
  %f9106 = load i32, ptr %f9105, align 4, !tbaa !0
  %35 = icmp slt i32 %f9103, %f9106
  %36 = zext i1 %35 to i32
  br i1 %35, label %if.then107, label %if.end108

if.then107:                                       ; preds = %if.end102
  ret i32 -1

if.end108:                                        ; preds = %if.end102
  %f9109 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 8
  %f9110 = load i32, ptr %f9109, align 4, !tbaa !0
  %other111 = load ptr, ptr %other, align 8
  %f9112 = getelementptr inbounds %class.Wide, ptr %other111, i32 0, i32 8
  %f9113 = load i32, ptr %f9112, align 4, !tbaa !0
  %37 = icmp sgt i32 %f9110, %f9113
  %38 = zext i1 %37 to i32
  br i1 %37, label %if.then114, label %if.end115

if.then114:                                       ; preds = %if.end108
  ret i32 1

if.end115:                                        ; preds = %if.end108
  %f10 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %f10116 = load i32, ptr %f10, align 4, !tbaa !0
  %other117 = load ptr, ptr %other, align 8
  %f10118 = getelementptr inbounds %class.Wide, ptr %other117, i32 0, i32 9
  %f10119 = load i32, ptr %f10118, align 4, !tbaa !0
  %39 = icmp slt i32 %f10116, %f10119
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then120, label %if.end121

if.then120:                                       ; preds = %if.end115
  ret i32 -1

if.end121:                                        ; preds = %if.end115
  %f10122 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 9
  %f10123 = load i32, ptr %f10122, align 4, !tbaa !0
  %other124 = load ptr, ptr %other, align 8
  %f10125 = getelementptr inbounds %class.Wide, ptr %other124, i32 0, i32 9
  %f10126 = load i32, ptr %f10125, align 4, !tbaa !0
  %41 = icmp sgt i32 %f10123, %f10126
  %42 = zext i1 %41 to i32
  br i1 %41, label %if.then127, label %if.end128

if.then127:                                       ; preds = %if.end121
  ret i32 1

if.end128:                                        ; preds = %if.end121
  %f11129 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %f11130 = load i32, ptr %f11129, align 4, !tbaa !0
  %other131 = load ptr, ptr %other, align 8
  %f11132 = getelementptr inbounds %class.Wide, ptr %other131, i32 0, i32 10
  %f11133 = load i32, ptr %f11132, align 4, !tbaa !0
  %43 = icmp slt i32 %f11130, %f11133
  %44 = zext i1 %43 to i32
  br i1 %43, label %if.then134, label %if.end135

if.then134:                                       ; preds = %if.end128
  ret i32 -1

if.end135:                                        ; preds = %if.end128
  %f11136 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 10
  %f11137 = load i32, ptr %f11136, align 4, !tbaa !0
  %other138 = load ptr, ptr %other, align 8
  %f11139 = getelementptr inbounds %class.Wide, ptr %other138, i32 0, i32 10
  %f11140 = load i32, ptr %f11139, align 4, !tbaa !0
  %45 = icmp sgt i32 %f11137, %f11140
  %46 = zext i1 %45 to i32
  br i1 %45, label %if.then141, label %if.end142

if.then141:                                       ; preds = %if.end135
  ret i32 1

if.end142:                                        ; preds = %if.end135
  %f12 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %f12143 = load i32, ptr %f12, align 4, !tbaa !0
  %other144 = load ptr, ptr %other, align 8
  %f12145 = getelementptr inbounds %class.Wide, ptr %other144, i32 0, i32 11
  %f12146 = load i32, ptr %f12145, align 4, !tbaa !0
  %47 = icmp slt i32 %f12143, %f12146
  %48 = zext i1 %47 to i32
  br i1 %47, label %if.then147, label %if.end148

if.then147:                                       ; preds = %if.end142
  ret i32 -1

if.end148:                                        ; preds = %if.end142
  %f12149 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 11
  %f12150 = load i32, ptr %f12149, align 4, !tbaa !0
  %other151 = load ptr, ptr %other, align 8
  %f12152 = getelementptr inbounds %class.Wide, ptr %other151, i32 0, i32 11
  %f12153 = load i32, ptr %f12152, align 4, !tbaa !0
  %49 = icmp sgt i32 %f12150, %f12153
  %50 = zext i1 %49 to i32
  br i1 %49, label %if.then154, label %if.end155

if.then154:                                       ; preds = %if.end148
  ret i32 1

if.end155:                                        ; preds = %if.end148
  %f13156 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %f13157 = load i32, ptr %f13156, align 4, !tbaa !0
  %other158 = load ptr, ptr %other, align 8
  %f13159 = getelementptr inbounds %class.Wide, ptr %other158, i32 0, i32 12
  %f13160 = load i32, ptr %f13159, align 4, !tbaa !0
  %51 = icmp slt i32 %f13157, %f13160
  %52 = zext i1 %51 to i32
  br i1 %51, label %if.then161, label %if.end162

if.then161:                                       ; preds = %if.end155
  ret i32 -1

if.end162:                                        ; preds = %if.end155
  %f13163 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 12
  %f13164 = load i32, ptr %f13163, align 4, !tbaa !0
  %other165 = load ptr, ptr %other, align 8
  %f13166 = getelementptr inbounds %class.Wide, ptr %other165, i32 0, i32 12
  %f13167 = load i32, ptr %f13166, align 4, !tbaa !0
  %53 = icmp sgt i32 %f13164, %f13167
  %54 = zext i1 %53 to i32
  br i1 %53, label %if.then168, label %if.end169

if.then168:                                       ; preds = %if.end162
  ret i32 1

if.end169:                                        ; preds = %if.end162
  %f14170 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %f14171 = load i32, ptr %f14170, align 4, !tbaa !0
  %other172 = load ptr, ptr %other, align 8
  %f14173 = getelementptr inbounds %class.Wide, ptr %other172, i32 0, i32 13
  %f14174 = load i32, ptr %f14173, align 4, !tbaa !0
  %55 = icmp slt i32 %f14171, %f14174
  %56 = zext i1 %55 to i32
  br i1 %55, label %if.then175, label %if.end176

if.then175:                                       ; preds = %if.end169
  ret i32 -1

if.end176:                                        ; preds = %if.end169
  %f14177 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 13
  %f14178 = load i32, ptr %f14177, align 4, !tbaa !0
  %other179 = load ptr, ptr %other, align 8
  %f14180 = getelementptr inbounds %class.Wide, ptr %other179, i32 0, i32 13
  %f14181 = load i32, ptr %f14180, align 4, !tbaa !0
  %57 = icmp sgt i32 %f14178, %f14181
  %58 = zext i1 %57 to i32
  br i1 %57, label %if.then182, label %if.end183

if.then182:                                       ; preds = %if.end176
  ret i32 1

if.end183:                                        ; preds = %if.end176
  %f15184 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %f15185 = load i32, ptr %f15184, align 4, !tbaa !0
  %other186 = load ptr, ptr %other, align 8
  %f15187 = getelementptr inbounds %class.Wide, ptr %other186, i32 0, i32 14
  %f15188 = load i32, ptr %f15187, align 4, !tbaa !0
  %59 = icmp slt i32 %f15185, %f15188
  %60 = zext i1 %59 to i32
  br i1 %59, label %if.then189, label %if.end190

if.then189:                                       ; preds = %if.end183
  ret i32 -1

if.end190:                                        ; preds = %if.end183
  %f15191 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 14
  %f15192 = load i32, ptr %f15191, align 4, !tbaa !0
  %other193 = load ptr, ptr %other, align 8
  %f15194 = getelementptr inbounds %class.Wide, ptr %other193, i32 0, i32 14
  %f15195 = load i32, ptr %f15194, align 4, !tbaa !0
  %61 = icmp sgt i32 %f15192, %f15195
  %62 = zext i1 %61 to i32
  br i1 %61, label %if.then196, label %if.end197

if.then196:                                       ; preds = %if.end190
  ret i32 1

if.end197:                                        ; preds = %if.end190
  %f16198 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %f16199 = load i32, ptr %f16198, align 4, !tbaa !0
  %other200 = load ptr, ptr %other, align 8
  %f16201 = getelementptr inbounds %class.Wide, ptr %other200, i32 0, i32 15
  %f16202 = load i32, ptr %f16201, align 4, !tbaa !0
  %63 = icmp slt i32 %f16199, %f16202
  %64 = zext i1 %63 to i32
  br i1 %63, label %if.then203, label %if.end204

if.then203:                                       ; preds = %if.end197
  ret i32 -1

if.end204:                                        ; preds = %if.end197
  %f16205 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 15
  %f16206 = load i32, ptr %f16205, align 4, !tbaa !0
  %other207 = load ptr, ptr %other, align 8
  %f16208 = getelementptr inbounds %class.Wide, ptr %other207, i32 0, i32 15
  %f16209 = load i32, ptr %f16208, align 4, !tbaa !0
  %65 = icmp sgt i32 %f16206, %f16209
  %66 = zext i1 %65 to i32
  br i1 %65, label %if.then210, label %if.end211

if.then210:                                       ; preds = %if.end204
  ret i32 1

if.end211:                                        ; preds = %if.end204
  %f17 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %f17212 = load i32, ptr %f17, align 4, !tbaa !0
  %other213 = load ptr, ptr %other, align 8
  %f17214 = getelementptr inbounds %class.Wide, ptr %other213, i32 0, i32 16
  %f17215 = load i32, ptr %f17214, align 4, !tbaa !0
  %67 = icmp slt i32 %f17212, %f17215
  %68 = zext i1 %67 to i32
  br i1 %67, label %if.then216, label %if.end217

if.then216:                                       ; preds = %if.end211
  ret i32 -1

if.end217:                                        ; preds = %if.end211
  %f17218 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 16
  %f17219 = load i32, ptr %f17218, align 4, !tbaa !0
  %other220 = load ptr, ptr %other, align 8
  %f17221 = getelementptr inbounds %class.Wide, ptr %other220, i32 0, i32 16
  %f17222 = load i32, ptr %f17221, align 4, !tbaa !0
  %69 = icmp sgt i32 %f17219, %f17222
  %70 = zext i1 %69 to i32
  br i1 %69, label %if.then223, label %if.end224

if.then223:                                       ; preds = %if.end217
  ret i32 1

if.end224:                                        ; preds = %if.end217
  %f18225 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %f18226 = load i32, ptr %f18225, align 4, !tbaa !0
  %other227 = load ptr, ptr %other, align 8
  %f18228 = getelementptr inbounds %class.Wide, ptr %other227, i32 0, i32 17
  %f18229 = load i32, ptr %f18228, align 4, !tbaa !0
  %71 = icmp slt i32 %f18226, %f18229
  %72 = zext i1 %71 to i32
  br i1 %71, label %if.then230, label %if.end231

if.then230:                                       ; preds = %if.end224
  ret i32 -1

if.end231:                                        ; preds = %if.end224
  %f18232 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 17
  %f18233 = load i32, ptr %f18232, align 4, !tbaa !0
  %other234 = load ptr, ptr %other, align 8
  %f18235 = getelementptr inbounds %class.Wide, ptr %other234, i32 0, i32 17
  %f18236 = load i32, ptr %f18235, align 4, !tbaa !0
  %73 = icmp sgt i32 %f18233, %f18236
  %74 = zext i1 %73 to i32
  br i1 %73, label %if.then237, label %if.end238

if.then237:                                       ; preds = %if.end231
  ret i32 1

if.end238:                                        ; preds = %if.end231
  %f19239 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %f19240 = load i32, ptr %f19239, align 4, !tbaa !0
  %other241 = load ptr, ptr %other, align 8
  %f19242 = getelementptr inbounds %class.Wide, ptr %other241, i32 0, i32 18
  %f19243 = load i32, ptr %f19242, align 4, !tbaa !0
  %75 = icmp slt i32 %f19240, %f19243
  %76 = zext i1 %75 to i32
  br i1 %75, label %if.then244, label %if.end245

if.then244:                                       ; preds = %if.end238
  ret i32 -1

if.end245:                                        ; preds = %if.end238
  %f19246 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 18
  %f19247 = load i32, ptr %f19246, align 4, !tbaa !0
  %other248 = load ptr, ptr %other, align 8
  %f19249 = getelementptr inbounds %class.Wide, ptr %other248, i32 0, i32 18
  %f19250 = load i32, ptr %f19249, align 4, !tbaa !0
  %77 = icmp sgt i32 %f19247, %f19250
  %78 = zext i1 %77 to i32
  br i1 %77, label %if.then251, label %if.end252

if.then251:                                       ; preds = %if.end245
  ret i32 1

if.end252:                                        ; preds = %if.end245
  %f20 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %f20253 = load i32, ptr %f20, align 4, !tbaa !0
  %other254 = load ptr, ptr %other, align 8
  %f20255 = getelementptr inbounds %class.Wide, ptr %other254, i32 0, i32 19
  %f20256 = load i32, ptr %f20255, align 4, !tbaa !0
  %79 = icmp slt i32 %f20253, %f20256
  %80 = zext i1 %79 to i32
  br i1 %79, label %if.then257, label %if.end258

if.then257:                                       ; preds = %if.end252
  ret i32 -1

if.end258:                                        ; preds = %if.end252
  %f20259 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 19
  %f20260 = load i32, ptr %f20259, align 4, !tbaa !0
  %other261 = load ptr, ptr %other, align 8
  %f20262 = getelementptr inbounds %class.Wide, ptr %other261, i32 0, i32 19
  %f20263 = load i32, ptr %f20262, align 4, !tbaa !0
  %81 = icmp sgt i32 %f20260, %f20263
  %82 = zext i1 %81 to i32
  br i1 %81, label %if.then264, label %if.end265

if.then264:                                       ; preds = %if.end258
  ret i32 1

if.end265:                                        ; preds = %if.end258
  %f21 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 20
  %f21266 = load i32, ptr %f21, align 4, !tbaa !0
  %other267 = load ptr, ptr %other, align 8
  %f21268 = getelementptr inbounds %class.Wide, ptr %other267, i32 0, i32 20
  %f21269 = load i32, ptr %f21268, align 4, !tbaa !0
  %83 = icmp slt i32 %f21266, %f21269
  %84 = zext i1 %83 to i32
  br i1 %83, label %if.then270, label %if.end271

if.then270:                                       ; preds = %if.end265
  ret i32 -1

if.end271:                                        ; preds = %if.end265
  %f21272 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 20
  %f21273 = load i32, ptr %f21272, align 4, !tbaa !0
  %other274 = load ptr, ptr %other, align 8
  %f21275 = getelementptr inbounds %class.Wide, ptr %other274, i32 0, i32 20
  %f21276 = load i32, ptr %f21275, align 4, !tbaa !0
  %85 = icmp sgt i32 %f21273, %f21276
  %86 = zext i1 %85 to i32
  br i1 %85, label %if.then277, label %if.end278

if.then277:                                       ; preds = %if.end271
  ret i32 1

if.end278:                                        ; preds = %if.end271
  %f22 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 21
  %f22279 = load i32, ptr %f22, align 4, !tbaa !0
  %other280 = load ptr, ptr %other, align 8
  %f22281 = getelementptr inbounds %class.Wide, ptr %other280, i32 0, i32 21
  %f22282 = load i32, ptr %f22281, align 4, !tbaa !0
  %87 = icmp slt i32 %f22279, %f22282
  %88 = zext i1 %87 to i32
  br i1 %87, label %if.then283, label %if.end284

if.then283:                                       ; preds = %if.end278
  ret i32 -1

if.end284:                                        ; preds = %if.end278
  %f22285 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 21
  %f22286 = load i32, ptr %f22285, align 4, !tbaa !0
  %other287 = load ptr, ptr %other, align 8
  %f22288 = getelementptr inbounds %class.Wide, ptr %other287, i32 0, i32 21
  %f22289 = load i32, ptr %f22288, align 4, !tbaa !0
  %89 = icmp sgt i32 %f22286, %f22289
  %90 = zext i1 %89 to i32
  br i1 %89, label %if.then290, label %if.end291

if.then290:                                       ; preds = %if.end284
  ret i32 1

if.end291:                                        ; preds = %if.end284
  %f23 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 22
  %f23292 = load i32, ptr %f23, align 4, !tbaa !0
  %other293 = load ptr, ptr %other, align 8
  %f23294 = getelementptr inbounds %class.Wide, ptr %other293, i32 0, i32 22
  %f23295 = load i32, ptr %f23294, align 4, !tbaa !0
  %91 = icmp slt i32 %f23292, %f23295
  %92 = zext i1 %91 to i32
  br i1 %91, label %if.then296, label %if.end297

if.then296:                                       ; preds = %if.end291
  ret i32 -1

if.end297:                                        ; preds = %if.end291
  %f23298 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 22
  %f23299 = load i32, ptr %f23298, align 4, !tbaa !0
  %other300 = load ptr, ptr %other, align 8
  %f23301 = getelementptr inbounds %class.Wide, ptr %other300, i32 0, i32 22
  %f23302 = load i32, ptr %f23301, align 4, !tbaa !0
  %93 = icmp sgt i32 %f23299, %f23302
  %94 = zext i1 %93 to i32
  br i1 %93, label %if.then303, label %if.end304

if.then303:                                       ; preds = %if.end297
  ret i32 1

if.end304:                                        ; preds = %if.end297
  %f24 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 23
  %f24305 = load i32, ptr %f24, align 4, !tbaa !0
  %other306 = load ptr, ptr %other, align 8
  %f24307 = getelementptr inbounds %class.Wide, ptr %other306, i32 0, i32 23
  %f24308 = load i32, ptr %f24307, align 4, !tbaa !0
  %95 = icmp slt i32 %f24305, %f24308
  %96 = zext i1 %95 to i32
  br i1 %95, label %if.then309, label %if.end310

if.then309:                                       ; preds = %if.end304
  ret i32 -1

if.end310:                                        ; preds = %if.end304
  %f24311 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 23
  %f24312 = load i32, ptr %f24311, align 4, !tbaa !0
  %other313 = load ptr, ptr %other, align 8
  %f24314 = getelementptr inbounds %class.Wide, ptr %other313, i32 0, i32 23
  %f24315 = load i32, ptr %f24314, align 4, !tbaa !0
  %97 = icmp sgt i32 %f24312, %f24315
  %98 = zext i1 %97 to i32
  br i1 %97, label %if.then316, label %if.end317

if.then316:                                       ; preds = %if.end310
  ret i32 1

if.end317:                                        ; preds = %if.end310
  %f25 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 24
  %f25318 = load i32, ptr %f25, align 4, !tbaa !0
  %other319 = load ptr, ptr %other, align 8
  %f25320 = getelementptr inbounds %class.Wide, ptr %other319, i32 0, i32 24
  %f25321 = load i32, ptr %f25320, align 4, !tbaa !0
  %99 = icmp slt i32 %f25318, %f25321
  %100 = zext i1 %99 to i32
  br i1 %99, label %if.then322, label %if.end323

if.then322:                                       ; preds = %if.end317
  ret i32 -1

if.end323:                                        ; preds = %if.end317
  %f25324 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 24
  %f25325 = load i32, ptr %f25324, align 4, !tbaa !0
  %other326 = load ptr, ptr %other, align 8
  %f25327 = getelementptr inbounds %class.Wide, ptr %other326, i32 0, i32 24
  %f25328 = load i32, ptr %f25327, align 4, !tbaa !0
  %101 = icmp sgt i32 %f25325, %f25328
  %102 = zext i1 %101 to i32
  br i1 %101, label %if.then329, label %if.end330

if.then329:                                       ; preds = %if.end323
  ret i32 1

if.end330:                                        ; preds = %if.end323
  %f26 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 25
  %f26331 = load i32, ptr %f26, align 4, !tbaa !0
  %other332 = load ptr, ptr %other, align 8
  %f26333 = getelementptr inbounds %class.Wide, ptr %other332, i32 0, i32 25
  %f26334 = load i32, ptr %f26333, align 4, !tbaa !0
  %103 = icmp slt i32 %f26331, %f26334
  %104 = zext i1 %103 to i32
  br i1 %103, label %if.then335, label %if.end336

if.then335:                                       ; preds = %if.end330
  ret i32 -1

if.end336:                                        ; preds = %if.end330
  %f26337 = getelementptr inbounds %class.Wide, ptr %0, i32 0, i32 25
  %f26338 = load i32, ptr %f26337, align 4, !tbaa !0
  %other339 = load ptr, ptr %other, align 8
  %f26340 = getelementptr inbounds %class.Wide, ptr %other339, i32 0, i32 25
  %f26341 = load i32, ptr %f26340, align 4, !tbaa !0
  %105 = icmp sgt i32 %f26338, %f26341
  %106 = zext i1 %105 to i32
  br i1 %105, label %if.then342, label %if.end343

if.then342:                                       ; preds = %if.end336
  ret i32 1

if.end343:                                        ; preds = %if.end336
  ret i32 0
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
  %"TreeSet$Wide.obj" = alloca %"class.TreeSet$Wide", align 8
  %got = alloca i32, align 4
  %r = alloca ptr, align 8
  %Wide.obj2 = alloca %class.Wide, align 8
  %q = alloca ptr, align 8
  %Wide.obj1 = alloca %class.Wide, align 8
  %p = alloca ptr, align 8
  %Wide.obj = alloca %class.Wide, align 8
  %m = alloca ptr, align 8
  %"HashMap$Wide$int.obj" = alloca %"class.HashMap$Wide$int", align 8
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
  call void @"HashMap$Wide$int.HashMap$Wide$int"(ptr %"HashMap$Wide$int.obj")
  store ptr %"HashMap$Wide$int.obj", ptr %m, align 8
  call void @Wide.Wide(ptr %Wide.obj, i32 3, i32 5)
  store ptr %Wide.obj, ptr %p, align 8
  call void @Wide.Wide(ptr %Wide.obj1, i32 3, i32 5)
  store ptr %Wide.obj1, ptr %q, align 8
  call void @Wide.Wide(ptr %Wide.obj2, i32 9, i32 1)
  store ptr %Wide.obj2, ptr %r, align 8
  %m3 = load ptr, ptr %m, align 8
  %p4 = load ptr, ptr %p, align 8
  call void @"HashMap$Wide$int.put"(ptr %m3, ptr %p4, i32 770)
  %m5 = load ptr, ptr %m, align 8
  %r6 = load ptr, ptr %r, align 8
  call void @"HashMap$Wide$int.put"(ptr %m5, ptr %r6, i32 42)
  store i32 -1, ptr %got, align 4
  %m7 = load ptr, ptr %m, align 8
  %q8 = load ptr, ptr %q, align 8
  %16 = call i32 @"HashMap$Wide$int.containsKey"(ptr %m7, ptr %q8)
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  %m9 = load ptr, ptr %m, align 8
  %q10 = load ptr, ptr %q, align 8
  %18 = call i32 @"HashMap$Wide$int.get"(ptr %m9, ptr %q10)
  store i32 %18, ptr %got, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %argv.end
  call void @"TreeSet$Wide.TreeSet$Wide"(ptr %"TreeSet$Wide.obj")
  store ptr %"TreeSet$Wide.obj", ptr %s, align 8
  %s11 = load ptr, ptr %s, align 8
  %p12 = load ptr, ptr %p, align 8
  call void @"TreeSet$Wide.add"(ptr %s11, ptr %p12)
  %s13 = load ptr, ptr %s, align 8
  %q14 = load ptr, ptr %q, align 8
  call void @"TreeSet$Wide.add"(ptr %s13, ptr %q14)
  %s15 = load ptr, ptr %s, align 8
  %r16 = load ptr, ptr %r, align 8
  call void @"TreeSet$Wide.add"(ptr %s15, ptr %r16)
  %got17 = load i32, ptr %got, align 4
  %s18 = load ptr, ptr %s, align 8
  %19 = call i32 @"TreeSet$Wide.size"(ptr %s18)
  %20 = call i32 (ptr, ...) @printf(ptr @.str, i32 %got17, i32 %19)
  ret i32 0
}

define internal void @"TreeSet$Wide.TreeSet$Wide"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 0
  store ptr @"TreeSet$Wide.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %root = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  store ptr null, ptr %root, align 8, !tbaa !4
  %count = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !0
  ret void
}

define internal void @"TreeSet$Wide.~TreeSet$Wide"(ptr %0) {
entry:
  %root = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !4
  call void @"TreeSet$Wide.freeSubtree"(ptr %0, ptr %root1)
  %root2 = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  store ptr null, ptr %root2, align 8, !tbaa !4
  %count = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !0
  ret void
}

define internal void @"TreeSet$Wide.freeSubtree"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n2, i32 0, i32 2
  %left3 = load ptr, ptr %left, align 8, !tbaa !4
  call void @"TreeSet$Wide.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n4, i32 0, i32 3
  %right7 = load ptr, ptr %right, align 8, !tbaa !4
  call void @"TreeSet$Wide.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n8, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !4
  %dtor.slot = getelementptr [357 x ptr], ptr %vtbl, i64 0, i64 356
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

define internal void @"TreeSet$Wide.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Wide.copy = alloca %class.Wide, align 8
  %value = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %value, align 8
  %root = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  %root1 = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root1, align 8, !tbaa !4
  %value3 = load ptr, ptr %value, align 8
  %3 = call ptr @"TreeSet$Wide.insertNode"(ptr %0, ptr %root2, ptr %value3)
  store ptr %3, ptr %root, align 8, !tbaa !4
  ret void
}

define internal i32 @"TreeSet$Wide.nodeHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  call void @__polaron_panic(ptr @.panic.3)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %height = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n2, i32 0, i32 4
  %height3 = load i32, ptr %height, align 4, !tbaa !0
  ret i32 %height3
}

define internal void @"TreeSet$Wide.fixHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rh = alloca i32, align 4
  %lh = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.4)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !4
  %3 = call i32 @"TreeSet$Wide.nodeHeight"(ptr %0, ptr %left2)
  store i32 %3, ptr %lh, align 4
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.5)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !4
  %5 = call i32 @"TreeSet$Wide.nodeHeight"(ptr %0, ptr %right6)
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
  call void @__polaron_panic(ptr @.panic.6)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n9, i32 0, i32 4
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !0
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.7)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %height16 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n13, i32 0, i32 4
  %rh17 = load i32, ptr %rh, align 4
  %11 = add i32 %rh17, 1
  store i32 %11, ptr %height16, align 4, !tbaa !0
  br label %if.end
}

define internal i32 @"TreeSet$Wide.balance"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.8)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !4
  %3 = call i32 @"TreeSet$Wide.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.9)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !4
  %5 = call i32 @"TreeSet$Wide.nodeHeight"(ptr %0, ptr %right6)
  %6 = sub i32 %3, %5
  ret i32 %6
}

define internal ptr @"TreeSet$Wide.rotateRight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %1, ptr %y, align 8
  %y1 = load ptr, ptr %y, align 8
  %2 = icmp eq ptr %y1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.10)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %y1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !4
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.11)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %y3, i32 0, i32 2
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.12)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %x7, i32 0, i32 3
  %right10 = load ptr, ptr %right, align 8, !tbaa !4
  store ptr %right10, ptr %left6, align 8, !tbaa !4
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.13)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %right14 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %x11, i32 0, i32 3
  %y15 = load ptr, ptr %y, align 8
  store ptr %y15, ptr %right14, align 8, !tbaa !4
  %y16 = load ptr, ptr %y, align 8
  call void @"TreeSet$Wide.fixHeight"(ptr %0, ptr %y16)
  %x17 = load ptr, ptr %x, align 8
  call void @"TreeSet$Wide.fixHeight"(ptr %0, ptr %x17)
  %x18 = load ptr, ptr %x, align 8
  ret ptr %x18
}

define internal ptr @"TreeSet$Wide.rotateLeft"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %2 = icmp eq ptr %x1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.14)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %x1, i32 0, i32 3
  %right2 = load ptr, ptr %right, align 8, !tbaa !4
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.15)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %x3, i32 0, i32 3
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.16)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %y7, i32 0, i32 2
  %left10 = load ptr, ptr %left, align 8, !tbaa !4
  store ptr %left10, ptr %right6, align 8, !tbaa !4
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.17)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %left14 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %y11, i32 0, i32 2
  %x15 = load ptr, ptr %x, align 8
  store ptr %x15, ptr %left14, align 8, !tbaa !4
  %x16 = load ptr, ptr %x, align 8
  call void @"TreeSet$Wide.fixHeight"(ptr %0, ptr %x16)
  %y17 = load ptr, ptr %y, align 8
  call void @"TreeSet$Wide.fixHeight"(ptr %0, ptr %y17)
  %y18 = load ptr, ptr %y, align 8
  ret ptr %y18
}

define internal ptr @"TreeSet$Wide.insertNode"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2) {
entry:
  %bf = alloca i32, align 4
  %c = alloca i32, align 4
  %Wide.copy = alloca %class.Wide, align 8
  %value = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  %3 = call ptr @memcpy(ptr %Wide.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %value, align 8
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %6 = add i32 %count3, 1
  store i32 %6, ptr %count, align 4, !tbaa !0
  %"TreeSetNode$Wide.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeSetNode$Wide", ptr null, i64 1) to i64))
  %value4 = load ptr, ptr %value, align 8
  call void @"TreeSetNode$Wide.TreeSetNode$Wide"(ptr %"TreeSetNode$Wide.obj", ptr %value4)
  ret ptr %"TreeSetNode$Wide.obj"

if.end:                                           ; preds = %entry
  %value5 = load ptr, ptr %value, align 8
  %node6 = load ptr, ptr %node, align 8
  %7 = icmp eq ptr %node6, null
  br i1 %7, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.18)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %value7 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node6, i32 0, i32 1
  %value8 = load ptr, ptr %value7, align 8, !tbaa !4
  %8 = call i32 @Wide.compareTo(ptr %value5, ptr %value8)
  store i32 %8, ptr %c, align 4
  %c9 = load i32, ptr %c, align 4
  %9 = icmp eq i32 %c9, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then10, label %if.end11

if.then10:                                        ; preds = %nullrecv.ok
  %node12 = load ptr, ptr %node, align 8
  ret ptr %node12

if.end11:                                         ; preds = %nullrecv.ok
  %c13 = load i32, ptr %c, align 4
  %11 = icmp slt i32 %c13, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then14, label %if.else

if.then14:                                        ; preds = %if.end11
  %node16 = load ptr, ptr %node, align 8
  %13 = icmp eq ptr %node16, null
  br i1 %13, label %nullrecv17, label %nullrecv.ok18

if.else:                                          ; preds = %if.end11
  %node25 = load ptr, ptr %node, align 8
  %14 = icmp eq ptr %node25, null
  br i1 %14, label %nullrecv26, label %nullrecv.ok27

if.end15:                                         ; preds = %nullrecv.ok30, %nullrecv.ok21
  %node34 = load ptr, ptr %node, align 8
  call void @"TreeSet$Wide.fixHeight"(ptr %0, ptr %node34)
  %node35 = load ptr, ptr %node, align 8
  %15 = call i32 @"TreeSet$Wide.balance"(ptr %0, ptr %node35)
  store i32 %15, ptr %bf, align 4
  %bf36 = load i32, ptr %bf, align 4
  %16 = icmp sgt i32 %bf36, 1
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then37, label %if.end38

nullrecv17:                                       ; preds = %if.then14
  call void @__polaron_panic(ptr @.panic.19)
  unreachable

nullrecv.ok18:                                    ; preds = %if.then14
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node16, i32 0, i32 2
  %node19 = load ptr, ptr %node, align 8
  %18 = icmp eq ptr %node19, null
  br i1 %18, label %nullrecv20, label %nullrecv.ok21

nullrecv20:                                       ; preds = %nullrecv.ok18
  call void @__polaron_panic(ptr @.panic.20)
  unreachable

nullrecv.ok21:                                    ; preds = %nullrecv.ok18
  %left22 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node19, i32 0, i32 2
  %left23 = load ptr, ptr %left22, align 8, !tbaa !4
  %value24 = load ptr, ptr %value, align 8
  %19 = call ptr @"TreeSet$Wide.insertNode"(ptr %0, ptr %left23, ptr %value24)
  store ptr %19, ptr %left, align 8, !tbaa !4
  br label %if.end15

nullrecv26:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.21)
  unreachable

nullrecv.ok27:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node25, i32 0, i32 3
  %node28 = load ptr, ptr %node, align 8
  %20 = icmp eq ptr %node28, null
  br i1 %20, label %nullrecv29, label %nullrecv.ok30

nullrecv29:                                       ; preds = %nullrecv.ok27
  call void @__polaron_panic(ptr @.panic.22)
  unreachable

nullrecv.ok30:                                    ; preds = %nullrecv.ok27
  %right31 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node28, i32 0, i32 3
  %right32 = load ptr, ptr %right31, align 8, !tbaa !4
  %value33 = load ptr, ptr %value, align 8
  %21 = call ptr @"TreeSet$Wide.insertNode"(ptr %0, ptr %right32, ptr %value33)
  store ptr %21, ptr %right, align 8, !tbaa !4
  br label %if.end15

if.then37:                                        ; preds = %if.end15
  %node39 = load ptr, ptr %node, align 8
  %22 = icmp eq ptr %node39, null
  br i1 %22, label %nullrecv40, label %nullrecv.ok41

if.end38:                                         ; preds = %if.end15
  %bf56 = load i32, ptr %bf, align 4
  %23 = icmp slt i32 %bf56, -1
  %24 = zext i1 %23 to i32
  br i1 %23, label %if.then57, label %if.end58

nullrecv40:                                       ; preds = %if.then37
  call void @__polaron_panic(ptr @.panic.23)
  unreachable

nullrecv.ok41:                                    ; preds = %if.then37
  %left42 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node39, i32 0, i32 2
  %left43 = load ptr, ptr %left42, align 8, !tbaa !4
  %25 = call i32 @"TreeSet$Wide.balance"(ptr %0, ptr %left43)
  %26 = icmp slt i32 %25, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then44, label %if.end45

if.then44:                                        ; preds = %nullrecv.ok41
  %node46 = load ptr, ptr %node, align 8
  %28 = icmp eq ptr %node46, null
  br i1 %28, label %nullrecv47, label %nullrecv.ok48

if.end45:                                         ; preds = %nullrecv.ok52, %nullrecv.ok41
  %node55 = load ptr, ptr %node, align 8
  %29 = call ptr @"TreeSet$Wide.rotateRight"(ptr %0, ptr %node55)
  ret ptr %29

nullrecv47:                                       ; preds = %if.then44
  call void @__polaron_panic(ptr @.panic.24)
  unreachable

nullrecv.ok48:                                    ; preds = %if.then44
  %left49 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node46, i32 0, i32 2
  %node50 = load ptr, ptr %node, align 8
  %30 = icmp eq ptr %node50, null
  br i1 %30, label %nullrecv51, label %nullrecv.ok52

nullrecv51:                                       ; preds = %nullrecv.ok48
  call void @__polaron_panic(ptr @.panic.25)
  unreachable

nullrecv.ok52:                                    ; preds = %nullrecv.ok48
  %left53 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node50, i32 0, i32 2
  %left54 = load ptr, ptr %left53, align 8, !tbaa !4
  %31 = call ptr @"TreeSet$Wide.rotateLeft"(ptr %0, ptr %left54)
  store ptr %31, ptr %left49, align 8, !tbaa !4
  br label %if.end45

if.then57:                                        ; preds = %if.end38
  %node59 = load ptr, ptr %node, align 8
  %32 = icmp eq ptr %node59, null
  br i1 %32, label %nullrecv60, label %nullrecv.ok61

if.end58:                                         ; preds = %if.end38
  %node76 = load ptr, ptr %node, align 8
  ret ptr %node76

nullrecv60:                                       ; preds = %if.then57
  call void @__polaron_panic(ptr @.panic.26)
  unreachable

nullrecv.ok61:                                    ; preds = %if.then57
  %right62 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node59, i32 0, i32 3
  %right63 = load ptr, ptr %right62, align 8, !tbaa !4
  %33 = call i32 @"TreeSet$Wide.balance"(ptr %0, ptr %right63)
  %34 = icmp sgt i32 %33, 0
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then64, label %if.end65

if.then64:                                        ; preds = %nullrecv.ok61
  %node66 = load ptr, ptr %node, align 8
  %36 = icmp eq ptr %node66, null
  br i1 %36, label %nullrecv67, label %nullrecv.ok68

if.end65:                                         ; preds = %nullrecv.ok72, %nullrecv.ok61
  %node75 = load ptr, ptr %node, align 8
  %37 = call ptr @"TreeSet$Wide.rotateLeft"(ptr %0, ptr %node75)
  ret ptr %37

nullrecv67:                                       ; preds = %if.then64
  call void @__polaron_panic(ptr @.panic.27)
  unreachable

nullrecv.ok68:                                    ; preds = %if.then64
  %right69 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node66, i32 0, i32 3
  %node70 = load ptr, ptr %node, align 8
  %38 = icmp eq ptr %node70, null
  br i1 %38, label %nullrecv71, label %nullrecv.ok72

nullrecv71:                                       ; preds = %nullrecv.ok68
  call void @__polaron_panic(ptr @.panic.28)
  unreachable

nullrecv.ok72:                                    ; preds = %nullrecv.ok68
  %right73 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node70, i32 0, i32 3
  %right74 = load ptr, ptr %right73, align 8, !tbaa !4
  %39 = call ptr @"TreeSet$Wide.rotateRight"(ptr %0, ptr %right74)
  store ptr %39, ptr %right69, align 8, !tbaa !4
  br label %if.end65
}

define internal i32 @"TreeSet$Wide.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %cur = alloca ptr, align 8
  %Wide.copy = alloca %class.Wide, align 8
  %value = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %value, align 8
  %root = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !4
  store ptr %root1, ptr %cur, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end10, %entry
  %cur2 = load ptr, ptr %cur, align 8
  %3 = icmp ne ptr %cur2, null
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %value3 = load ptr, ptr %value, align 8
  %cur4 = load ptr, ptr %cur, align 8
  %5 = icmp eq ptr %cur4, null
  br i1 %5, label %nullrecv, label %nullrecv.ok

while.end:                                        ; preds = %while.cond
  ret i32 0

nullrecv:                                         ; preds = %while.body
  call void @__polaron_panic(ptr @.panic.29)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %value5 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %cur4, i32 0, i32 1
  %value6 = load ptr, ptr %value5, align 8, !tbaa !4
  %6 = call i32 @Wide.compareTo(ptr %value3, ptr %value6)
  store i32 %6, ptr %c, align 4
  %c7 = load i32, ptr %c, align 4
  %7 = icmp eq i32 %c7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %nullrecv.ok
  ret i32 1

if.end:                                           ; preds = %nullrecv.ok
  %c8 = load i32, ptr %c, align 4
  %9 = icmp slt i32 %c8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then9, label %if.else

if.then9:                                         ; preds = %if.end
  %cur11 = load ptr, ptr %cur, align 8
  %11 = icmp eq ptr %cur11, null
  br i1 %11, label %nullrecv12, label %nullrecv.ok13

if.else:                                          ; preds = %if.end
  %cur15 = load ptr, ptr %cur, align 8
  %12 = icmp eq ptr %cur15, null
  br i1 %12, label %nullrecv16, label %nullrecv.ok17

if.end10:                                         ; preds = %nullrecv.ok17, %nullrecv.ok13
  br label %while.cond

nullrecv12:                                       ; preds = %if.then9
  call void @__polaron_panic(ptr @.panic.30)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then9
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %cur11, i32 0, i32 2
  %left14 = load ptr, ptr %left, align 8, !tbaa !4
  store ptr %left14, ptr %cur, align 8
  br label %if.end10

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.31)
  unreachable

nullrecv.ok17:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %cur15, i32 0, i32 3
  %right18 = load ptr, ptr %right, align 8, !tbaa !4
  store ptr %right18, ptr %cur, align 8
  br label %if.end10
}

define internal i32 @"TreeSet$Wide.fill"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
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
  call void @__polaron_panic(ptr @.panic.32)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node3, i32 0, i32 2
  %left4 = load ptr, ptr %left, align 8, !tbaa !4
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeSet$Wide.fill"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
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
  %arr.elem = getelementptr inbounds %class.Wide, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.33)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %value = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node9, i32 0, i32 1
  %value12 = load ptr, ptr %value, align 8, !tbaa !4
  %10 = call ptr @memcpy(ptr %arr.elem, ptr %value12, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  %i13 = load i32, ptr %i, align 4
  %11 = add i32 %i13, 1
  store i32 %11, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %12 = icmp eq ptr %node14, null
  br i1 %12, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.34)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %node14, i32 0, i32 3
  %right17 = load ptr, ptr %right, align 8, !tbaa !4
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %13 = call i32 @"TreeSet$Wide.fill"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %13
}

define internal ptr @"TreeSet$Wide.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 104
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !4
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeSet$Wide.fill"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal i32 @"TreeSet$Wide.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  ret i32 %count1
}

define internal i32 @"TreeSet$Wide.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$Wide", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"TreeSetNode$Wide.TreeSetNode$Wide"(ptr %0, ptr %1) {
entry:
  %Wide.copy = alloca %class.Wide, align 8
  %v = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %v, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %0, i32 0, i32 0
  store ptr @"TreeSetNode$Wide.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %value = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %0, i32 0, i32 1
  store ptr null, ptr %value, align 8, !tbaa !4
  %value1 = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %0, i32 0, i32 1
  %v2 = load ptr, ptr %v, align 8
  %Wide.copy3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  %3 = call ptr @memcpy(ptr %Wide.copy3, ptr %v2, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy3, ptr %value1, align 8, !tbaa !4
  %left = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %0, i32 0, i32 2
  store ptr null, ptr %left, align 8, !tbaa !4
  %right = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %0, i32 0, i32 3
  store ptr null, ptr %right, align 8, !tbaa !4
  %height = getelementptr inbounds %"class.TreeSetNode$Wide", ptr %0, i32 0, i32 4
  store i32 1, ptr %height, align 4, !tbaa !0
  ret void
}

define internal void @"HashMap$Wide$int.HashMap$Wide$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 0
  store ptr @"HashMap$Wide$int.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !4
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !4
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !0
  %keys1 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 840)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 832)
  store ptr %arr, ptr %keys1, align 8, !tbaa !4
  %values2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 32)
  store ptr %arr3, ptr %values2, align 8, !tbaa !4
  %used5 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !4
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !0
  %count8 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !0
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !0
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.393, ptr @.cl.394, i64 %contract.l, ptr @.cr.395, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !0
  %cap14 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !0
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !0
  %cap21 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !0
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.396, ptr @.cl.397, i64 %contract.l23, ptr @.cr.398, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !4
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.399, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !4
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.400, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !4
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !0
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.401, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$Wide$int.~HashMap$Wide$int"(ptr %0) {
entry:
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys1 = load ptr, ptr %keys, align 8, !tbaa !4
  call void @__polaron_free(ptr %keys1)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !4
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used3 = load ptr, ptr %used, align 8, !tbaa !4
  call void @__polaron_free(ptr %used3)
  ret void
}

define internal i32 @"HashMap$Wide$int.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !0
  %16 = sub i32 %cap21, 1
  store i32 %16, ptr %mask, align 4
  %key22 = load ptr, ptr %key, align 8
  %17 = call i64 @Wide.hash(ptr %key22)
  %18 = trunc i64 %17 to i32
  %mask23 = load i32, ptr %mask, align 4
  %19 = and i32 %18, %mask23
  store i32 %19, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %used24 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %20 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys28 = load ptr, ptr %keys27, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %21 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %keys28, align 8
  %arr.oob31 = icmp uge i64 %21, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

while.end:                                        ; preds = %idx.ok
  %i40 = load i32, ptr %i, align 4
  ret i32 %i40

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.402, ptr @.faila.403, i64 %20, ptr @.failb.404, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.cond
  %arr.data = getelementptr i8, ptr %used25, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %20
  %elem = load i8, ptr %arr.elem, align 1
  %22 = sext i8 %elem to i32
  %23 = icmp ne i32 %22, 0
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body, label %while.end

idx.bad32:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.405, ptr @.faila.406, i64 %21, ptr @.failb.407, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %keys28, i64 8
  %arr.elem35 = getelementptr inbounds %class.Wide, ptr %arr.data34, i64 %21
  %key36 = load ptr, ptr %key, align 8
  %25 = call i32 @Wide.equalsKey(ptr %arr.elem35, ptr %key36)
  %26 = icmp ne i32 %25, 0
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok33
  %i37 = load i32, ptr %i, align 4
  ret i32 %i37

if.end:                                           ; preds = %idx.ok33
  %i38 = load i32, ptr %i, align 4
  %27 = add i32 %i38, 1
  %mask39 = load i32, ptr %mask, align 4
  %28 = and i32 %27, %mask39
  store i32 %28, ptr %i, align 4
  br label %while.cond
}

define internal void @"HashMap$Wide$int.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !0
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !4
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !4
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !4
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !0
  %keys30 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !0
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 104
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !4
  %values33 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !0
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 4
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !4
  %used38 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !0
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !4
  %cap43 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !0
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
  %oldK115 = load ptr, ptr %oldK, align 8
  call void @__polaron_free(ptr %oldK115)
  %oldV116 = load ptr, ptr %oldV, align 8
  call void @__polaron_free(ptr %oldV116)
  %oldU117 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU117)
  %count118 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !0
  %33 = icmp sge i32 %count119, 0
  %34 = zext i1 %33 to i32
  %contract.ok = icmp ne i32 %34, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.408, ptr @.faila.409, i64 %30, ptr @.failb.410, i64 %arr.len, i32 70)
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
  %oldK50 = load ptr, ptr %oldK, align 8, !nonnull !6, !dereferenceable !7
  %j51 = load i32, ptr %j, align 4
  %38 = sext i32 %j51 to i64
  %arr.len52 = load i64, ptr %oldK50, align 8
  %arr.oob53 = icmp uge i64 %38, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !8

if.end:                                           ; preds = %idx.ok111, %idx.ok
  br label %for.update

idx.bad54:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.411, ptr @.faila.412, i64 %38, ptr @.failb.413, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %if.then
  %arr.data56 = getelementptr i8, ptr %oldK50, i64 8
  %arr.elem57 = getelementptr inbounds %class.Wide, ptr %arr.data56, i64 %38
  %39 = call i64 @Wide.hash(ptr %arr.elem57)
  %40 = trunc i64 %39 to i32
  %mask58 = load i32, ptr %mask, align 4
  %41 = and i32 %40, %mask58
  store i32 %41, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok55
  %used59 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used60 = load ptr, ptr %used59, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i61 = load i32, ptr %i, align 4
  %42 = sext i32 %i61 to i64
  %arr.len62 = load i64, ptr %used60, align 8
  %arr.oob63 = icmp uge i64 %42, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !8

while.body:                                       ; preds = %idx.ok65
  %i69 = load i32, ptr %i, align 4
  %43 = add i32 %i69, 1
  %mask70 = load i32, ptr %mask, align 4
  %44 = and i32 %43, %mask70
  store i32 %44, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %idx.ok65
  %used71 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used72 = load ptr, ptr %used71, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i73 = load i32, ptr %i, align 4
  %45 = sext i32 %i73 to i64
  %arr.len74 = load i64, ptr %used72, align 8
  %arr.oob75 = icmp uge i64 %45, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !8

idx.bad64:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.414, ptr @.faila.415, i64 %42, ptr @.failb.416, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %while.cond
  %arr.data66 = getelementptr i8, ptr %used60, i64 8
  %arr.elem67 = getelementptr inbounds i8, ptr %arr.data66, i64 %42
  %elem68 = load i8, ptr %arr.elem67, align 1
  %46 = sext i8 %elem68 to i32
  %47 = icmp ne i32 %46, 0
  %48 = zext i1 %47 to i32
  br i1 %47, label %while.body, label %while.end

idx.bad76:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.417, ptr @.faila.418, i64 %45, ptr @.failb.419, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %while.end
  %arr.data78 = getelementptr i8, ptr %used72, i64 8
  %arr.elem79 = getelementptr inbounds i8, ptr %arr.data78, i64 %45
  store i8 1, ptr %arr.elem79, align 1
  %keys80 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys81 = load ptr, ptr %keys80, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i82 = load i32, ptr %i, align 4
  %49 = sext i32 %i82 to i64
  %arr.len83 = load i64, ptr %keys81, align 8
  %arr.oob84 = icmp uge i64 %49, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !8

idx.bad85:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.420, ptr @.faila.421, i64 %49, ptr @.failb.422, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok77
  %arr.data87 = getelementptr i8, ptr %keys81, i64 8
  %arr.elem88 = getelementptr inbounds %class.Wide, ptr %arr.data87, i64 %49
  %oldK89 = load ptr, ptr %oldK, align 8, !nonnull !6, !dereferenceable !7
  %j90 = load i32, ptr %j, align 4
  %50 = sext i32 %j90 to i64
  %arr.len91 = load i64, ptr %oldK89, align 8
  %arr.oob92 = icmp uge i64 %50, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !8

idx.bad93:                                        ; preds = %idx.ok86
  call void @__polaron_fail(ptr @.fail.423, ptr @.faila.424, i64 %50, ptr @.failb.425, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %idx.ok86
  %arr.data95 = getelementptr i8, ptr %oldK89, i64 8
  %arr.elem96 = getelementptr inbounds %class.Wide, ptr %arr.data95, i64 %50
  %51 = call ptr @memcpy(ptr %arr.elem88, ptr %arr.elem96, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  %values97 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values98 = load ptr, ptr %values97, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i99 = load i32, ptr %i, align 4
  %52 = sext i32 %i99 to i64
  %arr.len100 = load i64, ptr %values98, align 8
  %arr.oob101 = icmp uge i64 %52, %arr.len100
  br i1 %arr.oob101, label %idx.bad102, label %idx.ok103, !prof !8

idx.bad102:                                       ; preds = %idx.ok94
  call void @__polaron_fail(ptr @.fail.426, ptr @.faila.427, i64 %52, ptr @.failb.428, i64 %arr.len100, i32 70)
  unreachable

idx.ok103:                                        ; preds = %idx.ok94
  %arr.data104 = getelementptr i8, ptr %values98, i64 8
  %arr.elem105 = getelementptr inbounds i32, ptr %arr.data104, i64 %52
  %oldV106 = load ptr, ptr %oldV, align 8, !nonnull !6, !dereferenceable !7
  %j107 = load i32, ptr %j, align 4
  %53 = sext i32 %j107 to i64
  %arr.len108 = load i64, ptr %oldV106, align 8
  %arr.oob109 = icmp uge i64 %53, %arr.len108
  br i1 %arr.oob109, label %idx.bad110, label %idx.ok111, !prof !8

idx.bad110:                                       ; preds = %idx.ok103
  call void @__polaron_fail(ptr @.fail.429, ptr @.faila.430, i64 %53, ptr @.failb.431, i64 %arr.len108, i32 70)
  unreachable

idx.ok111:                                        ; preds = %idx.ok103
  %arr.data112 = getelementptr i8, ptr %oldV106, i64 8
  %arr.elem113 = getelementptr inbounds i32, ptr %arr.data112, i64 %53
  %elem114 = load i32, ptr %arr.elem113, align 4
  store i32 %elem114, ptr %arr.elem105, align 4
  br label %if.end

contract.fail:                                    ; preds = %for.end
  %count120 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count121 = load i32, ptr %count120, align 4, !tbaa !0
  %contract.l = sext i32 %count121 to i64
  call void @__polaron_fail(ptr @.contract.432, ptr @.cl.433, i64 %contract.l, ptr @.cr.434, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %for.end
  %count122 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count123 = load i32, ptr %count122, align 4, !tbaa !0
  %cap124 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap125 = load i32, ptr %cap124, align 4, !tbaa !0
  %54 = icmp slt i32 %count123, %cap125
  %55 = zext i1 %54 to i32
  %contract.ok126 = icmp ne i32 %55, 0
  br i1 %contract.ok126, label %contract.cont128, label %contract.fail127

contract.fail127:                                 ; preds = %contract.cont
  %count129 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count130 = load i32, ptr %count129, align 4, !tbaa !0
  %cap131 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap132 = load i32, ptr %cap131, align 4, !tbaa !0
  %contract.l133 = sext i32 %count130 to i64
  %contract.r = sext i32 %cap132 to i64
  call void @__polaron_fail(ptr @.contract.435, ptr @.cl.436, i64 %contract.l133, ptr @.cr.437, i64 %contract.r, i32 1)
  unreachable

contract.cont128:                                 ; preds = %contract.cont
  %keys134 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys135 = load ptr, ptr %keys134, align 8, !tbaa !4
  %len136 = load i64, ptr %keys135, align 8
  %56 = trunc i64 %len136 to i32
  %cap137 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap138 = load i32, ptr %cap137, align 4, !tbaa !0
  %57 = icmp eq i32 %56, %cap138
  %58 = zext i1 %57 to i32
  %contract.ok139 = icmp ne i32 %58, 0
  br i1 %contract.ok139, label %contract.cont141, label %contract.fail140

contract.fail140:                                 ; preds = %contract.cont128
  call void @__polaron_fail(ptr @.contract.438, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont141:                                 ; preds = %contract.cont128
  %values142 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values143 = load ptr, ptr %values142, align 8, !tbaa !4
  %len144 = load i64, ptr %values143, align 8
  %59 = trunc i64 %len144 to i32
  %cap145 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap146 = load i32, ptr %cap145, align 4, !tbaa !0
  %60 = icmp eq i32 %59, %cap146
  %61 = zext i1 %60 to i32
  %contract.ok147 = icmp ne i32 %61, 0
  br i1 %contract.ok147, label %contract.cont149, label %contract.fail148

contract.fail148:                                 ; preds = %contract.cont141
  call void @__polaron_fail(ptr @.contract.439, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont149:                                 ; preds = %contract.cont141
  %used150 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used151 = load ptr, ptr %used150, align 8, !tbaa !4
  %len152 = load i64, ptr %used151, align 8
  %62 = trunc i64 %len152 to i32
  %cap153 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap154 = load i32, ptr %cap153, align 4, !tbaa !0
  %63 = icmp eq i32 %62, %cap154
  %64 = zext i1 %63 to i32
  %contract.ok155 = icmp ne i32 %64, 0
  br i1 %contract.ok155, label %contract.cont157, label %contract.fail156

contract.fail156:                                 ; preds = %contract.cont149
  call void @__polaron_fail(ptr @.contract.440, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont157:                                 ; preds = %contract.cont149
  ret void
}

define internal void @"HashMap$Wide$int.put"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %value = alloca i32, align 4
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !0
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$Wide$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %22 = call i32 @"HashMap$Wide$int.slotFor"(ptr %0, ptr %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.441, ptr @.faila.442, i64 %23, ptr @.failb.443, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %28 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %28, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.444, ptr @.faila.445, i64 %27, ptr @.failb.446, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !0
  %29 = add i32 %count41, 1
  store i32 %29, ptr %count39, align 4, !tbaa !0
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.447, ptr @.faila.448, i64 %28, ptr @.failb.449, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds %class.Wide, ptr %arr.data49, i64 %28
  %key51 = load ptr, ptr %key, align 8
  %30 = call ptr @memcpy(ptr %arr.elem50, ptr %key51, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  %values52 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %31 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %31, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.450, ptr @.faila.451, i64 %31, ptr @.failb.452, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %31
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  %count62 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count63 = load i32, ptr %count62, align 4, !tbaa !0
  %32 = icmp sge i32 %count63, 0
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count64 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count65 = load i32, ptr %count64, align 4, !tbaa !0
  %contract.l = sext i32 %count65 to i64
  call void @__polaron_fail(ptr @.contract.453, ptr @.cl.454, i64 %contract.l, ptr @.cr.455, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count66 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count67 = load i32, ptr %count66, align 4, !tbaa !0
  %cap68 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap69 = load i32, ptr %cap68, align 4, !tbaa !0
  %34 = icmp slt i32 %count67, %cap69
  %35 = zext i1 %34 to i32
  %contract.ok70 = icmp ne i32 %35, 0
  br i1 %contract.ok70, label %contract.cont72, label %contract.fail71

contract.fail71:                                  ; preds = %contract.cont
  %count73 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count74 = load i32, ptr %count73, align 4, !tbaa !0
  %cap75 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap76 = load i32, ptr %cap75, align 4, !tbaa !0
  %contract.l77 = sext i32 %count74 to i64
  %contract.r = sext i32 %cap76 to i64
  call void @__polaron_fail(ptr @.contract.456, ptr @.cl.457, i64 %contract.l77, ptr @.cr.458, i64 %contract.r, i32 1)
  unreachable

contract.cont72:                                  ; preds = %contract.cont
  %keys78 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys79 = load ptr, ptr %keys78, align 8, !tbaa !4
  %len80 = load i64, ptr %keys79, align 8
  %36 = trunc i64 %len80 to i32
  %cap81 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap82 = load i32, ptr %cap81, align 4, !tbaa !0
  %37 = icmp eq i32 %36, %cap82
  %38 = zext i1 %37 to i32
  %contract.ok83 = icmp ne i32 %38, 0
  br i1 %contract.ok83, label %contract.cont85, label %contract.fail84

contract.fail84:                                  ; preds = %contract.cont72
  call void @__polaron_fail(ptr @.contract.459, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont85:                                  ; preds = %contract.cont72
  %values86 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values87 = load ptr, ptr %values86, align 8, !tbaa !4
  %len88 = load i64, ptr %values87, align 8
  %39 = trunc i64 %len88 to i32
  %cap89 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !0
  %40 = icmp eq i32 %39, %cap90
  %41 = zext i1 %40 to i32
  %contract.ok91 = icmp ne i32 %41, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont85
  call void @__polaron_fail(ptr @.contract.460, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont85
  %used94 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !4
  %len96 = load i64, ptr %used95, align 8
  %42 = trunc i64 %len96 to i32
  %cap97 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap98 = load i32, ptr %cap97, align 4, !tbaa !0
  %43 = icmp eq i32 %42, %cap98
  %44 = zext i1 %43 to i32
  %contract.ok99 = icmp ne i32 %44, 0
  br i1 %contract.ok99, label %contract.cont101, label %contract.fail100

contract.fail100:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.461, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont101:                                 ; preds = %contract.cont93
  ret void
}

define internal i32 @"HashMap$Wide$int.get"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$Wide$int.slotFor"(ptr %0, ptr %key22)
  %17 = sext i32 %16 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.462, ptr @.faila.463, i64 %17, ptr @.failb.464, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %17
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"HashMap$Wide$int.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$Wide$int.slotFor"(ptr %0, ptr %key22)
  %17 = sext i32 %16 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.465, ptr @.faila.466, i64 %17, ptr @.failb.467, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used21, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %17
  %elem = load i8, ptr %arr.elem, align 1
  %18 = sext i8 %elem to i32
  %19 = icmp ne i32 %18, 0
  %20 = zext i1 %19 to i32
  ret i32 %20
}

define internal i32 @"HashMap$Wide$int.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca i32, align 4
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  store i32 %2, ptr %defaultValue, align 4
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %17 = call i32 @"HashMap$Wide$int.slotFor"(ptr %0, ptr %key20)
  store i32 %17, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %18 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.468, ptr @.faila.469, i64 %18, ptr @.failb.470, i64 %arr.len, i32 70)
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
  %values24 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %22 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %values25, align 8
  %arr.oob28 = icmp uge i64 %22, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !8

if.end:                                           ; preds = %idx.ok
  %defaultValue34 = load i32, ptr %defaultValue, align 4
  ret i32 %defaultValue34

idx.bad29:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.471, ptr @.faila.472, i64 %22, ptr @.failb.473, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 %22
  %elem33 = load i32, ptr %arr.elem32, align 4
  ret i32 %elem33
}

define internal void @"HashMap$Wide$int.merge"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %value = alloca i32, align 4
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %4 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %7 = icmp slt i32 %count3, %cap4
  %8 = zext i1 %7 to i32
  %inv.assume5 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %9 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %10 = icmp eq i32 %9, %cap8
  %11 = zext i1 %10 to i32
  %inv.assume9 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %12 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %13 = icmp eq i32 %12, %cap13
  %14 = zext i1 %13 to i32
  %inv.assume14 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %15 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %16 = icmp eq i32 %15, %cap18
  %17 = zext i1 %16 to i32
  %inv.assume19 = icmp ne i32 %17, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  %18 = add i32 %count21, 1
  %19 = mul i32 %18, 4
  %cap22 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !0
  %20 = mul i32 %cap23, 3
  %21 = icmp sge i32 %19, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$Wide$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %23 = call i32 @"HashMap$Wide$int.slotFor"(ptr %0, ptr %key24)
  store i32 %23, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %24 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %24, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.474, ptr @.faila.475, i64 %24, ptr @.failb.476, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %28 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %28, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.else:                                          ; preds = %idx.ok
  %values62 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values63 = load ptr, ptr %values62, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i64 = load i32, ptr %i, align 4
  %29 = sext i32 %i64 to i64
  %arr.len65 = load i64, ptr %values63, align 8
  %arr.oob66 = icmp uge i64 %29, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !8

if.end29:                                         ; preds = %idx.ok78, %idx.ok58
  %count83 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count84 = load i32, ptr %count83, align 4, !tbaa !0
  %30 = icmp sge i32 %count84, 0
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.477, ptr @.faila.478, i64 %28, ptr @.failb.479, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %28
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !0
  %32 = add i32 %count41, 1
  store i32 %32, ptr %count39, align 4, !tbaa !0
  %keys42 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %33 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %33, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.480, ptr @.faila.481, i64 %33, ptr @.failb.482, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds %class.Wide, ptr %arr.data49, i64 %33
  %key51 = load ptr, ptr %key, align 8
  %34 = call ptr @memcpy(ptr %arr.elem50, ptr %key51, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  %values52 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %35 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %35, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.483, ptr @.faila.484, i64 %35, ptr @.failb.485, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %35
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  br label %if.end29

idx.bad67:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.486, ptr @.faila.487, i64 %29, ptr @.failb.488, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %if.else
  %arr.data69 = getelementptr i8, ptr %values63, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 %29
  %combine71 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine71, align 8
  %36 = getelementptr ptr, ptr %combine71, i32 1
  %env = load ptr, ptr %36, align 8
  %values72 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values73 = load ptr, ptr %values72, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %37 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %values73, align 8
  %arr.oob76 = icmp uge i64 %37, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad77:                                        ; preds = %idx.ok68
  call void @__polaron_fail(ptr @.fail.489, ptr @.faila.490, i64 %37, ptr @.failb.491, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %idx.ok68
  %arr.data79 = getelementptr i8, ptr %values73, i64 8
  %arr.elem80 = getelementptr inbounds i32, ptr %arr.data79, i64 %37
  %elem81 = load i32, ptr %arr.elem80, align 4
  %value82 = load i32, ptr %value, align 4
  %38 = call i32 %code(ptr %env, i32 %elem81, i32 %value82)
  store i32 %38, ptr %arr.elem70, align 4
  br label %if.end29

contract.fail:                                    ; preds = %if.end29
  %count85 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count86 = load i32, ptr %count85, align 4, !tbaa !0
  %contract.l = sext i32 %count86 to i64
  call void @__polaron_fail(ptr @.contract.492, ptr @.cl.493, i64 %contract.l, ptr @.cr.494, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count87 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count88 = load i32, ptr %count87, align 4, !tbaa !0
  %cap89 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !0
  %39 = icmp slt i32 %count88, %cap90
  %40 = zext i1 %39 to i32
  %contract.ok91 = icmp ne i32 %40, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont
  %count94 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count95 = load i32, ptr %count94, align 4, !tbaa !0
  %cap96 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap97 = load i32, ptr %cap96, align 4, !tbaa !0
  %contract.l98 = sext i32 %count95 to i64
  %contract.r = sext i32 %cap97 to i64
  call void @__polaron_fail(ptr @.contract.495, ptr @.cl.496, i64 %contract.l98, ptr @.cr.497, i64 %contract.r, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont
  %keys99 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys100 = load ptr, ptr %keys99, align 8, !tbaa !4
  %len101 = load i64, ptr %keys100, align 8
  %41 = trunc i64 %len101 to i32
  %cap102 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap103 = load i32, ptr %cap102, align 4, !tbaa !0
  %42 = icmp eq i32 %41, %cap103
  %43 = zext i1 %42 to i32
  %contract.ok104 = icmp ne i32 %43, 0
  br i1 %contract.ok104, label %contract.cont106, label %contract.fail105

contract.fail105:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.498, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont106:                                 ; preds = %contract.cont93
  %values107 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values108 = load ptr, ptr %values107, align 8, !tbaa !4
  %len109 = load i64, ptr %values108, align 8
  %44 = trunc i64 %len109 to i32
  %cap110 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap111 = load i32, ptr %cap110, align 4, !tbaa !0
  %45 = icmp eq i32 %44, %cap111
  %46 = zext i1 %45 to i32
  %contract.ok112 = icmp ne i32 %46, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

contract.fail113:                                 ; preds = %contract.cont106
  call void @__polaron_fail(ptr @.contract.499, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %contract.cont106
  %used115 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used116 = load ptr, ptr %used115, align 8, !tbaa !4
  %len117 = load i64, ptr %used116, align 8
  %47 = trunc i64 %len117 to i32
  %cap118 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap119 = load i32, ptr %cap118, align 4, !tbaa !0
  %48 = icmp eq i32 %47, %cap119
  %49 = zext i1 %48 to i32
  %contract.ok120 = icmp ne i32 %49, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont114
  call void @__polaron_fail(ptr @.contract.500, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont122:                                 ; preds = %contract.cont114
  ret void
}

define internal i32 @"HashMap$Wide$int.remove"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %rv = alloca i32, align 4
  %rk = alloca ptr, align 8
  %Wide.copy83 = alloca %class.Wide, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %Wide.copy = alloca %class.Wide, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Wide.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$Wide$int.slotFor"(ptr %0, ptr %key20)
  store i32 %16, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.501, ptr @.faila.502, i64 %17, ptr @.failb.503, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used22, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %17
  %elem = load i8, ptr %arr.elem, align 1
  %18 = sext i8 %elem to i32
  %19 = icmp eq i32 %18, 0
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %count24 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !0
  %21 = icmp sge i32 %count25, 0
  %22 = zext i1 %21 to i32
  %contract.ok = icmp ne i32 %22, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !0
  %23 = sub i32 %cap49, 1
  store i32 %23, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %24 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %24, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !0
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.504, ptr @.cl.505, i64 %contract.l, ptr @.cr.506, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !0
  %cap30 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !0
  %25 = icmp slt i32 %count29, %cap31
  %26 = zext i1 %25 to i32
  %contract.ok32 = icmp ne i32 %26, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !0
  %cap37 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !0
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.507, ptr @.cl.508, i64 %contract.l39, ptr @.cr.509, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !4
  %len42 = load i64, ptr %used41, align 8
  %27 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !0
  %28 = icmp eq i32 %27, %cap44
  %29 = zext i1 %28 to i32
  %contract.ok45 = icmp ne i32 %29, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.510, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.511, ptr @.faila.512, i64 %24, ptr @.failb.513, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %24
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count61 = load i32, ptr %count60, align 4, !tbaa !0
  %30 = sub i32 %count61, 1
  store i32 %30, ptr %count59, align 4, !tbaa !0
  %i62 = load i32, ptr %i, align 4
  %31 = add i32 %i62, 1
  %mask63 = load i32, ptr %mask, align 4
  %32 = and i32 %31, %mask63
  store i32 %32, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok100, %idx.ok56
  %used64 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j66 = load i32, ptr %j, align 4
  %33 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %33, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !8

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %34 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %34, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

while.end:                                        ; preds = %idx.ok70
  %count110 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count111 = load i32, ptr %count110, align 4, !tbaa !0
  %35 = icmp sge i32 %count111, 0
  %36 = zext i1 %35 to i32
  %contract.ok112 = icmp ne i32 %36, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.514, ptr @.faila.515, i64 %33, ptr @.failb.516, i64 %arr.len67, i32 70)
  unreachable

idx.ok70:                                         ; preds = %while.cond
  %arr.data71 = getelementptr i8, ptr %used65, i64 8
  %arr.elem72 = getelementptr inbounds i8, ptr %arr.data71, i64 %33
  %elem73 = load i8, ptr %arr.elem72, align 1
  %37 = sext i8 %elem73 to i32
  %38 = icmp ne i32 %37, 0
  %39 = zext i1 %38 to i32
  br i1 %38, label %while.body, label %while.end

idx.bad79:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.517, ptr @.faila.518, i64 %34, ptr @.failb.519, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds %class.Wide, ptr %arr.data81, i64 %34
  %40 = call ptr @memcpy(ptr %Wide.copy83, ptr %arr.elem82, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  store ptr %Wide.copy83, ptr %rk, align 8
  %values84 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j86 = load i32, ptr %j, align 4
  %41 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %41, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.520, ptr @.faila.521, i64 %41, ptr @.failb.522, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 %41
  %elem93 = load i32, ptr %arr.elem92, align 4
  store i32 %elem93, ptr %rv, align 4
  %used94 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j96 = load i32, ptr %j, align 4
  %42 = sext i32 %j96 to i64
  %arr.len97 = load i64, ptr %used95, align 8
  %arr.oob98 = icmp uge i64 %42, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.523, ptr @.faila.524, i64 %42, ptr @.failb.525, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %used95, i64 8
  %arr.elem102 = getelementptr inbounds i8, ptr %arr.data101, i64 %42
  store i8 0, ptr %arr.elem102, align 1
  %count103 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count104 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count105 = load i32, ptr %count104, align 4, !tbaa !0
  %43 = sub i32 %count105, 1
  store i32 %43, ptr %count103, align 4, !tbaa !0
  %rk106 = load ptr, ptr %rk, align 8
  %rv107 = load i32, ptr %rv, align 4
  call void @"HashMap$Wide$int.put"(ptr %0, ptr %rk106, i32 %rv107)
  %j108 = load i32, ptr %j, align 4
  %44 = add i32 %j108, 1
  %mask109 = load i32, ptr %mask, align 4
  %45 = and i32 %44, %mask109
  store i32 %45, ptr %j, align 4
  br label %while.cond

contract.fail113:                                 ; preds = %while.end
  %count115 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count116 = load i32, ptr %count115, align 4, !tbaa !0
  %contract.l117 = sext i32 %count116 to i64
  call void @__polaron_fail(ptr @.contract.526, ptr @.cl.527, i64 %contract.l117, ptr @.cr.528, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %while.end
  %count118 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !0
  %cap120 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !0
  %46 = icmp slt i32 %count119, %cap121
  %47 = zext i1 %46 to i32
  %contract.ok122 = icmp ne i32 %47, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont114
  %count125 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !0
  %cap127 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !0
  %contract.l129 = sext i32 %count126 to i64
  %contract.r130 = sext i32 %cap128 to i64
  call void @__polaron_fail(ptr @.contract.529, ptr @.cl.530, i64 %contract.l129, ptr @.cr.531, i64 %contract.r130, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont114
  %used131 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used132 = load ptr, ptr %used131, align 8, !tbaa !4
  %len133 = load i64, ptr %used132, align 8
  %48 = trunc i64 %len133 to i32
  %cap134 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !0
  %49 = icmp eq i32 %48, %cap135
  %50 = zext i1 %49 to i32
  %contract.ok136 = icmp ne i32 %50, 0
  br i1 %contract.ok136, label %contract.cont138, label %contract.fail137

contract.fail137:                                 ; preds = %contract.cont124
  call void @__polaron_fail(ptr @.contract.532, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont138:                                 ; preds = %contract.cont124
  ret i32 1
}

define internal ptr @"HashMap$Wide$int.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  %14 = sext i32 %count21 to i64
  %15 = mul i64 %14, 104
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
  %cap23 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !0
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
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
  %out47 = load ptr, ptr %out, align 8
  ret ptr %out47

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.533, ptr @.faila.534, i64 %20, ptr @.failb.535, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.536, ptr @.faila.537, i64 %26, ptr @.failb.538, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds %class.Wide, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.539, ptr @.faila.540, i64 %27, ptr @.failb.541, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %keys38, i64 8
  %arr.elem45 = getelementptr inbounds %class.Wide, ptr %arr.data44, i64 %27
  %28 = call ptr @memcpy(ptr %arr.elem36, ptr %arr.elem45, i64 ptrtoint (ptr getelementptr (%class.Wide, ptr null, i64 1) to i64))
  %j46 = load i32, ptr %j, align 4
  %29 = add i32 %j46, 1
  store i32 %29, ptr %j, align 4
  br label %if.end
}

define internal ptr @"HashMap$Wide$int.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
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
  %cap23 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !0
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
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
  call void @__polaron_fail(ptr @.fail.542, ptr @.faila.543, i64 %20, ptr @.failb.544, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.545, ptr @.faila.546, i64 %26, ptr @.failb.547, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.548, ptr @.faila.549, i64 %27, ptr @.failb.550, i64 %arr.len40, i32 70)
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

define internal i32 @"HashMap$Wide$int.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  ret i32 %count21
}

define internal i32 @"HashMap$Wide$int.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Wide$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !4
  ret void
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5502)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5504)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @memcpy(ptr, ptr, i64)

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

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"ptr", !2, i64 0}
!6 = !{}
!7 = !{i64 8}
!8 = !{!"branch_weights", i32 1, i32 1048576}
