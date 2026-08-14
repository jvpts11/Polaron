; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_field_after_ref.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/reflect_field_after_ref.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%ReflectType = type { ptr, i64, ptr, ptr, i64, ptr, i64, ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr }
%class.Nation = type { ptr, ptr, double, i32, i32, i32 }
%"class.ArrayList$Field" = type { ptr, ptr, i32 }
%ReflectField = type { ptr, ptr, ptr }
%__box = type { ptr, i64 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$Field" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Nation.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayListIterator$Field.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$Field.hasNext", ptr @"ArrayListIterator$Field.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$Field.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$Field.toArray", ptr @"ArrayList$Field.size", ptr @"ArrayList$Field.isEmpty", ptr null, ptr null, ptr null, ptr @"ArrayList$Field.get", ptr null, ptr null, ptr null, ptr @"ArrayList$Field.remove", ptr null, ptr null, ptr @"ArrayList$Field.add", ptr @"ArrayList$Field.ensureCapacity", ptr @"ArrayList$Field.set", ptr @"ArrayList$Field.indexOf", ptr @"ArrayList$Field.contains", ptr @"ArrayList$Field.removeAt", ptr @"ArrayList$Field.insertAt", ptr @"ArrayList$Field.clear", ptr @"ArrayList$Field.forEach", ptr @"ArrayList$Field.filter", ptr @"ArrayList$Field.any", ptr @"ArrayList$Field.all", ptr @"ArrayList$Field.count", ptr @"ArrayList$Field.sortedBy", ptr @"ArrayList$Field.mergeSortRange", ptr @"ArrayList$Field.find", ptr @"ArrayList$Field.min", ptr @"ArrayList$Field.max", ptr @"ArrayList$Field.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$Field.~ArrayList$Field"]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.strdata = private constant [5 x i8] c"Rome\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [7 x i8] c"Nation\00"
@.strobj.2 = private global %String { i64 6, ptr @.strdata.1, i64 0 }
@methods.Nation = private constant [0 x ptr] zeroinitializer
@.strdata.3 = private constant [5 x i8] c"name\00"
@.strobj.4 = private global %String { i64 4, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [6 x i8] c"ratio\00"
@.strobj.6 = private global %String { i64 5, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [5 x i8] c"capX\00"
@.strobj.8 = private global %String { i64 4, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [5 x i8] c"capY\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [10 x i8] c"leaderIdx\00"
@.strobj.12 = private global %String { i64 9, ptr @.strdata.11, i64 0 }
@fields.Nation = private constant [5 x ptr] [ptr @.strobj.4, ptr @.strobj.6, ptr @.strobj.8, ptr @.strobj.10, ptr @.strobj.12]
@annotations.Nation = private constant [0 x ptr] zeroinitializer
@methodfns.Nation = private constant [0 x ptr] zeroinitializer
@fieldget.Nation = private constant [5 x ptr] [ptr @__fget.Nation.name, ptr @__fget.Nation.ratio, ptr @__fget.Nation.capX, ptr @__fget.Nation.capY, ptr @__fget.Nation.leaderIdx]
@fieldset.Nation = private constant [5 x ptr] [ptr @__fset.Nation.name, ptr @__fset.Nation.ratio, ptr @__fset.Nation.capX, ptr @__fset.Nation.capY, ptr @__fset.Nation.leaderIdx]
@methodanncounts.Nation = private constant [0 x i64] zeroinitializer
@methodannptrs.Nation = private constant [0 x ptr] zeroinitializer
@methodrettags.Nation = private constant [0 x i64] zeroinitializer
@type.Nation = private constant %ReflectType { ptr @.strobj.2, i64 0, ptr @methods.Nation, ptr @methodfns.Nation, i64 5, ptr @fields.Nation, i64 ptrtoint (ptr getelementptr (%class.Nation, ptr null, i64 1) to i64), ptr @Nation.Nation, i64 0, ptr @annotations.Nation, ptr @fieldget.Nation, ptr @fieldset.Nation, ptr @methodanncounts.Nation, ptr @methodannptrs.Nation, ptr @methodrettags.Nation }
@.str = private unnamed_addr constant [30 x i8] c"capX=%d capY=%d leaderIdx=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.contract.1308 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.ArrayList$Field\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1309 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1310 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1311 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.ArrayList$Field\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1312 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Field.add\0A\00", align 1
@.faila.1313 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1314 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1315 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$Field.add\0A\00", align 1
@.faila.1316 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1317 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1318 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$Field.add\0A\00", align 1
@.faila.1319 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1320 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1321 = private unnamed_addr constant [123 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$Field.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1322 = private unnamed_addr constant [110 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1323 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1324 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1325 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1326 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Field.ensureCapacity\0A\00", align 1
@.faila.1327 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1328 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1329 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$Field.ensureCapacity\0A\00", align 1
@.faila.1330 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1331 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1332 = private unnamed_addr constant [121 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1333 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1334 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1335 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1336 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$Field.get\0A\00", align 1
@.faila.1337 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1338 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1339 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$Field.get\0A\00", align 1
@.faila.1340 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1341 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1342 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$Field.set\0A\00", align 1
@.faila.1343 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1344 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1345 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1346 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$Field.set\0A\00", align 1
@.faila.1347 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1348 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1349 = private unnamed_addr constant [127 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1350 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$Field.indexOf\0A\00", align 1
@.faila.1351 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1352 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1353 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$Field.removeAt\0A\00", align 1
@.faila.1354 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1355 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1356 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1357 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1358 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1359 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1360 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Field.removeAt\0A\00", align 1
@.faila.1361 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1362 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1363 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$Field.removeAt\0A\00", align 1
@.faila.1364 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1365 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1366 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1367 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1368 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1369 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1370 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$Field.insertAt\0A\00", align 1
@.faila.1371 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1372 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1373 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1374 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1375 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1376 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1377 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Field.insertAt\0A\00", align 1
@.faila.1378 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1379 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1380 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$Field.insertAt\0A\00", align 1
@.faila.1381 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1382 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1383 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Field.insertAt\0A\00", align 1
@.faila.1384 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1385 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1386 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$Field.insertAt\0A\00", align 1
@.faila.1387 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1388 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1389 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$Field.insertAt\0A\00", align 1
@.faila.1390 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1391 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1392 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1393 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1394 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1395 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1396 = private unnamed_addr constant [112 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1397 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1398 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1399 = private unnamed_addr constant [129 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1400 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Field.toArray\0A\00", align 1
@.faila.1401 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1402 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1403 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$Field.toArray\0A\00", align 1
@.faila.1404 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1405 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1406 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$Field.forEach\0A\00", align 1
@.faila.1407 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1408 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1409 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$Field.filter\0A\00", align 1
@.faila.1410 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1411 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1412 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$Field.filter\0A\00", align 1
@.faila.1413 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1414 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1415 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$Field.any\0A\00", align 1
@.faila.1416 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1417 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1418 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$Field.all\0A\00", align 1
@.faila.1419 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1420 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1421 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$Field.count\0A\00", align 1
@.faila.1422 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1423 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1424 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$Field.sortedBy\0A\00", align 1
@.faila.1425 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1426 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1427 = private unnamed_addr constant [115 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$Field.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1428 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1429 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1430 = private unnamed_addr constant [132 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1431 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1432 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1433 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1434 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1435 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1436 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1437 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1438 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1439 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1440 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1441 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1442 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1443 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1444 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1445 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1446 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1447 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1448 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1449 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1450 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1451 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1452 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1453 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1454 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1455 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1456 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1457 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1458 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1459 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1460 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1461 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1462 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1463 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1464 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1465 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1466 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1467 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1468 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1469 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1470 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1471 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1472 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1473 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1474 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1475 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1476 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1477 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1478 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1479 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1480 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1481 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1482 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1483 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1484 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1485 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1486 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1487 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1488 = private unnamed_addr constant [100 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$Field.mergeSortRange\0A\00", align 1
@.faila.1489 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1490 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1491 = private unnamed_addr constant [138 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$Field.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1492 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$Field.find\0A\00", align 1
@.faila.1493 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1494 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1495 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$Field.find\0A\00", align 1
@.faila.1496 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1497 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1498 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$Field.min\0A\00", align 1
@.faila.1499 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1500 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1501 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$Field.min\0A\00", align 1
@.faila.1502 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1503 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1504 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$Field.min\0A\00", align 1
@.faila.1505 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1506 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1507 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$Field.max\0A\00", align 1
@.faila.1508 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1509 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1510 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$Field.max\0A\00", align 1
@.faila.1511 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1512 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1513 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$Field.max\0A\00", align 1
@.faila.1514 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1515 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1526 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1527 = private global %String { i64 16, ptr @.strdata.1526, i64 0 }
@.strdata.1528 = private constant [17 x i8] c"division by zero\00"
@.strobj.1529 = private global %String { i64 16, ptr @.strdata.1528, i64 0 }
@.strdata.5527 = private constant [1 x i8] zeroinitializer
@.strobj.5528 = private global %String { i64 0, ptr @.strdata.5527, i64 0 }
@.strdata.5529 = private constant [1 x i8] zeroinitializer
@.strobj.5530 = private global %String { i64 0, ptr @.strdata.5529, i64 0 }

define internal void @Nation.Nation(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 0
  store ptr @Nation.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %name = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 1
  store ptr null, ptr %name, align 8, !tbaa !0
  %name1 = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 1
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj)
  %1 = load ptr, ptr %name1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr %name1, align 8, !tbaa !0
  %ratio = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 2
  store double 2.250000e+00, ptr %ratio, align 8, !tbaa !4
  %capX = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 3
  store i32 111, ptr %capX, align 4, !tbaa !6
  %capY = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 4
  store i32 222, ptr %capY, align 4, !tbaa !6
  %leaderIdx = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 5
  store i32 333, ptr %leaderIdx, align 4, !tbaa !6
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %leaderIdx = alloca i32, align 4
  %capY = alloca i32, align 4
  %capX = alloca i32, align 4
  %fs3 = alloca ptr, align 8
  %li = alloca i64, align 8
  %t = alloca ptr, align 8
  %n = alloca ptr, align 8
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
  %Nation.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Nation, ptr null, i64 1) to i64))
  call void @Nation.Nation(ptr %Nation.obj)
  store ptr %Nation.obj, ptr %n, align 8
  store ptr @type.Nation, ptr %t, align 8
  %t1 = load ptr, ptr %t, align 8
  %list = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Field", ptr null, i64 1) to i64))
  call void @"ArrayList$Field.ArrayList$Field"(ptr %list)
  %16 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 4
  %n2 = load i64, ptr %16, align 8
  %17 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 5
  %names = load ptr, ptr %17, align 8
  %18 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 10
  %fg = load ptr, ptr %18, align 8
  %19 = getelementptr inbounds %ReflectType, ptr %t1, i32 0, i32 11
  %fs = load ptr, ptr %19, align 8
  store i64 0, ptr %li, align 8
  br label %l.hdr

l.hdr:                                            ; preds = %l.body, %argv.end
  %i = load i64, ptr %li, align 8
  %20 = icmp slt i64 %i, %n2
  br i1 %20, label %l.body, label %l.done

l.body:                                           ; preds = %l.hdr
  %21 = getelementptr ptr, ptr %names, i64 %i
  %nm = load ptr, ptr %21, align 8
  %tok = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%ReflectField, ptr null, i64 1) to i64))
  %22 = getelementptr inbounds %ReflectField, ptr %tok, i32 0, i32 0
  store ptr %nm, ptr %22, align 8
  %23 = getelementptr inbounds %ReflectField, ptr %tok, i32 0, i32 1
  %24 = getelementptr ptr, ptr %fg, i64 %i
  %g = load ptr, ptr %24, align 8
  store ptr %g, ptr %23, align 8
  %25 = getelementptr inbounds %ReflectField, ptr %tok, i32 0, i32 2
  %26 = getelementptr ptr, ptr %fs, i64 %i
  %s = load ptr, ptr %26, align 8
  store ptr %s, ptr %25, align 8
  call void @"ArrayList$Field.add"(ptr %list, ptr %tok)
  %27 = add i64 %i, 1
  store i64 %27, ptr %li, align 8
  br label %l.hdr

l.done:                                           ; preds = %l.hdr
  store ptr %list, ptr %fs3, align 8
  %fs4 = load ptr, ptr %fs3, align 8
  %28 = call ptr @"ArrayList$Field.get"(ptr %fs4, i32 2)
  %n5 = load ptr, ptr %n, align 8
  %29 = getelementptr inbounds %ReflectField, ptr %28, i32 0, i32 1
  %f.get = load ptr, ptr %29, align 8
  %30 = call ptr %f.get(ptr %n5)
  %31 = getelementptr inbounds %__box, ptr %30, i32 0, i32 1
  %unbox = load i64, ptr %31, align 8
  %32 = trunc i64 %unbox to i32
  store i32 %32, ptr %capX, align 4
  %fs6 = load ptr, ptr %fs3, align 8
  %33 = call ptr @"ArrayList$Field.get"(ptr %fs6, i32 3)
  %n7 = load ptr, ptr %n, align 8
  %34 = getelementptr inbounds %ReflectField, ptr %33, i32 0, i32 1
  %f.get8 = load ptr, ptr %34, align 8
  %35 = call ptr %f.get8(ptr %n7)
  %36 = getelementptr inbounds %__box, ptr %35, i32 0, i32 1
  %unbox9 = load i64, ptr %36, align 8
  %37 = trunc i64 %unbox9 to i32
  store i32 %37, ptr %capY, align 4
  %fs10 = load ptr, ptr %fs3, align 8
  %38 = call ptr @"ArrayList$Field.get"(ptr %fs10, i32 4)
  %n11 = load ptr, ptr %n, align 8
  %39 = getelementptr inbounds %ReflectField, ptr %38, i32 0, i32 1
  %f.get12 = load ptr, ptr %39, align 8
  %40 = call ptr %f.get12(ptr %n11)
  %41 = getelementptr inbounds %__box, ptr %40, i32 0, i32 1
  %unbox13 = load i64, ptr %41, align 8
  %42 = trunc i64 %unbox13 to i32
  store i32 %42, ptr %leaderIdx, align 4
  %capX14 = load i32, ptr %capX, align 4
  %capY15 = load i32, ptr %capY, align 4
  %leaderIdx16 = load i32, ptr %leaderIdx, align 4
  %43 = call i32 (ptr, ...) @printf(ptr @.str, i32 %capX14, i32 %capY15, i32 %leaderIdx16)
  %n17 = load ptr, ptr %n, align 8
  call void @__polaron_check_live(ptr %n17)
  %vtbl.addr = getelementptr inbounds %class.Nation, ptr %n17, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %44 = icmp ne ptr %dtor.fn, null
  br i1 %44, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %l.done
  call void %dtor.fn(ptr %n17)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %l.done
  %name.sfree = getelementptr inbounds %class.Nation, ptr %n17, i32 0, i32 1
  %45 = load ptr, ptr %name.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %45)
  call void @__polaron_free(ptr %n17)
  ret i32 0
}

define internal void @"ArrayList$Field.ArrayList$Field"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$Field.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !6
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !6
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.1308, ptr @.cl.1309, i64 %contract.l, ptr @.cr.1310, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
  %data8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1311, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$Field.~ArrayList$Field"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"ArrayList$Field.add"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !6
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %7 = trunc i64 %len12 to i32
  %8 = icmp sge i32 %count9, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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

if.end:                                           ; preds = %for.end, %entry
  %data35 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %count37 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count38 = load i32, ptr %count37, align 4, !tbaa !6
  %16 = sext i32 %count38 to i64
  %arr.len39 = load i64, ptr %data36, align 8
  %arr.oob40 = icmp uge i64 %16, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !10

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !6
  %17 = icmp slt i32 %i16, %count18
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !8, !dereferenceable !9
  %i20 = load i32, ptr %i, align 4
  %19 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok28
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  call void @__polaron_free(ptr %data32)
  %data33 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %bigger34 = load ptr, ptr %bigger, align 8
  store ptr %bigger34, ptr %data33, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1312, ptr @.faila.1313, i64 %19, ptr @.failb.1314, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data21, i64 %19
  %data22 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i24 = load i32, ptr %i, align 4
  %22 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %22, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !10

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1315, ptr @.faila.1316, i64 %22, ptr @.failb.1317, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds ptr, ptr %arr.data29, i64 %22
  %elem = load ptr, ptr %arr.elem30, align 8
  store ptr %elem, ptr %arr.elem, align 8
  br label %for.update

idx.bad41:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1318, ptr @.faila.1319, i64 %16, ptr @.failb.1320, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %if.end
  %arr.data43 = getelementptr i8, ptr %data36, i64 8
  %arr.elem44 = getelementptr inbounds ptr, ptr %arr.data43, i64 %16
  %item45 = load ptr, ptr %item, align 8
  store ptr %item45, ptr %arr.elem44, align 8
  %count46 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count47 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count48 = load i32, ptr %count47, align 4, !tbaa !6
  %23 = add i32 %count48, 1
  store i32 %23, ptr %count46, align 4, !tbaa !6
  %count49 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count50 = load i32, ptr %count49, align 4, !tbaa !6
  %old51 = load i32, ptr %old, align 4
  %24 = add i32 %old51, 1
  %25 = icmp eq i32 %count50, %24
  %26 = zext i1 %25 to i32
  %contract.ok = icmp ne i32 %26, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok42
  call void @__polaron_fail(ptr @.contract.1321, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok42
  %count52 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !6
  %27 = icmp sge i32 %count53, 0
  %28 = zext i1 %27 to i32
  %contract.ok54 = icmp ne i32 %28, 0
  br i1 %contract.ok54, label %contract.cont56, label %contract.fail55

contract.fail55:                                  ; preds = %contract.cont
  %count57 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count58 = load i32, ptr %count57, align 4, !tbaa !6
  %contract.l = sext i32 %count58 to i64
  call void @__polaron_fail(ptr @.contract.1322, ptr @.cl.1323, i64 %contract.l, ptr @.cr.1324, i64 0, i32 1)
  unreachable

contract.cont56:                                  ; preds = %contract.cont
  %count59 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !6
  %data61 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data62 = load ptr, ptr %data61, align 8, !tbaa !0
  %len63 = load i64, ptr %data62, align 8
  %29 = trunc i64 %len63 to i32
  %30 = icmp sle i32 %count60, %29
  %31 = zext i1 %30 to i32
  %contract.ok64 = icmp ne i32 %31, 0
  br i1 %contract.ok64, label %contract.cont66, label %contract.fail65

contract.fail65:                                  ; preds = %contract.cont56
  call void @__polaron_fail(ptr @.contract.1325, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont66:                                  ; preds = %contract.cont56
  ret void
}

define internal void @"ArrayList$Field.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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

if.end:                                           ; preds = %for.end, %entry
  %count30 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !6
  %14 = icmp sge i32 %count31, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count13 = load i32, ptr %count12, align 4, !tbaa !6
  %16 = icmp slt i32 %i11, %count13
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger14 = load ptr, ptr %bigger, align 8, !nonnull !8, !dereferenceable !9
  %i15 = load i32, ptr %i, align 4
  %18 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %bigger14, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok23
  %19 = load i32, ptr %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data26 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  call void @__polaron_free(ptr %data27)
  %data28 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %bigger29 = load ptr, ptr %bigger, align 8
  store ptr %bigger29, ptr %data28, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1326, ptr @.faila.1327, i64 %18, ptr @.failb.1328, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1329, ptr @.faila.1330, i64 %21, ptr @.failb.1331, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %21
  %elem = load ptr, ptr %arr.elem25, align 8
  store ptr %elem, ptr %arr.elem, align 8
  br label %for.update

contract.fail:                                    ; preds = %if.end
  %count32 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count33 = load i32, ptr %count32, align 4, !tbaa !6
  %contract.l = sext i32 %count33 to i64
  call void @__polaron_fail(ptr @.contract.1332, ptr @.cl.1333, i64 %contract.l, ptr @.cr.1334, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count34 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count35 = load i32, ptr %count34, align 4, !tbaa !6
  %data36 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0
  %len38 = load i64, ptr %data37, align 8
  %22 = trunc i64 %len38 to i32
  %23 = icmp sle i32 %count35, %22
  %24 = zext i1 %23 to i32
  %contract.ok39 = icmp ne i32 %24, 0
  br i1 %contract.ok39, label %contract.cont41, label %contract.fail40

contract.fail40:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1335, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont41:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Field.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !6
  %9 = icmp sge i32 %i7, %count9
  %10 = zext i1 %9 to i32
  %sc.b = icmp ne i32 %10, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %11 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %data12 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !10

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1336, ptr @.faila.1337, i64 %13, ptr @.failb.1338, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1339, ptr @.faila.1340, i64 %14, ptr @.failb.1341, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 %14
  %elem24 = load ptr, ptr %arr.elem23, align 8
  ret ptr %elem24
}

define internal void @"ArrayList$Field.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store ptr %2, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !6
  %10 = icmp sge i32 %i7, %count9
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %data12 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

if.end:                                           ; preds = %sc.end
  %data21 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i23 = load i32, ptr %i, align 4
  %15 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %data22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !10

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1342, ptr @.faila.1343, i64 %14, ptr @.failb.1344, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %14
  %item15 = load ptr, ptr %item, align 8
  store ptr %item15, ptr %arr.elem, align 8
  %count16 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !6
  %data18 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0
  %len20 = load i64, ptr %data19, align 8
  %16 = trunc i64 %len20 to i32
  %17 = icmp sle i32 %count17, %16
  %18 = zext i1 %17 to i32
  %contract.ok = icmp ne i32 %18, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.1345, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1346, ptr @.faila.1347, i64 %15, ptr @.failb.1348, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %if.end
  %arr.data28 = getelementptr i8, ptr %data22, i64 8
  %arr.elem29 = getelementptr inbounds ptr, ptr %arr.data28, i64 %15
  %item30 = load ptr, ptr %item, align 8
  store ptr %item30, ptr %arr.elem29, align 8
  %count31 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !6
  %data33 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0
  %len35 = load i64, ptr %data34, align 8
  %19 = trunc i64 %len35 to i32
  %20 = icmp sle i32 %count32, %19
  %21 = zext i1 %20 to i32
  %contract.ok36 = icmp ne i32 %21, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.contract.1349, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %idx.ok27
  ret void
}

define internal i32 @"ArrayList$Field.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i11 = load i32, ptr %i, align 4
  %9 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1350, ptr @.faila.1351, i64 %9, ptr @.failb.1352, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  %item12 = load ptr, ptr %item, align 8
  %12 = icmp eq ptr %elem, %item12
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i13 = load i32, ptr %i, align 4
  ret i32 %i13

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$Field.contains"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %7 = call i32 @"ArrayList$Field.indexOf"(ptr %0, ptr %item6)
  %8 = icmp sge i32 %7, 0
  %9 = zext i1 %8 to i32
  ret i32 %9
}

define internal void @"ArrayList$Field.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !6
  %9 = icmp sge i32 %i7, %count9
  %10 = zext i1 %9 to i32
  %sc.b = icmp ne i32 %10, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %11 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %data12 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

if.end:                                           ; preds = %sc.end
  %i27 = load i32, ptr %i, align 4
  store i32 %i27, ptr %j, align 4
  br label %for.cond

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1353, ptr @.faila.1354, i64 %13, ptr @.failb.1355, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  store ptr %elem, ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !6
  %14 = icmp sge i32 %count16, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !6
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.1356, ptr @.cl.1357, i64 %contract.l, ptr @.cr.1358, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !6
  %data21 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %16 = trunc i64 %len23 to i32
  %17 = icmp sle i32 %count20, %16
  %18 = zext i1 %17 to i32
  %contract.ok24 = icmp ne i32 %18, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1359, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !6
  %19 = sub i32 %count30, 1
  %20 = icmp slt i32 %j28, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j33 = load i32, ptr %j, align 4
  %22 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %22, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !10

for.update:                                       ; preds = %idx.ok46
  %23 = load i32, ptr %j, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count50 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count51 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !6
  %25 = sub i32 %count52, 1
  store i32 %25, ptr %count50, align 4, !tbaa !6
  %count53 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count54 = load i32, ptr %count53, align 4, !tbaa !6
  %26 = icmp sge i32 %count54, 0
  %27 = zext i1 %26 to i32
  %contract.ok55 = icmp ne i32 %27, 0
  br i1 %contract.ok55, label %contract.cont57, label %contract.fail56

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1360, ptr @.faila.1361, i64 %22, ptr @.failb.1362, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %22
  %data40 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j42 = load i32, ptr %j, align 4
  %28 = add i32 %j42, 1
  %29 = sext i32 %28 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %29, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !10

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.1363, ptr @.faila.1364, i64 %29, ptr @.failb.1365, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %data41, i64 8
  %arr.elem48 = getelementptr inbounds ptr, ptr %arr.data47, i64 %29
  %elem49 = load ptr, ptr %arr.elem48, align 8
  store ptr %elem49, ptr %arr.elem39, align 8
  br label %for.update

contract.fail56:                                  ; preds = %for.end
  %count58 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count59 = load i32, ptr %count58, align 4, !tbaa !6
  %contract.l60 = sext i32 %count59 to i64
  call void @__polaron_fail(ptr @.contract.1366, ptr @.cl.1367, i64 %contract.l60, ptr @.cr.1368, i64 0, i32 1)
  unreachable

contract.cont57:                                  ; preds = %for.end
  %count61 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count62 = load i32, ptr %count61, align 4, !tbaa !6
  %data63 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !0
  %len65 = load i64, ptr %data64, align 8
  %30 = trunc i64 %len65 to i32
  %31 = icmp sle i32 %count62, %30
  %32 = zext i1 %31 to i32
  %contract.ok66 = icmp ne i32 %32, 0
  br i1 %contract.ok66, label %contract.cont68, label %contract.fail67

contract.fail67:                                  ; preds = %contract.cont57
  call void @__polaron_fail(ptr @.contract.1369, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont68:                                  ; preds = %contract.cont57
  ret void
}

define internal void @"ArrayList$Field.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, ptr %2) {
entry:
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca ptr, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store ptr %2, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !6
  %10 = icmp sgt i32 %i7, %count9
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %data12 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

if.end:                                           ; preds = %sc.end
  %count28 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !6
  %data30 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0
  %len32 = load i64, ptr %data31, align 8
  %15 = trunc i64 %len32 to i32
  %16 = icmp sge i32 %count29, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then33, label %if.end34

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1370, ptr @.faila.1371, i64 %14, ptr @.failb.1372, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %14
  %item15 = load ptr, ptr %item, align 8
  store ptr %item15, ptr %arr.elem, align 8
  %count16 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !6
  %18 = icmp sge i32 %count17, 0
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count18 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !6
  %contract.l = sext i32 %count19 to i64
  call void @__polaron_fail(ptr @.contract.1373, ptr @.cl.1374, i64 %contract.l, ptr @.cr.1375, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !6
  %data22 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0
  %len24 = load i64, ptr %data23, align 8
  %20 = trunc i64 %len24 to i32
  %21 = icmp sle i32 %count21, %20
  %22 = zext i1 %21 to i32
  %contract.ok25 = icmp ne i32 %22, 0
  br i1 %contract.ok25, label %contract.cont27, label %contract.fail26

contract.fail26:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1376, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont27:                                  ; preds = %contract.cont
  ret void

if.then33:                                        ; preds = %if.end
  %data35 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0
  %len37 = load i64, ptr %data36, align 8
  %23 = trunc i64 %len37 to i32
  %24 = mul i32 %23, 2
  %25 = sext i32 %24 to i64
  %26 = mul i64 %25, 8
  %27 = add i64 8, %26
  %arr = call ptr @__polaron_malloc(i64 %27)
  store i64 %25, ptr %arr, align 8
  %arr.data38 = getelementptr i8, ptr %arr, i64 8
  %28 = call ptr @memset(ptr %arr.data38, i32 0, i64 %26)
  store ptr %arr, ptr %bigger, align 8
  store i32 0, ptr %k, align 4
  br label %for.cond

if.end34:                                         ; preds = %for.end, %if.end
  %count63 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count64 = load i32, ptr %count63, align 4, !tbaa !6
  store i32 %count64, ptr %j, align 4
  br label %for.cond65

for.cond:                                         ; preds = %for.update, %if.then33
  %k39 = load i32, ptr %k, align 4
  %count40 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !6
  %29 = icmp slt i32 %k39, %count41
  %30 = zext i1 %29 to i32
  br i1 %29, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger42 = load ptr, ptr %bigger, align 8, !nonnull !8, !dereferenceable !9
  %k43 = load i32, ptr %k, align 4
  %31 = sext i32 %k43 to i64
  %arr.len44 = load i64, ptr %bigger42, align 8
  %arr.oob45 = icmp uge i64 %31, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !10

for.update:                                       ; preds = %idx.ok56
  %32 = load i32, ptr %k, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data59 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !0
  call void @__polaron_free(ptr %data60)
  %data61 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %bigger62 = load ptr, ptr %bigger, align 8
  store ptr %bigger62, ptr %data61, align 8, !tbaa !0
  br label %if.end34

idx.bad46:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1377, ptr @.faila.1378, i64 %31, ptr @.failb.1379, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body
  %arr.data48 = getelementptr i8, ptr %bigger42, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 %31
  %data50 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %k52 = load i32, ptr %k, align 4
  %34 = sext i32 %k52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %34, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !10

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.1380, ptr @.faila.1381, i64 %34, ptr @.failb.1382, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %data51, i64 8
  %arr.elem58 = getelementptr inbounds ptr, ptr %arr.data57, i64 %34
  %elem = load ptr, ptr %arr.elem58, align 8
  store ptr %elem, ptr %arr.elem49, align 8
  br label %for.update

for.cond65:                                       ; preds = %for.update67, %if.end34
  %j69 = load i32, ptr %j, align 4
  %i70 = load i32, ptr %i, align 4
  %35 = icmp sgt i32 %j69, %i70
  %36 = zext i1 %35 to i32
  br i1 %35, label %for.body66, label %for.end68

for.body66:                                       ; preds = %for.cond65
  %data71 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data72 = load ptr, ptr %data71, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j73 = load i32, ptr %j, align 4
  %37 = sext i32 %j73 to i64
  %arr.len74 = load i64, ptr %data72, align 8
  %arr.oob75 = icmp uge i64 %37, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !10

for.update67:                                     ; preds = %idx.ok86
  %38 = load i32, ptr %j, align 4
  %39 = sub i32 %38, 1
  store i32 %39, ptr %j, align 4
  br label %for.cond65

for.end68:                                        ; preds = %for.cond65
  %data90 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i92 = load i32, ptr %i, align 4
  %40 = sext i32 %i92 to i64
  %arr.len93 = load i64, ptr %data91, align 8
  %arr.oob94 = icmp uge i64 %40, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !10

idx.bad76:                                        ; preds = %for.body66
  call void @__polaron_fail(ptr @.fail.1383, ptr @.faila.1384, i64 %37, ptr @.failb.1385, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %for.body66
  %arr.data78 = getelementptr i8, ptr %data72, i64 8
  %arr.elem79 = getelementptr inbounds ptr, ptr %arr.data78, i64 %37
  %data80 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data81 = load ptr, ptr %data80, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j82 = load i32, ptr %j, align 4
  %41 = sub i32 %j82, 1
  %42 = sext i32 %41 to i64
  %arr.len83 = load i64, ptr %data81, align 8
  %arr.oob84 = icmp uge i64 %42, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !10

idx.bad85:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.1386, ptr @.faila.1387, i64 %42, ptr @.failb.1388, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok77
  %arr.data87 = getelementptr i8, ptr %data81, i64 8
  %arr.elem88 = getelementptr inbounds ptr, ptr %arr.data87, i64 %42
  %elem89 = load ptr, ptr %arr.elem88, align 8
  store ptr %elem89, ptr %arr.elem79, align 8
  br label %for.update67

idx.bad95:                                        ; preds = %for.end68
  call void @__polaron_fail(ptr @.fail.1389, ptr @.faila.1390, i64 %40, ptr @.failb.1391, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %for.end68
  %arr.data97 = getelementptr i8, ptr %data91, i64 8
  %arr.elem98 = getelementptr inbounds ptr, ptr %arr.data97, i64 %40
  %item99 = load ptr, ptr %item, align 8
  store ptr %item99, ptr %arr.elem98, align 8
  %count100 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count101 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count102 = load i32, ptr %count101, align 4, !tbaa !6
  %43 = add i32 %count102, 1
  store i32 %43, ptr %count100, align 4, !tbaa !6
  %count103 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count104 = load i32, ptr %count103, align 4, !tbaa !6
  %44 = icmp sge i32 %count104, 0
  %45 = zext i1 %44 to i32
  %contract.ok105 = icmp ne i32 %45, 0
  br i1 %contract.ok105, label %contract.cont107, label %contract.fail106

contract.fail106:                                 ; preds = %idx.ok96
  %count108 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count109 = load i32, ptr %count108, align 4, !tbaa !6
  %contract.l110 = sext i32 %count109 to i64
  call void @__polaron_fail(ptr @.contract.1392, ptr @.cl.1393, i64 %contract.l110, ptr @.cr.1394, i64 0, i32 1)
  unreachable

contract.cont107:                                 ; preds = %idx.ok96
  %count111 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count112 = load i32, ptr %count111, align 4, !tbaa !6
  %data113 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data114 = load ptr, ptr %data113, align 8, !tbaa !0
  %len115 = load i64, ptr %data114, align 8
  %46 = trunc i64 %len115 to i32
  %47 = icmp sle i32 %count112, %46
  %48 = zext i1 %47 to i32
  %contract.ok116 = icmp ne i32 %48, 0
  br i1 %contract.ok116, label %contract.cont118, label %contract.fail117

contract.fail117:                                 ; preds = %contract.cont107
  call void @__polaron_fail(ptr @.contract.1395, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont118:                                 ; preds = %contract.cont107
  ret void
}

define internal i32 @"ArrayList$Field.remove"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca ptr, align 8
  store ptr %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load ptr, ptr %item, align 8
  %7 = call i32 @"ArrayList$Field.indexOf"(ptr %0, ptr %item6)
  store i32 %7, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %8 = icmp slt i32 %i7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %i8 = load i32, ptr %i, align 4
  call void @"ArrayList$Field.removeAt"(ptr %0, i32 %i8)
  ret i32 1
}

define internal void @"ArrayList$Field.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !6
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !6
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.1396, ptr @.cl.1397, i64 %contract.l, ptr @.cr.1398, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !6
  %data13 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1399, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$Field.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
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
  %count9 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !6
  %10 = icmp slt i32 %i8, %count10
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out11 = load ptr, ptr %out, align 8, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %12 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %out11, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok20
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out23 = load ptr, ptr %out, align 8
  ret ptr %out23

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1400, ptr @.faila.1401, i64 %12, ptr @.failb.1402, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !10

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1403, ptr @.faila.1404, i64 %15, ptr @.failb.1405, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %15
  %elem = load ptr, ptr %arr.elem22, align 8
  store ptr %elem, ptr %arr.elem, align 8
  br label %for.update
}

define internal i32 @"ArrayList$Field.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
  ret i32 %count7
}

define internal i32 @"ArrayList$Field.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$Field.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1406, ptr @.faila.1407, i64 %10, ptr @.failb.1408, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  call void %code(ptr %env, ptr %elem)
  br label %for.update
}

define internal ptr @"ArrayList$Field.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Field.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Field", ptr null, i64 1) to i64))
  call void @"ArrayList$Field.ArrayList$Field"(ptr %"ArrayList$Field.obj")
  store ptr %"ArrayList$Field.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  call void @"ArrayList$Field.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !6
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i15 = load i32, ptr %i, align 4
  %10 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %data14, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out27 = load ptr, ptr %out, align 8
  ret ptr %out27

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1409, ptr @.faila.1410, i64 %10, ptr @.failb.1411, i64 %arr.len, i32 70)
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
  %data17 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !10

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1412, ptr @.faila.1413, i64 %15, ptr @.failb.1414, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds ptr, ptr %arr.data24, i64 %15
  %elem26 = load ptr, ptr %arr.elem25, align 8
  call void @"ArrayList$Field.add"(ptr %out16, ptr %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$Field.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1415, ptr @.faila.1416, i64 %10, ptr @.failb.1417, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Field.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1418, ptr @.faila.1419, i64 %10, ptr @.failb.1420, i64 %arr.len, i32 70)
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

