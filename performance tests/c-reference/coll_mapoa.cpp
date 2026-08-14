/* O MESMO algoritmo do HashMap da Polaron -- endereçamento aberto, três arrays paralelos, crescimento
   a 75% quadruplicando, capacidade inicial 8, ocupação num byte -- escrito à mão em C++. Separa duas
   perguntas que o std::unordered_map confunde: a nossa ESTRUTURA é pior, ou o nosso CÓDIGO GERADO é
   pior?

   A RESPOSTA, medida 2026-08-13 com a carga já ACIMA do chão de medição: 28,4 ms aqui contra 40,7 ms
   nossos, ou seja **0,70**. É ESTE o número do código gerado.

   ATENÇÃO AO CHÃO. Com os 200 000 originais este ficheiro corria em ~5 ms e o nosso em ~6 -- e um
   programa VAZIO, medido do mesmo modo, dá 5,7 e 6,5. A carga inteira estava DEBAIXO do ruído de
   arranque do processo, por isso os rácios que saíam daqui (0,80, 0,90) não mediam o mapa: mediam o
   custo de lançar um processo. Foi por isso que três otimizações bem argumentadas mediram exatamente
   zero. A carga foi multiplicada por 20 para que o mapa domine. */
#include <cstdio>
#include <cstdlib>
#include <cstring>

struct Map {
    int *keys = nullptr, *values = nullptr;
    unsigned char *used = nullptr;
    int count = 0, cap = 8;
    Map() { keys = (int*)calloc(cap, 4); values = (int*)calloc(cap, 4); used = (unsigned char*)calloc(cap, 1); }
    int slotFor(int key) const {
        int mask = cap - 1, i = key & mask;
        while (used[i]) { if (keys[i] == key) return i; i = (i + 1) & mask; }
        return i;
    }
    void grow() {
        int oldCap = cap; int *oK = keys, *oV = values; unsigned char *oU = used;
        // QUADRUPLE, like the Polaron HashMap does. This said `* 2` while ours said `* 4`, so the
        // "same algorithm" reference was doing twice as many rehashes as the thing it was measuring.
        // The point of this file is a like-for-like comparison; a growth factor is part of "like".
        cap = oldCap * 4;
        keys = (int*)calloc(cap, 4); values = (int*)calloc(cap, 4); used = (unsigned char*)calloc(cap, 1);
        int mask = cap - 1;
        for (int j = 0; j < oldCap; j++) if (oU[j]) {
            int i = oK[j] & mask;
            while (used[i]) i = (i + 1) & mask;
            used[i] = 1; keys[i] = oK[j]; values[i] = oV[j];
        }
        free(oK); free(oV); free(oU);
    }
    void put(int key, int value) {
        if ((count + 1) * 4 >= cap * 3) grow();
        int i = slotFor(key);
        if (!used[i]) { used[i] = 1; count++; }
        keys[i] = key; values[i] = value;
    }
    int get(int key) const { int i = slotFor(key); return used[i] ? values[i] : 0; }
};

int main() {
    Map m;
    for (int i = 0; i < 4000000; i++) m.put(i, i * 7);
    int acc = 0;
    for (int i = 0; i < 4000000; i++) acc = (acc + m.get(i)) % 1000000007;
    std::printf("acc=%d\n", acc);
    return 0;
}
