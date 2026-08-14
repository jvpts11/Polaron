; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Aes = type { ptr, ptr, ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Aes.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Aes.xtime, ptr @Aes.rotl8, ptr @Aes.initTables, ptr @Aes.gmul, ptr @Aes.expandKey, ptr @Aes.addRoundKey, ptr @Aes.subBytes, ptr @Aes.invSubBytes, ptr @Aes.shiftRows, ptr @Aes.invShiftRows, ptr @Aes.mixColumns, ptr @Aes.invMixColumns, ptr @Aes.encryptBlock, ptr @Aes.decryptBlock, ptr @Aes.ctr, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:15:28  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:16:27  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:22:25  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:22:41  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.10 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:22:57  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.13 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:22:73  in main\0A\00", align 1
@.faila.14 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.15 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.16 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:23:25  in main\0A\00", align 1
@.faila.17 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.18 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.19 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:23:41  in main\0A\00", align 1
@.faila.20 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.21 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.22 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:23:57  in main\0A\00", align 1
@.faila.23 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.24 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.25 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:23:73  in main\0A\00", align 1
@.faila.26 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.27 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.28 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:24:25  in main\0A\00", align 1
@.faila.29 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.30 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.31 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:24:41  in main\0A\00", align 1
@.faila.32 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.33 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.34 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:24:58  in main\0A\00", align 1
@.faila.35 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.36 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.37 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:24:74  in main\0A\00", align 1
@.faila.38 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.39 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.40 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:25:26  in main\0A\00", align 1
@.faila.41 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.42 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.43 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:25:42  in main\0A\00", align 1
@.faila.44 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.45 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.46 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:25:58  in main\0A\00", align 1
@.faila.47 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.48 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.49 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:25:74  in main\0A\00", align 1
@.faila.50 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.51 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.52 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:28:21  in main\0A\00", align 1
@.faila.53 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.54 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.55 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:28:21  in main\0A\00", align 1
@.faila.56 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.57 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.58 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:34:21  in main\0A\00", align 1
@.faila.59 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.60 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.61 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:34:21  in main\0A\00", align 1
@.faila.62 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.63 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.64 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:38:63  in main\0A\00", align 1
@.faila.65 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.66 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.67 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:40:62  in main\0A\00", align 1
@.faila.68 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.69 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.70 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:46:21  in main\0A\00", align 1
@.faila.71 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.72 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.73 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:46:21  in main\0A\00", align 1
@.faila.74 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.75 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.76 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:47:21  in main\0A\00", align 1
@.faila.77 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.78 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.79 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:47:21  in main\0A\00", align 1
@.faila.80 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.81 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.82 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:52:66  in main\0A\00", align 1
@.faila.83 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.84 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.85 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:56:28  in main\0A\00", align 1
@.faila.86 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.87 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.88 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:56:47  in main\0A\00", align 1
@.faila.89 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.90 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.91 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:56:66  in main\0A\00", align 1
@.faila.92 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.93 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.94 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:56:85  in main\0A\00", align 1
@.faila.95 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.96 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.97 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:57:28  in main\0A\00", align 1
@.faila.98 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.99 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.100 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:57:47  in main\0A\00", align 1
@.faila.101 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.102 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.103 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:57:66  in main\0A\00", align 1
@.faila.104 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.105 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.106 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:57:85  in main\0A\00", align 1
@.faila.107 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.108 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.109 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:58:28  in main\0A\00", align 1
@.faila.110 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.111 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.112 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:58:47  in main\0A\00", align 1
@.faila.113 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.114 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.115 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:58:67  in main\0A\00", align 1
@.faila.116 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.117 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.118 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:58:86  in main\0A\00", align 1
@.faila.119 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.120 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.121 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:59:29  in main\0A\00", align 1
@.faila.122 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.123 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.124 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:59:48  in main\0A\00", align 1
@.faila.125 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.126 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.127 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:59:67  in main\0A\00", align 1
@.faila.128 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.129 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.130 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:59:86  in main\0A\00", align 1
@.faila.131 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.132 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.133 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:62:21  in main\0A\00", align 1
@.faila.134 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.135 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.136 = private unnamed_addr constant [122 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/aes.pol:62:21  in main\0A\00", align 1
@.faila.137 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.138 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [43 x i8] c"vec=%d ecb=%d ctr=%d changed=%d vec256=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1445 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1446 = private global %String { i64 16, ptr @.strdata.1445, i64 0 }
@.strdata.1447 = private constant [17 x i8] c"division by zero\00"
@.strobj.1448 = private global %String { i64 16, ptr @.strdata.1447, i64 0 }
@.fail.4092 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8256:29  in Aes.initTables\0A\00", align 1
@.faila.4093 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4094 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4095 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8257:29  in Aes.initTables\0A\00", align 1
@.faila.4096 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4097 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4098 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8264:39  in Aes.initTables\0A\00", align 1
@.faila.4099 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4100 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4101 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8264:39  in Aes.initTables\0A\00", align 1
@.faila.4102 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4103 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4104 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8268:34  in Aes.initTables\0A\00", align 1
@.faila.4105 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4106 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4107 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8269:37  in Aes.initTables\0A\00", align 1
@.faila.4108 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4109 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4110 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8288:71  in Aes.expandKey\0A\00", align 1
@.faila.4111 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4112 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4113 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8288:71  in Aes.expandKey\0A\00", align 1
@.faila.4114 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4115 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4116 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8292:21  in Aes.expandKey\0A\00", align 1
@.faila.4117 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4118 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4119 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8293:21  in Aes.expandKey\0A\00", align 1
@.faila.4120 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4121 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4122 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8294:21  in Aes.expandKey\0A\00", align 1
@.faila.4123 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4124 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4125 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8295:21  in Aes.expandKey\0A\00", align 1
@.faila.4126 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4127 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4128 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8297:25  in Aes.expandKey\0A\00", align 1
@.faila.4129 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4130 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4131 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8298:25  in Aes.expandKey\0A\00", align 1
@.faila.4132 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4133 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4134 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8299:25  in Aes.expandKey\0A\00", align 1
@.faila.4135 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4136 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4137 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8300:25  in Aes.expandKey\0A\00", align 1
@.faila.4138 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4139 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4140 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8304:28  in Aes.expandKey\0A\00", align 1
@.faila.4141 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4142 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4143 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8304:48  in Aes.expandKey\0A\00", align 1
@.faila.4144 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4145 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4146 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8305:28  in Aes.expandKey\0A\00", align 1
@.faila.4147 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4148 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4149 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8305:48  in Aes.expandKey\0A\00", align 1
@.faila.4150 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4151 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4152 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8307:40  in Aes.expandKey\0A\00", align 1
@.faila.4153 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4154 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4155 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8307:40  in Aes.expandKey\0A\00", align 1
@.faila.4156 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4157 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4158 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8308:40  in Aes.expandKey\0A\00", align 1
@.faila.4159 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4160 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4161 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8308:40  in Aes.expandKey\0A\00", align 1
@.faila.4162 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4163 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4164 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8309:40  in Aes.expandKey\0A\00", align 1
@.faila.4165 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4166 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4167 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8309:40  in Aes.expandKey\0A\00", align 1
@.faila.4168 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4169 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4170 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8310:40  in Aes.expandKey\0A\00", align 1
@.faila.4171 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4172 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4173 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8310:40  in Aes.expandKey\0A\00", align 1
@.faila.4174 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4175 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4176 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8315:61  in Aes.addRoundKey\0A\00", align 1
@.faila.4177 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4178 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4179 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8315:61  in Aes.addRoundKey\0A\00", align 1
@.faila.4180 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4181 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4182 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8315:61  in Aes.addRoundKey\0A\00", align 1
@.faila.4183 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4184 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4185 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8318:61  in Aes.subBytes\0A\00", align 1
@.faila.4186 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4187 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4188 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8318:61  in Aes.subBytes\0A\00", align 1
@.faila.4189 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4190 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4191 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8318:61  in Aes.subBytes\0A\00", align 1
@.faila.4192 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4193 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4194 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8321:61  in Aes.invSubBytes\0A\00", align 1
@.faila.4195 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4196 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4197 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8321:61  in Aes.invSubBytes\0A\00", align 1
@.faila.4198 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4199 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4200 = private unnamed_addr constant [86 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8321:61  in Aes.invSubBytes\0A\00", align 1
@.faila.4201 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4202 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4203 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8326:72  in Aes.shiftRows\0A\00", align 1
@.faila.4204 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4205 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4206 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8326:72  in Aes.shiftRows\0A\00", align 1
@.faila.4207 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4208 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4209 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8328:61  in Aes.shiftRows\0A\00", align 1
@.faila.4210 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4211 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4212 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8328:61  in Aes.shiftRows\0A\00", align 1
@.faila.4213 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4214 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4215 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8333:72  in Aes.invShiftRows\0A\00", align 1
@.faila.4216 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4217 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4218 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8333:72  in Aes.invShiftRows\0A\00", align 1
@.faila.4219 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4220 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4221 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8335:61  in Aes.invShiftRows\0A\00", align 1
@.faila.4222 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4223 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4224 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8335:61  in Aes.invShiftRows\0A\00", align 1
@.faila.4225 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4226 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4227 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8339:21  in Aes.mixColumns\0A\00", align 1
@.faila.4228 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4229 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4230 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8340:21  in Aes.mixColumns\0A\00", align 1
@.faila.4231 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4232 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4233 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8341:21  in Aes.mixColumns\0A\00", align 1
@.faila.4234 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4235 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4236 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8342:21  in Aes.mixColumns\0A\00", align 1
@.faila.4237 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4238 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4239 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8343:34  in Aes.mixColumns\0A\00", align 1
@.faila.4240 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4241 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4242 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8344:34  in Aes.mixColumns\0A\00", align 1
@.faila.4243 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4244 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4245 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8345:34  in Aes.mixColumns\0A\00", align 1
@.faila.4246 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4247 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4248 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8346:34  in Aes.mixColumns\0A\00", align 1
@.faila.4249 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4250 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4251 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8351:21  in Aes.invMixColumns\0A\00", align 1
@.faila.4252 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4253 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4254 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8352:21  in Aes.invMixColumns\0A\00", align 1
@.faila.4255 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4256 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4257 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8353:21  in Aes.invMixColumns\0A\00", align 1
@.faila.4258 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4259 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4260 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8354:21  in Aes.invMixColumns\0A\00", align 1
@.faila.4261 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4262 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4263 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8355:34  in Aes.invMixColumns\0A\00", align 1
@.faila.4264 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4265 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4266 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8356:34  in Aes.invMixColumns\0A\00", align 1
@.faila.4267 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4268 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4269 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8357:34  in Aes.invMixColumns\0A\00", align 1
@.faila.4270 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4271 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4272 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8358:34  in Aes.invMixColumns\0A\00", align 1
@.faila.4273 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4274 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4275 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8363:61  in Aes.encryptBlock\0A\00", align 1
@.faila.4276 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4277 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4278 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8363:61  in Aes.encryptBlock\0A\00", align 1
@.faila.4279 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4280 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4281 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8378:61  in Aes.decryptBlock\0A\00", align 1
@.faila.4282 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4283 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4284 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8378:61  in Aes.decryptBlock\0A\00", align 1
@.faila.4285 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4286 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4287 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8397:67  in Aes.ctr\0A\00", align 1
@.faila.4288 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4289 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4290 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8397:67  in Aes.ctr\0A\00", align 1
@.faila.4291 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4292 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4293 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8403:38  in Aes.ctr\0A\00", align 1
@.faila.4294 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4295 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4296 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8403:38  in Aes.ctr\0A\00", align 1
@.faila.4297 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4298 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4299 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8403:38  in Aes.ctr\0A\00", align 1
@.faila.4300 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4301 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4302 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8409:36  in Aes.ctr\0A\00", align 1
@.faila.4303 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4304 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4305 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8409:36  in Aes.ctr\0A\00", align 1
@.faila.4306 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4307 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4308 = private unnamed_addr constant [78 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8410:25  in Aes.ctr\0A\00", align 1
@.faila.4309 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4310 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5446 = private constant [1 x i8] zeroinitializer
@.strobj.5447 = private global %String { i64 0, ptr @.strdata.5446, i64 0 }
@.strdata.5448 = private constant [1 x i8] zeroinitializer
@.strobj.5449 = private global %String { i64 0, ptr @.strdata.5448, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %i406 = alloca i32, align 4
  %vec256 = alloca i32, align 4
  %want256 = alloca ptr, align 8
  %ct256 = alloca ptr, align 8
  %aes256 = alloca ptr, align 8
  %i273 = alloca i32, align 4
  %key256 = alloca ptr, align 8
  %i225 = alloca i32, align 4
  %changed = alloca i32, align 4
  %ctrok = alloca i32, align 4
  %dec = alloca ptr, align 8
  %enc = alloca ptr, align 8
  %i205 = alloca i32, align 4
  %iv = alloca ptr, align 8
  %i188 = alloca i32, align 4
  %msg = alloca ptr, align 8
  %i160 = alloca i32, align 4
  %ecb = alloca i32, align 4
  %rt = alloca ptr, align 8
  %i135 = alloca i32, align 4
  %vec = alloca i32, align 4
  %want = alloca ptr, align 8
  %ct = alloca ptr, align 8
  %aes = alloca ptr, align 8
  %i = alloca i32, align 4
  %pt = alloca ptr, align 8
  %key = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 64)
  store ptr %arr, ptr %key, align 8
  %arr2 = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr2, align 8
  %arr.data3 = getelementptr i8, ptr %arr2, i64 8
  %17 = call ptr @memset(ptr %arr.data3, i32 0, i64 64)
  store ptr %arr2, ptr %pt, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %argv.end
  %i4 = load i32, ptr %i, align 4
  %18 = icmp slt i32 %i4, 16
  %19 = zext i1 %18 to i32
  br i1 %18, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %key5 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %20 = sext i32 %i6 to i64
  %arr.len = load i64, ptr %key5, align 8
  %arr.oob = icmp uge i64 %20, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok14
  %21 = load i32, ptr %i, align 4
  %22 = add i32 %21, 1
  store i32 %22, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %Aes.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Aes, ptr null, i64 1) to i64))
  %key18 = load ptr, ptr %key, align 8
  call void @Aes.Aes(ptr %Aes.obj, ptr %key18)
  store ptr %Aes.obj, ptr %aes, align 8
  %aes19 = load ptr, ptr %aes, align 8
  %pt20 = load ptr, ptr %pt, align 8
  %23 = call ptr @Aes.encryptBlock(ptr %aes19, ptr %pt20)
  store ptr %23, ptr %ct, align 8
  %arr21 = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr21, align 8
  %arr.data22 = getelementptr i8, ptr %arr21, i64 8
  %24 = call ptr @memset(ptr %arr.data22, i32 0, i64 64)
  store ptr %arr21, ptr %want, align 8
  %want23 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len24 = load i64, ptr %want23, align 8
  %arr.oob25 = icmp uge i64 0, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 %20, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data7 = getelementptr i8, ptr %key5, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data7, i64 %20
  %i8 = load i32, ptr %i, align 4
  store i32 %i8, ptr %arr.elem, align 4
  %pt9 = load ptr, ptr %pt, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %25 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %pt9, align 8
  %arr.oob12 = icmp uge i64 %25, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 %25, ptr @.failb.3, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %pt9, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %25
  %i17 = load i32, ptr %i, align 4
  %26 = mul i32 %i17, 17
  store i32 %26, ptr %arr.elem16, align 4
  br label %for.update

idx.bad26:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 0, ptr @.failb.6, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %for.end
  %arr.data28 = getelementptr i8, ptr %want23, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 0
  store i32 105, ptr %arr.elem29, align 4
  %want30 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len31 = load i64, ptr %want30, align 8
  %arr.oob32 = icmp uge i64 1, %arr.len31
  br i1 %arr.oob32, label %idx.bad33, label %idx.ok34, !prof !2

idx.bad33:                                        ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 1, ptr @.failb.9, i64 %arr.len31, i32 70)
  unreachable

idx.ok34:                                         ; preds = %idx.ok27
  %arr.data35 = getelementptr i8, ptr %want30, i64 8
  %arr.elem36 = getelementptr inbounds i32, ptr %arr.data35, i64 1
  store i32 196, ptr %arr.elem36, align 4
  %want37 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len38 = load i64, ptr %want37, align 8
  %arr.oob39 = icmp uge i64 2, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !2

idx.bad40:                                        ; preds = %idx.ok34
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 2, ptr @.failb.12, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %idx.ok34
  %arr.data42 = getelementptr i8, ptr %want37, i64 8
  %arr.elem43 = getelementptr inbounds i32, ptr %arr.data42, i64 2
  store i32 224, ptr %arr.elem43, align 4
  %want44 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len45 = load i64, ptr %want44, align 8
  %arr.oob46 = icmp uge i64 3, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok41
  call void @__polaron_fail(ptr @.fail.13, ptr @.faila.14, i64 3, ptr @.failb.15, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok41
  %arr.data49 = getelementptr i8, ptr %want44, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 3
  store i32 216, ptr %arr.elem50, align 4
  %want51 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len52 = load i64, ptr %want51, align 8
  %arr.oob53 = icmp uge i64 4, %arr.len52
  br i1 %arr.oob53, label %idx.bad54, label %idx.ok55, !prof !2

idx.bad54:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.16, ptr @.faila.17, i64 4, ptr @.failb.18, i64 %arr.len52, i32 70)
  unreachable

idx.ok55:                                         ; preds = %idx.ok48
  %arr.data56 = getelementptr i8, ptr %want51, i64 8
  %arr.elem57 = getelementptr inbounds i32, ptr %arr.data56, i64 4
  store i32 106, ptr %arr.elem57, align 4
  %want58 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len59 = load i64, ptr %want58, align 8
  %arr.oob60 = icmp uge i64 5, %arr.len59
  br i1 %arr.oob60, label %idx.bad61, label %idx.ok62, !prof !2