define internal i32 @"ArrayList$Field.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %hits14 = load i32, ptr %hits, align 4
  ret i32 %hits14

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1421, ptr @.faila.1422, i64 %10, ptr @.failb.1423, i64 %arr.len, i32 70)
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

define internal ptr @"ArrayList$Field.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$Field.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Field", ptr null, i64 1) to i64))
  call void @"ArrayList$Field.ArrayList$Field"(ptr %"ArrayList$Field.obj")
  store ptr %"ArrayList$Field.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  call void @"ArrayList$Field.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !6
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %data14, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out16 = load ptr, ptr %out, align 8
  %12 = call i32 @"ArrayList$Field.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1424, ptr @.faila.1425, i64 %9, ptr @.failb.1426, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %9
  %elem = load ptr, ptr %arr.elem, align 8
  call void @"ArrayList$Field.add"(ptr %out12, ptr %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$Field.size"(ptr %out17)
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
  %20 = call i32 @"ArrayList$Field.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Field.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  call void @__polaron_free(ptr %scratch23)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  %out24 = load ptr, ptr %out, align 8
  %count25 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count26 = load i32, ptr %count25, align 4, !tbaa !6
  %22 = icmp sge i32 %count26, 0
  %23 = zext i1 %22 to i32
  %contract.ok = icmp ne i32 %23, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %if.end
  %count27 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !6
  %contract.l = sext i32 %count28 to i64
  call void @__polaron_fail(ptr @.contract.1427, ptr @.cl.1428, i64 %contract.l, ptr @.cr.1429, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count29 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !6
  %data31 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  %len33 = load i64, ptr %data32, align 8
  %24 = trunc i64 %len33 to i32
  %25 = icmp sle i32 %count30, %24
  %26 = zext i1 %25 to i32
  %contract.ok34 = icmp ne i32 %26, 0
  br i1 %contract.ok34, label %contract.cont36, label %contract.fail35

contract.fail35:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1430, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont36:                                  ; preds = %contract.cont
  ret ptr %out24
}

define internal void @"ArrayList$Field.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
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
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !6
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.1431, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data20 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok64
  %p68 = load i32, ptr %p, align 4
  %26 = add i32 %p68, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count69 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count70 = load i32, ptr %count69, align 4, !tbaa !6
  %data71 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data72 = load ptr, ptr %data71, align 8, !tbaa !0
  %len73 = load i64, ptr %data72, align 8
  %27 = trunc i64 %len73 to i32
  %28 = icmp sle i32 %count70, %27
  %29 = zext i1 %28 to i32
  %contract.ok74 = icmp ne i32 %29, 0
  br i1 %contract.ok74, label %contract.cont76, label %contract.fail75

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1432, ptr @.faila.1433, i64 %25, ptr @.failb.1434, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %25
  %elem = load ptr, ptr %arr.elem, align 8
  store ptr %elem, ptr %key, align 8
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
  %data38 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %q40 = load i32, ptr %q, align 4
  %33 = add i32 %q40, 1
  %34 = sext i32 %33 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %34, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !10

while.end:                                        ; preds = %sc.end
  %data58 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data59 = load ptr, ptr %data58, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %q60 = load i32, ptr %q, align 4
  %35 = add i32 %q60, 1
  %36 = sext i32 %35 to i64
  %arr.len61 = load i64, ptr %data59, align 8
  %arr.oob62 = icmp uge i64 %36, %arr.len61
  br i1 %arr.oob62, label %idx.bad63, label %idx.ok64, !prof !10

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %37 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %37, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %q29 = load i32, ptr %q, align 4
  %38 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %38, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !10

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %39 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1435, ptr @.faila.1436, i64 %38, ptr @.failb.1437, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1438, ptr @.faila.1439, i64 %34, ptr @.failb.1440, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %34
  %data47 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %q49 = load i32, ptr %q, align 4
  %43 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %43, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !10

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.1441, ptr @.faila.1442, i64 %43, ptr @.failb.1443, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %data48, i64 8
  %arr.elem55 = getelementptr inbounds ptr, ptr %arr.data54, i64 %43
  %elem56 = load ptr, ptr %arr.elem55, align 8
  store ptr %elem56, ptr %arr.elem46, align 8
  %q57 = load i32, ptr %q, align 4
  %44 = sub i32 %q57, 1
  store i32 %44, ptr %q, align 4
  br label %while.cond

idx.bad63:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.1444, ptr @.faila.1445, i64 %36, ptr @.failb.1446, i64 %arr.len61, i32 70)
  unreachable

