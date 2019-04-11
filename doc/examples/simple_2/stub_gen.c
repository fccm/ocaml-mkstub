/* Wrap function: myfunc */

CAMLprim value
ocaml_myfunc(
      value unit )
{
    CAMLparam0( );
    CAMLlocal0( );


    /* declarations */
    /* Empty */

    /* convert arguments */
    /* Empty */

    /* function call */
    myfunc( );

    /* convert results */


    CAMLreturn( Val_unit );
}

/* Wrap function: myfunc_add */

CAMLprim value
ocaml_myfunc_add(
      value ml_p0_p1,
      value ml_p1_p2 )
{
    CAMLparam2(
       ml_p0_p1,
       ml_p1_p2 );
    CAMLlocal0( );
    CAMLlocal1( ml__ret );

    int _ret;

    /* declarations */
    DEC_int( p0_p1 );
    DEC_int( p1_p2 );

    /* convert arguments */
    conv_int_ml2c( ml_p0_p1, & p0_p1 );
    conv_int_ml2c( ml_p1_p2, & p1_p2 );

    /* function call */
    _ret =
      myfunc_add(
          p0_p1, 
          p1_p2 );

    /* convert results */
    conv_int_c2ml( _ret, & ml__ret );


    CAMLreturn( ml__ret );
}

/* Wrap function: myfunc_c */

CAMLprim value
ocaml_myfunc_c(
      value unit )
{
    CAMLparam0( );
    CAMLlocal0( );
    CAMLlocal1( ml__ret );

    int _ret;

    /* declarations */
    /* Empty */

    /* convert arguments */
    /* Empty */

    /* function call */
    _ret =
      myfunc_c( );

    /* convert results */
    conv_int_c2ml( _ret, & ml__ret );


    CAMLreturn( ml__ret );
}

/* Wrap function: myfunc_wei */

CAMLprim value
ocaml_myfunc_wei(
      value ml_p0_p )
{
    CAMLparam1(
       ml_p0_p );
    CAMLlocal1(
        ml_p0_ret );


    /* declarations */
    DEC_int( p0_p );
    DEC_PTR_int( p1_ret );

    /* convert arguments */
    conv_int_ml2c( ml_p0_p, & p0_p );

    /* function call */
    myfunc_wei(
          p0_p, 
          p1_ret );

    /* convert results */
    conv_PTR_int_c2ml( p0_ret, & ml_p0_ret );

    Store_field( ml_ret_multi, 0, ml_p0_ret );

}

/* Wrap function: myfunc_arr */

CAMLprim value
ocaml_myfunc_arr(
      value ml_p0_arr )
{
    CAMLparam1(
       ml_p0_arr );
    CAMLlocal0( );
    CAMLlocal1( ml__ret );

    int _ret;

    /* declarations */
    DEC_int( p0_n );
    DEC_PTR_int( p1_arr );

    /* convert arguments */
    conv_PTR_int_ml2c( ml_p0_arr, & p0_arr );

    /* function call */
    _ret =
      myfunc_arr(
          p0_n, 
          p1_arr );

    /* convert results */
    conv_int_c2ml( _ret, & ml__ret );


    CAMLreturn( ml__ret );
}

/* Wrap function: myfunc_ii */

CAMLprim value
ocaml_myfunc_ii(
      value ml_p0_ )
{
    CAMLparam1(
       ml_p0_ );
    CAMLlocal0( );
    CAMLlocal1( ml__ret );

    int _ret;

    /* declarations */
    DEC_int( p0_ );

    /* convert arguments */
    conv_int_ml2c( ml_p0_, & p0_ );

    /* function call */
    _ret =
      myfunc_ii(
          p0_ );

    /* convert results */
    conv_int_c2ml( _ret, & ml__ret );


    CAMLreturn( ml__ret );
}

/* Wrap function: myfunc_io */

CAMLprim value
ocaml_myfunc_io(
      value ml_p0_p )
{
    CAMLparam1(
       ml_p0_p );
    CAMLlocal1(
        ml_p0_p );


    /* declarations */
    DEC_PTR_int( p0_p );

    /* convert arguments */
    conv_PTR_int_ml2c( ml_p0_p, & p0_p );

    /* function call */
    myfunc_io(
          p0_p );

    /* convert results */
    conv_PTR_int_c2ml( p0_p, & ml_p0_p );

    Store_field( ml_ret_multi, 0, ml_p0_p );

}

/* Wrap function: myfunc_st */

CAMLprim value
ocaml_myfunc_st(
      value ml_p0_ )
{
    CAMLparam1(
       ml_p0_ );
    CAMLlocal0( );
    CAMLlocal1( ml__ret );

    float _ret;

    /* declarations */
    DEC_floatRect( p0_ );

    /* convert arguments */
    conv_floatRect_ml2c( ml_p0_, & p0_ );

    /* function call */
    _ret =
      myfunc_st(
          p0_ );

    /* convert results */
    conv_float_c2ml( _ret, & ml__ret );


    CAMLreturn( ml__ret );
}

/* Wrap function: myfunc_blend */

CAMLprim value
ocaml_myfunc_blend(
      value ml_p0_ )
{
    CAMLparam1(
       ml_p0_ );
    CAMLlocal0( );
    CAMLlocal1( ml__ret );

    int _ret;

    /* declarations */
    DEC_blendMode( p0_ );

    /* convert arguments */
    conv_blendMode_ml2c( ml_p0_, & p0_ );

    /* function call */
    _ret =
      myfunc_blend(
          p0_ );

    /* convert results */
    conv_int_c2ml( _ret, & ml__ret );


    CAMLreturn( ml__ret );
}

