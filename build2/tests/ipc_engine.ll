; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_server.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_server.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.StereoMixer = type { ptr, i32, i32 }
%class.BundleAccessToken = type { ptr, i64, ptr }
%class.Main = type { ptr }
%"class.HashSet$long" = type { ptr, ptr, ptr, i32, i32 }
%class.IpcReader = type { ptr, ptr, i32 }
%class.IpcWriter = type { ptr, ptr }
%"class.ArrayList$long" = type { ptr, ptr, i32 }
%class.DivideByZeroException = type { ptr }
%__polaron_variant = type { i32, i64 }
%"class.ArrayListIterator$long" = type { ptr, ptr, i32 }
%"class.ArrayList$String" = type { ptr, ptr, i32 }
%"class.ArrayListIterator$String" = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.SecureRandom = type { ptr }

@IpcDispatch.live = private global ptr null
@IpcDispatch.ready = private global i32 0
@IpcServer.nonces = private global ptr null
@IpcServer.caps = private global ptr null
@IpcServer.ready = private global i32 0
@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@StereoMixer.vtable = private constant [353 x ptr] [ptr @StereoMixer.play, ptr @StereoMixer.setVolume, ptr @StereoMixer.volume, ptr @StereoMixer.mixdown, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Main.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayListIterator$String.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$String.hasNext", ptr @"ArrayListIterator$String.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"HashSet$long.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$long.toArray", ptr @"HashSet$long.size", ptr @"HashSet$long.isEmpty", ptr @"HashSet$long.slotFor", ptr @"HashSet$long.grow", ptr @"HashSet$long.add", ptr @"HashSet$long.contains", ptr @"HashSet$long.remove", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$long.~HashSet$long"]
@"ArrayList$long.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$long.toArray", ptr @"ArrayList$long.size", ptr @"ArrayList$long.isEmpty", ptr null, ptr null, ptr @"ArrayList$long.add", ptr @"ArrayList$long.contains", ptr @"ArrayList$long.remove", ptr null, ptr @"ArrayList$long.get", ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$long.ensureCapacity", ptr @"ArrayList$long.set", ptr @"ArrayList$long.indexOf", ptr @"ArrayList$long.removeAt", ptr @"ArrayList$long.insertAt", ptr @"ArrayList$long.clear", ptr @"ArrayList$long.forEach", ptr @"ArrayList$long.filter", ptr @"ArrayList$long.any", ptr @"ArrayList$long.all", ptr @"ArrayList$long.count", ptr @"ArrayList$long.sortedBy", ptr @"ArrayList$long.mergeSortRange", ptr @"ArrayList$long.find", ptr @"ArrayList$long.min", ptr @"ArrayList$long.max", ptr @"ArrayList$long.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$long.~ArrayList$long"]
@"ArrayListIterator$long.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayListIterator$long.hasNext", ptr @"ArrayListIterator$long.next", ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ArrayList$String.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.toArray", ptr @"ArrayList$String.size", ptr @"ArrayList$String.isEmpty", ptr null, ptr null, ptr @"ArrayList$String.add", ptr @"ArrayList$String.contains", ptr @"ArrayList$String.remove", ptr null, ptr @"ArrayList$String.get", ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.ensureCapacity", ptr @"ArrayList$String.set", ptr @"ArrayList$String.indexOf", ptr @"ArrayList$String.removeAt", ptr @"ArrayList$String.insertAt", ptr @"ArrayList$String.clear", ptr @"ArrayList$String.forEach", ptr @"ArrayList$String.filter", ptr @"ArrayList$String.any", ptr @"ArrayList$String.all", ptr @"ArrayList$String.count", ptr @"ArrayList$String.sortedBy", ptr @"ArrayList$String.mergeSortRange", ptr @"ArrayList$String.find", ptr @"ArrayList$String.min", ptr @"ArrayList$String.max", ptr @"ArrayList$String.iterator", ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ArrayList$String.~ArrayList$String"]
@Object.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IpcReader.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcReader.getString, ptr @IpcReader.getInt, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcReader.atEnd, ptr @IpcReader.getByte, ptr @IpcReader.getLong, ptr @IpcReader.getBoolean, ptr @IpcReader.getChar, ptr @IpcReader.getDouble, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@IpcWriter.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcWriter.putByte, ptr @IpcWriter.putLong, ptr @IpcWriter.putInt, ptr @IpcWriter.putBoolean, ptr @IpcWriter.putChar, ptr @IpcWriter.putDouble, ptr @IpcWriter.putString, ptr @IpcWriter.toFrame, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"IpcWriter.~IpcWriter"]
@BundleAccessToken.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BundleAccessToken.nonce, ptr @BundleAccessToken.capability, ptr @BundleAccessToken.granted, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@SecureRandom.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SecureRandom.nextInt, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SecureRandom.nextIntMax, ptr null, ptr @SecureRandom.nextDouble, ptr @SecureRandom.nextBool, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @SecureRandom.nextLong, ptr @SecureRandom.nextBytes, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [26 x i8] c"engine: playing %s (#%d)\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"engine: serving\00", align 1
@.strdata = private constant [11 x i8] c"GameEngine\00"
@.strobj = private global %String { i64 10, ptr @.strdata, i64 0 }
@.strdata.3 = private constant [8 x i8] c"mixdown\00"
@.strobj.4 = private global %String { i64 7, ptr @.strdata.3, i64 0 }
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_0, ptr null]
@.strdata.5 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.6 = private global %String { i64 11, ptr @.strdata.5, i64 0 }
@.strdata.7 = private constant [5 x i8] c"Main\00"
@.strobj.8 = private global %String { i64 4, ptr @.strdata.7, i64 0 }
@.strdata.9 = private constant [15 x i8] c"no such type: \00"
@.strobj.10 = private global %String { i64 14, ptr @.strdata.9, i64 0 }
@.strdata.11 = private constant [15 x i8] c"unknown object\00"
@.strobj.12 = private global %String { i64 14, ptr @.strdata.11, i64 0 }
@.strdata.13 = private constant [15 x i8] c"unknown object\00"
@.strobj.14 = private global %String { i64 14, ptr @.strdata.13, i64 0 }
@.strdata.15 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.16 = private global %String { i64 11, ptr @.strdata.15, i64 0 }
@.strdata.17 = private constant [5 x i8] c"play\00"
@.strobj.18 = private global %String { i64 4, ptr @.strdata.17, i64 0 }
@.strdata.19 = private constant [10 x i8] c"setVolume\00"
@.strobj.20 = private global %String { i64 9, ptr @.strdata.19, i64 0 }
@.strdata.21 = private constant [7 x i8] c"volume\00"
@.strobj.22 = private global %String { i64 6, ptr @.strdata.21, i64 0 }
@.strdata.23 = private constant [8 x i8] c"mixdown\00"
@.strobj.24 = private global %String { i64 7, ptr @.strdata.23, i64 0 }
@.strdata.25 = private constant [8 x i8] c"mixdown\00"
@.strobj.26 = private global %String { i64 7, ptr @.strdata.25, i64 0 }
@.strdata.27 = private constant [20 x i8] c"capability required\00"
@.strobj.28 = private global %String { i64 19, ptr @.strdata.27, i64 0 }
@.strdata.29 = private constant [8 x i8] c"mixdown\00"
@.strobj.30 = private global %String { i64 7, ptr @.strdata.29, i64 0 }
@.strdata.31 = private constant [15 x i8] c"no such method\00"
@.strobj.32 = private global %String { i64 14, ptr @.strdata.31, i64 0 }
@.strdata.33 = private constant [10 x i8] c"bad frame\00"
@.strobj.34 = private global %String { i64 9, ptr @.strdata.33, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.fail.74 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1133:17  in HashSet$long.slotFor\0A\00", align 1
@.faila.75 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.76 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.77 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1134:21  in HashSet$long.slotFor\0A\00", align 1
@.faila.78 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.79 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.80 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1148:21  in HashSet$long.grow\0A\00", align 1
@.faila.81 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.82 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.83 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1148:49  in HashSet$long.grow\0A\00", align 1
@.faila.84 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.85 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.86 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1156:17  in HashSet$long.add\0A\00", align 1
@.faila.87 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.88 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.89 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1157:34  in HashSet$long.add\0A\00", align 1
@.faila.90 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.91 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.92 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1158:35  in HashSet$long.add\0A\00", align 1
@.faila.93 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.94 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.95 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1163:17  in HashSet$long.contains\0A\00", align 1
@.faila.96 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.97 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.98 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1167:17  in HashSet$long.remove\0A\00", align 1
@.faila.99 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.100 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.101 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1169:30  in HashSet$long.remove\0A\00", align 1
@.faila.102 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.103 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.104 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1172:17  in HashSet$long.remove\0A\00", align 1
@.faila.105 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.106 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.107 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1173:21  in HashSet$long.remove\0A\00", align 1
@.faila.108 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.109 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.110 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1174:34  in HashSet$long.remove\0A\00", align 1
@.faila.111 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.112 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.113 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:21  in HashSet$long.toArray\0A\00", align 1
@.faila.114 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.115 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.116 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:53  in HashSet$long.toArray\0A\00", align 1
@.faila.117 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.118 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.119 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:53  in HashSet$long.toArray\0A\00", align 1
@.faila.120 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.121 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.754 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.ArrayList$long\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.755 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.756 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.757 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.ArrayList$long\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.758 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$long.add\0A\00", align 1
@.faila.759 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.760 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.761 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$long.add\0A\00", align 1
@.faila.762 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.763 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.764 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$long.add\0A\00", align 1
@.faila.765 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.766 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.767 = private unnamed_addr constant [122 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$long.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.768 = private unnamed_addr constant [109 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.769 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.770 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.771 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.772 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$long.ensureCapacity\0A\00", align 1
@.faila.773 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.774 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.775 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$long.ensureCapacity\0A\00", align 1
@.faila.776 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.777 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.778 = private unnamed_addr constant [120 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.779 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.780 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.781 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.782 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$long.get\0A\00", align 1
@.faila.783 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.784 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.785 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$long.get\0A\00", align 1
@.faila.786 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.787 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.788 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$long.set\0A\00", align 1
@.faila.789 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.790 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.791 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.792 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$long.set\0A\00", align 1
@.faila.793 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.794 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.795 = private unnamed_addr constant [126 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.796 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$long.indexOf\0A\00", align 1
@.faila.797 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.798 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.799 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$long.removeAt\0A\00", align 1
@.faila.800 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.801 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.802 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.803 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.804 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.805 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.806 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$long.removeAt\0A\00", align 1
@.faila.807 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.808 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.809 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$long.removeAt\0A\00", align 1
@.faila.810 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.811 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.812 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.813 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.814 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.815 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.816 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$long.insertAt\0A\00", align 1
@.faila.817 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.818 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.819 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.820 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.821 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.822 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.823 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$long.insertAt\0A\00", align 1
@.faila.824 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.825 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.826 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$long.insertAt\0A\00", align 1
@.faila.827 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.828 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.829 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$long.insertAt\0A\00", align 1
@.faila.830 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.831 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.832 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$long.insertAt\0A\00", align 1
@.faila.833 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.834 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.835 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$long.insertAt\0A\00", align 1
@.faila.836 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.837 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.838 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.839 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.840 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.841 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.842 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.843 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.844 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.845 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.846 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$long.toArray\0A\00", align 1
@.faila.847 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.848 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.849 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$long.toArray\0A\00", align 1
@.faila.850 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.851 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.852 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$long.forEach\0A\00", align 1
@.faila.853 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.854 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.855 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$long.filter\0A\00", align 1
@.faila.856 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.857 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.858 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$long.filter\0A\00", align 1
@.faila.859 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.860 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.861 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$long.any\0A\00", align 1
@.faila.862 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.863 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.864 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$long.all\0A\00", align 1
@.faila.865 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.866 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.867 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$long.count\0A\00", align 1
@.faila.868 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.869 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.870 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$long.sortedBy\0A\00", align 1
@.faila.871 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.872 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.873 = private unnamed_addr constant [114 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$long.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.874 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.875 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.876 = private unnamed_addr constant [131 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.877 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.878 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.879 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.880 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.881 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.882 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.883 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.884 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.885 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.886 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.887 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.888 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.889 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.890 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.891 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.892 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.893 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.894 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.895 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.896 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.897 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.898 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.899 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.900 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.901 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.902 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.903 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.904 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.905 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.906 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.907 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.908 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.909 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.910 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.911 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.912 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.913 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.914 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.915 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.916 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.917 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.918 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.919 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.920 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.921 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.922 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.923 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.924 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.925 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.926 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.927 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.928 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.929 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.930 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.931 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.932 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.933 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.934 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$long.mergeSortRange\0A\00", align 1
@.faila.935 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.936 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.937 = private unnamed_addr constant [137 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$long.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.938 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$long.find\0A\00", align 1
@.faila.939 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.940 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.941 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$long.find\0A\00", align 1
@.faila.942 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.943 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.944 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$long.min\0A\00", align 1
@.faila.945 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.946 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.947 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$long.min\0A\00", align 1
@.faila.948 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.949 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.950 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$long.min\0A\00", align 1
@.faila.951 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.952 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.953 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$long.max\0A\00", align 1
@.faila.954 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.955 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.956 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$long.max\0A\00", align 1
@.faila.957 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.958 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.959 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$long.max\0A\00", align 1
@.faila.960 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.961 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1170 = private unnamed_addr constant [124 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1171 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1172 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1173 = private unnamed_addr constant [141 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ArrayList$String\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1174 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1175 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1176 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1177 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:320:35  in ArrayList$String.add\0A\00", align 1
@.faila.1178 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1179 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1180 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:325:39  in ArrayList$String.add\0A\00", align 1
@.faila.1181 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1182 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1183 = private unnamed_addr constant [124 x i8] c"contract violated: ensures\0A  --> <prelude>:315:36  in ArrayList$String.add\0A   |  ensures this.count == old(this.count) + 1\0A\00", align 1
@.contract.1184 = private unnamed_addr constant [111 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.add\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1185 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1186 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1187 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.add\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1188 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1189 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1190 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1191 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:334:78  in ArrayList$String.ensureCapacity\0A\00", align 1
@.faila.1192 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1193 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1194 = private unnamed_addr constant [122 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1195 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1196 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1197 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.ensureCapacity\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1198 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:345:21  in ArrayList$String.get\0A\00", align 1
@.faila.1199 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1200 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1201 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:347:17  in ArrayList$String.get\0A\00", align 1
@.faila.1202 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1203 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1204 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:351:51  in ArrayList$String.set\0A\00", align 1
@.faila.1205 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1206 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1207 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1208 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:354:30  in ArrayList$String.set\0A\00", align 1
@.faila.1209 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1210 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1211 = private unnamed_addr constant [128 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.set\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1212 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:358:21  in ArrayList$String.indexOf\0A\00", align 1
@.faila.1213 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1214 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1215 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:369:21  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1216 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1217 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1218 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1219 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1220 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1221 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1222 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1223 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1224 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1225 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:373:34  in ArrayList$String.removeAt\0A\00", align 1
@.faila.1226 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1227 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1228 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.removeAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1229 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1230 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1231 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.removeAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1232 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:379:51  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1233 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1234 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1235 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1236 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1237 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1238 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1239 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1240 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1241 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1242 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:384:78  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1243 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1244 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1245 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1246 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1247 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1248 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:389:34  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1249 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1250 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1251 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:391:30  in ArrayList$String.insertAt\0A\00", align 1
@.faila.1252 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1253 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1254 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.insertAt\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1255 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1256 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1257 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.insertAt\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1258 = private unnamed_addr constant [113 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.clear\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1259 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1260 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1261 = private unnamed_addr constant [130 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.clear\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1262 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1263 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1264 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1265 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:405:71  in ArrayList$String.toArray\0A\00", align 1
@.faila.1266 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1267 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1268 = private unnamed_addr constant [94 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:416:70  in ArrayList$String.forEach\0A\00", align 1
@.faila.1269 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1270 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1271 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:21  in ArrayList$String.filter\0A\00", align 1
@.faila.1272 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1273 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1274 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:422:54  in ArrayList$String.filter\0A\00", align 1
@.faila.1275 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1276 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1277 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:439:21  in ArrayList$String.any\0A\00", align 1
@.faila.1278 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1279 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1280 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:445:21  in ArrayList$String.all\0A\00", align 1
@.faila.1281 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1282 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1283 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:452:21  in ArrayList$String.count\0A\00", align 1
@.faila.1284 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1285 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1286 = private unnamed_addr constant [95 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:462:71  in ArrayList$String.sortedBy\0A\00", align 1
@.faila.1287 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1288 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1289 = private unnamed_addr constant [116 x i8] c"contract violated: invariant\0A  --> <prelude>:300:34  in ArrayList$String.sortedBy\0A   |  invariant this.count >= 0;\0A\00", align 1
@.cl.1290 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.1291 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1292 = private unnamed_addr constant [133 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.sortedBy\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.contract.1293 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1294 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:478:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1295 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1296 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1297 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:480:25  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1298 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1299 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1300 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1303 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:481:46  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1306 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:484:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1309 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1310 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1311 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1312 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1313 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:491:17  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1314 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1315 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1316 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1317 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1318 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1319 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1320 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:496:21  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1321 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1322 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1323 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1324 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1325 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1326 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:497:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1327 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1328 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1329 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1330 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1331 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1332 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:500:32  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1333 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1334 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1335 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1336 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1337 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1338 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:505:43  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1339 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1340 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1341 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1342 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1343 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1344 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:506:42  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1345 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1346 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1347 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1348 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1349 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1350 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:507:77  in ArrayList$String.mergeSortRange\0A\00", align 1
@.faila.1351 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1352 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.contract.1353 = private unnamed_addr constant [139 x i8] c"contract violated: invariant\0A  --> <prelude>:301:34  in ArrayList$String.mergeSortRange\0A   |  invariant this.count <= this.data.length();\0A\00", align 1
@.fail.1354 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:21  in ArrayList$String.find\0A\00", align 1
@.faila.1355 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1356 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1357 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:514:47  in ArrayList$String.find\0A\00", align 1
@.faila.1358 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1359 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1360 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:520:17  in ArrayList$String.min\0A\00", align 1
@.faila.1361 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1362 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1363 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:21  in ArrayList$String.min\0A\00", align 1
@.faila.1364 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1365 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1366 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:522:65  in ArrayList$String.min\0A\00", align 1
@.faila.1367 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1368 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1369 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:528:17  in ArrayList$String.max\0A\00", align 1
@.faila.1370 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1371 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1372 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:21  in ArrayList$String.max\0A\00", align 1
@.faila.1373 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1374 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1375 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:530:65  in ArrayList$String.max\0A\00", align 1
@.faila.1376 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1377 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1388 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1389 = private global %String { i64 16, ptr @.strdata.1388, i64 0 }
@.strdata.1390 = private constant [17 x i8] c"division by zero\00"
@.strobj.1391 = private global %String { i64 16, ptr @.strdata.1390, i64 0 }
@.strdata.3991 = private constant [21 x i8] c"capability refused: \00"
@.strobj.3992 = private global %String { i64 20, ptr @.strdata.3991, i64 0 }
@.fail.4031 = private unnamed_addr constant [93 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8224:28  in SecureRandom.nextBytes\0A\00", align 1
@.faila.4032 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4033 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5388 = private constant [1 x i8] zeroinitializer
@.strobj.5389 = private global %String { i64 0, ptr @.strdata.5388, i64 0 }
@.strdata.5390 = private constant [1 x i8] zeroinitializer
@.strobj.5391 = private global %String { i64 0, ptr @.strdata.5390, i64 0 }

define internal void @StereoMixer.StereoMixer(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 0
  store ptr @StereoMixer.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %volume = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  store i32 5, ptr %volume, align 4, !tbaa !4
  %plays = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  store i32 0, ptr %plays, align 4, !tbaa !4
  ret void
}

define internal i32 @StereoMixer.play(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %sound = alloca ptr, align 8
  store ptr %1, ptr %sound, align 8
  %plays = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %plays1 = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %plays2 = load i32, ptr %plays1, align 4, !tbaa !4
  %2 = add i32 %plays2, 1
  store i32 %2, ptr %plays, align 4, !tbaa !4
  %sound3 = load ptr, ptr %sound, align 8
  %str.data = getelementptr inbounds %String, ptr %sound3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %plays4 = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %plays5 = load i32, ptr %plays4, align 4, !tbaa !4
  %3 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data, i32 %plays5)
  %plays6 = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %plays7 = load i32, ptr %plays6, align 4, !tbaa !4
  ret i32 %plays7
}

define internal void @StereoMixer.setVolume(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %volume = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4
  store i32 %v1, ptr %volume, align 4, !tbaa !4
  ret void
}

define internal i32 @StereoMixer.volume(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %volume = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %volume1 = load i32, ptr %volume, align 4, !tbaa !4
  ret i32 %volume1
}

define internal i32 @StereoMixer.mixdown(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %BundleAccessToken.copy = alloca %class.BundleAccessToken, align 8
  %mixdown = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BundleAccessToken.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BundleAccessToken, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BundleAccessToken, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  %5 = getelementptr inbounds %class.BundleAccessToken, ptr %BundleAccessToken.copy, i32 0, i32 2
  store ptr %strcpy, ptr %5, align 8, !tbaa !0
  store ptr %BundleAccessToken.copy, ptr %mixdown, align 8
  %volume = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %volume1 = load i32, ptr %volume, align 4, !tbaa !4
  %6 = mul i32 %volume1, 100
  ret i32 %6
}

define i32 @main(i32 %0, ptr %1) {
entry:
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
  %16 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr @.str.2)
  call void @Program.serve(ptr @.strobj, ptr @__polaron_closure)
  ret i32 0
}

define internal void @Main.Main(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Main, ptr %0, i32 0, i32 0
  store ptr @Main.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal void @IpcDispatch.ensure() {
entry:
  %ready = load i32, ptr @IpcDispatch.ready, align 4
  %0 = icmp eq i32 %ready, 0
  %1 = zext i1 %0 to i32
  br i1 %0, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %"HashSet$long.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.HashSet$long", ptr null, i64 1) to i64))
  call void @"HashSet$long.HashSet$long"(ptr %"HashSet$long.obj")
  store ptr %"HashSet$long.obj", ptr @IpcDispatch.live, align 8
  store i32 1, ptr @IpcDispatch.ready, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal i64 @IpcDispatch.lend(i64 %0) {
entry:
  %id = alloca i64, align 8
  %obj = alloca i64, align 8
  store i64 %0, ptr %obj, align 8
  call void @IpcDispatch.ensure()
  %obj1 = load i64, ptr %obj, align 8
  store i64 %obj1, ptr %id, align 8
  %live = load ptr, ptr @IpcDispatch.live, align 8
  %id2 = load i64, ptr %id, align 8
  call void @"HashSet$long.add"(ptr %live, i64 %id2)
  %id3 = load i64, ptr %id, align 8
  ret i64 %id3
}

define internal i32 @IpcDispatch.known(i64 %0) {
entry:
  %id = alloca i64, align 8
  store i64 %0, ptr %id, align 8
  call void @IpcDispatch.ensure()
  %live = load ptr, ptr @IpcDispatch.live, align 8
  %id1 = load i64, ptr %id, align 8
  %1 = call i32 @"HashSet$long.contains"(ptr %live, i64 %id1)
  ret i32 %1
}

define internal i32 @IpcDispatch.revoke(i64 %0) {
entry:
  %id = alloca i64, align 8
  store i64 %0, ptr %id, align 8
  call void @IpcDispatch.ensure()
  %live = load ptr, ptr @IpcDispatch.live, align 8
  %id1 = load i64, ptr %id, align 8
  %1 = call i32 @"HashSet$long.contains"(ptr %live, i64 %id1)
  %2 = icmp eq i32 %1, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %live2 = load ptr, ptr @IpcDispatch.live, align 8
  %id3 = load i64, ptr %id, align 8
  %4 = call i32 @"HashSet$long.remove"(ptr %live2, i64 %id3)
  ret i32 1
}

define internal ptr @IpcDispatch.handle(ptr %0) {
entry:
  %f244 = alloca ptr, align 8
  %out239 = alloca i32, align 4
  %w235 = alloca ptr, align 8
  %self225 = alloca ptr, align 8
  %mixdown = alloca ptr, align 8
  %__tok_mixdown = alloca i64, align 8
  %f194 = alloca ptr, align 8
  %out189 = alloca i32, align 4
  %w186 = alloca ptr, align 8
  %self176 = alloca ptr, align 8
  %f159 = alloca ptr, align 8
  %w153 = alloca ptr, align 8
  %self143 = alloca ptr, align 8
  %v = alloca i32, align 4
  %f125 = alloca ptr, align 8
  %out = alloca i32, align 4
  %w117 = alloca ptr, align 8
  %self = alloca ptr, align 8
  %sound = alloca ptr, align 8
  %meth = alloca ptr, align 8
  %type78 = alloca ptr, align 8
  %id75 = alloca i64, align 8
  %id = alloca i64, align 8
  %f38 = alloca ptr, align 8
  %w32 = alloca ptr, align 8
  %o30 = alloca ptr, align 8
  %f = alloca ptr, align 8
  %w = alloca ptr, align 8
  %o = alloca ptr, align 8
  %type = alloca ptr, align 8
  %kind = alloca i32, align 4
  %r = alloca ptr, align 8
  %frame = alloca ptr, align 8
  store ptr %0, ptr %frame, align 8
  %IpcReader.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcReader, ptr null, i64 1) to i64))
  %frame1 = load ptr, ptr %frame, align 8
  call void @IpcReader.IpcReader(ptr %IpcReader.obj, ptr %frame1)
  store ptr %IpcReader.obj, ptr %r, align 8
  %r2 = load ptr, ptr %r, align 8
  %1 = call i32 @IpcReader.getByte(ptr %r2)
  store i32 %1, ptr %kind, align 4
  %kind3 = load i32, ptr %kind, align 4
  %2 = call i32 @IpcProto.kCreate()
  %3 = icmp eq i32 %kind3, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %r4 = load ptr, ptr %r, align 8
  %5 = call ptr @IpcReader.getString(ptr %r4)
  %strcpy = call ptr @__polaron_str_copy(ptr %5)
  store ptr %strcpy, ptr %type, align 8
  call void @__polaron_str_free(ptr %5)
  %r5 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r5)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r5, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %6 = icmp ne ptr %dtor.fn, null
  br i1 %6, label %dtor.call, label %dtor.free

if.end:                                           ; preds = %entry
  %kind54 = load i32, ptr %kind, align 4
  %7 = call i32 @IpcProto.kRelease()
  %8 = icmp eq i32 %kind54, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then55, label %if.end56

dtor.call:                                        ; preds = %if.then
  call void %dtor.fn(ptr %r5)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.then
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r5, i32 0, i32 1
  %10 = load ptr, ptr %buf.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %10)
  call void @__polaron_free(ptr %r5)
  %type6 = load ptr, ptr %type, align 8
  %str.data = getelementptr inbounds %String, ptr %type6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data7 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %11 = call i32 @strcmp(ptr %data, ptr %data7)
  %12 = icmp eq i32 %11, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then8, label %if.end9

if.then8:                                         ; preds = %dtor.free
  %StereoMixer.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StereoMixer, ptr null, i64 1) to i64))
  call void @StereoMixer.StereoMixer(ptr %StereoMixer.obj)
  store ptr %StereoMixer.obj, ptr %o, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w10 = load ptr, ptr %w, align 8
  %14 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w10, i32 %14)
  %w11 = load ptr, ptr %w, align 8
  %o12 = load ptr, ptr %o, align 8
  %15 = ptrtoint ptr %o12 to i64
  %16 = call i64 @IpcDispatch.lend(i64 %15)
  call void @IpcWriter.putLong(ptr %w11, i64 %16)
  %w13 = load ptr, ptr %w, align 8
  %17 = call ptr @IpcWriter.toFrame(ptr %w13)
  %strcpy14 = call ptr @__polaron_str_copy(ptr %17)
  store ptr %strcpy14, ptr %f, align 8
  call void @__polaron_str_free(ptr %17)
  %w15 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w15)
  %vtbl.addr16 = getelementptr inbounds %class.IpcWriter, ptr %w15, i32 0, i32 0
  %vtbl17 = load ptr, ptr %vtbl.addr16, align 8, !tbaa !0
  %dtor.slot18 = getelementptr [353 x ptr], ptr %vtbl17, i64 0, i64 352
  %dtor.fn19 = load ptr, ptr %dtor.slot18, align 8
  %18 = icmp ne ptr %dtor.fn19, null
  br i1 %18, label %dtor.call20, label %dtor.free21

if.end9:                                          ; preds = %dtor.free
  %type24 = load ptr, ptr %type, align 8
  %str.data25 = getelementptr inbounds %String, ptr %type24, i32 0, i32 1
  %data26 = load ptr, ptr %str.data25, align 8
  %data27 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.8, i32 0, i32 1), align 8
  %19 = call i32 @strcmp(ptr %data26, ptr %data27)
  %20 = icmp eq i32 %19, 0
  %21 = zext i1 %20 to i32
  br i1 %20, label %if.then28, label %if.end29

dtor.call20:                                      ; preds = %if.then8
  call void %dtor.fn19(ptr %w15)
  br label %dtor.free21

dtor.free21:                                      ; preds = %dtor.call20, %if.then8
  call void @__polaron_free(ptr %w15)
  %f22 = load ptr, ptr %f, align 8
  %strcpy23 = call ptr @__polaron_str_copy(ptr %f22)
  %22 = load ptr, ptr %f, align 8
  call void @__polaron_str_free(ptr %22)
  %23 = load ptr, ptr %type, align 8
  call void @__polaron_str_free(ptr %23)
  ret ptr %strcpy23

if.then28:                                        ; preds = %if.end9
  %Main.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Main, ptr null, i64 1) to i64))
  call void @Main.Main(ptr %Main.obj)
  store ptr %Main.obj, ptr %o30, align 8
  %IpcWriter.obj31 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj31)
  store ptr %IpcWriter.obj31, ptr %w32, align 8
  %w33 = load ptr, ptr %w32, align 8
  %24 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w33, i32 %24)
  %w34 = load ptr, ptr %w32, align 8
  %o35 = load ptr, ptr %o30, align 8
  %25 = ptrtoint ptr %o35 to i64
  %26 = call i64 @IpcDispatch.lend(i64 %25)
  call void @IpcWriter.putLong(ptr %w34, i64 %26)
  %w36 = load ptr, ptr %w32, align 8
  %27 = call ptr @IpcWriter.toFrame(ptr %w36)
  %strcpy37 = call ptr @__polaron_str_copy(ptr %27)
  store ptr %strcpy37, ptr %f38, align 8
  call void @__polaron_str_free(ptr %27)
  %w39 = load ptr, ptr %w32, align 8
  call void @__polaron_check_live(ptr %w39)
  %vtbl.addr40 = getelementptr inbounds %class.IpcWriter, ptr %w39, i32 0, i32 0
  %vtbl41 = load ptr, ptr %vtbl.addr40, align 8, !tbaa !0
  %dtor.slot42 = getelementptr [353 x ptr], ptr %vtbl41, i64 0, i64 352
  %dtor.fn43 = load ptr, ptr %dtor.slot42, align 8
  %28 = icmp ne ptr %dtor.fn43, null
  br i1 %28, label %dtor.call44, label %dtor.free45

if.end29:                                         ; preds = %if.end9
  %type48 = load ptr, ptr %type, align 8
  %len = load i64, ptr @.strobj.10, align 8
  %str.len = getelementptr inbounds %String, ptr %type48, i32 0, i32 0
  %len49 = load i64, ptr %str.len, align 8
  %29 = add i64 %len, %len49
  %30 = add i64 %29, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %30)
  %data50 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.10, i32 0, i32 1), align 8
  %31 = call ptr @memcpy(ptr %cat.buf, ptr %data50, i64 %len)
  %str.data51 = getelementptr inbounds %String, ptr %type48, i32 0, i32 1
  %data52 = load ptr, ptr %str.data51, align 8
  %32 = getelementptr i8, ptr %cat.buf, i64 %len
  %33 = call ptr @memcpy(ptr %32, ptr %data52, i64 %len49)
  %34 = getelementptr i8, ptr %cat.buf, i64 %29
  store i8 0, ptr %34, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %38 = call ptr @IpcProto.errorFrame(ptr %newstr)
  %strcpy53 = call ptr @__polaron_str_copy(ptr %38)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %38)
  %39 = load ptr, ptr %type, align 8
  call void @__polaron_str_free(ptr %39)
  ret ptr %strcpy53

