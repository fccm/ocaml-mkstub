(* struct *)

type field = {
  field_name : string;
  field_type : string;
  field_annot : string;
}

type c_struct = {
  struct_name : string;
  fields : field list;
}

(* enum *)

type enum_val = {
  i : string;
  ev_name : string;
  ev_init : string;
}

type enum = {
  enum_name : string;
  enums : enum_val list;
}

(* function *)

type param = {
  param_type : string;
  param_name : string;
  param_annot : string;
}

type func = {
  fun_name : string;
  fun_res_type : string;
  fun_annot : string;
  params : param list;
}

