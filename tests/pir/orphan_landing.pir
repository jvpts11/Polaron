module "x86_64-pc-windows-msvc" bundle "OrphanLanding" {
  fn @Orphan.main() -> void linkage(public) conv(polaron) kind(method) unwind(may) {
  ^entry():
    ret
  ^landing0():
    %0:exc = landing ptr
    ret
  }
}

