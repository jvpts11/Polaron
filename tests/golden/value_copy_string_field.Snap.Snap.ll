define internal void @Snap.Snap(ptr nonnull align 8 dereferenceable(16) %_, ptr nonnull align 8 %_, i32 %_) #0 {
entry:
 %r = alloca i32, align 4
 %t = alloca ptr, align 8
 %this = alloca ptr, align 8
 store ptr %_, ptr %this, align 8
 store ptr %_, ptr %t, align 8
 store i32 %_, ptr %r, align 4
 %_ = load ptr, ptr %this, align 8
 %text = getelementptr inbounds %class.Snap, ptr %_, i32 0, i32 0
 store ptr null, ptr %text, align 8, !tbaa !0
 %_ = load ptr, ptr %t, align 8
 %_ = load ptr, ptr %this, align 8
 %text1 = getelementptr inbounds %class.Snap, ptr %_, i32 0, i32 0
 %_ = call ptr @__polaron_str_copy(ptr %_)
 %_ = load ptr, ptr %text1, align 8, !tbaa !0
 call void @__polaron_str_free(ptr %_)
 store ptr %_, ptr %text1, align 8, !tbaa !0
 %_ = load i32, ptr %r, align 4
 %_ = load ptr, ptr %this, align 8
 %row = getelementptr inbounds %class.Snap, ptr %_, i32 0, i32 1
 store i32 %_, ptr %row, align 4, !tbaa !4
 ret void
}
