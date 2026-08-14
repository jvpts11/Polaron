; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ecs_world.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/ecs_world.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Position = type { ptr, i32, i32 }
%class.Velocity = type { ptr, i32, i32 }
%class.World = type { ptr, ptr, ptr, i32, i32, i32, i32 }
%"class.ComponentStore$Position" = type { ptr, ptr, ptr, ptr, i32, i32 }
%"class.ComponentStore$Velocity" = type { ptr, ptr, ptr, ptr, i32, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Velocity.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr @Velocity.getDx, ptr @Velocity.getDy, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Position.vtable = private constant [353 x ptr] [ptr @Position.getX, ptr @Position.getY, ptr @Position.moved, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ComponentStore$Velocity.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ComponentStore$Velocity.size", ptr null, ptr null, ptr @"ComponentStore$Velocity.grow", ptr null, ptr @"ComponentStore$Velocity.get", ptr null, ptr null, ptr null, ptr @"ComponentStore$Velocity.remove", ptr null, ptr null, ptr @"ComponentStore$Velocity.add", ptr @"ComponentStore$Velocity.has", ptr @"ComponentStore$Velocity.set", ptr @"ComponentStore$Velocity.entityAt", ptr @"ComponentStore$Velocity.at", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"ComponentStore$Position.vtable" = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ComponentStore$Position.size", ptr null, ptr null, ptr @"ComponentStore$Position.grow", ptr null, ptr @"ComponentStore$Position.get", ptr null, ptr null, ptr null, ptr @"ComponentStore$Position.remove", ptr null, ptr null, ptr @"ComponentStore$Position.add", ptr @"ComponentStore$Position.has", ptr @"ComponentStore$Position.set", ptr @"ComponentStore$Position.entityAt", ptr @"ComponentStore$Position.at", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@World.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @World.size, ptr null, ptr null, ptr @World.grow, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @World.isAlive, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @World.createEntity, ptr @World.destroyEntity, ptr @World.capacity, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [44 x i8] c"a=%d,%d c=%d,%d size=%d bDead=%d dReuse=%d\0A\00", align 1
@.fail.672 = private unnamed_addr constant [118 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9034:80  in ComponentStore$Velocity.ComponentStore$Velocity\0A\00", align 1
@.faila.673 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.674 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.675 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9045:27  in ComponentStore$Velocity.grow\0A\00", align 1
@.faila.676 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.677 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.678 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9045:27  in ComponentStore$Velocity.grow\0A\00", align 1
@.faila.679 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.680 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.681 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9046:27  in ComponentStore$Velocity.grow\0A\00", align 1
@.faila.682 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.683 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.684 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9046:27  in ComponentStore$Velocity.grow\0A\00", align 1
@.faila.685 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.686 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.687 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9055:40  in ComponentStore$Velocity.add\0A\00", align 1
@.faila.688 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.689 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.690 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9056:46  in ComponentStore$Velocity.add\0A\00", align 1
@.faila.691 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.692 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.693 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9057:32  in ComponentStore$Velocity.add\0A\00", align 1
@.faila.694 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.695 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.696 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9061:56  in ComponentStore$Velocity.has\0A\00", align 1
@.faila.697 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.698 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.699 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9062:50  in ComponentStore$Velocity.get\0A\00", align 1
@.faila.700 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.701 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.702 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9062:50  in ComponentStore$Velocity.get\0A\00", align 1
@.faila.703 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.704 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.705 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9064:44  in ComponentStore$Velocity.set\0A\00", align 1
@.faila.706 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.707 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.708 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9064:44  in ComponentStore$Velocity.set\0A\00", align 1
@.faila.709 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.710 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.711 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9068:17  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.712 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.713 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.714 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9071:33  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.715 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.716 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.717 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9071:33  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.718 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.719 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.720 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9072:39  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.721 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.722 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.723 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9072:39  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.724 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.725 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.726 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9073:53  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.727 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.728 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.729 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9073:53  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.730 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.731 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.732 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9074:32  in ComponentStore$Velocity.remove\0A\00", align 1
@.faila.733 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.734 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.735 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9079:57  in ComponentStore$Velocity.entityAt\0A\00", align 1
@.faila.736 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.737 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.738 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9080:49  in ComponentStore$Velocity.at\0A\00", align 1
@.faila.739 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.740 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.741 = private unnamed_addr constant [118 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9034:80  in ComponentStore$Position.ComponentStore$Position\0A\00", align 1
@.faila.742 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.743 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.744 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9045:27  in ComponentStore$Position.grow\0A\00", align 1
@.faila.745 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.746 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.747 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9045:27  in ComponentStore$Position.grow\0A\00", align 1
@.faila.748 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.749 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.750 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9046:27  in ComponentStore$Position.grow\0A\00", align 1
@.faila.751 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.752 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.753 = private unnamed_addr constant [99 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9046:27  in ComponentStore$Position.grow\0A\00", align 1
@.faila.754 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.755 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.756 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9055:40  in ComponentStore$Position.add\0A\00", align 1
@.faila.757 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.758 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.759 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9056:46  in ComponentStore$Position.add\0A\00", align 1
@.faila.760 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.761 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.762 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9057:32  in ComponentStore$Position.add\0A\00", align 1
@.faila.763 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.764 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.765 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9061:56  in ComponentStore$Position.has\0A\00", align 1
@.faila.766 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.767 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.768 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9062:50  in ComponentStore$Position.get\0A\00", align 1
@.faila.769 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.770 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.771 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9062:50  in ComponentStore$Position.get\0A\00", align 1
@.faila.772 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.773 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.774 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9064:44  in ComponentStore$Position.set\0A\00", align 1
@.faila.775 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.776 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.777 = private unnamed_addr constant [98 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9064:44  in ComponentStore$Position.set\0A\00", align 1
@.faila.778 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.779 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.780 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9068:17  in ComponentStore$Position.remove\0A\00", align 1
@.faila.781 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.782 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.783 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9071:33  in ComponentStore$Position.remove\0A\00", align 1
@.faila.784 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.785 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.786 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9071:33  in ComponentStore$Position.remove\0A\00", align 1
@.faila.787 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.788 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.789 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9072:39  in ComponentStore$Position.remove\0A\00", align 1
@.faila.790 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.791 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.792 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9072:39  in ComponentStore$Position.remove\0A\00", align 1
@.faila.793 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.794 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.795 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9073:53  in ComponentStore$Position.remove\0A\00", align 1
@.faila.796 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.797 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.798 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9073:53  in ComponentStore$Position.remove\0A\00", align 1
@.faila.799 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.800 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.801 = private unnamed_addr constant [101 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9074:32  in ComponentStore$Position.remove\0A\00", align 1
@.faila.802 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.803 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.804 = private unnamed_addr constant [103 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9079:57  in ComponentStore$Position.entityAt\0A\00", align 1
@.faila.805 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.806 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.807 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9080:49  in ComponentStore$Position.at\0A\00", align 1
@.faila.808 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.809 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5240 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8989:68  in World.grow\0A\00", align 1
@.faila.5241 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5242 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5243 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8989:68  in World.grow\0A\00", align 1
@.faila.5244 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5245 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5246 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8990:74  in World.grow\0A\00", align 1
@.faila.5247 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5248 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5249 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8990:74  in World.grow\0A\00", align 1
@.faila.5250 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5251 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5252 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8999:24  in World.createEntity\0A\00", align 1
@.faila.5253 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5254 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5255 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9006:32  in World.createEntity\0A\00", align 1
@.faila.5256 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5257 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5258 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9011:17  in World.destroyEntity\0A\00", align 1
@.faila.5259 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5260 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5261 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9012:35  in World.destroyEntity\0A\00", align 1
@.faila.5262 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5263 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5264 = private unnamed_addr constant [90 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9013:51  in World.destroyEntity\0A\00", align 1
@.faila.5265 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5266 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.5267 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:9019:60  in World.isAlive\0A\00", align 1
@.faila.5268 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.5269 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5443 = private constant [1 x i8] zeroinitializer
@.strobj.5444 = private global %String { i64 0, ptr @.strdata.5443, i64 0 }
@.strdata.5445 = private constant [1 x i8] zeroinitializer
@.strobj.5446 = private global %String { i64 0, ptr @.strdata.5445, i64 0 }

define internal void @Position.Position(ptr %0, i32 %1, i32 %2) {
entry:
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  store i32 %2, ptr %y, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 0
  store ptr @Position.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %x1 = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 1
  %x2 = load i32, ptr %x, align 4
  store i32 %x2, ptr %x1, align 4, !tbaa !4
  %y3 = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 2
  %y4 = load i32, ptr %y, align 4
  store i32 %y4, ptr %y3, align 4, !tbaa !4
  ret void
}

define internal i32 @Position.getX(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %x = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 1
  %x1 = load i32, ptr %x, align 4, !tbaa !4
  ret i32 %x1
}

define internal i32 @Position.getY(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %y = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 2
  %y1 = load i32, ptr %y, align 4, !tbaa !4
  ret i32 %y1
}

define internal ptr @Position.moved(ptr nonnull align 8 dereferenceable(16) %0, i32 %1, i32 %2) {
entry:
  %dy = alloca i32, align 4
  %dx = alloca i32, align 4
  store i32 %1, ptr %dx, align 4
  store i32 %2, ptr %dy, align 4
  %Position.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  %x = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 1
  %x1 = load i32, ptr %x, align 4, !tbaa !4
  %dx2 = load i32, ptr %dx, align 4
  %3 = add i32 %x1, %dx2
  %y = getelementptr inbounds %class.Position, ptr %0, i32 0, i32 2
  %y3 = load i32, ptr %y, align 4, !tbaa !4
  %dy4 = load i32, ptr %dy, align 4
  %4 = add i32 %y3, %dy4
  call void @Position.Position(ptr %Position.obj, i32 %3, i32 %4)
  ret ptr %Position.obj
}

define internal void @Velocity.Velocity(ptr %0, i32 %1, i32 %2) {
entry:
  %dy = alloca i32, align 4
  %dx = alloca i32, align 4
  store i32 %1, ptr %dx, align 4
  store i32 %2, ptr %dy, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Velocity, ptr %0, i32 0, i32 0
  store ptr @Velocity.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %dx1 = getelementptr inbounds %class.Velocity, ptr %0, i32 0, i32 1
  %dx2 = load i32, ptr %dx, align 4
  store i32 %dx2, ptr %dx1, align 4, !tbaa !4
  %dy3 = getelementptr inbounds %class.Velocity, ptr %0, i32 0, i32 2
  %dy4 = load i32, ptr %dy, align 4
  store i32 %dy4, ptr %dy3, align 4, !tbaa !4
  ret void
}

define internal i32 @Velocity.getDx(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %dx = getelementptr inbounds %class.Velocity, ptr %0, i32 0, i32 1
  %dx1 = load i32, ptr %dx, align 4, !tbaa !4
  ret i32 %dx1
}

define internal i32 @Velocity.getDy(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %dy = getelementptr inbounds %class.Velocity, ptr %0, i32 0, i32 2
  %dy1 = load i32, ptr %dy, align 4, !tbaa !4
  ret i32 %dy1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %pc = alloca ptr, align 8
  %pa = alloca ptr, align 8
  %reuse = alloca i32, align 4
  %d = alloca i32, align 4
  %bDead = alloca i32, align 4
  %v = alloca ptr, align 8
  %p = alloca ptr, align 8
  %e = alloca i32, align 4
  %i = alloca i32, align 4
  %c = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %vel = alloca ptr, align 8
  %pos = alloca ptr, align 8
  %w = alloca ptr, align 8
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
  %World.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.World, ptr null, i64 1) to i64))
  call void @World.World(ptr %World.obj)
  store ptr %World.obj, ptr %w, align 8
  %"ComponentStore$Position.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ComponentStore$Position", ptr null, i64 1) to i64))
  call void @"ComponentStore$Position.ComponentStore$Position"(ptr %"ComponentStore$Position.obj", i32 64)
  store ptr %"ComponentStore$Position.obj", ptr %pos, align 8
  %"ComponentStore$Velocity.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ComponentStore$Velocity", ptr null, i64 1) to i64))
  call void @"ComponentStore$Velocity.ComponentStore$Velocity"(ptr %"ComponentStore$Velocity.obj", i32 64)
  store ptr %"ComponentStore$Velocity.obj", ptr %vel, align 8
  %w1 = load ptr, ptr %w, align 8
  %16 = call i32 @World.createEntity(ptr %w1)
  store i32 %16, ptr %a, align 4
  %w2 = load ptr, ptr %w, align 8
  %17 = call i32 @World.createEntity(ptr %w2)
  store i32 %17, ptr %b, align 4
  %w3 = load ptr, ptr %w, align 8
  %18 = call i32 @World.createEntity(ptr %w3)
  store i32 %18, ptr %c, align 4
  %pos4 = load ptr, ptr %pos, align 8
  %a5 = load i32, ptr %a, align 4
  %Position.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  call void @Position.Position(ptr %Position.obj, i32 0, i32 0)
  call void @"ComponentStore$Position.add"(ptr %pos4, i32 %a5, ptr %Position.obj)
  call void @__polaron_check_live(ptr %Position.obj)
  %vtbl.addr = getelementptr inbounds %class.Position, ptr %Position.obj, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [353 x ptr], ptr %vtbl, i64 0, i64 352
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %19 = icmp ne ptr %dtor.fn, null
  br i1 %19, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %Position.obj)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  call void @__polaron_free(ptr %Position.obj)
  %pos6 = load ptr, ptr %pos, align 8
  %b7 = load i32, ptr %b, align 4
  %Position.obj8 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  call void @Position.Position(ptr %Position.obj8, i32 10, i32 10)
  call void @"ComponentStore$Position.add"(ptr %pos6, i32 %b7, ptr %Position.obj8)
  call void @__polaron_check_live(ptr %Position.obj8)
  %vtbl.addr9 = getelementptr inbounds %class.Position, ptr %Position.obj8, i32 0, i32 0
  %vtbl10 = load ptr, ptr %vtbl.addr9, align 8, !tbaa !0
  %dtor.slot11 = getelementptr [353 x ptr], ptr %vtbl10, i64 0, i64 352
  %dtor.fn12 = load ptr, ptr %dtor.slot11, align 8
  %20 = icmp ne ptr %dtor.fn12, null
  br i1 %20, label %dtor.call13, label %dtor.free14

