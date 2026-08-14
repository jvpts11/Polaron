; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/statemachine_glob.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/statemachine_glob.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.StateMachine = type { ptr, ptr, ptr }
%"class.HashMap$String$String" = type { ptr, ptr, ptr, ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"HashMap$String$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$String.size", ptr @"HashMap$String$String.isEmpty", ptr @"HashMap$String$String.slotFor", ptr @"HashMap$String$String.grow", ptr @"HashMap$String$String.put", ptr @"HashMap$String$String.get", ptr @"HashMap$String$String.containsKey", ptr @"HashMap$String$String.getOrDefault", ptr @"HashMap$String$String.merge", ptr @"HashMap$String$String.remove", ptr @"HashMap$String$String.keyArray", ptr @"HashMap$String$String.valueArray", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashMap$String$String.~HashMap$String$String"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StateMachine.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StateMachine.addTransition, ptr @StateMachine.fire, ptr @StateMachine.state, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [7 x i8] c"locked\00"
@.strobj = private global %String { i64 6, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"locked\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [5 x i8] c"coin\00"
@.strobj.4 = private global %String { i64 4, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [9 x i8] c"unlocked\00"
@.strobj.6 = private global %String { i64 8, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [9 x i8] c"unlocked\00"
@.strobj.8 = private global %String { i64 8, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [5 x i8] c"push\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [7 x i8] c"locked\00"
@.strobj.12 = private global %String { i64 6, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [5 x i8] c"coin\00"
@.strobj.14 = private global %String { i64 4, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [5 x i8] c"coin\00"
@.strobj.16 = private global %String { i64 4, ptr @.strdata.15, i64 0 }
@.strdata.17 = private constant [5 x i8] c"push\00"
@.strobj.18 = private global %String { i64 4, ptr @.strdata.17, i64 0 }
@.str = private unnamed_addr constant [27 x i8] c"t1=%d t2=%d mid=%s end=%s\0A\00", align 1
@.str.19 = private unnamed_addr constant [31 x i8] c"g1=%d g2=%d g3=%d g4=%d g5=%d\0A\00", align 1
@.strdata.20 = private constant [4 x i8] c"a*c\00"
@.strobj.21 = private global %String { i64 3, ptr @.strdata.20, i64 0 }
@.strdata.22 = private constant [6 x i8] c"abbbc\00"
@.strobj.23 = private global %String { i64 5, ptr @.strdata.22, i64 0 }
@.strdata.24 = private constant [4 x i8] c"a?c\00"
@.strobj.25 = private global %String { i64 3, ptr @.strdata.24, i64 0 }
@.strdata.26 = private constant [4 x i8] c"abc\00"
@.strobj.27 = private global %String { i64 3, ptr @.strdata.26, i64 0 }
@.strdata.28 = private constant [4 x i8] c"a*c\00"
@.strobj.29 = private global %String { i64 3, ptr @.strdata.28, i64 0 }
@.strdata.30 = private constant [4 x i8] c"abd\00"
@.strobj.31 = private global %String { i64 3, ptr @.strdata.30, i64 0 }
@.strdata.32 = private constant [6 x i8] c"*.txt\00"
@.strobj.33 = private global %String { i64 5, ptr @.strdata.32, i64 0 }
@.strdata.34 = private constant [9 x i8] c"file.txt\00"
@.strobj.35 = private global %String { i64 8, ptr @.strdata.34, i64 0 }
@.strdata.36 = private constant [10 x i8] c"h*o?world\00"
@.strobj.37 = private global %String { i64 9, ptr @.strdata.36, i64 0 }
@.strdata.38 = private constant [12 x i8] c"hello world\00"
@.strobj.39 = private global %String { i64 11, ptr @.strdata.38, i64 0 }
@.contract.553 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.554 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.555 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.556 = private unnamed_addr constant [140 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.557 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.558 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.559 = private unnamed_addr constant [149 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.560 = private unnamed_addr constant [151 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.561 = private unnamed_addr constant [149 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.HashMap$String$String\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.562 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1004:17  in HashMap$String$String.slotFor\0A\00", align 1
@.faila.563 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.564 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.565 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1005:21  in HashMap$String$String.slotFor\0A\00", align 1
@.faila.566 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.567 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.568 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1033:21  in HashMap$String$String.grow\0A\00", align 1
@.faila.569 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.570 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.571 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1034:25  in HashMap$String$String.grow\0A\00", align 1
@.faila.572 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.573 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.574 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1035:25  in HashMap$String$String.grow\0A\00", align 1
@.faila.575 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.576 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.577 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1036:38  in HashMap$String$String.grow\0A\00", align 1
@.faila.578 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.579 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.580 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$String.grow\0A\00", align 1
@.faila.581 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.582 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.583 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1037:38  in HashMap$String$String.grow\0A\00", align 1
@.faila.584 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.585 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.586 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$String.grow\0A\00", align 1
@.faila.587 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.588 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.589 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1038:40  in HashMap$String$String.grow\0A\00", align 1
@.faila.590 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.591 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.592 = private unnamed_addr constant [117 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.grow\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.593 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.594 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.595 = private unnamed_addr constant [123 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.grow\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.596 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.597 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.598 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.grow\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.599 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.grow\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.600 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.grow\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.601 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:17  in HashMap$String$String.put\0A\00", align 1
@.faila.602 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.603 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.604 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1048:55  in HashMap$String$String.put\0A\00", align 1
@.faila.605 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.606 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.607 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1049:30  in HashMap$String$String.put\0A\00", align 1
@.faila.608 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.609 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.610 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1050:32  in HashMap$String$String.put\0A\00", align 1
@.faila.611 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.612 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.613 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.put\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.614 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.615 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.616 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.put\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.617 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.618 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.619 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.put\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.620 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.put\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.621 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.put\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.622 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1053:17  in HashMap$String$String.get\0A\00", align 1
@.faila.623 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.624 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.625 = private unnamed_addr constant [104 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1056:17  in HashMap$String$String.containsKey\0A\00", align 1
@.faila.626 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.627 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.628 = private unnamed_addr constant [105 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:17  in HashMap$String$String.getOrDefault\0A\00", align 1
@.faila.629 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.630 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.631 = private unnamed_addr constant [105 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1063:42  in HashMap$String$String.getOrDefault\0A\00", align 1
@.faila.632 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.633 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.634 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1069:17  in HashMap$String$String.merge\0A\00", align 1
@.faila.635 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.636 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.637 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1070:34  in HashMap$String$String.merge\0A\00", align 1
@.faila.638 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.639 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.640 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1072:34  in HashMap$String$String.merge\0A\00", align 1
@.faila.641 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.642 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.643 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1073:36  in HashMap$String$String.merge\0A\00", align 1
@.faila.644 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.645 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.646 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$String.merge\0A\00", align 1
@.faila.647 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.648 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.649 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1075:36  in HashMap$String$String.merge\0A\00", align 1
@.faila.650 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.651 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.652 = private unnamed_addr constant [118 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.merge\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.653 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.654 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.655 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.merge\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.656 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.657 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.658 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:966:42  in HashMap$String$String.merge\0A   |  invariant this.keys.length() == this.cap;\0A\00", align 1
@.contract.659 = private unnamed_addr constant [135 x i8] c"contract violated: invariant\0A  --> <prelude>:967:44  in HashMap$String$String.merge\0A   |  invariant this.values.length() == this.cap;\0A\00", align 1
@.contract.660 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.merge\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.661 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1080:17  in HashMap$String$String.remove\0A\00", align 1
@.faila.662 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.663 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.664 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.665 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.666 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.667 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.668 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.669 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.670 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.671 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1082:30  in HashMap$String$String.remove\0A\00", align 1
@.faila.672 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.673 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.674 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1085:17  in HashMap$String$String.remove\0A\00", align 1
@.faila.675 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.676 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.677 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1086:21  in HashMap$String$String.remove\0A\00", align 1
@.faila.678 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.679 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.680 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1087:21  in HashMap$String$String.remove\0A\00", align 1
@.faila.681 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.682 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.683 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1088:34  in HashMap$String$String.remove\0A\00", align 1
@.faila.684 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.685 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.686 = private unnamed_addr constant [119 x i8] c"contract violated: invariant\0A  --> <prelude>:964:34  in HashMap$String$String.remove\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.687 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.688 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.689 = private unnamed_addr constant [125 x i8] c"contract violated: invariant\0A  --> <prelude>:965:34  in HashMap$String$String.remove\0A   |  invariant this.count < this.cap;\0A\00", align 1
@.cl.690 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.691 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.692 = private unnamed_addr constant [134 x i8] c"contract violated: invariant\0A  --> <prelude>:968:42  in HashMap$String$String.remove\0A   |  invariant this.used.length() == this.cap;\0A\00", align 1
@.fail.693 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:21  in HashMap$String$String.keyArray\0A\00", align 1
@.faila.694 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.695 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.696 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$String.keyArray\0A\00", align 1
@.faila.697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.699 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1099:53  in HashMap$String$String.keyArray\0A\00", align 1
@.faila.700 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.701 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.702 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:21  in HashMap$String$String.valueArray\0A\00", align 1
@.faila.703 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.704 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.705 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$String.valueArray\0A\00", align 1
@.faila.706 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.707 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.708 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1107:53  in HashMap$String$String.valueArray\0A\00", align 1
@.faila.709 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.710 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.2587 = private constant [2 x i8] c"|\00"
@.strobj.2588 = private global %String { i64 1, ptr @.strdata.2587, i64 0 }
@.strdata.2589 = private constant [2 x i8] c"|\00"
@.strobj.2590 = private global %String { i64 1, ptr @.strdata.2589, i64 0 }
@.strdata.5346 = private constant [1 x i8] zeroinitializer
@.strobj.5347 = private global %String { i64 0, ptr @.strdata.5346, i64 0 }
@.strdata.5348 = private constant [1 x i8] zeroinitializer
@.strobj.5349 = private global %String { i64 0, ptr @.strdata.5348, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %s1 = alloca ptr, align 8
  %t2 = alloca i32, align 4
  %t1 = alloca i32, align 4
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
  %StateMachine.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StateMachine, ptr null, i64 1) to i64))
  call void @StateMachine.StateMachine(ptr %StateMachine.obj, ptr @.strobj)
  store ptr %StateMachine.obj, ptr %sm, align 8
  %sm1 = load ptr, ptr %sm, align 8
  call void @StateMachine.addTransition(ptr %sm1, ptr @.strobj.2, ptr @.strobj.4, ptr @.strobj.6)
  %sm2 = load ptr, ptr %sm, align 8
  call void @StateMachine.addTransition(ptr %sm2, ptr @.strobj.8, ptr @.strobj.10, ptr @.strobj.12)
  %sm3 = load ptr, ptr %sm, align 8
  %16 = call i32 @StateMachine.fire(ptr %sm3, ptr @.strobj.14)
  store i32 %16, ptr %t1, align 4
  %sm4 = load ptr, ptr %sm, align 8
  %17 = call i32 @StateMachine.fire(ptr %sm4, ptr @.strobj.16)
  store i32 %17, ptr %t2, align 4
  %sm5 = load ptr, ptr %sm, align 8
  %18 = call ptr @StateMachine.state(ptr %sm5)
  %strcpy = call ptr @__polaron_str_copy(ptr %18)
  store ptr %strcpy, ptr %s1, align 8
  call void @__polaron_str_free(ptr %18)
  %sm6 = load ptr, ptr %sm, align 8
  %19 = call i32 @StateMachine.fire(ptr %sm6, ptr @.strobj.18)
  %t17 = load i32, ptr %t1, align 4
  %t28 = load i32, ptr %t2, align 4
  %s19 = load ptr, ptr %s1, align 8
  %str.data = getelementptr inbounds %String, ptr %s19, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %sm10 = load ptr, ptr %sm, align 8
  %20 = call ptr @StateMachine.state(ptr %sm10)
  %str.data11 = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %21 = call i32 (ptr, ...) @printf(ptr @.str, i32 %t17, i32 %t28, ptr %data, ptr %data12)
  call void @__polaron_str_free(ptr %20)
  %22 = call i32 @Glob.matches(ptr @.strobj.21, ptr @.strobj.23)
  %23 = call i32 @Glob.matches(ptr @.strobj.25, ptr @.strobj.27)
  %24 = call i32 @Glob.matches(ptr @.strobj.29, ptr @.strobj.31)
  %25 = call i32 @Glob.matches(ptr @.strobj.33, ptr @.strobj.35)
  %26 = call i32 @Glob.matches(ptr @.strobj.37, ptr @.strobj.39)
  %27 = call i32 (ptr, ...) @printf(ptr @.str.19, i32 %22, i32 %23, i32 %24, i32 %25, i32 %26)
  %28 = load ptr, ptr %s1, align 8
  call void @__polaron_str_free(ptr %28)
  ret i32 0
}

define internal void @"HashMap$String$String.HashMap$String$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 0
  store ptr @"HashMap$String$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %keys, align 8, !tbaa !0
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %values, align 8, !tbaa !0
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  store ptr null, ptr %used, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !4
  %keys1 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %keys1, align 8, !tbaa !0
  %values2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 64)
  store ptr %arr3, ptr %values2, align 8, !tbaa !0
  %used5 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %arr6 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr6, align 8
  %arr.data7 = getelementptr i8, ptr %arr6, i64 8
  %3 = call ptr @memset(ptr %arr.data7, i32 0, i64 8)
  store ptr %arr6, ptr %used5, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %count8 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %4 = icmp sge i32 %count9, 0
  %5 = zext i1 %4 to i32
  %contract.ok = icmp ne i32 %5, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count10 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %contract.l = sext i32 %count11 to i64
  call void @__polaron_fail(ptr @.contract.553, ptr @.cl.554, i64 %contract.l, ptr @.cr.555, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count13 = load i32, ptr %count12, align 4, !tbaa !4
  %cap14 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap15 = load i32, ptr %cap14, align 4, !tbaa !4
  %6 = icmp slt i32 %count13, %cap15
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  %count19 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %cap21 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap22 = load i32, ptr %cap21, align 4, !tbaa !4
  %contract.l23 = sext i32 %count20 to i64
  %contract.r = sext i32 %cap22 to i64
  call void @__polaron_fail(ptr @.contract.556, ptr @.cl.557, i64 %contract.l23, ptr @.cr.558, i64 %contract.r, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  %keys24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys25 = load ptr, ptr %keys24, align 8, !tbaa !0
  %len = load i64, ptr %keys25, align 8
  %8 = trunc i64 %len to i32
  %cap26 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap27 = load i32, ptr %cap26, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap27
  %10 = zext i1 %9 to i32
  %contract.ok28 = icmp ne i32 %10, 0
  br i1 %contract.ok28, label %contract.cont30, label %contract.fail29

contract.fail29:                                  ; preds = %contract.cont18
  call void @__polaron_fail(ptr @.contract.559, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont30:                                  ; preds = %contract.cont18
  %values31 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values32 = load ptr, ptr %values31, align 8, !tbaa !0
  %len33 = load i64, ptr %values32, align 8
  %11 = trunc i64 %len33 to i32
  %cap34 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap35
  %13 = zext i1 %12 to i32
  %contract.ok36 = icmp ne i32 %13, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %contract.cont30
  call void @__polaron_fail(ptr @.contract.560, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %contract.cont30
  %used39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used40 = load ptr, ptr %used39, align 8, !tbaa !0
  %len41 = load i64, ptr %used40, align 8
  %14 = trunc i64 %len41 to i32
  %cap42 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap43 = load i32, ptr %cap42, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap43
  %16 = zext i1 %15 to i32
  %contract.ok44 = icmp ne i32 %16, 0
  br i1 %contract.ok44, label %contract.cont46, label %contract.fail45

contract.fail45:                                  ; preds = %contract.cont38
  call void @__polaron_fail(ptr @.contract.561, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont46:                                  ; preds = %contract.cont38
  ret void
}

define internal void @"HashMap$String$String.~HashMap$String$String"(ptr %0) {
entry:
  %ae.i5 = alloca i64, align 8
  %ae.i = alloca i64, align 8
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
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
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values2 = load ptr, ptr %values, align 8, !tbaa !0
  %ae.len3 = load i64, ptr %values2, align 8
  %arr.data4 = getelementptr i8, ptr %values2, i64 8
  store i64 0, ptr %ae.i5, align 8
  br label %ae.cond6

ae.cond6:                                         ; preds = %ae.next9, %ae.end
  %ae.iv11 = load i64, ptr %ae.i5, align 8
  %4 = icmp ult i64 %ae.iv11, %ae.len3
  br i1 %4, label %ae.body7, label %ae.end10

ae.body7:                                         ; preds = %ae.cond6
  %ae.ep12 = getelementptr ptr, ptr %arr.data4, i64 %ae.iv11
  %ae.el13 = load ptr, ptr %ae.ep12, align 8
  %5 = icmp ne ptr %ae.el13, null
  br i1 %5, label %ae.free8, label %ae.next9

ae.free8:                                         ; preds = %ae.body7
  call void @__polaron_str_free(ptr %ae.el13)
  store ptr null, ptr %ae.ep12, align 8
  br label %ae.next9

ae.next9:                                         ; preds = %ae.free8, %ae.body7
  %6 = add i64 %ae.iv11, 1
  store i64 %6, ptr %ae.i5, align 8
  br label %ae.cond6

ae.end10:                                         ; preds = %ae.cond6
  call void @__polaron_free(ptr %values2)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used14 = load ptr, ptr %used, align 8, !tbaa !0
  call void @__polaron_free(ptr %used14)
  ret void
}

define internal i32 @"HashMap$String$String.slotFor"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
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
  %used24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used25 = load ptr, ptr %used24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %19 = sext i32 %i26 to i64
  %arr.len = load i64, ptr %used25, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %keys27 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.562, ptr @.faila.563, i64 %19, ptr @.failb.564, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.565, ptr @.faila.566, i64 %20, ptr @.failb.567, i64 %arr.len30, i32 70)
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

define internal void @"HashMap$String$String.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %ae.i123 = alloca i64, align 8
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldV = alloca ptr, align 8
  %oldK = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %cap20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap21 = load i32, ptr %cap20, align 4, !tbaa !4
  store i32 %cap21, ptr %oldCap, align 4
  %keys22 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys23 = load ptr, ptr %keys22, align 8, !tbaa !0
  store ptr %keys23, ptr %oldK, align 8
  %values24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0
  store ptr %values25, ptr %oldV, align 8
  %used26 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used27 = load ptr, ptr %used26, align 8, !tbaa !0
  store ptr %used27, ptr %oldU, align 8
  %cap28 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %oldCap29 = load i32, ptr %oldCap, align 4
  %14 = mul i32 %oldCap29, 4
  store i32 %14, ptr %cap28, align 4, !tbaa !4
  %keys30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %cap31 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap32 = load i32, ptr %cap31, align 4, !tbaa !4
  %15 = sext i32 %cap32 to i64
  %16 = mul i64 %15, 8
  %17 = add i64 8, %16
  %arr = call ptr @__polaron_malloc(i64 %17)
  store i64 %15, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %18 = call ptr @memset(ptr %arr.data, i32 0, i64 %16)
  store ptr %arr, ptr %keys30, align 8, !tbaa !0
  %values33 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %cap34 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap35 = load i32, ptr %cap34, align 4, !tbaa !4
  %19 = sext i32 %cap35 to i64
  %20 = mul i64 %19, 8
  %21 = add i64 8, %20
  %arr36 = call ptr @__polaron_malloc(i64 %21)
  store i64 %19, ptr %arr36, align 8
  %arr.data37 = getelementptr i8, ptr %arr36, i64 8
  %22 = call ptr @memset(ptr %arr.data37, i32 0, i64 %20)
  store ptr %arr36, ptr %values33, align 8, !tbaa !0
  %used38 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %cap39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap40 = load i32, ptr %cap39, align 4, !tbaa !4
  %23 = sext i32 %cap40 to i64
  %24 = mul i64 %23, 1
  %25 = add i64 8, %24
  %arr41 = call ptr @__polaron_malloc(i64 %25)
  store i64 %23, ptr %arr41, align 8
  %arr.data42 = getelementptr i8, ptr %arr41, i64 8
  %26 = call ptr @memset(ptr %arr.data42, i32 0, i64 %24)
  store ptr %arr41, ptr %used38, align 8, !tbaa !0
  %cap43 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
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
  %oldK118 = load ptr, ptr %oldK, align 8
  %ae.len = load i64, ptr %oldK118, align 8
  %arr.data119 = getelementptr i8, ptr %oldK118, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.568, ptr @.faila.569, i64 %30, ptr @.failb.570, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.571, ptr @.faila.572, i64 %36, ptr @.failb.573, i64 %arr.len52, i32 70)
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
  %used60 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
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
  %used72 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used73 = load ptr, ptr %used72, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i74 = load i32, ptr %i, align 4
  %43 = sext i32 %i74 to i64
  %arr.len75 = load i64, ptr %used73, align 8
  %arr.oob76 = icmp uge i64 %43, %arr.len75
  br i1 %arr.oob76, label %idx.bad77, label %idx.ok78, !prof !8

idx.bad65:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.574, ptr @.faila.575, i64 %40, ptr @.failb.576, i64 %arr.len63, i32 70)
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
  call void @__polaron_fail(ptr @.fail.577, ptr @.faila.578, i64 %43, ptr @.failb.579, i64 %arr.len75, i32 70)
  unreachable

idx.ok78:                                         ; preds = %while.end
  %arr.data79 = getelementptr i8, ptr %used73, i64 8
  %arr.elem80 = getelementptr inbounds i8, ptr %arr.data79, i64 %43
  store i8 1, ptr %arr.elem80, align 1
  %keys81 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys82 = load ptr, ptr %keys81, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i83 = load i32, ptr %i, align 4
  %47 = sext i32 %i83 to i64
  %arr.len84 = load i64, ptr %keys82, align 8
  %arr.oob85 = icmp uge i64 %47, %arr.len84
  br i1 %arr.oob85, label %idx.bad86, label %idx.ok87, !prof !8

idx.bad86:                                        ; preds = %idx.ok78
  call void @__polaron_fail(ptr @.fail.580, ptr @.faila.581, i64 %47, ptr @.failb.582, i64 %arr.len84, i32 70)
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
  call void @__polaron_fail(ptr @.fail.583, ptr @.faila.584, i64 %48, ptr @.failb.585, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok87
  %arr.data96 = getelementptr i8, ptr %oldK90, i64 8
  %arr.elem97 = getelementptr inbounds ptr, ptr %arr.data96, i64 %48
  %elem98 = load ptr, ptr %arr.elem97, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem98)
  %49 = load ptr, ptr %arr.elem89, align 8
  call void @__polaron_str_free(ptr %49)
  store ptr %strcpy, ptr %arr.elem89, align 8
  %values99 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values100 = load ptr, ptr %values99, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i101 = load i32, ptr %i, align 4
  %50 = sext i32 %i101 to i64
  %arr.len102 = load i64, ptr %values100, align 8
  %arr.oob103 = icmp uge i64 %50, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !8

idx.bad104:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.586, ptr @.faila.587, i64 %50, ptr @.failb.588, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %idx.ok95
  %arr.data106 = getelementptr i8, ptr %values100, i64 8
  %arr.elem107 = getelementptr inbounds ptr, ptr %arr.data106, i64 %50
  %oldV108 = load ptr, ptr %oldV, align 8, !nonnull !6, !dereferenceable !7
  %j109 = load i32, ptr %j, align 4
  %51 = sext i32 %j109 to i64
  %arr.len110 = load i64, ptr %oldV108, align 8
  %arr.oob111 = icmp uge i64 %51, %arr.len110
  br i1 %arr.oob111, label %idx.bad112, label %idx.ok113, !prof !8

idx.bad112:                                       ; preds = %idx.ok105
  call void @__polaron_fail(ptr @.fail.589, ptr @.faila.590, i64 %51, ptr @.failb.591, i64 %arr.len110, i32 70)
  unreachable

idx.ok113:                                        ; preds = %idx.ok105
  %arr.data114 = getelementptr i8, ptr %oldV108, i64 8
  %arr.elem115 = getelementptr inbounds ptr, ptr %arr.data114, i64 %51
  %elem116 = load ptr, ptr %arr.elem115, align 8
  %strcpy117 = call ptr @__polaron_str_copy(ptr %elem116)
  %52 = load ptr, ptr %arr.elem107, align 8
  call void @__polaron_str_free(ptr %52)
  store ptr %strcpy117, ptr %arr.elem107, align 8
  br label %if.end

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %53 = icmp ult i64 %ae.iv, %ae.len
  br i1 %53, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data119, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %54 = icmp ne ptr %ae.el, null
  br i1 %54, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_str_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

ae.next:                                          ; preds = %ae.free, %ae.body
  %55 = add i64 %ae.iv, 1
  store i64 %55, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %oldK118)
  %oldV120 = load ptr, ptr %oldV, align 8
  %ae.len121 = load i64, ptr %oldV120, align 8
  %arr.data122 = getelementptr i8, ptr %oldV120, i64 8
  store i64 0, ptr %ae.i123, align 8
  br label %ae.cond124

ae.cond124:                                       ; preds = %ae.next127, %ae.end
  %ae.iv129 = load i64, ptr %ae.i123, align 8
  %56 = icmp ult i64 %ae.iv129, %ae.len121
  br i1 %56, label %ae.body125, label %ae.end128

ae.body125:                                       ; preds = %ae.cond124
  %ae.ep130 = getelementptr ptr, ptr %arr.data122, i64 %ae.iv129
  %ae.el131 = load ptr, ptr %ae.ep130, align 8
  %57 = icmp ne ptr %ae.el131, null
  br i1 %57, label %ae.free126, label %ae.next127

ae.free126:                                       ; preds = %ae.body125
  call void @__polaron_str_free(ptr %ae.el131)
  store ptr null, ptr %ae.ep130, align 8
  br label %ae.next127

ae.next127:                                       ; preds = %ae.free126, %ae.body125
  %58 = add i64 %ae.iv129, 1
  store i64 %58, ptr %ae.i123, align 8
  br label %ae.cond124

ae.end128:                                        ; preds = %ae.cond124
  call void @__polaron_free(ptr %oldV120)
  %oldU132 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU132)
  %count133 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count134 = load i32, ptr %count133, align 4, !tbaa !4
  %59 = icmp sge i32 %count134, 0
  %60 = zext i1 %59 to i32
  %contract.ok = icmp ne i32 %60, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %ae.end128
  %count135 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count136 = load i32, ptr %count135, align 4, !tbaa !4
  %contract.l = sext i32 %count136 to i64
  call void @__polaron_fail(ptr @.contract.592, ptr @.cl.593, i64 %contract.l, ptr @.cr.594, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %ae.end128
  %count137 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count138 = load i32, ptr %count137, align 4, !tbaa !4
  %cap139 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap140 = load i32, ptr %cap139, align 4, !tbaa !4
  %61 = icmp slt i32 %count138, %cap140
  %62 = zext i1 %61 to i32
  %contract.ok141 = icmp ne i32 %62, 0
  br i1 %contract.ok141, label %contract.cont143, label %contract.fail142

contract.fail142:                                 ; preds = %contract.cont
  %count144 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count145 = load i32, ptr %count144, align 4, !tbaa !4
  %cap146 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap147 = load i32, ptr %cap146, align 4, !tbaa !4
  %contract.l148 = sext i32 %count145 to i64
  %contract.r = sext i32 %cap147 to i64
  call void @__polaron_fail(ptr @.contract.595, ptr @.cl.596, i64 %contract.l148, ptr @.cr.597, i64 %contract.r, i32 1)
  unreachable

contract.cont143:                                 ; preds = %contract.cont
  %keys149 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys150 = load ptr, ptr %keys149, align 8, !tbaa !0
  %len151 = load i64, ptr %keys150, align 8
  %63 = trunc i64 %len151 to i32
  %cap152 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap153 = load i32, ptr %cap152, align 4, !tbaa !4
  %64 = icmp eq i32 %63, %cap153
  %65 = zext i1 %64 to i32
  %contract.ok154 = icmp ne i32 %65, 0
  br i1 %contract.ok154, label %contract.cont156, label %contract.fail155

contract.fail155:                                 ; preds = %contract.cont143
  call void @__polaron_fail(ptr @.contract.598, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont156:                                 ; preds = %contract.cont143
  %values157 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values158 = load ptr, ptr %values157, align 8, !tbaa !0
  %len159 = load i64, ptr %values158, align 8
  %66 = trunc i64 %len159 to i32
  %cap160 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap161 = load i32, ptr %cap160, align 4, !tbaa !4
  %67 = icmp eq i32 %66, %cap161
  %68 = zext i1 %67 to i32
  %contract.ok162 = icmp ne i32 %68, 0
  br i1 %contract.ok162, label %contract.cont164, label %contract.fail163

contract.fail163:                                 ; preds = %contract.cont156
  call void @__polaron_fail(ptr @.contract.599, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont164:                                 ; preds = %contract.cont156
  %used165 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used166 = load ptr, ptr %used165, align 8, !tbaa !0
  %len167 = load i64, ptr %used166, align 8
  %69 = trunc i64 %len167 to i32
  %cap168 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap169 = load i32, ptr %cap168, align 4, !tbaa !4
  %70 = icmp eq i32 %69, %cap169
  %71 = zext i1 %70 to i32
  %contract.ok170 = icmp ne i32 %71, 0
  br i1 %contract.ok170, label %contract.cont172, label %contract.fail171

contract.fail171:                                 ; preds = %contract.cont164
  call void @__polaron_fail(ptr @.contract.600, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont172:                                 ; preds = %contract.cont164
  ret void
}

define internal void @"HashMap$String$String.put"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2) {
entry:
  %i = alloca i32, align 4
  %value = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %value, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %16 = add i32 %count21, 1
  %17 = mul i32 %16, 4
  %cap22 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %18 = mul i32 %cap23, 3
  %19 = icmp sge i32 %17, %18
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$String$String.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %21 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key24)
  store i32 %21, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %22 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %22, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.601, ptr @.faila.602, i64 %22, ptr @.failb.603, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %26 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %26, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.end29:                                         ; preds = %idx.ok36, %idx.ok
  %keys42 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %27 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %27, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.604, ptr @.faila.605, i64 %26, ptr @.failb.606, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %26
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %28 = add i32 %count41, 1
  store i32 %28, ptr %count39, align 4, !tbaa !4
  br label %if.end29

idx.bad47:                                        ; preds = %if.end29
  call void @__polaron_fail(ptr @.fail.607, ptr @.faila.608, i64 %27, ptr @.failb.609, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %if.end29
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %27
  %key51 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key51)
  %29 = load ptr, ptr %arr.elem50, align 8
  call void @__polaron_str_free(ptr %29)
  store ptr %strcpy, ptr %arr.elem50, align 8
  %values52 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %30 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %30, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.610, ptr @.faila.611, i64 %30, ptr @.failb.612, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %30
  %value61 = load ptr, ptr %value, align 8
  %strcpy62 = call ptr @__polaron_str_copy(ptr %value61)
  %31 = load ptr, ptr %arr.elem60, align 8
  call void @__polaron_str_free(ptr %31)
  store ptr %strcpy62, ptr %arr.elem60, align 8
  %count63 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count64 = load i32, ptr %count63, align 4, !tbaa !4
  %32 = icmp sge i32 %count64, 0
  %33 = zext i1 %32 to i32
  %contract.ok = icmp ne i32 %33, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok58
  %count65 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count66 = load i32, ptr %count65, align 4, !tbaa !4
  %contract.l = sext i32 %count66 to i64
  call void @__polaron_fail(ptr @.contract.613, ptr @.cl.614, i64 %contract.l, ptr @.cr.615, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok58
  %count67 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count68 = load i32, ptr %count67, align 4, !tbaa !4
  %cap69 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap70 = load i32, ptr %cap69, align 4, !tbaa !4
  %34 = icmp slt i32 %count68, %cap70
  %35 = zext i1 %34 to i32
  %contract.ok71 = icmp ne i32 %35, 0
  br i1 %contract.ok71, label %contract.cont73, label %contract.fail72

contract.fail72:                                  ; preds = %contract.cont
  %count74 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count75 = load i32, ptr %count74, align 4, !tbaa !4
  %cap76 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap77 = load i32, ptr %cap76, align 4, !tbaa !4
  %contract.l78 = sext i32 %count75 to i64
  %contract.r = sext i32 %cap77 to i64
  call void @__polaron_fail(ptr @.contract.616, ptr @.cl.617, i64 %contract.l78, ptr @.cr.618, i64 %contract.r, i32 1)
  unreachable

contract.cont73:                                  ; preds = %contract.cont
  %keys79 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys80 = load ptr, ptr %keys79, align 8, !tbaa !0
  %len81 = load i64, ptr %keys80, align 8
  %36 = trunc i64 %len81 to i32
  %cap82 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap83 = load i32, ptr %cap82, align 4, !tbaa !4
  %37 = icmp eq i32 %36, %cap83
  %38 = zext i1 %37 to i32
  %contract.ok84 = icmp ne i32 %38, 0
  br i1 %contract.ok84, label %contract.cont86, label %contract.fail85

contract.fail85:                                  ; preds = %contract.cont73
  call void @__polaron_fail(ptr @.contract.619, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont86:                                  ; preds = %contract.cont73
  %values87 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values88 = load ptr, ptr %values87, align 8, !tbaa !0
  %len89 = load i64, ptr %values88, align 8
  %39 = trunc i64 %len89 to i32
  %cap90 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap91 = load i32, ptr %cap90, align 4, !tbaa !4
  %40 = icmp eq i32 %39, %cap91
  %41 = zext i1 %40 to i32
  %contract.ok92 = icmp ne i32 %41, 0
  br i1 %contract.ok92, label %contract.cont94, label %contract.fail93

contract.fail93:                                  ; preds = %contract.cont86
  call void @__polaron_fail(ptr @.contract.620, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont94:                                  ; preds = %contract.cont86
  %used95 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used96 = load ptr, ptr %used95, align 8, !tbaa !0
  %len97 = load i64, ptr %used96, align 8
  %42 = trunc i64 %len97 to i32
  %cap98 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap99 = load i32, ptr %cap98, align 4, !tbaa !4
  %43 = icmp eq i32 %42, %cap99
  %44 = zext i1 %43 to i32
  %contract.ok100 = icmp ne i32 %44, 0
  br i1 %contract.ok100, label %contract.cont102, label %contract.fail101

contract.fail101:                                 ; preds = %contract.cont94
  call void @__polaron_fail(ptr @.contract.621, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont102:                                 ; preds = %contract.cont94
  ret void
}

define internal ptr @"HashMap$String$String.get"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %values20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values21 = load ptr, ptr %values20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %values21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.622, ptr @.faila.623, i64 %16, ptr @.failb.624, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %16
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy
}

define internal i32 @"HashMap$String$String.containsKey"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %used20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used21 = load ptr, ptr %used20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %key22 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key22)
  %16 = sext i32 %15 to i64
  %arr.len = load i64, ptr %used21, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.625, ptr @.faila.626, i64 %16, ptr @.failb.627, i64 %arr.len, i32 70)
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

define internal ptr @"HashMap$String$String.getOrDefault"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2) {
entry:
  %i = alloca i32, align 4
  %defaultValue = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %defaultValue, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %count3, %cap4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %7 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %8 = icmp eq i32 %7, %cap8
  %9 = zext i1 %8 to i32
  %inv.assume9 = icmp ne i32 %9, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %10 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %11 = icmp eq i32 %10, %cap13
  %12 = zext i1 %11 to i32
  %inv.assume14 = icmp ne i32 %12, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %13 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %14 = icmp eq i32 %13, %cap18
  %15 = zext i1 %14 to i32
  %inv.assume19 = icmp ne i32 %15, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %16 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key20)
  store i32 %16, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %17 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.628, ptr @.faila.629, i64 %17, ptr @.failb.630, i64 %arr.len, i32 70)
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
  %values24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values25 = load ptr, ptr %values24, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i26 = load i32, ptr %i, align 4
  %21 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %values25, align 8
  %arr.oob28 = icmp uge i64 %21, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !8

if.end:                                           ; preds = %idx.ok
  %defaultValue34 = load ptr, ptr %defaultValue, align 8
  %strcpy35 = call ptr @__polaron_str_copy(ptr %defaultValue34)
  ret ptr %strcpy35

idx.bad29:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.631, ptr @.faila.632, i64 %21, ptr @.failb.633, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then
  %arr.data31 = getelementptr i8, ptr %values25, i64 8
  %arr.elem32 = getelementptr inbounds ptr, ptr %arr.data31, i64 %21
  %elem33 = load ptr, ptr %arr.elem32, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem33)
  ret ptr %strcpy
}

define internal void @"HashMap$String$String.merge"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2, ptr %3) {
entry:
  %i = alloca i32, align 4
  %combine = alloca ptr, align 8
  %value = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  store ptr %2, ptr %value, align 8
  store ptr %3, ptr %combine, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %4 = icmp sge i32 %count1, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %6 = icmp slt i32 %count3, %cap4
  %7 = zext i1 %6 to i32
  %inv.assume5 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %8 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap8
  %10 = zext i1 %9 to i32
  %inv.assume9 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %11 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap13
  %13 = zext i1 %12 to i32
  %inv.assume14 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %14 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %15 = icmp eq i32 %14, %cap18
  %16 = zext i1 %15 to i32
  %inv.assume19 = icmp ne i32 %16, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %17 = add i32 %count21, 1
  %18 = mul i32 %17, 4
  %cap22 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap23 = load i32, ptr %cap22, align 4, !tbaa !4
  %19 = mul i32 %cap23, 3
  %20 = icmp sge i32 %18, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashMap$String$String.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %key24 = load ptr, ptr %key, align 8
  %22 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key24)
  store i32 %22, ptr %i, align 4
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used26 = load ptr, ptr %used25, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i27 = load i32, ptr %i, align 4
  %23 = sext i32 %i27 to i64
  %arr.len = load i64, ptr %used26, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.634, ptr @.faila.635, i64 %23, ptr @.failb.636, i64 %arr.len, i32 70)
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
  %used30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used31 = load ptr, ptr %used30, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i32 = load i32, ptr %i, align 4
  %27 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %used31, align 8
  %arr.oob34 = icmp uge i64 %27, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !8

if.else:                                          ; preds = %idx.ok
  %values63 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values64 = load ptr, ptr %values63, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i65 = load i32, ptr %i, align 4
  %28 = sext i32 %i65 to i64
  %arr.len66 = load i64, ptr %values64, align 8
  %arr.oob67 = icmp uge i64 %28, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !8

if.end29:                                         ; preds = %idx.ok79, %idx.ok58
  %count85 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count86 = load i32, ptr %count85, align 4, !tbaa !4
  %29 = icmp sge i32 %count86, 0
  %30 = zext i1 %29 to i32
  %contract.ok = icmp ne i32 %30, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.637, ptr @.faila.638, i64 %27, ptr @.failb.639, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %used31, i64 8
  %arr.elem38 = getelementptr inbounds i8, ptr %arr.data37, i64 %27
  store i8 1, ptr %arr.elem38, align 1
  %count39 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count40 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %31 = add i32 %count41, 1
  store i32 %31, ptr %count39, align 4, !tbaa !4
  %keys42 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys43 = load ptr, ptr %keys42, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i44 = load i32, ptr %i, align 4
  %32 = sext i32 %i44 to i64
  %arr.len45 = load i64, ptr %keys43, align 8
  %arr.oob46 = icmp uge i64 %32, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !8

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.640, ptr @.faila.641, i64 %32, ptr @.failb.642, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %keys43, i64 8
  %arr.elem50 = getelementptr inbounds ptr, ptr %arr.data49, i64 %32
  %key51 = load ptr, ptr %key, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %key51)
  %33 = load ptr, ptr %arr.elem50, align 8
  call void @__polaron_str_free(ptr %33)
  store ptr %strcpy, ptr %arr.elem50, align 8
  %values52 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values53 = load ptr, ptr %values52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i54 = load i32, ptr %i, align 4
  %34 = sext i32 %i54 to i64
  %arr.len55 = load i64, ptr %values53, align 8
  %arr.oob56 = icmp uge i64 %34, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.643, ptr @.faila.644, i64 %34, ptr @.failb.645, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok48
  %arr.data59 = getelementptr i8, ptr %values53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %34
  %value61 = load ptr, ptr %value, align 8
  %strcpy62 = call ptr @__polaron_str_copy(ptr %value61)
  %35 = load ptr, ptr %arr.elem60, align 8
  call void @__polaron_str_free(ptr %35)
  store ptr %strcpy62, ptr %arr.elem60, align 8
  br label %if.end29

idx.bad68:                                        ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.646, ptr @.faila.647, i64 %28, ptr @.failb.648, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %if.else
  %arr.data70 = getelementptr i8, ptr %values64, i64 8
  %arr.elem71 = getelementptr inbounds ptr, ptr %arr.data70, i64 %28
  %combine72 = load ptr, ptr %combine, align 8
  %code = load ptr, ptr %combine72, align 8
  %36 = getelementptr ptr, ptr %combine72, i32 1
  %env = load ptr, ptr %36, align 8
  %values73 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values74 = load ptr, ptr %values73, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i75 = load i32, ptr %i, align 4
  %37 = sext i32 %i75 to i64
  %arr.len76 = load i64, ptr %values74, align 8
  %arr.oob77 = icmp uge i64 %37, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !8

idx.bad78:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.649, ptr @.faila.650, i64 %37, ptr @.failb.651, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok69
  %arr.data80 = getelementptr i8, ptr %values74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %37
  %elem82 = load ptr, ptr %arr.elem81, align 8
  %value83 = load ptr, ptr %value, align 8
  %38 = call ptr %code(ptr %env, ptr %elem82, ptr %value83)
  %strcpy84 = call ptr @__polaron_str_copy(ptr %38)
  %39 = load ptr, ptr %arr.elem71, align 8
  call void @__polaron_str_free(ptr %39)
  store ptr %strcpy84, ptr %arr.elem71, align 8
  br label %if.end29

contract.fail:                                    ; preds = %if.end29
  %count87 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count88 = load i32, ptr %count87, align 4, !tbaa !4
  %contract.l = sext i32 %count88 to i64
  call void @__polaron_fail(ptr @.contract.652, ptr @.cl.653, i64 %contract.l, ptr @.cr.654, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end29
  %count89 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count90 = load i32, ptr %count89, align 4, !tbaa !4
  %cap91 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap92 = load i32, ptr %cap91, align 4, !tbaa !4
  %40 = icmp slt i32 %count90, %cap92
  %41 = zext i1 %40 to i32
  %contract.ok93 = icmp ne i32 %41, 0
  br i1 %contract.ok93, label %contract.cont95, label %contract.fail94

contract.fail94:                                  ; preds = %contract.cont
  %count96 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count97 = load i32, ptr %count96, align 4, !tbaa !4
  %cap98 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap99 = load i32, ptr %cap98, align 4, !tbaa !4
  %contract.l100 = sext i32 %count97 to i64
  %contract.r = sext i32 %cap99 to i64
  call void @__polaron_fail(ptr @.contract.655, ptr @.cl.656, i64 %contract.l100, ptr @.cr.657, i64 %contract.r, i32 1)
  unreachable

contract.cont95:                                  ; preds = %contract.cont
  %keys101 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys102 = load ptr, ptr %keys101, align 8, !tbaa !0
  %len103 = load i64, ptr %keys102, align 8
  %42 = trunc i64 %len103 to i32
  %cap104 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap105 = load i32, ptr %cap104, align 4, !tbaa !4
  %43 = icmp eq i32 %42, %cap105
  %44 = zext i1 %43 to i32
  %contract.ok106 = icmp ne i32 %44, 0
  br i1 %contract.ok106, label %contract.cont108, label %contract.fail107

contract.fail107:                                 ; preds = %contract.cont95
  call void @__polaron_fail(ptr @.contract.658, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont108:                                 ; preds = %contract.cont95
  %values109 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values110 = load ptr, ptr %values109, align 8, !tbaa !0
  %len111 = load i64, ptr %values110, align 8
  %45 = trunc i64 %len111 to i32
  %cap112 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap113 = load i32, ptr %cap112, align 4, !tbaa !4
  %46 = icmp eq i32 %45, %cap113
  %47 = zext i1 %46 to i32
  %contract.ok114 = icmp ne i32 %47, 0
  br i1 %contract.ok114, label %contract.cont116, label %contract.fail115

contract.fail115:                                 ; preds = %contract.cont108
  call void @__polaron_fail(ptr @.contract.659, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont116:                                 ; preds = %contract.cont108
  %used117 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used118 = load ptr, ptr %used117, align 8, !tbaa !0
  %len119 = load i64, ptr %used118, align 8
  %48 = trunc i64 %len119 to i32
  %cap120 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap121 = load i32, ptr %cap120, align 4, !tbaa !4
  %49 = icmp eq i32 %48, %cap121
  %50 = zext i1 %49 to i32
  %contract.ok122 = icmp ne i32 %50, 0
  br i1 %contract.ok122, label %contract.cont124, label %contract.fail123

contract.fail123:                                 ; preds = %contract.cont116
  call void @__polaron_fail(ptr @.contract.660, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont124:                                 ; preds = %contract.cont116
  ret void
}

define internal i32 @"HashMap$String$String.remove"(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %rv = alloca ptr, align 8
  %rk = alloca ptr, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %count3, %cap4
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %6 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %7 = icmp eq i32 %6, %cap8
  %8 = zext i1 %7 to i32
  %inv.assume9 = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %9 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %10 = icmp eq i32 %9, %cap13
  %11 = zext i1 %10 to i32
  %inv.assume14 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %12 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %13 = icmp eq i32 %12, %cap18
  %14 = zext i1 %13 to i32
  %inv.assume19 = icmp ne i32 %14, 0
  call void @llvm.assume(i1 %inv.assume19)
  %key20 = load ptr, ptr %key, align 8
  %15 = call i32 @"HashMap$String$String.slotFor"(ptr %0, ptr %key20)
  store i32 %15, ptr %i, align 4
  %used21 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used22 = load ptr, ptr %used21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %16 = sext i32 %i23 to i64
  %arr.len = load i64, ptr %used22, align 8
  %arr.oob = icmp uge i64 %16, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.661, ptr @.faila.662, i64 %16, ptr @.failb.663, i64 %arr.len, i32 70)
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
  %count24 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count25 = load i32, ptr %count24, align 4, !tbaa !4
  %20 = icmp sge i32 %count25, 0
  %21 = zext i1 %20 to i32
  %contract.ok = icmp ne i32 %21, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

if.end:                                           ; preds = %idx.ok
  %cap48 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap49 = load i32, ptr %cap48, align 4, !tbaa !4
  %22 = sub i32 %cap49, 1
  store i32 %22, ptr %mask, align 4
  %used50 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used51 = load ptr, ptr %used50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i52 = load i32, ptr %i, align 4
  %23 = sext i32 %i52 to i64
  %arr.len53 = load i64, ptr %used51, align 8
  %arr.oob54 = icmp uge i64 %23, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

contract.fail:                                    ; preds = %if.then
  %count26 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  %contract.l = sext i32 %count27 to i64
  call void @__polaron_fail(ptr @.contract.664, ptr @.cl.665, i64 %contract.l, ptr @.cr.666, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  %count28 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %cap30 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap31 = load i32, ptr %cap30, align 4, !tbaa !4
  %24 = icmp slt i32 %count29, %cap31
  %25 = zext i1 %24 to i32
  %contract.ok32 = icmp ne i32 %25, 0
  br i1 %contract.ok32, label %contract.cont34, label %contract.fail33

contract.fail33:                                  ; preds = %contract.cont
  %count35 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %cap37 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap38 = load i32, ptr %cap37, align 4, !tbaa !4
  %contract.l39 = sext i32 %count36 to i64
  %contract.r = sext i32 %cap38 to i64
  call void @__polaron_fail(ptr @.contract.667, ptr @.cl.668, i64 %contract.l39, ptr @.cr.669, i64 %contract.r, i32 1)
  unreachable

contract.cont34:                                  ; preds = %contract.cont
  %used40 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used41 = load ptr, ptr %used40, align 8, !tbaa !0
  %len42 = load i64, ptr %used41, align 8
  %26 = trunc i64 %len42 to i32
  %cap43 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap44 = load i32, ptr %cap43, align 4, !tbaa !4
  %27 = icmp eq i32 %26, %cap44
  %28 = zext i1 %27 to i32
  %contract.ok45 = icmp ne i32 %28, 0
  br i1 %contract.ok45, label %contract.cont47, label %contract.fail46

contract.fail46:                                  ; preds = %contract.cont34
  call void @__polaron_fail(ptr @.contract.670, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont47:                                  ; preds = %contract.cont34
  ret i32 0

idx.bad55:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.671, ptr @.faila.672, i64 %23, ptr @.failb.673, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %if.end
  %arr.data57 = getelementptr i8, ptr %used51, i64 8
  %arr.elem58 = getelementptr inbounds i8, ptr %arr.data57, i64 %23
  store i8 0, ptr %arr.elem58, align 1
  %count59 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count60 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count61 = load i32, ptr %count60, align 4, !tbaa !4
  %29 = sub i32 %count61, 1
  store i32 %29, ptr %count59, align 4, !tbaa !4
  %i62 = load i32, ptr %i, align 4
  %30 = add i32 %i62, 1
  %mask63 = load i32, ptr %mask, align 4
  %31 = and i32 %30, %mask63
  store i32 %31, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok101, %idx.ok56
  %used64 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used65 = load ptr, ptr %used64, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j66 = load i32, ptr %j, align 4
  %32 = sext i32 %j66 to i64
  %arr.len67 = load i64, ptr %used65, align 8
  %arr.oob68 = icmp uge i64 %32, %arr.len67
  br i1 %arr.oob68, label %idx.bad69, label %idx.ok70, !prof !8

while.body:                                       ; preds = %idx.ok70
  %keys74 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys75 = load ptr, ptr %keys74, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j76 = load i32, ptr %j, align 4
  %33 = sext i32 %j76 to i64
  %arr.len77 = load i64, ptr %keys75, align 8
  %arr.oob78 = icmp uge i64 %33, %arr.len77
  br i1 %arr.oob78, label %idx.bad79, label %idx.ok80, !prof !8

while.end:                                        ; preds = %idx.ok70
  %count111 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count112 = load i32, ptr %count111, align 4, !tbaa !4
  %34 = icmp sge i32 %count112, 0
  %35 = zext i1 %34 to i32
  %contract.ok113 = icmp ne i32 %35, 0
  br i1 %contract.ok113, label %contract.cont115, label %contract.fail114

idx.bad69:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.674, ptr @.faila.675, i64 %32, ptr @.failb.676, i64 %arr.len67, i32 70)
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
  call void @__polaron_fail(ptr @.fail.677, ptr @.faila.678, i64 %33, ptr @.failb.679, i64 %arr.len77, i32 70)
  unreachable

idx.ok80:                                         ; preds = %while.body
  %arr.data81 = getelementptr i8, ptr %keys75, i64 8
  %arr.elem82 = getelementptr inbounds ptr, ptr %arr.data81, i64 %33
  %elem83 = load ptr, ptr %arr.elem82, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem83)
  store ptr %strcpy, ptr %rk, align 8
  %values84 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values85 = load ptr, ptr %values84, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j86 = load i32, ptr %j, align 4
  %39 = sext i32 %j86 to i64
  %arr.len87 = load i64, ptr %values85, align 8
  %arr.oob88 = icmp uge i64 %39, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !8

idx.bad89:                                        ; preds = %idx.ok80
  call void @__polaron_fail(ptr @.fail.680, ptr @.faila.681, i64 %39, ptr @.failb.682, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok80
  %arr.data91 = getelementptr i8, ptr %values85, i64 8
  %arr.elem92 = getelementptr inbounds ptr, ptr %arr.data91, i64 %39
  %elem93 = load ptr, ptr %arr.elem92, align 8
  %strcpy94 = call ptr @__polaron_str_copy(ptr %elem93)
  store ptr %strcpy94, ptr %rv, align 8
  %used95 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used96 = load ptr, ptr %used95, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j97 = load i32, ptr %j, align 4
  %40 = sext i32 %j97 to i64
  %arr.len98 = load i64, ptr %used96, align 8
  %arr.oob99 = icmp uge i64 %40, %arr.len98
  br i1 %arr.oob99, label %idx.bad100, label %idx.ok101, !prof !8

idx.bad100:                                       ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.683, ptr @.faila.684, i64 %40, ptr @.failb.685, i64 %arr.len98, i32 70)
  unreachable

idx.ok101:                                        ; preds = %idx.ok90
  %arr.data102 = getelementptr i8, ptr %used96, i64 8
  %arr.elem103 = getelementptr inbounds i8, ptr %arr.data102, i64 %40
  store i8 0, ptr %arr.elem103, align 1
  %count104 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count105 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count106 = load i32, ptr %count105, align 4, !tbaa !4
  %41 = sub i32 %count106, 1
  store i32 %41, ptr %count104, align 4, !tbaa !4
  %rk107 = load ptr, ptr %rk, align 8
  %rv108 = load ptr, ptr %rv, align 8
  call void @"HashMap$String$String.put"(ptr %0, ptr %rk107, ptr %rv108)
  %j109 = load i32, ptr %j, align 4
  %42 = add i32 %j109, 1
  %mask110 = load i32, ptr %mask, align 4
  %43 = and i32 %42, %mask110
  store i32 %43, ptr %j, align 4
  %44 = load ptr, ptr %rv, align 8
  call void @__polaron_str_free(ptr %44)
  %45 = load ptr, ptr %rk, align 8
  call void @__polaron_str_free(ptr %45)
  br label %while.cond

contract.fail114:                                 ; preds = %while.end
  %count116 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count117 = load i32, ptr %count116, align 4, !tbaa !4
  %contract.l118 = sext i32 %count117 to i64
  call void @__polaron_fail(ptr @.contract.686, ptr @.cl.687, i64 %contract.l118, ptr @.cr.688, i64 0, i32 1)
  unreachable

contract.cont115:                                 ; preds = %while.end
  %count119 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count120 = load i32, ptr %count119, align 4, !tbaa !4
  %cap121 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap122 = load i32, ptr %cap121, align 4, !tbaa !4
  %46 = icmp slt i32 %count120, %cap122
  %47 = zext i1 %46 to i32
  %contract.ok123 = icmp ne i32 %47, 0
  br i1 %contract.ok123, label %contract.cont125, label %contract.fail124

contract.fail124:                                 ; preds = %contract.cont115
  %count126 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count127 = load i32, ptr %count126, align 4, !tbaa !4
  %cap128 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap129 = load i32, ptr %cap128, align 4, !tbaa !4
  %contract.l130 = sext i32 %count127 to i64
  %contract.r131 = sext i32 %cap129 to i64
  call void @__polaron_fail(ptr @.contract.689, ptr @.cl.690, i64 %contract.l130, ptr @.cr.691, i64 %contract.r131, i32 1)
  unreachable

contract.cont125:                                 ; preds = %contract.cont115
  %used132 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used133 = load ptr, ptr %used132, align 8, !tbaa !0
  %len134 = load i64, ptr %used133, align 8
  %48 = trunc i64 %len134 to i32
  %cap135 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap136 = load i32, ptr %cap135, align 4, !tbaa !4
  %49 = icmp eq i32 %48, %cap136
  %50 = zext i1 %49 to i32
  %contract.ok137 = icmp ne i32 %50, 0
  br i1 %contract.ok137, label %contract.cont139, label %contract.fail138

contract.fail138:                                 ; preds = %contract.cont125
  call void @__polaron_fail(ptr @.contract.692, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont139:                                 ; preds = %contract.cont125
  ret i32 1
}

define internal ptr @"HashMap$String$String.keyArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.693, ptr @.faila.694, i64 %20, ptr @.failb.695, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.696, ptr @.faila.697, i64 %26, ptr @.failb.698, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 %26
  %keys37 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys38 = load ptr, ptr %keys37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %keys38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.699, ptr @.faila.700, i64 %27, ptr @.failb.701, i64 %arr.len40, i32 70)
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

define internal ptr @"HashMap$String$String.valueArray"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
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
  %cap23 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap24 = load i32, ptr %cap23, align 4, !tbaa !4
  %18 = icmp slt i32 %i22, %cap24
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used25 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
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
  call void @__polaron_fail(ptr @.fail.702, ptr @.faila.703, i64 %20, ptr @.failb.704, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.705, ptr @.faila.706, i64 %26, ptr @.failb.707, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %if.then
  %arr.data35 = getelementptr i8, ptr %out29, i64 8
  %arr.elem36 = getelementptr inbounds ptr, ptr %arr.data35, i64 %26
  %values37 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values38 = load ptr, ptr %values37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i39 = load i32, ptr %i, align 4
  %27 = sext i32 %i39 to i64
  %arr.len40 = load i64, ptr %values38, align 8
  %arr.oob41 = icmp uge i64 %27, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.708, ptr @.faila.709, i64 %27, ptr @.failb.710, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok34
  %arr.data44 = getelementptr i8, ptr %values38, i64 8
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

define internal i32 @"HashMap$String$String.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  ret i32 %count21
}

define internal i32 @"HashMap$String$String.isEmpty"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp slt i32 %count3, %cap4
  %4 = zext i1 %3 to i32
  %inv.assume5 = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume5)
  %keys = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 1
  %keys6 = load ptr, ptr %keys, align 8, !tbaa !0
  %len = load i64, ptr %keys6, align 8
  %5 = trunc i64 %len to i32
  %cap7 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %6 = icmp eq i32 %5, %cap8
  %7 = zext i1 %6 to i32
  %inv.assume9 = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume9)
  %values = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 2
  %values10 = load ptr, ptr %values, align 8, !tbaa !0
  %len11 = load i64, ptr %values10, align 8
  %8 = trunc i64 %len11 to i32
  %cap12 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap13 = load i32, ptr %cap12, align 4, !tbaa !4
  %9 = icmp eq i32 %8, %cap13
  %10 = zext i1 %9 to i32
  %inv.assume14 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume14)
  %used = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 3
  %used15 = load ptr, ptr %used, align 8, !tbaa !0
  %len16 = load i64, ptr %used15, align 8
  %11 = trunc i64 %len16 to i32
  %cap17 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 5
  %cap18 = load i32, ptr %cap17, align 4, !tbaa !4
  %12 = icmp eq i32 %11, %cap18
  %13 = zext i1 %12 to i32
  %inv.assume19 = icmp ne i32 %13, 0
  call void @llvm.assume(i1 %inv.assume19)
  %count20 = getelementptr inbounds %"class.HashMap$String$String", ptr %0, i32 0, i32 4
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @StateMachine.StateMachine(ptr %0, ptr %1) {
entry:
  %initial = alloca ptr, align 8
  store ptr %1, ptr %initial, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 0
  store ptr @StateMachine.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %transitions = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 1
  store ptr null, ptr %transitions, align 8, !tbaa !0
  %current = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 2
  store ptr null, ptr %current, align 8, !tbaa !0
  %transitions1 = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 1
  %"HashMap$String$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashMap$String$String", ptr null, i64 1) to i64))
  call void @"HashMap$String$String.HashMap$String$String"(ptr %"HashMap$String$String.obj")
  store ptr %"HashMap$String$String.obj", ptr %transitions1, align 8, !tbaa !0
  %current2 = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 2
  %initial3 = load ptr, ptr %initial, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %initial3)
  %2 = load ptr, ptr %current2, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %current2, align 8, !tbaa !0
  ret void
}

define internal void @StateMachine.addTransition(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, ptr %2, ptr %3) {
entry:
  %to = alloca ptr, align 8
  %event = alloca ptr, align 8
  %from = alloca ptr, align 8
  store ptr %1, ptr %from, align 8
  store ptr %2, ptr %event, align 8
  store ptr %3, ptr %to, align 8
  %transitions = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 1
  %transitions1 = load ptr, ptr %transitions, align 8, !tbaa !0
  %from2 = load ptr, ptr %from, align 8
  %str.len = getelementptr inbounds %String, ptr %from2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len3 = load i64, ptr @.strobj.2588, align 8
  %4 = add i64 %len, %len3
  %5 = add i64 %4, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %5)
  %str.data = getelementptr inbounds %String, ptr %from2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %6 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data4 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2588, i32 0, i32 1), align 8
  %7 = getelementptr i8, ptr %cat.buf, i64 %len
  %8 = call ptr @memcpy(ptr %7, ptr %data4, i64 %len3)
  %9 = getelementptr i8, ptr %cat.buf, i64 %4
  store i8 0, ptr %9, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %4, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %11, align 8
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %12, align 8
  %event5 = load ptr, ptr %event, align 8
  %str.len6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %str.len8 = getelementptr inbounds %String, ptr %event5, i32 0, i32 0
  %len9 = load i64, ptr %str.len8, align 8
  %13 = add i64 %len7, %len9
  %14 = add i64 %13, 1
  %cat.buf10 = call ptr @__polaron_malloc(i64 %14)
  %str.data11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %15 = call ptr @memcpy(ptr %cat.buf10, ptr %data12, i64 %len7)
  %str.data13 = getelementptr inbounds %String, ptr %event5, i32 0, i32 1
  %data14 = load ptr, ptr %str.data13, align 8
  %16 = getelementptr i8, ptr %cat.buf10, i64 %len7
  %17 = call ptr @memcpy(ptr %16, ptr %data14, i64 %len9)
  %18 = getelementptr i8, ptr %cat.buf10, i64 %13
  store i8 0, ptr %18, align 1
  %newstr15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %19 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 0
  store i64 %13, ptr %19, align 8
  %20 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 1
  store ptr %cat.buf10, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr15, i32 0, i32 2
  store i64 0, ptr %21, align 8
  %to16 = load ptr, ptr %to, align 8
  call void @"HashMap$String$String.put"(ptr %transitions1, ptr %newstr15, ptr %to16)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr15)
  ret void
}

