; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/autodiff_matrix.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/autodiff_matrix.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Matrix = type { ptr, ptr, i32, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.Dual = type { ptr, double, double }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Dual.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Dual.add, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Dual.sub, ptr @Dual.mul, ptr null, ptr null, ptr null, ptr null, ptr @Dual.value, ptr @Dual.deriv, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Matrix.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.get, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.add, ptr null, ptr @Matrix.set, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.multiply, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Matrix.rows, ptr @Matrix.cols, ptr @Matrix.transpose, ptr @Matrix.determinant, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.str = private unnamed_addr constant [38 x i8] c"fval=%d fder=%d c00=%d c11=%d t01=%d\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1304 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1305 = private global %String { i64 16, ptr @.strdata.1304, i64 0 }
@.strdata.1306 = private constant [17 x i8] c"division by zero\00"
@.strobj.1307 = private global %String { i64 16, ptr @.strdata.1306, i64 0 }
@.fail.3314 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5693:48  in Matrix.set\0A\00", align 1
@.faila.3315 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3316 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3317 = private unnamed_addr constant [81 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5696:59  in Matrix.get\0A\00", align 1
@.faila.3318 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3319 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3320 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5727:64  in Matrix.determinant\0A\00", align 1
@.faila.3321 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3322 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3323 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5727:64  in Matrix.determinant\0A\00", align 1
@.faila.3324 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3325 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3326 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5731:21  in Matrix.determinant\0A\00", align 1
@.faila.3327 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3328 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3329 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5734:29  in Matrix.determinant\0A\00", align 1
@.faila.3330 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3331 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3332 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5738:29  in Matrix.determinant\0A\00", align 1
@.faila.3333 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3334 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3335 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5739:42  in Matrix.determinant\0A\00", align 1
@.faila.3336 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3337 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3338 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5739:42  in Matrix.determinant\0A\00", align 1
@.faila.3339 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3340 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3341 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5740:43  in Matrix.determinant\0A\00", align 1
@.faila.3342 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3343 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3344 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3345 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3346 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3347 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3348 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3349 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3350 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3351 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3352 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3353 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3354 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3355 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3356 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5746:42  in Matrix.determinant\0A\00", align 1
@.faila.3357 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3358 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3359 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5749:26  in Matrix.determinant\0A\00", align 1
@.faila.3360 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3361 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.3362 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:5751:17  in Matrix.determinant\0A\00", align 1
@.faila.3363 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3364 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5305 = private constant [1 x i8] zeroinitializer
@.strobj.5306 = private global %String { i64 0, ptr @.strdata.5305, i64 0 }
@.strdata.5307 = private constant [1 x i8] zeroinitializer
@.strobj.5308 = private global %String { i64 0, ptr @.strdata.5307, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %t = alloca ptr, align 8
  %c = alloca ptr, align 8
  %b = alloca ptr, align 8
  %a = alloca ptr, align 8
  %f = alloca ptr, align 8
  %x = alloca ptr, align 8
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
  %16 = call ptr @Dual.variable(double 3.000000e+00)
  store ptr %16, ptr %x, align 8
  %x1 = load ptr, ptr %x, align 8
  %x2 = load ptr, ptr %x, align 8
  %17 = call ptr @Dual.mul(ptr %x1, ptr %x2)
  %x3 = load ptr, ptr %x, align 8
  %18 = call ptr @Dual.mul(ptr %17, ptr %x3)
  %x4 = load ptr, ptr %x, align 8
  %19 = call ptr @Dual.add(ptr %18, ptr %x4)
  store ptr %19, ptr %f, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 2, i32 2)
  store ptr %Matrix.obj, ptr %a, align 8
  %a5 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a5, i32 0, i32 0, i32 1)
  %a6 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a6, i32 0, i32 1, i32 2)
  %a7 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a7, i32 1, i32 0, i32 3)
  %a8 = load ptr, ptr %a, align 8
  call void @Matrix.set(ptr %a8, i32 1, i32 1, i32 4)
  %Matrix.obj9 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  call void @Matrix.Matrix(ptr %Matrix.obj9, i32 2, i32 2)
  store ptr %Matrix.obj9, ptr %b, align 8
  %b10 = load ptr, ptr %b, align 8
  call void @Matrix.set(ptr %b10, i32 0, i32 0, i32 5)
  %b11 = load ptr, ptr %b, align 8
  call void @Matrix.set(ptr %b11, i32 0, i32 1, i32 6)
  %b12 = load ptr, ptr %b, align 8
  call void @Matrix.set(ptr %b12, i32 1, i32 0, i32 7)
  %b13 = load ptr, ptr %b, align 8
  call void @Matrix.set(ptr %b13, i32 1, i32 1, i32 8)
  %a14 = load ptr, ptr %a, align 8
  %b15 = load ptr, ptr %b, align 8
  %20 = call ptr @Matrix.multiply(ptr %a14, ptr %b15)
  store ptr %20, ptr %c, align 8
  %a16 = load ptr, ptr %a, align 8
  %21 = call ptr @Matrix.transpose(ptr %a16)
  store ptr %21, ptr %t, align 8
  %f17 = load ptr, ptr %f, align 8
  %22 = call double @Dual.value(ptr %f17)
  %23 = call i32 @llvm.fptosi.sat.i32.f64(double %22)
  %f18 = load ptr, ptr %f, align 8
  %24 = call double @Dual.deriv(ptr %f18)
  %25 = call i32 @llvm.fptosi.sat.i32.f64(double %24)
  %c19 = load ptr, ptr %c, align 8
  %26 = call i32 @Matrix.get(ptr %c19, i32 0, i32 0)
  %c20 = load ptr, ptr %c, align 8
  %27 = call i32 @Matrix.get(ptr %c20, i32 1, i32 1)
  %t21 = load ptr, ptr %t, align 8
  %28 = call i32 @Matrix.get(ptr %t21, i32 0, i32 1)
  %29 = call i32 (ptr, ...) @printf(ptr @.str, i32 %23, i32 %25, i32 %26, i32 %27, i32 %28)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1305)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1307)
  ret ptr %strcpy
}

