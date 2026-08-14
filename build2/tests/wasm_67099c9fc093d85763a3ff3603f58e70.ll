; ModuleID = 'C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wasm_pure_math.pol'
source_filename = "C:/Users/jvpts/Documents/GitHub/LDP3/tests/samples/wasm_pure_math.pol"
target datalayout = "e-m:e-p:32:32-p10:8:8-p20:8:8-i64:64-i128:128-n32:64-S128-ni:1:10:20"
target triple = "wasm32-unknown-unknown"

; Function Attrs: noredzone
define internal i64 @Squares.sumTo(i32 %0) #0 {
entry:
  %i = alloca i32, align 4
  %sum = alloca i64, align 8
  %n = alloca i32, align 4
  store i32 %0, ptr %n, align 4
  store i64 0, ptr %sum, align 8
  store i32 1, ptr %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %i1 = load i32, ptr %i, align 4
  %n2 = load i32, ptr %n, align 4
  %1 = icmp sle i32 %i1, %n2
  %2 = zext i1 %1 to i32
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %sum3 = load i64, ptr %sum, align 8
  %i4 = load i32, ptr %i, align 4
  %i5 = load i32, ptr %i, align 4
  %3 = mul i32 %i4, %i5
  %4 = sext i32 %3 to i64
  %5 = add i64 %sum3, %4
  store i64 %5, ptr %sum, align 8
  %i6 = load i32, ptr %i, align 4
  %6 = add i32 %i6, 1
  store i32 %6, ptr %i, align 4
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %sum7 = load i64, ptr %sum, align 8
  ret i64 %sum7
}

; Function Attrs: noredzone
define i32 @kmain(ptr %0) #0 {
entry:
  %args = alloca ptr, align 4
  store ptr %0, ptr %args, align 4
  %1 = call i64 @Squares.sumTo(i32 100)
  ret i32 0
}

attributes #0 = { noredzone }
