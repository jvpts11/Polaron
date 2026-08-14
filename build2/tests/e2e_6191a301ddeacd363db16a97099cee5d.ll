; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/value_copy_string_field.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/value_copy_string_field.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Snap = type { ptr, ptr, i32 }
%"class.ArrayList$Snap" = type { ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$Snap" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Snap.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$Snap.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$Snap.toArray", ptr @"ArrayList$Snap.size", ptr @"ArrayList$Snap.isEmpty", ptr null, ptr null, ptr null, ptr @"ArrayList$Snap.get", ptr null, ptr null, ptr null, ptr @"ArrayList$Snap.remove", ptr null, ptr null, ptr @"ArrayList$Snap.add", ptr @"ArrayList$Snap.ensureCapacity", ptr @"ArrayList$Snap.set", ptr @"ArrayList$Snap.indexOf", ptr @"ArrayList$Snap.contains", ptr @"ArrayList$Snap.removeAt", ptr @"ArrayList$Snap.insertAt", ptr @"ArrayList$Snap.clear", ptr @"ArrayList$Snap.forEach", ptr @"ArrayList$Snap.filter", ptr @"ArrayList$Snap.any", ptr @"ArrayList$Snap.all", ptr @"ArrayList$Snap.count", ptr @"ArrayList$Snap.sortedBy", ptr @"ArrayList$Snap.mergeSortRange", ptr @"ArrayList$Snap.find", ptr @"ArrayList$Snap.min", ptr @"ArrayList$Snap.max", ptr @"ArrayList$Snap.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$Snap.~ArrayList$Snap"]
@"ArrayListIterator$Snap.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$Snap.hasNext", ptr @"ArrayListIterator$Snap.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [15 x i8] c"snapshot body \00"
@.strobj = private global %String { i64 14, ptr @.strdata, i64 0 }
@.str = private unnamed_addr constant [28 x i8] c"count=%d total=%d first=%s \00", align 1
@.strdata.1 = private constant [12 x i8] c"independent\00"
@.strobj.2 = private global %String { i64 11, ptr @.strdata.1, i64 0 }
@.str.3 = private unnamed_addr constant [21 x i8] c"copy=%s/%s survived\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.contract.1299 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.ArrayList$Snap\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1300 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1301 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1302 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.ArrayList$Snap\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1303 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Snap.add\0A\00", align 1
@.faila.1304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1306 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Snap.add\0A\00", align 1
@.faila.1307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1309 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$Snap.add\0A\00", align 1
@.faila.1310 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1311 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1312 = private unnamed_addr constant [122 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$Snap.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1313 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1314 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1315 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1316 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1317 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Snap.ensureCapacity\0A\00", align 1
@.faila.1318 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1319 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1320 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Snap.ensureCapacity\0A\00", align 1
@.faila.1321 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1322 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1323 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1324 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1325 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1326 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1327 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$Snap.get\0A\00", align 1
@.faila.1328 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1329 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1330 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$Snap.get\0A\00", align 1
@.faila.1331 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1332 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1333 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$Snap.set\0A\00", align 1
@.faila.1334 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1335 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1336 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1337 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$Snap.set\0A\00", align 1
@.faila.1338 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1339 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1340 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1341 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$Snap.indexOf\0A\00", align 1
@.faila.1342 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1343 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1344 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$Snap.removeAt\0A\00", align 1
@.faila.1345 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1346 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1347 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1348 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1349 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1350 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1351 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Snap.removeAt\0A\00", align 1
@.faila.1352 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1353 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1354 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Snap.removeAt\0A\00", align 1
@.faila.1355 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1356 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1357 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1358 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1359 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1360 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1361 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$Snap.insertAt\0A\00", align 1
@.faila.1362 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1363 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1364 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1365 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1366 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1367 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1368 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Snap.insertAt\0A\00", align 1
@.faila.1369 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1370 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1371 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Snap.insertAt\0A\00", align 1
@.faila.1372 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1373 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1374 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Snap.insertAt\0A\00", align 1
@.faila.1375 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1376 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1377 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Snap.insertAt\0A\00", align 1
@.faila.1378 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1379 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1380 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$Snap.insertAt\0A\00", align 1
@.faila.1381 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1382 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1383 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1384 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1385 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1386 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1387 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1388 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1389 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1390 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1391 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Snap.toArray\0A\00", align 1
@.faila.1392 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1393 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1394 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Snap.toArray\0A\00", align 1
@.faila.1395 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1396 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1397 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$Snap.forEach\0A\00", align 1
@.faila.1398 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1399 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1400 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$Snap.filter\0A\00", align 1
@.faila.1401 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1402 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1403 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$Snap.filter\0A\00", align 1
@.faila.1404 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1405 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1406 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$Snap.any\0A\00", align 1
@.faila.1407 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1408 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1409 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$Snap.all\0A\00", align 1
@.faila.1410 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1411 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1412 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$Snap.count\0A\00", align 1
@.faila.1413 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1414 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1415 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$Snap.sortedBy\0A\00", align 1
@.faila.1416 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1417 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1418 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Snap.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1419 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1420 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1421 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1422 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1423 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1424 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1425 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1426 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1427 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1428 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1429 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1430 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1431 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1432 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1433 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1434 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1435 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1436 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1437 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1438 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1439 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1440 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1441 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1442 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1443 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1444 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1445 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1446 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1447 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1448 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1449 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1450 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1451 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1452 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1453 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1454 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1455 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1456 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1457 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1458 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1459 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1460 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1461 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1462 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1463 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1464 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1465 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1466 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1467 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1468 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1469 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1470 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1471 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1472 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1473 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1474 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1475 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1476 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1477 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1478 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1479 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Snap.mergeSortRange\0A\00", align 1
@.faila.1480 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1481 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1482 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Snap.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1483 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$Snap.find\0A\00", align 1
@.faila.1484 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1485 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1486 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$Snap.find\0A\00", align 1
@.faila.1487 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1488 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1489 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$Snap.min\0A\00", align 1
@.faila.1490 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1491 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1492 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$Snap.min\0A\00", align 1
@.faila.1493 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1494 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1495 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$Snap.min\0A\00", align 1
@.faila.1496 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1497 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1498 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$Snap.max\0A\00", align 1
@.faila.1499 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1500 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1501 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$Snap.max\0A\00", align 1
@.faila.1502 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1503 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1504 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$Snap.max\0A\00", align 1
@.faila.1505 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1506 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1517 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1518 = private global %String { i64 16, ptr @.strdata.1517, i64 0 }
@.strdata.1519 = private constant [17 x i8] c"division by zero\00"
@.strobj.1520 = private global %String { i64 16, ptr @.strdata.1519, i64 0 }
@.strdata.5518 = private constant [1 x i8] zeroinitializer
@.strobj.5519 = private global %String { i64 0, ptr @.strdata.5518, i64 0 }
@.strdata.5520 = private constant [1 x i8] zeroinitializer
@.strobj.5521 = private global %String { i64 0, ptr @.strdata.5520, i64 0 }

define internal void @Snap.Snap(ptr %0, ptr %1, i32 %2) {
entry:
  %r = alloca i32, align 4
  %t = alloca ptr, align 8
  store ptr %1, ptr %t, align 8
  store i32 %2, ptr %r, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %0, i32 0, i32 0
  store ptr @Snap.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %text = getelementptr inbounds %class.Snap, ptr %0, i32 0, i32 1
  store ptr null, ptr %text, align 8, !tbaa !0
  %text1 = getelementptr inbounds %class.Snap, ptr %0, i32 0, i32 1
  %t2 = load ptr, ptr %t, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %t2)
  %3 = load ptr, ptr %text1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %text1, align 8, !tbaa !0
  %row = getelementptr inbounds %class.Snap, ptr %0, i32 0, i32 2
  %r3 = load i32, ptr %r, align 4
  store i32 %r3, ptr %row, align 4, !tbaa !4
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %b = alloca ptr, align 8
  %Snap.copy = alloca %class.Snap, align 8
  %a = alloca ptr, align 8
  %Snap.obj36 = alloca %class.Snap, align 8
  %k = alloca i32, align 4
  %total = alloca i32, align 4
  %i = alloca i32, align 4
  %snaps = alloca ptr, align 8
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
  %"ArrayList$Snap.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Snap", ptr null, i64 1) to i64))
  call void @"ArrayList$Snap.ArrayList$Snap"(ptr %"ArrayList$Snap.obj")
  store ptr %"ArrayList$Snap.obj", ptr %snaps, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %dtor.free, %argv.end
  %i1 = load i32, ptr %i, align 4
  %16 = icmp slt i32 %i1, 5
  %17 = zext i1 %16 to i32
  br i1 %16, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %snaps2 = load ptr, ptr %snaps, align 8
  %Snap.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %i3 = load i32, ptr %i, align 4
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %18 = sext i32 %i3 to i64
  %19 = call i64 @__polaron_itoa(i64 %18, ptr %itoa.buf)
  %newstr4 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %20 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  store i64 %19, ptr %20, align 8
  %21 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  store ptr %itoa.buf, ptr %21, align 8
  %22 = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 2
  store i64 0, ptr %22, align 8
  %len = load i64, ptr @.strobj, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 0
  %len5 = load i64, ptr %str.len, align 8
  %23 = add i64 %len, %len5
  %24 = add i64 %23, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %24)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj, i32 0, i32 1), align 8
  %25 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %newstr4, i32 0, i32 1
  %data6 = load ptr, ptr %str.data, align 8
  %26 = getelementptr i8, ptr %cat.buf, i64 %len
  %27 = call ptr @memcpy(ptr %26, ptr %data6, i64 %len5)
  %28 = getelementptr i8, ptr %cat.buf, i64 %23
  store i8 0, ptr %28, align 1
  %newstr7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %29 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 0
  store i64 %23, ptr %29, align 8
  %30 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 1
  store ptr %cat.buf, ptr %30, align 8
  %31 = getelementptr inbounds %String, ptr %newstr7, i32 0, i32 2
  store i64 0, ptr %31, align 8
  %i8 = load i32, ptr %i, align 4
  call void @Snap.Snap(ptr %Snap.obj, ptr %newstr7, i32 %i8)
  call void @"ArrayList$Snap.add"(ptr %snaps2, ptr %Snap.obj)
  call void @__polaron_check_live(ptr %Snap.obj)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %Snap.obj, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %32 = icmp ne ptr %dtor.fn, null
  br i1 %32, label %dtor.call, label %dtor.free

while.end:                                        ; preds = %while.cond
  store i32 0, ptr %total, align 4
  store i32 0, ptr %k, align 4
  br label %while.cond10

