; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.ArrayList$String" = type { ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$String" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.IpcError = type { ptr, ptr }
%class.Exception = type { ptr }

@Test.fails = private global i32 0
@Test.criterion = private global ptr null
@Test.skipping = private global i32 0
@Test.skipWhy = private global ptr null
@NullReferenceException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @NullReferenceException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayListIterator$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$String.hasNext", ptr @"ArrayListIterator$String.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ClassCastException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ClassCastException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@UnimportedTypeException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @UnimportedTypeException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr @"ArrayList$String.toArray", ptr @"ArrayList$String.size", ptr @"ArrayList$String.isEmpty", ptr null, ptr null, ptr null, ptr @"ArrayList$String.get", ptr null, ptr null, ptr null, ptr @"ArrayList$String.remove", ptr null, ptr null, ptr @"ArrayList$String.add", ptr @"ArrayList$String.ensureCapacity", ptr @"ArrayList$String.set", ptr @"ArrayList$String.indexOf", ptr @"ArrayList$String.contains", ptr @"ArrayList$String.removeAt", ptr @"ArrayList$String.insertAt", ptr @"ArrayList$String.clear", ptr @"ArrayList$String.forEach", ptr @"ArrayList$String.filter", ptr @"ArrayList$String.any", ptr @"ArrayList$String.all", ptr @"ArrayList$String.count", ptr @"ArrayList$String.sortedBy", ptr @"ArrayList$String.mergeSortRange", ptr @"ArrayList$String.find", ptr @"ArrayList$String.min", ptr @"ArrayList$String.max", ptr @"ArrayList$String.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.~ArrayList$String"]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@BundleNotLoadedException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @BundleNotLoadedException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@BundleAbiMismatchException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @BundleAbiMismatchException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@OverflowException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @OverflowException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@IpcError.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @IpcError.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:19:25  in Parser.seeds\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:20:25  in Parser.seeds\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:21:25  in Parser.seeds\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [40 x i8] c"the seed stays inside the accepted band\00"
@.strobj = private global %String { i64 39, ptr @.strdata, i64 0 }
@.fail.7 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:35:25  in Parser.names\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.10 = private constant [6 x i8] c"alpha\00"
@.strobj.11 = private global %String { i64 5, ptr @.strdata.10, i64 0 }
@.fail.12 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:36:25  in Parser.names\0A\00", align 1
@.faila.13 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.14 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.15 = private constant [5 x i8] c"beta\00"
@.strobj.16 = private global %String { i64 4, ptr @.strdata.15, i64 0 }
@.strdata.17 = private constant [28 x i8] c"names arrive already folded\00"
@.strobj.18 = private global %String { i64 27, ptr @.strdata.17, i64 0 }
@.strdata.19 = private constant [33 x i8] c"the parser drops the inner quote\00"
@.strobj.20 = private global %String { i64 32, ptr @.strdata.19, i64 0 }
@.strdata.21 = private constant [28 x i8] c"a large input still adds up\00"
@.strobj.22 = private global %String { i64 27, ptr @.strdata.21, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.23 = private unnamed_addr constant [10 x i8] c"total: 42\00", align 1
@.str.24 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.25 = private unnamed_addr constant [10 x i8] c"errors: 0\00", align 1
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_0, ptr null]
@.strdata.26 = private constant [27 x i8] c"the report names its total\00"
@.strobj.27 = private global %String { i64 26, ptr @.strdata.26, i64 0 }
@.strdata.28 = private constant [10 x i8] c"total: 42\00"
@.strobj.29 = private global %String { i64 9, ptr @.strdata.28, i64 0 }
@.strdata.30 = private constant [20 x i8] c"and its error count\00"
@.strobj.31 = private global %String { i64 19, ptr @.strdata.30, i64 0 }
@.strdata.32 = private constant [10 x i8] c"errors: 0\00"
@.strobj.33 = private global %String { i64 9, ptr @.strdata.32, i64 0 }
@.strdata.34 = private constant [15 x i8] c"/report.golden\00"
@.strobj.35 = private global %String { i64 14, ptr @.strdata.34, i64 0 }
@.strdata.36 = private constant [30 x i8] c"landmasses: 5\0Amountains: 14%\0A\00"
@.strobj.37 = private global %String { i64 29, ptr @.strdata.36, i64 0 }
@.strdata.38 = private constant [21 x i8] c"matching text passes\00"
@.strobj.39 = private global %String { i64 20, ptr @.strdata.38, i64 0 }
@.strdata.40 = private constant [30 x i8] c"landmasses: 5\0Amountains: 14%\0A\00"
@.strobj.41 = private global %String { i64 29, ptr @.strdata.40, i64 0 }
@.strdata.42 = private constant [5 x i8] c"text\00"
@.strobj.43 = private global %String { i64 4, ptr @.strdata.42, i64 0 }
@.strdata.44 = private constant [15 x i8] c"mountain share\00"
@.strobj.45 = private global %String { i64 14, ptr @.strdata.44, i64 0 }
@.strdata.46 = private constant [9 x i8] c"mountain\00"
@.strobj.47 = private global %String { i64 8, ptr @.strdata.46, i64 0 }
@.strdata.48 = private constant [15 x i8] c"mountain share\00"
@.strobj.49 = private global %String { i64 14, ptr @.strdata.48, i64 0 }
@.strdata.50 = private constant [6 x i8] c"share\00"
@.strobj.51 = private global %String { i64 5, ptr @.strdata.50, i64 0 }
@.strdata.52 = private constant [15 x i8] c"mountain share\00"
@.strobj.53 = private global %String { i64 14, ptr @.strdata.52, i64 0 }
@.strdata.54 = private constant [6 x i8] c"in sh\00"
@.strobj.55 = private global %String { i64 5, ptr @.strdata.54, i64 0 }
@.strdata.56 = private constant [8 x i8] c"scalars\00"
@.strobj.57 = private global %String { i64 7, ptr @.strdata.56, i64 0 }
@.strdata.58 = private constant [7 x i8] c"arrays\00"
@.strobj.59 = private global %String { i64 6, ptr @.strdata.58, i64 0 }
@.fail.60 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:139:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.61 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.62 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.63 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:140:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.64 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.65 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.66 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:141:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.67 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.68 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.69 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:144:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.70 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.71 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.72 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:145:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.73 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.74 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.75 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:147:24  in Report.the_assertion_surface\0A\00", align 1
@.faila.76 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.77 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.78 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:148:24  in Report.the_assertion_surface\0A\00", align 1
@.faila.79 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.80 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.81 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:151:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.82 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.83 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.84 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:152:23  in Report.the_assertion_surface\0A\00", align 1
@.faila.85 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.86 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.87 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:154:24  in Report.the_assertion_surface\0A\00", align 1
@.faila.88 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.89 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.90 = private unnamed_addr constant [153 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/test_full.pol:155:24  in Report.the_assertion_surface\0A\00", align 1
@.faila.91 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.92 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.93 = private constant [11 x i8] c"exceptions\00"
@.strobj.94 = private global %String { i64 10, ptr @.strdata.93, i64 0 }
@__polaron_closure.95 = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_1, ptr null]
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.contract.1188 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1189 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1190 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1191 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1192 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1193 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1194 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1195 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1196 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1197 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1198 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$String.add\0A\00", align 1
@.faila.1199 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1200 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1201 = private unnamed_addr constant [124 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$String.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1202 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1203 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1204 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1205 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1206 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1207 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1208 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1209 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1210 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1211 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1212 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1213 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1214 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1215 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1216 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$String.get\0A\00", align 1
@.faila.1217 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1218 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1219 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$String.get\0A\00", align 1
@.faila.1220 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1221 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1222 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$String.set\0A\00", align 1
@.faila.1223 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1224 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1225 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1226 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$String.set\0A\00", align 1
@.faila.1227 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1228 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1229 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1230 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$String.indexOf\0A\00", align 1
@.faila.1231 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1232 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1233 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1234 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1235 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1236 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1237 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1238 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1239 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1240 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1241 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1242 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1243 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1244 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1245 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1246 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1247 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1248 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1249 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1250 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1251 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1252 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1253 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1254 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1255 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1256 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1257 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1258 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1259 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1260 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1261 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1262 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1263 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1264 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1265 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1266 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1267 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1268 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1269 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1270 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1271 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1272 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1273 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1274 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1275 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1276 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1277 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1278 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1279 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1280 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1281 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1282 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1283 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1284 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1285 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1286 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$String.forEach\0A\00", align 1
@.faila.1287 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1288 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1289 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$String.filter\0A\00", align 1
@.faila.1290 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1291 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1292 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$String.filter\0A\00", align 1
@.faila.1293 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1294 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1295 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$String.any\0A\00", align 1
@.faila.1296 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1297 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1298 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$String.all\0A\00", align 1
@.faila.1299 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1300 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1301 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$String.count\0A\00", align 1
@.faila.1302 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1303 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1304 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$String.sortedBy\0A\00", align 1
@.faila.1305 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1306 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1307 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1308 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1309 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1310 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1311 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1312 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1313 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1314 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1315 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1316 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1317 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1318 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1319 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1320 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1321 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1322 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1323 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1324 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1325 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1326 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1327 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1328 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1329 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1330 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1331 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1332 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1333 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1334 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1335 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1336 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1337 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1338 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1339 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1340 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1341 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1342 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1343 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1344 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1345 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1346 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1347 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1348 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1349 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1350 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1351 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1352 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1353 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1354 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1355 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1356 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1357 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1358 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1359 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1360 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1361 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1362 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1363 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1364 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1365 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1366 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1367 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1368 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1369 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1370 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1371 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1372 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$String.find\0A\00", align 1
@.faila.1373 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1374 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1375 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$String.find\0A\00", align 1
@.faila.1376 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1377 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1378 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$String.min\0A\00", align 1
@.faila.1379 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1380 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1381 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$String.min\0A\00", align 1
@.faila.1382 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1383 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1384 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$String.min\0A\00", align 1
@.faila.1385 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1386 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1387 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$String.max\0A\00", align 1
@.faila.1388 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1389 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1390 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$String.max\0A\00", align 1
@.faila.1391 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1392 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1393 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$String.max\0A\00", align 1
@.faila.1394 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1395 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1396 = private constant [20 x i8] c"type was unimported\00"
@.strobj.1397 = private global %String { i64 19, ptr @.strdata.1396, i64 0 }
@.strdata.1398 = private constant [18 x i8] c"bundle not loaded\00"
@.strobj.1399 = private global %String { i64 17, ptr @.strdata.1398, i64 0 }
@.strdata.1400 = private constant [20 x i8] c"bundle ABI mismatch\00"
@.strobj.1401 = private global %String { i64 19, ptr @.strdata.1400, i64 0 }
@.strdata.1402 = private constant [13 x i8] c"invalid cast\00"
@.strobj.1403 = private global %String { i64 12, ptr @.strdata.1402, i64 0 }
@.strdata.1404 = private constant [32 x i8] c"null where a value was asserted\00"
@.strobj.1405 = private global %String { i64 31, ptr @.strdata.1404, i64 0 }
@.strdata.1406 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1407 = private global %String { i64 16, ptr @.strdata.1406, i64 0 }
@.strdata.1408 = private constant [17 x i8] c"division by zero\00"
@.strobj.1409 = private global %String { i64 16, ptr @.strdata.1408, i64 0 }
@.strdata.1410 = private constant [17 x i8] c"integer overflow\00"
@.strobj.1411 = private global %String { i64 16, ptr @.strdata.1410, i64 0 }
@.strdata.5295 = private constant [1 x i8] zeroinitializer
@.strobj.5296 = private global %String { i64 0, ptr @.strdata.5295, i64 0 }
@.strdata.5297 = private constant [1 x i8] zeroinitializer
@.strobj.5298 = private global %String { i64 0, ptr @.strdata.5297, i64 0 }
@.str.5299 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5300 = private unnamed_addr constant [8 x i8] c"  [%s] \00", align 1
@.str.5301 = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.5302 = private unnamed_addr constant [3 x i8] c"  \00", align 1
@.str.5303 = private unnamed_addr constant [21 x i8] c"expected %d, got %d\0A\00", align 1
@.str.5304 = private unnamed_addr constant [26 x i8] c"expected anything but %d\0A\00", align 1
@.str.5306 = private unnamed_addr constant [21 x i8] c"expected %s, got %s\0A\00", align 1
@.str.5311 = private unnamed_addr constant [25 x i8] c"expected %d..%d, got %d\0A\00", align 1
@.str.5316 = private unnamed_addr constant [42 x i8] c"expected %f within %f (relative), got %f\0A\00", align 1
@.str.5317 = private unnamed_addr constant [32 x i8] c"expected to contain %s, got %s\0A\00", align 1
@.str.5318 = private unnamed_addr constant [35 x i8] c"expected to start with %s, got %s\0A\00", align 1
@.str.5319 = private unnamed_addr constant [33 x i8] c"expected to end with %s, got %s\0A\00", align 1
@.str.5320 = private unnamed_addr constant [21 x i8] c"expected %c, got %c\0A\00", align 1
@.str.5321 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.5322 = private unnamed_addr constant [22 x i8] c"boolean values differ\00", align 1
@.str.5323 = private unnamed_addr constant [21 x i8] c"expected %f, got %f\0A\00", align 1
@.str.5338 = private unnamed_addr constant [30 x i8] c"expected %d elements, got %d\0A\00", align 1
@.fail.5339 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9544:21  in Test.assertEqualLongArray\0A\00", align 1
@.faila.5340 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5341 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5342 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9544:21  in Test.assertEqualLongArray\0A\00", align 1
@.faila.5343 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5344 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.5345 = private unnamed_addr constant [46 x i8] c"differs at index %d: expected %lld, got %lld\0A\00", align 1
@.fail.5346 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9546:49  in Test.assertEqualLongArray\0A\00", align 1
@.faila.5347 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5348 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5349 = private unnamed_addr constant [96 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9546:49  in Test.assertEqualLongArray\0A\00", align 1
@.faila.5350 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5351 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.5366 = private unnamed_addr constant [30 x i8] c"expected %d elements, got %d\0A\00", align 1
@.fail.5367 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9585:21  in Test.assertEqualDoubleArray\0A\00", align 1
@.faila.5368 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5369 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5370 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9585:21  in Test.assertEqualDoubleArray\0A\00", align 1
@.faila.5371 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5372 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.5373 = private unnamed_addr constant [49 x i8] c"differs at index %d: expected %f +/- %f, got %f\0A\00", align 1
@.fail.5374 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9591:49  in Test.assertEqualDoubleArray\0A\00", align 1
@.faila.5375 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5376 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5377 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9591:49  in Test.assertEqualDoubleArray\0A\00", align 1
@.faila.5378 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5379 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5380 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9603:21  in Test.assertSorted\0A\00", align 1
@.faila.5381 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5382 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5383 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9603:21  in Test.assertSorted\0A\00", align 1
@.faila.5384 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5385 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.5386 = private unnamed_addr constant [39 x i8] c"not sorted at index %d: %d follows %d\0A\00", align 1
@.fail.5387 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9605:49  in Test.assertSorted\0A\00", align 1
@.faila.5388 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5389 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5390 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9605:49  in Test.assertSorted\0A\00", align 1
@.faila.5391 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5392 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str.5394 = private unnamed_addr constant [31 x i8] c"expected no exception, got %s\0A\00", align 1
@.strdata.5395 = private constant [14 x i8] c".pol-capture-\00"
@.strobj.5396 = private global %String { i64 13, ptr @.strdata.5395, i64 0 }
@.str.5397 = private unnamed_addr constant [21 x i8] c"  updated golden %s\0A\00", align 1
@.str.5398 = private unnamed_addr constant [58 x i8] c"no golden file %s; run with --update-golden to create it\0A\00", align 1
@.strdata.5399 = private constant [2 x i8] c"\0A\00"
@.strobj.5400 = private global %String { i64 1, ptr @.strdata.5399, i64 0 }
@.strdata.5401 = private constant [2 x i8] c"\0A\00"
@.strobj.5402 = private global %String { i64 1, ptr @.strdata.5401, i64 0 }
@.str.5403 = private unnamed_addr constant [57 x i8] c"%s differs at line %d\0A    expected: %s\0A    actual:   %s\0A\00", align 1
@.str.5404 = private unnamed_addr constant [25 x i8] c"%s has %d lines, got %d\0A\00", align 1
@.strdata.5406 = private constant [14 x i8] c".pol-test-tmp\00"
@.strobj.5407 = private global %String { i64 13, ptr @.strdata.5406, i64 0 }
@.strdata.5408 = private constant [1 x i8] zeroinitializer
@.strobj.5409 = private global %String { i64 0, ptr @.strdata.5408, i64 0 }
@.strdata.5410 = private constant [1 x i8] zeroinitializer
@.strobj.5411 = private global %String { i64 0, ptr @.strdata.5410, i64 0 }
@.test.name = private unnamed_addr constant [32 x i8] c"Parser.every_seed_lands_in_band\00", align 1
@.test.tags = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5415 = private unnamed_addr constant [31 x i8] c"Parser.every_name_is_lowercase\00", align 1
@.test.tags.5416 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5417 = private unnamed_addr constant [26 x i8] c"Parser.stable_across_runs\00", align 1
@.test.tags.5418 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5419 = private unnamed_addr constant [21 x i8] c"Parser.nested_quotes\00", align 1
@.test.tags.5420 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5421 = private unnamed_addr constant [19 x i8] c"Parser.large_input\00", align 1
@.test.tags.5422 = private unnamed_addr constant [5 x i8] c"slow\00", align 1
@.test.name.5423 = private unnamed_addr constant [32 x i8] c"Parser.every_seed_lands_in_band\00", align 1
@.test.name.5424 = private unnamed_addr constant [31 x i8] c"Parser.every_name_is_lowercase\00", align 1
@.test.name.5425 = private unnamed_addr constant [26 x i8] c"Parser.stable_across_runs\00", align 1
@.test.name.5426 = private unnamed_addr constant [21 x i8] c"Parser.nested_quotes\00", align 1
@.test.name.5427 = private unnamed_addr constant [19 x i8] c"Parser.large_input\00", align 1
@.test.name.5428 = private unnamed_addr constant [34 x i8] c"Report.printed_output_is_captured\00", align 1
@.test.tags.5429 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5430 = private unnamed_addr constant [30 x i8] c"Report.golden_file_comparison\00", align 1
@.test.tags.5431 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5432 = private unnamed_addr constant [29 x i8] c"Report.the_assertion_surface\00", align 1
@.test.tags.5433 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.test.name.5434 = private unnamed_addr constant [34 x i8] c"Report.printed_output_is_captured\00", align 1
@.test.name.5435 = private unnamed_addr constant [30 x i8] c"Report.golden_file_comparison\00", align 1
@.test.name.5436 = private unnamed_addr constant [29 x i8] c"Report.the_assertion_surface\00", align 1
@.bench.name = private unnamed_addr constant [21 x i8] c"Parser.summing_speed\00", align 1

define internal ptr @Parser.seeds() {
entry:
  %rows = alloca ptr, align 8
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 12)
  store ptr %arr, ptr %rows, align 8
  %rows1 = load ptr, ptr %rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %rows1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %rows1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data2, i64 0
  store i32 2, ptr %arr.elem, align 4
  %rows3 = load ptr, ptr %rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len4 = load i64, ptr %rows3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !2

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %rows3, i64 8
  %arr.elem9 = getelementptr inbounds i32, ptr %arr.data8, i64 1
  store i32 7, ptr %arr.elem9, align 4
  %rows10 = load ptr, ptr %rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len11 = load i64, ptr %rows10, align 8
  %arr.oob12 = icmp uge i64 2, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok7
  %arr.data15 = getelementptr i8, ptr %rows10, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 2
  store i32 11, ptr %arr.elem16, align 4
  %rows17 = load ptr, ptr %rows, align 8
  ret ptr %rows17
}

define internal void @Parser.every_seed_lands_in_band(i32 %0) {
entry:
  %seed = alloca i32, align 4
  store i32 %0, ptr %seed, align 4
  call void @Test.checking(ptr @.strobj)
  %seed1 = load i32, ptr %seed, align 4
  call void @Test.assertBetween(i32 %seed1, i32 1, i32 15)
  ret void
}

define internal ptr @Parser.names() {
entry:
  %rows = alloca ptr, align 8
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %rows, align 8
  %rows1 = load ptr, ptr %rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %rows1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 0, ptr @.failb.9, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %rows1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data2, i64 0
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.11)
  %1 = load ptr, ptr %arr.elem, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr %arr.elem, align 8
  %rows3 = load ptr, ptr %rows, align 8, !nonnull !0, !dereferenceable !1
  %arr.len4 = load i64, ptr %rows3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !2

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.12, ptr @.faila.13, i64 1, ptr @.failb.14, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %rows3, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 1
  %strcpy10 = call ptr @__polaron_str_copy(ptr @.strobj.16)
  %2 = load ptr, ptr %arr.elem9, align 8
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy10, ptr %arr.elem9, align 8
  %rows11 = load ptr, ptr %rows, align 8
  ret ptr %rows11
}

