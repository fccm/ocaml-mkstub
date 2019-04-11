(** Print parsed elements using templaces *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

open Repr_t
module H = Repr_t

open Cmd_line
open Stmpl

type type_name =
  | Name of string
  | Ref of string * string

let rec get_type_name ns t =
  match Utils.assoc_opt t ns with
  | Some (Name s) -> s
  | Some (Ref ("POINTER", _id)) -> "PTR_" ^ (get_type_name ns _id)
  | Some (Ref ("ARRAY", _id)) -> "ARR_" ^ (get_type_name ns _id)
  | Some (Ref ("CONST", _id)) -> "CONST_" ^ (get_type_name ns _id)
  | Some (Ref (lbl, _id)) -> lbl ^ (get_type_name ns _id)
  | None -> "GCCXML_ID_" ^ t

let ref_str_qual = function
  | H.Const -> "CONST"
  | H.Volatile -> "VOLATILE"
  | H.Restrict -> "RESTRICT"

let type_name = function
  | H.FundT ft -> ft
  | H.Enum e -> e.e_name
  | H.Struct st -> st.st_name
  | H.Union u -> u.u_name
  | H.Ptr type_id -> "XXX"
  | H.Typedef td -> "XXX"
  | H.ArrayType ar -> "XXX"
  | H.Class cl -> "XXX"
  | H.CvQual cq -> "XXX"
  | H.Ellipsis -> "XXX"
  | H.TODO s -> "XXX"


(* Get the names types *)
let collect_type_names ts =
  List.map (fun (_id, t) ->
    match t with
    | H.FundT ft -> (_id, Name (type_name t))
    | H.Enum e -> (_id, Name (type_name t))
    | H.Struct st -> (_id, Name (type_name t))
    | H.Union u -> (_id, Name (type_name t))
    | H.Ptr type_id -> (_id, Ref ("POINTER", type_id))

    (* WIP *)
    | H.CvQual cq -> (_id, Ref (ref_str_qual cq.cv_qual, cq.cv_type))
    (* WIP
    | H.CvQual (qual, type_kind) -> (_id, Name "_CVQUAL_TODO")
    *)

    (* TODO *)
    | H.ArrayType ar -> (_id, Ref ("ARRAY", ar.ar_type)) (* size *)

    (* TODO *)
    | H.Typedef td -> (_id, Name "_TYPEDEF_TODO")
    | H.Class cl -> (_id, Name "_CLASS_TODO")
    | H.Ellipsis -> (_id, Name "_ELLIPSIS")
    | H.TODO s -> (_id, Name "_TODO")
  ) ts



(* Filtering *)

let no_builtin f =
  not (Utils.starts_with "__builtin" f.f_name)


let exclude a f =
  not (List.mem f.f_name a.exclude)

let only_t a t =
  a.only = [] || (List.mem (type_name t) a.only)

let only_f a f =
  a.only = [] || (List.mem f.f_name a.only)


(* Call/Read extern command *)

let extern_cmd a lbl _in =
  let _cmd = a.extern_cmd in
  if _cmd = "" then None else
  let cmd = Printf.sprintf "%s %s %s" _cmd lbl _in in
  let s = Utils.command cmd "extern_cmd" in
  Some (Utils.strip s)


(* Annotations *)

let extract_annot s =
  (Utils.str_extract s "gccxml(" ')')


let rem_prefix a name =
  List.fold_left Utils.rem_prefix name a.rem_prefix


let add_list_len replace =
  List.fold_left (fun acc rpl ->
    match rpl with
    | VAR _ -> rpl :: acc
    | LIST (lst_name, lst_args) ->
        VAR (lst_name ^ "_len", string_of_int (List.length lst_args)) ::
        rpl :: acc
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
  Stmpl.print a.template_e replace


(* Print Structs *)

let fields_params a ns fields =
  List.map (fun fld ->
    let fld_name = rem_prefix a fld.fld_name in
    let fld_type = get_type_name ns fld.fld_type in
    let fld_annots = extract_annot fld.fld_annot in
    let fld_annots =
      List.map (fun annot ->
        [ VAR ("Annot", annot) ]
      ) fld_annots
    in
    [ VAR ("Field_name", fld_name);
      VAR ("Field_type", fld_type);
      LIST ("Field_annots", fld_annots); ]
  ) fields

let print_arg ns arg =
  Printf.printf "   @ Arg: t:%s name:%s annot:'%s'\n"
    arg.arg_t
    arg.arg_name
    (String.concat " "
      (extract_annot arg.arg_annot))
    (*
    (Utils.assoc arg.arg_name ns)
    *)

let print_constructor ns c =
  Printf.printf "  @ Constructor: %s\n" c.c_name;
  List.iter (print_arg ns) c.c_args

let print_member ns = function
  | H.Field field -> ()
  | H.Constructor c -> print_constructor ns c
  | H.Destructor _
  | H.Method _
  | H.OperatorMethod _ -> ()

let filter_fields members =
  List.fold_left (fun acc -> function
    | H.Field field -> field :: acc
    | _ -> acc
  ) [] (List.rev members)

let print_struct a ns st =
  let st_name = rem_prefix a st.st_name in
  let fields = filter_fields st.st_members in
  let fields = fields_params a ns fields in
  let replace = [
    VAR ("Struct_name", st_name);
    LIST ("Struct_fields", fields);
  ] in
  let replace = add_cmd_tags a a.template_s_vars replace in
  let replace = add_list_len replace in
  Stmpl.print a.template_s replace


(* Union *)

let _fields_params a ns fields =
  List.map (fun fld ->
    let fld_name = rem_prefix a fld.fld_name in
    let fld_type = get_type_name ns fld.fld_type in
    let fld_annots = extract_annot fld.fld_annot in
    let fld_annots =
      List.map (fun annot ->
        [ VAR ("Annot", annot) ]
      ) fld_annots
    in
    [ VAR ("Mem_name", fld_name);
      VAR ("Mem_type", fld_type);
      LIST ("Mem_annots", fld_annots); ]
  ) fields

let print_union a ns u =  (* TODO *)
  let u_name = rem_prefix a u.u_name in
  let fields = filter_fields u.u_members in
  let mem = _fields_params a ns fields in
  (*
  let mem =
    List.map (fun m ->
      let t = get_type_name ns m in
      [ VAR ("Union_member", m);
        VAR ("Union_member_t", t); ]
    ) u.u_members
  in
  *)
  let replace = [
    VAR ("Union_name", u_name);
    LIST ("Union_members", mem);
  ] in
  Stmpl.print a.template_u replace



let print_type a ns t =
  match t with
  | H.FundT _ -> ()
  | H.Enum e -> print_enum a e
  | H.Struct st -> print_struct a ns st
  | H.Union u -> print_union a ns u
  (*
  | H.Typedef of typedef
  | H.Class of string
  | H.CvQual of qual * type_kind
  | H.Ellipsis
  | H.TODO of string
  *)
  | _ -> ()


let print_type a ns t =
  if only_t a t then
    print_type a ns t


(* Print Functions *)

let tmpl_arg a ns { arg_t; arg_name; arg_annot } =
  let arg_name = rem_prefix a arg_name in
  let arg_t = get_type_name ns arg_t in
  let arg_annots = extract_annot arg_annot in
  let arg_annots =
    List.map (fun annot ->
      [ VAR ("Annot", annot) ]
    ) arg_annots
  in
  [
    VAR ("Param_name", arg_name);
    VAR ("Param_type", arg_t);
    LIST ("Param_annots", arg_annots);
  ]


let print_function a ns f =
  let f_name = rem_prefix a f.f_name in
  let f_ret = get_type_name ns f.f_ret in
  let f_annots = extract_annot f.f_annot in
  let f_annots =
    List.map (fun annot ->
      [ VAR ("Annot", annot) ]
    ) f_annots
  in
  let replace = [
      VAR ("Fun_name", f_name);
      VAR ("Fun_return_type", f_ret);
      LIST ("Fun_annots", f_annots);
      LIST ("Args", List.map (tmpl_arg a ns) f.f_args);
    ]
  in
  let replace = add_cmd_tags a a.template_f_vars replace in
  let replace = add_list_len replace in
  Stmpl.print a.template_f replace


let print_function a ns f =
  if only_f a f then
    print_function a ns f


let print a (ts, fs) =
  (* get names of types *)
  let ns = collect_type_names ts in

  (* print types *)
  List.iter (fun (_id, type_kind) -> print_type a ns type_kind) ts;

  (* print functions *)
  let fs = List.filter no_builtin fs in
  List.iter (print_function a ns) fs;
;;
