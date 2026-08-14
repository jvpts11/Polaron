/* mandelbrot.c with the `escaped` flag replaced by a direct break -- the SAME computation and the
   same checksum. The flag is a loop-carried boolean that, once set, does nothing but end the loop.
   If clang reaches GCC's time here, then "eliminate an exit flag" is the transform GCC applies and
   LLVM does not, and it belongs in Polaron's middle end. */
#include <stdio.h>
int main(void) {
    const int w = 1200, h = 1200, maxIter = 1000;
    int total = 0;
    for (int py = 0; py < h; py++) {
        for (int px = 0; px < w; px++) {
            double cr = (double)px / (double)w * 3.5 - 2.5;
            double ci = (double)py / (double)h * 2.0 - 1.0;
            double zr = 0.0, zi = 0.0;
            int it = 0;
            while (it < maxIter) {
                double zr2 = zr * zr, zi2 = zi * zi;
                if (zr2 + zi2 > 4.0) break;
                zi = 2.0 * zr * zi + ci; zr = zr2 - zi2 + cr; it = it + 1;
            }
            total = (total + it) % 1000000007;
        }
    }
    printf("checksum=%d\n", total);
    return 0;
}
