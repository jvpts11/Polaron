/* C++ reference for strings.pol -- same loop, same pieces, same checksum. std::string with
   reserve-free append is the idiomatic equivalent of Polaron's StringBuilder. */
#include <cstdio>
#include <string>

int main() {
    const int n = 200000;
    int acc = 0;
    for (int i = 0; i < n; i++) {
        std::string s;
        s += "item-";
        s += std::to_string(i);
        s += "-of-";
        s += std::to_string(n);
        acc = (acc + (int)s.size()) % 1000000007;
        if (s == "item-0-of-200000") acc = (acc + 7) % 1000000007;
    }
    std::printf("acc=%d\n", acc);
    return 0;
}
