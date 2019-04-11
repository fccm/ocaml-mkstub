open Instructions_t
open S_repr_t
open H_repr_t

let arg_out annots =
  List.mem "out" annots

let arg_out_only annots =
  List.mem "out" annots &&
  not (List.mem "in" annots)

let is_status annots =
  List.mem "status" annots

let len_prefix = "len_of_p"
let is_len_of annot =
  Utils.starts_with len_prefix annot

let is_len annots =
  List.exists is_len_of annots

let get_len_of annots =
  let len = List.find is_len_of annots in
  let i = Utils.rem_prefix len len_prefix in
  int_of_string i

let hide_from_lang annots =
  arg_out_only annots ||
  is_len annots ||
  is_status annots

let returns_void f =
  f.fun_ret = "void"


let conv_function a f =
  let f_name = f.fun_name in
  let f_annots = f.fun_annots in
  let f_hint = "TODO_HINT" in
  let f_return =
    {
      return_type = f.fun_ret;
      return_name = "_ret";
      return_hint = "TODO_HINT";
    }
  in
  let f_args_c_call =
    List.map (fun arg ->
      { argc_type = arg.arg_type;
        argc_name = arg.arg_name;
        argc_hint = "TODO_HINT";
      }
    ) f.fun_args
  in
  let f_args_wrap =
    Utils.list_map_opt (fun arg ->
      if hide_from_lang arg.arg_annots then None else
        Some {
          argw_type = arg.arg_type;
          argw_name = arg.arg_name;
          argw_hint = "TODO_HINT";
        }
    ) f.fun_args
  in
  let f_args_result =
    Utils.list_map_opt (fun arg ->
      if arg_out arg.arg_annots then
        Some {
          res_type = arg.arg_type;
          res_name = arg.arg_name;
          res_hint = "TODO_HINT";
        }
      else None
    ) f.fun_args
  in
  let f_args_len =
    Utils.list_map_opt (fun arg ->
      if is_len arg.arg_annots then
        let i = get_len_of arg.arg_annots in
        let array_arg = List.nth f.fun_args i in
        Some {
          argl_len_type = arg.arg_type;
          argl_len_name = arg.arg_name;
          argl_len_hint = "TODO_HINT";
          argl_type = array_arg.arg_type;
          argl_name = array_arg.arg_name;
          argl_hint = "TODO_HINT";
        }
      else None
    ) f.fun_args
  in
  let f_args_status =
    Utils.list_map_opt (fun arg ->
      if is_status arg.arg_annots then
        Some {
          status_type = arg.arg_type;
          status_name = arg.arg_name;
          status_hint = "TODO_HINT";
        }
      else None
    ) f.fun_args
  in
  let f_return_is_void = returns_void f in
  let f_return_is_status = is_status f_annots in
  let f_all_results =
    if f_return_is_void || f_return_is_status
    then f_args_result
    else
      let return_result =
        {
          res_type = f_return.return_type;
          res_name = f_return.return_name;
          res_hint = f_return.return_hint;
        }
      in
      return_result :: f_args_result
  in
  let f_all_statuses =
    if f_return_is_status
    then {
        status_type = f_return.return_type;
        status_name = f_return.return_name;
        status_hint = f_return.return_hint;
      } :: f_args_status
    else f_args_status
  in
  {
    f_name;
    f_hint;
    f_return;
    f_return_is_void;
    f_return_is_status;
    f_args_c_call;
    f_args_wrap;
    f_args_result;
    f_args_len;
    f_args_status;
    f_all_results;
    f_all_statuses;
  }


let conv a (ts, fs) =
  (* convert functions *)
  let fs = List.map (conv_function a) fs in
  (fs)
