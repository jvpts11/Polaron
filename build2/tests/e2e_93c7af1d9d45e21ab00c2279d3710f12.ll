; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sha256.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sha256.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.str = private unnamed_addr constant [8 x i8] c"abc=%s\0A\00", align 1
@.strdata = private constant [4 x i8] c"abc\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.str.1 = private unnamed_addr constant [10 x i8] c"empty=%s\0A\00", align 1
@.strdata.2 = private constant [1 x i8] zeroinitializer
@.strobj.3 = private global %String { i64 0, ptr @.strdata.2, i64 0 }
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1309 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1310 = private global %String { i64 16, ptr @.strdata.1309, i64 0 }
@.strdata.1311 = private constant [17 x i8] c"division by zero\00"
@.strobj.1312 = private global %String { i64 16, ptr @.strdata.1311, i64 0 }
@.fail.4175 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8466:28  in Sha256.putWord\0A\00", align 1
@.faila.4176 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4177 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4178 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8467:28  in Sha256.putWord\0A\00", align 1
@.faila.4179 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4180 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4181 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8468:28  in Sha256.putWord\0A\00", align 1
@.faila.4182 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4183 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4184 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8469:28  in Sha256.putWord\0A\00", align 1
@.faila.4185 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4186 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.4187 = private constant [17 x i8] c"0123456789abcdef\00"
@.strobj.4188 = private global %String { i64 16, ptr @.strdata.4187, i64 0 }
@.fail.4189 = private unnamed_addr constant [83 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8477:21  in Sha256.toHex\0A\00", align 1
@.faila.4190 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4191 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4192 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8489:62  in Sha256.digestRaw\0A\00", align 1
@.faila.4193 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4194 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4195 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8489:62  in Sha256.digestRaw\0A\00", align 1
@.faila.4196 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4197 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4198 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8490:24  in Sha256.digestRaw\0A\00", align 1
@.faila.4199 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4200 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4201 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8493:39  in Sha256.digestRaw\0A\00", align 1
@.faila.4202 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4203 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4204 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8496:21  in Sha256.digestRaw\0A\00", align 1
@.faila.4205 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4206 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4207 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8496:50  in Sha256.digestRaw\0A\00", align 1
@.faila.4208 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4209 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4210 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8496:79  in Sha256.digestRaw\0A\00", align 1
@.faila.4211 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4212 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4213 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8496:108  in Sha256.digestRaw\0A\00", align 1
@.faila.4214 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4215 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4216 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8497:21  in Sha256.digestRaw\0A\00", align 1
@.faila.4217 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4218 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4219 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8497:50  in Sha256.digestRaw\0A\00", align 1
@.faila.4220 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4221 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4222 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8497:79  in Sha256.digestRaw\0A\00", align 1
@.faila.4223 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4224 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4225 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8497:108  in Sha256.digestRaw\0A\00", align 1
@.faila.4226 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4227 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4228 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8498:21  in Sha256.digestRaw\0A\00", align 1
@.faila.4229 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4230 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4231 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8498:50  in Sha256.digestRaw\0A\00", align 1
@.faila.4232 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4233 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4234 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8498:80  in Sha256.digestRaw\0A\00", align 1
@.faila.4235 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4236 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4237 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8498:110  in Sha256.digestRaw\0A\00", align 1
@.faila.4238 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4239 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4240 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8499:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4241 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4242 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4243 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8499:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4244 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4245 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4246 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8499:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4247 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4248 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4249 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8499:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4250 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4251 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4252 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8500:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4253 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4254 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4255 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8500:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4256 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4257 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4258 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8500:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4259 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4260 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4261 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8500:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4262 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4263 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4264 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8501:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4265 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4266 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4267 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8501:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4268 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4269 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4270 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8501:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4271 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4272 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4273 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8501:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4274 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4275 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4276 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8502:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4277 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4278 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4279 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8502:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4280 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4281 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4282 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8502:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4283 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4284 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4285 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8502:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4286 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4287 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4288 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8503:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4289 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4290 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4291 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8503:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4292 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4293 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4294 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8503:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4295 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4296 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4297 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8503:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4298 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4299 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4300 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8504:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4301 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4302 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4303 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8504:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4304 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4305 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4306 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8504:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4307 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4308 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4309 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8504:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4310 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4311 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4312 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8505:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4313 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4314 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4315 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8505:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4316 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4317 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4318 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8505:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4319 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4320 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4321 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8505:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4322 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4323 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4324 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8506:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4325 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4326 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4327 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8506:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4328 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4329 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4330 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8506:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4331 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4332 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4333 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8506:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4334 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4335 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4336 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8507:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4337 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4338 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4339 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8507:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4340 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4341 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4342 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8507:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4343 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4344 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4345 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8507:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4346 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4347 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4348 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8508:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4349 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4350 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4351 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8508:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4352 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4353 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4354 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8508:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4355 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4356 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4357 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8508:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4358 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4359 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4360 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8509:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4361 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4362 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4363 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8509:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4364 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4365 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4366 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8509:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4367 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4368 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4369 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8509:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4370 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4371 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4372 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8510:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4373 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4374 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4375 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8510:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4376 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4377 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4378 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8510:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4379 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4380 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4381 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8510:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4382 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4383 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4384 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8511:22  in Sha256.digestRaw\0A\00", align 1
@.faila.4385 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4386 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4387 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8511:52  in Sha256.digestRaw\0A\00", align 1
@.faila.4388 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4389 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4390 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8511:82  in Sha256.digestRaw\0A\00", align 1
@.faila.4391 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4392 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4393 = private unnamed_addr constant [88 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8511:112  in Sha256.digestRaw\0A\00", align 1
@.faila.4394 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4395 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4396 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8521:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4397 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4398 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4399 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8521:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4400 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4401 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4402 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8521:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4403 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4404 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4405 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8521:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4406 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4407 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4408 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8521:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4409 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4410 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4411 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8525:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4412 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4413 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4414 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8525:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4415 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4416 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4417 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8525:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4418 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4419 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4420 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8526:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4421 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4422 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4423 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8526:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4424 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4425 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4426 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8526:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4427 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4428 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4429 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8527:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4430 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4431 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4432 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8527:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4433 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4434 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4435 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8527:30  in Sha256.digestRaw\0A\00", align 1
@.faila.4436 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4437 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4438 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8534:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4439 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4440 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4441 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8534:25  in Sha256.digestRaw\0A\00", align 1
@.faila.4442 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4443 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4444 = private unnamed_addr constant [84 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:8552:65  in Sha256.digest\0A\00", align 1
@.faila.4445 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.4446 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5310 = private constant [1 x i8] zeroinitializer
@.strobj.5311 = private global %String { i64 0, ptr @.strdata.5310, i64 0 }
@.strdata.5312 = private constant [1 x i8] zeroinitializer
@.strobj.5313 = private global %String { i64 0, ptr @.strdata.5312, i64 0 }

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
  %16 = call ptr @Sha256.digest(ptr @.strobj)
  %str.data = getelementptr inbounds %String, ptr %16, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %17 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data)
  call void @__polaron_str_free(ptr %16)
  %18 = call ptr @Sha256.digest(ptr @.strobj.3)
  %str.data1 = getelementptr inbounds %String, ptr %18, i32 0, i32 1
  %data2 = load ptr, ptr %str.data1, align 8
  %19 = call i32 (ptr, ...) @printf(ptr @.str.1, ptr %data2)
  call void @__polaron_str_free(ptr %18)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1310)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1312)
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
  store i64 %1, ptr %buf, align 8, !tbaa !6
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
  %buf13 = load i64, ptr %buf, align 8, !tbaa !6
  %count14 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 2
  %count15 = load i32, ptr %count14, align 4, !tbaa !4
  %12 = sext i32 %count15 to i64
  %13 = inttoptr i64 %buf13 to ptr
  %14 = inttoptr i64 %nb12 to ptr
  %15 = call ptr @memcpy(ptr %14, ptr %13, i64 %12)
  %buf16 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf17 = load i64, ptr %buf16, align 8, !tbaa !6
  %16 = inttoptr i64 %buf17 to ptr
  call void @__polaron_free(ptr %16)
  %buf18 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %nb19 = load i64, ptr %nb, align 8
  store i64 %nb19, ptr %buf18, align 8, !tbaa !6
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
  %buf3 = load i64, ptr %buf, align 8, !tbaa !6
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
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
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
  %buf24 = load i64, ptr %buf, align 8, !tbaa !6
  %a25 = load i32, ptr %a, align 4
  %25 = sext i32 %a25 to i64
  %26 = add i64 %buf24, %25
  %27 = inttoptr i64 %26 to ptr
  %mem.read = load i8, ptr %27, align 1
  store i8 %mem.read, ptr %t, align 1
  %buf26 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf27 = load i64, ptr %buf26, align 8, !tbaa !6
  %a28 = load i32, ptr %a, align 4
  %28 = sext i32 %a28 to i64
  %29 = add i64 %buf27, %28
  %buf29 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf30 = load i64, ptr %buf29, align 8, !tbaa !6
  %b31 = load i32, ptr %b, align 4
  %30 = sext i32 %b31 to i64
  %31 = add i64 %buf30, %30
  %32 = inttoptr i64 %31 to ptr
  %mem.read32 = load i8, ptr %32, align 1
  %33 = inttoptr i64 %29 to ptr
  store i8 %mem.read32, ptr %33, align 1
  %buf33 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf34 = load i64, ptr %buf33, align 8, !tbaa !6
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
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
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
  %buf1 = load i64, ptr %buf, align 8, !tbaa !6
  %1 = icmp ne i64 %buf1, 0
  %2 = zext i1 %1 to i32
  br i1 %1, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %buf2 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  %buf3 = load i64, ptr %buf2, align 8, !tbaa !6
  %3 = inttoptr i64 %buf3 to ptr
  call void @__polaron_free(ptr %3)
  %buf4 = getelementptr inbounds %class.StringBuilder, ptr %0, i32 0, i32 1
  store i64 0, ptr %buf4, align 8, !tbaa !6
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  ret void
}

define internal i32 @Sha256.rotr(i32 %0, i32 %1) {
entry:
  %n = alloca i32, align 4
  %x = alloca i32, align 4
  store i32 %0, ptr %x, align 4
  store i32 %1, ptr %n, align 4
  %x1 = load i32, ptr %x, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp ult i32 %n2, 32
  %3 = select i1 %2, i32 %n2, i32 0
  %4 = lshr i32 %x1, %3
  %5 = select i1 %2, i32 %4, i32 0
  %x3 = load i32, ptr %x, align 4
  %n4 = load i32, ptr %n, align 4
  %6 = sub i32 32, %n4
  %7 = icmp ult i32 %6, 32
  %8 = select i1 %7, i32 %6, i32 0
  %9 = shl i32 %x3, %8
  %10 = select i1 %7, i32 %9, i32 0
  %11 = or i32 %5, %10
  ret i32 %11
}

