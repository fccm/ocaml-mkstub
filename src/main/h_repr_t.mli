(** Structured representation of a function call ready to be wrapped *)

(** All the params for the C function call *)
type f_arg_c_call = {
  argc_type : string;
  argc_name : string;
  argc_hint : string;
}

(** The return of the C function call *)
type f_return = {
  return_type : string;
  return_name : string;
  return_hint : string;
}

(** Lengths of arrays *)
type f_arg_len = {
  argl_len_type : string;      (** probably int, unsigned int or size_t *)
  argl_len_name : string;
  argl_len_hint : string;
  argl_type : string;
  argl_name : string;
  argl_hint : string;
}

(** These don't contain the length params, and the output params *)
type f_arg_wrap = {
  argw_type : string;
  argw_name : string;
  argw_hint : string;
}

(** Contains the fun call return (if it should) and "out" tagged parameters *)
type f_result = {
  res_type : string;
  res_name : string;
  res_hint : string;
}

(** status (function return or pointer argument) *)
type status = {
  status_type : string;
  status_name : string;
  status_hint : string;
}

(** Structured representation of a function call ready to be wrapped *)
type func = {
  f_name : string;
  f_hint : string;

  f_return : f_return;
  f_return_is_void : bool;
  f_return_is_status : bool;

  f_args_c_call : f_arg_c_call list;    (** C func call params *)
  f_args_wrap : f_arg_wrap list;        (** wrapped params *)
  f_args_len : f_arg_len list;          (** len params *)
  f_args_result : f_result list;        (** pointers with [out] annot *)
  f_args_status : status list;          (** status from arguments *)

  f_all_results : f_result list;        (** pointers with [out] annot *)
  f_all_statuses : status list;         (** status from arguments *)
}