idx.bad61:                                        ; preds = %idx.ok55
  call void @__polaron_fail(ptr @.fail.19, ptr @.faila.20, i64 5, ptr @.failb.21, i64 %arr.len59, i32 70)
  unreachable

idx.ok62:                                         ; preds = %idx.ok55
  %arr.data63 = getelementptr i8, ptr %want58, i64 8
  %arr.elem64 = getelementptr inbounds i32, ptr %arr.data63, i64 5
  store i32 123, ptr %arr.elem64, align 4
  %want65 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len66 = load i64, ptr %want65, align 8
  %arr.oob67 = icmp uge i64 6, %arr.len66
  br i1 %arr.oob67, label %idx.bad68, label %idx.ok69, !prof !2

idx.bad68:                                        ; preds = %idx.ok62
  call void @__polaron_fail(ptr @.fail.22, ptr @.faila.23, i64 6, ptr @.failb.24, i64 %arr.len66, i32 70)
  unreachable

idx.ok69:                                         ; preds = %idx.ok62
  %arr.data70 = getelementptr i8, ptr %want65, i64 8
  %arr.elem71 = getelementptr inbounds i32, ptr %arr.data70, i64 6
  store i32 4, ptr %arr.elem71, align 4
  %want72 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len73 = load i64, ptr %want72, align 8
  %arr.oob74 = icmp uge i64 7, %arr.len73
  br i1 %arr.oob74, label %idx.bad75, label %idx.ok76, !prof !2

idx.bad75:                                        ; preds = %idx.ok69
  call void @__polaron_fail(ptr @.fail.25, ptr @.faila.26, i64 7, ptr @.failb.27, i64 %arr.len73, i32 70)
  unreachable

idx.ok76:                                         ; preds = %idx.ok69
  %arr.data77 = getelementptr i8, ptr %want72, i64 8
  %arr.elem78 = getelementptr inbounds i32, ptr %arr.data77, i64 7
  store i32 48, ptr %arr.elem78, align 4
  %want79 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len80 = load i64, ptr %want79, align 8
  %arr.oob81 = icmp uge i64 8, %arr.len80
  br i1 %arr.oob81, label %idx.bad82, label %idx.ok83, !prof !2

idx.bad82:                                        ; preds = %idx.ok76
  call void @__polaron_fail(ptr @.fail.28, ptr @.faila.29, i64 8, ptr @.failb.30, i64 %arr.len80, i32 70)
  unreachable

idx.ok83:                                         ; preds = %idx.ok76
  %arr.data84 = getelementptr i8, ptr %want79, i64 8
  %arr.elem85 = getelementptr inbounds i32, ptr %arr.data84, i64 8
  store i32 216, ptr %arr.elem85, align 4
  %want86 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len87 = load i64, ptr %want86, align 8
  %arr.oob88 = icmp uge i64 9, %arr.len87
  br i1 %arr.oob88, label %idx.bad89, label %idx.ok90, !prof !2

idx.bad89:                                        ; preds = %idx.ok83
  call void @__polaron_fail(ptr @.fail.31, ptr @.faila.32, i64 9, ptr @.failb.33, i64 %arr.len87, i32 70)
  unreachable

idx.ok90:                                         ; preds = %idx.ok83
  %arr.data91 = getelementptr i8, ptr %want86, i64 8
  %arr.elem92 = getelementptr inbounds i32, ptr %arr.data91, i64 9
  store i32 205, ptr %arr.elem92, align 4
  %want93 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len94 = load i64, ptr %want93, align 8
  %arr.oob95 = icmp uge i64 10, %arr.len94
  br i1 %arr.oob95, label %idx.bad96, label %idx.ok97, !prof !2

idx.bad96:                                        ; preds = %idx.ok90
  call void @__polaron_fail(ptr @.fail.34, ptr @.faila.35, i64 10, ptr @.failb.36, i64 %arr.len94, i32 70)
  unreachable

idx.ok97:                                         ; preds = %idx.ok90
  %arr.data98 = getelementptr i8, ptr %want93, i64 8
  %arr.elem99 = getelementptr inbounds i32, ptr %arr.data98, i64 10
  store i32 183, ptr %arr.elem99, align 4
  %want100 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len101 = load i64, ptr %want100, align 8
  %arr.oob102 = icmp uge i64 11, %arr.len101
  br i1 %arr.oob102, label %idx.bad103, label %idx.ok104, !prof !2

idx.bad103:                                       ; preds = %idx.ok97
  call void @__polaron_fail(ptr @.fail.37, ptr @.faila.38, i64 11, ptr @.failb.39, i64 %arr.len101, i32 70)
  unreachable

idx.ok104:                                        ; preds = %idx.ok97
  %arr.data105 = getelementptr i8, ptr %want100, i64 8
  %arr.elem106 = getelementptr inbounds i32, ptr %arr.data105, i64 11
  store i32 128, ptr %arr.elem106, align 4
  %want107 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len108 = load i64, ptr %want107, align 8
  %arr.oob109 = icmp uge i64 12, %arr.len108
  br i1 %arr.oob109, label %idx.bad110, label %idx.ok111, !prof !2

idx.bad110:                                       ; preds = %idx.ok104
  call void @__polaron_fail(ptr @.fail.40, ptr @.faila.41, i64 12, ptr @.failb.42, i64 %arr.len108, i32 70)
  unreachable

idx.ok111:                                        ; preds = %idx.ok104
  %arr.data112 = getelementptr i8, ptr %want107, i64 8
  %arr.elem113 = getelementptr inbounds i32, ptr %arr.data112, i64 12
  store i32 112, ptr %arr.elem113, align 4
  %want114 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len115 = load i64, ptr %want114, align 8
  %arr.oob116 = icmp uge i64 13, %arr.len115
  br i1 %arr.oob116, label %idx.bad117, label %idx.ok118, !prof !2

idx.bad117:                                       ; preds = %idx.ok111
  call void @__polaron_fail(ptr @.fail.43, ptr @.faila.44, i64 13, ptr @.failb.45, i64 %arr.len115, i32 70)
  unreachable

idx.ok118:                                        ; preds = %idx.ok111
  %arr.data119 = getelementptr i8, ptr %want114, i64 8
  %arr.elem120 = getelementptr inbounds i32, ptr %arr.data119, i64 13
  store i32 180, ptr %arr.elem120, align 4
  %want121 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len122 = load i64, ptr %want121, align 8
  %arr.oob123 = icmp uge i64 14, %arr.len122
  br i1 %arr.oob123, label %idx.bad124, label %idx.ok125, !prof !2

idx.bad124:                                       ; preds = %idx.ok118
  call void @__polaron_fail(ptr @.fail.46, ptr @.faila.47, i64 14, ptr @.failb.48, i64 %arr.len122, i32 70)
  unreachable

idx.ok125:                                        ; preds = %idx.ok118
  %arr.data126 = getelementptr i8, ptr %want121, i64 8
  %arr.elem127 = getelementptr inbounds i32, ptr %arr.data126, i64 14
  store i32 197, ptr %arr.elem127, align 4
  %want128 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %arr.len129 = load i64, ptr %want128, align 8
  %arr.oob130 = icmp uge i64 15, %arr.len129
  br i1 %arr.oob130, label %idx.bad131, label %idx.ok132, !prof !2

idx.bad131:                                       ; preds = %idx.ok125
  call void @__polaron_fail(ptr @.fail.49, ptr @.faila.50, i64 15, ptr @.failb.51, i64 %arr.len129, i32 70)
  unreachable

idx.ok132:                                        ; preds = %idx.ok125
  %arr.data133 = getelementptr i8, ptr %want128, i64 8
  %arr.elem134 = getelementptr inbounds i32, ptr %arr.data133, i64 15
  store i32 90, ptr %arr.elem134, align 4
  store i32 1, ptr %vec, align 4
  store i32 0, ptr %i135, align 4
  br label %for.cond136

for.cond136:                                      ; preds = %for.update138, %idx.ok132
  %i140 = load i32, ptr %i135, align 4
  %27 = icmp slt i32 %i140, 16
  %28 = zext i1 %27 to i32
  br i1 %27, label %for.body137, label %for.end139

for.body137:                                      ; preds = %for.cond136
  %ct141 = load ptr, ptr %ct, align 8, !nonnull !0, !dereferenceable !1
  %i142 = load i32, ptr %i135, align 4
  %29 = sext i32 %i142 to i64
  %arr.len143 = load i64, ptr %ct141, align 8
  %arr.oob144 = icmp uge i64 %29, %arr.len143
  br i1 %arr.oob144, label %idx.bad145, label %idx.ok146, !prof !2

for.update138:                                    ; preds = %if.end
  %30 = load i32, ptr %i135, align 4
  %31 = add i32 %30, 1
  store i32 %31, ptr %i135, align 4
  br label %for.cond136

for.end139:                                       ; preds = %for.cond136
  %aes158 = load ptr, ptr %aes, align 8
  %ct159 = load ptr, ptr %ct, align 8
  %32 = call ptr @Aes.decryptBlock(ptr %aes158, ptr %ct159)
  store ptr %32, ptr %rt, align 8
  store i32 1, ptr %ecb, align 4
  store i32 0, ptr %i160, align 4
  br label %for.cond161

idx.bad145:                                       ; preds = %for.body137
  call void @__polaron_fail(ptr @.fail.52, ptr @.faila.53, i64 %29, ptr @.failb.54, i64 %arr.len143, i32 70)
  unreachable

idx.ok146:                                        ; preds = %for.body137
  %arr.data147 = getelementptr i8, ptr %ct141, i64 8
  %arr.elem148 = getelementptr inbounds i32, ptr %arr.data147, i64 %29
  %elem = load i32, ptr %arr.elem148, align 4
  %want149 = load ptr, ptr %want, align 8, !nonnull !0, !dereferenceable !1
  %i150 = load i32, ptr %i135, align 4
  %33 = sext i32 %i150 to i64
  %arr.len151 = load i64, ptr %want149, align 8
  %arr.oob152 = icmp uge i64 %33, %arr.len151
  br i1 %arr.oob152, label %idx.bad153, label %idx.ok154, !prof !2

idx.bad153:                                       ; preds = %idx.ok146
  call void @__polaron_fail(ptr @.fail.55, ptr @.faila.56, i64 %33, ptr @.failb.57, i64 %arr.len151, i32 70)
  unreachable

idx.ok154:                                        ; preds = %idx.ok146
  %arr.data155 = getelementptr i8, ptr %want149, i64 8
  %arr.elem156 = getelementptr inbounds i32, ptr %arr.data155, i64 %33
  %elem157 = load i32, ptr %arr.elem156, align 4
  %34 = icmp ne i32 %elem, %elem157
  %35 = zext i1 %34 to i32
  br i1 %34, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok154
  store i32 0, ptr %vec, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok154
  br label %for.update138

for.cond161:                                      ; preds = %for.update163, %for.end139
  %i165 = load i32, ptr %i160, align 4
  %36 = icmp slt i32 %i165, 16
  %37 = zext i1 %36 to i32
  br i1 %36, label %for.body162, label %for.end164

for.body162:                                      ; preds = %for.cond161
  %rt166 = load ptr, ptr %rt, align 8, !nonnull !0, !dereferenceable !1
  %i167 = load i32, ptr %i160, align 4
  %38 = sext i32 %i167 to i64
  %arr.len168 = load i64, ptr %rt166, align 8
  %arr.oob169 = icmp uge i64 %38, %arr.len168
  br i1 %arr.oob169, label %idx.bad170, label %idx.ok171, !prof !2

for.update163:                                    ; preds = %if.end185
  %39 = load i32, ptr %i160, align 4
  %40 = add i32 %39, 1
  store i32 %40, ptr %i160, align 4
  br label %for.cond161

for.end164:                                       ; preds = %for.cond161
  %arr186 = call ptr @__polaron_malloc(i64 88)
  store i64 20, ptr %arr186, align 8
  %arr.data187 = getelementptr i8, ptr %arr186, i64 8
  %41 = call ptr @memset(ptr %arr.data187, i32 0, i64 80)
  store ptr %arr186, ptr %msg, align 8
  store i32 0, ptr %i188, align 4
  br label %for.cond189

idx.bad170:                                       ; preds = %for.body162
  call void @__polaron_fail(ptr @.fail.58, ptr @.faila.59, i64 %38, ptr @.failb.60, i64 %arr.len168, i32 70)
  unreachable

idx.ok171:                                        ; preds = %for.body162
  %arr.data172 = getelementptr i8, ptr %rt166, i64 8
  %arr.elem173 = getelementptr inbounds i32, ptr %arr.data172, i64 %38
  %elem174 = load i32, ptr %arr.elem173, align 4
  %pt175 = load ptr, ptr %pt, align 8, !nonnull !0, !dereferenceable !1
  %i176 = load i32, ptr %i160, align 4
  %42 = sext i32 %i176 to i64
  %arr.len177 = load i64, ptr %pt175, align 8
  %arr.oob178 = icmp uge i64 %42, %arr.len177
  br i1 %arr.oob178, label %idx.bad179, label %idx.ok180, !prof !2

idx.bad179:                                       ; preds = %idx.ok171
  call void @__polaron_fail(ptr @.fail.61, ptr @.faila.62, i64 %42, ptr @.failb.63, i64 %arr.len177, i32 70)
  unreachable

idx.ok180:                                        ; preds = %idx.ok171
  %arr.data181 = getelementptr i8, ptr %pt175, i64 8
  %arr.elem182 = getelementptr inbounds i32, ptr %arr.data181, i64 %42
  %elem183 = load i32, ptr %arr.elem182, align 4
  %43 = icmp ne i32 %elem174, %elem183
  %44 = zext i1 %43 to i32
  br i1 %43, label %if.then184, label %if.end185

if.then184:                                       ; preds = %idx.ok180
  store i32 0, ptr %ecb, align 4
  br label %if.end185

if.end185:                                        ; preds = %if.then184, %idx.ok180
  br label %for.update163

for.cond189:                                      ; preds = %for.update191, %for.end164
  %i193 = load i32, ptr %i188, align 4
  %45 = icmp slt i32 %i193, 20
  %46 = zext i1 %45 to i32
  br i1 %45, label %for.body190, label %for.end192

for.body190:                                      ; preds = %for.cond189
  %msg194 = load ptr, ptr %msg, align 8, !nonnull !0, !dereferenceable !1
  %i195 = load i32, ptr %i188, align 4
  %47 = sext i32 %i195 to i64
  %arr.len196 = load i64, ptr %msg194, align 8
  %arr.oob197 = icmp uge i64 %47, %arr.len196
  br i1 %arr.oob197, label %idx.bad198, label %idx.ok199, !prof !2

for.update191:                                    ; preds = %idx.ok199
  %48 = load i32, ptr %i188, align 4
  %49 = add i32 %48, 1
  store i32 %49, ptr %i188, align 4
  br label %for.cond189

for.end192:                                       ; preds = %for.cond189
  %arr203 = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr203, align 8
  %arr.data204 = getelementptr i8, ptr %arr203, i64 8
  %50 = call ptr @memset(ptr %arr.data204, i32 0, i64 64)
  store ptr %arr203, ptr %iv, align 8
  store i32 0, ptr %i205, align 4
  br label %for.cond206

idx.bad198:                                       ; preds = %for.body190
  call void @__polaron_fail(ptr @.fail.64, ptr @.faila.65, i64 %47, ptr @.failb.66, i64 %arr.len196, i32 70)
  unreachable

idx.ok199:                                        ; preds = %for.body190
  %arr.data200 = getelementptr i8, ptr %msg194, i64 8
  %arr.elem201 = getelementptr inbounds i32, ptr %arr.data200, i64 %47
  %i202 = load i32, ptr %i188, align 4
  %51 = mul i32 %i202, 7
  %52 = add i32 %51, 3
  %53 = and i32 %52, 255
  store i32 %53, ptr %arr.elem201, align 4
  br label %for.update191

for.cond206:                                      ; preds = %for.update208, %for.end192
  %i210 = load i32, ptr %i205, align 4
  %54 = icmp slt i32 %i210, 16
  %55 = zext i1 %54 to i32
  br i1 %54, label %for.body207, label %for.end209

for.body207:                                      ; preds = %for.cond206
  %iv211 = load ptr, ptr %iv, align 8, !nonnull !0, !dereferenceable !1
  %i212 = load i32, ptr %i205, align 4
  %56 = sext i32 %i212 to i64
  %arr.len213 = load i64, ptr %iv211, align 8
  %arr.oob214 = icmp uge i64 %56, %arr.len213
  br i1 %arr.oob214, label %idx.bad215, label %idx.ok216, !prof !2

for.update208:                                    ; preds = %idx.ok216
  %57 = load i32, ptr %i205, align 4
  %58 = add i32 %57, 1
  store i32 %58, ptr %i205, align 4
  br label %for.cond206

for.end209:                                       ; preds = %for.cond206
  %aes219 = load ptr, ptr %aes, align 8
  %msg220 = load ptr, ptr %msg, align 8
  %iv221 = load ptr, ptr %iv, align 8
  %59 = call ptr @Aes.ctr(ptr %aes219, ptr %msg220, ptr %iv221)
  store ptr %59, ptr %enc, align 8
  %aes222 = load ptr, ptr %aes, align 8
  %enc223 = load ptr, ptr %enc, align 8
  %iv224 = load ptr, ptr %iv, align 8
  %60 = call ptr @Aes.ctr(ptr %aes222, ptr %enc223, ptr %iv224)
  store ptr %60, ptr %dec, align 8
  store i32 1, ptr %ctrok, align 4
  store i32 0, ptr %changed, align 4
  store i32 0, ptr %i225, align 4
  br label %for.cond226

idx.bad215:                                       ; preds = %for.body207
  call void @__polaron_fail(ptr @.fail.67, ptr @.faila.68, i64 %56, ptr @.failb.69, i64 %arr.len213, i32 70)
  unreachable

