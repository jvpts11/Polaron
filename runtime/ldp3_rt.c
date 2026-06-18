// LDP3 minimal runtime.
// Graph-identity tables for persistent serialization: dedup shared objects (DAGs) and break
// cycles. The compiler emits calls to these from __ldp3_ser_* / __ldp3_deser_*.
#include <stddef.h>

#define LDP3_GRAPH_CAP 4096

static void* ldp3_seen[LDP3_GRAPH_CAP];  // save side: objects in first-seen order
static int   ldp3_seen_n = 0;
static void* ldp3_made[LDP3_GRAPH_CAP];  // load side: objects by id (same order)
static int   ldp3_made_n = 0;

// Cleared at the start of each save and each load.
void __ldp3_graph_reset(void) {
    ldp3_seen_n = 0;
    ldp3_made_n = 0;
}

// Save side: if x was already serialized, return its id (>= 0). Otherwise record it (so a later
// reference -- including a cycle back to x -- finds it) and return -(id)-1 to signal "new".
int __ldp3_intern(void* x) {
    for (int i = 0; i < ldp3_seen_n; i++) {
        if (ldp3_seen[i] == x) return i;
    }
    int id = ldp3_seen_n++;
    ldp3_seen[id] = x;
    return -id - 1;
}

// Load side: objects are registered in first-seen order, matching the save side's ids.
void  __ldp3_made_add(void* obj) { ldp3_made[ldp3_made_n++] = obj; }
void* __ldp3_made_at(int id)     { return ldp3_made[id]; }
