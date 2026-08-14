; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/arena_heap_uf.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/arena_heap_uf.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.SlotMap$int" = type { ptr, ptr, ptr, ptr, ptr, i32, i32, i32 }
%class.IntHeap = type { ptr, ptr, i32, i32 }
%class.UnionFind = type { ptr, ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"SlotMap$int.vtable" = private constant [350 x ptr] [ptr @"SlotMap$int.grow", ptr @"SlotMap$int.insert", ptr @"SlotMap$int.containsHandle", ptr @"SlotMap$int.get", ptr @"SlotMap$int.remove", ptr @"SlotMap$int.size", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IntHeap.vtable = private constant [350 x ptr] [ptr @IntHeap.grow, ptr null, ptr null, ptr null, ptr null, ptr @IntHeap.size, ptr null, ptr null, ptr @IntHeap.peek, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntHeap.push, ptr @IntHeap.pop, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@UnionFind.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @UnionFind.merge, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @UnionFind.find, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @UnionFind.connected, ptr @UnionFind.groups, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [46 x i8] c"sm1=%d stale2=%d sm3=%d pop=%d c02=%d grp=%d\0A\00", align 1
@.fail = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1853:72  in SlotMap$int.SlotMap$int\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1862:27  in SlotMap$int.grow\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1862:27  in SlotMap$int.grow\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1863:27  in SlotMap$int.grow\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1863:27  in SlotMap$int.grow\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1864:27  in SlotMap$int.grow\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1864:27  in SlotMap$int.grow\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1868:28  in SlotMap$int.grow\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1881:17  in SlotMap$int.insert\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1883:35  in SlotMap$int.insert\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1884:32  in SlotMap$int.insert\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1886:17  in SlotMap$int.insert\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.34 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1891:17  in SlotMap$int.containsHandle\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1891:17  in SlotMap$int.containsHandle\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1893:50  in SlotMap$int.get\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1897:36  in SlotMap$int.remove\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1898:37  in SlotMap$int.remove\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1898:37  in SlotMap$int.remove\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1899:51  in SlotMap$int.remove\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1361 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1362 = private global %String { i64 16, ptr @.strdata.1361, i64 0 }
@.strdata.1363 = private constant [17 x i8] c"division by zero\00"
@.strobj.1364 = private global %String { i64 16, ptr @.strdata.1363, i64 0 }
@.fail.1596 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1921:66  in IntHeap.grow\0A\00", align 1
@.faila.1597 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1598 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1599 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1921:66  in IntHeap.grow\0A\00", align 1
@.faila.1600 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1601 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1602 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1928:32  in IntHeap.push\0A\00", align 1
@.faila.1603 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1604 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1605 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1931:17  in IntHeap.push\0A\00", align 1
@.faila.1606 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1607 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1608 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1931:17  in IntHeap.push\0A\00", align 1
@.faila.1609 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1610 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1611 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1932:21  in IntHeap.push\0A\00", align 1
@.faila.1612 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1613 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1614 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1933:31  in IntHeap.push\0A\00", align 1
@.faila.1615 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1616 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1617 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1933:31  in IntHeap.push\0A\00", align 1
@.faila.1618 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1619 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1620 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1934:41  in IntHeap.push\0A\00", align 1
@.faila.1621 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1622 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1623 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1940:17  in IntHeap.pop\0A\00", align 1
@.faila.1624 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1625 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1626 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1942:27  in IntHeap.pop\0A\00", align 1
@.faila.1627 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1628 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1629 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1942:27  in IntHeap.pop\0A\00", align 1
@.faila.1630 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1631 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1632 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1948:21  in IntHeap.pop\0A\00", align 1
@.faila.1633 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1634 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1635 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1948:21  in IntHeap.pop\0A\00", align 1
@.faila.1636 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1637 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1638 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1949:21  in IntHeap.pop\0A\00", align 1
@.faila.1639 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1640 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1641 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1949:21  in IntHeap.pop\0A\00", align 1
@.faila.1642 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1643 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1644 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1951:21  in IntHeap.pop\0A\00", align 1
@.faila.1645 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1646 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1647 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1952:31  in IntHeap.pop\0A\00", align 1
@.faila.1648 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1649 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1650 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1952:31  in IntHeap.pop\0A\00", align 1
@.faila.1651 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1652 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1653 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1953:32  in IntHeap.pop\0A\00", align 1
@.faila.1654 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1655 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1656 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1958:48  in IntHeap.peek\0A\00", align 1
@.faila.1657 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1658 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1925 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2519:70  in UnionFind.UnionFind\0A\00", align 1
@.faila.1926 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1927 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1928 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2523:17  in UnionFind.find\0A\00", align 1
@.faila.1929 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1930 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1931 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2524:36  in UnionFind.find\0A\00", align 1
@.faila.1932 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1933 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1934 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2524:36  in UnionFind.find\0A\00", align 1
@.faila.1935 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1936 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1937 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2524:36  in UnionFind.find\0A\00", align 1
@.faila.1938 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1939 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1940 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2525:23  in UnionFind.find\0A\00", align 1
@.faila.1941 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1942 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1943 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2533:17  in UnionFind.merge\0A\00", align 1
@.faila.1944 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1945 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1946 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2533:17  in UnionFind.merge\0A\00", align 1
@.faila.1947 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1948 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1949 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2534:37  in UnionFind.merge\0A\00", align 1
@.faila.1950 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1951 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1952 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2536:21  in UnionFind.merge\0A\00", align 1
@.faila.1953 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1954 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1955 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2536:21  in UnionFind.merge\0A\00", align 1
@.faila.1956 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1957 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1958 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2537:41  in UnionFind.merge\0A\00", align 1
@.faila.1959 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1960 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1961 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2539:41  in UnionFind.merge\0A\00", align 1
@.faila.1962 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1963 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1964 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2540:38  in UnionFind.merge\0A\00", align 1
@.faila.1965 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1966 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1967 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2540:38  in UnionFind.merge\0A\00", align 1
@.faila.1968 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1969 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5362 = private constant [1 x i8] zeroinitializer
@.strobj.5363 = private global %String { i64 0, ptr @.strdata.5362, i64 0 }
@.strdata.5364 = private constant [1 x i8] zeroinitializer
@.strobj.5365 = private global %String { i64 0, ptr @.strdata.5364, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %uf = alloca ptr, align 8
  %hp = alloca ptr, align 8
  %h3 = alloca i32, align 4
  %h2 = alloca i32, align 4
  %h1 = alloca i32, align 4
  %sm = alloca ptr, align 8
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
  %"SlotMap$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.SlotMap$int", ptr null, i64 1) to i64))
  call void @"SlotMap$int.SlotMap$int"(ptr %"SlotMap$int.obj")
  store ptr %"SlotMap$int.obj", ptr %sm, align 8
  %sm1 = load ptr, ptr %sm, align 8
  %16 = call i32 @"SlotMap$int.insert"(ptr %sm1, i32 10)
  store i32 %16, ptr %h1, align 4
  %sm2 = load ptr, ptr %sm, align 8
  %17 = call i32 @"SlotMap$int.insert"(ptr %sm2, i32 20)
  store i32 %17, ptr %h2, align 4
  %sm3 = load ptr, ptr %sm, align 8
  %h24 = load i32, ptr %h2, align 4
  call void @"SlotMap$int.remove"(ptr %sm3, i32 %h24)
  %sm5 = load ptr, ptr %sm, align 8
  %18 = call i32 @"SlotMap$int.insert"(ptr %sm5, i32 99)
  store i32 %18, ptr %h3, align 4
  %IntHeap.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntHeap, ptr null, i64 1) to i64))
  call void @IntHeap.IntHeap(ptr %IntHeap.obj)
  store ptr %IntHeap.obj, ptr %hp, align 8
  %hp6 = load ptr, ptr %hp, align 8
  call void @IntHeap.push(ptr %hp6, i32 5)
  %hp7 = load ptr, ptr %hp, align 8
  call void @IntHeap.push(ptr %hp7, i32 3)
  %hp8 = load ptr, ptr %hp, align 8
  call void @IntHeap.push(ptr %hp8, i32 8)
  %hp9 = load ptr, ptr %hp, align 8
  call void @IntHeap.push(ptr %hp9, i32 1)
  %UnionFind.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.UnionFind, ptr null, i64 1) to i64))
  call void @UnionFind.UnionFind(ptr %UnionFind.obj, i32 6)
  store ptr %UnionFind.obj, ptr %uf, align 8
  %uf10 = load ptr, ptr %uf, align 8
  call void @UnionFind.merge(ptr %uf10, i32 0, i32 1)
  %uf11 = load ptr, ptr %uf, align 8
  call void @UnionFind.merge(ptr %uf11, i32 1, i32 2)
  %uf12 = load ptr, ptr %uf, align 8
  call void @UnionFind.merge(ptr %uf12, i32 3, i32 4)
  %sm13 = load ptr, ptr %sm, align 8
  %h114 = load i32, ptr %h1, align 4
  %19 = call i32 @"SlotMap$int.get"(ptr %sm13, i32 %h114)
  %sm15 = load ptr, ptr %sm, align 8
  %h216 = load i32, ptr %h2, align 4
  %20 = call i32 @"SlotMap$int.containsHandle"(ptr %sm15, i32 %h216)
  %sm17 = load ptr, ptr %sm, align 8
  %h318 = load i32, ptr %h3, align 4
  %21 = call i32 @"SlotMap$int.get"(ptr %sm17, i32 %h318)
  %hp19 = load ptr, ptr %hp, align 8
  %22 = call i32 @IntHeap.pop(ptr %hp19)
  %uf20 = load ptr, ptr %uf, align 8
  %23 = call i32 @UnionFind.connected(ptr %uf20, i32 0, i32 2)
  %uf21 = load ptr, ptr %uf, align 8
  %24 = call i32 @UnionFind.groups(ptr %uf21)
  %25 = call i32 (ptr, ...) @printf(ptr @.str, i32 %19, i32 %20, i32 %21, i32 %22, i32 %23, i32 %24)
  ret i32 0
}