idx.ok216:                                        ; preds = %for.body207
  %arr.data217 = getelementptr i8, ptr %iv211, i64 8
  %arr.elem218 = getelementptr inbounds i32, ptr %arr.data217, i64 %56
  store i32 0, ptr %arr.elem218, align 4
  br label %for.update208

for.cond226:                                      ; preds = %for.update228, %for.end209
  %i230 = load i32, ptr %i225, align 4
  %61 = icmp slt i32 %i230, 20
  %62 = zext i1 %61 to i32
  br i1 %61, label %for.body227, label %for.end229

for.body227:                                      ; preds = %for.cond226
  %dec231 = load ptr, ptr %dec, align 8, !nonnull !0, !dereferenceable !1
  %i232 = load i32, ptr %i225, align 4
  %63 = sext i32 %i232 to i64
  %arr.len233 = load i64, ptr %dec231, align 8
  %arr.oob234 = icmp uge i64 %63, %arr.len233
  br i1 %arr.oob234, label %idx.bad235, label %idx.ok236, !prof !2

for.update228:                                    ; preds = %if.end270
  %64 = load i32, ptr %i225, align 4
  %65 = add i32 %64, 1
  store i32 %65, ptr %i225, align 4
  br label %for.cond226

for.end229:                                       ; preds = %for.cond226
  %arr271 = call ptr @__polaron_malloc(i64 136)
  store i64 32, ptr %arr271, align 8
  %arr.data272 = getelementptr i8, ptr %arr271, i64 8
  %66 = call ptr @memset(ptr %arr.data272, i32 0, i64 128)
  store ptr %arr271, ptr %key256, align 8
  store i32 0, ptr %i273, align 4
  br label %for.cond274

idx.bad235:                                       ; preds = %for.body227
  call void @__polaron_fail(ptr @.fail.70, ptr @.faila.71, i64 %63, ptr @.failb.72, i64 %arr.len233, i32 70)
  unreachable

idx.ok236:                                        ; preds = %for.body227
  %arr.data237 = getelementptr i8, ptr %dec231, i64 8
  %arr.elem238 = getelementptr inbounds i32, ptr %arr.data237, i64 %63
  %elem239 = load i32, ptr %arr.elem238, align 4
  %msg240 = load ptr, ptr %msg, align 8, !nonnull !0, !dereferenceable !1
  %i241 = load i32, ptr %i225, align 4
  %67 = sext i32 %i241 to i64
  %arr.len242 = load i64, ptr %msg240, align 8
  %arr.oob243 = icmp uge i64 %67, %arr.len242
  br i1 %arr.oob243, label %idx.bad244, label %idx.ok245, !prof !2

idx.bad244:                                       ; preds = %idx.ok236
  call void @__polaron_fail(ptr @.fail.73, ptr @.faila.74, i64 %67, ptr @.failb.75, i64 %arr.len242, i32 70)
  unreachable

idx.ok245:                                        ; preds = %idx.ok236
  %arr.data246 = getelementptr i8, ptr %msg240, i64 8
  %arr.elem247 = getelementptr inbounds i32, ptr %arr.data246, i64 %67
  %elem248 = load i32, ptr %arr.elem247, align 4
  %68 = icmp ne i32 %elem239, %elem248
  %69 = zext i1 %68 to i32
  br i1 %68, label %if.then249, label %if.end250

if.then249:                                       ; preds = %idx.ok245
  store i32 0, ptr %ctrok, align 4
  br label %if.end250

if.end250:                                        ; preds = %if.then249, %idx.ok245
  %enc251 = load ptr, ptr %enc, align 8, !nonnull !0, !dereferenceable !1
  %i252 = load i32, ptr %i225, align 4
  %70 = sext i32 %i252 to i64
  %arr.len253 = load i64, ptr %enc251, align 8
  %arr.oob254 = icmp uge i64 %70, %arr.len253
  br i1 %arr.oob254, label %idx.bad255, label %idx.ok256, !prof !2

idx.bad255:                                       ; preds = %if.end250
  call void @__polaron_fail(ptr @.fail.76, ptr @.faila.77, i64 %70, ptr @.failb.78, i64 %arr.len253, i32 70)
  unreachable

idx.ok256:                                        ; preds = %if.end250
  %arr.data257 = getelementptr i8, ptr %enc251, i64 8
  %arr.elem258 = getelementptr inbounds i32, ptr %arr.data257, i64 %70
  %elem259 = load i32, ptr %arr.elem258, align 4
  %msg260 = load ptr, ptr %msg, align 8, !nonnull !0, !dereferenceable !1
  %i261 = load i32, ptr %i225, align 4
  %71 = sext i32 %i261 to i64
  %arr.len262 = load i64, ptr %msg260, align 8
  %arr.oob263 = icmp uge i64 %71, %arr.len262
  br i1 %arr.oob263, label %idx.bad264, label %idx.ok265, !prof !2

idx.bad264:                                       ; preds = %idx.ok256
  call void @__polaron_fail(ptr @.fail.79, ptr @.faila.80, i64 %71, ptr @.failb.81, i64 %arr.len262, i32 70)
  unreachable

idx.ok265:                                        ; preds = %idx.ok256
  %arr.data266 = getelementptr i8, ptr %msg260, i64 8
  %arr.elem267 = getelementptr inbounds i32, ptr %arr.data266, i64 %71
  %elem268 = load i32, ptr %arr.elem267, align 4
  %72 = icmp ne i32 %elem259, %elem268
  %73 = zext i1 %72 to i32
  br i1 %72, label %if.then269, label %if.end270

if.then269:                                       ; preds = %idx.ok265
  store i32 1, ptr %changed, align 4
  br label %if.end270

if.end270:                                        ; preds = %if.then269, %idx.ok265
  br label %for.update228

for.cond274:                                      ; preds = %for.update276, %for.end229
  %i278 = load i32, ptr %i273, align 4
  %74 = icmp slt i32 %i278, 32
  %75 = zext i1 %74 to i32
  br i1 %74, label %for.body275, label %for.end277

for.body275:                                      ; preds = %for.cond274
  %key256279 = load ptr, ptr %key256, align 8, !nonnull !0, !dereferenceable !1
  %i280 = load i32, ptr %i273, align 4
  %76 = sext i32 %i280 to i64
  %arr.len281 = load i64, ptr %key256279, align 8
  %arr.oob282 = icmp uge i64 %76, %arr.len281
  br i1 %arr.oob282, label %idx.bad283, label %idx.ok284, !prof !2

for.update276:                                    ; preds = %idx.ok284
  %77 = load i32, ptr %i273, align 4
  %78 = add i32 %77, 1
  store i32 %78, ptr %i273, align 4
  br label %for.cond274

for.end277:                                       ; preds = %for.cond274
  %Aes.obj288 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Aes, ptr null, i64 1) to i64))
  %key256289 = load ptr, ptr %key256, align 8
  call void @Aes.Aes(ptr %Aes.obj288, ptr %key256289)
  store ptr %Aes.obj288, ptr %aes256, align 8
  %aes256290 = load ptr, ptr %aes256, align 8
  %pt291 = load ptr, ptr %pt, align 8
  %79 = call ptr @Aes.encryptBlock(ptr %aes256290, ptr %pt291)
  store ptr %79, ptr %ct256, align 8
  %arr292 = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr292, align 8
  %arr.data293 = getelementptr i8, ptr %arr292, i64 8
  %80 = call ptr @memset(ptr %arr.data293, i32 0, i64 64)
  store ptr %arr292, ptr %want256, align 8
  %want256294 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len295 = load i64, ptr %want256294, align 8
  %arr.oob296 = icmp uge i64 0, %arr.len295
  br i1 %arr.oob296, label %idx.bad297, label %idx.ok298, !prof !2

idx.bad283:                                       ; preds = %for.body275
  call void @__polaron_fail(ptr @.fail.82, ptr @.faila.83, i64 %76, ptr @.failb.84, i64 %arr.len281, i32 70)
  unreachable

idx.ok284:                                        ; preds = %for.body275
  %arr.data285 = getelementptr i8, ptr %key256279, i64 8
  %arr.elem286 = getelementptr inbounds i32, ptr %arr.data285, i64 %76
  %i287 = load i32, ptr %i273, align 4
  store i32 %i287, ptr %arr.elem286, align 4
  br label %for.update276

idx.bad297:                                       ; preds = %for.end277
  call void @__polaron_fail(ptr @.fail.85, ptr @.faila.86, i64 0, ptr @.failb.87, i64 %arr.len295, i32 70)
  unreachable

idx.ok298:                                        ; preds = %for.end277
  %arr.data299 = getelementptr i8, ptr %want256294, i64 8
  %arr.elem300 = getelementptr inbounds i32, ptr %arr.data299, i64 0
  store i32 142, ptr %arr.elem300, align 4
  %want256301 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len302 = load i64, ptr %want256301, align 8
  %arr.oob303 = icmp uge i64 1, %arr.len302
  br i1 %arr.oob303, label %idx.bad304, label %idx.ok305, !prof !2

idx.bad304:                                       ; preds = %idx.ok298
  call void @__polaron_fail(ptr @.fail.88, ptr @.faila.89, i64 1, ptr @.failb.90, i64 %arr.len302, i32 70)
  unreachable

idx.ok305:                                        ; preds = %idx.ok298
  %arr.data306 = getelementptr i8, ptr %want256301, i64 8
  %arr.elem307 = getelementptr inbounds i32, ptr %arr.data306, i64 1
  store i32 162, ptr %arr.elem307, align 4
  %want256308 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len309 = load i64, ptr %want256308, align 8
  %arr.oob310 = icmp uge i64 2, %arr.len309
  br i1 %arr.oob310, label %idx.bad311, label %idx.ok312, !prof !2

idx.bad311:                                       ; preds = %idx.ok305
  call void @__polaron_fail(ptr @.fail.91, ptr @.faila.92, i64 2, ptr @.failb.93, i64 %arr.len309, i32 70)
  unreachable

idx.ok312:                                        ; preds = %idx.ok305
  %arr.data313 = getelementptr i8, ptr %want256308, i64 8
  %arr.elem314 = getelementptr inbounds i32, ptr %arr.data313, i64 2
  store i32 183, ptr %arr.elem314, align 4
  %want256315 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len316 = load i64, ptr %want256315, align 8
  %arr.oob317 = icmp uge i64 3, %arr.len316
  br i1 %arr.oob317, label %idx.bad318, label %idx.ok319, !prof !2

idx.bad318:                                       ; preds = %idx.ok312
  call void @__polaron_fail(ptr @.fail.94, ptr @.faila.95, i64 3, ptr @.failb.96, i64 %arr.len316, i32 70)
  unreachable

idx.ok319:                                        ; preds = %idx.ok312
  %arr.data320 = getelementptr i8, ptr %want256315, i64 8
  %arr.elem321 = getelementptr inbounds i32, ptr %arr.data320, i64 3
  store i32 202, ptr %arr.elem321, align 4
  %want256322 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len323 = load i64, ptr %want256322, align 8
  %arr.oob324 = icmp uge i64 4, %arr.len323
  br i1 %arr.oob324, label %idx.bad325, label %idx.ok326, !prof !2

idx.bad325:                                       ; preds = %idx.ok319
  call void @__polaron_fail(ptr @.fail.97, ptr @.faila.98, i64 4, ptr @.failb.99, i64 %arr.len323, i32 70)
  unreachable

idx.ok326:                                        ; preds = %idx.ok319
  %arr.data327 = getelementptr i8, ptr %want256322, i64 8
  %arr.elem328 = getelementptr inbounds i32, ptr %arr.data327, i64 4
  store i32 81, ptr %arr.elem328, align 4
  %want256329 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len330 = load i64, ptr %want256329, align 8
  %arr.oob331 = icmp uge i64 5, %arr.len330
  br i1 %arr.oob331, label %idx.bad332, label %idx.ok333, !prof !2

idx.bad332:                                       ; preds = %idx.ok326
  call void @__polaron_fail(ptr @.fail.100, ptr @.faila.101, i64 5, ptr @.failb.102, i64 %arr.len330, i32 70)
  unreachable

idx.ok333:                                        ; preds = %idx.ok326
  %arr.data334 = getelementptr i8, ptr %want256329, i64 8
  %arr.elem335 = getelementptr inbounds i32, ptr %arr.data334, i64 5
  store i32 103, ptr %arr.elem335, align 4
  %want256336 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len337 = load i64, ptr %want256336, align 8
  %arr.oob338 = icmp uge i64 6, %arr.len337
  br i1 %arr.oob338, label %idx.bad339, label %idx.ok340, !prof !2

idx.bad339:                                       ; preds = %idx.ok333
  call void @__polaron_fail(ptr @.fail.103, ptr @.faila.104, i64 6, ptr @.failb.105, i64 %arr.len337, i32 70)
  unreachable

idx.ok340:                                        ; preds = %idx.ok333
  %arr.data341 = getelementptr i8, ptr %want256336, i64 8
  %arr.elem342 = getelementptr inbounds i32, ptr %arr.data341, i64 6
  store i32 69, ptr %arr.elem342, align 4
  %want256343 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len344 = load i64, ptr %want256343, align 8
  %arr.oob345 = icmp uge i64 7, %arr.len344
  br i1 %arr.oob345, label %idx.bad346, label %idx.ok347, !prof !2

idx.bad346:                                       ; preds = %idx.ok340
  call void @__polaron_fail(ptr @.fail.106, ptr @.faila.107, i64 7, ptr @.failb.108, i64 %arr.len344, i32 70)
  unreachable

idx.ok347:                                        ; preds = %idx.ok340
  %arr.data348 = getelementptr i8, ptr %want256343, i64 8
  %arr.elem349 = getelementptr inbounds i32, ptr %arr.data348, i64 7
  store i32 191, ptr %arr.elem349, align 4
  %want256350 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len351 = load i64, ptr %want256350, align 8
  %arr.oob352 = icmp uge i64 8, %arr.len351
  br i1 %arr.oob352, label %idx.bad353, label %idx.ok354, !prof !2

idx.bad353:                                       ; preds = %idx.ok347
  call void @__polaron_fail(ptr @.fail.109, ptr @.faila.110, i64 8, ptr @.failb.111, i64 %arr.len351, i32 70)
  unreachable

idx.ok354:                                        ; preds = %idx.ok347
  %arr.data355 = getelementptr i8, ptr %want256350, i64 8
  %arr.elem356 = getelementptr inbounds i32, ptr %arr.data355, i64 8
  store i32 234, ptr %arr.elem356, align 4
  %want256357 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len358 = load i64, ptr %want256357, align 8
  %arr.oob359 = icmp uge i64 9, %arr.len358
  br i1 %arr.oob359, label %idx.bad360, label %idx.ok361, !prof !2

idx.bad360:                                       ; preds = %idx.ok354
  call void @__polaron_fail(ptr @.fail.112, ptr @.faila.113, i64 9, ptr @.failb.114, i64 %arr.len358, i32 70)
  unreachable

idx.ok361:                                        ; preds = %idx.ok354
  %arr.data362 = getelementptr i8, ptr %want256357, i64 8
  %arr.elem363 = getelementptr inbounds i32, ptr %arr.data362, i64 9
  store i32 252, ptr %arr.elem363, align 4
  %want256364 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len365 = load i64, ptr %want256364, align 8
  %arr.oob366 = icmp uge i64 10, %arr.len365
  br i1 %arr.oob366, label %idx.bad367, label %idx.ok368, !prof !2

idx.bad367:                                       ; preds = %idx.ok361
  call void @__polaron_fail(ptr @.fail.115, ptr @.faila.116, i64 10, ptr @.failb.117, i64 %arr.len365, i32 70)
  unreachable

idx.ok368:                                        ; preds = %idx.ok361
  %arr.data369 = getelementptr i8, ptr %want256364, i64 8
  %arr.elem370 = getelementptr inbounds i32, ptr %arr.data369, i64 10
  store i32 73, ptr %arr.elem370, align 4
  %want256371 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len372 = load i64, ptr %want256371, align 8
  %arr.oob373 = icmp uge i64 11, %arr.len372
  br i1 %arr.oob373, label %idx.bad374, label %idx.ok375, !prof !2

idx.bad374:                                       ; preds = %idx.ok368
  call void @__polaron_fail(ptr @.fail.118, ptr @.faila.119, i64 11, ptr @.failb.120, i64 %arr.len372, i32 70)
  unreachable

idx.ok375:                                        ; preds = %idx.ok368
  %arr.data376 = getelementptr i8, ptr %want256371, i64 8
  %arr.elem377 = getelementptr inbounds i32, ptr %arr.data376, i64 11
  store i32 144, ptr %arr.elem377, align 4
  %want256378 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len379 = load i64, ptr %want256378, align 8
  %arr.oob380 = icmp uge i64 12, %arr.len379
  br i1 %arr.oob380, label %idx.bad381, label %idx.ok382, !prof !2

idx.bad381:                                       ; preds = %idx.ok375
  call void @__polaron_fail(ptr @.fail.121, ptr @.faila.122, i64 12, ptr @.failb.123, i64 %arr.len379, i32 70)
  unreachable

idx.ok382:                                        ; preds = %idx.ok375
  %arr.data383 = getelementptr i8, ptr %want256378, i64 8
  %arr.elem384 = getelementptr inbounds i32, ptr %arr.data383, i64 12
  store i32 75, ptr %arr.elem384, align 4
  %want256385 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len386 = load i64, ptr %want256385, align 8
  %arr.oob387 = icmp uge i64 13, %arr.len386
  br i1 %arr.oob387, label %idx.bad388, label %idx.ok389, !prof !2

idx.bad388:                                       ; preds = %idx.ok382
  call void @__polaron_fail(ptr @.fail.124, ptr @.faila.125, i64 13, ptr @.failb.126, i64 %arr.len386, i32 70)
  unreachable

