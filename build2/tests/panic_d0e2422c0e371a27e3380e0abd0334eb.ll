; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contract_report_freestanding.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contract_report_freestanding.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Gate = type { i32 }
%String = type { i64, ptr, i64 }

@.contract = private unnamed_addr constant [176 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contract_report_freestanding.pol:37:37  in Gate.admit\0A   |  requires this.seats >= wanted\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1

declare i32 @putchar(i32)

define internal void @Gate.Gate(ptr %0, i32 %1) {
entry:
  %howMany = alloca i32, align 4
  store i32 %1, ptr %howMany, align 4
  %seats = getelementptr inbounds %class.Gate, ptr %0, i32 0, i32 0
  %howMany1 = load i32, ptr %howMany, align 4
  store i32 %howMany1, ptr %seats, align 4, !tbaa !0
  ret void
}

define internal void @Gate.admit(ptr nonnull align 4 dereferenceable(4) %0, i32 %1) {
entry:
  %wanted = alloca i32, align 4
  store i32 %1, ptr %wanted, align 4
  %seats = getelementptr inbounds %class.Gate, ptr %0, i32 0, i32 0
  %seats1 = load i32, ptr %seats, align 4, !tbaa !0
  %wanted2 = load i32, ptr %wanted, align 4
  %2 = icmp sge i32 %seats1, %wanted2
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %seats3 = getelementptr inbounds %class.Gate, ptr %0, i32 0, i32 0
  %seats4 = load i32, ptr %seats3, align 4, !tbaa !0
  %wanted5 = load i32, ptr %wanted, align 4
  %contract.l = sext i32 %seats4 to i64
  %contract.r = sext i32 %wanted5 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 %contract.r, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %seats6 = getelementptr inbounds %class.Gate, ptr %0, i32 0, i32 0
  %seats7 = getelementptr inbounds %class.Gate, ptr %0, i32 0, i32 0
  %seats8 = load i32, ptr %seats7, align 4, !tbaa !0
  %wanted9 = load i32, ptr %wanted, align 4
  %4 = sub i32 %seats8, %wanted9
  store i32 %4, ptr %seats6, align 4, !tbaa !0
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %g = alloca ptr, align 8
  %Gate.obj = alloca %class.Gate, align 8
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
  call void @Gate.Gate(ptr %Gate.obj, i32 4)
  store ptr %Gate.obj, ptr %g, align 8
  %16 = call i32 @putchar(i32 79)
  %g1 = load ptr, ptr %g, align 8
  call void @Gate.admit(ptr %g1, i32 9)
  %17 = call i32 @putchar(i32 78)
  ret i32 0
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