define internal void @"SlotMap$int.SlotMap$int"(ptr %0) {
entry:
  %i = alloca i32, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 0
  store ptr @"SlotMap$int.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %values = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %values, align 8, !tbaa !0
  %gens = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  store ptr null, ptr %gens, align 8, !tbaa !0
  %occ = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  store ptr null, ptr %occ, align 8, !tbaa !0
  %freeList = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 4
  store ptr null, ptr %freeList, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 6
  store i32 4, ptr %cap, align 4, !tbaa !4
  %values1 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %values1, align 8, !tbaa !0
  %gens2 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 16)
  store ptr %arr3, ptr %gens2, align 8, !tbaa !0
  %occ5 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 12)
  store i64 4, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 4)
  store ptr %arr6, ptr %occ5, align 8, !tbaa !0
  %freeList8 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 4
  %arr9 = call ptr @__polaron_malloc(i64 24)
  store i64 4, ptr %arr9, align 8
  %arr.data10 = getelementptr i8, ptr %arr9, i64 8
  %4 = call ptr @memset(ptr %arr.data10, i32 0, i64 16)
  store ptr %arr9, ptr %freeList8, align 8, !tbaa !0
  %freeCount = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  store i32 4, ptr %freeCount, align 4, !tbaa !4
  %len = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 7
  store i32 0, ptr %len, align 4, !tbaa !4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i11 = load i32, ptr %i, align 4
  %5 = icmp slt i32 %i11, 4
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %freeList12 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 4
  %freeList13 = load ptr, ptr %freeList12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i14 = load i32, ptr %i, align 4
  %7 = sext i32 %i14 to i64
  %arr.len = load i64, ptr %freeList13, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %7, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data15 = getelementptr i8, ptr %freeList13, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data15, i64 %7
  %i16 = load i32, ptr %i, align 4
  store i32 %i16, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @"SlotMap$int.grow"(ptr nonnull align 8 dereferenceable(56) %0) {
entry:
  %i62 = alloca i32, align 4
  %fc = alloca i32, align 4
  %i = alloca i32, align 4
  %nf = alloca ptr, align 8
  %no = alloca ptr, align 8
  %ng = alloca ptr, align 8
  %nv = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 6
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = mul i32 %cap1, 2
  store i32 %1, ptr %nc, align 4
  %nc2 = load i32, ptr %nc, align 4
  %2 = sext i32 %nc2 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %nv, align 8
  %nc3 = load i32, ptr %nc, align 4
  %6 = sext i32 %nc3 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr4 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %9 = call ptr @memset(ptr %arr.data5, i32 0, i64 %7)
  store ptr %arr4, ptr %ng, align 8
  %nc6 = load i32, ptr %nc, align 4
  %10 = sext i32 %nc6 to i64
  %11 = mul i64 %10, 1
  %12 = add i64 8, %11
  %arr7 = call ptr @__polaron_malloc(i64 %12)
  store i64 %10, ptr %arr7, align 8
  %arr.data8 = getelementptr i8, ptr %arr7, i64 8
  %13 = call ptr @memset(ptr %arr.data8, i32 0, i64 %11)
  store ptr %arr7, ptr %no, align 8
  %nc9 = load i32, ptr %nc, align 4
  %14 = sext i32 %nc9 to i64
  %15 = mul i64 %14, 4
  %16 = add i64 8, %15
  %arr10 = call ptr @__polaron_malloc(i64 %16)
  store i64 %14, ptr %arr10, align 8
  %arr.data11 = getelementptr i8, ptr %arr10, i64 8
  %17 = call ptr @memset(ptr %arr.data11, i32 0, i64 %15)
  store ptr %arr10, ptr %nf, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i12 = load i32, ptr %i, align 4
  %cap13 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 6
  %cap14 = load i32, ptr %cap13, align 4, !tbaa !4
  %18 = icmp slt i32 %i12, %cap14
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nv15 = load ptr, ptr %nv, align 8, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %20 = sext i32 %i16 to i64
  %arr.len = load i64, ptr %nv15, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok56
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %fc, align 4
  %cap60 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 6
  %cap61 = load i32, ptr %cap60, align 4, !tbaa !4
  store i32 %cap61, ptr %i62, align 4
  br label %for.cond63

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %20, ptr @.failb.3, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data17 = getelementptr i8, ptr %nv15, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data17, i64 %20
  %values = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 1
  %values18 = load ptr, ptr %values, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %23 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %values18, align 8
  %arr.oob21 = icmp uge i64 %23, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 %23, ptr @.failb.6, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %values18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %23
  %elem = load i32, ptr %arr.elem25, align 4
  store i32 %elem, ptr %arr.elem, align 4
  %ng26 = load ptr, ptr %ng, align 8, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %24 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %ng26, align 8
  %arr.oob29 = icmp uge i64 %24, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !8

idx.bad30:                                        ; preds = %idx.ok23
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %24, ptr @.failb.9, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok23
  %arr.data32 = getelementptr i8, ptr %ng26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %24
  %gens = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %gens34 = load ptr, ptr %gens, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i35 = load i32, ptr %i, align 4
  %25 = sext i32 %i35 to i64
  %arr.len36 = load i64, ptr %gens34, align 8
  %arr.oob37 = icmp uge i64 %25, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !8

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 %25, ptr @.failb.12, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %gens34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %25
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %arr.elem33, align 4
  %no43 = load ptr, ptr %no, align 8, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %26 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %no43, align 8
  %arr.oob46 = icmp uge i64 %26, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 %26, ptr @.failb.15, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok39
  %arr.data49 = getelementptr i8, ptr %no43, i64 8
  %arr.elem50 = getelementptr inbounds i8, ptr %arr.data49, i64 %26
  %occ = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  %occ51 = load ptr, ptr %occ, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %27 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %occ51, align 8
  %arr.oob54 = icmp uge i64 %27, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 %27, ptr @.failb.18, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok48
  %arr.data57 = getelementptr i8, ptr %occ51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %27
  %elem59 = load i8, ptr %arr.elem58, align 1
  %28 = zext i8 %elem59 to i32
  %29 = trunc i32 %28 to i8
  store i8 %29, ptr %arr.elem50, align 1
  br label %for.update

for.cond63:                                       ; preds = %for.update65, %for.end
  %i67 = load i32, ptr %i62, align 4
  %nc68 = load i32, ptr %nc, align 4
  %30 = icmp slt i32 %i67, %nc68
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body64, label %for.end66

for.body64:                                       ; preds = %for.cond63
  %nf69 = load ptr, ptr %nf, align 8, !nonnull !6, !dereferenceable !7
  %fc70 = load i32, ptr %fc, align 4
  %32 = sext i32 %fc70 to i64
  %arr.len71 = load i64, ptr %nf69, align 8
  %arr.oob72 = icmp uge i64 %32, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !8

for.update65:                                     ; preds = %idx.ok74
  %33 = load i32, ptr %i62, align 4
  %34 = add i32 %33, 1
  store i32 %34, ptr %i62, align 4
  br label %for.cond63

for.end66:                                        ; preds = %for.cond63
  %values79 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 1
  %nv80 = load ptr, ptr %nv, align 8
  store ptr %nv80, ptr %values79, align 8, !tbaa !0
  %gens81 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %ng82 = load ptr, ptr %ng, align 8
  store ptr %ng82, ptr %gens81, align 8, !tbaa !0
  %occ83 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  %no84 = load ptr, ptr %no, align 8
  store ptr %no84, ptr %occ83, align 8, !tbaa !0
  %freeList = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 4
  %nf85 = load ptr, ptr %nf, align 8
  store ptr %nf85, ptr %freeList, align 8, !tbaa !0
  %freeCount = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %fc86 = load i32, ptr %fc, align 4
  store i32 %fc86, ptr %freeCount, align 4, !tbaa !4
  %cap87 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 6
  %nc88 = load i32, ptr %nc, align 4
  store i32 %nc88, ptr %cap87, align 4, !tbaa !4
  ret void

idx.bad73:                                        ; preds = %for.body64
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 %32, ptr @.failb.21, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %for.body64
  %arr.data75 = getelementptr i8, ptr %nf69, i64 8
  %arr.elem76 = getelementptr inbounds i32, ptr %arr.data75, i64 %32
  %i77 = load i32, ptr %i62, align 4
  store i32 %i77, ptr %arr.elem76, align 4
  %fc78 = load i32, ptr %fc, align 4
  %35 = add i32 %fc78, 1
  store i32 %35, ptr %fc, align 4
  br label %for.update65
}

