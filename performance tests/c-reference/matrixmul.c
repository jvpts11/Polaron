/* The C reference for performance tests/matrixmul.pol -- SAME algorithm, same sizes, same
   checksum, so a difference in time is a difference in generated code and nothing else.
   Kept beside the Polaron source because a benchmark whose reference lives on another machine
   is a benchmark nobody can re-run. */
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
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            double sum = 0.0;
            for (int k = 0; k < n; k++) {
                sum = sum + a[i * n + k] * b[k * n + j];
            }
            c[i * n + j] = sum;
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
