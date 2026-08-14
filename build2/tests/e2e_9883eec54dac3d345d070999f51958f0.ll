; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/value_struct_keys.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/value_struct_keys.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Point = type { i32, i32 }
%"class.TreeSet$Point" = type { ptr, ptr, i32 }
%"class.HashMap$Point$int" = type { ptr, ptr, ptr, ptr, i32, i32 }
%"class.TreeSetNode$Point" = type { ptr, ptr, ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"TreeSetNode$Point.vtable" = private constant [357 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"TreeSet$Point.vtable" = private constant [357 x ptr] [ptr @"TreeSet$Point.freeSubtree", ptr @"TreeSet$Point.add", ptr @"TreeSet$Point.nodeHeight", ptr @"TreeSet$Point.fixHeight", ptr @"TreeSet$Point.balance", ptr @"TreeSet$Point.rotateRight", ptr @"TreeSet$Point.rotateLeft", ptr @"TreeSet$Point.insertNode", ptr @"TreeSet$Point.contains", ptr @"TreeSet$Point.fill", ptr @"TreeSet$Point.toArray", ptr @"TreeSet$Point.size", ptr @"TreeSet$Point.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"TreeSet$Point.~TreeSet$Point"]
@"HashMap$Point$int.vtable" = private constant [357 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$Point$int.size", ptr @"HashMap$Point$int.isEmpty", ptr null, ptr null, ptr null, ptr @"HashMap$Point$int.slotFor", ptr @"HashMap$Point$int.grow", ptr @"HashMap$Point$int.put", ptr @"HashMap$Point$int.get", ptr @"HashMap$Point$int.containsKey", ptr @"HashMap$Point$int.getOrDefault", ptr @"HashMap$Point$int.merge", ptr @"HashMap$Point$int.remove", ptr @"HashMap$Point$int.keyArray", ptr @"HashMap$Point$int.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$Point$int.~HashMap$Point$int"]
@Object.vtable = private constant [357 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [29 x i8] c"get=%d has55=no treesize=%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [30 x i8] c"get=%d has55=yes treesize=%d\0A\00", align 1
@.panic = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1409:33  in TreeSet$Point.freeSubtree\0A\00", align 1
@.panic.2 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1410:33  in TreeSet$Point.freeSubtree\0A\00", align 1
@.panic.3 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1411:17  in TreeSet$Point.freeSubtree\0A\00", align 1
@.panic.4 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1419:17  in TreeSet$Point.nodeHeight\0A\00", align 1
@.panic.5 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1422:17  in TreeSet$Point.fixHeight\0A\00", align 1
@.panic.6 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1423:17  in TreeSet$Point.fixHeight\0A\00", align 1
@.panic.7 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:41  in TreeSet$Point.fixHeight\0A\00", align 1
@.panic.8 = private unnamed_addr constant [95 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1424:69  in TreeSet$Point.fixHeight\0A\00", align 1
@.panic.9 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$Point.balance\0A\00", align 1
@.panic.10 = private unnamed_addr constant [93 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1427:17  in TreeSet$Point.balance\0A\00", align 1
@.panic.11 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1430:17  in TreeSet$Point.rotateRight\0A\00", align 1
@.panic.12 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$Point.rotateRight\0A\00", align 1
@.panic.13 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1431:24  in TreeSet$Point.rotateRight\0A\00", align 1
@.panic.14 = private unnamed_addr constant [97 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1432:25  in TreeSet$Point.rotateRight\0A\00", align 1
@.panic.15 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1438:17  in TreeSet$Point.rotateLeft\0A\00", align 1
@.panic.16 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$Point.rotateLeft\0A\00", align 1
@.panic.17 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1439:25  in TreeSet$Point.rotateLeft\0A\00", align 1
@.panic.18 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1440:24  in TreeSet$Point.rotateLeft\0A\00", align 1
@.panic.19 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1450:17  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.20 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.21 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1453:31  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.22 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.23 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1455:32  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.24 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:21  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.25 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.26 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1460:66  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.27 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:21  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.28 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.29 = private unnamed_addr constant [96 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1464:68  in TreeSet$Point.insertNode\0A\00", align 1
@.panic.30 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1472:21  in TreeSet$Point.contains\0A\00", align 1
@.panic.31 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:38  in TreeSet$Point.contains\0A\00", align 1
@.panic.32 = private unnamed_addr constant [94 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1474:63  in TreeSet$Point.contains\0A\00", align 1
@.panic.33 = private unnamed_addr constant [90 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1480:17  in TreeSet$Point.fill\0A\00", align 1
@.fail = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1481:24  in TreeSet$Point.fill\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.panic.34 = private unnamed_addr constant [90 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1481:24  in TreeSet$Point.fill\0A\00", align 1
@.panic.35 = private unnamed_addr constant [90 x i8] c"Polaron panic: null reference dereference\0A  --> <prelude>:1483:17  in TreeSet$Point.fill\0A\00", align 1
@.contract.710 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Point$int.HashMap$Point$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.711 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.712 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.713 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Point$int.HashMap$Point$int\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.714 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.715 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.716 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Point$int.HashMap$Point$int\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.717 = private unnamed_addr constant [143 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Point$int.HashMap$Point$int\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.718 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Point$int.HashMap$Point$int\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.719 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$Point$int.slotFor\0A\00", align 1
@.faila.720 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.721 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.722 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$Point$int.slotFor\0A\00", align 1
@.faila.723 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.724 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.725 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$Point$int.grow\0A\00", align 1
@.faila.726 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.727 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.728 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$Point$int.grow\0A\00", align 1
@.faila.729 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.730 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.731 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$Point$int.grow\0A\00", align 1
@.faila.732 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.733 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.734 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$Point$int.grow\0A\00", align 1
@.faila.735 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.736 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.737 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$Point$int.grow\0A\00", align 1
@.faila.738 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.739 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.740 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$Point$int.grow\0A\00", align 1
@.faila.741 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.742 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.743 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$Point$int.grow\0A\00", align 1
@.faila.744 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.745 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.746 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$Point$int.grow\0A\00", align 1
@.faila.747 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.748 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.749 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Point$int.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.750 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.751 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.752 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Point$int.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.753 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.754 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.755 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Point$int.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.756 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Point$int.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.757 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Point$int.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.758 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$Point$int.put\0A\00", align 1
@.faila.759 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.760 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.761 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$Point$int.put\0A\00", align 1
@.faila.762 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.763 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.764 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$Point$int.put\0A\00", align 1
@.faila.765 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.766 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.767 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$Point$int.put\0A\00", align 1
@.faila.768 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.769 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.770 = private unnamed_addr constant [112 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Point$int.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.771 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.772 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.773 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Point$int.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.774 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.775 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.776 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Point$int.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.777 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Point$int.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.778 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Point$int.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.779 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$Point$int.get\0A\00", align 1
@.faila.780 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.781 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.782 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$Point$int.containsKey\0A\00", align 1
@.faila.783 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.784 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.785 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$Point$int.getOrDefault\0A\00", align 1
@.faila.786 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.787 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.788 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$Point$int.getOrDefault\0A\00", align 1
@.faila.789 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.790 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.791 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$Point$int.merge\0A\00", align 1
@.faila.792 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.793 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.794 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$Point$int.merge\0A\00", align 1
@.faila.795 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.796 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.797 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$Point$int.merge\0A\00", align 1
@.faila.798 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.799 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.800 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$Point$int.merge\0A\00", align 1
@.faila.801 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.802 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.803 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$Point$int.merge\0A\00", align 1
@.faila.804 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.805 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.806 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$Point$int.merge\0A\00", align 1
@.faila.807 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.808 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.809 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Point$int.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.810 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.811 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.812 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Point$int.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.813 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.814 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.815 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$Point$int.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.816 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$Point$int.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.817 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Point$int.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.818 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$Point$int.remove\0A\00", align 1
@.faila.819 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.820 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.821 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Point$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.822 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.823 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.824 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Point$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.825 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.826 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.827 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Point$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.828 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$Point$int.remove\0A\00", align 1
@.faila.829 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.830 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.831 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$Point$int.remove\0A\00", align 1
@.faila.832 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.833 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.834 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$Point$int.remove\0A\00", align 1
@.faila.835 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.836 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.837 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$Point$int.remove\0A\00", align 1
@.faila.838 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.839 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.840 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$Point$int.remove\0A\00", align 1
@.faila.841 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.842 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.843 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$Point$int.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.844 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.845 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.846 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$Point$int.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.847 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.848 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.849 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$Point$int.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.850 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$Point$int.keyArray\0A\00", align 1
@.faila.851 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.852 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.853 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$Point$int.keyArray\0A\00", align 1
@.faila.854 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.855 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.856 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$Point$int.keyArray\0A\00", align 1
@.faila.857 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.858 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.859 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$Point$int.valueArray\0A\00", align 1
@.faila.860 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.861 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.862 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$Point$int.valueArray\0A\00", align 1
@.faila.863 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.864 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.865 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$Point$int.valueArray\0A\00", align 1
@.faila.866 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.867 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5502 = private constant [1 x i8] zeroinitializer
@.strobj.5503 = private global %String { i64 0, ptr @.strdata.5502, i64 0 }
@.strdata.5504 = private constant [1 x i8] zeroinitializer
@.strobj.5505 = private global %String { i64 0, ptr @.strdata.5504, i64 0 }

define internal void @Point.Point(ptr %0, i32 %1, i32 %2) {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  %x1 = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x2 = load i32, ptr %x, align 4
  store i32 %x2, ptr %x1, align 4, !tbaa !0
  %y3 = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y4 = load i32, ptr %y, align 4
  store i32 %y4, ptr %y3, align 4, !tbaa !0
  ret void
}

define internal i32 @Point.equalsKey(ptr nonnull align 4 dereferenceable(8) %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %other, align 8
  %x = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %other2 = load ptr, ptr %other, align 8
  %x3 = getelementptr inbounds %class.Point, ptr %other2, i32 0, i32 0
  %x4 = load i32, ptr %x3, align 4, !tbaa !0
  %3 = icmp eq i32 %x1, %x4
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %y = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y5 = load i32, ptr %y, align 4, !tbaa !0
  %other6 = load ptr, ptr %other, align 8
  %y7 = getelementptr inbounds %class.Point, ptr %other6, i32 0, i32 1
  %y8 = load i32, ptr %y7, align 4, !tbaa !0
  %5 = icmp eq i32 %y5, %y8
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  ret i32 %7
}

define internal i64 @Point.hash(ptr nonnull align 4 dereferenceable(8) %0) {
entry:
  %x = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %1 = sext i32 %x1 to i64
  %2 = add i64 527, %1
  %3 = mul i64 %2, 31
  %y = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y2 = load i32, ptr %y, align 4, !tbaa !0
  %4 = sext i32 %y2 to i64
  %5 = add i64 %3, %4
  ret i64 %5
}

define internal i32 @Point.compareTo(ptr nonnull align 4 dereferenceable(8) %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %other = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %other, align 8
  %x = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x1 = load i32, ptr %x, align 4, !tbaa !0
  %other2 = load ptr, ptr %other, align 8
  %x3 = getelementptr inbounds %class.Point, ptr %other2, i32 0, i32 0
  %x4 = load i32, ptr %x3, align 4, !tbaa !0
  %3 = icmp slt i32 %x1, %x4
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 -1

if.end:                                           ; preds = %entry
  %x5 = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 0
  %x6 = load i32, ptr %x5, align 4, !tbaa !0
  %other7 = load ptr, ptr %other, align 8
  %x8 = getelementptr inbounds %class.Point, ptr %other7, i32 0, i32 0
  %x9 = load i32, ptr %x8, align 4, !tbaa !0
  %5 = icmp sgt i32 %x6, %x9
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then10, label %if.end11

if.then10:                                        ; preds = %if.end
  ret i32 1

if.end11:                                         ; preds = %if.end
  %y = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y12 = load i32, ptr %y, align 4, !tbaa !0
  %other13 = load ptr, ptr %other, align 8
  %y14 = getelementptr inbounds %class.Point, ptr %other13, i32 0, i32 1
  %y15 = load i32, ptr %y14, align 4, !tbaa !0
  %7 = icmp slt i32 %y12, %y15
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then16, label %if.end17

if.then16:                                        ; preds = %if.end11
  ret i32 -1

if.end17:                                         ; preds = %if.end11
  %y18 = getelementptr inbounds %class.Point, ptr %0, i32 0, i32 1
  %y19 = load i32, ptr %y18, align 4, !tbaa !0
  %other20 = load ptr, ptr %other, align 8
  %y21 = getelementptr inbounds %class.Point, ptr %other20, i32 0, i32 1
  %y22 = load i32, ptr %y21, align 4, !tbaa !0
  %9 = icmp sgt i32 %y19, %y22
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then23, label %if.end24

if.then23:                                        ; preds = %if.end17
  ret i32 1

if.end24:                                         ; preds = %if.end17
  ret i32 0
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
  %"TreeSet$Point.obj" = alloca %"class.TreeSet$Point", align 8
  %Point.obj12 = alloca %class.Point, align 8
  %has55 = alloca i32, align 4
  %got = alloca i32, align 4
  %d = alloca ptr, align 8
  %Point.obj2 = alloca %class.Point, align 8
  %b = alloca ptr, align 8
  %Point.obj1 = alloca %class.Point, align 8
  %a = alloca ptr, align 8
  %Point.obj = alloca %class.Point, align 8
  %m = alloca ptr, align 8
  %"HashMap$Point$int.obj" = alloca %"class.HashMap$Point$int", align 8
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
  call void @"HashMap$Point$int.HashMap$Point$int"(ptr %"HashMap$Point$int.obj")
  store ptr %"HashMap$Point$int.obj", ptr %m, align 8
  call void @Point.Point(ptr %Point.obj, i32 1, i32 2)
  store ptr %Point.obj, ptr %a, align 8
  call void @Point.Point(ptr %Point.obj1, i32 1, i32 2)
  store ptr %Point.obj1, ptr %b, align 8
  call void @Point.Point(ptr %Point.obj2, i32 9, i32 9)
  store ptr %Point.obj2, ptr %d, align 8
  %m3 = load ptr, ptr %m, align 8
  %a4 = load ptr, ptr %a, align 8
  call void @"HashMap$Point$int.put"(ptr %m3, ptr %a4, i32 100)
  %m5 = load ptr, ptr %m, align 8
  %d6 = load ptr, ptr %d, align 8
  call void @"HashMap$Point$int.put"(ptr %m5, ptr %d6, i32 7)
  store i32 -1, ptr %got, align 4
  %m7 = load ptr, ptr %m, align 8
  %b8 = load ptr, ptr %b, align 8
  %16 = call i32 @"HashMap$Point$int.containsKey"(ptr %m7, ptr %b8)
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  %m9 = load ptr, ptr %m, align 8
  %b10 = load ptr, ptr %b, align 8
  %18 = call i32 @"HashMap$Point$int.get"(ptr %m9, ptr %b10)
  store i32 %18, ptr %got, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %argv.end
  store i32 0, ptr %has55, align 4
  %m11 = load ptr, ptr %m, align 8
  call void @Point.Point(ptr %Point.obj12, i32 5, i32 5)
  %19 = call i32 @"HashMap$Point$int.containsKey"(ptr %m11, ptr %Point.obj12)
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end
  store i32 1, ptr %has55, align 4
  br label %if.end14

if.end14:                                         ; preds = %if.then13, %if.end
  call void @"TreeSet$Point.TreeSet$Point"(ptr %"TreeSet$Point.obj")
  store ptr %"TreeSet$Point.obj", ptr %s, align 8
  %s15 = load ptr, ptr %s, align 8
  %a16 = load ptr, ptr %a, align 8
  call void @"TreeSet$Point.add"(ptr %s15, ptr %a16)
  %s17 = load ptr, ptr %s, align 8
  %b18 = load ptr, ptr %b, align 8
  call void @"TreeSet$Point.add"(ptr %s17, ptr %b18)
  %s19 = load ptr, ptr %s, align 8
  %d20 = load ptr, ptr %d, align 8
  call void @"TreeSet$Point.add"(ptr %s19, ptr %d20)
  %has5521 = load i32, ptr %has55, align 4
  %21 = icmp eq i32 %has5521, 0
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then22, label %if.else

if.then22:                                        ; preds = %if.end14
  %got24 = load i32, ptr %got, align 4
  %s25 = load ptr, ptr %s, align 8
  %23 = call i32 @"TreeSet$Point.size"(ptr %s25)
  %24 = call i32 (ptr, ...) @printf(ptr @.str, i32 %got24, i32 %23)
  br label %if.end23

if.else:                                          ; preds = %if.end14
  %got26 = load i32, ptr %got, align 4
  %s27 = load ptr, ptr %s, align 8
  %25 = call i32 @"TreeSet$Point.size"(ptr %s27)
  %26 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %got26, i32 %25)
  br label %if.end23

if.end23:                                         ; preds = %if.else, %if.then22
  ret i32 0
}

define internal void @"TreeSet$Point.TreeSet$Point"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 0
  store ptr @"TreeSet$Point.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %root = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
  store ptr null, ptr %root, align 8, !tbaa !4
  %count = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !0
  ret void
}

define internal void @"TreeSet$Point.~TreeSet$Point"(ptr %0) {
entry:
  %root = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
  %root1 = load ptr, ptr %root, align 8, !tbaa !4
  call void @"TreeSet$Point.freeSubtree"(ptr %0, ptr %root1)
  %root2 = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
  store ptr null, ptr %root2, align 8, !tbaa !4
  %count = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !0
  ret void
}

define internal void @"TreeSet$Point.freeSubtree"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n2, i32 0, i32 2
  %left3 = load ptr, ptr %left, align 8, !tbaa !4
  call void @"TreeSet$Point.freeSubtree"(ptr %0, ptr %left3)
  %n4 = load ptr, ptr %n, align 8
  %5 = icmp eq ptr %n4, null
  br i1 %5, label %nullrecv5, label %nullrecv.ok6

nullrecv5:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

nullrecv.ok6:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n4, i32 0, i32 3
  %right7 = load ptr, ptr %right, align 8, !tbaa !4
  call void @"TreeSet$Point.freeSubtree"(ptr %0, ptr %right7)
  %n8 = load ptr, ptr %n, align 8
  %6 = icmp eq ptr %n8, null
  br i1 %6, label %nullrecv9, label %nullrecv.ok10

nullrecv9:                                        ; preds = %nullrecv.ok6
  call void @__polaron_panic(ptr @.panic.3)
  unreachable

nullrecv.ok10:                                    ; preds = %nullrecv.ok6
  call void @__polaron_check_live(ptr %n8)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n8, i32 0, i32 0
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

define internal void @"TreeSet$Point.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %value = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %value, align 8
  %root = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
  %root1 = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root1, align 8, !tbaa !4
  %value3 = load ptr, ptr %value, align 8
  %3 = call ptr @"TreeSet$Point.insertNode"(ptr %0, ptr %root2, ptr %value3)
  store ptr %3, ptr %root, align 8, !tbaa !4
  ret void
}

define internal i32 @"TreeSet$Point.nodeHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
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
  call void @__polaron_panic(ptr @.panic.4)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %height = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n2, i32 0, i32 4
  %height3 = load i32, ptr %height, align 4, !tbaa !0
  ret i32 %height3
}

define internal void @"TreeSet$Point.fixHeight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %rh = alloca i32, align 4
  %lh = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.5)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !4
  %3 = call i32 @"TreeSet$Point.nodeHeight"(ptr %0, ptr %left2)
  store i32 %3, ptr %lh, align 4
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.6)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !4
  %5 = call i32 @"TreeSet$Point.nodeHeight"(ptr %0, ptr %right6)
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
  call void @__polaron_panic(ptr @.panic.7)
  unreachable

nullrecv.ok11:                                    ; preds = %if.then
  %height = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n9, i32 0, i32 4
  %lh12 = load i32, ptr %lh, align 4
  %10 = add i32 %lh12, 1
  store i32 %10, ptr %height, align 4, !tbaa !0
  br label %if.end

nullrecv14:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.8)
  unreachable

nullrecv.ok15:                                    ; preds = %if.else
  %height16 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n13, i32 0, i32 4
  %rh17 = load i32, ptr %rh, align 4
  %11 = add i32 %rh17, 1
  store i32 %11, ptr %height16, align 4, !tbaa !0
  br label %if.end
}

define internal i32 @"TreeSet$Point.balance"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca ptr, align 8
  store ptr %1, ptr %n, align 8
  %n1 = load ptr, ptr %n, align 8
  %2 = icmp eq ptr %n1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.9)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !4
  %3 = call i32 @"TreeSet$Point.nodeHeight"(ptr %0, ptr %left2)
  %n3 = load ptr, ptr %n, align 8
  %4 = icmp eq ptr %n3, null
  br i1 %4, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.10)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %n3, i32 0, i32 3
  %right6 = load ptr, ptr %right, align 8, !tbaa !4
  %5 = call i32 @"TreeSet$Point.nodeHeight"(ptr %0, ptr %right6)
  %6 = sub i32 %3, %5
  ret i32 %6
}

define internal ptr @"TreeSet$Point.rotateRight"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %x = alloca ptr, align 8
  %y = alloca ptr, align 8
  store ptr %1, ptr %y, align 8
  %y1 = load ptr, ptr %y, align 8
  %2 = icmp eq ptr %y1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.11)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %y1, i32 0, i32 2
  %left2 = load ptr, ptr %left, align 8, !tbaa !4
  store ptr %left2, ptr %x, align 8
  %y3 = load ptr, ptr %y, align 8
  %3 = icmp eq ptr %y3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.12)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %left6 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %y3, i32 0, i32 2
  %x7 = load ptr, ptr %x, align 8
  %4 = icmp eq ptr %x7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.13)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %x7, i32 0, i32 3
  %right10 = load ptr, ptr %right, align 8, !tbaa !4
  store ptr %right10, ptr %left6, align 8, !tbaa !4
  %x11 = load ptr, ptr %x, align 8
  %5 = icmp eq ptr %x11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.14)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %right14 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %x11, i32 0, i32 3
  %y15 = load ptr, ptr %y, align 8
  store ptr %y15, ptr %right14, align 8, !tbaa !4
  %y16 = load ptr, ptr %y, align 8
  call void @"TreeSet$Point.fixHeight"(ptr %0, ptr %y16)
  %x17 = load ptr, ptr %x, align 8
  call void @"TreeSet$Point.fixHeight"(ptr %0, ptr %x17)
  %x18 = load ptr, ptr %x, align 8
  ret ptr %x18
}

