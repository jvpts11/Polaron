; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Biome = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Biome.vtable = private constant [350 x ptr] [ptr @Biome.code, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [350 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.fail = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol:28:26  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@Biome.OCEAN.__inst = private global ptr null
@.fail.1 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol:29:26  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@Biome.GRASS.__inst = private global ptr null
@.fail.4 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol:30:26  in main\0A\00", align 1
@.faila.5 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.6 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.fail.7 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol:31:26  in main\0A\00", align 1
@.faila.8 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.9 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@Biome.MOUNTAIN.__inst = private global ptr null
@.fail.10 = private unnamed_addr constant [136 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/enum_array_delete.pol:32:42  in main\0A\00", align 1
@.faila.11 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.12 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.str = private unnamed_addr constant [20 x i8] c"cells[2] code = %d\0A\00", align 1
@.str.13 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str.14 = private unnamed_addr constant [11 x i8] c"deleted ok\00", align 1
@.strdata.5322 = private constant [1 x i8] zeroinitializer
@.strobj.5323 = private global %String { i64 0, ptr @.strdata.5322, i64 0 }
@.strdata.5324 = private constant [1 x i8] zeroinitializer
@.strobj.5325 = private global %String { i64 0, ptr @.strdata.5324, i64 0 }

define internal void @Biome.Biome(ptr %0, i32 %1) {
entry:
  %code = alloca i32, align 4
  store i32 %1, ptr %code, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Biome, ptr %0, i32 0, i32 0
  store ptr @Biome.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %code1 = getelementptr inbounds %class.Biome, ptr %0, i32 0, i32 1
  %code2 = load i32, ptr %code, align 4
  store i32 %code2, ptr %code1, align 4, !tbaa !4
  ret void
}

define internal i32 @Biome.code(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %code = getelementptr inbounds %class.Biome, ptr %0, i32 0, i32 1
  %code1 = load i32, ptr %code, align 4, !tbaa !4
  ret i32 %code1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %cells = alloca ptr, align 8
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
  %arr = call ptr @__polaron_malloc(i64 40)
  store i64 4, ptr %arr, align 8
  %arr.data1 = getelementptr i8, ptr %arr, i64 8
  %16 = call ptr @memset(ptr %arr.data1, i32 0, i64 32)
  store ptr %arr, ptr %cells, align 8
  %cells2 = load ptr, ptr %cells, align 8, !nonnull !6, !dereferenceable !7
  %arr.len = load i64, ptr %cells2, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !8

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data3 = getelementptr i8, ptr %cells2, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data3, i64 0
  %enum.cur = load ptr, ptr @Biome.OCEAN.__inst, align 8
  %17 = icmp eq ptr %enum.cur, null
  br i1 %17, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %idx.ok
  %Biome = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Biome, ptr null, i64 1) to i64))
  call void @Biome.Biome(ptr %Biome, i32 1)
  store ptr %Biome, ptr @Biome.OCEAN.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %idx.ok
  %Biome4 = load ptr, ptr @Biome.OCEAN.__inst, align 8
  store ptr %Biome4, ptr %arr.elem, align 8
  %cells5 = load ptr, ptr %cells, align 8, !nonnull !6, !dereferenceable !7
  %arr.len6 = load i64, ptr %cells5, align 8
  %arr.oob7 = icmp uge i64 1, %arr.len6
  br i1 %arr.oob7, label %idx.bad8, label %idx.ok9, !prof !8

idx.bad8:                                         ; preds = %enumc.done
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len6, i32 70)
  unreachable

idx.ok9:                                          ; preds = %enumc.done
  %arr.data10 = getelementptr i8, ptr %cells5, i64 8
  %arr.elem11 = getelementptr inbounds ptr, ptr %arr.data10, i64 1
  %enum.cur12 = load ptr, ptr @Biome.GRASS.__inst, align 8
  %18 = icmp eq ptr %enum.cur12, null
  br i1 %18, label %enumc.init13, label %enumc.done14

enumc.init13:                                     ; preds = %idx.ok9
  %Biome15 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Biome, ptr null, i64 1) to i64))
  call void @Biome.Biome(ptr %Biome15, i32 2)
  store ptr %Biome15, ptr @Biome.GRASS.__inst, align 8
  br label %enumc.done14