define internal void @Parser.every_name_is_lowercase(ptr %0) {
entry:
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  call void @Test.checking(ptr @.strobj.18)
  %name1 = load ptr, ptr %name, align 8
  %str.len = getelementptr inbounds %String, ptr %name1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.data = getelementptr inbounds %String, ptr %name1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %1 = call ptr @__polaron_str_lower(ptr %data, i64 %len)
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %2 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %len, ptr %2, align 8
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %1, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %4, align 8
  %name2 = load ptr, ptr %name, align 8
  call void @Test.assertEqualString(ptr %newstr, ptr %name2)
  call void @__polaron_str_free(ptr %newstr)
  ret void
}

define internal void @Parser.stable_across_runs() {
entry:
  call void @Test.assertEqual(i32 4, i32 4)
  ret void
}

define internal void @Parser.nested_quotes() {
entry:
  call void @Test.fail(ptr @.strobj.20)
  ret void
}

define internal void @Parser.large_input() {
entry:
  %i = alloca i32, align 4
  %total = alloca i32, align 4
  store i32 0, ptr %total, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %0 = icmp slt i32 %i1, 10000
  %1 = zext i1 %0 to i32
  br i1 %0, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %total2 = load i32, ptr %total, align 4
  %i3 = load i32, ptr %i, align 4
  %2 = add i32 %total2, %i3
  store i32 %2, ptr %total, align 4
  %i4 = load i32, ptr %i, align 4
  %3 = add i32 %i4, 1
  store i32 %3, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  call void @Test.checking(ptr @.strobj.22)
  %total5 = load i32, ptr %total, align 4
  call void @Test.assertEqual(i32 %total5, i32 49995000)
  ret void
}

define internal void @Parser.summing_speed() {
entry:
  %i = alloca i32, align 4
  %total = alloca i32, align 4
  store i32 0, ptr %total, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %0 = icmp slt i32 %i1, 100
  %1 = zext i1 %0 to i32
  br i1 %0, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %total2 = load i32, ptr %total, align 4
  %i3 = load i32, ptr %i, align 4
  %2 = add i32 %total2, %i3
  store i32 %2, ptr %total, align 4
  %i4 = load i32, ptr %i, align 4
  %3 = add i32 %i4, 1
  store i32 %3, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

define internal void @Report.printed_output_is_captured() {
entry:
  %out = alloca ptr, align 8
  %0 = call ptr @Test.captureOutput(ptr @__polaron_closure)
  %strcpy = call ptr @__polaron_str_copy(ptr %0)
  store ptr %strcpy, ptr %out, align 8
  call void @__polaron_str_free(ptr %0)
  call void @Test.checking(ptr @.strobj.27)
  %out1 = load ptr, ptr %out, align 8
  call void @Test.assertContains(ptr %out1, ptr @.strobj.29)
  call void @Test.checking(ptr @.strobj.31)
  %out2 = load ptr, ptr %out, align 8
  call void @Test.assertContains(ptr %out2, ptr @.strobj.33)
  %1 = load ptr, ptr %out, align 8
  call void @__polaron_str_free(ptr %1)
  ret void
}

define internal void @Report.golden_file_comparison() {
entry:
  %path = alloca ptr, align 8
  %0 = call ptr @Test.tempDir()
  %str.len = getelementptr inbounds %String, ptr %0, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len1 = load i64, ptr @.strobj.35, align 8
  %1 = add i64 %len, %len1
  %2 = add i64 %1, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %2)
  %str.data = getelementptr inbounds %String, ptr %0, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %3 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.35, i32 0, i32 1), align 8
  %4 = getelementptr i8, ptr %cat.buf, i64 %len
  %5 = call ptr @memcpy(ptr %4, ptr %data2, i64 %len1)
  %6 = getelementptr i8, ptr %cat.buf, i64 %1
  store i8 0, ptr %6, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %1, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %8, align 8
  %9 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %9, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %path, align 8
  call void @__polaron_str_free(ptr %0)
  call void @__polaron_str_free(ptr %newstr)
  %path3 = load ptr, ptr %path, align 8
  %str.data4 = getelementptr inbounds %String, ptr %path3, i32 0, i32 1
  %data5 = load ptr, ptr %str.data4, align 8
  %data6 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.37, i32 0, i32 1), align 8
  %len7 = load i64, ptr @.strobj.37, align 8
  %10 = call i32 @__polaron_file_write_all(ptr %data5, ptr %data6, i64 %len7, i32 0)
  call void @Test.checking(ptr @.strobj.39)
  %path8 = load ptr, ptr %path, align 8
  call void @Test.assertMatchesGolden(ptr @.strobj.41, ptr %path8)
  %11 = load ptr, ptr %path, align 8
  call void @__polaron_str_free(ptr %11)
  ret void
}

define internal void @Report.the_assertion_surface() {
entry:
  %ds2 = alloca ptr, align 8
  %ds = alloca ptr, align 8
  %ls2 = alloca ptr, align 8
  %ls = alloca ptr, align 8
  %xs = alloca ptr, align 8
  call void @Test.checking(ptr @.strobj.43)
  call void @Test.assertStartsWith(ptr @.strobj.45, ptr @.strobj.47)
  call void @Test.assertEndsWith(ptr @.strobj.49, ptr @.strobj.51)
  call void @Test.assertContains(ptr @.strobj.53, ptr @.strobj.55)
  call void @Test.checking(ptr @.strobj.57)
  call void @Test.assertEqualChar(i32 88, i32 88)
  call void @Test.assertEqualBoolean(i32 1, i32 1)
  call void @Test.assertEqualDouble(double 1.500000e+00, double 1.500000e+00)
  call void @Test.assertNear(double 0x3FEF5C28F5C28F5C, double 1.000000e+00, double 5.000000e-02)
  call void @Test.assertNotEqual(i32 7, i32 8)
  call void @Test.checking(ptr @.strobj.59)
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %0 = call ptr @memset(ptr %arr.data, i32 0, i64 12)
  store ptr %arr, ptr %xs, align 8
  %xs1 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %xs1, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.60, ptr @.faila.61, i64 0, ptr @.failb.62, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data2 = getelementptr i8, ptr %xs1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data2, i64 0
  store i32 1, ptr %arr.elem, align 4
  %xs3 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len4 = load i64, ptr %xs3, align 8
  %arr.oob5 = icmp uge i64 1, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !2

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.63, ptr @.faila.64, i64 1, ptr @.failb.65, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %xs3, i64 8
  %arr.elem9 = getelementptr inbounds i32, ptr %arr.data8, i64 1
  store i32 4, ptr %arr.elem9, align 4
  %xs10 = load ptr, ptr %xs, align 8, !nonnull !0, !dereferenceable !1
  %arr.len11 = load i64, ptr %xs10, align 8
  %arr.oob12 = icmp uge i64 2, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok7
  call void @__polaron_fail(ptr @.fail.66, ptr @.faila.67, i64 2, ptr @.failb.68, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok7
  %arr.data15 = getelementptr i8, ptr %xs10, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 2
  store i32 9, ptr %arr.elem16, align 4
  %xs17 = load ptr, ptr %xs, align 8
  call void @Test.assertSorted(ptr %xs17)
  %arr18 = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr18, align 8
  %arr.data19 = getelementptr i8, ptr %arr18, i64 8
  %1 = call ptr @memset(ptr %arr.data19, i32 0, i64 16)
  store ptr %arr18, ptr %ls, align 8
  %ls20 = load ptr, ptr %ls, align 8, !nonnull !0, !dereferenceable !1
  %arr.len21 = load i64, ptr %ls20, align 8
  %arr.oob22 = icmp uge i64 0, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

idx.bad23:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.69, ptr @.faila.70, i64 0, ptr @.failb.71, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok14
  %arr.data25 = getelementptr i8, ptr %ls20, i64 8
  %arr.elem26 = getelementptr inbounds i64, ptr %arr.data25, i64 0
  store i64 10, ptr %arr.elem26, align 8
  %ls27 = load ptr, ptr %ls, align 8, !nonnull !0, !dereferenceable !1
  %arr.len28 = load i64, ptr %ls27, align 8
  %arr.oob29 = icmp uge i64 1, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

idx.bad30:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.72, ptr @.faila.73, i64 1, ptr @.failb.74, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %idx.ok24
  %arr.data32 = getelementptr i8, ptr %ls27, i64 8
  %arr.elem33 = getelementptr inbounds i64, ptr %arr.data32, i64 1
  store i64 20, ptr %arr.elem33, align 8
  %arr34 = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr34, align 8
  %arr.data35 = getelementptr i8, ptr %arr34, i64 8
  %2 = call ptr @memset(ptr %arr.data35, i32 0, i64 16)
  store ptr %arr34, ptr %ls2, align 8
  %ls236 = load ptr, ptr %ls2, align 8, !nonnull !0, !dereferenceable !1
  %arr.len37 = load i64, ptr %ls236, align 8
  %arr.oob38 = icmp uge i64 0, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !2

idx.bad39:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.75, ptr @.faila.76, i64 0, ptr @.failb.77, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok31
  %arr.data41 = getelementptr i8, ptr %ls236, i64 8
  %arr.elem42 = getelementptr inbounds i64, ptr %arr.data41, i64 0
  store i64 10, ptr %arr.elem42, align 8
  %ls243 = load ptr, ptr %ls2, align 8, !nonnull !0, !dereferenceable !1
  %arr.len44 = load i64, ptr %ls243, align 8
  %arr.oob45 = icmp uge i64 1, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !2

idx.bad46:                                        ; preds = %idx.ok40
  call void @__polaron_fail(ptr @.fail.78, ptr @.faila.79, i64 1, ptr @.failb.80, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %idx.ok40
  %arr.data48 = getelementptr i8, ptr %ls243, i64 8
  %arr.elem49 = getelementptr inbounds i64, ptr %arr.data48, i64 1
  store i64 20, ptr %arr.elem49, align 8
  %ls50 = load ptr, ptr %ls, align 8
  %ls251 = load ptr, ptr %ls2, align 8
  call void @Test.assertEqualLongArray(ptr %ls50, ptr %ls251)
  %arr52 = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr52, align 8
  %arr.data53 = getelementptr i8, ptr %arr52, i64 8
  %3 = call ptr @memset(ptr %arr.data53, i32 0, i64 16)
  store ptr %arr52, ptr %ds, align 8
  %ds54 = load ptr, ptr %ds, align 8, !nonnull !0, !dereferenceable !1
  %arr.len55 = load i64, ptr %ds54, align 8
  %arr.oob56 = icmp uge i64 0, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !2

idx.bad57:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.81, ptr @.faila.82, i64 0, ptr @.failb.83, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok47
  %arr.data59 = getelementptr i8, ptr %ds54, i64 8
  %arr.elem60 = getelementptr inbounds double, ptr %arr.data59, i64 0
  store double 1.000000e+00, ptr %arr.elem60, align 8
  %ds61 = load ptr, ptr %ds, align 8, !nonnull !0, !dereferenceable !1
  %arr.len62 = load i64, ptr %ds61, align 8
  %arr.oob63 = icmp uge i64 1, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !2

idx.bad64:                                        ; preds = %idx.ok58
  call void @__polaron_fail(ptr @.fail.84, ptr @.faila.85, i64 1, ptr @.failb.86, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %idx.ok58
  %arr.data66 = getelementptr i8, ptr %ds61, i64 8
  %arr.elem67 = getelementptr inbounds double, ptr %arr.data66, i64 1
  store double 2.000000e+00, ptr %arr.elem67, align 8
  %arr68 = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %arr68, align 8
  %arr.data69 = getelementptr i8, ptr %arr68, i64 8
  %4 = call ptr @memset(ptr %arr.data69, i32 0, i64 16)
  store ptr %arr68, ptr %ds2, align 8
  %ds270 = load ptr, ptr %ds2, align 8, !nonnull !0, !dereferenceable !1
  %arr.len71 = load i64, ptr %ds270, align 8
  %arr.oob72 = icmp uge i64 0, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !2

idx.bad73:                                        ; preds = %idx.ok65
  call void @__polaron_fail(ptr @.fail.87, ptr @.faila.88, i64 0, ptr @.failb.89, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %idx.ok65
  %arr.data75 = getelementptr i8, ptr %ds270, i64 8
  %arr.elem76 = getelementptr inbounds double, ptr %arr.data75, i64 0
  store double 1.001000e+00, ptr %arr.elem76, align 8
  %ds277 = load ptr, ptr %ds2, align 8, !nonnull !0, !dereferenceable !1
  %arr.len78 = load i64, ptr %ds277, align 8
  %arr.oob79 = icmp uge i64 1, %arr.len78
  br i1 %arr.oob79, label %idx.bad80, label %idx.ok81, !prof !2

idx.bad80:                                        ; preds = %idx.ok74
  call void @__polaron_fail(ptr @.fail.90, ptr @.faila.91, i64 1, ptr @.failb.92, i64 %arr.len78, i32 70)
  unreachable

idx.ok81:                                         ; preds = %idx.ok74
  %arr.data82 = getelementptr i8, ptr %ds277, i64 8
  %arr.elem83 = getelementptr inbounds double, ptr %arr.data82, i64 1
  store double 1.999000e+00, ptr %arr.elem83, align 8
  %ds84 = load ptr, ptr %ds, align 8
  %ds285 = load ptr, ptr %ds2, align 8
  call void @Test.assertEqualDoubleArray(ptr %ds84, ptr %ds285, double 1.000000e-02)
  %xs86 = load ptr, ptr %xs, align 8
  call void @__polaron_free(ptr %xs86)
  %ls87 = load ptr, ptr %ls, align 8
  call void @__polaron_free(ptr %ls87)
  %ls288 = load ptr, ptr %ls2, align 8
  call void @__polaron_free(ptr %ls288)
  %ds89 = load ptr, ptr %ds, align 8
  call void @__polaron_free(ptr %ds89)
  %ds290 = load ptr, ptr %ds2, align 8
  call void @__polaron_free(ptr %ds290)
  call void @Test.checking(ptr @.strobj.94)
  call void @Test.assertDoesNotThrow(ptr @__polaron_closure.95)
  ret void
}

define internal void @"ArrayList$String.ArrayList$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$String.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !3
  %data1 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !3
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !7
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !7
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.1188, ptr @.cl.1189, i64 %contract.l, ptr @.cr.1190, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !3
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1191, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$String.~ArrayList$String"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3
  %len12 = load i64, ptr %data11, align 8
  %7 = trunc i64 %len12 to i32
  %8 = icmp sge i32 %count9, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !3
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
  %data37 = load ptr, ptr %data36, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %count38 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count39 = load i32, ptr %count38, align 4, !tbaa !7
  %16 = sext i32 %count39 to i64
  %arr.len40 = load i64, ptr %data37, align 8
  %arr.oob41 = icmp uge i64 %16, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !7
  %17 = icmp slt i32 %i16, %count18
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !0, !dereferenceable !1
  %i20 = load i32, ptr %i, align 4
  %19 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok28
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !3
  %ae.len = load i64, ptr %data32, align 8
  %arr.data33 = getelementptr i8, ptr %data32, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1192, ptr @.faila.1193, i64 %19, ptr @.failb.1194, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data21, i64 %19
  %data22 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i24 = load i32, ptr %i, align 4
  %22 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %22, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !2

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1195, ptr @.faila.1196, i64 %22, ptr @.failb.1197, i64 %arr.len25, i32 70)
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
  store ptr %bigger35, ptr %data34, align 8, !tbaa !3
  br label %if.end

idx.bad42:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1198, ptr @.faila.1199, i64 %16, ptr @.failb.1200, i64 %arr.len40, i32 70)
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
  %count50 = load i32, ptr %count49, align 4, !tbaa !7
  %28 = add i32 %count50, 1
  store i32 %28, ptr %count48, align 4, !tbaa !7
  %count51 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !7
  %old53 = load i32, ptr %old, align 4
  %29 = add i32 %old53, 1
  %30 = icmp eq i32 %count52, %29
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok43
  call void @__polaron_fail(ptr @.contract.1201, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok43
  %count54 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !7
  %32 = icmp sge i32 %count55, 0
  %33 = zext i1 %32 to i32
  %contract.ok56 = icmp ne i32 %33, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

contract.fail57:                                  ; preds = %contract.cont
  %count59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !7
  %contract.l = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.1202, ptr @.cl.1203, i64 %contract.l, ptr @.cr.1204, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %contract.cont
  %count61 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count62 = load i32, ptr %count61, align 4, !tbaa !7
  %data63 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !3
  %len65 = load i64, ptr %data64, align 8
  %34 = trunc i64 %len65 to i32
  %35 = icmp sle i32 %count62, %34
  %36 = zext i1 %35 to i32
  %contract.ok66 = icmp ne i32 %36, 0
  br i1 %contract.ok66, label %contract.cont68, label %contract.fail67

contract.fail67:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.1205, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data8 = load ptr, ptr %data7, align 8, !tbaa !3
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
  %count32 = load i32, ptr %count31, align 4, !tbaa !7
  %14 = icmp sge i32 %count32, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count13 = load i32, ptr %count12, align 4, !tbaa !7
  %16 = icmp slt i32 %i11, %count13
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger14 = load ptr, ptr %bigger, align 8, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %18 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %bigger14, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok23
  %19 = load i32, ptr %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data26 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !3
  %ae.len = load i64, ptr %data27, align 8
  %arr.data28 = getelementptr i8, ptr %data27, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1206, ptr @.faila.1207, i64 %18, ptr @.failb.1208, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1209, ptr @.faila.1210, i64 %21, ptr @.failb.1211, i64 %arr.len20, i32 70)
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
  store ptr %bigger30, ptr %data29, align 8, !tbaa !3
  br label %if.end

contract.fail:                                    ; preds = %if.end
  %count33 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !7
  %contract.l = sext i32 %count34 to i64
  call void @__polaron_fail(ptr @.contract.1212, ptr @.cl.1213, i64 %contract.l, ptr @.cr.1214, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count35 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !7
  %data37 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !3
  %len39 = load i64, ptr %data38, align 8
  %26 = trunc i64 %len39 to i32
  %27 = icmp sle i32 %count36, %26
  %28 = zext i1 %27 to i32
  %contract.ok40 = icmp ne i32 %28, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1215, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$String.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
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
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !3
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !2

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1216, ptr @.faila.1217, i64 %13, ptr @.failb.1218, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1219, ptr @.faila.1220, i64 %14, ptr @.failb.1221, i64 %arr.len18, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
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
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !3
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %sc.end
  %data21 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i23 = load i32, ptr %i, align 4
  %15 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %data22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1222, ptr @.faila.1223, i64 %14, ptr @.failb.1224, i64 %arr.len, i32 70)
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
  %count17 = load i32, ptr %count16, align 4, !tbaa !7
  %data18 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !3
  %len20 = load i64, ptr %data19, align 8
  %17 = trunc i64 %len20 to i32
  %18 = icmp sle i32 %count17, %17
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.1225, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1226, ptr @.faila.1227, i64 %15, ptr @.failb.1228, i64 %arr.len24, i32 70)
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
  %count33 = load i32, ptr %count32, align 4, !tbaa !7
  %data34 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data35 = load ptr, ptr %data34, align 8, !tbaa !3
  %len36 = load i64, ptr %data35, align 8
  %21 = trunc i64 %len36 to i32
  %22 = icmp sle i32 %count33, %21
  %23 = zext i1 %22 to i32
  %contract.ok37 = icmp ne i32 %23, 0
  br i1 %contract.ok37, label %contract.cont39, label %contract.fail38

contract.fail38:                                  ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.contract.1229, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i11 = load i32, ptr %i, align 4
  %9 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1230, ptr @.faila.1231, i64 %9, ptr @.failb.1232, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
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
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !3
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %sc.end
  %i27 = load i32, ptr %i, align 4
  store i32 %i27, ptr %j, align 4
  br label %for.cond

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1233, ptr @.faila.1234, i64 %13, ptr @.failb.1235, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !7
  %14 = icmp sge i32 %count16, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !7
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.1236, ptr @.cl.1237, i64 %contract.l, ptr @.cr.1238, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !7
  %data21 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !3
  %len23 = load i64, ptr %data22, align 8
  %16 = trunc i64 %len23 to i32
  %17 = icmp sle i32 %count20, %16
  %18 = zext i1 %17 to i32
  %contract.ok24 = icmp ne i32 %18, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1239, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  %19 = load ptr, ptr %oob, align 8
  call void @__polaron_str_free(ptr %19)
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !7
  %20 = sub i32 %count30, 1
  %21 = icmp slt i32 %j28, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j33 = load i32, ptr %j, align 4
  %23 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %23, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !2

for.update:                                       ; preds = %idx.ok46
  %24 = load i32, ptr %j, align 4
  %25 = add i32 %24, 1
  store i32 %25, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count51 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count52 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !7
  %26 = sub i32 %count53, 1
  store i32 %26, ptr %count51, align 4, !tbaa !7
  %count54 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !7
  %27 = icmp sge i32 %count55, 0
  %28 = zext i1 %27 to i32
  %contract.ok56 = icmp ne i32 %28, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1240, ptr @.faila.1241, i64 %23, ptr @.failb.1242, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %23
  %data40 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j42 = load i32, ptr %j, align 4
  %29 = add i32 %j42, 1
  %30 = sext i32 %29 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %30, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.1243, ptr @.faila.1244, i64 %30, ptr @.failb.1245, i64 %arr.len43, i32 70)
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
  %count60 = load i32, ptr %count59, align 4, !tbaa !7
  %contract.l61 = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.1246, ptr @.cl.1247, i64 %contract.l61, ptr @.cr.1248, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %for.end
  %count62 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count63 = load i32, ptr %count62, align 4, !tbaa !7
  %data64 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data65 = load ptr, ptr %data64, align 8, !tbaa !3
  %len66 = load i64, ptr %data65, align 8
  %32 = trunc i64 %len66 to i32
  %33 = icmp sle i32 %count63, %32
  %34 = zext i1 %33 to i32
  %contract.ok67 = icmp ne i32 %34, 0
  br i1 %contract.ok67, label %contract.cont69, label %contract.fail68

