; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_collections.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_collections.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%"class.ImmutableList$int" = type { ptr, ptr, i32 }
%"class.EnumMap$String" = type { ptr, ptr, ptr, i32 }
%class.EnumSet = type { ptr, ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@"ImmutableList$int.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"ImmutableList$int.size", ptr @"ImmutableList$int.isEmpty", ptr @"ImmutableList$int.get", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@"EnumMap$String.vtable" = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @"EnumMap$String.size", ptr null, ptr @"EnumMap$String.get", ptr null, ptr null, ptr @"EnumMap$String.put", ptr @"EnumMap$String.containsKey", ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@EnumSet.vtable = private constant [349 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr @EnumSet.size, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @EnumSet.remove, ptr null, ptr null, ptr @EnumSet.add, ptr null, ptr null, ptr null, ptr @EnumSet.contains, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [135 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_collections.pol:16:23  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1 = private unnamed_addr constant [135 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_collections.pol:16:34  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.4 = private unnamed_addr constant [135 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_collections.pol:16:45  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [18 x i8] c"il1=%d ilsize=%d\0A\00", align 1
@.strdata = private constant [4 x i8] c"red\00"
@.strobj = private global %String { i64 3, ptr @.strdata, i64 0 }
@.strdata.7 = private constant [5 x i8] c"blue\00"
@.strobj.8 = private global %String { i64 4, ptr @.strdata.7, i64 0 }
@.str.9 = private unnamed_addr constant [26 x i8] c"em0=%s has1=%d emsize=%d\0A\00", align 1
@.str.10 = private unnamed_addr constant [34 x i8] c"c1=%d c1after=%d c2=%d essize=%d\0A\00", align 1
@.fail.53 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2130:72  in ImmutableList$int.ImmutableList$int\0A\00", align 1
@.faila.54 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.55 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.56 = private unnamed_addr constant [106 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2130:72  in ImmutableList$int.ImmutableList$int\0A\00", align 1
@.faila.57 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.58 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.59 = private unnamed_addr constant [92 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2132:50  in ImmutableList$int.get\0A\00", align 1
@.faila.60 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.61 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.694 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2148:17  in EnumMap$String.put\0A\00", align 1
@.faila.695 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.696 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.697 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2148:90  in EnumMap$String.put\0A\00", align 1
@.faila.698 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.699 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.700 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2149:34  in EnumMap$String.put\0A\00", align 1
@.faila.701 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.702 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.703 = private unnamed_addr constant [89 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2152:52  in EnumMap$String.get\0A\00", align 1
@.faila.704 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.705 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.706 = private unnamed_addr constant [97 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2153:66  in EnumMap$String.containsKey\0A\00", align 1
@.faila.707 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.708 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1691 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2162:55  in EnumSet.add\0A\00", align 1
@.faila.1692 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1693 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1694 = private unnamed_addr constant [82 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2162:93  in EnumSet.add\0A\00", align 1
@.faila.1695 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1696 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1697 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2163:58  in EnumSet.remove\0A\00", align 1
@.faila.1698 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1699 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1700 = private unnamed_addr constant [85 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2163:95  in EnumSet.remove\0A\00", align 1
@.faila.1701 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1702 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.1703 = private unnamed_addr constant [87 x i8] c"Polaron panic: array index out of bounds\0A  --> <prelude>:2164:63  in EnumSet.contains\0A\00", align 1
@.faila.1704 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.1705 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.5344 = private constant [1 x i8] zeroinitializer
@.strobj.5345 = private global %String { i64 0, ptr @.strdata.5344, i64 0 }
@.strdata.5346 = private constant [1 x i8] zeroinitializer
@.strobj.5347 = private global %String { i64 0, ptr @.strdata.5346, i64 0 }

define i32 @main(i32 %0, ptr %1) {
entry:
  %c1 = alloca i32, align 4
  %es = alloca ptr, align 8
  %em = alloca ptr, align 8
  %il = alloca ptr, align 8
  %src = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 20)
  store i64 3, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 12)
  store ptr %arr, ptr %src, align 8
  %src2 = load ptr, ptr %src, align 8, !nonnull !0, !dereferenceable !1
  %arr.len = load i64, ptr %src2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %src2, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data3, i64 0
  store i32 10, ptr %arr.elem, align 4
  %src4 = load ptr, ptr %src, align 8, !nonnull !0, !dereferenceable !1
  %arr.len5 = load i64, ptr %src4, align 8
  %arr.oob6 = icmp uge i64 1, %arr.len5
  br i1 %arr.oob6, label %idx.bad7, label %idx.ok8, !prof !2

idx.bad7:                                         ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len5, i32 70)
  unreachable

idx.ok8:                                          ; preds = %idx.ok
  %arr.data9 = getelementptr i8, ptr %src4, i64 8
  %arr.elem10 = getelementptr inbounds i32, ptr %arr.data9, i64 1
  store i32 20, ptr %arr.elem10, align 4
  %src11 = load ptr, ptr %src, align 8, !nonnull !0, !dereferenceable !1
  %arr.len12 = load i64, ptr %src11, align 8
  %arr.oob13 = icmp uge i64 2, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok8
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok8
  %arr.data16 = getelementptr i8, ptr %src11, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 2
  store i32 30, ptr %arr.elem17, align 4
  %"ImmutableList$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.ImmutableList$int", ptr null, i64 1) to i64))
  %src18 = load ptr, ptr %src, align 8
  call void @"ImmutableList$int.ImmutableList$int"(ptr %"ImmutableList$int.obj", ptr %src18, i32 3)
  store ptr %"ImmutableList$int.obj", ptr %il, align 8
  %il19 = load ptr, ptr %il, align 8
  %17 = call i32 @"ImmutableList$int.get"(ptr %il19, i32 1)
  %il20 = load ptr, ptr %il, align 8
  %18 = call i32 @"ImmutableList$int.size"(ptr %il20)
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %17, i32 %18)
  %"EnumMap$String.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.EnumMap$String", ptr null, i64 1) to i64))
  call void @"EnumMap$String.EnumMap$String"(ptr %"EnumMap$String.obj", i32 3)
  store ptr %"EnumMap$String.obj", ptr %em, align 8
  %em21 = load ptr, ptr %em, align 8
  call void @"EnumMap$String.put"(ptr %em21, i32 0, ptr @.strobj)
  %em22 = load ptr, ptr %em, align 8
  call void @"EnumMap$String.put"(ptr %em22, i32 2, ptr @.strobj.8)
  %em23 = load ptr, ptr %em, align 8
  %20 = call ptr @"EnumMap$String.get"(ptr %em23, i32 0)
  %str.data = getelementptr inbounds %String, ptr %20, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %em24 = load ptr, ptr %em, align 8
  %21 = call i32 @"EnumMap$String.containsKey"(ptr %em24, i32 1)
  %em25 = load ptr, ptr %em, align 8
  %22 = call i32 @"EnumMap$String.size"(ptr %em25)
  %23 = call i32 (ptr, ...) @printf(ptr @.str.9, ptr %data, i32 %21, i32 %22)
  call void @__polaron_str_free(ptr %20)
  %EnumSet.obj = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.EnumSet, ptr null, i64 1) to i64))
  call void @EnumSet.EnumSet(ptr %EnumSet.obj, i32 5)
  store ptr %EnumSet.obj, ptr %es, align 8
  %es26 = load ptr, ptr %es, align 8
  call void @EnumSet.add(ptr %es26, i32 1)
  %es27 = load ptr, ptr %es, align 8
  call void @EnumSet.add(ptr %es27, i32 3)
  %es28 = load ptr, ptr %es, align 8
  call void @EnumSet.add(ptr %es28, i32 1)
  %es29 = load ptr, ptr %es, align 8
  %24 = call i32 @EnumSet.contains(ptr %es29, i32 1)
  store i32 %24, ptr %c1, align 4
  %es30 = load ptr, ptr %es, align 8
  call void @EnumSet.remove(ptr %es30, i32 1)
  %c131 = load i32, ptr %c1, align 4
  %es32 = load ptr, ptr %es, align 8
  %25 = call i32 @EnumSet.contains(ptr %es32, i32 1)
  %es33 = load ptr, ptr %es, align 8
  %26 = call i32 @EnumSet.contains(ptr %es33, i32 2)
  %es34 = load ptr, ptr %es, align 8
  %27 = call i32 @EnumSet.size(ptr %es34)
  %28 = call i32 (ptr, ...) @printf(ptr @.str.10, i32 %c131, i32 %25, i32 %26, i32 %27)
  ret i32 0
}