define internal void @Sha256.putWord(ptr %0, i32 %1, i32 %2) {
entry:
  %w = alloca i32, align 4
  %off = alloca i32, align 4
  %out = alloca ptr, align 8
  store ptr %0, ptr %out, align 8
  store i32 %1, ptr %off, align 4
  store i32 %2, ptr %w, align 4
  %out1 = load ptr, ptr %out, align 8, !nonnull !8, !dereferenceable !9
  %off2 = load i32, ptr %off, align 4
  %3 = sext i32 %off2 to i64
  %arr.len = load i64, ptr %out1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.4175, ptr @.faila.4176, i64 %3, ptr @.failb.4177, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %out1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %3
  %w3 = load i32, ptr %w, align 4
  %4 = lshr i32 %w3, 24
  %5 = and i32 %4, 255
  store i32 %5, ptr %arr.elem, align 4
  %out4 = load ptr, ptr %out, align 8, !nonnull !8, !dereferenceable !9
  %off5 = load i32, ptr %off, align 4
  %6 = add i32 %off5, 1
  %7 = sext i32 %6 to i64
  %arr.len6 = load i64, ptr %out4, align 8
  %arr.oob7 = icmp uge i64 %7, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !10

idx.bad8:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4178, ptr @.faila.4179, i64 %7, ptr @.failb.4180, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %idx.ok
  %arr.data10 = getelementptr i8, ptr %out4, i64 8
  %arr.elem11 = getelementptr inbounds i32, ptr %arr.data10, i64 %7
  %w12 = load i32, ptr %w, align 4
  %8 = lshr i32 %w12, 16
  %9 = and i32 %8, 255
  store i32 %9, ptr %arr.elem11, align 4
  %out13 = load ptr, ptr %out, align 8, !nonnull !8, !dereferenceable !9
  %off14 = load i32, ptr %off, align 4
  %10 = add i32 %off14, 2
  %11 = sext i32 %10 to i64
  %arr.len15 = load i64, ptr %out13, align 8
  %arr.oob16 = icmp uge i64 %11, %arr.len15
  br i1 %arr.oob16, label %idx.bad17, label %idx.ok18, !prof !10

idx.bad17:                                        ; preds = %idx.ok9
  call void @__polaron_fail(ptr @.fail.4181, ptr @.faila.4182, i64 %11, ptr @.failb.4183, i64 %arr.len15, i32 70)
  unreachable

idx.ok18:                                         ; preds = %idx.ok9
  %arr.data19 = getelementptr i8, ptr %out13, i64 8
  %arr.elem20 = getelementptr inbounds i32, ptr %arr.data19, i64 %11
  %w21 = load i32, ptr %w, align 4
  %12 = lshr i32 %w21, 8
  %13 = and i32 %12, 255
  store i32 %13, ptr %arr.elem20, align 4
  %out22 = load ptr, ptr %out, align 8, !nonnull !8, !dereferenceable !9
  %off23 = load i32, ptr %off, align 4
  %14 = add i32 %off23, 3
  %15 = sext i32 %14 to i64
  %arr.len24 = load i64, ptr %out22, align 8
  %arr.oob25 = icmp uge i64 %15, %arr.len24
  br i1 %arr.oob25, label %idx.bad26, label %idx.ok27, !prof !10

idx.bad26:                                        ; preds = %idx.ok18
  call void @__polaron_fail(ptr @.fail.4184, ptr @.faila.4185, i64 %15, ptr @.failb.4186, i64 %arr.len24, i32 70)
  unreachable

idx.ok27:                                         ; preds = %idx.ok18
  %arr.data28 = getelementptr i8, ptr %out22, i64 8
  %arr.elem29 = getelementptr inbounds i32, ptr %arr.data28, i64 %15
  %w30 = load i32, ptr %w, align 4
  %16 = and i32 %w30, 255
  store i32 %16, ptr %arr.elem29, align 4
  ret void
}

define internal ptr @Sha256.toHex(ptr %0, i32 %1) {
entry:
  %b = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %digs = alloca ptr, align 8
  %n = alloca i32, align 4
  %bytes = alloca ptr, align 8
  store ptr %0, ptr %bytes, align 8
  store i32 %1, ptr %n, align 4
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.4188)
  store ptr %strcpy, ptr %digs, align 8
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %2 = icmp slt i32 %i1, %n2
  %3 = zext i1 %2 to i32
  br i1 %2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %bytes3 = load ptr, ptr %bytes, align 8, !nonnull !8, !dereferenceable !9
  %i4 = load i32, ptr %i, align 4
  %4 = sext i32 %i4 to i64
  %arr.len = load i64, ptr %bytes3, align 8
  %arr.oob = icmp uge i64 %4, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %5 = load i32, ptr %i, align 4
  %6 = add i32 %5, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %sb15 = load ptr, ptr %sb, align 8
  %7 = call ptr @StringBuilder.toString(ptr %sb15)
  %strcpy16 = call ptr @__polaron_str_copy(ptr %7)
  call void @__polaron_str_free(ptr %7)
  %8 = load ptr, ptr %digs, align 8
  call void @__polaron_str_free(ptr %8)
  ret ptr %strcpy16

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4189, ptr @.faila.4190, i64 %4, ptr @.failb.4191, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data = getelementptr i8, ptr %bytes3, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %4
  %elem = load i32, ptr %arr.elem, align 4
  %9 = and i32 %elem, 255
  store i32 %9, ptr %b, align 4
  %sb5 = load ptr, ptr %sb, align 8
  %digs6 = load ptr, ptr %digs, align 8
  %b7 = load i32, ptr %b, align 4
  %10 = ashr i32 %b7, 31
  %11 = ashr i32 %b7, 4
  %12 = and i32 %11, 15
  %13 = sext i32 %12 to i64
  %str.data = getelementptr inbounds %String, ptr %digs6, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %13
  %ch = load i8, ptr %ch.addr, align 1
  %14 = zext i8 %ch to i32
  %15 = call ptr @StringBuilder.appendChar(ptr %sb5, i32 %14)
  %sb8 = load ptr, ptr %sb, align 8
  %digs9 = load ptr, ptr %digs, align 8
  %b10 = load i32, ptr %b, align 4
  %16 = and i32 %b10, 15
  %17 = sext i32 %16 to i64
  %str.data11 = getelementptr inbounds %String, ptr %digs9, i32 0, i32 1
  %data12 = load ptr, ptr %str.data11, align 8
  %ch.addr13 = getelementptr i8, ptr %data12, i64 %17
  %ch14 = load i8, ptr %ch.addr13, align 1
  %18 = zext i8 %ch14 to i32
  %19 = call ptr @StringBuilder.appendChar(ptr %sb8, i32 %18)
  br label %for.update
}

define internal ptr @Sha256.digestRaw(ptr %0, i32 %1) personality ptr @__CxxFrameHandler3 {
entry:
  %out = alloca ptr, align 8
  %t2 = alloca i32, align 4
  %maj = alloca i32, align 4
  %bigS0 = alloca i32, align 4
  %t1 = alloca i32, align 4
  %ch = alloca i32, align 4
  %bigS1 = alloca i32, align 4
  %t649 = alloca i32, align 4
  %hh = alloca i32, align 4
  %g = alloca i32, align 4
  %f = alloca i32, align 4
  %e = alloca i32, align 4
  %d = alloca i32, align 4
  %c = alloca i32, align 4
  %b2 = alloca i32, align 4
  %a = alloca i32, align 4
  %s1 = alloca i32, align 4
  %s0 = alloca i32, align 4
  %t553 = alloca i32, align 4
  %b = alloca i32, align 4
  %t = alloca i32, align 4
  %blk = alloca i32, align 4
  %w = alloca ptr, align 8
  %h7 = alloca i32, align 4
  %h6 = alloca i32, align 4
  %h5 = alloca i32, align 4
  %h4 = alloca i32, align 4
  %h3 = alloca i32, align 4
  %h2 = alloca i32, align 4
  %h1 = alloca i32, align 4
  %h0 = alloca i32, align 4
  %k = alloca ptr, align 8
  %i28 = alloca i32, align 4
  %bits = alloca i64, align 8
  %i = alloca i32, align 4
  %m = alloca ptr, align 8
  %exc.thrown = alloca ptr, align 8
  %padded = alloca i32, align 4
  %len = alloca i32, align 4
  %data = alloca ptr, align 8
  store ptr %0, ptr %data, align 8
  store i32 %1, ptr %len, align 4
  %len1 = load i32, ptr %len, align 4
  %2 = add i32 %len1, 1
  store i32 %2, ptr %padded, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %padded2 = load i32, ptr %padded, align 4
  %3 = icmp eq i32 %padded2, -2147483648
  %4 = and i1 %3, false
  %5 = or i1 false, %4
  br i1 %5, label %div.bad, label %div.ok

while.body:                                       ; preds = %div.ok
  %padded3 = load i32, ptr %padded, align 4
  %6 = add i32 %padded3, 1
  store i32 %6, ptr %padded, align 4
  br label %while.cond

while.end:                                        ; preds = %div.ok
  %padded4 = load i32, ptr %padded, align 4
  %7 = add i32 %padded4, 8
  store i32 %7, ptr %padded, align 4
  %padded5 = load i32, ptr %padded, align 4
  %8 = sext i32 %padded5 to i64
  %9 = mul i64 %8, 4
  %10 = add i64 8, %9
  %arr = call ptr @__polaron_malloc(i64 %10)
  store i64 %8, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %11 = call ptr @memset(ptr %arr.data, i32 0, i64 %9)
  store ptr %arr, ptr %m, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

div.bad:                                          ; preds = %while.cond
  %exc = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.DivideByZeroException, ptr null, i64 1) to i64))
  call void @DivideByZeroException.DivideByZeroException(ptr %exc)
  store ptr %exc, ptr %exc.thrown, align 8
  call void @_CxxThrowException(ptr %exc.thrown, ptr @_TI1PEAX)
  unreachable

div.ok:                                           ; preds = %while.cond
  %12 = srem i32 %padded2, 64
  %13 = icmp ne i32 %12, 56
  %14 = zext i1 %13 to i32
  br i1 %13, label %while.body, label %while.end

for.cond:                                         ; preds = %for.update, %while.end
  %i6 = load i32, ptr %i, align 4
  %len7 = load i32, ptr %len, align 4
  %15 = icmp slt i32 %i6, %len7
  %16 = zext i1 %15 to i32
  br i1 %15, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %m8 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %i9 = load i32, ptr %i, align 4
  %17 = sext i32 %i9 to i64
  %arr.len = load i64, ptr %m8, align 8
  %arr.oob = icmp uge i64 %17, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok16
  %18 = load i32, ptr %i, align 4
  %19 = add i32 %18, 1
  store i32 %19, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %m19 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %len20 = load i32, ptr %len, align 4
  %20 = sext i32 %len20 to i64
  %arr.len21 = load i64, ptr %m19, align 8
  %arr.oob22 = icmp uge i64 %20, %arr.len21
  br i1 %arr.oob22, label %idx.bad23, label %idx.ok24, !prof !10

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4192, ptr @.faila.4193, i64 %17, ptr @.failb.4194, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data10 = getelementptr i8, ptr %m8, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data10, i64 %17
  %data11 = load ptr, ptr %data, align 8, !nonnull !8, !dereferenceable !9
  %i12 = load i32, ptr %i, align 4
  %21 = sext i32 %i12 to i64
  %arr.len13 = load i64, ptr %data11, align 8
  %arr.oob14 = icmp uge i64 %21, %arr.len13
  br i1 %arr.oob14, label %idx.bad15, label %idx.ok16, !prof !10

idx.bad15:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.4195, ptr @.faila.4196, i64 %21, ptr @.failb.4197, i64 %arr.len13, i32 70)
  unreachable

idx.ok16:                                         ; preds = %idx.ok
  %arr.data17 = getelementptr i8, ptr %data11, i64 8
  %arr.elem18 = getelementptr inbounds i32, ptr %arr.data17, i64 %21
  %elem = load i32, ptr %arr.elem18, align 4
  %22 = and i32 %elem, 255
  store i32 %22, ptr %arr.elem, align 4
  br label %for.update

idx.bad23:                                        ; preds = %for.end
  call void @__polaron_fail(ptr @.fail.4198, ptr @.faila.4199, i64 %20, ptr @.failb.4200, i64 %arr.len21, i32 70)
  unreachable

idx.ok24:                                         ; preds = %for.end
  %arr.data25 = getelementptr i8, ptr %m19, i64 8
  %arr.elem26 = getelementptr inbounds i32, ptr %arr.data25, i64 %20
  store i32 128, ptr %arr.elem26, align 4
  %len27 = load i32, ptr %len, align 4
  %23 = sext i32 %len27 to i64
  %24 = mul i64 %23, 8
  store i64 %24, ptr %bits, align 8
  store i32 0, ptr %i28, align 4
  br label %for.cond29

for.cond29:                                       ; preds = %for.update31, %idx.ok24
  %i33 = load i32, ptr %i28, align 4
  %25 = icmp slt i32 %i33, 8
  %26 = zext i1 %25 to i32
  br i1 %25, label %for.body30, label %for.end32

for.body30:                                       ; preds = %for.cond29
  %m34 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %padded35 = load i32, ptr %padded, align 4
  %27 = sub i32 %padded35, 1
  %i36 = load i32, ptr %i28, align 4
  %28 = sub i32 %27, %i36
  %29 = sext i32 %28 to i64
  %arr.len37 = load i64, ptr %m34, align 8
  %arr.oob38 = icmp uge i64 %29, %arr.len37
  br i1 %arr.oob38, label %idx.bad39, label %idx.ok40, !prof !10

for.update31:                                     ; preds = %idx.ok40
  %30 = load i32, ptr %i28, align 4
  %31 = add i32 %30, 1
  store i32 %31, ptr %i28, align 4
  br label %for.cond29

for.end32:                                        ; preds = %for.cond29
  %arr45 = call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr45, align 8
  %arr.data46 = getelementptr i8, ptr %arr45, i64 8
  %32 = call ptr @memset(ptr %arr.data46, i32 0, i64 256)
  store ptr %arr45, ptr %k, align 8
  %k47 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len48 = load i64, ptr %k47, align 8
  %arr.oob49 = icmp uge i64 0, %arr.len48
  br i1 %arr.oob49, label %idx.bad50, label %idx.ok51, !prof !10

idx.bad39:                                        ; preds = %for.body30
  call void @__polaron_fail(ptr @.fail.4201, ptr @.faila.4202, i64 %29, ptr @.failb.4203, i64 %arr.len37, i32 70)
  unreachable

