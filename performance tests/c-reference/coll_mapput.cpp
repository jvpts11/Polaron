#include <cstdio>
#include <unordered_map>
int main(){ std::unordered_map<int,int> m; for(int i=0;i<4000000;i++) m[i]=i*7;
  std::printf("acc=%d\n",m[3999999]); return 0; }
