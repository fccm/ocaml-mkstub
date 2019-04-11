#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include "try1.h"

CAMLprim value
ocaml_myfunc(value unit)
{
    myfunc();
    return Val_unit;
}

CAMLprim value
ocaml_myfunc_c(value unit)
{
    int r;
    r = myfunc_c();
    return Val_int(r);
}

CAMLprim value
ocaml_myfunc_add(value ml_p1, value ml_p2)
{
    int r;
    int p1;
    int p2;
    p1 = Int_val(ml_p1);
    p2 = Int_val(ml_p2);
    r = myfunc_add(p1, p2);
    return Val_int(r);
}

CAMLprim value
ocaml_myfunc_ii(value ml_p)
{
    int r;
    int p;
    p = Int_val(ml_p);
    r = myfunc_ii(p);
    return Val_int(r);
}

static const blendMode table_blendMode[] = {
    BLENDMODE_NONE,
    BLENDMODE_BLEND,
    BLENDMODE_ADD,
    BLENDMODE_MOD
};

#define BlendMode_val(v) \
    (table_blendMode[Long_val(v)])

CAMLprim value
ocaml_myfunc_blend(value ml_p)
{
    int r;
    blendMode p;
    p = BlendMode_val(ml_p);
    r = myfunc_blend(p);
    return Val_int(r);
}

void conv_floatRect_ml2c(value ml_p, floatRect *p)
{
    /*
    p.left   = Double_val(Field(ml_p, 0));
    p.top    = Double_val(Field(ml_p, 1));
    p.width  = Double_val(Field(ml_p, 2));
    p.height = Double_val(Field(ml_p, 3));
    */
    p->left   = Double_field(ml_p, 0);
    p->top    = Double_field(ml_p, 1);
    p->width  = Double_field(ml_p, 2);
    p->height = Double_field(ml_p, 3);
}

CAMLprim value
ocaml_myfunc_st(value ml_p)
{
    int r;
    floatRect p;
    conv_floatRect_ml2c(ml_p, &p);
    r = myfunc_st(p);
    return caml_copy_double(r);
}

CAMLprim value
ocaml_myfunc_wei(value ml_p)
{
    int ret;
    myfunc_wei(Int_val(ml_p), &ret);
    return Val_int(ret);
}

CAMLprim value
ocaml_myfunc_arr(value ml_array)
{
    int i, len;
    int ret;
    int *arr;
    len = Wosize_val(ml_array);
    arr = malloc(len * sizeof(int));
    for (i=0; i < len; i++)
    {
        arr[i] = Int_val(Field(ml_array, i));
    }
    ret = myfunc_arr(len, arr);
    free(arr);
    return Val_int(ret);
}