idx.ok40:                                         ; preds = %for.body30
  %arr.data41 = getelementptr i8, ptr %m34, i64 8
  %arr.elem42 = getelementptr inbounds i32, ptr %arr.data41, i64 %29
  %bits43 = load i64, ptr %bits, align 8
  %i44 = load i32, ptr %i28, align 4
  %33 = mul i32 %i44, 8
  %34 = sext i32 %33 to i64
  %35 = ashr i64 %bits43, 63
  %36 = icmp ult i64 %34, 64
  %37 = select i1 %36, i64 %34, i64 0
  %38 = ashr i64 %bits43, %37
  %39 = select i1 %36, i64 %38, i64 %35
  %40 = and i64 %39, 255
  %41 = trunc i64 %40 to i32
  store i32 %41, ptr %arr.elem42, align 4
  br label %for.update31

idx.bad50:                                        ; preds = %for.end32
  call void @__polaron_fail(ptr @.fail.4204, ptr @.faila.4205, i64 0, ptr @.failb.4206, i64 %arr.len48, i32 70)
  unreachable

idx.ok51:                                         ; preds = %for.end32
  %arr.data52 = getelementptr i8, ptr %k47, i64 8
  %arr.elem53 = getelementptr inbounds i32, ptr %arr.data52, i64 0
  store i32 1116352408, ptr %arr.elem53, align 4
  %k54 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len55 = load i64, ptr %k54, align 8
  %arr.oob56 = icmp uge i64 1, %arr.len55
  br i1 %arr.oob56, label %idx.bad57, label %idx.ok58, !prof !10

idx.bad57:                                        ; preds = %idx.ok51
  call void @__polaron_fail(ptr @.fail.4207, ptr @.faila.4208, i64 1, ptr @.failb.4209, i64 %arr.len55, i32 70)
  unreachable

idx.ok58:                                         ; preds = %idx.ok51
  %arr.data59 = getelementptr i8, ptr %k54, i64 8
  %arr.elem60 = getelementptr inbounds i32, ptr %arr.data59, i64 1
  store i32 1899447441, ptr %arr.elem60, align 4
  %k61 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len62 = load i64, ptr %k61, align 8
  %arr.oob63 = icmp uge i64 2, %arr.len62
  br i1 %arr.oob63, label %idx.bad64, label %idx.ok65, !prof !10

idx.bad64:                                        ; preds = %idx.ok58
  call void @__polaron_fail(ptr @.fail.4210, ptr @.faila.4211, i64 2, ptr @.failb.4212, i64 %arr.len62, i32 70)
  unreachable

idx.ok65:                                         ; preds = %idx.ok58
  %arr.data66 = getelementptr i8, ptr %k61, i64 8
  %arr.elem67 = getelementptr inbounds i32, ptr %arr.data66, i64 2
  store i32 -1245643825, ptr %arr.elem67, align 4
  %k68 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len69 = load i64, ptr %k68, align 8
  %arr.oob70 = icmp uge i64 3, %arr.len69
  br i1 %arr.oob70, label %idx.bad71, label %idx.ok72, !prof !10

idx.bad71:                                        ; preds = %idx.ok65
  call void @__polaron_fail(ptr @.fail.4213, ptr @.faila.4214, i64 3, ptr @.failb.4215, i64 %arr.len69, i32 70)
  unreachable

idx.ok72:                                         ; preds = %idx.ok65
  %arr.data73 = getelementptr i8, ptr %k68, i64 8
  %arr.elem74 = getelementptr inbounds i32, ptr %arr.data73, i64 3
  store i32 -373957723, ptr %arr.elem74, align 4
  %k75 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len76 = load i64, ptr %k75, align 8
  %arr.oob77 = icmp uge i64 4, %arr.len76
  br i1 %arr.oob77, label %idx.bad78, label %idx.ok79, !prof !10

idx.bad78:                                        ; preds = %idx.ok72
  call void @__polaron_fail(ptr @.fail.4216, ptr @.faila.4217, i64 4, ptr @.failb.4218, i64 %arr.len76, i32 70)
  unreachable

idx.ok79:                                         ; preds = %idx.ok72
  %arr.data80 = getelementptr i8, ptr %k75, i64 8
  %arr.elem81 = getelementptr inbounds i32, ptr %arr.data80, i64 4
  store i32 961987163, ptr %arr.elem81, align 4
  %k82 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len83 = load i64, ptr %k82, align 8
  %arr.oob84 = icmp uge i64 5, %arr.len83
  br i1 %arr.oob84, label %idx.bad85, label %idx.ok86, !prof !10

idx.bad85:                                        ; preds = %idx.ok79
  call void @__polaron_fail(ptr @.fail.4219, ptr @.faila.4220, i64 5, ptr @.failb.4221, i64 %arr.len83, i32 70)
  unreachable

idx.ok86:                                         ; preds = %idx.ok79
  %arr.data87 = getelementptr i8, ptr %k82, i64 8
  %arr.elem88 = getelementptr inbounds i32, ptr %arr.data87, i64 5
  store i32 1508970993, ptr %arr.elem88, align 4
  %k89 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len90 = load i64, ptr %k89, align 8
  %arr.oob91 = icmp uge i64 6, %arr.len90
  br i1 %arr.oob91, label %idx.bad92, label %idx.ok93, !prof !10

idx.bad92:                                        ; preds = %idx.ok86
  call void @__polaron_fail(ptr @.fail.4222, ptr @.faila.4223, i64 6, ptr @.failb.4224, i64 %arr.len90, i32 70)
  unreachable

idx.ok93:                                         ; preds = %idx.ok86
  %arr.data94 = getelementptr i8, ptr %k89, i64 8
  %arr.elem95 = getelementptr inbounds i32, ptr %arr.data94, i64 6
  store i32 -1841331548, ptr %arr.elem95, align 4
  %k96 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len97 = load i64, ptr %k96, align 8
  %arr.oob98 = icmp uge i64 7, %arr.len97
  br i1 %arr.oob98, label %idx.bad99, label %idx.ok100, !prof !10

idx.bad99:                                        ; preds = %idx.ok93
  call void @__polaron_fail(ptr @.fail.4225, ptr @.faila.4226, i64 7, ptr @.failb.4227, i64 %arr.len97, i32 70)
  unreachable

idx.ok100:                                        ; preds = %idx.ok93
  %arr.data101 = getelementptr i8, ptr %k96, i64 8
  %arr.elem102 = getelementptr inbounds i32, ptr %arr.data101, i64 7
  store i32 -1424204075, ptr %arr.elem102, align 4
  %k103 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len104 = load i64, ptr %k103, align 8
  %arr.oob105 = icmp uge i64 8, %arr.len104
  br i1 %arr.oob105, label %idx.bad106, label %idx.ok107, !prof !10

idx.bad106:                                       ; preds = %idx.ok100
  call void @__polaron_fail(ptr @.fail.4228, ptr @.faila.4229, i64 8, ptr @.failb.4230, i64 %arr.len104, i32 70)
  unreachable

idx.ok107:                                        ; preds = %idx.ok100
  %arr.data108 = getelementptr i8, ptr %k103, i64 8
  %arr.elem109 = getelementptr inbounds i32, ptr %arr.data108, i64 8
  store i32 -670586216, ptr %arr.elem109, align 4
  %k110 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len111 = load i64, ptr %k110, align 8
  %arr.oob112 = icmp uge i64 9, %arr.len111
  br i1 %arr.oob112, label %idx.bad113, label %idx.ok114, !prof !10

idx.bad113:                                       ; preds = %idx.ok107
  call void @__polaron_fail(ptr @.fail.4231, ptr @.faila.4232, i64 9, ptr @.failb.4233, i64 %arr.len111, i32 70)
  unreachable

idx.ok114:                                        ; preds = %idx.ok107
  %arr.data115 = getelementptr i8, ptr %k110, i64 8
  %arr.elem116 = getelementptr inbounds i32, ptr %arr.data115, i64 9
  store i32 310598401, ptr %arr.elem116, align 4
  %k117 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len118 = load i64, ptr %k117, align 8
  %arr.oob119 = icmp uge i64 10, %arr.len118
  br i1 %arr.oob119, label %idx.bad120, label %idx.ok121, !prof !10

idx.bad120:                                       ; preds = %idx.ok114
  call void @__polaron_fail(ptr @.fail.4234, ptr @.faila.4235, i64 10, ptr @.failb.4236, i64 %arr.len118, i32 70)
  unreachable

idx.ok121:                                        ; preds = %idx.ok114
  %arr.data122 = getelementptr i8, ptr %k117, i64 8
  %arr.elem123 = getelementptr inbounds i32, ptr %arr.data122, i64 10
  store i32 607225278, ptr %arr.elem123, align 4
  %k124 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len125 = load i64, ptr %k124, align 8
  %arr.oob126 = icmp uge i64 11, %arr.len125
  br i1 %arr.oob126, label %idx.bad127, label %idx.ok128, !prof !10

idx.bad127:                                       ; preds = %idx.ok121
  call void @__polaron_fail(ptr @.fail.4237, ptr @.faila.4238, i64 11, ptr @.failb.4239, i64 %arr.len125, i32 70)
  unreachable

idx.ok128:                                        ; preds = %idx.ok121
  %arr.data129 = getelementptr i8, ptr %k124, i64 8
  %arr.elem130 = getelementptr inbounds i32, ptr %arr.data129, i64 11
  store i32 1426881987, ptr %arr.elem130, align 4
  %k131 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len132 = load i64, ptr %k131, align 8
  %arr.oob133 = icmp uge i64 12, %arr.len132
  br i1 %arr.oob133, label %idx.bad134, label %idx.ok135, !prof !10

idx.bad134:                                       ; preds = %idx.ok128
  call void @__polaron_fail(ptr @.fail.4240, ptr @.faila.4241, i64 12, ptr @.failb.4242, i64 %arr.len132, i32 70)
  unreachable

idx.ok135:                                        ; preds = %idx.ok128
  %arr.data136 = getelementptr i8, ptr %k131, i64 8
  %arr.elem137 = getelementptr inbounds i32, ptr %arr.data136, i64 12
  store i32 1925078388, ptr %arr.elem137, align 4
  %k138 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len139 = load i64, ptr %k138, align 8
  %arr.oob140 = icmp uge i64 13, %arr.len139
  br i1 %arr.oob140, label %idx.bad141, label %idx.ok142, !prof !10

idx.bad141:                                       ; preds = %idx.ok135
  call void @__polaron_fail(ptr @.fail.4243, ptr @.faila.4244, i64 13, ptr @.failb.4245, i64 %arr.len139, i32 70)
  unreachable

idx.ok142:                                        ; preds = %idx.ok135
  %arr.data143 = getelementptr i8, ptr %k138, i64 8
  %arr.elem144 = getelementptr inbounds i32, ptr %arr.data143, i64 13
  store i32 -2132889090, ptr %arr.elem144, align 4
  %k145 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len146 = load i64, ptr %k145, align 8
  %arr.oob147 = icmp uge i64 14, %arr.len146
  br i1 %arr.oob147, label %idx.bad148, label %idx.ok149, !prof !10

idx.bad148:                                       ; preds = %idx.ok142
  call void @__polaron_fail(ptr @.fail.4246, ptr @.faila.4247, i64 14, ptr @.failb.4248, i64 %arr.len146, i32 70)
  unreachable

idx.ok149:                                        ; preds = %idx.ok142
  %arr.data150 = getelementptr i8, ptr %k145, i64 8
  %arr.elem151 = getelementptr inbounds i32, ptr %arr.data150, i64 14
  store i32 -1680079193, ptr %arr.elem151, align 4
  %k152 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len153 = load i64, ptr %k152, align 8
  %arr.oob154 = icmp uge i64 15, %arr.len153
  br i1 %arr.oob154, label %idx.bad155, label %idx.ok156, !prof !10

idx.bad155:                                       ; preds = %idx.ok149
  call void @__polaron_fail(ptr @.fail.4249, ptr @.faila.4250, i64 15, ptr @.failb.4251, i64 %arr.len153, i32 70)
  unreachable

idx.ok156:                                        ; preds = %idx.ok149
  %arr.data157 = getelementptr i8, ptr %k152, i64 8
  %arr.elem158 = getelementptr inbounds i32, ptr %arr.data157, i64 15
  store i32 -1046744716, ptr %arr.elem158, align 4
  %k159 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len160 = load i64, ptr %k159, align 8
  %arr.oob161 = icmp uge i64 16, %arr.len160
  br i1 %arr.oob161, label %idx.bad162, label %idx.ok163, !prof !10

idx.bad162:                                       ; preds = %idx.ok156
  call void @__polaron_fail(ptr @.fail.4252, ptr @.faila.4253, i64 16, ptr @.failb.4254, i64 %arr.len160, i32 70)
  unreachable

