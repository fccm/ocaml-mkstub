// simple functions

void f1();
int f2(int);
int f3(int p);
double f4(float p1, float p2, float p3);
int * f5(int *p1, float *p2);
char * f6(char *p);

// test array with given size

int f7(int arr[16]);

// test annotations

#if defined(__GCCXML__)

#define _annot_ret  __attribute((gccxml("annot_ret")))
#define _annot_p1   __attribute((gccxml("annot_p1")))
#define _annot_p2_a __attribute((gccxml("annot_p2_a")))
#define _annot_p2_b __attribute((gccxml("annot_p2_b")))

#else

#define _annot_ret
#define _annot_p1
#define _annot_p2_a
#define _annot_p2_b

#endif

_annot_ret int f8(
    _annot_p1 int p1,
    _annot_p2_a _annot_p2_b int p2);


#if defined(__GCCXML__)

#define _annot_s1(s)  __attribute((gccxml("annot_s_" s)))
#define _annot_s2(s)  __attribute((gccxml("annot_s_" #s)))

#else

#define _annot_s1(s)
#define _annot_s2(s)

#endif

_annot_ret int f9(
    _annot_s1("Hello") int s1,
    _annot_s2(Hello) int s2);