contract.fail68:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.1249, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
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
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !3
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

if.end:                                           ; preds = %sc.end
  %count28 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !7
  %data30 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !3
  %len32 = load i64, ptr %data31, align 8
  %15 = trunc i64 %len32 to i32
  %16 = icmp sge i32 %count29, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then33, label %if.end34

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1250, ptr @.faila.1251, i64 %14, ptr @.failb.1252, i64 %arr.len, i32 70)
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
  %count17 = load i32, ptr %count16, align 4, !tbaa !7
  %19 = icmp sge i32 %count17, 0
  %20 = zext i1 %19 to i32
  %contract.ok = icmp ne i32 %20, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count18 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !7
  %contract.l = sext i32 %count19 to i64
  call void @__polaron_fail(ptr @.contract.1253, ptr @.cl.1254, i64 %contract.l, ptr @.cr.1255, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !7
  %data22 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !3
  %len24 = load i64, ptr %data23, align 8
  %21 = trunc i64 %len24 to i32
  %22 = icmp sle i32 %count21, %21
  %23 = zext i1 %22 to i32
  %contract.ok25 = icmp ne i32 %23, 0
  br i1 %contract.ok25, label %contract.cont27, label %contract.fail26

contract.fail26:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1256, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont27:                                  ; preds = %contract.cont
  ret void

if.then33:                                        ; preds = %if.end
  %data35 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !3
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
  %count66 = load i32, ptr %count65, align 4, !tbaa !7
  store i32 %count66, ptr %j, align 4
  br label %for.cond67

for.cond:                                         ; preds = %for.update, %if.then33
  %k39 = load i32, ptr %k, align 4
  %count40 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !7
  %30 = icmp slt i32 %k39, %count41
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger42 = load ptr, ptr %bigger, align 8, !nonnull !0, !dereferenceable !1
  %k43 = load i32, ptr %k, align 4
  %32 = sext i32 %k43 to i64
  %arr.len44 = load i64, ptr %bigger42, align 8
  %arr.oob45 = icmp uge i64 %32, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !2

for.update:                                       ; preds = %idx.ok56
  %33 = load i32, ptr %k, align 4
  %34 = add i32 %33, 1
  store i32 %34, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data60 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data61 = load ptr, ptr %data60, align 8, !tbaa !3
  %ae.len = load i64, ptr %data61, align 8
  %arr.data62 = getelementptr i8, ptr %data61, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad46:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1257, ptr @.faila.1258, i64 %32, ptr @.failb.1259, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body
  %arr.data48 = getelementptr i8, ptr %bigger42, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 %32
  %data50 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %k52 = load i32, ptr %k, align 4
  %35 = sext i32 %k52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %35, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !2

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.1260, ptr @.faila.1261, i64 %35, ptr @.failb.1262, i64 %arr.len53, i32 70)
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
  store ptr %bigger64, ptr %data63, align 8, !tbaa !3
  br label %if.end34

for.cond67:                                       ; preds = %for.update69, %if.end34
  %j71 = load i32, ptr %j, align 4
  %i72 = load i32, ptr %i, align 4
  %40 = icmp sgt i32 %j71, %i72
  %41 = zext i1 %40 to i32
  br i1 %40, label %for.body68, label %for.end70

for.body68:                                       ; preds = %for.cond67
  %data73 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j75 = load i32, ptr %j, align 4
  %42 = sext i32 %j75 to i64
  %arr.len76 = load i64, ptr %data74, align 8
  %arr.oob77 = icmp uge i64 %42, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !2

for.update69:                                     ; preds = %idx.ok88
  %43 = load i32, ptr %j, align 4
  %44 = sub i32 %43, 1
  store i32 %44, ptr %j, align 4
  br label %for.cond67

for.end70:                                        ; preds = %for.cond67
  %data93 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data94 = load ptr, ptr %data93, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i95 = load i32, ptr %i, align 4
  %45 = sext i32 %i95 to i64
  %arr.len96 = load i64, ptr %data94, align 8
  %arr.oob97 = icmp uge i64 %45, %arr.len96
  br i1 %arr.oob97, label %idx.bad98, label %idx.ok99, !prof !2

idx.bad78:                                        ; preds = %for.body68
  call void @__polaron_fail(ptr @.fail.1263, ptr @.faila.1264, i64 %42, ptr @.failb.1265, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %for.body68
  %arr.data80 = getelementptr i8, ptr %data74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %42
  %data82 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data83 = load ptr, ptr %data82, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j84 = load i32, ptr %j, align 4
  %46 = sub i32 %j84, 1
  %47 = sext i32 %46 to i64
  %arr.len85 = load i64, ptr %data83, align 8
  %arr.oob86 = icmp uge i64 %47, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !2

idx.bad87:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.1266, ptr @.faila.1267, i64 %47, ptr @.failb.1268, i64 %arr.len85, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1269, ptr @.faila.1270, i64 %45, ptr @.failb.1271, i64 %arr.len96, i32 70)
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
  %count106 = load i32, ptr %count105, align 4, !tbaa !7
  %50 = add i32 %count106, 1
  store i32 %50, ptr %count104, align 4, !tbaa !7
  %count107 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count108 = load i32, ptr %count107, align 4, !tbaa !7
  %51 = icmp sge i32 %count108, 0
  %52 = zext i1 %51 to i32
  %contract.ok109 = icmp ne i32 %52, 0
  br i1 %contract.ok109, label %contract.cont111, label %contract.fail110

contract.fail110:                                 ; preds = %idx.ok99
  %count112 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !7
  %contract.l114 = sext i32 %count113 to i64
  call void @__polaron_fail(ptr @.contract.1272, ptr @.cl.1273, i64 %contract.l114, ptr @.cr.1274, i64 0, i32 1)
  unreachable

contract.cont111:                                 ; preds = %idx.ok99
  %count115 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count116 = load i32, ptr %count115, align 4, !tbaa !7
  %data117 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data118 = load ptr, ptr %data117, align 8, !tbaa !3
  %len119 = load i64, ptr %data118, align 8
  %53 = trunc i64 %len119 to i32
  %54 = icmp sle i32 %count116, %53
  %55 = zext i1 %54 to i32
  %contract.ok120 = icmp ne i32 %55, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont111
  call void @__polaron_fail(ptr @.contract.1275, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !7
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !7
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.1276, ptr @.cl.1277, i64 %contract.l, ptr @.cr.1278, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !7
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !3
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1279, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$String.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
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
  %count10 = load i32, ptr %count9, align 4, !tbaa !7
  %10 = icmp slt i32 %i8, %count10
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out11 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %12 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %out11, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok20
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out23 = load ptr, ptr %out, align 8
  ret ptr %out23

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1280, ptr @.faila.1281, i64 %12, ptr @.failb.1282, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1283, ptr @.faila.1284, i64 %15, ptr @.failb.1285, i64 %arr.len17, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
  ret i32 %count7
}

define internal i32 @"ArrayList$String.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
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
  call void @__polaron_fail(ptr @.fail.1286, ptr @.faila.1287, i64 %10, ptr @.failb.1288, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  call void @"ArrayList$String.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !7
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %10 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %data14, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out27 = load ptr, ptr %out, align 8
  ret ptr %out27

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1289, ptr @.faila.1290, i64 %10, ptr @.failb.1291, i64 %arr.len, i32 70)
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
  %data18 = load ptr, ptr %data17, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !2

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1292, ptr @.faila.1293, i64 %15, ptr @.failb.1294, i64 %arr.len20, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1295, ptr @.faila.1296, i64 %10, ptr @.failb.1297, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1298, ptr @.faila.1299, i64 %10, ptr @.failb.1300, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %hits14 = load i32, ptr %hits, align 4
  ret i32 %hits14

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1301, ptr @.faila.1302, i64 %10, ptr @.failb.1303, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  call void @"ArrayList$String.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !7
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %9 = sext i32 %i15 to i64
  %arr.len = load i64, ptr %data14, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

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
  call void @__polaron_fail(ptr @.fail.1304, ptr @.faila.1305, i64 %9, ptr @.failb.1306, i64 %arr.len, i32 70)
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
  %count27 = load i32, ptr %count26, align 4, !tbaa !7
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
  %count29 = load i32, ptr %count28, align 4, !tbaa !7
  %contract.l = sext i32 %count29 to i64
  call void @__polaron_fail(ptr @.contract.1307, ptr @.cl.1308, i64 %contract.l, ptr @.cr.1309, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count30 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !7
  %data32 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !3
  %len34 = load i64, ptr %data33, align 8
  %27 = trunc i64 %len34 to i32
  %28 = icmp sle i32 %count31, %27
  %29 = zext i1 %28 to i32
  %contract.ok35 = icmp ne i32 %29, 0
  br i1 %contract.ok35, label %contract.cont37, label %contract.fail36

contract.fail36:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1310, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count9 = load i32, ptr %count8, align 4, !tbaa !7
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3
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
  call void @__polaron_fail(ptr @.contract.1311, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data21 = load ptr, ptr %data20, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok65
  %p70 = load i32, ptr %p, align 4
  %26 = add i32 %p70, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count71 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count72 = load i32, ptr %count71, align 4, !tbaa !7
  %data73 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !3
  %len75 = load i64, ptr %data74, align 8
  %27 = trunc i64 %len75 to i32
  %28 = icmp sle i32 %count72, %27
  %29 = zext i1 %28 to i32
  %contract.ok76 = icmp ne i32 %29, 0
  br i1 %contract.ok76, label %contract.cont78, label %contract.fail77

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1312, ptr @.faila.1313, i64 %25, ptr @.failb.1314, i64 %arr.len, i32 70)
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
  %data39 = load ptr, ptr %data38, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %q40 = load i32, ptr %q, align 4
  %33 = add i32 %q40, 1
  %34 = sext i32 %33 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %34, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !2

while.end:                                        ; preds = %sc.end
  %data59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %q61 = load i32, ptr %q, align 4
  %35 = add i32 %q61, 1
  %36 = sext i32 %35 to i64
  %arr.len62 = load i64, ptr %data60, align 8
  %arr.oob63 = icmp uge i64 %36, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !2

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %37 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %37, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %q29 = load i32, ptr %q, align 4
  %38 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %38, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %39 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1315, ptr @.faila.1316, i64 %38, ptr @.failb.1317, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1318, ptr @.faila.1319, i64 %34, ptr @.failb.1320, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %34
  %data47 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %q49 = load i32, ptr %q, align 4
  %43 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %43, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !2

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.1321, ptr @.faila.1322, i64 %43, ptr @.failb.1323, i64 %arr.len50, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1324, ptr @.faila.1325, i64 %36, ptr @.failb.1326, i64 %arr.len62, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1327, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data93 = load ptr, ptr %data92, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %mid94 = load i32, ptr %mid, align 4
  %51 = sext i32 %mid94 to i64
  %arr.len95 = load i64, ptr %data93, align 8
  %arr.oob96 = icmp uge i64 %51, %arr.len95
  br i1 %arr.oob96, label %idx.bad97, label %idx.ok98, !prof !2

idx.bad97:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1328, ptr @.faila.1329, i64 %51, ptr @.failb.1330, i64 %arr.len95, i32 70)
  unreachable