idx.ok163:                                        ; preds = %idx.ok156
  %arr.data164 = getelementptr i8, ptr %k159, i64 8
  %arr.elem165 = getelementptr inbounds i32, ptr %arr.data164, i64 16
  store i32 -459576895, ptr %arr.elem165, align 4
  %k166 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len167 = load i64, ptr %k166, align 8
  %arr.oob168 = icmp uge i64 17, %arr.len167
  br i1 %arr.oob168, label %idx.bad169, label %idx.ok170, !prof !10

idx.bad169:                                       ; preds = %idx.ok163
  call void @__polaron_fail(ptr @.fail.4255, ptr @.faila.4256, i64 17, ptr @.failb.4257, i64 %arr.len167, i32 70)
  unreachable

idx.ok170:                                        ; preds = %idx.ok163
  %arr.data171 = getelementptr i8, ptr %k166, i64 8
  %arr.elem172 = getelementptr inbounds i32, ptr %arr.data171, i64 17
  store i32 -272742522, ptr %arr.elem172, align 4
  %k173 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len174 = load i64, ptr %k173, align 8
  %arr.oob175 = icmp uge i64 18, %arr.len174
  br i1 %arr.oob175, label %idx.bad176, label %idx.ok177, !prof !10

idx.bad176:                                       ; preds = %idx.ok170
  call void @__polaron_fail(ptr @.fail.4258, ptr @.faila.4259, i64 18, ptr @.failb.4260, i64 %arr.len174, i32 70)
  unreachable

idx.ok177:                                        ; preds = %idx.ok170
  %arr.data178 = getelementptr i8, ptr %k173, i64 8
  %arr.elem179 = getelementptr inbounds i32, ptr %arr.data178, i64 18
  store i32 264347078, ptr %arr.elem179, align 4
  %k180 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len181 = load i64, ptr %k180, align 8
  %arr.oob182 = icmp uge i64 19, %arr.len181
  br i1 %arr.oob182, label %idx.bad183, label %idx.ok184, !prof !10

idx.bad183:                                       ; preds = %idx.ok177
  call void @__polaron_fail(ptr @.fail.4261, ptr @.faila.4262, i64 19, ptr @.failb.4263, i64 %arr.len181, i32 70)
  unreachable

idx.ok184:                                        ; preds = %idx.ok177
  %arr.data185 = getelementptr i8, ptr %k180, i64 8
  %arr.elem186 = getelementptr inbounds i32, ptr %arr.data185, i64 19
  store i32 604807628, ptr %arr.elem186, align 4
  %k187 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len188 = load i64, ptr %k187, align 8
  %arr.oob189 = icmp uge i64 20, %arr.len188
  br i1 %arr.oob189, label %idx.bad190, label %idx.ok191, !prof !10

idx.bad190:                                       ; preds = %idx.ok184
  call void @__polaron_fail(ptr @.fail.4264, ptr @.faila.4265, i64 20, ptr @.failb.4266, i64 %arr.len188, i32 70)
  unreachable

idx.ok191:                                        ; preds = %idx.ok184
  %arr.data192 = getelementptr i8, ptr %k187, i64 8
  %arr.elem193 = getelementptr inbounds i32, ptr %arr.data192, i64 20
  store i32 770255983, ptr %arr.elem193, align 4
  %k194 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len195 = load i64, ptr %k194, align 8
  %arr.oob196 = icmp uge i64 21, %arr.len195
  br i1 %arr.oob196, label %idx.bad197, label %idx.ok198, !prof !10

idx.bad197:                                       ; preds = %idx.ok191
  call void @__polaron_fail(ptr @.fail.4267, ptr @.faila.4268, i64 21, ptr @.failb.4269, i64 %arr.len195, i32 70)
  unreachable

idx.ok198:                                        ; preds = %idx.ok191
  %arr.data199 = getelementptr i8, ptr %k194, i64 8
  %arr.elem200 = getelementptr inbounds i32, ptr %arr.data199, i64 21
  store i32 1249150122, ptr %arr.elem200, align 4
  %k201 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len202 = load i64, ptr %k201, align 8
  %arr.oob203 = icmp uge i64 22, %arr.len202
  br i1 %arr.oob203, label %idx.bad204, label %idx.ok205, !prof !10

idx.bad204:                                       ; preds = %idx.ok198
  call void @__polaron_fail(ptr @.fail.4270, ptr @.faila.4271, i64 22, ptr @.failb.4272, i64 %arr.len202, i32 70)
  unreachable

idx.ok205:                                        ; preds = %idx.ok198
  %arr.data206 = getelementptr i8, ptr %k201, i64 8
  %arr.elem207 = getelementptr inbounds i32, ptr %arr.data206, i64 22
  store i32 1555081692, ptr %arr.elem207, align 4
  %k208 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len209 = load i64, ptr %k208, align 8
  %arr.oob210 = icmp uge i64 23, %arr.len209
  br i1 %arr.oob210, label %idx.bad211, label %idx.ok212, !prof !10

idx.bad211:                                       ; preds = %idx.ok205
  call void @__polaron_fail(ptr @.fail.4273, ptr @.faila.4274, i64 23, ptr @.failb.4275, i64 %arr.len209, i32 70)
  unreachable

idx.ok212:                                        ; preds = %idx.ok205
  %arr.data213 = getelementptr i8, ptr %k208, i64 8
  %arr.elem214 = getelementptr inbounds i32, ptr %arr.data213, i64 23
  store i32 1996064986, ptr %arr.elem214, align 4
  %k215 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len216 = load i64, ptr %k215, align 8
  %arr.oob217 = icmp uge i64 24, %arr.len216
  br i1 %arr.oob217, label %idx.bad218, label %idx.ok219, !prof !10

idx.bad218:                                       ; preds = %idx.ok212
  call void @__polaron_fail(ptr @.fail.4276, ptr @.faila.4277, i64 24, ptr @.failb.4278, i64 %arr.len216, i32 70)
  unreachable

idx.ok219:                                        ; preds = %idx.ok212
  %arr.data220 = getelementptr i8, ptr %k215, i64 8
  %arr.elem221 = getelementptr inbounds i32, ptr %arr.data220, i64 24
  store i32 -1740746414, ptr %arr.elem221, align 4
  %k222 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len223 = load i64, ptr %k222, align 8
  %arr.oob224 = icmp uge i64 25, %arr.len223
  br i1 %arr.oob224, label %idx.bad225, label %idx.ok226, !prof !10

idx.bad225:                                       ; preds = %idx.ok219
  call void @__polaron_fail(ptr @.fail.4279, ptr @.faila.4280, i64 25, ptr @.failb.4281, i64 %arr.len223, i32 70)
  unreachable

idx.ok226:                                        ; preds = %idx.ok219
  %arr.data227 = getelementptr i8, ptr %k222, i64 8
  %arr.elem228 = getelementptr inbounds i32, ptr %arr.data227, i64 25
  store i32 -1473132947, ptr %arr.elem228, align 4
  %k229 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len230 = load i64, ptr %k229, align 8
  %arr.oob231 = icmp uge i64 26, %arr.len230
  br i1 %arr.oob231, label %idx.bad232, label %idx.ok233, !prof !10

idx.bad232:                                       ; preds = %idx.ok226
  call void @__polaron_fail(ptr @.fail.4282, ptr @.faila.4283, i64 26, ptr @.failb.4284, i64 %arr.len230, i32 70)
  unreachable

idx.ok233:                                        ; preds = %idx.ok226
  %arr.data234 = getelementptr i8, ptr %k229, i64 8
  %arr.elem235 = getelementptr inbounds i32, ptr %arr.data234, i64 26
  store i32 -1341970488, ptr %arr.elem235, align 4
  %k236 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len237 = load i64, ptr %k236, align 8
  %arr.oob238 = icmp uge i64 27, %arr.len237
  br i1 %arr.oob238, label %idx.bad239, label %idx.ok240, !prof !10

idx.bad239:                                       ; preds = %idx.ok233
  call void @__polaron_fail(ptr @.fail.4285, ptr @.faila.4286, i64 27, ptr @.failb.4287, i64 %arr.len237, i32 70)
  unreachable

idx.ok240:                                        ; preds = %idx.ok233
  %arr.data241 = getelementptr i8, ptr %k236, i64 8
  %arr.elem242 = getelementptr inbounds i32, ptr %arr.data241, i64 27
  store i32 -1084653625, ptr %arr.elem242, align 4
  %k243 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len244 = load i64, ptr %k243, align 8
  %arr.oob245 = icmp uge i64 28, %arr.len244
  br i1 %arr.oob245, label %idx.bad246, label %idx.ok247, !prof !10

idx.bad246:                                       ; preds = %idx.ok240
  call void @__polaron_fail(ptr @.fail.4288, ptr @.faila.4289, i64 28, ptr @.failb.4290, i64 %arr.len244, i32 70)
  unreachable

idx.ok247:                                        ; preds = %idx.ok240
  %arr.data248 = getelementptr i8, ptr %k243, i64 8
  %arr.elem249 = getelementptr inbounds i32, ptr %arr.data248, i64 28
  store i32 -958395405, ptr %arr.elem249, align 4
  %k250 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len251 = load i64, ptr %k250, align 8
  %arr.oob252 = icmp uge i64 29, %arr.len251
  br i1 %arr.oob252, label %idx.bad253, label %idx.ok254, !prof !10

idx.bad253:                                       ; preds = %idx.ok247
  call void @__polaron_fail(ptr @.fail.4291, ptr @.faila.4292, i64 29, ptr @.failb.4293, i64 %arr.len251, i32 70)
  unreachable

idx.ok254:                                        ; preds = %idx.ok247
  %arr.data255 = getelementptr i8, ptr %k250, i64 8
  %arr.elem256 = getelementptr inbounds i32, ptr %arr.data255, i64 29
  store i32 -710438585, ptr %arr.elem256, align 4
  %k257 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len258 = load i64, ptr %k257, align 8
  %arr.oob259 = icmp uge i64 30, %arr.len258
  br i1 %arr.oob259, label %idx.bad260, label %idx.ok261, !prof !10

idx.bad260:                                       ; preds = %idx.ok254
  call void @__polaron_fail(ptr @.fail.4294, ptr @.faila.4295, i64 30, ptr @.failb.4296, i64 %arr.len258, i32 70)
  unreachable

idx.ok261:                                        ; preds = %idx.ok254
  %arr.data262 = getelementptr i8, ptr %k257, i64 8
  %arr.elem263 = getelementptr inbounds i32, ptr %arr.data262, i64 30
  store i32 113926993, ptr %arr.elem263, align 4
  %k264 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len265 = load i64, ptr %k264, align 8
  %arr.oob266 = icmp uge i64 31, %arr.len265
  br i1 %arr.oob266, label %idx.bad267, label %idx.ok268, !prof !10

idx.bad267:                                       ; preds = %idx.ok261
  call void @__polaron_fail(ptr @.fail.4297, ptr @.faila.4298, i64 31, ptr @.failb.4299, i64 %arr.len265, i32 70)
  unreachable

idx.ok268:                                        ; preds = %idx.ok261
  %arr.data269 = getelementptr i8, ptr %k264, i64 8
  %arr.elem270 = getelementptr inbounds i32, ptr %arr.data269, i64 31
  store i32 338241895, ptr %arr.elem270, align 4
  %k271 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len272 = load i64, ptr %k271, align 8
  %arr.oob273 = icmp uge i64 32, %arr.len272
  br i1 %arr.oob273, label %idx.bad274, label %idx.ok275, !prof !10

idx.bad274:                                       ; preds = %idx.ok268
  call void @__polaron_fail(ptr @.fail.4300, ptr @.faila.4301, i64 32, ptr @.failb.4302, i64 %arr.len272, i32 70)
  unreachable

idx.ok275:                                        ; preds = %idx.ok268
  %arr.data276 = getelementptr i8, ptr %k271, i64 8
  %arr.elem277 = getelementptr inbounds i32, ptr %arr.data276, i64 32
  store i32 666307205, ptr %arr.elem277, align 4
  %k278 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len279 = load i64, ptr %k278, align 8
  %arr.oob280 = icmp uge i64 33, %arr.len279
  br i1 %arr.oob280, label %idx.bad281, label %idx.ok282, !prof !10

idx.bad281:                                       ; preds = %idx.ok275
  call void @__polaron_fail(ptr @.fail.4303, ptr @.faila.4304, i64 33, ptr @.failb.4305, i64 %arr.len279, i32 70)
  unreachable

idx.ok282:                                        ; preds = %idx.ok275
  %arr.data283 = getelementptr i8, ptr %k278, i64 8
  %arr.elem284 = getelementptr inbounds i32, ptr %arr.data283, i64 33
  store i32 773529912, ptr %arr.elem284, align 4
  %k285 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len286 = load i64, ptr %k285, align 8
  %arr.oob287 = icmp uge i64 34, %arr.len286
  br i1 %arr.oob287, label %idx.bad288, label %idx.ok289, !prof !10