define internal void @"ImmutableList$int.ImmutableList$int"(ptr %0, ptr %1, i32 %2) {
entry:
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %src = alloca ptr, align 8
  store ptr %1, ptr %src, align 8
  store i32 %2, ptr %count, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 0
  store ptr @"ImmutableList$int.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %data = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 1
  store ptr null, ptr %data, align 8, !tbaa !3
  %n = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4
  store i32 %count1, ptr %n, align 4, !tbaa !7
  %data2 = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 1
  %count3 = load i32, ptr %count, align 4
  %3 = sext i32 %count3 to i64
  %4 = mul i64 %3, 4
  %5 = add i64 8, %4
  %arr = call ptr @__polaron_malloc(i64 %5)
  store i64 %3, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %6 = call ptr @memset(ptr %arr.data, i32 0, i64 %4)
  store ptr %arr, ptr %data2, align 8, !tbaa !3
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.update, %entry
  %i4 = load i32, ptr %i, align 4
  %count5 = load i32, ptr %count, align 4
  %7 = icmp slt i32 %i4, %count5
  %8 = zext i1 %7 to i32
  br i1 %7, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %data6 = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 1
  %data7 = load ptr, ptr %data6, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i8 = load i32, ptr %i, align 4
  %9 = sext i32 %i8 to i64
  %arr.len = load i64, ptr %data7, align 8
  %arr.oob = icmp uge i64 %9, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

for.update:                                       ; preds = %idx.ok15
  %10 = load i32, ptr %i, align 4
  %11 = add i32 %10, 1
  store i32 %11, ptr %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void

idx.bad:                                          ; preds = %for.body
  call void @__polaron_fail(ptr @.fail.53, ptr @.faila.54, i64 %9, ptr @.failb.55, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %for.body
  %arr.data9 = getelementptr i8, ptr %data7, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data9, i64 %9
  %src10 = load ptr, ptr %src, align 8, !nonnull !0, !dereferenceable !1
  %i11 = load i32, ptr %i, align 4
  %12 = sext i32 %i11 to i64
  %arr.len12 = load i64, ptr %src10, align 8
  %arr.oob13 = icmp uge i64 %12, %arr.len12
  br i1 %arr.oob13, label %idx.bad14, label %idx.ok15, !prof !2

idx.bad14:                                        ; preds = %idx.ok
  call void @__polaron_fail(ptr @.fail.56, ptr @.faila.57, i64 %12, ptr @.failb.58, i64 %arr.len12, i32 70)
  unreachable

idx.ok15:                                         ; preds = %idx.ok
  %arr.data16 = getelementptr i8, ptr %src10, i64 8
  %arr.elem17 = getelementptr inbounds i32, ptr %arr.data16, i64 %12
  %elem = load i32, ptr %arr.elem17, align 4
  store i32 %elem, ptr %arr.elem, align 4
  br label %for.update
}

define internal i32 @"ImmutableList$int.get"(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %i = alloca i32, align 4
  store i32 %1, ptr %i, align 4
  %data = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 1
  %data1 = load ptr, ptr %data, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %i2 = load i32, ptr %i, align 4
  %2 = sext i32 %i2 to i64
  %arr.len = load i64, ptr %data1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.59, ptr @.faila.60, i64 %2, ptr @.failb.61, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %data1, i64 8
  %arr.elem = getelementptr inbounds i32, ptr %arr.data, i64 %2
  %elem = load i32, ptr %arr.elem, align 4
  ret i32 %elem
}

define internal i32 @"ImmutableList$int.size"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %n = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  ret i32 %n1
}