define internal i32 @StateMachine.fire(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  %event = alloca ptr, align 8
  store ptr %1, ptr %event, align 8
  %current = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 2
  %current1 = load ptr, ptr %current, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %current1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len2 = load i64, ptr @.strobj.2590, align 8
  %2 = add i64 %len, %len2
  %3 = add i64 %2, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %3)
  %str.data = getelementptr inbounds %String, ptr %current1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %4 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data3 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2590, i32 0, i32 1), align 8
  %5 = getelementptr i8, ptr %cat.buf, i64 %len
  %6 = call ptr @memcpy(ptr %5, ptr %data3, i64 %len2)
  %7 = getelementptr i8, ptr %cat.buf, i64 %2
  store i8 0, ptr %7, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %2, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %9, align 8
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %10, align 8
  %event4 = load ptr, ptr %event, align 8
  %str.len5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %str.len7 = getelementptr inbounds %String, ptr %event4, i32 0, i32 0
  %len8 = load i64, ptr %str.len7, align 8
  %11 = add i64 %len6, %len8
  %12 = add i64 %11, 1
  %cat.buf9 = call ptr @__polaron_malloc(i64 %12)
  %str.data10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  %data11 = load ptr, ptr %str.data10, align 8
  %13 = call ptr @memcpy(ptr %cat.buf9, ptr %data11, i64 %len6)
  %str.data12 = getelementptr inbounds %String, ptr %event4, i32 0, i32 1
  %data13 = load ptr, ptr %str.data12, align 8
  %14 = getelementptr i8, ptr %cat.buf9, i64 %len6
  %15 = call ptr @memcpy(ptr %14, ptr %data13, i64 %len8)
  %16 = getelementptr i8, ptr %cat.buf9, i64 %11
  store i8 0, ptr %16, align 1
  %newstr14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 0
  store i64 %11, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 1
  store ptr %cat.buf9, ptr %18, align 8
  %19 = getelementptr inbounds %String, ptr %newstr14, i32 0, i32 2
  store i64 0, ptr %19, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr14)
  store ptr %strcpy, ptr %key, align 8
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr14)
  %transitions = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 1
  %transitions15 = load ptr, ptr %transitions, align 8, !tbaa !0
  %key16 = load ptr, ptr %key, align 8
  %20 = call i32 @"HashMap$String$String.containsKey"(ptr %transitions15, ptr %key16)
  %21 = icmp ne i32 %20, 0
  br i1 %21, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %current17 = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 2
  %transitions18 = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 1
  %transitions19 = load ptr, ptr %transitions18, align 8, !tbaa !0
  %key20 = load ptr, ptr %key, align 8
  %22 = call ptr @"HashMap$String$String.get"(ptr %transitions19, ptr %key20)
  %strcpy21 = call ptr @__polaron_str_copy(ptr %22)
  %23 = load ptr, ptr %current17, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %23)
  store ptr %strcpy21, ptr %current17, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %22)
  %24 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %24)
  ret i32 1