idx.bad288:                                       ; preds = %idx.ok282
  call void @__polaron_fail(ptr @.fail.4306, ptr @.faila.4307, i64 34, ptr @.failb.4308, i64 %arr.len286, i32 70)
  unreachable

idx.ok289:                                        ; preds = %idx.ok282
  %arr.data290 = getelementptr i8, ptr %k285, i64 8
  %arr.elem291 = getelementptr inbounds i32, ptr %arr.data290, i64 34
  store i32 1294757372, ptr %arr.elem291, align 4
  %k292 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len293 = load i64, ptr %k292, align 8
  %arr.oob294 = icmp uge i64 35, %arr.len293
  br i1 %arr.oob294, label %idx.bad295, label %idx.ok296, !prof !10

idx.bad295:                                       ; preds = %idx.ok289
  call void @__polaron_fail(ptr @.fail.4309, ptr @.faila.4310, i64 35, ptr @.failb.4311, i64 %arr.len293, i32 70)
  unreachable

idx.ok296:                                        ; preds = %idx.ok289
  %arr.data297 = getelementptr i8, ptr %k292, i64 8
  %arr.elem298 = getelementptr inbounds i32, ptr %arr.data297, i64 35
  store i32 1396182291, ptr %arr.elem298, align 4
  %k299 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len300 = load i64, ptr %k299, align 8
  %arr.oob301 = icmp uge i64 36, %arr.len300
  br i1 %arr.oob301, label %idx.bad302, label %idx.ok303, !prof !10

idx.bad302:                                       ; preds = %idx.ok296
  call void @__polaron_fail(ptr @.fail.4312, ptr @.faila.4313, i64 36, ptr @.failb.4314, i64 %arr.len300, i32 70)
  unreachable

idx.ok303:                                        ; preds = %idx.ok296
  %arr.data304 = getelementptr i8, ptr %k299, i64 8
  %arr.elem305 = getelementptr inbounds i32, ptr %arr.data304, i64 36
  store i32 1695183700, ptr %arr.elem305, align 4
  %k306 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len307 = load i64, ptr %k306, align 8
  %arr.oob308 = icmp uge i64 37, %arr.len307
  br i1 %arr.oob308, label %idx.bad309, label %idx.ok310, !prof !10

idx.bad309:                                       ; preds = %idx.ok303
  call void @__polaron_fail(ptr @.fail.4315, ptr @.faila.4316, i64 37, ptr @.failb.4317, i64 %arr.len307, i32 70)
  unreachable

idx.ok310:                                        ; preds = %idx.ok303
  %arr.data311 = getelementptr i8, ptr %k306, i64 8
  %arr.elem312 = getelementptr inbounds i32, ptr %arr.data311, i64 37
  store i32 1986661051, ptr %arr.elem312, align 4
  %k313 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len314 = load i64, ptr %k313, align 8
  %arr.oob315 = icmp uge i64 38, %arr.len314
  br i1 %arr.oob315, label %idx.bad316, label %idx.ok317, !prof !10

idx.bad316:                                       ; preds = %idx.ok310
  call void @__polaron_fail(ptr @.fail.4318, ptr @.faila.4319, i64 38, ptr @.failb.4320, i64 %arr.len314, i32 70)
  unreachable

idx.ok317:                                        ; preds = %idx.ok310
  %arr.data318 = getelementptr i8, ptr %k313, i64 8
  %arr.elem319 = getelementptr inbounds i32, ptr %arr.data318, i64 38
  store i32 -2117940946, ptr %arr.elem319, align 4
  %k320 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len321 = load i64, ptr %k320, align 8
  %arr.oob322 = icmp uge i64 39, %arr.len321
  br i1 %arr.oob322, label %idx.bad323, label %idx.ok324, !prof !10

idx.bad323:                                       ; preds = %idx.ok317
  call void @__polaron_fail(ptr @.fail.4321, ptr @.faila.4322, i64 39, ptr @.failb.4323, i64 %arr.len321, i32 70)
  unreachable

idx.ok324:                                        ; preds = %idx.ok317
  %arr.data325 = getelementptr i8, ptr %k320, i64 8
  %arr.elem326 = getelementptr inbounds i32, ptr %arr.data325, i64 39
  store i32 -1838011259, ptr %arr.elem326, align 4
  %k327 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len328 = load i64, ptr %k327, align 8
  %arr.oob329 = icmp uge i64 40, %arr.len328
  br i1 %arr.oob329, label %idx.bad330, label %idx.ok331, !prof !10

idx.bad330:                                       ; preds = %idx.ok324
  call void @__polaron_fail(ptr @.fail.4324, ptr @.faila.4325, i64 40, ptr @.failb.4326, i64 %arr.len328, i32 70)
  unreachable

idx.ok331:                                        ; preds = %idx.ok324
  %arr.data332 = getelementptr i8, ptr %k327, i64 8
  %arr.elem333 = getelementptr inbounds i32, ptr %arr.data332, i64 40
  store i32 -1564481375, ptr %arr.elem333, align 4
  %k334 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len335 = load i64, ptr %k334, align 8
  %arr.oob336 = icmp uge i64 41, %arr.len335
  br i1 %arr.oob336, label %idx.bad337, label %idx.ok338, !prof !10

idx.bad337:                                       ; preds = %idx.ok331
  call void @__polaron_fail(ptr @.fail.4327, ptr @.faila.4328, i64 41, ptr @.failb.4329, i64 %arr.len335, i32 70)
  unreachable

idx.ok338:                                        ; preds = %idx.ok331
  %arr.data339 = getelementptr i8, ptr %k334, i64 8
  %arr.elem340 = getelementptr inbounds i32, ptr %arr.data339, i64 41
  store i32 -1474664885, ptr %arr.elem340, align 4
  %k341 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len342 = load i64, ptr %k341, align 8
  %arr.oob343 = icmp uge i64 42, %arr.len342
  br i1 %arr.oob343, label %idx.bad344, label %idx.ok345, !prof !10

idx.bad344:                                       ; preds = %idx.ok338
  call void @__polaron_fail(ptr @.fail.4330, ptr @.faila.4331, i64 42, ptr @.failb.4332, i64 %arr.len342, i32 70)
  unreachable

idx.ok345:                                        ; preds = %idx.ok338
  %arr.data346 = getelementptr i8, ptr %k341, i64 8
  %arr.elem347 = getelementptr inbounds i32, ptr %arr.data346, i64 42
  store i32 -1035236496, ptr %arr.elem347, align 4
  %k348 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len349 = load i64, ptr %k348, align 8
  %arr.oob350 = icmp uge i64 43, %arr.len349
  br i1 %arr.oob350, label %idx.bad351, label %idx.ok352, !prof !10

idx.bad351:                                       ; preds = %idx.ok345
  call void @__polaron_fail(ptr @.fail.4333, ptr @.faila.4334, i64 43, ptr @.failb.4335, i64 %arr.len349, i32 70)
  unreachable

idx.ok352:                                        ; preds = %idx.ok345
  %arr.data353 = getelementptr i8, ptr %k348, i64 8
  %arr.elem354 = getelementptr inbounds i32, ptr %arr.data353, i64 43
  store i32 -949202525, ptr %arr.elem354, align 4
  %k355 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len356 = load i64, ptr %k355, align 8
  %arr.oob357 = icmp uge i64 44, %arr.len356
  br i1 %arr.oob357, label %idx.bad358, label %idx.ok359, !prof !10

idx.bad358:                                       ; preds = %idx.ok352
  call void @__polaron_fail(ptr @.fail.4336, ptr @.faila.4337, i64 44, ptr @.failb.4338, i64 %arr.len356, i32 70)
  unreachable

idx.ok359:                                        ; preds = %idx.ok352
  %arr.data360 = getelementptr i8, ptr %k355, i64 8
  %arr.elem361 = getelementptr inbounds i32, ptr %arr.data360, i64 44
  store i32 -778901479, ptr %arr.elem361, align 4
  %k362 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len363 = load i64, ptr %k362, align 8
  %arr.oob364 = icmp uge i64 45, %arr.len363
  br i1 %arr.oob364, label %idx.bad365, label %idx.ok366, !prof !10

idx.bad365:                                       ; preds = %idx.ok359
  call void @__polaron_fail(ptr @.fail.4339, ptr @.faila.4340, i64 45, ptr @.failb.4341, i64 %arr.len363, i32 70)
  unreachable

idx.ok366:                                        ; preds = %idx.ok359
  %arr.data367 = getelementptr i8, ptr %k362, i64 8
  %arr.elem368 = getelementptr inbounds i32, ptr %arr.data367, i64 45
  store i32 -694614492, ptr %arr.elem368, align 4
  %k369 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len370 = load i64, ptr %k369, align 8
  %arr.oob371 = icmp uge i64 46, %arr.len370
  br i1 %arr.oob371, label %idx.bad372, label %idx.ok373, !prof !10

idx.bad372:                                       ; preds = %idx.ok366
  call void @__polaron_fail(ptr @.fail.4342, ptr @.faila.4343, i64 46, ptr @.failb.4344, i64 %arr.len370, i32 70)
  unreachable

idx.ok373:                                        ; preds = %idx.ok366
  %arr.data374 = getelementptr i8, ptr %k369, i64 8
  %arr.elem375 = getelementptr inbounds i32, ptr %arr.data374, i64 46
  store i32 -200395387, ptr %arr.elem375, align 4
  %k376 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len377 = load i64, ptr %k376, align 8
  %arr.oob378 = icmp uge i64 47, %arr.len377
  br i1 %arr.oob378, label %idx.bad379, label %idx.ok380, !prof !10

idx.bad379:                                       ; preds = %idx.ok373
  call void @__polaron_fail(ptr @.fail.4345, ptr @.faila.4346, i64 47, ptr @.failb.4347, i64 %arr.len377, i32 70)
  unreachable

idx.ok380:                                        ; preds = %idx.ok373
  %arr.data381 = getelementptr i8, ptr %k376, i64 8
  %arr.elem382 = getelementptr inbounds i32, ptr %arr.data381, i64 47
  store i32 275423344, ptr %arr.elem382, align 4
  %k383 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len384 = load i64, ptr %k383, align 8
  %arr.oob385 = icmp uge i64 48, %arr.len384
  br i1 %arr.oob385, label %idx.bad386, label %idx.ok387, !prof !10

idx.bad386:                                       ; preds = %idx.ok380
  call void @__polaron_fail(ptr @.fail.4348, ptr @.faila.4349, i64 48, ptr @.failb.4350, i64 %arr.len384, i32 70)
  unreachable

idx.ok387:                                        ; preds = %idx.ok380
  %arr.data388 = getelementptr i8, ptr %k383, i64 8
  %arr.elem389 = getelementptr inbounds i32, ptr %arr.data388, i64 48
  store i32 430227734, ptr %arr.elem389, align 4
  %k390 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len391 = load i64, ptr %k390, align 8
  %arr.oob392 = icmp uge i64 49, %arr.len391
  br i1 %arr.oob392, label %idx.bad393, label %idx.ok394, !prof !10

idx.bad393:                                       ; preds = %idx.ok387
  call void @__polaron_fail(ptr @.fail.4351, ptr @.faila.4352, i64 49, ptr @.failb.4353, i64 %arr.len391, i32 70)
  unreachable

idx.ok394:                                        ; preds = %idx.ok387
  %arr.data395 = getelementptr i8, ptr %k390, i64 8
  %arr.elem396 = getelementptr inbounds i32, ptr %arr.data395, i64 49
  store i32 506948616, ptr %arr.elem396, align 4
  %k397 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len398 = load i64, ptr %k397, align 8
  %arr.oob399 = icmp uge i64 50, %arr.len398
  br i1 %arr.oob399, label %idx.bad400, label %idx.ok401, !prof !10

idx.bad400:                                       ; preds = %idx.ok394
  call void @__polaron_fail(ptr @.fail.4354, ptr @.faila.4355, i64 50, ptr @.failb.4356, i64 %arr.len398, i32 70)
  unreachable

idx.ok401:                                        ; preds = %idx.ok394
  %arr.data402 = getelementptr i8, ptr %k397, i64 8
  %arr.elem403 = getelementptr inbounds i32, ptr %arr.data402, i64 50
  store i32 659060556, ptr %arr.elem403, align 4
  %k404 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len405 = load i64, ptr %k404, align 8
  %arr.oob406 = icmp uge i64 51, %arr.len405
  br i1 %arr.oob406, label %idx.bad407, label %idx.ok408, !prof !10

idx.bad407:                                       ; preds = %idx.ok401
  call void @__polaron_fail(ptr @.fail.4357, ptr @.faila.4358, i64 51, ptr @.failb.4359, i64 %arr.len405, i32 70)
  unreachable