define internal ptr @"TreeSet$Point.rotateLeft"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %y = alloca ptr, align 8
  %x = alloca ptr, align 8
  store ptr %1, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %2 = icmp eq ptr %x1, null
  br i1 %2, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %entry
  call void @__polaron_panic(ptr @.panic.15)
  unreachable

nullrecv.ok:                                      ; preds = %entry
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %x1, i32 0, i32 3
  %right2 = load ptr, ptr %right, align 8, !tbaa !4
  store ptr %right2, ptr %y, align 8
  %x3 = load ptr, ptr %x, align 8
  %3 = icmp eq ptr %x3, null
  br i1 %3, label %nullrecv4, label %nullrecv.ok5

nullrecv4:                                        ; preds = %nullrecv.ok
  call void @__polaron_panic(ptr @.panic.16)
  unreachable

nullrecv.ok5:                                     ; preds = %nullrecv.ok
  %right6 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %x3, i32 0, i32 3
  %y7 = load ptr, ptr %y, align 8
  %4 = icmp eq ptr %y7, null
  br i1 %4, label %nullrecv8, label %nullrecv.ok9

nullrecv8:                                        ; preds = %nullrecv.ok5
  call void @__polaron_panic(ptr @.panic.17)
  unreachable

nullrecv.ok9:                                     ; preds = %nullrecv.ok5
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %y7, i32 0, i32 2
  %left10 = load ptr, ptr %left, align 8, !tbaa !4
  store ptr %left10, ptr %right6, align 8, !tbaa !4
  %y11 = load ptr, ptr %y, align 8
  %5 = icmp eq ptr %y11, null
  br i1 %5, label %nullrecv12, label %nullrecv.ok13