dtor.call:                                        ; preds = %while.body
  call void %dtor.fn(ptr %Snap.obj)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %while.body
  %text.sfree = getelementptr inbounds %class.Snap, ptr %Snap.obj, i32 0, i32 1
  %33 = load ptr, ptr %text.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %33)
  call void @__polaron_free(ptr %Snap.obj)
  %i9 = load i32, ptr %i, align 4
  %34 = add i32 %i9, 1
  store i32 %34, ptr %i, align 4
  br label %while.cond

while.cond10:                                     ; preds = %while.body11, %while.end
  %k13 = load i32, ptr %k, align 4
  %snaps14 = load ptr, ptr %snaps, align 8
  %35 = call i32 @"ArrayList$Snap.size"(ptr %snaps14)
  %36 = icmp slt i32 %k13, %35
  %37 = zext i1 %36 to i32
  br i1 %36, label %while.body11, label %while.end12

while.body11:                                     ; preds = %while.cond10
  %total15 = load i32, ptr %total, align 4
  %snaps16 = load ptr, ptr %snaps, align 8
  %k17 = load i32, ptr %k, align 4
  %38 = call ptr @"ArrayList$Snap.get"(ptr %snaps16, i32 %k17)
  %text = getelementptr inbounds %class.Snap, ptr %38, i32 0, i32 1
  %text18 = load ptr, ptr %text, align 8, !tbaa !0
  %str.len19 = getelementptr inbounds %String, ptr %text18, i32 0, i32 0
  %len20 = load i64, ptr %str.len19, align 8
  %39 = trunc i64 %len20 to i32
  %40 = add i32 %total15, %39
  store i32 %40, ptr %total, align 4
  %k21 = load i32, ptr %k, align 4
  %41 = add i32 %k21, 1
  store i32 %41, ptr %k, align 4
  br label %while.cond10

while.end12:                                      ; preds = %while.cond10
  %snaps22 = load ptr, ptr %snaps, align 8
  %42 = call i32 @"ArrayList$Snap.size"(ptr %snaps22)
  %total23 = load i32, ptr %total, align 4
  %snaps24 = load ptr, ptr %snaps, align 8
  %43 = call ptr @"ArrayList$Snap.get"(ptr %snaps24, i32 0)
  %text25 = getelementptr inbounds %class.Snap, ptr %43, i32 0, i32 1
  %text26 = load ptr, ptr %text25, align 8, !tbaa !0
  %str.data27 = getelementptr inbounds %String, ptr %text26, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %44 = call i32 (ptr, ...) @printf(ptr @.str, i32 %42, i32 %total23, ptr %data28)
  %snaps29 = load ptr, ptr %snaps, align 8
  call void @__polaron_check_live(ptr %snaps29)
  %vtbl.addr30 = getelementptr inbounds %"class.ArrayList$Snap", ptr %snaps29, i32 0, i32 0
  %vtbl31 = load ptr, ptr %vtbl.addr30, align 8, !tbaa !0
  %dtor.slot32 = getelementptr [349 x ptr], ptr %vtbl31, i64 0, i64 348
  %dtor.fn33 = load ptr, ptr %dtor.slot32, align 8
  %45 = icmp ne ptr %dtor.fn33, null
  br i1 %45, label %dtor.call34, label %dtor.free35

dtor.call34:                                      ; preds = %while.end12
  call void %dtor.fn33(ptr %snaps29)
  br label %dtor.free35

dtor.free35:                                      ; preds = %dtor.call34, %while.end12
  call void @__polaron_free(ptr %snaps29)
  call void @Snap.Snap(ptr %Snap.obj36, ptr @.strobj.2, i32 1)
  store ptr %Snap.obj36, ptr %a, align 8
  %a37 = load ptr, ptr %a, align 8
  %46 = call ptr @memcpy(ptr %Snap.copy, ptr %a37, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %47 = getelementptr inbounds %class.Snap, ptr %a37, i32 0, i32 1
  %48 = load ptr, ptr %47, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %48)
  %49 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %49, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %b, align 8
  %b38 = load ptr, ptr %b, align 8
  %row = getelementptr inbounds %class.Snap, ptr %b38, i32 0, i32 2
  store i32 2, ptr %row, align 4, !tbaa !4
  %a39 = load ptr, ptr %a, align 8
  %text40 = getelementptr inbounds %class.Snap, ptr %a39, i32 0, i32 1
  %text41 = load ptr, ptr %text40, align 8, !tbaa !0
  %str.data42 = getelementptr inbounds %String, ptr %text41, i32 0, i32 1
  %data43 = load ptr, ptr %str.data42, align 8
  %b44 = load ptr, ptr %b, align 8
  %text45 = getelementptr inbounds %class.Snap, ptr %b44, i32 0, i32 1
  %text46 = load ptr, ptr %text45, align 8, !tbaa !0
  %str.data47 = getelementptr inbounds %String, ptr %text46, i32 0, i32 1
  %data48 = load ptr, ptr %str.data47, align 8
  %50 = call i32 (ptr, ...) @printf(ptr @.str.3, ptr %data43, ptr %data48)
  ret i32 0
}

define internal void @"ArrayList$Snap.ArrayList$Snap"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$Snap.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.1299, ptr @.cl.1300, i64 %contract.l, ptr @.cr.1301, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1302, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$Snap.~ArrayList$Snap"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %3 = icmp ne ptr %dtor.fn, null
  br i1 %3, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %4 = add i64 %ae.iv, 1
  store i64 %4, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data1)
  ret void

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  %text.sfree = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 1
  %5 = load ptr, ptr %text.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %5)
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next
}

define internal void @"ArrayList$Snap.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %Snap.copy = alloca %class.Snap, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Snap.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Snap, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  %5 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %5, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp sge i32 %count1, 0
  %7 = zext i1 %6 to i32
  %inv.assume = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %8 = trunc i64 %len to i32
  %9 = icmp sle i32 %count3, %8
  %10 = zext i1 %9 to i32
  %inv.assume5 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %11 = trunc i64 %len12 to i32
  %12 = icmp sge i32 %count9, %11
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %14 = trunc i64 %len15 to i32
  %15 = mul i32 %14, 2
  %16 = sext i32 %15 to i64
  %17 = mul i64 %16, 8
  %18 = add i64 8, %17
  %arr = call ptr @__polaron_malloc(i64 %18)
  store i64 %16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %19 = call ptr @memset(ptr %arr.data, i32 0, i64 %17)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

if.end:                                           ; preds = %ae.end, %entry
  %data38 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count40 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %20 = sext i32 %count41 to i64
  %arr.len42 = load i64, ptr %data39, align 8
  %arr.oob43 = icmp uge i64 %20, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %21 = icmp slt i32 %i16, %count18
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %23 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %23, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok28
  %24 = load i32, ptr %i, align 4
  %25 = add i32 %24, 1
  store i32 %25, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data33 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0
  %ae.len = load i64, ptr %data34, align 8
  %arr.data35 = getelementptr i8, ptr %data34, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1303, ptr @.faila.1304, i64 %23, ptr @.failb.1305, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data21, i64 %23
  %data22 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %26 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %26, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1306, ptr @.faila.1307, i64 %26, ptr @.failb.1308, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds ptr, ptr %arr.data29, i64 %26
  %elem = load ptr, ptr %arr.elem30, align 8
  %Snap.copy31 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %27 = call ptr @memcpy(ptr %Snap.copy31, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %28 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %29 = load ptr, ptr %28, align 8, !tbaa !0
  %strcpy32 = call ptr @__polaron_str_copy(ptr %29)
  %30 = getelementptr inbounds %class.Snap, ptr %Snap.copy31, i32 0, i32 1
  store ptr %strcpy32, ptr %30, align 8, !tbaa !0
  store ptr %Snap.copy31, ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %31 = icmp ult i64 %ae.iv, %ae.len
  br i1 %31, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data35, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %32 = icmp ne ptr %ae.el, null
  br i1 %32, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %33 = icmp ne ptr %dtor.fn, null
  br i1 %33, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %34 = add i64 %ae.iv, 1
  store i64 %34, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data34)
  %data36 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %bigger37 = load ptr, ptr %bigger, align 8
  store ptr %bigger37, ptr %data36, align 8, !tbaa !0
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  %text.sfree = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 1
  %35 = load ptr, ptr %text.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %35)
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

idx.bad44:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1309, ptr @.faila.1310, i64 %20, ptr @.failb.1311, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %if.end
  %arr.data46 = getelementptr i8, ptr %data39, i64 8
  %arr.elem47 = getelementptr inbounds ptr, ptr %arr.data46, i64 %20
  %item48 = load ptr, ptr %item, align 8
  %Snap.copy49 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %36 = call ptr @memcpy(ptr %Snap.copy49, ptr %item48, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %37 = getelementptr inbounds %class.Snap, ptr %item48, i32 0, i32 1
  %38 = load ptr, ptr %37, align 8, !tbaa !0
  %strcpy50 = call ptr @__polaron_str_copy(ptr %38)
  %39 = getelementptr inbounds %class.Snap, ptr %Snap.copy49, i32 0, i32 1
  store ptr %strcpy50, ptr %39, align 8, !tbaa !0
  store ptr %Snap.copy49, ptr %arr.elem47, align 8
  %count51 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count52 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %40 = add i32 %count53, 1
  store i32 %40, ptr %count51, align 4, !tbaa !4
  %count54 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %old56 = load i32, ptr %old, align 4
  %41 = add i32 %old56, 1
  %42 = icmp eq i32 %count55, %41
  %43 = zext i1 %42 to i32
  %contract.ok = icmp ne i32 %43, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok45
  call void @__polaron_fail(ptr @.contract.1312, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok45
  %count57 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count58 = load i32, ptr %count57, align 4, !tbaa !4
  %44 = icmp sge i32 %count58, 0
  %45 = zext i1 %44 to i32
  %contract.ok59 = icmp ne i32 %45, 0
  br i1 %contract.ok59, label %contract.cont61, label %contract.fail60

contract.fail60:                                  ; preds = %contract.cont
  %count62 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count63 = load i32, ptr %count62, align 4, !tbaa !4
  %contract.l = sext i32 %count63 to i64
  call void @__polaron_fail(ptr @.contract.1313, ptr @.cl.1314, i64 %contract.l, ptr @.cr.1315, i64 0, i32 1)
  unreachable

contract.cont61:                                  ; preds = %contract.cont
  %count64 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count65 = load i32, ptr %count64, align 4, !tbaa !4
  %data66 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data67 = load ptr, ptr %data66, align 8, !tbaa !0
  %len68 = load i64, ptr %data67, align 8
  %46 = trunc i64 %len68 to i32
  %47 = icmp sle i32 %count65, %46
  %48 = zext i1 %47 to i32
  %contract.ok69 = icmp ne i32 %48, 0
  br i1 %contract.ok69, label %contract.cont71, label %contract.fail70

contract.fail70:                                  ; preds = %contract.cont61
  call void @__polaron_fail(ptr @.contract.1316, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont71:                                  ; preds = %contract.cont61
  ret void
}

define internal void @"ArrayList$Snap.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ae.i = alloca i64, align 8
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count31 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %14 = icmp sge i32 %count32, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
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
  %data26 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  %ae.len = load i64, ptr %data27, align 8
  %arr.data28 = getelementptr i8, ptr %data27, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1317, ptr @.faila.1318, i64 %18, ptr @.failb.1319, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1320, ptr @.faila.1321, i64 %21, ptr @.failb.1322, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %21
  %elem = load ptr, ptr %arr.elem25, align 8
  %Snap.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %22 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %23 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %24 = load ptr, ptr %23, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %24)
  %25 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %25, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %arr.elem, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %26 = icmp ult i64 %ae.iv, %ae.len
  br i1 %26, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data28, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %27 = icmp ne ptr %ae.el, null
  br i1 %27, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %28 = icmp ne ptr %dtor.fn, null
  br i1 %28, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %29 = add i64 %ae.iv, 1
  store i64 %29, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data27)
  %data29 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %bigger30 = load ptr, ptr %bigger, align 8
  store ptr %bigger30, ptr %data29, align 8, !tbaa !0
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  %text.sfree = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 1
  %30 = load ptr, ptr %text.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %30)
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

