; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Main = type { ptr }
%"class.HashSet$long" = type { ptr, ptr, ptr, i32, i32 }
%class.IpcReader = type { ptr, ptr, i32 }
%class.IpcWriter = type { ptr, ptr }
%"class.RemoteType$StereoMixer" = type { ptr, i64 }
%class.StereoMixer = type { ptr, i64, i64 }
%class.IpcChannel = type { ptr, i64 }
%class.BundleAccessToken = type { ptr, i64, ptr }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.Subprocess = type { ptr, i64 }
%class.IpcError = type { ptr, ptr }
%class.ProgramHandle = type { ptr, i64 }

@IpcDispatch.live = private global ptr null
@IpcDispatch.ready = private global i32 0
@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Main.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"RemoteType$StereoMixer.vtable" = private constant [358 x ptr] [ptr @"RemoteType$StereoMixer.instantiate", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"HashSet$long.vtable" = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$long.toArray", ptr @"HashSet$long.size", ptr @"HashSet$long.isEmpty", ptr @"HashSet$long.slotFor", ptr @"HashSet$long.grow", ptr @"HashSet$long.add", ptr @"HashSet$long.contains", ptr @"HashSet$long.remove", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"HashSet$long.~HashSet$long"]
@Object.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StereoMixer.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StereoMixer.__ipcId, ptr @StereoMixer.__ipcConn, ptr @StereoMixer.release, ptr @StereoMixer.play, ptr @StereoMixer.setVolume, ptr @StereoMixer.volume, ptr @StereoMixer.mixdown, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IpcReader.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcReader.getString, ptr @IpcReader.getInt, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcReader.atEnd, ptr @IpcReader.getByte, ptr @IpcReader.getLong, ptr @IpcReader.getBoolean, ptr @IpcReader.getChar, ptr @IpcReader.getDouble, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@ProgramHandle.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @ProgramHandle.close, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @ProgramHandle.connection, ptr null, ptr null, ptr null, ptr null, ptr @ProgramHandle.bundle, ptr @ProgramHandle.namespace, ptr @ProgramHandle.requestAccess, ptr @"ProgramHandle.type$StereoMixer", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Subprocess.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Subprocess.isValid, ptr @Subprocess.write, ptr @Subprocess.read, ptr @Subprocess.isAlive, ptr @Subprocess.canRead, ptr @Subprocess.closeInput, ptr @Subprocess.close, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IpcChannel.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcChannel.close, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcChannel.connection, ptr @IpcChannel.request, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IpcError.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @IpcError.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IpcWriter.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IpcWriter.putByte, ptr @IpcWriter.putLong, ptr @IpcWriter.putInt, ptr @IpcWriter.putBoolean, ptr @IpcWriter.putChar, ptr @IpcWriter.putDouble, ptr @IpcWriter.putString, ptr @IpcWriter.toFrame, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"IpcWriter.~IpcWriter"]
@BundleAccessToken.vtable = private constant [358 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @BundleAccessToken.nonce, ptr @BundleAccessToken.capability, ptr @BundleAccessToken.granted, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.1 = private unnamed_addr constant [50 x i8] c"usage: ipc_client <path-to-the-engine-executable>\00", align 1
@.fail = private unnamed_addr constant [129 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol:34:17  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [11 x i8] c"GameEngine\00"
@.strobj = private global %String { i64 10, ptr @.strdata, i64 0 }
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.3 = private unnamed_addr constant [34 x i8] c"client: the engine is not running\00", align 1
@.panic = private unnamed_addr constant [130 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol:43:17  in main\0A\00", align 1
@.strdata.4 = private constant [6 x i8] c"audio\00"
@.strobj.5 = private global %String { i64 5, ptr @.strdata.4, i64 0 }
@.strdata.6 = private constant [7 x i8] c"mixers\00"
@.strobj.7 = private global %String { i64 6, ptr @.strdata.6, i64 0 }
@.strdata.8 = private constant [9 x i8] c"boom.wav\00"
@.strobj.9 = private global %String { i64 8, ptr @.strdata.8, i64 0 }
@.strdata.10 = private constant [10 x i8] c"laser.wav\00"
@.strobj.11 = private global %String { i64 9, ptr @.strdata.10, i64 0 }
@.str.12 = private unnamed_addr constant [21 x i8] c"client: plays=%d,%d\0A\00", align 1
@.str.13 = private unnamed_addr constant [19 x i8] c"client: volume=%d\0A\00", align 1
@.panic.14 = private unnamed_addr constant [130 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol:56:21  in main\0A\00", align 1
@.strdata.15 = private constant [5 x i8] c"root\00"
@.strobj.16 = private global %String { i64 4, ptr @.strdata.15, i64 0 }
@.str.17 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.18 = private unnamed_addr constant [23 x i8] c"client: 'root' refused\00", align 1
@.panic.19 = private unnamed_addr constant [130 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol:62:21  in main\0A\00", align 1
@.strdata.20 = private constant [8 x i8] c"mixdown\00"
@.strobj.21 = private global %String { i64 7, ptr @.strdata.20, i64 0 }
@.str.22 = private unnamed_addr constant [20 x i8] c"client: mixdown=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.str.23 = private unnamed_addr constant [24 x i8] c"client: ipc failed: %s\0A\00", align 1
@.panic.24 = private unnamed_addr constant [130 x i8] c"Polaron panic: null reference dereference\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ipc_client.pol:70:24  in main\0A\00", align 1
@.strdata.25 = private constant [5 x i8] c"Main\00"
@.strobj.26 = private global %String { i64 4, ptr @.strdata.25, i64 0 }
@.strdata.27 = private constant [15 x i8] c"no such type: \00"
@.strobj.28 = private global %String { i64 14, ptr @.strdata.27, i64 0 }
@.strdata.29 = private constant [15 x i8] c"unknown object\00"
@.strobj.30 = private global %String { i64 14, ptr @.strdata.29, i64 0 }
@.strdata.31 = private constant [15 x i8] c"unknown object\00"
@.strobj.32 = private global %String { i64 14, ptr @.strdata.31, i64 0 }
@.strdata.33 = private constant [15 x i8] c"no such method\00"
@.strobj.34 = private global %String { i64 14, ptr @.strdata.33, i64 0 }
@.strdata.35 = private constant [10 x i8] c"bad frame\00"
@.strobj.36 = private global %String { i64 9, ptr @.strdata.35, i64 0 }
@.fail.79 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1133:17  in HashSet$long.slotFor\0A\00", align 1
@.faila.80 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.81 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.82 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1134:21  in HashSet$long.slotFor\0A\00", align 1
@.faila.83 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.84 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.85 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1148:21  in HashSet$long.grow\0A\00", align 1
@.faila.86 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.87 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.88 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1148:49  in HashSet$long.grow\0A\00", align 1
@.faila.89 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.90 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.91 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1156:17  in HashSet$long.add\0A\00", align 1
@.faila.92 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.93 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.94 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1157:34  in HashSet$long.add\0A\00", align 1
@.faila.95 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.96 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.97 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1158:35  in HashSet$long.add\0A\00", align 1
@.faila.98 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.99 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.100 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1163:17  in HashSet$long.contains\0A\00", align 1
@.faila.101 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.102 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.103 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1167:17  in HashSet$long.remove\0A\00", align 1
@.faila.104 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.105 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.106 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1169:30  in HashSet$long.remove\0A\00", align 1
@.faila.107 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.108 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.109 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1172:17  in HashSet$long.remove\0A\00", align 1
@.faila.110 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.111 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.112 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1173:21  in HashSet$long.remove\0A\00", align 1
@.faila.113 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.114 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.115 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1174:34  in HashSet$long.remove\0A\00", align 1
@.faila.116 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.117 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.118 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:21  in HashSet$long.toArray\0A\00", align 1
@.faila.119 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.120 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.121 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:53  in HashSet$long.toArray\0A\00", align 1
@.faila.122 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.123 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.124 = private unnamed_addr constant [91 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:1185:53  in HashSet$long.toArray\0A\00", align 1
@.faila.125 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.126 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.1383 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.1384 = private global %String { i64 11, ptr @.strdata.1383, i64 0 }
@.strdata.1385 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.1386 = private global %String { i64 11, ptr @.strdata.1385, i64 0 }
@.strdata.1387 = private constant [5 x i8] c"play\00"
@.strobj.1388 = private global %String { i64 4, ptr @.strdata.1387, i64 0 }
@.strdata.1389 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.1390 = private global %String { i64 11, ptr @.strdata.1389, i64 0 }
@.strdata.1391 = private constant [10 x i8] c"setVolume\00"
@.strobj.1392 = private global %String { i64 9, ptr @.strdata.1391, i64 0 }
@.strdata.1393 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.1394 = private global %String { i64 11, ptr @.strdata.1393, i64 0 }
@.strdata.1395 = private constant [7 x i8] c"volume\00"
@.strobj.1396 = private global %String { i64 6, ptr @.strdata.1395, i64 0 }
@.strdata.1397 = private constant [12 x i8] c"StereoMixer\00"
@.strobj.1398 = private global %String { i64 11, ptr @.strdata.1397, i64 0 }
@.strdata.1399 = private constant [8 x i8] c"mixdown\00"
@.strobj.1400 = private global %String { i64 7, ptr @.strdata.1399, i64 0 }
@.strdata.1411 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1412 = private global %String { i64 16, ptr @.strdata.1411, i64 0 }
@.strdata.1413 = private constant [17 x i8] c"division by zero\00"
@.strobj.1414 = private global %String { i64 16, ptr @.strdata.1413, i64 0 }
@.strdata.4012 = private constant [31 x i8] c"the peer closed the connection\00"
@.strobj.4013 = private global %String { i64 30, ptr @.strdata.4012, i64 0 }
@.strdata.5411 = private constant [1 x i8] zeroinitializer
@.strobj.5412 = private global %String { i64 0, ptr @.strdata.5411, i64 0 }
@.strdata.5413 = private constant [1 x i8] zeroinitializer
@.strobj.5414 = private global %String { i64 0, ptr @.strdata.5413, i64 0 }

define i32 @main(i32 %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %e = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %mixdown = alloca ptr, align 8
  %denied = alloca ptr, align 8
  %second = alloca i32, align 4
  %first = alloca i32, align 4
  %mixer = alloca ptr, align 8
  %a = alloca ptr, align 8
  %engine = alloca ptr, align 8
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
  %args1 = load ptr, ptr %args, align 8
  %len = load i64, ptr %args1, align 8
  %16 = trunc i64 %len to i32
  %17 = icmp slt i32 %16, 1
  %18 = zext i1 %17 to i32
  br i1 %17, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  %19 = call i32 (ptr, ...) @printf(ptr @.str, ptr @.str.1)
  ret i32 0

if.end:                                           ; preds = %argv.end
  %args2 = load ptr, ptr %args, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %args2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data3 = getelementptr i8, ptr %args2, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data3, i64 0
  %elem = load ptr, ptr %arr.elem, align 8
  %20 = call ptr @Subprocess.start(ptr %elem)
  store ptr %20, ptr %engine, align 8
  call void @__polaron_sleep(i64 400)
  %21 = call ptr @Program.connect(ptr @.strobj)
  store ptr %21, ptr %a, align 8
  %a4 = load ptr, ptr %a, align 8
  %22 = icmp eq ptr %a4, null
  %23 = zext i1 %22 to i32
  br i1 %22, label %if.then5, label %if.end6

if.then5:                                         ; preds = %idx.ok
  %24 = call i32 (ptr, ...) @printf(ptr @.str.2, ptr @.str.3)
  ret i32 0

if.end6:                                          ; preds = %idx.ok
  %a7 = load ptr, ptr %a, align 8
  %25 = icmp eq ptr %a7, null
  br i1 %25, label %nullrecv, label %nullrecv.ok

nullrecv:                                         ; preds = %if.end6
  call void @__polaron_panic(ptr @.panic)
  unreachable

nullrecv.ok:                                      ; preds = %if.end6
  %26 = call ptr @ProgramHandle.bundle(ptr %a7, ptr @.strobj.5)
  %27 = call ptr @ProgramHandle.namespace(ptr %26, ptr @.strobj.7)
  %28 = call ptr @"ProgramHandle.type$StereoMixer"(ptr %27)
  %29 = call ptr @"RemoteType$StereoMixer.instantiate"(ptr %28)
  store ptr %29, ptr %mixer, align 8
  %mixer8 = load ptr, ptr %mixer, align 8
  %30 = invoke i32 @StereoMixer.play(ptr %mixer8, ptr @.strobj.9)
          to label %invoke.cont unwind label %ehpad

ehpad:                                            ; preds = %if.then31, %invoke.cont28, %nullrecv.ok27, %invoke.cont20, %nullrecv.ok19, %invoke.cont14, %invoke.cont10, %invoke.cont, %nullrecv.ok
  %31 = catchswitch within none [label %catch.dispatch] unwind to caller

try.cont:                                         ; preds = %catch.body, %if.end32
  %a37 = load ptr, ptr %a, align 8
  %32 = icmp eq ptr %a37, null
  br i1 %32, label %nullrecv38, label %nullrecv.ok39

invoke.cont:                                      ; preds = %nullrecv.ok
  store i32 %30, ptr %first, align 4
  %mixer9 = load ptr, ptr %mixer, align 8
  %33 = invoke i32 @StereoMixer.play(ptr %mixer9, ptr @.strobj.11)
          to label %invoke.cont10 unwind label %ehpad

invoke.cont10:                                    ; preds = %invoke.cont
  store i32 %33, ptr %second, align 4
  %first11 = load i32, ptr %first, align 4
  %second12 = load i32, ptr %second, align 4
  %34 = call i32 (ptr, ...) @printf(ptr @.str.12, i32 %first11, i32 %second12)
  %mixer13 = load ptr, ptr %mixer, align 8
  invoke void @StereoMixer.setVolume(ptr %mixer13, i32 9)
          to label %invoke.cont14 unwind label %ehpad

invoke.cont14:                                    ; preds = %invoke.cont10
  %mixer15 = load ptr, ptr %mixer, align 8
  %35 = invoke i32 @StereoMixer.volume(ptr %mixer15)
          to label %invoke.cont16 unwind label %ehpad

invoke.cont16:                                    ; preds = %invoke.cont14
  %36 = call i32 (ptr, ...) @printf(ptr @.str.13, i32 %35)
  %a17 = load ptr, ptr %a, align 8
  %37 = icmp eq ptr %a17, null
  br i1 %37, label %nullrecv18, label %nullrecv.ok19

nullrecv18:                                       ; preds = %invoke.cont16
  call void @__polaron_panic(ptr @.panic.14)
  unreachable

nullrecv.ok19:                                    ; preds = %invoke.cont16
  %38 = invoke ptr @ProgramHandle.requestAccess(ptr %a17, ptr @.strobj.16)
          to label %invoke.cont20 unwind label %ehpad

invoke.cont20:                                    ; preds = %nullrecv.ok19
  store ptr %38, ptr %denied, align 8
  %denied21 = load ptr, ptr %denied, align 8
  %39 = invoke i32 @BundleAccessToken.granted(ptr %denied21)
          to label %invoke.cont22 unwind label %ehpad

invoke.cont22:                                    ; preds = %invoke.cont20
  %40 = icmp eq i32 %39, 0
  %41 = zext i1 %40 to i32
  br i1 %40, label %if.then23, label %if.end24

if.then23:                                        ; preds = %invoke.cont22
  %42 = call i32 (ptr, ...) @printf(ptr @.str.17, ptr @.str.18)
  br label %if.end24

if.end24:                                         ; preds = %if.then23, %invoke.cont22
  %a25 = load ptr, ptr %a, align 8
  %43 = icmp eq ptr %a25, null
  br i1 %43, label %nullrecv26, label %nullrecv.ok27

nullrecv26:                                       ; preds = %if.end24
  call void @__polaron_panic(ptr @.panic.19)
  unreachable

nullrecv.ok27:                                    ; preds = %if.end24
  %44 = invoke ptr @ProgramHandle.requestAccess(ptr %a25, ptr @.strobj.21)
          to label %invoke.cont28 unwind label %ehpad

invoke.cont28:                                    ; preds = %nullrecv.ok27
  store ptr %44, ptr %mixdown, align 8
  %mixdown29 = load ptr, ptr %mixdown, align 8
  %45 = invoke i32 @BundleAccessToken.granted(ptr %mixdown29)
          to label %invoke.cont30 unwind label %ehpad

invoke.cont30:                                    ; preds = %invoke.cont28
  %46 = icmp ne i32 %45, 0
  br i1 %46, label %if.then31, label %if.end32

if.then31:                                        ; preds = %invoke.cont30
  %mixer33 = load ptr, ptr %mixer, align 8
  %mixdown34 = load ptr, ptr %mixdown, align 8
  %47 = invoke i32 @StereoMixer.mixdown(ptr %mixer33, ptr %mixdown34)
          to label %invoke.cont35 unwind label %ehpad

if.end32:                                         ; preds = %invoke.cont35, %invoke.cont30
  br label %try.cont

invoke.cont35:                                    ; preds = %if.then31
  %48 = call i32 (ptr, ...) @printf(ptr @.str.22, i32 %47)
  br label %if.end32

catch.dispatch:                                   ; preds = %ehpad
  %49 = catchpad within %31 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  %is = icmp eq ptr %exc.vtbl, @IpcError.vtable
  br i1 %is, label %catch.match, label %catch.next

catch.match:                                      ; preds = %catch.dispatch
  store ptr %caught, ptr %e, align 8
  catchret from %49 to label %catch.body

catch.next:                                       ; preds = %catch.dispatch
  catchret from %49 to label %rethrow

catch.body:                                       ; preds = %catch.match
  %e36 = load ptr, ptr %e, align 8
  %50 = call ptr @IpcError.message(ptr %e36)
  %str.data = getelementptr inbounds %String, ptr %50, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %51 = call i32 (ptr, ...) @printf(ptr @.str.23, ptr %data)
  call void @__polaron_str_free(ptr %50)
  br label %try.cont

rethrow:                                          ; preds = %catch.next
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  store ptr %rethrow.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

nullrecv38:                                       ; preds = %try.cont
  call void @__polaron_panic(ptr @.panic.24)
  unreachable

nullrecv.ok39:                                    ; preds = %try.cont
  call void @ProgramHandle.close(ptr %a37)
  %engine40 = load ptr, ptr %engine, align 8
  call void @Subprocess.close(ptr %engine40)
  ret i32 0
}

define internal void @Main.Main(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Main, ptr %0, i32 0, i32 0
  store ptr @Main.vtable, ptr %vtbl.addr, align 8, !tbaa !3
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
  %meth = alloca ptr, align 8
  %type54 = alloca ptr, align 8
  %id51 = alloca i64, align 8
  %id = alloca i64, align 8
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
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %6 = icmp ne ptr %dtor.fn, null
  br i1 %6, label %dtor.call, label %dtor.free

if.end:                                           ; preds = %entry
  %kind30 = load i32, ptr %kind, align 4
  %7 = call i32 @IpcProto.kRelease()
  %8 = icmp eq i32 %kind30, %7
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then31, label %if.end32

dtor.call:                                        ; preds = %if.then
  call void %dtor.fn(ptr %r5)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.then
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r5, i32 0, i32 1
  %10 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %10)
  call void @__polaron_free(ptr %r5)
  %type6 = load ptr, ptr %type, align 8
  %str.data = getelementptr inbounds %String, ptr %type6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %data7 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.26, i32 0, i32 1), align 8
  %11 = call i32 @strcmp(ptr %data, ptr %data7)
  %12 = icmp eq i32 %11, 0
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then8, label %if.end9

if.then8:                                         ; preds = %dtor.free
  %Main.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Main, ptr null, i64 1) to i64))
  call void @Main.Main(ptr %Main.obj)
  store ptr %Main.obj, ptr %o, align 8
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
  %vtbl17 = load ptr, ptr %vtbl.addr16, align 8, !tbaa !3
  %dtor.slot18 = getelementptr [358 x ptr], ptr %vtbl17, i64 0, i64 357
  %dtor.fn19 = load ptr, ptr %dtor.slot18, align 8
  %18 = icmp ne ptr %dtor.fn19, null
  br i1 %18, label %dtor.call20, label %dtor.free21

if.end9:                                          ; preds = %dtor.free
  %type24 = load ptr, ptr %type, align 8
  %len = load i64, ptr @.strobj.28, align 8
  %str.len = getelementptr inbounds %String, ptr %type24, i32 0, i32 0
  %len25 = load i64, ptr %str.len, align 8
  %19 = add i64 %len, %len25
  %20 = add i64 %19, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %20)
  %data26 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.28, i32 0, i32 1), align 8
  %21 = call ptr @memcpy(ptr %cat.buf, ptr %data26, i64 %len)
  %str.data27 = getelementptr inbounds %String, ptr %type24, i32 0, i32 1
  %data28 = load ptr, ptr %str.data27, align 8
  %22 = getelementptr i8, ptr %cat.buf, i64 %len
  %23 = call ptr @memcpy(ptr %22, ptr %data28, i64 %len25)
  %24 = getelementptr i8, ptr %cat.buf, i64 %19
  store i8 0, ptr %24, align 1
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %25 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %19, ptr %25, align 8
  %26 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %cat.buf, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %27, align 8
  %28 = call ptr @IpcProto.errorFrame(ptr %newstr)
  %strcpy29 = call ptr @__polaron_str_copy(ptr %28)
  call void @__polaron_str_free(ptr %newstr)
  call void @__polaron_str_free(ptr %28)
  %29 = load ptr, ptr %type, align 8
  call void @__polaron_str_free(ptr %29)
  ret ptr %strcpy29

