; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sealed_java_enum_match.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sealed_java_enum_match.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Pace = type { ptr, i32, ptr }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Pace.vtable = private constant [353 x ptr] [ptr @Pace.steps, ptr @Pace.label, ptr @Pace.score, ptr @Pace.brisk, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [353 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Pace.Slow.__inst = private global ptr null
@Pace.Fast.__inst = private global ptr null
@.fail = private unnamed_addr constant [141 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sealed_java_enum_match.pol:69:42  in main\0A\00", align 1
@.faila = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata = private constant [5 x i8] c"slow\00"
@.strobj = private global %String { i64 4, ptr @.strdata, i64 0 }
@.fail.1 = private unnamed_addr constant [141 x i8] c"Polaron panic: array index out of bounds\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/sealed_java_enum_match.pol:69:42  in main\0A\00", align 1
@.faila.2 = private unnamed_addr constant [6 x i8] c"index\00", align 1
@.failb.3 = private unnamed_addr constant [7 x i8] c"length\00", align 1
@.strdata.4 = private constant [5 x i8] c"fast\00"
@.strobj.5 = private global %String { i64 4, ptr @.strdata.4, i64 0 }
@.str = private unnamed_addr constant [13 x i8] c"how many %d\0A\00", align 1
@.strdata.6 = private constant [5 x i8] c"fast\00"
@.strobj.7 = private global %String { i64 4, ptr @.strdata.6, i64 0 }
@.str.8 = private unnamed_addr constant [12 x i8] c"ordinal %d\0A\00", align 1
@.strdata.9 = private constant [5 x i8] c"fast\00"
@.strobj.10 = private global %String { i64 4, ptr @.strdata.9, i64 0 }
@.str.11 = private unnamed_addr constant [10 x i8] c"label %s\0A\00", align 1
@.strdata.12 = private constant [5 x i8] c"slow\00"
@.strobj.13 = private global %String { i64 4, ptr @.strdata.12, i64 0 }
@.strdata.14 = private constant [5 x i8] c"fast\00"
@.strobj.15 = private global %String { i64 4, ptr @.strdata.14, i64 0 }
@.str.16 = private unnamed_addr constant [13 x i8] c"score %g %g\0A\00", align 1
@.strdata.17 = private constant [5 x i8] c"slow\00"
@.strobj.18 = private global %String { i64 4, ptr @.strdata.17, i64 0 }
@.strdata.19 = private constant [5 x i8] c"fast\00"
@.strobj.20 = private global %String { i64 4, ptr @.strdata.19, i64 0 }
@.str.21 = private unnamed_addr constant [13 x i8] c"brisk %d %d\0A\00", align 1
@.strdata.22 = private constant [5 x i8] c"slow\00"
@.strobj.23 = private global %String { i64 4, ptr @.strdata.22, i64 0 }
@.str.24 = private unnamed_addr constant [12 x i8] c"held %s %g\0A\00", align 1
@.strdata.5334 = private constant [1 x i8] zeroinitializer
@.strobj.5335 = private global %String { i64 0, ptr @.strdata.5334, i64 0 }
@.strdata.5336 = private constant [1 x i8] zeroinitializer
@.strobj.5337 = private global %String { i64 0, ptr @.strdata.5336, i64 0 }

define internal void @Pace.Pace(ptr %0, i32 %1, ptr %2) {
entry:
  %said = alloca ptr, align 8
  %n = alloca i32, align 4
  store i32 %1, ptr %n, align 4
  store ptr %2, ptr %said, align 8
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 0
  store ptr @Pace.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %said1 = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 2
  store ptr null, ptr %said1, align 8, !tbaa !0
  %n2 = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 1
  %n3 = load i32, ptr %n, align 4
  store i32 %n3, ptr %n2, align 4, !tbaa !4
  %said4 = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 2
  %said5 = load ptr, ptr %said, align 8
  %strcpy = call ptr @__polaron_str_copy(ptr %said5)
  %3 = load ptr, ptr %said4, align 8, !tbaa !0
  call void @__polaron_str_free(ptr %3)
  store ptr %strcpy, ptr %said4, align 8, !tbaa !0
  ret void
}

define internal i32 @Pace.steps(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %n = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  ret i32 %n1
}

define internal ptr @Pace.label(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %said = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 2
  %said1 = load ptr, ptr %said, align 8, !tbaa !0
  %strcpy = call ptr @__polaron_str_copy(ptr %said1)
  ret ptr %strcpy
}

define internal float @Pace.score(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %enum.ord.cur = load ptr, ptr @Pace.Slow.__inst, align 8
  %1 = icmp eq ptr %0, %enum.ord.cur
  %enum.ord = select i1 %1, i32 0, i32 -1
  %enum.ord.cur1 = load ptr, ptr @Pace.Fast.__inst, align 8
  %2 = icmp eq ptr %0, %enum.ord.cur1
  %enum.ord2 = select i1 %2, i32 1, i32 %enum.ord
  %is = icmp eq i32 %enum.ord2, 0
  br i1 %is, label %matchx.case, label %matchx.next

matchx.end:                                       ; preds = %matchx.case3, %matchx.case
  %matchx = phi double [ 2.500000e-01, %matchx.case ], [ 7.500000e-01, %matchx.case3 ]
  %3 = fptrunc double %matchx to float
  ret float %3

matchx.case:                                      ; preds = %entry
  br label %matchx.end

matchx.next:                                      ; preds = %entry
  %is5 = icmp eq i32 %enum.ord2, 1
  br i1 %is5, label %matchx.case3, label %matchx.next4

matchx.case3:                                     ; preds = %matchx.next
  br label %matchx.end

matchx.next4:                                     ; preds = %matchx.next
  unreachable
}

define internal i32 @Pace.brisk(ptr nonnull align 8 dereferenceable(24) %0) {
entry:
  %n = getelementptr inbounds %class.Pace, ptr %0, i32 0, i32 1
  %n1 = load i32, ptr %n, align 4, !tbaa !4
  %1 = icmp sge i32 %n1, 5
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %held = alloca ptr, align 8
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
  %enum.vals = call ptr @__polaron_malloc(i64 24)
  store i64 2, ptr %enum.vals, align 8
  %arr.len = load i64, ptr %enum.vals, align 8
  %arr.oob = icmp uge i64 0, %arr.len
  br i1 %arr.oob, label %idx.bad, label %idx.ok, !prof !6

idx.bad:                                          ; preds = %argv.end
  call void @__polaron_fail(ptr @.fail, ptr @.faila, i64 0, ptr @.failb, i64 %arr.len, i32 70)
  unreachable

idx.ok:                                           ; preds = %argv.end
  %arr.data1 = getelementptr i8, ptr %enum.vals, i64 8
  %arr.elem = getelementptr inbounds ptr, ptr %arr.data1, i64 0
  %enum.cur = load ptr, ptr @Pace.Slow.__inst, align 8
  %16 = icmp eq ptr %enum.cur, null
  br i1 %16, label %enumc.init, label %enumc.done

enumc.init:                                       ; preds = %idx.ok
  %Pace = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace, i32 1, ptr @.strobj)
  store ptr %Pace, ptr @Pace.Slow.__inst, align 8
  br label %enumc.done

enumc.done:                                       ; preds = %enumc.init, %idx.ok
  %Pace2 = load ptr, ptr @Pace.Slow.__inst, align 8
  store ptr %Pace2, ptr %arr.elem, align 8
  %arr.len3 = load i64, ptr %enum.vals, align 8
  %arr.oob4 = icmp uge i64 1, %arr.len3
  br i1 %arr.oob4, label %idx.bad5, label %idx.ok6, !prof !6

idx.bad5:                                         ; preds = %enumc.done
  call void @__polaron_fail(ptr @.fail.1, ptr @.faila.2, i64 1, ptr @.failb.3, i64 %arr.len3, i32 70)
  unreachable

idx.ok6:                                          ; preds = %enumc.done
  %arr.data7 = getelementptr i8, ptr %enum.vals, i64 8
  %arr.elem8 = getelementptr inbounds ptr, ptr %arr.data7, i64 1
  %enum.cur9 = load ptr, ptr @Pace.Fast.__inst, align 8
  %17 = icmp eq ptr %enum.cur9, null
  br i1 %17, label %enumc.init10, label %enumc.done11

enumc.init10:                                     ; preds = %idx.ok6
  %Pace12 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace12, i32 9, ptr @.strobj.5)
  store ptr %Pace12, ptr @Pace.Fast.__inst, align 8
  br label %enumc.done11

enumc.done11:                                     ; preds = %enumc.init10, %idx.ok6
  %Pace13 = load ptr, ptr @Pace.Fast.__inst, align 8
  store ptr %Pace13, ptr %arr.elem8, align 8
  %len = load i64, ptr %enum.vals, align 8
  %18 = trunc i64 %len to i32
  %19 = call i32 (ptr, ...) @printf(ptr @.str, i32 %18)
  %enum.cur14 = load ptr, ptr @Pace.Fast.__inst, align 8
  %20 = icmp eq ptr %enum.cur14, null
  br i1 %20, label %enumc.init15, label %enumc.done16

enumc.init15:                                     ; preds = %enumc.done11
  %Pace17 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace17, i32 9, ptr @.strobj.7)
  store ptr %Pace17, ptr @Pace.Fast.__inst, align 8
  br label %enumc.done16

enumc.done16:                                     ; preds = %enumc.init15, %enumc.done11
  %Pace18 = load ptr, ptr @Pace.Fast.__inst, align 8
  %enum.ord.cur = load ptr, ptr @Pace.Slow.__inst, align 8
  %21 = icmp eq ptr %Pace18, %enum.ord.cur
  %enum.ord = select i1 %21, i32 0, i32 -1
  %enum.ord.cur19 = load ptr, ptr @Pace.Fast.__inst, align 8
  %22 = icmp eq ptr %Pace18, %enum.ord.cur19
  %enum.ord20 = select i1 %22, i32 1, i32 %enum.ord
  %23 = call i32 (ptr, ...) @printf(ptr @.str.8, i32 %enum.ord20)
  %enum.cur21 = load ptr, ptr @Pace.Fast.__inst, align 8
  %24 = icmp eq ptr %enum.cur21, null
  br i1 %24, label %enumc.init22, label %enumc.done23

enumc.init22:                                     ; preds = %enumc.done16
  %Pace24 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace24, i32 9, ptr @.strobj.10)
  store ptr %Pace24, ptr @Pace.Fast.__inst, align 8
  br label %enumc.done23