contract.fail:                                    ; preds = %if.end
  %count33 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %contract.l = sext i32 %count34 to i64
  call void @__polaron_fail(ptr @.contract.1323, ptr @.cl.1324, i64 %contract.l, ptr @.cr.1325, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count35 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %data37 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %31 = trunc i64 %len39 to i32
  %32 = icmp sle i32 %count36, %31
  %33 = zext i1 %32 to i32
  %contract.ok40 = icmp ne i32 %33, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1326, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Snap.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1327, ptr @.faila.1328, i64 %13, ptr @.failb.1329, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1330, ptr @.faila.1331, i64 %14, ptr @.failb.1332, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %14
  %elem24 = load ptr, ptr %arr.elem23, align 8
  ret ptr %elem24
}

define internal void @"ArrayList$Snap.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %Snap.copy = alloca %class.Snap, align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %3 = call ptr @memcpy(ptr %Snap.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %class.Snap, ptr %2, i32 0, i32 1
  %5 = load ptr, ptr %4, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %5)
  %6 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %6, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %7 = icmp sge i32 %count1, 0
  %8 = zext i1 %7 to i32
  %inv.assume = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %9 = trunc i64 %len to i32
  %10 = icmp sle i32 %count3, %9
  %11 = zext i1 %10 to i32
  %inv.assume5 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %12 = icmp slt i32 %i6, 0
  %13 = zext i1 %12 to i32
  %sc.a = icmp ne i32 %13, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %14 = icmp sge i32 %i7, %count9
  %15 = zext i1 %14 to i32
  %sc.b = icmp ne i32 %15, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %16 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %17 = trunc i64 %len14 to i32
  %18 = sext i32 %17 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data23 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data24 = load ptr, ptr %data23, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i25 = load i32, ptr %i, align 4
  %19 = sext i32 %i25 to i64
  %arr.len26 = load i64, ptr %data24, align 8
  %arr.oob27 = icmp uge i64 %19, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1333, ptr @.faila.1334, i64 %18, ptr @.failb.1335, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %18
  %item15 = load ptr, ptr %item, align 8
  %Snap.copy16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %20 = call ptr @memcpy(ptr %Snap.copy16, ptr %item15, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %21 = getelementptr inbounds %class.Snap, ptr %item15, i32 0, i32 1
  %22 = load ptr, ptr %21, align 8, !tbaa !0
  %strcpy17 = call ptr @__polaron_str_copy(ptr %22)
  %23 = getelementptr inbounds %class.Snap, ptr %Snap.copy16, i32 0, i32 1
  store ptr %strcpy17, ptr %23, align 8, !tbaa !0
  store ptr %Snap.copy16, ptr %arr.elem, align 8
  %count18 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !4
  %data20 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0
  %len22 = load i64, ptr %data21, align 8
  %24 = trunc i64 %len22 to i32
  %25 = icmp sle i32 %count19, %24
  %26 = zext i1 %25 to i32
  %contract.ok = icmp ne i32 %26, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.1336, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad28:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1337, ptr @.faila.1338, i64 %19, ptr @.failb.1339, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %if.end
  %arr.data30 = getelementptr i8, ptr %data24, i64 8
  %arr.elem31 = getelementptr inbounds ptr, ptr %arr.data30, i64 %19
  %item32 = load ptr, ptr %item, align 8
  %Snap.copy33 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %27 = call ptr @memcpy(ptr %Snap.copy33, ptr %item32, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %28 = getelementptr inbounds %class.Snap, ptr %item32, i32 0, i32 1
  %29 = load ptr, ptr %28, align 8, !tbaa !0
  %strcpy34 = call ptr @__polaron_str_copy(ptr %29)
  %30 = getelementptr inbounds %class.Snap, ptr %Snap.copy33, i32 0, i32 1
  store ptr %strcpy34, ptr %30, align 8, !tbaa !0
  store ptr %Snap.copy33, ptr %arr.elem31, align 8
  %count35 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %data37 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %31 = trunc i64 %len39 to i32
  %32 = icmp sle i32 %count36, %31
  %33 = zext i1 %32 to i32
  %contract.ok40 = icmp ne i32 %33, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.contract.1340, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %idx.ok29
  ret void
}

define internal i32 @"ArrayList$Snap.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %Snap.copy = alloca %class.Snap, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Snap.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Snap, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  %5 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %5, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp sge i32 %count1, 0
  %7 = zext i1 %6 to i32
  %inv.assume = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %8 = trunc i64 %len to i32
  %9 = icmp sle i32 %count3, %8
  %10 = zext i1 %9 to i32
  %inv.assume5 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume5)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %11 = icmp slt i32 %i6, %count8
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %13 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %14 = load i32, ptr %i, align 4
  %15 = add i32 %14, 1
  store i32 %15, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1341, ptr @.faila.1342, i64 %13, ptr @.failb.1343, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %item12 = load ptr, ptr %item, align 8
  %16 = call i32 @Object.equalsKey(ptr %elem, ptr %item12)
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i13 = load i32, ptr %i, align 4
  ret i32 %i13

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$Snap.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Snap.copy = alloca %class.Snap, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Snap.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Snap, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  %5 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %5, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp sge i32 %count1, 0
  %7 = zext i1 %6 to i32
  %inv.assume = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %8 = trunc i64 %len to i32
  %9 = icmp sle i32 %count3, %8
  %10 = zext i1 %9 to i32
  %inv.assume5 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %11 = call i32 @"ArrayList$Snap.indexOf"(ptr %0, ptr %item6)
  %12 = icmp sge i32 %11, 0
  %13 = zext i1 %12 to i32
  ret i32 %13
}

define internal void @"ArrayList$Snap.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca ptr, align 8
  %Snap.copy = alloca %class.Snap, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1344, ptr @.faila.1345, i64 %13, ptr @.failb.1346, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %14 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %15 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %16 = load ptr, ptr %15, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  %17 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %17, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %18 = icmp sge i32 %count16, 0
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.1347, ptr @.cl.1348, i64 %contract.l, ptr @.cr.1349, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %data21 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %20 = trunc i64 %len23 to i32
  %21 = icmp sle i32 %count20, %20
  %22 = zext i1 %21 to i32
  %contract.ok24 = icmp ne i32 %22, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1350, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %23 = sub i32 %count30, 1
  %24 = icmp slt i32 %j28, %23
  %25 = zext i1 %24 to i32
  br i1 %24, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j33 = load i32, ptr %j, align 4
  %26 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %26, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