idx.ok64:                                         ; preds = %while.end
  %arr.data65 = getelementptr i8, ptr %data59, i64 8
  %arr.elem66 = getelementptr inbounds ptr, ptr %arr.data65, i64 %36
  %key67 = load ptr, ptr %key, align 8
  store ptr %key67, ptr %arr.elem66, align 8
  br label %for.update

contract.fail75:                                  ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.1447, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @"ArrayList$Field.mergeSortRange"(ptr %0, ptr %tmp79, i32 %lo80, i32 %mid81, ptr %compare82)
  %tmp83 = load ptr, ptr %tmp, align 8
  %mid84 = load i32, ptr %mid, align 4
  %46 = add i32 %mid84, 1
  %hi85 = load i32, ptr %hi, align 4
  %compare86 = load ptr, ptr %compare, align 8
  call void @"ArrayList$Field.mergeSortRange"(ptr %0, ptr %tmp83, i32 %46, i32 %hi85, ptr %compare86)
  %compare87 = load ptr, ptr %compare, align 8
  %code88 = load ptr, ptr %compare87, align 8
  %47 = getelementptr ptr, ptr %compare87, i32 1
  %env89 = load ptr, ptr %47, align 8
  %data90 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %mid92 = load i32, ptr %mid, align 4
  %48 = sext i32 %mid92 to i64
  %arr.len93 = load i64, ptr %data91, align 8
  %arr.oob94 = icmp uge i64 %48, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !10