dtor.call20:                                      ; preds = %if.then8
  call void %dtor.fn19(ptr %w15)
  br label %dtor.free21

dtor.free21:                                      ; preds = %dtor.call20, %if.then8
  call void @__polaron_free(ptr %w15)
  %f22 = load ptr, ptr %f, align 8
  %strcpy23 = call ptr @__polaron_str_copy(ptr %f22)
  %30 = load ptr, ptr %f, align 8
  call void @__polaron_str_free(ptr %30)
  %31 = load ptr, ptr %type, align 8
  call void @__polaron_str_free(ptr %31)
  ret ptr %strcpy23

if.then31:                                        ; preds = %if.end
  %r33 = load ptr, ptr %r, align 8
  %32 = call i64 @IpcReader.getLong(ptr %r33)
  store i64 %32, ptr %id, align 8
  %r34 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r34)
  %vtbl.addr35 = getelementptr inbounds %class.IpcReader, ptr %r34, i32 0, i32 0
  %vtbl36 = load ptr, ptr %vtbl.addr35, align 8, !tbaa !3
  %dtor.slot37 = getelementptr [358 x ptr], ptr %vtbl36, i64 0, i64 357
  %dtor.fn38 = load ptr, ptr %dtor.slot37, align 8
  %33 = icmp ne ptr %dtor.fn38, null
  br i1 %33, label %dtor.call39, label %dtor.free40

