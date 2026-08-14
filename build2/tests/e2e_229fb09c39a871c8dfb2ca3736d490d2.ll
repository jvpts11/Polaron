; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/events.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/events.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Box = type { ptr, i32 }
%class.Signal = type { ptr, ptr, i32, i32 }
%class.IntEvent = type { ptr, ptr, i32, i32 }
%class.StringEvent = type { ptr, ptr, i32, i32 }
%class.Object = type { ptr }
%class.VoidHandler = type { ptr, ptr }
%class.IntHandler = type { ptr, ptr }
%class.StringHandler = type { ptr, ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Box.vtable = private constant [349 x ptr] [ptr @Box.add, ptr @Box.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringEvent.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringEvent.grow, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringEvent.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringEvent.emit, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringEvent.subscribe, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringHandler.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringHandler.invoke, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IntHandler.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntHandler.invoke, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@VoidHandler.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @VoidHandler.invoke, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Signal.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Signal.grow, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Signal.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Signal.emit, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Signal.subscribe, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@IntEvent.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntEvent.grow, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntEvent.count, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntEvent.emit, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @IntEvent.subscribe, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [9 x i8] c"tick %d\0A\00", align 1
@__polaron_closure = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_2, ptr null]
@.str.1 = private unnamed_addr constant [8 x i8] c"msg=%s\0A\00", align 1
@__polaron_closure.2 = private unnamed_addr constant [2 x ptr] [ptr @__polaron_lambda_3, ptr null]
@.strdata = private constant [3 x i8] c"hi\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.str.3 = private unnamed_addr constant [35 x i8] c"total=%d nsig=%d ntick=%d nmsg=%d\0A\00", align 1
@.fail.5072 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8879:70  in Signal.grow\0A\00", align 1
@.faila.5073 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5074 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5075 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8879:70  in Signal.grow\0A\00", align 1
@.faila.5076 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5077 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5078 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8886:37  in Signal.subscribe\0A\00", align 1
@.faila.5079 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5080 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5081 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8891:81  in Signal.emit\0A\00", align 1
@.faila.5082 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5083 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5084 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8914:70  in IntEvent.grow\0A\00", align 1
@.faila.5085 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5086 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5087 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8914:70  in IntEvent.grow\0A\00", align 1
@.faila.5088 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5089 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5090 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8921:37  in IntEvent.subscribe\0A\00", align 1
@.faila.5091 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5092 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5093 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8926:81  in IntEvent.emit\0A\00", align 1
@.faila.5094 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5095 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5096 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8949:70  in StringEvent.grow\0A\00", align 1
@.faila.5097 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5098 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5099 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8949:70  in StringEvent.grow\0A\00", align 1
@.faila.5100 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5101 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5102 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8956:37  in StringEvent.subscribe\0A\00", align 1
@.faila.5103 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5104 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5105 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8961:81  in StringEvent.emit\0A\00", align 1
@.faila.5106 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5107 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5311 = private constant [1 x i8] zeroinitializer
@.strobj.5312 = private global %String { i64 0, ptr @.strdata.5311, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.fail.5318 = private unnamed_addr constant [116 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8956:37  in StringEvent.subscribe#0=__polaron_lambda_3$fs\0A\00", align 1
@.faila.5319 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5320 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5321 = private unnamed_addr constant [113 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8921:37  in IntEvent.subscribe#0=__polaron_lambda_2$fs\0A\00", align 1
@.faila.5322 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5323 = private unnamed_addr constant [7 x i8] c"length\00", align 1

define internal void @Box.Box(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 0
  store ptr @Box.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  store i32 0, ptr %v, align 4, !tbaa !4
  ret void
}

define internal void @Box.add(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %v1 = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %v2 = load i32, ptr %v1, align 4, !tbaa !4
  %x3 = load i32, ptr %x, align 4
  %2 = add i32 %v2, %x3
  store i32 %2, ptr %v, align 4, !tbaa !4
  ret void
}

define internal i32 @Box.get(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %v = getelementptr inbounds %class.Box, ptr %0, i32 0, i32 1
  %v1 = load i32, ptr %v, align 4, !tbaa !4
  ret i32 %v1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %onMsg = alloca ptr, align 8
  %onTick = alloca ptr, align 8
  %onSave = alloca ptr, align 8
  %bx = alloca ptr, align 8
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
  %Box.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Box, ptr null, i64 1) to i64))
  call void @Box.Box(ptr %Box.obj)
  store ptr %Box.obj, ptr %bx, align 8
  %Signal.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Signal, ptr null, i64 1) to i64))
  call void @Signal.Signal(ptr %Signal.obj)
  store ptr %Signal.obj, ptr %onSave, align 8
  %onSave1 = load ptr, ptr %onSave, align 8
  %env = call ptr @__polaron_malloc(i64 8)
  %16 = getelementptr ptr, ptr %env, i32 0
  %cap = call ptr @__polaron_malloc(i64 8)
  %17 = load ptr, ptr %bx, align 8
  store ptr %17, ptr %cap, align 8
  store ptr %cap, ptr %16, align 8
  %closure = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_0, ptr %closure, align 8
  %18 = getelementptr ptr, ptr %closure, i32 1
  store ptr %env, ptr %18, align 8
  call void @Signal.subscribe(ptr %onSave1, ptr %closure)
  %onSave2 = load ptr, ptr %onSave, align 8
  call void @Signal.emit(ptr %onSave2)
  %onSave3 = load ptr, ptr %onSave, align 8
  call void @Signal.emit(ptr %onSave3)
  %IntEvent.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntEvent, ptr null, i64 1) to i64))
  call void @IntEvent.IntEvent(ptr %IntEvent.obj)
  store ptr %IntEvent.obj, ptr %onTick, align 8
  %onTick4 = load ptr, ptr %onTick, align 8
  %env5 = call ptr @__polaron_malloc(i64 8)
  %19 = getelementptr ptr, ptr %env5, i32 0
  %cap6 = call ptr @__polaron_malloc(i64 8)
  %20 = load ptr, ptr %bx, align 8
  store ptr %20, ptr %cap6, align 8
  store ptr %cap6, ptr %19, align 8
  %closure7 = call ptr @__polaron_malloc(i64 16)
  store ptr @__polaron_lambda_1, ptr %closure7, align 8
  %21 = getelementptr ptr, ptr %closure7, i32 1
  store ptr %env5, ptr %21, align 8
  call void @IntEvent.subscribe(ptr %onTick4, ptr %closure7)
  %onTick8 = load ptr, ptr %onTick, align 8
  call void @"IntEvent.subscribe#0=__polaron_lambda_2$fs"(ptr %onTick8, ptr @__polaron_closure)
  %onTick9 = load ptr, ptr %onTick, align 8
  call void @IntEvent.emit(ptr %onTick9, i32 5)
  %onTick10 = load ptr, ptr %onTick, align 8
  call void @IntEvent.emit(ptr %onTick10, i32 10)
  %StringEvent.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringEvent, ptr null, i64 1) to i64))
  call void @StringEvent.StringEvent(ptr %StringEvent.obj)
  store ptr %StringEvent.obj, ptr %onMsg, align 8
  %onMsg11 = load ptr, ptr %onMsg, align 8
  call void @"StringEvent.subscribe#0=__polaron_lambda_3$fs"(ptr %onMsg11, ptr @__polaron_closure.2)
  %onMsg12 = load ptr, ptr %onMsg, align 8
  call void @StringEvent.emit(ptr %onMsg12, ptr @.strobj)
  %bx13 = load ptr, ptr %bx, align 8
  %22 = call i32 @Box.get(ptr %bx13)
  %onSave14 = load ptr, ptr %onSave, align 8
  %23 = call i32 @Signal.count(ptr %onSave14)
  %onTick15 = load ptr, ptr %onTick, align 8
  %24 = call i32 @IntEvent.count(ptr %onTick15)
  %onMsg16 = load ptr, ptr %onMsg, align 8
  %25 = call i32 @StringEvent.count(ptr %onMsg16)
  %26 = call i32 (ptr, ...) @printf(ptr @.str.3, i32 %22, i32 %23, i32 %24, i32 %25)
  ret i32 0
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