dtor.call44:                                      ; preds = %if.then28
  call void %dtor.fn43(ptr %w39)
  br label %dtor.free45

dtor.free45:                                      ; preds = %dtor.call44, %if.then28
  call void @__polaron_free(ptr %w39)
  %f46 = load ptr, ptr %f38, align 8
  %strcpy47 = call ptr @__polaron_str_copy(ptr %f46)
  %40 = load ptr, ptr %f38, align 8
  call void @__polaron_str_free(ptr %40)
  %41 = load ptr, ptr %type, align 8
  call void @__polaron_str_free(ptr %41)
  ret ptr %strcpy47

if.then55:                                        ; preds = %if.end
  %r57 = load ptr, ptr %r, align 8
  %42 = call i64 @IpcReader.getLong(ptr %r57)
  store i64 %42, ptr %id, align 8
  %r58 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r58)
  %vtbl.addr59 = getelementptr inbounds %class.IpcReader, ptr %r58, i32 0, i32 0
  %vtbl60 = load ptr, ptr %vtbl.addr59, align 8, !tbaa !0
  %dtor.slot61 = getelementptr [353 x ptr], ptr %vtbl60, i64 0, i64 352
  %dtor.fn62 = load ptr, ptr %dtor.slot61, align 8
  %43 = icmp ne ptr %dtor.fn62, null
  br i1 %43, label %dtor.call63, label %dtor.free64

if.end56:                                         ; preds = %if.end
  %kind71 = load i32, ptr %kind, align 4
  %44 = call i32 @IpcProto.kCall()
  %45 = icmp eq i32 %kind71, %44
  %46 = zext i1 %45 to i32
  br i1 %45, label %if.then72, label %if.end73

dtor.call63:                                      ; preds = %if.then55
  call void %dtor.fn62(ptr %r58)
  br label %dtor.free64

dtor.free64:                                      ; preds = %dtor.call63, %if.then55
  %buf.sfree65 = getelementptr inbounds %class.IpcReader, ptr %r58, i32 0, i32 1
  %47 = load ptr, ptr %buf.sfree65, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %47)
  call void @__polaron_free(ptr %r58)
  %id66 = load i64, ptr %id, align 8
  %48 = call i32 @IpcDispatch.revoke(i64 %id66)
  %49 = icmp eq i32 %48, 0
  %50 = zext i1 %49 to i32
  br i1 %49, label %if.then67, label %if.end68

if.then67:                                        ; preds = %dtor.free64
  %51 = call ptr @IpcProto.errorFrame(ptr @.strobj.12)
  %strcpy69 = call ptr @__polaron_str_copy(ptr %51)
  call void @__polaron_str_free(ptr %51)
  ret ptr %strcpy69

if.end68:                                         ; preds = %dtor.free64
  %52 = call ptr @IpcProto.okFrame()
  %strcpy70 = call ptr @__polaron_str_copy(ptr %52)
  call void @__polaron_str_free(ptr %52)
  ret ptr %strcpy70

if.then72:                                        ; preds = %if.end56
  %r74 = load ptr, ptr %r, align 8
  %53 = call i64 @IpcReader.getLong(ptr %r74)
  store i64 %53, ptr %id75, align 8
  %r76 = load ptr, ptr %r, align 8
  %54 = call ptr @IpcReader.getString(ptr %r76)
  %strcpy77 = call ptr @__polaron_str_copy(ptr %54)
  store ptr %strcpy77, ptr %type78, align 8
  call void @__polaron_str_free(ptr %54)
  %r79 = load ptr, ptr %r, align 8
  %55 = call ptr @IpcReader.getString(ptr %r79)
  %strcpy80 = call ptr @__polaron_str_copy(ptr %55)
  store ptr %strcpy80, ptr %meth, align 8
  call void @__polaron_str_free(ptr %55)
  %id81 = load i64, ptr %id75, align 8
  %56 = call i32 @IpcDispatch.known(i64 %id81)
  %57 = icmp eq i32 %56, 0
  %58 = zext i1 %57 to i32
  br i1 %57, label %if.then82, label %if.end83

if.end73:                                         ; preds = %if.end56
  %r263 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r263)
  %vtbl.addr264 = getelementptr inbounds %class.IpcReader, ptr %r263, i32 0, i32 0
  %vtbl265 = load ptr, ptr %vtbl.addr264, align 8, !tbaa !0
  %dtor.slot266 = getelementptr [353 x ptr], ptr %vtbl265, i64 0, i64 352
  %dtor.fn267 = load ptr, ptr %dtor.slot266, align 8
  %59 = icmp ne ptr %dtor.fn267, null
  br i1 %59, label %dtor.call268, label %dtor.free269

if.then82:                                        ; preds = %if.then72
  %r84 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r84)
  %vtbl.addr85 = getelementptr inbounds %class.IpcReader, ptr %r84, i32 0, i32 0
  %vtbl86 = load ptr, ptr %vtbl.addr85, align 8, !tbaa !0
  %dtor.slot87 = getelementptr [353 x ptr], ptr %vtbl86, i64 0, i64 352
  %dtor.fn88 = load ptr, ptr %dtor.slot87, align 8
  %60 = icmp ne ptr %dtor.fn88, null
  br i1 %60, label %dtor.call89, label %dtor.free90

if.end83:                                         ; preds = %if.then72
  %type93 = load ptr, ptr %type78, align 8
  %str.data94 = getelementptr inbounds %String, ptr %type93, i32 0, i32 1
  %data95 = load ptr, ptr %str.data94, align 8
  %data96 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.16, i32 0, i32 1), align 8
  %61 = call i32 @strcmp(ptr %data95, ptr %data96)
  %62 = icmp eq i32 %61, 0
  %63 = zext i1 %62 to i32
  br i1 %62, label %if.then97, label %if.end98

dtor.call89:                                      ; preds = %if.then82
  call void %dtor.fn88(ptr %r84)
  br label %dtor.free90

dtor.free90:                                      ; preds = %dtor.call89, %if.then82
  %buf.sfree91 = getelementptr inbounds %class.IpcReader, ptr %r84, i32 0, i32 1
  %64 = load ptr, ptr %buf.sfree91, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %64)
  call void @__polaron_free(ptr %r84)
  %65 = call ptr @IpcProto.errorFrame(ptr @.strobj.14)
  %strcpy92 = call ptr @__polaron_str_copy(ptr %65)
  call void @__polaron_str_free(ptr %65)
  %66 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %66)
  %67 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %67)
  ret ptr %strcpy92

if.then97:                                        ; preds = %if.end83
  %meth99 = load ptr, ptr %meth, align 8
  %str.data100 = getelementptr inbounds %String, ptr %meth99, i32 0, i32 1
  %data101 = load ptr, ptr %str.data100, align 8
  %data102 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.18, i32 0, i32 1), align 8
  %68 = call i32 @strcmp(ptr %data101, ptr %data102)
  %69 = icmp eq i32 %68, 0
  %70 = zext i1 %69 to i32
  br i1 %69, label %if.then103, label %if.end104

if.end98:                                         ; preds = %if.end209, %if.end83
  %r254 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r254)
  %vtbl.addr255 = getelementptr inbounds %class.IpcReader, ptr %r254, i32 0, i32 0
  %vtbl256 = load ptr, ptr %vtbl.addr255, align 8, !tbaa !0
  %dtor.slot257 = getelementptr [353 x ptr], ptr %vtbl256, i64 0, i64 352
  %dtor.fn258 = load ptr, ptr %dtor.slot257, align 8
  %71 = icmp ne ptr %dtor.fn258, null
  br i1 %71, label %dtor.call259, label %dtor.free260

if.then103:                                       ; preds = %if.then97
  %r105 = load ptr, ptr %r, align 8
  %72 = call ptr @IpcReader.getString(ptr %r105)
  %strcpy106 = call ptr @__polaron_str_copy(ptr %72)
  store ptr %strcpy106, ptr %sound, align 8
  call void @__polaron_str_free(ptr %72)
  %id107 = load i64, ptr %id75, align 8
  %73 = inttoptr i64 %id107 to ptr
  store ptr %73, ptr %self, align 8
  %r108 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r108)
  %vtbl.addr109 = getelementptr inbounds %class.IpcReader, ptr %r108, i32 0, i32 0
  %vtbl110 = load ptr, ptr %vtbl.addr109, align 8, !tbaa !0
  %dtor.slot111 = getelementptr [353 x ptr], ptr %vtbl110, i64 0, i64 352
  %dtor.fn112 = load ptr, ptr %dtor.slot111, align 8
  %74 = icmp ne ptr %dtor.fn112, null
  br i1 %74, label %dtor.call113, label %dtor.free114

if.end104:                                        ; preds = %if.then97
  %meth135 = load ptr, ptr %meth, align 8
  %str.data136 = getelementptr inbounds %String, ptr %meth135, i32 0, i32 1
  %data137 = load ptr, ptr %str.data136, align 8
  %data138 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.20, i32 0, i32 1), align 8
  %75 = call i32 @strcmp(ptr %data137, ptr %data138)
  %76 = icmp eq i32 %75, 0
  %77 = zext i1 %76 to i32
  br i1 %76, label %if.then139, label %if.end140

dtor.call113:                                     ; preds = %if.then103
  call void %dtor.fn112(ptr %r108)
  br label %dtor.free114

dtor.free114:                                     ; preds = %dtor.call113, %if.then103
  %buf.sfree115 = getelementptr inbounds %class.IpcReader, ptr %r108, i32 0, i32 1
  %78 = load ptr, ptr %buf.sfree115, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %78)
  call void @__polaron_free(ptr %r108)
  %IpcWriter.obj116 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj116)
  store ptr %IpcWriter.obj116, ptr %w117, align 8
  %w118 = load ptr, ptr %w117, align 8
  %79 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w118, i32 %79)
  %self119 = load ptr, ptr %self, align 8
  %sound120 = load ptr, ptr %sound, align 8
  %80 = call i32 @StereoMixer.play(ptr %self119, ptr %sound120)
  store i32 %80, ptr %out, align 4
  %w121 = load ptr, ptr %w117, align 8
  %out122 = load i32, ptr %out, align 4
  call void @IpcWriter.putInt(ptr %w121, i32 %out122)
  %w123 = load ptr, ptr %w117, align 8
  %81 = call ptr @IpcWriter.toFrame(ptr %w123)
  %strcpy124 = call ptr @__polaron_str_copy(ptr %81)
  store ptr %strcpy124, ptr %f125, align 8
  call void @__polaron_str_free(ptr %81)
  %w126 = load ptr, ptr %w117, align 8
  call void @__polaron_check_live(ptr %w126)
  %vtbl.addr127 = getelementptr inbounds %class.IpcWriter, ptr %w126, i32 0, i32 0
  %vtbl128 = load ptr, ptr %vtbl.addr127, align 8, !tbaa !0
  %dtor.slot129 = getelementptr [353 x ptr], ptr %vtbl128, i64 0, i64 352
  %dtor.fn130 = load ptr, ptr %dtor.slot129, align 8
  %82 = icmp ne ptr %dtor.fn130, null
  br i1 %82, label %dtor.call131, label %dtor.free132

dtor.call131:                                     ; preds = %dtor.free114
  call void %dtor.fn130(ptr %w126)
  br label %dtor.free132

dtor.free132:                                     ; preds = %dtor.call131, %dtor.free114
  call void @__polaron_free(ptr %w126)
  %f133 = load ptr, ptr %f125, align 8
  %strcpy134 = call ptr @__polaron_str_copy(ptr %f133)
  %83 = load ptr, ptr %f125, align 8
  call void @__polaron_str_free(ptr %83)
  %84 = load ptr, ptr %sound, align 8
  call void @__polaron_str_free(ptr %84)
  %85 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %85)
  %86 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %86)
  ret ptr %strcpy134

if.then139:                                       ; preds = %if.end104
  %r141 = load ptr, ptr %r, align 8
  %87 = call i32 @IpcReader.getInt(ptr %r141)
  store i32 %87, ptr %v, align 4
  %id142 = load i64, ptr %id75, align 8
  %88 = inttoptr i64 %id142 to ptr
  store ptr %88, ptr %self143, align 8
  %r144 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r144)
  %vtbl.addr145 = getelementptr inbounds %class.IpcReader, ptr %r144, i32 0, i32 0
  %vtbl146 = load ptr, ptr %vtbl.addr145, align 8, !tbaa !0
  %dtor.slot147 = getelementptr [353 x ptr], ptr %vtbl146, i64 0, i64 352
  %dtor.fn148 = load ptr, ptr %dtor.slot147, align 8
  %89 = icmp ne ptr %dtor.fn148, null
  br i1 %89, label %dtor.call149, label %dtor.free150

if.end140:                                        ; preds = %if.end104
  %meth169 = load ptr, ptr %meth, align 8
  %str.data170 = getelementptr inbounds %String, ptr %meth169, i32 0, i32 1
  %data171 = load ptr, ptr %str.data170, align 8
  %data172 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.22, i32 0, i32 1), align 8
  %90 = call i32 @strcmp(ptr %data171, ptr %data172)
  %91 = icmp eq i32 %90, 0
  %92 = zext i1 %91 to i32
  br i1 %91, label %if.then173, label %if.end174

dtor.call149:                                     ; preds = %if.then139
  call void %dtor.fn148(ptr %r144)
  br label %dtor.free150

dtor.free150:                                     ; preds = %dtor.call149, %if.then139
  %buf.sfree151 = getelementptr inbounds %class.IpcReader, ptr %r144, i32 0, i32 1
  %93 = load ptr, ptr %buf.sfree151, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %93)
  call void @__polaron_free(ptr %r144)
  %IpcWriter.obj152 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj152)
  store ptr %IpcWriter.obj152, ptr %w153, align 8
  %w154 = load ptr, ptr %w153, align 8
  %94 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w154, i32 %94)
  %self155 = load ptr, ptr %self143, align 8
  %v156 = load i32, ptr %v, align 4
  call void @StereoMixer.setVolume(ptr %self155, i32 %v156)
  %w157 = load ptr, ptr %w153, align 8
  %95 = call ptr @IpcWriter.toFrame(ptr %w157)
  %strcpy158 = call ptr @__polaron_str_copy(ptr %95)
  store ptr %strcpy158, ptr %f159, align 8
  call void @__polaron_str_free(ptr %95)
  %w160 = load ptr, ptr %w153, align 8
  call void @__polaron_check_live(ptr %w160)
  %vtbl.addr161 = getelementptr inbounds %class.IpcWriter, ptr %w160, i32 0, i32 0
  %vtbl162 = load ptr, ptr %vtbl.addr161, align 8, !tbaa !0
  %dtor.slot163 = getelementptr [353 x ptr], ptr %vtbl162, i64 0, i64 352
  %dtor.fn164 = load ptr, ptr %dtor.slot163, align 8
  %96 = icmp ne ptr %dtor.fn164, null
  br i1 %96, label %dtor.call165, label %dtor.free166

dtor.call165:                                     ; preds = %dtor.free150
  call void %dtor.fn164(ptr %w160)
  br label %dtor.free166

dtor.free166:                                     ; preds = %dtor.call165, %dtor.free150
  call void @__polaron_free(ptr %w160)
  %f167 = load ptr, ptr %f159, align 8
  %strcpy168 = call ptr @__polaron_str_copy(ptr %f167)
  %97 = load ptr, ptr %f159, align 8
  call void @__polaron_str_free(ptr %97)
  %98 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %98)
  %99 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %99)
  ret ptr %strcpy168

if.then173:                                       ; preds = %if.end140
  %id175 = load i64, ptr %id75, align 8
  %100 = inttoptr i64 %id175 to ptr
  store ptr %100, ptr %self176, align 8
  %r177 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r177)
  %vtbl.addr178 = getelementptr inbounds %class.IpcReader, ptr %r177, i32 0, i32 0
  %vtbl179 = load ptr, ptr %vtbl.addr178, align 8, !tbaa !0
  %dtor.slot180 = getelementptr [353 x ptr], ptr %vtbl179, i64 0, i64 352
  %dtor.fn181 = load ptr, ptr %dtor.slot180, align 8
  %101 = icmp ne ptr %dtor.fn181, null
  br i1 %101, label %dtor.call182, label %dtor.free183

if.end174:                                        ; preds = %if.end140
  %meth204 = load ptr, ptr %meth, align 8
  %str.data205 = getelementptr inbounds %String, ptr %meth204, i32 0, i32 1
  %data206 = load ptr, ptr %str.data205, align 8
  %data207 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.24, i32 0, i32 1), align 8
  %102 = call i32 @strcmp(ptr %data206, ptr %data207)
  %103 = icmp eq i32 %102, 0
  %104 = zext i1 %103 to i32
  br i1 %103, label %if.then208, label %if.end209

dtor.call182:                                     ; preds = %if.then173
  call void %dtor.fn181(ptr %r177)
  br label %dtor.free183