idx.ok98:                                         ; preds = %div.ok
  %arr.data99 = getelementptr i8, ptr %data93, i64 8
  %arr.elem100 = getelementptr inbounds ptr, ptr %arr.data99, i64 %51
  %elem101 = load ptr, ptr %arr.elem100, align 8
  %data102 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data103 = load ptr, ptr %data102, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %mid104 = load i32, ptr %mid, align 4
  %52 = add i32 %mid104, 1
  %53 = sext i32 %52 to i64
  %arr.len105 = load i64, ptr %data103, align 8
  %arr.oob106 = icmp uge i64 %53, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !2

idx.bad107:                                       ; preds = %idx.ok98
  call void @__polaron_fail(ptr @.fail.1331, ptr @.faila.1332, i64 %53, ptr @.failb.1333, i64 %arr.len105, i32 70)
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
  %count115 = load i32, ptr %count114, align 4, !tbaa !7
  %data116 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data117 = load ptr, ptr %data116, align 8, !tbaa !3
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
  call void @__polaron_fail(ptr @.contract.1334, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data141 = load ptr, ptr %data140, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i142 = load i32, ptr %i, align 4
  %64 = sext i32 %i142 to i64
  %arr.len143 = load i64, ptr %data141, align 8
  %arr.oob144 = icmp uge i64 %64, %arr.len143
  br i1 %arr.oob144, label %idx.bad145, label %idx.ok146, !prof !2

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
  call void @__polaron_fail(ptr @.fail.1335, ptr @.faila.1336, i64 %64, ptr @.failb.1337, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %while.body126
  %arr.data147 = getelementptr i8, ptr %data141, i64 8
  %arr.elem148 = getelementptr inbounds ptr, ptr %arr.data147, i64 %64
  %elem149 = load ptr, ptr %arr.elem148, align 8
  %data150 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data151 = load ptr, ptr %data150, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j152 = load i32, ptr %j, align 4
  %68 = sext i32 %j152 to i64
  %arr.len153 = load i64, ptr %data151, align 8
  %arr.oob154 = icmp uge i64 %68, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !2

idx.bad155:                                       ; preds = %idx.ok146
  call void @__polaron_fail(ptr @.fail.1338, ptr @.faila.1339, i64 %68, ptr @.failb.1340, i64 %arr.len153, i32 70)
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
  %tmp162 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %k163 = load i32, ptr %k, align 4
  %72 = sext i32 %k163 to i64
  %arr.len164 = load i64, ptr %tmp162, align 8
  %arr.oob165 = icmp uge i64 %72, %arr.len164
  br i1 %arr.oob165, label %idx.bad166, label %idx.ok167, !prof !2

if.else:                                          ; preds = %idx.ok156
  %tmp182 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %k183 = load i32, ptr %k, align 4
  %73 = sext i32 %k183 to i64
  %arr.len184 = load i64, ptr %tmp182, align 8
  %arr.oob185 = icmp uge i64 %73, %arr.len184
  br i1 %arr.oob185, label %idx.bad186, label %idx.ok187, !prof !2

if.end161:                                        ; preds = %idx.ok196, %idx.ok176
  %k202 = load i32, ptr %k, align 4
  %74 = add i32 %k202, 1
  store i32 %74, ptr %k, align 4
  br label %while.cond125

idx.bad166:                                       ; preds = %if.then160
  call void @__polaron_fail(ptr @.fail.1341, ptr @.faila.1342, i64 %72, ptr @.failb.1343, i64 %arr.len164, i32 70)
  unreachable

idx.ok167:                                        ; preds = %if.then160
  %arr.data168 = getelementptr i8, ptr %tmp162, i64 8
  %arr.elem169 = getelementptr inbounds ptr, ptr %arr.data168, i64 %72
  %data170 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data171 = load ptr, ptr %data170, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i172 = load i32, ptr %i, align 4
  %75 = sext i32 %i172 to i64
  %arr.len173 = load i64, ptr %data171, align 8
  %arr.oob174 = icmp uge i64 %75, %arr.len173
  br i1 %arr.oob174, label %idx.bad175, label %idx.ok176, !prof !2

idx.bad175:                                       ; preds = %idx.ok167
  call void @__polaron_fail(ptr @.fail.1344, ptr @.faila.1345, i64 %75, ptr @.failb.1346, i64 %arr.len173, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1347, ptr @.faila.1348, i64 %73, ptr @.failb.1349, i64 %arr.len184, i32 70)
  unreachable

idx.ok187:                                        ; preds = %if.else
  %arr.data188 = getelementptr i8, ptr %tmp182, i64 8
  %arr.elem189 = getelementptr inbounds ptr, ptr %arr.data188, i64 %73
  %data190 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data191 = load ptr, ptr %data190, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j192 = load i32, ptr %j, align 4
  %78 = sext i32 %j192 to i64
  %arr.len193 = load i64, ptr %data191, align 8
  %arr.oob194 = icmp uge i64 %78, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !2

idx.bad195:                                       ; preds = %idx.ok187
  call void @__polaron_fail(ptr @.fail.1350, ptr @.faila.1351, i64 %78, ptr @.failb.1352, i64 %arr.len193, i32 70)
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
  %tmp208 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %k209 = load i32, ptr %k, align 4
  %83 = sext i32 %k209 to i64
  %arr.len210 = load i64, ptr %tmp208, align 8
  %arr.oob211 = icmp uge i64 %83, %arr.len210
  br i1 %arr.oob211, label %idx.bad212, label %idx.ok213, !prof !2

while.end205:                                     ; preds = %while.cond203
  br label %while.cond229

idx.bad212:                                       ; preds = %while.body204
  call void @__polaron_fail(ptr @.fail.1353, ptr @.faila.1354, i64 %83, ptr @.failb.1355, i64 %arr.len210, i32 70)
  unreachable

idx.ok213:                                        ; preds = %while.body204
  %arr.data214 = getelementptr i8, ptr %tmp208, i64 8
  %arr.elem215 = getelementptr inbounds ptr, ptr %arr.data214, i64 %83
  %data216 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data217 = load ptr, ptr %data216, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i218 = load i32, ptr %i, align 4
  %84 = sext i32 %i218 to i64
  %arr.len219 = load i64, ptr %data217, align 8
  %arr.oob220 = icmp uge i64 %84, %arr.len219
  br i1 %arr.oob220, label %idx.bad221, label %idx.ok222, !prof !2

idx.bad221:                                       ; preds = %idx.ok213
  call void @__polaron_fail(ptr @.fail.1356, ptr @.faila.1357, i64 %84, ptr @.failb.1358, i64 %arr.len219, i32 70)
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
  %tmp234 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %k235 = load i32, ptr %k, align 4
  %90 = sext i32 %k235 to i64
  %arr.len236 = load i64, ptr %tmp234, align 8
  %arr.oob237 = icmp uge i64 %90, %arr.len236
  br i1 %arr.oob237, label %idx.bad238, label %idx.ok239, !prof !2

while.end231:                                     ; preds = %while.cond229
  %lo255 = load i32, ptr %lo, align 4
  store i32 %lo255, ptr %t, align 4
  br label %for.cond256

idx.bad238:                                       ; preds = %while.body230
  call void @__polaron_fail(ptr @.fail.1359, ptr @.faila.1360, i64 %90, ptr @.failb.1361, i64 %arr.len236, i32 70)
  unreachable

idx.ok239:                                        ; preds = %while.body230
  %arr.data240 = getelementptr i8, ptr %tmp234, i64 8
  %arr.elem241 = getelementptr inbounds ptr, ptr %arr.data240, i64 %90
  %data242 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data243 = load ptr, ptr %data242, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j244 = load i32, ptr %j, align 4
  %91 = sext i32 %j244 to i64
  %arr.len245 = load i64, ptr %data243, align 8
  %arr.oob246 = icmp uge i64 %91, %arr.len245
  br i1 %arr.oob246, label %idx.bad247, label %idx.ok248, !prof !2

idx.bad247:                                       ; preds = %idx.ok239
  call void @__polaron_fail(ptr @.fail.1362, ptr @.faila.1363, i64 %91, ptr @.failb.1364, i64 %arr.len245, i32 70)
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
  %data263 = load ptr, ptr %data262, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t264 = load i32, ptr %t, align 4
  %97 = sext i32 %t264 to i64
  %arr.len265 = load i64, ptr %data263, align 8
  %arr.oob266 = icmp uge i64 %97, %arr.len265
  br i1 %arr.oob266, label %idx.bad267, label %idx.ok268, !prof !2

for.update258:                                    ; preds = %idx.ok276
  %t281 = load i32, ptr %t, align 4
  %98 = add i32 %t281, 1
  store i32 %98, ptr %t, align 4
  br label %for.cond256

for.end259:                                       ; preds = %for.cond256
  %count282 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count283 = load i32, ptr %count282, align 4, !tbaa !7
  %data284 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data285 = load ptr, ptr %data284, align 8, !tbaa !3
  %len286 = load i64, ptr %data285, align 8
  %99 = trunc i64 %len286 to i32
  %100 = icmp sle i32 %count283, %99
  %101 = zext i1 %100 to i32
  %contract.ok287 = icmp ne i32 %101, 0
  br i1 %contract.ok287, label %contract.cont289, label %contract.fail288

idx.bad267:                                       ; preds = %for.body257
  call void @__polaron_fail(ptr @.fail.1365, ptr @.faila.1366, i64 %97, ptr @.failb.1367, i64 %arr.len265, i32 70)
  unreachable

idx.ok268:                                        ; preds = %for.body257
  %arr.data269 = getelementptr i8, ptr %data263, i64 8
  %arr.elem270 = getelementptr inbounds ptr, ptr %arr.data269, i64 %97
  %tmp271 = load ptr, ptr %tmp, align 8, !nonnull !0, !dereferenceable !1
  %t272 = load i32, ptr %t, align 4
  %102 = sext i32 %t272 to i64
  %arr.len273 = load i64, ptr %tmp271, align 8
  %arr.oob274 = icmp uge i64 %102, %arr.len273
  br i1 %arr.oob274, label %idx.bad275, label %idx.ok276, !prof !2

idx.bad275:                                       ; preds = %idx.ok268
  call void @__polaron_fail(ptr @.fail.1368, ptr @.faila.1369, i64 %102, ptr @.failb.1370, i64 %arr.len273, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1371, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %10 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %10, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret %__polaron_variant { i32 1, i64 0 }

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1372, ptr @.faila.1373, i64 %10, ptr @.failb.1374, i64 %arr.len, i32 70)
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
  %data14 = load ptr, ptr %data13, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1375, ptr @.faila.1376, i64 %15, ptr @.failb.1377, i64 %arr.len16, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1378, ptr @.faila.1379, i64 0, ptr @.failb.1380, i64 %arr.len, i32 70)
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
  %count12 = load i32, ptr %count11, align 4, !tbaa !7
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

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
  call void @__polaron_fail(ptr @.fail.1381, ptr @.faila.1382, i64 %12, ptr @.failb.1383, i64 %arr.len17, i32 70)
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
  %data28 = load ptr, ptr %data27, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1384, ptr @.faila.1385, i64 %19, ptr @.failb.1386, i64 %arr.len30, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !7
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1387, ptr @.faila.1388, i64 0, ptr @.failb.1389, i64 %arr.len, i32 70)
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
  %count12 = load i32, ptr %count11, align 4, !tbaa !7
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

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
  call void @__polaron_fail(ptr @.fail.1390, ptr @.faila.1391, i64 %12, ptr @.failb.1392, i64 %arr.len17, i32 70)
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
  %data28 = load ptr, ptr %data27, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1393, ptr @.faila.1394, i64 %19, ptr @.failb.1395, i64 %arr.len30, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !7
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !3
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
  %4 = load ptr, ptr %3, align 8, !tbaa !3
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.ArrayList$String", ptr %"ArrayList$String.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !3
  store ptr %"ArrayList$String.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$String.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %list1 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !3
  %list2 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$String.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %9 = call ptr @memcpy(ptr %"ArrayList$String.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %"class.ArrayList$String", ptr %list3, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !3
  %arr.len5 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len5, 8
  %13 = add i64 8, %12
  %arr.copy6 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy6, ptr %11, i64 %13)
  %15 = getelementptr inbounds %"class.ArrayList$String", ptr %"ArrayList$String.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %15, align 8, !tbaa !3
  store ptr %"ArrayList$String.copy4", ptr %list2, align 8, !tbaa !3
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !7
  ret void
}

define internal i32 @"ArrayListIterator$String.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !7
  %list = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !3
  %1 = call i32 @"ArrayList$String.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$String.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !3
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !7
  %1 = call ptr @"ArrayList$String.get"(ptr %list1, i32 %pos2)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  store ptr %strcpy, ptr %value, align 8
  call void @__polaron_str_free(ptr %1)
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !7
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !7
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
  store ptr @Object.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal void @Exception.Exception(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  ret void
}

define internal ptr @UnimportedTypeException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1397)
  ret ptr %strcpy
}

define internal ptr @BundleNotLoadedException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1399)
  ret ptr %strcpy
}

define internal ptr @BundleAbiMismatchException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1401)
  ret ptr %strcpy
}

define internal ptr @ClassCastException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1403)
  ret ptr %strcpy
}

define internal ptr @NullReferenceException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1405)
  ret ptr %strcpy
}

define internal void @ArithmeticException.ArithmeticException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ArithmeticException, ptr %0, i32 0, i32 0
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1407)
  ret ptr %strcpy
}

define internal void @DivideByZeroException.DivideByZeroException(ptr %0) {
entry:
  call void @ArithmeticException.ArithmeticException(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.DivideByZeroException, ptr %0, i32 0, i32 0
  store ptr @DivideByZeroException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @DivideByZeroException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1409)
  ret ptr %strcpy
}

define internal ptr @OverflowException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1411)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !7
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !7
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !7
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !7
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !7
  %extra9 = load i32, ptr %extra, align 4
  %6 = add i32 %count8, %extra9
  %7 = icmp slt i32 %n6, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %n10 = load i32, ptr %n, align 4
  %9 = mul i32 %n10, 2
  store i32 %9, ptr %n, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %n11 = load i32, ptr %n, align 4
  %10 = zext i32 %n11 to i64
  %mem.alloc = call ptr @__polaron_malloc(i64 %10)
  %11 = ptrtoint ptr %mem.alloc to i64
  store i64 %11, ptr %nb, align 8
  %nb12 = load i64, ptr %nb, align 8
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf13 = load i64, ptr %buf, align 8, !tbaa !9
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !7
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !9
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !9
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !7
  ret void
}

define internal ptr @StringBuilder.append(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %n = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  call void @StringBuilder.ensure(ptr %0, i32 %n2)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !7
  %3 = sext i32 %count4 to i64
  %4 = add i64 %buf3, %3
  %s5 = load ptr, ptr %s, align 8
  %5 = inttoptr i64 %4 to ptr
  %str.len6 = getelementptr inbounds %String, ptr %s5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %str.data = getelementptr inbounds %String, ptr %s5, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %6 = call ptr @memcpy(ptr %5, ptr %data, i64 %len7)
  %count8 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count9 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !7
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !7
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !7
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !7
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !7
  ret ptr %0
}

define internal ptr @StringBuilder.appendInt(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i8, align 1
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %exc.thrown15 = alloca ptr, align 8
  %d = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %start = alloca i32, align 4
  %v = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %1, ptr %value, align 4
  call void @StringBuilder.ensure(ptr %0, i32 12)
  %value1 = load i32, ptr %value, align 4
  %2 = icmp eq i32 %value1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %4 = call ptr @StringBuilder.appendChar(ptr %0, i32 48)
  ret ptr %4

if.end:                                           ; preds = %entry
  %value2 = load i32, ptr %value, align 4
  store i32 %value2, ptr %v, align 4
  %v3 = load i32, ptr %v, align 4
  %5 = icmp sgt i32 %v3, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then4, label %if.else

if.then4:                                         ; preds = %if.end
  %v6 = load i32, ptr %v, align 4
  %7 = sub i32 0, %v6
  store i32 %7, ptr %v, align 4
  br label %if.end5

if.else:                                          ; preds = %if.end
  %8 = call ptr @StringBuilder.appendChar(ptr %0, i32 45)
  br label %if.end5

if.end5:                                          ; preds = %if.else, %if.then4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count, align 4, !tbaa !7
  store i32 %count7, ptr %start, align 4
  br label %while.cond

while.cond:                                       ; preds = %div.ok13, %if.end5
  %v8 = load i32, ptr %v, align 4
  %9 = icmp ne i32 %v8, 0
  %10 = zext i1 %9 to i32
  br i1 %9, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v9 = load i32, ptr %v, align 4
  %11 = icmp eq i32 %v9, -2147483648
  %12 = and i1 %11, false
  %13 = or i1 false, %12
  br i1 %13, label %div.bad, label %div.ok

while.end:                                        ; preds = %while.cond
  %start16 = load i32, ptr %start, align 4
  store i32 %start16, ptr %a, align 4
  %count17 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !7
  %14 = sub i32 %count18, 1
  store i32 %14, ptr %b, align 4
  br label %while.cond19

div.bad:                                          ; preds = %while.body
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.body
  %15 = srem i32 %v9, 10
  %16 = sub i32 0, %15
  store i32 %16, ptr %d, align 4
  %d10 = load i32, ptr %d, align 4
  %17 = add i32 48, %d10
  %18 = call ptr @StringBuilder.appendChar(ptr %0, i32 %17)
  %v11 = load i32, ptr %v, align 4
  %19 = icmp eq i32 %v11, -2147483648
  %20 = and i1 %19, false
  %21 = or i1 false, %20
  br i1 %21, label %div.bad12, label %div.ok13

div.bad12:                                        ; preds = %div.ok
  %exc14 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc14)
  store ptr %exc14, ptr %exc.thrown15, align 8
  call void @_CxxThrowException(ptr %exc.thrown15, ptr @_TI1PEAX)
  unreachable