idx.ok389:                                        ; preds = %idx.ok382
  %arr.data390 = getelementptr i8, ptr %want256385, i64 8
  %arr.elem391 = getelementptr inbounds i32, ptr %arr.data390, i64 13
  store i32 73, ptr %arr.elem391, align 4
  %want256392 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len393 = load i64, ptr %want256392, align 8
  %arr.oob394 = icmp uge i64 14, %arr.len393
  br i1 %arr.oob394, label %idx.bad395, label %idx.ok396, !prof !2

idx.bad395:                                       ; preds = %idx.ok389
  call void @__polaron_fail(ptr @.fail.127, ptr @.faila.128, i64 14, ptr @.failb.129, i64 %arr.len393, i32 70)
  unreachable

idx.ok396:                                        ; preds = %idx.ok389
  %arr.data397 = getelementptr i8, ptr %want256392, i64 8
  %arr.elem398 = getelementptr inbounds i32, ptr %arr.data397, i64 14
  store i32 96, ptr %arr.elem398, align 4
  %want256399 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %arr.len400 = load i64, ptr %want256399, align 8
  %arr.oob401 = icmp uge i64 15, %arr.len400
  br i1 %arr.oob401, label %idx.bad402, label %idx.ok403, !prof !2

idx.bad402:                                       ; preds = %idx.ok396
  call void @__polaron_fail(ptr @.fail.130, ptr @.faila.131, i64 15, ptr @.failb.132, i64 %arr.len400, i32 70)
  unreachable

idx.ok403:                                        ; preds = %idx.ok396
  %arr.data404 = getelementptr i8, ptr %want256399, i64 8
  %arr.elem405 = getelementptr inbounds i32, ptr %arr.data404, i64 15
  store i32 137, ptr %arr.elem405, align 4
  store i32 1, ptr %vec256, align 4
  store i32 0, ptr %i406, align 4
  br label %for.cond407

for.cond407:                                      ; preds = %for.update409, %idx.ok403
  %i411 = load i32, ptr %i406, align 4
  %81 = icmp slt i32 %i411, 16
  %82 = zext i1 %81 to i32
  br i1 %81, label %for.body408, label %for.end410

for.body408:                                      ; preds = %for.cond407
  %ct256412 = load ptr, ptr %ct256, align 8, !nonnull !0, !dereferenceable !1
  %i413 = load i32, ptr %i406, align 4
  %83 = sext i32 %i413 to i64
  %arr.len414 = load i64, ptr %ct256412, align 8
  %arr.oob415 = icmp uge i64 %83, %arr.len414
  br i1 %arr.oob415, label %idx.bad416, label %idx.ok417, !prof !2

for.update409:                                    ; preds = %if.end431
  %84 = load i32, ptr %i406, align 4
  %85 = add i32 %84, 1
  store i32 %85, ptr %i406, align 4
  br label %for.cond407

for.end410:                                       ; preds = %for.cond407
  %vec432 = load i32, ptr %vec, align 4
  %ecb433 = load i32, ptr %ecb, align 4
  %ctrok434 = load i32, ptr %ctrok, align 4
  %changed435 = load i32, ptr %changed, align 4
  %vec256436 = load i32, ptr %vec256, align 4
  %86 = call i32 (ptr, ...) @printf(ptr @.str, i32 %vec432, i32 %ecb433, i32 %ctrok434, i32 %changed435, i32 %vec256436)
  ret i32 0

idx.bad416:                                       ; preds = %for.body408
  call void @__polaron_fail(ptr @.fail.133, ptr @.faila.134, i64 %83, ptr @.failb.135, i64 %arr.len414, i32 70)
  unreachable

idx.ok417:                                        ; preds = %for.body408
  %arr.data418 = getelementptr i8, ptr %ct256412, i64 8
  %arr.elem419 = getelementptr inbounds i32, ptr %arr.data418, i64 %83
  %elem420 = load i32, ptr %arr.elem419, align 4
  %want256421 = load ptr, ptr %want256, align 8, !nonnull !0, !dereferenceable !1
  %i422 = load i32, ptr %i406, align 4
  %87 = sext i32 %i422 to i64
  %arr.len423 = load i64, ptr %want256421, align 8
  %arr.oob424 = icmp uge i64 %87, %arr.len423
  br i1 %arr.oob424, label %idx.bad425, label %idx.ok426, !prof !2

idx.bad425:                                       ; preds = %idx.ok417
  call void @__polaron_fail(ptr @.fail.136, ptr @.faila.137, i64 %87, ptr @.failb.138, i64 %arr.len423, i32 70)
  unreachable

idx.ok426:                                        ; preds = %idx.ok417
  %arr.data427 = getelementptr i8, ptr %want256421, i64 8
  %arr.elem428 = getelementptr inbounds i32, ptr %arr.data427, i64 %87
  %elem429 = load i32, ptr %arr.elem428, align 4
  %88 = icmp ne i32 %elem420, %elem429
  %89 = zext i1 %88 to i32
  br i1 %88, label %if.then430, label %if.end431

if.then430:                                       ; preds = %idx.ok426
  store i32 0, ptr %vec256, align 4
  br label %if.end431

if.end431:                                        ; preds = %if.then430, %idx.ok426
  br label %for.update409
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1446)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1448)
  ret ptr %strcpy
}

define internal void @Aes.Aes(ptr %0, ptr %1) {
entry:
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 0
  store ptr @Aes.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %sbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  store ptr null, ptr %sbox, align 8, !tbaa !3
  %invSbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 2
  store ptr null, ptr %invSbox, align 8, !tbaa !3
  %rk = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  store ptr null, ptr %rk, align 8, !tbaa !3
  call void @Aes.initTables(ptr %0)
  %key1 = load ptr, ptr %key, align 8
  call void @Aes.expandKey(ptr %0, ptr %key1)
  ret void
}

define internal i32 @Aes.xtime(ptr nonnull align 8 dereferenceable(40) %0, i32 %1) {
entry:
  %r = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %1, ptr %x, align 4
  %x1 = load i32, ptr %x, align 4
  %2 = shl i32 %x1, 1
  %3 = and i32 %2, 255
  store i32 %3, ptr %r, align 4
  %x2 = load i32, ptr %x, align 4
  %4 = and i32 %x2, 128
  %5 = icmp ne i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %r3 = load i32, ptr %r, align 4
  %7 = xor i32 %r3, 27
  store i32 %7, ptr %r, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %r4 = load i32, ptr %r, align 4
  ret i32 %r4
}

define internal i32 @Aes.rotl8(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, i32 %2) {
entry:
  %n = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 %1, ptr %b, align 4
  store i32 %2, ptr %n, align 4
  %b1 = load i32, ptr %b, align 4
  %n2 = load i32, ptr %n, align 4
  %3 = icmp ult i32 %n2, 32
  %4 = select i1 %3, i32 %n2, i32 0
  %5 = shl i32 %b1, %4
  %6 = select i1 %3, i32 %5, i32 0
  %b3 = load i32, ptr %b, align 4
  %n4 = load i32, ptr %n, align 4
  %7 = sub i32 8, %n4
  %8 = ashr i32 %b3, 31
  %9 = icmp ult i32 %7, 32
  %10 = select i1 %9, i32 %7, i32 0
  %11 = ashr i32 %b3, %10
  %12 = select i1 %9, i32 %11, i32 %8
  %13 = or i32 %6, %12
  %14 = and i32 %13, 255
  ret i32 %14
}

define internal void @Aes.initTables(ptr nonnull align 8 dereferenceable(40) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %s = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %inv = alloca i32, align 4
  %a = alloca i32, align 4
  %i = alloca i32, align 4
  %x = alloca i32, align 4
  %logt = alloca ptr, align 8
  %expt = alloca ptr, align 8
  %arr = call ptr @__polaron_malloc(i64 1032)
  store i64 256, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %1 = call ptr @memset(ptr %arr.data, i32 0, i64 1024)
  store ptr %arr, ptr %expt, align 8
  %arr1 = call ptr @__polaron_malloc(i64 1032)
  store i64 256, ptr %arr1, align 8
  %arr.data2 = getelementptr i8, ptr %arr1, i64 8
  %2 = call ptr @memset(ptr %arr.data2, i32 0, i64 1024)
  store ptr %arr1, ptr %logt, align 8
  store i32 1, ptr %x, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %3 = icmp slt i32 %i3, 255
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %expt4 = load ptr, ptr %expt, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %5 = sext i32 %i5 to i64
  %arr.len = load i64, ptr %expt4, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok13
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %arr19 = call ptr @__polaron_malloc(i64 1032)
  store i64 256, ptr %arr19, align 8
  %arr.data20 = getelementptr i8, ptr %arr19, i64 8
  %8 = call ptr @memset(ptr %arr.data20, i32 0, i64 1024)
  store ptr %arr19, ptr %sbox, align 8, !tbaa !3
  %invSbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 2
  %arr21 = call ptr @__polaron_malloc(i64 1032)
  store i64 256, ptr %arr21, align 8
  %arr.data22 = getelementptr i8, ptr %arr21, i64 8
  %9 = call ptr @memset(ptr %arr.data22, i32 0, i64 1024)
  store ptr %arr21, ptr %invSbox, align 8, !tbaa !3
  store i32 0, ptr %a, align 4
  br label %for.cond23

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4092, ptr @.faila.4093, i64 %5, ptr @.failb.4094, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data6 = getelementptr i8, ptr %expt4, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data6, i64 %5
  %x7 = load i32, ptr %x, align 4
  store i32 %x7, ptr %arr.elem, align 4
  %logt8 = load ptr, ptr %logt, align 8, !nonnull !0, !dereferenceable !1
  %x9 = load i32, ptr %x, align 4
  %10 = sext i32 %x9 to i64
  %arr.len10 = load i64, ptr %logt8, align 8
  %arr.oob11 = icmp uge i64 %10, %arr.len10
  br i1 %arr.oob11, label %idx.bad12, label %idx.ok13, !prof !2

idx.bad12:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4095, ptr @.faila.4096, i64 %10, ptr @.failb.4097, i64 %arr.len10, i32 70)
  unreachable

idx.ok13:                                         ; preds = %idx.ok
  %arr.data14 = getelementptr i8, ptr %logt8, i64 8
  %arr.elem15 = getelementptr inbounds i32, ptr %arr.data14, i64 %10
  %i16 = load i32, ptr %i, align 4
  store i32 %i16, ptr %arr.elem15, align 4
  %x17 = load i32, ptr %x, align 4
  %x18 = load i32, ptr %x, align 4
  %11 = call i32 @Aes.xtime(ptr %0, i32 %x18)
  %12 = xor i32 %x17, %11
  store i32 %12, ptr %x, align 4
  br label %for.update

for.cond23:                                       ; preds = %for.update25, %for.end
  %a27 = load i32, ptr %a, align 4
  %13 = icmp slt i32 %a27, 256
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body24, label %for.end26

for.body24:                                       ; preds = %for.cond23
  store i32 0, ptr %inv, align 4
  %a28 = load i32, ptr %a, align 4
  %15 = icmp ne i32 %a28, 0
  %16 = zext i1 %15 to i32
  br i1 %15, label %if.then, label %if.end

for.update25:                                     ; preds = %idx.ok67
  %17 = load i32, ptr %a, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %a, align 4
  br label %for.cond23

for.end26:                                        ; preds = %for.cond23
  ret void

if.then:                                          ; preds = %for.body24
  %expt29 = load ptr, ptr %expt, align 8, !nonnull !0, !dereferenceable !1
  %logt30 = load ptr, ptr %logt, align 8, !nonnull !0, !dereferenceable !1
  %a31 = load i32, ptr %a, align 4
  %19 = sext i32 %a31 to i64
  %arr.len32 = load i64, ptr %logt30, align 8
  %arr.oob33 = icmp uge i64 %19, %arr.len32
  br i1 %arr.oob33, label %idx.bad34, label %idx.ok35, !prof !2

if.end:                                           ; preds = %idx.ok41, %for.body24
  %inv45 = load i32, ptr %inv, align 4
  %inv46 = load i32, ptr %inv, align 4
  %20 = call i32 @Aes.rotl8(ptr %0, i32 %inv46, i32 1)
  %21 = xor i32 %inv45, %20
  %inv47 = load i32, ptr %inv, align 4
  %22 = call i32 @Aes.rotl8(ptr %0, i32 %inv47, i32 2)
  %23 = xor i32 %21, %22
  %inv48 = load i32, ptr %inv, align 4
  %24 = call i32 @Aes.rotl8(ptr %0, i32 %inv48, i32 3)
  %25 = xor i32 %23, %24
  %inv49 = load i32, ptr %inv, align 4
  %26 = call i32 @Aes.rotl8(ptr %0, i32 %inv49, i32 4)
  %27 = xor i32 %25, %26
  %28 = xor i32 %27, 99
  store i32 %28, ptr %s, align 4
  %s50 = load i32, ptr %s, align 4
  %29 = and i32 %s50, 255
  store i32 %29, ptr %s, align 4
  %sbox51 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox52 = load ptr, ptr %sbox51, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %a53 = load i32, ptr %a, align 4
  %30 = sext i32 %a53 to i64
  %arr.len54 = load i64, ptr %sbox52, align 8
  %arr.oob55 = icmp uge i64 %30, %arr.len54
  br i1 %arr.oob55, label %idx.bad56, label %idx.ok57, !prof !2

idx.bad34:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.4098, ptr @.faila.4099, i64 %19, ptr @.failb.4100, i64 %arr.len32, i32 70)
  unreachable

idx.ok35:                                         ; preds = %if.then
  %arr.data36 = getelementptr i8, ptr %logt30, i64 8
  %arr.elem37 = getelementptr inbounds i32, ptr %arr.data36, i64 %19
  %elem = load i32, ptr %arr.elem37, align 4
  %31 = sub i32 255, %elem
  %32 = icmp eq i32 %31, -2147483648
  %33 = and i1 %32, false
  %34 = or i1 false, %33
  br i1 %34, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok35
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok35
  %35 = srem i32 %31, 255
  %36 = sext i32 %35 to i64
  %arr.len38 = load i64, ptr %expt29, align 8
  %arr.oob39 = icmp uge i64 %36, %arr.len38
  br i1 %arr.oob39, label %idx.bad40, label %idx.ok41, !prof !2

idx.bad40:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.4101, ptr @.faila.4102, i64 %36, ptr @.failb.4103, i64 %arr.len38, i32 70)
  unreachable

idx.ok41:                                         ; preds = %div.ok
  %arr.data42 = getelementptr i8, ptr %expt29, i64 8
  %arr.elem43 = getelementptr inbounds i32, ptr %arr.data42, i64 %36
  %elem44 = load i32, ptr %arr.elem43, align 4
  store i32 %elem44, ptr %inv, align 4
  br label %if.end

idx.bad56:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.4104, ptr @.faila.4105, i64 %30, ptr @.failb.4106, i64 %arr.len54, i32 70)
  unreachable

idx.ok57:                                         ; preds = %if.end
  %arr.data58 = getelementptr i8, ptr %sbox52, i64 8
  %arr.elem59 = getelementptr inbounds i32, ptr %arr.data58, i64 %30
  %s60 = load i32, ptr %s, align 4
  store i32 %s60, ptr %arr.elem59, align 4
  %invSbox61 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 2
  %invSbox62 = load ptr, ptr %invSbox61, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s63 = load i32, ptr %s, align 4
  %37 = sext i32 %s63 to i64
  %arr.len64 = load i64, ptr %invSbox62, align 8
  %arr.oob65 = icmp uge i64 %37, %arr.len64
  br i1 %arr.oob65, label %idx.bad66, label %idx.ok67, !prof !2

idx.bad66:                                        ; preds = %idx.ok57
  call void @__polaron_fail(ptr @.fail.4107, ptr @.faila.4108, i64 %37, ptr @.failb.4109, i64 %arr.len64, i32 70)
  unreachable

idx.ok67:                                         ; preds = %idx.ok57
  %arr.data68 = getelementptr i8, ptr %invSbox62, i64 8
  %arr.elem69 = getelementptr inbounds i32, ptr %arr.data68, i64 %37
  %a70 = load i32, ptr %a, align 4
  store i32 %a70, ptr %arr.elem69, align 4
  br label %for.update25
}

define internal i32 @Aes.gmul(ptr nonnull align 8 dereferenceable(40) %0, i32 %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %bb = alloca i32, align 4
  %aa = alloca i32, align 4
  %p = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %1, ptr %a, align 4
  store i32 %2, ptr %b, align 4
  store i32 0, ptr %p, align 4
  %a1 = load i32, ptr %a, align 4
  %3 = and i32 %a1, 255
  store i32 %3, ptr %aa, align 4
  %b2 = load i32, ptr %b, align 4
  %4 = and i32 %b2, 255
  store i32 %4, ptr %bb, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %5 = icmp slt i32 %i3, 8
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bb4 = load i32, ptr %bb, align 4
  %7 = and i32 %bb4, 1
  %8 = icmp ne i32 %7, 0
  %9 = zext i1 %8 to i32
  br i1 %8, label %if.then, label %if.end

for.update:                                       ; preds = %if.end
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %p9 = load i32, ptr %p, align 4
  %12 = and i32 %p9, 255
  ret i32 %12

if.then:                                          ; preds = %for.body
  %p5 = load i32, ptr %p, align 4
  %aa6 = load i32, ptr %aa, align 4
  %13 = xor i32 %p5, %aa6
  store i32 %13, ptr %p, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %aa7 = load i32, ptr %aa, align 4
  %14 = call i32 @Aes.xtime(ptr %0, i32 %aa7)
  store i32 %14, ptr %aa, align 4
  %bb8 = load i32, ptr %bb, align 4
  %15 = ashr i32 %bb8, 31
  %16 = ashr i32 %bb8, 1
  store i32 %16, ptr %bb, align 4
  br label %for.update
}