dtor.call13:                                      ; preds = %dtor.free
  call void %dtor.fn12(ptr %Position.obj8)
  br label %dtor.free14

dtor.free14:                                      ; preds = %dtor.call13, %dtor.free
  call void @__polaron_free(ptr %Position.obj8)
  %pos15 = load ptr, ptr %pos, align 8
  %c16 = load i32, ptr %c, align 4
  %Position.obj17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  call void @Position.Position(ptr %Position.obj17, i32 5, i32 5)
  call void @"ComponentStore$Position.add"(ptr %pos15, i32 %c16, ptr %Position.obj17)
  call void @__polaron_check_live(ptr %Position.obj17)
  %vtbl.addr18 = getelementptr inbounds %class.Position, ptr %Position.obj17, i32 0, i32 0
  %vtbl19 = load ptr, ptr %vtbl.addr18, align 8, !tbaa !0
  %dtor.slot20 = getelementptr [353 x ptr], ptr %vtbl19, i64 0, i64 352
  %dtor.fn21 = load ptr, ptr %dtor.slot20, align 8
  %21 = icmp ne ptr %dtor.fn21, null
  br i1 %21, label %dtor.call22, label %dtor.free23

dtor.call22:                                      ; preds = %dtor.free14
  call void %dtor.fn21(ptr %Position.obj17)
  br label %dtor.free23

dtor.free23:                                      ; preds = %dtor.call22, %dtor.free14
  call void @__polaron_free(ptr %Position.obj17)
  %vel24 = load ptr, ptr %vel, align 8
  %a25 = load i32, ptr %a, align 4
  %Velocity.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  call void @Velocity.Velocity(ptr %Velocity.obj, i32 1, i32 2)
  call void @"ComponentStore$Velocity.add"(ptr %vel24, i32 %a25, ptr %Velocity.obj)
  call void @__polaron_check_live(ptr %Velocity.obj)
  %vtbl.addr26 = getelementptr inbounds %class.Velocity, ptr %Velocity.obj, i32 0, i32 0
  %vtbl27 = load ptr, ptr %vtbl.addr26, align 8, !tbaa !0
  %dtor.slot28 = getelementptr [353 x ptr], ptr %vtbl27, i64 0, i64 352
  %dtor.fn29 = load ptr, ptr %dtor.slot28, align 8
  %22 = icmp ne ptr %dtor.fn29, null
  br i1 %22, label %dtor.call30, label %dtor.free31

dtor.call30:                                      ; preds = %dtor.free23
  call void %dtor.fn29(ptr %Velocity.obj)
  br label %dtor.free31

dtor.free31:                                      ; preds = %dtor.call30, %dtor.free23
  call void @__polaron_free(ptr %Velocity.obj)
  %vel32 = load ptr, ptr %vel, align 8
  %c33 = load i32, ptr %c, align 4
  %Velocity.obj34 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  call void @Velocity.Velocity(ptr %Velocity.obj34, i32 -1, i32 -1)
  call void @"ComponentStore$Velocity.add"(ptr %vel32, i32 %c33, ptr %Velocity.obj34)
  call void @__polaron_check_live(ptr %Velocity.obj34)
  %vtbl.addr35 = getelementptr inbounds %class.Velocity, ptr %Velocity.obj34, i32 0, i32 0
  %vtbl36 = load ptr, ptr %vtbl.addr35, align 8, !tbaa !0
  %dtor.slot37 = getelementptr [353 x ptr], ptr %vtbl36, i64 0, i64 352
  %dtor.fn38 = load ptr, ptr %dtor.slot37, align 8
  %23 = icmp ne ptr %dtor.fn38, null
  br i1 %23, label %dtor.call39, label %dtor.free40

