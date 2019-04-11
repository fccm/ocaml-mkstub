
static const blendMode ocaml_table_blendMode[] = {
    BLENDMODE_NONE,
    BLENDMODE_BLEND,
    BLENDMODE_ADD,
    BLENDMODE_MOD,
};

#define blendMode_val_unsafe(v) \
    (ocaml_table_blendMode[Long_val(v)])

blendMode blendMode_val_safe(v)
{
    switch (Long_val(v))
    {
        case 0: return BLENDMODE_NONE;
        case 1: return BLENDMODE_BLEND;
        case 2: return BLENDMODE_ADD;
        case 3: return BLENDMODE_MOD;

        default: caml_failwith("blendMode_val");
    }
    caml_failwith("blendMode_val");
}

#if defined(USE_SAFE_STUB)

#define conv_blendMode_ml2c( ml_v, v ) \
    ((*v) = blendMode_val_safe(ml_v))

#else

#define conv_blendMode_ml2c( ml_v, v ) \
    ((*v) = blendMode_val_unsafe(ml_v))

#endif

value
Val_blendMode(blendMode e)
{
    switch (e)
    {
        case BLENDMODE_NONE:	return Val_long(0);
        case BLENDMODE_BLEND:	return Val_long(1);
        case BLENDMODE_ADD:	return Val_long(2);
        case BLENDMODE_MOD:	return Val_long(3);

        default: caml_failwith("Val_blendMode");
    }
    caml_failwith("Val_blendMode");
}


CAMLprim value
ocaml_myfunc(
      value unit )
{
    value ret;
    DEC_void( res );

    /* declarations */
    /* Empty */

    /* convertions */
    /* Empty */

    /* call */
    RES_void( res )
      myfunc( );

    conv_void_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_add(
      value ml_p0_p1,
      value ml_p1_p2 )
{
    value ret;
    DEC_int( res );

    /* declarations */
    int p0_p1;
    int p1_p2;

    /* convertions */
    conv_int_ml2c( ml_p0_p1, & p0_p1 );
    conv_int_ml2c( ml_p1_p2, & p1_p2 );

    /* call */
    RES_int( res )
      myfunc_add(
          p0_p1, 
          p1_p2 );

    conv_int_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_c(
      value unit )
{
    value ret;
    DEC_int( res );

    /* declarations */
    /* Empty */

    /* convertions */
    /* Empty */

    /* call */
    RES_int( res )
      myfunc_c( );

    conv_int_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_wei(
      value ml_p0_p,
      value ml_p1_ret )
{
    value ret;
    DEC_void( res );

    /* declarations */
    int p0_p;
    PTR_int p1_ret;

    /* convertions */
    conv_int_ml2c( ml_p0_p, & p0_p );
    conv_PTR_int_ml2c( ml_p1_ret, & p1_ret );

    /* call */
    RES_void( res )
      myfunc_wei(
          p0_p, 
          p1_ret );

    conv_void_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_arr(
      value ml_p0_n,
      value ml_p1_arr )
{
    value ret;
    DEC_int( res );

    /* declarations */
    int p0_n;
    PTR_int p1_arr;

    /* convertions */
    conv_int_ml2c( ml_p0_n, & p0_n );
    conv_PTR_int_ml2c( ml_p1_arr, & p1_arr );

    /* call */
    RES_int( res )
      myfunc_arr(
          p0_n, 
          p1_arr );

    conv_int_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_ii(
      value ml_p0_ )
{
    value ret;
    DEC_int( res );

    /* declarations */
    int p0_;

    /* convertions */
    conv_int_ml2c( ml_p0_, & p0_ );

    /* call */
    RES_int( res )
      myfunc_ii(
          p0_ );

    conv_int_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_st(
      value ml_p0_ )
{
    value ret;
    DEC_float( res );

    /* declarations */
    floatRect p0_;

    /* convertions */
    conv_floatRect_ml2c( ml_p0_, & p0_ );

    /* call */
    RES_float( res )
      myfunc_st(
          p0_ );

    conv_float_c2ml( res, & ret );
    return ret;
}


CAMLprim value
ocaml_myfunc_blend(
      value ml_p0_ )
{
    value ret;
    DEC_int( res );

    /* declarations */
    blendMode p0_;

    /* convertions */
    conv_blendMode_ml2c( ml_p0_, & p0_ );

    /* call */
    RES_int( res )
      myfunc_blend(
          p0_ );

    conv_int_c2ml( res, & ret );
    return ret;
}

