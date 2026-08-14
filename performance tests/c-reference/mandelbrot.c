/* C reference for mandelbrot.pol -- same grid, same maxIter, same escape test, same checksum. */
#include <stdio.h>
int main(void) {
    const int w = 1200, h = 1200, maxIter = 1000;
    int total = 0;
    for (int py = 0; py < h; py++) {
        for (int px = 0; px < w; px++) {
            double cr = (double)px / (double)w * 3.5 - 2.5;
            double ci = (double)py / (double)h * 2.0 - 1.0;
            double zr = 0.0, zi = 0.0;
            int it = 0, escaped = 0;
            while (it < maxIter && escaped == 0) {
                double zr2 = zr * zr, zi2 = zi * zi;
                if (zr2 + zi2 > 4.0) { escaped = 1; }
                else { zi = 2.0 * zr * zi + ci; zr = zr2 - zi2 + cr; it = it + 1; }
            }
            total = (total + it) % 1000000007;
        }
    }
    printf("checksum=%d\n", total);
    return 0;
}
