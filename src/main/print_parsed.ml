(** Print parsed elements using templaces *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

open S_repr_t
module S = S_repr_t

open Cmd_line
open Stmpl


let type_name t =
  match t with
  | S.FundT s -> s
  | S.Enum e -> e.e_name
  | S.ArrayType ar -> "XXX_PTR_" ^ ar.ar_type
  | S.Struct st -> st.st_name
  (*
  | S.Typedef td -> "XXX_TYPEDEF_" ^ td.td_name ^ "__" ^ td.td_type
  *)
  | S.Typedef td -> td.td_name

  | S.Union u -> u.u_name

  | S.Variable var -> var.var_name

  | S.Class _ ->  "XXX_Class"
  | S.CvQual _ -> "XXX_CvQual"
  | S.Ptr ptr ->  ptr
  | S.Ellipsis -> "XXX_Ellipsis"
  | S.TODO _ ->   "XXX_TODO"


(* Filtering *)

let filter_t a t =
  not (List.mem (type_name t) a.exclude) &&
  a.only = [] || (List.mem (type_name t) a.only)


let filter_f a f =
  not (List.mem f.fun_name a.exclude) &&
  (a.only = [] || (List.mem f.fun_name a.only))


(* Call/Read extern command *)

let extern_cmd a lbl _in =
  let _cmd = a.extern_cmd in
  if _cmd = "" then None else
  let cmd = Printf.sprintf "%s %s %s" _cmd lbl _in in
  let s = Utils.command cmd "extern_cmd" in
  Some (Utils.strip s)


(* Annotations *)


let rem_prefix a name =
  List.fold_left Utils.rem_prefix name a.rem_prefix


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


(* cmd: tags *)

let template_contains_tag tag tmpl_vars =
  List.mem tag tmpl_vars

let add_cmd_tags a tmpl_vars replace =
  Stmpl.params_fold_assoc
    ( fun ((tag, tag_val) as orig) ->
        let tag_cmd = "cmd:" ^ tag in
        if template_contains_tag tag_cmd tmpl_vars then
        ( match extern_cmd a tag tag_val with
          | Some cmd_res -> (tag_cmd, cmd_res) :: orig :: []
          | None -> [orig] )
        else [orig]
    ) replace



(* Print Types *)

let stmpl_print template replace =
  Stmpl.print template (Stmpl.add_len replace)

(* Print Enums *)

let print_enum a e =
  let e_name = rem_prefix a e.e_name in
  let enums =
    List.map (fun ev ->
      let ev_name = rem_prefix a ev.ev_name in
      [ VAR ("Enum_val_name", ev_name);
        VAR ("Enum_val_init", ev.ev_init); ]
    ) e.e_values
  in
  let replace = [
    VAR ("Enum_name", e_name);
    LIST ("Enum_list", enums);
  ] in
  let replace = add_cmd_tags a a.template_e_vars replace in
  let replace = add_list_len replace in
  stmpl_print a.template_e replace


(* Print Structs *)

let fields_params a fields =
  List.map (fun fld ->
    let fld_name = rem_prefix a fld.fld_name in
    let fld_type = fld.fld_type in
    let fld_annots = fld.fld_annots in
    let fld_annots =
      List.map (fun annot ->
        [ VAR ("Annot", annot) ]
      ) fld_annots
    in
    [ VAR ("Field_name", fld_name);
      VAR ("Field_type", fld_type);
      LIST ("Field_annots", fld_annots); ]
  ) fields

let print_arg arg =
  Printf.printf "   @ Arg: t:%s name:%s annot:'%s'\n"
    arg.arg_type
    arg.arg_name
    (String.concat " " arg.arg_annots)

let print_constructor c =
  Printf.printf "  @ Constructor: %s\n" c.c_name;
  List.iter print_arg c.c_args

let print_member = function
  | S.Field field -> ()
  | S.Constructor c -> print_constructor c
  | S.Destructor _
  | S.Method _
  | S.OperatorMethod _ -> ()

let filter_fields members =
  List.fold_left (fun acc -> function
    | S.Field field -> field :: acc
    | _ -> acc
  ) [] (List.rev members)

let print_struct a st =
  let st_name = rem_prefix a st.st_name in
  let fields = filter_fields st.st_members in
  let fields = fields_params a fields in
  let replace = [
    VAR ("Struct_name", st_name);
    LIST ("Struct_fields", fields);
  ] in
  let replace = add_cmd_tags a a.template_s_vars replace in
  let replace = add_list_len replace in
  stmpl_print a.template_s replace


(* Class *)

let print_class a cl =
  print_endline "=== HERE: print_class";
  let replace = [
    VAR ("Class_name", cl);
  ] in
  stmpl_print a.template_o replace


(* Union *)

let _fields_params a fields =
  List.map (fun fld ->
    let fld_name = rem_prefix a fld.fld_name in
    let fld_type = fld.fld_type in
    let fld_annots = fld.fld_annots in
    let fld_annots =
      List.map (fun annot ->
        [ VAR ("Annot", annot) ]
      ) fld_annots
    in
    [ VAR ("Mem_name", fld_name);
      VAR ("Mem_type", fld_type);
      LIST ("Mem_annots", fld_annots); ]
  ) fields

let print_union a u =  (* TODO *)
  let u_name = rem_prefix a u.u_name in
  let fields = filter_fields u.u_members in
  let mem = _fields_params a fields in
  (*
  let mem =
    List.map (fun m ->
      let t = __ m in
      [ VAR ("Union_member", m);
        VAR ("Union_member_t", t); ]
    ) u.u_members
  in
  *)
  let replace = [
    VAR ("Union_name", u_name);
    LIST ("Union_members", mem);
  ] in
  stmpl_print a.template_u replace


let print_typedef a td =
  Printf.eprintf "print_typedef:\n  %s\n  %s\n%!"
    td.td_name
    td.td_type

let print_variable a var =
  Printf.printf "print_variable:\n  %s\n  %s\n%!"
    var.var_name
    var.var_type


let print_type a t =
  match t with
  | S.FundT _ -> ()
  | S.Enum e -> print_enum a e
  | S.Struct st -> print_struct a st
  | S.Union u -> print_union a u
  | S.Typedef td -> print_typedef a td
  | S.Variable var -> print_variable a var
  | S.Class cl -> print_class a cl
  (*
  | S.CvQual of qual * type_kind
  | S.Ellipsis
  | S.TODO of string
  *)
  | _ -> ()



(* Print Functions *)

let tmpl_arg a { arg_type; arg_name; arg_annots } =
  let arg_name = rem_prefix a arg_name in
  let arg_annots =
    List.map (fun annot ->
      [ VAR ("Annot", annot) ]
    ) arg_annots
  in
  [
    VAR ("Param_name", arg_name);
    VAR ("Param_type", arg_type);
    LIST ("Param_annots", arg_annots);
  ]


let print_function a f =
  let f_name = rem_prefix a f.fun_name in
  let f_ret = f.fun_ret in
  let f_annots = f.fun_annots in
  let f_annots =
    List.map (fun annot ->
      [ VAR ("Annot", annot) ]
    ) f_annots
  in
  let replace = [
      VAR ("Fun_name", f_name);
      VAR ("Fun_return_type", f_ret);
      LIST ("Fun_annots", f_annots);
      LIST ("Args", List.map (tmpl_arg a) f.fun_args);
    ]
  in
  let replace = add_cmd_tags a a.template_f_vars replace in
  let replace = add_list_len replace in
  stmpl_print a.template_f replace


let replace_name t name =
  let _failwith s =
    failwith ("TODO: Print_parsed.replace_name: " ^ s)
  in
  match t with
  | S.Enum e -> S.Enum { e with e_name = name }
  | S.Struct st -> S.Struct { st with st_name = name }
  | S.Union u -> S.Union { u with u_name = name }
  | S.FundT s -> S.FundT name
  | S.Ptr ptr -> S.FundT ("__PTR_" ^ ptr ^ "_" ^ name ^ "_")

  | S.Typedef td -> S.Typedef { td with td_name = name }

  | S.ArrayType ar -> _failwith "S.ArrayType"
  | S.Variable var -> _failwith "S.Variable"
  | S.Class _ ->   _failwith "S.Class"
  | S.CvQual _ ->  _failwith "S.CvQual"
  | S.Ellipsis ->  _failwith "S.Ellipsis"
  | S.TODO _ ->    _failwith "S.TODO"

  (*
  | S.Typedef _ -> _failwith "S.Typedef"
  *)


let is_ref = function
  | S.Typedef td -> Some (td.td_name, td.td_type)
  | S.Variable var -> Some (var.var_name, var.var_type)  (* XXX *)
  | _ -> None

(* TODO: rewrite this *)
let typedef_ref ts =
  List.map (fun t ->
    match is_ref t with
    | None -> t
    | Some (name, ref_type) ->
        try
          let t = List.find (fun t -> (type_name t) = ref_type) ts in
          replace_name t name
        with Not_found ->
          S.FundT ("__NOT_FOUND_" ^ name ^ "_")
  ) ts


let debug_ts ts =
  List.iter (function
  | S.FundT ft -> Printf.eprintf "@ S.FundT: %s\n" ft
  | S.Enum e -> Printf.eprintf "@ S.Enum: %s\n" e.S.e_name
  | S.ArrayType _ -> ()
  | S.Struct st -> Printf.eprintf "@ S.Struct: %s\n" st.S.st_name
  | S.Typedef td -> Printf.eprintf "@ S.Typedef: %s\n" td.S.td_name
  | S.Union u -> Printf.eprintf "@ S.Union: %s\n" u.S.u_name
  | S.Class cl -> ()
  | S.CvQual qv -> ()
  | S.Ptr _id -> ()
  | S.Variable var -> Printf.eprintf "@ S.Variable: %s\n" var.S.var_name
  | S.Ellipsis -> ()
  | S.TODO td -> ()
  ) ts


let print a (ts, fs) =
  let ts = typedef_ref ts in

  (* DEBUG
  *)
  debug_ts ts;

  let ts = List.filter (filter_t a) ts in
  let fs = List.filter (filter_f a) fs in

  (* print types *)
  List.iter (print_type a) ts;

  (* print functions *)
  List.iter (print_function a) fs;
;;