idx.bad95:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1448, ptr @.faila.1449, i64 %48, ptr @.failb.1450, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %div.ok
  %arr.data97 = getelementptr i8, ptr %data91, i64 8
  %arr.elem98 = getelementptr inbounds ptr, ptr %arr.data97, i64 %48
  %elem99 = load ptr, ptr %arr.elem98, align 8
  %data100 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data101 = load ptr, ptr %data100, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %mid102 = load i32, ptr %mid, align 4
  %49 = add i32 %mid102, 1
  %50 = sext i32 %49 to i64
  %arr.len103 = load i64, ptr %data101, align 8
  %arr.oob104 = icmp uge i64 %50, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !10

idx.bad105:                                       ; preds = %idx.ok96
  call void @__polaron_fail(ptr @.fail.1451, ptr @.faila.1452, i64 %50, ptr @.failb.1453, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %idx.ok96
  %arr.data107 = getelementptr i8, ptr %data101, i64 8
  %arr.elem108 = getelementptr inbounds ptr, ptr %arr.data107, i64 %50
  %elem109 = load ptr, ptr %arr.elem108, align 8
  %51 = call i32 %code88(ptr %env89, ptr %elem99, ptr %elem109)
  %52 = icmp sle i32 %51, 0
  %53 = zext i1 %52 to i32
  br i1 %52, label %if.then110, label %if.end111

if.then110:                                       ; preds = %idx.ok106
  %count112 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !6
  %data114 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.1454, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data138 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data139 = load ptr, ptr %data138, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i140 = load i32, ptr %i, align 4
  %61 = sext i32 %i140 to i64
  %arr.len141 = load i64, ptr %data139, align 8
  %arr.oob142 = icmp uge i64 %61, %arr.len141
  br i1 %arr.oob142, label %idx.bad143, label %idx.ok144, !prof !10

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
  call void @__polaron_fail(ptr @.fail.1455, ptr @.faila.1456, i64 %61, ptr @.failb.1457, i64 %arr.len141, i32 70)
  unreachable

idx.ok144:                                        ; preds = %while.body124
  %arr.data145 = getelementptr i8, ptr %data139, i64 8
  %arr.elem146 = getelementptr inbounds ptr, ptr %arr.data145, i64 %61
  %elem147 = load ptr, ptr %arr.elem146, align 8
  %data148 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data149 = load ptr, ptr %data148, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j150 = load i32, ptr %j, align 4
  %65 = sext i32 %j150 to i64
  %arr.len151 = load i64, ptr %data149, align 8
  %arr.oob152 = icmp uge i64 %65, %arr.len151
  br i1 %arr.oob152, label %idx.bad153, label %idx.ok154, !prof !10

idx.bad153:                                       ; preds = %idx.ok144
  call void @__polaron_fail(ptr @.fail.1458, ptr @.faila.1459, i64 %65, ptr @.failb.1460, i64 %arr.len151, i32 70)
  unreachable

idx.ok154:                                        ; preds = %idx.ok144
  %arr.data155 = getelementptr i8, ptr %data149, i64 8
  %arr.elem156 = getelementptr inbounds ptr, ptr %arr.data155, i64 %65
  %elem157 = load ptr, ptr %arr.elem156, align 8
  %66 = call i32 %code136(ptr %env137, ptr %elem147, ptr %elem157)
  %67 = icmp sle i32 %66, 0
  %68 = zext i1 %67 to i32
  br i1 %67, label %if.then158, label %if.else

if.then158:                                       ; preds = %idx.ok154
  %tmp160 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %k161 = load i32, ptr %k, align 4
  %69 = sext i32 %k161 to i64
  %arr.len162 = load i64, ptr %tmp160, align 8
  %arr.oob163 = icmp uge i64 %69, %arr.len162
  br i1 %arr.oob163, label %idx.bad164, label %idx.ok165, !prof !10

if.else:                                          ; preds = %idx.ok154
  %tmp179 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %k180 = load i32, ptr %k, align 4
  %70 = sext i32 %k180 to i64
  %arr.len181 = load i64, ptr %tmp179, align 8
  %arr.oob182 = icmp uge i64 %70, %arr.len181
  br i1 %arr.oob182, label %idx.bad183, label %idx.ok184, !prof !10

if.end159:                                        ; preds = %idx.ok193, %idx.ok174
  %k198 = load i32, ptr %k, align 4
  %71 = add i32 %k198, 1
  store i32 %71, ptr %k, align 4
  br label %while.cond123

idx.bad164:                                       ; preds = %if.then158
  call void @__polaron_fail(ptr @.fail.1461, ptr @.faila.1462, i64 %69, ptr @.failb.1463, i64 %arr.len162, i32 70)
  unreachable

idx.ok165:                                        ; preds = %if.then158
  %arr.data166 = getelementptr i8, ptr %tmp160, i64 8
  %arr.elem167 = getelementptr inbounds ptr, ptr %arr.data166, i64 %69
  %data168 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data169 = load ptr, ptr %data168, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i170 = load i32, ptr %i, align 4
  %72 = sext i32 %i170 to i64
  %arr.len171 = load i64, ptr %data169, align 8
  %arr.oob172 = icmp uge i64 %72, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !10

idx.bad173:                                       ; preds = %idx.ok165
  call void @__polaron_fail(ptr @.fail.1464, ptr @.faila.1465, i64 %72, ptr @.failb.1466, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %idx.ok165
  %arr.data175 = getelementptr i8, ptr %data169, i64 8
  %arr.elem176 = getelementptr inbounds ptr, ptr %arr.data175, i64 %72
  %elem177 = load ptr, ptr %arr.elem176, align 8
  store ptr %elem177, ptr %arr.elem167, align 8
  %i178 = load i32, ptr %i, align 4
  %73 = add i32 %i178, 1
  store i32 %73, ptr %i, align 4
  br label %if.end159

idx.bad183:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.1467, ptr @.faila.1468, i64 %70, ptr @.failb.1469, i64 %arr.len181, i32 70)
  unreachable

idx.ok184:                                        ; preds = %if.else
  %arr.data185 = getelementptr i8, ptr %tmp179, i64 8
  %arr.elem186 = getelementptr inbounds ptr, ptr %arr.data185, i64 %70
  %data187 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data188 = load ptr, ptr %data187, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j189 = load i32, ptr %j, align 4
  %74 = sext i32 %j189 to i64
  %arr.len190 = load i64, ptr %data188, align 8
  %arr.oob191 = icmp uge i64 %74, %arr.len190
  br i1 %arr.oob191, label %idx.bad192, label %idx.ok193, !prof !10

idx.bad192:                                       ; preds = %idx.ok184
  call void @__polaron_fail(ptr @.fail.1470, ptr @.faila.1471, i64 %74, ptr @.failb.1472, i64 %arr.len190, i32 70)
  unreachable

idx.ok193:                                        ; preds = %idx.ok184
  %arr.data194 = getelementptr i8, ptr %data188, i64 8
  %arr.elem195 = getelementptr inbounds ptr, ptr %arr.data194, i64 %74
  %elem196 = load ptr, ptr %arr.elem195, align 8
  store ptr %elem196, ptr %arr.elem186, align 8
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
  %tmp204 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %k205 = load i32, ptr %k, align 4
  %78 = sext i32 %k205 to i64
  %arr.len206 = load i64, ptr %tmp204, align 8
  %arr.oob207 = icmp uge i64 %78, %arr.len206
  br i1 %arr.oob207, label %idx.bad208, label %idx.ok209, !prof !10

while.end201:                                     ; preds = %while.cond199
  br label %while.cond224

idx.bad208:                                       ; preds = %while.body200
  call void @__polaron_fail(ptr @.fail.1473, ptr @.faila.1474, i64 %78, ptr @.failb.1475, i64 %arr.len206, i32 70)
  unreachable

idx.ok209:                                        ; preds = %while.body200
  %arr.data210 = getelementptr i8, ptr %tmp204, i64 8
  %arr.elem211 = getelementptr inbounds ptr, ptr %arr.data210, i64 %78
  %data212 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data213 = load ptr, ptr %data212, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i214 = load i32, ptr %i, align 4
  %79 = sext i32 %i214 to i64
  %arr.len215 = load i64, ptr %data213, align 8
  %arr.oob216 = icmp uge i64 %79, %arr.len215
  br i1 %arr.oob216, label %idx.bad217, label %idx.ok218, !prof !10

idx.bad217:                                       ; preds = %idx.ok209
  call void @__polaron_fail(ptr @.fail.1476, ptr @.faila.1477, i64 %79, ptr @.failb.1478, i64 %arr.len215, i32 70)
  unreachable

idx.ok218:                                        ; preds = %idx.ok209
  %arr.data219 = getelementptr i8, ptr %data213, i64 8
  %arr.elem220 = getelementptr inbounds ptr, ptr %arr.data219, i64 %79
  %elem221 = load ptr, ptr %arr.elem220, align 8
  store ptr %elem221, ptr %arr.elem211, align 8
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
  %tmp229 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %k230 = load i32, ptr %k, align 4
  %84 = sext i32 %k230 to i64
  %arr.len231 = load i64, ptr %tmp229, align 8
  %arr.oob232 = icmp uge i64 %84, %arr.len231
  br i1 %arr.oob232, label %idx.bad233, label %idx.ok234, !prof !10

while.end226:                                     ; preds = %while.cond224
  %lo249 = load i32, ptr %lo, align 4
  store i32 %lo249, ptr %t, align 4
  br label %for.cond250

idx.bad233:                                       ; preds = %while.body225
  call void @__polaron_fail(ptr @.fail.1479, ptr @.faila.1480, i64 %84, ptr @.failb.1481, i64 %arr.len231, i32 70)
  unreachable

idx.ok234:                                        ; preds = %while.body225
  %arr.data235 = getelementptr i8, ptr %tmp229, i64 8
  %arr.elem236 = getelementptr inbounds ptr, ptr %arr.data235, i64 %84
  %data237 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data238 = load ptr, ptr %data237, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %j239 = load i32, ptr %j, align 4
  %85 = sext i32 %j239 to i64
  %arr.len240 = load i64, ptr %data238, align 8
  %arr.oob241 = icmp uge i64 %85, %arr.len240
  br i1 %arr.oob241, label %idx.bad242, label %idx.ok243, !prof !10

idx.bad242:                                       ; preds = %idx.ok234
  call void @__polaron_fail(ptr @.fail.1482, ptr @.faila.1483, i64 %85, ptr @.failb.1484, i64 %arr.len240, i32 70)
  unreachable

idx.ok243:                                        ; preds = %idx.ok234
  %arr.data244 = getelementptr i8, ptr %data238, i64 8
  %arr.elem245 = getelementptr inbounds ptr, ptr %arr.data244, i64 %85
  %elem246 = load ptr, ptr %arr.elem245, align 8
  store ptr %elem246, ptr %arr.elem236, align 8
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
  %data256 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data257 = load ptr, ptr %data256, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %t258 = load i32, ptr %t, align 4
  %90 = sext i32 %t258 to i64
  %arr.len259 = load i64, ptr %data257, align 8
  %arr.oob260 = icmp uge i64 %90, %arr.len259
  br i1 %arr.oob260, label %idx.bad261, label %idx.ok262, !prof !10

for.update252:                                    ; preds = %idx.ok270
  %t274 = load i32, ptr %t, align 4
  %91 = add i32 %t274, 1
  store i32 %91, ptr %t, align 4
  br label %for.cond250

for.end253:                                       ; preds = %for.cond250
  %count275 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count276 = load i32, ptr %count275, align 4, !tbaa !6
  %data277 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data278 = load ptr, ptr %data277, align 8, !tbaa !0
  %len279 = load i64, ptr %data278, align 8
  %92 = trunc i64 %len279 to i32
  %93 = icmp sle i32 %count276, %92
  %94 = zext i1 %93 to i32
  %contract.ok280 = icmp ne i32 %94, 0
  br i1 %contract.ok280, label %contract.cont282, label %contract.fail281

idx.bad261:                                       ; preds = %for.body251
  call void @__polaron_fail(ptr @.fail.1485, ptr @.faila.1486, i64 %90, ptr @.failb.1487, i64 %arr.len259, i32 70)
  unreachable

idx.ok262:                                        ; preds = %for.body251
  %arr.data263 = getelementptr i8, ptr %data257, i64 8
  %arr.elem264 = getelementptr inbounds ptr, ptr %arr.data263, i64 %90
  %tmp265 = load ptr, ptr %tmp, align 8, !nonnull !8, !dereferenceable !9
  %t266 = load i32, ptr %t, align 4
  %95 = sext i32 %t266 to i64
  %arr.len267 = load i64, ptr %tmp265, align 8
  %arr.oob268 = icmp uge i64 %95, %arr.len267
  br i1 %arr.oob268, label %idx.bad269, label %idx.ok270, !prof !10

idx.bad269:                                       ; preds = %idx.ok262
  call void @__polaron_fail(ptr @.fail.1488, ptr @.faila.1489, i64 %95, ptr @.failb.1490, i64 %arr.len267, i32 70)
  unreachable

idx.ok270:                                        ; preds = %idx.ok262
  %arr.data271 = getelementptr i8, ptr %tmp265, i64 8
  %arr.elem272 = getelementptr inbounds ptr, ptr %arr.data271, i64 %95
  %elem273 = load ptr, ptr %arr.elem272, align 8
  store ptr %elem273, ptr %arr.elem264, align 8
  br label %for.update252

contract.fail281:                                 ; preds = %for.end253
  call void @__polaron_fail(ptr @.contract.1491, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont282:                                 ; preds = %for.end253
  ret void
}

define internal %__polaron_variant @"ArrayList$Field.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !6
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret %__polaron_variant { i32 1, i64 0 }

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1492, ptr @.faila.1493, i64 %10, ptr @.failb.1494, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %10
  %elem = load ptr, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, ptr %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !10

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1495, ptr @.faila.1496, i64 %15, ptr @.failb.1497, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %15
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %var.enc.p = ptrtoint ptr %elem22 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$Field.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1498, ptr @.faila.1499, i64 0, ptr @.failb.1500, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  store ptr %elem, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !6
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !10

for.update:                                       ; preds = %if.end26
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1501, ptr @.faila.1502, i64 %12, ptr @.failb.1503, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %12
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %15 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %16 = icmp slt i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i29 = load i32, ptr %i, align 4
  %18 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %18, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !10

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1504, ptr @.faila.1505, i64 %18, ptr @.failb.1506, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %18
  %elem36 = load ptr, ptr %arr.elem35, align 8
  store ptr %elem36, ptr %best, align 8
  br label %if.end26
}

