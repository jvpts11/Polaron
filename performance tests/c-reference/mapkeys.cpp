/* The same three key distributions as mapkeys.pol, over four maps, selected by argv:
     unordered  std::unordered_map      (node-based, prime buckets, identity hash)
     phmap      phmap::flat_hash_map    (Abseil design: open addressing + MIXED hash)
     robin      robin_hood::unordered_flat_map
   Same sizes, same LCG, same checksums as the Polaron version. */
#include <cstdio>
#include <cstring>
#include <unordered_map>

/* The two best-in-class maps are OPTIONAL, and that is the point of this block.
   They are third-party headers, and when they are absent this file used to fail to compile -- which
   the harness then reported as "no reference", indistinguishable from a benchmark that never had one.
   So the benchmark written specifically to remove the sequential-key bias from the map numbers
   silently compared against nothing, while the biased benchmark kept publishing a ratio.
   std::unordered_map is always here, so a comparison always happens; the sharper ones join in when
   their headers are installed. */
#if defined(__has_include)
#  if __has_include(<parallel_hashmap/phmap.h>)
#    include <parallel_hashmap/phmap.h>
#    define HAVE_PHMAP 1
#  endif
#  if __has_include(<robin_hood.h>)
#    include <robin_hood.h>
#    define HAVE_ROBIN 1
#  endif
#endif

template <typename M> int fill(M& m, int n, int mode) {
    unsigned int s = 12345u;
    int acc = 0;
    for (int i = 0; i < n; i++) {
        int k = i;
        if (mode == 1) { s = s * 1103515245u + 12345u; k = (int)(s >> 8); }
        if (mode == 2) { k = i * 64; }
        m[k] = i;
    }
    s = 12345u;
    for (int i = 0; i < n; i++) {
        int k = i;
        if (mode == 1) { s = s * 1103515245u + 12345u; k = (int)(s >> 8); }
        if (mode == 2) { k = i * 64; }
        acc = (acc + m[k]) % 1000000007;
    }
    return acc;
}

template <typename M> void run() {
    M a; int r0 = fill(a, 2000000, 0);
    M b; int r1 = fill(b, 2000000, 1);
    M c; int r2 = fill(c, 400000, 2);
    std::printf("seq=%d rand=%d patt=%d\n", r0, r1, r2);
}

int main(int argc, char** argv) {
    const char* w = argc > 1 ? argv[1] : "unordered";
#ifdef HAVE_PHMAP
    if (std::strcmp(w, "phmap") == 0) { run<phmap::flat_hash_map<int,int>>(); return 0; }
#endif
#ifdef HAVE_ROBIN
    if (std::strcmp(w, "robin") == 0) { run<robin_hood::unordered_flat_map<int,int>>(); return 0; }
#endif
    /* Asking for a map that was not compiled in SAYS SO on stderr and then measures the one that is,
       rather than quietly measuring something else under the name that was asked for. */
    if (std::strcmp(w, "unordered") != 0) {
        std::fprintf(stderr, "mapkeys: '%s' was not compiled in (header absent); measuring "
                             "std::unordered_map instead\n", w);
    }
    run<std::unordered_map<int,int>>();
    return 0;
}