enumc.done14:                                     ; preds = %enumc.init13, %idx.ok9
  %Biome16 = load ptr, ptr @Biome.GRASS.__inst, align 8
  store ptr %Biome16, ptr %arr.elem11, align 8
  %cells17 = load ptr, ptr %cells, align 8, !nonnull !6, !dereferenceable !7
  %arr.len18 = load i64, ptr %cells17, align 8
  %arr.oob19 = icmp uge i64 2, %arr.len18
  br i1 %arr.oob19, label %idx.bad20, label %idx.ok21, !prof !8

idx.bad20:                                        ; preds = %enumc.done14
  call void @__polaron_fail(ptr @.fail.4, ptr @.faila.5, i64 2, ptr @.failb.6, i64 %arr.len18, i32 70)
  unreachable

idx.ok21:                                         ; preds = %enumc.done14
  %arr.data22 = getelementptr i8, ptr %cells17, i64 8
  %arr.elem23 = getelementptr inbounds ptr, ptr %arr.data22, i64 2
  %enum.cur24 = load ptr, ptr @Biome.OCEAN.__inst, align 8
  %19 = icmp eq ptr %enum.cur24, null
  br i1 %19, label %enumc.init25, label %enumc.done26

enumc.init25:                                     ; preds = %idx.ok21
  %Biome27 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Biome, ptr null, i64 1) to i64))
  call void @Biome.Biome(ptr %Biome27, i32 1)
  store ptr %Biome27, ptr @Biome.OCEAN.__inst, align 8
  br label %enumc.done26

enumc.done26:                                     ; preds = %enumc.init25, %idx.ok21
  %Biome28 = load ptr, ptr @Biome.OCEAN.__inst, align 8
  store ptr %Biome28, ptr %arr.elem23, align 8
  %cells29 = load ptr, ptr %cells, align 8, !nonnull !6, !dereferenceable !7
  %arr.len30 = load i64, ptr %cells29, align 8
  %arr.oob31 = icmp uge i64 3, %arr.len30
  br i1 %arr.oob31, label %idx.bad32, label %idx.ok33, !prof !8

idx.bad32:                                        ; preds = %enumc.done26
  call void @__polaron_fail(ptr @.fail.7, ptr @.faila.8, i64 3, ptr @.failb.9, i64 %arr.len30, i32 70)
  unreachable

idx.ok33:                                         ; preds = %enumc.done26
  %arr.data34 = getelementptr i8, ptr %cells29, i64 8
  %arr.elem35 = getelementptr inbounds ptr, ptr %arr.data34, i64 3
  %enum.cur36 = load ptr, ptr @Biome.MOUNTAIN.__inst, align 8
  %20 = icmp eq ptr %enum.cur36, null
  br i1 %20, label %enumc.init37, label %enumc.done38

enumc.init37:                                     ; preds = %idx.ok33
  %Biome39 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Biome, ptr null, i64 1) to i64))
  call void @Biome.Biome(ptr %Biome39, i32 3)
  store ptr %Biome39, ptr @Biome.MOUNTAIN.__inst, align 8
  br label %enumc.done38

enumc.done38:                                     ; preds = %enumc.init37, %idx.ok33
  %Biome40 = load ptr, ptr @Biome.MOUNTAIN.__inst, align 8
  store ptr %Biome40, ptr %arr.elem35, align 8
  %cells41 = load ptr, ptr %cells, align 8, !nonnull !6, !dereferenceable !7
  %arr.len42 = load i64, ptr %cells41, align 8
  %arr.oob43 = icmp uge i64 2, %arr.len42
  br i1 %arr.oob43, label %idx.bad44, label %idx.ok45, !prof !8

idx.bad44:                                        ; preds = %enumc.done38
  call void @__polaron_fail(ptr @.fail.10, ptr @.faila.11, i64 2, ptr @.failb.12, i64 %arr.len42, i32 70)
  unreachable

idx.ok45:                                         ; preds = %enumc.done38
  %arr.data46 = getelementptr i8, ptr %cells41, i64 8
  %arr.elem47 = getelementptr inbounds ptr, ptr %arr.data46, i64 2
  %elem = load ptr, ptr %arr.elem47, align 8
  %21 = call i32 @Biome.code(ptr %elem)
  %22 = call i32 (ptr, ...) @printf(ptr @.str, i32 %21)
  %cells48 = load ptr, ptr %cells, align 8
  call void @__polaron_free(ptr %cells48)
  %23 = call i32 (ptr, ...) @printf(ptr @.str.13, ptr @.str.14)
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

define internal void @Test.__onClassLoad() {
entry:
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5323)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5325)
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

declare void @__polaron_free(ptr)

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