if.end32:                                         ; preds = %if.end
  %kind47 = load i32, ptr %kind, align 4
  %34 = call i32 @IpcProto.kCall()
  %35 = icmp eq i32 %kind47, %34
  %36 = zext i1 %35 to i32
  br i1 %35, label %if.then48, label %if.end49

dtor.call39:                                      ; preds = %if.then31
  call void %dtor.fn38(ptr %r34)
  br label %dtor.free40

dtor.free40:                                      ; preds = %dtor.call39, %if.then31
  %buf.sfree41 = getelementptr inbounds %class.IpcReader, ptr %r34, i32 0, i32 1
  %37 = load ptr, ptr %buf.sfree41, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %37)
  call void @__polaron_free(ptr %r34)
  %id42 = load i64, ptr %id, align 8
  %38 = call i32 @IpcDispatch.revoke(i64 %id42)
  %39 = icmp eq i32 %38, 0
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then43, label %if.end44

if.then43:                                        ; preds = %dtor.free40
  %41 = call ptr @IpcProto.errorFrame(ptr @.strobj.30)
  %strcpy45 = call ptr @__polaron_str_copy(ptr %41)
  call void @__polaron_str_free(ptr %41)
  ret ptr %strcpy45

if.end44:                                         ; preds = %dtor.free40
  %42 = call ptr @IpcProto.okFrame()
  %strcpy46 = call ptr @__polaron_str_copy(ptr %42)
  call void @__polaron_str_free(ptr %42)
  ret ptr %strcpy46

if.then48:                                        ; preds = %if.end32
  %r50 = load ptr, ptr %r, align 8
  %43 = call i64 @IpcReader.getLong(ptr %r50)
  store i64 %43, ptr %id51, align 8
  %r52 = load ptr, ptr %r, align 8
  %44 = call ptr @IpcReader.getString(ptr %r52)
  %strcpy53 = call ptr @__polaron_str_copy(ptr %44)
  store ptr %strcpy53, ptr %type54, align 8
  call void @__polaron_str_free(ptr %44)
  %r55 = load ptr, ptr %r, align 8
  %45 = call ptr @IpcReader.getString(ptr %r55)
  %strcpy56 = call ptr @__polaron_str_copy(ptr %45)
  store ptr %strcpy56, ptr %meth, align 8
  call void @__polaron_str_free(ptr %45)
  %id57 = load i64, ptr %id51, align 8
  %46 = call i32 @IpcDispatch.known(i64 %id57)
  %47 = icmp eq i32 %46, 0
  %48 = zext i1 %47 to i32
  br i1 %47, label %if.then58, label %if.end59

if.end49:                                         ; preds = %if.end32
  %r78 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r78)
  %vtbl.addr79 = getelementptr inbounds %class.IpcReader, ptr %r78, i32 0, i32 0
  %vtbl80 = load ptr, ptr %vtbl.addr79, align 8, !tbaa !3
  %dtor.slot81 = getelementptr [358 x ptr], ptr %vtbl80, i64 0, i64 357
  %dtor.fn82 = load ptr, ptr %dtor.slot81, align 8
  %49 = icmp ne ptr %dtor.fn82, null
  br i1 %49, label %dtor.call83, label %dtor.free84

if.then58:                                        ; preds = %if.then48
  %r60 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r60)
  %vtbl.addr61 = getelementptr inbounds %class.IpcReader, ptr %r60, i32 0, i32 0
  %vtbl62 = load ptr, ptr %vtbl.addr61, align 8, !tbaa !3
  %dtor.slot63 = getelementptr [358 x ptr], ptr %vtbl62, i64 0, i64 357
  %dtor.fn64 = load ptr, ptr %dtor.slot63, align 8
  %50 = icmp ne ptr %dtor.fn64, null
  br i1 %50, label %dtor.call65, label %dtor.free66

if.end59:                                         ; preds = %if.then48
  %r69 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r69)
  %vtbl.addr70 = getelementptr inbounds %class.IpcReader, ptr %r69, i32 0, i32 0
  %vtbl71 = load ptr, ptr %vtbl.addr70, align 8, !tbaa !3
  %dtor.slot72 = getelementptr [358 x ptr], ptr %vtbl71, i64 0, i64 357
  %dtor.fn73 = load ptr, ptr %dtor.slot72, align 8
  %51 = icmp ne ptr %dtor.fn73, null
  br i1 %51, label %dtor.call74, label %dtor.free75

dtor.call65:                                      ; preds = %if.then58
  call void %dtor.fn64(ptr %r60)
  br label %dtor.free66

dtor.free66:                                      ; preds = %dtor.call65, %if.then58
  %buf.sfree67 = getelementptr inbounds %class.IpcReader, ptr %r60, i32 0, i32 1
  %52 = load ptr, ptr %buf.sfree67, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %52)
  call void @__polaron_free(ptr %r60)
  %53 = call ptr @IpcProto.errorFrame(ptr @.strobj.32)
  %strcpy68 = call ptr @__polaron_str_copy(ptr %53)
  call void @__polaron_str_free(ptr %53)
  %54 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %54)
  %55 = load ptr, ptr %type54, align 8
  call void @__polaron_str_free(ptr %55)
  ret ptr %strcpy68

dtor.call74:                                      ; preds = %if.end59
  call void %dtor.fn73(ptr %r69)
  br label %dtor.free75

dtor.free75:                                      ; preds = %dtor.call74, %if.end59
  %buf.sfree76 = getelementptr inbounds %class.IpcReader, ptr %r69, i32 0, i32 1
  %56 = load ptr, ptr %buf.sfree76, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %56)
  call void @__polaron_free(ptr %r69)
  %57 = call ptr @IpcProto.errorFrame(ptr @.strobj.34)
  %strcpy77 = call ptr @__polaron_str_copy(ptr %57)
  call void @__polaron_str_free(ptr %57)
  %58 = load ptr, ptr %meth, align 8
  call void @__polaron_str_free(ptr %58)
  %59 = load ptr, ptr %type54, align 8
  call void @__polaron_str_free(ptr %59)
  ret ptr %strcpy77

dtor.call83:                                      ; preds = %if.end49
  call void %dtor.fn82(ptr %r78)
  br label %dtor.free84

dtor.free84:                                      ; preds = %dtor.call83, %if.end49
  %buf.sfree85 = getelementptr inbounds %class.IpcReader, ptr %r78, i32 0, i32 1
  %60 = load ptr, ptr %buf.sfree85, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %60)
  call void @__polaron_free(ptr %r78)
  %61 = call ptr @IpcProto.errorFrame(ptr @.strobj.36)
  %strcpy86 = call ptr @__polaron_str_copy(ptr %61)
  call void @__polaron_str_free(ptr %61)
  ret ptr %strcpy86
}

define internal void @"RemoteType$StereoMixer.RemoteType$StereoMixer"(ptr %0, i64 %1) {
entry:
  %conn = alloca i64, align 8
  store i64 %1, ptr %conn, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.RemoteType$StereoMixer", ptr %0, i32 0, i32 0
  store ptr @"RemoteType$StereoMixer.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %conn1 = getelementptr inbounds %"class.RemoteType$StereoMixer", ptr %0, i32 0, i32 1
  %conn2 = load i64, ptr %conn, align 8
  store i64 %conn2, ptr %conn1, align 8, !tbaa !7
  ret void
}

define internal ptr @"RemoteType$StereoMixer.instantiate"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %StereoMixer.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StereoMixer, ptr null, i64 1) to i64))
  %conn = getelementptr inbounds %"class.RemoteType$StereoMixer", ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  call void @StereoMixer.StereoMixer(ptr %StereoMixer.obj, i64 %conn1, i64 0)
  ret ptr %StereoMixer.obj
}

define internal void @"HashSet$long.HashSet$long"(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 0
  store ptr @"HashSet$long.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  store ptr null, ptr %elems, align 8, !tbaa !3
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  store ptr null, ptr %used, align 8, !tbaa !3
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  store i32 8, ptr %cap, align 4, !tbaa !9
  %elems1 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %elems1, align 8, !tbaa !3
  %used2 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 16)
  store i64 8, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 8)
  store ptr %arr3, ptr %used2, align 8, !tbaa !3
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !9
  ret void
}

define internal void @"HashSet$long.~HashSet$long"(ptr %0) {
entry:
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems1 = load ptr, ptr %elems, align 8, !tbaa !3
  call void @__polaron_free(ptr %elems1)
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used2 = load ptr, ptr %used, align 8, !tbaa !3
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
  %cap1 = load i32, ptr %cap, align 4, !tbaa !9
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
  %used4 = load ptr, ptr %used, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

while.body:                                       ; preds = %idx.ok
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems6 = load ptr, ptr %elems, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %6 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %elems6, align 8
  %arr.oob9 = icmp uge i64 %6, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !2

while.end:                                        ; preds = %idx.ok
  %i19 = load i32, ptr %i, align 4
  ret i32 %i19

idx.bad:                                          ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.79, ptr @.faila.80, i64 %5, ptr @.failb.81, i64 %arr.len, i32 70)
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
  call void @__polaron_fail(ptr @.fail.82, ptr @.faila.83, i64 %6, ptr @.failb.84, i64 %arr.len8, i32 70)
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
  %cap1 = load i32, ptr %cap, align 4, !tbaa !9
  store i32 %cap1, ptr %oldCap, align 4
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems2 = load ptr, ptr %elems, align 8, !tbaa !3
  store ptr %elems2, ptr %oldE, align 8
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used3 = load ptr, ptr %used, align 8, !tbaa !3
  store ptr %used3, ptr %oldU, align 8
  %cap4 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %oldCap5 = load i32, ptr %oldCap, align 4
  %1 = mul i32 %oldCap5, 2
  store i32 %1, ptr %cap4, align 4, !tbaa !9
  %elems6 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %cap7 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !9
  %2 = sext i32 %cap8 to i64
  %3 = mul i64 %2, 8
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %elems6, align 8, !tbaa !3
  %used9 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %cap10 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap11 = load i32, ptr %cap10, align 4, !tbaa !9
  %6 = sext i32 %cap11 to i64
  %7 = mul i64 %6, 1
  %8 = add i64 8, %7
  %arr12 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr12, align 8
  %arr.data13 = getelementptr i8, ptr %arr12, i64 8
  %9 = call ptr @memset(ptr %arr.data13, i32 0, i64 %7)
  store ptr %arr12, ptr %used9, align 8, !tbaa !3
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !9
  store i32 0, ptr %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %j14 = load i32, ptr %j, align 4
  %oldCap15 = load i32, ptr %oldCap, align 4
  %10 = icmp slt i32 %j14, %oldCap15
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %oldU16 = load ptr, ptr %oldU, align 8, !nonnull !0, !dereferenceable !1
  %j17 = load i32, ptr %j, align 4
  %12 = sext i32 %j17 to i64
  %arr.len = load i64, ptr %oldU16, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

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
  call void @__polaron_fail(ptr @.fail.85, ptr @.faila.86, i64 %12, ptr @.failb.87, i64 %arr.len, i32 70)
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
  %oldE19 = load ptr, ptr %oldE, align 8, !nonnull !0, !dereferenceable !1
  %j20 = load i32, ptr %j, align 4
  %18 = sext i32 %j20 to i64
  %arr.len21 = load i64, ptr %oldE19, align 8
  %arr.oob22 = icmp uge i64 %18, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

if.end:                                           ; preds = %idx.ok24, %idx.ok
  br label %for.update