define internal void @VoidHandler.VoidHandler(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  store ptr %1, ptr %f, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.VoidHandler, ptr %0, i32 0, i32 0
  store ptr @VoidHandler.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %fn = getelementptr inbounds %class.VoidHandler, ptr %0, i32 0, i32 1
  %f1 = load ptr, ptr %f, align 8
  store ptr %f1, ptr %fn, align 8, !tbaa !0
  ret void
}

define internal void @VoidHandler.invoke(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %fn = getelementptr inbounds %class.VoidHandler, ptr %0, i32 0, i32 1
  %fn1 = load ptr, ptr %fn, align 8, !tbaa !0
  %code = load ptr, ptr %fn1, align 8
  %1 = getelementptr ptr, ptr %fn1, i32 1
  %env = load ptr, ptr %1, align 8
  call void %code(ptr %env)
  ret void
}

define internal void @Signal.Signal(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 0
  store ptr @Signal.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %hs = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 1
  store ptr null, ptr %hs, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 3
  store i32 4, ptr %cap, align 4, !tbaa !4
  %hs1 = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %hs1, align 8, !tbaa !0
  %count = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @Signal.grow(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %nh = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 3
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = mul i32 %cap1, 2
  store i32 %1, ptr %nc, align 4
  %nc2 = load i32, ptr %nc, align 4
  %2 = sext i32 %nc2 to i64
  %3 = mul i64 %2, 8
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
  %count = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp slt i32 %i3, %count4
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
  %hs16 = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 1
  %nh17 = load ptr, ptr %nh, align 8
  store ptr %nh17, ptr %hs16, align 8, !tbaa !0
  %cap18 = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 3
  %nc19 = load i32, ptr %nc, align 4
  store i32 %nc19, ptr %cap18, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5072, ptr @.faila.5073, i64 %8, ptr @.failb.5074, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %nh5, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data7, i64 %8
  %hs = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 1
  %hs8 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %11 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %hs8, align 8
  %arr.oob11 = icmp uge i64 %11, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5075, ptr @.faila.5076, i64 %11, ptr @.failb.5077, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %hs8, i64 8
  %arr.elem15 = getelementptr inbounds ptr, ptr %arr.data14, i64 %11
  %elem = load ptr, ptr %arr.elem15, align 8
  %VoidHandler.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.VoidHandler, ptr null, i64 1) to i64))
  %12 = call ptr @memcpy(ptr %VoidHandler.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.VoidHandler, ptr null, i64 1) to i64))
  store ptr %VoidHandler.copy, ptr %arr.elem, align 8
  br label %for.update
}