define internal %__polaron_variant @"ArrayList$Field.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !6
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1507, ptr @.faila.1508, i64 0, ptr @.failb.1509, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  store ptr %elem, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !6
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !10

for.update:                                       ; preds = %if.end26
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load ptr, ptr %best, align 8
  %var.enc.p = ptrtoint ptr %best37 to i64
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.p, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1510, ptr @.faila.1511, i64 %12, ptr @.failb.1512, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds ptr, ptr %arr.data21, i64 %12
  %elem23 = load ptr, ptr %arr.elem22, align 8
  %best24 = load ptr, ptr %best, align 8
  %15 = call i32 %code(ptr %env, ptr %elem23, ptr %best24)
  %16 = icmp sgt i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i29 = load i32, ptr %i, align 4
  %18 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %18, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !10

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1513, ptr @.faila.1514, i64 %18, ptr @.failb.1515, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 %18
  %elem36 = load ptr, ptr %arr.elem35, align 8
  store ptr %elem36, ptr %best, align 8
  br label %if.end26
}

define internal ptr @"ArrayList$Field.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !6
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !6
  %data = getelementptr inbounds %"class.ArrayList$Field", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$Field.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$Field", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$Field.ArrayListIterator$Field"(ptr %"ArrayListIterator$Field.obj", ptr %0)
  ret ptr %"ArrayListIterator$Field.obj"
}

