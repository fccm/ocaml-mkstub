(** Structured representation of a function call ready to be wrapped *)

(** Lengths of arrays *)
type f_arg_len = {
  argl_type_len : string;      (** probably int, unsigned int or size_t *)
  argl_name_len : string;
  argl_type : string;
  argl_name : string;
  argl_hint : string;
}

(** These don't contain the length params, and the output params *)
type f_arg_lang = {
  argw_type : string;
  argw_name : string;
  argw_hint : string;
}

(** All the params for the C function call *)
type f_arg_call = {
  argc_type : string;
  argc_name : string;
  argc_hint : string;
}

(** Empty list if return void, otherwise one element *)
type f_return = {
  f_return_type : string;
}

(** Contains the fun call return (if it should) and "out" tagged parameters *)
type f_result = {
  res_type : string;
  res_name : string;
}

(** Returned status *)
type status = {
  status_name : string;
}

(** Structured representation of a function call ready to be wrapped *)
type func = {
  f_name : string;
  f_hint : string;
  f_return_type : string;
  f_args_len : f_arg_len list;          (** len params *)
  f_args_lang : f_arg_lang list;        (** wrapped params *)
  f_args_call : f_arg_call list;        (** C func call params *)
  f_return : f_return option;
  f_check_status : status list;
  f_results : f_result list;
}