nullrecv12:                                       ; preds = %nullrecv.ok9
  call void @__polaron_panic(ptr @.panic.18)
  unreachable

nullrecv.ok13:                                    ; preds = %nullrecv.ok9
  %left14 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %y11, i32 0, i32 2
  %x15 = load ptr, ptr %x, align 8
  store ptr %x15, ptr %left14, align 8, !tbaa !4
  %x16 = load ptr, ptr %x, align 8
  call void @"TreeSet$Point.fixHeight"(ptr %0, ptr %x16)
  %y17 = load ptr, ptr %y, align 8
  call void @"TreeSet$Point.fixHeight"(ptr %0, ptr %y17)
  %y18 = load ptr, ptr %y, align 8
  ret ptr %y18
}

define internal ptr @"TreeSet$Point.insertNode"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2) {
entry:
  %bf = alloca i32, align 4
  %c = alloca i32, align 4
  %Point.copy = alloca %class.Point, align 8
  %value = alloca ptr, align 8
  %node = alloca ptr, align 8
  store ptr %1, ptr %node, align 8
  %3 = call ptr @memcpy(ptr %Point.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %value, align 8
  %node1 = load ptr, ptr %node, align 8
  %4 = icmp eq ptr %node1, null
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %count = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  %count2 = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %6 = add i32 %count3, 1
  store i32 %6, ptr %count, align 4, !tbaa !0
  %"TreeSetNode$Point.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.TreeSetNode$Point", ptr null, i64 1) to i64))
  %value4 = load ptr, ptr %value, align 8
  call void @"TreeSetNode$Point.TreeSetNode$Point"(ptr %"TreeSetNode$Point.obj", ptr %value4)
  ret ptr %"TreeSetNode$Point.obj"

