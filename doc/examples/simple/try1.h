#if defined(__GCCXML__)

#define __in  __attribute((gccxml("in")))
#define __out __attribute((gccxml("out")))
#define __ig  __attribute((gccxml("ignore")))
#define __default __attribute((gccxml("default")))
#define __export  __attribute((gccxml("export")))
#define __len    __attribute((gccxml("len")))
#define __len_p0 __attribute((gccxml("len_p0")))
#define __len_p1 __attribute((gccxml("len_p1")))
#define __len_p2 __attribute((gccxml("len_p2")))
#define __len_p3 __attribute((gccxml("len_p3")))

#define __len_is(i) __attribute((gccxml("len_is_p" #i "")))
#define __len_of(i) __attribute((gccxml("len_of_p" #i "")))

#else

#define __in
#define __out
#define __ig
#define __default
#define __export
#define __len
#define __len_p0
#define __len_p1
#define __len_p2
#define __len_p3
#define __len_is(i)
#define __len_of(i)

#endif

typedef enum {
    // __default
    BLENDMODE_NONE  = 0x0000,
    BLENDMODE_BLEND = 0x0001,
    BLENDMODE_ADD   = 0x0002,
    BLENDMODE_MOD   = 0x0004,
} blendMode;

typedef struct {
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
void myfunc_io(__in __out int *p);

int myfunc_arr(__len_of(1) int n, __len_is(0) int *arr);