enumc.done23:                                     ; preds = %enumc.init22, %enumc.done16
  %Pace25 = load ptr, ptr @Pace.Fast.__inst, align 8
  %25 = call ptr @Pace.label(ptr %Pace25)
  %str.data = getelementptr inbounds %String, ptr %25, i32 0, i32 1
  %data = load ptr, ptr %str.data, align 8
  %26 = call i32 (ptr, ...) @printf(ptr @.str.11, ptr %data)
  call void @__polaron_str_free(ptr %25)
  %enum.cur26 = load ptr, ptr @Pace.Slow.__inst, align 8
  %27 = icmp eq ptr %enum.cur26, null
  br i1 %27, label %enumc.init27, label %enumc.done28

enumc.init27:                                     ; preds = %enumc.done23
  %Pace29 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace29, i32 1, ptr @.strobj.13)
  store ptr %Pace29, ptr @Pace.Slow.__inst, align 8
  br label %enumc.done28

enumc.done28:                                     ; preds = %enumc.init27, %enumc.done23
  %Pace30 = load ptr, ptr @Pace.Slow.__inst, align 8
  %28 = call float @Pace.score(ptr %Pace30)
  %29 = fpext float %28 to double
  %enum.cur31 = load ptr, ptr @Pace.Fast.__inst, align 8
  %30 = icmp eq ptr %enum.cur31, null
  br i1 %30, label %enumc.init32, label %enumc.done33