idx.bad23:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.88, ptr @.faila.89, i64 %18, ptr @.failb.90, i64 %arr.len21, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !9
  %2 = add i32 %count1, 1
  %3 = mul i32 %2, 4
  %cap = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 4
  %cap2 = load i32, ptr %cap, align 4, !tbaa !9
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
  %used4 = load ptr, ptr %used, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %8 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.91, ptr @.faila.92, i64 %8, ptr @.failb.93, i64 %arr.len, i32 70)
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
  %used9 = load ptr, ptr %used8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %used9, align 8
  %arr.oob12 = icmp uge i64 %12, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

if.end7:                                          ; preds = %idx.ok22, %idx.ok
  ret void

idx.bad13:                                        ; preds = %if.then6
  call void @__polaron_fail(ptr @.fail.94, ptr @.faila.95, i64 %12, ptr @.failb.96, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %if.then6
  %arr.data15 = getelementptr i8, ptr %used9, i64 8
  %arr.elem16 = getelementptr inbounds i8, ptr %arr.data15, i64 %12
  store i8 1, ptr %arr.elem16, align 1
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems17 = load ptr, ptr %elems, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i18 = load i32, ptr %i, align 4
  %13 = sext i32 %i18 to i64
  %arr.len19 = load i64, ptr %elems17, align 8
  %arr.oob20 = icmp uge i64 %13, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !2

idx.bad21:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.97, ptr @.faila.98, i64 %13, ptr @.failb.99, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %idx.ok14
  %arr.data23 = getelementptr i8, ptr %elems17, i64 8
  %arr.elem24 = getelementptr inbounds i64, ptr %arr.data23, i64 %13
  %value25 = load i64, ptr %value, align 8
  store i64 %value25, ptr %arr.elem24, align 8
  %count26 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count27 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count28 = load i32, ptr %count27, align 4, !tbaa !9
  %14 = add i32 %count28, 1
  store i32 %14, ptr %count26, align 4, !tbaa !9
  br label %if.end7
}

define internal i32 @"HashSet$long.contains"(ptr nonnull align 8 dereferenceable(32) %0, i64 %1) {
entry:
  %value = alloca i64, align 8
  store i64 %1, ptr %value, align 8
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used1 = load ptr, ptr %used, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %value2 = load i64, ptr %value, align 8
  %2 = call i32 @"HashSet$long.slotFor"(ptr %0, i64 %value2)
  %3 = sext i32 %2 to i64
  %arr.len = load i64, ptr %used1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.100, ptr @.faila.101, i64 %3, ptr @.failb.102, i64 %arr.len, i32 70)
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
  %used2 = load ptr, ptr %used, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %3 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %used2, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.103, ptr @.faila.104, i64 %3, ptr @.failb.105, i64 %arr.len, i32 70)
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
  %cap4 = load i32, ptr %cap, align 4, !tbaa !9
  %7 = sub i32 %cap4, 1
  store i32 %7, ptr %mask, align 4
  %used5 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used6 = load ptr, ptr %used5, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len8 = load i64, ptr %used6, align 8
  %arr.oob9 = icmp uge i64 %8, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !2

idx.bad10:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.106, ptr @.faila.107, i64 %8, ptr @.failb.108, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %if.end
  %arr.data12 = getelementptr i8, ptr %used6, i64 8
  %arr.elem13 = getelementptr inbounds i8, ptr %arr.data12, i64 %8
  store i8 0, ptr %arr.elem13, align 1
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count14 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count15 = load i32, ptr %count14, align 4, !tbaa !9
  %9 = sub i32 %count15, 1
  store i32 %9, ptr %count, align 4, !tbaa !9
  %i16 = load i32, ptr %i, align 4
  %10 = add i32 %i16, 1
  %mask17 = load i32, ptr %mask, align 4
  %11 = and i32 %10, %mask17
  store i32 %11, ptr %j, align 4
  br label %while.cond

while.cond:                                       ; preds = %idx.ok43, %idx.ok11
  %used18 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used19 = load ptr, ptr %used18, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j20 = load i32, ptr %j, align 4
  %12 = sext i32 %j20 to i64
  %arr.len21 = load i64, ptr %used19, align 8
  %arr.oob22 = icmp uge i64 %12, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !2

while.body:                                       ; preds = %idx.ok24
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems28 = load ptr, ptr %elems, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j29 = load i32, ptr %j, align 4
  %13 = sext i32 %j29 to i64
  %arr.len30 = load i64, ptr %elems28, align 8
  %arr.oob31 = icmp uge i64 %13, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

while.end:                                        ; preds = %idx.ok24
  ret i32 1

idx.bad23:                                        ; preds = %while.cond
  call void @__polaron_fail(ptr @.fail.109, ptr @.faila.110, i64 %12, ptr @.failb.111, i64 %arr.len21, i32 70)
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
  call void @__polaron_fail(ptr @.fail.112, ptr @.faila.113, i64 %13, ptr @.failb.114, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body
  %arr.data34 = getelementptr i8, ptr %elems28, i64 8
  %arr.elem35 = getelementptr inbounds i64, ptr %arr.data34, i64 %13
  %elem36 = load i64, ptr %arr.elem35, align 8
  store i64 %elem36, ptr %re, align 8
  %used37 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used38 = load ptr, ptr %used37, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %j39 = load i32, ptr %j, align 4
  %17 = sext i32 %j39 to i64
  %arr.len40 = load i64, ptr %used38, align 8
  %arr.oob41 = icmp uge i64 %17, %arr.len40
  br i1 %arr.oob41, label %idx.bad42, label %idx.ok43, !prof !2

idx.bad42:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.115, ptr @.faila.116, i64 %17, ptr @.failb.117, i64 %arr.len40, i32 70)
  unreachable

idx.ok43:                                         ; preds = %idx.ok33
  %arr.data44 = getelementptr i8, ptr %used38, i64 8
  %arr.elem45 = getelementptr inbounds i8, ptr %arr.data44, i64 %17
  store i8 0, ptr %arr.elem45, align 1
  %count46 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count47 = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count48 = load i32, ptr %count47, align 4, !tbaa !9
  %18 = sub i32 %count48, 1
  store i32 %18, ptr %count46, align 4, !tbaa !9
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
  %count1 = load i32, ptr %count, align 4, !tbaa !9
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
  %cap3 = load i32, ptr %cap, align 4, !tbaa !9
  %5 = icmp slt i32 %i2, %cap3
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %used = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 2
  %used4 = load ptr, ptr %used, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %7 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %used4, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %if.end
  %8 = load i32, ptr %i, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %out25 = load ptr, ptr %out, align 8
  ret ptr %out25

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.118, ptr @.faila.119, i64 %7, ptr @.failb.120, i64 %arr.len, i32 70)
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
  %out7 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %j8 = load i32, ptr %j, align 4
  %13 = sext i32 %j8 to i64
  %arr.len9 = load i64, ptr %out7, align 8
  %arr.oob10 = icmp uge i64 %13, %arr.len9
  br i1 %arr.oob10, label %idx.bad11, label %idx.ok12, !prof !2

if.end:                                           ; preds = %idx.ok20, %idx.ok
  br label %for.update

idx.bad11:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.121, ptr @.faila.122, i64 %13, ptr @.failb.123, i64 %arr.len9, i32 70)
  unreachable

idx.ok12:                                         ; preds = %if.then
  %arr.data13 = getelementptr i8, ptr %out7, i64 8
  %arr.elem14 = getelementptr inbounds i64, ptr %arr.data13, i64 %13
  %elems = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 1
  %elems15 = load ptr, ptr %elems, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i16 = load i32, ptr %i, align 4
  %14 = sext i32 %i16 to i64
  %arr.len17 = load i64, ptr %elems15, align 8
  %arr.oob18 = icmp uge i64 %14, %arr.len17
  br i1 %arr.oob18, label %idx.bad19, label %idx.ok20, !prof !2

idx.bad19:                                        ; preds = %idx.ok12
  call void @__polaron_fail(ptr @.fail.124, ptr @.faila.125, i64 %14, ptr @.failb.126, i64 %arr.len17, i32 70)
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
  %count1 = load i32, ptr %count, align 4, !tbaa !9
  ret i32 %count1
}

define internal i32 @"HashSet$long.isEmpty"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.HashSet$long", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !9
  %1 = icmp eq i32 %count1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @StereoMixer.StereoMixer(ptr %0, i64 %1, i64 %2) {
entry:
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %id = alloca i64, align 8
  %conn = alloca i64, align 8
  store i64 %1, ptr %conn, align 8
  store i64 %2, ptr %id, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 0
  store ptr @StereoMixer.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8
  store i64 %conn1, ptr %__conn, align 8, !tbaa !7
  %id2 = load i64, ptr %id, align 8
  %3 = icmp ne i64 %id2, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %id3 = load i64, ptr %id, align 8
  store i64 %id3, ptr %__id, align 8, !tbaa !7
  ret void

if.end:                                           ; preds = %entry
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w4 = load ptr, ptr %w, align 8
  %5 = call i32 @IpcProto.kCreate()
  call void @IpcWriter.putByte(ptr %w4, i32 %5)
  %w5 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w5, ptr @.strobj.1384)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %conn6 = load i64, ptr %conn, align 8
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %conn6)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch7 = load ptr, ptr %ch, align 8
  %w8 = load ptr, ptr %w, align 8
  %6 = call ptr @IpcWriter.toFrame(ptr %w8)
  %7 = call ptr @IpcChannel.request(ptr %ch7, ptr %6)
  store ptr %7, ptr %r, align 8
  call void @__polaron_str_free(ptr %6)
  %__id9 = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %r10 = load ptr, ptr %r, align 8
  %8 = call i64 @IpcReader.getLong(ptr %r10)
  store i64 %8, ptr %__id9, align 8, !tbaa !7
  %r11 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r11)
  %vtbl.addr12 = getelementptr inbounds %class.IpcReader, ptr %r11, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr12, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %9 = icmp ne ptr %dtor.fn, null
  br i1 %9, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %if.end
  call void %dtor.fn(ptr %r11)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.end
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r11, i32 0, i32 1
  %10 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %10)
  call void @__polaron_free(ptr %r11)
  %ch13 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch13)
  %vtbl.addr14 = getelementptr inbounds %class.IpcChannel, ptr %ch13, i32 0, i32 0
  %vtbl15 = load ptr, ptr %vtbl.addr14, align 8, !tbaa !3
  %dtor.slot16 = getelementptr [358 x ptr], ptr %vtbl15, i64 0, i64 357
  %dtor.fn17 = load ptr, ptr %dtor.slot16, align 8
  %11 = icmp ne ptr %dtor.fn17, null
  br i1 %11, label %dtor.call18, label %dtor.free19

dtor.call18:                                      ; preds = %dtor.free
  call void %dtor.fn17(ptr %ch13)
  br label %dtor.free19

dtor.free19:                                      ; preds = %dtor.call18, %dtor.free
  call void @__polaron_free(ptr %ch13)
  %w20 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w20)
  %vtbl.addr21 = getelementptr inbounds %class.IpcWriter, ptr %w20, i32 0, i32 0
  %vtbl22 = load ptr, ptr %vtbl.addr21, align 8, !tbaa !3
  %dtor.slot23 = getelementptr [358 x ptr], ptr %vtbl22, i64 0, i64 357
  %dtor.fn24 = load ptr, ptr %dtor.slot23, align 8
  %12 = icmp ne ptr %dtor.fn24, null
  br i1 %12, label %dtor.call25, label %dtor.free26

dtor.call25:                                      ; preds = %dtor.free19
  call void %dtor.fn24(ptr %w20)
  br label %dtor.free26