define internal i32 @"ImmutableList$int.isEmpty"(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %n = getelementptr inbounds %"class.ImmutableList$int", ptr %0, i32 0, i32 2
  %n1 = load i32, ptr %n, align 4, !tbaa !7
  %1 = icmp eq i32 %n1, 0
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define internal void @"EnumMap$String.EnumMap$String"(ptr %0, i32 %1) {
entry:
  %size = alloca i32, align 4
  store i32 %1, ptr %size, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 0
  store ptr @"EnumMap$String.vtable", ptr %vtbl.addr, align 8, !tbaa !3
  %values = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 1
  store ptr null, ptr %values, align 8, !tbaa !3
  %present = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 2
  store ptr null, ptr %present, align 8, !tbaa !3
  %values1 = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 1
  %size2 = load i32, ptr %size, align 4
  %2 = sext i32 %size2 to i64
  %3 = mul i64 %2, 8
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %values1, align 8, !tbaa !3
  %present3 = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 2
  %size4 = load i32, ptr %size, align 4
  %6 = sext i32 %size4 to i64
  %7 = mul i64 %6, 1
  %8 = add i64 8, %7
  %arr5 = call ptr @__polaron_malloc(i64 %8)
  store i64 %6, ptr %arr5, align 8
  %arr.data6 = getelementptr i8, ptr %arr5, i64 8
  %9 = call ptr @memset(ptr %arr.data6, i32 0, i64 %7)
  store ptr %arr5, ptr %present3, align 8, !tbaa !3
  %count = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 3
  store i32 0, ptr %count, align 4, !tbaa !7
  ret void
}

define internal void @"EnumMap$String.put"(ptr nonnull align 8 dereferenceable(32) %0, i32 %1, ptr %2) {
entry:
  %v = alloca ptr, align 8
  %ord = alloca i32, align 4
  store i32 %1, ptr %ord, align 4
  store ptr %2, ptr %v, align 8
  %present = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 2
  %present1 = load ptr, ptr %present, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord2 = load i32, ptr %ord, align 4
  %3 = sext i32 %ord2 to i64
  %arr.len = load i64, ptr %present1, align 8
  %arr.oob = icmp uge i64 %3, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.694, ptr @.faila.695, i64 %3, ptr @.failb.696, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %present1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %3
  %elem = load i8, ptr %arr.elem, align 1
  %4 = zext i8 %elem to i32
  %5 = icmp eq i32 %4, 0
  %6 = zext i1 %5 to i32
  br i1 %5, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %count = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 3
  %count3 = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 3
  %count4 = load i32, ptr %count3, align 4, !tbaa !7
  %7 = add i32 %count4, 1
  store i32 %7, ptr %count, align 4, !tbaa !7
  %present5 = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 2
  %present6 = load ptr, ptr %present5, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord7 = load i32, ptr %ord, align 4
  %8 = sext i32 %ord7 to i64
  %arr.len8 = load i64, ptr %present6, align 8
  %arr.oob9 = icmp uge i64 %8, %arr.len8
  br i1 %arr.oob9, label %idx.bad10, label %idx.ok11, !prof !2

if.end:                                           ; preds = %idx.ok11, %idx.ok
  %values = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 1
  %values14 = load ptr, ptr %values, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord15 = load i32, ptr %ord, align 4
  %9 = sext i32 %ord15 to i64
  %arr.len16 = load i64, ptr %values14, align 8
  %arr.oob17 = icmp uge i64 %9, %arr.len16
  br i1 %arr.oob17, label %idx.bad18, label %idx.ok19, !prof !2

idx.bad10:                                        ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.697, ptr @.faila.698, i64 %8, ptr @.failb.699, i64 %arr.len8, i32 70)
  unreachable

idx.ok11:                                         ; preds = %if.then
  %arr.data12 = getelementptr i8, ptr %present6, i64 8
  %arr.elem13 = getelementptr inbounds i8, ptr %arr.data12, i64 %8
  store i8 1, ptr %arr.elem13, align 1
  br label %if.end

idx.bad18:                                        ; preds = %if.end
  call void @__polaron_fail(ptr @.fail.700, ptr @.faila.701, i64 %9, ptr @.failb.702, i64 %arr.len16, i32 70)
  unreachable

idx.ok19:                                         ; preds = %if.end
  %arr.data20 = getelementptr i8, ptr %values14, i64 8
  %arr.elem21 = getelementptr inbounds ptr, ptr %arr.data20, i64 %9
  %v22 = load ptr, ptr %v, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %v22)
  %10 = load ptr, ptr %arr.elem21, align 8
  call void @__polaron_str_free(ptr %10)
  store ptr %strcpy, ptr %arr.elem21, align 8
  ret void
}

