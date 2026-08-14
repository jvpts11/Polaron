#include <cstdio>
#include <unordered_map>
int main(){ std::unordered_map<int,int> m; for(int i=0;i<4000000;i++) m[i]=i*7;
  int acc=0; for(int i=0;i<4000000;i++) acc=(acc+m[i])%1000000007;
  std::printf("acc=%d\n",acc); return 0; }