define internal i32 @"SlotMap$int.insert"(ptr nonnull align 8 dereferenceable(56) %0, i32 %1) {
entry:
  %slot = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  %freeCount = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount1 = load i32, ptr %freeCount, align 4, !tbaa !4
  %2 = icmp eq i32 %freeCount1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"SlotMap$int.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %freeList = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 4
  %freeList2 = load ptr, ptr %freeList, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %freeCount3 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount4 = load i32, ptr %freeCount3, align 4, !tbaa !4
  %4 = sub i32 %freeCount4, 1
  %5 = sext i32 %4 to i64
  %arr.len = load i64, ptr %freeList2, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 %5, ptr @.failb.24, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %freeList2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %slot, align 4
  %freeCount5 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount6 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount7 = load i32, ptr %freeCount6, align 4, !tbaa !4
  %6 = sub i32 %freeCount7, 1
  store i32 %6, ptr %freeCount5, align 4, !tbaa !4
  %values = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 1
  %values8 = load ptr, ptr %values, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot9 = load i32, ptr %slot, align 4
  %7 = sext i32 %slot9 to i64
  %arr.len10 = load i64, ptr %values8, align 8
  %arr.oob11 = icmp uge i64 %7, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 %7, ptr @.failb.27, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %values8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %7
  %value16 = load i32, ptr %value, align 4
  store i32 %value16, ptr %arr.elem15, align 4
  %occ = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  %occ17 = load ptr, ptr %occ, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot18 = load i32, ptr %slot, align 4
  %8 = sext i32 %slot18 to i64
  %arr.len19 = load i64, ptr %occ17, align 8
  %arr.oob20 = icmp uge i64 %8, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !8

idx.bad21:                                        ; preds = %idx.ok13
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 %8, ptr @.failb.30, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok13
  %arr.data23 = getelementptr i8, ptr %occ17, i64 8
  %arr.elem24 = getelementptr inbounds i8, ptr %arr.data23, i64 %8
  store i8 1, ptr %arr.elem24, align 1
  %len = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 7
  %len25 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 7
  %len26 = load i32, ptr %len25, align 4, !tbaa !4
  %9 = add i32 %len26, 1
  store i32 %9, ptr %len, align 4, !tbaa !4
  %slot27 = load i32, ptr %slot, align 4
  %10 = mul i32 %slot27, 1048576
  %gens = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %gens28 = load ptr, ptr %gens, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot29 = load i32, ptr %slot, align 4
  %11 = sext i32 %slot29 to i64
  %arr.len30 = load i64, ptr %gens28, align 8
  %arr.oob31 = icmp uge i64 %11, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

idx.bad32:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 %11, ptr @.failb.33, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %idx.ok22
  %arr.data34 = getelementptr i8, ptr %gens28, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %11
  %elem36 = load i32, ptr %arr.elem35, align 4
  %12 = add i32 %10, %elem36
  ret i32 %12
}

define internal i32 @"SlotMap$int.containsHandle"(ptr nonnull align 8 dereferenceable(56) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %gen = alloca i32, align 4
  %exc.thrown6 = alloca ptr, align 8
  %slot = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %h = alloca i32, align 4
  store i32 %1, ptr %h, align 4
  %h1 = load i32, ptr %h, align 4
  %2 = icmp eq i32 %h1, -2147483648
  %3 = and i1 %2, false
  %4 = or i1 false, %3
  br i1 %4, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %5 = sdiv i32 %h1, 1048576
  store i32 %5, ptr %slot, align 4
  %h2 = load i32, ptr %h, align 4
  %6 = icmp eq i32 %h2, -2147483648
  %7 = and i1 %6, false
  %8 = or i1 false, %7
  br i1 %8, label %div.bad3, label %div.ok4

div.bad3:                                         ; preds = %div.ok
  %exc5 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc5)
  store ptr %exc5, ptr %exc.thrown6, align 8
  call void @_CxxThrowException(ptr %exc.thrown6, ptr @_TI1PEAX)
  unreachable

div.ok4:                                          ; preds = %div.ok
  %9 = srem i32 %h2, 1048576
  store i32 %9, ptr %gen, align 4
  %slot7 = load i32, ptr %slot, align 4
  %cap = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 6
  %cap8 = load i32, ptr %cap, align 4, !tbaa !4
  %10 = icmp slt i32 %slot7, %cap8
  %11 = zext i1 %10 to i32
  %sc.a = icmp ne i32 %11, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %div.ok4
  %occ = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  %occ9 = load ptr, ptr %occ, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot10 = load i32, ptr %slot, align 4
  %12 = sext i32 %slot10 to i64
  %arr.len = load i64, ptr %occ9, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