dtor.call39:                                      ; preds = %dtor.free31
  call void %dtor.fn38(ptr %Velocity.obj34)
  br label %dtor.free40

dtor.free40:                                      ; preds = %dtor.call39, %dtor.free31
  call void @__polaron_free(ptr %Velocity.obj34)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %dtor.free40
  %i41 = load i32, ptr %i, align 4
  %pos42 = load ptr, ptr %pos, align 8
  %24 = call i32 @"ComponentStore$Position.size"(ptr %pos42)
  %25 = icmp slt i32 %i41, %24
  %26 = zext i1 %25 to i32
  br i1 %25, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %pos43 = load ptr, ptr %pos, align 8
  %i44 = load i32, ptr %i, align 4
  %27 = call i32 @"ComponentStore$Position.entityAt"(ptr %pos43, i32 %i44)
  store i32 %27, ptr %e, align 4
  %vel45 = load ptr, ptr %vel, align 8
  %e46 = load i32, ptr %e, align 4
  %28 = call i32 @"ComponentStore$Velocity.has"(ptr %vel45, i32 %e46)
  %29 = icmp ne i32 %28, 0
  br i1 %29, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %30 = load i32, ptr %i, align 4
  %31 = add i32 %30, 1
  store i32 %31, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %w56 = load ptr, ptr %w, align 8
  %b57 = load i32, ptr %b, align 4
  call void @World.destroyEntity(ptr %w56, i32 %b57)
  %w58 = load ptr, ptr %w, align 8
  %b59 = load i32, ptr %b, align 4
  %32 = call i32 @World.isAlive(ptr %w58, i32 %b59)
  store i32 %32, ptr %bDead, align 4
  %w60 = load ptr, ptr %w, align 8
  %33 = call i32 @World.createEntity(ptr %w60)
  store i32 %33, ptr %d, align 4
  store i32 0, ptr %reuse, align 4
  %d61 = load i32, ptr %d, align 4
  %b62 = load i32, ptr %b, align 4
  %34 = icmp eq i32 %d61, %b62
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then63, label %if.end64

if.then:                                          ; preds = %for.body
  %pos47 = load ptr, ptr %pos, align 8
  %e48 = load i32, ptr %e, align 4
  %36 = call ptr @"ComponentStore$Position.get"(ptr %pos47, i32 %e48)
  store ptr %36, ptr %p, align 8
  %vel49 = load ptr, ptr %vel, align 8
  %e50 = load i32, ptr %e, align 4
  %37 = call ptr @"ComponentStore$Velocity.get"(ptr %vel49, i32 %e50)
  store ptr %37, ptr %v, align 8
  %pos51 = load ptr, ptr %pos, align 8
  %e52 = load i32, ptr %e, align 4
  %p53 = load ptr, ptr %p, align 8
  %v54 = load ptr, ptr %v, align 8
  %38 = call i32 @Velocity.getDx(ptr %v54)
  %v55 = load ptr, ptr %v, align 8
  %39 = call i32 @Velocity.getDy(ptr %v55)
  %40 = call ptr @Position.moved(ptr %p53, i32 %38, i32 %39)
  call void @"ComponentStore$Position.set"(ptr %pos51, i32 %e52, ptr %40)
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.update

if.then63:                                        ; preds = %for.end
  store i32 1, ptr %reuse, align 4
  br label %if.end64

if.end64:                                         ; preds = %if.then63, %for.end
  %pos65 = load ptr, ptr %pos, align 8
  %a66 = load i32, ptr %a, align 4
  %41 = call ptr @"ComponentStore$Position.get"(ptr %pos65, i32 %a66)
  store ptr %41, ptr %pa, align 8
  %pos67 = load ptr, ptr %pos, align 8
  %c68 = load i32, ptr %c, align 4
  %42 = call ptr @"ComponentStore$Position.get"(ptr %pos67, i32 %c68)
  store ptr %42, ptr %pc, align 8
  %pa69 = load ptr, ptr %pa, align 8
  %43 = call i32 @Position.getX(ptr %pa69)
  %pa70 = load ptr, ptr %pa, align 8
  %44 = call i32 @Position.getY(ptr %pa70)
  %pc71 = load ptr, ptr %pc, align 8
  %45 = call i32 @Position.getX(ptr %pc71)
  %pc72 = load ptr, ptr %pc, align 8
  %46 = call i32 @Position.getY(ptr %pc72)
  %w73 = load ptr, ptr %w, align 8
  %47 = call i32 @World.size(ptr %w73)
  %bDead74 = load i32, ptr %bDead, align 4
  %reuse75 = load i32, ptr %reuse, align 4
  %48 = call i32 (ptr, ...) @printf(ptr @.str, i32 %43, i32 %44, i32 %45, i32 %46, i32 %47, i32 %bDead74, i32 %reuse75)
  ret i32 0
}