dtor.free183:                                     ; preds = %dtor.call182, %if.then173
  %buf.sfree184 = getelementptr inbounds %class.IpcReader, ptr %r177, i32 0, i32 1
  %105 = load ptr, ptr %buf.sfree184, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %105)
  call void @__polaron_free(ptr %r177)
  %IpcWriter.obj185 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj185)
  store ptr %IpcWriter.obj185, ptr %w186, align 8
  %w187 = load ptr, ptr %w186, align 8
  %106 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w187, i32 %106)
  %self188 = load ptr, ptr %self176, align 8
  %107 = call i32 @StereoMixer.volume(ptr %self188)
  store i32 %107, ptr %out189, align 4
  %w190 = load ptr, ptr %w186, align 8
  %out191 = load i32, ptr %out189, align 4
  call void @IpcWriter.putInt(ptr %w190, i32 %out191)
  %w192 = load ptr, ptr %w186, align 8
  %108 = call ptr @IpcWriter.toFrame(ptr %w192)
  %strcpy193 = call ptr @__polaron_str_copy(ptr %108)
  store ptr %strcpy193, ptr %f194, align 8
  call void @__polaron_str_free(ptr %108)
  %w195 = load ptr, ptr %w186, align 8
  call void @__polaron_check_live(ptr %w195)
  %vtbl.addr196 = getelementptr inbounds %class.IpcWriter, ptr %w195, i32 0, i32 0
  %vtbl197 = load ptr, ptr %vtbl.addr196, align 8, !tbaa !0
  %dtor.slot198 = getelementptr [353 x ptr], ptr %vtbl197, i64 0, i64 352
  %dtor.fn199 = load ptr, ptr %dtor.slot198, align 8
  %109 = icmp ne ptr %dtor.fn199, null
  br i1 %109, label %dtor.call200, label %dtor.free201

dtor.call200:                                     ; preds = %dtor.free183
  call void %dtor.fn199(ptr %w195)
  br label %dtor.free201

dtor.free201:                                     ; preds = %dtor.call200, %dtor.free183
  call void @__polaron_free(ptr %w195)
  %f202 = load ptr, ptr %f194, align 8
  %strcpy203 = call ptr @__polaron_str_copy(ptr %f202)
  %110 = load ptr, ptr %f194, align 8
  call void @__polaron_str_free(ptr %110)
  %111 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %111)
  %112 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %112)
  ret ptr %strcpy203

if.then208:                                       ; preds = %if.end174
  %r210 = load ptr, ptr %r, align 8
  %113 = call i64 @IpcReader.getLong(ptr %r210)
  store i64 %113, ptr %__tok_mixdown, align 8
  %__tok_mixdown211 = load i64, ptr %__tok_mixdown, align 8
  %114 = call i32 @IpcServer.validate(i64 %__tok_mixdown211, ptr @.strobj.26)
  %115 = icmp eq i32 %114, 0
  %116 = zext i1 %115 to i32
  br i1 %115, label %if.then212, label %if.end213

if.end209:                                        ; preds = %if.end174
  br label %if.end98

if.then212:                                       ; preds = %if.then208
  %r214 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r214)
  %vtbl.addr215 = getelementptr inbounds %class.IpcReader, ptr %r214, i32 0, i32 0
  %vtbl216 = load ptr, ptr %vtbl.addr215, align 8, !tbaa !0
  %dtor.slot217 = getelementptr [353 x ptr], ptr %vtbl216, i64 0, i64 352
  %dtor.fn218 = load ptr, ptr %dtor.slot217, align 8
  %117 = icmp ne ptr %dtor.fn218, null
  br i1 %117, label %dtor.call219, label %dtor.free220

if.end213:                                        ; preds = %if.then208
  %BundleAccessToken.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BundleAccessToken, ptr null, i64 1) to i64))
  %__tok_mixdown223 = load i64, ptr %__tok_mixdown, align 8
  call void @BundleAccessToken.BundleAccessToken(ptr %BundleAccessToken.obj, i64 %__tok_mixdown223, ptr @.strobj.30)
  store ptr %BundleAccessToken.obj, ptr %mixdown, align 8
  %id224 = load i64, ptr %id75, align 8
  %118 = inttoptr i64 %id224 to ptr
  store ptr %118, ptr %self225, align 8
  %r226 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r226)
  %vtbl.addr227 = getelementptr inbounds %class.IpcReader, ptr %r226, i32 0, i32 0
  %vtbl228 = load ptr, ptr %vtbl.addr227, align 8, !tbaa !0
  %dtor.slot229 = getelementptr [353 x ptr], ptr %vtbl228, i64 0, i64 352
  %dtor.fn230 = load ptr, ptr %dtor.slot229, align 8
  %119 = icmp ne ptr %dtor.fn230, null
  br i1 %119, label %dtor.call231, label %dtor.free232

dtor.call219:                                     ; preds = %if.then212
  call void %dtor.fn218(ptr %r214)
  br label %dtor.free220

dtor.free220:                                     ; preds = %dtor.call219, %if.then212
  %buf.sfree221 = getelementptr inbounds %class.IpcReader, ptr %r214, i32 0, i32 1
  %120 = load ptr, ptr %buf.sfree221, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %120)
  call void @__polaron_free(ptr %r214)
  %121 = call ptr @IpcProto.errorFrame(ptr @.strobj.28)
  %strcpy222 = call ptr @__polaron_str_copy(ptr %121)
  call void @__polaron_str_free(ptr %121)
  %122 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %122)
  %123 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %123)
  ret ptr %strcpy222

dtor.call231:                                     ; preds = %if.end213
  call void %dtor.fn230(ptr %r226)
  br label %dtor.free232

dtor.free232:                                     ; preds = %dtor.call231, %if.end213
  %buf.sfree233 = getelementptr inbounds %class.IpcReader, ptr %r226, i32 0, i32 1
  %124 = load ptr, ptr %buf.sfree233, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %124)
  call void @__polaron_free(ptr %r226)
  %IpcWriter.obj234 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj234)
  store ptr %IpcWriter.obj234, ptr %w235, align 8
  %w236 = load ptr, ptr %w235, align 8
  %125 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w236, i32 %125)
  %self237 = load ptr, ptr %self225, align 8
  %mixdown238 = load ptr, ptr %mixdown, align 8
  %126 = call i32 @StereoMixer.mixdown(ptr %self237, ptr %mixdown238)
  store i32 %126, ptr %out239, align 4
  %w240 = load ptr, ptr %w235, align 8
  %out241 = load i32, ptr %out239, align 4
  call void @IpcWriter.putInt(ptr %w240, i32 %out241)
  %w242 = load ptr, ptr %w235, align 8
  %127 = call ptr @IpcWriter.toFrame(ptr %w242)
  %strcpy243 = call ptr @__polaron_str_copy(ptr %127)
  store ptr %strcpy243, ptr %f244, align 8
  call void @__polaron_str_free(ptr %127)
  %w245 = load ptr, ptr %w235, align 8
  call void @__polaron_check_live(ptr %w245)
  %vtbl.addr246 = getelementptr inbounds %class.IpcWriter, ptr %w245, i32 0, i32 0
  %vtbl247 = load ptr, ptr %vtbl.addr246, align 8, !tbaa !0
  %dtor.slot248 = getelementptr [353 x ptr], ptr %vtbl247, i64 0, i64 352
  %dtor.fn249 = load ptr, ptr %dtor.slot248, align 8
  %128 = icmp ne ptr %dtor.fn249, null
  br i1 %128, label %dtor.call250, label %dtor.free251

dtor.call250:                                     ; preds = %dtor.free232
  call void %dtor.fn249(ptr %w245)
  br label %dtor.free251

dtor.free251:                                     ; preds = %dtor.call250, %dtor.free232
  call void @__polaron_free(ptr %w245)
  %f252 = load ptr, ptr %f244, align 8
  %strcpy253 = call ptr @__polaron_str_copy(ptr %f252)
  %129 = load ptr, ptr %f244, align 8
  call void @__polaron_str_free(ptr %129)
  %130 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %130)
  %131 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %131)
  ret ptr %strcpy253

dtor.call259:                                     ; preds = %if.end98
  call void %dtor.fn258(ptr %r254)
  br label %dtor.free260

dtor.free260:                                     ; preds = %dtor.call259, %if.end98
  %buf.sfree261 = getelementptr inbounds %class.IpcReader, ptr %r254, i32 0, i32 1
  %132 = load ptr, ptr %buf.sfree261, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %132)
  call void @__polaron_free(ptr %r254)
  %133 = call ptr @IpcProto.errorFrame(ptr @.strobj.32)
  %strcpy262 = call ptr @__polaron_str_copy(ptr %133)
  call void @__polaron_str_free(ptr %133)
  %134 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %134)
  %135 = load ptr, ptr %type78, align 8
  call void @__polaron_str_free(ptr %135)
  ret ptr %strcpy262

dtor.call268:                                     ; preds = %if.end73
  call void %dtor.fn267(ptr %r263)
  br label %dtor.free269

dtor.free269:                                     ; preds = %dtor.call268, %if.end73
  %buf.sfree270 = getelementptr inbounds %class.IpcReader, ptr %r263, i32 0, i32 1
  %136 = load ptr, ptr %buf.sfree270, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %136)
  call void @__polaron_free(ptr %r263)
  %137 = call ptr @IpcProto.errorFrame(ptr @.strobj.34)
  %strcpy271 = call ptr @__polaron_str_copy(ptr %137)
  call void @__polaron_str_free(ptr %137)
  ret ptr %strcpy271
}

define internal void @"HashSet$long.HashSet$long"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 0
  store ptr @"HashSet$long.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  store ptr null, ptr %elems, align 8, !tbaa !0
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  store ptr null, ptr %used, align 8, !tbaa !0
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  store i32 8, ptr %cap, align 4, !tbaa !4
  %elems1 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %elems1, align 8, !tbaa !0
  %used2 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 8)
  store ptr %arr3, ptr %used2, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @"HashSet$long.~HashSet$long"(ptr %0) {
entry:
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems1 = load ptr, ptr %elems, align 8, !tbaa !0
  call void @__polaron_free(ptr %elems1)
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used2 = load ptr, ptr %used, align 8, !tbaa !0
  call void @__polaron_free(ptr %used2)
  ret void
}

define internal i32 @"HashSet$long.slotFor"(ptr nonnull align 8 dereferenceable(32) %0, i64 %1) {
entry:
  %i = alloca i32, align 4
  %mask = alloca i32, align 4
  %value = alloca i64, align 8
  store i64 %1, ptr %value, align 8
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = sub i32 %cap1, 1
  store i32 %2, ptr %mask, align 4
  %value2 = load i64, ptr %value, align 8
  %3 = trunc i64 %value2 to i32
  %mask3 = load i32, ptr %mask, align 4
  %4 = and i32 %3, %mask3
  store i32 %4, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end, %entry
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

while.body:                                       ; preds = %idx.ok
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems6 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %6 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %elems6, align 8
  %arr.oob9 = icmp uge i64 %6, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !8

while.end:                                        ; preds = %idx.ok
  %i19 = load i32, ptr %i, align 4
  ret i32 %i19

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.74, ptr @.faila.75, i64 %5, ptr @.failb.76, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %while.cond
  %arr.data = getelementptr i8, ptr %used4, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %5
  %elem = load i8, ptr %arr.elem, align 1
  %7 = sext i8 %elem to i32
  %8 = icmp ne i32 %7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %while.body, label %while.end

idx.bad10:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.77, ptr @.faila.78, i64 %6, ptr @.failb.79, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %while.body
  %arr.data12 = getelementptr i8, ptr %elems6, i64 8
  %arr.elem13 = getelementptr inbounds i64, ptr %arr.data12, i64 %6
  %elem14 = load i64, ptr %arr.elem13, align 8
  %value15 = load i64, ptr %value, align 8
  %10 = icmp eq i64 %elem14, %value15
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok11
  %i16 = load i32, ptr %i, align 4
  ret i32 %i16

if.end:                                           ; preds = %idx.ok11
  %i17 = load i32, ptr %i, align 4
  %12 = add i32 %i17, 1
  %mask18 = load i32, ptr %mask, align 4
  %13 = and i32 %12, %mask18
  store i32 %13, ptr %i, align 4
  br label %while.cond
}

define internal void @"HashSet$long.grow"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %j = alloca i32, align 4
  %oldU = alloca ptr, align 8
  %oldE = alloca ptr, align 8
  %oldCap = alloca i32, align 4
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  store i32 %cap1, ptr %oldCap, align 4
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems2 = load ptr, ptr %elems, align 8, !tbaa !0
  store ptr %elems2, ptr %oldE, align 8
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used3 = load ptr, ptr %used, align 8, !tbaa !0
  store ptr %used3, ptr %oldU, align 8
  %cap4 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %oldCap5 = load i32, ptr %oldCap, align 4
  %1 = mul i32 %oldCap5, 2
  store i32 %1, ptr %cap4, align 4, !tbaa !4
  %elems6 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %cap7 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %2 = sext i32 %cap8 to i64
  %3 = mul i64 %2, 8
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %elems6, align 8, !tbaa !0
  %used9 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %cap10 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !4
  %6 = sext i32 %cap11 to i64
  %7 = mul i64 %6, 1
  %8 = add i64 8, %7
  %arr12 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr12, align 8
  %arr.data13 = getelementptr i8, ptr %arr12, i64 8
  %9 = call ptr @memset(ptr %arr.data13, i32 0, i64 %7)
  store ptr %arr12, ptr %used9, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !4
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j14 = load i32, ptr %j, align 4
  %oldCap15 = load i32, ptr %oldCap, align 4
  %10 = icmp slt i32 %j14, %oldCap15
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %oldU16 = load ptr, ptr %oldU, align 8, !nonnull !6, !dereferenceable !7
  %j17 = load i32, ptr %j, align 4
  %12 = sext i32 %j17 to i64
  %arr.len = load i64, ptr %oldU16, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %13 = load i32, ptr %j, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %oldE28 = load ptr, ptr %oldE, align 8
  call void @__polaron_free(ptr %oldE28)
  %oldU29 = load ptr, ptr %oldU, align 8
  call void @__polaron_free(ptr %oldU29)
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.80, ptr @.faila.81, i64 %12, ptr @.failb.82, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data18 = getelementptr i8, ptr %oldU16, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data18, i64 %12
  %elem = load i8, ptr %arr.elem, align 1
  %15 = sext i8 %elem to i32
  %16 = icmp ne i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %oldE19 = load ptr, ptr %oldE, align 8, !nonnull !6, !dereferenceable !7
  %j20 = load i32, ptr %j, align 4
  %18 = sext i32 %j20 to i64
  %arr.len21 = load i64, ptr %oldE19, align 8
  %arr.oob22 = icmp uge i64 %18, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

if.end:                                           ; preds = %idx.ok24, %idx.ok
  br label %for.update

idx.bad23:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.83, ptr @.faila.84, i64 %18, ptr @.failb.85, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %if.then
  %arr.data25 = getelementptr i8, ptr %oldE19, i64 8
  %arr.elem26 = getelementptr inbounds i64, ptr %arr.data25, i64 %18
  %elem27 = load i64, ptr %arr.elem26, align 8
  call void @"HashSet$long.add"(ptr %0, i64 %elem27)
  br label %if.end
}

define internal void @"HashSet$long.add"(ptr nonnull align 8 dereferenceable(32) %0, i64 %1) {
entry:
  %i = alloca i32, align 4
  %value = alloca i64, align 8
  store i64 %1, ptr %value, align 8
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = add i32 %count1, 1
  %3 = mul i32 %2, 4
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = mul i32 %cap2, 3
  %5 = icmp sge i32 %3, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"HashSet$long.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %value3 = load i64, ptr %value, align 8
  %7 = call i32 @"HashSet$long.slotFor"(ptr %0, i64 %value3)
  store i32 %7, ptr %i, align 4
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %8 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.86, ptr @.faila.87, i64 %8, ptr @.failb.88, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %used4, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %8
  %elem = load i8, ptr %arr.elem, align 1
  %9 = sext i8 %elem to i32
  %10 = icmp eq i32 %9, 0
  %11 = zext i1 %10 to i32
  br i1 %10, label %if.then6, label %if.end7

if.then6:                                         ; preds = %idx.ok
  %used8 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used9 = load ptr, ptr %used8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %used9, align 8
  %arr.oob12 = icmp uge i64 %12, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !8

if.end7:                                          ; preds = %idx.ok22, %idx.ok
  ret void

idx.bad13:                                        ; preds = %if.then6
  call void @__polaron_fail(ptr @.fail.89, ptr @.faila.90, i64 %12, ptr @.failb.91, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %if.then6
  %arr.data15 = getelementptr i8, ptr %used9, i64 8
  %arr.elem16 = getelementptr inbounds i8, ptr %arr.data15, i64 %12
  store i8 1, ptr %arr.elem16, align 1
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems17 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i18 = load i32, ptr %i, align 4
  %13 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %elems17, align 8
  %arr.oob20 = icmp uge i64 %13, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !8

idx.bad21:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.92, ptr @.faila.93, i64 %13, ptr @.failb.94, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok14
  %arr.data23 = getelementptr i8, ptr %elems17, i64 8
  %arr.elem24 = getelementptr inbounds i64, ptr %arr.data23, i64 %13
  %value25 = load i64, ptr %value, align 8
  store i64 %value25, ptr %arr.elem24, align 8
  %count26 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count27 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %14 = add i32 %count28, 1
  store i32 %14, ptr %count26, align 4, !tbaa !4
  br label %if.end7
}

define internal i32 @"HashSet$long.contains"(ptr nonnull align 8 dereferenceable(32) %0, i64 %1) {
entry:
  %value = alloca i64, align 8
  store i64 %1, ptr %value, align 8
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used1 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %value2 = load i64, ptr %value, align 8
  %2 = call i32 @"HashSet$long.slotFor"(ptr %0, i64 %value2)
  %3 = sext i32 %2 to i64
  %arr.len = load i64, ptr %used1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.95, ptr @.faila.96, i64 %3, ptr @.failb.97, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %3
  %elem = load i8, ptr %arr.elem, align 1
  %4 = sext i8 %elem to i32
  %5 = icmp ne i32 %4, 0
  %6 = zext i1 %5 to i32
  ret i32 %6
}

define internal i32 @"HashSet$long.remove"(ptr nonnull align 8 dereferenceable(32) %0, i64 %1) {
entry:
  %re = alloca i64, align 8
  %j = alloca i32, align 4
  %mask = alloca i32, align 4
  %i = alloca i32, align 4
  %value = alloca i64, align 8
  store i64 %1, ptr %value, align 8
  %value1 = load i64, ptr %value, align 8
  %2 = call i32 @"HashSet$long.slotFor"(ptr %0, i64 %value1)
  store i32 %2, ptr %i, align 4
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used2 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i3 = load i32, ptr %i, align 4
  %3 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %used2, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.98, ptr @.faila.99, i64 %3, ptr @.failb.100, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %used2, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %3
  %elem = load i8, ptr %arr.elem, align 1
  %4 = sext i8 %elem to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap4 = load i32, ptr %cap, align 4, !tbaa !4
  %7 = sub i32 %cap4, 1
  store i32 %7, ptr %mask, align 4
  %used5 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used6 = load ptr, ptr %used5, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %used6, align 8
  %arr.oob9 = icmp uge i64 %8, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !8

idx.bad10:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.101, ptr @.faila.102, i64 %8, ptr @.failb.103, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %if.end
  %arr.data12 = getelementptr i8, ptr %used6, i64 8
  %arr.elem13 = getelementptr inbounds i8, ptr %arr.data12, i64 %8
  store i8 0, ptr %arr.elem13, align 1
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count14 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %9 = sub i32 %count15, 1
  store i32 %9, ptr %count, align 4, !tbaa !4
  %i16 = load i32, ptr %i, align 4
  %10 = add i32 %i16, 1
  %mask17 = load i32, ptr %mask, align 4
  %11 = and i32 %10, %mask17
  store i32 %11, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok43, %idx.ok11
  %used18 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used19 = load ptr, ptr %used18, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j20 = load i32, ptr %j, align 4
  %12 = sext i32 %j20 to i64
  %arr.len21 = load i64, ptr %used19, align 8
  %arr.oob22 = icmp uge i64 %12, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

while.body:                                       ; preds = %idx.ok24
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems28 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j29 = load i32, ptr %j, align 4
  %13 = sext i32 %j29 to i64
  %arr.len30 = load i64, ptr %elems28, align 8
  %arr.oob31 = icmp uge i64 %13, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

while.end:                                        ; preds = %idx.ok24
  ret i32 1

idx.bad23:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.104, ptr @.faila.105, i64 %12, ptr @.failb.106, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %while.cond
  %arr.data25 = getelementptr i8, ptr %used19, i64 8
  %arr.elem26 = getelementptr inbounds i8, ptr %arr.data25, i64 %12
  %elem27 = load i8, ptr %arr.elem26, align 1
  %14 = sext i8 %elem27 to i32
  %15 = icmp ne i32 %14, 0
  %16 = zext i1 %15 to i32
  br i1 %15, label %while.body, label %while.end

idx.bad32:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.107, ptr @.faila.108, i64 %13, ptr @.failb.109, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %elems28, i64 8
  %arr.elem35 = getelementptr inbounds i64, ptr %arr.data34, i64 %13
  %elem36 = load i64, ptr %arr.elem35, align 8
  store i64 %elem36, ptr %re, align 8
  %used37 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used38 = load ptr, ptr %used37, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j39 = load i32, ptr %j, align 4
  %17 = sext i32 %j39 to i64
  %arr.len40 = load i64, ptr %used38, align 8
  %arr.oob41 = icmp uge i64 %17, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

idx.bad42:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.110, ptr @.faila.111, i64 %17, ptr @.failb.112, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok33
  %arr.data44 = getelementptr i8, ptr %used38, i64 8
  %arr.elem45 = getelementptr inbounds i8, ptr %arr.data44, i64 %17
  store i8 0, ptr %arr.elem45, align 1
  %count46 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count47 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count48 = load i32, ptr %count47, align 4, !tbaa !4
  %18 = sub i32 %count48, 1
  store i32 %18, ptr %count46, align 4, !tbaa !4
  %re49 = load i64, ptr %re, align 8
  call void @"HashSet$long.add"(ptr %0, i64 %re49)
  %j50 = load i32, ptr %j, align 4
  %19 = add i32 %j50, 1
  %mask51 = load i32, ptr %mask, align 4
  %20 = and i32 %19, %mask51
  store i32 %20, ptr %j, align 4
  br label %while.cond
}

define internal ptr @"HashSet$long.toArray"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = sext i32 %count1 to i64
  %2 = mul i64 %1, 8
  %3 = add i64 8, %2
  %arr = call ptr @__polaron_malloc(i64 %3)
  store i64 %1, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %4 = call ptr @memset(ptr %arr.data, i32 0, i64 %2)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %j, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp slt i32 %i2, %cap3
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %7 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out25 = load ptr, ptr %out, align 8
  ret ptr %out25

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.113, ptr @.faila.114, i64 %7, ptr @.failb.115, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data6 = getelementptr i8, ptr %used4, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data6, i64 %7
  %elem = load i8, ptr %arr.elem, align 1
  %10 = sext i8 %elem to i32
  %11 = icmp ne i32 %10, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out7 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %j8 = load i32, ptr %j, align 4
  %13 = sext i32 %j8 to i64
  %arr.len9 = load i64, ptr %out7, align 8
  %arr.oob10 = icmp uge i64 %13, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !8

if.end:                                           ; preds = %idx.ok20, %idx.ok
  br label %for.update

idx.bad11:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.116, ptr @.faila.117, i64 %13, ptr @.failb.118, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %if.then
  %arr.data13 = getelementptr i8, ptr %out7, i64 8
  %arr.elem14 = getelementptr inbounds i64, ptr %arr.data13, i64 %13
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems15 = load ptr, ptr %elems, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %14 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %elems15, align 8
  %arr.oob18 = icmp uge i64 %14, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.119, ptr @.faila.120, i64 %14, ptr @.failb.121, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok12
  %arr.data21 = getelementptr i8, ptr %elems15, i64 8
  %arr.elem22 = getelementptr inbounds i64, ptr %arr.data21, i64 %14
  %elem23 = load i64, ptr %arr.elem22, align 8
  store i64 %elem23, ptr %arr.elem14, align 8
  %j24 = load i32, ptr %j, align 4
  %15 = add i32 %j24, 1
  store i32 %15, ptr %j, align 4
  br label %if.end
}

define internal i32 @"HashSet$long.size"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"HashSet$long.isEmpty"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"ArrayList$long.ArrayList$long"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$long.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.754, ptr @.cl.755, i64 %contract.l, ptr @.cr.756, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.757, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$long.~ArrayList$long"(ptr %0) {
entry:
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  call void @__polaron_free(ptr %data1)
  ret void
}

