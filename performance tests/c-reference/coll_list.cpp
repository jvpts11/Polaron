#include <cstdio>
#include <vector>
int main(){ const int n=20000000; std::vector<int> v; for(int i=0;i<n;i++) v.push_back(i*3%1000);
  int acc=0; for(int i=0;i<n;i++) acc=(acc+v[i])%1000000007;
  std::printf("acc=%d size=%d\n",acc,(int)v.size()); return 0; }
