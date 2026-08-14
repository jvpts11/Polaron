; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%String = type { i64, ptr, i64 }
%class.Account = type { ptr, i32 }
%class.Object = type { ptr }

@Test.criterion = private global ptr null
@Test.skipWhy = private global ptr null
@Account.vtable = private constant [352 x ptr] [ptr @Account.deposit, ptr @Account.withdraw, ptr @Account.getBalance, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@Object.vtable = private constant [352 x ptr] [ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @Object.equals, ptr @Object.hashCode, ptr @Object.equalsKey, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null]
@.contract = private unnamed_addr constant [152 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:17:32  in Account.Account\0A   |  requires start >= 0\0A\00", align 1
@.cl = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.1 = private unnamed_addr constant [161 x i8] c"contract violated: ensures\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:18:38  in Account.Account\0A   |  ensures this.balance == start\0A\00", align 1
@.cl.2 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.3 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.4 = private unnamed_addr constant [162 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:14:36  in Account.Account\0A   |  invariant this.balance >= 0;\0A\00", align 1
@.cl.5 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.6 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.7 = private unnamed_addr constant [152 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:24:33  in Account.deposit\0A   |  requires amount > 0\0A\00", align 1
@.cl.8 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.9 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.10 = private unnamed_addr constant [182 x i8] c"contract violated: ensures\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:25:38  in Account.deposit\0A   |  ensures this.balance == old(this.balance) + amount\0A\00", align 1
@.contract.11 = private unnamed_addr constant [162 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:14:36  in Account.deposit\0A   |  invariant this.balance >= 0;\0A\00", align 1
@.cl.12 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.13 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.14 = private unnamed_addr constant [153 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:31:33  in Account.withdraw\0A   |  requires amount > 0\0A\00", align 1
@.cl.15 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.16 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.17 = private unnamed_addr constant [165 x i8] c"contract violated: requires\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:32:33  in Account.withdraw\0A   |  requires amount <= this.balance\0A\00", align 1
@.cl.18 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.19 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.contract.20 = private unnamed_addr constant [183 x i8] c"contract violated: ensures\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:33:38  in Account.withdraw\0A   |  ensures this.balance == old(this.balance) - amount\0A\00", align 1
@.contract.21 = private unnamed_addr constant [163 x i8] c"contract violated: invariant\0A  --> C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/contracts.pol:14:36  in Account.withdraw\0A   |  invariant this.balance >= 0;\0A\00", align 1
@.cl.22 = private unnamed_addr constant [5 x i8] c"left\00", align 1
@.cr.23 = private unnamed_addr constant [6 x i8] c"right\00", align 1
@.str = private unnamed_addr constant [14 x i8] c"balance = %d\0A\00", align 1
@.strdata.5331 = private constant [1 x i8] zeroinitializer
@.strobj.5332 = private global %String { i64 0, ptr @.strdata.5331, i64 0 }
@.strdata.5333 = private constant [1 x i8] zeroinitializer
@.strobj.5334 = private global %String { i64 0, ptr @.strdata.5333, i64 0 }

define internal void @Account.Account(ptr %0, i32 %1) {
entry:
  %start = alloca i32, align 4
  store i32 %1, ptr %start, align 4
  call void @Object.Object(ptr %0)
  %vtbl.addr = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 0
  store ptr @Account.vtable, ptr %vtbl.addr, align 8, !tbaa !0
  %start1 = load i32, ptr %start, align 4
  %2 = icmp sge i32 %start1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %start2 = load i32, ptr %start, align 4
  %contract.l = sext i32 %start2 to i64
  call void @__polaron_fail(ptr @.contract, ptr @.cl, i64 %contract.l, ptr @.cr, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %balance = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %start3 = load i32, ptr %start, align 4
  store i32 %start3, ptr %balance, align 4, !tbaa !4
  %balance4 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance5 = load i32, ptr %balance4, align 4, !tbaa !4
  %start6 = load i32, ptr %start, align 4
  %4 = icmp eq i32 %balance5, %start6
  %5 = zext i1 %4 to i32
  %contract.ok7 = icmp ne i32 %5, 0
  br i1 %contract.ok7, label %contract.cont9, label %contract.fail8

contract.fail8:                                   ; preds = %contract.cont
  %balance10 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance11 = load i32, ptr %balance10, align 4, !tbaa !4
  %start12 = load i32, ptr %start, align 4
  %contract.l13 = sext i32 %balance11 to i64
  %contract.r = sext i32 %start12 to i64
  call void @__polaron_fail(ptr @.contract.1, ptr @.cl.2, i64 %contract.l13, ptr @.cr.3, i64 %contract.r, i32 1)
  unreachable

contract.cont9:                                   ; preds = %contract.cont
  %balance14 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance15 = load i32, ptr %balance14, align 4, !tbaa !4
  %6 = icmp sge i32 %balance15, 0
  %7 = zext i1 %6 to i32
  %contract.ok16 = icmp ne i32 %7, 0
  br i1 %contract.ok16, label %contract.cont18, label %contract.fail17

contract.fail17:                                  ; preds = %contract.cont9
  %balance19 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance20 = load i32, ptr %balance19, align 4, !tbaa !4
  %contract.l21 = sext i32 %balance20 to i64
  call void @__polaron_fail(ptr @.contract.4, ptr @.cl.5, i64 %contract.l21, ptr @.cr.6, i64 0, i32 1)
  unreachable

contract.cont18:                                  ; preds = %contract.cont9
  ret void
}

define internal void @Account.deposit(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %old = alloca i32, align 4
  %amount = alloca i32, align 4
  store i32 %1, ptr %amount, align 4
  %amount1 = load i32, ptr %amount, align 4
  %2 = icmp sgt i32 %amount1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %amount2 = load i32, ptr %amount, align 4
  %contract.l = sext i32 %amount2 to i64
  call void @__polaron_fail(ptr @.contract.7, ptr @.cl.8, i64 %contract.l, ptr @.cr.9, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %balance = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance3 = load i32, ptr %balance, align 4, !tbaa !4
  %4 = icmp sge i32 %balance3, 0
  %5 = zext i1 %4 to i32
  %inv.assume = icmp ne i32 %5, 0
  call void @llvm.assume(i1 %inv.assume)
  %balance4 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance5 = load i32, ptr %balance4, align 4, !tbaa !4
  store i32 %balance5, ptr %old, align 4
  %balance6 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance7 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance8 = load i32, ptr %balance7, align 4, !tbaa !4
  %amount9 = load i32, ptr %amount, align 4
  %6 = add i32 %balance8, %amount9
  store i32 %6, ptr %balance6, align 4, !tbaa !4
  %balance10 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance11 = load i32, ptr %balance10, align 4, !tbaa !4
  %old12 = load i32, ptr %old, align 4
  %amount13 = load i32, ptr %amount, align 4
  %7 = add i32 %old12, %amount13
  %8 = icmp eq i32 %balance11, %7
  %9 = zext i1 %8 to i32
  %contract.ok14 = icmp ne i32 %9, 0
  br i1 %contract.ok14, label %contract.cont16, label %contract.fail15

contract.fail15:                                  ; preds = %contract.cont
  call void @__polaron_fail(ptr @.contract.10, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont16:                                  ; preds = %contract.cont
  %balance17 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance18 = load i32, ptr %balance17, align 4, !tbaa !4
  %10 = icmp sge i32 %balance18, 0
  %11 = zext i1 %10 to i32
  %contract.ok19 = icmp ne i32 %11, 0
  br i1 %contract.ok19, label %contract.cont21, label %contract.fail20

contract.fail20:                                  ; preds = %contract.cont16
  %balance22 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance23 = load i32, ptr %balance22, align 4, !tbaa !4
  %contract.l24 = sext i32 %balance23 to i64
  call void @__polaron_fail(ptr @.contract.11, ptr @.cl.12, i64 %contract.l24, ptr @.cr.13, i64 0, i32 1)
  unreachable

contract.cont21:                                  ; preds = %contract.cont16
  ret void
}

define internal void @Account.withdraw(ptr nonnull align 8 dereferenceable(16) %0, i32 %1) {
entry:
  %old = alloca i32, align 4
  %amount = alloca i32, align 4
  store i32 %1, ptr %amount, align 4
  %amount1 = load i32, ptr %amount, align 4
  %2 = icmp sgt i32 %amount1, 0
  %3 = zext i1 %2 to i32
  %contract.ok = icmp ne i32 %3, 0
  br i1 %contract.ok, label %contract.cont, label %contract.fail

contract.fail:                                    ; preds = %entry
  %amount2 = load i32, ptr %amount, align 4
  %contract.l = sext i32 %amount2 to i64
  call void @__polaron_fail(ptr @.contract.14, ptr @.cl.15, i64 %contract.l, ptr @.cr.16, i64 0, i32 1)
  unreachable

contract.cont:                                    ; preds = %entry
  %amount3 = load i32, ptr %amount, align 4
  %balance = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance4 = load i32, ptr %balance, align 4, !tbaa !4
  %4 = icmp sle i32 %amount3, %balance4
  %5 = zext i1 %4 to i32
  %contract.ok5 = icmp ne i32 %5, 0
  br i1 %contract.ok5, label %contract.cont7, label %contract.fail6

contract.fail6:                                   ; preds = %contract.cont
  %amount8 = load i32, ptr %amount, align 4
  %balance9 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance10 = load i32, ptr %balance9, align 4, !tbaa !4
  %contract.l11 = sext i32 %amount8 to i64
  %contract.r = sext i32 %balance10 to i64
  call void @__polaron_fail(ptr @.contract.17, ptr @.cl.18, i64 %contract.l11, ptr @.cr.19, i64 %contract.r, i32 1)
  unreachable

contract.cont7:                                   ; preds = %contract.cont
  %balance12 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance13 = load i32, ptr %balance12, align 4, !tbaa !4
  %6 = icmp sge i32 %balance13, 0
  %7 = zext i1 %6 to i32
  %inv.assume = icmp ne i32 %7, 0
  call void @llvm.assume(i1 %inv.assume)
  %balance14 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance15 = load i32, ptr %balance14, align 4, !tbaa !4
  store i32 %balance15, ptr %old, align 4
  %balance16 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance17 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance18 = load i32, ptr %balance17, align 4, !tbaa !4
  %amount19 = load i32, ptr %amount, align 4
  %8 = sub i32 %balance18, %amount19
  store i32 %8, ptr %balance16, align 4, !tbaa !4
  %balance20 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance21 = load i32, ptr %balance20, align 4, !tbaa !4
  %old22 = load i32, ptr %old, align 4
  %amount23 = load i32, ptr %amount, align 4
  %9 = sub i32 %old22, %amount23
  %10 = icmp eq i32 %balance21, %9
  %11 = zext i1 %10 to i32
  %contract.ok24 = icmp ne i32 %11, 0
  br i1 %contract.ok24, label %contract.cont26, label %contract.fail25

contract.fail25:                                  ; preds = %contract.cont7
  call void @__polaron_fail(ptr @.contract.20, ptr null, i64 0, ptr null, i64 0, i32 1)
  unreachable

contract.cont26:                                  ; preds = %contract.cont7
  %balance27 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance28 = load i32, ptr %balance27, align 4, !tbaa !4
  %12 = icmp sge i32 %balance28, 0
  %13 = zext i1 %12 to i32
  %contract.ok29 = icmp ne i32 %13, 0
  br i1 %contract.ok29, label %contract.cont31, label %contract.fail30

contract.fail30:                                  ; preds = %contract.cont26
  %balance32 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance33 = load i32, ptr %balance32, align 4, !tbaa !4
  %contract.l34 = sext i32 %balance33 to i64
  call void @__polaron_fail(ptr @.contract.21, ptr @.cl.22, i64 %contract.l34, ptr @.cr.23, i64 0, i32 1)
  unreachable

contract.cont31:                                  ; preds = %contract.cont26
  ret void
}

define internal i32 @Account.getBalance(ptr nonnull align 8 dereferenceable(16) %0) {
entry:
  %balance = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance1 = load i32, ptr %balance, align 4, !tbaa !4
  %1 = icmp sge i32 %balance1, 0
  %2 = zext i1 %1 to i32
  %inv.assume = icmp ne i32 %2, 0
  call void @llvm.assume(i1 %inv.assume)
  %balance2 = getelementptr inbounds %class.Account, ptr %0, i32 0, i32 1
  %balance3 = load i32, ptr %balance2, align 4, !tbaa !4
  ret i32 %balance3
}

define i32 @main(i32 %0, ptr %1) {
entry:
  %a = alloca ptr, align 8
  %Account.obj = alloca %class.Account, align 8
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
  call void @Account.Account(ptr %Account.obj, i32 100)
  store ptr %Account.obj, ptr %a, align 8
  %a1 = load ptr, ptr %a, align 8
  call void @Account.deposit(ptr %a1, i32 50)
  %a2 = load ptr, ptr %a, align 8
  call void @Account.withdraw(ptr %a2, i32 30)
  %a3 = load ptr, ptr %a, align 8
  %16 = call i32 @Account.getBalance(ptr %a3)
  %17 = call i32 (ptr, ...) @printf(ptr @.str, i32 %16)
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
  %strcpy = call ptr @__polaron_str_copy(ptr @.strobj.5332)
  %0 = load ptr, ptr @Test.criterion, align 8
  call void @__polaron_str_free(ptr %0)
  store ptr %strcpy, ptr @Test.criterion, align 8
  %strcpy1 = call ptr @__polaron_str_copy(ptr @.strobj.5334)
  %1 = load ptr, ptr @Test.skipWhy, align 8
  call void @__polaron_str_free(ptr %1)
  store ptr %strcpy1, ptr @Test.skipWhy, align 8
  ret void
}

; Function Attrs: cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite)
declare void @__polaron_fail(ptr nocapture readonly, ptr nocapture readonly, i64, ptr nocapture readonly, i64, i32) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

declare noalias ptr @__polaron_malloc(i64)

declare i64 @strlen(ptr)

declare i32 @printf(ptr, ...)

declare ptr @memcpy(ptr, ptr, i64)

declare void @__polaron_str_free(ptr)

declare ptr @__polaron_str_copy(ptr)

attributes #0 = { cold noreturn nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }

!0 = !{!1, !1, i64 0}
!1 = !{!"ptr", !2, i64 0}
!2 = !{!"polaron char", !3, i64 0}
!3 = !{!"polaron TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"i32", !2, i64 0}
