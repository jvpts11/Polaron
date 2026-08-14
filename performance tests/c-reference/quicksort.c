/* C reference for quicksort.pol -- same Hoare partition, same LCG-generated input, same
   every-1000th checksum. */
#include <stdio.h>
#include <stdlib.h>
static void qsort_h(int *a, int lo, int hi) {
    if (lo >= hi) return;
    int pivot = a[(lo + hi) / 2];
    int i = lo, j = hi;
    while (i <= j) {
        while (a[i] < pivot) i = i + 1;
        while (a[j] > pivot) j = j - 1;
        if (i <= j) { int t = a[i]; a[i] = a[j]; a[j] = t; i = i + 1; j = j - 1; }
    }
    qsort_h(a, lo, j);
    qsort_h(a, i, hi);
}
int main(void) {
    const int n = 5000000;
    int *a = malloc((size_t)n * sizeof(int));
    unsigned int s = 12345u;
    for (int k = 0; k < n; k++) { s = s * 1103515245u + 12345u; a[k] = (int)(s >> 16); }
    qsort_h(a, 0, n - 1);
    int acc = 0;
    for (int k = 0; k < n; k = k + 1000) acc = (acc + a[k]) % 1000000007;
    printf("checksum=%d\n", acc);
    free(a);
    return 0;
}
