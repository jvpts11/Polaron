; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unimport_freestanding.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/unimport_freestanding.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%class.Nic = type { i32 }
%String = type { i64, ptr, i64 }

@__polaron_code_base = private global ptr @__polaron_code
@__polaron_code_count = private global i64 4
@instances.Nic = private global i32 0
@alive.Nic = private global i32 1
@.panic = private unnamed_addr constant [70 x i8] c"use of an unimported type: its code was ripped from RAM by `unimport`\00", align 1
@.panic.1 = private unnamed_addr constant [70 x i8] c"use of an unimported type: its code was ripped from RAM by `unimport`\00", align 1
@.panic.2 = private unnamed_addr constant [55 x i8] c"cannot unimport 'Nic': instances of it are still alive\00", align 1
@__polaron_code = private constant [4 x ptr] [ptr @Nic.Nic, ptr @Nic.poll, ptr @"Nic.~Nic", ptr @main]

define internal void @Nic.Nic(ptr %0) {
entry:
  %inst.n = load i32, ptr @instances.Nic, align 4
  %1 = add i32 %inst.n, 1
  store i32 %1, ptr @instances.Nic, align 4
  %irq = getelementptr inbounds %class.Nic, ptr %0, i32 0, i32 0
  store i32 11, ptr %irq, align 4, !tbaa !0
  ret void
}

define internal i32 @Nic.poll(ptr nonnull align 4 dereferenceable(4) %0) {
entry:
  %irq = getelementptr inbounds %class.Nic, ptr %0, i32 0, i32 0
  %irq1 = load i32, ptr %irq, align 4, !tbaa !0
  ret i32 %irq1
}

define internal void @"Nic.~Nic"(ptr %0) {
entry:
  %inst.n = load i32, ptr @instances.Nic, align 4
  %1 = sub i32 %inst.n, 1
  store i32 %1, ptr @instances.Nic, align 4
  ret void
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %seen = alloca i32, align 4
  %n = alloca ptr, align 8
  store ptr null, ptr %n, align 8
  %Nic.obj = alloca %class.Nic, align 8
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
  %alive = load i32, ptr @alive.Nic, align 4
  %16 = icmp eq i32 %alive, 0
  br i1 %16, label %unimported, label %alive.ok

unimported:                                       ; preds = %argv.end
  call void @__polaron_panic(ptr @.panic)
  unreachable

alive.ok:                                         ; preds = %argv.end
  call void @Nic.Nic(ptr %Nic.obj)
  store ptr %Nic.obj, ptr %n, align 8
  %alive1 = load i32, ptr @alive.Nic, align 4
  %17 = icmp eq i32 %alive1, 0
  br i1 %17, label %unimported2, label %alive.ok3

unimported2:                                      ; preds = %alive.ok
  call void @__polaron_panic(ptr @.panic.1)
  unreachable

alive.ok3:                                        ; preds = %alive.ok
  %n4 = load ptr, ptr %n, align 8
  %18 = call i32 @Nic.poll(ptr %n4)
  store i32 %18, ptr %seen, align 4
  %live.n = load i32, ptr @instances.Nic, align 4
  %19 = icmp ne i32 %live.n, 0
  br i1 %19, label %unimport.live, label %unimport.ok

unimport.live:                                    ; preds = %alive.ok3
  call void @__polaron_panic(ptr @.panic.2)
  unreachable

unimport.ok:                                      ; preds = %alive.ok3
  store i32 0, ptr @alive.Nic, align 4
  %code.base = load ptr, ptr @__polaron_code_base, align 8
  %code.n = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @Nic.poll, ptr %code.base, i64 %code.n)
  %code.base5 = load ptr, ptr @__polaron_code_base, align 8
  %code.n6 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @Nic.Nic, ptr %code.base5, i64 %code.n6)
  %code.base7 = load ptr, ptr @__polaron_code_base, align 8
  %code.n8 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_unload_fn(ptr @"Nic.~Nic", ptr %code.base7, i64 %code.n8)
  %code.base9 = load ptr, ptr @__polaron_code_base, align 8
  %code.n10 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_reload_fn(ptr @Nic.poll, ptr %code.base9, i64 %code.n10)
  %code.base11 = load ptr, ptr @__polaron_code_base, align 8
  %code.n12 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_reload_fn(ptr @Nic.Nic, ptr %code.base11, i64 %code.n12)
  %code.base13 = load ptr, ptr @__polaron_code_base, align 8
  %code.n14 = load i64, ptr @__polaron_code_count, align 8
  call void @__polaron_reload_fn(ptr @"Nic.~Nic", ptr %code.base13, i64 %code.n14)
  store i32 1, ptr @alive.Nic, align 4
  %seen15 = load i32, ptr %seen, align 4
  %20 = load ptr, ptr %n, align 8
  %21 = icmp ne ptr %20, null
  br i1 %21, label %dtor.live, label %dtor.done

dtor.live:                                        ; preds = %unimport.ok
  call void @"Nic.~Nic"(ptr %20)
  br label %dtor.done

dtor.done:                                        ; preds = %dtor.live, %unimport.ok
  ret i32 %seen15
}

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_panic(ptr nocapture readonly) #0

declare void @__polaron_unload_fn(ptr, ptr, i64)

declare void @__polaron_reload_fn(ptr, ptr, i64)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }

!0 = !{!1, !1, i64 0}
!1 = !{!"i32", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
