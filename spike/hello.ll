@.fmt = private unnamed_addr constant [15 x i8] c"Resultado: %d\0A\00"
declare i32 @printf(ptr, ...)
define i32 @main() {
  %r = call i32 (ptr, ...) @printf(ptr @.fmt, i32 42)
  ret i32 0
}
