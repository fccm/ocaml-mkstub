#if defined(__GCCXML__)

#define __in  __attribute((gccxml("in")))
#define __out __attribute((gccxml("out")))

#define __len_is(i) __attribute((gccxml("len_is_p" #i "")))
#define __len_of(i) __attribute((gccxml("len_of_p" #i "")))

#else

#define __in
#define __out
#define __len_is(i)
#define __len_of(i)

#endif

typedef enum {
    MODE_A,
    MODE_B,
    MODE_C,
} mode;

typedef struct {
    float width;
    float height;
} rect;

void fun_void();
int fun_p(int p1, int p2);

int fun_enum(mode);
float fun_struct(rect);

void fun_io(__in int p, __out int *ret);
void fun_io_same(__in __out int *p);

void fun_outs( __out int *r1, __out int *r2, __out int *r3);
int fun_outs2( __out int *r1, __out int *r2, __out int *r3);
int fun_outs3( __out int *, __out int *, __out int *);

int fun_arr(__len_of(1) int n, __len_is(0) int *arr);