dtor.free26:                                      ; preds = %dtor.call25, %dtor.free19
  call void @__polaron_free(ptr %w20)
  ret void
}

define internal i64 @StereoMixer.__ipcId(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id1 = load i64, ptr %__id, align 8, !tbaa !7
  ret i64 %__id1
}

define internal i64 @StereoMixer.__ipcConn(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %__conn1 = load i64, ptr %__conn, align 8, !tbaa !7
  ret i64 %__conn1
}

define internal void @StereoMixer.release(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id1 = load i64, ptr %__id, align 8, !tbaa !7
  %1 = icmp eq i64 %__id1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w2 = load ptr, ptr %w, align 8
  %3 = call i32 @IpcProto.kRelease()
  call void @IpcWriter.putByte(ptr %w2, i32 %3)
  %w3 = load ptr, ptr %w, align 8
  %__id4 = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id5 = load i64, ptr %__id4, align 8, !tbaa !7
  call void @IpcWriter.putLong(ptr %w3, i64 %__id5)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %__conn6 = load i64, ptr %__conn, align 8, !tbaa !7
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %__conn6)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch7 = load ptr, ptr %ch, align 8
  %w8 = load ptr, ptr %w, align 8
  %4 = call ptr @IpcWriter.toFrame(ptr %w8)
  %5 = call ptr @IpcChannel.request(ptr %ch7, ptr %4)
  store ptr %5, ptr %r, align 8
  call void @__polaron_str_free(ptr %4)
  %r9 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r9)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r9, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %6 = icmp ne ptr %dtor.fn, null
  br i1 %6, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %if.end
  call void %dtor.fn(ptr %r9)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.end
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r9, i32 0, i32 1
  %7 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %7)
  call void @__polaron_free(ptr %r9)
  %ch10 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch10)
  %vtbl.addr11 = getelementptr inbounds %class.IpcChannel, ptr %ch10, i32 0, i32 0
  %vtbl12 = load ptr, ptr %vtbl.addr11, align 8, !tbaa !3
  %dtor.slot13 = getelementptr [358 x ptr], ptr %vtbl12, i64 0, i64 357
  %dtor.fn14 = load ptr, ptr %dtor.slot13, align 8
  %8 = icmp ne ptr %dtor.fn14, null
  br i1 %8, label %dtor.call15, label %dtor.free16

dtor.call15:                                      ; preds = %dtor.free
  call void %dtor.fn14(ptr %ch10)
  br label %dtor.free16

dtor.free16:                                      ; preds = %dtor.call15, %dtor.free
  call void @__polaron_free(ptr %ch10)
  %w17 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w17)
  %vtbl.addr18 = getelementptr inbounds %class.IpcWriter, ptr %w17, i32 0, i32 0
  %vtbl19 = load ptr, ptr %vtbl.addr18, align 8, !tbaa !3
  %dtor.slot20 = getelementptr [358 x ptr], ptr %vtbl19, i64 0, i64 357
  %dtor.fn21 = load ptr, ptr %dtor.slot20, align 8
  %9 = icmp ne ptr %dtor.fn21, null
  br i1 %9, label %dtor.call22, label %dtor.free23

dtor.call22:                                      ; preds = %dtor.free16
  call void %dtor.fn21(ptr %w17)
  br label %dtor.free23

dtor.free23:                                      ; preds = %dtor.call22, %dtor.free16
  call void @__polaron_free(ptr %w17)
  %__id24 = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  store i64 0, ptr %__id24, align 8, !tbaa !7
  ret void
}

define internal i32 @StereoMixer.play(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %out = alloca i32, align 4
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %sound = alloca ptr, align 8
  store ptr %1, ptr %sound, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %2 = call i32 @IpcProto.kCall()
  call void @IpcWriter.putByte(ptr %w1, i32 %2)
  %w2 = load ptr, ptr %w, align 8
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id3 = load i64, ptr %__id, align 8, !tbaa !7
  call void @IpcWriter.putLong(ptr %w2, i64 %__id3)
  %w4 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w4, ptr @.strobj.1386)
  %w5 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w5, ptr @.strobj.1388)
  %w6 = load ptr, ptr %w, align 8
  %sound7 = load ptr, ptr %sound, align 8
  call void @IpcWriter.putString(ptr %w6, ptr %sound7)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %__conn8 = load i64, ptr %__conn, align 8, !tbaa !7
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %__conn8)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch9 = load ptr, ptr %ch, align 8
  %w10 = load ptr, ptr %w, align 8
  %3 = call ptr @IpcWriter.toFrame(ptr %w10)
  %4 = call ptr @IpcChannel.request(ptr %ch9, ptr %3)
  store ptr %4, ptr %r, align 8
  call void @__polaron_str_free(ptr %3)
  %r11 = load ptr, ptr %r, align 8
  %5 = call i32 @IpcReader.getInt(ptr %r11)
  store i32 %5, ptr %out, align 4
  %r12 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r12)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r12, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %6 = icmp ne ptr %dtor.fn, null
  br i1 %6, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %r12)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r12, i32 0, i32 1
  %7 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %7)
  call void @__polaron_free(ptr %r12)
  %ch13 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch13)
  %vtbl.addr14 = getelementptr inbounds %class.IpcChannel, ptr %ch13, i32 0, i32 0
  %vtbl15 = load ptr, ptr %vtbl.addr14, align 8, !tbaa !3
  %dtor.slot16 = getelementptr [358 x ptr], ptr %vtbl15, i64 0, i64 357
  %dtor.fn17 = load ptr, ptr %dtor.slot16, align 8
  %8 = icmp ne ptr %dtor.fn17, null
  br i1 %8, label %dtor.call18, label %dtor.free19

dtor.call18:                                      ; preds = %dtor.free
  call void %dtor.fn17(ptr %ch13)
  br label %dtor.free19

dtor.free19:                                      ; preds = %dtor.call18, %dtor.free
  call void @__polaron_free(ptr %ch13)
  %w20 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w20)
  %vtbl.addr21 = getelementptr inbounds %class.IpcWriter, ptr %w20, i32 0, i32 0
  %vtbl22 = load ptr, ptr %vtbl.addr21, align 8, !tbaa !3
  %dtor.slot23 = getelementptr [358 x ptr], ptr %vtbl22, i64 0, i64 357
  %dtor.fn24 = load ptr, ptr %dtor.slot23, align 8
  %9 = icmp ne ptr %dtor.fn24, null
  br i1 %9, label %dtor.call25, label %dtor.free26

dtor.call25:                                      ; preds = %dtor.free19
  call void %dtor.fn24(ptr %w20)
  br label %dtor.free26

dtor.free26:                                      ; preds = %dtor.call25, %dtor.free19
  call void @__polaron_free(ptr %w20)
  %out27 = load i32, ptr %out, align 4
  ret i32 %out27
}

define internal void @StereoMixer.setVolume(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %2 = call i32 @IpcProto.kCall()
  call void @IpcWriter.putByte(ptr %w1, i32 %2)
  %w2 = load ptr, ptr %w, align 8
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id3 = load i64, ptr %__id, align 8, !tbaa !7
  call void @IpcWriter.putLong(ptr %w2, i64 %__id3)
  %w4 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w4, ptr @.strobj.1390)
  %w5 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w5, ptr @.strobj.1392)
  %w6 = load ptr, ptr %w, align 8
  %v7 = load i32, ptr %v, align 4
  call void @IpcWriter.putInt(ptr %w6, i32 %v7)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %__conn8 = load i64, ptr %__conn, align 8, !tbaa !7
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %__conn8)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch9 = load ptr, ptr %ch, align 8
  %w10 = load ptr, ptr %w, align 8
  %3 = call ptr @IpcWriter.toFrame(ptr %w10)
  %4 = call ptr @IpcChannel.request(ptr %ch9, ptr %3)
  store ptr %4, ptr %r, align 8
  call void @__polaron_str_free(ptr %3)
  %r11 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r11)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r11, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %5 = icmp ne ptr %dtor.fn, null
  br i1 %5, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %r11)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r11, i32 0, i32 1
  %6 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %6)
  call void @__polaron_free(ptr %r11)
  %ch12 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch12)
  %vtbl.addr13 = getelementptr inbounds %class.IpcChannel, ptr %ch12, i32 0, i32 0
  %vtbl14 = load ptr, ptr %vtbl.addr13, align 8, !tbaa !3
  %dtor.slot15 = getelementptr [358 x ptr], ptr %vtbl14, i64 0, i64 357
  %dtor.fn16 = load ptr, ptr %dtor.slot15, align 8
  %7 = icmp ne ptr %dtor.fn16, null
  br i1 %7, label %dtor.call17, label %dtor.free18

dtor.call17:                                      ; preds = %dtor.free
  call void %dtor.fn16(ptr %ch12)
  br label %dtor.free18

dtor.free18:                                      ; preds = %dtor.call17, %dtor.free
  call void @__polaron_free(ptr %ch12)
  %w19 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w19)
  %vtbl.addr20 = getelementptr inbounds %class.IpcWriter, ptr %w19, i32 0, i32 0
  %vtbl21 = load ptr, ptr %vtbl.addr20, align 8, !tbaa !3
  %dtor.slot22 = getelementptr [358 x ptr], ptr %vtbl21, i64 0, i64 357
  %dtor.fn23 = load ptr, ptr %dtor.slot22, align 8
  %8 = icmp ne ptr %dtor.fn23, null
  br i1 %8, label %dtor.call24, label %dtor.free25

dtor.call24:                                      ; preds = %dtor.free18
  call void %dtor.fn23(ptr %w19)
  br label %dtor.free25

dtor.free25:                                      ; preds = %dtor.call24, %dtor.free18
  call void @__polaron_free(ptr %w19)
  ret void
}

define internal i32 @StereoMixer.volume(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %out = alloca i32, align 4
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %1 = call i32 @IpcProto.kCall()
  call void @IpcWriter.putByte(ptr %w1, i32 %1)
  %w2 = load ptr, ptr %w, align 8
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id3 = load i64, ptr %__id, align 8, !tbaa !7
  call void @IpcWriter.putLong(ptr %w2, i64 %__id3)
  %w4 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w4, ptr @.strobj.1394)
  %w5 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w5, ptr @.strobj.1396)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %__conn6 = load i64, ptr %__conn, align 8, !tbaa !7
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %__conn6)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch7 = load ptr, ptr %ch, align 8
  %w8 = load ptr, ptr %w, align 8
  %2 = call ptr @IpcWriter.toFrame(ptr %w8)
  %3 = call ptr @IpcChannel.request(ptr %ch7, ptr %2)
  store ptr %3, ptr %r, align 8
  call void @__polaron_str_free(ptr %2)
  %r9 = load ptr, ptr %r, align 8
  %4 = call i32 @IpcReader.getInt(ptr %r9)
  store i32 %4, ptr %out, align 4
  %r10 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r10)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r10, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %5 = icmp ne ptr %dtor.fn, null
  br i1 %5, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %r10)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r10, i32 0, i32 1
  %6 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %6)
  call void @__polaron_free(ptr %r10)
  %ch11 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch11)
  %vtbl.addr12 = getelementptr inbounds %class.IpcChannel, ptr %ch11, i32 0, i32 0
  %vtbl13 = load ptr, ptr %vtbl.addr12, align 8, !tbaa !3
  %dtor.slot14 = getelementptr [358 x ptr], ptr %vtbl13, i64 0, i64 357
  %dtor.fn15 = load ptr, ptr %dtor.slot14, align 8
  %7 = icmp ne ptr %dtor.fn15, null
  br i1 %7, label %dtor.call16, label %dtor.free17

