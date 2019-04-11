open H_repr_t
open Cmd_line
open Stmpl

let rec add_list_len replace =
  List.fold_left (fun acc rpl ->
    match rpl with
    | VAR _ -> rpl :: acc
    | LIST (lst_name, lst_args) ->
        let lst_args = List.map add_list_len lst_args in
        let lst = LIST (lst_name, lst_args) in
        VAR ("len:" ^ lst_name, string_of_int (List.length lst_args)) ::
        lst :: acc
  ) [] (List.rev replace)


let tmpl_arg_c argc =
  [
    VAR ("Arg_type", argc.argc_type);
    VAR ("Arg_name", argc.argc_name);
    VAR ("Arg_hint", argc.argc_hint);
  ]

let tmpl_arg_w argw =
  [
    VAR ("Arg_type", argw.argw_type);
    VAR ("Arg_name", argw.argw_name);
    VAR ("Arg_hint", argw.argw_hint);
  ]

let tmpl_arg_r res =
  [
    VAR ("Res_type", res.res_type);
    VAR ("Res_name", res.res_name);
    VAR ("Res_hint", res.res_hint);
  ]

let tmpl_arg_l argl =
  [
    VAR ("Arg_len_type", argl.argl_len_type);
    VAR ("Arg_len_name", argl.argl_len_name);
    VAR ("Arg_len_hint", argl.argl_len_hint);

    VAR ("Arg_type", argl.argl_type);
    VAR ("Arg_name", argl.argl_name);
    VAR ("Arg_hint", argl.argl_hint);
  ]

let tmpl_check st =
  [
    VAR ("Status_type", st.status_type);
    VAR ("Status_name", st.status_name);
    VAR ("Status_hint", st.status_hint);
  ]

let tmpl_return ret =
  [
    VAR ("Func_return_type", ret.return_type);
    VAR ("Func_return_name", ret.return_name);
    VAR ("Func_return_hint", ret.return_hint);
  ]

let tmpl_results res =
  [
    VAR ("Res_type", res.res_type);
    VAR ("Res_name", res.res_name);
    VAR ("Res_hint", res.res_hint);
  ]

let print_f a f =
  let args_c_call = List.map  tmpl_arg_c  f.f_args_c_call in
  let args_result = List.map  tmpl_arg_r  f.f_args_result in
  let args_w_lang = List.map  tmpl_arg_w  f.f_args_wrap in
  let args_ar_len = List.map  tmpl_arg_l  f.f_args_len in
  let args_status = List.map  tmpl_check  f.f_args_status in
  let results     = List.map tmpl_results f.f_all_results in
  let return =
    if f.f_return_is_void
    then []
    else [ tmpl_return f.f_return ]
  in
  let res_all_len = List.length f.f_all_results
  and res_arg_len = List.length f.f_args_result
  and res_ret_len =
    let ret =
      ( f.f_return_is_void,
        f.f_return_is_status )
    in
    match ret with
    | true, false -> 0
    | false, true -> 0
    | false, false -> 1
    | true, true -> Printf.kprintf invalid_arg "%s: void status" f.f_name
  in
  let zero_result = if res_all_len = 0 then [ [] ] else [] in
  let one_result = if res_all_len = 1 then results else [] in
  let multi_results = if res_all_len >= 2 then results else [] in
  let one_result_arg =
    if res_all_len = 1
    && res_arg_len = 1 then results else []
  in
  let one_result_return =
    if res_all_len = 1
    && res_ret_len = 1 then results else []
  in
  let multi_results_arg =
    if res_all_len >= 2
    && res_all_len = res_arg_len then results else []
  in
  let multi_results_return =
    if res_all_len >= 2
    && res_all_len = (1 + res_arg_len) then results else []
  in
  let replace = [
    VAR ("Func_name", f.f_name);
    VAR ("Func_return_type", f.f_return.return_type);
    VAR ("Func_hint", f.f_hint);

    LIST ("Args_C", args_c_call);
    LIST ("Args_wrap", args_w_lang);
    LIST ("Args_result", args_result);
    LIST ("Args_len", args_ar_len);
    LIST ("Args_status", args_status);

    LIST ("Return", return);
    LIST ("Results", results);

    LIST ("Zero_result", zero_result);
    LIST ("One_result", one_result);
    LIST ("Multi_results", multi_results);

    LIST ("One_result_arg", one_result_arg);
    LIST ("One_result_return", one_result_return);

    LIST ("Multi_results_arg", multi_results_arg);
    LIST ("Multi_results_return", multi_results_return);
  ] in
  let replace = add_list_len replace in
  Stmpl.print a.template_w (Stmpl.add_len replace)


let filter_f a f =
  not (List.mem f.f_name a.exclude) &&
  (a.only = [] || (List.mem f.f_name a.only))


let print a fs =
  let fs = List.filter (filter_f a) fs in
  List.iter (print_f a) fs