if.end:                                           ; preds = %entry
  %value5 = load ptr, ptr %value, align 8
  %node6 = load ptr, ptr %node, align 8
  %7 = icmp eq ptr %node6, null
  br i1 %7, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end
  call void @__polaron_panic(ptr @.panic.19)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %value7 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node6, i32 0, i32 1
  %value8 = load ptr, ptr %value7, align 8, !tbaa !4
  %8 = call i32 @Point.compareTo(ptr %value5, ptr %value8)
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
  call void @"TreeSet$Point.fixHeight"(ptr %0, ptr %node34)
  %node35 = load ptr, ptr %node, align 8
  %15 = call i32 @"TreeSet$Point.balance"(ptr %0, ptr %node35)
  store i32 %15, ptr %bf, align 4
  %bf36 = load i32, ptr %bf, align 4
  %16 = icmp sgt i32 %bf36, 1
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then37, label %if.end38

nullrecv17:                                       ; preds = %if.then14
  call void @__polaron_panic(ptr @.panic.20)
  unreachable

nullrecv.ok18:                                    ; preds = %if.then14
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node16, i32 0, i32 2
  %node19 = load ptr, ptr %node, align 8
  %18 = icmp eq ptr %node19, null
  br i1 %18, label %nullrecv20, label %nullrecv.ok21

nullrecv20:                                       ; preds = %nullrecv.ok18
  call void @__polaron_panic(ptr @.panic.21)
  unreachable

nullrecv.ok21:                                    ; preds = %nullrecv.ok18
  %left22 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node19, i32 0, i32 2
  %left23 = load ptr, ptr %left22, align 8, !tbaa !4
  %value24 = load ptr, ptr %value, align 8
  %19 = call ptr @"TreeSet$Point.insertNode"(ptr %0, ptr %left23, ptr %value24)
  store ptr %19, ptr %left, align 8, !tbaa !4
  br label %if.end15

nullrecv26:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.22)
  unreachable

nullrecv.ok27:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node25, i32 0, i32 3
  %node28 = load ptr, ptr %node, align 8
  %20 = icmp eq ptr %node28, null
  br i1 %20, label %nullrecv29, label %nullrecv.ok30

nullrecv29:                                       ; preds = %nullrecv.ok27
  call void @__polaron_panic(ptr @.panic.23)
  unreachable

nullrecv.ok30:                                    ; preds = %nullrecv.ok27
  %right31 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node28, i32 0, i32 3
  %right32 = load ptr, ptr %right31, align 8, !tbaa !4
  %value33 = load ptr, ptr %value, align 8
  %21 = call ptr @"TreeSet$Point.insertNode"(ptr %0, ptr %right32, ptr %value33)
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
  call void @__polaron_panic(ptr @.panic.24)
  unreachable

nullrecv.ok41:                                    ; preds = %if.then37
  %left42 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node39, i32 0, i32 2
  %left43 = load ptr, ptr %left42, align 8, !tbaa !4
  %25 = call i32 @"TreeSet$Point.balance"(ptr %0, ptr %left43)
  %26 = icmp slt i32 %25, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then44, label %if.end45

if.then44:                                        ; preds = %nullrecv.ok41
  %node46 = load ptr, ptr %node, align 8
  %28 = icmp eq ptr %node46, null
  br i1 %28, label %nullrecv47, label %nullrecv.ok48

if.end45:                                         ; preds = %nullrecv.ok52, %nullrecv.ok41
  %node55 = load ptr, ptr %node, align 8
  %29 = call ptr @"TreeSet$Point.rotateRight"(ptr %0, ptr %node55)
  ret ptr %29

nullrecv47:                                       ; preds = %if.then44
  call void @__polaron_panic(ptr @.panic.25)
  unreachable

nullrecv.ok48:                                    ; preds = %if.then44
  %left49 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node46, i32 0, i32 2
  %node50 = load ptr, ptr %node, align 8
  %30 = icmp eq ptr %node50, null
  br i1 %30, label %nullrecv51, label %nullrecv.ok52

nullrecv51:                                       ; preds = %nullrecv.ok48
  call void @__polaron_panic(ptr @.panic.26)
  unreachable

nullrecv.ok52:                                    ; preds = %nullrecv.ok48
  %left53 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node50, i32 0, i32 2
  %left54 = load ptr, ptr %left53, align 8, !tbaa !4
  %31 = call ptr @"TreeSet$Point.rotateLeft"(ptr %0, ptr %left54)
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
  call void @__polaron_panic(ptr @.panic.27)
  unreachable

nullrecv.ok61:                                    ; preds = %if.then57
  %right62 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node59, i32 0, i32 3
  %right63 = load ptr, ptr %right62, align 8, !tbaa !4
  %33 = call i32 @"TreeSet$Point.balance"(ptr %0, ptr %right63)
  %34 = icmp sgt i32 %33, 0
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then64, label %if.end65

if.then64:                                        ; preds = %nullrecv.ok61
  %node66 = load ptr, ptr %node, align 8
  %36 = icmp eq ptr %node66, null
  br i1 %36, label %nullrecv67, label %nullrecv.ok68

if.end65:                                         ; preds = %nullrecv.ok72, %nullrecv.ok61
  %node75 = load ptr, ptr %node, align 8
  %37 = call ptr @"TreeSet$Point.rotateLeft"(ptr %0, ptr %node75)
  ret ptr %37

nullrecv67:                                       ; preds = %if.then64
  call void @__polaron_panic(ptr @.panic.28)
  unreachable

nullrecv.ok68:                                    ; preds = %if.then64
  %right69 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node66, i32 0, i32 3
  %node70 = load ptr, ptr %node, align 8
  %38 = icmp eq ptr %node70, null
  br i1 %38, label %nullrecv71, label %nullrecv.ok72

nullrecv71:                                       ; preds = %nullrecv.ok68
  call void @__polaron_panic(ptr @.panic.29)
  unreachable

nullrecv.ok72:                                    ; preds = %nullrecv.ok68
  %right73 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node70, i32 0, i32 3
  %right74 = load ptr, ptr %right73, align 8, !tbaa !4
  %39 = call ptr @"TreeSet$Point.rotateRight"(ptr %0, ptr %right74)
  store ptr %39, ptr %right69, align 8, !tbaa !4
  br label %if.end65
}

define internal i32 @"TreeSet$Point.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %c = alloca i32, align 4
  %cur = alloca ptr, align 8
  %Point.copy = alloca %class.Point, align 8
  %value = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %value, align 8
  %root = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
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
  call void @__polaron_panic(ptr @.panic.30)
  unreachable