for.update:                                       ; preds = %idx.ok46
  %27 = load i32, ptr %j, align 4
  %28 = add i32 %27, 1
  store i32 %28, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count52 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count53 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count54 = load i32, ptr %count53, align 4, !tbaa !4
  %29 = sub i32 %count54, 1
  store i32 %29, ptr %count52, align 4, !tbaa !4
  %count55 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count56 = load i32, ptr %count55, align 4, !tbaa !4
  %30 = icmp sge i32 %count56, 0
  %31 = zext i1 %30 to i32
  %contract.ok57 = icmp ne i32 %31, 0
  br i1 %contract.ok57, label %contract.cont59, label %contract.fail58

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1351, ptr @.faila.1352, i64 %26, ptr @.failb.1353, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %26
  %data40 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j42 = load i32, ptr %j, align 4
  %32 = add i32 %j42, 1
  %33 = sext i32 %32 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %33, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.1354, ptr @.faila.1355, i64 %33, ptr @.failb.1356, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %data41, i64 8
  %arr.elem48 = getelementptr inbounds ptr, ptr %arr.data47, i64 %33
  %elem49 = load ptr, ptr %arr.elem48, align 8
  %Snap.copy50 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %34 = call ptr @memcpy(ptr %Snap.copy50, ptr %elem49, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %class.Snap, ptr %elem49, i32 0, i32 1
  %36 = load ptr, ptr %35, align 8, !tbaa !0
  %strcpy51 = call ptr @__polaron_str_copy(ptr %36)
  %37 = getelementptr inbounds %class.Snap, ptr %Snap.copy50, i32 0, i32 1
  store ptr %strcpy51, ptr %37, align 8, !tbaa !0
  store ptr %Snap.copy50, ptr %arr.elem39, align 8
  br label %for.update

contract.fail58:                                  ; preds = %for.end
  %count60 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count61 = load i32, ptr %count60, align 4, !tbaa !4
  %contract.l62 = sext i32 %count61 to i64
  call void @__polaron_fail(ptr @.contract.1357, ptr @.cl.1358, i64 %contract.l62, ptr @.cr.1359, i64 0, i32 1)
  unreachable

contract.cont59:                                  ; preds = %for.end
  %count63 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count64 = load i32, ptr %count63, align 4, !tbaa !4
  %data65 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data66 = load ptr, ptr %data65, align 8, !tbaa !0
  %len67 = load i64, ptr %data66, align 8
  %38 = trunc i64 %len67 to i32
  %39 = icmp sle i32 %count64, %38
  %40 = zext i1 %39 to i32
  %contract.ok68 = icmp ne i32 %40, 0
  br i1 %contract.ok68, label %contract.cont70, label %contract.fail69

contract.fail69:                                  ; preds = %contract.cont59
  call void @__polaron_fail(ptr @.contract.1360, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont70:                                  ; preds = %contract.cont59
  ret void
}

define internal void @"ArrayList$Snap.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %j = alloca i32, align 4
  %ae.i = alloca i64, align 8
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %Snap.copy = alloca %class.Snap, align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %3 = call ptr @memcpy(ptr %Snap.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %class.Snap, ptr %2, i32 0, i32 1
  %5 = load ptr, ptr %4, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %5)
  %6 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %6, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %7 = icmp sge i32 %count1, 0
  %8 = zext i1 %7 to i32
  %inv.assume = icmp ne i32 %8, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %9 = trunc i64 %len to i32
  %10 = icmp sle i32 %count3, %9
  %11 = zext i1 %10 to i32
  %inv.assume5 = icmp ne i32 %11, 0
  call void @llvm.assume(i1 %inv.assume5)
  %i6 = load i32, ptr %i, align 4
  %12 = icmp slt i32 %i6, 0
  %13 = zext i1 %12 to i32
  %sc.a = icmp ne i32 %13, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %i7 = load i32, ptr %i, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %14 = icmp sgt i32 %i7, %count9
  %15 = zext i1 %14 to i32
  %sc.b = icmp ne i32 %15, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %16 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %17 = trunc i64 %len14 to i32
  %18 = sext i32 %17 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count30 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %data32 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %len34 = load i64, ptr %data33, align 8
  %19 = trunc i64 %len34 to i32
  %20 = icmp sge i32 %count31, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then35, label %if.end36

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1361, ptr @.faila.1362, i64 %18, ptr @.failb.1363, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %18
  %item15 = load ptr, ptr %item, align 8
  %Snap.copy16 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %22 = call ptr @memcpy(ptr %Snap.copy16, ptr %item15, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %23 = getelementptr inbounds %class.Snap, ptr %item15, i32 0, i32 1
  %24 = load ptr, ptr %23, align 8, !tbaa !0
  %strcpy17 = call ptr @__polaron_str_copy(ptr %24)
  %25 = getelementptr inbounds %class.Snap, ptr %Snap.copy16, i32 0, i32 1
  store ptr %strcpy17, ptr %25, align 8, !tbaa !0
  store ptr %Snap.copy16, ptr %arr.elem, align 8
  %count18 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !4
  %26 = icmp sge i32 %count19, 0
  %27 = zext i1 %26 to i32
  %contract.ok = icmp ne i32 %27, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %contract.l = sext i32 %count21 to i64
  call void @__polaron_fail(ptr @.contract.1364, ptr @.cl.1365, i64 %contract.l, ptr @.cr.1366, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count22 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count23 = load i32, ptr %count22, align 4, !tbaa !4
  %data24 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data25 = load ptr, ptr %data24, align 8, !tbaa !0
  %len26 = load i64, ptr %data25, align 8
  %28 = trunc i64 %len26 to i32
  %29 = icmp sle i32 %count23, %28
  %30 = zext i1 %29 to i32
  %contract.ok27 = icmp ne i32 %30, 0
  br i1 %contract.ok27, label %contract.cont29, label %contract.fail28

contract.fail28:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1367, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont29:                                  ; preds = %contract.cont
  ret void

if.then35:                                        ; preds = %if.end
  %data37 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %31 = trunc i64 %len39 to i32
  %32 = mul i32 %31, 2
  %33 = sext i32 %32 to i64
  %34 = mul i64 %33, 8
  %35 = add i64 8, %34
  %arr = call ptr @__polaron_malloc(i64 %35)
  store i64 %33, ptr %arr, align 8
  %arr.data40 = getelementptr i8, ptr %arr, i64 8
  %36 = call ptr @memset(ptr %arr.data40, i32 0, i64 %34)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

if.end36:                                         ; preds = %ae.end, %if.end
  %count68 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count69 = load i32, ptr %count68, align 4, !tbaa !4
  store i32 %count69, ptr %j, align 4
  br label %for.cond70

for.cond:                                         ; preds = %for.update, %if.then35
  %k41 = load i32, ptr %k, align 4
  %count42 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count43 = load i32, ptr %count42, align 4, !tbaa !4
  %37 = icmp slt i32 %k41, %count43
  %38 = zext i1 %37 to i32
  br i1 %37, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger44 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k45 = load i32, ptr %k, align 4
  %39 = sext i32 %k45 to i64
  %arr.len46 = load i64, ptr %bigger44, align 8
  %arr.oob47 = icmp uge i64 %39, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !8

for.update:                                       ; preds = %idx.ok58
  %40 = load i32, ptr %k, align 4
  %41 = add i32 %40, 1
  store i32 %41, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data63 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !0
  %ae.len = load i64, ptr %data64, align 8
  %arr.data65 = getelementptr i8, ptr %data64, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad48:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1368, ptr @.faila.1369, i64 %39, ptr @.failb.1370, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %for.body
  %arr.data50 = getelementptr i8, ptr %bigger44, i64 8
  %arr.elem51 = getelementptr inbounds ptr, ptr %arr.data50, i64 %39
  %data52 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data53 = load ptr, ptr %data52, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k54 = load i32, ptr %k, align 4
  %42 = sext i32 %k54 to i64
  %arr.len55 = load i64, ptr %data53, align 8
  %arr.oob56 = icmp uge i64 %42, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !8

idx.bad57:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.1371, ptr @.faila.1372, i64 %42, ptr @.failb.1373, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok49
  %arr.data59 = getelementptr i8, ptr %data53, i64 8
  %arr.elem60 = getelementptr inbounds ptr, ptr %arr.data59, i64 %42
  %elem = load ptr, ptr %arr.elem60, align 8
  %Snap.copy61 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %43 = call ptr @memcpy(ptr %Snap.copy61, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %44 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %45 = load ptr, ptr %44, align 8, !tbaa !0
  %strcpy62 = call ptr @__polaron_str_copy(ptr %45)
  %46 = getelementptr inbounds %class.Snap, ptr %Snap.copy61, i32 0, i32 1
  store ptr %strcpy62, ptr %46, align 8, !tbaa !0
  store ptr %Snap.copy61, ptr %arr.elem51, align 8
  br label %for.update

ae.cond:                                          ; preds = %ae.next, %for.end
  %ae.iv = load i64, ptr %ae.i, align 8
  %47 = icmp ult i64 %ae.iv, %ae.len
  br i1 %47, label %ae.body, label %ae.end

ae.body:                                          ; preds = %ae.cond
  %ae.ep = getelementptr ptr, ptr %arr.data65, i64 %ae.iv
  %ae.el = load ptr, ptr %ae.ep, align 8
  %48 = icmp ne ptr %ae.el, null
  br i1 %48, label %ae.free, label %ae.next

ae.free:                                          ; preds = %ae.body
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %49 = icmp ne ptr %dtor.fn, null
  br i1 %49, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %50 = add i64 %ae.iv, 1
  store i64 %50, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %data64)
  %data66 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %bigger67 = load ptr, ptr %bigger, align 8
  store ptr %bigger67, ptr %data66, align 8, !tbaa !0
  br label %if.end36

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  %text.sfree = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 1
  %51 = load ptr, ptr %text.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %51)
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

for.cond70:                                       ; preds = %for.update72, %if.end36
  %j74 = load i32, ptr %j, align 4
  %i75 = load i32, ptr %i, align 4
  %52 = icmp sgt i32 %j74, %i75
  %53 = zext i1 %52 to i32
  br i1 %52, label %for.body71, label %for.end73

for.body71:                                       ; preds = %for.cond70
  %data76 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data77 = load ptr, ptr %data76, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j78 = load i32, ptr %j, align 4
  %54 = sext i32 %j78 to i64
  %arr.len79 = load i64, ptr %data77, align 8
  %arr.oob80 = icmp uge i64 %54, %arr.len79
  br i1 %arr.oob80, label %idx.bad81, label %idx.ok82, !prof !8

for.update72:                                     ; preds = %idx.ok91
  %55 = load i32, ptr %j, align 4
  %56 = sub i32 %55, 1
  store i32 %56, ptr %j, align 4
  br label %for.cond70

for.end73:                                        ; preds = %for.cond70
  %data97 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data98 = load ptr, ptr %data97, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i99 = load i32, ptr %i, align 4
  %57 = sext i32 %i99 to i64
  %arr.len100 = load i64, ptr %data98, align 8
  %arr.oob101 = icmp uge i64 %57, %arr.len100
  br i1 %arr.oob101, label %idx.bad102, label %idx.ok103, !prof !8

idx.bad81:                                        ; preds = %for.body71
  call void @__polaron_fail(ptr @.fail.1374, ptr @.faila.1375, i64 %54, ptr @.failb.1376, i64 %arr.len79, i32 70)
  unreachable

idx.ok82:                                         ; preds = %for.body71
  %arr.data83 = getelementptr i8, ptr %data77, i64 8
  %arr.elem84 = getelementptr inbounds ptr, ptr %arr.data83, i64 %54
  %data85 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data86 = load ptr, ptr %data85, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j87 = load i32, ptr %j, align 4
  %58 = sub i32 %j87, 1
  %59 = sext i32 %58 to i64
  %arr.len88 = load i64, ptr %data86, align 8
  %arr.oob89 = icmp uge i64 %59, %arr.len88
  br i1 %arr.oob89, label %idx.bad90, label %idx.ok91, !prof !8

idx.bad90:                                        ; preds = %idx.ok82
  call void @__polaron_fail(ptr @.fail.1377, ptr @.faila.1378, i64 %59, ptr @.failb.1379, i64 %arr.len88, i32 70)
  unreachable

idx.ok91:                                         ; preds = %idx.ok82
  %arr.data92 = getelementptr i8, ptr %data86, i64 8
  %arr.elem93 = getelementptr inbounds ptr, ptr %arr.data92, i64 %59
  %elem94 = load ptr, ptr %arr.elem93, align 8
  %Snap.copy95 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %60 = call ptr @memcpy(ptr %Snap.copy95, ptr %elem94, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %61 = getelementptr inbounds %class.Snap, ptr %elem94, i32 0, i32 1
  %62 = load ptr, ptr %61, align 8, !tbaa !0
  %strcpy96 = call ptr @__polaron_str_copy(ptr %62)
  %63 = getelementptr inbounds %class.Snap, ptr %Snap.copy95, i32 0, i32 1
  store ptr %strcpy96, ptr %63, align 8, !tbaa !0
  store ptr %Snap.copy95, ptr %arr.elem84, align 8
  br label %for.update72

idx.bad102:                                       ; preds = %for.end73
  call void @__polaron_fail(ptr @.fail.1380, ptr @.faila.1381, i64 %57, ptr @.failb.1382, i64 %arr.len100, i32 70)
  unreachable

idx.ok103:                                        ; preds = %for.end73
  %arr.data104 = getelementptr i8, ptr %data98, i64 8
  %arr.elem105 = getelementptr inbounds ptr, ptr %arr.data104, i64 %57
  %item106 = load ptr, ptr %item, align 8
  %Snap.copy107 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %64 = call ptr @memcpy(ptr %Snap.copy107, ptr %item106, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %65 = getelementptr inbounds %class.Snap, ptr %item106, i32 0, i32 1
  %66 = load ptr, ptr %65, align 8, !tbaa !0
  %strcpy108 = call ptr @__polaron_str_copy(ptr %66)
  %67 = getelementptr inbounds %class.Snap, ptr %Snap.copy107, i32 0, i32 1
  store ptr %strcpy108, ptr %67, align 8, !tbaa !0
  store ptr %Snap.copy107, ptr %arr.elem105, align 8
  %count109 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count110 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count111 = load i32, ptr %count110, align 4, !tbaa !4
  %68 = add i32 %count111, 1
  store i32 %68, ptr %count109, align 4, !tbaa !4
  %count112 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !4
  %69 = icmp sge i32 %count113, 0
  %70 = zext i1 %69 to i32
  %contract.ok114 = icmp ne i32 %70, 0
  br i1 %contract.ok114, label %contract.cont116, label %contract.fail115

contract.fail115:                                 ; preds = %idx.ok103
  %count117 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count118 = load i32, ptr %count117, align 4, !tbaa !4
  %contract.l119 = sext i32 %count118 to i64
  call void @__polaron_fail(ptr @.contract.1383, ptr @.cl.1384, i64 %contract.l119, ptr @.cr.1385, i64 0, i32 1)
  unreachable

contract.cont116:                                 ; preds = %idx.ok103
  %count120 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count121 = load i32, ptr %count120, align 4, !tbaa !4
  %data122 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data123 = load ptr, ptr %data122, align 8, !tbaa !0
  %len124 = load i64, ptr %data123, align 8
  %71 = trunc i64 %len124 to i32
  %72 = icmp sle i32 %count121, %71
  %73 = zext i1 %72 to i32
  %contract.ok125 = icmp ne i32 %73, 0
  br i1 %contract.ok125, label %contract.cont127, label %contract.fail126

contract.fail126:                                 ; preds = %contract.cont116
  call void @__polaron_fail(ptr @.contract.1386, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont127:                                 ; preds = %contract.cont116
  ret void
}

define internal i32 @"ArrayList$Snap.remove"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %Snap.copy = alloca %class.Snap, align 8
  %item = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Snap.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Snap, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  %5 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %5, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp sge i32 %count1, 0
  %7 = zext i1 %6 to i32
  %inv.assume = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %8 = trunc i64 %len to i32
  %9 = icmp sle i32 %count3, %8
  %10 = zext i1 %9 to i32
  %inv.assume5 = icmp ne i32 %10, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %11 = call i32 @"ArrayList$Snap.indexOf"(ptr %0, ptr %item6)
  store i32 %11, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %12 = icmp slt i32 %i7, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %i8 = load i32, ptr %i, align 4
  call void @"ArrayList$Snap.removeAt"(ptr %0, i32 %i8)
  ret i32 1
}

define internal void @"ArrayList$Snap.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.1387, ptr @.cl.1388, i64 %contract.l, ptr @.cr.1389, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1390, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Snap.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
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
  %count9 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.1391, ptr @.faila.1392, i64 %12, ptr @.failb.1393, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1394, ptr @.faila.1395, i64 %15, ptr @.failb.1396, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %15
  %elem = load ptr, ptr %arr.elem22, align 8
  %Snap.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %17 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %18 = load ptr, ptr %17, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %18)
  %19 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %19, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %arr.elem, align 8
  br label %for.update
}

define internal i32 @"ArrayList$Snap.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$Snap.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$Snap.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1397, ptr @.faila.1398, i64 %10, ptr @.failb.1399, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  call void %code(ptr %env, ptr %elem)
  br label %for.update
}

