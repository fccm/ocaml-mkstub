#if defined(__GCCXML__)

#define __in __attribute((gccxml("in")))
#define __out __attribute((gccxml("out")))
#define __ig __attribute((gccxml("ignore")))
#define _deflt_ __attribute((gccxml("default")))
#define __export __attribute((gccxml("export")))
#define __len __attribute((gccxml("len")))
#define __len_p0 __attribute((gccxml("len_p0")))
#define __len_p1 __attribute((gccxml("len_p1")))
#define __len_p2 __attribute((gccxml("len_p2")))
#define __len_p3 __attribute((gccxml("len_p3")))

#else

#define __in
#define __out
#define __export
#define __len
#define __len_p0
#define __len_p1
#define __len_p2
#define __len_p3

#endif

typedef enum
{
    BLENDMODE_NONE  = 0x0000,
    BLENDMODE_BLEND = 0x0001,
    BLENDMODE_ADD   = 0x0002,
    BLENDMODE_MOD   = 0x0004,
} blendMode;
// __default

typedef struct
{
    float left;
    float top;
    float width;
    __ig float height;
} floatRect;

void myfunc();
int myfunc_c();
int myfunc_add(int p1, int p2);
int myfunc_ii(int);
int myfunc_blend(blendMode);
float myfunc_st(floatRect);

__export void myfunc_wei(__in int p, __out int *ret);

int myfunc_arr(__len int n, __len_p0 int *arr);
