let en =
{ enum_name = "blendMode";
  enums = [
    { i = "0";
      ev_name = "BLENDMODE_NONE";
      ev_init = "0";
    };
    { i = "1";
      ev_name = "BLENDMODE_BLEND";
      ev_init = "1";
    };
    { i = "2";
      ev_name = "BLENDMODE_ADD";
      ev_init = "2";
    };
    { i = "3";
      ev_name = "BLENDMODE_MOD";
      ev_init = "4";
    };
  ]
}


let sts =
{ struct_name = "floatRect";
  fields = [
    { field_name = "left";
      field_type = "float";
      field_annot = "";
    };
    { field_name = "top";
      field_type = "float";
      field_annot = "";
    };
    { field_name = "width";
      field_type = "float";
      field_annot = "";
    };
    { field_name = "height";
      field_type = "float";
      field_annot = "ignore";
    };
  ];
}


let funs = [

{ fun_name     = "myfunc";
  fun_res_type = "void";
  fun_annot    = "";
  params = [
  ];
};
{ fun_name     = "myfunc_add";
  fun_res_type = "int";
  fun_annot    = "";
  params = [
    { param_type  = "int";
      param_name  = "p1";
      param_annot = "";
    };
    { param_type  = "int";
      param_name  = "p2";
      param_annot = "";
    };
  ];
};
{ fun_name     = "myfunc_c";
  fun_res_type = "int";
  fun_annot    = "";
  params = [
  ];
};
{ fun_name     = "myfunc_wei";
  fun_res_type = "void";
  fun_annot    = "export";
  params = [
    { param_type  = "int";
      param_name  = "p";
      param_annot = "in";
    };
    { param_type  = "PTR_int";
      param_name  = "ret";
      param_annot = "out";
    };
  ];
};
{ fun_name     = "myfunc_arr";
  fun_res_type = "int";
  fun_annot    = "";
  params = [
    { param_type  = "int";
      param_name  = "n";
      param_annot = "len";
    };
    { param_type  = "PTR_int";
      param_name  = "arr";
      param_annot = "len_p0";
    };
  ];
};
{ fun_name     = "myfunc_ii";
  fun_res_type = "int";
  fun_annot    = "";
  params = [
    { param_type  = "int";
      param_name  = "";
      param_annot = "";
    };
  ];
};
{ fun_name     = "myfunc_st";
  fun_res_type = "float";
  fun_annot    = "";
  params = [
    { param_type  = "floatRect";
      param_name  = "";
      param_annot = "";
    };
  ];
};
{ fun_name     = "myfunc_blend";
  fun_res_type = "int";
  fun_annot    = "";
  params = [
    { param_type  = "blendMode";
      param_name  = "";
      param_annot = "";
    };
  ];
};
]