nullrecv.ok:                                      ; preds = %while.body
  %value5 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %cur4, i32 0, i32 1
  %value6 = load ptr, ptr %value5, align 8, !tbaa !4
  %6 = call i32 @Point.compareTo(ptr %value3, ptr %value6)
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
  call void @__polaron_panic(ptr @.panic.31)
  unreachable

nullrecv.ok13:                                    ; preds = %if.then9
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %cur11, i32 0, i32 2
  %left14 = load ptr, ptr %left, align 8, !tbaa !4
  store ptr %left14, ptr %cur, align 8
  br label %if.end10

nullrecv16:                                       ; preds = %if.else
  call void @__polaron_panic(ptr @.panic.32)
  unreachable

nullrecv.ok17:                                    ; preds = %if.else
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %cur15, i32 0, i32 3
  %right18 = load ptr, ptr %right, align 8, !tbaa !4
  store ptr %right18, ptr %cur, align 8
  br label %if.end10
}

define internal i32 @"TreeSet$Point.fill"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, i32 %3) {
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
  call void @__polaron_panic(ptr @.panic.33)
  unreachable

nullrecv.ok:                                      ; preds = %if.end
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node3, i32 0, i32 2
  %left4 = load ptr, ptr %left, align 8, !tbaa !4
  %out5 = load ptr, ptr %out, align 8
  %idx6 = load i32, ptr %idx, align 4
  %7 = call i32 @"TreeSet$Point.fill"(ptr %0, ptr %left4, ptr %out5, i32 %idx6)
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
  %arr.elem = getelementptr inbounds %class.Point, ptr %arr.data, i64 %8
  %node9 = load ptr, ptr %node, align 8
  %9 = icmp eq ptr %node9, null
  br i1 %9, label %nullrecv10, label %nullrecv.ok11

nullrecv10:                                       ; preds = %idx.ok
  call void @__polaron_panic(ptr @.panic.34)
  unreachable

nullrecv.ok11:                                    ; preds = %idx.ok
  %value = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node9, i32 0, i32 1
  %value12 = load ptr, ptr %value, align 8, !tbaa !4
  %10 = call ptr @memcpy(ptr %arr.elem, ptr %value12, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  %i13 = load i32, ptr %i, align 4
  %11 = add i32 %i13, 1
  store i32 %11, ptr %i, align 4
  %node14 = load ptr, ptr %node, align 8
  %12 = icmp eq ptr %node14, null
  br i1 %12, label %nullrecv15, label %nullrecv.ok16

nullrecv15:                                       ; preds = %nullrecv.ok11
  call void @__polaron_panic(ptr @.panic.35)
  unreachable

nullrecv.ok16:                                    ; preds = %nullrecv.ok11
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %node14, i32 0, i32 3
  %right17 = load ptr, ptr %right, align 8, !tbaa !4
  %out18 = load ptr, ptr %out, align 8
  %i19 = load i32, ptr %i, align 4
  %13 = call i32 @"TreeSet$Point.fill"(ptr %0, ptr %right17, ptr %out18, i32 %i19)
  ret i32 %13
}

define internal ptr @"TreeSet$Point.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 8
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  %root = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 1
  %root2 = load ptr, ptr %root, align 8, !tbaa !4
  %out3 = load ptr, ptr %out, align 8
  %5 = call i32 @"TreeSet$Point.fill"(ptr %0, ptr %root2, ptr %out3, i32 0)
  %out4 = load ptr, ptr %out, align 8
  ret ptr %out4
}

define internal i32 @"TreeSet$Point.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  ret i32 %count1
}

define internal i32 @"TreeSet$Point.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.TreeSet$Point", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"TreeSetNode$Point.TreeSetNode$Point"(ptr %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %v = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %v, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.TreeSetNode$Point", ptr %0, i32 0, i32 0
  store ptr @"TreeSetNode$Point.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %value = getelementptr inbounds %"class.TreeSetNode$Point", ptr %0, i32 0, i32 1
  store ptr null, ptr %value, align 8, !tbaa !4
  %value1 = getelementptr inbounds %"class.TreeSetNode$Point", ptr %0, i32 0, i32 1
  %v2 = load ptr, ptr %v, align 8
  %Point.copy3 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  %3 = call ptr @memcpy(ptr %Point.copy3, ptr %v2, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy3, ptr %value1, align 8, !tbaa !4
  %left = getelementptr inbounds %"class.TreeSetNode$Point", ptr %0, i32 0, i32 2
  store ptr null, ptr %left, align 8, !tbaa !4
  %right = getelementptr inbounds %"class.TreeSetNode$Point", ptr %0, i32 0, i32 3
  store ptr null, ptr %right, align 8, !tbaa !4
  %height = getelementptr inbounds %"class.TreeSetNode$Point", ptr %0, i32 0, i32 4
  store i32 1, ptr %height, align 4, !tbaa !0
  ret void
}

define internal void @"HashMap$Point$int.HashMap$Point$int"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 0
  store ptr @"HashMap$Point$int.vtable", ptr %vtbl.addr, align 8, !tbaa !4
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !4
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !4
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !0
  %keys1 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %keys1, align 8, !tbaa !4
  %values2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 32)
  store ptr %arr3, ptr %values2, align 8, !tbaa !4
  %used5 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !4
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !0
  %count8 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !0
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !0
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.710, ptr @.cl.711, i64 %contract.l, ptr @.cr.712, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !0
  %cap14 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !0
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !0
  %cap21 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !0
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.713, ptr @.cl.714, i64 %contract.l23, ptr @.cr.715, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !4
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.716, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !4
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.717, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !4
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !0
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.718, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$Point$int.~HashMap$Point$int"(ptr %0) {
entry:
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys1 = load ptr, ptr %keys, align 8, !tbaa !4
  call void @__polaron_free(ptr %keys1)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !4
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used3 = load ptr, ptr %used, align 8, !tbaa !4
  call void @__polaron_free(ptr %used3)
  ret void
}

define internal i32 @"HashMap$Point$int.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !0
  %16 = sub i32 %cap21, 1
  store i32 %16, ptr %mask, align 4
  %key22 = load ptr, ptr %key, align 8
  %17 = call i64 @Point.hash(ptr %key22)
  %18 = trunc i64 %17 to i32
  %mask23 = load i32, ptr %mask, align 4
  %19 = and i32 %18, %mask23
  store i32 %19, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %used24 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %20 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.719, ptr @.faila.720, i64 %20, ptr @.failb.721, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.722, ptr @.faila.723, i64 %21, ptr @.failb.724, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %keys28, i64 8
  %arr.elem35 = getelementptr inbounds %class.Point, ptr %arr.data34, i64 %21
  %key36 = load ptr, ptr %key, align 8
  %25 = call i32 @Point.equalsKey(ptr %arr.elem35, ptr %key36)
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

define internal void @"HashMap$Point$int.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !0
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !4
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !4
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !4
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !0
  %keys30 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !0
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 8
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !4
  %values33 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !0
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 4
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !4
  %used38 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !0
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !4
  %cap43 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
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
  %count118 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !0
  %33 = icmp sge i32 %count119, 0
  %34 = zext i1 %33 to i32
  %contract.ok = icmp ne i32 %34, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.725, ptr @.faila.726, i64 %30, ptr @.failb.727, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.728, ptr @.faila.729, i64 %38, ptr @.failb.730, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %if.then
  %arr.data56 = getelementptr i8, ptr %oldK50, i64 8
  %arr.elem57 = getelementptr inbounds %class.Point, ptr %arr.data56, i64 %38
  %39 = call i64 @Point.hash(ptr %arr.elem57)
  %40 = trunc i64 %39 to i32
  %mask58 = load i32, ptr %mask, align 4
  %41 = and i32 %40, %mask58
  store i32 %41, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %idx.ok55
  %used59 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
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
  %used71 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used72 = load ptr, ptr %used71, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i73 = load i32, ptr %i, align 4
  %45 = sext i32 %i73 to i64
  %arr.len74 = load i64, ptr %used72, align 8
  %arr.oob75 = icmp uge i64 %45, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !8

