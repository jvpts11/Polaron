; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collections_basic.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/collections_basic.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.Stack$int" = type { ptr, ptr, i32 }
%"class.Queue$int" = type { ptr, ptr, i32, i32 }
%"class.Deque$int" = type { ptr, ptr, i32, i32 }
%class.DivideByZeroException = type { ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"Queue$int.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr @"Queue$int.peek", ptr @"Queue$int.toArray", ptr @"Queue$int.size", ptr @"Queue$int.isEmpty", ptr @"Queue$int.enqueue", ptr @"Queue$int.dequeue", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Queue$int.~Queue$int"]
@"Stack$int.vtable" = private constant [353 x ptr] [ptr @"Stack$int.push", ptr @"Stack$int.pop", ptr @"Stack$int.peek", ptr @"Stack$int.toArray", ptr @"Stack$int.size", ptr @"Stack$int.isEmpty", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Stack$int.~Stack$int"]
@"Deque$int.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr @"Deque$int.toArray", ptr @"Deque$int.size", ptr @"Deque$int.isEmpty", ptr null, ptr null, ptr null, ptr @"Deque$int.grow", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.addLast", ptr @"Deque$int.addFirst", ptr @"Deque$int.removeFirst", ptr @"Deque$int.removeLast", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"Deque$int.~Deque$int"]
@Object.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [13 x i8] c"stack=%d %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [13 x i8] c"queue=%d %d\0A\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"deque=%d %d %d\0A\00", align 1
@.contract = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:666:34  in Stack$int.Stack$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.3 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:667:34  in Stack$int.Stack$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:675:78  in Stack$int.push\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:675:78  in Stack$int.push\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:679:39  in Stack$int.push\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.10 = private unnamed_addr constant [105 x i8] c"contract violated: invariant\0A  --> <prelude>:666:34  in Stack$int.push\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.11 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.12 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.13 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:667:34  in Stack$int.push\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.14 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:684:17  in Stack$int.pop\0A\00", align 1
@.faila.15 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.16 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.17 = private unnamed_addr constant [104 x i8] c"contract violated: invariant\0A  --> <prelude>:666:34  in Stack$int.pop\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.18 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.19 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.20 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:667:34  in Stack$int.pop\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.21 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:686:46  in Stack$int.peek\0A\00", align 1
@.faila.22 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.23 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.24 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:689:71  in Stack$int.toArray\0A\00", align 1
@.faila.25 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.26 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.27 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:689:71  in Stack$int.toArray\0A\00", align 1
@.faila.28 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.29 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.30 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.Queue$int\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.31 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.32 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.33 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.Queue$int\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.34 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.Queue$int\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.35 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.36 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.37 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.Queue$int\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.38 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:712:35  in Queue$int.enqueue\0A\00", align 1
@.faila.39 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.40 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.41 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:712:35  in Queue$int.enqueue\0A\00", align 1
@.faila.42 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.43 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.44 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:718:74  in Queue$int.enqueue\0A\00", align 1
@.faila.45 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.46 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.47 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.enqueue\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.48 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.49 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.50 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.enqueue\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.51 = private unnamed_addr constant [107 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.enqueue\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.52 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.53 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.54 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.enqueue\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.55 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:722:17  in Queue$int.dequeue\0A\00", align 1
@.faila.56 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.57 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.58 = private unnamed_addr constant [108 x i8] c"contract violated: invariant\0A  --> <prelude>:699:34  in Queue$int.dequeue\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.59 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.60 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.61 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:700:34  in Queue$int.dequeue\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.62 = private unnamed_addr constant [107 x i8] c"contract violated: invariant\0A  --> <prelude>:701:33  in Queue$int.dequeue\0A   |  invariant this.head >= 0;\0A\00", align 1
@.cl.63 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.64 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.65 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:702:33  in Queue$int.dequeue\0A   |  invariant this.head < this.data.length();\0A\00", align 1
@.fail.66 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:727:46  in Queue$int.peek\0A\00", align 1
@.faila.67 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.68 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.69 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:731:28  in Queue$int.toArray\0A\00", align 1
@.faila.70 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.71 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.72 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:731:28  in Queue$int.toArray\0A\00", align 1
@.faila.73 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.74 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.707 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:749:31  in Deque$int.grow\0A\00", align 1
@.faila.708 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.709 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.710 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:749:31  in Deque$int.grow\0A\00", align 1
@.faila.711 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.712 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.713 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:757:74  in Deque$int.addLast\0A\00", align 1
@.faila.714 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.715 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.716 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:763:38  in Deque$int.addFirst\0A\00", align 1
@.faila.717 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.718 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.719 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:767:17  in Deque$int.removeFirst\0A\00", align 1
@.faila.720 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.721 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.722 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:774:17  in Deque$int.removeLast\0A\00", align 1
@.faila.723 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.724 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.725 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:779:28  in Deque$int.toArray\0A\00", align 1
@.faila.726 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.727 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.728 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:779:28  in Deque$int.toArray\0A\00", align 1
@.faila.729 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.730 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1363 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1364 = private global %String { i64 16, ptr @.strdata.1363, i64 0 }
@.strdata.1365 = private constant [17 x i8] c"division by zero\00"
@.strobj.1366 = private global %String { i64 16, ptr @.strdata.1365, i64 0 }
@.strdata.5364 = private constant [1 x i8] zeroinitializer
@.strobj.5365 = private global %String { i64 0, ptr @.strdata.5364, i64 0 }
@.strdata.5366 = private constant [1 x i8] zeroinitializer
@.strobj.5367 = private global %String { i64 0, ptr @.strdata.5366, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %d = alloca ptr, align 8
  %q = alloca ptr, align 8
  %s = alloca ptr, align 8
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
  %"Stack$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Stack$int", ptr null, i64 1) to i64))
  call void @"Stack$int.Stack$int"(ptr %"Stack$int.obj")
  store ptr %"Stack$int.obj", ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  call void @"Stack$int.push"(ptr %s1, i32 1)
  %s2 = load ptr, ptr %s, align 8
  call void @"Stack$int.push"(ptr %s2, i32 2)
  %s3 = load ptr, ptr %s, align 8
  call void @"Stack$int.push"(ptr %s3, i32 3)
  %s4 = load ptr, ptr %s, align 8
  %16 = call i32 @"Stack$int.pop"(ptr %s4)
  %s5 = load ptr, ptr %s, align 8
  %17 = call i32 @"Stack$int.pop"(ptr %s5)
  %18 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16, i32 %17)
  %"Queue$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Queue$int", ptr null, i64 1) to i64))
  call void @"Queue$int.Queue$int"(ptr %"Queue$int.obj")
  store ptr %"Queue$int.obj", ptr %q, align 8
  %q6 = load ptr, ptr %q, align 8
  call void @"Queue$int.enqueue"(ptr %q6, i32 10)
  %q7 = load ptr, ptr %q, align 8
  call void @"Queue$int.enqueue"(ptr %q7, i32 20)
  %q8 = load ptr, ptr %q, align 8
  call void @"Queue$int.enqueue"(ptr %q8, i32 30)
  %q9 = load ptr, ptr %q, align 8
  %19 = call i32 @"Queue$int.dequeue"(ptr %q9)
  %q10 = load ptr, ptr %q, align 8
  %20 = call i32 @"Queue$int.dequeue"(ptr %q10)
  %21 = call i32 (ptr, ...) @printf(ptr @.str.1, i32 %19, i32 %20)
  %"Deque$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.Deque$int", ptr null, i64 1) to i64))
  call void @"Deque$int.Deque$int"(ptr %"Deque$int.obj")
  store ptr %"Deque$int.obj", ptr %d, align 8
  %d11 = load ptr, ptr %d, align 8
  call void @"Deque$int.addLast"(ptr %d11, i32 1)
  %d12 = load ptr, ptr %d, align 8
  call void @"Deque$int.addFirst"(ptr %d12, i32 0)
  %d13 = load ptr, ptr %d, align 8
  call void @"Deque$int.addLast"(ptr %d13, i32 2)
  %d14 = load ptr, ptr %d, align 8
  %22 = call i32 @"Deque$int.removeFirst"(ptr %d14)
  %d15 = load ptr, ptr %d, align 8
  %23 = call i32 @"Deque$int.removeFirst"(ptr %d15)
  %d16 = load ptr, ptr %d, align 8
  %24 = call i32 @"Deque$int.removeLast"(ptr %d16)
  %25 = call i32 (ptr, ...) @printf(ptr @.str.2, i32 %22, i32 %23, i32 %24)
  ret i32 0
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
  call void @__polaron_fail(ptr @.contract.3, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %19, ptr @.failb, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 %22, ptr @.failb.6, i64 %arr.len23, i32 70)
  unreachable

