define internal i32 @Holder.fieldOffCall(ptr nonnull align 4 dereferenceable(4) %_) #0 {
entry:
 %this = alloca ptr, align 8
 store ptr %_, ptr %this, align 8
 %_ = load ptr, ptr %this, align 8
 %_ = call ptr @Holder.table(ptr %_)
 %n = getelementptr inbounds %class.Holder, ptr %_, i32 0, i32 0
 %_ = load i32, ptr %n, align 4, !tbaa !0
 ret i32 %_
}
