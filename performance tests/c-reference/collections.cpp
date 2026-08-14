/* C++ reference for collections.pol -- std::vector and std::unordered_map, the containers a C++
   programmer actually reaches for, against Polaron's ArrayList and HashMap. */
#include <cstdio>
#include <vector>
#include <unordered_map>

int main() {
    const int n = 20000000;
    std::vector<int> list;
    for (int i = 0; i < n; i++) list.push_back(i * 3 % 1000);
    int acc = 0;
    for (int i = 0; i < n; i++) acc = (acc + list[i]) % 1000000007;
    std::unordered_map<int,int> map;
    for (int i = 0; i < 4000000; i++) map[i] = i * 7;
    for (int i = 0; i < 4000000; i++) acc = (acc + map[i]) % 1000000007;
    std::printf("acc=%d size=%d\n", acc, (int)list.size());
    return 0;
}
