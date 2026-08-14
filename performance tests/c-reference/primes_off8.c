/* primes.c with the data pointer deliberately offset by 8 bytes from the allocation, which is where
   a Polaron `boolean[]` puts its elements: the array header (the length) occupies the first 8 bytes,
   so `arr.data == malloc + 8`. If GCC slows to Polaron's number here, the deficit is that offset --
   an alignment problem in our array layout, not a codegen one. */
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    const int n = 20000000;
    unsigned char *base = calloc((size_t)n + 8, 1);
    unsigned char *sieve = base + 8;          /* exactly Polaron's data pointer */
    int count = 0;
    for (int i = 2; i < n; i++) {
        if (sieve[i] == 0) {
            count = count + 1;
            for (int j = i + i; j < n; j = j + i) sieve[j] = 1;
        }
    }
    printf("primes=%d\n", count);
    free(base);
    return 0;
}