define internal ptr @"ArrayList$Snap.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Snap.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Snap", ptr null, i64 1) to i64))
  call void @"ArrayList$Snap.ArrayList$Snap"(ptr %"ArrayList$Snap.obj")
  store ptr %"ArrayList$Snap.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$Snap.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1400, ptr @.faila.1401, i64 %10, ptr @.failb.1402, i64 %arr.len, i32 70)
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
  %data17 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1403, ptr @.faila.1404, i64 %15, ptr @.failb.1405, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %15
  %elem26 = load ptr, ptr %arr.elem25, align 8
  call void @"ArrayList$Snap.add"(ptr %out16, ptr %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$Snap.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1406, ptr @.faila.1407, i64 %10, ptr @.failb.1408, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Snap.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1409, ptr @.faila.1410, i64 %10, ptr @.failb.1411, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Snap.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1412, ptr @.faila.1413, i64 %10, ptr @.failb.1414, i64 %arr.len, i32 70)
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

define internal ptr @"ArrayList$Snap.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %ae.i = alloca i64, align 8
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Snap.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Snap", ptr null, i64 1) to i64))
  call void @"ArrayList$Snap.ArrayList$Snap"(ptr %"ArrayList$Snap.obj")
  store ptr %"ArrayList$Snap.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$Snap.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %12 = call i32 @"ArrayList$Snap.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1415, ptr @.faila.1416, i64 %9, ptr @.failb.1417, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  call void @"ArrayList$Snap.add"(ptr %out12, ptr %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$Snap.size"(ptr %out17)
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
  %20 = call i32 @"ArrayList$Snap.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Snap.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  %ae.len = load i64, ptr %scratch23, align 8
  %arr.data24 = getelementptr i8, ptr %scratch23, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

if.end:                                           ; preds = %ae.end, %for.end
  %out25 = load ptr, ptr %out, align 8
  %count26 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
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
  call void @__polaron_check_live(ptr %ae.el)
  %vtbl.addr = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %26 = icmp ne ptr %dtor.fn, null
  br i1 %26, label %dtor.call, label %dtor.free

ae.next:                                          ; preds = %dtor.free, %ae.body
  %27 = add i64 %ae.iv, 1
  store i64 %27, ptr %ae.i, align 8
  br label %ae.cond

ae.end:                                           ; preds = %ae.cond
  call void @__polaron_free(ptr %scratch23)
  br label %if.end

dtor.call:                                        ; preds = %ae.free
  call void %dtor.fn(ptr %ae.el)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %ae.free
  %text.sfree = getelementptr inbounds %class.Snap, ptr %ae.el, i32 0, i32 1
  %28 = load ptr, ptr %text.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %28)
  call void @__polaron_free(ptr %ae.el)
  store ptr null, ptr %ae.ep, align 8
  br label %ae.next

contract.fail:                                    ; preds = %if.end
  %count28 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %contract.l = sext i32 %count29 to i64
  call void @__polaron_fail(ptr @.contract.1418, ptr @.cl.1419, i64 %contract.l, ptr @.cr.1420, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count30 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %data32 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %len34 = load i64, ptr %data33, align 8
  %29 = trunc i64 %len34 to i32
  %30 = icmp sle i32 %count31, %29
  %31 = zext i1 %30 to i32
  %contract.ok35 = icmp ne i32 %31, 0
  br i1 %contract.ok35, label %contract.cont37, label %contract.fail36

contract.fail36:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1421, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont37:                                  ; preds = %contract.cont
  ret ptr %out25
}

define internal void @"ArrayList$Snap.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %q = alloca i32, align 4
  %key = alloca ptr, align 8
  %Snap.copy = alloca %class.Snap, align 8
  %p = alloca i32, align 4
  %compare = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca ptr, align 8
  store ptr %1, ptr %tmp, align 8
  store i32 %2, ptr %lo, align 4
  store i32 %3, ptr %hi, align 4
  store ptr %4, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.1422, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.then
  ret void

if.then15:                                        ; preds = %if.end
  %lo17 = load i32, ptr %lo, align 4
  %18 = add i32 %lo17, 1
  store i32 %18, ptr %p, align 4
  br label %for.cond

if.end16:                                         ; preds = %if.end
  %lo81 = load i32, ptr %lo, align 4
  %hi82 = load i32, ptr %hi, align 4
  %19 = add i32 %lo81, %hi82
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
  %data20 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok66
  %p72 = load i32, ptr %p, align 4
  %26 = add i32 %p72, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count73 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count74 = load i32, ptr %count73, align 4, !tbaa !4
  %data75 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data76 = load ptr, ptr %data75, align 8, !tbaa !0
  %len77 = load i64, ptr %data76, align 8
  %27 = trunc i64 %len77 to i32
  %28 = icmp sle i32 %count74, %27
  %29 = zext i1 %28 to i32
  %contract.ok78 = icmp ne i32 %29, 0
  br i1 %contract.ok78, label %contract.cont80, label %contract.fail79

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1423, ptr @.faila.1424, i64 %25, ptr @.failb.1425, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %25
  %elem = load ptr, ptr %arr.elem, align 8
  %30 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %32 = load ptr, ptr %31, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %32)
  %33 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %33, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %key, align 8
  %p23 = load i32, ptr %p, align 4
  %34 = sub i32 %p23, 1
  store i32 %34, ptr %q, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok53, %idx.ok
  %q24 = load i32, ptr %q, align 4
  %lo25 = load i32, ptr %lo, align 4
  %35 = icmp sge i32 %q24, %lo25
  %36 = zext i1 %35 to i32
  %sc.a = icmp ne i32 %36, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %data38 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q40 = load i32, ptr %q, align 4
  %37 = add i32 %q40, 1
  %38 = sext i32 %37 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %38, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

while.end:                                        ; preds = %sc.end
  %data60 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data61 = load ptr, ptr %data60, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q62 = load i32, ptr %q, align 4
  %39 = add i32 %q62, 1
  %40 = sext i32 %39 to i64
  %arr.len63 = load i64, ptr %data61, align 8
  %arr.oob64 = icmp uge i64 %40, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %41 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %41, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q29 = load i32, ptr %q, align 4
  %42 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %42, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %43 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1426, ptr @.faila.1427, i64 %42, ptr @.failb.1428, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %sc.rhs
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %42
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %key37 = load ptr, ptr %key, align 8
  %44 = call i32 %code(ptr %env, ptr %elem36, ptr %key37)
  %45 = icmp sgt i32 %44, 0
  %46 = zext i1 %45 to i32
  %sc.b = icmp ne i32 %46, 0
  br label %sc.end

