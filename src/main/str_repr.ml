(** Convert id's into string content *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

open Cmd_line

module R = Repr_t
module S = S_repr_t

type type_name =
  | Name of string
  | Ref of string * string

let rec get_type_name ns t =
  match Utils.assoc_opt t ns with
  | Some (Name s) -> s
  | Some (Ref ("POINTER", _id)) -> "PTR_" ^ (get_type_name ns _id)

  | Some (Ref ("TYPEDEF", _id)) -> (*"TYPEDEF_" ^*) (get_type_name ns _id)

  | Some (Ref ("ARRAY", _id)) -> "ARR_" ^ (get_type_name ns _id)
  | Some (Ref ("CONST", _id)) -> "CONST_" ^ (get_type_name ns _id)
  | Some (Ref (lbl, _id)) -> lbl ^ "_" ^ (get_type_name ns _id)
  | None -> "GCCXML_ID_" ^ t

let ref_str_qual = function
  | R.Const -> "CONST"
  | R.Volatile -> "VOLATILE"
  | R.Restrict -> "RESTRICT"

let type_name = function
  | R.FundT ft -> ft
  | R.Enum e -> e.R.e_name
  | R.Struct st -> st.R.st_name
  | R.Union u -> u.R.u_name
  | R.Typedef td -> td.R.td_name
  | R.Variable var -> var.R.var_name
  | R.Ptr type_id -> "XXX"
  | R.ArrayType ar -> "XXX"
  | R.Class cl -> "XXX"
  | R.CvQual cq -> "XXX"
  | R.Ellipsis -> "XXX"
  | R.TODO s -> "XXX"


(* Get the names types *)
let collect_type_names ts =
  List.map (fun (_id, t) ->
    match t with
    | R.FundT ft -> (_id, Name (type_name t))
    | R.Enum e -> (_id, Name (type_name t))
    | R.Struct st -> (_id, Name (type_name t))
    | R.Union u -> (_id, Name (type_name t))
    | R.Ptr type_id -> (_id, Ref ("POINTER", type_id))

    (* WIP *)
    | R.CvQual cq -> (_id, Ref (ref_str_qual cq.R.cv_qual, cq.R.cv_type))
    (* WIP
    | R.CvQual (qual, type_kind) -> (_id, Name "_CVQUAL_TODO")
    *)

    (* TODO *)
    | R.ArrayType ar -> (_id, Ref ("ARRAY", ar.R.ar_type)) (* size *)

    (* WIP *)
    (*
    | R.Typedef td -> (_id, Ref ("TYPEDEF", td.R.td_name))
    *)
    | R.Typedef td -> (_id, Name (td.R.td_name))

    | R.Variable var -> (_id, Name (var.R.var_name))

    (* TODO *)
    | R.Class cl -> (_id, Name "_CLASS_TODO")
    | R.Ellipsis -> (_id, Name "_ELLIPSIS")
    | R.TODO s -> (_id, Name "_TODO")
  ) ts



(* Filtering *)

let no_builtin f =
  not (Utils.starts_with "__builtin" f.R.f_name)



(* Call/Read extern command *)

let extern_cmd a lbl _in =
  let _cmd = a.extern_cmd in
  if _cmd = "" then None else
  let cmd = Printf.sprintf "%s %s %s" _cmd lbl _in in
  let s = Utils.command cmd "extern_cmd" in
  Some (Utils.strip s)


(* Annotations *)

let extract_annots s =
  (Utils.str_extract s "gccxml(" ')')


(* Map Types *)

(* Map Enums *)

let map_enum e =
  { S.e_name = e.R.e_name;
    S.e_values =
      List.map (fun ev ->
        { S.ev_name = ev.R.ev_name;
          S.ev_init = ev.R.ev_init;
        }
      ) e.R.e_values
  }


(* Map Structs *)

let map_fields ns fields =
  List.map (fun fld ->
    let fld_name = fld.R.fld_name in
    let fld_type = get_type_name ns fld.R.fld_type in
    let fld_annots = extract_annots fld.R.fld_annot in
    S.Field { S.
      fld_name;
      fld_type;
      fld_annots;
    }
  ) fields


let print_arg ns arg =
  Printf.printf "   @ Arg: t:%s name:%s annot:'%s'\n"
    arg.R.arg_type
    arg.R.arg_name
    (String.concat " "
      (extract_annots arg.R.arg_annot))

let print_constructor ns c =
  Printf.printf "  @ Constructor: %s\n" c.R.c_name;
  List.iter (print_arg ns) c.R.c_args

let print_member ns = function
  | R.Field field -> ()
  | R.Constructor c -> print_constructor ns c
  | R.Destructor _
  | R.Method _
  | R.OperatorMethod _ -> ()
  | R.Mbr _id ->
      Printf.printf "  @ Member: id:%s\n" _id

let filter_fields members =
  List.fold_left (fun acc -> function
    | R.Field field -> field :: acc
    | _ -> acc
  ) [] (List.rev members)

let map_struct ns st =
  let fields = filter_fields st.R.st_members in
  let fields = map_fields ns fields in
  { S.st_name = st.R.st_name;
    S.st_members = fields;
  }


(* Map Union *)

let map_union ns u =  (* TODO *)
  let fields = filter_fields u.R.u_members in
  let mem = map_fields ns fields in
  { S.u_name = u.R.u_name;
    S.u_members = mem;
  }


(* Map ArrayType *)

let map_array ns ar =
  { S.
    ar_min = ar.R.ar_min;
    ar_max = ar.R.ar_max;
    ar_type = get_type_name ns ar.R.ar_type;
    ar_size = ar.R.ar_size;
    ar_align = ar.R.ar_align;
  }


(* Map Typedef *)

let map_typedef ns td =
  { S.
    td_name = td.R.td_name;
    td_type =
      match td.R.td_type with
      | Some _id -> get_type_name ns _id
      | None -> ""
  }


(* Map Variable *)

let map_variable ns var =
  { S.
    var_name = var.R.var_name;
    var_type = get_type_name ns var.R.var_type;
  }


(* Map CvQual *)

let map_qual = function
  | R.Const    -> S.Const
  | R.Volatile -> S.Volatile
  | R.Restrict -> S.Restrict


let map_cvQual ns qv =
  { S.cv_qual = map_qual qv.R.cv_qual;
    S.cv_type = get_type_name ns qv.R.cv_type;
  }


let map_type ns t =
  match t with
  | R.FundT ft -> S.FundT ft
  | R.Enum e -> S.Enum (map_enum e)
  | R.ArrayType ar -> S.ArrayType (map_array ns ar)
  | R.Struct st -> S.Struct (map_struct ns st)
  | R.Typedef td -> S.Typedef (map_typedef ns td)
  | R.Union u -> S.Union (map_union ns u)
  | R.Class cl -> failwith "TODO: map class"
  | R.CvQual qv -> S.CvQual (map_cvQual ns qv)
  | R.Ptr _id -> S.Ptr (get_type_name ns _id)
  | R.Variable var -> S.Variable (map_variable ns var)
  | R.Ellipsis -> S.Ellipsis
  | R.TODO td -> S.TODO td



(* Map Functions *)

let map_arg ns arg =
  let arg_name = arg.R.arg_name in
  let arg_type = get_type_name ns arg.R.arg_type in
  let arg_annots = extract_annots arg.R.arg_annot in
  { S.
    arg_name;
    arg_type;
    arg_annots;
  }


let map_function ns f =
  let fun_name = f.R.f_name in
  let fun_ret = get_type_name ns f.R.f_ret in
  let fun_annots = extract_annots f.R.f_annot in
  let fun_args = List.map (map_arg ns) f.R.f_args in
  { S.
    fun_name;
    fun_ret;
    fun_annots;
    fun_args;
  }


let debug_ts ts =
  List.iter (function
  | S.FundT ft -> Printf.eprintf " S.FundT: %s\n" ft
  | S.Enum e -> Printf.eprintf " S.Enum: %s\n" e.S.e_name
  | S.ArrayType _ -> ()
  | S.Struct st -> Printf.eprintf " S.Struct: %s\n" st.S.st_name
  | S.Typedef td -> Printf.eprintf " S.Typedef: %s\n" td.S.td_name
  | S.Union u -> Printf.eprintf " S.Union: %s\n" u.S.u_name
  | S.Class cl -> ()
  | S.CvQual qv -> ()
  | S.Ptr _id -> ()
  | S.Variable var -> Printf.eprintf " S.Variable: %s\n" var.S.var_name
  | S.Ellipsis -> ()
  | S.TODO td -> ()
  ) ts


let stringify a (ts, fs) =
  (* get names of types *)
  let ns = collect_type_names ts in

  (* map types *)
  let ts = List.map (fun (_id, type_kind) -> map_type ns type_kind) ts in

  (* DEBUG
  *)
  debug_ts ts;

  (* map functions *)
  let fs = List.filter no_builtin fs in
  let fs = List.map (map_function ns) fs in

  (ts, fs)