div.ok13:                                         ; preds = %div.ok
  %22 = sdiv i32 %v11, 10
  store i32 %22, ptr %v, align 4
  br label %while.cond

while.cond19:                                     ; preds = %while.body20, %while.end
  %a22 = load i32, ptr %a, align 4
  %b23 = load i32, ptr %b, align 4
  %23 = icmp slt i32 %a22, %b23
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body20, label %while.end21

while.body20:                                     ; preds = %while.cond19
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf24 = load i64, ptr %buf, align 8, !tbaa !9
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !9
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !9
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !9
  %b35 = load i32, ptr %b, align 4
  %34 = sext i32 %b35 to i64
  %35 = add i64 %buf34, %34
  %t36 = load i8, ptr %t, align 1
  %36 = inttoptr i64 %35 to ptr
  store i8 %t36, ptr %36, align 1
  %a37 = load i32, ptr %a, align 4
  %37 = add i32 %a37, 1
  store i32 %37, ptr %a, align 4
  %b38 = load i32, ptr %b, align 4
  %38 = sub i32 %b38, 1
  store i32 %38, ptr %b, align 4
  br label %while.cond19

while.end21:                                      ; preds = %while.cond19
  ret ptr %0
}

define internal i32 @StringBuilder.length(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !7
  %1 = sext i32 %count2 to i64
  %2 = inttoptr i64 %buf1 to ptr
  %3 = add i64 %1, 1
  %fb.buf = call ptr @__polaron_malloc(i64 %3)
  %4 = call ptr @memcpy(ptr %fb.buf, ptr %2, i64 %1)
  %5 = getelementptr i8, ptr %fb.buf, i64 %1
  store i8 0, ptr %5, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %1, ptr %6, align 8
  %7 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %fb.buf, ptr %7, align 8
  %8 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %8, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal ptr @StringBuilder.clear(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !7
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !9
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !9
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal ptr @Strings.split(ptr %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %hit = alloca i32, align 4
  %i = alloca i32, align 4
  %start = alloca i32, align 4
  %m = alloca i32, align 4
  %n = alloca i32, align 4
  %out = alloca ptr, align 8
  %separator = alloca ptr, align 8
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store ptr %1, ptr %separator, align 8
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr %out, align 8
  %text1 = load ptr, ptr %text, align 8
  %str.len = getelementptr inbounds %String, ptr %text1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  store i32 %2, ptr %n, align 4
  %separator2 = load ptr, ptr %separator, align 8
  %str.len3 = getelementptr inbounds %String, ptr %separator2, i32 0, i32 0
  %len4 = load i64, ptr %str.len3, align 8
  %3 = trunc i64 %len4 to i32
  store i32 %3, ptr %m, align 4
  %m5 = load i32, ptr %m, align 4
  %4 = icmp eq i32 %m5, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %out6 = load ptr, ptr %out, align 8
  %text7 = load ptr, ptr %text, align 8
  call void @"ArrayList$String.add"(ptr %out6, ptr %text7)
  %out8 = load ptr, ptr %out, align 8
  ret ptr %out8

if.end:                                           ; preds = %entry
  store i32 0, ptr %start, align 4
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end27, %if.end
  %i9 = load i32, ptr %i, align 4
  %m10 = load i32, ptr %m, align 4
  %6 = add i32 %i9, %m10
  %n11 = load i32, ptr %n, align 4
  %7 = icmp sle i32 %6, %n11
  %8 = zext i1 %7 to i32
  br i1 %7, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  store i32 1, ptr %hit, align 4
  store i32 0, ptr %j, align 4
  br label %for.cond

while.end:                                        ; preds = %while.cond
  %out38 = load ptr, ptr %out, align 8
  %text39 = load ptr, ptr %text, align 8
  %start40 = load i32, ptr %start, align 4
  %9 = sext i32 %start40 to i64
  %n41 = load i32, ptr %n, align 4
  %10 = sext i32 %n41 to i64
  %11 = sub i64 %10, %9
  %12 = add i64 %11, 1
  %sub.buf42 = call ptr @__polaron_malloc(i64 %12)
  %str.data43 = getelementptr inbounds %String, ptr %text39, i32 0, i32 1
  %data44 = load ptr, ptr %str.data43, align 8
  %13 = getelementptr i8, ptr %data44, i64 %9
  %14 = call ptr @memcpy(ptr %sub.buf42, ptr %13, i64 %11)
  %15 = getelementptr i8, ptr %sub.buf42, i64 %11
  store i8 0, ptr %15, align 1
  %newstr45 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %16 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 0
  store i64 %11, ptr %16, align 8
  %17 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 1
  store ptr %sub.buf42, ptr %17, align 8
  %18 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 2
  store i64 0, ptr %18, align 8
  call void @"ArrayList$String.add"(ptr %out38, ptr %newstr45)
  call void @__polaron_str_free(ptr %newstr45)
  %out46 = load ptr, ptr %out, align 8
  ret ptr %out46

for.cond:                                         ; preds = %for.update, %while.body
  %j12 = load i32, ptr %j, align 4
  %m13 = load i32, ptr %m, align 4
  %19 = icmp slt i32 %j12, %m13
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %text14 = load ptr, ptr %text, align 8
  %i15 = load i32, ptr %i, align 4
  %j16 = load i32, ptr %j, align 4
  %21 = add i32 %i15, %j16
  %22 = sext i32 %21 to i64
  %str.data = getelementptr inbounds %String, ptr %text14, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %22
  %ch = load i8, ptr %ch.addr, align 1
  %23 = zext i8 %ch to i32
  %separator17 = load ptr, ptr %separator, align 8
  %j18 = load i32, ptr %j, align 4
  %24 = sext i32 %j18 to i64
  %str.data19 = getelementptr inbounds %String, ptr %separator17, i32 0, i32 1
  %data20 = load ptr, ptr %str.data19, align 8
  %ch.addr21 = getelementptr i8, ptr %data20, i64 %24
  %ch22 = load i8, ptr %ch.addr21, align 1
  %25 = zext i8 %ch22 to i32
  %26 = icmp ne i32 %23, %25
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then23, label %if.end24

for.update:                                       ; preds = %if.end24
  %28 = load i32, ptr %j, align 4
  %29 = add i32 %28, 1
  store i32 %29, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %hit25 = load i32, ptr %hit, align 4
  %30 = icmp ne i32 %hit25, 0
  br i1 %30, label %if.then26, label %if.else

if.then23:                                        ; preds = %for.body
  store i32 0, ptr %hit, align 4
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %for.body
  br label %for.update

if.then26:                                        ; preds = %for.end
  %out28 = load ptr, ptr %out, align 8
  %text29 = load ptr, ptr %text, align 8
  %start30 = load i32, ptr %start, align 4
  %31 = sext i32 %start30 to i64
  %i31 = load i32, ptr %i, align 4
  %32 = sext i32 %i31 to i64
  %33 = sub i64 %32, %31
  %34 = add i64 %33, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %34)
  %str.data32 = getelementptr inbounds %String, ptr %text29, i32 0, i32 1
  %data33 = load ptr, ptr %str.data32, align 8
  %35 = getelementptr i8, ptr %data33, i64 %31
  %36 = call ptr @memcpy(ptr %sub.buf, ptr %35, i64 %33)
  %37 = getelementptr i8, ptr %sub.buf, i64 %33
  store i8 0, ptr %37, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %38 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %33, ptr %38, align 8
  %39 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %39, align 8
  %40 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %40, align 8
  call void @"ArrayList$String.add"(ptr %out28, ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  %i34 = load i32, ptr %i, align 4
  %m35 = load i32, ptr %m, align 4
  %41 = add i32 %i34, %m35
  store i32 %41, ptr %i, align 4
  %i36 = load i32, ptr %i, align 4
  store i32 %i36, ptr %start, align 4
  br label %if.end27

if.else:                                          ; preds = %for.end
  %i37 = load i32, ptr %i, align 4
  %42 = add i32 %i37, 1
  store i32 %42, ptr %i, align 4
  br label %if.end27

if.end27:                                         ; preds = %if.else, %if.then26
  br label %while.cond
}

define internal ptr @IpcError.message(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %text = getelementptr inbounds %class.IpcError, ptr %0, i32 0, i32 1
  %text1 = load ptr, ptr %text, align 8, !tbaa !3
  %strcpy = call ptr @__polaron_str_copy(ptr %text1)
  ret ptr %strcpy
}

define internal void @Test.reset() {
entry:
  store i32 0, ptr @Test.fails, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5296)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  store i32 0, ptr @Test.skipping, align 4
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5298)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

define internal i32 @Test.failures() {
entry:
  %fails = load i32, ptr @Test.fails, align 4
  ret i32 %fails
}

define internal i32 @Test.wasSkipped() {
entry:
  %skipping = load i32, ptr @Test.skipping, align 4
  ret i32 %skipping
}

define internal ptr @Test.skipReason() {
entry:
  %skipWhy = load ptr, ptr @Test.skipWhy, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %skipWhy)
  ret ptr %strcpy
}

define internal void @Test.checking(ptr %0) {
entry:
  %what = alloca ptr, align 8
  store ptr %0, ptr %what, align 8
  %what1 = load ptr, ptr %what, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %what1)
  %1 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy, ptr @Test.criterion, align 8
  ret void
}

define internal void @Test.fail(ptr %0) {
entry:
  %why = alloca ptr, align 8
  store ptr %0, ptr %why, align 8
  call void @Test.mark()
  %why1 = load ptr, ptr %why, align 8
  %str.data = getelementptr inbounds %String, ptr %why1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %1 = call i32 (ptr, ...) @printf(ptr @.str.5299, ptr %data)
  ret void
}

declare void @__polaron_test_detail()

define internal void @Test.mark() {
entry:
  call void @__polaron_test_detail()
  %fails = load i32, ptr @Test.fails, align 4
  %0 = add i32 %fails, 1
  store i32 %0, ptr @Test.fails, align 4
  %criterion = load ptr, ptr @Test.criterion, align 8
  %str.len = getelementptr inbounds %String, ptr %criterion, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp sgt i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %criterion1 = load ptr, ptr @Test.criterion, align 8
  %str.data = getelementptr inbounds %String, ptr %criterion1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5300, ptr %data)
  br label %if.end

