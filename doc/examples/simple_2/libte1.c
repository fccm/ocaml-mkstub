#include "try1.h"

static int count = 0;
void func()
{
    count++;
}

int func_c()
{
    return count;
}

int func_ii(int p)
{
    return (p+3);
}

int func_add(int p1, int p2)
{
    return (p1 + p2);
}

int func_blend(blendMode p)
{
    int r;
    switch (p) {
        case BLENDMODE_NONE : r = 2; break;
        case BLENDMODE_BLEND: r = 4; break;
        case BLENDMODE_ADD  : r = 6; break;
        case BLENDMODE_MOD  : r = 8; break;
    }
    return r;
}

float func_st(floatRect p)
{
    float r;
    float tot = 0;
    tot += p.left;
    tot += p.top;
    tot += p.width;
    tot += p.height;
    r = tot;
    return r;
}

void func_wei(int p, int *ret)
{
    *ret = p * 2;
}

int func_arr(int n, int *arr)
{
    int i;
    int tot = 0;
    for (i=0; i<n; i++) {
        tot += arr[i];
    }
    return tot;
}

void func_io( /* in and out */ int *p)
{
    int _p = *p;
    int _res = _p * _p;
    *p = _res;
}

void func_iom(int *p1, int *p2, int *p3, int *p4)
{
    const int n = 6;
    int i;
    p1 = malloc(n * sizeof(int));
    p2 = malloc(n * sizeof(int));
    p3 = malloc(n * sizeof(int));
    p4 = malloc(n * sizeof(int));
    for (i = 0; i < n; i++)
    {
        int j = i + 1;
        p1[i] = i;
        p2[i] = j;
        p3[i] = j * j;
        p4[i] = j * j * j;
    }
}