sc.end:                                           ; preds = %idx.ok, %div.ok4
  %sc = phi i1 [ false, %div.ok4 ], [ %sc.b, %idx.ok ]
  %13 = zext i1 %sc to i32
  %sc.a11 = icmp ne i32 %13, 0
  br i1 %sc.a11, label %sc.rhs12, label %sc.end13

idx.bad:                                          ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 %12, ptr @.failb.36, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs
  %arr.data = getelementptr i8, ptr %occ9, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %12
  %elem = load i8, ptr %arr.elem, align 1
  %14 = zext i8 %elem to i32
  %sc.b = icmp ne i32 %14, 0
  br label %sc.end

sc.rhs12:                                         ; preds = %sc.end
  %gens = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %gens14 = load ptr, ptr %gens, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot15 = load i32, ptr %slot, align 4
  %15 = sext i32 %slot15 to i64
  %arr.len16 = load i64, ptr %gens14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

sc.end13:                                         ; preds = %idx.ok19, %sc.end
  %sc25 = phi i1 [ false, %sc.end ], [ %sc.b24, %idx.ok19 ]
  %16 = zext i1 %sc25 to i32
  ret i32 %16

idx.bad18:                                        ; preds = %sc.rhs12
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 %15, ptr @.failb.39, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %sc.rhs12
  %arr.data20 = getelementptr i8, ptr %gens14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %15
  %elem22 = load i32, ptr %arr.elem21, align 4
  %gen23 = load i32, ptr %gen, align 4
  %17 = icmp eq i32 %elem22, %gen23
  %18 = zext i1 %17 to i32
  %sc.b24 = icmp ne i32 %18, 0
  br label %sc.end13
}

define internal i32 @"SlotMap$int.get"(ptr nonnull align 8 dereferenceable(56) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %h = alloca i32, align 4
  store i32 %1, ptr %h, align 4
  %values = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 1
  %values1 = load ptr, ptr %values, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %h2 = load i32, ptr %h, align 4
  %2 = icmp eq i32 %h2, -2147483648
  %3 = and i1 %2, false
  %4 = or i1 false, %3
  br i1 %4, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %5 = sdiv i32 %h2, 1048576
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %values1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 %6, ptr @.failb.42, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %values1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal void @"SlotMap$int.remove"(ptr nonnull align 8 dereferenceable(56) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %slot = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %h = alloca i32, align 4
  store i32 %1, ptr %h, align 4
  %h1 = load i32, ptr %h, align 4
  %2 = call i32 @"SlotMap$int.containsHandle"(ptr %0, i32 %h1)
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %h2 = load i32, ptr %h, align 4
  %4 = icmp eq i32 %h2, -2147483648
  %5 = and i1 %4, false
  %6 = or i1 false, %5
  br i1 %6, label %div.bad, label %div.ok

if.end:                                           ; preds = %idx.ok27, %entry
  ret void

div.bad:                                          ; preds = %if.then
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.then
  %7 = sdiv i32 %h2, 1048576
  store i32 %7, ptr %slot, align 4
  %occ = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 3
  %occ3 = load ptr, ptr %occ, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot4 = load i32, ptr %slot, align 4
  %8 = sext i32 %slot4 to i64
  %arr.len = load i64, ptr %occ3, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 %8, ptr @.failb.45, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %div.ok
  %arr.data = getelementptr i8, ptr %occ3, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %8
  store i8 0, ptr %arr.elem, align 1
  %gens = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %gens5 = load ptr, ptr %gens, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot6 = load i32, ptr %slot, align 4
  %9 = sext i32 %slot6 to i64
  %arr.len7 = load i64, ptr %gens5, align 8
  %arr.oob8 = icmp uge i64 %9, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !8

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 %9, ptr @.failb.48, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %gens5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %9
  %gens13 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 2
  %gens14 = load ptr, ptr %gens13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %slot15 = load i32, ptr %slot, align 4
  %10 = sext i32 %slot15 to i64
  %arr.len16 = load i64, ptr %gens14, align 8
  %arr.oob17 = icmp uge i64 %10, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 %10, ptr @.failb.51, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok10
  %arr.data20 = getelementptr i8, ptr %gens14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %10
  %elem = load i32, ptr %arr.elem21, align 4
  %11 = add i32 %elem, 1
  store i32 %11, ptr %arr.elem12, align 4
  %freeList = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 4
  %freeList22 = load ptr, ptr %freeList, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %freeCount = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount23 = load i32, ptr %freeCount, align 4, !tbaa !4
  %12 = sext i32 %freeCount23 to i64
  %arr.len24 = load i64, ptr %freeList22, align 8
  %arr.oob25 = icmp uge i64 %12, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !8

idx.bad26:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 %12, ptr @.failb.54, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok19
  %arr.data28 = getelementptr i8, ptr %freeList22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %12
  %slot30 = load i32, ptr %slot, align 4
  store i32 %slot30, ptr %arr.elem29, align 4
  %freeCount31 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount32 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 5
  %freeCount33 = load i32, ptr %freeCount32, align 4, !tbaa !4
  %13 = add i32 %freeCount33, 1
  store i32 %13, ptr %freeCount31, align 4, !tbaa !4
  %len = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 7
  %len34 = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 7
  %len35 = load i32, ptr %len34, align 4, !tbaa !4
  %14 = sub i32 %len35, 1
  store i32 %14, ptr %len, align 4, !tbaa !4
  br label %if.end
}

define internal i32 @"SlotMap$int.size"(ptr nonnull align 8 dereferenceable(56) %0) {
entry:
  %len = getelementptr inbounds %"class.SlotMap$int", ptr %0, i32 0, i32 7
  %len1 = load i32, ptr %len, align 4, !tbaa !4
  ret i32 %len1
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1362)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1364)
  ret ptr %strcpy
}

define internal void @IntHeap.IntHeap(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 0
  store ptr @IntHeap.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %h = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  store ptr null, ptr %h, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 3
  store i32 8, ptr %cap, align 4, !tbaa !4
  %h1 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %h1, align 8, !tbaa !0
  %n = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  store i32 0, ptr %n, align 4, !tbaa !4
  ret void
}