idx.bad43:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.1429, ptr @.faila.1430, i64 %38, ptr @.failb.1431, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %38
  %data47 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q49 = load i32, ptr %q, align 4
  %47 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %47, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !8

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.1432, ptr @.faila.1433, i64 %47, ptr @.failb.1434, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %data48, i64 8
  %arr.elem55 = getelementptr inbounds ptr, ptr %arr.data54, i64 %47
  %elem56 = load ptr, ptr %arr.elem55, align 8
  %Snap.copy57 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %48 = call ptr @memcpy(ptr %Snap.copy57, ptr %elem56, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %49 = getelementptr inbounds %class.Snap, ptr %elem56, i32 0, i32 1
  %50 = load ptr, ptr %49, align 8, !tbaa !0
  %strcpy58 = call ptr @__polaron_str_copy(ptr %50)
  %51 = getelementptr inbounds %class.Snap, ptr %Snap.copy57, i32 0, i32 1
  store ptr %strcpy58, ptr %51, align 8, !tbaa !0
  store ptr %Snap.copy57, ptr %arr.elem46, align 8
  %q59 = load i32, ptr %q, align 4
  %52 = sub i32 %q59, 1
  store i32 %52, ptr %q, align 4
  br label %while.cond

idx.bad65:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1435, ptr @.faila.1436, i64 %40, ptr @.failb.1437, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %while.end
  %arr.data67 = getelementptr i8, ptr %data61, i64 8
  %arr.elem68 = getelementptr inbounds ptr, ptr %arr.data67, i64 %40
  %key69 = load ptr, ptr %key, align 8
  %Snap.copy70 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %53 = call ptr @memcpy(ptr %Snap.copy70, ptr %key69, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %54 = getelementptr inbounds %class.Snap, ptr %key69, i32 0, i32 1
  %55 = load ptr, ptr %54, align 8, !tbaa !0
  %strcpy71 = call ptr @__polaron_str_copy(ptr %55)
  %56 = getelementptr inbounds %class.Snap, ptr %Snap.copy70, i32 0, i32 1
  store ptr %strcpy71, ptr %56, align 8, !tbaa !0
  store ptr %Snap.copy70, ptr %arr.elem68, align 8
  br label %for.update

contract.fail79:                                  ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.1438, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont80:                                  ; preds = %for.end
  ret void

div.bad:                                          ; preds = %if.end16
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %if.end16
  %57 = sdiv i32 %19, 2
  store i32 %57, ptr %mid, align 4
  %tmp83 = load ptr, ptr %tmp, align 8
  %lo84 = load i32, ptr %lo, align 4
  %mid85 = load i32, ptr %mid, align 4
  %compare86 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Snap.mergeSortRange"(ptr %0, ptr %tmp83, i32 %lo84, i32 %mid85, ptr %compare86)
  %tmp87 = load ptr, ptr %tmp, align 8
  %mid88 = load i32, ptr %mid, align 4
  %58 = add i32 %mid88, 1
  %hi89 = load i32, ptr %hi, align 4
  %compare90 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Snap.mergeSortRange"(ptr %0, ptr %tmp87, i32 %58, i32 %hi89, ptr %compare90)
  %compare91 = load ptr, ptr %compare, align 8
  %code92 = load ptr, ptr %compare91, align 8
  %59 = getelementptr ptr, ptr %compare91, i32 1
  %env93 = load ptr, ptr %59, align 8
  %data94 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data95 = load ptr, ptr %data94, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid96 = load i32, ptr %mid, align 4
  %60 = sext i32 %mid96 to i64
  %arr.len97 = load i64, ptr %data95, align 8
  %arr.oob98 = icmp uge i64 %60, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !8

idx.bad99:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1439, ptr @.faila.1440, i64 %60, ptr @.failb.1441, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %div.ok
  %arr.data101 = getelementptr i8, ptr %data95, i64 8
  %arr.elem102 = getelementptr inbounds ptr, ptr %arr.data101, i64 %60
  %elem103 = load ptr, ptr %arr.elem102, align 8
  %data104 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data105 = load ptr, ptr %data104, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid106 = load i32, ptr %mid, align 4
  %61 = add i32 %mid106, 1
  %62 = sext i32 %61 to i64
  %arr.len107 = load i64, ptr %data105, align 8
  %arr.oob108 = icmp uge i64 %62, %arr.len107
  br i1 %arr.oob108, label %idx.bad109, label %idx.ok110, !prof !8

idx.bad109:                                       ; preds = %idx.ok100
  call void @__polaron_fail(ptr @.fail.1442, ptr @.faila.1443, i64 %62, ptr @.failb.1444, i64 %arr.len107, i32 70)
  unreachable

idx.ok110:                                        ; preds = %idx.ok100
  %arr.data111 = getelementptr i8, ptr %data105, i64 8
  %arr.elem112 = getelementptr inbounds ptr, ptr %arr.data111, i64 %62
  %elem113 = load ptr, ptr %arr.elem112, align 8
  %63 = call i32 %code92(ptr %env93, ptr %elem103, ptr %elem113)
  %64 = icmp sle i32 %63, 0
  %65 = zext i1 %64 to i32
  br i1 %64, label %if.then114, label %if.end115

if.then114:                                       ; preds = %idx.ok110
  %count116 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count117 = load i32, ptr %count116, align 4, !tbaa !4
  %data118 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data119 = load ptr, ptr %data118, align 8, !tbaa !0
  %len120 = load i64, ptr %data119, align 8
  %66 = trunc i64 %len120 to i32
  %67 = icmp sle i32 %count117, %66
  %68 = zext i1 %67 to i32
  %contract.ok121 = icmp ne i32 %68, 0
  br i1 %contract.ok121, label %contract.cont123, label %contract.fail122

if.end115:                                        ; preds = %idx.ok110
  %lo124 = load i32, ptr %lo, align 4
  store i32 %lo124, ptr %i, align 4
  %mid125 = load i32, ptr %mid, align 4
  %69 = add i32 %mid125, 1
  store i32 %69, ptr %j, align 4
  %lo126 = load i32, ptr %lo, align 4
  store i32 %lo126, ptr %k, align 4
  br label %while.cond127

contract.fail122:                                 ; preds = %if.then114
  call void @__polaron_fail(ptr @.contract.1445, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont123:                                 ; preds = %if.then114
  ret void

while.cond127:                                    ; preds = %if.end163, %if.end115
  %i130 = load i32, ptr %i, align 4
  %mid131 = load i32, ptr %mid, align 4
  %70 = icmp sle i32 %i130, %mid131
  %71 = zext i1 %70 to i32
  %sc.a132 = icmp ne i32 %71, 0
  br i1 %sc.a132, label %sc.rhs133, label %sc.end134

while.body128:                                    ; preds = %sc.end134
  %compare139 = load ptr, ptr %compare, align 8
  %code140 = load ptr, ptr %compare139, align 8
  %72 = getelementptr ptr, ptr %compare139, i32 1
  %env141 = load ptr, ptr %72, align 8
  %data142 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data143 = load ptr, ptr %data142, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i144 = load i32, ptr %i, align 4
  %73 = sext i32 %i144 to i64
  %arr.len145 = load i64, ptr %data143, align 8
  %arr.oob146 = icmp uge i64 %73, %arr.len145
  br i1 %arr.oob146, label %idx.bad147, label %idx.ok148, !prof !8

while.end129:                                     ; preds = %sc.end134
  br label %while.cond207

sc.rhs133:                                        ; preds = %while.cond127
  %j135 = load i32, ptr %j, align 4
  %hi136 = load i32, ptr %hi, align 4
  %74 = icmp sle i32 %j135, %hi136
  %75 = zext i1 %74 to i32
  %sc.b137 = icmp ne i32 %75, 0
  br label %sc.end134

sc.end134:                                        ; preds = %sc.rhs133, %while.cond127
  %sc138 = phi i1 [ false, %while.cond127 ], [ %sc.b137, %sc.rhs133 ]
  %76 = zext i1 %sc138 to i32
  br i1 %sc138, label %while.body128, label %while.end129

idx.bad147:                                       ; preds = %while.body128
  call void @__polaron_fail(ptr @.fail.1446, ptr @.faila.1447, i64 %73, ptr @.failb.1448, i64 %arr.len145, i32 70)
  unreachable

idx.ok148:                                        ; preds = %while.body128
  %arr.data149 = getelementptr i8, ptr %data143, i64 8
  %arr.elem150 = getelementptr inbounds ptr, ptr %arr.data149, i64 %73
  %elem151 = load ptr, ptr %arr.elem150, align 8
  %data152 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data153 = load ptr, ptr %data152, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j154 = load i32, ptr %j, align 4
  %77 = sext i32 %j154 to i64
  %arr.len155 = load i64, ptr %data153, align 8
  %arr.oob156 = icmp uge i64 %77, %arr.len155
  br i1 %arr.oob156, label %idx.bad157, label %idx.ok158, !prof !8

idx.bad157:                                       ; preds = %idx.ok148
  call void @__polaron_fail(ptr @.fail.1449, ptr @.faila.1450, i64 %77, ptr @.failb.1451, i64 %arr.len155, i32 70)
  unreachable

idx.ok158:                                        ; preds = %idx.ok148
  %arr.data159 = getelementptr i8, ptr %data153, i64 8
  %arr.elem160 = getelementptr inbounds ptr, ptr %arr.data159, i64 %77
  %elem161 = load ptr, ptr %arr.elem160, align 8
  %78 = call i32 %code140(ptr %env141, ptr %elem151, ptr %elem161)
  %79 = icmp sle i32 %78, 0
  %80 = zext i1 %79 to i32
  br i1 %79, label %if.then162, label %if.else

if.then162:                                       ; preds = %idx.ok158
  %tmp164 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k165 = load i32, ptr %k, align 4
  %81 = sext i32 %k165 to i64
  %arr.len166 = load i64, ptr %tmp164, align 8
  %arr.oob167 = icmp uge i64 %81, %arr.len166
  br i1 %arr.oob167, label %idx.bad168, label %idx.ok169, !prof !8

if.else:                                          ; preds = %idx.ok158
  %tmp185 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k186 = load i32, ptr %k, align 4
  %82 = sext i32 %k186 to i64
  %arr.len187 = load i64, ptr %tmp185, align 8
  %arr.oob188 = icmp uge i64 %82, %arr.len187
  br i1 %arr.oob188, label %idx.bad189, label %idx.ok190, !prof !8

if.end163:                                        ; preds = %idx.ok199, %idx.ok178
  %k206 = load i32, ptr %k, align 4
  %83 = add i32 %k206, 1
  store i32 %83, ptr %k, align 4
  br label %while.cond127

idx.bad168:                                       ; preds = %if.then162
  call void @__polaron_fail(ptr @.fail.1452, ptr @.faila.1453, i64 %81, ptr @.failb.1454, i64 %arr.len166, i32 70)
  unreachable

idx.ok169:                                        ; preds = %if.then162
  %arr.data170 = getelementptr i8, ptr %tmp164, i64 8
  %arr.elem171 = getelementptr inbounds ptr, ptr %arr.data170, i64 %81
  %data172 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data173 = load ptr, ptr %data172, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i174 = load i32, ptr %i, align 4
  %84 = sext i32 %i174 to i64
  %arr.len175 = load i64, ptr %data173, align 8
  %arr.oob176 = icmp uge i64 %84, %arr.len175
  br i1 %arr.oob176, label %idx.bad177, label %idx.ok178, !prof !8

idx.bad177:                                       ; preds = %idx.ok169
  call void @__polaron_fail(ptr @.fail.1455, ptr @.faila.1456, i64 %84, ptr @.failb.1457, i64 %arr.len175, i32 70)
  unreachable

idx.ok178:                                        ; preds = %idx.ok169
  %arr.data179 = getelementptr i8, ptr %data173, i64 8
  %arr.elem180 = getelementptr inbounds ptr, ptr %arr.data179, i64 %84
  %elem181 = load ptr, ptr %arr.elem180, align 8
  %Snap.copy182 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %85 = call ptr @memcpy(ptr %Snap.copy182, ptr %elem181, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %86 = getelementptr inbounds %class.Snap, ptr %elem181, i32 0, i32 1
  %87 = load ptr, ptr %86, align 8, !tbaa !0
  %strcpy183 = call ptr @__polaron_str_copy(ptr %87)
  %88 = getelementptr inbounds %class.Snap, ptr %Snap.copy182, i32 0, i32 1
  store ptr %strcpy183, ptr %88, align 8, !tbaa !0
  store ptr %Snap.copy182, ptr %arr.elem171, align 8
  %i184 = load i32, ptr %i, align 4
  %89 = add i32 %i184, 1
  store i32 %89, ptr %i, align 4
  br label %if.end163

idx.bad189:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1458, ptr @.faila.1459, i64 %82, ptr @.failb.1460, i64 %arr.len187, i32 70)
  unreachable

idx.ok190:                                        ; preds = %if.else
  %arr.data191 = getelementptr i8, ptr %tmp185, i64 8
  %arr.elem192 = getelementptr inbounds ptr, ptr %arr.data191, i64 %82
  %data193 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data194 = load ptr, ptr %data193, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j195 = load i32, ptr %j, align 4
  %90 = sext i32 %j195 to i64
  %arr.len196 = load i64, ptr %data194, align 8
  %arr.oob197 = icmp uge i64 %90, %arr.len196
  br i1 %arr.oob197, label %idx.bad198, label %idx.ok199, !prof !8

idx.bad198:                                       ; preds = %idx.ok190
  call void @__polaron_fail(ptr @.fail.1461, ptr @.faila.1462, i64 %90, ptr @.failb.1463, i64 %arr.len196, i32 70)
  unreachable

idx.ok199:                                        ; preds = %idx.ok190
  %arr.data200 = getelementptr i8, ptr %data194, i64 8
  %arr.elem201 = getelementptr inbounds ptr, ptr %arr.data200, i64 %90
  %elem202 = load ptr, ptr %arr.elem201, align 8
  %Snap.copy203 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %91 = call ptr @memcpy(ptr %Snap.copy203, ptr %elem202, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %92 = getelementptr inbounds %class.Snap, ptr %elem202, i32 0, i32 1
  %93 = load ptr, ptr %92, align 8, !tbaa !0
  %strcpy204 = call ptr @__polaron_str_copy(ptr %93)
  %94 = getelementptr inbounds %class.Snap, ptr %Snap.copy203, i32 0, i32 1
  store ptr %strcpy204, ptr %94, align 8, !tbaa !0
  store ptr %Snap.copy203, ptr %arr.elem192, align 8
  %j205 = load i32, ptr %j, align 4
  %95 = add i32 %j205, 1
  store i32 %95, ptr %j, align 4
  br label %if.end163

while.cond207:                                    ; preds = %idx.ok226, %while.end129
  %i210 = load i32, ptr %i, align 4
  %mid211 = load i32, ptr %mid, align 4
  %96 = icmp sle i32 %i210, %mid211
  %97 = zext i1 %96 to i32
  br i1 %96, label %while.body208, label %while.end209

while.body208:                                    ; preds = %while.cond207
  %tmp212 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k213 = load i32, ptr %k, align 4
  %98 = sext i32 %k213 to i64
  %arr.len214 = load i64, ptr %tmp212, align 8
  %arr.oob215 = icmp uge i64 %98, %arr.len214
  br i1 %arr.oob215, label %idx.bad216, label %idx.ok217, !prof !8

while.end209:                                     ; preds = %while.cond207
  br label %while.cond234

idx.bad216:                                       ; preds = %while.body208
  call void @__polaron_fail(ptr @.fail.1464, ptr @.faila.1465, i64 %98, ptr @.failb.1466, i64 %arr.len214, i32 70)
  unreachable

idx.ok217:                                        ; preds = %while.body208
  %arr.data218 = getelementptr i8, ptr %tmp212, i64 8
  %arr.elem219 = getelementptr inbounds ptr, ptr %arr.data218, i64 %98
  %data220 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data221 = load ptr, ptr %data220, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i222 = load i32, ptr %i, align 4
  %99 = sext i32 %i222 to i64
  %arr.len223 = load i64, ptr %data221, align 8
  %arr.oob224 = icmp uge i64 %99, %arr.len223
  br i1 %arr.oob224, label %idx.bad225, label %idx.ok226, !prof !8

idx.bad225:                                       ; preds = %idx.ok217
  call void @__polaron_fail(ptr @.fail.1467, ptr @.faila.1468, i64 %99, ptr @.failb.1469, i64 %arr.len223, i32 70)
  unreachable

idx.ok226:                                        ; preds = %idx.ok217
  %arr.data227 = getelementptr i8, ptr %data221, i64 8
  %arr.elem228 = getelementptr inbounds ptr, ptr %arr.data227, i64 %99
  %elem229 = load ptr, ptr %arr.elem228, align 8
  %Snap.copy230 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %100 = call ptr @memcpy(ptr %Snap.copy230, ptr %elem229, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %101 = getelementptr inbounds %class.Snap, ptr %elem229, i32 0, i32 1
  %102 = load ptr, ptr %101, align 8, !tbaa !0
  %strcpy231 = call ptr @__polaron_str_copy(ptr %102)
  %103 = getelementptr inbounds %class.Snap, ptr %Snap.copy230, i32 0, i32 1
  store ptr %strcpy231, ptr %103, align 8, !tbaa !0
  store ptr %Snap.copy230, ptr %arr.elem219, align 8
  %i232 = load i32, ptr %i, align 4
  %104 = add i32 %i232, 1
  store i32 %104, ptr %i, align 4
  %k233 = load i32, ptr %k, align 4
  %105 = add i32 %k233, 1
  store i32 %105, ptr %k, align 4
  br label %while.cond207

while.cond234:                                    ; preds = %idx.ok253, %while.end209
  %j237 = load i32, ptr %j, align 4
  %hi238 = load i32, ptr %hi, align 4
  %106 = icmp sle i32 %j237, %hi238
  %107 = zext i1 %106 to i32
  br i1 %106, label %while.body235, label %while.end236

while.body235:                                    ; preds = %while.cond234
  %tmp239 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k240 = load i32, ptr %k, align 4
  %108 = sext i32 %k240 to i64
  %arr.len241 = load i64, ptr %tmp239, align 8
  %arr.oob242 = icmp uge i64 %108, %arr.len241
  br i1 %arr.oob242, label %idx.bad243, label %idx.ok244, !prof !8

while.end236:                                     ; preds = %while.cond234
  %lo261 = load i32, ptr %lo, align 4
  store i32 %lo261, ptr %t, align 4
  br label %for.cond262

idx.bad243:                                       ; preds = %while.body235
  call void @__polaron_fail(ptr @.fail.1470, ptr @.faila.1471, i64 %108, ptr @.failb.1472, i64 %arr.len241, i32 70)
  unreachable

idx.ok244:                                        ; preds = %while.body235
  %arr.data245 = getelementptr i8, ptr %tmp239, i64 8
  %arr.elem246 = getelementptr inbounds ptr, ptr %arr.data245, i64 %108
  %data247 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data248 = load ptr, ptr %data247, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j249 = load i32, ptr %j, align 4
  %109 = sext i32 %j249 to i64
  %arr.len250 = load i64, ptr %data248, align 8
  %arr.oob251 = icmp uge i64 %109, %arr.len250
  br i1 %arr.oob251, label %idx.bad252, label %idx.ok253, !prof !8

idx.bad252:                                       ; preds = %idx.ok244
  call void @__polaron_fail(ptr @.fail.1473, ptr @.faila.1474, i64 %109, ptr @.failb.1475, i64 %arr.len250, i32 70)
  unreachable

idx.ok253:                                        ; preds = %idx.ok244
  %arr.data254 = getelementptr i8, ptr %data248, i64 8
  %arr.elem255 = getelementptr inbounds ptr, ptr %arr.data254, i64 %109
  %elem256 = load ptr, ptr %arr.elem255, align 8
  %Snap.copy257 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %110 = call ptr @memcpy(ptr %Snap.copy257, ptr %elem256, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %111 = getelementptr inbounds %class.Snap, ptr %elem256, i32 0, i32 1
  %112 = load ptr, ptr %111, align 8, !tbaa !0
  %strcpy258 = call ptr @__polaron_str_copy(ptr %112)
  %113 = getelementptr inbounds %class.Snap, ptr %Snap.copy257, i32 0, i32 1
  store ptr %strcpy258, ptr %113, align 8, !tbaa !0
  store ptr %Snap.copy257, ptr %arr.elem246, align 8
  %j259 = load i32, ptr %j, align 4
  %114 = add i32 %j259, 1
  store i32 %114, ptr %j, align 4
  %k260 = load i32, ptr %k, align 4
  %115 = add i32 %k260, 1
  store i32 %115, ptr %k, align 4
  br label %while.cond234

for.cond262:                                      ; preds = %for.update264, %while.end236
  %t266 = load i32, ptr %t, align 4
  %hi267 = load i32, ptr %hi, align 4
  %116 = icmp sle i32 %t266, %hi267
  %117 = zext i1 %116 to i32
  br i1 %116, label %for.body263, label %for.end265

for.body263:                                      ; preds = %for.cond262
  %data268 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data269 = load ptr, ptr %data268, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %t270 = load i32, ptr %t, align 4
  %118 = sext i32 %t270 to i64
  %arr.len271 = load i64, ptr %data269, align 8
  %arr.oob272 = icmp uge i64 %118, %arr.len271
  br i1 %arr.oob272, label %idx.bad273, label %idx.ok274, !prof !8

for.update264:                                    ; preds = %idx.ok282
  %t288 = load i32, ptr %t, align 4
  %119 = add i32 %t288, 1
  store i32 %119, ptr %t, align 4
  br label %for.cond262

for.end265:                                       ; preds = %for.cond262
  %count289 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count290 = load i32, ptr %count289, align 4, !tbaa !4
  %data291 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data292 = load ptr, ptr %data291, align 8, !tbaa !0
  %len293 = load i64, ptr %data292, align 8
  %120 = trunc i64 %len293 to i32
  %121 = icmp sle i32 %count290, %120
  %122 = zext i1 %121 to i32
  %contract.ok294 = icmp ne i32 %122, 0
  br i1 %contract.ok294, label %contract.cont296, label %contract.fail295

idx.bad273:                                       ; preds = %for.body263
  call void @__polaron_fail(ptr @.fail.1476, ptr @.faila.1477, i64 %118, ptr @.failb.1478, i64 %arr.len271, i32 70)
  unreachable

idx.ok274:                                        ; preds = %for.body263
  %arr.data275 = getelementptr i8, ptr %data269, i64 8
  %arr.elem276 = getelementptr inbounds ptr, ptr %arr.data275, i64 %118
  %tmp277 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %t278 = load i32, ptr %t, align 4
  %123 = sext i32 %t278 to i64
  %arr.len279 = load i64, ptr %tmp277, align 8
  %arr.oob280 = icmp uge i64 %123, %arr.len279
  br i1 %arr.oob280, label %idx.bad281, label %idx.ok282, !prof !8

idx.bad281:                                       ; preds = %idx.ok274
  call void @__polaron_fail(ptr @.fail.1479, ptr @.faila.1480, i64 %123, ptr @.failb.1481, i64 %arr.len279, i32 70)
  unreachable

idx.ok282:                                        ; preds = %idx.ok274
  %arr.data283 = getelementptr i8, ptr %tmp277, i64 8
  %arr.elem284 = getelementptr inbounds ptr, ptr %arr.data283, i64 %123
  %elem285 = load ptr, ptr %arr.elem284, align 8
  %Snap.copy286 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %124 = call ptr @memcpy(ptr %Snap.copy286, ptr %elem285, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %125 = getelementptr inbounds %class.Snap, ptr %elem285, i32 0, i32 1
  %126 = load ptr, ptr %125, align 8, !tbaa !0
  %strcpy287 = call ptr @__polaron_str_copy(ptr %126)
  %127 = getelementptr inbounds %class.Snap, ptr %Snap.copy286, i32 0, i32 1
  store ptr %strcpy287, ptr %127, align 8, !tbaa !0
  store ptr %Snap.copy286, ptr %arr.elem276, align 8
  br label %for.update264

contract.fail295:                                 ; preds = %for.end265
  call void @__polaron_fail(ptr @.contract.1482, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont296:                                 ; preds = %for.end265
  ret void
}

define internal %__polaron_variant @"ArrayList$Snap.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1483, ptr @.faila.1484, i64 %10, ptr @.failb.1485, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1486, ptr @.faila.1487, i64 %15, ptr @.failb.1488, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %15
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %var.enc.p = ptrtoint ptr %elem22 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$Snap.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %Snap.copy = alloca %class.Snap, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1489, ptr @.faila.1490, i64 0, ptr @.failb.1491, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %9 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %11)
  %12 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %12, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %13 = icmp slt i32 %i10, %count12
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %15 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %15, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %16 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %16, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1492, ptr @.faila.1493, i64 %16, ptr @.failb.1494, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %16
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %19 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %20 = icmp slt i32 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %22 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %22, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %vcopy.done, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1495, ptr @.faila.1496, i64 %22, ptr @.failb.1497, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %22
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %23 = load ptr, ptr %best, align 8
  %24 = icmp eq ptr %elem36, %23
  br i1 %24, label %vcopy.done, label %vcopy

vcopy:                                            ; preds = %idx.ok33
  %25 = getelementptr inbounds %class.Snap, ptr %23, i32 0, i32 1
  %26 = load ptr, ptr %25, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %26)
  %27 = getelementptr inbounds %class.Snap, ptr %23, i32 0, i32 2
  %28 = call ptr @memcpy(ptr %23, ptr %elem36, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  br label %vcopy.done

vcopy.done:                                       ; preds = %vcopy, %idx.ok33
  br label %if.end26
}

define internal %__polaron_variant @"ArrayList$Snap.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %Snap.copy = alloca %class.Snap, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1498, ptr @.faila.1499, i64 0, ptr @.failb.1500, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %9 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %11)
  %12 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %12, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %13 = icmp slt i32 %i10, %count12
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %15 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %15, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %16 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %16, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %17 = load i32, ptr %i, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1501, ptr @.faila.1502, i64 %16, ptr @.failb.1503, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %16
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %19 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %20 = icmp sgt i32 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %22 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %22, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %vcopy.done, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1504, ptr @.faila.1505, i64 %22, ptr @.failb.1506, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %22
  %elem36 = load ptr, ptr %arr.elem35, align 8
  %23 = load ptr, ptr %best, align 8
  %24 = icmp eq ptr %elem36, %23
  br i1 %24, label %vcopy.done, label %vcopy

vcopy:                                            ; preds = %idx.ok33
  %25 = getelementptr inbounds %class.Snap, ptr %23, i32 0, i32 1
  %26 = load ptr, ptr %25, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %26)
  %27 = getelementptr inbounds %class.Snap, ptr %23, i32 0, i32 2
  %28 = call ptr @memcpy(ptr %23, ptr %elem36, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  br label %vcopy.done

vcopy.done:                                       ; preds = %vcopy, %idx.ok33
  br label %if.end26
}

define internal ptr @"ArrayList$Snap.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$Snap", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$Snap.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$Snap", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$Snap.ArrayListIterator$Snap"(ptr %"ArrayListIterator$Snap.obj", ptr %0)
  ret ptr %"ArrayListIterator$Snap.obj"
}

define internal void @"ArrayListIterator$Snap.ArrayListIterator$Snap"(ptr %0, ptr %1) {
entry:
  %"ArrayList$Snap.copy" = alloca %"class.ArrayList$Snap", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$Snap.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Snap", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$Snap", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  br label %arrdup.head

arrdup.head:                                      ; preds = %arrdup.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %17, %arrdup.cont ]
  %8 = icmp slt i64 %i, %arr.len
  br i1 %8, label %arrdup.body, label %arrdup.done

arrdup.body:                                      ; preds = %arrdup.head
  %9 = mul i64 %i, 8
  %10 = add i64 8, %9
  %11 = getelementptr i8, ptr %arr.copy, i64 %10
  %elem = load ptr, ptr %11, align 8
  %12 = icmp eq ptr %elem, null
  br i1 %12, label %arrdup.cont, label %arrdup.copy

arrdup.copy:                                      ; preds = %arrdup.body
  %Snap.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %13 = call ptr @memcpy(ptr %Snap.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %14 = getelementptr inbounds %class.Snap, ptr %elem, i32 0, i32 1
  %15 = load ptr, ptr %14, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %15)
  %16 = getelementptr inbounds %class.Snap, ptr %Snap.copy, i32 0, i32 1
  store ptr %strcpy, ptr %16, align 8, !tbaa !0
  store ptr %Snap.copy, ptr %11, align 8
  br label %arrdup.cont

arrdup.cont:                                      ; preds = %arrdup.copy, %arrdup.body
  %17 = add i64 %i, 1
  br label %arrdup.head

arrdup.done:                                      ; preds = %arrdup.head
  %18 = getelementptr inbounds %"class.ArrayList$Snap", ptr %"ArrayList$Snap.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %18, align 8, !tbaa !0
  store ptr %"ArrayList$Snap.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$Snap.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$Snap.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Snap", ptr null, i64 1) to i64))
  %19 = call ptr @memcpy(ptr %"ArrayList$Snap.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Snap", ptr null, i64 1) to i64))
  %20 = getelementptr inbounds %"class.ArrayList$Snap", ptr %list3, i32 0, i32 1
  %21 = load ptr, ptr %20, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %21, align 8
  %22 = mul i64 %arr.len5, 8
  %23 = add i64 8, %22
  %arr.copy6 = call ptr @__polaron_malloc(i64 %23)
  %24 = call ptr @memcpy(ptr %arr.copy6, ptr %21, i64 %23)
  br label %arrdup.head7