define internal void @Signal.subscribe(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %count = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 3
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = icmp eq i32 %count1, %cap2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @Signal.grow(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %hs = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %4 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.5078, ptr @.faila.5079, i64 %4, ptr @.failb.5080, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %VoidHandler.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.VoidHandler, ptr null, i64 1) to i64))
  %h6 = load ptr, ptr %h, align 8
  call void @VoidHandler.VoidHandler(ptr %VoidHandler.obj, ptr %h6)
  store ptr %VoidHandler.obj, ptr %arr.elem, align 8
  %count7 = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count8 = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %5 = add i32 %count9, 1
  store i32 %5, ptr %count7, align 4, !tbaa !4
  ret void
}

define internal void @Signal.emit(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %count = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %1 = icmp slt i32 %i1, %count2
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %hs = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i4 = load i32, ptr %i, align 4
  %3 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %4 = load i32, ptr %i, align 4
  %5 = add i32 %4, 1
  store i32 %5, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5081, ptr @.faila.5082, i64 %3, ptr @.failb.5083, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %3
  %elem = load ptr, ptr %arr.elem, align 8
  call void @VoidHandler.invoke(ptr %elem)
  br label %for.update
}

define internal i32 @Signal.count(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.Signal, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal void @IntHandler.IntHandler(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  store ptr %1, ptr %f, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IntHandler, ptr %0, i32 0, i32 0
  store ptr @IntHandler.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %fn = getelementptr inbounds %class.IntHandler, ptr %0, i32 0, i32 1
  %f1 = load ptr, ptr %f, align 8
  store ptr %f1, ptr %fn, align 8, !tbaa !0
  ret void
}

define internal void @IntHandler.invoke(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %arg = alloca i32, align 4
  store i32 %1, ptr %arg, align 4
  %fn = getelementptr inbounds %class.IntHandler, ptr %0, i32 0, i32 1
  %fn1 = load ptr, ptr %fn, align 8, !tbaa !0
  %code = load ptr, ptr %fn1, align 8
  %2 = getelementptr ptr, ptr %fn1, i32 1
  %env = load ptr, ptr %2, align 8
  %arg2 = load i32, ptr %arg, align 4
  call void %code(ptr %env, i32 %arg2)
  ret void
}

define internal void @IntEvent.IntEvent(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 0
  store ptr @IntEvent.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %hs = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  store ptr null, ptr %hs, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 3
  store i32 4, ptr %cap, align 4, !tbaa !4
  %hs1 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %hs1, align 8, !tbaa !0
  %count = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @IntEvent.grow(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %nh = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 3
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = mul i32 %cap1, 2
  store i32 %1, ptr %nc, align 4
  %nc2 = load i32, ptr %nc, align 4
  %2 = sext i32 %nc2 to i64
  %3 = mul i64 %2, 8
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
  %count = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp slt i32 %i3, %count4
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
  %hs16 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  %nh17 = load ptr, ptr %nh, align 8
  store ptr %nh17, ptr %hs16, align 8, !tbaa !0
  %cap18 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 3
  %nc19 = load i32, ptr %nc, align 4
  store i32 %nc19, ptr %cap18, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5084, ptr @.faila.5085, i64 %8, ptr @.failb.5086, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %nh5, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data7, i64 %8
  %hs = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  %hs8 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %11 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %hs8, align 8
  %arr.oob11 = icmp uge i64 %11, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5087, ptr @.faila.5088, i64 %11, ptr @.failb.5089, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %hs8, i64 8
  %arr.elem15 = getelementptr inbounds ptr, ptr %arr.data14, i64 %11
  %elem = load ptr, ptr %arr.elem15, align 8
  %IntHandler.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntHandler, ptr null, i64 1) to i64))
  %12 = call ptr @memcpy(ptr %IntHandler.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.IntHandler, ptr null, i64 1) to i64))
  store ptr %IntHandler.copy, ptr %arr.elem, align 8
  br label %for.update
}

