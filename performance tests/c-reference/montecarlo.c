/* C reference for montecarlo.pol -- 50M points, the same uint32 LCG, same wrap-around. */
#include <stdio.h>
int main(void) {
    const int n = 50000000;
    unsigned int s = 12345u;
    int inside = 0;
    for (int i = 0; i < n; i++) {
        s = s * 1103515245u + 12345u;
        double x = (double)(s >> 16) / 65536.0;
        s = s * 1103515245u + 12345u;
        double y = (double)(s >> 16) / 65536.0;
        if (x * x + y * y <= 1.0) inside = inside + 1;
    }
    printf("inside=%d\n", inside);
    return 0;
}
