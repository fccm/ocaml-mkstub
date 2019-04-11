union {
    char b[20];
    short s[10];
    long l[5];
} my_un1;

typedef union
{
    char size[16];
    long int align;
} my_un2;

#if defined(__GCCXML__)

#define _annot_a  __attribute((gccxml("annot_A")))
#define _annot_b1 __attribute((gccxml("annot_B1")))
#define _annot_b2 __attribute((gccxml("annot_B2")))

#else

#define _annot_a
#define _annot_b1
#define _annot_b2

#endif

typedef union
{
    _annot_a int field_a;
    _annot_b1 _annot_b2 char *field_b;
} my_un3;

