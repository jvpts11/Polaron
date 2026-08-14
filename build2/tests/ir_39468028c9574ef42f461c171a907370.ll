; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interrupt_entry.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/interrupt_entry.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Keyboard = type { i32 }
%class.Trap = type { i64, i64, i64, i64, i64 }
%class.Spurious = type { i32 }
%String = type { i64, ptr, i64 }

@"Keyboard$interrupt$self" = internal global ptr null
@"Spurious$interrupt$self" = internal global ptr null

define internal void @Keyboard.Keyboard(ptr %0) {
entry:
  %scancodes = getelementptr inbounds %class.Keyboard, ptr %0, i32 0, i32 0
  store volatile i32 0, ptr %scancodes, align 4, !tbaa !0
  ret void
}

define internal void @Keyboard.interrupt(ptr nonnull align 4 dereferenceable(4) %0, ptr %1) {
entry:
  %Trap.copy = alloca %class.Trap, align 8
  %t = alloca ptr, align 8
  %2 = call ptr @memcpy(ptr %Trap.copy, ptr %1, i64 ptrtoint (ptr getelementptr (%class.Trap, ptr null, i64 1) to i64))
  store ptr %Trap.copy, ptr %t, align 8
  %scancodes = getelementptr inbounds %class.Keyboard, ptr %0, i32 0, i32 0
  %scancodes1 = getelementptr inbounds %class.Keyboard, ptr %0, i32 0, i32 0
  %scancodes2 = load volatile i32, ptr %scancodes1, align 4, !tbaa !0
  %3 = add i32 %scancodes2, 1
  store volatile i32 %3, ptr %scancodes, align 4, !tbaa !0
  ret void
}

define x86_intrcc void @"Keyboard$interrupt"(ptr byval(%class.Trap) %0) {
entry:
  %self = load ptr, ptr @"Keyboard$interrupt$self", align 8
  call void @Keyboard.interrupt(ptr %self, ptr %0)
  ret void
}

define internal i32 @Keyboard.count(ptr nonnull align 4 dereferenceable(4) %0) {
entry:
  %scancodes = getelementptr inbounds %class.Keyboard, ptr %0, i32 0, i32 0
  %scancodes1 = load volatile i32, ptr %scancodes, align 4, !tbaa !0
  ret i32 %scancodes1
}

define internal void @Spurious.Spurious(ptr %0) {
entry:
  %seen = getelementptr inbounds %class.Spurious, ptr %0, i32 0, i32 0
  store volatile i32 0, ptr %seen, align 4, !tbaa !0
  ret void
}

define internal void @Spurious.interrupt(ptr nonnull align 4 dereferenceable(4) %0) {
entry:
  %seen = getelementptr inbounds %class.Spurious, ptr %0, i32 0, i32 0
  %seen1 = getelementptr inbounds %class.Spurious, ptr %0, i32 0, i32 0
  %seen2 = load volatile i32, ptr %seen1, align 4, !tbaa !0
  %1 = add i32 %seen2, 1
  store volatile i32 %1, ptr %seen, align 4, !tbaa !0
  ret void
}

define x86_intrcc void @"Spurious$interrupt"(ptr byval({ i64, i64, i64, i64, i64 }) %0) {
entry:
  %self = load ptr, ptr @"Spurious$interrupt$self", align 8
  call void @Spurious.interrupt(ptr %self)
  ret void
}

define internal i32 @Spurious.count(ptr nonnull align 4 dereferenceable(4) %0) {
entry:
  %seen = getelementptr inbounds %class.Spurious, ptr %0, i32 0, i32 0
  %seen1 = load volatile i32, ptr %seen, align 4, !tbaa !0
  ret i32 %seen1
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %spurEntry = alloca i64, align 8
  %kbdEntry = alloca i64, align 8
  %spur = alloca ptr, align 8
  %Spurious.obj = alloca %class.Spurious, align 8
  %kbd = alloca ptr, align 8
  %Keyboard.obj = alloca %class.Keyboard, align 8
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
  call void @Keyboard.Keyboard(ptr %Keyboard.obj)
  store ptr %Keyboard.obj, ptr %kbd, align 8
  call void @Spurious.Spurious(ptr %Spurious.obj)
  store ptr %Spurious.obj, ptr %spur, align 8
  %kbd1 = load ptr, ptr %kbd, align 8
  store ptr %kbd1, ptr @"Keyboard$interrupt$self", align 8
  store i64 ptrtoint (ptr @"Keyboard$interrupt" to i64), ptr %kbdEntry, align 8
  %spur2 = load ptr, ptr %spur, align 8
  store ptr %spur2, ptr @"Spurious$interrupt$self", align 8
  store i64 ptrtoint (ptr @"Spurious$interrupt" to i64), ptr %spurEntry, align 8
  %kbdEntry3 = load i64, ptr %kbdEntry, align 8
  %16 = icmp eq i64 %kbdEntry3, 0
  %17 = zext i1 %16 to i32
  br i1 %16, label %if.then, label %if.end

if.then:                                          ; preds = %argv.end
  ret i32 1

if.end:                                           ; preds = %argv.end
  %spurEntry4 = load i64, ptr %spurEntry, align 8
  %18 = icmp eq i64 %spurEntry4, 0
  %19 = zext i1 %18 to i32
  br i1 %18, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  ret i32 2

if.end6:                                          ; preds = %if.end
  %kbd7 = load ptr, ptr %kbd, align 8
  %20 = call i32 @Keyboard.count(ptr %kbd7)
  %spur8 = load ptr, ptr %spur, align 8
  %21 = call i32 @Spurious.count(ptr %spur8)
  %22 = add i32 %20, %21
  ret i32 %22
}

declare ptr @memcpy(ptr, ptr, i64)

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