dtor.call16:                                      ; preds = %dtor.free
  call void %dtor.fn15(ptr %ch11)
  br label %dtor.free17

dtor.free17:                                      ; preds = %dtor.call16, %dtor.free
  call void @__polaron_free(ptr %ch11)
  %w18 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w18)
  %vtbl.addr19 = getelementptr inbounds %class.IpcWriter, ptr %w18, i32 0, i32 0
  %vtbl20 = load ptr, ptr %vtbl.addr19, align 8, !tbaa !3
  %dtor.slot21 = getelementptr [358 x ptr], ptr %vtbl20, i64 0, i64 357
  %dtor.fn22 = load ptr, ptr %dtor.slot21, align 8
  %8 = icmp ne ptr %dtor.fn22, null
  br i1 %8, label %dtor.call23, label %dtor.free24

dtor.call23:                                      ; preds = %dtor.free17
  call void %dtor.fn22(ptr %w18)
  br label %dtor.free24

dtor.free24:                                      ; preds = %dtor.call23, %dtor.free17
  call void @__polaron_free(ptr %w18)
  %out25 = load i32, ptr %out, align 4
  ret i32 %out25
}

define internal i32 @StereoMixer.mixdown(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %out = alloca i32, align 4
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %BundleAccessToken.copy = alloca %class.BundleAccessToken, align 8
  %mixdown = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %BundleAccessToken.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.BundleAccessToken, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.BundleAccessToken, ptr %1, i32 0, i32 2
  %4 = load ptr, ptr %3, align 8, !tbaa !3
  %strcpy = call ptr @__polaron_str_copy(ptr %4)
  %5 = getelementptr inbounds %class.BundleAccessToken, ptr %BundleAccessToken.copy, i32 0, i32 2
  store ptr %strcpy, ptr %5, align 8, !tbaa !3
  store ptr %BundleAccessToken.copy, ptr %mixdown, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %6 = call i32 @IpcProto.kCall()
  call void @IpcWriter.putByte(ptr %w1, i32 %6)
  %w2 = load ptr, ptr %w, align 8
  %__id = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 2
  %__id3 = load i64, ptr %__id, align 8, !tbaa !7
  call void @IpcWriter.putLong(ptr %w2, i64 %__id3)
  %w4 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w4, ptr @.strobj.1398)
  %w5 = load ptr, ptr %w, align 8
  call void @IpcWriter.putString(ptr %w5, ptr @.strobj.1400)
  %w6 = load ptr, ptr %w, align 8
  %mixdown7 = load ptr, ptr %mixdown, align 8
  %7 = call i64 @BundleAccessToken.nonce(ptr %mixdown7)
  call void @IpcWriter.putLong(ptr %w6, i64 %7)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %__conn = getelementptr inbounds %class.StereoMixer, ptr %0, i32 0, i32 1
  %__conn8 = load i64, ptr %__conn, align 8, !tbaa !7
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %__conn8)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch9 = load ptr, ptr %ch, align 8
  %w10 = load ptr, ptr %w, align 8
  %8 = call ptr @IpcWriter.toFrame(ptr %w10)
  %9 = call ptr @IpcChannel.request(ptr %ch9, ptr %8)
  store ptr %9, ptr %r, align 8
  call void @__polaron_str_free(ptr %8)
  %r11 = load ptr, ptr %r, align 8
  %10 = call i32 @IpcReader.getInt(ptr %r11)
  store i32 %10, ptr %out, align 4
  %r12 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r12)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r12, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %11 = icmp ne ptr %dtor.fn, null
  br i1 %11, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %entry
  call void %dtor.fn(ptr %r12)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %entry
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r12, i32 0, i32 1
  %12 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %12)
  call void @__polaron_free(ptr %r12)
  %ch13 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch13)
  %vtbl.addr14 = getelementptr inbounds %class.IpcChannel, ptr %ch13, i32 0, i32 0
  %vtbl15 = load ptr, ptr %vtbl.addr14, align 8, !tbaa !3
  %dtor.slot16 = getelementptr [358 x ptr], ptr %vtbl15, i64 0, i64 357
  %dtor.fn17 = load ptr, ptr %dtor.slot16, align 8
  %13 = icmp ne ptr %dtor.fn17, null
  br i1 %13, label %dtor.call18, label %dtor.free19

dtor.call18:                                      ; preds = %dtor.free
  call void %dtor.fn17(ptr %ch13)
  br label %dtor.free19

dtor.free19:                                      ; preds = %dtor.call18, %dtor.free
  call void @__polaron_free(ptr %ch13)
  %w20 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w20)
  %vtbl.addr21 = getelementptr inbounds %class.IpcWriter, ptr %w20, i32 0, i32 0
  %vtbl22 = load ptr, ptr %vtbl.addr21, align 8, !tbaa !3
  %dtor.slot23 = getelementptr [358 x ptr], ptr %vtbl22, i64 0, i64 357
  %dtor.fn24 = load ptr, ptr %dtor.slot23, align 8
  %14 = icmp ne ptr %dtor.fn24, null
  br i1 %14, label %dtor.call25, label %dtor.free26

dtor.call25:                                      ; preds = %dtor.free19
  call void %dtor.fn24(ptr %w20)
  br label %dtor.free26

dtor.free26:                                      ; preds = %dtor.call25, %dtor.free19
  call void @__polaron_free(ptr %w20)
  %out27 = load i32, ptr %out, align 4
  ret i32 %out27
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

define internal void @ArithmeticException.ArithmeticException(ptr %0) {
entry:
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ArithmeticException, ptr %0, i32 0, i32 0
  store ptr @ArithmeticException.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  ret void
}

define internal ptr @ArithmeticException.message(ptr nonnull align 8 dereferenceable(8) %0) {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1412)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1414)
  ret ptr %strcpy
}

define internal void @StringBuilder.StringBuilder(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 0
  store ptr @StringBuilder.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  store i32 16, ptr %cap, align 4, !tbaa !9
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %mem.alloc = call ptr @__polaron_malloc(i64 16)
  %1 = ptrtoint ptr %mem.alloc to i64
  store i64 %1, ptr %buf, align 8, !tbaa !7
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !9
  ret void
}

define internal void @StringBuilder.ensure(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %nb = alloca i64, align 8
  %n = alloca i32, align 4
  %extra = alloca i32, align 4
  store i32 %1, ptr %extra, align 4
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !9
  %extra2 = load i32, ptr %extra, align 4
  %2 = add i32 %count1, %extra2
  %cap = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap3 = load i32, ptr %cap, align 4, !tbaa !9
  %3 = icmp sle i32 %2, %cap3
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret void

if.end:                                           ; preds = %entry
  %cap4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %cap5 = load i32, ptr %cap4, align 4, !tbaa !9
  %5 = mul i32 %cap5, 2
  store i32 %5, ptr %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %n6 = load i32, ptr %n, align 4
  %count7 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count8 = load i32, ptr %count7, align 4, !tbaa !9
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
  %buf13 = load i64, ptr %buf, align 8, !tbaa !7
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !9
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !7
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !7
  %cap20 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 3
  %n21 = load i32, ptr %n, align 4
  store i32 %n21, ptr %cap20, align 4, !tbaa !9
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
  %buf3 = load i64, ptr %buf, align 8, !tbaa !7
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !9
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
  %count10 = load i32, ptr %count9, align 4, !tbaa !9
  %n11 = load i32, ptr %n, align 4
  %7 = add i32 %count10, %n11
  store i32 %7, ptr %count8, align 4, !tbaa !9
  ret ptr %0
}

define internal ptr @StringBuilder.appendChar(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %c = alloca i32, align 4
  store i32 %1, ptr %c, align 4
  call void @StringBuilder.ensure(ptr %0, i32 1)
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !7
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !9
  %2 = sext i32 %count2 to i64
  %3 = add i64 %buf1, %2
  %c3 = load i32, ptr %c, align 4
  %4 = trunc i32 %c3 to i8
  %5 = inttoptr i64 %3 to ptr
  store i8 %4, ptr %5, align 1
  %count4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count5 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count6 = load i32, ptr %count5, align 4, !tbaa !9
  %6 = add i32 %count6, 1
  store i32 %6, ptr %count4, align 4, !tbaa !9
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
  %count7 = load i32, ptr %count, align 4, !tbaa !9
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
  %count18 = load i32, ptr %count17, align 4, !tbaa !9
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
  %buf24 = load i64, ptr %buf, align 8, !tbaa !7
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !7
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !7
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !7
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
  %count1 = load i32, ptr %count, align 4, !tbaa !9
  ret i32 %count1
}

define internal ptr @StringBuilder.toString(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !7
  %count = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !9
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
  store i32 0, ptr %count, align 4, !tbaa !9
  ret ptr %0
}

define internal void @"StringBuilder.~StringBuilder"(ptr %0) {
entry:
  %buf = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf1 = load i64, ptr %buf, align 8, !tbaa !7
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !7
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !7
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal void @Subprocess.Subprocess(ptr %0, i64 %1) {
entry:
  %h = alloca i64, align 8
  store i64 %1, ptr %h, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 0
  store ptr @Subprocess.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %h1 = load i64, ptr %h, align 8
  store i64 %h1, ptr %handle, align 8, !tbaa !7
  ret void
}

define internal ptr @Subprocess.start(ptr %0) {
entry:
  %command = alloca ptr, align 8
  store ptr %0, ptr %command, align 8
  %Subprocess.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Subprocess, ptr null, i64 1) to i64))
  %command1 = load ptr, ptr %command, align 8
  %str.data = getelementptr inbounds %String, ptr %command1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %1 = call i64 @__polaron_subproc_spawn_ex(ptr %data, i64 0, i64 0)
  call void @Subprocess.Subprocess(ptr %Subprocess.obj, i64 %1)
  ret ptr %Subprocess.obj
}

define internal i32 @Subprocess.isValid(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  %1 = icmp ne i64 %handle1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal i32 @Subprocess.write(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  %data2 = load ptr, ptr %data, align 8
  %str.data = getelementptr inbounds %String, ptr %data2, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %data2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = call i64 @__polaron_subproc_write(i64 %handle1, ptr %data3, i64 %len)
  %3 = trunc i64 %2 to i32
  ret i32 %3
}

define internal ptr @Subprocess.read(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %sp.len = alloca i64, align 8
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  %1 = call ptr @__polaron_subproc_read(i64 %handle1, ptr %sp.len)
  %sp.n = load i64, ptr %sp.len, align 8
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %2 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %sp.n, ptr %2, align 8
  %3 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %1, ptr %3, align 8
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %4, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  call void @__polaron_str_free(ptr %newstr)
  ret ptr %strcpy
}

define internal i32 @Subprocess.isAlive(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  %1 = call i32 @__polaron_subproc_alive(i64 %handle1)
  ret i32 %1
}

define internal i32 @Subprocess.canRead(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  %1 = call i32 @__polaron_subproc_can_read(i64 %handle1)
  ret i32 %1
}

define internal void @Subprocess.closeInput(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  call void @__polaron_subproc_close_stdin(i64 %handle1)
  ret void
}

define internal void @Subprocess.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %handle = getelementptr inbounds %class.Subprocess, ptr %0, i32 0, i32 1
  %handle1 = load i64, ptr %handle, align 8, !tbaa !7
  call void @__polaron_subproc_close(i64 %handle1)
  ret void
}