idx.ok408:                                        ; preds = %idx.ok401
  %arr.data409 = getelementptr i8, ptr %k404, i64 8
  %arr.elem410 = getelementptr inbounds i32, ptr %arr.data409, i64 51
  store i32 883997877, ptr %arr.elem410, align 4
  %k411 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len412 = load i64, ptr %k411, align 8
  %arr.oob413 = icmp uge i64 52, %arr.len412
  br i1 %arr.oob413, label %idx.bad414, label %idx.ok415, !prof !10

idx.bad414:                                       ; preds = %idx.ok408
  call void @__polaron_fail(ptr @.fail.4360, ptr @.faila.4361, i64 52, ptr @.failb.4362, i64 %arr.len412, i32 70)
  unreachable

idx.ok415:                                        ; preds = %idx.ok408
  %arr.data416 = getelementptr i8, ptr %k411, i64 8
  %arr.elem417 = getelementptr inbounds i32, ptr %arr.data416, i64 52
  store i32 958139571, ptr %arr.elem417, align 4
  %k418 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len419 = load i64, ptr %k418, align 8
  %arr.oob420 = icmp uge i64 53, %arr.len419
  br i1 %arr.oob420, label %idx.bad421, label %idx.ok422, !prof !10

idx.bad421:                                       ; preds = %idx.ok415
  call void @__polaron_fail(ptr @.fail.4363, ptr @.faila.4364, i64 53, ptr @.failb.4365, i64 %arr.len419, i32 70)
  unreachable

idx.ok422:                                        ; preds = %idx.ok415
  %arr.data423 = getelementptr i8, ptr %k418, i64 8
  %arr.elem424 = getelementptr inbounds i32, ptr %arr.data423, i64 53
  store i32 1322822218, ptr %arr.elem424, align 4
  %k425 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len426 = load i64, ptr %k425, align 8
  %arr.oob427 = icmp uge i64 54, %arr.len426
  br i1 %arr.oob427, label %idx.bad428, label %idx.ok429, !prof !10

idx.bad428:                                       ; preds = %idx.ok422
  call void @__polaron_fail(ptr @.fail.4366, ptr @.faila.4367, i64 54, ptr @.failb.4368, i64 %arr.len426, i32 70)
  unreachable

idx.ok429:                                        ; preds = %idx.ok422
  %arr.data430 = getelementptr i8, ptr %k425, i64 8
  %arr.elem431 = getelementptr inbounds i32, ptr %arr.data430, i64 54
  store i32 1537002063, ptr %arr.elem431, align 4
  %k432 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len433 = load i64, ptr %k432, align 8
  %arr.oob434 = icmp uge i64 55, %arr.len433
  br i1 %arr.oob434, label %idx.bad435, label %idx.ok436, !prof !10

idx.bad435:                                       ; preds = %idx.ok429
  call void @__polaron_fail(ptr @.fail.4369, ptr @.faila.4370, i64 55, ptr @.failb.4371, i64 %arr.len433, i32 70)
  unreachable

idx.ok436:                                        ; preds = %idx.ok429
  %arr.data437 = getelementptr i8, ptr %k432, i64 8
  %arr.elem438 = getelementptr inbounds i32, ptr %arr.data437, i64 55
  store i32 1747873779, ptr %arr.elem438, align 4
  %k439 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len440 = load i64, ptr %k439, align 8
  %arr.oob441 = icmp uge i64 56, %arr.len440
  br i1 %arr.oob441, label %idx.bad442, label %idx.ok443, !prof !10

idx.bad442:                                       ; preds = %idx.ok436
  call void @__polaron_fail(ptr @.fail.4372, ptr @.faila.4373, i64 56, ptr @.failb.4374, i64 %arr.len440, i32 70)
  unreachable

idx.ok443:                                        ; preds = %idx.ok436
  %arr.data444 = getelementptr i8, ptr %k439, i64 8
  %arr.elem445 = getelementptr inbounds i32, ptr %arr.data444, i64 56
  store i32 1955562222, ptr %arr.elem445, align 4
  %k446 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len447 = load i64, ptr %k446, align 8
  %arr.oob448 = icmp uge i64 57, %arr.len447
  br i1 %arr.oob448, label %idx.bad449, label %idx.ok450, !prof !10

idx.bad449:                                       ; preds = %idx.ok443
  call void @__polaron_fail(ptr @.fail.4375, ptr @.faila.4376, i64 57, ptr @.failb.4377, i64 %arr.len447, i32 70)
  unreachable

idx.ok450:                                        ; preds = %idx.ok443
  %arr.data451 = getelementptr i8, ptr %k446, i64 8
  %arr.elem452 = getelementptr inbounds i32, ptr %arr.data451, i64 57
  store i32 2024104815, ptr %arr.elem452, align 4
  %k453 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len454 = load i64, ptr %k453, align 8
  %arr.oob455 = icmp uge i64 58, %arr.len454
  br i1 %arr.oob455, label %idx.bad456, label %idx.ok457, !prof !10

idx.bad456:                                       ; preds = %idx.ok450
  call void @__polaron_fail(ptr @.fail.4378, ptr @.faila.4379, i64 58, ptr @.failb.4380, i64 %arr.len454, i32 70)
  unreachable

idx.ok457:                                        ; preds = %idx.ok450
  %arr.data458 = getelementptr i8, ptr %k453, i64 8
  %arr.elem459 = getelementptr inbounds i32, ptr %arr.data458, i64 58
  store i32 -2067236844, ptr %arr.elem459, align 4
  %k460 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len461 = load i64, ptr %k460, align 8
  %arr.oob462 = icmp uge i64 59, %arr.len461
  br i1 %arr.oob462, label %idx.bad463, label %idx.ok464, !prof !10

idx.bad463:                                       ; preds = %idx.ok457
  call void @__polaron_fail(ptr @.fail.4381, ptr @.faila.4382, i64 59, ptr @.failb.4383, i64 %arr.len461, i32 70)
  unreachable

idx.ok464:                                        ; preds = %idx.ok457
  %arr.data465 = getelementptr i8, ptr %k460, i64 8
  %arr.elem466 = getelementptr inbounds i32, ptr %arr.data465, i64 59
  store i32 -1933114872, ptr %arr.elem466, align 4
  %k467 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len468 = load i64, ptr %k467, align 8
  %arr.oob469 = icmp uge i64 60, %arr.len468
  br i1 %arr.oob469, label %idx.bad470, label %idx.ok471, !prof !10

idx.bad470:                                       ; preds = %idx.ok464
  call void @__polaron_fail(ptr @.fail.4384, ptr @.faila.4385, i64 60, ptr @.failb.4386, i64 %arr.len468, i32 70)
  unreachable

idx.ok471:                                        ; preds = %idx.ok464
  %arr.data472 = getelementptr i8, ptr %k467, i64 8
  %arr.elem473 = getelementptr inbounds i32, ptr %arr.data472, i64 60
  store i32 -1866530822, ptr %arr.elem473, align 4
  %k474 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len475 = load i64, ptr %k474, align 8
  %arr.oob476 = icmp uge i64 61, %arr.len475
  br i1 %arr.oob476, label %idx.bad477, label %idx.ok478, !prof !10

idx.bad477:                                       ; preds = %idx.ok471
  call void @__polaron_fail(ptr @.fail.4387, ptr @.faila.4388, i64 61, ptr @.failb.4389, i64 %arr.len475, i32 70)
  unreachable

idx.ok478:                                        ; preds = %idx.ok471
  %arr.data479 = getelementptr i8, ptr %k474, i64 8
  %arr.elem480 = getelementptr inbounds i32, ptr %arr.data479, i64 61
  store i32 -1538233109, ptr %arr.elem480, align 4
  %k481 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len482 = load i64, ptr %k481, align 8
  %arr.oob483 = icmp uge i64 62, %arr.len482
  br i1 %arr.oob483, label %idx.bad484, label %idx.ok485, !prof !10

idx.bad484:                                       ; preds = %idx.ok478
  call void @__polaron_fail(ptr @.fail.4390, ptr @.faila.4391, i64 62, ptr @.failb.4392, i64 %arr.len482, i32 70)
  unreachable

idx.ok485:                                        ; preds = %idx.ok478
  %arr.data486 = getelementptr i8, ptr %k481, i64 8
  %arr.elem487 = getelementptr inbounds i32, ptr %arr.data486, i64 62
  store i32 -1090935817, ptr %arr.elem487, align 4
  %k488 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %arr.len489 = load i64, ptr %k488, align 8
  %arr.oob490 = icmp uge i64 63, %arr.len489
  br i1 %arr.oob490, label %idx.bad491, label %idx.ok492, !prof !10

idx.bad491:                                       ; preds = %idx.ok485
  call void @__polaron_fail(ptr @.fail.4393, ptr @.faila.4394, i64 63, ptr @.failb.4395, i64 %arr.len489, i32 70)
  unreachable

idx.ok492:                                        ; preds = %idx.ok485
  %arr.data493 = getelementptr i8, ptr %k488, i64 8
  %arr.elem494 = getelementptr inbounds i32, ptr %arr.data493, i64 63
  store i32 -965641998, ptr %arr.elem494, align 4
  store i32 1779033703, ptr %h0, align 4
  store i32 -1150833019, ptr %h1, align 4
  store i32 1013904242, ptr %h2, align 4
  store i32 -1521486534, ptr %h3, align 4
  store i32 1359893119, ptr %h4, align 4
  store i32 -1694144372, ptr %h5, align 4
  store i32 528734635, ptr %h6, align 4
  store i32 1541459225, ptr %h7, align 4
  %arr495 = call ptr @__polaron_malloc(i64 264)
  store i64 64, ptr %arr495, align 8
  %arr.data496 = getelementptr i8, ptr %arr495, i64 8
  %42 = call ptr @memset(ptr %arr.data496, i32 0, i64 256)
  store ptr %arr495, ptr %w, align 8
  store i32 0, ptr %blk, align 4
  br label %while.cond497

while.cond497:                                    ; preds = %for.end653, %idx.ok492
  %blk500 = load i32, ptr %blk, align 4
  %padded501 = load i32, ptr %padded, align 4
  %43 = icmp slt i32 %blk500, %padded501
  %44 = zext i1 %43 to i32
  br i1 %43, label %while.body498, label %while.end499

while.body498:                                    ; preds = %while.cond497
  store i32 0, ptr %t, align 4
  br label %for.cond502

while.end499:                                     ; preds = %while.cond497
  %arr721 = call ptr @__polaron_malloc(i64 136)
  store i64 32, ptr %arr721, align 8
  %arr.data722 = getelementptr i8, ptr %arr721, i64 8
  %45 = call ptr @memset(ptr %arr.data722, i32 0, i64 128)
  store ptr %arr721, ptr %out, align 8
  %out723 = load ptr, ptr %out, align 8
  %h0724 = load i32, ptr %h0, align 4
  call void @Sha256.putWord(ptr %out723, i32 0, i32 %h0724)
  %out725 = load ptr, ptr %out, align 8
  %h1726 = load i32, ptr %h1, align 4
  call void @Sha256.putWord(ptr %out725, i32 4, i32 %h1726)
  %out727 = load ptr, ptr %out, align 8
  %h2728 = load i32, ptr %h2, align 4
  call void @Sha256.putWord(ptr %out727, i32 8, i32 %h2728)
  %out729 = load ptr, ptr %out, align 8
  %h3730 = load i32, ptr %h3, align 4
  call void @Sha256.putWord(ptr %out729, i32 12, i32 %h3730)
  %out731 = load ptr, ptr %out, align 8
  %h4732 = load i32, ptr %h4, align 4
  call void @Sha256.putWord(ptr %out731, i32 16, i32 %h4732)
  %out733 = load ptr, ptr %out, align 8
  %h5734 = load i32, ptr %h5, align 4
  call void @Sha256.putWord(ptr %out733, i32 20, i32 %h5734)
  %out735 = load ptr, ptr %out, align 8
  %h6736 = load i32, ptr %h6, align 4
  call void @Sha256.putWord(ptr %out735, i32 24, i32 %h6736)
  %out737 = load ptr, ptr %out, align 8
  %h7738 = load i32, ptr %h7, align 4
  call void @Sha256.putWord(ptr %out737, i32 28, i32 %h7738)
  %out739 = load ptr, ptr %out, align 8
  ret ptr %out739

for.cond502:                                      ; preds = %for.update504, %while.body498
  %t506 = load i32, ptr %t, align 4
  %46 = icmp slt i32 %t506, 16
  %47 = zext i1 %46 to i32
  br i1 %46, label %for.body503, label %for.end505