if.end:                                           ; preds = %entry
  %25 = load ptr, ptr %key, align 8
  call void @__polaron_str_free(ptr %25)
  ret i32 0
}

define internal ptr @StateMachine.state(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %current = getelementptr inbounds %class.StateMachine, ptr %0, i32 0, i32 2
  %current1 = load ptr, ptr %current, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %current1)
  ret ptr %strcpy
}

define internal i32 @Glob.matches(ptr %0, ptr %1) {
entry:
  %mark = alloca i32, align 4
  %star = alloca i32, align 4
  %t = alloca i32, align 4
  %p = alloca i32, align 4
  %tn = alloca i32, align 4
  %pn = alloca i32, align 4
  %text = alloca ptr, align 8
  %pattern = alloca ptr, align 8
  store ptr %0, ptr %pattern, align 8
  store ptr %1, ptr %text, align 8
  %pattern1 = load ptr, ptr %pattern, align 8
  %str.len = getelementptr inbounds %String, ptr %pattern1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %pn, align 4
  %text2 = load ptr, ptr %text, align 8
  %str.len3 = getelementptr inbounds %String, ptr %text2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %tn, align 4
  store i32 0, ptr %p, align 4
  store i32 0, ptr %t, align 4
  store i32 -1, ptr %star, align 4
  store i32 0, ptr %mark, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %t5 = load i32, ptr %t, align 4
  %tn6 = load i32, ptr %tn, align 4
  %4 = icmp slt i32 %t5, %tn6
  %5 = zext i1 %4 to i32
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %p7 = load i32, ptr %p, align 4
  %pn8 = load i32, ptr %pn, align 4
  %6 = icmp slt i32 %p7, %pn8
  %7 = zext i1 %6 to i32
  %sc.a = icmp ne i32 %7, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.end:                                        ; preds = %while.cond
  br label %while.cond56

sc.rhs:                                           ; preds = %while.body
  %pattern9 = load ptr, ptr %pattern, align 8
  %p10 = load i32, ptr %p, align 4
  %8 = sext i32 %p10 to i64
  %str.data = getelementptr inbounds %String, ptr %pattern9, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %8
  %ch = load i8, ptr %ch.addr, align 1
  %9 = zext i8 %ch to i32
  %10 = icmp eq i32 %9, 63
  %11 = zext i1 %10 to i32
  %sc.a11 = icmp ne i32 %11, 0
  br i1 %sc.a11, label %sc.end13, label %sc.rhs12

sc.end:                                           ; preds = %sc.end13, %while.body
  %sc27 = phi i1 [ false, %while.body ], [ %sc.b26, %sc.end13 ]
  %12 = zext i1 %sc27 to i32
  br i1 %sc27, label %if.then, label %if.else

sc.rhs12:                                         ; preds = %sc.rhs
  %pattern14 = load ptr, ptr %pattern, align 8
  %p15 = load i32, ptr %p, align 4
  %13 = sext i32 %p15 to i64
  %str.data16 = getelementptr inbounds %String, ptr %pattern14, i32 0, i32 1
  %data17 = load ptr, ptr %str.data16, align 8
  %ch.addr18 = getelementptr i8, ptr %data17, i64 %13
  %ch19 = load i8, ptr %ch.addr18, align 1
  %14 = zext i8 %ch19 to i32
  %text20 = load ptr, ptr %text, align 8
  %t21 = load i32, ptr %t, align 4
  %15 = sext i32 %t21 to i64
  %str.data22 = getelementptr inbounds %String, ptr %text20, i32 0, i32 1
  %data23 = load ptr, ptr %str.data22, align 8
  %ch.addr24 = getelementptr i8, ptr %data23, i64 %15
  %ch25 = load i8, ptr %ch.addr24, align 1
  %16 = zext i8 %ch25 to i32
  %17 = icmp eq i32 %14, %16
  %18 = zext i1 %17 to i32
  %sc.b = icmp ne i32 %18, 0
  br label %sc.end13

sc.end13:                                         ; preds = %sc.rhs12, %sc.rhs
  %sc = phi i1 [ true, %sc.rhs ], [ %sc.b, %sc.rhs12 ]
  %19 = zext i1 %sc to i32
  %sc.b26 = icmp ne i32 %19, 0
  br label %sc.end

if.then:                                          ; preds = %sc.end
  %p28 = load i32, ptr %p, align 4
  %20 = add i32 %p28, 1
  store i32 %20, ptr %p, align 4
  %t29 = load i32, ptr %t, align 4
  %21 = add i32 %t29, 1
  store i32 %21, ptr %t, align 4
  br label %if.end

if.else:                                          ; preds = %sc.end
  %p30 = load i32, ptr %p, align 4
  %pn31 = load i32, ptr %pn, align 4
  %22 = icmp slt i32 %p30, %pn31
  %23 = zext i1 %22 to i32
  %sc.a32 = icmp ne i32 %23, 0
  br i1 %sc.a32, label %sc.rhs33, label %sc.end34

if.end:                                           ; preds = %if.end45, %if.then
  br label %while.cond

sc.rhs33:                                         ; preds = %if.else
  %pattern35 = load ptr, ptr %pattern, align 8
  %p36 = load i32, ptr %p, align 4
  %24 = sext i32 %p36 to i64
  %str.data37 = getelementptr inbounds %String, ptr %pattern35, i32 0, i32 1
  %data38 = load ptr, ptr %str.data37, align 8
  %ch.addr39 = getelementptr i8, ptr %data38, i64 %24
  %ch40 = load i8, ptr %ch.addr39, align 1
  %25 = zext i8 %ch40 to i32
  %26 = icmp eq i32 %25, 42
  %27 = zext i1 %26 to i32
  %sc.b41 = icmp ne i32 %27, 0
  br label %sc.end34

sc.end34:                                         ; preds = %sc.rhs33, %if.else
  %sc42 = phi i1 [ false, %if.else ], [ %sc.b41, %sc.rhs33 ]
  %28 = zext i1 %sc42 to i32
  br i1 %sc42, label %if.then43, label %if.else44

if.then43:                                        ; preds = %sc.end34
  %p46 = load i32, ptr %p, align 4
  store i32 %p46, ptr %star, align 4
  %t47 = load i32, ptr %t, align 4
  store i32 %t47, ptr %mark, align 4
  %p48 = load i32, ptr %p, align 4
  %29 = add i32 %p48, 1
  store i32 %29, ptr %p, align 4
  br label %if.end45

if.else44:                                        ; preds = %sc.end34
  %star49 = load i32, ptr %star, align 4
  %30 = icmp ne i32 %star49, -1
  %31 = zext i1 %30 to i32
  br i1 %30, label %if.then50, label %if.else51

if.end45:                                         ; preds = %if.end52, %if.then43
  br label %if.end

if.then50:                                        ; preds = %if.else44
  %star53 = load i32, ptr %star, align 4
  %32 = add i32 %star53, 1
  store i32 %32, ptr %p, align 4
  %mark54 = load i32, ptr %mark, align 4
  %33 = add i32 %mark54, 1
  store i32 %33, ptr %mark, align 4
  %mark55 = load i32, ptr %mark, align 4
  store i32 %mark55, ptr %t, align 4
  br label %if.end52

if.else51:                                        ; preds = %if.else44
  ret i32 0

if.end52:                                         ; preds = %if.then50
  br label %if.end45

while.cond56:                                     ; preds = %while.body57, %while.end
  %p59 = load i32, ptr %p, align 4
  %pn60 = load i32, ptr %pn, align 4
  %34 = icmp slt i32 %p59, %pn60
  %35 = zext i1 %34 to i32
  %sc.a61 = icmp ne i32 %35, 0
  br i1 %sc.a61, label %sc.rhs62, label %sc.end63

while.body57:                                     ; preds = %sc.end63
  %p72 = load i32, ptr %p, align 4
  %36 = add i32 %p72, 1
  store i32 %36, ptr %p, align 4
  br label %while.cond56

while.end58:                                      ; preds = %sc.end63
  %p73 = load i32, ptr %p, align 4
  %pn74 = load i32, ptr %pn, align 4
  %37 = icmp eq i32 %p73, %pn74
  %38 = zext i1 %37 to i32
  ret i32 %38

sc.rhs62:                                         ; preds = %while.cond56
  %pattern64 = load ptr, ptr %pattern, align 8
  %p65 = load i32, ptr %p, align 4
  %39 = sext i32 %p65 to i64
  %str.data66 = getelementptr inbounds %String, ptr %pattern64, i32 0, i32 1
  %data67 = load ptr, ptr %str.data66, align 8
  %ch.addr68 = getelementptr i8, ptr %data67, i64 %39
  %ch69 = load i8, ptr %ch.addr68, align 1
  %40 = zext i8 %ch69 to i32
  %41 = icmp eq i32 %40, 42
  %42 = zext i1 %41 to i32
  %sc.b70 = icmp ne i32 %42, 0
  br label %sc.end63

sc.end63:                                         ; preds = %sc.rhs62, %while.cond56
  %sc71 = phi i1 [ false, %while.cond56 ], [ %sc.b70, %sc.rhs62 ]
  %43 = zext i1 %sc71 to i32
  br i1 %sc71, label %while.body57, label %while.end58
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5347)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5349)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @__polaron_str_hash_obj(ptr)

declare i32 @strcmp(ptr, ptr)

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
