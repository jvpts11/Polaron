/* C reference for primes.pol -- sieve of Eratosthenes to 20M over a byte array, as Polaron's
   `boolean[]` is a byte per element. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void) {
    const int n = 20000000;
    unsigned char *sieve = calloc((size_t)n, 1);
    int count = 0;
    for (int i = 2; i < n; i++) {
        if (sieve[i] == 0) {
            count = count + 1;
            for (int j = i + i; j < n; j = j + i) sieve[j] = 1;
        }
    }
    printf("primes=%d\n", count);
    free(sieve);
    return 0;
}