define internal void @"ComponentStore$Velocity.ComponentStore$Velocity"(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %maxEntities = alloca i32, align 4
  store i32 %1, ptr %maxEntities, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 0
  store ptr @"ComponentStore$Velocity.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  store ptr null, ptr %dense, align 8, !tbaa !0
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  store ptr null, ptr %denseEntity, align 8, !tbaa !0
  %sparse = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  store ptr null, ptr %sparse, align 8, !tbaa !0
  %sparse1 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %maxEntities2 = load i32, ptr %maxEntities, align 4
  %2 = sext i32 %maxEntities2 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %sparse1, align 8, !tbaa !0
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %maxEntities4 = load i32, ptr %maxEntities, align 4
  %6 = icmp slt i32 %i3, %maxEntities4
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sparse5 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse6 = load ptr, ptr %sparse5, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %sparse6, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dense9 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %arr10 = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr10, align 8
  %arr.data11 = getelementptr i8, ptr %arr10, i64 8
  %11 = call ptr @memset(ptr %arr.data11, i32 0, i64 64)
  store ptr %arr10, ptr %dense9, align 8, !tbaa !0
  %denseEntity12 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %arr13 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr13, align 8
  %arr.data14 = getelementptr i8, ptr %arr13, i64 8
  %12 = call ptr @memset(ptr %arr.data14, i32 0, i64 32)
  store ptr %arr13, ptr %denseEntity12, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.672, ptr @.faila.673, i64 %8, ptr @.failb.674, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %sparse6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %8
  store i32 -1, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @"ComponentStore$Velocity.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %ne = alloca ptr, align 8
  %nd = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 5
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
  store ptr %arr, ptr %nd, align 8
  %nc3 = load i32, ptr %nc, align 4
  %6 = sext i32 %nc3 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr4 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %9 = call ptr @memset(ptr %arr.data5, i32 0, i64 %7)
  store ptr %arr4, ptr %ne, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count7 = load i32, ptr %count, align 4, !tbaa !4
  %10 = icmp slt i32 %i6, %count7
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nd8 = load ptr, ptr %nd, align 8, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %12 = sext i32 %i9 to i64
  %arr.len = load i64, ptr %nd8, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok32
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dense36 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %nd37 = load ptr, ptr %nd, align 8
  store ptr %nd37, ptr %dense36, align 8, !tbaa !0
  %denseEntity38 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %ne39 = load ptr, ptr %ne, align 8
  store ptr %ne39, ptr %denseEntity38, align 8, !tbaa !0
  %cap40 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 5
  %nc41 = load i32, ptr %nc, align 4
  store i32 %nc41, ptr %cap40, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.675, ptr @.faila.676, i64 %12, ptr @.failb.677, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data10 = getelementptr i8, ptr %nd8, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data10, i64 %12
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense11 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %15 = sext i32 %i12 to i64
  %arr.len13 = load i64, ptr %dense11, align 8
  %arr.oob14 = icmp uge i64 %15, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !8

idx.bad15:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.678, ptr @.faila.679, i64 %15, ptr @.failb.680, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok
  %arr.data17 = getelementptr i8, ptr %dense11, i64 8
  %arr.elem18 = getelementptr inbounds ptr, ptr %arr.data17, i64 %15
  %elem = load ptr, ptr %arr.elem18, align 8
  %Velocity.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Velocity.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  store ptr %Velocity.copy, ptr %arr.elem, align 8
  %ne19 = load ptr, ptr %ne, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %17 = sext i32 %i20 to i64
  %arr.len21 = load i64, ptr %ne19, align 8
  %arr.oob22 = icmp uge i64 %17, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

idx.bad23:                                        ; preds = %idx.ok16
  call void @__polaron_fail(ptr @.fail.681, ptr @.faila.682, i64 %17, ptr @.failb.683, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok16
  %arr.data25 = getelementptr i8, ptr %ne19, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 %17
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %denseEntity27 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i28 = load i32, ptr %i, align 4
  %18 = sext i32 %i28 to i64
  %arr.len29 = load i64, ptr %denseEntity27, align 8
  %arr.oob30 = icmp uge i64 %18, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !8

idx.bad31:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.684, ptr @.faila.685, i64 %18, ptr @.failb.686, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok24
  %arr.data33 = getelementptr i8, ptr %denseEntity27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %18
  %elem35 = load i32, ptr %arr.elem34, align 4
  store i32 %elem35, ptr %arr.elem26, align 4
  br label %for.update
}

define internal void @"ComponentStore$Velocity.add"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2) {
entry:
  %Velocity.copy = alloca %class.Velocity, align 8
  %component = alloca ptr, align 8
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %3 = call ptr @memcpy(ptr %Velocity.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  store ptr %Velocity.copy, ptr %component, align 8
  %count = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 5
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp eq i32 %count1, %cap2
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"ComponentStore$Velocity.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense3 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %6 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %dense3, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.687, ptr @.faila.688, i64 %6, ptr @.failb.689, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %dense3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %6
  %component6 = load ptr, ptr %component, align 8
  %Velocity.copy7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  %7 = call ptr @memcpy(ptr %Velocity.copy7, ptr %component6, i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  store ptr %Velocity.copy7, ptr %arr.elem, align 8
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %denseEntity8 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count9 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %8 = sext i32 %count10 to i64
  %arr.len11 = load i64, ptr %denseEntity8, align 8
  %arr.oob12 = icmp uge i64 %8, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !8

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.690, ptr @.faila.691, i64 %8, ptr @.failb.692, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %denseEntity8, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %8
  %e17 = load i32, ptr %e, align 4
  store i32 %e17, ptr %arr.elem16, align 4
  %sparse = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse18 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e19 = load i32, ptr %e, align 4
  %9 = sext i32 %e19 to i64
  %arr.len20 = load i64, ptr %sparse18, align 8
  %arr.oob21 = icmp uge i64 %9, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.693, ptr @.faila.694, i64 %9, ptr @.failb.695, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok14
  %arr.data24 = getelementptr i8, ptr %sparse18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %9
  %count26 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  store i32 %count27, ptr %arr.elem25, align 4
  %count28 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count29 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %10 = add i32 %count30, 1
  store i32 %10, ptr %count28, align 4, !tbaa !4
  ret void
}

define internal i32 @"ComponentStore$Velocity.has"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %sparse = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse1 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e2 = load i32, ptr %e, align 4
  %2 = sext i32 %e2 to i64
  %arr.len = load i64, ptr %sparse1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.696, ptr @.faila.697, i64 %2, ptr @.failb.698, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  %3 = icmp sge i32 %elem, 0
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal ptr @"ComponentStore$Velocity.get"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense1 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sparse = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse2 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e3 = load i32, ptr %e, align 4
  %2 = sext i32 %e3 to i64
  %arr.len = load i64, ptr %sparse2, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.699, ptr @.faila.700, i64 %2, ptr @.failb.701, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  %3 = sext i32 %elem to i64
  %arr.len4 = load i64, ptr %dense1, align 8
  %arr.oob5 = icmp uge i64 %3, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !8

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.702, ptr @.faila.703, i64 %3, ptr @.failb.704, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %dense1, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 %3
  %elem10 = load ptr, ptr %arr.elem9, align 8
  ret ptr %elem10
}

define internal void @"ComponentStore$Velocity.set"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2) {
entry:
  %Velocity.copy = alloca %class.Velocity, align 8
  %component = alloca ptr, align 8
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %3 = call ptr @memcpy(ptr %Velocity.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  store ptr %Velocity.copy, ptr %component, align 8
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense1 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sparse = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse2 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e3 = load i32, ptr %e, align 4
  %4 = sext i32 %e3 to i64
  %arr.len = load i64, ptr %sparse2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.705, ptr @.faila.706, i64 %4, ptr @.failb.707, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %5 = sext i32 %elem to i64
  %arr.len4 = load i64, ptr %dense1, align 8
  %arr.oob5 = icmp uge i64 %5, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !8

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.708, ptr @.faila.709, i64 %5, ptr @.failb.710, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %dense1, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 %5
  %component10 = load ptr, ptr %component, align 8
  %Velocity.copy11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  %6 = call ptr @memcpy(ptr %Velocity.copy11, ptr %component10, i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  store ptr %Velocity.copy11, ptr %arr.elem9, align 8
  ret void
}

define internal void @"ComponentStore$Velocity.remove"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %last = alloca i32, align 4
  %idx = alloca i32, align 4
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %sparse = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse1 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e2 = load i32, ptr %e, align 4
  %2 = sext i32 %e2 to i64
  %arr.len = load i64, ptr %sparse1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.711, ptr @.faila.712, i64 %2, ptr @.failb.713, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %idx, align 4
  %idx3 = load i32, ptr %idx, align 4
  %3 = icmp slt i32 %idx3, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret void

if.end:                                           ; preds = %idx.ok
  %count = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %5 = sub i32 %count4, 1
  store i32 %5, ptr %last, align 4
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense5 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %idx6 = load i32, ptr %idx, align 4
  %6 = sext i32 %idx6 to i64
  %arr.len7 = load i64, ptr %dense5, align 8
  %arr.oob8 = icmp uge i64 %6, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !8

idx.bad9:                                         ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.714, ptr @.faila.715, i64 %6, ptr @.failb.716, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %if.end
  %arr.data11 = getelementptr i8, ptr %dense5, i64 8
  %arr.elem12 = getelementptr inbounds ptr, ptr %arr.data11, i64 %6
  %dense13 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense14 = load ptr, ptr %dense13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %last15 = load i32, ptr %last, align 4
  %7 = sext i32 %last15 to i64
  %arr.len16 = load i64, ptr %dense14, align 8
  %arr.oob17 = icmp uge i64 %7, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.717, ptr @.faila.718, i64 %7, ptr @.failb.719, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok10
  %arr.data20 = getelementptr i8, ptr %dense14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %7
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %Velocity.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  %8 = call ptr @memcpy(ptr %Velocity.copy, ptr %elem22, i64 ptrtoint (ptr getelementptr (%class.Velocity, ptr null, i64 1) to i64))
  store ptr %Velocity.copy, ptr %arr.elem12, align 8
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %denseEntity23 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %idx24 = load i32, ptr %idx, align 4
  %9 = sext i32 %idx24 to i64
  %arr.len25 = load i64, ptr %denseEntity23, align 8
  %arr.oob26 = icmp uge i64 %9, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.720, ptr @.faila.721, i64 %9, ptr @.failb.722, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok19
  %arr.data29 = getelementptr i8, ptr %denseEntity23, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 %9
  %denseEntity31 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %denseEntity32 = load ptr, ptr %denseEntity31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %last33 = load i32, ptr %last, align 4
  %10 = sext i32 %last33 to i64
  %arr.len34 = load i64, ptr %denseEntity32, align 8
  %arr.oob35 = icmp uge i64 %10, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

idx.bad36:                                        ; preds = %idx.ok28
  call void @__polaron_fail(ptr @.fail.723, ptr @.faila.724, i64 %10, ptr @.failb.725, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %idx.ok28
  %arr.data38 = getelementptr i8, ptr %denseEntity32, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %10
  %elem40 = load i32, ptr %arr.elem39, align 4
  store i32 %elem40, ptr %arr.elem30, align 4
  %sparse41 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse42 = load ptr, ptr %sparse41, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %denseEntity43 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %denseEntity44 = load ptr, ptr %denseEntity43, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %last45 = load i32, ptr %last, align 4
  %11 = sext i32 %last45 to i64
  %arr.len46 = load i64, ptr %denseEntity44, align 8
  %arr.oob47 = icmp uge i64 %11, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !8

idx.bad48:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.726, ptr @.faila.727, i64 %11, ptr @.failb.728, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok37
  %arr.data50 = getelementptr i8, ptr %denseEntity44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %11
  %elem52 = load i32, ptr %arr.elem51, align 4
  %12 = sext i32 %elem52 to i64
  %arr.len53 = load i64, ptr %sparse42, align 8
  %arr.oob54 = icmp uge i64 %12, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.729, ptr @.faila.730, i64 %12, ptr @.failb.731, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok49
  %arr.data57 = getelementptr i8, ptr %sparse42, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %12
  %idx59 = load i32, ptr %idx, align 4
  store i32 %idx59, ptr %arr.elem58, align 4
  %sparse60 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 3
  %sparse61 = load ptr, ptr %sparse60, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e62 = load i32, ptr %e, align 4
  %13 = sext i32 %e62 to i64
  %arr.len63 = load i64, ptr %sparse61, align 8
  %arr.oob64 = icmp uge i64 %13, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !8

idx.bad65:                                        ; preds = %idx.ok56
  call void @__polaron_fail(ptr @.fail.732, ptr @.faila.733, i64 %13, ptr @.failb.734, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %idx.ok56
  %arr.data67 = getelementptr i8, ptr %sparse61, i64 8
  %arr.elem68 = getelementptr inbounds i32, ptr %arr.data67, i64 %13
  store i32 -1, ptr %arr.elem68, align 4
  %count69 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count70 = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count71 = load i32, ptr %count70, align 4, !tbaa !4
  %14 = sub i32 %count71, 1
  store i32 %14, ptr %count69, align 4, !tbaa !4
  ret void
}

define internal i32 @"ComponentStore$Velocity.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"ComponentStore$Velocity.entityAt"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 2
  %denseEntity1 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %denseEntity1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.735, ptr @.faila.736, i64 %2, ptr @.failb.737, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %denseEntity1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @"ComponentStore$Velocity.at"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %dense = getelementptr inbounds %"class.ComponentStore$Velocity", ptr %0, i32 0, i32 1
  %dense1 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %dense1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.738, ptr @.faila.739, i64 %2, ptr @.failb.740, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %dense1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %2
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem
}

define internal void @"ComponentStore$Position.ComponentStore$Position"(ptr %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  %maxEntities = alloca i32, align 4
  store i32 %1, ptr %maxEntities, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 0
  store ptr @"ComponentStore$Position.vtable", ptr %vtbl.addr, align 8, !tbaa !0
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  store ptr null, ptr %dense, align 8, !tbaa !0
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  store ptr null, ptr %denseEntity, align 8, !tbaa !0
  %sparse = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  store ptr null, ptr %sparse, align 8, !tbaa !0
  %sparse1 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %maxEntities2 = load i32, ptr %maxEntities, align 4
  %2 = sext i32 %maxEntities2 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %sparse1, align 8, !tbaa !0
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %maxEntities4 = load i32, ptr %maxEntities, align 4
  %6 = icmp slt i32 %i3, %maxEntities4
  %7 = zext i1 %6 to i32
  br i1 %6, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %sparse5 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse6 = load ptr, ptr %sparse5, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i7 = load i32, ptr %i, align 4
  %8 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %sparse6, align 8
  %arr.oob = icmp uge i64 %8, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok
  %9 = load i32, ptr %i, align 4
  %10 = add i32 %9, 1
  store i32 %10, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dense9 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %arr10 = call ptr @__polaron_malloc(i64 72)
  store i64 8, ptr %arr10, align 8
  %arr.data11 = getelementptr i8, ptr %arr10, i64 8
  %11 = call ptr @memset(ptr %arr.data11, i32 0, i64 64)
  store ptr %arr10, ptr %dense9, align 8, !tbaa !0
  %denseEntity12 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %arr13 = call ptr @__polaron_malloc(i64 40)
  store i64 8, ptr %arr13, align 8
  %arr.data14 = getelementptr i8, ptr %arr13, i64 8
  %12 = call ptr @memset(ptr %arr.data14, i32 0, i64 32)
  store ptr %arr13, ptr %denseEntity12, align 8, !tbaa !0
  %count = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  store i32 0, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 5
  store i32 8, ptr %cap, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.741, ptr @.faila.742, i64 %8, ptr @.failb.743, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %sparse6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %8
  store i32 -1, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @"ComponentStore$Position.grow"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i = alloca i32, align 4
  %ne = alloca ptr, align 8
  %nd = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 5
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
  store ptr %arr, ptr %nd, align 8
  %nc3 = load i32, ptr %nc, align 4
  %6 = sext i32 %nc3 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr4 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %9 = call ptr @memset(ptr %arr.data5, i32 0, i64 %7)
  store ptr %arr4, ptr %ne, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %count = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count7 = load i32, ptr %count, align 4, !tbaa !4
  %10 = icmp slt i32 %i6, %count7
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %nd8 = load ptr, ptr %nd, align 8, !nonnull !6, !dereferenceable !7
  %i9 = load i32, ptr %i, align 4
  %12 = sext i32 %i9 to i64
  %arr.len = load i64, ptr %nd8, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok32
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %dense36 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %nd37 = load ptr, ptr %nd, align 8
  store ptr %nd37, ptr %dense36, align 8, !tbaa !0
  %denseEntity38 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %ne39 = load ptr, ptr %ne, align 8
  store ptr %ne39, ptr %denseEntity38, align 8, !tbaa !0
  %cap40 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 5
  %nc41 = load i32, ptr %nc, align 4
  store i32 %nc41, ptr %cap40, align 4, !tbaa !4
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.744, ptr @.faila.745, i64 %12, ptr @.failb.746, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data10 = getelementptr i8, ptr %nd8, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data10, i64 %12
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense11 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i12 = load i32, ptr %i, align 4
  %15 = sext i32 %i12 to i64
  %arr.len13 = load i64, ptr %dense11, align 8
  %arr.oob14 = icmp uge i64 %15, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !8

idx.bad15:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.747, ptr @.faila.748, i64 %15, ptr @.failb.749, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok
  %arr.data17 = getelementptr i8, ptr %dense11, i64 8
  %arr.elem18 = getelementptr inbounds ptr, ptr %arr.data17, i64 %15
  %elem = load ptr, ptr %arr.elem18, align 8
  %Position.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  %16 = call ptr @memcpy(ptr %Position.copy, ptr %elem, i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  store ptr %Position.copy, ptr %arr.elem, align 8
  %ne19 = load ptr, ptr %ne, align 8, !nonnull !6, !dereferenceable !7
  %i20 = load i32, ptr %i, align 4
  %17 = sext i32 %i20 to i64
  %arr.len21 = load i64, ptr %ne19, align 8
  %arr.oob22 = icmp uge i64 %17, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !8

idx.bad23:                                        ; preds = %idx.ok16
  call void @__polaron_fail(ptr @.fail.750, ptr @.faila.751, i64 %17, ptr @.failb.752, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %idx.ok16
  %arr.data25 = getelementptr i8, ptr %ne19, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 %17
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %denseEntity27 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i28 = load i32, ptr %i, align 4
  %18 = sext i32 %i28 to i64
  %arr.len29 = load i64, ptr %denseEntity27, align 8
  %arr.oob30 = icmp uge i64 %18, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !8

idx.bad31:                                        ; preds = %idx.ok24
  call void @__polaron_fail(ptr @.fail.753, ptr @.faila.754, i64 %18, ptr @.failb.755, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %idx.ok24
  %arr.data33 = getelementptr i8, ptr %denseEntity27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %18
  %elem35 = load i32, ptr %arr.elem34, align 4
  store i32 %elem35, ptr %arr.elem26, align 4
  br label %for.update
}

define internal void @"ComponentStore$Position.add"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2) {
entry:
  %Position.copy = alloca %class.Position, align 8
  %component = alloca ptr, align 8
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %3 = call ptr @memcpy(ptr %Position.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  store ptr %Position.copy, ptr %component, align 8
  %count = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  %cap = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 5
  %cap2 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp eq i32 %count1, %cap2
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  call void @"ComponentStore$Position.grow"(ptr %0)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense3 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count4 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count5 = load i32, ptr %count4, align 4, !tbaa !4
  %6 = sext i32 %count5 to i64
  %arr.len = load i64, ptr %dense3, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.756, ptr @.faila.757, i64 %6, ptr @.failb.758, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.end
  %arr.data = getelementptr i8, ptr %dense3, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %6
  %component6 = load ptr, ptr %component, align 8
  %Position.copy7 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  %7 = call ptr @memcpy(ptr %Position.copy7, ptr %component6, i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  store ptr %Position.copy7, ptr %arr.elem, align 8
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %denseEntity8 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %count9 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count10 = load i32, ptr %count9, align 4, !tbaa !4
  %8 = sext i32 %count10 to i64
  %arr.len11 = load i64, ptr %denseEntity8, align 8
  %arr.oob12 = icmp uge i64 %8, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !8

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.759, ptr @.faila.760, i64 %8, ptr @.failb.761, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %denseEntity8, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %8
  %e17 = load i32, ptr %e, align 4
  store i32 %e17, ptr %arr.elem16, align 4
  %sparse = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse18 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e19 = load i32, ptr %e, align 4
  %9 = sext i32 %e19 to i64
  %arr.len20 = load i64, ptr %sparse18, align 8
  %arr.oob21 = icmp uge i64 %9, %arr.len20
  br i1 %arr.oob21, label %idx.bad22, label %idx.ok23, !prof !8

idx.bad22:                                        ; preds = %idx.ok14
  call void @__polaron_fail(ptr @.fail.762, ptr @.faila.763, i64 %9, ptr @.failb.764, i64 %arr.len20, i32 70)
  unreachable

idx.ok23:                                         ; preds = %idx.ok14
  %arr.data24 = getelementptr i8, ptr %sparse18, i64 8
  %arr.elem25 = getelementptr inbounds i32, ptr %arr.data24, i64 %9
  %count26 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count27 = load i32, ptr %count26, align 4, !tbaa !4
  store i32 %count27, ptr %arr.elem25, align 4
  %count28 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count29 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count30 = load i32, ptr %count29, align 4, !tbaa !4
  %10 = add i32 %count30, 1
  store i32 %10, ptr %count28, align 4, !tbaa !4
  ret void
}

define internal i32 @"ComponentStore$Position.has"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %sparse = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse1 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e2 = load i32, ptr %e, align 4
  %2 = sext i32 %e2 to i64
  %arr.len = load i64, ptr %sparse1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.765, ptr @.faila.766, i64 %2, ptr @.failb.767, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  %3 = icmp sge i32 %elem, 0
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define internal ptr @"ComponentStore$Position.get"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense1 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sparse = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse2 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e3 = load i32, ptr %e, align 4
  %2 = sext i32 %e3 to i64
  %arr.len = load i64, ptr %sparse2, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.768, ptr @.faila.769, i64 %2, ptr @.failb.770, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  %3 = sext i32 %elem to i64
  %arr.len4 = load i64, ptr %dense1, align 8
  %arr.oob5 = icmp uge i64 %3, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !8

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.771, ptr @.faila.772, i64 %3, ptr @.failb.773, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %dense1, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 %3
  %elem10 = load ptr, ptr %arr.elem9, align 8
  ret ptr %elem10
}

define internal void @"ComponentStore$Position.set"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, ptr %2) {
entry:
  %Position.copy = alloca %class.Position, align 8
  %component = alloca ptr, align 8
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %3 = call ptr @memcpy(ptr %Position.copy, ptr %2, i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  store ptr %Position.copy, ptr %component, align 8
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense1 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %sparse = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse2 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e3 = load i32, ptr %e, align 4
  %4 = sext i32 %e3 to i64
  %arr.len = load i64, ptr %sparse2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.774, ptr @.faila.775, i64 %4, ptr @.failb.776, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %5 = sext i32 %elem to i64
  %arr.len4 = load i64, ptr %dense1, align 8
  %arr.oob5 = icmp uge i64 %5, %arr.len4
  br i1 %arr.oob5, label %idx.bad6, label %idx.ok7, !prof !8

idx.bad6:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.777, ptr @.faila.778, i64 %5, ptr @.failb.779, i64 %arr.len4, i32 70)
  unreachable

idx.ok7:                                          ; preds = %idx.ok
  %arr.data8 = getelementptr i8, ptr %dense1, i64 8
  %arr.elem9 = getelementptr inbounds ptr, ptr %arr.data8, i64 %5
  %component10 = load ptr, ptr %component, align 8
  %Position.copy11 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  %6 = call ptr @memcpy(ptr %Position.copy11, ptr %component10, i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  store ptr %Position.copy11, ptr %arr.elem9, align 8
  ret void
}

define internal void @"ComponentStore$Position.remove"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %last = alloca i32, align 4
  %idx = alloca i32, align 4
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %sparse = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse1 = load ptr, ptr %sparse, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e2 = load i32, ptr %e, align 4
  %2 = sext i32 %e2 to i64
  %arr.len = load i64, ptr %sparse1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.780, ptr @.faila.781, i64 %2, ptr @.failb.782, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %sparse1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %idx, align 4
  %idx3 = load i32, ptr %idx, align 4
  %3 = icmp slt i32 %idx3, 0
  %4 = zext i1 %3 to i32
  br i1 %3, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  ret void

if.end:                                           ; preds = %idx.ok
  %count = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count4 = load i32, ptr %count, align 4, !tbaa !4
  %5 = sub i32 %count4, 1
  store i32 %5, ptr %last, align 4
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense5 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %idx6 = load i32, ptr %idx, align 4
  %6 = sext i32 %idx6 to i64
  %arr.len7 = load i64, ptr %dense5, align 8
  %arr.oob8 = icmp uge i64 %6, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !8

idx.bad9:                                         ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.783, ptr @.faila.784, i64 %6, ptr @.failb.785, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %if.end
  %arr.data11 = getelementptr i8, ptr %dense5, i64 8
  %arr.elem12 = getelementptr inbounds ptr, ptr %arr.data11, i64 %6
  %dense13 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense14 = load ptr, ptr %dense13, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %last15 = load i32, ptr %last, align 4
  %7 = sext i32 %last15 to i64
  %arr.len16 = load i64, ptr %dense14, align 8
  %arr.oob17 = icmp uge i64 %7, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !8

idx.bad18:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.786, ptr @.faila.787, i64 %7, ptr @.failb.788, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %idx.ok10
  %arr.data20 = getelementptr i8, ptr %dense14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %7
  %elem22 = load ptr, ptr %arr.elem21, align 8
  %Position.copy = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  %8 = call ptr @memcpy(ptr %Position.copy, ptr %elem22, i64 ptrtoint (ptr getelementptr (%class.Position, ptr null, i64 1) to i64))
  store ptr %Position.copy, ptr %arr.elem12, align 8
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %denseEntity23 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %idx24 = load i32, ptr %idx, align 4
  %9 = sext i32 %idx24 to i64
  %arr.len25 = load i64, ptr %denseEntity23, align 8
  %arr.oob26 = icmp uge i64 %9, %arr.len25
  br i1 %arr.oob26, label %idx.bad27, label %idx.ok28, !prof !8

idx.bad27:                                        ; preds = %idx.ok19
  call void @__polaron_fail(ptr @.fail.789, ptr @.faila.790, i64 %9, ptr @.failb.791, i64 %arr.len25, i32 70)
  unreachable

idx.ok28:                                         ; preds = %idx.ok19
  %arr.data29 = getelementptr i8, ptr %denseEntity23, i64 8
  %arr.elem30 = getelementptr inbounds i32, ptr %arr.data29, i64 %9
  %denseEntity31 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %denseEntity32 = load ptr, ptr %denseEntity31, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %last33 = load i32, ptr %last, align 4
  %10 = sext i32 %last33 to i64
  %arr.len34 = load i64, ptr %denseEntity32, align 8
  %arr.oob35 = icmp uge i64 %10, %arr.len34
  br i1 %arr.oob35, label %idx.bad36, label %idx.ok37, !prof !8

idx.bad36:                                        ; preds = %idx.ok28
  call void @__polaron_fail(ptr @.fail.792, ptr @.faila.793, i64 %10, ptr @.failb.794, i64 %arr.len34, i32 70)
  unreachable

idx.ok37:                                         ; preds = %idx.ok28
  %arr.data38 = getelementptr i8, ptr %denseEntity32, i64 8
  %arr.elem39 = getelementptr inbounds i32, ptr %arr.data38, i64 %10
  %elem40 = load i32, ptr %arr.elem39, align 4
  store i32 %elem40, ptr %arr.elem30, align 4
  %sparse41 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse42 = load ptr, ptr %sparse41, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %denseEntity43 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %denseEntity44 = load ptr, ptr %denseEntity43, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %last45 = load i32, ptr %last, align 4
  %11 = sext i32 %last45 to i64
  %arr.len46 = load i64, ptr %denseEntity44, align 8
  %arr.oob47 = icmp uge i64 %11, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !8

idx.bad48:                                        ; preds = %idx.ok37
  call void @__polaron_fail(ptr @.fail.795, ptr @.faila.796, i64 %11, ptr @.failb.797, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok37
  %arr.data50 = getelementptr i8, ptr %denseEntity44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %11
  %elem52 = load i32, ptr %arr.elem51, align 4
  %12 = sext i32 %elem52 to i64
  %arr.len53 = load i64, ptr %sparse42, align 8
  %arr.oob54 = icmp uge i64 %12, %arr.len53
  br i1 %arr.oob54, label %idx.bad55, label %idx.ok56, !prof !8

idx.bad55:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.798, ptr @.faila.799, i64 %12, ptr @.failb.800, i64 %arr.len53, i32 70)
  unreachable

idx.ok56:                                         ; preds = %idx.ok49
  %arr.data57 = getelementptr i8, ptr %sparse42, i64 8
  %arr.elem58 = getelementptr inbounds i32, ptr %arr.data57, i64 %12
  %idx59 = load i32, ptr %idx, align 4
  store i32 %idx59, ptr %arr.elem58, align 4
  %sparse60 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 3
  %sparse61 = load ptr, ptr %sparse60, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e62 = load i32, ptr %e, align 4
  %13 = sext i32 %e62 to i64
  %arr.len63 = load i64, ptr %sparse61, align 8
  %arr.oob64 = icmp uge i64 %13, %arr.len63
  br i1 %arr.oob64, label %idx.bad65, label %idx.ok66, !prof !8

idx.bad65:                                        ; preds = %idx.ok56
  call void @__polaron_fail(ptr @.fail.801, ptr @.faila.802, i64 %13, ptr @.failb.803, i64 %arr.len63, i32 70)
  unreachable

idx.ok66:                                         ; preds = %idx.ok56
  %arr.data67 = getelementptr i8, ptr %sparse61, i64 8
  %arr.elem68 = getelementptr inbounds i32, ptr %arr.data67, i64 %13
  store i32 -1, ptr %arr.elem68, align 4
  %count69 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count70 = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count71 = load i32, ptr %count70, align 4, !tbaa !4
  %14 = sub i32 %count71, 1
  store i32 %14, ptr %count69, align 4, !tbaa !4
  ret void
}

define internal i32 @"ComponentStore$Position.size"(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 4
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @"ComponentStore$Position.entityAt"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %denseEntity = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 2
  %denseEntity1 = load ptr, ptr %denseEntity, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %denseEntity1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.804, ptr @.faila.805, i64 %2, ptr @.failb.806, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %denseEntity1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @"ComponentStore$Position.at"(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %dense = getelementptr inbounds %"class.ComponentStore$Position", ptr %0, i32 0, i32 1
  %dense1 = load ptr, ptr %dense, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %dense1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.807, ptr @.faila.808, i64 %2, ptr @.failb.809, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %dense1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %2
  %elem = load ptr, ptr %arr.elem, align 8
  ret ptr %elem
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

define internal void @World.World(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.World, ptr %0, i32 0, i32 0
  store ptr @World.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %alive = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  store ptr null, ptr %alive, align 8, !tbaa !0
  %freeList = getelementptr inbounds %class.World, ptr %0, i32 0, i32 2
  store ptr null, ptr %freeList, align 8, !tbaa !0
  %cap = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  store i32 16, ptr %cap, align 4, !tbaa !4
  %alive1 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %arr = call ptr @__polaron_malloc(i64 24)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 16)
  store ptr %arr, ptr %alive1, align 8, !tbaa !0
  %freeList2 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 2
  %arr3 = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %2 = call ptr @memset(ptr %arr.data4, i32 0, i64 64)
  store ptr %arr3, ptr %freeList2, align 8, !tbaa !0
  %freeCount = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  store i32 0, ptr %freeCount, align 4, !tbaa !4
  %next = getelementptr inbounds %class.World, ptr %0, i32 0, i32 4
  store i32 0, ptr %next, align 4, !tbaa !4
  %count = getelementptr inbounds %class.World, ptr %0, i32 0, i32 6
  store i32 0, ptr %count, align 4, !tbaa !4
  ret void
}

define internal void @World.grow(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %i20 = alloca i32, align 4
  %i = alloca i32, align 4
  %nf = alloca ptr, align 8
  %na = alloca ptr, align 8
  %nc = alloca i32, align 4
  %cap = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  %1 = mul i32 %cap1, 2
  store i32 %1, ptr %nc, align 4
  %nc2 = load i32, ptr %nc, align 4
  %2 = sext i32 %nc2 to i64
  %3 = mul i64 %2, 1
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %na, align 8
  %nc3 = load i32, ptr %nc, align 4
  %6 = sext i32 %nc3 to i64
  %7 = mul i64 %6, 4
  %8 = add i64 8, %7
  %arr4 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr4, align 8
  %arr.data5 = getelementptr i8, ptr %arr4, i64 8
  %9 = call ptr @memset(ptr %arr.data5, i32 0, i64 %7)
  store ptr %arr4, ptr %nf, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i6 = load i32, ptr %i, align 4
  %cap7 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %cap8 = load i32, ptr %cap7, align 4, !tbaa !4
  %10 = icmp slt i32 %i6, %cap8
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %na9 = load ptr, ptr %na, align 8, !nonnull !6, !dereferenceable !7
  %i10 = load i32, ptr %i, align 4
  %12 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %na9, align 8
  %arr.oob = icmp uge i64 %12, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

for.update:                                       ; preds = %idx.ok17
  %13 = load i32, ptr %i, align 4
  %14 = add i32 %13, 1
  store i32 %14, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i20, align 4
  br label %for.cond21

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.5240, ptr @.faila.5241, i64 %12, ptr @.failb.5242, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %na9, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data11, i64 %12
  %alive = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %alive12 = load ptr, ptr %alive, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i13 = load i32, ptr %i, align 4
  %15 = sext i32 %i13 to i64
  %arr.len14 = load i64, ptr %alive12, align 8
  %arr.oob15 = icmp uge i64 %15, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !8

idx.bad16:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.5243, ptr @.faila.5244, i64 %15, ptr @.failb.5245, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok
  %arr.data18 = getelementptr i8, ptr %alive12, i64 8
  %arr.elem19 = getelementptr inbounds i8, ptr %arr.data18, i64 %15
  %elem = load i8, ptr %arr.elem19, align 1
  %16 = zext i8 %elem to i32
  %17 = trunc i32 %16 to i8
  store i8 %17, ptr %arr.elem, align 1
  br label %for.update

for.cond21:                                       ; preds = %for.update23, %for.end
  %i25 = load i32, ptr %i20, align 4
  %freeCount = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount26 = load i32, ptr %freeCount, align 4, !tbaa !4
  %18 = icmp slt i32 %i25, %freeCount26
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  %nf27 = load ptr, ptr %nf, align 8, !nonnull !6, !dereferenceable !7
  %i28 = load i32, ptr %i20, align 4
  %20 = sext i32 %i28 to i64
  %arr.len29 = load i64, ptr %nf27, align 8
  %arr.oob30 = icmp uge i64 %20, %arr.len29
  br i1 %arr.oob30, label %idx.bad31, label %idx.ok32, !prof !8

for.update23:                                     ; preds = %idx.ok40
  %21 = load i32, ptr %i20, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i20, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  %alive44 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %na45 = load ptr, ptr %na, align 8
  store ptr %na45, ptr %alive44, align 8, !tbaa !0
  %freeList46 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 2
  %nf47 = load ptr, ptr %nf, align 8
  store ptr %nf47, ptr %freeList46, align 8, !tbaa !0
  %cap48 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %nc49 = load i32, ptr %nc, align 4
  store i32 %nc49, ptr %cap48, align 4, !tbaa !4
  ret void

idx.bad31:                                        ; preds = %for.body22
  call void @__polaron_fail(ptr @.fail.5246, ptr @.faila.5247, i64 %20, ptr @.failb.5248, i64 %arr.len29, i32 70)
  unreachable

idx.ok32:                                         ; preds = %for.body22
  %arr.data33 = getelementptr i8, ptr %nf27, i64 8
  %arr.elem34 = getelementptr inbounds i32, ptr %arr.data33, i64 %20
  %freeList = getelementptr inbounds %class.World, ptr %0, i32 0, i32 2
  %freeList35 = load ptr, ptr %freeList, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %i36 = load i32, ptr %i20, align 4
  %23 = sext i32 %i36 to i64
  %arr.len37 = load i64, ptr %freeList35, align 8
  %arr.oob38 = icmp uge i64 %23, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !8

idx.bad39:                                        ; preds = %idx.ok32
  call void @__polaron_fail(ptr @.fail.5249, ptr @.faila.5250, i64 %23, ptr @.failb.5251, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %idx.ok32
  %arr.data41 = getelementptr i8, ptr %freeList35, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %23
  %elem43 = load i32, ptr %arr.elem42, align 4
  store i32 %elem43, ptr %arr.elem34, align 4
  br label %for.update23
}

define internal i32 @World.createEntity(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %id = alloca i32, align 4
  store i32 0, ptr %id, align 4
  %freeCount = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount1 = load i32, ptr %freeCount, align 4, !tbaa !4
  %1 = icmp sgt i32 %freeCount1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %freeList = getelementptr inbounds %class.World, ptr %0, i32 0, i32 2
  %freeList2 = load ptr, ptr %freeList, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %freeCount3 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount4 = load i32, ptr %freeCount3, align 4, !tbaa !4
  %3 = sub i32 %freeCount4, 1
  %4 = sext i32 %3 to i64
  %arr.len = load i64, ptr %freeList2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

if.else:                                          ; preds = %entry
  %next = getelementptr inbounds %class.World, ptr %0, i32 0, i32 4
  %next8 = load i32, ptr %next, align 4, !tbaa !4
  %cap = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %cap9 = load i32, ptr %cap, align 4, !tbaa !4
  %5 = icmp eq i32 %next8, %cap9
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then10, label %if.end11

if.end:                                           ; preds = %if.end11, %idx.ok
  %alive = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %alive17 = load ptr, ptr %alive, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %id18 = load i32, ptr %id, align 4
  %7 = sext i32 %id18 to i64
  %arr.len19 = load i64, ptr %alive17, align 8
  %arr.oob20 = icmp uge i64 %7, %arr.len19
  br i1 %arr.oob20, label %idx.bad21, label %idx.ok22, !prof !8

idx.bad:                                          ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.5252, ptr @.faila.5253, i64 %4, ptr @.failb.5254, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %if.then
  %arr.data = getelementptr i8, ptr %freeList2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %id, align 4
  %freeCount5 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount6 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount7 = load i32, ptr %freeCount6, align 4, !tbaa !4
  %8 = sub i32 %freeCount7, 1
  store i32 %8, ptr %freeCount5, align 4, !tbaa !4
  br label %if.end

if.then10:                                        ; preds = %if.else
  call void @World.grow(ptr %0)
  br label %if.end11

if.end11:                                         ; preds = %if.then10, %if.else
  %next12 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 4
  %next13 = load i32, ptr %next12, align 4, !tbaa !4
  store i32 %next13, ptr %id, align 4
  %next14 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 4
  %next15 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 4
  %next16 = load i32, ptr %next15, align 4, !tbaa !4
  %9 = add i32 %next16, 1
  store i32 %9, ptr %next14, align 4, !tbaa !4
  br label %if.end

idx.bad21:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.5255, ptr @.faila.5256, i64 %7, ptr @.failb.5257, i64 %arr.len19, i32 70)
  unreachable

idx.ok22:                                         ; preds = %if.end
  %arr.data23 = getelementptr i8, ptr %alive17, i64 8
  %arr.elem24 = getelementptr inbounds i8, ptr %arr.data23, i64 %7
  store i8 1, ptr %arr.elem24, align 1
  %count = getelementptr inbounds %class.World, ptr %0, i32 0, i32 6
  %count25 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 6
  %count26 = load i32, ptr %count25, align 4, !tbaa !4
  %10 = add i32 %count26, 1
  store i32 %10, ptr %count, align 4, !tbaa !4
  %id27 = load i32, ptr %id, align 4
  ret i32 %id27
}

define internal void @World.destroyEntity(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %e1 = load i32, ptr %e, align 4
  %2 = icmp sge i32 %e1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %e2 = load i32, ptr %e, align 4
  %cap = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %e2, %cap3
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  %sc.a4 = icmp ne i32 %6, 0
  br i1 %sc.a4, label %sc.rhs5, label %sc.end6

sc.rhs5:                                          ; preds = %sc.end
  %alive = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %alive7 = load ptr, ptr %alive, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e8 = load i32, ptr %e, align 4
  %7 = sext i32 %e8 to i64
  %arr.len = load i64, ptr %alive7, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

sc.end6:                                          ; preds = %idx.ok, %sc.end
  %sc10 = phi i1 [ false, %sc.end ], [ %sc.b9, %idx.ok ]
  %8 = zext i1 %sc10 to i32
  br i1 %sc10, label %if.then, label %if.end

idx.bad:                                          ; preds = %sc.rhs5
  call void @__polaron_fail(ptr @.fail.5258, ptr @.faila.5259, i64 %7, ptr @.failb.5260, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs5
  %arr.data = getelementptr i8, ptr %alive7, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %7
  %elem = load i8, ptr %arr.elem, align 1
  %9 = zext i8 %elem to i32
  %sc.b9 = icmp ne i32 %9, 0
  br label %sc.end6

if.then:                                          ; preds = %sc.end6
  %alive11 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %alive12 = load ptr, ptr %alive11, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e13 = load i32, ptr %e, align 4
  %10 = sext i32 %e13 to i64
  %arr.len14 = load i64, ptr %alive12, align 8
  %arr.oob15 = icmp uge i64 %10, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !8

if.end:                                           ; preds = %idx.ok25, %sc.end6
  ret void

idx.bad16:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.5261, ptr @.faila.5262, i64 %10, ptr @.failb.5263, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %if.then
  %arr.data18 = getelementptr i8, ptr %alive12, i64 8
  %arr.elem19 = getelementptr inbounds i8, ptr %arr.data18, i64 %10
  store i8 0, ptr %arr.elem19, align 1
  %freeList = getelementptr inbounds %class.World, ptr %0, i32 0, i32 2
  %freeList20 = load ptr, ptr %freeList, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %freeCount = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount21 = load i32, ptr %freeCount, align 4, !tbaa !4
  %11 = sext i32 %freeCount21 to i64
  %arr.len22 = load i64, ptr %freeList20, align 8
  %arr.oob23 = icmp uge i64 %11, %arr.len22
  br i1 %arr.oob23, label %idx.bad24, label %idx.ok25, !prof !8

idx.bad24:                                        ; preds = %idx.ok17
  call void @__polaron_fail(ptr @.fail.5264, ptr @.faila.5265, i64 %11, ptr @.failb.5266, i64 %arr.len22, i32 70)
  unreachable

idx.ok25:                                         ; preds = %idx.ok17
  %arr.data26 = getelementptr i8, ptr %freeList20, i64 8
  %arr.elem27 = getelementptr inbounds i32, ptr %arr.data26, i64 %11
  %e28 = load i32, ptr %e, align 4
  store i32 %e28, ptr %arr.elem27, align 4
  %freeCount29 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount30 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 3
  %freeCount31 = load i32, ptr %freeCount30, align 4, !tbaa !4
  %12 = add i32 %freeCount31, 1
  store i32 %12, ptr %freeCount29, align 4, !tbaa !4
  %count = getelementptr inbounds %class.World, ptr %0, i32 0, i32 6
  %count32 = getelementptr inbounds %class.World, ptr %0, i32 0, i32 6
  %count33 = load i32, ptr %count32, align 4, !tbaa !4
  %13 = sub i32 %count33, 1
  store i32 %13, ptr %count, align 4, !tbaa !4
  br label %if.end
}

define internal i32 @World.isAlive(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %e = alloca i32, align 4
  store i32 %1, ptr %e, align 4
  %e1 = load i32, ptr %e, align 4
  %2 = icmp sge i32 %e1, 0
  %3 = zext i1 %2 to i32
  %sc.a = icmp ne i32 %3, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

sc.rhs:                                           ; preds = %entry
  %e2 = load i32, ptr %e, align 4
  %cap = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %cap3 = load i32, ptr %cap, align 4, !tbaa !4
  %4 = icmp slt i32 %e2, %cap3
  %5 = zext i1 %4 to i32
  %sc.b = icmp ne i32 %5, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %entry
  %sc = phi i1 [ false, %entry ], [ %sc.b, %sc.rhs ]
  %6 = zext i1 %sc to i32
  %sc.a4 = icmp ne i32 %6, 0
  br i1 %sc.a4, label %sc.rhs5, label %sc.end6

sc.rhs5:                                          ; preds = %sc.end
  %alive = getelementptr inbounds %class.World, ptr %0, i32 0, i32 1
  %alive7 = load ptr, ptr %alive, align 8, !tbaa !0, !nonnull !6, !dereferenceable !7
  %e8 = load i32, ptr %e, align 4
  %7 = sext i32 %e8 to i64
  %arr.len = load i64, ptr %alive7, align 8
  %arr.oob = icmp uge i64 %7, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

sc.end6:                                          ; preds = %idx.ok, %sc.end
  %sc10 = phi i1 [ false, %sc.end ], [ %sc.b9, %idx.ok ]
  %8 = zext i1 %sc10 to i32
  ret i32 %8

idx.bad:                                          ; preds = %sc.rhs5
  call void @__polaron_fail(ptr @.fail.5267, ptr @.faila.5268, i64 %7, ptr @.failb.5269, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %sc.rhs5
  %arr.data = getelementptr i8, ptr %alive7, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %7
  %elem = load i8, ptr %arr.elem, align 1
  %9 = zext i8 %elem to i32
  %sc.b9 = icmp ne i32 %9, 0
  br label %sc.end6
}

define internal i32 @World.size(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %count = getelementptr inbounds %class.World, ptr %0, i32 0, i32 6
  %count1 = load i32, ptr %count, align 4, !tbaa !4
  ret i32 %count1
}

define internal i32 @World.capacity(ptr nonnull align 8 dereferenceable(40) %0) {
entry:
  %cap = getelementptr inbounds %class.World, ptr %0, i32 0, i32 5
  %cap1 = load i32, ptr %cap, align 4, !tbaa !4
  ret i32 %cap1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5444)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5446)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare i32 @printf(ptr, ...)

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
