(** SML input from hxtr *)

type param = {
  param_type : string;
  param_name : string;
  param_annots : string list;
}

type in_fun = {
  fun_name : string;
  fun_ret : string;
  fun_annots : string list;
  fun_params : param list;
}