define internal void @Dual.Dual(ptr %0, double %1, double %2) {
entry:
  %deriv = alloca double, align 8
  %value = alloca double, align 8
  store double %1, ptr %value, align 8
  store double %2, ptr %deriv, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 0
  store ptr @Dual.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %v = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 1
  %value1 = load double, ptr %value, align 8
  store double %value1, ptr %v, align 8, !tbaa !4
  %d = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 2
  %deriv2 = load double, ptr %deriv, align 8
  store double %deriv2, ptr %d, align 8, !tbaa !4
  ret void
}

define internal ptr @Dual.variable(double %0) {
entry:
  %x = alloca double, align 8
  store double %0, ptr %x, align 8
  %Dual.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  %x1 = load double, ptr %x, align 8
  call void @Dual.Dual(ptr %Dual.obj, double %x1, double 1.000000e+00)
  ret ptr %Dual.obj
}

define internal double @Dual.value(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %v = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 1
  %v1 = load double, ptr %v, align 8, !tbaa !4
  ret double %v1
}

define internal double @Dual.deriv(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %d = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 2
  %d1 = load double, ptr %d, align 8, !tbaa !4
  ret double %d1
}

define internal ptr @Dual.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Dual.copy = alloca %class.Dual, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Dual.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  store ptr %Dual.copy, ptr %o, align 8
  %Dual.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  %v = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 1
  %v1 = load double, ptr %v, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Dual.value(ptr %o2)
  %4 = fadd double %v1, %3
  %d = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 2
  %d3 = load double, ptr %d, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Dual.deriv(ptr %o4)
  %6 = fadd double %d3, %5
  call void @Dual.Dual(ptr %Dual.obj, double %4, double %6)
  ret ptr %Dual.obj
}

define internal ptr @Dual.sub(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Dual.copy = alloca %class.Dual, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Dual.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  store ptr %Dual.copy, ptr %o, align 8
  %Dual.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  %v = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 1
  %v1 = load double, ptr %v, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Dual.value(ptr %o2)
  %4 = fsub double %v1, %3
  %d = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 2
  %d3 = load double, ptr %d, align 8, !tbaa !4
  %o4 = load ptr, ptr %o, align 8
  %5 = call double @Dual.deriv(ptr %o4)
  %6 = fsub double %d3, %5
  call void @Dual.Dual(ptr %Dual.obj, double %4, double %6)
  ret ptr %Dual.obj
}

define internal ptr @Dual.mul(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %Dual.copy = alloca %class.Dual, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Dual.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  store ptr %Dual.copy, ptr %o, align 8
  %Dual.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Dual, ptr null, i64 1) to i64))
  %v = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 1
  %v1 = load double, ptr %v, align 8, !tbaa !4
  %o2 = load ptr, ptr %o, align 8
  %3 = call double @Dual.value(ptr %o2)
  %4 = fmul double %v1, %3
  %v3 = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 1
  %v4 = load double, ptr %v3, align 8, !tbaa !4
  %o5 = load ptr, ptr %o, align 8
  %5 = call double @Dual.deriv(ptr %o5)
  %6 = fmul double %v4, %5
  %d = getelementptr inbounds %class.Dual, ptr %0, i32 0, i32 2
  %d6 = load double, ptr %d, align 8, !tbaa !4
  %o7 = load ptr, ptr %o, align 8
  %7 = call double @Dual.value(ptr %o7)
  %8 = fmul double %d6, %7
  %9 = fadd double %6, %8
  call void @Dual.Dual(ptr %Dual.obj, double %4, double %9)
  ret ptr %Dual.obj
}

define internal void @Matrix.Matrix(ptr %0, i32 %1, i32 %2) {
entry:
  %cols = alloca i32, align 4
  %rows = alloca i32, align 4
  store i32 %1, ptr %rows, align 4
  store i32 %2, ptr %cols, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 0
  store ptr @Matrix.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  store ptr null, ptr %cells, align 8, !tbaa !0
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %rows1 = load i32, ptr %rows, align 4
  store i32 %rows1, ptr %nrows, align 4, !tbaa !6
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %cols2 = load i32, ptr %cols, align 4
  store i32 %cols2, ptr %ncols, align 4, !tbaa !6
  %cells3 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %rows4 = load i32, ptr %rows, align 4
  %cols5 = load i32, ptr %cols, align 4
  %3 = mul i32 %rows4, %cols5
  %4 = sext i32 %3 to i64
  %5 = mul i64 %4, 4
  %6 = add i64 8, %5
  %arr = call ptr @__polaron_malloc(i64 %6)
  store i64 %4, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %7 = call ptr @memset(ptr %arr.data, i32 0, i64 %5)
  store ptr %arr, ptr %cells3, align 8, !tbaa !0
  ret void
}

