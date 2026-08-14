/* C reference for binarytrees.pol -- malloc/free per node, which is what the Polaron version does
   with `on heap` + `delete`. Depth 18, thirty times. */
#include <stdio.h>
#include <stdlib.h>
typedef struct Tree { struct Tree *left, *right; } Tree;
static Tree *make(int depth) {
    Tree *t = malloc(sizeof(Tree));
    t->left = NULL; t->right = NULL;
    if (depth > 0) { t->left = make(depth - 1); t->right = make(depth - 1); }
    return t;
}
static int check(Tree *t) {
    if (t->left == NULL) return 1;
    return 1 + check(t->left) + check(t->right);
}
static void freetree(Tree *t) {
    if (t->left != NULL) { freetree(t->left); freetree(t->right); }
    free(t);
}
int main(void) {
    const int depth = 18;
    int total = 0;
    for (int i = 0; i < 30; i++) {
        Tree *t = make(depth);
        total = total + check(t);
        freetree(t);
    }
    printf("nodes=%d\n", total);
    return 0;
}
