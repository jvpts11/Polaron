/* C reference for collatz.pol -- longest chain below 1M, 64-bit arithmetic throughout. */
#include <stdio.h>
int main(void) {
    const int n = 1000000;
    int maxLen = 0, maxStart = 0;
    for (int start = 1; start < n; start++) {
        long long x = (long long)start;
        int len = 0;
        while (x != 1) {
            if (x % 2 == 0) x = x / 2; else x = 3 * x + 1;
            len = len + 1;
        }
        if (len > maxLen) { maxLen = len; maxStart = start; }
    }
    printf("maxLen=%d maxStart=%d\n", maxLen, maxStart);
    return 0;
}