define internal i32 @Matrix.rows(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !6
  ret i32 %nrows1
}

define internal i32 @Matrix.cols(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols1 = load i32, ptr %ncols, align 4, !tbaa !6
  ret i32 %ncols1
}

define internal void @Matrix.set(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2, i32 %3) {
entry:
  %value = alloca i32, align 4
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  store i32 %3, ptr %value, align 4
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %r2 = load i32, ptr %r, align 4
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols3 = load i32, ptr %ncols, align 4, !tbaa !6
  %4 = mul i32 %r2, %ncols3
  %c4 = load i32, ptr %c, align 4
  %5 = add i32 %4, %c4
  %6 = sext i32 %5 to i64
  %arr.len = load i64, ptr %cells1, align 8
  %arr.oob = icmp uge i64 %6, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3314, ptr @.faila.3315, i64 %6, ptr @.failb.3316, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cells1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %6
  %value5 = load i32, ptr %value, align 4
  store i32 %value5, ptr %arr.elem, align 4
  ret void
}

define internal i32 @Matrix.get(ptr nonnull align 8 dereferenceable(24) %0, i32 %1, i32 %2) {
entry:
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 %1, ptr %r, align 4
  store i32 %2, ptr %c, align 4
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %cells1 = load ptr, ptr %cells, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %r2 = load i32, ptr %r, align 4
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols3 = load i32, ptr %ncols, align 4, !tbaa !6
  %3 = mul i32 %r2, %ncols3
  %c4 = load i32, ptr %c, align 4
  %4 = add i32 %3, %c4
  %5 = sext i32 %4 to i64
  %arr.len = load i64, ptr %cells1, align 8
  %arr.oob = icmp uge i64 %5, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.3317, ptr @.faila.3318, i64 %5, ptr @.failb.3319, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %cells1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %5
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal ptr @Matrix.multiply(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %k = alloca i32, align 4
  %s = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %Matrix.copy = alloca %class.Matrix, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Matrix.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Matrix, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.Matrix, ptr %Matrix.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %Matrix.copy, ptr %o, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !6
  %o2 = load ptr, ptr %o, align 8
  %9 = call i32 @Matrix.cols(ptr %o2)
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 %nrows1, i32 %9)
  store ptr %Matrix.obj, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %nrows4 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows5 = load i32, ptr %nrows4, align 4, !tbaa !6
  %10 = icmp slt i32 %i3, %nrows5
  %11 = zext i1 %10 to i32
  br i1 %10, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %12 = load i32, ptr %i, align 4
  %13 = add i32 %12, 1
  store i32 %13, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m28 = load ptr, ptr %m, align 8
  ret ptr %m28

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %o11 = load ptr, ptr %o, align 8
  %14 = call i32 @Matrix.cols(ptr %o11)
  %15 = icmp slt i32 %j10, %14
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  store i32 0, ptr %s, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond12

for.update8:                                      ; preds = %for.end15
  %17 = load i32, ptr %j, align 4
  %18 = add i32 %17, 1
  store i32 %18, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update

for.cond12:                                       ; preds = %for.update14, %for.body7
  %k16 = load i32, ptr %k, align 4
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols17 = load i32, ptr %ncols, align 4, !tbaa !6
  %19 = icmp slt i32 %k16, %ncols17
  %20 = zext i1 %19 to i32
  br i1 %19, label %for.body13, label %for.end15

for.body13:                                       ; preds = %for.cond12
  %s18 = load i32, ptr %s, align 4
  %i19 = load i32, ptr %i, align 4
  %k20 = load i32, ptr %k, align 4
  %21 = call i32 @Matrix.get(ptr %0, i32 %i19, i32 %k20)
  %o21 = load ptr, ptr %o, align 8
  %k22 = load i32, ptr %k, align 4
  %j23 = load i32, ptr %j, align 4
  %22 = call i32 @Matrix.get(ptr %o21, i32 %k22, i32 %j23)
  %23 = mul i32 %21, %22
  %24 = add i32 %s18, %23
  store i32 %24, ptr %s, align 4
  br label %for.update14

for.update14:                                     ; preds = %for.body13
  %25 = load i32, ptr %k, align 4
  %26 = add i32 %25, 1
  store i32 %26, ptr %k, align 4
  br label %for.cond12

for.end15:                                        ; preds = %for.cond12
  %m24 = load ptr, ptr %m, align 8
  %i25 = load i32, ptr %i, align 4
  %j26 = load i32, ptr %j, align 4
  %s27 = load i32, ptr %s, align 4
  call void @Matrix.set(ptr %m24, i32 %i25, i32 %j26, i32 %s27)
  br label %for.update8
}