idx.ok26:                                         ; preds = %idx.ok
  %arr.data27 = getelementptr i8, ptr %data21, i64 8
  %arr.elem28 = getelementptr inbounds i32, ptr %arr.data27, i64 %22
  %elem = load i32, ptr %arr.elem28, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

idx.bad39:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 %16, ptr @.failb.9, i64 %arr.len37, i32 70)
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
  call void @__polaron_fail(ptr @.contract.10, ptr @.cl.11, i64 %contract.l, ptr @.cr.12, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.13, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.14, ptr @.faila.15, i64 %7, ptr @.failb.16, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.17, ptr @.cl.18, i64 %contract.l, ptr @.cr.19, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.20, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.21, ptr @.faila.22, i64 %7, ptr @.failb.23, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.24, ptr @.faila.25, i64 %12, ptr @.failb.26, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.27, ptr @.faila.28, i64 %15, ptr @.failb.29, i64 %arr.len17, i32 70)
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
  call void @__polaron_fail(ptr @.contract.30, ptr @.cl.31, i64 %contract.l, ptr @.cr.32, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.33, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.34, ptr @.cl.35, i64 %contract.l20, ptr @.cr.36, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.37, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.38, ptr @.faila.39, i64 %30, ptr @.failb.40, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.41, ptr @.faila.42, i64 %41, ptr @.failb.43, i64 %arr.len36, i32 70)
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
  call void @__polaron_fail(ptr @.fail.44, ptr @.faila.45, i64 %43, ptr @.failb.46, i64 %arr.len60, i32 70)
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
  call void @__polaron_fail(ptr @.contract.47, ptr @.cl.48, i64 %contract.l, ptr @.cr.49, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.50, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.51, ptr @.cl.52, i64 %contract.l89, ptr @.cr.53, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.54, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.55, ptr @.faila.56, i64 %11, ptr @.failb.57, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.contract.58, ptr @.cl.59, i64 %contract.l, ptr @.cr.60, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.61, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.62, ptr @.cl.63, i64 %contract.l47, ptr @.cr.64, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.contract.65, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @__polaron_fail(ptr @.fail.66, ptr @.faila.67, i64 %11, ptr @.failb.68, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.69, ptr @.faila.70, i64 %17, ptr @.failb.71, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.72, ptr @.faila.73, i64 %28, ptr @.failb.74, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.707, ptr @.faila.708, i64 %12, ptr @.failb.709, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.710, ptr @.faila.711, i64 %23, ptr @.failb.712, i64 %arr.len19, i32 70)
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
  call void @__polaron_fail(ptr @.fail.713, ptr @.faila.714, i64 %10, ptr @.failb.715, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.716, ptr @.faila.717, i64 %12, ptr @.failb.718, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.719, ptr @.faila.720, i64 %1, ptr @.failb.721, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.722, ptr @.faila.723, i64 %10, ptr @.failb.724, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.725, ptr @.faila.726, i64 %7, ptr @.failb.727, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.728, ptr @.faila.729, i64 %18, ptr @.failb.730, i64 %arr.len13, i32 70)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1364)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1366)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5365)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5367)
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
