; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interrupt_atomic_ok.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interrupt_atomic_ok.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Timer = type { ptr, i32 }
%"class.atomic$int" = type { i32 }
%class.Trap = type { i64 }
%String = type { i64, ptr, i64 }

@"Timer$interrupt$self" = internal global ptr null

define internal void @Timer.Timer(ptr %0) {
entry:
  %ticks = getelementptr inbounds %class.Timer, ptr %0, i32 0, i32 0
  store ptr null, ptr %ticks, align 8, !tbaa !0
  %ticks1 = getelementptr inbounds %class.Timer, ptr %0, i32 0, i32 0
  %"atomic$int.obj" = call ptr @__polaron_malloc(i64 ptrtoint (ptr getelementptr (%"class.atomic$int", ptr null, i64 1) to i64))
  call void @"atomic$int.atomic$int"(ptr %"atomic$int.obj", i32 0)
  store ptr %"atomic$int.obj", ptr %ticks1, align 8, !tbaa !0
  %hz = getelementptr inbounds %class.Timer, ptr %0, i32 0, i32 1
  store i32 100, ptr %hz, align 4, !tbaa !4
  ret void
}

define internal void @Timer.interrupt(ptr nonnull align 8 dereferenceable(16) %0, ptr %1) {
entry:
  %Trap.copy = alloca %class.Trap, align 8
  %t = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Trap.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Trap, ptr null, i64 1) to i64))
  store ptr %Trap.copy, ptr %t, align 8
  call void @Timer.bump(ptr %0)
  ret void
}

define x86_intrcc void @"Timer$interrupt"(ptr byval(%class.Trap) %0) {
entry:
  %self = load ptr, ptr @"Timer$interrupt$self", align 8
  call void @Timer.interrupt(ptr %self, ptr %0)
  ret void
}

define internal void @Timer.bump(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %ticks = getelementptr inbounds %class.Timer, ptr %0, i32 0, i32 0
  %ticks1 = load ptr, ptr %ticks, align 8, !tbaa !0
  %atomic.value = getelementptr inbounds %"class.atomic$int", ptr %ticks1, i32 0, i32 0
  %1 = atomicrmw add ptr %atomic.value, i32 1 seq_cst, align 4
  %atomic.new = add i32 %1, 1
  ret void
}

define internal i32 @Timer.elapsed(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %ticks = getelementptr inbounds %class.Timer, ptr %0, i32 0, i32 0
  %ticks1 = load ptr, ptr %ticks, align 8, !tbaa !0
  %atomic.value = getelementptr inbounds %"class.atomic$int", ptr %ticks1, i32 0, i32 0
  %atomic.get = load atomic i32, ptr %atomic.value seq_cst, align 4, !tbaa !4
  ret i32 %atomic.get
}

define internal i32 @Timer.rate(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %hz = getelementptr inbounds %class.Timer, ptr %0, i32 0, i32 1
  %hz1 = load i32, ptr %hz, align 4, !tbaa !4
  ret i32 %hz1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %entry2 = alloca i64, align 8
  %clock = alloca ptr, align 8
  %Timer.obj = alloca %class.Timer, align 8
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
  call void @Timer.Timer(ptr %Timer.obj)
  store ptr %Timer.obj, ptr %clock, align 8
  %clock1 = load ptr, ptr %clock, align 8
  store ptr %clock1, ptr @"Timer$interrupt$self", align 8
  store i64 ptrtoint (ptr @"Timer$interrupt" to i64), ptr %entry2, align 8
  %entry3 = load i64, ptr %entry2, align 8
  %16 = icmp eq i64 %entry3, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  ret i32 1

if.end:                                           ; preds = %argv.end
  %clock4 = load ptr, ptr %clock, align 8
  %18 = call i32 @Timer.elapsed(ptr %clock4)
  %clock5 = load ptr, ptr %clock, align 8
  %19 = call i32 @Timer.rate(ptr %clock5)
  %20 = add i32 %18, %19
  ret i32 %20
}

define internal void @"atomic$int.atomic$int"(ptr %0, i32 %1) {
entry:
  %initial = alloca i32, align 4
  store i32 %1, ptr %initial, align 4
  %value = getelementptr inbounds %"class.atomic$int", ptr %0, i32 0, i32 0
  %initial1 = load i32, ptr %initial, align 4
  store i32 %initial1, ptr %value, align 4, !tbaa !4
  ret void
}

declare noalias ptr @__polaron_malloc(i64)

declare ptr @memcpy(ptr, ptr, i64)

declare i64 @strlen(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