define internal void @"ArrayList$long.add"(ptr nonnull align 8 dereferenceable(24) %0, i64 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %old = alloca i32, align 4
  %item = alloca i64, align 8
  store i64 %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %7 = trunc i64 %len12 to i32
  %8 = icmp sge i32 %count9, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %data35 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count37 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count38 = load i32, ptr %count37, align 4, !tbaa !4
  %16 = sext i32 %count38 to i64
  %arr.len39 = load i64, ptr %data36, align 8
  %arr.oob40 = icmp uge i64 %16, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %17 = icmp slt i32 %i16, %count18
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %19 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok28
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  call void @__polaron_free(ptr %data32)
  %data33 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %bigger34 = load ptr, ptr %bigger, align 8
  store ptr %bigger34, ptr %data33, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.758, ptr @.faila.759, i64 %19, ptr @.failb.760, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data21, i64 %19
  %data22 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %22 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %22, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.761, ptr @.faila.762, i64 %22, ptr @.failb.763, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok
  %arr.data29 = getelementptr i8, ptr %data23, i64 8
  %arr.elem30 = getelementptr inbounds i64, ptr %arr.data29, i64 %22
  %elem = load i64, ptr %arr.elem30, align 8
  store i64 %elem, ptr %arr.elem, align 8
  br label %for.update

idx.bad41:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.764, ptr @.faila.765, i64 %16, ptr @.failb.766, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %if.end
  %arr.data43 = getelementptr i8, ptr %data36, i64 8
  %arr.elem44 = getelementptr inbounds i64, ptr %arr.data43, i64 %16
  %item45 = load i64, ptr %item, align 8
  store i64 %item45, ptr %arr.elem44, align 8
  %count46 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count47 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count48 = load i32, ptr %count47, align 4, !tbaa !4
  %23 = add i32 %count48, 1
  store i32 %23, ptr %count46, align 4, !tbaa !4
  %count49 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count50 = load i32, ptr %count49, align 4, !tbaa !4
  %old51 = load i32, ptr %old, align 4
  %24 = add i32 %old51, 1
  %25 = icmp eq i32 %count50, %24
  %26 = zext i1 %25 to i32
  %contract.ok = icmp ne i32 %26, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok42
  call void @__polaron_fail(ptr @.contract.767, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok42
  %count52 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %27 = icmp sge i32 %count53, 0
  %28 = zext i1 %27 to i32
  %contract.ok54 = icmp ne i32 %28, 0
  br i1 %contract.ok54, label %contract.cont56, label %contract.fail55

contract.fail55:                                  ; preds = %contract.cont
  %count57 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count58 = load i32, ptr %count57, align 4, !tbaa !4
  %contract.l = sext i32 %count58 to i64
  call void @__polaron_fail(ptr @.contract.768, ptr @.cl.769, i64 %contract.l, ptr @.cr.770, i64 0, i32 1)
  unreachable

contract.cont56:                                  ; preds = %contract.cont
  %count59 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %data61 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data62 = load ptr, ptr %data61, align 8, !tbaa !0
  %len63 = load i64, ptr %data62, align 8
  %29 = trunc i64 %len63 to i32
  %30 = icmp sle i32 %count60, %29
  %31 = zext i1 %30 to i32
  %contract.ok64 = icmp ne i32 %31, 0
  br i1 %contract.ok64, label %contract.cont66, label %contract.fail65

contract.fail65:                                  ; preds = %contract.cont56
  call void @__polaron_fail(ptr @.contract.771, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont66:                                  ; preds = %contract.cont56
  ret void
}

define internal void @"ArrayList$long.ensureCapacity"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count30 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %14 = icmp sge i32 %count31, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
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
  %data26 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  call void @__polaron_free(ptr %data27)
  %data28 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %bigger29 = load ptr, ptr %bigger, align 8
  store ptr %bigger29, ptr %data28, align 8, !tbaa !0
  br label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.772, ptr @.faila.773, i64 %18, ptr @.failb.774, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.775, ptr @.faila.776, i64 %21, ptr @.failb.777, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds i64, ptr %arr.data24, i64 %21
  %elem = load i64, ptr %arr.elem25, align 8
  store i64 %elem, ptr %arr.elem, align 8
  br label %for.update

contract.fail:                                    ; preds = %if.end
  %count32 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %contract.l = sext i32 %count33 to i64
  call void @__polaron_fail(ptr @.contract.778, ptr @.cl.779, i64 %contract.l, ptr @.cr.780, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count34 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count35 = load i32, ptr %count34, align 4, !tbaa !4
  %data36 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0
  %len38 = load i64, ptr %data37, align 8
  %22 = trunc i64 %len38 to i32
  %23 = icmp sle i32 %count35, %22
  %24 = zext i1 %23 to i32
  %contract.ok39 = icmp ne i32 %24, 0
  br i1 %contract.ok39, label %contract.cont41, label %contract.fail40

contract.fail40:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.781, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont41:                                  ; preds = %contract.cont
  ret void
}

define internal i64 @"ArrayList$long.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.782, ptr @.faila.783, i64 %13, ptr @.failb.784, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %13
  %elem = load i64, ptr %arr.elem, align 8
  ret i64 %elem

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.785, ptr @.faila.786, i64 %14, ptr @.failb.787, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %if.end
  %arr.data22 = getelementptr i8, ptr %data16, i64 8
  %arr.elem23 = getelementptr inbounds i64, ptr %arr.data22, i64 %14
  %elem24 = load i64, ptr %arr.elem23, align 8
  ret i64 %elem24
}

define internal void @"ArrayList$long.set"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i64 %2) {
entry:
  %item = alloca i64, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i64 %2, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %10 = icmp sge i32 %i7, %count9
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data21 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %15 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %data22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.788, ptr @.faila.789, i64 %14, ptr @.failb.790, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %14
  %item15 = load i64, ptr %item, align 8
  store i64 %item15, ptr %arr.elem, align 8
  %count16 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %data18 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0
  %len20 = load i64, ptr %data19, align 8
  %16 = trunc i64 %len20 to i32
  %17 = icmp sle i32 %count17, %16
  %18 = zext i1 %17 to i32
  %contract.ok = icmp ne i32 %18, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.791, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.792, ptr @.faila.793, i64 %15, ptr @.failb.794, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %if.end
  %arr.data28 = getelementptr i8, ptr %data22, i64 8
  %arr.elem29 = getelementptr inbounds i64, ptr %arr.data28, i64 %15
  %item30 = load i64, ptr %item, align 8
  store i64 %item30, ptr %arr.elem29, align 8
  %count31 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %data33 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data34 = load ptr, ptr %data33, align 8, !tbaa !0
  %len35 = load i64, ptr %data34, align 8
  %19 = trunc i64 %len35 to i32
  %20 = icmp sle i32 %count32, %19
  %21 = zext i1 %20 to i32
  %contract.ok36 = icmp ne i32 %21, 0
  br i1 %contract.ok36, label %contract.cont38, label %contract.fail37

contract.fail37:                                  ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.contract.795, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont38:                                  ; preds = %idx.ok27
  ret void
}

define internal i32 @"ArrayList$long.indexOf"(ptr nonnull align 8 dereferenceable(24) %0, i64 %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca i64, align 8
  store i64 %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %9 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.796, ptr @.faila.797, i64 %9, ptr @.failb.798, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data10, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %9
  %elem = load i64, ptr %arr.elem, align 8
  %item12 = load i64, ptr %item, align 8
  %12 = icmp eq i64 %elem, %item12
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %i13 = load i32, ptr %i, align 4
  ret i32 %i13

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$long.contains"(ptr nonnull align 8 dereferenceable(24) %0, i64 %1) {
entry:
  %item = alloca i64, align 8
  store i64 %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load i64, ptr %item, align 8
  %7 = call i32 @"ArrayList$long.indexOf"(ptr %0, i64 %item6)
  %8 = icmp sge i32 %7, 0
  %9 = zext i1 %8 to i32
  ret i32 %9
}

define internal void @"ArrayList$long.removeAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %j = alloca i32, align 4
  %oob = alloca i64, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.799, ptr @.faila.800, i64 %13, ptr @.failb.801, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %13
  %elem = load i64, ptr %arr.elem, align 8
  store i64 %elem, ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %14 = icmp sge i32 %count16, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.802, ptr @.cl.803, i64 %contract.l, ptr @.cr.804, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %data21 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %16 = trunc i64 %len23 to i32
  %17 = icmp sle i32 %count20, %16
  %18 = zext i1 %17 to i32
  %contract.ok24 = icmp ne i32 %18, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.805, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %19 = sub i32 %count30, 1
  %20 = icmp slt i32 %j28, %19
  %21 = zext i1 %20 to i32
  br i1 %20, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j33 = load i32, ptr %j, align 4
  %22 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %22, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

for.update:                                       ; preds = %idx.ok46
  %23 = load i32, ptr %j, align 4
  %24 = add i32 %23, 1
  store i32 %24, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count50 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count51 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %25 = sub i32 %count52, 1
  store i32 %25, ptr %count50, align 4, !tbaa !4
  %count53 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count54 = load i32, ptr %count53, align 4, !tbaa !4
  %26 = icmp sge i32 %count54, 0
  %27 = zext i1 %26 to i32
  %contract.ok55 = icmp ne i32 %27, 0
  br i1 %contract.ok55, label %contract.cont57, label %contract.fail56

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.806, ptr @.faila.807, i64 %22, ptr @.failb.808, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds i64, ptr %arr.data38, i64 %22
  %data40 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j42 = load i32, ptr %j, align 4
  %28 = add i32 %j42, 1
  %29 = sext i32 %28 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %29, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.809, ptr @.faila.810, i64 %29, ptr @.failb.811, i64 %arr.len43, i32 70)
  unreachable

idx.ok46:                                         ; preds = %idx.ok37
  %arr.data47 = getelementptr i8, ptr %data41, i64 8
  %arr.elem48 = getelementptr inbounds i64, ptr %arr.data47, i64 %29
  %elem49 = load i64, ptr %arr.elem48, align 8
  store i64 %elem49, ptr %arr.elem39, align 8
  br label %for.update

contract.fail56:                                  ; preds = %for.end
  %count58 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count59 = load i32, ptr %count58, align 4, !tbaa !4
  %contract.l60 = sext i32 %count59 to i64
  call void @__polaron_fail(ptr @.contract.812, ptr @.cl.813, i64 %contract.l60, ptr @.cr.814, i64 0, i32 1)
  unreachable

contract.cont57:                                  ; preds = %for.end
  %count61 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count62 = load i32, ptr %count61, align 4, !tbaa !4
  %data63 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !0
  %len65 = load i64, ptr %data64, align 8
  %30 = trunc i64 %len65 to i32
  %31 = icmp sle i32 %count62, %30
  %32 = zext i1 %31 to i32
  %contract.ok66 = icmp ne i32 %32, 0
  br i1 %contract.ok66, label %contract.cont68, label %contract.fail67

contract.fail67:                                  ; preds = %contract.cont57
  call void @__polaron_fail(ptr @.contract.815, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont68:                                  ; preds = %contract.cont57
  ret void
}

define internal void @"ArrayList$long.insertAt"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i64 %2) {
entry:
  %j = alloca i32, align 4
  %k = alloca i32, align 4
  %bigger = alloca ptr, align 8
  %item = alloca i64, align 8
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  store i64 %2, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %10 = icmp sgt i32 %i7, %count9
  %11 = zext i1 %10 to i32
  %sc.b = icmp ne i32 %11, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ true, %entry ], [ %sc.b, %sc.rhs ]
  %12 = zext i1 %sc to i32
  br i1 %sc, label %if.then, label %if.end

if.then:                                          ; preds = %sc.end
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count28 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %data30 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0
  %len32 = load i64, ptr %data31, align 8
  %15 = trunc i64 %len32 to i32
  %16 = icmp sge i32 %count29, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then33, label %if.end34

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.816, ptr @.faila.817, i64 %14, ptr @.failb.818, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %14
  %item15 = load i64, ptr %item, align 8
  store i64 %item15, ptr %arr.elem, align 8
  %count16 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %18 = icmp sge i32 %count17, 0
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count18 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !4
  %contract.l = sext i32 %count19 to i64
  call void @__polaron_fail(ptr @.contract.819, ptr @.cl.820, i64 %contract.l, ptr @.cr.821, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %data22 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0
  %len24 = load i64, ptr %data23, align 8
  %20 = trunc i64 %len24 to i32
  %21 = icmp sle i32 %count21, %20
  %22 = zext i1 %21 to i32
  %contract.ok25 = icmp ne i32 %22, 0
  br i1 %contract.ok25, label %contract.cont27, label %contract.fail26

contract.fail26:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.822, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont27:                                  ; preds = %contract.cont
  ret void

if.then33:                                        ; preds = %if.end
  %data35 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count63 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count64 = load i32, ptr %count63, align 4, !tbaa !4
  store i32 %count64, ptr %j, align 4
  br label %for.cond65

for.cond:                                         ; preds = %for.update, %if.then33
  %k39 = load i32, ptr %k, align 4
  %count40 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %29 = icmp slt i32 %k39, %count41
  %30 = zext i1 %29 to i32
  br i1 %29, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger42 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k43 = load i32, ptr %k, align 4
  %31 = sext i32 %k43 to i64
  %arr.len44 = load i64, ptr %bigger42, align 8
  %arr.oob45 = icmp uge i64 %31, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !8

for.update:                                       ; preds = %idx.ok56
  %32 = load i32, ptr %k, align 4
  %33 = add i32 %32, 1
  store i32 %33, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data59 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !0
  call void @__polaron_free(ptr %data60)
  %data61 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %bigger62 = load ptr, ptr %bigger, align 8
  store ptr %bigger62, ptr %data61, align 8, !tbaa !0
  br label %if.end34

idx.bad46:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.823, ptr @.faila.824, i64 %31, ptr @.failb.825, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body
  %arr.data48 = getelementptr i8, ptr %bigger42, i64 8
  %arr.elem49 = getelementptr inbounds i64, ptr %arr.data48, i64 %31
  %data50 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k52 = load i32, ptr %k, align 4
  %34 = sext i32 %k52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %34, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.826, ptr @.faila.827, i64 %34, ptr @.failb.828, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok47
  %arr.data57 = getelementptr i8, ptr %data51, i64 8
  %arr.elem58 = getelementptr inbounds i64, ptr %arr.data57, i64 %34
  %elem = load i64, ptr %arr.elem58, align 8
  store i64 %elem, ptr %arr.elem49, align 8
  br label %for.update

for.cond65:                                       ; preds = %for.update67, %if.end34
  %j69 = load i32, ptr %j, align 4
  %i70 = load i32, ptr %i, align 4
  %35 = icmp sgt i32 %j69, %i70
  %36 = zext i1 %35 to i32
  br i1 %35, label %for.body66, label %for.end68

for.body66:                                       ; preds = %for.cond65
  %data71 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data72 = load ptr, ptr %data71, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j73 = load i32, ptr %j, align 4
  %37 = sext i32 %j73 to i64
  %arr.len74 = load i64, ptr %data72, align 8
  %arr.oob75 = icmp uge i64 %37, %arr.len74
  br i1 %arr.oob75, label %idx.bad76, label %idx.ok77, !prof !8

for.update67:                                     ; preds = %idx.ok86
  %38 = load i32, ptr %j, align 4
  %39 = sub i32 %38, 1
  store i32 %39, ptr %j, align 4
  br label %for.cond65

for.end68:                                        ; preds = %for.cond65
  %data90 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i92 = load i32, ptr %i, align 4
  %40 = sext i32 %i92 to i64
  %arr.len93 = load i64, ptr %data91, align 8
  %arr.oob94 = icmp uge i64 %40, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !8

idx.bad76:                                        ; preds = %for.body66
  call void @__polaron_fail(ptr @.fail.829, ptr @.faila.830, i64 %37, ptr @.failb.831, i64 %arr.len74, i32 70)
  unreachable

idx.ok77:                                         ; preds = %for.body66
  %arr.data78 = getelementptr i8, ptr %data72, i64 8
  %arr.elem79 = getelementptr inbounds i64, ptr %arr.data78, i64 %37
  %data80 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data81 = load ptr, ptr %data80, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j82 = load i32, ptr %j, align 4
  %41 = sub i32 %j82, 1
  %42 = sext i32 %41 to i64
  %arr.len83 = load i64, ptr %data81, align 8
  %arr.oob84 = icmp uge i64 %42, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !8

idx.bad85:                                        ; preds = %idx.ok77
  call void @__polaron_fail(ptr @.fail.832, ptr @.faila.833, i64 %42, ptr @.failb.834, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok77
  %arr.data87 = getelementptr i8, ptr %data81, i64 8
  %arr.elem88 = getelementptr inbounds i64, ptr %arr.data87, i64 %42
  %elem89 = load i64, ptr %arr.elem88, align 8
  store i64 %elem89, ptr %arr.elem79, align 8
  br label %for.update67

idx.bad95:                                        ; preds = %for.end68
  call void @__polaron_fail(ptr @.fail.835, ptr @.faila.836, i64 %40, ptr @.failb.837, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %for.end68
  %arr.data97 = getelementptr i8, ptr %data91, i64 8
  %arr.elem98 = getelementptr inbounds i64, ptr %arr.data97, i64 %40
  %item99 = load i64, ptr %item, align 8
  store i64 %item99, ptr %arr.elem98, align 8
  %count100 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count101 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count102 = load i32, ptr %count101, align 4, !tbaa !4
  %43 = add i32 %count102, 1
  store i32 %43, ptr %count100, align 4, !tbaa !4
  %count103 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count104 = load i32, ptr %count103, align 4, !tbaa !4
  %44 = icmp sge i32 %count104, 0
  %45 = zext i1 %44 to i32
  %contract.ok105 = icmp ne i32 %45, 0
  br i1 %contract.ok105, label %contract.cont107, label %contract.fail106

contract.fail106:                                 ; preds = %idx.ok96
  %count108 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count109 = load i32, ptr %count108, align 4, !tbaa !4
  %contract.l110 = sext i32 %count109 to i64
  call void @__polaron_fail(ptr @.contract.838, ptr @.cl.839, i64 %contract.l110, ptr @.cr.840, i64 0, i32 1)
  unreachable

contract.cont107:                                 ; preds = %idx.ok96
  %count111 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count112 = load i32, ptr %count111, align 4, !tbaa !4
  %data113 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data114 = load ptr, ptr %data113, align 8, !tbaa !0
  %len115 = load i64, ptr %data114, align 8
  %46 = trunc i64 %len115 to i32
  %47 = icmp sle i32 %count112, %46
  %48 = zext i1 %47 to i32
  %contract.ok116 = icmp ne i32 %48, 0
  br i1 %contract.ok116, label %contract.cont118, label %contract.fail117

contract.fail117:                                 ; preds = %contract.cont107
  call void @__polaron_fail(ptr @.contract.841, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont118:                                 ; preds = %contract.cont107
  ret void
}

define internal i32 @"ArrayList$long.remove"(ptr nonnull align 8 dereferenceable(24) %0, i64 %1) {
entry:
  %i = alloca i32, align 4
  %item = alloca i64, align 8
  store i64 %1, ptr %item, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %item6 = load i64, ptr %item, align 8
  %7 = call i32 @"ArrayList$long.indexOf"(ptr %0, i64 %item6)
  store i32 %7, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %8 = icmp slt i32 %i7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  %i8 = load i32, ptr %i, align 4
  call void @"ArrayList$long.removeAt"(ptr %0, i32 %i8)
  ret i32 1
}

define internal void @"ArrayList$long.clear"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.842, ptr @.cl.843, i64 %contract.l, ptr @.cr.844, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.845, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$long.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
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
  %count9 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.846, ptr @.faila.847, i64 %12, ptr @.failb.848, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.849, ptr @.faila.850, i64 %15, ptr @.failb.851, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %idx.ok
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i64, ptr %arr.data21, i64 %15
  %elem = load i64, ptr %arr.elem22, align 8
  store i64 %elem, ptr %arr.elem, align 8
  br label %for.update
}

define internal i32 @"ArrayList$long.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$long.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %6 = icmp eq i32 %count7, 0
  %7 = zext i1 %6 to i32
  ret i32 %7
}

define internal void @"ArrayList$long.forEach"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %action = alloca ptr, align 8
  store ptr %1, ptr %action, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.852, ptr @.faila.853, i64 %10, ptr @.failb.854, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %10
  %elem = load i64, ptr %arr.elem, align 8
  call void %code(ptr %env, i64 %elem)
  br label %for.update
}

define internal ptr @"ArrayList$long.filter"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %keep = alloca ptr, align 8
  store ptr %1, ptr %keep, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$long.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$long", ptr null, i64 1) to i64))
  call void @"ArrayList$long.ArrayList$long"(ptr %"ArrayList$long.obj")
  store ptr %"ArrayList$long.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$long.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.855, ptr @.faila.856, i64 %10, ptr @.failb.857, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %10
  %elem = load i64, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, i64 %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %out16 = load ptr, ptr %out, align 8
  %data17 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.858, ptr @.faila.859, i64 %15, ptr @.failb.860, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %if.then
  %arr.data24 = getelementptr i8, ptr %data18, i64 8
  %arr.elem25 = getelementptr inbounds i64, ptr %arr.data24, i64 %15
  %elem26 = load i64, ptr %arr.elem25, align 8
  call void @"ArrayList$long.add"(ptr %out16, i64 %elem26)
  br label %if.end
}

define internal i32 @"ArrayList$long.any"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.861, ptr @.faila.862, i64 %10, ptr @.failb.863, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %10
  %elem = load i64, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, i64 %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 1

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$long.all"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.864, ptr @.faila.865, i64 %10, ptr @.failb.866, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %10
  %elem = load i64, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, i64 %elem)
  %14 = icmp eq i32 %13, 0
  %15 = zext i1 %14 to i32
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret i32 0

if.end:                                           ; preds = %idx.ok
  br label %for.update
}

define internal i32 @"ArrayList$long.count"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %hits = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.867, ptr @.faila.868, i64 %10, ptr @.failb.869, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %10
  %elem = load i64, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, i64 %elem)
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

define internal ptr @"ArrayList$long.sortedBy"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %scratch = alloca ptr, align 8
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayList$long.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$long", ptr null, i64 1) to i64))
  call void @"ArrayList$long.ArrayList$long"(ptr %"ArrayList$long.obj")
  store ptr %"ArrayList$long.obj", ptr %out, align 8
  %out6 = load ptr, ptr %out, align 8
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$long.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %12 = call i32 @"ArrayList$long.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.870, ptr @.faila.871, i64 %9, ptr @.failb.872, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data14, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %9
  %elem = load i64, ptr %arr.elem, align 8
  call void @"ArrayList$long.add"(ptr %out12, i64 %elem)
  br label %for.update

if.then:                                          ; preds = %for.end
  %out17 = load ptr, ptr %out, align 8
  %15 = call i32 @"ArrayList$long.size"(ptr %out17)
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
  %20 = call i32 @"ArrayList$long.size"(ptr %out21)
  %21 = sub i32 %20, 1
  %compare22 = load ptr, ptr %compare, align 8
  call void @"ArrayList$long.mergeSortRange"(ptr %out19, ptr %scratch20, i32 0, i32 %21, ptr %compare22)
  %scratch23 = load ptr, ptr %scratch, align 8
  call void @__polaron_free(ptr %scratch23)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.end
  %out24 = load ptr, ptr %out, align 8
  %count25 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count26 = load i32, ptr %count25, align 4, !tbaa !4
  %22 = icmp sge i32 %count26, 0
  %23 = zext i1 %22 to i32
  %contract.ok = icmp ne i32 %23, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %if.end
  %count27 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count28 = load i32, ptr %count27, align 4, !tbaa !4
  %contract.l = sext i32 %count28 to i64
  call void @__polaron_fail(ptr @.contract.873, ptr @.cl.874, i64 %contract.l, ptr @.cr.875, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count29 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %data31 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  %len33 = load i64, ptr %data32, align 8
  %24 = trunc i64 %len33 to i32
  %25 = icmp sle i32 %count30, %24
  %26 = zext i1 %25 to i32
  %contract.ok34 = icmp ne i32 %26, 0
  br i1 %contract.ok34, label %contract.cont36, label %contract.fail35

contract.fail35:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.876, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont36:                                  ; preds = %contract.cont
  ret ptr %out24
}