define internal ptr @Matrix.transpose(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols1 = load i32, ptr %ncols, align 4, !tbaa !6
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows2 = load i32, ptr %nrows, align 4, !tbaa !6
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 %ncols1, i32 %nrows2)
  store ptr %Matrix.obj, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %nrows4 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows5 = load i32, ptr %nrows4, align 4, !tbaa !6
  %1 = icmp slt i32 %i3, %nrows5
  %2 = zext i1 %1 to i32
  br i1 %1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %3 = load i32, ptr %i, align 4
  %4 = add i32 %3, 1
  store i32 %4, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m18 = load ptr, ptr %m, align 8
  ret ptr %m18

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %ncols11 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols12 = load i32, ptr %ncols11, align 4, !tbaa !6
  %5 = icmp slt i32 %j10, %ncols12
  %6 = zext i1 %5 to i32
  br i1 %5, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %m13 = load ptr, ptr %m, align 8
  %j14 = load i32, ptr %j, align 4
  %i15 = load i32, ptr %i, align 4
  %i16 = load i32, ptr %i, align 4
  %j17 = load i32, ptr %j, align 4
  %7 = call i32 @Matrix.get(ptr %0, i32 %i16, i32 %j17)
  call void @Matrix.set(ptr %m13, i32 %j14, i32 %i15, i32 %7)
  br label %for.update8

for.update8:                                      ; preds = %for.body7
  %8 = load i32, ptr %j, align 4
  %9 = add i32 %8, 1
  store i32 %9, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update
}

define internal ptr @Matrix.add(ptr nonnull align 8 dereferenceable(24) %0, ptr %1) {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %Matrix.copy = alloca %class.Matrix, align 8
  %o = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Matrix.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %3 = getelementptr inbounds %class.Matrix, ptr %1, i32 0, i32 1
  %4 = load ptr, ptr %3, align 8, !tbaa !0
  %arr.len = load i64, ptr %4, align 8
  %5 = mul i64 %arr.len, 4
  %6 = add i64 8, %5
  %arr.copy = call ptr @__polaron_malloc(i64 %6)
  %7 = call ptr @memcpy(ptr %arr.copy, ptr %4, i64 %6)
  %8 = getelementptr inbounds %class.Matrix, ptr %Matrix.copy, i32 0, i32 1
  store ptr %arr.copy, ptr %8, align 8, !tbaa !0
  store ptr %Matrix.copy, ptr %o, align 8
  %Matrix.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Matrix, ptr null, i64 1) to i64))
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !6
  %ncols = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols2 = load i32, ptr %ncols, align 4, !tbaa !6
  call void @Matrix.Matrix(ptr %Matrix.obj, i32 %nrows1, i32 %ncols2)
  store ptr %Matrix.obj, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i3 = load i32, ptr %i, align 4
  %nrows4 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows5 = load i32, ptr %nrows4, align 4, !tbaa !6
  %9 = icmp slt i32 %i3, %nrows5
  %10 = zext i1 %9 to i32
  br i1 %9, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  br label %for.cond6

for.update:                                       ; preds = %for.end9
  %11 = load i32, ptr %i, align 4
  %12 = add i32 %11, 1
  store i32 %12, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m21 = load ptr, ptr %m, align 8
  ret ptr %m21

for.cond6:                                        ; preds = %for.update8, %for.body
  %j10 = load i32, ptr %j, align 4
  %ncols11 = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 3
  %ncols12 = load i32, ptr %ncols11, align 4, !tbaa !6
  %13 = icmp slt i32 %j10, %ncols12
  %14 = zext i1 %13 to i32
  br i1 %13, label %for.body7, label %for.end9

for.body7:                                        ; preds = %for.cond6
  %m13 = load ptr, ptr %m, align 8
  %i14 = load i32, ptr %i, align 4
  %j15 = load i32, ptr %j, align 4
  %i16 = load i32, ptr %i, align 4
  %j17 = load i32, ptr %j, align 4
  %15 = call i32 @Matrix.get(ptr %0, i32 %i16, i32 %j17)
  %o18 = load ptr, ptr %o, align 8
  %i19 = load i32, ptr %i, align 4
  %j20 = load i32, ptr %j, align 4
  %16 = call i32 @Matrix.get(ptr %o18, i32 %i19, i32 %j20)
  %17 = add i32 %15, %16
  call void @Matrix.set(ptr %m13, i32 %i14, i32 %j15, i32 %17)
  br label %for.update8

for.update8:                                      ; preds = %for.body7
  %18 = load i32, ptr %j, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %j, align 4
  br label %for.cond6

for.end9:                                         ; preds = %for.cond6
  br label %for.update
}

