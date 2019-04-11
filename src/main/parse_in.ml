(** Converts Gccxml_t.t input into higher Repr_t.t *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

open Cmd_line
open Repr_t
open Gccxml_t

module G = Gccxml_t
module R = Repr_t

type id = Gccxml_t.id

let list_map a f lst =
  let map =
    if a.failsafe
    then Utils.list_map_failsafe
    else Utils.list_map
  in
  map f lst


let map_enum_val ev = {
  ev_name = ev.gx_ev_name;
  ev_init = ev.gx_ev_init;
}

let enum_of_gx e = {
  e_name = e.gx_e_name;
  e_values = List.map map_enum_val e.gx_e_values;
}

let map_enum e =
  let id = e.gx_e_id in
  (id, R.Enum (enum_of_gx e))


let arraytype_of_gx ar = {
  ar_min   = ar.gx_ar_min;
  ar_max   = ar.gx_ar_max;
  ar_type  = ar.gx_ar_type;
  ar_size  = ar.gx_ar_size;
  ar_align = ar.gx_ar_align;
}

let map_arraytype ar =
  let id = ar.gx_ar_id in
  (id, R.ArrayType (arraytype_of_gx ar))


let ellipsis = {
  arg_type = "...";
  arg_name = "ellipsis";
  arg_annot = "";
}

let _map_arg arg = {
  arg_type =     arg.gx_a_type;
  arg_name =  arg.gx_a_name;
  arg_annot = arg.gx_a_attributes;
}

let map_arg = function
  | G.Arg arg -> _map_arg arg
  | G.Ellipsis -> ellipsis

let map_func f = {
  f_name  = f.gx_f_name;
  f_ret   = f.gx_f_returns;
  f_annot = f.gx_f_attributes;
  f_args  = List.map map_arg f.gx_f_args;
}


(*
let arg_map_types ts arg =
  (*
  { arg with arg_type = List.assoc arg.arg_type ts }
  *)
  { arg with
    arg_type =
      Utils.assoc_default_warn
        arg.arg_type ts
        (R.TODO "TODO (map)")
        (Printf.sprintf "Arg: %s not found" arg.arg_type)
  }

let fun_map_types ts f =
  { f with
    f_ret = List.assoc f.f_ret ts;
    f_args = List.map (arg_map_types ts) f.f_args;
  }
*)


let map_fundam_t ft =
  let id = ft.gx_ft_id in
  (id, FundT ft.gx_ft_name)


let map_field fld = {
  fld_name = fld.gx_fld_name;
  fld_type = fld.gx_fld_type;
  fld_annot = fld.gx_fld_attributes;
}

let map_constructor c = {
  c_name = c.gx_c_name;
  c_args = List.map map_arg c.gx_c_args;
}

let map_destructor d = {
  d_name = d.gx_d_name;
}

let map_method m = {
  m_name = m.gx_m_name;
  m_returns = m.gx_m_returns;
  m_args = List.map map_arg m.gx_m_args;
}

let map_operatormethod o = {
  o_name = o.gx_o_name;
  o_returns = o.gx_o_returns;
  o_args = List.map map_arg o.gx_o_args;
}

(*
let dummy_field _id = {
  fld_name = "dummy:" ^ _id;
  fld_type = "dummy";
  fld_annot = "dummy";
}
*)

let struct_of_gx a members st = {
  st_name = st.gx_s_name;
  st_members =
    list_map a (fun _id ->
      (*
      let err = Printf.sprintf "struct_of_gx: id:%s not found" _id in
      (Utils.assoc_err _id members err)
      *)
      (* TODO *)
      Utils.assoc_default_warn
        _id members
        (R.Mbr (Printf.sprintf "_ID_%s" _id))
        (Printf.sprintf "struct_of_gx: id:%s not found" _id)
    ) st.gx_s_members;

    (*
    List.map (fun _id ->
      Utils.assoc_default_warn
        _id members
        (dummy_field _id)
        (Printf.sprintf "struct_of_gx: id:%s not found" _id)
    ) st.gx_s_members;
    *)
}

let map_struct a members st =
  let id = st.gx_s_id in
  (id, R.Struct (struct_of_gx a members st))


let union_of_gx a members u = (* TODO *)
  let u_name = 
    match u.gx_u_name with Some s -> s | None -> "" 
  in
  {
    u_name;
    (*
    u_members = u.gx_u_members;
    *)
    u_members =
      list_map a (fun _id ->
        let err = Printf.sprintf "union_of_gx: id %s not found" _id in
        (Utils.assoc_err _id members err)
      ) u.gx_u_members;
  }

let map_union a members u =
  let id = u.gx_u_id in
  (id, R.Union (union_of_gx a members u))


let typedef_of_gx td = {
  td_name = td.gx_td_name;
  td_type = Some td.gx_td_type;
}

let map_typedef td =
  let id = td.gx_td_id in
  (id, R.Typedef (typedef_of_gx td))

let pointer_of_gx ptr =
  ptr.gx_p_type

let map_pointer ptr =
  let id = ptr.gx_p_id in
  (id, R.Ptr (pointer_of_gx ptr))

let variable_of_gx var = {
  var_name = var.gx_v_name;
  var_type = var.gx_v_type;
}

let map_variable var =
  let id = var.gx_v_id in
  (id, R.Variable (variable_of_gx var))

let qual q =
  assert (List.length q = 1);
  if List.mem "const" q then R.Const else
  if List.mem "volatile" q then R.Volatile else
  if List.mem "restrict" q then R.Restrict else
    Printf.kprintf failwith "CvQual: %s" (String.concat " " q)

let cvqual_of_gx ql = {
  cv_qual = qual ql.gx_cv_qual;
  cv_type = ql.gx_cv_type;
}

let map_cvqual ql =
  let id = ql.gx_cv_id in
  (id, R.CvQual (cvqual_of_gx ql))


let collect_members gccxml =
  List.fold_left (fun members -> function
    | G.Field fld ->
        let id = fld.gx_fld_id in
        (id, R.Field(map_field fld)) :: members

    | G.Constructor c ->
        let id = c.gx_c_id in
        (id, R.Constructor(map_constructor c)) :: members

    | G.Destructor d ->
        let id = d.gx_d_id in
        (id, R.Destructor(map_destructor d)) :: members

    | G.Method m ->
        let id = m.gx_m_id in
        (id, R.Method(map_method m)) :: members

    | G.OperatorMethod o ->
        let id = o.gx_o_id in
        (id, R.OperatorMethod(map_operatormethod o)) :: members

    | _ -> members
  ) [] gccxml


let collect_types a members gccxml =
  List.fold_left (fun ts -> function
    | G.FundamentalType ft -> (map_fundam_t ft) :: ts
    | G.Enumeration e -> (map_enum e) :: ts
    | G.ArrayType ar -> (map_arraytype ar) :: ts
    | G.Struct st -> (map_struct a members st) :: ts
    | G.Typedef td -> (map_typedef td) :: ts
    | G.Union u -> (map_union a members u) :: ts
    | G.PointerType ptr -> (map_pointer ptr) :: ts
    | G.CvQualifiedType ql -> (map_cvqual ql) :: ts

    | G.ReferenceType rt -> ts (* TODO *)
    | G.Variable var -> (map_variable var) :: ts

    | G.Function _ -> ts
    | G.Field _ -> ts
    | G.OperatorMethod _
    | G.Method _
    | G.Destructor _
    | G.Constructor _ -> ts

    | G.TODO xt -> ts (* TODO *)
  ) [] gccxml


let collect_functions gccxml =
  List.fold_left (fun fs -> function
    | G.Function f ->
        let _ = f.gx_f_id in
        (map_func f) :: fs
    | _ -> fs
  ) [] (List.rev gccxml)


let of_gccxml a gccxml =
  let members = collect_members gccxml in
  let ts = collect_types a members gccxml in
  let fs = collect_functions gccxml in

  (*
  (* replace type ids, by type info structures *)
  let fs = List.map (fun_map_types ts) fs in
  *)

  (ts, fs)