define internal void @Aes.expandKey(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown120 = alloca ptr, align 8
  %r3 = alloca i32, align 4
  %r2 = alloca i32, align 4
  %r1 = alloca i32, align 4
  %r0 = alloca i32, align 4
  %exc.thrown68 = alloca ptr, align 8
  %t3 = alloca i32, align 4
  %t2 = alloca i32, align 4
  %t1 = alloca i32, align 4
  %t0 = alloca i32, align 4
  %w = alloca i32, align 4
  %rcon = alloca i32, align 4
  %i = alloca i32, align 4
  %nw = alloca i32, align 4
  %nk = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %key = alloca ptr, align 8
  store ptr %1, ptr %key, align 8
  %key1 = load ptr, ptr %key, align 8
  %len = load i64, ptr %key1, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp eq i32 %2, -2147483648
  %4 = and i1 %3, false
  %5 = or i1 false, %4
  br i1 %5, label %div.bad, label %div.ok

div.bad:                                          ; preds = %entry
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %entry
  %6 = sdiv i32 %2, 4
  store i32 %6, ptr %nk, align 4
  %rounds = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 4
  %nk2 = load i32, ptr %nk, align 4
  %7 = add i32 %nk2, 6
  store i32 %7, ptr %rounds, align 4, !tbaa !7
  %rounds3 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 4
  %rounds4 = load i32, ptr %rounds3, align 4, !tbaa !7
  %8 = add i32 %rounds4, 1
  %9 = mul i32 %8, 4
  store i32 %9, ptr %nw, align 4
  %rk = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %nw5 = load i32, ptr %nw, align 4
  %10 = mul i32 %nw5, 4
  %11 = sext i32 %10 to i64
  %12 = mul i64 %11, 4
  %13 = add i64 8, %12
  %arr = call ptr @__polaron_malloc(i64 %13)
  store i64 %11, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %14 = call ptr @memset(ptr %arr.data, i32 0, i64 %12)
  store ptr %arr, ptr %rk, align 8, !tbaa !3
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %div.ok
  %i6 = load i32, ptr %i, align 4
  %nk7 = load i32, ptr %nk, align 4
  %15 = mul i32 %nk7, 4
  %16 = icmp slt i32 %i6, %15
  %17 = zext i1 %16 to i32
  br i1 %16, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %rk8 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk9 = load ptr, ptr %rk8, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %18 = sext i32 %i10 to i64
  %arr.len = load i64, ptr %rk9, align 8
  %arr.oob = icmp uge i64 %18, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok17
  %19 = load i32, ptr %i, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %rcon, align 4
  %nk20 = load i32, ptr %nk, align 4
  store i32 %nk20, ptr %w, align 4
  br label %while.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4110, ptr @.faila.4111, i64 %18, ptr @.failb.4112, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data11 = getelementptr i8, ptr %rk9, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data11, i64 %18
  %key12 = load ptr, ptr %key, align 8, !nonnull !0, !dereferenceable !1
  %i13 = load i32, ptr %i, align 4
  %21 = sext i32 %i13 to i64
  %arr.len14 = load i64, ptr %key12, align 8
  %arr.oob15 = icmp uge i64 %21, %arr.len14
  br i1 %arr.oob15, label %idx.bad16, label %idx.ok17, !prof !2

idx.bad16:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4113, ptr @.faila.4114, i64 %21, ptr @.failb.4115, i64 %arr.len14, i32 70)
  unreachable

idx.ok17:                                         ; preds = %idx.ok
  %arr.data18 = getelementptr i8, ptr %key12, i64 8
  %arr.elem19 = getelementptr inbounds i32, ptr %arr.data18, i64 %21
  %elem = load i32, ptr %arr.elem19, align 4
  %22 = and i32 %elem, 255
  store i32 %22, ptr %arr.elem, align 4
  br label %for.update

while.cond:                                       ; preds = %idx.ok242, %for.end
  %w21 = load i32, ptr %w, align 4
  %nw22 = load i32, ptr %nw, align 4
  %23 = icmp slt i32 %w21, %nw22
  %24 = zext i1 %23 to i32
  br i1 %23, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %rk23 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk24 = load ptr, ptr %rk23, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w25 = load i32, ptr %w, align 4
  %25 = sub i32 %w25, 1
  %26 = mul i32 %25, 4
  %27 = add i32 %26, 0
  %28 = sext i32 %27 to i64
  %arr.len26 = load i64, ptr %rk24, align 8
  %arr.oob27 = icmp uge i64 %28, %arr.len26
  br i1 %arr.oob27, label %idx.bad28, label %idx.ok29, !prof !2

while.end:                                        ; preds = %while.cond
  ret void

idx.bad28:                                        ; preds = %while.body
  call void @__polaron_fail(ptr @.fail.4116, ptr @.faila.4117, i64 %28, ptr @.failb.4118, i64 %arr.len26, i32 70)
  unreachable

idx.ok29:                                         ; preds = %while.body
  %arr.data30 = getelementptr i8, ptr %rk24, i64 8
  %arr.elem31 = getelementptr inbounds i32, ptr %arr.data30, i64 %28
  %elem32 = load i32, ptr %arr.elem31, align 4
  store i32 %elem32, ptr %t0, align 4
  %rk33 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk34 = load ptr, ptr %rk33, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w35 = load i32, ptr %w, align 4
  %29 = sub i32 %w35, 1
  %30 = mul i32 %29, 4
  %31 = add i32 %30, 1
  %32 = sext i32 %31 to i64
  %arr.len36 = load i64, ptr %rk34, align 8
  %arr.oob37 = icmp uge i64 %32, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok29
  call void @__polaron_fail(ptr @.fail.4119, ptr @.faila.4120, i64 %32, ptr @.failb.4121, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok29
  %arr.data40 = getelementptr i8, ptr %rk34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %32
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %t1, align 4
  %rk43 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk44 = load ptr, ptr %rk43, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w45 = load i32, ptr %w, align 4
  %33 = sub i32 %w45, 1
  %34 = mul i32 %33, 4
  %35 = add i32 %34, 2
  %36 = sext i32 %35 to i64
  %arr.len46 = load i64, ptr %rk44, align 8
  %arr.oob47 = icmp uge i64 %36, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !2

idx.bad48:                                        ; preds = %idx.ok39
  call void @__polaron_fail(ptr @.fail.4122, ptr @.faila.4123, i64 %36, ptr @.failb.4124, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %idx.ok39
  %arr.data50 = getelementptr i8, ptr %rk44, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %36
  %elem52 = load i32, ptr %arr.elem51, align 4
  store i32 %elem52, ptr %t2, align 4
  %rk53 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk54 = load ptr, ptr %rk53, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w55 = load i32, ptr %w, align 4
  %37 = sub i32 %w55, 1
  %38 = mul i32 %37, 4
  %39 = add i32 %38, 3
  %40 = sext i32 %39 to i64
  %arr.len56 = load i64, ptr %rk54, align 8
  %arr.oob57 = icmp uge i64 %40, %arr.len56
  br i1 %arr.oob57, label %idx.bad58, label %idx.ok59, !prof !2

idx.bad58:                                        ; preds = %idx.ok49
  call void @__polaron_fail(ptr @.fail.4125, ptr @.faila.4126, i64 %40, ptr @.failb.4127, i64 %arr.len56, i32 70)
  unreachable

idx.ok59:                                         ; preds = %idx.ok49
  %arr.data60 = getelementptr i8, ptr %rk54, i64 8
  %arr.elem61 = getelementptr inbounds i32, ptr %arr.data60, i64 %40
  %elem62 = load i32, ptr %arr.elem61, align 4
  store i32 %elem62, ptr %t3, align 4
  %w63 = load i32, ptr %w, align 4
  %nk64 = load i32, ptr %nk, align 4
  %41 = icmp eq i32 %nk64, 0
  %42 = icmp eq i32 %w63, -2147483648
  %43 = icmp eq i32 %nk64, -1
  %44 = and i1 %42, %43
  %45 = or i1 %41, %44
  br i1 %45, label %div.bad65, label %div.ok66

div.bad65:                                        ; preds = %idx.ok59
  %exc67 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc67)
  store ptr %exc67, ptr %exc.thrown68, align 8
  call void @_CxxThrowException(ptr %exc.thrown68, ptr @_TI1PEAX)
  unreachable

div.ok66:                                         ; preds = %idx.ok59
  %46 = srem i32 %w63, %nk64
  %47 = icmp eq i32 %46, 0
  %48 = zext i1 %47 to i32
  br i1 %47, label %if.then, label %if.else

if.then:                                          ; preds = %div.ok66
  %sbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox69 = load ptr, ptr %sbox, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t170 = load i32, ptr %t1, align 4
  %49 = sext i32 %t170 to i64
  %arr.len71 = load i64, ptr %sbox69, align 8
  %arr.oob72 = icmp uge i64 %49, %arr.len71
  br i1 %arr.oob72, label %idx.bad73, label %idx.ok74, !prof !2

if.else:                                          ; preds = %div.ok66
  %nk114 = load i32, ptr %nk, align 4
  %50 = icmp sgt i32 %nk114, 6
  %51 = zext i1 %50 to i32
  %sc.a = icmp ne i32 %51, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

if.end:                                           ; preds = %if.end122, %idx.ok105
  %rk163 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk164 = load ptr, ptr %rk163, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w165 = load i32, ptr %w, align 4
  %52 = mul i32 %w165, 4
  %53 = add i32 %52, 0
  %54 = sext i32 %53 to i64
  %arr.len166 = load i64, ptr %rk164, align 8
  %arr.oob167 = icmp uge i64 %54, %arr.len166
  br i1 %arr.oob167, label %idx.bad168, label %idx.ok169, !prof !2

idx.bad73:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.4128, ptr @.faila.4129, i64 %49, ptr @.failb.4130, i64 %arr.len71, i32 70)
  unreachable

idx.ok74:                                         ; preds = %if.then
  %arr.data75 = getelementptr i8, ptr %sbox69, i64 8
  %arr.elem76 = getelementptr inbounds i32, ptr %arr.data75, i64 %49
  %elem77 = load i32, ptr %arr.elem76, align 4
  %rcon78 = load i32, ptr %rcon, align 4
  %55 = xor i32 %elem77, %rcon78
  store i32 %55, ptr %r0, align 4
  %sbox79 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox80 = load ptr, ptr %sbox79, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t281 = load i32, ptr %t2, align 4
  %56 = sext i32 %t281 to i64
  %arr.len82 = load i64, ptr %sbox80, align 8
  %arr.oob83 = icmp uge i64 %56, %arr.len82
  br i1 %arr.oob83, label %idx.bad84, label %idx.ok85, !prof !2

idx.bad84:                                        ; preds = %idx.ok74
  call void @__polaron_fail(ptr @.fail.4131, ptr @.faila.4132, i64 %56, ptr @.failb.4133, i64 %arr.len82, i32 70)
  unreachable

idx.ok85:                                         ; preds = %idx.ok74
  %arr.data86 = getelementptr i8, ptr %sbox80, i64 8
  %arr.elem87 = getelementptr inbounds i32, ptr %arr.data86, i64 %56
  %elem88 = load i32, ptr %arr.elem87, align 4
  store i32 %elem88, ptr %r1, align 4
  %sbox89 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox90 = load ptr, ptr %sbox89, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t391 = load i32, ptr %t3, align 4
  %57 = sext i32 %t391 to i64
  %arr.len92 = load i64, ptr %sbox90, align 8
  %arr.oob93 = icmp uge i64 %57, %arr.len92
  br i1 %arr.oob93, label %idx.bad94, label %idx.ok95, !prof !2

idx.bad94:                                        ; preds = %idx.ok85
  call void @__polaron_fail(ptr @.fail.4134, ptr @.faila.4135, i64 %57, ptr @.failb.4136, i64 %arr.len92, i32 70)
  unreachable

idx.ok95:                                         ; preds = %idx.ok85
  %arr.data96 = getelementptr i8, ptr %sbox90, i64 8
  %arr.elem97 = getelementptr inbounds i32, ptr %arr.data96, i64 %57
  %elem98 = load i32, ptr %arr.elem97, align 4
  store i32 %elem98, ptr %r2, align 4
  %sbox99 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox100 = load ptr, ptr %sbox99, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t0101 = load i32, ptr %t0, align 4
  %58 = sext i32 %t0101 to i64
  %arr.len102 = load i64, ptr %sbox100, align 8
  %arr.oob103 = icmp uge i64 %58, %arr.len102
  br i1 %arr.oob103, label %idx.bad104, label %idx.ok105, !prof !2

idx.bad104:                                       ; preds = %idx.ok95
  call void @__polaron_fail(ptr @.fail.4137, ptr @.faila.4138, i64 %58, ptr @.failb.4139, i64 %arr.len102, i32 70)
  unreachable

idx.ok105:                                        ; preds = %idx.ok95
  %arr.data106 = getelementptr i8, ptr %sbox100, i64 8
  %arr.elem107 = getelementptr inbounds i32, ptr %arr.data106, i64 %58
  %elem108 = load i32, ptr %arr.elem107, align 4
  store i32 %elem108, ptr %r3, align 4
  %r0109 = load i32, ptr %r0, align 4
  store i32 %r0109, ptr %t0, align 4
  %r1110 = load i32, ptr %r1, align 4
  store i32 %r1110, ptr %t1, align 4
  %r2111 = load i32, ptr %r2, align 4
  store i32 %r2111, ptr %t2, align 4
  %r3112 = load i32, ptr %r3, align 4
  store i32 %r3112, ptr %t3, align 4
  %rcon113 = load i32, ptr %rcon, align 4
  %59 = call i32 @Aes.xtime(ptr %0, i32 %rcon113)
  store i32 %59, ptr %rcon, align 4
  br label %if.end

sc.rhs:                                           ; preds = %if.else
  %w115 = load i32, ptr %w, align 4
  %nk116 = load i32, ptr %nk, align 4
  %60 = icmp eq i32 %nk116, 0
  %61 = icmp eq i32 %w115, -2147483648
  %62 = icmp eq i32 %nk116, -1
  %63 = and i1 %61, %62
  %64 = or i1 %60, %63
  br i1 %64, label %div.bad117, label %div.ok118

sc.end:                                           ; preds = %div.ok118, %if.else
  %sc = phi i1 [ false, %if.else ], [ %sc.b, %div.ok118 ]
  %65 = zext i1 %sc to i32
  br i1 %sc, label %if.then121, label %if.end122

div.bad117:                                       ; preds = %sc.rhs
  %exc119 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc119)
  store ptr %exc119, ptr %exc.thrown120, align 8
  call void @_CxxThrowException(ptr %exc.thrown120, ptr @_TI1PEAX)
  unreachable

div.ok118:                                        ; preds = %sc.rhs
  %66 = srem i32 %w115, %nk116
  %67 = icmp eq i32 %66, 4
  %68 = zext i1 %67 to i32
  %sc.b = icmp ne i32 %68, 0
  br label %sc.end

if.then121:                                       ; preds = %sc.end
  %sbox123 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox124 = load ptr, ptr %sbox123, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t0125 = load i32, ptr %t0, align 4
  %69 = sext i32 %t0125 to i64
  %arr.len126 = load i64, ptr %sbox124, align 8
  %arr.oob127 = icmp uge i64 %69, %arr.len126
  br i1 %arr.oob127, label %idx.bad128, label %idx.ok129, !prof !2

if.end122:                                        ; preds = %idx.ok159, %sc.end
  br label %if.end

idx.bad128:                                       ; preds = %if.then121
  call void @__polaron_fail(ptr @.fail.4140, ptr @.faila.4141, i64 %69, ptr @.failb.4142, i64 %arr.len126, i32 70)
  unreachable

idx.ok129:                                        ; preds = %if.then121
  %arr.data130 = getelementptr i8, ptr %sbox124, i64 8
  %arr.elem131 = getelementptr inbounds i32, ptr %arr.data130, i64 %69
  %elem132 = load i32, ptr %arr.elem131, align 4
  store i32 %elem132, ptr %t0, align 4
  %sbox133 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox134 = load ptr, ptr %sbox133, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t1135 = load i32, ptr %t1, align 4
  %70 = sext i32 %t1135 to i64
  %arr.len136 = load i64, ptr %sbox134, align 8
  %arr.oob137 = icmp uge i64 %70, %arr.len136
  br i1 %arr.oob137, label %idx.bad138, label %idx.ok139, !prof !2

idx.bad138:                                       ; preds = %idx.ok129
  call void @__polaron_fail(ptr @.fail.4143, ptr @.faila.4144, i64 %70, ptr @.failb.4145, i64 %arr.len136, i32 70)
  unreachable

idx.ok139:                                        ; preds = %idx.ok129
  %arr.data140 = getelementptr i8, ptr %sbox134, i64 8
  %arr.elem141 = getelementptr inbounds i32, ptr %arr.data140, i64 %70
  %elem142 = load i32, ptr %arr.elem141, align 4
  store i32 %elem142, ptr %t1, align 4
  %sbox143 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox144 = load ptr, ptr %sbox143, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t2145 = load i32, ptr %t2, align 4
  %71 = sext i32 %t2145 to i64
  %arr.len146 = load i64, ptr %sbox144, align 8
  %arr.oob147 = icmp uge i64 %71, %arr.len146
  br i1 %arr.oob147, label %idx.bad148, label %idx.ok149, !prof !2

idx.bad148:                                       ; preds = %idx.ok139
  call void @__polaron_fail(ptr @.fail.4146, ptr @.faila.4147, i64 %71, ptr @.failb.4148, i64 %arr.len146, i32 70)
  unreachable

idx.ok149:                                        ; preds = %idx.ok139
  %arr.data150 = getelementptr i8, ptr %sbox144, i64 8
  %arr.elem151 = getelementptr inbounds i32, ptr %arr.data150, i64 %71
  %elem152 = load i32, ptr %arr.elem151, align 4
  store i32 %elem152, ptr %t2, align 4
  %sbox153 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox154 = load ptr, ptr %sbox153, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %t3155 = load i32, ptr %t3, align 4
  %72 = sext i32 %t3155 to i64
  %arr.len156 = load i64, ptr %sbox154, align 8
  %arr.oob157 = icmp uge i64 %72, %arr.len156
  br i1 %arr.oob157, label %idx.bad158, label %idx.ok159, !prof !2

