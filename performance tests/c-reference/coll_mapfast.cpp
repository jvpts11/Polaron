/* The REAL bar for a hash map, not std::unordered_map.
   unordered_map is node-based by mandate (the standard requires reference stability), which is why
   it is the slow member of the family. Polaron's HashMap is open addressing -- the FAST family -- so
   the honest reference is a well-implemented flat map of that same family. Two of them here:
   phmap::flat_hash_map (the Abseil design) and robin_hood::unordered_flat_map.
   Same workload as coll_map.pol, same checksum. */
#include <cstdio>
#include <cstring>
#include <parallel_hashmap/phmap.h>
#include <robin_hood.h>

template <typename M> int run(const char* name) {
    M m;
    for (int i = 0; i < 200000; i++) m[i] = i * 7;
    int acc = 0;
    for (int i = 0; i < 200000; i++) acc = (acc + m[i]) % 1000000007;
    std::printf("acc=%d\n", acc);
    (void)name;
    return acc;
}

int main(int argc, char** argv) {
    const char* which = argc > 1 ? argv[1] : "phmap";
    if (std::strcmp(which, "robin") == 0) run<robin_hood::unordered_flat_map<int,int>>("robin");
    else                                  run<phmap::flat_hash_map<int,int>>("phmap");
    return 0;
}
