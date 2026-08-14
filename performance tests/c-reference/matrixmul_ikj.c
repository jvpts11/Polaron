/* The SAME computation as matrixmul.c with the two inner loops interchanged (ijk -> ikj).
   The point of this file is not to be a faster benchmark -- it is to answer one question:
   does the ijk->ikj interchange alone let LLVM vectorize what it otherwise leaves scalar?
   If it does, the interchange belongs in the Polaron compiler, because our backend will not
   discover it and GCC's does. */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    const int n = 512;
    double *a = malloc((size_t)n * n * sizeof(double));
    double *b = malloc((size_t)n * n * sizeof(double));
    double *c = malloc((size_t)n * n * sizeof(double));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            a[i * n + j] = (double)((i + j) % 100) * 0.5;
            b[i * n + j] = (double)((i * j) % 100) * 0.25;
        }
    }
    for (int i = 0; i < n * n; i++) c[i] = 0.0;
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            const double r = a[i * n + k];            /* loop-invariant in j */
            for (int j = 0; j < n; j++) {
                c[i * n + j] += r * b[k * n + j];      /* both contiguous in j */
            }
        }
    }
    int acc = 0;
    for (int i = 0; i < n * n; i++) {
        acc = (acc + (int)c[i]) % 1000000007;
    }
    printf("checksum=%d\n", acc);
    free(a); free(b); free(c);
    return 0;
}
