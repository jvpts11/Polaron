define internal %__polaron_variant @Main.makeValue(i32 %_) #0 {
entry:
 %x = alloca i32, align 4
 store i32 %_, ptr %x, align 4
 %_ = load i32, ptr %x, align 4
 %_ = icmp slt i32 %_, 0
 br i1 %_, label %then0, label %else1

then0: ; preds = %entry
 ret %__polaron_variant { i32 1, i64 1 }

else1: ; preds = %entry
 br label %join2

join2: ; preds = %else1
 %_ = load i32, ptr %x, align 4
 %var.enc.i = zext i32 %_ to i64
 %var.val = insertvalue %__polaron_variant { i32 0, i64 undef }, i64 %var.enc.i, 1
 ret %__polaron_variant %var.val
}