idx.bad158:                                       ; preds = %idx.ok149
  call void @__polaron_fail(ptr @.fail.4149, ptr @.faila.4150, i64 %72, ptr @.failb.4151, i64 %arr.len156, i32 70)
  unreachable

idx.ok159:                                        ; preds = %idx.ok149
  %arr.data160 = getelementptr i8, ptr %sbox154, i64 8
  %arr.elem161 = getelementptr inbounds i32, ptr %arr.data160, i64 %72
  %elem162 = load i32, ptr %arr.elem161, align 4
  store i32 %elem162, ptr %t3, align 4
  br label %if.end122

idx.bad168:                                       ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.4152, ptr @.faila.4153, i64 %54, ptr @.failb.4154, i64 %arr.len166, i32 70)
  unreachable

idx.ok169:                                        ; preds = %if.end
  %arr.data170 = getelementptr i8, ptr %rk164, i64 8
  %arr.elem171 = getelementptr inbounds i32, ptr %arr.data170, i64 %54
  %rk172 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk173 = load ptr, ptr %rk172, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w174 = load i32, ptr %w, align 4
  %nk175 = load i32, ptr %nk, align 4
  %73 = sub i32 %w174, %nk175
  %74 = mul i32 %73, 4
  %75 = add i32 %74, 0
  %76 = sext i32 %75 to i64
  %arr.len176 = load i64, ptr %rk173, align 8
  %arr.oob177 = icmp uge i64 %76, %arr.len176
  br i1 %arr.oob177, label %idx.bad178, label %idx.ok179, !prof !2

idx.bad178:                                       ; preds = %idx.ok169
  call void @__polaron_fail(ptr @.fail.4155, ptr @.faila.4156, i64 %76, ptr @.failb.4157, i64 %arr.len176, i32 70)
  unreachable

idx.ok179:                                        ; preds = %idx.ok169
  %arr.data180 = getelementptr i8, ptr %rk173, i64 8
  %arr.elem181 = getelementptr inbounds i32, ptr %arr.data180, i64 %76
  %elem182 = load i32, ptr %arr.elem181, align 4
  %t0183 = load i32, ptr %t0, align 4
  %77 = xor i32 %elem182, %t0183
  store i32 %77, ptr %arr.elem171, align 4
  %rk184 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk185 = load ptr, ptr %rk184, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w186 = load i32, ptr %w, align 4
  %78 = mul i32 %w186, 4
  %79 = add i32 %78, 1
  %80 = sext i32 %79 to i64
  %arr.len187 = load i64, ptr %rk185, align 8
  %arr.oob188 = icmp uge i64 %80, %arr.len187
  br i1 %arr.oob188, label %idx.bad189, label %idx.ok190, !prof !2

idx.bad189:                                       ; preds = %idx.ok179
  call void @__polaron_fail(ptr @.fail.4158, ptr @.faila.4159, i64 %80, ptr @.failb.4160, i64 %arr.len187, i32 70)
  unreachable

idx.ok190:                                        ; preds = %idx.ok179
  %arr.data191 = getelementptr i8, ptr %rk185, i64 8
  %arr.elem192 = getelementptr inbounds i32, ptr %arr.data191, i64 %80
  %rk193 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk194 = load ptr, ptr %rk193, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w195 = load i32, ptr %w, align 4
  %nk196 = load i32, ptr %nk, align 4
  %81 = sub i32 %w195, %nk196
  %82 = mul i32 %81, 4
  %83 = add i32 %82, 1
  %84 = sext i32 %83 to i64
  %arr.len197 = load i64, ptr %rk194, align 8
  %arr.oob198 = icmp uge i64 %84, %arr.len197
  br i1 %arr.oob198, label %idx.bad199, label %idx.ok200, !prof !2

idx.bad199:                                       ; preds = %idx.ok190
  call void @__polaron_fail(ptr @.fail.4161, ptr @.faila.4162, i64 %84, ptr @.failb.4163, i64 %arr.len197, i32 70)
  unreachable

idx.ok200:                                        ; preds = %idx.ok190
  %arr.data201 = getelementptr i8, ptr %rk194, i64 8
  %arr.elem202 = getelementptr inbounds i32, ptr %arr.data201, i64 %84
  %elem203 = load i32, ptr %arr.elem202, align 4
  %t1204 = load i32, ptr %t1, align 4
  %85 = xor i32 %elem203, %t1204
  store i32 %85, ptr %arr.elem192, align 4
  %rk205 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk206 = load ptr, ptr %rk205, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w207 = load i32, ptr %w, align 4
  %86 = mul i32 %w207, 4
  %87 = add i32 %86, 2
  %88 = sext i32 %87 to i64
  %arr.len208 = load i64, ptr %rk206, align 8
  %arr.oob209 = icmp uge i64 %88, %arr.len208
  br i1 %arr.oob209, label %idx.bad210, label %idx.ok211, !prof !2

idx.bad210:                                       ; preds = %idx.ok200
  call void @__polaron_fail(ptr @.fail.4164, ptr @.faila.4165, i64 %88, ptr @.failb.4166, i64 %arr.len208, i32 70)
  unreachable

idx.ok211:                                        ; preds = %idx.ok200
  %arr.data212 = getelementptr i8, ptr %rk206, i64 8
  %arr.elem213 = getelementptr inbounds i32, ptr %arr.data212, i64 %88
  %rk214 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk215 = load ptr, ptr %rk214, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w216 = load i32, ptr %w, align 4
  %nk217 = load i32, ptr %nk, align 4
  %89 = sub i32 %w216, %nk217
  %90 = mul i32 %89, 4
  %91 = add i32 %90, 2
  %92 = sext i32 %91 to i64
  %arr.len218 = load i64, ptr %rk215, align 8
  %arr.oob219 = icmp uge i64 %92, %arr.len218
  br i1 %arr.oob219, label %idx.bad220, label %idx.ok221, !prof !2

idx.bad220:                                       ; preds = %idx.ok211
  call void @__polaron_fail(ptr @.fail.4167, ptr @.faila.4168, i64 %92, ptr @.failb.4169, i64 %arr.len218, i32 70)
  unreachable

idx.ok221:                                        ; preds = %idx.ok211
  %arr.data222 = getelementptr i8, ptr %rk215, i64 8
  %arr.elem223 = getelementptr inbounds i32, ptr %arr.data222, i64 %92
  %elem224 = load i32, ptr %arr.elem223, align 4
  %t2225 = load i32, ptr %t2, align 4
  %93 = xor i32 %elem224, %t2225
  store i32 %93, ptr %arr.elem213, align 4
  %rk226 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk227 = load ptr, ptr %rk226, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w228 = load i32, ptr %w, align 4
  %94 = mul i32 %w228, 4
  %95 = add i32 %94, 3
  %96 = sext i32 %95 to i64
  %arr.len229 = load i64, ptr %rk227, align 8
  %arr.oob230 = icmp uge i64 %96, %arr.len229
  br i1 %arr.oob230, label %idx.bad231, label %idx.ok232, !prof !2

idx.bad231:                                       ; preds = %idx.ok221
  call void @__polaron_fail(ptr @.fail.4170, ptr @.faila.4171, i64 %96, ptr @.failb.4172, i64 %arr.len229, i32 70)
  unreachable

idx.ok232:                                        ; preds = %idx.ok221
  %arr.data233 = getelementptr i8, ptr %rk227, i64 8
  %arr.elem234 = getelementptr inbounds i32, ptr %arr.data233, i64 %96
  %rk235 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk236 = load ptr, ptr %rk235, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %w237 = load i32, ptr %w, align 4
  %nk238 = load i32, ptr %nk, align 4
  %97 = sub i32 %w237, %nk238
  %98 = mul i32 %97, 4
  %99 = add i32 %98, 3
  %100 = sext i32 %99 to i64
  %arr.len239 = load i64, ptr %rk236, align 8
  %arr.oob240 = icmp uge i64 %100, %arr.len239
  br i1 %arr.oob240, label %idx.bad241, label %idx.ok242, !prof !2

idx.bad241:                                       ; preds = %idx.ok232
  call void @__polaron_fail(ptr @.fail.4173, ptr @.faila.4174, i64 %100, ptr @.failb.4175, i64 %arr.len239, i32 70)
  unreachable

idx.ok242:                                        ; preds = %idx.ok232
  %arr.data243 = getelementptr i8, ptr %rk236, i64 8
  %arr.elem244 = getelementptr inbounds i32, ptr %arr.data243, i64 %100
  %elem245 = load i32, ptr %arr.elem244, align 4
  %t3246 = load i32, ptr %t3, align 4
  %101 = xor i32 %elem245, %t3246
  store i32 %101, ptr %arr.elem234, align 4
  %w247 = load i32, ptr %w, align 4
  %102 = add i32 %w247, 1
  store i32 %102, ptr %w, align 4
  br label %while.cond
}

