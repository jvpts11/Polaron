/* C reference for regions.pol -- malloc/free per object, which is the idiomatic C a Polaron
   `region` replaces. The Polaron version bump-allocates into an arena it releases whole; this is
   what that costs when the language does not give you one. */
#include <stdio.h>
#include <stdlib.h>
typedef struct { int v; } Cell;
int main(void) {
    const int iters = 2000, per = 20000;
    int total = 0;
    for (int it = 0; it < iters; it++) {
        Cell **kept = malloc((size_t)per * sizeof(Cell *));
        for (int i = 0; i < per; i++) {
            Cell *c = malloc(sizeof(Cell));
            c->v = i;
            total = (total + c->v) % 1000000007;
            kept[i] = c;
        }
        for (int i = 0; i < per; i++) free(kept[i]);
        free(kept);
    }
    printf("total=%d\n", total);
    return 0;
}