idx.bad64:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.731, ptr @.faila.732, i64 %42, ptr @.failb.733, i64 %arr.len62, i32 70)
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
  call void @__polaron_fail(ptr @.fail.734, ptr @.faila.735, i64 %45, ptr @.failb.736, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %while.end
  %arr.data78 = getelementptr i8, ptr %used72, i64 8
  %arr.elem79 = getelementptr inbounds i8, ptr %arr.data78, i64 %45
  store i8 1, ptr %arr.elem79, align 1
  %keys80 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys81 = load ptr, ptr %keys80, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i82 = load i32, ptr %i, align 4
  %49 = sext i32 %i82 to i64
  %arr.len83 = load i64, ptr %keys81, align 8
  %arr.oob84 = icmp uge i64 %49, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !8

idx.bad85:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.737, ptr @.faila.738, i64 %49, ptr @.failb.739, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok77
  %arr.data87 = getelementptr i8, ptr %keys81, i64 8
  %arr.elem88 = getelementptr inbounds %class.Point, ptr %arr.data87, i64 %49
  %oldK89 = load ptr, ptr %oldK, align 8, !nonnull !6, !dereferenceable !7
  %j90 = load i32, ptr %j, align 4
  %50 = sext i32 %j90 to i64
  %arr.len91 = load i64, ptr %oldK89, align 8
  %arr.oob92 = icmp uge i64 %50, %arr.len91
  br i1 %arr.oob92, label %idx.bad93, label %idx.ok94, !prof !8

idx.bad93:                                        ; preds = %idx.ok86
  call void @__polaron_fail(ptr @.fail.740, ptr @.faila.741, i64 %50, ptr @.failb.742, i64 %arr.len91, i32 70)
  unreachable

idx.ok94:                                         ; preds = %idx.ok86
  %arr.data95 = getelementptr i8, ptr %oldK89, i64 8
  %arr.elem96 = getelementptr inbounds %class.Point, ptr %arr.data95, i64 %50
  %51 = call ptr @memcpy(ptr %arr.elem88, ptr %arr.elem96, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  %values97 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values98 = load ptr, ptr %values97, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i99 = load i32, ptr %i, align 4
  %52 = sext i32 %i99 to i64
  %arr.len100 = load i64, ptr %values98, align 8
  %arr.oob101 = icmp uge i64 %52, %arr.len100
  br i1 %arr.oob101, label %idx.bad102, label %idx.ok103, !prof !8

idx.bad102:                                       ; preds = %idx.ok94
  call void @__polaron_fail(ptr @.fail.743, ptr @.faila.744, i64 %52, ptr @.failb.745, i64 %arr.len100, i32 70)
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
  call void @__polaron_fail(ptr @.fail.746, ptr @.faila.747, i64 %53, ptr @.failb.748, i64 %arr.len108, i32 70)
  unreachable

idx.ok111:                                        ; preds = %idx.ok103
  %arr.data112 = getelementptr i8, ptr %oldV106, i64 8
  %arr.elem113 = getelementptr inbounds i32, ptr %arr.data112, i64 %53
  %elem114 = load i32, ptr %arr.elem113, align 4
  store i32 %elem114, ptr %arr.elem105, align 4
  br label %if.end

contract.fail:                                    ; preds = %for.end
  %count120 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count121 = load i32, ptr %count120, align 4, !tbaa !0
  %contract.l = sext i32 %count121 to i64
  call void @__polaron_fail(ptr @.contract.749, ptr @.cl.750, i64 %contract.l, ptr @.cr.751, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %for.end
  %count122 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count123 = load i32, ptr %count122, align 4, !tbaa !0
  %cap124 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap125 = load i32, ptr %cap124, align 4, !tbaa !0
  %54 = icmp slt i32 %count123, %cap125
  %55 = zext i1 %54 to i32
  %contract.ok126 = icmp ne i32 %55, 0
  br i1 %contract.ok126, label %contract.cont128, label %contract.fail127

contract.fail127:                                 ; preds = %contract.cont
  %count129 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count130 = load i32, ptr %count129, align 4, !tbaa !0
  %cap131 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap132 = load i32, ptr %cap131, align 4, !tbaa !0
  %contract.l133 = sext i32 %count130 to i64
  %contract.r = sext i32 %cap132 to i64
  call void @__polaron_fail(ptr @.contract.752, ptr @.cl.753, i64 %contract.l133, ptr @.cr.754, i64 %contract.r, i32 1)
  unreachable

contract.cont128:                                 ; preds = %contract.cont
  %keys134 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys135 = load ptr, ptr %keys134, align 8, !tbaa !4
  %len136 = load i64, ptr %keys135, align 8
  %56 = trunc i64 %len136 to i32
  %cap137 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap138 = load i32, ptr %cap137, align 4, !tbaa !0
  %57 = icmp eq i32 %56, %cap138
  %58 = zext i1 %57 to i32
  %contract.ok139 = icmp ne i32 %58, 0
  br i1 %contract.ok139, label %contract.cont141, label %contract.fail140

contract.fail140:                                 ; preds = %contract.cont128
  call void @__polaron_fail(ptr @.contract.755, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont141:                                 ; preds = %contract.cont128
  %values142 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values143 = load ptr, ptr %values142, align 8, !tbaa !4
  %len144 = load i64, ptr %values143, align 8
  %59 = trunc i64 %len144 to i32
  %cap145 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap146 = load i32, ptr %cap145, align 4, !tbaa !0
  %60 = icmp eq i32 %59, %cap146
  %61 = zext i1 %60 to i32
  %contract.ok147 = icmp ne i32 %61, 0
  br i1 %contract.ok147, label %contract.cont149, label %contract.fail148

contract.fail148:                                 ; preds = %contract.cont141
  call void @__polaron_fail(ptr @.contract.756, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont149:                                 ; preds = %contract.cont141
  %used150 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used151 = load ptr, ptr %used150, align 8, !tbaa !4
  %len152 = load i64, ptr %used151, align 8
  %62 = trunc i64 %len152 to i32
  %cap153 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap154 = load i32, ptr %cap153, align 4, !tbaa !0
  %63 = icmp eq i32 %62, %cap154
  %64 = zext i1 %63 to i32
  %contract.ok155 = icmp ne i32 %64, 0
  br i1 %contract.ok155, label %contract.cont157, label %contract.fail156

contract.fail156:                                 ; preds = %contract.cont149
  call void @__polaron_fail(ptr @.contract.757, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont157:                                 ; preds = %contract.cont149
  ret void
}

define internal void @"HashMap$Point$int.put"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %value = alloca i32, align 4
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !0
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$Point$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %22 = call i32 @"HashMap$Point$int.slotFor"(ptr %0, ptr %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.758, ptr @.faila.759, i64 %23, ptr @.failb.760, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %28 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %28, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.761, ptr @.faila.762, i64 %27, ptr @.failb.763, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !0
  %29 = add i32 %count41, 1
  store i32 %29, ptr %count39, align 4, !tbaa !0
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.764, ptr @.faila.765, i64 %28, ptr @.failb.766, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds %class.Point, ptr %arr.data49, i64 %28
  %key51 = load ptr, ptr %key, align 8
  %30 = call ptr @memcpy(ptr %arr.elem50, ptr %key51, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  %values52 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %31 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %31, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.767, ptr @.faila.768, i64 %31, ptr @.failb.769, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %31
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  %count62 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count63 = load i32, ptr %count62, align 4, !tbaa !0
  %32 = icmp sge i32 %count63, 0
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count64 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count65 = load i32, ptr %count64, align 4, !tbaa !0
  %contract.l = sext i32 %count65 to i64
  call void @__polaron_fail(ptr @.contract.770, ptr @.cl.771, i64 %contract.l, ptr @.cr.772, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count66 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count67 = load i32, ptr %count66, align 4, !tbaa !0
  %cap68 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap69 = load i32, ptr %cap68, align 4, !tbaa !0
  %34 = icmp slt i32 %count67, %cap69
  %35 = zext i1 %34 to i32
  %contract.ok70 = icmp ne i32 %35, 0
  br i1 %contract.ok70, label %contract.cont72, label %contract.fail71

contract.fail71:                                  ; preds = %contract.cont
  %count73 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count74 = load i32, ptr %count73, align 4, !tbaa !0
  %cap75 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap76 = load i32, ptr %cap75, align 4, !tbaa !0
  %contract.l77 = sext i32 %count74 to i64
  %contract.r = sext i32 %cap76 to i64
  call void @__polaron_fail(ptr @.contract.773, ptr @.cl.774, i64 %contract.l77, ptr @.cr.775, i64 %contract.r, i32 1)
  unreachable

contract.cont72:                                  ; preds = %contract.cont
  %keys78 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys79 = load ptr, ptr %keys78, align 8, !tbaa !4
  %len80 = load i64, ptr %keys79, align 8
  %36 = trunc i64 %len80 to i32
  %cap81 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap82 = load i32, ptr %cap81, align 4, !tbaa !0
  %37 = icmp eq i32 %36, %cap82
  %38 = zext i1 %37 to i32
  %contract.ok83 = icmp ne i32 %38, 0
  br i1 %contract.ok83, label %contract.cont85, label %contract.fail84

contract.fail84:                                  ; preds = %contract.cont72
  call void @__polaron_fail(ptr @.contract.776, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont85:                                  ; preds = %contract.cont72
  %values86 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values87 = load ptr, ptr %values86, align 8, !tbaa !4
  %len88 = load i64, ptr %values87, align 8
  %39 = trunc i64 %len88 to i32
  %cap89 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !0
  %40 = icmp eq i32 %39, %cap90
  %41 = zext i1 %40 to i32
  %contract.ok91 = icmp ne i32 %41, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont85
  call void @__polaron_fail(ptr @.contract.777, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont85
  %used94 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !4
  %len96 = load i64, ptr %used95, align 8
  %42 = trunc i64 %len96 to i32
  %cap97 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap98 = load i32, ptr %cap97, align 4, !tbaa !0
  %43 = icmp eq i32 %42, %cap98
  %44 = zext i1 %43 to i32
  %contract.ok99 = icmp ne i32 %44, 0
  br i1 %contract.ok99, label %contract.cont101, label %contract.fail100

contract.fail100:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.778, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont101:                                 ; preds = %contract.cont93
  ret void
}

define internal i32 @"HashMap$Point$int.get"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$Point$int.slotFor"(ptr %0, ptr %key22)
  %17 = sext i32 %16 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.779, ptr @.faila.780, i64 %17, ptr @.failb.781, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %17
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"HashMap$Point$int.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$Point$int.slotFor"(ptr %0, ptr %key22)
  %17 = sext i32 %16 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.782, ptr @.faila.783, i64 %17, ptr @.failb.784, i64 %arr.len, i32 70)
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

define internal i32 @"HashMap$Point$int.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca i32, align 4
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %3 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  store i32 %2, ptr %defaultValue, align 4
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %17 = call i32 @"HashMap$Point$int.slotFor"(ptr %0, ptr %key20)
  store i32 %17, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %18 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.785, ptr @.faila.786, i64 %18, ptr @.failb.787, i64 %arr.len, i32 70)
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
  %values24 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.788, ptr @.faila.789, i64 %22, ptr @.failb.790, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds i32, ptr %arr.data31, i64 %22
  %elem33 = load i32, ptr %arr.elem32, align 4
  ret i32 %elem33
}

define internal void @"HashMap$Point$int.merge"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %value = alloca i32, align 4
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %4 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  store i32 %2, ptr %value, align 4
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %7 = icmp slt i32 %count3, %cap4
  %8 = zext i1 %7 to i32
  %inv.assume5 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %9 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %10 = icmp eq i32 %9, %cap8
  %11 = zext i1 %10 to i32
  %inv.assume9 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %12 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %13 = icmp eq i32 %12, %cap13
  %14 = zext i1 %13 to i32
  %inv.assume14 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %15 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %16 = icmp eq i32 %15, %cap18
  %17 = zext i1 %16 to i32
  %inv.assume19 = icmp ne i32 %17, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  %18 = add i32 %count21, 1
  %19 = mul i32 %18, 4
  %cap22 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !0
  %20 = mul i32 %cap23, 3
  %21 = icmp sge i32 %19, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$Point$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %23 = call i32 @"HashMap$Point$int.slotFor"(ptr %0, ptr %key24)
  store i32 %23, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %24 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %24, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.791, ptr @.faila.792, i64 %24, ptr @.failb.793, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %28 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %28, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.else:                                          ; preds = %idx.ok
  %values62 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values63 = load ptr, ptr %values62, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i64 = load i32, ptr %i, align 4
  %29 = sext i32 %i64 to i64
  %arr.len65 = load i64, ptr %values63, align 8
  %arr.oob66 = icmp uge i64 %29, %arr.len65
  br i1 %arr.oob66, label %idx.bad67, label %idx.ok68, !prof !8

if.end29:                                         ; preds = %idx.ok78, %idx.ok58
  %count83 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count84 = load i32, ptr %count83, align 4, !tbaa !0
  %30 = icmp sge i32 %count84, 0
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.794, ptr @.faila.795, i64 %28, ptr @.failb.796, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %28
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !0
  %32 = add i32 %count41, 1
  store i32 %32, ptr %count39, align 4, !tbaa !0
  %keys42 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %33 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %33, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.797, ptr @.faila.798, i64 %33, ptr @.failb.799, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds %class.Point, ptr %arr.data49, i64 %33
  %key51 = load ptr, ptr %key, align 8
  %34 = call ptr @memcpy(ptr %arr.elem50, ptr %key51, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  %values52 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %35 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %35, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.800, ptr @.faila.801, i64 %35, ptr @.failb.802, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 %35
  %value61 = load i32, ptr %value, align 4
  store i32 %value61, ptr %arr.elem60, align 4
  br label %if.end29

idx.bad67:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.803, ptr @.faila.804, i64 %29, ptr @.failb.805, i64 %arr.len65, i32 70)
  unreachable

idx.ok68:                                         ; preds = %if.else
  %arr.data69 = getelementptr i8, ptr %values63, i64 8
  %arr.elem70 = getelementptr inbounds i32, ptr %arr.data69, i64 %29
  %combine71 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine71, align 8
  %36 = getelementptr ptr, ptr %combine71, i32 1
  %env = load ptr, ptr %36, align 8
  %values72 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values73 = load ptr, ptr %values72, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %37 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %values73, align 8
  %arr.oob76 = icmp uge i64 %37, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad77:                                        ; preds = %idx.ok68
  call void @__polaron_fail(ptr @.fail.806, ptr @.faila.807, i64 %37, ptr @.failb.808, i64 %arr.len75, i32 70)
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
  %count85 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count86 = load i32, ptr %count85, align 4, !tbaa !0
  %contract.l = sext i32 %count86 to i64
  call void @__polaron_fail(ptr @.contract.809, ptr @.cl.810, i64 %contract.l, ptr @.cr.811, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count87 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count88 = load i32, ptr %count87, align 4, !tbaa !0
  %cap89 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap90 = load i32, ptr %cap89, align 4, !tbaa !0
  %39 = icmp slt i32 %count88, %cap90
  %40 = zext i1 %39 to i32
  %contract.ok91 = icmp ne i32 %40, 0
  br i1 %contract.ok91, label %contract.cont93, label %contract.fail92

contract.fail92:                                  ; preds = %contract.cont
  %count94 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count95 = load i32, ptr %count94, align 4, !tbaa !0
  %cap96 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap97 = load i32, ptr %cap96, align 4, !tbaa !0
  %contract.l98 = sext i32 %count95 to i64
  %contract.r = sext i32 %cap97 to i64
  call void @__polaron_fail(ptr @.contract.812, ptr @.cl.813, i64 %contract.l98, ptr @.cr.814, i64 %contract.r, i32 1)
  unreachable

contract.cont93:                                  ; preds = %contract.cont
  %keys99 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys100 = load ptr, ptr %keys99, align 8, !tbaa !4
  %len101 = load i64, ptr %keys100, align 8
  %41 = trunc i64 %len101 to i32
  %cap102 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap103 = load i32, ptr %cap102, align 4, !tbaa !0
  %42 = icmp eq i32 %41, %cap103
  %43 = zext i1 %42 to i32
  %contract.ok104 = icmp ne i32 %43, 0
  br i1 %contract.ok104, label %contract.cont106, label %contract.fail105

contract.fail105:                                 ; preds = %contract.cont93
  call void @__polaron_fail(ptr @.contract.815, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont106:                                 ; preds = %contract.cont93
  %values107 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values108 = load ptr, ptr %values107, align 8, !tbaa !4
  %len109 = load i64, ptr %values108, align 8
  %44 = trunc i64 %len109 to i32
  %cap110 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap111 = load i32, ptr %cap110, align 4, !tbaa !0
  %45 = icmp eq i32 %44, %cap111
  %46 = zext i1 %45 to i32
  %contract.ok112 = icmp ne i32 %46, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

contract.fail113:                                 ; preds = %contract.cont106
  call void @__polaron_fail(ptr @.contract.816, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %contract.cont106
  %used115 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used116 = load ptr, ptr %used115, align 8, !tbaa !4
  %len117 = load i64, ptr %used116, align 8
  %47 = trunc i64 %len117 to i32
  %cap118 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap119 = load i32, ptr %cap118, align 4, !tbaa !0
  %48 = icmp eq i32 %47, %cap119
  %49 = zext i1 %48 to i32
  %contract.ok120 = icmp ne i32 %49, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont114
  call void @__polaron_fail(ptr @.contract.817, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont122:                                 ; preds = %contract.cont114
  ret void
}

define internal i32 @"HashMap$Point$int.remove"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %rv = alloca i32, align 4
  %rk = alloca ptr, align 8
  %Point.copy83 = alloca %class.Point, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %Point.copy = alloca %class.Point, align 8
  %key = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Point.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$Point$int.slotFor"(ptr %0, ptr %key20)
  store i32 %16, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.818, ptr @.faila.819, i64 %17, ptr @.failb.820, i64 %arr.len, i32 70)
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
  %count24 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !0
  %21 = icmp sge i32 %count25, 0
  %22 = zext i1 %21 to i32
  %contract.ok = icmp ne i32 %22, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !0
  %23 = sub i32 %cap49, 1
  store i32 %23, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %24 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %24, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !0
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.821, ptr @.cl.822, i64 %contract.l, ptr @.cr.823, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !0
  %cap30 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !0
  %25 = icmp slt i32 %count29, %cap31
  %26 = zext i1 %25 to i32
  %contract.ok32 = icmp ne i32 %26, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !0
  %cap37 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !0
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.824, ptr @.cl.825, i64 %contract.l39, ptr @.cr.826, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !4
  %len42 = load i64, ptr %used41, align 8
  %27 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !0
  %28 = icmp eq i32 %27, %cap44
  %29 = zext i1 %28 to i32
  %contract.ok45 = icmp ne i32 %29, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.827, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.828, ptr @.faila.829, i64 %24, ptr @.failb.830, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %24
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
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
  %used64 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j66 = load i32, ptr %j, align 4
  %33 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %33, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !8

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %34 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %34, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

while.end:                                        ; preds = %idx.ok70
  %count110 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count111 = load i32, ptr %count110, align 4, !tbaa !0
  %35 = icmp sge i32 %count111, 0
  %36 = zext i1 %35 to i32
  %contract.ok112 = icmp ne i32 %36, 0
  br i1 %contract.ok112, label %contract.cont114, label %contract.fail113

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.831, ptr @.faila.832, i64 %33, ptr @.failb.833, i64 %arr.len67, i32 70)
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
  call void @__polaron_fail(ptr @.fail.834, ptr @.faila.835, i64 %34, ptr @.failb.836, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds %class.Point, ptr %arr.data81, i64 %34
  %40 = call ptr @memcpy(ptr %Point.copy83, ptr %arr.elem82, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  store ptr %Point.copy83, ptr %rk, align 8
  %values84 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j86 = load i32, ptr %j, align 4
  %41 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %41, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.837, ptr @.faila.838, i64 %41, ptr @.failb.839, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 %41
  %elem93 = load i32, ptr %arr.elem92, align 4
  store i32 %elem93, ptr %rv, align 4
  %used94 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used95 = load ptr, ptr %used94, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %j96 = load i32, ptr %j, align 4
  %42 = sext i32 %j96 to i64
  %arr.len97 = load i64, ptr %used95, align 8
  %arr.oob98 = icmp uge i64 %42, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.840, ptr @.faila.841, i64 %42, ptr @.failb.842, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok90
  %arr.data101 = getelementptr i8, ptr %used95, i64 8
  %arr.elem102 = getelementptr inbounds i8, ptr %arr.data101, i64 %42
  store i8 0, ptr %arr.elem102, align 1
  %count103 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count104 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count105 = load i32, ptr %count104, align 4, !tbaa !0
  %43 = sub i32 %count105, 1
  store i32 %43, ptr %count103, align 4, !tbaa !0
  %rk106 = load ptr, ptr %rk, align 8
  %rv107 = load i32, ptr %rv, align 4
  call void @"HashMap$Point$int.put"(ptr %0, ptr %rk106, i32 %rv107)
  %j108 = load i32, ptr %j, align 4
  %44 = add i32 %j108, 1
  %mask109 = load i32, ptr %mask, align 4
  %45 = and i32 %44, %mask109
  store i32 %45, ptr %j, align 4
  br label %while.cond

contract.fail113:                                 ; preds = %while.end
  %count115 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count116 = load i32, ptr %count115, align 4, !tbaa !0
  %contract.l117 = sext i32 %count116 to i64
  call void @__polaron_fail(ptr @.contract.843, ptr @.cl.844, i64 %contract.l117, ptr @.cr.845, i64 0, i32 1)
  unreachable

contract.cont114:                                 ; preds = %while.end
  %count118 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count119 = load i32, ptr %count118, align 4, !tbaa !0
  %cap120 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !0
  %46 = icmp slt i32 %count119, %cap121
  %47 = zext i1 %46 to i32
  %contract.ok122 = icmp ne i32 %47, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont114
  %count125 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count126 = load i32, ptr %count125, align 4, !tbaa !0
  %cap127 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap128 = load i32, ptr %cap127, align 4, !tbaa !0
  %contract.l129 = sext i32 %count126 to i64
  %contract.r130 = sext i32 %cap128 to i64
  call void @__polaron_fail(ptr @.contract.846, ptr @.cl.847, i64 %contract.l129, ptr @.cr.848, i64 %contract.r130, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont114
  %used131 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used132 = load ptr, ptr %used131, align 8, !tbaa !4
  %len133 = load i64, ptr %used132, align 8
  %48 = trunc i64 %len133 to i32
  %cap134 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap135 = load i32, ptr %cap134, align 4, !tbaa !0
  %49 = icmp eq i32 %48, %cap135
  %50 = zext i1 %49 to i32
  %contract.ok136 = icmp ne i32 %50, 0
  br i1 %contract.ok136, label %contract.cont138, label %contract.fail137

contract.fail137:                                 ; preds = %contract.cont124
  call void @__polaron_fail(ptr @.contract.849, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont138:                                 ; preds = %contract.cont124
  ret i32 1
}

define internal ptr @"HashMap$Point$int.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
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
  %cap23 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !0
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.850, ptr @.faila.851, i64 %20, ptr @.failb.852, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.853, ptr @.faila.854, i64 %26, ptr @.failb.855, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds %class.Point, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.856, ptr @.faila.857, i64 %27, ptr @.failb.858, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %keys38, i64 8
  %arr.elem45 = getelementptr inbounds %class.Point, ptr %arr.data44, i64 %27
  %28 = call ptr @memcpy(ptr %arr.elem36, ptr %arr.elem45, i64 ptrtoint (ptr getelementptr (%class.Point, ptr null, i64 1) to i64))
  %j46 = load i32, ptr %j, align 4
  %29 = add i32 %j46, 1
  store i32 %29, ptr %j, align 4
  br label %if.end
}

define internal ptr @"HashMap$Point$int.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !0
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.859, ptr @.faila.860, i64 %20, ptr @.failb.861, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.862, ptr @.faila.863, i64 %26, ptr @.failb.864, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !4, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.865, ptr @.faila.866, i64 %27, ptr @.failb.867, i64 %arr.len40, i32 70)
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

define internal i32 @"HashMap$Point$int.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !0
  ret i32 %count21
}

define internal i32 @"HashMap$Point$int.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !0
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !0
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !4
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !0
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !4
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !0
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !4
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !0
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$Point$int", ptr %0, i32 0, i32 4
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5503)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5505)
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