define internal void @"ArrayList$long.mergeSortRange"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1, i32 %2, i32 %3, ptr %4) personality ptr @__CxxFrameHandler3 {
entry:
  %t = alloca i32, align 4
  %k = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %mid = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %q = alloca i32, align 4
  %key = alloca i64, align 8
  %p = alloca i32, align 4
  %compare = alloca ptr, align 8
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %tmp = alloca ptr, align 8
  store ptr %1, ptr %tmp, align 8
  store i32 %2, ptr %lo, align 4
  store i32 %3, ptr %hi, align 4
  store ptr %4, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.877, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data20 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok64
  %p68 = load i32, ptr %p, align 4
  %26 = add i32 %p68, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count69 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count70 = load i32, ptr %count69, align 4, !tbaa !4
  %data71 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data72 = load ptr, ptr %data71, align 8, !tbaa !0
  %len73 = load i64, ptr %data72, align 8
  %27 = trunc i64 %len73 to i32
  %28 = icmp sle i32 %count70, %27
  %29 = zext i1 %28 to i32
  %contract.ok74 = icmp ne i32 %29, 0
  br i1 %contract.ok74, label %contract.cont76, label %contract.fail75

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.878, ptr @.faila.879, i64 %25, ptr @.failb.880, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data21, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %25
  %elem = load i64, ptr %arr.elem, align 8
  store i64 %elem, ptr %key, align 8
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
  %data38 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q40 = load i32, ptr %q, align 4
  %33 = add i32 %q40, 1
  %34 = sext i32 %33 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %34, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

while.end:                                        ; preds = %sc.end
  %data58 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data59 = load ptr, ptr %data58, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q60 = load i32, ptr %q, align 4
  %35 = add i32 %q60, 1
  %36 = sext i32 %35 to i64
  %arr.len61 = load i64, ptr %data59, align 8
  %arr.oob62 = icmp uge i64 %36, %arr.len61
  br i1 %arr.oob62, label %idx.bad63, label %idx.ok64, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %37 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %37, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q29 = load i32, ptr %q, align 4
  %38 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %38, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %39 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.881, ptr @.faila.882, i64 %38, ptr @.failb.883, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %sc.rhs
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds i64, ptr %arr.data34, i64 %38
  %elem36 = load i64, ptr %arr.elem35, align 8
  %key37 = load i64, ptr %key, align 8
  %40 = call i32 %code(ptr %env, i64 %elem36, i64 %key37)
  %41 = icmp sgt i32 %40, 0
  %42 = zext i1 %41 to i32
  %sc.b = icmp ne i32 %42, 0
  br label %sc.end

idx.bad43:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.884, ptr @.faila.885, i64 %34, ptr @.failb.886, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds i64, ptr %arr.data45, i64 %34
  %data47 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q49 = load i32, ptr %q, align 4
  %43 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %43, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !8

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.887, ptr @.faila.888, i64 %43, ptr @.failb.889, i64 %arr.len50, i32 70)
  unreachable

idx.ok53:                                         ; preds = %idx.ok44
  %arr.data54 = getelementptr i8, ptr %data48, i64 8
  %arr.elem55 = getelementptr inbounds i64, ptr %arr.data54, i64 %43
  %elem56 = load i64, ptr %arr.elem55, align 8
  store i64 %elem56, ptr %arr.elem46, align 8
  %q57 = load i32, ptr %q, align 4
  %44 = sub i32 %q57, 1
  store i32 %44, ptr %q, align 4
  br label %while.cond

idx.bad63:                                        ; preds = %while.end
  call void @__polaron_fail(ptr @.fail.890, ptr @.faila.891, i64 %36, ptr @.failb.892, i64 %arr.len61, i32 70)
  unreachable

idx.ok64:                                         ; preds = %while.end
  %arr.data65 = getelementptr i8, ptr %data59, i64 8
  %arr.elem66 = getelementptr inbounds i64, ptr %arr.data65, i64 %36
  %key67 = load i64, ptr %key, align 8
  store i64 %key67, ptr %arr.elem66, align 8
  br label %for.update

contract.fail75:                                  ; preds = %for.end
  call void @__polaron_fail(ptr @.contract.893, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  call void @"ArrayList$long.mergeSortRange"(ptr %0, ptr %tmp79, i32 %lo80, i32 %mid81, ptr %compare82)
  %tmp83 = load ptr, ptr %tmp, align 8
  %mid84 = load i32, ptr %mid, align 4
  %46 = add i32 %mid84, 1
  %hi85 = load i32, ptr %hi, align 4
  %compare86 = load ptr, ptr %compare, align 8
  call void @"ArrayList$long.mergeSortRange"(ptr %0, ptr %tmp83, i32 %46, i32 %hi85, ptr %compare86)
  %compare87 = load ptr, ptr %compare, align 8
  %code88 = load ptr, ptr %compare87, align 8
  %47 = getelementptr ptr, ptr %compare87, i32 1
  %env89 = load ptr, ptr %47, align 8
  %data90 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data91 = load ptr, ptr %data90, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid92 = load i32, ptr %mid, align 4
  %48 = sext i32 %mid92 to i64
  %arr.len93 = load i64, ptr %data91, align 8
  %arr.oob94 = icmp uge i64 %48, %arr.len93
  br i1 %arr.oob94, label %idx.bad95, label %idx.ok96, !prof !8

idx.bad95:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.894, ptr @.faila.895, i64 %48, ptr @.failb.896, i64 %arr.len93, i32 70)
  unreachable

idx.ok96:                                         ; preds = %div.ok
  %arr.data97 = getelementptr i8, ptr %data91, i64 8
  %arr.elem98 = getelementptr inbounds i64, ptr %arr.data97, i64 %48
  %elem99 = load i64, ptr %arr.elem98, align 8
  %data100 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data101 = load ptr, ptr %data100, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid102 = load i32, ptr %mid, align 4
  %49 = add i32 %mid102, 1
  %50 = sext i32 %49 to i64
  %arr.len103 = load i64, ptr %data101, align 8
  %arr.oob104 = icmp uge i64 %50, %arr.len103
  br i1 %arr.oob104, label %idx.bad105, label %idx.ok106, !prof !8

idx.bad105:                                       ; preds = %idx.ok96
  call void @__polaron_fail(ptr @.fail.897, ptr @.faila.898, i64 %50, ptr @.failb.899, i64 %arr.len103, i32 70)
  unreachable

idx.ok106:                                        ; preds = %idx.ok96
  %arr.data107 = getelementptr i8, ptr %data101, i64 8
  %arr.elem108 = getelementptr inbounds i64, ptr %arr.data107, i64 %50
  %elem109 = load i64, ptr %arr.elem108, align 8
  %51 = call i32 %code88(ptr %env89, i64 %elem99, i64 %elem109)
  %52 = icmp sle i32 %51, 0
  %53 = zext i1 %52 to i32
  br i1 %52, label %if.then110, label %if.end111

if.then110:                                       ; preds = %idx.ok106
  %count112 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !4
  %data114 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.900, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data138 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data139 = load ptr, ptr %data138, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i140 = load i32, ptr %i, align 4
  %61 = sext i32 %i140 to i64
  %arr.len141 = load i64, ptr %data139, align 8
  %arr.oob142 = icmp uge i64 %61, %arr.len141
  br i1 %arr.oob142, label %idx.bad143, label %idx.ok144, !prof !8

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
  call void @__polaron_fail(ptr @.fail.901, ptr @.faila.902, i64 %61, ptr @.failb.903, i64 %arr.len141, i32 70)
  unreachable

idx.ok144:                                        ; preds = %while.body124
  %arr.data145 = getelementptr i8, ptr %data139, i64 8
  %arr.elem146 = getelementptr inbounds i64, ptr %arr.data145, i64 %61
  %elem147 = load i64, ptr %arr.elem146, align 8
  %data148 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data149 = load ptr, ptr %data148, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j150 = load i32, ptr %j, align 4
  %65 = sext i32 %j150 to i64
  %arr.len151 = load i64, ptr %data149, align 8
  %arr.oob152 = icmp uge i64 %65, %arr.len151
  br i1 %arr.oob152, label %idx.bad153, label %idx.ok154, !prof !8

idx.bad153:                                       ; preds = %idx.ok144
  call void @__polaron_fail(ptr @.fail.904, ptr @.faila.905, i64 %65, ptr @.failb.906, i64 %arr.len151, i32 70)
  unreachable

idx.ok154:                                        ; preds = %idx.ok144
  %arr.data155 = getelementptr i8, ptr %data149, i64 8
  %arr.elem156 = getelementptr inbounds i64, ptr %arr.data155, i64 %65
  %elem157 = load i64, ptr %arr.elem156, align 8
  %66 = call i32 %code136(ptr %env137, i64 %elem147, i64 %elem157)
  %67 = icmp sle i32 %66, 0
  %68 = zext i1 %67 to i32
  br i1 %67, label %if.then158, label %if.else

if.then158:                                       ; preds = %idx.ok154
  %tmp160 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k161 = load i32, ptr %k, align 4
  %69 = sext i32 %k161 to i64
  %arr.len162 = load i64, ptr %tmp160, align 8
  %arr.oob163 = icmp uge i64 %69, %arr.len162
  br i1 %arr.oob163, label %idx.bad164, label %idx.ok165, !prof !8

if.else:                                          ; preds = %idx.ok154
  %tmp179 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k180 = load i32, ptr %k, align 4
  %70 = sext i32 %k180 to i64
  %arr.len181 = load i64, ptr %tmp179, align 8
  %arr.oob182 = icmp uge i64 %70, %arr.len181
  br i1 %arr.oob182, label %idx.bad183, label %idx.ok184, !prof !8

if.end159:                                        ; preds = %idx.ok193, %idx.ok174
  %k198 = load i32, ptr %k, align 4
  %71 = add i32 %k198, 1
  store i32 %71, ptr %k, align 4
  br label %while.cond123

idx.bad164:                                       ; preds = %if.then158
  call void @__polaron_fail(ptr @.fail.907, ptr @.faila.908, i64 %69, ptr @.failb.909, i64 %arr.len162, i32 70)
  unreachable

idx.ok165:                                        ; preds = %if.then158
  %arr.data166 = getelementptr i8, ptr %tmp160, i64 8
  %arr.elem167 = getelementptr inbounds i64, ptr %arr.data166, i64 %69
  %data168 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data169 = load ptr, ptr %data168, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i170 = load i32, ptr %i, align 4
  %72 = sext i32 %i170 to i64
  %arr.len171 = load i64, ptr %data169, align 8
  %arr.oob172 = icmp uge i64 %72, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !8

idx.bad173:                                       ; preds = %idx.ok165
  call void @__polaron_fail(ptr @.fail.910, ptr @.faila.911, i64 %72, ptr @.failb.912, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %idx.ok165
  %arr.data175 = getelementptr i8, ptr %data169, i64 8
  %arr.elem176 = getelementptr inbounds i64, ptr %arr.data175, i64 %72
  %elem177 = load i64, ptr %arr.elem176, align 8
  store i64 %elem177, ptr %arr.elem167, align 8
  %i178 = load i32, ptr %i, align 4
  %73 = add i32 %i178, 1
  store i32 %73, ptr %i, align 4
  br label %if.end159

idx.bad183:                                       ; preds = %if.else
  call void @__polaron_fail(ptr @.fail.913, ptr @.faila.914, i64 %70, ptr @.failb.915, i64 %arr.len181, i32 70)
  unreachable

idx.ok184:                                        ; preds = %if.else
  %arr.data185 = getelementptr i8, ptr %tmp179, i64 8
  %arr.elem186 = getelementptr inbounds i64, ptr %arr.data185, i64 %70
  %data187 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data188 = load ptr, ptr %data187, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j189 = load i32, ptr %j, align 4
  %74 = sext i32 %j189 to i64
  %arr.len190 = load i64, ptr %data188, align 8
  %arr.oob191 = icmp uge i64 %74, %arr.len190
  br i1 %arr.oob191, label %idx.bad192, label %idx.ok193, !prof !8

idx.bad192:                                       ; preds = %idx.ok184
  call void @__polaron_fail(ptr @.fail.916, ptr @.faila.917, i64 %74, ptr @.failb.918, i64 %arr.len190, i32 70)
  unreachable

idx.ok193:                                        ; preds = %idx.ok184
  %arr.data194 = getelementptr i8, ptr %data188, i64 8
  %arr.elem195 = getelementptr inbounds i64, ptr %arr.data194, i64 %74
  %elem196 = load i64, ptr %arr.elem195, align 8
  store i64 %elem196, ptr %arr.elem186, align 8
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
  %tmp204 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k205 = load i32, ptr %k, align 4
  %78 = sext i32 %k205 to i64
  %arr.len206 = load i64, ptr %tmp204, align 8
  %arr.oob207 = icmp uge i64 %78, %arr.len206
  br i1 %arr.oob207, label %idx.bad208, label %idx.ok209, !prof !8

while.end201:                                     ; preds = %while.cond199
  br label %while.cond224

idx.bad208:                                       ; preds = %while.body200
  call void @__polaron_fail(ptr @.fail.919, ptr @.faila.920, i64 %78, ptr @.failb.921, i64 %arr.len206, i32 70)
  unreachable

idx.ok209:                                        ; preds = %while.body200
  %arr.data210 = getelementptr i8, ptr %tmp204, i64 8
  %arr.elem211 = getelementptr inbounds i64, ptr %arr.data210, i64 %78
  %data212 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data213 = load ptr, ptr %data212, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i214 = load i32, ptr %i, align 4
  %79 = sext i32 %i214 to i64
  %arr.len215 = load i64, ptr %data213, align 8
  %arr.oob216 = icmp uge i64 %79, %arr.len215
  br i1 %arr.oob216, label %idx.bad217, label %idx.ok218, !prof !8

idx.bad217:                                       ; preds = %idx.ok209
  call void @__polaron_fail(ptr @.fail.922, ptr @.faila.923, i64 %79, ptr @.failb.924, i64 %arr.len215, i32 70)
  unreachable

idx.ok218:                                        ; preds = %idx.ok209
  %arr.data219 = getelementptr i8, ptr %data213, i64 8
  %arr.elem220 = getelementptr inbounds i64, ptr %arr.data219, i64 %79
  %elem221 = load i64, ptr %arr.elem220, align 8
  store i64 %elem221, ptr %arr.elem211, align 8
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
  %tmp229 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k230 = load i32, ptr %k, align 4
  %84 = sext i32 %k230 to i64
  %arr.len231 = load i64, ptr %tmp229, align 8
  %arr.oob232 = icmp uge i64 %84, %arr.len231
  br i1 %arr.oob232, label %idx.bad233, label %idx.ok234, !prof !8

while.end226:                                     ; preds = %while.cond224
  %lo249 = load i32, ptr %lo, align 4
  store i32 %lo249, ptr %t, align 4
  br label %for.cond250

idx.bad233:                                       ; preds = %while.body225
  call void @__polaron_fail(ptr @.fail.925, ptr @.faila.926, i64 %84, ptr @.failb.927, i64 %arr.len231, i32 70)
  unreachable

idx.ok234:                                        ; preds = %while.body225
  %arr.data235 = getelementptr i8, ptr %tmp229, i64 8
  %arr.elem236 = getelementptr inbounds i64, ptr %arr.data235, i64 %84
  %data237 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data238 = load ptr, ptr %data237, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j239 = load i32, ptr %j, align 4
  %85 = sext i32 %j239 to i64
  %arr.len240 = load i64, ptr %data238, align 8
  %arr.oob241 = icmp uge i64 %85, %arr.len240
  br i1 %arr.oob241, label %idx.bad242, label %idx.ok243, !prof !8

idx.bad242:                                       ; preds = %idx.ok234
  call void @__polaron_fail(ptr @.fail.928, ptr @.faila.929, i64 %85, ptr @.failb.930, i64 %arr.len240, i32 70)
  unreachable

idx.ok243:                                        ; preds = %idx.ok234
  %arr.data244 = getelementptr i8, ptr %data238, i64 8
  %arr.elem245 = getelementptr inbounds i64, ptr %arr.data244, i64 %85
  %elem246 = load i64, ptr %arr.elem245, align 8
  store i64 %elem246, ptr %arr.elem236, align 8
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
  %data256 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data257 = load ptr, ptr %data256, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %t258 = load i32, ptr %t, align 4
  %90 = sext i32 %t258 to i64
  %arr.len259 = load i64, ptr %data257, align 8
  %arr.oob260 = icmp uge i64 %90, %arr.len259
  br i1 %arr.oob260, label %idx.bad261, label %idx.ok262, !prof !8

for.update252:                                    ; preds = %idx.ok270
  %t274 = load i32, ptr %t, align 4
  %91 = add i32 %t274, 1
  store i32 %91, ptr %t, align 4
  br label %for.cond250

for.end253:                                       ; preds = %for.cond250
  %count275 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count276 = load i32, ptr %count275, align 4, !tbaa !4
  %data277 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data278 = load ptr, ptr %data277, align 8, !tbaa !0
  %len279 = load i64, ptr %data278, align 8
  %92 = trunc i64 %len279 to i32
  %93 = icmp sle i32 %count276, %92
  %94 = zext i1 %93 to i32
  %contract.ok280 = icmp ne i32 %94, 0
  br i1 %contract.ok280, label %contract.cont282, label %contract.fail281

idx.bad261:                                       ; preds = %for.body251
  call void @__polaron_fail(ptr @.fail.931, ptr @.faila.932, i64 %90, ptr @.failb.933, i64 %arr.len259, i32 70)
  unreachable

idx.ok262:                                        ; preds = %for.body251
  %arr.data263 = getelementptr i8, ptr %data257, i64 8
  %arr.elem264 = getelementptr inbounds i64, ptr %arr.data263, i64 %90
  %tmp265 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %t266 = load i32, ptr %t, align 4
  %95 = sext i32 %t266 to i64
  %arr.len267 = load i64, ptr %tmp265, align 8
  %arr.oob268 = icmp uge i64 %95, %arr.len267
  br i1 %arr.oob268, label %idx.bad269, label %idx.ok270, !prof !8

idx.bad269:                                       ; preds = %idx.ok262
  call void @__polaron_fail(ptr @.fail.934, ptr @.faila.935, i64 %95, ptr @.failb.936, i64 %arr.len267, i32 70)
  unreachable

idx.ok270:                                        ; preds = %idx.ok262
  %arr.data271 = getelementptr i8, ptr %tmp265, i64 8
  %arr.elem272 = getelementptr inbounds i64, ptr %arr.data271, i64 %95
  %elem273 = load i64, ptr %arr.elem272, align 8
  store i64 %elem273, ptr %arr.elem264, align 8
  br label %for.update252

contract.fail281:                                 ; preds = %for.end253
  call void @__polaron_fail(ptr @.contract.937, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont282:                                 ; preds = %for.end253
  ret void
}

define internal %__polaron_variant @"ArrayList$long.find"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %pred = alloca ptr, align 8
  store ptr %1, ptr %pred, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.938, ptr @.faila.939, i64 %10, ptr @.failb.940, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 %10
  %elem = load i64, ptr %arr.elem, align 8
  %13 = call i32 %code(ptr %env, i64 %elem)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %data13 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.941, ptr @.faila.942, i64 %15, ptr @.failb.943, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.then
  %arr.data20 = getelementptr i8, ptr %data14, i64 8
  %arr.elem21 = getelementptr inbounds i64, ptr %arr.data20, i64 %15
  %elem22 = load i64, ptr %arr.elem21, align 8
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %elem22, 1
  ret %__polaron_variant %var.val
}

define internal %__polaron_variant @"ArrayList$long.min"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca i64, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.944, ptr @.faila.945, i64 0, ptr @.failb.946, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 0
  %elem = load i64, ptr %arr.elem, align 8
  store i64 %elem, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load i64, ptr %best, align 8
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %best37, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.947, ptr @.faila.948, i64 %12, ptr @.failb.949, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i64, ptr %arr.data21, i64 %12
  %elem23 = load i64, ptr %arr.elem22, align 8
  %best24 = load i64, ptr %best, align 8
  %15 = call i32 %code(ptr %env, i64 %elem23, i64 %best24)
  %16 = icmp slt i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %18 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %18, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.950, ptr @.faila.951, i64 %18, ptr @.failb.952, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds i64, ptr %arr.data34, i64 %18
  %elem36 = load i64, ptr %arr.elem35, align 8
  store i64 %elem36, ptr %best, align 8
  br label %if.end26
}

define internal %__polaron_variant @"ArrayList$long.max"(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %best = alloca i64, align 8
  %compare = alloca ptr, align 8
  store ptr %1, ptr %compare, align 8
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.953, ptr @.faila.954, i64 0, ptr @.failb.955, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %data9, i64 8
  %arr.elem = getelementptr inbounds i64, ptr %arr.data, i64 0
  %elem = load i64, ptr %arr.elem, align 8
  store i64 %elem, ptr %best, align 8
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %idx.ok
  %i10 = load i32, ptr %i, align 4
  %count11 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

for.update:                                       ; preds = %if.end26
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %best37 = load i64, ptr %best, align 8
  %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %best37, 1
  ret %__polaron_variant %var.val

idx.bad19:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.956, ptr @.faila.957, i64 %12, ptr @.failb.958, i64 %arr.len17, i32 70)
  unreachable

idx.ok20:                                         ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %data15, i64 8
  %arr.elem22 = getelementptr inbounds i64, ptr %arr.data21, i64 %12
  %elem23 = load i64, ptr %arr.elem22, align 8
  %best24 = load i64, ptr %best, align 8
  %15 = call i32 %code(ptr %env, i64 %elem23, i64 %best24)
  %16 = icmp sgt i32 %15, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then25, label %if.end26

if.then25:                                        ; preds = %idx.ok20
  %data27 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %18 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %18, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.959, ptr @.faila.960, i64 %18, ptr @.failb.961, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %if.then25
  %arr.data34 = getelementptr i8, ptr %data28, i64 8
  %arr.elem35 = getelementptr inbounds i64, ptr %arr.data34, i64 %18
  %elem36 = load i64, ptr %arr.elem35, align 8
  store i64 %elem36, ptr %best, align 8
  br label %if.end26
}

define internal ptr @"ArrayList$long.iterator"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$long", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %"ArrayListIterator$long.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayListIterator$long", ptr null, i64 1) to i64))
  call void @"ArrayListIterator$long.ArrayListIterator$long"(ptr %"ArrayListIterator$long.obj", ptr %0)
  ret ptr %"ArrayListIterator$long.obj"
}

define internal void @"ArrayListIterator$long.ArrayListIterator$long"(ptr %0, ptr %1) {
entry:
  %"ArrayList$long.copy" = alloca %"class.ArrayList$long", align 8
  %list = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %"ArrayList$long.copy", ptr %1, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$long", ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %"class.ArrayList$long", ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.ArrayList$long", ptr %"ArrayList$long.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %"ArrayList$long.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$long.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$long.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$long", ptr null, i64 1) to i64))
  %9 = call ptr @memcpy(ptr %"ArrayList$long.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$long", ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %"class.ArrayList$long", ptr %list3, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len5, 8
  %13 = add i64 8, %12
  %arr.copy6 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy6, ptr %11, i64 %13)
  %15 = getelementptr inbounds %"class.ArrayList$long", ptr %"ArrayList$long.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %15, align 8, !tbaa !0
  store ptr %"ArrayList$long.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$long.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$long.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal i64 @"ArrayListIterator$long.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca i64, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call i64 @"ArrayList$long.get"(ptr %list1, i32 %pos2)
  store i64 %1, ptr %value, align 8
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$long", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !4
  %value6 = load i64, ptr %value, align 8
  ret i64 %value6
}

define internal void @"ArrayList$String.ArrayList$String"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 0
  store ptr @"ArrayList$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %data1, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %2 = icmp sge i32 %count3, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count4 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %contract.l = sext i32 %count5 to i64
  call void @__polaron_fail(ptr @.contract.1170, ptr @.cl.1171, i64 %contract.l, ptr @.cr.1172, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0
  %len = load i64, ptr %data9, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count7, %4
  %6 = zext i1 %5 to i32
  %contract.ok10 = icmp ne i32 %6, 0
  br i1 %contract.ok10, label %contract.cont12, label %contract.fail11

contract.fail11:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1173, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont12:                                  ; preds = %contract.cont
  ret void
}

