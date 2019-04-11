#ifndef _GEN_CAML_DECLAR
#define _GEN_CAML_DECLAR

#define CAMLlocal0()

/* Handle the return of the wrapped C function */

#define R_DEC_int(v) int v
#define R_DEC_short(v) short v
#define R_DEC_long(v) long v
#define R_DEC_float(v) float v
#define R_DEC_double(v) double v
#define R_DEC_unsigned_int(v) unsigned int v


/* Parameters Declarations */

#define DEC_int(r) int r
#define DEC_short(r) short r
#define DEC_long(r) long r
#define DEC_float(r) float r
#define DEC_double(r) double r
#define DEC_unsigned_int(r) unsigned int r
#define DEC_CONST_PTR_char(r) char *r
#define DEC_PTR_CONST_char(r) char *r


#endif // _GEN_CAML_DECLAR