for.body503:                                      ; preds = %for.cond502
  %blk507 = load i32, ptr %blk, align 4
  %t508 = load i32, ptr %t, align 4
  %48 = mul i32 %t508, 4
  %49 = add i32 %blk507, %48
  store i32 %49, ptr %b, align 4
  %w509 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t510 = load i32, ptr %t, align 4
  %50 = sext i32 %t510 to i64
  %arr.len511 = load i64, ptr %w509, align 8
  %arr.oob512 = icmp uge i64 %50, %arr.len511
  br i1 %arr.oob512, label %idx.bad513, label %idx.ok514, !prof !10

for.update504:                                    ; preds = %idx.ok549
  %51 = load i32, ptr %t, align 4
  %52 = add i32 %51, 1
  store i32 %52, ptr %t, align 4
  br label %for.cond502

for.end505:                                       ; preds = %for.cond502
  store i32 16, ptr %t553, align 4
  br label %for.cond554

idx.bad513:                                       ; preds = %for.body503
  call void @__polaron_fail(ptr @.fail.4396, ptr @.faila.4397, i64 %50, ptr @.failb.4398, i64 %arr.len511, i32 70)
  unreachable

idx.ok514:                                        ; preds = %for.body503
  %arr.data515 = getelementptr i8, ptr %w509, i64 8
  %arr.elem516 = getelementptr inbounds i32, ptr %arr.data515, i64 %50
  %m517 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %b518 = load i32, ptr %b, align 4
  %53 = sext i32 %b518 to i64
  %arr.len519 = load i64, ptr %m517, align 8
  %arr.oob520 = icmp uge i64 %53, %arr.len519
  br i1 %arr.oob520, label %idx.bad521, label %idx.ok522, !prof !10

idx.bad521:                                       ; preds = %idx.ok514
  call void @__polaron_fail(ptr @.fail.4399, ptr @.faila.4400, i64 %53, ptr @.failb.4401, i64 %arr.len519, i32 70)
  unreachable

idx.ok522:                                        ; preds = %idx.ok514
  %arr.data523 = getelementptr i8, ptr %m517, i64 8
  %arr.elem524 = getelementptr inbounds i32, ptr %arr.data523, i64 %53
  %elem525 = load i32, ptr %arr.elem524, align 4
  %54 = shl i32 %elem525, 24
  %m526 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %b527 = load i32, ptr %b, align 4
  %55 = add i32 %b527, 1
  %56 = sext i32 %55 to i64
  %arr.len528 = load i64, ptr %m526, align 8
  %arr.oob529 = icmp uge i64 %56, %arr.len528
  br i1 %arr.oob529, label %idx.bad530, label %idx.ok531, !prof !10

idx.bad530:                                       ; preds = %idx.ok522
  call void @__polaron_fail(ptr @.fail.4402, ptr @.faila.4403, i64 %56, ptr @.failb.4404, i64 %arr.len528, i32 70)
  unreachable

idx.ok531:                                        ; preds = %idx.ok522
  %arr.data532 = getelementptr i8, ptr %m526, i64 8
  %arr.elem533 = getelementptr inbounds i32, ptr %arr.data532, i64 %56
  %elem534 = load i32, ptr %arr.elem533, align 4
  %57 = shl i32 %elem534, 16
  %58 = or i32 %54, %57
  %m535 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %b536 = load i32, ptr %b, align 4
  %59 = add i32 %b536, 2
  %60 = sext i32 %59 to i64
  %arr.len537 = load i64, ptr %m535, align 8
  %arr.oob538 = icmp uge i64 %60, %arr.len537
  br i1 %arr.oob538, label %idx.bad539, label %idx.ok540, !prof !10

idx.bad539:                                       ; preds = %idx.ok531
  call void @__polaron_fail(ptr @.fail.4405, ptr @.faila.4406, i64 %60, ptr @.failb.4407, i64 %arr.len537, i32 70)
  unreachable

idx.ok540:                                        ; preds = %idx.ok531
  %arr.data541 = getelementptr i8, ptr %m535, i64 8
  %arr.elem542 = getelementptr inbounds i32, ptr %arr.data541, i64 %60
  %elem543 = load i32, ptr %arr.elem542, align 4
  %61 = shl i32 %elem543, 8
  %62 = or i32 %58, %61
  %m544 = load ptr, ptr %m, align 8, !nonnull !8, !dereferenceable !9
  %b545 = load i32, ptr %b, align 4
  %63 = add i32 %b545, 3
  %64 = sext i32 %63 to i64
  %arr.len546 = load i64, ptr %m544, align 8
  %arr.oob547 = icmp uge i64 %64, %arr.len546
  br i1 %arr.oob547, label %idx.bad548, label %idx.ok549, !prof !10

idx.bad548:                                       ; preds = %idx.ok540
  call void @__polaron_fail(ptr @.fail.4408, ptr @.faila.4409, i64 %64, ptr @.failb.4410, i64 %arr.len546, i32 70)
  unreachable

idx.ok549:                                        ; preds = %idx.ok540
  %arr.data550 = getelementptr i8, ptr %m544, i64 8
  %arr.elem551 = getelementptr inbounds i32, ptr %arr.data550, i64 %64
  %elem552 = load i32, ptr %arr.elem551, align 4
  %65 = or i32 %62, %elem552
  store i32 %65, ptr %arr.elem516, align 4
  br label %for.update504

for.cond554:                                      ; preds = %for.update556, %for.end505
  %t558 = load i32, ptr %t553, align 4
  %66 = icmp slt i32 %t558, 64
  %67 = zext i1 %66 to i32
  br i1 %66, label %for.body555, label %for.end557

for.body555:                                      ; preds = %for.cond554
  %w559 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t560 = load i32, ptr %t553, align 4
  %68 = sub i32 %t560, 15
  %69 = sext i32 %68 to i64
  %arr.len561 = load i64, ptr %w559, align 8
  %arr.oob562 = icmp uge i64 %69, %arr.len561
  br i1 %arr.oob562, label %idx.bad563, label %idx.ok564, !prof !10

for.update556:                                    ; preds = %idx.ok636
  %70 = load i32, ptr %t553, align 4
  %71 = add i32 %70, 1
  store i32 %71, ptr %t553, align 4
  br label %for.cond554

for.end557:                                       ; preds = %for.cond554
  %h0641 = load i32, ptr %h0, align 4
  store i32 %h0641, ptr %a, align 4
  %h1642 = load i32, ptr %h1, align 4
  store i32 %h1642, ptr %b2, align 4
  %h2643 = load i32, ptr %h2, align 4
  store i32 %h2643, ptr %c, align 4
  %h3644 = load i32, ptr %h3, align 4
  store i32 %h3644, ptr %d, align 4
  %h4645 = load i32, ptr %h4, align 4
  store i32 %h4645, ptr %e, align 4
  %h5646 = load i32, ptr %h5, align 4
  store i32 %h5646, ptr %f, align 4
  %h6647 = load i32, ptr %h6, align 4
  store i32 %h6647, ptr %g, align 4
  %h7648 = load i32, ptr %h7, align 4
  store i32 %h7648, ptr %hh, align 4
  store i32 0, ptr %t649, align 4
  br label %for.cond650

idx.bad563:                                       ; preds = %for.body555
  call void @__polaron_fail(ptr @.fail.4411, ptr @.faila.4412, i64 %69, ptr @.failb.4413, i64 %arr.len561, i32 70)
  unreachable

idx.ok564:                                        ; preds = %for.body555
  %arr.data565 = getelementptr i8, ptr %w559, i64 8
  %arr.elem566 = getelementptr inbounds i32, ptr %arr.data565, i64 %69
  %elem567 = load i32, ptr %arr.elem566, align 4
  %72 = call i32 @Sha256.rotr(i32 %elem567, i32 7)
  %w568 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t569 = load i32, ptr %t553, align 4
  %73 = sub i32 %t569, 15
  %74 = sext i32 %73 to i64
  %arr.len570 = load i64, ptr %w568, align 8
  %arr.oob571 = icmp uge i64 %74, %arr.len570
  br i1 %arr.oob571, label %idx.bad572, label %idx.ok573, !prof !10

idx.bad572:                                       ; preds = %idx.ok564
  call void @__polaron_fail(ptr @.fail.4414, ptr @.faila.4415, i64 %74, ptr @.failb.4416, i64 %arr.len570, i32 70)
  unreachable

idx.ok573:                                        ; preds = %idx.ok564
  %arr.data574 = getelementptr i8, ptr %w568, i64 8
  %arr.elem575 = getelementptr inbounds i32, ptr %arr.data574, i64 %74
  %elem576 = load i32, ptr %arr.elem575, align 4
  %75 = call i32 @Sha256.rotr(i32 %elem576, i32 18)
  %76 = xor i32 %72, %75
  %w577 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t578 = load i32, ptr %t553, align 4
  %77 = sub i32 %t578, 15
  %78 = sext i32 %77 to i64
  %arr.len579 = load i64, ptr %w577, align 8
  %arr.oob580 = icmp uge i64 %78, %arr.len579
  br i1 %arr.oob580, label %idx.bad581, label %idx.ok582, !prof !10

idx.bad581:                                       ; preds = %idx.ok573
  call void @__polaron_fail(ptr @.fail.4417, ptr @.faila.4418, i64 %78, ptr @.failb.4419, i64 %arr.len579, i32 70)
  unreachable

idx.ok582:                                        ; preds = %idx.ok573
  %arr.data583 = getelementptr i8, ptr %w577, i64 8
  %arr.elem584 = getelementptr inbounds i32, ptr %arr.data583, i64 %78
  %elem585 = load i32, ptr %arr.elem584, align 4
  %79 = lshr i32 %elem585, 3
  %80 = xor i32 %76, %79
  store i32 %80, ptr %s0, align 4
  %w586 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t587 = load i32, ptr %t553, align 4
  %81 = sub i32 %t587, 2
  %82 = sext i32 %81 to i64
  %arr.len588 = load i64, ptr %w586, align 8
  %arr.oob589 = icmp uge i64 %82, %arr.len588
  br i1 %arr.oob589, label %idx.bad590, label %idx.ok591, !prof !10

idx.bad590:                                       ; preds = %idx.ok582
  call void @__polaron_fail(ptr @.fail.4420, ptr @.faila.4421, i64 %82, ptr @.failb.4422, i64 %arr.len588, i32 70)
  unreachable

idx.ok591:                                        ; preds = %idx.ok582
  %arr.data592 = getelementptr i8, ptr %w586, i64 8
  %arr.elem593 = getelementptr inbounds i32, ptr %arr.data592, i64 %82
  %elem594 = load i32, ptr %arr.elem593, align 4
  %83 = call i32 @Sha256.rotr(i32 %elem594, i32 17)
  %w595 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t596 = load i32, ptr %t553, align 4
  %84 = sub i32 %t596, 2
  %85 = sext i32 %84 to i64
  %arr.len597 = load i64, ptr %w595, align 8
  %arr.oob598 = icmp uge i64 %85, %arr.len597
  br i1 %arr.oob598, label %idx.bad599, label %idx.ok600, !prof !10

idx.bad599:                                       ; preds = %idx.ok591
  call void @__polaron_fail(ptr @.fail.4423, ptr @.faila.4424, i64 %85, ptr @.failb.4425, i64 %arr.len597, i32 70)
  unreachable

idx.ok600:                                        ; preds = %idx.ok591
  %arr.data601 = getelementptr i8, ptr %w595, i64 8
  %arr.elem602 = getelementptr inbounds i32, ptr %arr.data601, i64 %85
  %elem603 = load i32, ptr %arr.elem602, align 4
  %86 = call i32 @Sha256.rotr(i32 %elem603, i32 19)
  %87 = xor i32 %83, %86
  %w604 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t605 = load i32, ptr %t553, align 4
  %88 = sub i32 %t605, 2
  %89 = sext i32 %88 to i64
  %arr.len606 = load i64, ptr %w604, align 8
  %arr.oob607 = icmp uge i64 %89, %arr.len606
  br i1 %arr.oob607, label %idx.bad608, label %idx.ok609, !prof !10

idx.bad608:                                       ; preds = %idx.ok600
  call void @__polaron_fail(ptr @.fail.4426, ptr @.faila.4427, i64 %89, ptr @.failb.4428, i64 %arr.len606, i32 70)
  unreachable

idx.ok609:                                        ; preds = %idx.ok600
  %arr.data610 = getelementptr i8, ptr %w604, i64 8
  %arr.elem611 = getelementptr inbounds i32, ptr %arr.data610, i64 %89
  %elem612 = load i32, ptr %arr.elem611, align 4
  %90 = lshr i32 %elem612, 10
  %91 = xor i32 %87, %90
  store i32 %91, ptr %s1, align 4
  %w613 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t614 = load i32, ptr %t553, align 4
  %92 = sext i32 %t614 to i64
  %arr.len615 = load i64, ptr %w613, align 8
  %arr.oob616 = icmp uge i64 %92, %arr.len615
  br i1 %arr.oob616, label %idx.bad617, label %idx.ok618, !prof !10