define internal void @IpcError.IpcError(ptr %0, ptr %1) {
entry:
  %text = alloca ptr, align 8
  store ptr %1, ptr %text, align 8
  call void @Exception.Exception(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IpcError, ptr %0, i32 0, i32 0
  store ptr @IpcError.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %text1 = getelementptr inbounds %class.IpcError, ptr %0, i32 0, i32 1
  store ptr null, ptr %text1, align 8, !tbaa !3
  %text2 = getelementptr inbounds %class.IpcError, ptr %0, i32 0, i32 1
  %text3 = load ptr, ptr %text, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %text3)
  %2 = load ptr, ptr %text2, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %text2, align 8, !tbaa !3
  ret void
}

define internal ptr @IpcError.message(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %text = getelementptr inbounds %class.IpcError, ptr %0, i32 0, i32 1
  %text1 = load ptr, ptr %text, align 8, !tbaa !3
  %strcpy = call ptr @__polaron_str_copy(ptr %text1)
  ret ptr %strcpy
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
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
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
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
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
  store ptr @IpcWriter.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  store ptr null, ptr %sb, align 8, !tbaa !3
  %sb1 = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb1, align 8, !tbaa !3
  ret void
}

define internal void @IpcWriter.putByte(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %b = alloca i32, align 4
  store i32 %1, ptr %b, align 4
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !3
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
  %sb2 = load ptr, ptr %sb, align 8, !tbaa !3
  %s3 = load ptr, ptr %s, align 8
  %3 = call ptr @StringBuilder.append(ptr %sb2, ptr %s3)
  ret void
}

define internal ptr @IpcWriter.toFrame(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !3
  %1 = call ptr @StringBuilder.toString(ptr %sb1)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal void @"IpcWriter.~IpcWriter"(ptr %0) {
entry:
  %sb = getelementptr inbounds %class.IpcWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !3
  call void @__polaron_check_live(ptr %sb1)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %sb1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
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
  store ptr @IpcReader.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %buf = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  store ptr null, ptr %buf, align 8, !tbaa !3
  %buf1 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  %frame2 = load ptr, ptr %frame, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %frame2)
  %2 = load ptr, ptr %buf1, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %buf1, align 8, !tbaa !3
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !9
  ret void
}

define internal i32 @IpcReader.atEnd(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos1 = load i32, ptr %pos, align 4, !tbaa !9
  %buf = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 1
  %buf2 = load ptr, ptr %buf, align 8, !tbaa !3
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
  %buf1 = load ptr, ptr %buf, align 8, !tbaa !3
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !9
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
  %pos5 = load i32, ptr %pos4, align 4, !tbaa !9
  %4 = add i32 %pos5, 1
  store i32 %4, ptr %pos3, align 4, !tbaa !9
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
  %buf1 = load ptr, ptr %buf, align 8, !tbaa !3
  %pos = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !9
  %2 = sext i32 %pos2 to i64
  %pos3 = getelementptr inbounds %class.IpcReader, ptr %0, i32 0, i32 2
  %pos4 = load i32, ptr %pos3, align 4, !tbaa !9
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
  %pos8 = load i32, ptr %pos7, align 4, !tbaa !9
  %n9 = load i32, ptr %n, align 4
  %13 = add i32 %pos8, %n9
  store i32 %13, ptr %pos6, align 4, !tbaa !9
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

define internal void @IpcChannel.IpcChannel(ptr %0, i64 %1) {
entry:
  %conn = alloca i64, align 8
  store i64 %1, ptr %conn, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 0
  store ptr @IpcChannel.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %conn1 = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 1
  %conn2 = load i64, ptr %conn, align 8
  store i64 %conn2, ptr %conn1, align 8, !tbaa !7
  ret void
}

define internal i64 @IpcChannel.connection(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %conn = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  ret i64 %conn1
}

define internal ptr @IpcChannel.request(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %reply = alloca ptr, align 8
  %exc.thrown22 = alloca ptr, align 8
  %m = alloca ptr, align 8
  %kind = alloca i32, align 4
  %r = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %msg = alloca ptr, align 8
  %ipc.len = alloca i64, align 8
  %frame = alloca ptr, align 8
  store ptr %1, ptr %frame, align 8
  %conn = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  %frame2 = load ptr, ptr %frame, align 8
  %str.data = getelementptr inbounds %String, ptr %frame2, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %str.len = getelementptr inbounds %String, ptr %frame2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = call i64 @__polaron_ipc_send(i64 %conn1, ptr %data, i64 %len)
  br label %while.cond

while.cond:                                       ; preds = %dtor.free29, %entry
  br i1 true, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %conn3 = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 1
  %conn4 = load i64, ptr %conn3, align 8, !tbaa !7
  %3 = call ptr @__polaron_ipc_recv(i64 %conn4, ptr %ipc.len)
  %ipc.n = load i64, ptr %ipc.len, align 8
  %newstr = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %4 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 0
  store i64 %ipc.n, ptr %4, align 8
  %5 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 1
  store ptr %3, ptr %5, align 8
  %6 = getelementptr inbounds %String, ptr %newstr, i32 0, i32 2
  store i64 0, ptr %6, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %newstr)
  store ptr %strcpy, ptr %msg, align 8
  call void @__polaron_str_free(ptr %newstr)
  %msg5 = load ptr, ptr %msg, align 8
  %str.len6 = getelementptr inbounds %String, ptr %msg5, i32 0, i32 0
  %len7 = load i64, ptr %str.len6, align 8
  %7 = trunc i64 %len7 to i32
  %8 = icmp eq i32 %7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

while.end:                                        ; preds = %while.cond
  ret ptr null

if.then:                                          ; preds = %while.body
  %IpcError.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcError, ptr null, i64 1) to i64))
  call void @IpcError.IpcError(ptr %IpcError.obj, ptr @.strobj.4013)
  store ptr %IpcError.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

if.end:                                           ; preds = %while.body
  %IpcReader.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcReader, ptr null, i64 1) to i64))
  %msg8 = load ptr, ptr %msg, align 8
  call void @IpcReader.IpcReader(ptr %IpcReader.obj, ptr %msg8)
  store ptr %IpcReader.obj, ptr %r, align 8
  %r9 = load ptr, ptr %r, align 8
  %10 = call i32 @IpcReader.getByte(ptr %r9)
  store i32 %10, ptr %kind, align 4
  %kind10 = load i32, ptr %kind, align 4
  %11 = call i32 @IpcProto.kReplyOk()
  %12 = icmp eq i32 %kind10, %11
  %13 = zext i1 %12 to i32
  br i1 %12, label %if.then11, label %if.end12

if.then11:                                        ; preds = %if.end
  %r13 = load ptr, ptr %r, align 8
  %14 = load ptr, ptr %msg, align 8
  call void @__polaron_str_free(ptr %14)
  ret ptr %r13

if.end12:                                         ; preds = %if.end
  %kind14 = load i32, ptr %kind, align 4
  %15 = call i32 @IpcProto.kReplyError()
  %16 = icmp eq i32 %kind14, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then15, label %if.end16

if.then15:                                        ; preds = %if.end12
  %r17 = load ptr, ptr %r, align 8
  %18 = call ptr @IpcReader.getString(ptr %r17)
  %strcpy18 = call ptr @__polaron_str_copy(ptr %18)
  store ptr %strcpy18, ptr %m, align 8
  call void @__polaron_str_free(ptr %18)
  %r19 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r19)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r19, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %19 = icmp ne ptr %dtor.fn, null
  br i1 %19, label %dtor.call, label %dtor.free

if.end16:                                         ; preds = %if.end12
  %r23 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r23)
  %vtbl.addr24 = getelementptr inbounds %class.IpcReader, ptr %r23, i32 0, i32 0
  %vtbl25 = load ptr, ptr %vtbl.addr24, align 8, !tbaa !3
  %dtor.slot26 = getelementptr [358 x ptr], ptr %vtbl25, i64 0, i64 357
  %dtor.fn27 = load ptr, ptr %dtor.slot26, align 8
  %20 = icmp ne ptr %dtor.fn27, null
  br i1 %20, label %dtor.call28, label %dtor.free29

dtor.call:                                        ; preds = %if.then15
  call void %dtor.fn(ptr %r19)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %if.then15
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r19, i32 0, i32 1
  %21 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %21)
  call void @__polaron_free(ptr %r19)
  %IpcError.obj20 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcError, ptr null, i64 1) to i64))
  %m21 = load ptr, ptr %m, align 8
  call void @IpcError.IpcError(ptr %IpcError.obj20, ptr %m21)
  store ptr %IpcError.obj20, ptr %exc.thrown22, align 8
  call void @_CxxThrowException(ptr %exc.thrown22, ptr @_TI1PEAX)
  unreachable

dtor.call28:                                      ; preds = %if.end16
  call void %dtor.fn27(ptr %r23)
  br label %dtor.free29

dtor.free29:                                      ; preds = %dtor.call28, %if.end16
  %buf.sfree30 = getelementptr inbounds %class.IpcReader, ptr %r23, i32 0, i32 1
  %22 = load ptr, ptr %buf.sfree30, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %22)
  call void @__polaron_free(ptr %r23)
  %msg31 = load ptr, ptr %msg, align 8
  %23 = call ptr @IpcRuntime.handle(ptr %msg31)
  %strcpy32 = call ptr @__polaron_str_copy(ptr %23)
  store ptr %strcpy32, ptr %reply, align 8
  call void @__polaron_str_free(ptr %23)
  %conn33 = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 1
  %conn34 = load i64, ptr %conn33, align 8, !tbaa !7
  %reply35 = load ptr, ptr %reply, align 8
  %str.data36 = getelementptr inbounds %String, ptr %reply35, i32 0, i32 1
  %data37 = load ptr, ptr %str.data36, align 8
  %str.len38 = getelementptr inbounds %String, ptr %reply35, i32 0, i32 0
  %len39 = load i64, ptr %str.len38, align 8
  %24 = call i64 @__polaron_ipc_send(i64 %conn34, ptr %data37, i64 %len39)
  %25 = load ptr, ptr %reply, align 8
  call void @__polaron_str_free(ptr %25)
  %26 = load ptr, ptr %msg, align 8
  call void @__polaron_str_free(ptr %26)
  br label %while.cond
}

define internal void @IpcChannel.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %conn = getelementptr inbounds %class.IpcChannel, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  call void @__polaron_ipc_close(i64 %conn1)
  ret void
}

define internal void @BundleAccessToken.BundleAccessToken(ptr %0, i64 %1, ptr %2) {
entry:
  %capability = alloca ptr, align 8
  %nonce = alloca i64, align 8
  store i64 %1, ptr %nonce, align 8
  store ptr %2, ptr %capability, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 0
  store ptr @BundleAccessToken.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %capabilityName = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 2
  store ptr null, ptr %capabilityName, align 8, !tbaa !3
  %nonceValue = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 1
  %nonce1 = load i64, ptr %nonce, align 8
  store i64 %nonce1, ptr %nonceValue, align 8, !tbaa !7
  %capabilityName2 = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 2
  %capability3 = load ptr, ptr %capability, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %capability3)
  %3 = load ptr, ptr %capabilityName2, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %capabilityName2, align 8, !tbaa !3
  ret void
}

define internal i64 @BundleAccessToken.nonce(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nonceValue = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 1
  %nonceValue1 = load i64, ptr %nonceValue, align 8, !tbaa !7
  ret i64 %nonceValue1
}

define internal ptr @BundleAccessToken.capability(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %capabilityName = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 2
  %capabilityName1 = load ptr, ptr %capabilityName, align 8, !tbaa !3
  %strcpy = call ptr @__polaron_str_copy(ptr %capabilityName1)
  ret ptr %strcpy
}

