/* C++ reference for virtualcall.pol -- the same interface, the same two implementations, the same
   alternating fill so neither compiler can devirtualize the call. */
#include <cstdio>
#include <vector>

struct Shape { virtual int area() const = 0; virtual ~Shape() {} };
struct Square : Shape { int s; Square(int s) : s(s) {} int area() const override { return s * s; } };
struct Rect : Shape { int w, h; Rect(int w, int h) : w(w), h(h) {} int area() const override { return w * h; } };

int main() {
    const int n = 2000;
    std::vector<Shape*> shapes(n);
    for (int i = 0; i < n; i++) {
        if (i % 2 == 0) shapes[i] = new Square(i % 50);
        else shapes[i] = new Rect(i % 30, i % 40);
    }
    int acc = 0;
    for (int r = 0; r < 20000; r++)
        for (int i = 0; i < n; i++)
            acc = (acc + shapes[i]->area()) % 1000000007;
    std::printf("acc=%d\n", acc);
    return 0;
}