idx.bad617:                                       ; preds = %idx.ok609
  call void @__polaron_fail(ptr @.fail.4429, ptr @.faila.4430, i64 %92, ptr @.failb.4431, i64 %arr.len615, i32 70)
  unreachable

idx.ok618:                                        ; preds = %idx.ok609
  %arr.data619 = getelementptr i8, ptr %w613, i64 8
  %arr.elem620 = getelementptr inbounds i32, ptr %arr.data619, i64 %92
  %w621 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t622 = load i32, ptr %t553, align 4
  %93 = sub i32 %t622, 16
  %94 = sext i32 %93 to i64
  %arr.len623 = load i64, ptr %w621, align 8
  %arr.oob624 = icmp uge i64 %94, %arr.len623
  br i1 %arr.oob624, label %idx.bad625, label %idx.ok626, !prof !10

idx.bad625:                                       ; preds = %idx.ok618
  call void @__polaron_fail(ptr @.fail.4432, ptr @.faila.4433, i64 %94, ptr @.failb.4434, i64 %arr.len623, i32 70)
  unreachable

idx.ok626:                                        ; preds = %idx.ok618
  %arr.data627 = getelementptr i8, ptr %w621, i64 8
  %arr.elem628 = getelementptr inbounds i32, ptr %arr.data627, i64 %94
  %elem629 = load i32, ptr %arr.elem628, align 4
  %s0630 = load i32, ptr %s0, align 4
  %95 = add i32 %elem629, %s0630
  %w631 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t632 = load i32, ptr %t553, align 4
  %96 = sub i32 %t632, 7
  %97 = sext i32 %96 to i64
  %arr.len633 = load i64, ptr %w631, align 8
  %arr.oob634 = icmp uge i64 %97, %arr.len633
  br i1 %arr.oob634, label %idx.bad635, label %idx.ok636, !prof !10

idx.bad635:                                       ; preds = %idx.ok626
  call void @__polaron_fail(ptr @.fail.4435, ptr @.faila.4436, i64 %97, ptr @.failb.4437, i64 %arr.len633, i32 70)
  unreachable

idx.ok636:                                        ; preds = %idx.ok626
  %arr.data637 = getelementptr i8, ptr %w631, i64 8
  %arr.elem638 = getelementptr inbounds i32, ptr %arr.data637, i64 %97
  %elem639 = load i32, ptr %arr.elem638, align 4
  %98 = add i32 %95, %elem639
  %s1640 = load i32, ptr %s1, align 4
  %99 = add i32 %98, %s1640
  store i32 %99, ptr %arr.elem620, align 4
  br label %for.update556

for.cond650:                                      ; preds = %for.update652, %for.end557
  %t654 = load i32, ptr %t649, align 4
  %100 = icmp slt i32 %t654, 64
  %101 = zext i1 %100 to i32
  br i1 %100, label %for.body651, label %for.end653

for.body651:                                      ; preds = %for.cond650
  %e655 = load i32, ptr %e, align 4
  %102 = call i32 @Sha256.rotr(i32 %e655, i32 6)
  %e656 = load i32, ptr %e, align 4
  %103 = call i32 @Sha256.rotr(i32 %e656, i32 11)
  %104 = xor i32 %102, %103
  %e657 = load i32, ptr %e, align 4
  %105 = call i32 @Sha256.rotr(i32 %e657, i32 25)
  %106 = xor i32 %104, %105
  store i32 %106, ptr %bigS1, align 4
  %e658 = load i32, ptr %e, align 4
  %f659 = load i32, ptr %f, align 4
  %107 = and i32 %e658, %f659
  %e660 = load i32, ptr %e, align 4
  %108 = xor i32 %e660, -1
  %g661 = load i32, ptr %g, align 4
  %109 = and i32 %108, %g661
  %110 = xor i32 %107, %109
  store i32 %110, ptr %ch, align 4
  %hh662 = load i32, ptr %hh, align 4
  %bigS1663 = load i32, ptr %bigS1, align 4
  %111 = add i32 %hh662, %bigS1663
  %ch664 = load i32, ptr %ch, align 4
  %112 = add i32 %111, %ch664
  %k665 = load ptr, ptr %k, align 8, !nonnull !8, !dereferenceable !9
  %t666 = load i32, ptr %t649, align 4
  %113 = sext i32 %t666 to i64
  %arr.len667 = load i64, ptr %k665, align 8
  %arr.oob668 = icmp uge i64 %113, %arr.len667
  br i1 %arr.oob668, label %idx.bad669, label %idx.ok670, !prof !10

for.update652:                                    ; preds = %idx.ok679
  %114 = load i32, ptr %t649, align 4
  %115 = add i32 %114, 1
  store i32 %115, ptr %t649, align 4
  br label %for.cond650

for.end653:                                       ; preds = %for.cond650
  %h0704 = load i32, ptr %h0, align 4
  %a705 = load i32, ptr %a, align 4
  %116 = add i32 %h0704, %a705
  store i32 %116, ptr %h0, align 4
  %h1706 = load i32, ptr %h1, align 4
  %b2707 = load i32, ptr %b2, align 4
  %117 = add i32 %h1706, %b2707
  store i32 %117, ptr %h1, align 4
  %h2708 = load i32, ptr %h2, align 4
  %c709 = load i32, ptr %c, align 4
  %118 = add i32 %h2708, %c709
  store i32 %118, ptr %h2, align 4
  %h3710 = load i32, ptr %h3, align 4
  %d711 = load i32, ptr %d, align 4
  %119 = add i32 %h3710, %d711
  store i32 %119, ptr %h3, align 4
  %h4712 = load i32, ptr %h4, align 4
  %e713 = load i32, ptr %e, align 4
  %120 = add i32 %h4712, %e713
  store i32 %120, ptr %h4, align 4
  %h5714 = load i32, ptr %h5, align 4
  %f715 = load i32, ptr %f, align 4
  %121 = add i32 %h5714, %f715
  store i32 %121, ptr %h5, align 4
  %h6716 = load i32, ptr %h6, align 4
  %g717 = load i32, ptr %g, align 4
  %122 = add i32 %h6716, %g717
  store i32 %122, ptr %h6, align 4
  %h7718 = load i32, ptr %h7, align 4
  %hh719 = load i32, ptr %hh, align 4
  %123 = add i32 %h7718, %hh719
  store i32 %123, ptr %h7, align 4
  %blk720 = load i32, ptr %blk, align 4
  %124 = add i32 %blk720, 64
  store i32 %124, ptr %blk, align 4
  br label %while.cond497

idx.bad669:                                       ; preds = %for.body651
  call void @__polaron_fail(ptr @.fail.4438, ptr @.faila.4439, i64 %113, ptr @.failb.4440, i64 %arr.len667, i32 70)
  unreachable

idx.ok670:                                        ; preds = %for.body651
  %arr.data671 = getelementptr i8, ptr %k665, i64 8
  %arr.elem672 = getelementptr inbounds i32, ptr %arr.data671, i64 %113
  %elem673 = load i32, ptr %arr.elem672, align 4
  %125 = add i32 %112, %elem673
  %w674 = load ptr, ptr %w, align 8, !nonnull !8, !dereferenceable !9
  %t675 = load i32, ptr %t649, align 4
  %126 = sext i32 %t675 to i64
  %arr.len676 = load i64, ptr %w674, align 8
  %arr.oob677 = icmp uge i64 %126, %arr.len676
  br i1 %arr.oob677, label %idx.bad678, label %idx.ok679, !prof !10

idx.bad678:                                       ; preds = %idx.ok670
  call void @__polaron_fail(ptr @.fail.4441, ptr @.faila.4442, i64 %126, ptr @.failb.4443, i64 %arr.len676, i32 70)
  unreachable

idx.ok679:                                        ; preds = %idx.ok670
  %arr.data680 = getelementptr i8, ptr %w674, i64 8
  %arr.elem681 = getelementptr inbounds i32, ptr %arr.data680, i64 %126
  %elem682 = load i32, ptr %arr.elem681, align 4
  %127 = add i32 %125, %elem682
  store i32 %127, ptr %t1, align 4
  %a683 = load i32, ptr %a, align 4
  %128 = call i32 @Sha256.rotr(i32 %a683, i32 2)
  %a684 = load i32, ptr %a, align 4
  %129 = call i32 @Sha256.rotr(i32 %a684, i32 13)
  %130 = xor i32 %128, %129
  %a685 = load i32, ptr %a, align 4
  %131 = call i32 @Sha256.rotr(i32 %a685, i32 22)
  %132 = xor i32 %130, %131
  store i32 %132, ptr %bigS0, align 4
  %a686 = load i32, ptr %a, align 4
  %b2687 = load i32, ptr %b2, align 4
  %133 = and i32 %a686, %b2687
  %a688 = load i32, ptr %a, align 4
  %c689 = load i32, ptr %c, align 4
  %134 = and i32 %a688, %c689
  %135 = xor i32 %133, %134
  %b2690 = load i32, ptr %b2, align 4
  %c691 = load i32, ptr %c, align 4
  %136 = and i32 %b2690, %c691
  %137 = xor i32 %135, %136
  store i32 %137, ptr %maj, align 4
  %bigS0692 = load i32, ptr %bigS0, align 4
  %maj693 = load i32, ptr %maj, align 4
  %138 = add i32 %bigS0692, %maj693
  store i32 %138, ptr %t2, align 4
  %g694 = load i32, ptr %g, align 4
  store i32 %g694, ptr %hh, align 4
  %f695 = load i32, ptr %f, align 4
  store i32 %f695, ptr %g, align 4
  %e696 = load i32, ptr %e, align 4
  store i32 %e696, ptr %f, align 4
  %d697 = load i32, ptr %d, align 4
  %t1698 = load i32, ptr %t1, align 4
  %139 = add i32 %d697, %t1698
  store i32 %139, ptr %e, align 4
  %c699 = load i32, ptr %c, align 4
  store i32 %c699, ptr %d, align 4
  %b2700 = load i32, ptr %b2, align 4
  store i32 %b2700, ptr %c, align 4
  %a701 = load i32, ptr %a, align 4
  store i32 %a701, ptr %b2, align 4
  %t1702 = load i32, ptr %t1, align 4
  %t2703 = load i32, ptr %t2, align 4
  %140 = add i32 %t1702, %t2703
  store i32 %140, ptr %a, align 4
  br label %for.update652
}

define internal ptr @Sha256.digest(ptr %0) {
entry:
  %i = alloca i32, align 4
  %data = alloca ptr, align 8
  %len2 = alloca i32, align 4
  %msg = alloca ptr, align 8
  store ptr %0, ptr %msg, align 8
  %msg1 = load ptr, ptr %msg, align 8
  %str.len = getelementptr inbounds %String, ptr %msg1, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %1 = trunc i64 %len to i32
  store i32 %1, ptr %len2, align 4
  %len3 = load i32, ptr %len2, align 4
  %2 = add i32 %len3, 1
  %3 = sext i32 %2 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %data, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i4 = load i32, ptr %i, align 4
  %len5 = load i32, ptr %len2, align 4
  %7 = icmp slt i32 %i4, %len5
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data6 = load ptr, ptr %data, align 8, !nonnull !8, !dereferenceable !9
  %i7 = load i32, ptr %i, align 4
  %9 = sext i32 %i7 to i64
  %arr.len = load i64, ptr %data6, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !10

for.update:                                       ; preds = %idx.ok
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %data12 = load ptr, ptr %data, align 8
  %len13 = load i32, ptr %len2, align 4
  %12 = call ptr @Sha256.digestRaw(ptr %data12, i32 %len13)
  %13 = call ptr @Sha256.toHex(ptr %12, i32 32)
  %strcpy = call ptr @__polaron_str_copy(ptr %13)
  call void @__polaron_str_free(ptr %13)
  ret ptr %strcpy

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.4444, ptr @.faila.4445, i64 %9, ptr @.failb.4446, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data8 = getelementptr i8, ptr %data6, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data8, i64 %9
  %msg9 = load ptr, ptr %msg, align 8
  %i10 = load i32, ptr %i, align 4
  %14 = sext i32 %i10 to i64
  %str.data = getelementptr inbounds %String, ptr %msg9, i32 0, i32 1
  %data11 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data11, i64 %14
  %ch = load i8, ptr %ch.addr, align 1
  %15 = zext i8 %ch to i32
  %16 = and i32 %15, 255
  store i32 %16, ptr %arr.elem, align 4
  br label %for.update
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5311)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5313)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare void @__polaron_str_free(ptr)

declare ptr @memset(ptr, i32, i64)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare void @__polaron_free(ptr)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
!8 = !{}
!9 = !{i64 8}
!10 = !{!"branch_weights", i32 1, i32 1048576}