define internal void @Aes.addRoundKey(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  store i32 %2, ptr %round, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %3 = icmp slt i32 %i1, 16
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %5 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok18
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4176, ptr @.faila.4177, i64 %5, ptr @.failb.4178, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %s4 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i5 = load i32, ptr %i, align 4
  %8 = sext i32 %i5 to i64
  %arr.len6 = load i64, ptr %s4, align 8
  %arr.oob7 = icmp uge i64 %8, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4179, ptr @.faila.4180, i64 %8, ptr @.failb.4181, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %s4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %8
  %elem = load i32, ptr %arr.elem11, align 4
  %rk = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 3
  %rk12 = load ptr, ptr %rk, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %round13 = load i32, ptr %round, align 4
  %9 = mul i32 %round13, 16
  %i14 = load i32, ptr %i, align 4
  %10 = add i32 %9, %i14
  %11 = sext i32 %10 to i64
  %arr.len15 = load i64, ptr %rk12, align 8
  %arr.oob16 = icmp uge i64 %11, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.4182, ptr @.faila.4183, i64 %11, ptr @.failb.4184, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok9
  %arr.data19 = getelementptr i8, ptr %rk12, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %11
  %elem21 = load i32, ptr %arr.elem20, align 4
  %12 = xor i32 %elem, %elem21
  store i32 %12, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @Aes.subBytes(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i1, 16
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %4 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok16
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4185, ptr @.faila.4186, i64 %4, ptr @.failb.4187, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %sbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 1
  %sbox4 = load ptr, ptr %sbox, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s5 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %7 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %s5, align 8
  %arr.oob8 = icmp uge i64 %7, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4188, ptr @.faila.4189, i64 %7, ptr @.failb.4190, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %s5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %7
  %elem = load i32, ptr %arr.elem12, align 4
  %8 = sext i32 %elem to i64
  %arr.len13 = load i64, ptr %sbox4, align 8
  %arr.oob14 = icmp uge i64 %8, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !2

idx.bad15:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4191, ptr @.faila.4192, i64 %8, ptr @.failb.4193, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok10
  %arr.data17 = getelementptr i8, ptr %sbox4, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 %8
  %elem19 = load i32, ptr %arr.elem18, align 4
  store i32 %elem19, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @Aes.invSubBytes(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %2 = icmp slt i32 %i1, 16
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %4 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok16
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4194, ptr @.faila.4195, i64 %4, ptr @.failb.4196, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %invSbox = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 2
  %invSbox4 = load ptr, ptr %invSbox, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %s5 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %7 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %s5, align 8
  %arr.oob8 = icmp uge i64 %7, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4197, ptr @.faila.4198, i64 %7, ptr @.failb.4199, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %s5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %7
  %elem = load i32, ptr %arr.elem12, align 4
  %8 = sext i32 %elem to i64
  %arr.len13 = load i64, ptr %invSbox4, align 8
  %arr.oob14 = icmp uge i64 %8, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !2

idx.bad15:                                        ; preds = %idx.ok10
  call void @__polaron_fail(ptr @.fail.4200, ptr @.faila.4201, i64 %8, ptr @.failb.4202, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok10
  %arr.data17 = getelementptr i8, ptr %invSbox4, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 %8
  %elem19 = load i32, ptr %arr.elem18, align 4
  store i32 %elem19, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @Aes.shiftRows(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %i = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %t = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %2 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %t, align 8
  store i32 0, ptr %r, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %r1 = load i32, ptr %r, align 4
  %3 = icmp slt i32 %r1, 4
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %c, align 4
  br label %for.cond2

for.update:                                       ; preds = %for.end5
  %5 = load i32, ptr %r, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %r, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i, align 4
  br label %for.cond21

for.cond2:                                        ; preds = %for.update4, %for.body
  %c6 = load i32, ptr %c, align 4
  %7 = icmp slt i32 %c6, 4
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body3, label %for.end5

for.body3:                                        ; preds = %for.cond2
  %t7 = load ptr, ptr %t, align 8, !nonnull !0, !dereferenceable !1
  %r8 = load i32, ptr %r, align 4
  %c9 = load i32, ptr %c, align 4
  %9 = mul i32 4, %c9
  %10 = add i32 %r8, %9
  %11 = sext i32 %10 to i64
  %arr.len = load i64, ptr %t7, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update4:                                      ; preds = %idx.ok18
  %12 = load i32, ptr %c, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %c, align 4
  br label %for.cond2

for.end5:                                         ; preds = %for.cond2
  br label %for.update

idx.bad:                                          ; preds = %for.body3
  call void @__polaron_fail(ptr @.fail.4203, ptr @.faila.4204, i64 %11, ptr @.failb.4205, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body3
  %arr.data10 = getelementptr i8, ptr %t7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data10, i64 %11
  %s11 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %r12 = load i32, ptr %r, align 4
  %c13 = load i32, ptr %c, align 4
  %r14 = load i32, ptr %r, align 4
  %14 = add i32 %c13, %r14
  %15 = icmp eq i32 %14, -2147483648
  %16 = and i1 %15, false
  %17 = or i1 false, %16
  br i1 %17, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %18 = srem i32 %14, 4
  %19 = mul i32 4, %18
  %20 = add i32 %r12, %19
  %21 = sext i32 %20 to i64
  %arr.len15 = load i64, ptr %s11, align 8
  %arr.oob16 = icmp uge i64 %21, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.4206, ptr @.faila.4207, i64 %21, ptr @.failb.4208, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %div.ok
  %arr.data19 = getelementptr i8, ptr %s11, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %21
  %elem = load i32, ptr %arr.elem20, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update4

for.cond21:                                       ; preds = %for.update23, %for.end
  %i25 = load i32, ptr %i, align 4
  %22 = icmp slt i32 %i25, 16
  %23 = zext i1 %22 to i32
  br i1 %22, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  %s26 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %24 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %s26, align 8
  %arr.oob29 = icmp uge i64 %24, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

for.update23:                                     ; preds = %idx.ok39
  %25 = load i32, ptr %i, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %i, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  ret void

idx.bad30:                                        ; preds = %for.body22
  call void @__polaron_fail(ptr @.fail.4209, ptr @.faila.4210, i64 %24, ptr @.failb.4211, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %for.body22
  %arr.data32 = getelementptr i8, ptr %s26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %24
  %t34 = load ptr, ptr %t, align 8, !nonnull !0, !dereferenceable !1
  %i35 = load i32, ptr %i, align 4
  %27 = sext i32 %i35 to i64
  %arr.len36 = load i64, ptr %t34, align 8
  %arr.oob37 = icmp uge i64 %27, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.4212, ptr @.faila.4213, i64 %27, ptr @.failb.4214, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %t34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %27
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %arr.elem33, align 4
  br label %for.update23
}

define internal void @Aes.invShiftRows(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) personality ptr @__CxxFrameHandler3 {
entry:
  %i = alloca i32, align 4
  %exc.thrown = alloca ptr, align 8
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %t = alloca ptr, align 8
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %2 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %t, align 8
  store i32 0, ptr %r, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %r1 = load i32, ptr %r, align 4
  %3 = icmp slt i32 %r1, 4
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %c, align 4
  br label %for.cond2

for.update:                                       ; preds = %for.end5
  %5 = load i32, ptr %r, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %r, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %i, align 4
  br label %for.cond21

for.cond2:                                        ; preds = %for.update4, %for.body
  %c6 = load i32, ptr %c, align 4
  %7 = icmp slt i32 %c6, 4
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body3, label %for.end5

for.body3:                                        ; preds = %for.cond2
  %t7 = load ptr, ptr %t, align 8, !nonnull !0, !dereferenceable !1
  %r8 = load i32, ptr %r, align 4
  %c9 = load i32, ptr %c, align 4
  %9 = mul i32 4, %c9
  %10 = add i32 %r8, %9
  %11 = sext i32 %10 to i64
  %arr.len = load i64, ptr %t7, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update4:                                      ; preds = %idx.ok18
  %12 = load i32, ptr %c, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %c, align 4
  br label %for.cond2

for.end5:                                         ; preds = %for.cond2
  br label %for.update

idx.bad:                                          ; preds = %for.body3
  call void @__polaron_fail(ptr @.fail.4215, ptr @.faila.4216, i64 %11, ptr @.failb.4217, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body3
  %arr.data10 = getelementptr i8, ptr %t7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data10, i64 %11
  %s11 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %r12 = load i32, ptr %r, align 4
  %c13 = load i32, ptr %c, align 4
  %r14 = load i32, ptr %r, align 4
  %14 = sub i32 %c13, %r14
  %15 = add i32 %14, 4
  %16 = icmp eq i32 %15, -2147483648
  %17 = and i1 %16, false
  %18 = or i1 false, %17
  br i1 %18, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok
  %19 = srem i32 %15, 4
  %20 = mul i32 4, %19
  %21 = add i32 %r12, %20
  %22 = sext i32 %21 to i64
  %arr.len15 = load i64, ptr %s11, align 8
  %arr.oob16 = icmp uge i64 %22, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %div.ok
  call void @__polaron_fail(ptr @.fail.4218, ptr @.faila.4219, i64 %22, ptr @.failb.4220, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %div.ok
  %arr.data19 = getelementptr i8, ptr %s11, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %22
  %elem = load i32, ptr %arr.elem20, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update4

for.cond21:                                       ; preds = %for.update23, %for.end
  %i25 = load i32, ptr %i, align 4
  %23 = icmp slt i32 %i25, 16
  %24 = zext i1 %23 to i32
  br i1 %23, label %for.body22, label %for.end24

for.body22:                                       ; preds = %for.cond21
  %s26 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i27 = load i32, ptr %i, align 4
  %25 = sext i32 %i27 to i64
  %arr.len28 = load i64, ptr %s26, align 8
  %arr.oob29 = icmp uge i64 %25, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !2

for.update23:                                     ; preds = %idx.ok39
  %26 = load i32, ptr %i, align 4
  %27 = add i32 %26, 1
  store i32 %27, ptr %i, align 4
  br label %for.cond21

for.end24:                                        ; preds = %for.cond21
  ret void

idx.bad30:                                        ; preds = %for.body22
  call void @__polaron_fail(ptr @.fail.4221, ptr @.faila.4222, i64 %25, ptr @.failb.4223, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %for.body22
  %arr.data32 = getelementptr i8, ptr %s26, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %25
  %t34 = load ptr, ptr %t, align 8, !nonnull !0, !dereferenceable !1
  %i35 = load i32, ptr %i, align 4
  %28 = sext i32 %i35 to i64
  %arr.len36 = load i64, ptr %t34, align 8
  %arr.oob37 = icmp uge i64 %28, %arr.len36
  br i1 %arr.oob37, label %idx.bad38, label %idx.ok39, !prof !2

idx.bad38:                                        ; preds = %idx.ok31
  call void @__polaron_fail(ptr @.fail.4224, ptr @.faila.4225, i64 %28, ptr @.failb.4226, i64 %arr.len36, i32 70)
  unreachable

idx.ok39:                                         ; preds = %idx.ok31
  %arr.data40 = getelementptr i8, ptr %t34, i64 8
  %arr.elem41 = getelementptr inbounds i32, ptr %arr.data40, i64 %28
  %elem42 = load i32, ptr %arr.elem41, align 4
  store i32 %elem42, ptr %arr.elem33, align 4
  br label %for.update23
}

define internal void @Aes.mixColumns(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %a3 = alloca i32, align 4
  %a2 = alloca i32, align 4
  %a1 = alloca i32, align 4
  %a0 = alloca i32, align 4
  %c = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  store i32 0, ptr %c, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %c1 = load i32, ptr %c, align 4
  %2 = icmp slt i32 %c1, 4
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c3 = load i32, ptr %c, align 4
  %4 = mul i32 4, %c3
  %5 = add i32 %4, 0
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok72
  %7 = load i32, ptr %c, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %c, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4227, ptr @.faila.4228, i64 %6, ptr @.failb.4229, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %a0, align 4
  %s4 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c5 = load i32, ptr %c, align 4
  %9 = mul i32 4, %c5
  %10 = add i32 %9, 1
  %11 = sext i32 %10 to i64
  %arr.len6 = load i64, ptr %s4, align 8
  %arr.oob7 = icmp uge i64 %11, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4230, ptr @.faila.4231, i64 %11, ptr @.failb.4232, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %s4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %11
  %elem12 = load i32, ptr %arr.elem11, align 4
  store i32 %elem12, ptr %a1, align 4
  %s13 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c14 = load i32, ptr %c, align 4
  %12 = mul i32 4, %c14
  %13 = add i32 %12, 2
  %14 = sext i32 %13 to i64
  %arr.len15 = load i64, ptr %s13, align 8
  %arr.oob16 = icmp uge i64 %14, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.4233, ptr @.faila.4234, i64 %14, ptr @.failb.4235, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok9
  %arr.data19 = getelementptr i8, ptr %s13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %14
  %elem21 = load i32, ptr %arr.elem20, align 4
  store i32 %elem21, ptr %a2, align 4
  %s22 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c23 = load i32, ptr %c, align 4
  %15 = mul i32 4, %c23
  %16 = add i32 %15, 3
  %17 = sext i32 %16 to i64
  %arr.len24 = load i64, ptr %s22, align 8
  %arr.oob25 = icmp uge i64 %17, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad26:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.4236, ptr @.faila.4237, i64 %17, ptr @.failb.4238, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok18
  %arr.data28 = getelementptr i8, ptr %s22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %17
  %elem30 = load i32, ptr %arr.elem29, align 4
  store i32 %elem30, ptr %a3, align 4
  %s31 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c32 = load i32, ptr %c, align 4
  %18 = mul i32 4, %c32
  %19 = add i32 %18, 0
  %20 = sext i32 %19 to i64
  %arr.len33 = load i64, ptr %s31, align 8
  %arr.oob34 = icmp uge i64 %20, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.fail.4239, ptr @.faila.4240, i64 %20, ptr @.failb.4241, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok27
  %arr.data37 = getelementptr i8, ptr %s31, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 %20
  %a039 = load i32, ptr %a0, align 4
  %21 = call i32 @Aes.gmul(ptr %0, i32 %a039, i32 2)
  %a140 = load i32, ptr %a1, align 4
  %22 = call i32 @Aes.gmul(ptr %0, i32 %a140, i32 3)
  %23 = xor i32 %21, %22
  %a241 = load i32, ptr %a2, align 4
  %24 = xor i32 %23, %a241
  %a342 = load i32, ptr %a3, align 4
  %25 = xor i32 %24, %a342
  store i32 %25, ptr %arr.elem38, align 4
  %s43 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c44 = load i32, ptr %c, align 4
  %26 = mul i32 4, %c44
  %27 = add i32 %26, 1
  %28 = sext i32 %27 to i64
  %arr.len45 = load i64, ptr %s43, align 8
  %arr.oob46 = icmp uge i64 %28, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.4242, ptr @.faila.4243, i64 %28, ptr @.failb.4244, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %s43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %28
  %a051 = load i32, ptr %a0, align 4
  %a152 = load i32, ptr %a1, align 4
  %29 = call i32 @Aes.gmul(ptr %0, i32 %a152, i32 2)
  %30 = xor i32 %a051, %29
  %a253 = load i32, ptr %a2, align 4
  %31 = call i32 @Aes.gmul(ptr %0, i32 %a253, i32 3)
  %32 = xor i32 %30, %31
  %a354 = load i32, ptr %a3, align 4
  %33 = xor i32 %32, %a354
  store i32 %33, ptr %arr.elem50, align 4
  %s55 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c56 = load i32, ptr %c, align 4
  %34 = mul i32 4, %c56
  %35 = add i32 %34, 2
  %36 = sext i32 %35 to i64
  %arr.len57 = load i64, ptr %s55, align 8
  %arr.oob58 = icmp uge i64 %36, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.4245, ptr @.faila.4246, i64 %36, ptr @.failb.4247, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok48
  %arr.data61 = getelementptr i8, ptr %s55, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 %36
  %a063 = load i32, ptr %a0, align 4
  %a164 = load i32, ptr %a1, align 4
  %37 = xor i32 %a063, %a164
  %a265 = load i32, ptr %a2, align 4
  %38 = call i32 @Aes.gmul(ptr %0, i32 %a265, i32 2)
  %39 = xor i32 %37, %38
  %a366 = load i32, ptr %a3, align 4
  %40 = call i32 @Aes.gmul(ptr %0, i32 %a366, i32 3)
  %41 = xor i32 %39, %40
  store i32 %41, ptr %arr.elem62, align 4
  %s67 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c68 = load i32, ptr %c, align 4
  %42 = mul i32 4, %c68
  %43 = add i32 %42, 3
  %44 = sext i32 %43 to i64
  %arr.len69 = load i64, ptr %s67, align 8
  %arr.oob70 = icmp uge i64 %44, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

idx.bad71:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.4248, ptr @.faila.4249, i64 %44, ptr @.failb.4250, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok60
  %arr.data73 = getelementptr i8, ptr %s67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %44
  %a075 = load i32, ptr %a0, align 4
  %45 = call i32 @Aes.gmul(ptr %0, i32 %a075, i32 3)
  %a176 = load i32, ptr %a1, align 4
  %46 = xor i32 %45, %a176
  %a277 = load i32, ptr %a2, align 4
  %47 = xor i32 %46, %a277
  %a378 = load i32, ptr %a3, align 4
  %48 = call i32 @Aes.gmul(ptr %0, i32 %a378, i32 2)
  %49 = xor i32 %47, %48
  store i32 %49, ptr %arr.elem74, align 4
  br label %for.update
}

define internal void @Aes.invMixColumns(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %a3 = alloca i32, align 4
  %a2 = alloca i32, align 4
  %a1 = alloca i32, align 4
  %a0 = alloca i32, align 4
  %c = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  store i32 0, ptr %c, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %c1 = load i32, ptr %c, align 4
  %2 = icmp slt i32 %c1, 4
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c3 = load i32, ptr %c, align 4
  %4 = mul i32 4, %c3
  %5 = add i32 %4, 0
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok72
  %7 = load i32, ptr %c, align 4
  %8 = add i32 %7, 1
  store i32 %8, ptr %c, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4251, ptr @.faila.4252, i64 %6, ptr @.failb.4253, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %elem = load i32, ptr %arr.elem, align 4
  store i32 %elem, ptr %a0, align 4
  %s4 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c5 = load i32, ptr %c, align 4
  %9 = mul i32 4, %c5
  %10 = add i32 %9, 1
  %11 = sext i32 %10 to i64
  %arr.len6 = load i64, ptr %s4, align 8
  %arr.oob7 = icmp uge i64 %11, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4254, ptr @.faila.4255, i64 %11, ptr @.failb.4256, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %s4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %11
  %elem12 = load i32, ptr %arr.elem11, align 4
  store i32 %elem12, ptr %a1, align 4
  %s13 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c14 = load i32, ptr %c, align 4
  %12 = mul i32 4, %c14
  %13 = add i32 %12, 2
  %14 = sext i32 %13 to i64
  %arr.len15 = load i64, ptr %s13, align 8
  %arr.oob16 = icmp uge i64 %14, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !2

idx.bad17:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.4257, ptr @.faila.4258, i64 %14, ptr @.failb.4259, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok9
  %arr.data19 = getelementptr i8, ptr %s13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %14
  %elem21 = load i32, ptr %arr.elem20, align 4
  store i32 %elem21, ptr %a2, align 4
  %s22 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c23 = load i32, ptr %c, align 4
  %15 = mul i32 4, %c23
  %16 = add i32 %15, 3
  %17 = sext i32 %16 to i64
  %arr.len24 = load i64, ptr %s22, align 8
  %arr.oob25 = icmp uge i64 %17, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !2

idx.bad26:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.4260, ptr @.faila.4261, i64 %17, ptr @.failb.4262, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok18
  %arr.data28 = getelementptr i8, ptr %s22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %17
  %elem30 = load i32, ptr %arr.elem29, align 4
  store i32 %elem30, ptr %a3, align 4
  %s31 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c32 = load i32, ptr %c, align 4
  %18 = mul i32 4, %c32
  %19 = add i32 %18, 0
  %20 = sext i32 %19 to i64
  %arr.len33 = load i64, ptr %s31, align 8
  %arr.oob34 = icmp uge i64 %20, %arr.len33
  br i1 %arr.oob34, label %idx.bad35, label %idx.ok36, !prof !2

idx.bad35:                                        ; preds = %idx.ok27
  call void @__polaron_fail(ptr @.fail.4263, ptr @.faila.4264, i64 %20, ptr @.failb.4265, i64 %arr.len33, i32 70)
  unreachable

idx.ok36:                                         ; preds = %idx.ok27
  %arr.data37 = getelementptr i8, ptr %s31, i64 8
  %arr.elem38 = getelementptr inbounds i32, ptr %arr.data37, i64 %20
  %a039 = load i32, ptr %a0, align 4
  %21 = call i32 @Aes.gmul(ptr %0, i32 %a039, i32 14)
  %a140 = load i32, ptr %a1, align 4
  %22 = call i32 @Aes.gmul(ptr %0, i32 %a140, i32 11)
  %23 = xor i32 %21, %22
  %a241 = load i32, ptr %a2, align 4
  %24 = call i32 @Aes.gmul(ptr %0, i32 %a241, i32 13)
  %25 = xor i32 %23, %24
  %a342 = load i32, ptr %a3, align 4
  %26 = call i32 @Aes.gmul(ptr %0, i32 %a342, i32 9)
  %27 = xor i32 %25, %26
  store i32 %27, ptr %arr.elem38, align 4
  %s43 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c44 = load i32, ptr %c, align 4
  %28 = mul i32 4, %c44
  %29 = add i32 %28, 1
  %30 = sext i32 %29 to i64
  %arr.len45 = load i64, ptr %s43, align 8
  %arr.oob46 = icmp uge i64 %30, %arr.len45
  br i1 %arr.oob46, label %idx.bad47, label %idx.ok48, !prof !2

idx.bad47:                                        ; preds = %idx.ok36
  call void @__polaron_fail(ptr @.fail.4266, ptr @.faila.4267, i64 %30, ptr @.failb.4268, i64 %arr.len45, i32 70)
  unreachable

idx.ok48:                                         ; preds = %idx.ok36
  %arr.data49 = getelementptr i8, ptr %s43, i64 8
  %arr.elem50 = getelementptr inbounds i32, ptr %arr.data49, i64 %30
  %a051 = load i32, ptr %a0, align 4
  %31 = call i32 @Aes.gmul(ptr %0, i32 %a051, i32 9)
  %a152 = load i32, ptr %a1, align 4
  %32 = call i32 @Aes.gmul(ptr %0, i32 %a152, i32 14)
  %33 = xor i32 %31, %32
  %a253 = load i32, ptr %a2, align 4
  %34 = call i32 @Aes.gmul(ptr %0, i32 %a253, i32 11)
  %35 = xor i32 %33, %34
  %a354 = load i32, ptr %a3, align 4
  %36 = call i32 @Aes.gmul(ptr %0, i32 %a354, i32 13)
  %37 = xor i32 %35, %36
  store i32 %37, ptr %arr.elem50, align 4
  %s55 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c56 = load i32, ptr %c, align 4
  %38 = mul i32 4, %c56
  %39 = add i32 %38, 2
  %40 = sext i32 %39 to i64
  %arr.len57 = load i64, ptr %s55, align 8
  %arr.oob58 = icmp uge i64 %40, %arr.len57
  br i1 %arr.oob58, label %idx.bad59, label %idx.ok60, !prof !2

idx.bad59:                                        ; preds = %idx.ok48
  call void @__polaron_fail(ptr @.fail.4269, ptr @.faila.4270, i64 %40, ptr @.failb.4271, i64 %arr.len57, i32 70)
  unreachable

idx.ok60:                                         ; preds = %idx.ok48
  %arr.data61 = getelementptr i8, ptr %s55, i64 8
  %arr.elem62 = getelementptr inbounds i32, ptr %arr.data61, i64 %40
  %a063 = load i32, ptr %a0, align 4
  %41 = call i32 @Aes.gmul(ptr %0, i32 %a063, i32 13)
  %a164 = load i32, ptr %a1, align 4
  %42 = call i32 @Aes.gmul(ptr %0, i32 %a164, i32 9)
  %43 = xor i32 %41, %42
  %a265 = load i32, ptr %a2, align 4
  %44 = call i32 @Aes.gmul(ptr %0, i32 %a265, i32 14)
  %45 = xor i32 %43, %44
  %a366 = load i32, ptr %a3, align 4
  %46 = call i32 @Aes.gmul(ptr %0, i32 %a366, i32 11)
  %47 = xor i32 %45, %46
  store i32 %47, ptr %arr.elem62, align 4
  %s67 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %c68 = load i32, ptr %c, align 4
  %48 = mul i32 4, %c68
  %49 = add i32 %48, 3
  %50 = sext i32 %49 to i64
  %arr.len69 = load i64, ptr %s67, align 8
  %arr.oob70 = icmp uge i64 %50, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !2

idx.bad71:                                        ; preds = %idx.ok60
  call void @__polaron_fail(ptr @.fail.4272, ptr @.faila.4273, i64 %50, ptr @.failb.4274, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok60
  %arr.data73 = getelementptr i8, ptr %s67, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %50
  %a075 = load i32, ptr %a0, align 4
  %51 = call i32 @Aes.gmul(ptr %0, i32 %a075, i32 11)
  %a176 = load i32, ptr %a1, align 4
  %52 = call i32 @Aes.gmul(ptr %0, i32 %a176, i32 13)
  %53 = xor i32 %51, %52
  %a277 = load i32, ptr %a2, align 4
  %54 = call i32 @Aes.gmul(ptr %0, i32 %a277, i32 9)
  %55 = xor i32 %53, %54
  %a378 = load i32, ptr %a3, align 4
  %56 = call i32 @Aes.gmul(ptr %0, i32 %a378, i32 14)
  %57 = xor i32 %55, %56
  store i32 %57, ptr %arr.elem74, align 4
  br label %for.update
}

define internal ptr @Aes.encryptBlock(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %r = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  %input = alloca ptr, align 8
  store ptr %1, ptr %input, align 8
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %2 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %s, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %3 = icmp slt i32 %i1, 16
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %5 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok10
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s13 = load ptr, ptr %s, align 8
  call void @Aes.addRoundKey(ptr %0, ptr %s13, i32 0)
  store i32 1, ptr %r, align 4
  br label %for.cond14

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4275, ptr @.faila.4276, i64 %5, ptr @.failb.4277, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data4 = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data4, i64 %5
  %input5 = load ptr, ptr %input, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %8 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %input5, align 8
  %arr.oob8 = icmp uge i64 %8, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4278, ptr @.faila.4279, i64 %8, ptr @.failb.4280, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %input5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %8
  %elem = load i32, ptr %arr.elem12, align 4
  %9 = and i32 %elem, 255
  store i32 %9, ptr %arr.elem, align 4
  br label %for.update

for.cond14:                                       ; preds = %for.update16, %for.end
  %r18 = load i32, ptr %r, align 4
  %rounds = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 4
  %rounds19 = load i32, ptr %rounds, align 4, !tbaa !7
  %10 = icmp slt i32 %r18, %rounds19
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body15, label %for.end17

for.body15:                                       ; preds = %for.cond14
  %s20 = load ptr, ptr %s, align 8
  call void @Aes.subBytes(ptr %0, ptr %s20)
  %s21 = load ptr, ptr %s, align 8
  call void @Aes.shiftRows(ptr %0, ptr %s21)
  %s22 = load ptr, ptr %s, align 8
  call void @Aes.mixColumns(ptr %0, ptr %s22)
  %s23 = load ptr, ptr %s, align 8
  %r24 = load i32, ptr %r, align 4
  call void @Aes.addRoundKey(ptr %0, ptr %s23, i32 %r24)
  br label %for.update16

for.update16:                                     ; preds = %for.body15
  %12 = load i32, ptr %r, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %r, align 4
  br label %for.cond14

for.end17:                                        ; preds = %for.cond14
  %s25 = load ptr, ptr %s, align 8
  call void @Aes.subBytes(ptr %0, ptr %s25)
  %s26 = load ptr, ptr %s, align 8
  call void @Aes.shiftRows(ptr %0, ptr %s26)
  %s27 = load ptr, ptr %s, align 8
  %rounds28 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 4
  %rounds29 = load i32, ptr %rounds28, align 4, !tbaa !7
  call void @Aes.addRoundKey(ptr %0, ptr %s27, i32 %rounds29)
  %s30 = load ptr, ptr %s, align 8
  ret ptr %s30
}

define internal ptr @Aes.decryptBlock(ptr nonnull align 8 dereferenceable(40) %0, ptr %1) {
entry:
  %r = alloca i32, align 4
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  %input = alloca ptr, align 8
  store ptr %1, ptr %input, align 8
  %arr = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %2 = call ptr @memset(ptr %arr.data, i32 0, i64 64)
  store ptr %arr, ptr %s, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %3 = icmp slt i32 %i1, 16
  %4 = zext i1 %3 to i32
  br i1 %3, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %s2 = load ptr, ptr %s, align 8, !nonnull !0, !dereferenceable !1
  %i3 = load i32, ptr %i, align 4
  %5 = sext i32 %i3 to i64
  %arr.len = load i64, ptr %s2, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok10
  %6 = load i32, ptr %i, align 4
  %7 = add i32 %6, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %s13 = load ptr, ptr %s, align 8
  %rounds = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 4
  %rounds14 = load i32, ptr %rounds, align 4, !tbaa !7
  call void @Aes.addRoundKey(ptr %0, ptr %s13, i32 %rounds14)
  %rounds15 = getelementptr inbounds %class.Aes, ptr %0, i32 0, i32 4
  %rounds16 = load i32, ptr %rounds15, align 4, !tbaa !7
  %8 = sub i32 %rounds16, 1
  store i32 %8, ptr %r, align 4
  br label %for.cond17

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4281, ptr @.faila.4282, i64 %5, ptr @.failb.4283, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data4 = getelementptr i8, ptr %s2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data4, i64 %5
  %input5 = load ptr, ptr %input, align 8, !nonnull !0, !dereferenceable !1
  %i6 = load i32, ptr %i, align 4
  %9 = sext i32 %i6 to i64
  %arr.len7 = load i64, ptr %input5, align 8
  %arr.oob8 = icmp uge i64 %9, %arr.len7
  br i1 %arr.oob8, label %idx.bad9, label %idx.ok10, !prof !2

idx.bad9:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4284, ptr @.faila.4285, i64 %9, ptr @.failb.4286, i64 %arr.len7, i32 70)
  unreachable

idx.ok10:                                         ; preds = %idx.ok
  %arr.data11 = getelementptr i8, ptr %input5, i64 8
  %arr.elem12 = getelementptr inbounds i32, ptr %arr.data11, i64 %9
  %elem = load i32, ptr %arr.elem12, align 4
  %10 = and i32 %elem, 255
  store i32 %10, ptr %arr.elem, align 4
  br label %for.update

for.cond17:                                       ; preds = %for.update19, %for.end
  %r21 = load i32, ptr %r, align 4
  %11 = icmp sgt i32 %r21, 0
  %12 = zext i1 %11 to i32
  br i1 %11, label %for.body18, label %for.end20

for.body18:                                       ; preds = %for.cond17
  %s22 = load ptr, ptr %s, align 8
  call void @Aes.invShiftRows(ptr %0, ptr %s22)
  %s23 = load ptr, ptr %s, align 8
  call void @Aes.invSubBytes(ptr %0, ptr %s23)
  %s24 = load ptr, ptr %s, align 8
  %r25 = load i32, ptr %r, align 4
  call void @Aes.addRoundKey(ptr %0, ptr %s24, i32 %r25)
  %s26 = load ptr, ptr %s, align 8
  call void @Aes.invMixColumns(ptr %0, ptr %s26)
  br label %for.update19

for.update19:                                     ; preds = %for.body18
  %r27 = load i32, ptr %r, align 4
  %13 = sub i32 %r27, 1
  store i32 %13, ptr %r, align 4
  br label %for.cond17

for.end20:                                        ; preds = %for.cond17
  %s28 = load ptr, ptr %s, align 8
  call void @Aes.invShiftRows(ptr %0, ptr %s28)
  %s29 = load ptr, ptr %s, align 8
  call void @Aes.invSubBytes(ptr %0, ptr %s29)
  %s30 = load ptr, ptr %s, align 8
  call void @Aes.addRoundKey(ptr %0, ptr %s30, i32 0)
  %s31 = load ptr, ptr %s, align 8
  ret ptr %s31
}

define internal ptr @Aes.ctr(ptr nonnull align 8 dereferenceable(40) %0, ptr %1, ptr %2) {
entry:
  %carry = alloca i32, align 4
  %c = alloca i32, align 4
  %j = alloca i32, align 4
  %ks = alloca ptr, align 8
  %off = alloca i32, align 4
  %i = alloca i32, align 4
  %counter = alloca ptr, align 8
  %out = alloca ptr, align 8
  %n = alloca i32, align 4
  %iv = alloca ptr, align 8
  %data = alloca ptr, align 8
  store ptr %1, ptr %data, align 8
  store ptr %2, ptr %iv, align 8
  %data1 = load ptr, ptr %data, align 8
  %len = load i64, ptr %data1, align 8
  %3 = trunc i64 %len to i32
  store i32 %3, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %4 = sext i32 %n2 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %out, align 8
  %arr3 = call ptr @__polaron_malloc(i64 72)
  store i64 16, ptr %arr3, align 8
  %arr.data4 = getelementptr i8, ptr %arr3, i64 8
  %8 = call ptr @memset(ptr %arr.data4, i32 0, i64 64)
  store ptr %arr3, ptr %counter, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i5 = load i32, ptr %i, align 4
  %9 = icmp slt i32 %i5, 16
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %counter6 = load ptr, ptr %counter, align 8, !nonnull !0, !dereferenceable !1
  %i7 = load i32, ptr %i, align 4
  %11 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %counter6, align 8
  %arr.oob = icmp uge i64 %11, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok14
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, ptr %off, align 4
  br label %while.cond

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4287, ptr @.faila.4288, i64 %11, ptr @.failb.4289, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %counter6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %11
  %iv9 = load ptr, ptr %iv, align 8, !nonnull !0, !dereferenceable !1
  %i10 = load i32, ptr %i, align 4
  %14 = sext i32 %i10 to i64
  %arr.len11 = load i64, ptr %iv9, align 8
  %arr.oob12 = icmp uge i64 %14, %arr.len11
  br i1 %arr.oob12, label %idx.bad13, label %idx.ok14, !prof !2

idx.bad13:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4290, ptr @.faila.4291, i64 %14, ptr @.failb.4292, i64 %arr.len11, i32 70)
  unreachable

idx.ok14:                                         ; preds = %idx.ok
  %arr.data15 = getelementptr i8, ptr %iv9, i64 8
  %arr.elem16 = getelementptr inbounds i32, ptr %arr.data15, i64 %14
  %elem = load i32, ptr %arr.elem16, align 4
  %15 = and i32 %elem, 255
  store i32 %15, ptr %arr.elem, align 4
  br label %for.update

while.cond:                                       ; preds = %while.end58, %for.end
  %off17 = load i32, ptr %off, align 4
  %n18 = load i32, ptr %n, align 4
  %16 = icmp slt i32 %off17, %n18
  %17 = zext i1 %16 to i32
  br i1 %16, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %counter19 = load ptr, ptr %counter, align 8
  %18 = call ptr @Aes.encryptBlock(ptr %0, ptr %counter19)
  store ptr %18, ptr %ks, align 8
  store i32 0, ptr %j, align 4
  br label %while.cond20

while.end:                                        ; preds = %while.cond
  %out94 = load ptr, ptr %out, align 8
  ret ptr %out94

while.cond20:                                     ; preds = %idx.ok51, %while.body
  %j23 = load i32, ptr %j, align 4
  %19 = icmp slt i32 %j23, 16
  %20 = zext i1 %19 to i32
  %sc.a = icmp ne i32 %20, 0
  br i1 %sc.a, label %sc.rhs, label %sc.end

while.body21:                                     ; preds = %sc.end
  %out27 = load ptr, ptr %out, align 8, !nonnull !0, !dereferenceable !1
  %off28 = load i32, ptr %off, align 4
  %j29 = load i32, ptr %j, align 4
  %21 = add i32 %off28, %j29
  %22 = sext i32 %21 to i64
  %arr.len30 = load i64, ptr %out27, align 8
  %arr.oob31 = icmp uge i64 %22, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !2

while.end22:                                      ; preds = %sc.end
  store i32 15, ptr %c, align 4
  store i32 1, ptr %carry, align 4
  br label %while.cond56

sc.rhs:                                           ; preds = %while.cond20
  %off24 = load i32, ptr %off, align 4
  %j25 = load i32, ptr %j, align 4
  %23 = add i32 %off24, %j25
  %n26 = load i32, ptr %n, align 4
  %24 = icmp slt i32 %23, %n26
  %25 = zext i1 %24 to i32
  %sc.b = icmp ne i32 %25, 0
  br label %sc.end

sc.end:                                           ; preds = %sc.rhs, %while.cond20
  %sc = phi i1 [ false, %while.cond20 ], [ %sc.b, %sc.rhs ]
  %26 = zext i1 %sc to i32
  br i1 %sc, label %while.body21, label %while.end22

idx.bad32:                                        ; preds = %while.body21
  call void @__polaron_fail(ptr @.fail.4293, ptr @.faila.4294, i64 %22, ptr @.failb.4295, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %while.body21
  %arr.data34 = getelementptr i8, ptr %out27, i64 8
  %arr.elem35 = getelementptr inbounds i32, ptr %arr.data34, i64 %22
  %data36 = load ptr, ptr %data, align 8, !nonnull !0, !dereferenceable !1
  %off37 = load i32, ptr %off, align 4
  %j38 = load i32, ptr %j, align 4
  %27 = add i32 %off37, %j38
  %28 = sext i32 %27 to i64
  %arr.len39 = load i64, ptr %data36, align 8
  %arr.oob40 = icmp uge i64 %28, %arr.len39
  br i1 %arr.oob40, label %idx.bad41, label %idx.ok42, !prof !2

idx.bad41:                                        ; preds = %idx.ok33
  call void @__polaron_fail(ptr @.fail.4296, ptr @.faila.4297, i64 %28, ptr @.failb.4298, i64 %arr.len39, i32 70)
  unreachable

idx.ok42:                                         ; preds = %idx.ok33
  %arr.data43 = getelementptr i8, ptr %data36, i64 8
  %arr.elem44 = getelementptr inbounds i32, ptr %arr.data43, i64 %28
  %elem45 = load i32, ptr %arr.elem44, align 4
  %ks46 = load ptr, ptr %ks, align 8, !nonnull !0, !dereferenceable !1
  %j47 = load i32, ptr %j, align 4
  %29 = sext i32 %j47 to i64
  %arr.len48 = load i64, ptr %ks46, align 8
  %arr.oob49 = icmp uge i64 %29, %arr.len48
  br i1 %arr.oob49, label %idx.bad50, label %idx.ok51, !prof !2

idx.bad50:                                        ; preds = %idx.ok42
  call void @__polaron_fail(ptr @.fail.4299, ptr @.faila.4300, i64 %29, ptr @.failb.4301, i64 %arr.len48, i32 70)
  unreachable

idx.ok51:                                         ; preds = %idx.ok42
  %arr.data52 = getelementptr i8, ptr %ks46, i64 8
  %arr.elem53 = getelementptr inbounds i32, ptr %arr.data52, i64 %29
  %elem54 = load i32, ptr %arr.elem53, align 4
  %30 = xor i32 %elem45, %elem54
  %31 = and i32 %30, 255
  store i32 %31, ptr %arr.elem35, align 4
  %j55 = load i32, ptr %j, align 4
  %32 = add i32 %j55, 1
  store i32 %32, ptr %j, align 4
  br label %while.cond20

while.cond56:                                     ; preds = %if.end, %while.end22
  %c59 = load i32, ptr %c, align 4
  %33 = icmp sge i32 %c59, 0
  %34 = zext i1 %33 to i32
  %sc.a60 = icmp ne i32 %34, 0
  br i1 %sc.a60, label %sc.rhs61, label %sc.end62

while.body57:                                     ; preds = %sc.end62
  %counter66 = load ptr, ptr %counter, align 8, !nonnull !0, !dereferenceable !1
  %c67 = load i32, ptr %c, align 4
  %35 = sext i32 %c67 to i64
  %arr.len68 = load i64, ptr %counter66, align 8
  %arr.oob69 = icmp uge i64 %35, %arr.len68
  br i1 %arr.oob69, label %idx.bad70, label %idx.ok71, !prof !2

while.end58:                                      ; preds = %sc.end62
  %off93 = load i32, ptr %off, align 4
  %36 = add i32 %off93, 16
  store i32 %36, ptr %off, align 4
  br label %while.cond

sc.rhs61:                                         ; preds = %while.cond56
  %carry63 = load i32, ptr %carry, align 4
  %sc.b64 = icmp ne i32 %carry63, 0
  br label %sc.end62

sc.end62:                                         ; preds = %sc.rhs61, %while.cond56
  %sc65 = phi i1 [ false, %while.cond56 ], [ %sc.b64, %sc.rhs61 ]
  %37 = zext i1 %sc65 to i32
  br i1 %sc65, label %while.body57, label %while.end58

idx.bad70:                                        ; preds = %while.body57
  call void @__polaron_fail(ptr @.fail.4302, ptr @.faila.4303, i64 %35, ptr @.failb.4304, i64 %arr.len68, i32 70)
  unreachable

idx.ok71:                                         ; preds = %while.body57
  %arr.data72 = getelementptr i8, ptr %counter66, i64 8
  %arr.elem73 = getelementptr inbounds i32, ptr %arr.data72, i64 %35
  %counter74 = load ptr, ptr %counter, align 8, !nonnull !0, !dereferenceable !1
  %c75 = load i32, ptr %c, align 4
  %38 = sext i32 %c75 to i64
  %arr.len76 = load i64, ptr %counter74, align 8
  %arr.oob77 = icmp uge i64 %38, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !2

idx.bad78:                                        ; preds = %idx.ok71
  call void @__polaron_fail(ptr @.fail.4305, ptr @.faila.4306, i64 %38, ptr @.failb.4307, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok71
  %arr.data80 = getelementptr i8, ptr %counter74, i64 8
  %arr.elem81 = getelementptr inbounds i32, ptr %arr.data80, i64 %38
  %elem82 = load i32, ptr %arr.elem81, align 4
  %39 = add i32 %elem82, 1
  %40 = and i32 %39, 255
  store i32 %40, ptr %arr.elem73, align 4
  %counter83 = load ptr, ptr %counter, align 8, !nonnull !0, !dereferenceable !1
  %c84 = load i32, ptr %c, align 4
  %41 = sext i32 %c84 to i64
  %arr.len85 = load i64, ptr %counter83, align 8
  %arr.oob86 = icmp uge i64 %41, %arr.len85
  br i1 %arr.oob86, label %idx.bad87, label %idx.ok88, !prof !2

idx.bad87:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.4308, ptr @.faila.4309, i64 %41, ptr @.failb.4310, i64 %arr.len85, i32 70)
  unreachable

idx.ok88:                                         ; preds = %idx.ok79
  %arr.data89 = getelementptr i8, ptr %counter83, i64 8
  %arr.elem90 = getelementptr inbounds i32, ptr %arr.data89, i64 %41
  %elem91 = load i32, ptr %arr.elem90, align 4
  %42 = icmp ne i32 %elem91, 0
  %43 = zext i1 %42 to i32
  br i1 %42, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok88
  store i32 0, ptr %carry, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %idx.ok88
  %c92 = load i32, ptr %c, align 4
  %44 = sub i32 %c92, 1
  store i32 %44, ptr %c, align 4
  br label %while.cond56
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5447)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5449)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{}
!1 = !{i64 8}
!2 = !{!"branch_weights", i32 1, i32 1048576}
!3 = !{!4, !4, i64 0}
!4 = !{!"ptr", !5, i64 0}
!5 = !{!"polaron char", !6, i64 0}
!6 = !{!"polaron TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"i32", !5, i64 0}