define internal void @"ArrayListIterator$Field.ArrayListIterator$Field"(ptr %0, ptr %1) {
entry:
  %"ArrayList$Field.copy" = alloca %"class.ArrayList$Field", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$Field.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Field", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$Field", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.ArrayList$Field", ptr %"ArrayList$Field.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %"ArrayList$Field.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$Field.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$Field.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Field", ptr null, i64 1) to i64))
  %9 = call ptr @memcpy(ptr %"ArrayList$Field.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$Field", ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %"class.ArrayList$Field", ptr %list3, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len5, 8
  %13 = add i64 8, %12
  %arr.copy6 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy6, ptr %11, i64 %13)
  %15 = getelementptr inbounds %"class.ArrayList$Field", ptr %"ArrayList$Field.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %15, align 8, !tbaa !0
  store ptr %"ArrayList$Field.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !6
  ret void
}

define internal i32 @"ArrayListIterator$Field.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !6
  %list = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$Field.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$Field.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !6
  %1 = call ptr @"ArrayList$Field.get"(ptr %list1, i32 %pos2)
  store ptr %1, ptr %value, align 8
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$Field", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !6
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !6
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1527)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1529)
  ret ptr %strcpy
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5528)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5530)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define private ptr @__fget.Nation.name(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 1
  %f.val = load ptr, ptr %f.addr, align 8, !tbaa !0
  ret ptr %f.val
}

