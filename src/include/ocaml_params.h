#ifndef _GEN_CAML_PARAMS
#define _GEN_CAML_PARAMS


#define CAMLparam6(p1, p2, p3, p4, p5, p6) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam1(p6)

#define CAMLparam7(p1, p2, p3, p4, p5, p6, p7) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam2(p6, p7)

#define CAMLparam8(p1, p2, p3, p4, p5, p6, p7, p8) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam3(p6, p7, p8)

#define CAMLparam9(p1, p2, p3, p4, p5, p6, p7, p8, p9) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam4(p6, p7, p8, p9)

#define CAMLparam10(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10)

#define CAMLparam11(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam1(p11)

#define CAMLparam12(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam2(p11, p12)

#define CAMLparam13(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam3(p11, p12, p13)

#define CAMLparam14(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam4(p11, p12, p13, p14)

#define CAMLparam15(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam5(p11, p12, p13, p14, p15)

#define CAMLparam16(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam5(p11, p12, p13, p14, p15); \
    CAMLxparam1(p16)

#define CAMLparam17(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15, \
      p16,p17) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam5(p11, p12, p13, p14, p15); \
    CAMLxparam2(p16, p17)

#define CAMLparam18(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15, \
      p16,p17,p18) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam5(p11, p12, p13, p14, p15); \
    CAMLxparam3(p16, p17, p18)

#define CAMLparam19(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15, \
      p16,p17,p18,p19) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam5(p11, p12, p13, p14, p15); \
    CAMLxparam4(p16, p17, p18, p19)

#define CAMLparam20(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15, \
      p16,p17,p18,p19,p20) \
    CAMLparam5(p1, p2, p3, p4, p5); \
    CAMLxparam5(p6, p7, p8, p9, p10); \
    CAMLxparam5(p11, p12, p13, p14, p15); \
    CAMLxparam5(p16, p17, p18, p19, p20)


#endif // _GEN_CAML_PARAMS