define internal void @"ArrayList$String.~ArrayList$String"(ptr %0) {
entry:
  %ae.i = alloca i64, align 8
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  store i32 %count7, ptr %old, align 4
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0
  %len12 = load i64, ptr %data11, align 8
  %7 = trunc i64 %len12 to i32
  %8 = icmp sge i32 %count9, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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

if.end:                                           ; preds = %ae.end, %entry
  %data36 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data37 = load ptr, ptr %data36, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count38 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count39 = load i32, ptr %count38, align 4, !tbaa !4
  %16 = sext i32 %count39 to i64
  %arr.len40 = load i64, ptr %data37, align 8
  %arr.oob41 = icmp uge i64 %16, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !8

for.cond:                                         ; preds = %for.update, %if.then
  %i16 = load i32, ptr %i, align 4
  %count17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %17 = icmp slt i32 %i16, %count18
  %18 = zext i1 %17 to i32
  br i1 %17, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger19 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %19 = sext i32 %i20 to i64
  %arr.len = load i64, ptr %bigger19, align 8
  %arr.oob = icmp uge i64 %19, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok28
  %20 = load i32, ptr %i, align 4
  %21 = add i32 %20, 1
  store i32 %21, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0
  %ae.len = load i64, ptr %data32, align 8
  %arr.data33 = getelementptr i8, ptr %data32, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1174, ptr @.faila.1175, i64 %19, ptr @.failb.1176, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data21 = getelementptr i8, ptr %bigger19, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data21, i64 %19
  %data22 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i24 = load i32, ptr %i, align 4
  %22 = sext i32 %i24 to i64
  %arr.len25 = load i64, ptr %data23, align 8
  %arr.oob26 = icmp uge i64 %22, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1177, ptr @.faila.1178, i64 %22, ptr @.failb.1179, i64 %arr.len25, i32 70)
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
  store ptr %bigger35, ptr %data34, align 8, !tbaa !0
  br label %if.end

idx.bad42:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1180, ptr @.faila.1181, i64 %16, ptr @.failb.1182, i64 %arr.len40, i32 70)
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
  %count50 = load i32, ptr %count49, align 4, !tbaa !4
  %28 = add i32 %count50, 1
  store i32 %28, ptr %count48, align 4, !tbaa !4
  %count51 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count52 = load i32, ptr %count51, align 4, !tbaa !4
  %old53 = load i32, ptr %old, align 4
  %29 = add i32 %old53, 1
  %30 = icmp eq i32 %count52, %29
  %31 = zext i1 %30 to i32
  %contract.ok = icmp ne i32 %31, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok43
  call void @__polaron_fail(ptr @.contract.1183, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok43
  %count54 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %32 = icmp sge i32 %count55, 0
  %33 = zext i1 %32 to i32
  %contract.ok56 = icmp ne i32 %33, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

contract.fail57:                                  ; preds = %contract.cont
  %count59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %contract.l = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.1184, ptr @.cl.1185, i64 %contract.l, ptr @.cr.1186, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %contract.cont
  %count61 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count62 = load i32, ptr %count61, align 4, !tbaa !4
  %data63 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data64 = load ptr, ptr %data63, align 8, !tbaa !0
  %len65 = load i64, ptr %data64, align 8
  %34 = trunc i64 %len65 to i32
  %35 = icmp sle i32 %count62, %34
  %36 = zext i1 %35 to i32
  %contract.ok66 = icmp ne i32 %36, 0
  br i1 %contract.ok66, label %contract.cont68, label %contract.fail67

contract.fail67:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.1187, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %n6 = load i32, ptr %n, align 4
  %data7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count32 = load i32, ptr %count31, align 4, !tbaa !4
  %14 = icmp sge i32 %count32, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

for.cond:                                         ; preds = %for.update, %if.then
  %i11 = load i32, ptr %i, align 4
  %count12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
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
  %data26 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data27 = load ptr, ptr %data26, align 8, !tbaa !0
  %ae.len = load i64, ptr %data27, align 8
  %arr.data28 = getelementptr i8, ptr %data27, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1188, ptr @.faila.1189, i64 %18, ptr @.failb.1190, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data16 = getelementptr i8, ptr %bigger14, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data16, i64 %18
  %data17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %21 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %21, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1191, ptr @.faila.1192, i64 %21, ptr @.failb.1193, i64 %arr.len20, i32 70)
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
  store ptr %bigger30, ptr %data29, align 8, !tbaa !0
  br label %if.end

contract.fail:                                    ; preds = %if.end
  %count33 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count34 = load i32, ptr %count33, align 4, !tbaa !4
  %contract.l = sext i32 %count34 to i64
  call void @__polaron_fail(ptr @.contract.1194, ptr @.cl.1195, i64 %contract.l, ptr @.cr.1196, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count35 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count36 = load i32, ptr %count35, align 4, !tbaa !4
  %data37 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data38 = load ptr, ptr %data37, align 8, !tbaa !0
  %len39 = load i64, ptr %data38, align 8
  %26 = trunc i64 %len39 to i32
  %27 = icmp sle i32 %count36, %26
  %28 = zext i1 %27 to i32
  %contract.ok40 = icmp ne i32 %28, 0
  br i1 %contract.ok40, label %contract.cont42, label %contract.fail41

contract.fail41:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1197, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont42:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$String.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %12 = trunc i64 %len14 to i32
  %13 = sext i32 %12 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %13, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data15 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data16 = load ptr, ptr %data15, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i17 = load i32, ptr %i, align 4
  %14 = sext i32 %i17 to i64
  %arr.len18 = load i64, ptr %data16, align 8
  %arr.oob19 = icmp uge i64 %14, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1198, ptr @.faila.1199, i64 %13, ptr @.failb.1200, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy

idx.bad20:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1201, ptr @.faila.1202, i64 %14, ptr @.failb.1203, i64 %arr.len18, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
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
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %data21 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i23 = load i32, ptr %i, align 4
  %15 = sext i32 %i23 to i64
  %arr.len24 = load i64, ptr %data22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1204, ptr @.faila.1205, i64 %14, ptr @.failb.1206, i64 %arr.len, i32 70)
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
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %data18 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data19 = load ptr, ptr %data18, align 8, !tbaa !0
  %len20 = load i64, ptr %data19, align 8
  %17 = trunc i64 %len20 to i32
  %18 = icmp sle i32 %count17, %17
  %19 = zext i1 %18 to i32
  %contract.ok = icmp ne i32 %19, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  call void @__polaron_fail(ptr @.contract.1207, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  ret void

idx.bad26:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1208, ptr @.faila.1209, i64 %15, ptr @.failb.1210, i64 %arr.len24, i32 70)
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
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %data34 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data35 = load ptr, ptr %data34, align 8, !tbaa !0
  %len36 = load i64, ptr %data35, align 8
  %21 = trunc i64 %len36 to i32
  %22 = icmp sle i32 %count33, %21
  %23 = zext i1 %22 to i32
  %contract.ok37 = icmp ne i32 %23, 0
  br i1 %contract.ok37, label %contract.cont39, label %contract.fail38

contract.fail38:                                  ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.contract.1211, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data10 = load ptr, ptr %data9, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i11 = load i32, ptr %i, align 4
  %9 = sext i32 %i11 to i64
  %arr.len = load i64, ptr %data10, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %if.end
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 -1

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1212, ptr @.faila.1213, i64 %9, ptr @.failb.1214, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
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
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1215, ptr @.faila.1216, i64 %13, ptr @.failb.1217, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %data11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %13
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  store ptr %strcpy, ptr %oob, align 8
  %count15 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count16 = load i32, ptr %count15, align 4, !tbaa !4
  %14 = icmp sge i32 %count16, 0
  %15 = zext i1 %14 to i32
  %contract.ok = icmp ne i32 %15, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count17 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
  %contract.l = sext i32 %count18 to i64
  call void @__polaron_fail(ptr @.contract.1218, ptr @.cl.1219, i64 %contract.l, ptr @.cr.1220, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count19 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count20 = load i32, ptr %count19, align 4, !tbaa !4
  %data21 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data22 = load ptr, ptr %data21, align 8, !tbaa !0
  %len23 = load i64, ptr %data22, align 8
  %16 = trunc i64 %len23 to i32
  %17 = icmp sle i32 %count20, %16
  %18 = zext i1 %17 to i32
  %contract.ok24 = icmp ne i32 %18, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1221, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont
  %19 = load ptr, ptr %oob, align 8
  call void @__polaron_str_free(ptr %19)
  ret void

for.cond:                                         ; preds = %for.update, %if.end
  %j28 = load i32, ptr %j, align 4
  %count29 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %20 = sub i32 %count30, 1
  %21 = icmp slt i32 %j28, %20
  %22 = zext i1 %21 to i32
  br i1 %21, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data31 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data32 = load ptr, ptr %data31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j33 = load i32, ptr %j, align 4
  %23 = sext i32 %j33 to i64
  %arr.len34 = load i64, ptr %data32, align 8
  %arr.oob35 = icmp uge i64 %23, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

for.update:                                       ; preds = %idx.ok46
  %24 = load i32, ptr %j, align 4
  %25 = add i32 %24, 1
  store i32 %25, ptr %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count51 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count52 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count53 = load i32, ptr %count52, align 4, !tbaa !4
  %26 = sub i32 %count53, 1
  store i32 %26, ptr %count51, align 4, !tbaa !4
  %count54 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count55 = load i32, ptr %count54, align 4, !tbaa !4
  %27 = icmp sge i32 %count55, 0
  %28 = zext i1 %27 to i32
  %contract.ok56 = icmp ne i32 %28, 0
  br i1 %contract.ok56, label %contract.cont58, label %contract.fail57

idx.bad36:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1222, ptr @.faila.1223, i64 %23, ptr @.failb.1224, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %for.body
  %arr.data38 = getelementptr i8, ptr %data32, i64 8
  %arr.elem39 = getelementptr inbounds ptr, ptr %arr.data38, i64 %23
  %data40 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data41 = load ptr, ptr %data40, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j42 = load i32, ptr %j, align 4
  %29 = add i32 %j42, 1
  %30 = sext i32 %29 to i64
  %arr.len43 = load i64, ptr %data41, align 8
  %arr.oob44 = icmp uge i64 %30, %arr.len43
  br i1 %arr.oob44, label %idx.bad45, label %idx.ok46, !prof !8

idx.bad45:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.1225, ptr @.faila.1226, i64 %30, ptr @.failb.1227, i64 %arr.len43, i32 70)
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
  %count60 = load i32, ptr %count59, align 4, !tbaa !4
  %contract.l61 = sext i32 %count60 to i64
  call void @__polaron_fail(ptr @.contract.1228, ptr @.cl.1229, i64 %contract.l61, ptr @.cr.1230, i64 0, i32 1)
  unreachable

contract.cont58:                                  ; preds = %for.end
  %count62 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count63 = load i32, ptr %count62, align 4, !tbaa !4
  %data64 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data65 = load ptr, ptr %data64, align 8, !tbaa !0
  %len66 = load i64, ptr %data65, align 8
  %32 = trunc i64 %len66 to i32
  %33 = icmp sle i32 %count63, %32
  %34 = zext i1 %33 to i32
  %contract.ok67 = icmp ne i32 %34, 0
  br i1 %contract.ok67, label %contract.cont69, label %contract.fail68

contract.fail68:                                  ; preds = %contract.cont58
  call void @__polaron_fail(ptr @.contract.1231, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %3 = icmp sge i32 %count1, 0
  %4 = zext i1 %3 to i32
  %inv.assume = icmp ne i32 %4, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
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
  %data11 = load ptr, ptr %data10, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %data12 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data13 = load ptr, ptr %data12, align 8, !tbaa !0
  %len14 = load i64, ptr %data13, align 8
  %13 = trunc i64 %len14 to i32
  %14 = sext i32 %13 to i64
  %arr.len = load i64, ptr %data11, align 8
  %arr.oob = icmp uge i64 %14, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.end:                                           ; preds = %sc.end
  %count28 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %data30 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data31 = load ptr, ptr %data30, align 8, !tbaa !0
  %len32 = load i64, ptr %data31, align 8
  %15 = trunc i64 %len32 to i32
  %16 = icmp sge i32 %count29, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then33, label %if.end34

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1232, ptr @.faila.1233, i64 %14, ptr @.failb.1234, i64 %arr.len, i32 70)
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
  %count17 = load i32, ptr %count16, align 4, !tbaa !4
  %19 = icmp sge i32 %count17, 0
  %20 = zext i1 %19 to i32
  %contract.ok = icmp ne i32 %20, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %idx.ok
  %count18 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count19 = load i32, ptr %count18, align 4, !tbaa !4
  %contract.l = sext i32 %count19 to i64
  call void @__polaron_fail(ptr @.contract.1235, ptr @.cl.1236, i64 %contract.l, ptr @.cr.1237, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %idx.ok
  %count20 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count21 = load i32, ptr %count20, align 4, !tbaa !4
  %data22 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data23 = load ptr, ptr %data22, align 8, !tbaa !0
  %len24 = load i64, ptr %data23, align 8
  %21 = trunc i64 %len24 to i32
  %22 = icmp sle i32 %count21, %21
  %23 = zext i1 %22 to i32
  %contract.ok25 = icmp ne i32 %23, 0
  br i1 %contract.ok25, label %contract.cont27, label %contract.fail26

contract.fail26:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1238, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont27:                                  ; preds = %contract.cont
  ret void

if.then33:                                        ; preds = %if.end
  %data35 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data36 = load ptr, ptr %data35, align 8, !tbaa !0
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
  %count66 = load i32, ptr %count65, align 4, !tbaa !4
  store i32 %count66, ptr %j, align 4
  br label %for.cond67

for.cond:                                         ; preds = %for.update, %if.then33
  %k39 = load i32, ptr %k, align 4
  %count40 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count41 = load i32, ptr %count40, align 4, !tbaa !4
  %30 = icmp slt i32 %k39, %count41
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bigger42 = load ptr, ptr %bigger, align 8, !nonnull !6, !dereferenceable !7
  %k43 = load i32, ptr %k, align 4
  %32 = sext i32 %k43 to i64
  %arr.len44 = load i64, ptr %bigger42, align 8
  %arr.oob45 = icmp uge i64 %32, %arr.len44
  br i1 %arr.oob45, label %idx.bad46, label %idx.ok47, !prof !8

for.update:                                       ; preds = %idx.ok56
  %33 = load i32, ptr %k, align 4
  %34 = add i32 %33, 1
  store i32 %34, ptr %k, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data60 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data61 = load ptr, ptr %data60, align 8, !tbaa !0
  %ae.len = load i64, ptr %data61, align 8
  %arr.data62 = getelementptr i8, ptr %data61, i64 8
  store i64 0, ptr %ae.i, align 8
  br label %ae.cond

idx.bad46:                                        ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1239, ptr @.faila.1240, i64 %32, ptr @.failb.1241, i64 %arr.len44, i32 70)
  unreachable

idx.ok47:                                         ; preds = %for.body
  %arr.data48 = getelementptr i8, ptr %bigger42, i64 8
  %arr.elem49 = getelementptr inbounds ptr, ptr %arr.data48, i64 %32
  %data50 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data51 = load ptr, ptr %data50, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %k52 = load i32, ptr %k, align 4
  %35 = sext i32 %k52 to i64
  %arr.len53 = load i64, ptr %data51, align 8
  %arr.oob54 = icmp uge i64 %35, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok47
  call void @__polaron_fail(ptr @.fail.1242, ptr @.faila.1243, i64 %35, ptr @.failb.1244, i64 %arr.len53, i32 70)
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
  store ptr %bigger64, ptr %data63, align 8, !tbaa !0
  br label %if.end34

for.cond67:                                       ; preds = %for.update69, %if.end34
  %j71 = load i32, ptr %j, align 4
  %i72 = load i32, ptr %i, align 4
  %40 = icmp sgt i32 %j71, %i72
  %41 = zext i1 %40 to i32
  br i1 %40, label %for.body68, label %for.end70

for.body68:                                       ; preds = %for.cond67
  %data73 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j75 = load i32, ptr %j, align 4
  %42 = sext i32 %j75 to i64
  %arr.len76 = load i64, ptr %data74, align 8
  %arr.oob77 = icmp uge i64 %42, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !8

for.update69:                                     ; preds = %idx.ok88
  %43 = load i32, ptr %j, align 4
  %44 = sub i32 %43, 1
  store i32 %44, ptr %j, align 4
  br label %for.cond67

for.end70:                                        ; preds = %for.cond67
  %data93 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data94 = load ptr, ptr %data93, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i95 = load i32, ptr %i, align 4
  %45 = sext i32 %i95 to i64
  %arr.len96 = load i64, ptr %data94, align 8
  %arr.oob97 = icmp uge i64 %45, %arr.len96
  br i1 %arr.oob97, label %idx.bad98, label %idx.ok99, !prof !8

idx.bad78:                                        ; preds = %for.body68
  call void @__polaron_fail(ptr @.fail.1245, ptr @.faila.1246, i64 %42, ptr @.failb.1247, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %for.body68
  %arr.data80 = getelementptr i8, ptr %data74, i64 8
  %arr.elem81 = getelementptr inbounds ptr, ptr %arr.data80, i64 %42
  %data82 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data83 = load ptr, ptr %data82, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j84 = load i32, ptr %j, align 4
  %46 = sub i32 %j84, 1
  %47 = sext i32 %46 to i64
  %arr.len85 = load i64, ptr %data83, align 8
  %arr.oob86 = icmp uge i64 %47, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !8

idx.bad87:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.1248, ptr @.faila.1249, i64 %47, ptr @.failb.1250, i64 %arr.len85, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1251, ptr @.faila.1252, i64 %45, ptr @.failb.1253, i64 %arr.len96, i32 70)
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
  %count106 = load i32, ptr %count105, align 4, !tbaa !4
  %50 = add i32 %count106, 1
  store i32 %50, ptr %count104, align 4, !tbaa !4
  %count107 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count108 = load i32, ptr %count107, align 4, !tbaa !4
  %51 = icmp sge i32 %count108, 0
  %52 = zext i1 %51 to i32
  %contract.ok109 = icmp ne i32 %52, 0
  br i1 %contract.ok109, label %contract.cont111, label %contract.fail110

contract.fail110:                                 ; preds = %idx.ok99
  %count112 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count113 = load i32, ptr %count112, align 4, !tbaa !4
  %contract.l114 = sext i32 %count113 to i64
  call void @__polaron_fail(ptr @.contract.1254, ptr @.cl.1255, i64 %contract.l114, ptr @.cr.1256, i64 0, i32 1)
  unreachable

contract.cont111:                                 ; preds = %idx.ok99
  %count115 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count116 = load i32, ptr %count115, align 4, !tbaa !4
  %data117 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data118 = load ptr, ptr %data117, align 8, !tbaa !0
  %len119 = load i64, ptr %data118, align 8
  %53 = trunc i64 %len119 to i32
  %54 = icmp sle i32 %count116, %53
  %55 = zext i1 %54 to i32
  %contract.ok120 = icmp ne i32 %55, 0
  br i1 %contract.ok120, label %contract.cont122, label %contract.fail121

contract.fail121:                                 ; preds = %contract.cont111
  call void @__polaron_fail(ptr @.contract.1257, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %count6, align 4, !tbaa !4
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %6 = icmp sge i32 %count8, 0
  %7 = zext i1 %6 to i32
  %contract.ok = icmp ne i32 %7, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %count9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %contract.l = sext i32 %count10 to i64
  call void @__polaron_fail(ptr @.contract.1258, ptr @.cl.1259, i64 %contract.l, ptr @.cr.1260, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %count11 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0
  %len15 = load i64, ptr %data14, align 8
  %8 = trunc i64 %len15 to i32
  %9 = icmp sle i32 %count12, %8
  %10 = zext i1 %9 to i32
  %contract.ok16 = icmp ne i32 %10, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1261, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont
  ret void
}

define internal ptr @"ArrayList$String.toArray"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
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
  %count9 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
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
  call void @__polaron_fail(ptr @.fail.1262, ptr @.faila.1263, i64 %12, ptr @.failb.1264, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data13 = getelementptr i8, ptr %out11, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data13, i64 %12
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %15 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %15, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

idx.bad19:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1265, ptr @.faila.1266, i64 %15, ptr @.failb.1267, i64 %arr.len17, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  ret i32 %count7
}

define internal i32 @"ArrayList$String.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %3 = trunc i64 %len to i32
  %4 = icmp sle i32 %count3, %3
  %5 = zext i1 %4 to i32
  %inv.assume5 = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %action9 = load ptr, ptr %action, align 8
  %code = load ptr, ptr %action9, align 8
  %9 = getelementptr ptr, ptr %action9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1268, ptr @.faila.1269, i64 %10, ptr @.failb.1270, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$String.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %keep12 = load ptr, ptr %keep, align 8
  %code = load ptr, ptr %keep12, align 8
  %9 = getelementptr ptr, ptr %keep12, i32 1
  %env = load ptr, ptr %9, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1271, ptr @.faila.1272, i64 %10, ptr @.failb.1273, i64 %arr.len, i32 70)
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
  %data18 = load ptr, ptr %data17, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i19 = load i32, ptr %i, align 4
  %15 = sext i32 %i19 to i64
  %arr.len20 = load i64, ptr %data18, align 8
  %arr.oob21 = icmp uge i64 %15, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

if.end:                                           ; preds = %idx.ok23, %idx.ok
  br label %for.update

idx.bad22:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1274, ptr @.faila.1275, i64 %15, ptr @.failb.1276, i64 %arr.len20, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1277, ptr @.faila.1278, i64 %10, ptr @.failb.1279, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1280, ptr @.faila.1281, i64 %10, ptr @.failb.1282, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1283, ptr @.faila.1284, i64 %10, ptr @.failb.1285, i64 %arr.len, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
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
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  call void @"ArrayList$String.ensureCapacity"(ptr %out6, i32 %count8)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i9 = load i32, ptr %i, align 4
  %count10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count11 = load i32, ptr %count10, align 4, !tbaa !4
  %7 = icmp slt i32 %i9, %count11
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out12 = load ptr, ptr %out, align 8
  %data13 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %12 = call i32 @"ArrayList$String.size"(ptr %out16)
  %13 = icmp sgt i32 %12, 1
  %14 = zext i1 %13 to i32
  br i1 %13, label %if.then, label %if.end

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1286, ptr @.faila.1287, i64 %9, ptr @.failb.1288, i64 %arr.len, i32 70)
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
  %count29 = load i32, ptr %count28, align 4, !tbaa !4
  %contract.l = sext i32 %count29 to i64
  call void @__polaron_fail(ptr @.contract.1289, ptr @.cl.1290, i64 %contract.l, ptr @.cr.1291, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %if.end
  %count30 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count31 = load i32, ptr %count30, align 4, !tbaa !4
  %data32 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data33 = load ptr, ptr %data32, align 8, !tbaa !0
  %len34 = load i64, ptr %data33, align 8
  %27 = trunc i64 %len34 to i32
  %28 = icmp sle i32 %count31, %27
  %29 = zext i1 %28 to i32
  %contract.ok35 = icmp ne i32 %29, 0
  br i1 %contract.ok35, label %contract.cont37, label %contract.fail36

contract.fail36:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.1292, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %5 = icmp sge i32 %count1, 0
  %6 = zext i1 %5 to i32
  %inv.assume = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.contract.1293, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data21 = load ptr, ptr %data20, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %p22 = load i32, ptr %p, align 4
  %25 = sext i32 %p22 to i64
  %arr.len = load i64, ptr %data21, align 8
  %arr.oob = icmp uge i64 %25, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok65
  %p70 = load i32, ptr %p, align 4
  %26 = add i32 %p70, 1
  store i32 %26, ptr %p, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %count71 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count72 = load i32, ptr %count71, align 4, !tbaa !4
  %data73 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data74 = load ptr, ptr %data73, align 8, !tbaa !0
  %len75 = load i64, ptr %data74, align 8
  %27 = trunc i64 %len75 to i32
  %28 = icmp sle i32 %count72, %27
  %29 = zext i1 %28 to i32
  %contract.ok76 = icmp ne i32 %29, 0
  br i1 %contract.ok76, label %contract.cont78, label %contract.fail77

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.1294, ptr @.faila.1295, i64 %25, ptr @.failb.1296, i64 %arr.len, i32 70)
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
  %data39 = load ptr, ptr %data38, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q40 = load i32, ptr %q, align 4
  %33 = add i32 %q40, 1
  %34 = sext i32 %33 to i64
  %arr.len41 = load i64, ptr %data39, align 8
  %arr.oob42 = icmp uge i64 %34, %arr.len41
  br i1 %arr.oob42, label %idx.bad43, label %idx.ok44, !prof !8

while.end:                                        ; preds = %sc.end
  %data59 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data60 = load ptr, ptr %data59, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q61 = load i32, ptr %q, align 4
  %35 = add i32 %q61, 1
  %36 = sext i32 %35 to i64
  %arr.len62 = load i64, ptr %data60, align 8
  %arr.oob63 = icmp uge i64 %36, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !8

sc.rhs:                                           ; preds = %while.cond
  %compare26 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare26, align 8
  %37 = getelementptr ptr, ptr %compare26, i32 1
  %env = load ptr, ptr %37, align 8
  %data27 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q29 = load i32, ptr %q, align 4
  %38 = sext i32 %q29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %38, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

sc.end:                                           ; preds = %idx.ok33, %while.cond
  %sc = phi i1 [ false, %while.cond ], [ %sc.b, %idx.ok33 ]
  %39 = zext i1 %sc to i32
  br i1 %sc, label %while.body, label %while.end

