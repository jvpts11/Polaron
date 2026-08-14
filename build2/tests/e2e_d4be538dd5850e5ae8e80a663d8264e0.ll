; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sql_codec.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sql_codec.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.ByteWriter = type { ptr, ptr }
%class.StringBuilder = type { ptr, i64, i32, i32 }
%class.ByteReader = type { ptr, ptr, i32 }
%class.Object = type { ptr }
%class.ArithmeticException = type { ptr }
%class.DivideByZeroException = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@ByteReader.vtable = private constant [354 x ptr] [ptr @ByteReader.u8, ptr @ByteReader.u16le, ptr @ByteReader.u32le, ptr @ByteReader.ucs2, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ByteWriter.vtable = private constant [354 x ptr] [ptr @ByteWriter.u8, ptr @ByteWriter.u16le, ptr @ByteWriter.u32le, ptr @ByteWriter.ucs2, ptr @ByteWriter.build, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"ByteWriter.~ByteWriter"]
@Object.vtable = private constant [354 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@ArithmeticException.vtable = private constant [354 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @ArithmeticException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@DivideByZeroException.vtable = private constant [354 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr @DivideByZeroException.message, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@StringBuilder.vtable = private constant [354 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.clear, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr @StringBuilder.length, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.ensure, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @StringBuilder.append, ptr @StringBuilder.appendChar, ptr @StringBuilder.appendInt, ptr @StringBuilder.toString, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @"StringBuilder.~StringBuilder"]
@.strdata = private constant [3 x i8] c"Hi\00"
@.strobj = private global %String { i64 2, ptr @.strdata, i64 0 }
@.strdata.1 = private constant [2 x i8] c" \00"
@.strobj.2 = private global %String { i64 1, ptr @.strdata.1, i64 0 }
@.strdata.3 = private constant [2 x i8] c" \00"
@.strobj.4 = private global %String { i64 1, ptr @.strdata.3, i64 0 }
@.strdata.5 = private constant [2 x i8] c" \00"
@.strobj.6 = private global %String { i64 1, ptr @.strdata.5, i64 0 }
@.str = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@"??_7type_info@@6B@" = external constant ptr
@"??_R0PEAX@8" = internal global { ptr, ptr, [6 x i8] } { ptr @"??_7type_info@@6B@", ptr null, [6 x i8] c".PEAX\00" }
@__ImageBase = external constant i8
@"_CT??_R0PEAX@88" = internal constant { i32, i32, i32, i32, i32, i32, i32 } { i32 1, i32 trunc (i64 sub (i64 ptrtoint (ptr @"??_R0PEAX@8" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32), i32 0, i32 -1, i32 0, i32 8, i32 0 }, section ".xdata"
@_CTA1PEAX = internal constant { i32, [1 x i32] } { i32 1, [1 x i32] [i32 trunc (i64 sub (i64 ptrtoint (ptr @"_CT??_R0PEAX@88" to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32)] }, section ".xdata"
@_TI1PEAX = internal constant { i32, i32, i32, i32 } { i32 0, i32 0, i32 0, i32 trunc (i64 sub (i64 ptrtoint (ptr @_CTA1PEAX to i64), i64 ptrtoint (ptr @__ImageBase to i64)) to i32) }, section ".xdata"
@.strdata.1312 = private constant [17 x i8] c"arithmetic error\00"
@.strobj.1313 = private global %String { i64 16, ptr @.strdata.1312, i64 0 }
@.strdata.1314 = private constant [17 x i8] c"division by zero\00"
@.strobj.1315 = private global %String { i64 16, ptr @.strdata.1314, i64 0 }
@.strdata.5313 = private constant [1 x i8] zeroinitializer
@.strobj.5314 = private global %String { i64 0, ptr @.strdata.5313, i64 0 }
@.strdata.5315 = private constant [1 x i8] zeroinitializer
@.strobj.5316 = private global %String { i64 0, ptr @.strdata.5315, i64 0 }

define internal void @ByteWriter.ByteWriter(ptr %0) {
entry:
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ByteWriter, ptr %0, i32 0, i32 0
  store ptr @ByteWriter.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %sb = getelementptr inbounds %class.ByteWriter, ptr %0, i32 0, i32 1
  store ptr null, ptr %sb, align 8, !tbaa !0
  %sb1 = getelementptr inbounds %class.ByteWriter, ptr %0, i32 0, i32 1
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb1, align 8, !tbaa !0
  ret void
}

define internal void @"ByteWriter.~ByteWriter"(ptr %0) {
entry:
  %sb = getelementptr inbounds %class.ByteWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !0
  call void @__polaron_check_live(ptr %sb1)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %sb1, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [354 x ptr], ptr %vtbl, i64 0, i64 353
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

define internal void @ByteWriter.u8(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %sb = getelementptr inbounds %class.ByteWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !0
  %v2 = load i32, ptr %v, align 4
  %2 = and i32 %v2, 255
  %3 = call ptr @StringBuilder.appendChar(ptr %sb1, i32 %2)
  ret void
}

define internal void @ByteWriter.u16le(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = and i32 %v1, 255
  call void @ByteWriter.u8(ptr %0, i32 %2)
  %v2 = load i32, ptr %v, align 4
  %3 = ashr i32 %v2, 31
  %4 = ashr i32 %v2, 8
  %5 = and i32 %4, 255
  call void @ByteWriter.u8(ptr %0, i32 %5)
  ret void
}

define internal void @ByteWriter.u32le(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %v = alloca i32, align 4
  store i32 %1, ptr %v, align 4
  %v1 = load i32, ptr %v, align 4
  %2 = and i32 %v1, 255
  call void @ByteWriter.u8(ptr %0, i32 %2)
  %v2 = load i32, ptr %v, align 4
  %3 = ashr i32 %v2, 31
  %4 = ashr i32 %v2, 8
  %5 = and i32 %4, 255
  call void @ByteWriter.u8(ptr %0, i32 %5)
  %v3 = load i32, ptr %v, align 4
  %6 = ashr i32 %v3, 31
  %7 = ashr i32 %v3, 16
  %8 = and i32 %7, 255
  call void @ByteWriter.u8(ptr %0, i32 %8)
  %v4 = load i32, ptr %v, align 4
  %9 = ashr i32 %v4, 31
  %10 = ashr i32 %v4, 24
  %11 = and i32 %10, 255
  call void @ByteWriter.u8(ptr %0, i32 %11)
  ret void
}

define internal void @ByteWriter.ucs2(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %i = alloca i32, align 4
  %s = alloca ptr, align 8
  store ptr %1, ptr %s, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %s2 = load ptr, ptr %s, align 8
  %str.len = getelementptr inbounds %String, ptr %s2, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %2 = trunc i64 %len to i32
  %3 = icmp slt i32 %i1, %2
  %4 = zext i1 %3 to i32
  br i1 %3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %s3 = load ptr, ptr %s, align 8
  %i4 = load i32, ptr %i, align 4
  %5 = sext i32 %i4 to i64
  %str.data = getelementptr inbounds %String, ptr %s3, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data, i64 %5
  %ch = load i8, ptr %ch.addr, align 1
  %6 = zext i8 %ch to i32
  %7 = and i32 %6, 255
  call void @ByteWriter.u16le(ptr %0, i32 %7)
  %i5 = load i32, ptr %i, align 4
  %8 = add i32 %i5, 1
  store i32 %8, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

define internal ptr @ByteWriter.build(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %sb = getelementptr inbounds %class.ByteWriter, ptr %0, i32 0, i32 1
  %sb1 = load ptr, ptr %sb, align 8, !tbaa !0
  %1 = call ptr @StringBuilder.toString(ptr %sb1)
  %strcpy = call ptr @__polaron_str_copy(ptr %1)
  call void @__polaron_str_free(ptr %1)
  ret ptr %strcpy
}

define internal void @ByteReader.ByteReader(ptr %0, ptr %1) {
entry:
  %d = alloca ptr, align 8
  store ptr %1, ptr %d, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 0
  store ptr @ByteReader.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %data = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !0
  %data1 = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 1
  %d2 = load ptr, ptr %d, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %d2)
  %2 = load ptr, ptr %data1, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %2)
  store ptr %strcpy, ptr %data1, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 2
  store i32 0, ptr %pos, align 4, !tbaa !4
  ret void
}

define internal i32 @ByteReader.u8(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %v = alloca i32, align 4
  %data = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !0
  %pos = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 2
  %pos2 = load i32, ptr %pos, align 4, !tbaa !4
  %1 = sext i32 %pos2 to i64
  %str.data = getelementptr inbounds %String, ptr %data1, i32 0, i32 1
  %data3 = load ptr, ptr %str.data, align 8
  %ch.addr = getelementptr i8, ptr %data3, i64 %1
  %ch = load i8, ptr %ch.addr, align 1
  %2 = zext i8 %ch to i32
  %3 = and i32 %2, 255
  store i32 %3, ptr %v, align 4
  %pos4 = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 2
  %pos5 = getelementptr inbounds %class.ByteReader, ptr %0, i32 0, i32 2
  %pos6 = load i32, ptr %pos5, align 4, !tbaa !4
  %4 = add i32 %pos6, 1
  store i32 %4, ptr %pos4, align 4, !tbaa !4
  %v7 = load i32, ptr %v, align 4
  ret i32 %v7
}

define internal i32 @ByteReader.u16le(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %hi = alloca i32, align 4
  %lo = alloca i32, align 4
  %1 = call i32 @ByteReader.u8(ptr %0)
  store i32 %1, ptr %lo, align 4
  %2 = call i32 @ByteReader.u8(ptr %0)
  store i32 %2, ptr %hi, align 4
  %lo1 = load i32, ptr %lo, align 4
  %hi2 = load i32, ptr %hi, align 4
  %3 = shl i32 %hi2, 8
  %4 = or i32 %lo1, %3
  ret i32 %4
}

define internal i32 @ByteReader.u32le(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %d = alloca i32, align 4
  %c = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %1 = call i32 @ByteReader.u8(ptr %0)
  store i32 %1, ptr %a, align 4
  %2 = call i32 @ByteReader.u8(ptr %0)
  store i32 %2, ptr %b, align 4
  %3 = call i32 @ByteReader.u8(ptr %0)
  store i32 %3, ptr %c, align 4
  %4 = call i32 @ByteReader.u8(ptr %0)
  store i32 %4, ptr %d, align 4
  %a1 = load i32, ptr %a, align 4
  %b2 = load i32, ptr %b, align 4
  %5 = shl i32 %b2, 8
  %6 = or i32 %a1, %5
  %c3 = load i32, ptr %c, align 4
  %7 = shl i32 %c3, 16
  %8 = or i32 %6, %7
  %d4 = load i32, ptr %d, align 4
  %9 = shl i32 %d4, 24
  %10 = or i32 %8, %9
  ret i32 %10
}

define internal ptr @ByteReader.ucs2(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %out = alloca ptr, align 8
  %lo = alloca i32, align 4
  %i = alloca i32, align 4
  %sb = alloca ptr, align 8
  %nbytes = alloca i32, align 4
  store i32 %1, ptr %nbytes, align 4
  %StringBuilder.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.StringBuilder, ptr null, i64 1) to i64))
  call void @StringBuilder.StringBuilder(ptr %StringBuilder.obj)
  store ptr %StringBuilder.obj, ptr %sb, align 8
  store i32 0, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %nbytes2 = load i32, ptr %nbytes, align 4
  %2 = icmp slt i32 %i1, %nbytes2
  %3 = zext i1 %2 to i32
  br i1 %2, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %4 = call i32 @ByteReader.u8(ptr %0)
  store i32 %4, ptr %lo, align 4
  %5 = call i32 @ByteReader.u8(ptr %0)
  %sb3 = load ptr, ptr %sb, align 8
  %lo4 = load i32, ptr %lo, align 4
  %6 = call ptr @StringBuilder.appendChar(ptr %sb3, i32 %lo4)
  %i5 = load i32, ptr %i, align 4
  %7 = add i32 %i5, 2
  store i32 %7, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sb6 = load ptr, ptr %sb, align 8
  %8 = call ptr @StringBuilder.toString(ptr %sb6)
  %strcpy = call ptr @__polaron_str_copy(ptr %8)
  store ptr %strcpy, ptr %out, align 8
  call void @__polaron_str_free(ptr %8)
  %sb7 = load ptr, ptr %sb, align 8
  call void @__polaron_check_live(ptr %sb7)
  %vtbl.addr = getelementptr inbounds %class.StringBuilder, ptr %sb7, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [354 x ptr], ptr %vtbl, i64 0, i64 353
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %9 = icmp ne ptr %dtor.fn, null
  br i1 %9, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %while.end
  call void %dtor.fn(ptr %sb7)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %while.end
  call void @__polaron_free(ptr %sb7)
  %out8 = load ptr, ptr %out, align 8
  %strcpy9 = call ptr @__polaron_str_copy(ptr %out8)
  %10 = load ptr, ptr %out, align 8
  call void @__polaron_str_free(ptr %10)
  ret ptr %strcpy9
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %s = alloca ptr, align 8
  %c = alloca i32, align 4
  %b = alloca i32, align 4
  %a = alloca i32, align 4
  %r = alloca ptr, align 8
  %bytes = alloca ptr, align 8
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
  %ByteWriter.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ByteWriter, ptr null, i64 1) to i64))
  call void @ByteWriter.ByteWriter(ptr %ByteWriter.obj)
  store ptr %ByteWriter.obj, ptr %w, align 8
  %w1 = load ptr, ptr %w, align 8
  call void @ByteWriter.u8(ptr %w1, i32 65)
  %w2 = load ptr, ptr %w, align 8
  call void @ByteWriter.u16le(ptr %w2, i32 4660)
  %w3 = load ptr, ptr %w, align 8
  call void @ByteWriter.u32le(ptr %w3, i32 168496141)
  %w4 = load ptr, ptr %w, align 8
  call void @ByteWriter.ucs2(ptr %w4, ptr @.strobj)
  %w5 = load ptr, ptr %w, align 8
  %16 = call ptr @ByteWriter.build(ptr %w5)
  %strcpy = call ptr @__polaron_str_copy(ptr %16)
  store ptr %strcpy, ptr %bytes, align 8
  call void @__polaron_str_free(ptr %16)
  %w6 = load ptr, ptr %w, align 8
  call void @__polaron_check_live(ptr %w6)
  %vtbl.addr = getelementptr inbounds %class.ByteWriter, ptr %w6, i32 0, i32 0
  %vtbl = load ptr, ptr %vtbl.addr, align 8, !tbaa !0
  %dtor.slot = getelementptr [354 x ptr], ptr %vtbl, i64 0, i64 353
  %dtor.fn = load ptr, ptr %dtor.slot, align 8
  %17 = icmp ne ptr %dtor.fn, null
  br i1 %17, label %dtor.call, label %dtor.free

dtor.call:                                        ; preds = %argv.end
  call void %dtor.fn(ptr %w6)
  br label %dtor.free

dtor.free:                                        ; preds = %dtor.call, %argv.end
  call void @__polaron_free(ptr %w6)
  %ByteReader.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.ByteReader, ptr null, i64 1) to i64))
  %bytes7 = load ptr, ptr %bytes, align 8
  call void @ByteReader.ByteReader(ptr %ByteReader.obj, ptr %bytes7)
  store ptr %ByteReader.obj, ptr %r, align 8
  %r8 = load ptr, ptr %r, align 8
  %18 = call i32 @ByteReader.u8(ptr %r8)
  store i32 %18, ptr %a, align 4
  %r9 = load ptr, ptr %r, align 8
  %19 = call i32 @ByteReader.u16le(ptr %r9)
  store i32 %19, ptr %b, align 4
  %r10 = load ptr, ptr %r, align 8
  %20 = call i32 @ByteReader.u32le(ptr %r10)
  store i32 %20, ptr %c, align 4
  %r11 = load ptr, ptr %r, align 8
  %21 = call ptr @ByteReader.ucs2(ptr %r11, i32 4)
  %strcpy12 = call ptr @__polaron_str_copy(ptr %21)
  store ptr %strcpy12, ptr %s, align 8
  call void @__polaron_str_free(ptr %21)
  %r13 = load ptr, ptr %r, align 8
  call void @__polaron_check_live(ptr %r13)
  %vtbl.addr14 = getelementptr inbounds %class.ByteReader, ptr %r13, i32 0, i32 0
  %vtbl15 = load ptr, ptr %vtbl.addr14, align 8, !tbaa !0
  %dtor.slot16 = getelementptr [354 x ptr], ptr %vtbl15, i64 0, i64 353
  %dtor.fn17 = load ptr, ptr %dtor.slot16, align 8
  %22 = icmp ne ptr %dtor.fn17, null
  br i1 %22, label %dtor.call18, label %dtor.free19