if.else:                                          ; preds = %entry
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5301, ptr @.str.5302)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define internal void @Test.assertEqual(i32 %0, i32 %1) {
entry:
  %expected = alloca i32, align 4
  %actual = alloca i32, align 4
  store i32 %0, ptr %actual, align 4
  store i32 %1, ptr %expected, align 4
  %actual1 = load i32, ptr %actual, align 4
  %expected2 = load i32, ptr %expected, align 4
  %2 = icmp ne i32 %actual1, %expected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected3 = load i32, ptr %expected, align 4
  %actual4 = load i32, ptr %actual, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5303, i32 %expected3, i32 %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertNotEqual(i32 %0, i32 %1) {
entry:
  %unexpected = alloca i32, align 4
  %actual = alloca i32, align 4
  store i32 %0, ptr %actual, align 4
  store i32 %1, ptr %unexpected, align 4
  %actual1 = load i32, ptr %actual, align 4
  %unexpected2 = load i32, ptr %unexpected, align 4
  %2 = icmp eq i32 %actual1, %unexpected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %unexpected3 = load i32, ptr %unexpected, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5304, i32 %unexpected3)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEqualString(ptr %0, ptr %1) {
entry:
  %expected = alloca ptr, align 8
  %actual = alloca ptr, align 8
  store ptr %0, ptr %actual, align 8
  store ptr %1, ptr %expected, align 8
  %actual1 = load ptr, ptr %actual, align 8
  %expected2 = load ptr, ptr %expected, align 8
  %str.data = getelementptr inbounds %String, ptr %actual1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data3 = getelementptr inbounds %String, ptr %expected2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %2 = call i32 @strcmp(ptr %data, ptr %data4)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected5 = load ptr, ptr %expected, align 8
  %str.data6 = getelementptr inbounds %String, ptr %expected5, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %actual8 = load ptr, ptr %actual, align 8
  %str.data9 = getelementptr inbounds %String, ptr %actual8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5306, ptr %data7, ptr %data10)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertBetween(i32 %0, i32 %1, i32 %2) {
entry:
  %high = alloca i32, align 4
  %low = alloca i32, align 4
  %value = alloca i32, align 4
  store i32 %0, ptr %value, align 4
  store i32 %1, ptr %low, align 4
  store i32 %2, ptr %high, align 4
  %value1 = load i32, ptr %value, align 4
  %low2 = load i32, ptr %low, align 4
  %3 = icmp slt i32 %value1, %low2
  %4 = zext i1 %3 to i32
  %sc.a = icmp ne i32 %4, 0
  br i1 %sc.a, label %sc.end, label %sc.rhs

sc.rhs:                                           ; preds = %entry
  %value3 = load i32, ptr %value, align 4
  %high4 = load i32, ptr %high, align 4
  %5 = icmp sgt i32 %value3, %high4
  %6 = zext i1 %5 to i32
  %sc.b = icmp ne i32 %6, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %7 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  call void @Test.mark()
  %low5 = load i32, ptr %low, align 4
  %high6 = load i32, ptr %high, align 4
  %value7 = load i32, ptr %value, align 4
  %8 = call i32 (ptr, ...) @printf(ptr @.str.5311, i32 %low5, i32 %high6, i32 %value7)
  br label %if.end

if.end:                                           ; preds = %if.then, %sc.end
  ret void
}

define internal void @Test.assertNear(double %0, double %1, double %2) {
entry:
  %d = alloca double, align 8
  %allowed = alloca double, align 8
  %scale = alloca double, align 8
  %relativeTolerance = alloca double, align 8
  %expected = alloca double, align 8
  %actual = alloca double, align 8
  store double %0, ptr %actual, align 8
  store double %1, ptr %expected, align 8
  store double %2, ptr %relativeTolerance, align 8
  %expected1 = load double, ptr %expected, align 8
  store double %expected1, ptr %scale, align 8
  %scale2 = load double, ptr %scale, align 8
  %3 = fcmp olt double %scale2, 0.000000e+00
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %scale3 = load double, ptr %scale, align 8
  %5 = fsub double 0.000000e+00, %scale3
  store double %5, ptr %scale, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %relativeTolerance4 = load double, ptr %relativeTolerance, align 8
  %scale5 = load double, ptr %scale, align 8
  %6 = fmul double %relativeTolerance4, %scale5
  store double %6, ptr %allowed, align 8
  %scale6 = load double, ptr %scale, align 8
  %7 = fcmp oeq double %scale6, 0.000000e+00
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then7, label %if.end8

if.then7:                                         ; preds = %if.end
  %relativeTolerance9 = load double, ptr %relativeTolerance, align 8
  store double %relativeTolerance9, ptr %allowed, align 8
  br label %if.end8

if.end8:                                          ; preds = %if.then7, %if.end
  %actual10 = load double, ptr %actual, align 8
  %expected11 = load double, ptr %expected, align 8
  %9 = fsub double %actual10, %expected11
  store double %9, ptr %d, align 8
  %d12 = load double, ptr %d, align 8
  %10 = fcmp olt double %d12, 0.000000e+00
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then13, label %if.end14

if.then13:                                        ; preds = %if.end8
  %d15 = load double, ptr %d, align 8
  %12 = fsub double 0.000000e+00, %d15
  store double %12, ptr %d, align 8
  br label %if.end14

if.end14:                                         ; preds = %if.then13, %if.end8
  %d16 = load double, ptr %d, align 8
  %allowed17 = load double, ptr %allowed, align 8
  %13 = fcmp ogt double %d16, %allowed17
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then18, label %if.end19

if.then18:                                        ; preds = %if.end14
  call void @Test.mark()
  %expected20 = load double, ptr %expected, align 8
  %relativeTolerance21 = load double, ptr %relativeTolerance, align 8
  %actual22 = load double, ptr %actual, align 8
  %15 = call i32 (ptr, ...) @printf(ptr @.str.5316, double %expected20, double %relativeTolerance21, double %actual22)
  br label %if.end19

if.end19:                                         ; preds = %if.then18, %if.end14
  ret void
}

define internal void @Test.assertContains(ptr %0, ptr %1) {
entry:
  %needle = alloca ptr, align 8
  %haystack = alloca ptr, align 8
  store ptr %0, ptr %haystack, align 8
  store ptr %1, ptr %needle, align 8
  %haystack1 = load ptr, ptr %haystack, align 8
  %needle2 = load ptr, ptr %needle, align 8
  %str.data = getelementptr inbounds %String, ptr %haystack1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %haystack1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.data3 = getelementptr inbounds %String, ptr %needle2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %str.len5 = getelementptr inbounds %String, ptr %needle2, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %2 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data4, i64 %len6)
  %3 = icmp sge i64 %2, 0
  %4 = zext i1 %3 to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %needle7 = load ptr, ptr %needle, align 8
  %str.data8 = getelementptr inbounds %String, ptr %needle7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %haystack10 = load ptr, ptr %haystack, align 8
  %str.data11 = getelementptr inbounds %String, ptr %haystack10, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5317, ptr %data9, ptr %data12)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertStartsWith(ptr %0, ptr %1) {
entry:
  %prefix = alloca ptr, align 8
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store ptr %1, ptr %prefix, align 8
  %text1 = load ptr, ptr %text, align 8
  %prefix2 = load ptr, ptr %prefix, align 8
  %str.data = getelementptr inbounds %String, ptr %text1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %text1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.data3 = getelementptr inbounds %String, ptr %prefix2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %str.len5 = getelementptr inbounds %String, ptr %prefix2, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %2 = call i64 @__polaron_str_index(ptr %data, i64 %len, ptr %data4, i64 %len6)
  %3 = icmp eq i64 %2, 0
  %4 = zext i1 %3 to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %prefix7 = load ptr, ptr %prefix, align 8
  %str.data8 = getelementptr inbounds %String, ptr %prefix7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %text10 = load ptr, ptr %text, align 8
  %str.data11 = getelementptr inbounds %String, ptr %text10, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %7 = call i32 (ptr, ...) @printf(ptr @.str.5318, ptr %data9, ptr %data12)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEndsWith(ptr %0, ptr %1) {
entry:
  %suffix = alloca ptr, align 8
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  store ptr %1, ptr %suffix, align 8
  %text1 = load ptr, ptr %text, align 8
  %suffix2 = load ptr, ptr %suffix, align 8
  %str.data = getelementptr inbounds %String, ptr %text1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %text1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %str.data3 = getelementptr inbounds %String, ptr %suffix2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %str.len5 = getelementptr inbounds %String, ptr %suffix2, i32 0, i32 0
  %len6 = load i64, ptr %str.len5, align 8
  %2 = call i32 @__polaron_str_ends(ptr %data, i64 %len, ptr %data4, i64 %len6)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %suffix7 = load ptr, ptr %suffix, align 8
  %str.data8 = getelementptr inbounds %String, ptr %suffix7, i32 0, i32 1
  %data9 = load ptr, ptr %str.data8, align 8
  %text10 = load ptr, ptr %text, align 8
  %str.data11 = getelementptr inbounds %String, ptr %text10, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5319, ptr %data9, ptr %data12)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEqualChar(i32 %0, i32 %1) {
entry:
  %expected = alloca i32, align 4
  %actual = alloca i32, align 4
  store i32 %0, ptr %actual, align 4
  store i32 %1, ptr %expected, align 4
  %actual1 = load i32, ptr %actual, align 4
  %expected2 = load i32, ptr %expected, align 4
  %2 = icmp ne i32 %actual1, %expected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected3 = load i32, ptr %expected, align 4
  %actual4 = load i32, ptr %actual, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5320, i32 %expected3, i32 %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEqualBoolean(i32 %0, i32 %1) {
entry:
  %expected = alloca i32, align 4
  %actual = alloca i32, align 4
  store i32 %0, ptr %actual, align 4
  store i32 %1, ptr %expected, align 4
  %actual1 = load i32, ptr %actual, align 4
  %expected2 = load i32, ptr %expected, align 4
  %2 = icmp ne i32 %actual1, %expected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5321, ptr @.str.5322)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEqualDouble(double %0, double %1) {
entry:
  %expected = alloca double, align 8
  %actual = alloca double, align 8
  store double %0, ptr %actual, align 8
  store double %1, ptr %expected, align 8
  %actual1 = load double, ptr %actual, align 8
  %expected2 = load double, ptr %expected, align 8
  %2 = fcmp one double %actual1, %expected2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected3 = load double, ptr %expected, align 8
  %actual4 = load double, ptr %actual, align 8
  %4 = call i32 (ptr, ...) @printf(ptr @.str.5323, double %expected3, double %actual4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Test.assertEqualLongArray(ptr %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %expected = alloca ptr, align 8
  %actual = alloca ptr, align 8
  store ptr %0, ptr %actual, align 8
  store ptr %1, ptr %expected, align 8
  %actual1 = load ptr, ptr %actual, align 8
  %len = load i64, ptr %actual1, align 8
  %2 = trunc i64 %len to i32
  %expected2 = load ptr, ptr %expected, align 8
  %len3 = load i64, ptr %expected2, align 8
  %3 = trunc i64 %len3 to i32
  %4 = icmp ne i32 %2, %3
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected4 = load ptr, ptr %expected, align 8
  %len5 = load i64, ptr %expected4, align 8
  %6 = trunc i64 %len5 to i32
  %actual6 = load ptr, ptr %actual, align 8
  %len7 = load i64, ptr %actual6, align 8
  %7 = trunc i64 %len7 to i32
  %8 = call i32 (ptr, ...) @printf(ptr @.str.5338, i32 %6, i32 %7)
  ret void

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end23, %if.end
  %i8 = load i32, ptr %i, align 4
  %actual9 = load ptr, ptr %actual, align 8
  %len10 = load i64, ptr %actual9, align 8
  %9 = trunc i64 %len10 to i32
  %10 = icmp slt i32 %i8, %9
  %11 = zext i1 %10 to i32
  br i1 %10, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %actual11 = load ptr, ptr %actual, align 8, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %12 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %actual11, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.5339, ptr @.faila.5340, i64 %12, ptr @.failb.5341, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %actual11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %12
  %elem = load i64, ptr %arr.elem, align 8
  %expected13 = load ptr, ptr %expected, align 8, !nonnull !0, !dereferenceable !1
  %i14 = load i32, ptr %i, align 4
  %13 = sext i32 %i14 to i64
  %arr.len15 = load i64, ptr %expected13, align 8
  %arr.oob16 = icmp uge i64 %13, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5342, ptr @.faila.5343, i64 %13, ptr @.failb.5344, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %expected13, i64 8
  %arr.elem20 = getelementptr inbounds i64, ptr %arr.data19, i64 %13
  %elem21 = load i64, ptr %arr.elem20, align 8
  %14 = icmp ne i64 %elem, %elem21
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then22, label %if.end23

if.then22:                                        ; preds = %idx.ok18
  call void @Test.mark()
  %i24 = load i32, ptr %i, align 4
  %expected25 = load ptr, ptr %expected, align 8, !nonnull !0, !dereferenceable !1
  %i26 = load i32, ptr %i, align 4
  %16 = sext i32 %i26 to i64
  %arr.len27 = load i64, ptr %expected25, align 8
  %arr.oob28 = icmp uge i64 %16, %arr.len27
  br i1 %arr.oob28, label %idx.bad29, label %idx.ok30, !prof !2

if.end23:                                         ; preds = %idx.ok18
  %i43 = load i32, ptr %i, align 4
  %17 = add i32 %i43, 1
  store i32 %17, ptr %i, align 4
  br label %while.cond

idx.bad29:                                        ; preds = %if.then22
  call void @__polaron_fail(ptr @.fail.5346, ptr @.faila.5347, i64 %16, ptr @.failb.5348, i64 %arr.len27, i32 70)
  unreachable

idx.ok30:                                         ; preds = %if.then22
  %arr.data31 = getelementptr i8, ptr %expected25, i64 8
  %arr.elem32 = getelementptr inbounds i64, ptr %arr.data31, i64 %16
  %elem33 = load i64, ptr %arr.elem32, align 8
  %actual34 = load ptr, ptr %actual, align 8, !nonnull !0, !dereferenceable !1
  %i35 = load i32, ptr %i, align 4
  %18 = sext i32 %i35 to i64
  %arr.len36 = load i64, ptr %actual34, align 8
  %arr.oob37 = icmp uge i64 %18, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok30
  call void @__polaron_fail(ptr @.fail.5349, ptr @.faila.5350, i64 %18, ptr @.failb.5351, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok30
  %arr.data40 = getelementptr i8, ptr %actual34, i64 8
  %arr.elem41 = getelementptr inbounds i64, ptr %arr.data40, i64 %18
  %elem42 = load i64, ptr %arr.elem41, align 8
  %19 = call i32 (ptr, ...) @printf(ptr @.str.5345, i32 %i24, i64 %elem33, i64 %elem42)
  ret void
}

define internal void @Test.assertEqualDoubleArray(ptr %0, ptr %1, double %2) {
entry:
  %d = alloca double, align 8
  %i = alloca i32, align 4
  %tolerance = alloca double, align 8
  %expected = alloca ptr, align 8
  %actual = alloca ptr, align 8
  store ptr %0, ptr %actual, align 8
  store ptr %1, ptr %expected, align 8
  store double %2, ptr %tolerance, align 8
  %actual1 = load ptr, ptr %actual, align 8
  %len = load i64, ptr %actual1, align 8
  %3 = trunc i64 %len to i32
  %expected2 = load ptr, ptr %expected, align 8
  %len3 = load i64, ptr %expected2, align 8
  %4 = trunc i64 %len3 to i32
  %5 = icmp ne i32 %3, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Test.mark()
  %expected4 = load ptr, ptr %expected, align 8
  %len5 = load i64, ptr %expected4, align 8
  %7 = trunc i64 %len5 to i32
  %actual6 = load ptr, ptr %actual, align 8
  %len7 = load i64, ptr %actual6, align 8
  %8 = trunc i64 %len7 to i32
  %9 = call i32 (ptr, ...) @printf(ptr @.str.5366, i32 %7, i32 %8)
  ret void

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end29, %if.end
  %i8 = load i32, ptr %i, align 4
  %actual9 = load ptr, ptr %actual, align 8
  %len10 = load i64, ptr %actual9, align 8
  %10 = trunc i64 %len10 to i32
  %11 = icmp slt i32 %i8, %10
  %12 = zext i1 %11 to i32
  br i1 %11, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %actual11 = load ptr, ptr %actual, align 8, !nonnull !0, !dereferenceable !1
  %i12 = load i32, ptr %i, align 4
  %13 = sext i32 %i12 to i64
  %arr.len = load i64, ptr %actual11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.5367, ptr @.faila.5368, i64 %13, ptr @.failb.5369, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %actual11, i64 8
  %arr.elem = getelementptr inbounds double, ptr %arr.data, i64 %13
  %elem = load double, ptr %arr.elem, align 8
  %expected13 = load ptr, ptr %expected, align 8, !nonnull !0, !dereferenceable !1
  %i14 = load i32, ptr %i, align 4
  %14 = sext i32 %i14 to i64
  %arr.len15 = load i64, ptr %expected13, align 8
  %arr.oob16 = icmp uge i64 %14, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5370, ptr @.faila.5371, i64 %14, ptr @.failb.5372, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok
  %arr.data19 = getelementptr i8, ptr %expected13, i64 8
  %arr.elem20 = getelementptr inbounds double, ptr %arr.data19, i64 %14
  %elem21 = load double, ptr %arr.elem20, align 8
  %15 = fsub double %elem, %elem21
  store double %15, ptr %d, align 8
  %d22 = load double, ptr %d, align 8
  %16 = fcmp olt double %d22, 0.000000e+00
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then23, label %if.end24

if.then23:                                        ; preds = %idx.ok18
  %d25 = load double, ptr %d, align 8
  %18 = fsub double 0.000000e+00, %d25
  store double %18, ptr %d, align 8
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %idx.ok18
  %d26 = load double, ptr %d, align 8
  %tolerance27 = load double, ptr %tolerance, align 8
  %19 = fcmp ogt double %d26, %tolerance27
  %20 = zext i1 %19 to i32
  br i1 %19, label %if.then28, label %if.end29

if.then28:                                        ; preds = %if.end24
  call void @Test.mark()
  %i30 = load i32, ptr %i, align 4
  %expected31 = load ptr, ptr %expected, align 8, !nonnull !0, !dereferenceable !1
  %i32 = load i32, ptr %i, align 4
  %21 = sext i32 %i32 to i64
  %arr.len33 = load i64, ptr %expected31, align 8
  %arr.oob34 = icmp uge i64 %21, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

if.end29:                                         ; preds = %if.end24
  %i50 = load i32, ptr %i, align 4
  %22 = add i32 %i50, 1
  store i32 %22, ptr %i, align 4
  br label %while.cond

idx.bad35:                                        ; preds = %if.then28
  call void @__polaron_fail(ptr @.fail.5374, ptr @.faila.5375, i64 %21, ptr @.failb.5376, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %if.then28
  %arr.data37 = getelementptr i8, ptr %expected31, i64 8
  %arr.elem38 = getelementptr inbounds double, ptr %arr.data37, i64 %21
  %elem39 = load double, ptr %arr.elem38, align 8
  %tolerance40 = load double, ptr %tolerance, align 8
  %actual41 = load ptr, ptr %actual, align 8, !nonnull !0, !dereferenceable !1
  %i42 = load i32, ptr %i, align 4
  %23 = sext i32 %i42 to i64
  %arr.len43 = load i64, ptr %actual41, align 8
  %arr.oob44 = icmp uge i64 %23, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !2

idx.bad45:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.5377, ptr @.faila.5378, i64 %23, ptr @.failb.5379, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok36
  %arr.data47 = getelementptr i8, ptr %actual41, i64 8
  %arr.elem48 = getelementptr inbounds double, ptr %arr.data47, i64 %23
  %elem49 = load double, ptr %arr.elem48, align 8
  %24 = call i32 (ptr, ...) @printf(ptr @.str.5373, i32 %i30, double %elem39, double %tolerance40, double %elem49)
  ret void
}

define internal void @Test.assertSorted(ptr %0) {
entry:
  %i = alloca i32, align 4
  %values = alloca ptr, align 8
  store ptr %0, ptr %values, align 8
  store i32 1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %i1 = load i32, ptr %i, align 4
  %values2 = load ptr, ptr %values, align 8
  %len = load i64, ptr %values2, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp slt i32 %i1, %1
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %values3 = load ptr, ptr %values, align 8, !nonnull !0, !dereferenceable !1
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %values3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad:                                          ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.5380, ptr @.faila.5381, i64 %4, ptr @.failb.5382, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.body
  %arr.data = getelementptr i8, ptr %values3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %values5 = load ptr, ptr %values, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %5 = sub i32 %i6, 1
  %6 = sext i32 %5 to i64
  %arr.len7 = load i64, ptr %values5, align 8
  %arr.oob8 = icmp uge i64 %6, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5383, ptr @.faila.5384, i64 %6, ptr @.failb.5385, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %values5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %6
  %elem13 = load i32, ptr %arr.elem12, align 4
  %7 = icmp slt i32 %elem, %elem13
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok10
  call void @Test.mark()
  %i14 = load i32, ptr %i, align 4
  %values15 = load ptr, ptr %values, align 8, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %9 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %values15, align 8
  %arr.oob18 = icmp uge i64 %9, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

if.end:                                           ; preds = %idx.ok10
  %i33 = load i32, ptr %i, align 4
  %10 = add i32 %i33, 1
  store i32 %10, ptr %i, align 4
  br label %while.cond

idx.bad19:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.5387, ptr @.faila.5388, i64 %9, ptr @.failb.5389, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %if.then
  %arr.data21 = getelementptr i8, ptr %values15, i64 8
  %arr.elem22 = getelementptr inbounds i32, ptr %arr.data21, i64 %9
  %elem23 = load i32, ptr %arr.elem22, align 4
  %values24 = load ptr, ptr %values, align 8, !nonnull !0, !dereferenceable !1
  %i25 = load i32, ptr %i, align 4
  %11 = sub i32 %i25, 1
  %12 = sext i32 %11 to i64
  %arr.len26 = load i64, ptr %values24, align 8
  %arr.oob27 = icmp uge i64 %12, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

idx.bad28:                                        ; preds = %idx.ok20
  call void @__polaron_fail(ptr @.fail.5390, ptr @.faila.5391, i64 %12, ptr @.failb.5392, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %idx.ok20
  %arr.data30 = getelementptr i8, ptr %values24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %12
  %elem32 = load i32, ptr %arr.elem31, align 4
  %13 = call i32 (ptr, ...) @printf(ptr @.str.5386, i32 %i14, i32 %elem23, i32 %elem32)
  ret void
}

define internal void @Test.assertDoesNotThrow(ptr %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %e = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %action = alloca ptr, align 8
  store ptr %0, ptr %action, align 8
  %action1 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action1, align 8
  %1 = getelementptr ptr, ptr %action1, i32 1
  %env = load ptr, ptr %1, align 8
  invoke void %code(ptr %env)
          to label %invoke.cont unwind label %ehpad

ehpad:                                            ; preds = %entry
  %2 = catchswitch within none [label %catch.dispatch] unwind to caller

try.cont:                                         ; preds = %catch.body, %invoke.cont
  ret void

invoke.cont:                                      ; preds = %entry
  br label %try.cont

catch.dispatch:                                   ; preds = %ehpad
  %3 = catchpad within %2 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  %is = icmp eq ptr %exc.vtbl, @NullReferenceException.vtable
  %is2 = icmp eq ptr %exc.vtbl, @ClassCastException.vtable
  %or = or i1 %is, %is2
  %is3 = icmp eq ptr %exc.vtbl, @UnimportedTypeException.vtable
  %or4 = or i1 %or, %is3
  %is5 = icmp eq ptr %exc.vtbl, @BundleNotLoadedException.vtable
  %or6 = or i1 %or4, %is5
  %is7 = icmp eq ptr %exc.vtbl, @BundleAbiMismatchException.vtable
  %or8 = or i1 %or6, %is7
  %is9 = icmp eq ptr %exc.vtbl, @ArithmeticException.vtable
  %or10 = or i1 %or8, %is9
  %is11 = icmp eq ptr %exc.vtbl, @DivideByZeroException.vtable
  %or12 = or i1 %or10, %is11
  %is13 = icmp eq ptr %exc.vtbl, @OverflowException.vtable
  %or14 = or i1 %or12, %is13
  %is15 = icmp eq ptr %exc.vtbl, @IpcError.vtable
  %or16 = or i1 %or14, %is15
  br i1 %or16, label %catch.match, label %catch.next

catch.match:                                      ; preds = %catch.dispatch
  store ptr %caught, ptr %e, align 8
  catchret from %3 to label %catch.body

catch.next:                                       ; preds = %catch.dispatch
  catchret from %3 to label %rethrow

catch.body:                                       ; preds = %catch.match
  call void @Test.mark()
  %e17 = load ptr, ptr %e, align 8
  %vtbl.addr = getelementptr inbounds %class.Exception, ptr %e17, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %slot = getelementptr [348 x ptr], ptr %vtbl, i64 0, i64 41
  %fn = load ptr, ptr %slot, align 8
  %4 = call ptr %fn(ptr %e17)
  %str.data = getelementptr inbounds %String, ptr %4, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %5 = call i32 (ptr, ...) @printf(ptr @.str.5394, ptr %data)
  call void @__polaron_str_free(ptr %4)
  br label %try.cont

rethrow:                                          ; preds = %catch.next
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  store ptr %rethrow.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable
}

declare void @__polaron_capture_begin()

declare void @__polaron_capture_end()

declare i32 @__polaron_capture_id()

declare i32 @__polaron_test_update_golden()

define internal ptr @Test.capturePath() {
entry:
  %path = alloca ptr, align 8
  %sb = alloca ptr, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  %sb1 = load ptr, ptr %sb, align 8
  %0 = call ptr @StringBuilder.append(ptr %sb1, ptr @.strobj.5396)
  %sb2 = load ptr, ptr %sb, align 8
  %1 = call i32 @__polaron_capture_id()
  %2 = call ptr @StringBuilder.appendInt(ptr %sb2, i32 %1)
  %sb3 = load ptr, ptr %sb, align 8
  %3 = call ptr @StringBuilder.toString(ptr %sb3)
  %strcpy = call ptr @__polaron_str_copy(ptr %3)
  store ptr %strcpy, ptr %path, align 8
  call void @__polaron_str_free(ptr %3)
  %sb4 = load ptr, ptr %sb, align 8
  call void @__polaron_check_live(ptr %sb4)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %sb4, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [349 x ptr], ptr %vtbl, i64 0, i64 348
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %4 = icmp ne ptr %dtor.fn, null
  br i1 %4, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %sb4)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %sb4)
  %path5 = load ptr, ptr %path, align 8
  %strcpy6 = call ptr @__polaron_str_copy(ptr %path5)
  %5 = load ptr, ptr %path, align 8
  call void @__polaron_str_free(ptr %5)
  ret ptr %strcpy6
}

define internal ptr @Test.captureOutput(ptr %0) {
entry:
  %action = alloca ptr, align 8
  store ptr %0, ptr %action, align 8
  call void @__polaron_capture_begin()
  %action1 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action1, align 8
  %1 = getelementptr ptr, ptr %action1, i32 1
  %env = load ptr, ptr %1, align 8
  call void %code(ptr %env)
  call void @__polaron_capture_end()
  %2 = call ptr @Test.capturePath()
  %fr.len = alloca i64, align 8
  %str.data = getelementptr inbounds %String, ptr %2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %3 = call ptr @__polaron_file_read_all(ptr %data, ptr %fr.len)
  %fr.n = load i64, ptr %fr.len, align 8
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %fr.n, ptr %4, align 8
  %5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %3, ptr %5, align 8
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %6, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %2)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal void @Test.assertMatchesGolden(ptr %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %expected = alloca ptr, align 8
  %goldenPath = alloca ptr, align 8
  %actual = alloca ptr, align 8
  store ptr %0, ptr %actual, align 8
  store ptr %1, ptr %goldenPath, align 8
  %2 = call i32 @__polaron_test_update_golden()
  %3 = icmp ne i32 %2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %goldenPath1 = load ptr, ptr %goldenPath, align 8
  %actual2 = load ptr, ptr %actual, align 8
  %str.data = getelementptr inbounds %String, ptr %goldenPath1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data3 = getelementptr inbounds %String, ptr %actual2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %str.len = getelementptr inbounds %String, ptr %actual2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %5 = call i32 @__polaron_file_write_all(ptr %data, ptr %data4, i64 %len, i32 0)
  %goldenPath5 = load ptr, ptr %goldenPath, align 8
  %str.data6 = getelementptr inbounds %String, ptr %goldenPath5, i32 0, i32 1
  %data7 = load ptr, ptr %str.data6, align 8
  %6 = call i32 (ptr, ...) @printf(ptr @.str.5397, ptr %data7)
  ret void

if.end:                                           ; preds = %entry
  %goldenPath8 = load ptr, ptr %goldenPath, align 8
  %str.data9 = getelementptr inbounds %String, ptr %goldenPath8, i32 0, i32 1
  %data10 = load ptr, ptr %str.data9, align 8
  %7 = call i32 @__polaron_file_exists(ptr %data10)
  %8 = icmp eq i32 %7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then11, label %if.end12

if.then11:                                        ; preds = %if.end
  call void @Test.mark()
  %goldenPath13 = load ptr, ptr %goldenPath, align 8
  %str.data14 = getelementptr inbounds %String, ptr %goldenPath13, i32 0, i32 1
  %data15 = load ptr, ptr %str.data14, align 8
  %10 = call i32 (ptr, ...) @printf(ptr @.str.5398, ptr %data15)
  ret void

if.end12:                                         ; preds = %if.end
  %goldenPath16 = load ptr, ptr %goldenPath, align 8
  %fr.len = alloca i64, align 8
  %str.data17 = getelementptr inbounds %String, ptr %goldenPath16, i32 0, i32 1
  %data18 = load ptr, ptr %str.data17, align 8
  %11 = call ptr @__polaron_file_read_all(ptr %data18, ptr %fr.len)
  %fr.n = load i64, ptr %fr.len, align 8
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %fr.n, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %11, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %expected, align 8
  call void @__polaron_str_free(ptr %newstr)
  %actual19 = load ptr, ptr %actual, align 8
  %expected20 = load ptr, ptr %expected, align 8
  %str.data21 = getelementptr inbounds %String, ptr %actual19, i32 0, i32 1
  %data22 = load ptr, ptr %str.data21, align 8
  %str.data23 = getelementptr inbounds %String, ptr %expected20, i32 0, i32 1
  %data24 = load ptr, ptr %str.data23, align 8
  %15 = call i32 @strcmp(ptr %data22, ptr %data24)
  %16 = icmp eq i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %if.end12
  %18 = load ptr, ptr %expected, align 8
  call void @__polaron_str_free(ptr %18)
  ret void

if.end26:                                         ; preds = %if.end12
  %actual27 = load ptr, ptr %actual, align 8
  %19 = call ptr @Strings.split(ptr %actual27, ptr @.strobj.5400)
  store ptr %19, ptr %a, align 8
  %expected28 = load ptr, ptr %expected, align 8
  %20 = call ptr @Strings.split(ptr %expected28, ptr @.strobj.5402)
  store ptr %20, ptr %b, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end42, %if.end26
  %i29 = load i32, ptr %i, align 4
  %a30 = load ptr, ptr %a, align 8
  %21 = call i32 @"ArrayList$String.size"(ptr %a30)
  %22 = icmp slt i32 %i29, %21
  %23 = zext i1 %22 to i32
  %sc.a = icmp ne i32 %23, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body:                                       ; preds = %sc.end
  %a33 = load ptr, ptr %a, align 8
  %i34 = load i32, ptr %i, align 4
  %24 = call ptr @"ArrayList$String.get"(ptr %a33, i32 %i34)
  %b35 = load ptr, ptr %b, align 8
  %i36 = load i32, ptr %i, align 4
  %25 = call ptr @"ArrayList$String.get"(ptr %b35, i32 %i36)
  %str.data37 = getelementptr inbounds %String, ptr %24, i32 0, i32 1
  %data38 = load ptr, ptr %str.data37, align 8
  %str.data39 = getelementptr inbounds %String, ptr %25, i32 0, i32 1
  %data40 = load ptr, ptr %str.data39, align 8
  %26 = call i32 @strcmp(ptr %data38, ptr %data40)
  %27 = icmp eq i32 %26, 0
  %28 = zext i1 %27 to i32
  %29 = icmp eq i32 %28, 0
  %30 = zext i1 %29 to i32
  call void @__polaron_str_free(ptr %24)
  call void @__polaron_str_free(ptr %25)
  br i1 %29, label %if.then41, label %if.end42

while.end:                                        ; preds = %sc.end
  call void @Test.mark()
  %goldenPath56 = load ptr, ptr %goldenPath, align 8
  %str.data57 = getelementptr inbounds %String, ptr %goldenPath56, i32 0, i32 1
  %data58 = load ptr, ptr %str.data57, align 8
  %b59 = load ptr, ptr %b, align 8
  %31 = call i32 @"ArrayList$String.size"(ptr %b59)
  %a60 = load ptr, ptr %a, align 8
  %32 = call i32 @"ArrayList$String.size"(ptr %a60)
  %33 = call i32 (ptr, ...) @printf(ptr @.str.5404, ptr %data58, i32 %31, i32 %32)
  %34 = load ptr, ptr %expected, align 8
  call void @__polaron_str_free(ptr %34)
  ret void

sc.rhs:                                           ; preds = %while.cond
  %i31 = load i32, ptr %i, align 4
  %b32 = load ptr, ptr %b, align 8
  %35 = call i32 @"ArrayList$String.size"(ptr %b32)
  %36 = icmp slt i32 %i31, %35
  %37 = zext i1 %36 to i32
  %sc.b = icmp ne i32 %37, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %sc.rhs ]
  %38 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

if.then41:                                        ; preds = %while.body
  call void @Test.mark()
  %goldenPath43 = load ptr, ptr %goldenPath, align 8
  %str.data44 = getelementptr inbounds %String, ptr %goldenPath43, i32 0, i32 1
  %data45 = load ptr, ptr %str.data44, align 8
  %i46 = load i32, ptr %i, align 4
  %39 = add i32 %i46, 1
  %b47 = load ptr, ptr %b, align 8
  %i48 = load i32, ptr %i, align 4
  %40 = call ptr @"ArrayList$String.get"(ptr %b47, i32 %i48)
  %str.data49 = getelementptr inbounds %String, ptr %40, i32 0, i32 1
  %data50 = load ptr, ptr %str.data49, align 8
  %a51 = load ptr, ptr %a, align 8
  %i52 = load i32, ptr %i, align 4
  %41 = call ptr @"ArrayList$String.get"(ptr %a51, i32 %i52)
  %str.data53 = getelementptr inbounds %String, ptr %41, i32 0, i32 1
  %data54 = load ptr, ptr %str.data53, align 8
  %42 = call i32 (ptr, ...) @printf(ptr @.str.5403, ptr %data45, i32 %39, ptr %data50, ptr %data54)
  call void @__polaron_str_free(ptr %40)
  call void @__polaron_str_free(ptr %41)
  %43 = load ptr, ptr %expected, align 8
  call void @__polaron_str_free(ptr %43)
  ret void

if.end42:                                         ; preds = %while.body
  %i55 = load i32, ptr %i, align 4
  %44 = add i32 %i55, 1
  store i32 %44, ptr %i, align 4
  br label %while.cond
}

define internal ptr @Test.tempDir() {
entry:
  %dir = alloca ptr, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5407)
  store ptr %strcpy, ptr %dir, align 8
  %dir1 = load ptr, ptr %dir, align 8
  %str.data = getelementptr inbounds %String, ptr %dir1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %0 = call i32 @__polaron_file_exists(ptr %data)
  %1 = icmp eq i32 %0, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %dir2 = load ptr, ptr %dir, align 8
  %str.data3 = getelementptr inbounds %String, ptr %dir2, i32 0, i32 1
  %data4 = load ptr, ptr %str.data3, align 8
  %3 = call i32 @__polaron_mkdir(ptr %data4)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %dir5 = load ptr, ptr %dir, align 8
  %strcpy6 = call ptr @__polaron_str_copy(ptr %dir5)
  %4 = load ptr, ptr %dir, align 8
  call void @__polaron_str_free(ptr %4)
  ret ptr %strcpy6
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5409)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5411)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_lower(ptr, i64)

define internal void @__polaron_lambda_0(ptr %0) {
entry:
  %1 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.23)
  %2 = call i32 (ptr, ...) @printf(ptr @.str.24, ptr @.str.25)
  ret void
}

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @__polaron_file_write_all(ptr, ptr, i64, i32)

declare void @__polaron_free(ptr)

define internal void @__polaron_lambda_1(ptr %0) {
entry:
  call void @Test.assertEqual(i32 1, i32 1)
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare void @__polaron_check_live(ptr)

declare i32 @strcmp(ptr, ptr)

declare i64 @__polaron_str_index(ptr, i64, ptr, i64)

declare i64 @__polaron_now_ns()

declare ptr @__polaron_file_read_all(ptr, ptr)

declare i32 @__polaron_str_ends(ptr, i64, ptr, i64)

declare i32 @__polaron_file_exists(ptr)

declare i32 @__polaron_mkdir(ptr)

define i32 @main(i32 %0, ptr %1) {
entry:
  call void @__polaron_test_begin(i32 %0, ptr %1)
  call void @Test.__onClassLoad()
  %2 = call i32 @__polaron_test_should_run(ptr @.test.name, ptr @.test.tags)
  %sel = icmp ne i32 %2, 0
  %any = or i1 false, %sel
  %3 = call i32 @__polaron_test_should_run(ptr @.test.name.5415, ptr @.test.tags.5416)
  %sel1 = icmp ne i32 %3, 0
  %any2 = or i1 %any, %sel1
  %4 = call i32 @__polaron_test_should_run(ptr @.test.name.5417, ptr @.test.tags.5418)
  %sel3 = icmp ne i32 %4, 0
  %any4 = or i1 %any2, %sel3
  %5 = call i32 @__polaron_test_should_run(ptr @.test.name.5419, ptr @.test.tags.5420)
  %sel5 = icmp ne i32 %5, 0
  %any6 = or i1 %any4, %sel5
  %6 = call i32 @__polaron_test_should_run(ptr @.test.name.5421, ptr @.test.tags.5422)
  %sel7 = icmp ne i32 %6, 0
  %any8 = or i1 %any6, %sel7
  br i1 %any8, label %then, label %cont

then:                                             ; preds = %entry
  br label %cont

cont:                                             ; preds = %then, %entry
  %aborted = call i32 @__polaron_test_aborted()
  %7 = icmp eq i32 %aborted, 0
  %live = and i1 %sel, %7
  br i1 %live, label %then9, label %cont10

then9:                                            ; preds = %cont
  %rows = call ptr @Parser.seeds()
  %rows.len = load i64, ptr %rows, align 8
  %row = alloca i64, align 8
  store i64 0, ptr %row, align 8
  br label %rows.cond

cont10:                                           ; preds = %rows.done, %cont
  %aborted12 = call i32 @__polaron_test_aborted()
  %8 = icmp eq i32 %aborted12, 0
  %live13 = and i1 %sel1, %8
  br i1 %live13, label %then14, label %cont15

rows.cond:                                        ; preds = %rows.body, %then9
  %i = load i64, ptr %row, align 8
  %9 = icmp ult i64 %i, %rows.len
  br i1 %9, label %rows.body, label %rows.done

rows.body:                                        ; preds = %rows.cond
  %i11 = load i64, ptr %row, align 8
  %arr.data = getelementptr i8, ptr %rows, i64 8
  %row.elem = getelementptr i32, ptr %arr.data, i64 %i11
  %row.val = load i32, ptr %row.elem, align 4
  %casename = call ptr @__polaron_test_case_name(ptr @.test.name.5423, i64 %i11)
  call void @__polaron_test_start(ptr %casename, i32 0)
  %t0 = call i64 @__polaron_now_ns()
  %failcount = alloca i32, align 4
  store i32 0, ptr %failcount, align 4
  call void @Test.reset()
  call void @Parser.every_seed_lands_in_band(i32 %row.val)
  %fails = call i32 @Test.failures()
  %failed = icmp ne i32 %fails, 0
  %10 = zext i1 %failed to i32
  %11 = load i32, ptr %failcount, align 4
  %12 = add i32 %11, %10
  store i32 %12, ptr %failcount, align 4
  %13 = load i32, ptr %failcount, align 4
  %anyfailed = icmp ne i32 %13, 0
  %t1 = call i64 @__polaron_now_ns()
  %ns = sub i64 %t1, %t0
  %skipped = call i32 @Test.wasSkipped()
  %14 = icmp ne i32 %skipped, 0
  %why = call ptr @Test.skipReason()
  %15 = call ptr @__polaron_str_cstr(ptr %why)
  %16 = select i1 %anyfailed, i32 1, i32 0
  %verdict = select i1 %14, i32 2, i32 %16
  call void @__polaron_test_record(ptr %casename, i32 %verdict, i64 %ns, ptr %15, i64 0)
  %17 = add i64 %i11, 1
  store i64 %17, ptr %row, align 8
  br label %rows.cond

rows.done:                                        ; preds = %rows.cond
  br label %cont10

then14:                                           ; preds = %cont10
  %rows16 = call ptr @Parser.names()
  %rows.len17 = load i64, ptr %rows16, align 8
  %row18 = alloca i64, align 8
  store i64 0, ptr %row18, align 8
  br label %rows.cond19

cont15:                                           ; preds = %rows.done21, %cont10
  %aborted38 = call i32 @__polaron_test_aborted()
  %18 = icmp eq i32 %aborted38, 0
  %live39 = and i1 %sel3, %18
  br i1 %live39, label %then40, label %cont41

rows.cond19:                                      ; preds = %rows.body20, %then14
  %i22 = load i64, ptr %row18, align 8
  %19 = icmp ult i64 %i22, %rows.len17
  br i1 %19, label %rows.body20, label %rows.done21

rows.body20:                                      ; preds = %rows.cond19
  %i23 = load i64, ptr %row18, align 8
  %arr.data24 = getelementptr i8, ptr %rows16, i64 8
  %row.elem25 = getelementptr ptr, ptr %arr.data24, i64 %i23
  %row.val26 = load ptr, ptr %row.elem25, align 8
  %casename27 = call ptr @__polaron_test_case_name(ptr @.test.name.5424, i64 %i23)
  call void @__polaron_test_start(ptr %casename27, i32 0)
  %t028 = call i64 @__polaron_now_ns()
  %failcount29 = alloca i32, align 4
  store i32 0, ptr %failcount29, align 4
  call void @Test.reset()
  call void @Parser.every_name_is_lowercase(ptr %row.val26)
  %fails30 = call i32 @Test.failures()
  %failed31 = icmp ne i32 %fails30, 0
  %20 = zext i1 %failed31 to i32
  %21 = load i32, ptr %failcount29, align 4
  %22 = add i32 %21, %20
  store i32 %22, ptr %failcount29, align 4
  %23 = load i32, ptr %failcount29, align 4
  %anyfailed32 = icmp ne i32 %23, 0
  %t133 = call i64 @__polaron_now_ns()
  %ns34 = sub i64 %t133, %t028
  %skipped35 = call i32 @Test.wasSkipped()
  %24 = icmp ne i32 %skipped35, 0
  %why36 = call ptr @Test.skipReason()
  %25 = call ptr @__polaron_str_cstr(ptr %why36)
  %26 = select i1 %anyfailed32, i32 1, i32 0
  %verdict37 = select i1 %24, i32 2, i32 %26
  call void @__polaron_test_record(ptr %casename27, i32 %verdict37, i64 %ns34, ptr %25, i64 0)
  %27 = add i64 %i23, 1
  store i64 %27, ptr %row18, align 8
  br label %rows.cond19

rows.done21:                                      ; preds = %rows.cond19
  br label %cont15

then40:                                           ; preds = %cont15
  call void @__polaron_test_start(ptr @.test.name.5425, i32 0)
  %t042 = call i64 @__polaron_now_ns()
  %failcount43 = alloca i32, align 4
  store i32 0, ptr %failcount43, align 4
  call void @Test.reset()
  call void @Parser.stable_across_runs()
  %fails44 = call i32 @Test.failures()
  %failed45 = icmp ne i32 %fails44, 0
  br i1 %failed45, label %then46, label %cont47

cont41:                                           ; preds = %cont63, %cont15
  %aborted70 = call i32 @__polaron_test_aborted()
  %28 = icmp eq i32 %aborted70, 0
  %live71 = and i1 %sel5, %28
  br i1 %live71, label %then72, label %cont73

then46:                                           ; preds = %then40
  call void @__polaron_test_repeat_failed(i64 1)
  br label %cont47

cont47:                                           ; preds = %then46, %then40
  %29 = zext i1 %failed45 to i32
  %30 = load i32, ptr %failcount43, align 4
  %31 = add i32 %30, %29
  store i32 %31, ptr %failcount43, align 4
  call void @Test.reset()
  call void @Parser.stable_across_runs()
  %fails48 = call i32 @Test.failures()
  %failed49 = icmp ne i32 %fails48, 0
  br i1 %failed49, label %then50, label %cont51

then50:                                           ; preds = %cont47
  call void @__polaron_test_repeat_failed(i64 2)
  br label %cont51

cont51:                                           ; preds = %then50, %cont47
  %32 = zext i1 %failed49 to i32
  %33 = load i32, ptr %failcount43, align 4
  %34 = add i32 %33, %32
  store i32 %34, ptr %failcount43, align 4
  call void @Test.reset()
  call void @Parser.stable_across_runs()
  %fails52 = call i32 @Test.failures()
  %failed53 = icmp ne i32 %fails52, 0
  br i1 %failed53, label %then54, label %cont55

then54:                                           ; preds = %cont51
  call void @__polaron_test_repeat_failed(i64 3)
  br label %cont55

cont55:                                           ; preds = %then54, %cont51
  %35 = zext i1 %failed53 to i32
  %36 = load i32, ptr %failcount43, align 4
  %37 = add i32 %36, %35
  store i32 %37, ptr %failcount43, align 4
  call void @Test.reset()
  call void @Parser.stable_across_runs()
  %fails56 = call i32 @Test.failures()
  %failed57 = icmp ne i32 %fails56, 0
  br i1 %failed57, label %then58, label %cont59

then58:                                           ; preds = %cont55
  call void @__polaron_test_repeat_failed(i64 4)
  br label %cont59

cont59:                                           ; preds = %then58, %cont55
  %38 = zext i1 %failed57 to i32
  %39 = load i32, ptr %failcount43, align 4
  %40 = add i32 %39, %38
  store i32 %40, ptr %failcount43, align 4
  call void @Test.reset()
  call void @Parser.stable_across_runs()
  %fails60 = call i32 @Test.failures()
  %failed61 = icmp ne i32 %fails60, 0
  br i1 %failed61, label %then62, label %cont63

then62:                                           ; preds = %cont59
  call void @__polaron_test_repeat_failed(i64 5)
  br label %cont63

cont63:                                           ; preds = %then62, %cont59
  %41 = zext i1 %failed61 to i32
  %42 = load i32, ptr %failcount43, align 4
  %43 = add i32 %42, %41
  store i32 %43, ptr %failcount43, align 4
  %44 = load i32, ptr %failcount43, align 4
  %anyfailed64 = icmp ne i32 %44, 0
  %t165 = call i64 @__polaron_now_ns()
  %ns66 = sub i64 %t165, %t042
  %skipped67 = call i32 @Test.wasSkipped()
  %45 = icmp ne i32 %skipped67, 0
  %why68 = call ptr @Test.skipReason()
  %46 = call ptr @__polaron_str_cstr(ptr %why68)
  %47 = select i1 %anyfailed64, i32 1, i32 0
  %verdict69 = select i1 %45, i32 2, i32 %47
  call void @__polaron_test_record(ptr @.test.name.5425, i32 %verdict69, i64 %ns66, ptr %46, i64 0)
  br label %cont41

then72:                                           ; preds = %cont41
  call void @__polaron_test_start(ptr @.test.name.5426, i32 1)
  %t074 = call i64 @__polaron_now_ns()
  %failcount75 = alloca i32, align 4
  store i32 0, ptr %failcount75, align 4
  call void @Test.reset()
  call void @Parser.nested_quotes()
  %fails76 = call i32 @Test.failures()
  %failed77 = icmp ne i32 %fails76, 0
  %48 = zext i1 %failed77 to i32
  %49 = load i32, ptr %failcount75, align 4
  %50 = add i32 %49, %48
  store i32 %50, ptr %failcount75, align 4
  %51 = load i32, ptr %failcount75, align 4
  %anyfailed78 = icmp ne i32 %51, 0
  %t179 = call i64 @__polaron_now_ns()
  %ns80 = sub i64 %t179, %t074
  %skipped81 = call i32 @Test.wasSkipped()
  %52 = icmp ne i32 %skipped81, 0
  %why82 = call ptr @Test.skipReason()
  %53 = call ptr @__polaron_str_cstr(ptr %why82)
  %54 = select i1 %anyfailed78, i32 3, i32 4
  %verdict83 = select i1 %52, i32 2, i32 %54
  call void @__polaron_test_record(ptr @.test.name.5426, i32 %verdict83, i64 %ns80, ptr %53, i64 0)
  br label %cont73

cont73:                                           ; preds = %then72, %cont41
  %aborted84 = call i32 @__polaron_test_aborted()
  %55 = icmp eq i32 %aborted84, 0
  %live85 = and i1 %sel7, %55
  br i1 %live85, label %then86, label %cont87

then86:                                           ; preds = %cont73
  call void @__polaron_test_start(ptr @.test.name.5427, i32 0)
  %t088 = call i64 @__polaron_now_ns()
  %failcount89 = alloca i32, align 4
  store i32 0, ptr %failcount89, align 4
  call void @Test.reset()
  call void @Parser.large_input()
  %fails90 = call i32 @Test.failures()
  %failed91 = icmp ne i32 %fails90, 0
  %56 = zext i1 %failed91 to i32
  %57 = load i32, ptr %failcount89, align 4
  %58 = add i32 %57, %56
  store i32 %58, ptr %failcount89, align 4
  %59 = load i32, ptr %failcount89, align 4
  %anyfailed92 = icmp ne i32 %59, 0
  %t193 = call i64 @__polaron_now_ns()
  %ns94 = sub i64 %t193, %t088
  %skipped95 = call i32 @Test.wasSkipped()
  %60 = icmp ne i32 %skipped95, 0
  %why96 = call ptr @Test.skipReason()
  %61 = call ptr @__polaron_str_cstr(ptr %why96)
  %62 = select i1 %anyfailed92, i32 1, i32 0
  %verdict97 = select i1 %60, i32 2, i32 %62
  call void @__polaron_test_record(ptr @.test.name.5427, i32 %verdict97, i64 %ns94, ptr %61, i64 30000000000)
  br label %cont87

cont87:                                           ; preds = %then86, %cont73
  br i1 %any8, label %then98, label %cont99

then98:                                           ; preds = %cont87
  br label %cont99

cont99:                                           ; preds = %then98, %cont87
  %63 = call i32 @__polaron_test_should_run(ptr @.test.name.5428, ptr @.test.tags.5429)
  %sel100 = icmp ne i32 %63, 0
  %any101 = or i1 false, %sel100
  %64 = call i32 @__polaron_test_should_run(ptr @.test.name.5430, ptr @.test.tags.5431)
  %sel102 = icmp ne i32 %64, 0
  %any103 = or i1 %any101, %sel102
  %65 = call i32 @__polaron_test_should_run(ptr @.test.name.5432, ptr @.test.tags.5433)
  %sel104 = icmp ne i32 %65, 0
  %any105 = or i1 %any103, %sel104
  br i1 %any105, label %then106, label %cont107

then106:                                          ; preds = %cont99
  br label %cont107

cont107:                                          ; preds = %then106, %cont99
  %aborted108 = call i32 @__polaron_test_aborted()
  %66 = icmp eq i32 %aborted108, 0
  %live109 = and i1 %sel100, %66
  br i1 %live109, label %then110, label %cont111

then110:                                          ; preds = %cont107
  call void @__polaron_test_start(ptr @.test.name.5434, i32 0)
  %t0112 = call i64 @__polaron_now_ns()
  %failcount113 = alloca i32, align 4
  store i32 0, ptr %failcount113, align 4
  call void @Test.reset()
  call void @Report.printed_output_is_captured()
  %fails114 = call i32 @Test.failures()
  %failed115 = icmp ne i32 %fails114, 0
  %67 = zext i1 %failed115 to i32
  %68 = load i32, ptr %failcount113, align 4
  %69 = add i32 %68, %67
  store i32 %69, ptr %failcount113, align 4
  %70 = load i32, ptr %failcount113, align 4
  %anyfailed116 = icmp ne i32 %70, 0
  %t1117 = call i64 @__polaron_now_ns()
  %ns118 = sub i64 %t1117, %t0112
  %skipped119 = call i32 @Test.wasSkipped()
  %71 = icmp ne i32 %skipped119, 0
  %why120 = call ptr @Test.skipReason()
  %72 = call ptr @__polaron_str_cstr(ptr %why120)
  %73 = select i1 %anyfailed116, i32 1, i32 0
  %verdict121 = select i1 %71, i32 2, i32 %73
  call void @__polaron_test_record(ptr @.test.name.5434, i32 %verdict121, i64 %ns118, ptr %72, i64 0)
  br label %cont111

cont111:                                          ; preds = %then110, %cont107
  %aborted122 = call i32 @__polaron_test_aborted()
  %74 = icmp eq i32 %aborted122, 0
  %live123 = and i1 %sel102, %74
  br i1 %live123, label %then124, label %cont125

then124:                                          ; preds = %cont111
  call void @__polaron_test_start(ptr @.test.name.5435, i32 0)
  %t0126 = call i64 @__polaron_now_ns()
  %failcount127 = alloca i32, align 4
  store i32 0, ptr %failcount127, align 4
  call void @Test.reset()
  call void @Report.golden_file_comparison()
  %fails128 = call i32 @Test.failures()
  %failed129 = icmp ne i32 %fails128, 0
  %75 = zext i1 %failed129 to i32
  %76 = load i32, ptr %failcount127, align 4
  %77 = add i32 %76, %75
  store i32 %77, ptr %failcount127, align 4
  %78 = load i32, ptr %failcount127, align 4
  %anyfailed130 = icmp ne i32 %78, 0
  %t1131 = call i64 @__polaron_now_ns()
  %ns132 = sub i64 %t1131, %t0126
  %skipped133 = call i32 @Test.wasSkipped()
  %79 = icmp ne i32 %skipped133, 0
  %why134 = call ptr @Test.skipReason()
  %80 = call ptr @__polaron_str_cstr(ptr %why134)
  %81 = select i1 %anyfailed130, i32 1, i32 0
  %verdict135 = select i1 %79, i32 2, i32 %81
  call void @__polaron_test_record(ptr @.test.name.5435, i32 %verdict135, i64 %ns132, ptr %80, i64 0)
  br label %cont125

cont125:                                          ; preds = %then124, %cont111
  %aborted136 = call i32 @__polaron_test_aborted()
  %82 = icmp eq i32 %aborted136, 0
  %live137 = and i1 %sel104, %82
  br i1 %live137, label %then138, label %cont139

then138:                                          ; preds = %cont125
  call void @__polaron_test_start(ptr @.test.name.5436, i32 0)
  %t0140 = call i64 @__polaron_now_ns()
  %failcount141 = alloca i32, align 4
  store i32 0, ptr %failcount141, align 4
  call void @Test.reset()
  call void @Report.the_assertion_surface()
  %fails142 = call i32 @Test.failures()
  %failed143 = icmp ne i32 %fails142, 0
  %83 = zext i1 %failed143 to i32
  %84 = load i32, ptr %failcount141, align 4
  %85 = add i32 %84, %83
  store i32 %85, ptr %failcount141, align 4
  %86 = load i32, ptr %failcount141, align 4
  %anyfailed144 = icmp ne i32 %86, 0
  %t1145 = call i64 @__polaron_now_ns()
  %ns146 = sub i64 %t1145, %t0140
  %skipped147 = call i32 @Test.wasSkipped()
  %87 = icmp ne i32 %skipped147, 0
  %why148 = call ptr @Test.skipReason()
  %88 = call ptr @__polaron_str_cstr(ptr %why148)
  %89 = select i1 %anyfailed144, i32 1, i32 0
  %verdict149 = select i1 %87, i32 2, i32 %89
  call void @__polaron_test_record(ptr @.test.name.5436, i32 %verdict149, i64 %ns146, ptr %88, i64 0)
  br label %cont139

cont139:                                          ; preds = %then138, %cont125
  br i1 %any105, label %then150, label %cont151

then150:                                          ; preds = %cont139
  br label %cont151

cont151:                                          ; preds = %then150, %cont139
  %90 = call i32 @__polaron_bench_should_run(ptr @.bench.name)
  %bsel = icmp ne i32 %90, 0
  br i1 %bsel, label %then152, label %cont153

then152:                                          ; preds = %cont151
  %warm = alloca i64, align 8
  store i64 0, ptr %warm, align 8
  br label %b.cond

cont153:                                          ; preds = %b.done156, %cont151
  %rc = call i32 @__polaron_test_summary()
  ret i32 %rc

b.cond:                                           ; preds = %b.body, %then152
  %91 = load i64, ptr %warm, align 8
  %92 = icmp ult i64 %91, 5
  br i1 %92, label %b.body, label %b.done

b.body:                                           ; preds = %b.cond
  call void @Parser.summing_speed()
  %93 = load i64, ptr %warm, align 8
  %94 = add i64 %93, 1
  store i64 %94, ptr %warm, align 8
  br label %b.cond

b.done:                                           ; preds = %b.cond
  %b0 = call i64 @__polaron_now_ns()
  %iter = alloca i64, align 8
  store i64 0, ptr %iter, align 8
  br label %b.cond154

b.cond154:                                        ; preds = %b.body155, %b.done
  %95 = load i64, ptr %iter, align 8
  %96 = icmp ult i64 %95, 50
  br i1 %96, label %b.body155, label %b.done156

b.body155:                                        ; preds = %b.cond154
  call void @Parser.summing_speed()
  %97 = load i64, ptr %iter, align 8
  %98 = add i64 %97, 1
  store i64 %98, ptr %iter, align 8
  br label %b.cond154

b.done156:                                        ; preds = %b.cond154
  %b1 = call i64 @__polaron_now_ns()
  %bns = sub i64 %b1, %b0
  call void @__polaron_bench_record(ptr @.bench.name, i64 %bns, i64 50)
  br label %cont153
}

declare void @__polaron_test_begin(i32, ptr)

declare i32 @__polaron_test_should_run(ptr, ptr)

declare void @__polaron_test_start(ptr, i32)

declare void @__polaron_test_record(ptr, i32, i64, ptr, i64)

declare i32 @__polaron_test_summary()

declare ptr @__polaron_str_cstr(ptr)

declare ptr @__polaron_test_case_name(ptr, i64)

declare void @__polaron_test_repeat_failed(i64)

declare i32 @__polaron_test_aborted()

declare i32 @__polaron_bench_should_run(ptr)

declare void @__polaron_bench_record(ptr, i64, i64)

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
!9 = !{!10, !10, i64 0}
!10 = !{!"i64", !5, i64 0}