idx.bad32:                                        ; preds = %sc.rhs
  call void @__polaron_fail(ptr @.fail.1297, ptr @.faila.1298, i64 %38, ptr @.failb.1299, i64 %arr.len30, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1300, ptr @.faila.1301, i64 %34, ptr @.failb.1302, i64 %arr.len41, i32 70)
  unreachable

idx.ok44:                                         ; preds = %while.body
  %arr.data45 = getelementptr i8, ptr %data39, i64 8
  %arr.elem46 = getelementptr inbounds ptr, ptr %arr.data45, i64 %34
  %data47 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data48 = load ptr, ptr %data47, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %q49 = load i32, ptr %q, align 4
  %43 = sext i32 %q49 to i64
  %arr.len50 = load i64, ptr %data48, align 8
  %arr.oob51 = icmp uge i64 %43, %arr.len50
  br i1 %arr.oob51, label %idx.bad52, label %idx.ok53, !prof !8

idx.bad52:                                        ; preds = %idx.ok44
  call void @__polaron_fail(ptr @.fail.1303, ptr @.faila.1304, i64 %43, ptr @.failb.1305, i64 %arr.len50, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1306, ptr @.faila.1307, i64 %36, ptr @.failb.1308, i64 %arr.len62, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1309, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data93 = load ptr, ptr %data92, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid94 = load i32, ptr %mid, align 4
  %51 = sext i32 %mid94 to i64
  %arr.len95 = load i64, ptr %data93, align 8
  %arr.oob96 = icmp uge i64 %51, %arr.len95
  br i1 %arr.oob96, label %idx.bad97, label %idx.ok98, !prof !8

idx.bad97:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.1310, ptr @.faila.1311, i64 %51, ptr @.failb.1312, i64 %arr.len95, i32 70)
  unreachable

idx.ok98:                                         ; preds = %div.ok
  %arr.data99 = getelementptr i8, ptr %data93, i64 8
  %arr.elem100 = getelementptr inbounds ptr, ptr %arr.data99, i64 %51
  %elem101 = load ptr, ptr %arr.elem100, align 8
  %data102 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data103 = load ptr, ptr %data102, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %mid104 = load i32, ptr %mid, align 4
  %52 = add i32 %mid104, 1
  %53 = sext i32 %52 to i64
  %arr.len105 = load i64, ptr %data103, align 8
  %arr.oob106 = icmp uge i64 %53, %arr.len105
  br i1 %arr.oob106, label %idx.bad107, label %idx.ok108, !prof !8

idx.bad107:                                       ; preds = %idx.ok98
  call void @__polaron_fail(ptr @.fail.1313, ptr @.faila.1314, i64 %53, ptr @.failb.1315, i64 %arr.len105, i32 70)
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
  %count115 = load i32, ptr %count114, align 4, !tbaa !4
  %data116 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data117 = load ptr, ptr %data116, align 8, !tbaa !0
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
  call void @__polaron_fail(ptr @.contract.1316, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %data141 = load ptr, ptr %data140, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i142 = load i32, ptr %i, align 4
  %64 = sext i32 %i142 to i64
  %arr.len143 = load i64, ptr %data141, align 8
  %arr.oob144 = icmp uge i64 %64, %arr.len143
  br i1 %arr.oob144, label %idx.bad145, label %idx.ok146, !prof !8

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
  call void @__polaron_fail(ptr @.fail.1317, ptr @.faila.1318, i64 %64, ptr @.failb.1319, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %while.body126
  %arr.data147 = getelementptr i8, ptr %data141, i64 8
  %arr.elem148 = getelementptr inbounds ptr, ptr %arr.data147, i64 %64
  %elem149 = load ptr, ptr %arr.elem148, align 8
  %data150 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data151 = load ptr, ptr %data150, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j152 = load i32, ptr %j, align 4
  %68 = sext i32 %j152 to i64
  %arr.len153 = load i64, ptr %data151, align 8
  %arr.oob154 = icmp uge i64 %68, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !8

idx.bad155:                                       ; preds = %idx.ok146
  call void @__polaron_fail(ptr @.fail.1320, ptr @.faila.1321, i64 %68, ptr @.failb.1322, i64 %arr.len153, i32 70)
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
  %tmp162 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k163 = load i32, ptr %k, align 4
  %72 = sext i32 %k163 to i64
  %arr.len164 = load i64, ptr %tmp162, align 8
  %arr.oob165 = icmp uge i64 %72, %arr.len164
  br i1 %arr.oob165, label %idx.bad166, label %idx.ok167, !prof !8

if.else:                                          ; preds = %idx.ok156
  %tmp182 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k183 = load i32, ptr %k, align 4
  %73 = sext i32 %k183 to i64
  %arr.len184 = load i64, ptr %tmp182, align 8
  %arr.oob185 = icmp uge i64 %73, %arr.len184
  br i1 %arr.oob185, label %idx.bad186, label %idx.ok187, !prof !8

if.end161:                                        ; preds = %idx.ok196, %idx.ok176
  %k202 = load i32, ptr %k, align 4
  %74 = add i32 %k202, 1
  store i32 %74, ptr %k, align 4
  br label %while.cond125

idx.bad166:                                       ; preds = %if.then160
  call void @__polaron_fail(ptr @.fail.1323, ptr @.faila.1324, i64 %72, ptr @.failb.1325, i64 %arr.len164, i32 70)
  unreachable

idx.ok167:                                        ; preds = %if.then160
  %arr.data168 = getelementptr i8, ptr %tmp162, i64 8
  %arr.elem169 = getelementptr inbounds ptr, ptr %arr.data168, i64 %72
  %data170 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data171 = load ptr, ptr %data170, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i172 = load i32, ptr %i, align 4
  %75 = sext i32 %i172 to i64
  %arr.len173 = load i64, ptr %data171, align 8
  %arr.oob174 = icmp uge i64 %75, %arr.len173
  br i1 %arr.oob174, label %idx.bad175, label %idx.ok176, !prof !8

idx.bad175:                                       ; preds = %idx.ok167
  call void @__polaron_fail(ptr @.fail.1326, ptr @.faila.1327, i64 %75, ptr @.failb.1328, i64 %arr.len173, i32 70)
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
  call void @__polaron_fail(ptr @.fail.1329, ptr @.faila.1330, i64 %73, ptr @.failb.1331, i64 %arr.len184, i32 70)
  unreachable

idx.ok187:                                        ; preds = %if.else
  %arr.data188 = getelementptr i8, ptr %tmp182, i64 8
  %arr.elem189 = getelementptr inbounds ptr, ptr %arr.data188, i64 %73
  %data190 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data191 = load ptr, ptr %data190, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j192 = load i32, ptr %j, align 4
  %78 = sext i32 %j192 to i64
  %arr.len193 = load i64, ptr %data191, align 8
  %arr.oob194 = icmp uge i64 %78, %arr.len193
  br i1 %arr.oob194, label %idx.bad195, label %idx.ok196, !prof !8

idx.bad195:                                       ; preds = %idx.ok187
  call void @__polaron_fail(ptr @.fail.1332, ptr @.faila.1333, i64 %78, ptr @.failb.1334, i64 %arr.len193, i32 70)
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
  %tmp208 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k209 = load i32, ptr %k, align 4
  %83 = sext i32 %k209 to i64
  %arr.len210 = load i64, ptr %tmp208, align 8
  %arr.oob211 = icmp uge i64 %83, %arr.len210
  br i1 %arr.oob211, label %idx.bad212, label %idx.ok213, !prof !8

while.end205:                                     ; preds = %while.cond203
  br label %while.cond229

idx.bad212:                                       ; preds = %while.body204
  call void @__polaron_fail(ptr @.fail.1335, ptr @.faila.1336, i64 %83, ptr @.failb.1337, i64 %arr.len210, i32 70)
  unreachable

idx.ok213:                                        ; preds = %while.body204
  %arr.data214 = getelementptr i8, ptr %tmp208, i64 8
  %arr.elem215 = getelementptr inbounds ptr, ptr %arr.data214, i64 %83
  %data216 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data217 = load ptr, ptr %data216, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i218 = load i32, ptr %i, align 4
  %84 = sext i32 %i218 to i64
  %arr.len219 = load i64, ptr %data217, align 8
  %arr.oob220 = icmp uge i64 %84, %arr.len219
  br i1 %arr.oob220, label %idx.bad221, label %idx.ok222, !prof !8

idx.bad221:                                       ; preds = %idx.ok213
  call void @__polaron_fail(ptr @.fail.1338, ptr @.faila.1339, i64 %84, ptr @.failb.1340, i64 %arr.len219, i32 70)
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
  %tmp234 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %k235 = load i32, ptr %k, align 4
  %90 = sext i32 %k235 to i64
  %arr.len236 = load i64, ptr %tmp234, align 8
  %arr.oob237 = icmp uge i64 %90, %arr.len236
  br i1 %arr.oob237, label %idx.bad238, label %idx.ok239, !prof !8

while.end231:                                     ; preds = %while.cond229
  %lo255 = load i32, ptr %lo, align 4
  store i32 %lo255, ptr %t, align 4
  br label %for.cond256

idx.bad238:                                       ; preds = %while.body230
  call void @__polaron_fail(ptr @.fail.1341, ptr @.faila.1342, i64 %90, ptr @.failb.1343, i64 %arr.len236, i32 70)
  unreachable

idx.ok239:                                        ; preds = %while.body230
  %arr.data240 = getelementptr i8, ptr %tmp234, i64 8
  %arr.elem241 = getelementptr inbounds ptr, ptr %arr.data240, i64 %90
  %data242 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data243 = load ptr, ptr %data242, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %j244 = load i32, ptr %j, align 4
  %91 = sext i32 %j244 to i64
  %arr.len245 = load i64, ptr %data243, align 8
  %arr.oob246 = icmp uge i64 %91, %arr.len245
  br i1 %arr.oob246, label %idx.bad247, label %idx.ok248, !prof !8

idx.bad247:                                       ; preds = %idx.ok239
  call void @__polaron_fail(ptr @.fail.1344, ptr @.faila.1345, i64 %91, ptr @.failb.1346, i64 %arr.len245, i32 70)
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
  %data263 = load ptr, ptr %data262, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %t264 = load i32, ptr %t, align 4
  %97 = sext i32 %t264 to i64
  %arr.len265 = load i64, ptr %data263, align 8
  %arr.oob266 = icmp uge i64 %97, %arr.len265
  br i1 %arr.oob266, label %idx.bad267, label %idx.ok268, !prof !8

for.update258:                                    ; preds = %idx.ok276
  %t281 = load i32, ptr %t, align 4
  %98 = add i32 %t281, 1
  store i32 %98, ptr %t, align 4
  br label %for.cond256

for.end259:                                       ; preds = %for.cond256
  %count282 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count283 = load i32, ptr %count282, align 4, !tbaa !4
  %data284 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data285 = load ptr, ptr %data284, align 8, !tbaa !0
  %len286 = load i64, ptr %data285, align 8
  %99 = trunc i64 %len286 to i32
  %100 = icmp sle i32 %count283, %99
  %101 = zext i1 %100 to i32
  %contract.ok287 = icmp ne i32 %101, 0
  br i1 %contract.ok287, label %contract.cont289, label %contract.fail288

idx.bad267:                                       ; preds = %for.body257
  call void @__polaron_fail(ptr @.fail.1347, ptr @.faila.1348, i64 %97, ptr @.failb.1349, i64 %arr.len265, i32 70)
  unreachable

idx.ok268:                                        ; preds = %for.body257
  %arr.data269 = getelementptr i8, ptr %data263, i64 8
  %arr.elem270 = getelementptr inbounds ptr, ptr %arr.data269, i64 %97
  %tmp271 = load ptr, ptr %tmp, align 8, !nonnull !6, !dereferenceable !7
  %t272 = load i32, ptr %t, align 4
  %102 = sext i32 %t272 to i64
  %arr.len273 = load i64, ptr %tmp271, align 8
  %arr.oob274 = icmp uge i64 %102, %arr.len273
  br i1 %arr.oob274, label %idx.bad275, label %idx.ok276, !prof !8

idx.bad275:                                       ; preds = %idx.ok268
  call void @__polaron_fail(ptr @.fail.1350, ptr @.faila.1351, i64 %102, ptr @.failb.1352, i64 %arr.len273, i32 70)
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
  call void @__polaron_fail(ptr @.contract.1353, ptr null, i64 0, ptr null, i64 0, i32 1)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  %count7 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
  %7 = icmp slt i32 %i6, %count8
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pred9 = load ptr, ptr %pred, align 8
  %code = load ptr, ptr %pred9, align 8
  %9 = getelementptr ptr, ptr %pred9, i32 1
  %env = load ptr, ptr %9, align 8
  %data10 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
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
  call void @__polaron_fail(ptr @.fail.1354, ptr @.faila.1355, i64 %10, ptr @.failb.1356, i64 %arr.len, i32 70)
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
  %data14 = load ptr, ptr %data13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i15 = load i32, ptr %i, align 4
  %15 = sext i32 %i15 to i64
  %arr.len16 = load i64, ptr %data14, align 8
  %arr.oob17 = icmp uge i64 %15, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

if.end:                                           ; preds = %idx.ok
  br label %for.update

idx.bad18:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1357, ptr @.faila.1358, i64 %15, ptr @.failb.1359, i64 %arr.len16, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1360, ptr @.faila.1361, i64 0, ptr @.failb.1362, i64 %arr.len, i32 70)
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
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

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
  call void @__polaron_fail(ptr @.fail.1363, ptr @.faila.1364, i64 %12, ptr @.failb.1365, i64 %arr.len17, i32 70)
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
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1366, ptr @.faila.1367, i64 %19, ptr @.failb.1368, i64 %arr.len30, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp sge i32 %count1, 0
  %3 = zext i1 %2 to i32
  %inv.assume = icmp ne i32 %3, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
  %len = load i64, ptr %data4, align 8
  %4 = trunc i64 %len to i32
  %5 = icmp sle i32 %count3, %4
  %6 = zext i1 %5 to i32
  %inv.assume5 = icmp ne i32 %6, 0
  call void @llvm.assume(i1 %inv.assume5)
  %count6 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count7 = load i32, ptr %count6, align 4, !tbaa !4
  %7 = icmp eq i32 %count7, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret %__polaron_variant { i32 1, i64 0 }

if.end:                                           ; preds = %entry
  %data8 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data9 = load ptr, ptr %data8, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %data9, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.1369, ptr @.faila.1370, i64 0, ptr @.failb.1371, i64 %arr.len, i32 70)
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
  %count12 = load i32, ptr %count11, align 4, !tbaa !4
  %9 = icmp slt i32 %i10, %count12
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %compare13 = load ptr, ptr %compare, align 8
  %code = load ptr, ptr %compare13, align 8
  %11 = getelementptr ptr, ptr %compare13, i32 1
  %env = load ptr, ptr %11, align 8
  %data14 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data15 = load ptr, ptr %data14, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i16 = load i32, ptr %i, align 4
  %12 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %data15, align 8
  %arr.oob18 = icmp uge i64 %12, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !8

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
  call void @__polaron_fail(ptr @.fail.1372, ptr @.faila.1373, i64 %12, ptr @.failb.1374, i64 %arr.len17, i32 70)
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
  %data28 = load ptr, ptr %data27, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i29 = load i32, ptr %i, align 4
  %19 = sext i32 %i29 to i64
  %arr.len30 = load i64, ptr %data28, align 8
  %arr.oob31 = icmp uge i64 %19, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

if.end26:                                         ; preds = %idx.ok33, %idx.ok20
  br label %for.update

idx.bad32:                                        ; preds = %if.then25
  call void @__polaron_fail(ptr @.fail.1375, ptr @.faila.1376, i64 %19, ptr @.failb.1377, i64 %arr.len30, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp sge i32 %count1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %count2 = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 2
  %count3 = load i32, ptr %count2, align 4, !tbaa !4
  %data = getelementptr inbounds %"class.ArrayList$String", ptr %0, i32 0, i32 1
  %data4 = load ptr, ptr %data, align 8, !tbaa !0
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
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 8
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %"class.ArrayList$String", ptr %"ArrayList$String.copy", i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %"ArrayList$String.copy", ptr %list, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 0
  store ptr @"ArrayListIterator$String.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %list1 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %list1, align 8, !tbaa !0
  %list2 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list3 = load ptr, ptr %list, align 8
  %"ArrayList$String.copy4" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %9 = call ptr @memcpy(ptr %"ArrayList$String.copy4", ptr %list3, i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %"class.ArrayList$String", ptr %list3, i32 0, i32 1
  %11 = load ptr, ptr %10, align 8, !tbaa !0
  %arr.len5 = load i64, ptr %11, align 8
  %12 = mul i64 %arr.len5, 8
  %13 = add i64 8, %12
  %arr.copy6 = call ptr @__polaron_malloc(i64 %13)
  %14 = call ptr @memcpy(ptr %arr.copy6, ptr %11, i64 %13)
  %15 = getelementptr inbounds %"class.ArrayList$String", ptr %"ArrayList$String.copy4", i32 0, i32 1
  store ptr %arr.copy6, ptr %15, align 8, !tbaa !0
  store ptr %"ArrayList$String.copy4", ptr %list2, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @"ArrayListIterator$String.hasNext"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %list = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list2 = load ptr, ptr %list, align 8, !tbaa !0
  %1 = call i32 @"ArrayList$String.size"(ptr %list2)
  %2 = icmp slt i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal ptr @"ArrayListIterator$String.next"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %value = alloca ptr, align 8
  %list = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 1
  %list1 = load ptr, ptr %list, align 8, !tbaa !0
  %pos = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = call ptr @"ArrayList$String.get"(ptr %list1, i32 %pos2)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  store ptr %strcpy, ptr %value, align 8
  call void @__polaron_str_free(ptr %1)
  %pos3 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %"class.ArrayListIterator$String", ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %2 = add i32 %pos5, 1
  store i32 %2, ptr %pos3, align 4, !tbaa !4
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1389)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1391)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !4
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !4
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !4
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
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
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
  store i32 %n21, ptr %cap20, align 4, !tbaa !4
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
  %count4 = load i32, ptr %count, align 4, !tbaa !4
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
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !4
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
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !4
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !4
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
  %count7 = load i32, ptr %count, align 4, !tbaa !4
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
  %count18 = load i32, ptr %count17, align 4, !tbaa !4
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
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !9
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
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
  store i32 0, ptr %count, align 4, !tbaa !4
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

define internal i32 @IpcProto.kCreate() {
entry:
  ret i32 1
}

define internal i32 @IpcProto.kCall() {
entry:
  ret i32 2
}

define internal i32 @IpcProto.kRelease() {
entry:
  ret i32 3
}

define internal i32 @IpcProto.kCapability() {
entry:
  ret i32 4
}

define internal i32 @IpcProto.kReplyOk() {
entry:
  ret i32 10
}

define internal i32 @IpcProto.kReplyError() {
entry:
  ret i32 11
}

define internal ptr @IpcProto.errorFrame(ptr %0) {
entry:
  %f = alloca ptr, align 8
  %w = alloca ptr, align 8
  %text = alloca ptr, align 8
  store ptr %0, ptr %text, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %1 = call i32 @IpcProto.kReplyError()
  call void @IpcWriter.putByte(ptr %w1, i32 %1)
  %w2 = load ptr, ptr %w, align 8
  %text3 = load ptr, ptr %text, align 8
  call void @IpcWriter.putString(ptr %w2, ptr %text3)
  %w4 = load ptr, ptr %w, align 8
  %2 = call ptr @IpcWriter.toFrame(ptr %w4)
  %strcpy = call ptr @__polaron_str_copy(ptr %2)
  store ptr %strcpy, ptr %f, align 8
  call void @__polaron_str_free(ptr %2)
  %w5 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w5)
  %vtbl.addr = getelementptr inbounds %class.IpcWriter, ptr %w5, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %3 = icmp ne ptr %dtor.fn, null
  br i1 %3, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %w5)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %w5)
  %f6 = load ptr, ptr %f, align 8
  %strcpy7 = call ptr @__polaron_str_copy(ptr %f6)
  %4 = load ptr, ptr %f, align 8
  call void @__polaron_str_free(ptr %4)
  ret ptr %strcpy7
}

define internal ptr @IpcProto.okFrame() {
entry:
  %f = alloca ptr, align 8
  %w = alloca ptr, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %0 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w1, i32 %0)
  %w2 = load ptr, ptr %w, align 8
  %1 = call ptr @IpcWriter.toFrame(ptr %w2)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  store ptr %strcpy, ptr %f, align 8
  call void @__polaron_str_free(ptr %1)
  %w3 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w3)
  %vtbl.addr = getelementptr inbounds %class.IpcWriter, ptr %w3, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %2 = icmp ne ptr %dtor.fn, null
  br i1 %2, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %w3)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %w3)
  %f4 = load ptr, ptr %f, align 8
  %strcpy5 = call ptr @__polaron_str_copy(ptr %f4)
  %3 = load ptr, ptr %f, align 8
  call void @__polaron_str_free(ptr %3)
  ret ptr %strcpy5
}

define internal void @IpcWriter.IpcWriter(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 0
  store ptr @IpcWriter.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  store ptr null, ptr %sb, align 8, !tbaa !0
  %sb1 = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb1, align 8, !tbaa !0
  ret void
}

define internal void @IpcWriter.putByte(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %b = alloca i32, align 4
  store i32 %1, ptr %b, align 4
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !0
  %b2 = load i32, ptr %b, align 4
  %2 = and i32 %b2, 255
  %3 = call ptr @StringBuilder.appendChar(ptr %sb1, i32 %2)
  ret void
}