enumc.init32:                                     ; preds = %enumc.done28
  %Pace34 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace34, i32 9, ptr @.strobj.15)
  store ptr %Pace34, ptr @Pace.Fast.__inst, align 8
  br label %enumc.done33

enumc.done33:                                     ; preds = %enumc.init32, %enumc.done28
  %Pace35 = load ptr, ptr @Pace.Fast.__inst, align 8
  %31 = call float @Pace.score(ptr %Pace35)
  %32 = fpext float %31 to double
  %33 = call i32 (ptr, ...) @printf(ptr @.str.16, double %29, double %32)
  %enum.cur36 = load ptr, ptr @Pace.Slow.__inst, align 8
  %34 = icmp eq ptr %enum.cur36, null
  br i1 %34, label %enumc.init37, label %enumc.done38

enumc.init37:                                     ; preds = %enumc.done33
  %Pace39 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace39, i32 1, ptr @.strobj.18)
  store ptr %Pace39, ptr @Pace.Slow.__inst, align 8
  br label %enumc.done38

enumc.done38:                                     ; preds = %enumc.init37, %enumc.done33
  %Pace40 = load ptr, ptr @Pace.Slow.__inst, align 8
  %35 = call i32 @Pace.brisk(ptr %Pace40)
  %enum.cur41 = load ptr, ptr @Pace.Fast.__inst, align 8
  %36 = icmp eq ptr %enum.cur41, null
  br i1 %36, label %enumc.init42, label %enumc.done43

