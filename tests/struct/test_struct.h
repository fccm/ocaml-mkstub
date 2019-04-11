struct struct_first {
    int field_a1;
    int field_b1;
    int field_c1;
};

typedef struct {
    int field_a2;
    int field_b2;
    int field_c2;
} struct_second;

typedef struct struct_third {
    int field_a3;
    int field_b3;
    int field_c3;
} struct_third_def;

#if defined(__GCCXML__)

#define _annot_a  __attribute((gccxml("annot_A")))
#define _annot_b  __attribute((gccxml("annot_B")))
#define _annot_c1 __attribute((gccxml("annot_C1")))
#define _annot_c2 __attribute((gccxml("annot_C2")))

#else

#define _annot_a
#define _annot_b
#define _annot_c1
#define _annot_c2

#endif

// test annotations
struct struct_fourth {
    _annot_a int field_a4;
    _annot_b int field_b4;
    _annot_c1 _annot_c2 int field_c4;
};