define internal void @IntEvent.subscribe(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %count = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 3
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = icmp eq i32 %count1, %cap2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @IntEvent.grow(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %hs = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %4 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.5090, ptr @.faila.5091, i64 %4, ptr @.failb.5092, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %IntHandler.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntHandler, ptr null, i64 1) to i64))
  %h6 = load ptr, ptr %h, align 8
  call void @IntHandler.IntHandler(ptr %IntHandler.obj, ptr %h6)
  store ptr %IntHandler.obj, ptr %arr.elem, align 8
  %count7 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count8 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %5 = add i32 %count9, 1
  store i32 %5, ptr %count7, align 4, !tbaa !4
  ret void
}

define internal void @IntEvent.emit(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %arg = alloca i32, align 4
  store i32 %1, ptr %arg, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %count = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp slt i32 %i1, %count2
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %hs = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5093, ptr @.faila.5094, i64 %4, ptr @.failb.5095, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %elem = load ptr, ptr %arr.elem, align 8
  %arg5 = load i32, ptr %arg, align 4
  call void @IntHandler.invoke(ptr %elem, i32 %arg5)
  br label %for.update
}

define internal i32 @IntEvent.count(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal void @StringHandler.StringHandler(ptr %0, ptr %1) {
entry:
  %f = alloca ptr, align 8
  store ptr %1, ptr %f, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringHandler, ptr %0, i32 0, i32 0
  store ptr @StringHandler.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %fn = getelementptr inbounds %class.StringHandler, ptr %0, i32 0, i32 1
  %f1 = load ptr, ptr %f, align 8
  store ptr %f1, ptr %fn, align 8, !tbaa !0
  ret void
}

define internal void @StringHandler.invoke(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %arg = alloca ptr, align 8
  store ptr %1, ptr %arg, align 8
  %fn = getelementptr inbounds %class.StringHandler, ptr %0, i32 0, i32 1
  %fn1 = load ptr, ptr %fn, align 8, !tbaa !0
  %code = load ptr, ptr %fn1, align 8
  %2 = getelementptr ptr, ptr %fn1, i32 1
  %env = load ptr, ptr %2, align 8
  %arg2 = load ptr, ptr %arg, align 8
  call void %code(ptr %env, ptr %arg2)
  ret void
}

define internal void @StringEvent.StringEvent(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 0
  store ptr @StringEvent.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %hs = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  store ptr null, ptr %hs, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 3
  store i32 4, ptr %cap, align 4, !tbaa !4
  %hs1 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 32)
  store ptr %arr, ptr %hs1, align 8, !tbaa !0
  %count = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @StringEvent.grow(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %i = alloca i32, align 4
  %nh = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 3
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = mul i32 %cap1, 2
  store i32 %1, ptr %nc, align 4
  %nc2 = load i32, ptr %nc, align 4
  %2 = sext i32 %nc2 to i64
  %3 = mul i64 %2, 8
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
  %count = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %6 = icmp slt i32 %i3, %count4
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
  %hs16 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  %nh17 = load ptr, ptr %nh, align 8
  store ptr %nh17, ptr %hs16, align 8, !tbaa !0
  %cap18 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 3
  %nc19 = load i32, ptr %nc, align 4
  store i32 %nc19, ptr %cap18, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5096, ptr @.faila.5097, i64 %8, ptr @.failb.5098, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %nh5, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data7, i64 %8
  %hs = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  %hs8 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %11 = sext i32 %i9 to i64
  %arr.len10 = load i64, ptr %hs8, align 8
  %arr.oob11 = icmp uge i64 %11, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !8

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5099, ptr @.faila.5100, i64 %11, ptr @.failb.5101, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %hs8, i64 8
  %arr.elem15 = getelementptr inbounds ptr, ptr %arr.data14, i64 %11
  %elem = load ptr, ptr %arr.elem15, align 8
  %StringHandler.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringHandler, ptr null, i64 1) to i64))
  %12 = call ptr @memcpy(ptr %StringHandler.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.StringHandler, ptr null, i64 1) to i64))
  store ptr %StringHandler.copy, ptr %arr.elem, align 8
  br label %for.update
}