define internal void @IntHeap.grow(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %nh = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 3
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = mul i32 %cap1, 2
  store i32 %1, ptr %nc, align 4
  %nc2 = load i32, ptr %nc, align 4
  %2 = sext i32 %nc2 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %nh, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %n = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n, align 4, !tbaa !4
  %6 = icmp slt i32 %i3, %n4
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nh5 = load ptr, ptr %nh, align 8, !nonnull !6, !dereferenceable !7
  %i6 = load i32, ptr %i, align 4
  %8 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %nh5, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok13
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %h16 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %nh17 = load ptr, ptr %nh, align 8
  store ptr %nh17, ptr %h16, align 8, !tbaa !0
  %cap18 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 3
  %nc19 = load i32, ptr %nc, align 4
  store i32 %nc19, ptr %cap18, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1596, ptr @.faila.1597, i64 %8, ptr @.failb.1598, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %nh5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 %8
  %h = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h8 = load ptr, ptr %h, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %11 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %h8, align 8
  %arr.oob11 = icmp uge i64 %11, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1599, ptr @.faila.1600, i64 %11, ptr @.failb.1601, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %h8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %11
  %elem = load i32, ptr %arr.elem15, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @IntHeap.push(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown83 = alloca ptr, align 8
  %exc.thrown71 = alloca ptr, align 8
  %exc.thrown57 = alloca ptr, align 8
  %t = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %i = alloca i32, align 4
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %n = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 3
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = icmp eq i32 %n1, %cap2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @IntHeap.grow(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %h = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h3 = load ptr, ptr %h, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %n4 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n5 = load i32, ptr %n4, align 4, !tbaa !4
  %4 = sext i32 %n5 to i64
  %arr.len = load i64, ptr %h3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1602, ptr @.faila.1603, i64 %4, ptr @.failb.1604, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %h3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %v6 = load i32, ptr %v, align 4
  store i32 %v6, ptr %arr.elem, align 4
  %n7 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n8 = load i32, ptr %n7, align 4, !tbaa !4
  store i32 %n8, ptr %i, align 4
  %n9 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n10 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n11 = load i32, ptr %n10, align 4, !tbaa !4
  %5 = add i32 %n11, 1
  store i32 %5, ptr %n9, align 4, !tbaa !4
  br label %while.cond

while.cond:                                       ; preds = %div.ok81, %idx.ok
  %i12 = load i32, ptr %i, align 4
  %6 = icmp sgt i32 %i12, 0
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %h32 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h33 = load ptr, ptr %h32, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i34 = load i32, ptr %i, align 4
  %8 = sext i32 %i34 to i64
  %arr.len35 = load i64, ptr %h33, align 8
  %arr.oob36 = icmp uge i64 %8, %arr.len35
  br i1 %arr.oob36, label %idx.bad37, label %idx.ok38, !prof !8

while.end:                                        ; preds = %sc.end
  ret void

sc.rhs:                                           ; preds = %while.cond
  %h13 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h14 = load ptr, ptr %h13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %9 = sub i32 %i15, 1
  %10 = icmp eq i32 %9, -2147483648
  %11 = and i1 %10, false
  %12 = or i1 false, %11
  br i1 %12, label %div.bad, label %div.ok

sc.end:                                           ; preds = %idx.ok28, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok28 ]
  %13 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

div.bad:                                          ; preds = %sc.rhs
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %sc.rhs
  %14 = sdiv i32 %9, 2
  %15 = sext i32 %14 to i64
  %arr.len16 = load i64, ptr %h14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1605, ptr @.faila.1606, i64 %15, ptr @.failb.1607, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %div.ok
  %arr.data20 = getelementptr i8, ptr %h14, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %15
  %elem = load i32, ptr %arr.elem21, align 4
  %h22 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h23 = load ptr, ptr %h22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %16 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %h23, align 8
  %arr.oob26 = icmp uge i64 %16, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.1608, ptr @.faila.1609, i64 %16, ptr @.failb.1610, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok19
  %arr.data29 = getelementptr i8, ptr %h23, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 %16
  %elem31 = load i32, ptr %arr.elem30, align 4
  %17 = icmp sgt i32 %elem, %elem31
  %18 = zext i1 %17 to i32
  %sc.b = icmp ne i32 %18, 0
  br label %sc.end

idx.bad37:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1611, ptr @.faila.1612, i64 %8, ptr @.failb.1613, i64 %arr.len35, i32 70)
  unreachable

idx.ok38:                                         ; preds = %while.body
  %arr.data39 = getelementptr i8, ptr %h33, i64 8
  %arr.elem40 = getelementptr inbounds i32, ptr %arr.data39, i64 %8
  %elem41 = load i32, ptr %arr.elem40, align 4
  store i32 %elem41, ptr %t, align 4
  %h42 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h43 = load ptr, ptr %h42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %19 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %h43, align 8
  %arr.oob46 = icmp uge i64 %19, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok38
  call void @__polaron_fail(ptr @.fail.1614, ptr @.faila.1615, i64 %19, ptr @.failb.1616, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok38
  %arr.data49 = getelementptr i8, ptr %h43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %19
  %h51 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h52 = load ptr, ptr %h51, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i53 = load i32, ptr %i, align 4
  %20 = sub i32 %i53, 1
  %21 = icmp eq i32 %20, -2147483648
  %22 = and i1 %21, false
  %23 = or i1 false, %22
  br i1 %23, label %div.bad54, label %div.ok55

div.bad54:                                        ; preds = %idx.ok48
  %exc56 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc56)
  store ptr %exc56, ptr %exc.thrown57, align 8
  call void @_CxxThrowException(ptr %exc.thrown57, ptr @_TI1PEAX)
  unreachable

div.ok55:                                         ; preds = %idx.ok48
  %24 = sdiv i32 %20, 2
  %25 = sext i32 %24 to i64
  %arr.len58 = load i64, ptr %h52, align 8
  %arr.oob59 = icmp uge i64 %25, %arr.len58
  br i1 %arr.oob59, label %idx.bad60, label %idx.ok61, !prof !8

idx.bad60:                                        ; preds = %div.ok55
  call void @__polaron_fail(ptr @.fail.1617, ptr @.faila.1618, i64 %25, ptr @.failb.1619, i64 %arr.len58, i32 70)
  unreachable

idx.ok61:                                         ; preds = %div.ok55
  %arr.data62 = getelementptr i8, ptr %h52, i64 8
  %arr.elem63 = getelementptr inbounds i32, ptr %arr.data62, i64 %25
  %elem64 = load i32, ptr %arr.elem63, align 4
  store i32 %elem64, ptr %arr.elem50, align 4
  %h65 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h66 = load ptr, ptr %h65, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i67 = load i32, ptr %i, align 4
  %26 = sub i32 %i67, 1
  %27 = icmp eq i32 %26, -2147483648
  %28 = and i1 %27, false
  %29 = or i1 false, %28
  br i1 %29, label %div.bad68, label %div.ok69

div.bad68:                                        ; preds = %idx.ok61
  %exc70 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc70)
  store ptr %exc70, ptr %exc.thrown71, align 8
  call void @_CxxThrowException(ptr %exc.thrown71, ptr @_TI1PEAX)
  unreachable

div.ok69:                                         ; preds = %idx.ok61
  %30 = sdiv i32 %26, 2
  %31 = sext i32 %30 to i64
  %arr.len72 = load i64, ptr %h66, align 8
  %arr.oob73 = icmp uge i64 %31, %arr.len72
  br i1 %arr.oob73, label %idx.bad74, label %idx.ok75, !prof !8

idx.bad74:                                        ; preds = %div.ok69
  call void @__polaron_fail(ptr @.fail.1620, ptr @.faila.1621, i64 %31, ptr @.failb.1622, i64 %arr.len72, i32 70)
  unreachable

idx.ok75:                                         ; preds = %div.ok69
  %arr.data76 = getelementptr i8, ptr %h66, i64 8
  %arr.elem77 = getelementptr inbounds i32, ptr %arr.data76, i64 %31
  %t78 = load i32, ptr %t, align 4
  store i32 %t78, ptr %arr.elem77, align 4
  %i79 = load i32, ptr %i, align 4
  %32 = sub i32 %i79, 1
  %33 = icmp eq i32 %32, -2147483648
  %34 = and i1 %33, false
  %35 = or i1 false, %34
  br i1 %35, label %div.bad80, label %div.ok81

div.bad80:                                        ; preds = %idx.ok75
  %exc82 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc82)
  store ptr %exc82, ptr %exc.thrown83, align 8
  call void @_CxxThrowException(ptr %exc.thrown83, ptr @_TI1PEAX)
  unreachable

div.ok81:                                         ; preds = %idx.ok75
  %36 = sdiv i32 %32, 2
  store i32 %36, ptr %i, align 4
  br label %while.cond
}

