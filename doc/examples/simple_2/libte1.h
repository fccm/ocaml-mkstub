#if defined(__GCCXML__)

#define __in  __attribute((gccxml("in")))
#define __out __attribute((gccxml("out")))

#define __len_is(i) __attribute((gccxml("len_is_p" #i)))
#define __len_of(i) __attribute((gccxml("len_of_p" #i)))

#else

#define __in
#define __out
#define __len_is(i)
#define __len_of(i)

#endif

typedef enum {
    MODE_A = 0x0000,
    MODE_B = 0x0001,
    MODE_C = 0x0002,
    MODE_D = 0x0004,
} mode;

typedef struct {
    float left;
    float top;
    float width;
    float height;
} rect;

void func();
int func_c();
int func_add(int p1, int p2);
int func_ii(int);
int func_blend(mode);
float func_st(rect);

void func_wei(__in int p, __out int *ret);
void func_io(__in __out int *p);
void func_iom(__out int *p1, __out int *p2, __out int *p3, __out int *p4);

int func_arr(__len_of(1) int n, __len_is(0) int *arr);