define internal i32 @BundleAccessToken.granted(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nonceValue = getelementptr inbounds %class.BundleAccessToken, ptr %0, i32 0, i32 1
  %nonceValue1 = load i64, ptr %nonceValue, align 8, !tbaa !7
  %1 = icmp ne i64 %nonceValue1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @ProgramHandle.ProgramHandle(ptr %0, i64 %1) {
entry:
  %conn = alloca i64, align 8
  store i64 %1, ptr %conn, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ProgramHandle, ptr %0, i32 0, i32 0
  store ptr @ProgramHandle.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %conn1 = getelementptr inbounds %class.ProgramHandle, ptr %0, i32 0, i32 1
  %conn2 = load i64, ptr %conn, align 8
  store i64 %conn2, ptr %conn1, align 8, !tbaa !7
  ret void
}

define internal i64 @ProgramHandle.connection(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %conn = getelementptr inbounds %class.ProgramHandle, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  ret i64 %conn1
}

define internal ptr @ProgramHandle.bundle(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  store ptr %1, ptr %name, align 8
  ret ptr %0
}

define internal ptr @ProgramHandle.namespace(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %name = alloca ptr, align 8
  store ptr %1, ptr %name, align 8
  ret ptr %0
}

define internal ptr @ProgramHandle.requestAccess(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %e = alloca ptr, align 8
  %exc.caught = alloca ptr, align 8
  %nonce = alloca i64, align 8
  %r = alloca ptr, align 8
  %ch = alloca ptr, align 8
  %w = alloca ptr, align 8
  %capability = alloca ptr, align 8
  store ptr %1, ptr %capability, align 8
  %IpcWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcWriter, ptr null, i64 1) to i64))
  call void @IpcWriter.IpcWriter(ptr %IpcWriter.obj)
  store ptr %IpcWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  %2 = call i32 @IpcProto.kCapability()
  call void @IpcWriter.putByte(ptr %w1, i32 %2)
  %w2 = load ptr, ptr %w, align 8
  %capability3 = load ptr, ptr %capability, align 8
  call void @IpcWriter.putString(ptr %w2, ptr %capability3)
  %IpcChannel.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IpcChannel, ptr null, i64 1) to i64))
  %conn = getelementptr inbounds %class.ProgramHandle, ptr %0, i32 0, i32 1
  %conn4 = load i64, ptr %conn, align 8, !tbaa !7
  call void @IpcChannel.IpcChannel(ptr %IpcChannel.obj, i64 %conn4)
  store ptr %IpcChannel.obj, ptr %ch, align 8
  %ch5 = load ptr, ptr %ch, align 8
  %w6 = load ptr, ptr %w, align 8
  %3 = invoke ptr @IpcWriter.toFrame(ptr %w6)
          to label %invoke.cont unwind label %ehpad

ehpad:                                            ; preds = %dtor.free24, %invoke.cont7, %invoke.cont, %entry
  %4 = catchswitch within none [label %catch.dispatch] unwind to caller

try.cont:                                         ; No predecessors!
  ret ptr null

invoke.cont:                                      ; preds = %entry
  %5 = invoke ptr @IpcChannel.request(ptr %ch5, ptr %3)
          to label %invoke.cont7 unwind label %ehpad

invoke.cont7:                                     ; preds = %invoke.cont
  store ptr %5, ptr %r, align 8
  %r8 = load ptr, ptr %r, align 8
  %6 = invoke i64 @IpcReader.getLong(ptr %r8)
          to label %invoke.cont9 unwind label %ehpad

invoke.cont9:                                     ; preds = %invoke.cont7
  store i64 %6, ptr %nonce, align 8
  %r10 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r10)
  %vtbl.addr = getelementptr inbounds %class.IpcReader, ptr %r10, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !3
  %dtor.slot = getelementptr [358 x ptr], ptr %vtbl, i64 0, i64 357
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %7 = icmp ne ptr %dtor.fn, null
  br i1 %7, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %invoke.cont9
  call void %dtor.fn(ptr %r10)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %invoke.cont9
  %buf.sfree = getelementptr inbounds %class.IpcReader, ptr %r10, i32 0, i32 1
  %8 = load ptr, ptr %buf.sfree, align 8, !tbaa !3
  call void @__polaron_str_free(ptr %8)
  call void @__polaron_free(ptr %r10)
  %ch11 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch11)
  %vtbl.addr12 = getelementptr inbounds %class.IpcChannel, ptr %ch11, i32 0, i32 0
  %vtbl13 = load ptr, ptr %vtbl.addr12, align 8, !tbaa !3
  %dtor.slot14 = getelementptr [358 x ptr], ptr %vtbl13, i64 0, i64 357
  %dtor.fn15 = load ptr, ptr %dtor.slot14, align 8
  %9 = icmp ne ptr %dtor.fn15, null
  br i1 %9, label %dtor.call16, label %dtor.free17

dtor.call16:                                      ; preds = %dtor.free
  call void %dtor.fn15(ptr %ch11)
  br label %dtor.free17

dtor.free17:                                      ; preds = %dtor.call16, %dtor.free
  call void @__polaron_free(ptr %ch11)
  %w18 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w18)
  %vtbl.addr19 = getelementptr inbounds %class.IpcWriter, ptr %w18, i32 0, i32 0
  %vtbl20 = load ptr, ptr %vtbl.addr19, align 8, !tbaa !3
  %dtor.slot21 = getelementptr [358 x ptr], ptr %vtbl20, i64 0, i64 357
  %dtor.fn22 = load ptr, ptr %dtor.slot21, align 8
  %10 = icmp ne ptr %dtor.fn22, null
  br i1 %10, label %dtor.call23, label %dtor.free24

dtor.call23:                                      ; preds = %dtor.free17
  call void %dtor.fn22(ptr %w18)
  br label %dtor.free24

dtor.free24:                                      ; preds = %dtor.call23, %dtor.free17
  call void @__polaron_free(ptr %w18)
  %BundleAccessToken.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BundleAccessToken, ptr null, i64 1) to i64))
  %nonce25 = load i64, ptr %nonce, align 8
  %capability26 = load ptr, ptr %capability, align 8
  invoke void @BundleAccessToken.BundleAccessToken(ptr %BundleAccessToken.obj, i64 %nonce25, ptr %capability26)
          to label %invoke.cont27 unwind label %ehpad

invoke.cont27:                                    ; preds = %dtor.free24
  ret ptr %BundleAccessToken.obj

catch.dispatch:                                   ; preds = %ehpad
  %11 = catchpad within %4 [ptr @"??_R0PEAX@8", i32 0, ptr %exc.caught]
  %caught = load ptr, ptr %exc.caught, align 8
  %exc.vtbl = load ptr, ptr %caught, align 8
  %is = icmp eq ptr %exc.vtbl, @IpcError.vtable
  br i1 %is, label %catch.match, label %catch.next

catch.match:                                      ; preds = %catch.dispatch
  store ptr %caught, ptr %e, align 8
  catchret from %11 to label %catch.body

catch.next:                                       ; preds = %catch.dispatch
  catchret from %11 to label %rethrow

catch.body:                                       ; preds = %catch.match
  %ch28 = load ptr, ptr %ch, align 8
  call void @__polaron_check_live(ptr %ch28)
  %vtbl.addr29 = getelementptr inbounds %class.IpcChannel, ptr %ch28, i32 0, i32 0
  %vtbl30 = load ptr, ptr %vtbl.addr29, align 8, !tbaa !3
  %dtor.slot31 = getelementptr [358 x ptr], ptr %vtbl30, i64 0, i64 357
  %dtor.fn32 = load ptr, ptr %dtor.slot31, align 8
  %12 = icmp ne ptr %dtor.fn32, null
  br i1 %12, label %dtor.call33, label %dtor.free34

dtor.call33:                                      ; preds = %catch.body
  call void %dtor.fn32(ptr %ch28)
  br label %dtor.free34

dtor.free34:                                      ; preds = %dtor.call33, %catch.body
  call void @__polaron_free(ptr %ch28)
  %w35 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w35)
  %vtbl.addr36 = getelementptr inbounds %class.IpcWriter, ptr %w35, i32 0, i32 0
  %vtbl37 = load ptr, ptr %vtbl.addr36, align 8, !tbaa !3
  %dtor.slot38 = getelementptr [358 x ptr], ptr %vtbl37, i64 0, i64 357
  %dtor.fn39 = load ptr, ptr %dtor.slot38, align 8
  %13 = icmp ne ptr %dtor.fn39, null
  br i1 %13, label %dtor.call40, label %dtor.free41

dtor.call40:                                      ; preds = %dtor.free34
  call void %dtor.fn39(ptr %w35)
  br label %dtor.free41

dtor.free41:                                      ; preds = %dtor.call40, %dtor.free34
  call void @__polaron_free(ptr %w35)
  %BundleAccessToken.obj42 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.BundleAccessToken, ptr null, i64 1) to i64))
  %capability43 = load ptr, ptr %capability, align 8
  call void @BundleAccessToken.BundleAccessToken(ptr %BundleAccessToken.obj42, i64 0, ptr %capability43)
  ret ptr %BundleAccessToken.obj42

rethrow:                                          ; preds = %catch.next
  %rethrow.obj = load ptr, ptr %exc.caught, align 8
  store ptr %rethrow.obj, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable
}

define internal void @ProgramHandle.close(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %conn = getelementptr inbounds %class.ProgramHandle, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  call void @__polaron_ipc_close(i64 %conn1)
  ret void
}

define internal ptr @"ProgramHandle.type$StereoMixer"(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %"RemoteType$StereoMixer.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.RemoteType$StereoMixer", ptr null, i64 1) to i64))
  %conn = getelementptr inbounds %class.ProgramHandle, ptr %0, i32 0, i32 1
  %conn1 = load i64, ptr %conn, align 8, !tbaa !7
  call void @"RemoteType$StereoMixer.RemoteType$StereoMixer"(ptr %"RemoteType$StereoMixer.obj", i64 %conn1)
  ret ptr %"RemoteType$StereoMixer.obj"
}

define internal ptr @Program.connect(ptr %0) {
entry:
  %c = alloca i64, align 8
  %name = alloca ptr, align 8
  store ptr %0, ptr %name, align 8
  %name1 = load ptr, ptr %name, align 8
  %str.data = getelementptr inbounds %String, ptr %name1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %1 = call i64 @__polaron_ipc_connect(ptr %data)
  store i64 %1, ptr %c, align 8
  %c2 = load i64, ptr %c, align 8
  %2 = icmp slt i64 %c2, 0
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  ret ptr null

if.end:                                           ; preds = %entry
  %ProgramHandle.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ProgramHandle, ptr null, i64 1) to i64))
  %c3 = load i64, ptr %c, align 8
  call void @ProgramHandle.ProgramHandle(ptr %ProgramHandle.obj, i64 %c3)
  ret ptr %ProgramHandle.obj
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5412)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5414)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_sleep(i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare i32 @__CxxFrameHandler3(...)

declare void @__polaron_str_free(ptr)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i32 @strcmp(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @memset(ptr, i32, i64)

declare i64 @__polaron_subproc_spawn_ex(ptr, i64, i64)

declare i64 @__polaron_subproc_write(i64, ptr, i64)

declare ptr @__polaron_subproc_read(i64, ptr)

declare i32 @__polaron_subproc_alive(i64)

declare i32 @__polaron_subproc_can_read(i64)

declare void @__polaron_subproc_close_stdin(i64)

declare void @__polaron_subproc_close(i64)

declare i64 @__polaron_ipc_send(i64, ptr, i64)

declare ptr @__polaron_ipc_recv(i64, ptr)

declare void @__polaron_ipc_close(i64)

declare i64 @__polaron_ipc_connect(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i64", !5, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"i32", !5, i64 0}