define internal i32 @Matrix.determinant(ptr nonnull align 8 dereferenceable(24) %0) personality ptr @__CxxFrameHandler3 {
entry:
  %exc.thrown = alloca ptr, align 8
  %j = alloca i32, align 4
  %i110 = alloca i32, align 4
  %t = alloca i32, align 4
  %c = alloca i32, align 4
  %r = alloca i32, align 4
  %sw = alloca i32, align 4
  %k = alloca i32, align 4
  %sign = alloca i32, align 4
  %prev = alloca i32, align 4
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %n = alloca i32, align 4
  %nrows = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 2
  %nrows1 = load i32, ptr %nrows, align 4, !tbaa !6
  store i32 %nrows1, ptr %n, align 4
  %n2 = load i32, ptr %n, align 4
  %n3 = load i32, ptr %n, align 4
  %1 = mul i32 %n2, %n3
  %2 = sext i32 %1 to i64
  %3 = mul i64 %2, 4
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i4 = load i32, ptr %i, align 4
  %n5 = load i32, ptr %n, align 4
  %n6 = load i32, ptr %n, align 4
  %6 = mul i32 %n5, %n6
  %7 = icmp slt i32 %i4, %6
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %m7 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %i8 = load i32, ptr %i, align 4
  %9 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %m7, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok15
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 1, ptr %prev, align 4
  store i32 1, ptr %sign, align 4
  store i32 0, ptr %k, align 4
  br label %for.cond18

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.3320, ptr @.faila.3321, i64 %9, ptr @.failb.3322, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data9 = getelementptr i8, ptr %m7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %9
  %cells = getelementptr inbounds %class.Matrix, ptr %0, i32 0, i32 1
  %cells10 = load ptr, ptr %cells, align 8, !tbaa !0, !nonnull !8, !dereferenceable !9
  %i11 = load i32, ptr %i, align 4
  %12 = sext i32 %i11 to i64
  %arr.len12 = load i64, ptr %cells10, align 8
  %arr.oob13 = icmp uge i64 %12, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !10

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.3323, ptr @.faila.3324, i64 %12, ptr @.failb.3325, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %cells10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %12
  %elem = load i32, ptr %arr.elem17, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update

for.cond18:                                       ; preds = %for.update20, %for.end
  %k22 = load i32, ptr %k, align 4
  %n23 = load i32, ptr %n, align 4
  %13 = sub i32 %n23, 1
  %14 = icmp slt i32 %k22, %13
  %15 = zext i1 %14 to i32
  br i1 %14, label %for.body19, label %for.end21

for.body19:                                       ; preds = %for.cond18
  %m24 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %k25 = load i32, ptr %k, align 4
  %n26 = load i32, ptr %n, align 4
  %16 = mul i32 %k25, %n26
  %k27 = load i32, ptr %k, align 4
  %17 = add i32 %16, %k27
  %18 = sext i32 %17 to i64
  %arr.len28 = load i64, ptr %m24, align 8
  %arr.oob29 = icmp uge i64 %18, %arr.len28
  br i1 %arr.oob29, label %idx.bad30, label %idx.ok31, !prof !10

for.update20:                                     ; preds = %idx.ok186
  %19 = load i32, ptr %k, align 4
  %20 = add i32 %19, 1
  store i32 %20, ptr %k, align 4
  br label %for.cond18

for.end21:                                        ; preds = %for.cond18
  %sign190 = load i32, ptr %sign, align 4
  %m191 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %n192 = load i32, ptr %n, align 4
  %21 = sub i32 %n192, 1
  %n193 = load i32, ptr %n, align 4
  %22 = mul i32 %21, %n193
  %n194 = load i32, ptr %n, align 4
  %23 = sub i32 %n194, 1
  %24 = add i32 %22, %23
  %25 = sext i32 %24 to i64
  %arr.len195 = load i64, ptr %m191, align 8
  %arr.oob196 = icmp uge i64 %25, %arr.len195
  br i1 %arr.oob196, label %idx.bad197, label %idx.ok198, !prof !10

idx.bad30:                                        ; preds = %for.body19
  call void @__polaron_fail(ptr @.fail.3326, ptr @.faila.3327, i64 %18, ptr @.failb.3328, i64 %arr.len28, i32 70)
  unreachable

idx.ok31:                                         ; preds = %for.body19
  %arr.data32 = getelementptr i8, ptr %m24, i64 8
  %arr.elem33 = getelementptr inbounds i32, ptr %arr.data32, i64 %18
  %elem34 = load i32, ptr %arr.elem33, align 4
  %26 = icmp eq i32 %elem34, 0
  %27 = zext i1 %26 to i32
  br i1 %26, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok31
  store i32 -1, ptr %sw, align 4
  %k35 = load i32, ptr %k, align 4
  %28 = add i32 %k35, 1
  store i32 %28, ptr %r, align 4
  br label %for.cond36

if.end:                                           ; preds = %for.end62, %idx.ok31
  %k109 = load i32, ptr %k, align 4
  %29 = add i32 %k109, 1
  store i32 %29, ptr %i110, align 4
  br label %for.cond111

for.cond36:                                       ; preds = %for.update38, %if.then
  %r40 = load i32, ptr %r, align 4
  %n41 = load i32, ptr %n, align 4
  %30 = icmp slt i32 %r40, %n41
  %31 = zext i1 %30 to i32
  br i1 %30, label %for.body37, label %for.end39

for.body37:                                       ; preds = %for.cond36
  %m42 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %r43 = load i32, ptr %r, align 4
  %n44 = load i32, ptr %n, align 4
  %32 = mul i32 %r43, %n44
  %k45 = load i32, ptr %k, align 4
  %33 = add i32 %32, %k45
  %34 = sext i32 %33 to i64
  %arr.len46 = load i64, ptr %m42, align 8
  %arr.oob47 = icmp uge i64 %34, %arr.len46
  br i1 %arr.oob47, label %idx.bad48, label %idx.ok49, !prof !10

for.update38:                                     ; preds = %if.end54
  %35 = load i32, ptr %r, align 4
  %36 = add i32 %35, 1
  store i32 %36, ptr %r, align 4
  br label %for.cond36

for.end39:                                        ; preds = %for.cond36
  %sw56 = load i32, ptr %sw, align 4
  %37 = icmp slt i32 %sw56, 0
  %38 = zext i1 %37 to i32
  br i1 %37, label %if.then57, label %if.end58

idx.bad48:                                        ; preds = %for.body37
  call void @__polaron_fail(ptr @.fail.3329, ptr @.faila.3330, i64 %34, ptr @.failb.3331, i64 %arr.len46, i32 70)
  unreachable

idx.ok49:                                         ; preds = %for.body37
  %arr.data50 = getelementptr i8, ptr %m42, i64 8
  %arr.elem51 = getelementptr inbounds i32, ptr %arr.data50, i64 %34
  %elem52 = load i32, ptr %arr.elem51, align 4
  %39 = icmp ne i32 %elem52, 0
  %40 = zext i1 %39 to i32
  br i1 %39, label %if.then53, label %if.end54

if.then53:                                        ; preds = %idx.ok49
  %r55 = load i32, ptr %r, align 4
  store i32 %r55, ptr %sw, align 4
  br label %if.end54

if.end54:                                         ; preds = %if.then53, %idx.ok49
  br label %for.update38

if.then57:                                        ; preds = %for.end39
  ret i32 0

if.end58:                                         ; preds = %for.end39
  store i32 0, ptr %c, align 4
  br label %for.cond59

for.cond59:                                       ; preds = %for.update61, %if.end58
  %c63 = load i32, ptr %c, align 4
  %n64 = load i32, ptr %n, align 4
  %41 = icmp slt i32 %c63, %n64
  %42 = zext i1 %41 to i32
  br i1 %41, label %for.body60, label %for.end62

for.body60:                                       ; preds = %for.cond59
  %m65 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %k66 = load i32, ptr %k, align 4
  %n67 = load i32, ptr %n, align 4
  %43 = mul i32 %k66, %n67
  %c68 = load i32, ptr %c, align 4
  %44 = add i32 %43, %c68
  %45 = sext i32 %44 to i64
  %arr.len69 = load i64, ptr %m65, align 8
  %arr.oob70 = icmp uge i64 %45, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !10

for.update61:                                     ; preds = %idx.ok104
  %46 = load i32, ptr %c, align 4
  %47 = add i32 %46, 1
  store i32 %47, ptr %c, align 4
  br label %for.cond59

for.end62:                                        ; preds = %for.cond59
  %sign108 = load i32, ptr %sign, align 4
  %48 = sub i32 0, %sign108
  store i32 %48, ptr %sign, align 4
  br label %if.end

idx.bad71:                                        ; preds = %for.body60
  call void @__polaron_fail(ptr @.fail.3332, ptr @.faila.3333, i64 %45, ptr @.failb.3334, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %for.body60
  %arr.data73 = getelementptr i8, ptr %m65, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 %45
  %elem75 = load i32, ptr %arr.elem74, align 4
  store i32 %elem75, ptr %t, align 4
  %m76 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %k77 = load i32, ptr %k, align 4
  %n78 = load i32, ptr %n, align 4
  %49 = mul i32 %k77, %n78
  %c79 = load i32, ptr %c, align 4
  %50 = add i32 %49, %c79
  %51 = sext i32 %50 to i64
  %arr.len80 = load i64, ptr %m76, align 8
  %arr.oob81 = icmp uge i64 %51, %arr.len80
  br i1 %arr.oob81, label %idx.bad82, label %idx.ok83, !prof !10

idx.bad82:                                        ; preds = %idx.ok72
  call void @__polaron_fail(ptr @.fail.3335, ptr @.faila.3336, i64 %51, ptr @.failb.3337, i64 %arr.len80, i32 70)
  unreachable

idx.ok83:                                         ; preds = %idx.ok72
  %arr.data84 = getelementptr i8, ptr %m76, i64 8
  %arr.elem85 = getelementptr inbounds i32, ptr %arr.data84, i64 %51
  %m86 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %sw87 = load i32, ptr %sw, align 4
  %n88 = load i32, ptr %n, align 4
  %52 = mul i32 %sw87, %n88
  %c89 = load i32, ptr %c, align 4
  %53 = add i32 %52, %c89
  %54 = sext i32 %53 to i64
  %arr.len90 = load i64, ptr %m86, align 8
  %arr.oob91 = icmp uge i64 %54, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !10

idx.bad92:                                        ; preds = %idx.ok83
  call void @__polaron_fail(ptr @.fail.3338, ptr @.faila.3339, i64 %54, ptr @.failb.3340, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok83
  %arr.data94 = getelementptr i8, ptr %m86, i64 8
  %arr.elem95 = getelementptr inbounds i32, ptr %arr.data94, i64 %54
  %elem96 = load i32, ptr %arr.elem95, align 4
  store i32 %elem96, ptr %arr.elem85, align 4
  %m97 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %sw98 = load i32, ptr %sw, align 4
  %n99 = load i32, ptr %n, align 4
  %55 = mul i32 %sw98, %n99
  %c100 = load i32, ptr %c, align 4
  %56 = add i32 %55, %c100
  %57 = sext i32 %56 to i64
  %arr.len101 = load i64, ptr %m97, align 8
  %arr.oob102 = icmp uge i64 %57, %arr.len101
  br i1 %arr.oob102, label %idx.bad103, label %idx.ok104, !prof !10

idx.bad103:                                       ; preds = %idx.ok93
  call void @__polaron_fail(ptr @.fail.3341, ptr @.faila.3342, i64 %57, ptr @.failb.3343, i64 %arr.len101, i32 70)
  unreachable

idx.ok104:                                        ; preds = %idx.ok93
  %arr.data105 = getelementptr i8, ptr %m97, i64 8
  %arr.elem106 = getelementptr inbounds i32, ptr %arr.data105, i64 %57
  %t107 = load i32, ptr %t, align 4
  store i32 %t107, ptr %arr.elem106, align 4
  br label %for.update61

for.cond111:                                      ; preds = %for.update113, %if.end
  %i115 = load i32, ptr %i110, align 4
  %n116 = load i32, ptr %n, align 4
  %58 = icmp slt i32 %i115, %n116
  %59 = zext i1 %58 to i32
  br i1 %58, label %for.body112, label %for.end114

for.body112:                                      ; preds = %for.cond111
  %k117 = load i32, ptr %k, align 4
  %60 = add i32 %k117, 1
  store i32 %60, ptr %j, align 4
  br label %for.cond118

for.update113:                                    ; preds = %for.end121
  %61 = load i32, ptr %i110, align 4
  %62 = add i32 %61, 1
  store i32 %62, ptr %i110, align 4
  br label %for.cond111

for.end114:                                       ; preds = %for.cond111
  %m179 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %k180 = load i32, ptr %k, align 4
  %n181 = load i32, ptr %n, align 4
  %63 = mul i32 %k180, %n181
  %k182 = load i32, ptr %k, align 4
  %64 = add i32 %63, %k182
  %65 = sext i32 %64 to i64
  %arr.len183 = load i64, ptr %m179, align 8
  %arr.oob184 = icmp uge i64 %65, %arr.len183
  br i1 %arr.oob184, label %idx.bad185, label %idx.ok186, !prof !10

for.cond118:                                      ; preds = %for.update120, %for.body112
  %j122 = load i32, ptr %j, align 4
  %n123 = load i32, ptr %n, align 4
  %66 = icmp slt i32 %j122, %n123
  %67 = zext i1 %66 to i32
  br i1 %66, label %for.body119, label %for.end121

for.body119:                                      ; preds = %for.cond118
  %m124 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %i125 = load i32, ptr %i110, align 4
  %n126 = load i32, ptr %n, align 4
  %68 = mul i32 %i125, %n126
  %j127 = load i32, ptr %j, align 4
  %69 = add i32 %68, %j127
  %70 = sext i32 %69 to i64
  %arr.len128 = load i64, ptr %m124, align 8
  %arr.oob129 = icmp uge i64 %70, %arr.len128
  br i1 %arr.oob129, label %idx.bad130, label %idx.ok131, !prof !10

for.update120:                                    ; preds = %div.ok
  %71 = load i32, ptr %j, align 4
  %72 = add i32 %71, 1
  store i32 %72, ptr %j, align 4
  br label %for.cond118

for.end121:                                       ; preds = %for.cond118
  br label %for.update113

idx.bad130:                                       ; preds = %for.body119
  call void @__polaron_fail(ptr @.fail.3344, ptr @.faila.3345, i64 %70, ptr @.failb.3346, i64 %arr.len128, i32 70)
  unreachable

idx.ok131:                                        ; preds = %for.body119
  %arr.data132 = getelementptr i8, ptr %m124, i64 8
  %arr.elem133 = getelementptr inbounds i32, ptr %arr.data132, i64 %70
  %m134 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %i135 = load i32, ptr %i110, align 4
  %n136 = load i32, ptr %n, align 4
  %73 = mul i32 %i135, %n136
  %j137 = load i32, ptr %j, align 4
  %74 = add i32 %73, %j137
  %75 = sext i32 %74 to i64
  %arr.len138 = load i64, ptr %m134, align 8
  %arr.oob139 = icmp uge i64 %75, %arr.len138
  br i1 %arr.oob139, label %idx.bad140, label %idx.ok141, !prof !10

idx.bad140:                                       ; preds = %idx.ok131
  call void @__polaron_fail(ptr @.fail.3347, ptr @.faila.3348, i64 %75, ptr @.failb.3349, i64 %arr.len138, i32 70)
  unreachable

idx.ok141:                                        ; preds = %idx.ok131
  %arr.data142 = getelementptr i8, ptr %m134, i64 8
  %arr.elem143 = getelementptr inbounds i32, ptr %arr.data142, i64 %75
  %elem144 = load i32, ptr %arr.elem143, align 4
  %m145 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %k146 = load i32, ptr %k, align 4
  %n147 = load i32, ptr %n, align 4
  %76 = mul i32 %k146, %n147
  %k148 = load i32, ptr %k, align 4
  %77 = add i32 %76, %k148
  %78 = sext i32 %77 to i64
  %arr.len149 = load i64, ptr %m145, align 8
  %arr.oob150 = icmp uge i64 %78, %arr.len149
  br i1 %arr.oob150, label %idx.bad151, label %idx.ok152, !prof !10

idx.bad151:                                       ; preds = %idx.ok141
  call void @__polaron_fail(ptr @.fail.3350, ptr @.faila.3351, i64 %78, ptr @.failb.3352, i64 %arr.len149, i32 70)
  unreachable

idx.ok152:                                        ; preds = %idx.ok141
  %arr.data153 = getelementptr i8, ptr %m145, i64 8
  %arr.elem154 = getelementptr inbounds i32, ptr %arr.data153, i64 %78
  %elem155 = load i32, ptr %arr.elem154, align 4
  %79 = mul i32 %elem144, %elem155
  %m156 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %i157 = load i32, ptr %i110, align 4
  %n158 = load i32, ptr %n, align 4
  %80 = mul i32 %i157, %n158
  %k159 = load i32, ptr %k, align 4
  %81 = add i32 %80, %k159
  %82 = sext i32 %81 to i64
  %arr.len160 = load i64, ptr %m156, align 8
  %arr.oob161 = icmp uge i64 %82, %arr.len160
  br i1 %arr.oob161, label %idx.bad162, label %idx.ok163, !prof !10

idx.bad162:                                       ; preds = %idx.ok152
  call void @__polaron_fail(ptr @.fail.3353, ptr @.faila.3354, i64 %82, ptr @.failb.3355, i64 %arr.len160, i32 70)
  unreachable

idx.ok163:                                        ; preds = %idx.ok152
  %arr.data164 = getelementptr i8, ptr %m156, i64 8
  %arr.elem165 = getelementptr inbounds i32, ptr %arr.data164, i64 %82
  %elem166 = load i32, ptr %arr.elem165, align 4
  %m167 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %k168 = load i32, ptr %k, align 4
  %n169 = load i32, ptr %n, align 4
  %83 = mul i32 %k168, %n169
  %j170 = load i32, ptr %j, align 4
  %84 = add i32 %83, %j170
  %85 = sext i32 %84 to i64
  %arr.len171 = load i64, ptr %m167, align 8
  %arr.oob172 = icmp uge i64 %85, %arr.len171
  br i1 %arr.oob172, label %idx.bad173, label %idx.ok174, !prof !10

idx.bad173:                                       ; preds = %idx.ok163
  call void @__polaron_fail(ptr @.fail.3356, ptr @.faila.3357, i64 %85, ptr @.failb.3358, i64 %arr.len171, i32 70)
  unreachable

idx.ok174:                                        ; preds = %idx.ok163
  %arr.data175 = getelementptr i8, ptr %m167, i64 8
  %arr.elem176 = getelementptr inbounds i32, ptr %arr.data175, i64 %85
  %elem177 = load i32, ptr %arr.elem176, align 4
  %86 = mul i32 %elem166, %elem177
  %87 = sub i32 %79, %86
  %prev178 = load i32, ptr %prev, align 4
  %88 = icmp eq i32 %prev178, 0
  %89 = icmp eq i32 %87, -2147483648
  %90 = icmp eq i32 %prev178, -1
  %91 = and i1 %89, %90
  %92 = or i1 %88, %91
  br i1 %92, label %div.bad, label %div.ok

div.bad:                                          ; preds = %idx.ok174
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %idx.ok174
  %93 = sdiv i32 %87, %prev178
  store i32 %93, ptr %arr.elem133, align 4
  br label %for.update120

idx.bad185:                                       ; preds = %for.end114
  call void @__polaron_fail(ptr @.fail.3359, ptr @.faila.3360, i64 %65, ptr @.failb.3361, i64 %arr.len183, i32 70)
  unreachable

idx.ok186:                                        ; preds = %for.end114
  %arr.data187 = getelementptr i8, ptr %m179, i64 8
  %arr.elem188 = getelementptr inbounds i32, ptr %arr.data187, i64 %65
  %elem189 = load i32, ptr %arr.elem188, align 4
  store i32 %elem189, ptr %prev, align 4
  br label %for.update20

idx.bad197:                                       ; preds = %for.end21
  call void @__polaron_fail(ptr @.fail.3362, ptr @.faila.3363, i64 %25, ptr @.failb.3364, i64 %arr.len195, i32 70)
  unreachable

idx.ok198:                                        ; preds = %for.end21
  %arr.data199 = getelementptr i8, ptr %m191, i64 8
  %arr.elem200 = getelementptr inbounds i32, ptr %arr.data199, i64 %25
  %elem201 = load i32, ptr %arr.elem200, align 4
  %94 = mul i32 %sign190, %elem201
  ret i32 %94
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5306)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5308)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.fptosi.sat.i32.f64(double) #0

declare i32 @printf(ptr, ...)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #1

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #1 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

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