arrdup.head7:                                     ; preds = %arrdup.cont10, %arrdup.done
  %i12 = phi i64 [ 0, %arrdup.done ], [ %34, %arrdup.cont10 ]
  %25 = icmp slt i64 %i12, %arr.len5
  br i1 %25, label %arrdup.body8, label %arrdup.done11

arrdup.body8:                                     ; preds = %arrdup.head7
  %26 = mul i64 %i12, 8
  %27 = add i64 8, %26
  %28 = getelementptr i8, ptr %arr.copy6, i64 %27
  %elem13 = load ptr, ptr %28, align 8
  %29 = icmp eq ptr %elem13, null
  br i1 %29, label %arrdup.cont10, label %arrdup.copy9

arrdup.copy9:                                     ; preds = %arrdup.body8
  %Snap.copy14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %30 = call ptr @memcpy(ptr %Snap.copy14, ptr %elem13, i64 ptrtoint (ptr getelementptr (%class.Snap, ptr null, i64 1) to i64))
  %31 = getelementptr inbounds %class.Snap, ptr %elem13, i32 0, i32 1
  %32 = load ptr, ptr %31, align 8, !tbaa !0
  %strcpy15 = call ptr @__polaron_str_copy(ptr %32)
  %33 = getelementptr inbounds %class.Snap, ptr %Snap.copy14, i32 0, i32 1
  store ptr %strcpy15, ptr %33, align 8, !tbaa !0
  store ptr %Snap.copy14, ptr %28, align 8
  br label %arrdup.cont10

arrdup.cont10:                                    ; preds = %arrdup.copy9, %arrdup.body8
  %34 = add i64 %i12, 1
  br label %arrdup.head7

arrdup.done11:                                    ; preds = %arrdup.head7
  %35 = getelementptr inbounds %"class.ArrayList$Snap", ptr %"ArrayList$Snap.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %35, align 8, !tbaa !0
  store ptr %"ArrayList$Snap.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$Snap.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$Snap.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$Snap.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call ptr @"ArrayList$Snap.get"(ptr %list1, i32 %pos2)
  store ptr %1, ptr %value, align 8
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$Snap", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !4
  %value6 = load ptr, ptr %value, align 8
  ret ptr %value6
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1518)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1520)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5519)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5521)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

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
