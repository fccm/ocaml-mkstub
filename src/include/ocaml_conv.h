#ifndef _GEN_CAML_CONV
#define _GEN_CAML_CONV


#define conv_double_c2ml(c_v, ml_v)  (*ml_v = caml_copy_double(c_v))
#define conv_double_ml2c(ml_v, c_v)  (*c_v = Double_val(ml_v))

#define conv_float_c2ml   conv_double_c2ml
#define conv_float_ml2c(ml_v, c_v)   (*c_v = (float) Double_val(ml_v))

#define conv_long_c2ml(c_v, ml_v)  (*ml_v = Val_long(c_v))
#define conv_long_ml2c(ml_v, c_v)  (*c_v = Long_val(ml_v))

#define conv_int_c2ml(c_v, ml_v)  (*ml_v = Val_int(c_v))
#define conv_int_ml2c(ml_v, c_v)  (*c_v = Int_val(ml_v))

#define conv_unsigned_int_c2ml(c_v, ml_v)  (*ml_v = Val_long(c_v))
#define conv_unsigned_int_ml2c(ml_v, c_v)  (*c_v = (unsigned int) Long_val(ml_v))

#define conv_size_t_c2ml(c_v, ml_v)  (*ml_v = Val_long(c_v))
#define conv_size_t_ml2c(ml_v, c_v)  (*c_v = (size_t) Long_val(ml_v))


#define conv_CONST_PTR_char_ml2c(ml_v, c_v)  (*c_v = String_val(ml_v))
#define conv_PTR_CONST_char_ml2c(ml_v, c_v)  (*c_v = String_val(ml_v))


#endif // _GEN_CAML_CONV