define internal ptr @"EnumMap$String.get"(ptr nonnull align 8 dereferenceable(32) %0, i32 %1) {
entry:
  %ord = alloca i32, align 4
  store i32 %1, ptr %ord, align 4
  %values = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 1
  %values1 = load ptr, ptr %values, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord2 = load i32, ptr %ord, align 4
  %2 = sext i32 %ord2 to i64
  %arr.len = load i64, ptr %values1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.703, ptr @.faila.704, i64 %2, ptr @.failb.705, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %values1, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data, i64 %2
  %elem = load ptr, ptr %arr.elem, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %elem)
  ret ptr %strcpy
}

define internal i32 @"EnumMap$String.containsKey"(ptr nonnull align 8 dereferenceable(32) %0, i32 %1) {
entry:
  %ord = alloca i32, align 4
  store i32 %1, ptr %ord, align 4
  %present = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 2
  %present1 = load ptr, ptr %present, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord2 = load i32, ptr %ord, align 4
  %2 = sext i32 %ord2 to i64
  %arr.len = load i64, ptr %present1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.706, ptr @.faila.707, i64 %2, ptr @.failb.708, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %present1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %2
  %elem = load i8, ptr %arr.elem, align 1
  %3 = zext i8 %elem to i32
  ret i32 %3
}