dtor.call18:                                      ; preds = %dtor.free
  call void %dtor.fn17(ptr %r13)
  br label %dtor.free19

dtor.free19:                                      ; preds = %dtor.call18, %dtor.free
  %data.sfree = getelementptr inbounds %class.ByteReader, ptr %r13, i32 0, i32 1
  %23 = load ptr, ptr %data.sfree, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %23)
  call void @__polaron_free(ptr %r13)
  %a20 = load i32, ptr %a, align 4
  %itoa.buf = call ptr @__polaron_malloc(i64 24)
  %24 = sext i32 %a20 to i64
  %25 = call i64 @__polaron_itoa(i64 %24, ptr %itoa.buf)
  %newstr21 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %26 = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 0
  store i64 %25, ptr %26, align 8
  %27 = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 1
  store ptr %itoa.buf, ptr %27, align 8
  %28 = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 2
  store i64 0, ptr %28, align 8
  %str.len = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 0
  %len = load i64, ptr %str.len, align 8
  %len22 = load i64, ptr @.strobj.2, align 8
  %29 = add i64 %len, %len22
  %30 = add i64 %29, 1
  %cat.buf = call ptr @__polaron_malloc(i64 %30)
  %str.data = getelementptr inbounds %String, ptr %newstr21, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %31 = call ptr @memcpy(ptr %cat.buf, ptr %data, i64 %len)
  %data23 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.2, i32 0, i32 1), align 8
  %32 = getelementptr i8, ptr %cat.buf, i64 %len
  %33 = call ptr @memcpy(ptr %32, ptr %data23, i64 %len22)
  %34 = getelementptr i8, ptr %cat.buf, i64 %29
  store i8 0, ptr %34, align 1
  %newstr24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %35 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  store i64 %29, ptr %35, align 8
  %36 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  store ptr %cat.buf, ptr %36, align 8
  %37 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 2
  store i64 0, ptr %37, align 8
  %b25 = load i32, ptr %b, align 4
  %itoa.buf26 = call ptr @__polaron_malloc(i64 24)
  %38 = sext i32 %b25 to i64
  %39 = call i64 @__polaron_itoa(i64 %38, ptr %itoa.buf26)
  %newstr27 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %40 = getelementptr inbounds %String, ptr %newstr27, i32 0, i32 0
  store i64 %39, ptr %40, align 8
  %41 = getelementptr inbounds %String, ptr %newstr27, i32 0, i32 1
  store ptr %itoa.buf26, ptr %41, align 8
  %42 = getelementptr inbounds %String, ptr %newstr27, i32 0, i32 2
  store i64 0, ptr %42, align 8
  %str.len28 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 0
  %len29 = load i64, ptr %str.len28, align 8
  %str.len30 = getelementptr inbounds %String, ptr %newstr27, i32 0, i32 0
  %len31 = load i64, ptr %str.len30, align 8
  %43 = add i64 %len29, %len31
  %44 = add i64 %43, 1
  %cat.buf32 = call ptr @__polaron_malloc(i64 %44)
  %str.data33 = getelementptr inbounds %String, ptr %newstr24, i32 0, i32 1
  %data34 = load ptr, ptr %str.data33, align 8
  %45 = call ptr @memcpy(ptr %cat.buf32, ptr %data34, i64 %len29)
  %str.data35 = getelementptr inbounds %String, ptr %newstr27, i32 0, i32 1
  %data36 = load ptr, ptr %str.data35, align 8
  %46 = getelementptr i8, ptr %cat.buf32, i64 %len29
  %47 = call ptr @memcpy(ptr %46, ptr %data36, i64 %len31)
  %48 = getelementptr i8, ptr %cat.buf32, i64 %43
  store i8 0, ptr %48, align 1
  %newstr37 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %49 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 0
  store i64 %43, ptr %49, align 8
  %50 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 1
  store ptr %cat.buf32, ptr %50, align 8
  %51 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 2
  store i64 0, ptr %51, align 8
  %str.len38 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 0
  %len39 = load i64, ptr %str.len38, align 8
  %len40 = load i64, ptr @.strobj.4, align 8
  %52 = add i64 %len39, %len40
  %53 = add i64 %52, 1
  %cat.buf41 = call ptr @__polaron_malloc(i64 %53)
  %str.data42 = getelementptr inbounds %String, ptr %newstr37, i32 0, i32 1
  %data43 = load ptr, ptr %str.data42, align 8
  %54 = call ptr @memcpy(ptr %cat.buf41, ptr %data43, i64 %len39)
  %data44 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.4, i32 0, i32 1), align 8
  %55 = getelementptr i8, ptr %cat.buf41, i64 %len39
  %56 = call ptr @memcpy(ptr %55, ptr %data44, i64 %len40)
  %57 = getelementptr i8, ptr %cat.buf41, i64 %52
  store i8 0, ptr %57, align 1
  %newstr45 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %58 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 0
  store i64 %52, ptr %58, align 8
  %59 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 1
  store ptr %cat.buf41, ptr %59, align 8
  %60 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 2
  store i64 0, ptr %60, align 8
  %c46 = load i32, ptr %c, align 4
  %itoa.buf47 = call ptr @__polaron_malloc(i64 24)
  %61 = sext i32 %c46 to i64
  %62 = call i64 @__polaron_itoa(i64 %61, ptr %itoa.buf47)
  %newstr48 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %63 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 0
  store i64 %62, ptr %63, align 8
  %64 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 1
  store ptr %itoa.buf47, ptr %64, align 8
  %65 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 2
  store i64 0, ptr %65, align 8
  %str.len49 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 0
  %len50 = load i64, ptr %str.len49, align 8
  %str.len51 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 0
  %len52 = load i64, ptr %str.len51, align 8
  %66 = add i64 %len50, %len52
  %67 = add i64 %66, 1
  %cat.buf53 = call ptr @__polaron_malloc(i64 %67)
  %str.data54 = getelementptr inbounds %String, ptr %newstr45, i32 0, i32 1
  %data55 = load ptr, ptr %str.data54, align 8
  %68 = call ptr @memcpy(ptr %cat.buf53, ptr %data55, i64 %len50)
  %str.data56 = getelementptr inbounds %String, ptr %newstr48, i32 0, i32 1
  %data57 = load ptr, ptr %str.data56, align 8
  %69 = getelementptr i8, ptr %cat.buf53, i64 %len50
  %70 = call ptr @memcpy(ptr %69, ptr %data57, i64 %len52)
  %71 = getelementptr i8, ptr %cat.buf53, i64 %66
  store i8 0, ptr %71, align 1
  %newstr58 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %72 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 0
  store i64 %66, ptr %72, align 8
  %73 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 1
  store ptr %cat.buf53, ptr %73, align 8
  %74 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 2
  store i64 0, ptr %74, align 8
  %str.len59 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 0
  %len60 = load i64, ptr %str.len59, align 8
  %len61 = load i64, ptr @.strobj.6, align 8
  %75 = add i64 %len60, %len61
  %76 = add i64 %75, 1
  %cat.buf62 = call ptr @__polaron_malloc(i64 %76)
  %str.data63 = getelementptr inbounds %String, ptr %newstr58, i32 0, i32 1
  %data64 = load ptr, ptr %str.data63, align 8
  %77 = call ptr @memcpy(ptr %cat.buf62, ptr %data64, i64 %len60)
  %data65 = load ptr, ptr getelementptr inbounds (%String, ptr @.strobj.6, i32 0, i32 1), align 8
  %78 = getelementptr i8, ptr %cat.buf62, i64 %len60
  %79 = call ptr @memcpy(ptr %78, ptr %data65, i64 %len61)
  %80 = getelementptr i8, ptr %cat.buf62, i64 %75
  store i8 0, ptr %80, align 1
  %newstr66 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %81 = getelementptr inbounds %String, ptr %newstr66, i32 0, i32 0
  store i64 %75, ptr %81, align 8
  %82 = getelementptr inbounds %String, ptr %newstr66, i32 0, i32 1
  store ptr %cat.buf62, ptr %82, align 8
  %83 = getelementptr inbounds %String, ptr %newstr66, i32 0, i32 2
  store i64 0, ptr %83, align 8
  %s67 = load ptr, ptr %s, align 8
  %str.len68 = getelementptr inbounds %String, ptr %newstr66, i32 0, i32 0
  %len69 = load i64, ptr %str.len68, align 8
  %str.len70 = getelementptr inbounds %String, ptr %s67, i32 0, i32 0
  %len71 = load i64, ptr %str.len70, align 8
  %84 = add i64 %len69, %len71
  %85 = add i64 %84, 1
  %cat.buf72 = call ptr @__polaron_malloc(i64 %85)
  %str.data73 = getelementptr inbounds %String, ptr %newstr66, i32 0, i32 1
  %data74 = load ptr, ptr %str.data73, align 8
  %86 = call ptr @memcpy(ptr %cat.buf72, ptr %data74, i64 %len69)
  %str.data75 = getelementptr inbounds %String, ptr %s67, i32 0, i32 1
  %data76 = load ptr, ptr %str.data75, align 8
  %87 = getelementptr i8, ptr %cat.buf72, i64 %len69
  %88 = call ptr @memcpy(ptr %87, ptr %data76, i64 %len71)
  %89 = getelementptr i8, ptr %cat.buf72, i64 %84
  store i8 0, ptr %89, align 1
  %newstr77 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%String, ptr null, i64 1) to i64))
  %90 = getelementptr inbounds %String, ptr %newstr77, i32 0, i32 0
  store i64 %84, ptr %90, align 8
  %91 = getelementptr inbounds %String, ptr %newstr77, i32 0, i32 1
  store ptr %cat.buf72, ptr %91, align 8
  %92 = getelementptr inbounds %String, ptr %newstr77, i32 0, i32 2
  store i64 0, ptr %92, align 8
  %str.data78 = getelementptr inbounds %String, ptr %newstr77, i32 0, i32 1
  %data79 = load ptr, ptr %str.data78, align 8
  %93 = call i32 (ptr, ...) @printf(ptr @.str, ptr %data79)
  call void @__polaron_str_free(ptr %newstr21)
  call void @__polaron_str_free(ptr %newstr24)
  call void @__polaron_str_free(ptr %newstr27)
  call void @__polaron_str_free(ptr %newstr37)
  call void @__polaron_str_free(ptr %newstr45)
  call void @__polaron_str_free(ptr %newstr48)
  call void @__polaron_str_free(ptr %newstr58)
  call void @__polaron_str_free(ptr %newstr66)
  call void @__polaron_str_free(ptr %newstr77)
  %94 = load ptr, ptr %s, align 8
  call void @__polaron_str_free(ptr %94)
  %95 = load ptr, ptr %bytes, align 8
  call void @__polaron_str_free(ptr %95)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1313)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.1315)
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5314)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5316)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare void @__polaron_check_live(ptr)

declare void @__polaron_free(ptr)

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare i64 @strlen(ptr)

declare i64 @__polaron_itoa(i64, ptr)

declare ptr @memcpy(ptr, ptr, i64)

declare i32 @printf(ptr, ...)

declare i32 @__CxxFrameHandler3(...)

declare void @_CxxThrowException(ptr, ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!7, !7, i64 0}
!7 = !{!"i64", !2, i64 0}