define internal void @StringEvent.subscribe(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %count = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 3
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = icmp eq i32 %count1, %cap2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @StringEvent.grow(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %hs = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %4 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.5102, ptr @.faila.5103, i64 %4, ptr @.failb.5104, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %StringHandler.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringHandler, ptr null, i64 1) to i64))
  %h6 = load ptr, ptr %h, align 8
  call void @StringHandler.StringHandler(ptr %StringHandler.obj, ptr %h6)
  store ptr %StringHandler.obj, ptr %arr.elem, align 8
  %count7 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count8 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %5 = add i32 %count9, 1
  store i32 %5, ptr %count7, align 4, !tbaa !4
  ret void
}

define internal void @StringEvent.emit(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %arg = alloca ptr, align 8
  store ptr %1, ptr %arg, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %count = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count2 = load i32, ptr %count, align 4, !tbaa !4
  %2 = icmp slt i32 %i1, %count2
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %hs = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5105, ptr @.faila.5106, i64 %4, ptr @.failb.5107, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %elem = load ptr, ptr %arr.elem, align 8
  %arg5 = load ptr, ptr %arg, align 8
  call void @StringHandler.invoke(ptr %elem, ptr %arg5)
  br label %for.update
}

define internal i32 @StringEvent.count(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5312)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