define internal void @IpcWriter.putLong(ptr nonnull align 8 dereferenceable(16) %0, i64 %1) {
entry:
  %i = alloca i32, align 4
  %v = alloca i64, align 8
  store i64 %1, ptr %v, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i1, 8
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v2 = load i64, ptr %v, align 8
  %i3 = load i32, ptr %i, align 4
  %4 = mul i32 %i3, 8
  %5 = sext i32 %4 to i64
  %6 = ashr i64 %v2, 63
  %7 = icmp ult i64 %5, 64
  %8 = select i1 %7, i64 %5, i64 0
  %9 = ashr i64 %v2, %8
  %10 = select i1 %7, i64 %9, i64 %6
  %11 = and i64 %10, 255
  %12 = trunc i64 %11 to i32
  call void @IpcWriter.putByte(ptr %0, i32 %12)
  %i4 = load i32, ptr %i, align 4
  %13 = add i32 %i4, 1
  store i32 %13, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

define internal void @IpcWriter.putInt(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = sext i32 %v1 to i64
  call void @IpcWriter.putLong(ptr %0, i64 %2)
  ret void
}

define internal void @IpcWriter.putBoolean(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %b = alloca i32, align 4
  store i32 %1, ptr %b, align 4
  %b1 = load i32, ptr %b, align 4
  %2 = icmp ne i32 %b1, 0
  br i1 %2, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  call void @IpcWriter.putByte(ptr %0, i32 1)
  br label %if.end

if.else:                                          ; preds = %entry
  call void @IpcWriter.putByte(ptr %0, i32 0)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define internal void @IpcWriter.putChar(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  %c1 = load i32, ptr %c, align 4
  %2 = and i32 %c1, 255
  call void @IpcWriter.putByte(ptr %0, i32 %2)
  ret void
}

define internal void @IpcWriter.putDouble(ptr nonnull align 8 dereferenceable(16) %0, double %1) {
entry:
  %d = alloca double, align 8
  store double %1, ptr %d, align 8
  %d1 = load double, ptr %d, align 8
  %bits.d2l = bitcast double %d1 to i64
  call void @IpcWriter.putLong(ptr %0, i64 %bits.d2l)
  ret void
}

define internal void @IpcWriter.putString(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %s1 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  call void @IpcWriter.putInt(ptr %0, i32 %2)
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb2 = load ptr, ptr %sb, align 8, !tbaa !0
  %s3 = load ptr, ptr %s, align 8
  %3 = call ptr @StringBuilder.append(ptr %sb2, ptr %s3)
  ret void
}

define internal ptr @IpcWriter.toFrame(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !0
  %1 = call ptr @StringBuilder.toString(ptr %sb1)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal void @"IpcWriter.~IpcWriter"(ptr %0) {
entry:
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !0
  call void @__polaron_check_live(ptr %sb1)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %sb1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %1 = icmp ne ptr %dtor.fn, null
  br i1 %1, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %sb1)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  call void @__polaron_free(ptr %sb1)
  ret void
}

define internal void @IpcReader.IpcReader(ptr %0, ptr %1) {
entry:
  %frame = alloca ptr, align 8
  store ptr %1, ptr %frame, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 0
  store ptr @IpcReader.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %buf = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  store ptr null, ptr %buf, align 8, !tbaa !0
  %buf1 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  %frame2 = load ptr, ptr %frame, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %frame2)
  %2 = load ptr, ptr %buf1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %buf1, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @IpcReader.atEnd(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !4
  %buf = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  %buf2 = load ptr, ptr %buf, align 8, !tbaa !0
  %str.len = getelementptr inbounds %String, ptr %buf2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  %2 = icmp sge i32 %pos1, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal i32 @IpcReader.getByte(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %b = alloca i32, align 4
  %buf = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  %buf1 = load ptr, ptr %buf, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = sext i32 %pos2 to i64
  %str.data = getelementptr inbounds %String, ptr %buf1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %1
  %ch = load i8, ptr %ch.addr, align 1
  %2 = zext i8 %ch to i32
  %3 = and i32 %2, 255
  store i32 %3, ptr %b, align 4
  %pos3 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos4 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !4
  %4 = add i32 %pos5, 1
  store i32 %4, ptr %pos3, align 4, !tbaa !4
  %b6 = load i32, ptr %b, align 4
  ret i32 %b6
}

define internal i64 @IpcReader.getLong(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %v = alloca i64, align 8
  store i64 0, ptr %v, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %1 = icmp slt i32 %i1, 8
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %v2 = load i64, ptr %v, align 8
  %3 = call i32 @IpcReader.getByte(ptr %0)
  %4 = sext i32 %3 to i64
  %i3 = load i32, ptr %i, align 4
  %5 = mul i32 %i3, 8
  %6 = sext i32 %5 to i64
  %7 = icmp ult i64 %6, 64
  %8 = select i1 %7, i64 %6, i64 0
  %9 = shl i64 %4, %8
  %10 = select i1 %7, i64 %9, i64 0
  %11 = or i64 %v2, %10
  store i64 %11, ptr %v, align 8
  %i4 = load i32, ptr %i, align 4
  %12 = add i32 %i4, 1
  store i32 %12, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %v5 = load i64, ptr %v, align 8
  ret i64 %v5
}

define internal i32 @IpcReader.getInt(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i64 @IpcReader.getLong(ptr %0)
  %2 = trunc i64 %1 to i32
  ret i32 %2
}

define internal i32 @IpcReader.getBoolean(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i32 @IpcReader.getByte(ptr %0)
  %2 = icmp ne i32 %1, 0
  %3 = zext i1 %2 to i32
  ret i32 %3
}

define internal i32 @IpcReader.getChar(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i32 @IpcReader.getByte(ptr %0)
  ret i32 %1
}

define internal double @IpcReader.getDouble(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %1 = call i64 @IpcReader.getLong(ptr %0)
  %bits.l2d = bitcast i64 %1 to double
  ret double %bits.l2d
}

define internal ptr @IpcReader.getString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %s = alloca ptr, align 8
  %n = alloca i32, align 4
  %1 = call i32 @IpcReader.getInt(ptr %0)
  store i32 %1, ptr %n, align 4
  %buf = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  %buf1 = load ptr, ptr %buf, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %2 = sext i32 %pos2 to i64
  %pos3 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos4 = load i32, ptr %pos3, align 4, !tbaa !4
  %n5 = load i32, ptr %n, align 4
  %3 = add i32 %pos4, %n5
  %4 = sext i32 %3 to i64
  %5 = sub i64 %4, %2
  %6 = add i64 %5, 1
  %sub.buf = call ptr @__polaron_malloc(i64 %6)
  %str.data = getelementptr inbounds %String, ptr %buf1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %7 = getelementptr i8, ptr %data, i64 %2
  %8 = call ptr @memcpy(ptr %sub.buf, ptr %7, i64 %5)
  %9 = getelementptr i8, ptr %sub.buf, i64 %5
  store i8 0, ptr %9, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %10 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %5, ptr %10, align 8
  %11 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %sub.buf, ptr %11, align 8
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %12, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %s, align 8
  call void @__polaron_str_free(ptr %newstr)
  %pos6 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos7 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos8 = load i32, ptr %pos7, align 4, !tbaa !4
  %n9 = load i32, ptr %n, align 4
  %13 = add i32 %pos8, %n9
  store i32 %13, ptr %pos6, align 4, !tbaa !4
  %s10 = load ptr, ptr %s, align 8
  %strcpy11 = call ptr @__polaron_str_copy(ptr %s10)
  %14 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %14)
  ret ptr %strcpy11
}

define internal ptr @IpcRuntime.handle(ptr %0) {
entry:
  %frame = alloca ptr, align 8
  store ptr %0, ptr %frame, align 8
  %frame1 = load ptr, ptr %frame, align 8
  %1 = call ptr @IpcDispatch.handle(ptr %frame1)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal void @BundleAccessToken.BundleAccessToken(ptr %0, i64 %1, ptr %2) {
entry:
  %capability = alloca ptr, align 8
  %nonce = alloca i64, align 8
  store i64 %1, ptr %nonce, align 8
  store ptr %2, ptr %capability, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 0
  store ptr @BundleAccessToken.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %capabilityName = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 2
  store ptr null, ptr %capabilityName, align 8, !tbaa !0
  %nonceValue = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 1
  %nonce1 = load i64, ptr %nonce, align 8
  store i64 %nonce1, ptr %nonceValue, align 8, !tbaa !9
  %capabilityName2 = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 2
  %capability3 = load ptr, ptr %capability, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %capability3)
  %3 = load ptr, ptr %capabilityName2, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %capabilityName2, align 8, !tbaa !0
  ret void
}

define internal i64 @BundleAccessToken.nonce(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nonceValue = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 1
  %nonceValue1 = load i64, ptr %nonceValue, align 8, !tbaa !9
  ret i64 %nonceValue1
}

define internal ptr @BundleAccessToken.capability(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %capabilityName = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 2
  %capabilityName1 = load ptr, ptr %capabilityName, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %capabilityName1)
  ret ptr %strcpy
}

define internal i32 @BundleAccessToken.granted(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nonceValue = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 1
  %nonceValue1 = load i64, ptr %nonceValue, align 8, !tbaa !9
  %1 = icmp ne i64 %nonceValue1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @Program.serve(ptr %0, ptr %1) {
entry:
  %auth = alloca ptr, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  store ptr %1, ptr %auth, align 8
  %name1 = load ptr, ptr %name, align 8
  %auth2 = load ptr, ptr %auth, align 8
  call void @IpcServer.serve(ptr %name1, ptr %auth2)
  ret void
}

define internal void @IpcServer.serve(ptr %0, ptr %1) {
entry:
  %c = alloca i64, align 8
  %srv = alloca i64, align 8
  %auth = alloca ptr, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  store ptr %1, ptr %auth, align 8
  %"ArrayList$long.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$long", ptr null, i64 1) to i64))
  call void @"ArrayList$long.ArrayList$long"(ptr %"ArrayList$long.obj")
  store ptr %"ArrayList$long.obj", ptr @IpcServer.nonces, align 8
  %"ArrayList$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ArrayList$String", ptr null, i64 1) to i64))
  call void @"ArrayList$String.ArrayList$String"(ptr %"ArrayList$String.obj")
  store ptr %"ArrayList$String.obj", ptr @IpcServer.caps, align 8
  store i32 1, ptr @IpcServer.ready, align 4
  %name1 = load ptr, ptr %name, align 8
  %str.data = getelementptr inbounds %String, ptr %name1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %2 = call i64 @__polaron_ipc_listen(ptr %data)
  store i64 %2, ptr %srv, align 8
  %srv2 = load i64, ptr %srv, align 8
  %3 = icmp slt i64 %srv2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  br label %while.cond

while.cond:                                       ; preds = %if.end6, %if.end
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %srv3 = load i64, ptr %srv, align 8
  %5 = call i64 @__polaron_ipc_accept(i64 %srv3)
  store i64 %5, ptr %c, align 8
  %c4 = load i64, ptr %c, align 8
  %6 = icmp slt i64 %c4, 0
  %7 = zext i1 %6 to i32
  br i1 %6, label %if.then5, label %if.end6

while.end:                                        ; preds = %if.then5, %while.cond
  %srv10 = load i64, ptr %srv, align 8
  call void @__polaron_ipc_close(i64 %srv10)
  ret void

if.then5:                                         ; preds = %while.body
  br label %while.end

if.end6:                                          ; preds = %while.body
  %c7 = load i64, ptr %c, align 8
  %auth8 = load ptr, ptr %auth, align 8
  call void @IpcServer.session(i64 %c7, ptr %auth8)
  %c9 = load i64, ptr %c, align 8
  call void @__polaron_ipc_close(i64 %c9)
  br label %while.cond
}

define internal void @IpcServer.session(i64 %0, ptr %1) {
entry:
  %cap = alloca ptr, align 8
  %kind = alloca i32, align 4
  %peek = alloca ptr, align 8
  %msg = alloca ptr, align 8
  %ipc.len = alloca i64, align 8
  %auth = alloca ptr, align 8
  %conn = alloca i64, align 8
  store i64 %0, ptr %conn, align 8
  store ptr %1, ptr %auth, align 8
  br label %while.cond

while.cond:                                       ; preds = %if.end7, %entry
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %conn1 = load i64, ptr %conn, align 8
  %2 = call ptr @__polaron_ipc_recv(i64 %conn1, ptr %ipc.len)
  %ipc.n = load i64, ptr %ipc.len, align 8
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %ipc.n, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %2, ptr %4, align 8
  %5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %5, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %msg, align 8
  call void @__polaron_str_free(ptr %newstr)
  %msg2 = load ptr, ptr %msg, align 8
  %str.len = getelementptr inbounds %String, ptr %msg2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %6 = trunc i64 %len to i32
  %7 = icmp eq i32 %6, 0
  %8 = zext i1 %7 to i32
  br i1 %7, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  ret void

if.then:                                          ; preds = %while.body
  %9 = load ptr, ptr %msg, align 8
  call void @__polaron_str_free(ptr %9)
  ret void

if.end:                                           ; preds = %while.body
  %IpcReader.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcReader, ptr null, i64 1) to i64))
  %msg3 = load ptr, ptr %msg, align 8
  call void @IpcReader.IpcReader(ptr %IpcReader.obj, ptr %msg3)
  store ptr %IpcReader.obj, ptr %peek, align 8
  %peek4 = load ptr, ptr %peek, align 8
  %10 = call i32 @IpcReader.getByte(ptr %peek4)
  store i32 %10, ptr %kind, align 4
  %kind5 = load i32, ptr %kind, align 4
  %11 = call i32 @IpcProto.kCapability()
  %12 = icmp eq i32 %kind5, %11
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then6, label %if.else

if.then6:                                         ; preds = %if.end
  %peek8 = load ptr, ptr %peek, align 8
  %14 = call ptr @IpcReader.getString(ptr %peek8)
  %strcpy9 = call ptr @__polaron_str_copy(ptr %14)
  store ptr %strcpy9, ptr %cap, align 8
  call void @__polaron_str_free(ptr %14)
  %peek10 = load ptr, ptr %peek, align 8
  call void @__polaron_check_live(ptr %peek10)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %peek10, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %15 = icmp ne ptr %dtor.fn, null
  br i1 %15, label %dtor.call, label %dtor.free

if.else:                                          ; preds = %if.end
  %peek16 = load ptr, ptr %peek, align 8
  call void @__polaron_check_live(ptr %peek16)
  %vtbl.addr17 = getelementptr inbounds %class.IpcReader, ptr %peek16, i32 0, i32 0
  %vtbl18 = load ptr, ptr %vtbl.addr17, align 8, !tbaa !0
  %dtor.slot19 = getelementptr [353 x ptr], ptr %vtbl18, i64 0, i64 352
  %dtor.fn20 = load ptr, ptr %dtor.slot19, align 8
  %16 = icmp ne ptr %dtor.fn20, null
  br i1 %16, label %dtor.call21, label %dtor.free22

if.end7:                                          ; preds = %dtor.free22, %dtor.free
  %17 = load ptr, ptr %msg, align 8
  call void @__polaron_str_free(ptr %17)
  br label %while.cond

dtor.call:                                        ; preds = %if.then6
  call void %dtor.fn(ptr %peek10)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.then6
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %peek10, i32 0, i32 1
  %18 = load ptr, ptr %buf.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %18)
  call void @__polaron_free(ptr %peek10)
  %conn11 = load i64, ptr %conn, align 8
  %cap12 = load ptr, ptr %cap, align 8
  %auth13 = load ptr, ptr %auth, align 8
  %19 = call ptr @IpcServer.grant(ptr %cap12, ptr %auth13)
  %str.data = getelementptr inbounds %String, ptr %19, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len14 = getelementptr inbounds %String, ptr %19, i32 0, i32 0
  %len15 = load i64, ptr %str.len14, align 8
  %20 = call i64 @__polaron_ipc_send(i64 %conn11, ptr %data, i64 %len15)
  call void @__polaron_str_free(ptr %19)
  %21 = load ptr, ptr %cap, align 8
  call void @__polaron_str_free(ptr %21)
  br label %if.end7

dtor.call21:                                      ; preds = %if.else
  call void %dtor.fn20(ptr %peek16)
  br label %dtor.free22

dtor.free22:                                      ; preds = %dtor.call21, %if.else
  %buf.sfree23 = getelementptr inbounds %class.IpcReader, ptr %peek16, i32 0, i32 1
  %22 = load ptr, ptr %buf.sfree23, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %22)
  call void @__polaron_free(ptr %peek16)
  %conn24 = load i64, ptr %conn, align 8
  %msg25 = load ptr, ptr %msg, align 8
  %23 = call ptr @IpcRuntime.handle(ptr %msg25)
  %str.data26 = getelementptr inbounds %String, ptr %23, i32 0, i32 1
  %data27 = load ptr, ptr %str.data26, align 8
  %str.len28 = getelementptr inbounds %String, ptr %23, i32 0, i32 0
  %len29 = load i64, ptr %str.len28, align 8
  %24 = call i64 @__polaron_ipc_send(i64 %conn24, ptr %data27, i64 %len29)
  call void @__polaron_str_free(ptr %23)
  br label %if.end7
}

define internal ptr @IpcServer.grant(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  %w = alloca ptr, align 8
  %nonce = alloca i64, align 8
  %rng = alloca ptr, align 8
  %auth = alloca ptr, align 8
  %cap = alloca ptr, align 8
  store ptr %0, ptr %cap, align 8
  store ptr %1, ptr %auth, align 8
  %auth1 = load ptr, ptr %auth, align 8
  %code = load ptr, ptr %auth1, align 8
  %2 = getelementptr ptr, ptr %auth1, i32 1
  %env = load ptr, ptr %2, align 8
  %cap2 = load ptr, ptr %cap, align 8
  %3 = call i32 %code(ptr %env, ptr %cap2)
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %cap3 = load ptr, ptr %cap, align 8
  %len = load i64, ptr @.strobj.3992, align 8
  %str.len = getelementptr inbounds %String, ptr %cap3, i32 0, i32 0
  %len4 = load i64, ptr %str.len, align 8
  %6 = add i64 %len, %len4
  %7 = add i64 %6, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %7)
  %data = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.3992, i32 0, i32 1), align 8
  %8 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %str.data = getelementptr inbounds %String, ptr %cap3, i32 0, i32 1
  %data5 = load ptr, ptr %str.data, align 8
  %9 = getelementptr i8, ptr %cat.buf, i64 %len
  %10 = call ptr @memcpy(ptr %9, ptr %data5, i64 %len4)
  %11 = getelementptr i8, ptr %cat.buf, i64 %6
  store i8 0, ptr %11, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %12 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %6, ptr %12, align 8
  %13 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %13, align 8
  %14 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %14, align 8
  %15 = call ptr @IpcProto.errorFrame(ptr %newstr)
  %strcpy = call ptr @__polaron_str_copy(ptr %15)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %15)
  ret ptr %strcpy

if.end:                                           ; preds = %entry
  %SecureRandom.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.SecureRandom, ptr null, i64 1) to i64))
  call void @SecureRandom.SecureRandom(ptr %SecureRandom.obj)
  store ptr %SecureRandom.obj, ptr %rng, align 8
  %rng6 = load ptr, ptr %rng, align 8
  %16 = call i64 @SecureRandom.nextLong(ptr %rng6)
  store i64 %16, ptr %nonce, align 8
  %rng7 = load ptr, ptr %rng, align 8
  call void @__polaron_check_live(ptr %rng7)
  %vtbl.addr = getelementptr inbounds %class.SecureRandom, ptr %rng7, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %17 = icmp ne ptr %dtor.fn, null
  br i1 %17, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %if.end
  call void %dtor.fn(ptr %rng7)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.end
  call void @__polaron_free(ptr %rng7)
  %nonces = load ptr, ptr @IpcServer.nonces, align 8
  %nonce8 = load i64, ptr %nonce, align 8
  call void @"ArrayList$long.add"(ptr %nonces, i64 %nonce8)
  %caps = load ptr, ptr @IpcServer.caps, align 8
  %cap9 = load ptr, ptr %cap, align 8
  call void @"ArrayList$String.add"(ptr %caps, ptr %cap9)
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w10 = load ptr, ptr %w, align 8
  %18 = call i32 @IpcProto.kReplyOk()
  call void @IpcWriter.putByte(ptr %w10, i32 %18)
  %w11 = load ptr, ptr %w, align 8
  %nonce12 = load i64, ptr %nonce, align 8
  call void @IpcWriter.putLong(ptr %w11, i64 %nonce12)
  %w13 = load ptr, ptr %w, align 8
  %19 = call ptr @IpcWriter.toFrame(ptr %w13)
  %strcpy14 = call ptr @__polaron_str_copy(ptr %19)
  store ptr %strcpy14, ptr %f, align 8
  call void @__polaron_str_free(ptr %19)
  %w15 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w15)
  %vtbl.addr16 = getelementptr inbounds %class.IpcWriter, ptr %w15, i32 0, i32 0
  %vtbl17 = load ptr, ptr %vtbl.addr16, align 8, !tbaa !0
  %dtor.slot18 = getelementptr [353 x ptr], ptr %vtbl17, i64 0, i64 352
  %dtor.fn19 = load ptr, ptr %dtor.slot18, align 8
  %20 = icmp ne ptr %dtor.fn19, null
  br i1 %20, label %dtor.call20, label %dtor.free21

dtor.call20:                                      ; preds = %dtor.free
  call void %dtor.fn19(ptr %w15)
  br label %dtor.free21

dtor.free21:                                      ; preds = %dtor.call20, %dtor.free
  call void @__polaron_free(ptr %w15)
  %f22 = load ptr, ptr %f, align 8
  %strcpy23 = call ptr @__polaron_str_copy(ptr %f22)
  %21 = load ptr, ptr %f, align 8
  call void @__polaron_str_free(ptr %21)
  ret ptr %strcpy23
}

define internal i32 @IpcServer.validate(i64 %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %cap = alloca ptr, align 8
  %nonce = alloca i64, align 8
  store i64 %0, ptr %nonce, align 8
  store ptr %1, ptr %cap, align 8
  %ready = load i32, ptr @IpcServer.ready, align 4
  %2 = icmp eq i32 %ready, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret i32 0

if.end:                                           ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end10, %if.end
  %i1 = load i32, ptr %i, align 4
  %nonces = load ptr, ptr @IpcServer.nonces, align 8
  %4 = call i32 @"ArrayList$long.size"(ptr %nonces)
  %5 = icmp slt i32 %i1, %4
  %6 = zext i1 %5 to i32
  br i1 %5, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %nonces2 = load ptr, ptr @IpcServer.nonces, align 8
  %i3 = load i32, ptr %i, align 4
  %7 = call i64 @"ArrayList$long.get"(ptr %nonces2, i32 %i3)
  %nonce4 = load i64, ptr %nonce, align 8
  %8 = icmp eq i64 %7, %nonce4
  %9 = zext i1 %8 to i32
  %sc.a = icmp ne i32 %9, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.end:                                        ; preds = %while.cond
  ret i32 0

sc.rhs:                                           ; preds = %while.body
  %caps = load ptr, ptr @IpcServer.caps, align 8
  %i5 = load i32, ptr %i, align 4
  %10 = call ptr @"ArrayList$String.get"(ptr %caps, i32 %i5)
  %cap6 = load ptr, ptr %cap, align 8
  %str.data = getelementptr inbounds %String, ptr %10, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.data7 = getelementptr inbounds %String, ptr %cap6, i32 0, i32 1
  %data8 = load ptr, ptr %str.data7, align 8
  %11 = call i32 @strcmp(ptr %data, ptr %data8)
  %12 = icmp eq i32 %11, 0
  %13 = zext i1 %12 to i32
  %sc.b = icmp ne i32 %13, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.body
  %sc = phi i1 [ false, %while.body ], [ %sc.b, %sc.rhs ]
  %14 = zext i1 %sc to i32
  br i1 %sc, label %if.then9, label %if.end10

if.then9:                                         ; preds = %sc.end
  ret i32 1

if.end10:                                         ; preds = %sc.end
  %i11 = load i32, ptr %i, align 4
  %15 = add i32 %i11, 1
  store i32 %15, ptr %i, align 4
  br label %while.cond
}

declare i64 @__polaron_secure_random()

define internal void @SecureRandom.SecureRandom(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.SecureRandom, ptr %0, i32 0, i32 0
  store ptr @SecureRandom.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  ret void
}

define internal i64 @SecureRandom.nextLong(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call i64 @__polaron_secure_random()
  ret i64 %1
}

define internal i32 @SecureRandom.nextInt(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call i64 @SecureRandom.nextLong(ptr %0)
  %2 = ashr i64 %1, 63
  %3 = ashr i64 %1, 33
  %4 = and i64 %3, 2147483647
  %5 = trunc i64 %4 to i32
  ret i32 %5
}

define internal i32 @SecureRandom.nextIntMax(ptr nonnull align 8 dereferenceable(8) %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %max = alloca i32, align 4
  store i32 %1, ptr %max, align 4
  %2 = call i32 @SecureRandom.nextInt(ptr %0)
  %max1 = load i32, ptr %max, align 4
  %3 = icmp eq i32 %max1, 0
  %4 = icmp eq i32 %2, -2147483648
  %5 = icmp eq i32 %max1, -1
  %6 = and i1 %4, %5
  %7 = or i1 %3, %6
  br i1 %7, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %8 = srem i32 %2, %max1
  ret i32 %8
}

define internal i32 @SecureRandom.nextBool(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %1 = call i64 @SecureRandom.nextLong(ptr %0)
  %2 = and i64 %1, 1
  %3 = icmp eq i64 %2, 1
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal double @SecureRandom.nextDouble(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %bits = alloca i64, align 8
  %1 = call i64 @SecureRandom.nextLong(ptr %0)
  %2 = and i64 %1, 4503599627370495
  store i64 %2, ptr %bits, align 8
  %bits1 = load i64, ptr %bits, align 8
  %3 = sitofp i64 %bits1 to double
  %4 = fdiv double %3, 0x4330000000000000
  ret double %4
}

define internal ptr @SecureRandom.nextBytes(ptr nonnull align 8 dereferenceable(8) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %out = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  %n1 = load i32, ptr %n, align 4
  %2 = sext i32 %n1 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %out, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i2 = load i32, ptr %i, align 4
  %n3 = load i32, ptr %n, align 4
  %6 = icmp slt i32 %i2, %n3
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %out4 = load ptr, ptr %out, align 8, !nonnull !6, !dereferenceable !7
  %i5 = load i32, ptr %i, align 4
  %8 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %out4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out7 = load ptr, ptr %out, align 8
  ret ptr %out7

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4031, ptr @.faila.4032, i64 %8, ptr @.failb.4033, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data6 = getelementptr i8, ptr %out4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 %8
  %11 = call i64 @SecureRandom.nextLong(ptr %0)
  %12 = and i64 %11, 255
  %13 = trunc i64 %12 to i32
  store i32 %13, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5389)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5391)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal i32 @__polaron_lambda_0(ptr %0, ptr %1) {
entry:
  %capability = alloca ptr, align 8
  store ptr %1, ptr %capability, align 8
  %capability1 = load ptr, ptr %capability, align 8
  %str.data = getelementptr inbounds %String, ptr %capability1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data2 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %2 = call i32 @strcmp(ptr %data, ptr %data2)
  %3 = icmp eq i32 %2, 0
  %4 = zext i1 %3 to i32
  ret i32 %4
}

declare i32 @strcmp(ptr, ptr)

declare void @__polaron_str_free(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare i64 @__polaron_ipc_send(i64, ptr, i64)

declare ptr @__polaron_ipc_recv(i64, ptr)

declare void @__polaron_ipc_close(i64)

declare i64 @__polaron_ipc_listen(ptr)

declare i64 @__polaron_ipc_accept(i64)

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
!9 = !{!10, !10, i64 0}
!10 = !{!"i64", !2, i64 0}
