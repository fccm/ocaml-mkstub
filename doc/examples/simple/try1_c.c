#include "try1.h"

static int count = 0;
void myfunc()
{
    count++;
}

int myfunc_c()
{
    return count;
}

int myfunc_ii(int p)
{
    return (p+3);
}

int myfunc_add(int p1, int p2)
{
    return (p1 + p2);
}

int myfunc_blend(blendMode p)
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

float myfunc_st(floatRect p)
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

void myfunc_wei(int p, int *ret)
{
    *ret = p * 2;
}

int myfunc_arr(int n, int *arr)
{
    int i;
    int tot = 0;
    for (i=0; i<n; i++) {
        tot += arr[i];
    }
    return tot;
}