define internal void @__polaron_lambda_0(ptr %0) {
entry:
  %1 = getelementptr ptr, ptr %0, i32 0
  %bx = load ptr, ptr %1, align 8
  %bx1 = load ptr, ptr %bx, align 8
  call void @Box.add(ptr %bx1, i32 1)
  ret void
}

define internal void @__polaron_lambda_1(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %2 = getelementptr ptr, ptr %0, i32 0
  %bx = load ptr, ptr %2, align 8
  %bx1 = load ptr, ptr %bx, align 8
  %x2 = load i32, ptr %x, align 4
  call void @Box.add(ptr %bx1, i32 %x2)
  ret void
}

define internal void @__polaron_lambda_2(ptr %0, i32 %1) {
entry:
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %2 = call i32 (ptr, ...) @printf(ptr @.str, i32 %x1)
  ret void
}

declare i32 @printf(ptr, ...)

define internal void @"IntEvent.subscribe#0=__polaron_lambda_2$fs"(ptr %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %count = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 3
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = icmp eq i32 %count1, %cap2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @IntEvent.grow(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %hs = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %4 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.5321, ptr @.faila.5322, i64 %4, ptr @.failb.5323, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %IntHandler.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.IntHandler, ptr null, i64 1) to i64))
  %h6 = load ptr, ptr %h, align 8
  call void @IntHandler.IntHandler(ptr %IntHandler.obj, ptr %h6)
  store ptr %IntHandler.obj, ptr %arr.elem, align 8
  %count7 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count8 = getelementptr inbounds %class.IntEvent, ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %5 = add i32 %count9, 1
  store i32 %5, ptr %count7, align 4, !tbaa !4
  ret void
}

define internal void @__polaron_lambda_3(ptr %0, ptr %1) {
entry:
  %m = alloca ptr, align 8
  store ptr %1, ptr %m, align 8
  %m1 = load ptr, ptr %m, align 8
  %str.data = getelementptr inbounds %String, ptr %m1, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %2 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data)
  ret void
}

define internal void @"StringEvent.subscribe#0=__polaron_lambda_3$fs"(ptr %0, ptr %1) {
entry:
  %h = alloca ptr, align 8
  store ptr %1, ptr %h, align 8
  %count = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 3
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %2 = icmp eq i32 %count1, %cap2
  %3 = zext i1 %2 to i32
  br i1 %2, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @StringEvent.grow(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %hs = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 1
  %hs3 = load ptr, ptr %hs, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %4 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %hs3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.5318, ptr @.faila.5319, i64 %4, ptr @.failb.5320, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %hs3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %4
  %StringHandler.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringHandler, ptr null, i64 1) to i64))
  %h6 = load ptr, ptr %h, align 8
  call void @StringHandler.StringHandler(ptr %StringHandler.obj, ptr %h6)
  store ptr %StringHandler.obj, ptr %arr.elem, align 8
  %count7 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count8 = getelementptr inbounds %class.StringEvent, ptr %0, i32 0, i32 2
  %count9 = load i32, ptr %count8, align 4, !tbaa !4
  %5 = add i32 %count9, 1
  store i32 %5, ptr %count7, align 4, !tbaa !4
  ret void
}

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

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