define internal i32 @IntHeap.pop(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %t = alloca i32, align 4
  %sm = alloca i32, align 4
  %r = alloca i32, align 4
  %l = alloca i32, align 4
  %i = alloca i32, align 4
  %top = alloca i32, align 4
  %h = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h1 = load ptr, ptr %h, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %h1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1623, ptr @.faila.1624, i64 0, ptr @.failb.1625, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %h1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %top, align 4
  %n = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n2 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n3 = load i32, ptr %n2, align 4, !tbaa !4
  %1 = sub i32 %n3, 1
  store i32 %1, ptr %n, align 4, !tbaa !4
  %h4 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h5 = load ptr, ptr %h4, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len6 = load i64, ptr %h5, align 8
  %arr.oob7 = icmp uge i64 0, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1626, ptr @.faila.1627, i64 0, ptr @.failb.1628, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %h5, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 0
  %h12 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h13 = load ptr, ptr %h12, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %n14 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n15 = load i32, ptr %n14, align 4, !tbaa !4
  %2 = sext i32 %n15 to i64
  %arr.len16 = load i64, ptr %h13, align 8
  %arr.oob17 = icmp uge i64 %2, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.1629, ptr @.faila.1630, i64 %2, ptr @.failb.1631, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok9
  %arr.data20 = getelementptr i8, ptr %h13, i64 8
  %arr.elem21 = getelementptr inbounds i32, ptr %arr.data20, i64 %2
  %elem22 = load i32, ptr %arr.elem21, align 4
  store i32 %elem22, ptr %arr.elem11, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok121, %idx.ok19
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
  store i32 %i25, ptr %sm, align 4
  %l26 = load i32, ptr %l, align 4
  %n27 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n28 = load i32, ptr %n27, align 4, !tbaa !4
  %7 = icmp slt i32 %l26, %n28
  %8 = zext i1 %7 to i32
  %sc.a = icmp ne i32 %8, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.end:                                        ; preds = %while.cond
  %top126 = load i32, ptr %top, align 4
  ret i32 %top126

sc.rhs:                                           ; preds = %while.body
  %h29 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h30 = load ptr, ptr %h29, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %l31 = load i32, ptr %l, align 4
  %9 = sext i32 %l31 to i64
  %arr.len32 = load i64, ptr %h30, align 8
  %arr.oob33 = icmp uge i64 %9, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !8

sc.end:                                           ; preds = %idx.ok45, %while.body
  %sc = phi i1 [ false, %while.body ], [ %sc.b, %idx.ok45 ]
  %10 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

idx.bad34:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1632, ptr @.faila.1633, i64 %9, ptr @.failb.1634, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %sc.rhs
  %arr.data36 = getelementptr i8, ptr %h30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %9
  %elem38 = load i32, ptr %arr.elem37, align 4
  %h39 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h40 = load ptr, ptr %h39, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sm41 = load i32, ptr %sm, align 4
  %11 = sext i32 %sm41 to i64
  %arr.len42 = load i64, ptr %h40, align 8
  %arr.oob43 = icmp uge i64 %11, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !8

idx.bad44:                                        ; preds = %idx.ok35
  call void @__polaron_fail(ptr @.fail.1635, ptr @.faila.1636, i64 %11, ptr @.failb.1637, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %idx.ok35
  %arr.data46 = getelementptr i8, ptr %h40, i64 8
  %arr.elem47 = getelementptr inbounds i32, ptr %arr.data46, i64 %11
  %elem48 = load i32, ptr %arr.elem47, align 4
  %12 = icmp slt i32 %elem38, %elem48
  %13 = zext i1 %12 to i32
  %sc.b = icmp ne i32 %13, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %l49 = load i32, ptr %l, align 4
  store i32 %l49, ptr %sm, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  %r50 = load i32, ptr %r, align 4
  %n51 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n52 = load i32, ptr %n51, align 4, !tbaa !4
  %14 = icmp slt i32 %r50, %n52
  %15 = zext i1 %14 to i32
  %sc.a53 = icmp ne i32 %15, 0
  br i1 %sc.a53, label %sc.rhs54, label %sc.end55

sc.rhs54:                                         ; preds = %if.end
  %h56 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h57 = load ptr, ptr %h56, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r58 = load i32, ptr %r, align 4
  %16 = sext i32 %r58 to i64
  %arr.len59 = load i64, ptr %h57, align 8
  %arr.oob60 = icmp uge i64 %16, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !8

sc.end55:                                         ; preds = %idx.ok72, %if.end
  %sc77 = phi i1 [ false, %if.end ], [ %sc.b76, %idx.ok72 ]
  %17 = zext i1 %sc77 to i32
  br i1 %sc77, label %if.then78, label %if.end79

idx.bad61:                                        ; preds = %sc.rhs54
  call void @__polaron_fail(ptr @.fail.1638, ptr @.faila.1639, i64 %16, ptr @.failb.1640, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %sc.rhs54
  %arr.data63 = getelementptr i8, ptr %h57, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 %16
  %elem65 = load i32, ptr %arr.elem64, align 4
  %h66 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h67 = load ptr, ptr %h66, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sm68 = load i32, ptr %sm, align 4
  %18 = sext i32 %sm68 to i64
  %arr.len69 = load i64, ptr %h67, align 8
  %arr.oob70 = icmp uge i64 %18, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !8

idx.bad71:                                        ; preds = %idx.ok62
  call void @__polaron_fail(ptr @.fail.1641, ptr @.faila.1642, i64 %18, ptr @.failb.1643, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok62
  %arr.data73 = getelementptr i8, ptr %h67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %18
  %elem75 = load i32, ptr %arr.elem74, align 4
  %19 = icmp slt i32 %elem65, %elem75
  %20 = zext i1 %19 to i32
  %sc.b76 = icmp ne i32 %20, 0
  br label %sc.end55

if.then78:                                        ; preds = %sc.end55
  %r80 = load i32, ptr %r, align 4
  store i32 %r80, ptr %sm, align 4
  br label %if.end79

if.end79:                                         ; preds = %if.then78, %sc.end55
  %sm81 = load i32, ptr %sm, align 4
  %i82 = load i32, ptr %i, align 4
  %21 = icmp eq i32 %sm81, %i82
  %22 = zext i1 %21 to i32
  br i1 %21, label %if.then83, label %if.end84

if.then83:                                        ; preds = %if.end79
  %top85 = load i32, ptr %top, align 4
  ret i32 %top85

if.end84:                                         ; preds = %if.end79
  %h86 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h87 = load ptr, ptr %h86, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i88 = load i32, ptr %i, align 4
  %23 = sext i32 %i88 to i64
  %arr.len89 = load i64, ptr %h87, align 8
  %arr.oob90 = icmp uge i64 %23, %arr.len89
  br i1 %arr.oob90, label %idx.bad91, label %idx.ok92, !prof !8

idx.bad91:                                        ; preds = %if.end84
  call void @__polaron_fail(ptr @.fail.1644, ptr @.faila.1645, i64 %23, ptr @.failb.1646, i64 %arr.len89, i32 70)
  unreachable

idx.ok92:                                         ; preds = %if.end84
  %arr.data93 = getelementptr i8, ptr %h87, i64 8
  %arr.elem94 = getelementptr inbounds i32, ptr %arr.data93, i64 %23
  %elem95 = load i32, ptr %arr.elem94, align 4
  store i32 %elem95, ptr %t, align 4
  %h96 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h97 = load ptr, ptr %h96, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i98 = load i32, ptr %i, align 4
  %24 = sext i32 %i98 to i64
  %arr.len99 = load i64, ptr %h97, align 8
  %arr.oob100 = icmp uge i64 %24, %arr.len99
  br i1 %arr.oob100, label %idx.bad101, label %idx.ok102, !prof !8

idx.bad101:                                       ; preds = %idx.ok92
  call void @__polaron_fail(ptr @.fail.1647, ptr @.faila.1648, i64 %24, ptr @.failb.1649, i64 %arr.len99, i32 70)
  unreachable

idx.ok102:                                        ; preds = %idx.ok92
  %arr.data103 = getelementptr i8, ptr %h97, i64 8
  %arr.elem104 = getelementptr inbounds i32, ptr %arr.data103, i64 %24
  %h105 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h106 = load ptr, ptr %h105, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sm107 = load i32, ptr %sm, align 4
  %25 = sext i32 %sm107 to i64
  %arr.len108 = load i64, ptr %h106, align 8
  %arr.oob109 = icmp uge i64 %25, %arr.len108
  br i1 %arr.oob109, label %idx.bad110, label %idx.ok111, !prof !8

idx.bad110:                                       ; preds = %idx.ok102
  call void @__polaron_fail(ptr @.fail.1650, ptr @.faila.1651, i64 %25, ptr @.failb.1652, i64 %arr.len108, i32 70)
  unreachable

idx.ok111:                                        ; preds = %idx.ok102
  %arr.data112 = getelementptr i8, ptr %h106, i64 8
  %arr.elem113 = getelementptr inbounds i32, ptr %arr.data112, i64 %25
  %elem114 = load i32, ptr %arr.elem113, align 4
  store i32 %elem114, ptr %arr.elem104, align 4
  %h115 = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h116 = load ptr, ptr %h115, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sm117 = load i32, ptr %sm, align 4
  %26 = sext i32 %sm117 to i64
  %arr.len118 = load i64, ptr %h116, align 8
  %arr.oob119 = icmp uge i64 %26, %arr.len118
  br i1 %arr.oob119, label %idx.bad120, label %idx.ok121, !prof !8

idx.bad120:                                       ; preds = %idx.ok111
  call void @__polaron_fail(ptr @.fail.1653, ptr @.faila.1654, i64 %26, ptr @.failb.1655, i64 %arr.len118, i32 70)
  unreachable

idx.ok121:                                        ; preds = %idx.ok111
  %arr.data122 = getelementptr i8, ptr %h116, i64 8
  %arr.elem123 = getelementptr inbounds i32, ptr %arr.data122, i64 %26
  %t124 = load i32, ptr %t, align 4
  store i32 %t124, ptr %arr.elem123, align 4
  %sm125 = load i32, ptr %sm, align 4
  store i32 %sm125, ptr %i, align 4
  br label %while.cond
}

define internal i32 @IntHeap.peek(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %h = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 1
  %h1 = load ptr, ptr %h, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %h1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1656, ptr @.faila.1657, i64 0, ptr @.failb.1658, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %h1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 0
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @IntHeap.size(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %n = getelementptr inbounds %class.IntHeap, ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  ret i32 %n1
}

define internal void @UnionFind.UnionFind(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 0
  store ptr @UnionFind.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %parent = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  store ptr null, ptr %parent, align 8, !tbaa !0
  %rnk = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  store ptr null, ptr %rnk, align 8, !tbaa !0
  %parent1 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %n2 = load i32, ptr %n, align 4
  %2 = sext i32 %n2 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %parent1, align 8, !tbaa !0
  %rnk3 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %n4 = load i32, ptr %n, align 4
  %6 = sext i32 %n4 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr5 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr5, align 8
  %arr.data6 = getelementptr i8, ptr %arr5, i64 8
  %9 = call ptr @memset(ptr %arr.data6, i32 0, i64 %7)
  store ptr %arr5, ptr %rnk3, align 8, !tbaa !0
  %count = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 3
  %n7 = load i32, ptr %n, align 4
  store i32 %n7, ptr %count, align 4, !tbaa !4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i8 = load i32, ptr %i, align 4
  %n9 = load i32, ptr %n, align 4
  %10 = icmp slt i32 %i8, %n9
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %parent10 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent11 = load ptr, ptr %parent10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %12 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %parent11, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1925, ptr @.faila.1926, i64 %12, ptr @.failb.1927, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %parent11, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data13, i64 %12
  %i14 = load i32, ptr %i, align 4
  store i32 %i14, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @UnionFind.find(ptr nonnull align 8 dereferenceable(32) %0, i32 %1) {
entry:
  %r = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  store i32 %x1, ptr %r, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok39, %entry
  %parent = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent2 = load ptr, ptr %parent, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r3 = load i32, ptr %r, align 4
  %2 = sext i32 %r3 to i64
  %arr.len = load i64, ptr %parent2, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %parent5 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent6 = load ptr, ptr %parent5, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r7 = load i32, ptr %r, align 4
  %3 = sext i32 %r7 to i64
  %arr.len8 = load i64, ptr %parent6, align 8
  %arr.oob9 = icmp uge i64 %3, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !8

while.end:                                        ; preds = %idx.ok
  %r43 = load i32, ptr %r, align 4
  ret i32 %r43

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.1928, ptr @.faila.1929, i64 %2, ptr @.failb.1930, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.cond
  %arr.data = getelementptr i8, ptr %parent2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  %r4 = load i32, ptr %r, align 4
  %4 = icmp ne i32 %elem, %r4
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

idx.bad10:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1931, ptr @.faila.1932, i64 %3, ptr @.failb.1933, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %while.body
  %arr.data12 = getelementptr i8, ptr %parent6, i64 8
  %arr.elem13 = getelementptr inbounds i32, ptr %arr.data12, i64 %3
  %parent14 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent15 = load ptr, ptr %parent14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %parent16 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent17 = load ptr, ptr %parent16, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r18 = load i32, ptr %r, align 4
  %6 = sext i32 %r18 to i64
  %arr.len19 = load i64, ptr %parent17, align 8
  %arr.oob20 = icmp uge i64 %6, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !8

idx.bad21:                                        ; preds = %idx.ok11
  call void @__polaron_fail(ptr @.fail.1934, ptr @.faila.1935, i64 %6, ptr @.failb.1936, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok11
  %arr.data23 = getelementptr i8, ptr %parent17, i64 8
  %arr.elem24 = getelementptr inbounds i32, ptr %arr.data23, i64 %6
  %elem25 = load i32, ptr %arr.elem24, align 4
  %7 = sext i32 %elem25 to i64
  %arr.len26 = load i64, ptr %parent15, align 8
  %arr.oob27 = icmp uge i64 %7, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !8

idx.bad28:                                        ; preds = %idx.ok22
  call void @__polaron_fail(ptr @.fail.1937, ptr @.faila.1938, i64 %7, ptr @.failb.1939, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok22
  %arr.data30 = getelementptr i8, ptr %parent15, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %7
  %elem32 = load i32, ptr %arr.elem31, align 4
  store i32 %elem32, ptr %arr.elem13, align 4
  %parent33 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent34 = load ptr, ptr %parent33, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %r35 = load i32, ptr %r, align 4
  %8 = sext i32 %r35 to i64
  %arr.len36 = load i64, ptr %parent34, align 8
  %arr.oob37 = icmp uge i64 %8, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !8

idx.bad38:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.1940, ptr @.faila.1941, i64 %8, ptr @.failb.1942, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok29
  %arr.data40 = getelementptr i8, ptr %parent34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %8
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %r, align 4
  br label %while.cond
}

define internal void @UnionFind.merge(ptr nonnull align 8 dereferenceable(32) %0, i32 %1, i32 %2) {
entry:
  %rb = alloca i32, align 4
  %ra = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  store i32 %2, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %3 = call i32 @UnionFind.find(ptr %0, i32 %a1)
  store i32 %3, ptr %ra, align 4
  %b2 = load i32, ptr %b, align 4
  %4 = call i32 @UnionFind.find(ptr %0, i32 %b2)
  store i32 %4, ptr %rb, align 4
  %ra3 = load i32, ptr %ra, align 4
  %rb4 = load i32, ptr %rb, align 4
  %5 = icmp eq i32 %ra3, %rb4
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %rnk = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %rnk5 = load ptr, ptr %rnk, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %ra6 = load i32, ptr %ra, align 4
  %7 = sext i32 %ra6 to i64
  %arr.len = load i64, ptr %rnk5, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1943, ptr @.faila.1944, i64 %7, ptr @.failb.1945, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %rnk5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %7
  %elem = load i32, ptr %arr.elem, align 4
  %rnk7 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %rnk8 = load ptr, ptr %rnk7, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %rb9 = load i32, ptr %rb, align 4
  %8 = sext i32 %rb9 to i64
  %arr.len10 = load i64, ptr %rnk8, align 8
  %arr.oob11 = icmp uge i64 %8, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1946, ptr @.faila.1947, i64 %8, ptr @.failb.1948, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %rnk8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %8
  %elem16 = load i32, ptr %arr.elem15, align 4
  %9 = icmp slt i32 %elem, %elem16
  %10 = zext i1 %9 to i32
  br i1 %9, label %if.then17, label %if.else

if.then17:                                        ; preds = %idx.ok13
  %parent = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent19 = load ptr, ptr %parent, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %ra20 = load i32, ptr %ra, align 4
  %11 = sext i32 %ra20 to i64
  %arr.len21 = load i64, ptr %parent19, align 8
  %arr.oob22 = icmp uge i64 %11, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

if.else:                                          ; preds = %idx.ok13
  %rnk28 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %rnk29 = load ptr, ptr %rnk28, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %ra30 = load i32, ptr %ra, align 4
  %12 = sext i32 %ra30 to i64
  %arr.len31 = load i64, ptr %rnk29, align 8
  %arr.oob32 = icmp uge i64 %12, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !8

if.end18:                                         ; preds = %if.end50, %idx.ok24
  %count = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 3
  %count90 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 3
  %count91 = load i32, ptr %count90, align 4, !tbaa !4
  %13 = sub i32 %count91, 1
  store i32 %13, ptr %count, align 4, !tbaa !4
  ret void

idx.bad23:                                        ; preds = %if.then17
  call void @__polaron_fail(ptr @.fail.1949, ptr @.faila.1950, i64 %11, ptr @.failb.1951, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %if.then17
  %arr.data25 = getelementptr i8, ptr %parent19, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 %11
  %rb27 = load i32, ptr %rb, align 4
  store i32 %rb27, ptr %arr.elem26, align 4
  br label %if.end18

idx.bad33:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1952, ptr @.faila.1953, i64 %12, ptr @.failb.1954, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.else
  %arr.data35 = getelementptr i8, ptr %rnk29, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 %12
  %elem37 = load i32, ptr %arr.elem36, align 4
  %rnk38 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %rnk39 = load ptr, ptr %rnk38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %rb40 = load i32, ptr %rb, align 4
  %14 = sext i32 %rb40 to i64
  %arr.len41 = load i64, ptr %rnk39, align 8
  %arr.oob42 = icmp uge i64 %14, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

idx.bad43:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.1955, ptr @.faila.1956, i64 %14, ptr @.failb.1957, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %idx.ok34
  %arr.data45 = getelementptr i8, ptr %rnk39, i64 8
  %arr.elem46 = getelementptr inbounds i32, ptr %arr.data45, i64 %14
  %elem47 = load i32, ptr %arr.elem46, align 4
  %15 = icmp sgt i32 %elem37, %elem47
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then48, label %if.else49

if.then48:                                        ; preds = %idx.ok44
  %parent51 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent52 = load ptr, ptr %parent51, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %rb53 = load i32, ptr %rb, align 4
  %17 = sext i32 %rb53 to i64
  %arr.len54 = load i64, ptr %parent52, align 8
  %arr.oob55 = icmp uge i64 %17, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !8

if.else49:                                        ; preds = %idx.ok44
  %parent61 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 1
  %parent62 = load ptr, ptr %parent61, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %rb63 = load i32, ptr %rb, align 4
  %18 = sext i32 %rb63 to i64
  %arr.len64 = load i64, ptr %parent62, align 8
  %arr.oob65 = icmp uge i64 %18, %arr.len64
  br i1 %arr.oob65, label %idx.bad66, label %idx.ok67, !prof !8

if.end50:                                         ; preds = %idx.ok86, %idx.ok57
  br label %if.end18

idx.bad56:                                        ; preds = %if.then48
  call void @__polaron_fail(ptr @.fail.1958, ptr @.faila.1959, i64 %17, ptr @.failb.1960, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %if.then48
  %arr.data58 = getelementptr i8, ptr %parent52, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 %17
  %ra60 = load i32, ptr %ra, align 4
  store i32 %ra60, ptr %arr.elem59, align 4
  br label %if.end50

idx.bad66:                                        ; preds = %if.else49
  call void @__polaron_fail(ptr @.fail.1961, ptr @.faila.1962, i64 %18, ptr @.failb.1963, i64 %arr.len64, i32 70)
  unreachable

idx.ok67:                                         ; preds = %if.else49
  %arr.data68 = getelementptr i8, ptr %parent62, i64 8
  %arr.elem69 = getelementptr inbounds i32, ptr %arr.data68, i64 %18
  %ra70 = load i32, ptr %ra, align 4
  store i32 %ra70, ptr %arr.elem69, align 4
  %rnk71 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %rnk72 = load ptr, ptr %rnk71, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %ra73 = load i32, ptr %ra, align 4
  %19 = sext i32 %ra73 to i64
  %arr.len74 = load i64, ptr %rnk72, align 8
  %arr.oob75 = icmp uge i64 %19, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !8

idx.bad76:                                        ; preds = %idx.ok67
  call void @__polaron_fail(ptr @.fail.1964, ptr @.faila.1965, i64 %19, ptr @.failb.1966, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %idx.ok67
  %arr.data78 = getelementptr i8, ptr %rnk72, i64 8
  %arr.elem79 = getelementptr inbounds i32, ptr %arr.data78, i64 %19
  %rnk80 = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 2
  %rnk81 = load ptr, ptr %rnk80, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %ra82 = load i32, ptr %ra, align 4
  %20 = sext i32 %ra82 to i64
  %arr.len83 = load i64, ptr %rnk81, align 8
  %arr.oob84 = icmp uge i64 %20, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !8

idx.bad85:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.1967, ptr @.faila.1968, i64 %20, ptr @.failb.1969, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok77
  %arr.data87 = getelementptr i8, ptr %rnk81, i64 8
  %arr.elem88 = getelementptr inbounds i32, ptr %arr.data87, i64 %20
  %elem89 = load i32, ptr %arr.elem88, align 4
  %21 = add i32 %elem89, 1
  store i32 %21, ptr %arr.elem79, align 4
  br label %if.end50
}

define internal i32 @UnionFind.connected(ptr nonnull align 8 dereferenceable(32) %0, i32 %1, i32 %2) {
entry:
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  store i32 %2, ptr %b, align 4
  %a1 = load i32, ptr %a, align 4
  %3 = call i32 @UnionFind.find(ptr %0, i32 %a1)
  %b2 = load i32, ptr %b, align 4
  %4 = call i32 @UnionFind.find(ptr %0, i32 %b2)
  %5 = icmp eq i32 %3, %4
  %6 = zext i1 %5 to i32
  ret i32 %6
}

define internal i32 @UnionFind.groups(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %class.UnionFind, ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5363)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5365)
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

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

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