enumc.init42:                                     ; preds = %enumc.done38
  %Pace44 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace44, i32 9, ptr @.strobj.20)
  store ptr %Pace44, ptr @Pace.Fast.__inst, align 8
  br label %enumc.done43

enumc.done43:                                     ; preds = %enumc.init42, %enumc.done38
  %Pace45 = load ptr, ptr @Pace.Fast.__inst, align 8
  %37 = call i32 @Pace.brisk(ptr %Pace45)
  %38 = call i32 (ptr, ...) @printf(ptr @.str.21, i32 %35, i32 %37)
  %enum.cur46 = load ptr, ptr @Pace.Slow.__inst, align 8
  %39 = icmp eq ptr %enum.cur46, null
  br i1 %39, label %enumc.init47, label %enumc.done48

enumc.init47:                                     ; preds = %enumc.done43
  %Pace49 = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%class.Pace, ptr null, i64 1) to i64))
  call void @Pace.Pace(ptr %Pace49, i32 1, ptr @.strobj.23)
  store ptr %Pace49, ptr @Pace.Slow.__inst, align 8
  br label %enumc.done48

enumc.done48:                                     ; preds = %enumc.init47, %enumc.done43
  %Pace50 = load ptr, ptr @Pace.Slow.__inst, align 8
  store ptr %Pace50, ptr %held, align 8
  %held51 = load ptr, ptr %held, align 8
  %40 = call ptr @Pace.label(ptr %held51)
  %str.data52 = getelementptr inbounds %String, ptr %40, i32 0, i32 1
  %data53 = load ptr, ptr %str.data52, align 8
  %held54 = load ptr, ptr %held, align 8
  %41 = call float @Pace.score(ptr %held54)
  %42 = fpext float %41 to double
  %43 = call i32 (ptr, ...) @printf(ptr @.str.24, ptr %data53, double %42)
  call void @__polaron_str_free(ptr %40)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5335)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5337)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

declare ptr @__polaron_str_copy(ptr)

declare void @__polaron_str_free(ptr)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
!6 = !{!"branch_weights", i32 1, i32 1048576}