define internal i32 @"EnumMap$String.size"(ptr nonnull align 8 dereferenceable(32) %0) {
entry:
  %count = getelementptr inbounds %"class.EnumMap$String", ptr %0, i32 0, i32 3
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  ret i32 %count1
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

define internal void @EnumSet.EnumSet(ptr %0, i32 %1) {
entry:
  %size = alloca i32, align 4
  store i32 %1, ptr %size, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 0
  store ptr @EnumSet.vtable, ptr %vtbl.addr, align 8, !tbaa !3
  %bits = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  store ptr null, ptr %bits, align 8, !tbaa !3
  %bits1 = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  %size2 = load i32, ptr %size, align 4
  %2 = sext i32 %size2 to i64
  %3 = mul i64 %2, 1
  %4 = add i64 8, %3
  %arr = call ptr @__polaron_malloc(i64 %4)
  store i64 %2, ptr %arr, align 8
  %arr.data = getelementptr i8, ptr %arr, i64 8
  %5 = call ptr @memset(ptr %arr.data, i32 0, i64 %3)
  store ptr %arr, ptr %bits1, align 8, !tbaa !3
  %count = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 2
  store i32 0, ptr %count, align 4, !tbaa !7
  ret void
}

define internal void @EnumSet.add(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ord = alloca i32, align 4
  store i32 %1, ptr %ord, align 4
  %bits = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  %bits1 = load ptr, ptr %bits, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord2 = load i32, ptr %ord, align 4
  %2 = sext i32 %ord2 to i64
  %arr.len = load i64, ptr %bits1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1691, ptr @.faila.1692, i64 %2, ptr @.failb.1693, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %bits1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %2
  %elem = load i8, ptr %arr.elem, align 1
  %3 = zext i8 %elem to i32
  %4 = icmp eq i32 %3, 0
  %5 = zext i1 %4 to i32
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %bits3 = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  %bits4 = load ptr, ptr %bits3, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord5 = load i32, ptr %ord, align 4
  %6 = sext i32 %ord5 to i64
  %arr.len6 = load i64, ptr %bits4, align 8
  %arr.oob7 = icmp uge i64 %6, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

if.end:                                           ; preds = %idx.ok9, %idx.ok
  ret void

idx.bad8:                                         ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1694, ptr @.faila.1695, i64 %6, ptr @.failb.1696, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %if.then
  %arr.data10 = getelementptr i8, ptr %bits4, i64 8
  %arr.elem11 = getelementptr inbounds i8, ptr %arr.data10, i64 %6
  store i8 1, ptr %arr.elem11, align 1
  %count = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 2
  %count12 = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 2
  %count13 = load i32, ptr %count12, align 4, !tbaa !7
  %7 = add i32 %count13, 1
  store i32 %7, ptr %count, align 4, !tbaa !7
  br label %if.end
}

define internal void @EnumSet.remove(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ord = alloca i32, align 4
  store i32 %1, ptr %ord, align 4
  %bits = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  %bits1 = load ptr, ptr %bits, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord2 = load i32, ptr %ord, align 4
  %2 = sext i32 %ord2 to i64
  %arr.len = load i64, ptr %bits1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1697, ptr @.faila.1698, i64 %2, ptr @.failb.1699, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %bits1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %2
  %elem = load i8, ptr %arr.elem, align 1
  %3 = zext i8 %elem to i32
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %if.then, label %if.end

if.then:                                          ; preds = %idx.ok
  %bits3 = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  %bits4 = load ptr, ptr %bits3, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord5 = load i32, ptr %ord, align 4
  %5 = sext i32 %ord5 to i64
  %arr.len6 = load i64, ptr %bits4, align 8
  %arr.oob7 = icmp uge i64 %5, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !2

if.end:                                           ; preds = %idx.ok9, %idx.ok
  ret void

idx.bad8:                                         ; preds = %if.then
  call void @__polaron_fail(ptr @.fail.1700, ptr @.faila.1701, i64 %5, ptr @.failb.1702, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %if.then
  %arr.data10 = getelementptr i8, ptr %bits4, i64 8
  %arr.elem11 = getelementptr inbounds i8, ptr %arr.data10, i64 %5
  store i8 0, ptr %arr.elem11, align 1
  %count = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 2
  %count12 = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 2
  %count13 = load i32, ptr %count12, align 4, !tbaa !7
  %6 = sub i32 %count13, 1
  store i32 %6, ptr %count, align 4, !tbaa !7
  br label %if.end
}

define internal i32 @EnumSet.contains(ptr nonnull align 8 dereferenceable(24) %0, i32 %1) {
entry:
  %ord = alloca i32, align 4
  store i32 %1, ptr %ord, align 4
  %bits = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 1
  %bits1 = load ptr, ptr %bits, align 8, !tbaa !3, !nonnull !0, !dereferenceable !1
  %ord2 = load i32, ptr %ord, align 4
  %2 = sext i32 %ord2 to i64
  %arr.len = load i64, ptr %bits1, align 8
  %arr.oob = icmp uge i64 %2, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !2

idx.bad:                                          ; preds = %entry
  call void @__polaron_fail(ptr @.fail.1703, ptr @.faila.1704, i64 %2, ptr @.failb.1705, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %entry
  %arr.data = getelementptr i8, ptr %bits1, i64 8
  %arr.elem = getelementptr inbounds i8, ptr %arr.data, i64 %2
  %elem = load i8, ptr %arr.elem, align 1
  %3 = zext i8 %elem to i32
  ret i32 %3
}

define internal i32 @EnumSet.size(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %count = getelementptr inbounds %class.EnumSet, ptr %0, i32 0, i32 2
  %count1 = load i32, ptr %count, align 4, !tbaa !7
  ret i32 %count1
}

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5345)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5347)
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

declare void @__polaron_str_free(ptr)

declare ptr @memcpy(ptr, ptr, i64)

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