define private void @__fset.Nation.name(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 1
  store ptr %1, ptr %f.addr, align 8, !tbaa !0
  ret void
}

define private ptr @__fget.Nation.ratio(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 2
  %f.val = load double, ptr %f.addr, align 8, !tbaa !4
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %1, align 8
  %2 = bitcast double %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Nation.ratio(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 2
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = bitcast i64 %unbox to double
  store double %3, ptr %f.addr, align 8, !tbaa !4
  ret void
}

define private ptr @__fget.Nation.capX(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 3
  %f.val = load i32, ptr %f.addr, align 4, !tbaa !6
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %1, align 8
  %2 = sext i32 %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Nation.capX(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 3
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = trunc i64 %unbox to i32
  store i32 %3, ptr %f.addr, align 4, !tbaa !6
  ret void
}

define private ptr @__fget.Nation.capY(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 4
  %f.val = load i32, ptr %f.addr, align 4, !tbaa !6
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %1, align 8
  %2 = sext i32 %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Nation.capY(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 4
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = trunc i64 %unbox to i32
  store i32 %3, ptr %f.addr, align 4, !tbaa !6
  ret void
}

define private ptr @__fget.Nation.leaderIdx(ptr %0) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 5
  %f.val = load i32, ptr %f.addr, align 4, !tbaa !6
  %box = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%__box, ptr null, i64 1) to i64))
  %1 = getelementptr inbounds %__box, ptr %box, i32 0, i32 0
  store ptr @Object.vtable, ptr %1, align 8
  %2 = sext i32 %f.val to i64
  %3 = getelementptr inbounds %__box, ptr %box, i32 0, i32 1
  store i64 %2, ptr %3, align 8
  ret ptr %box
}

define private void @__fset.Nation.leaderIdx(ptr %0, ptr %1) {
entry:
  %f.addr = getelementptr inbounds %class.Nation, ptr %0, i32 0, i32 5
  %2 = getelementptr inbounds %__box, ptr %1, i32 0, i32 1
  %unbox = load i64, ptr %2, align 8
  %3 = trunc i64 %unbox to i32
  store i32 %3, ptr %f.addr, align 4, !tbaa !6
  ret void
}

declare i32 @printf(ptr, ...)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"f64", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i32", !2, i64 0}
!8 = !{}
!9 = !{i64 8}
!10 = !{!"branch_weights", i32 1, i32 1048576}
