open Smls_t
open Hrepr_t
open Instructions_t

let conv fi =
  let f_name = fi.fun_name in
  let f_hint = "" in
  let f_return_type = fi.fun_ret in
  (*
  fun_annots : string list;
  fun_params : param list;
  *)
  {
    f_name;
    f_hint;
    f_return_type;
    f_args_len = [];
    f_args_lang = [];
    f_args_call = [];
    f_return = None;
    f_check_status = [];
    f_results = [];
  }
