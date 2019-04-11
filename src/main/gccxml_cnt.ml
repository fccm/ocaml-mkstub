(** Reads the contents of the gccxml produced files *)
open Cmd_line
open XML_read
open Gccxml_t


let list_map a f lst =
  if a.failsafe
  then Utils.list_map_failsafe f lst
  else Utils.list_map f lst


let assert_no_child childs lbl =
  if childs <> [] then
    Utils.warning (Printf.sprintf "%s: should have no child" lbl)

let assert_no_attrs attrs lbl =
  if attrs <> [] then
    Utils.warning (Printf.sprintf "%s: should have no attributes" lbl)

let print_assoc =
  List.iter (fun (a,b) -> Printf.printf " assoc (%s, %s)\n%!" a b) ;;


(* ==== FundamentalType ==== *)

(*
  <FundamentalType id="_740" name="bool" size="8" align="8"/>
*)
let read_fundamentaltype a attrs childs =
  assert_no_child childs "FundamentalType";
  let assoc_d attr =
    Utils.assoc_default attr attrs ""
  in
  {
    gx_ft_id    = assoc_d "id";
    gx_ft_name  = assoc_d "name";
    gx_ft_size  = assoc_d "size";
    gx_ft_align = assoc_d "align";
  }


(* ==== Enumeration ==== *)

(*
    <EnumValue name="BETA" init="1"/>
*)
let read_enum_value a = function
  | X (("EnumValue", attrs), childs) ->
      assert_no_child childs "EnumValue";
      {
        gx_ev_name = Utils.assoc "name" attrs;
        gx_ev_init = Utils.assoc "init" attrs;
      }
  | _ ->
      if a.failsafe
      then { gx_ev_name = ""; gx_ev_init = "" }
      else failwith "EnumValue"

(*
  <Enumeration id="_100" name="e_first" context="_1"
   location="f1:1" file="f1" line="1" artificial="1" size="32" align="32">
    <EnumValue name="ALPHA" init="0"/>
    <EnumValue name="BETA" init="1"/>
    <EnumValue name="GAMMA" init="2"/>
  </Enumeration>
*)
let read_enumeration a attrs childs =
  let warn attr =
    Printf.sprintf "Enumeration: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  {
    gx_e_id      = assoc_w "id";
    gx_e_name    = assoc_w "name";
    gx_e_context = assoc_w "context";
    gx_e_size    = assoc_w "size";
    gx_e_align   = assoc_w "align";
    gx_e_values  = List.map (read_enum_value a) childs;
  }


(* ArrayType *)
let read_arraytype a attrs childs =
  let warn attr =
    Printf.sprintf "ArrayType: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  {
    gx_ar_id    = assoc_w "id";
    gx_ar_min   = assoc_w "min";
    gx_ar_max   = assoc_w "max";
    gx_ar_type  = assoc_w "type";
    gx_ar_size  = assoc_w "size";
    gx_ar_align = assoc_w "align";
  }
(*
  <ArrayType id="_175" min="0" max="19u" type="_169" size="160" align="8"/>
*)


(* ==== Function ==== *)

(*
    <Argument type="_146" location="f1:16" file="f1" line="16"/>
*)
let read_argument a = function
  | X (("Argument", attrs), childs) ->
      assert_no_child childs "Argument";
      Arg {
        gx_a_type = Utils.assoc "type" attrs;
        gx_a_name = Utils.assoc_default "name" attrs "";
        gx_a_attributes = Utils.assoc_default "attributes" attrs "";
      }
  | X (("Ellipsis", attrs), childs) ->
      assert_no_child childs "Ellipsis";
      assert_no_attrs attrs "Ellipsis";
      Ellipsis
  | _ ->
      if a.failsafe
      then Arg { gx_a_name = ""; gx_a_type = ""; gx_a_attributes = "" }
      else failwith "Argument"

(*
  <Function id="_132" name="f2" returns="_146" context="_1"
   mangled="_Z2f2i" demangled="f2(int)"
   location="f1:16" file="f1" line="16" extern="1">
    <Argument type="_146" location="f1:16" file="f1" line="16"/>
  </Function>
*)
let read_function a attrs childs =
  let warn attr =
    Printf.sprintf "Function: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  let assoc_d attr =
    Utils.assoc_default attr attrs ""
  in
  {
    gx_f_id      = assoc_w "id";
    gx_f_name    = assoc_w "name";
    gx_f_returns = assoc_w "returns";
    gx_f_attributes = assoc_d "attributes";
    gx_f_args = Utils.list_map (read_argument a) childs;
  }


(* ==== Typedef ==== *)

let read_typedef a attrs childs =
  let warn attr =
    Printf.sprintf "Typedef: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  {
    gx_td_id      = assoc_w "id";
    gx_td_name    = assoc_w "name";
    gx_td_type    = assoc_w "type";
    gx_td_context = assoc_w "context";
  }
(*
  <Typedef id="_41" name="__swblk_t" type="_12" context="_1"
    location="f9:154" file="f9" line="154"/>
*)


(* ==== Union ==== *)

let read_union a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  let assoc_o attr =
    Utils.assoc_opt attr attrs
  in
  let _id = assoc "id" in
  let warn attr =
    Printf.sprintf "Union(%s): attribute %s not found" _id attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  let assoc_d attr =
    Utils.assoc_default attr attrs ""
  in
  {
    gx_u_id      = assoc_w "id";
    gx_u_name    = assoc_o "name";
    gx_u_context = assoc_d "context";
    gx_u_size    = assoc_w "size";
    gx_u_align   = assoc_w "align";
    gx_u_members = Utils.char_split ' ' (assoc_w "members");
    gx_u_bases   = assoc_w "bases";
  }
(*
  <Union id="_28" name="pthread_condattr_t" context="_1"
    mangled="18pthread_condattr_t" demangled="pthread_condattr_t"
    location="f7:105" file="f7" line="105" size="32" align="32"
    members="_760 _761 _762 _763 _764 _765 " bases=""/>

  <Union id="_91" context="_1" mangled="3._0" demangled="._0" location="f1:2"
    file="f1" line="2" artificial="1" size="160" align="32"
    members="_155 _156 _157 _158 _159 _160 _161 " bases=""/>
*)
(*
  <Union id="_58" name="my_data_t" context="_1"
    mangled="9my_data_t" demangled="my_data_t"
    location="f1:12" file="f1" line="12"
    size="128" align="32"
    members="_152 _153 _154 _155 _156 _157 " bases=""/>

  <Union id="_92" context="_1" mangled="3._0" demangled="._0"
    location="f1:2" file="f1" line="2"
    artificial="1"
    size="160" align="32"
    members="_162 _163 _164 _165 _166 _167 _168 " bases=""/>
*)


(* ==== Variable ==== *)

let read_variable a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_v_id      = assoc "id";
    gx_v_name    = assoc "name";
    gx_v_type    = assoc "type";
    gx_v_context = assoc "context";
  }
(*
  <Variable id="_34" name="my_data" type="_92" context="_1"
    location="f1:6" file="f1" line="6"/>
*)


(* ==== Struct ==== *)

let read_struct a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  let _id = assoc "id" in
  let warn attr =
    Printf.sprintf "Struct(%s): attribute %s not found" _id attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  let assoc_d attr =
    Utils.assoc_default attr attrs ""
  in
  {
    gx_s_id = _id;
    gx_s_name        = assoc_w "name";
    gx_s_context     = assoc_w "context";
    gx_s_access      = assoc_d "access";
    gx_s_artificial  = assoc_d "artificial";
    gx_s_size        = assoc_d "size";
    gx_s_align       = assoc_w "align";
    gx_s_members = Utils.char_split ' ' (assoc_d "members");
    gx_s_bases   = Utils.char_split ' ' (assoc_d "bases");
  }


let read_field a attrs childs =
  let warn attr =
    Printf.sprintf "Field: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  let assoc_d attr =
    Utils.assoc_default attr attrs ""
  in
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_fld_id      = assoc "id";
    gx_fld_name    = assoc "name";
    gx_fld_type    = assoc_w "type";
    gx_fld_access  = assoc_w "access";
    gx_fld_offset  = assoc_w "offset";
    gx_fld_context = assoc_d "context";
    gx_fld_attributes = assoc_d "attributes";
  }


(* ==== CvQualifiedType ==== *)

let read_cvqualifiedtype a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  let gx_cv_qual =
    List.fold_left (fun acc attr ->
      if List.mem (attr, "1") attrs
      then (attr :: acc)
      else (acc)
    ) []
      [ "const";
        "volatile";
        "restrict"; ]
  in
  {
    gx_cv_id   = assoc "id";
    gx_cv_type = assoc "type";
    gx_cv_qual;
  }


(* ==== Method ==== *)

let read_method a attrs childs =
  let warn attr =
    Printf.sprintf "Method: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  let assoc_d attr =
    Utils.assoc_default attr attrs ""
  in
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_m_id      = assoc "id";
    gx_m_name    = assoc_w "name";
    gx_m_returns = assoc_w "returns";
    gx_m_context = assoc_w "context";
    gx_m_access  = assoc_w "access";
    gx_m_inline  = assoc_d "inline";
    gx_m_args = Utils.list_map (read_argument a) childs;
  }
(*
  <Method id="_2108" name="__setdoit" returns="_1815" context="_710"
   access="public" mangled="_ZN23__pthread_cleanup_class9__setdoitEi"
   demangled="__pthread_cleanup_class::__setdoit(int)" location="f3:536"
   file="f3" line="536" endline="536" inline="1">
    <Argument name="__newval" type="_29"
     location="f3:536" file="f3" line="536"/>
  </Method>
*)


(* ==== OperatorMethod ==== *)

let read_operatormethod a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_o_id         = assoc "id";
    gx_o_name       = assoc "name";
    gx_o_returns    = assoc "returns";
    (*
    gx_o_artificial = assoc "artificial";
    gx_o_throw      = assoc "throw";
    gx_o_context    = assoc "context";
    gx_o_access     = assoc "access";
    gx_o_inline     = assoc "inline";
    *)
    gx_o_args = Utils.list_map (read_argument a) childs;
  }
(*
  <OperatorMethod id="_841" name="=" returns="_1302" artificial="1" throw=""
    context="_91" access="public" mangled="_ZN20yaml_tag_directive_taSERKS_"
    demangled="yaml_tag_directive_t::operator=(yaml_tag_directive_t
    const&amp;)" location="f2:94" file="f2" line="94" endline="94" inline="1">
      <Argument type="_1322" location="f14:29" file="f14" line="29"/>
  </OperatorMethod>
*)



(* ==== Constructor === *)

let read_constructor a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  let warn attr =
    Printf.sprintf "Constructor: attribute %s not found" attr
  in
  let assoc_w attr =
    Utils.assoc_default_warn attr attrs "" (warn attr)
  in
  {
    gx_c_id   = assoc "id";
    gx_c_name = assoc_w "name";
    gx_c_args = Utils.list_map (read_argument a) childs;
    (* TODO?
      artificial
      throw
      context
      access
      inline
    *)
  }
(*
  <Constructor id="_842" name="._26" artificial="1" throw="" context="_91"
    access="public" mangled="_ZN20yaml_tag_directive_tC1ERKS_ *INTERNAL* "
    demangled="yaml_tag_directive_t::yaml_tag_directive_t(yaml_tag_directive_t
    const&amp;)" location="f2:94" file="f2" line="94" endline="94" inline="1">

    <Argument type="_1303" location="f2:89" file="f2" line="89"/>
  </Constructor>
*)


(* ==== Destructor === *)

let read_destructor a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_d_id   = assoc "id";
    gx_d_name = assoc "name";
    (* TODO?
      artificial
      throw
      context
      access
      inline
    *)
  }
(*
  <Destructor id="_840" name="._26" artificial="1" throw="" context="_91"
    access="public" mangled="_ZN20yaml_tag_directive_tD1Ev *INTERNAL* "
    demangled="yaml_tag_directive_t::~yaml_tag_directive_t()" location="f2:94"
    file="f2" line="94" endline="94" inline="1">
*)


(* ==== ReferenceType ==== *)

(*
  <ReferenceType id="_174" type="_45c" size="32" align="32"/>
*)
let read_referencetype a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_r_id    = assoc "id";
    gx_r_type  = assoc "type";
    gx_r_size  = assoc "size";
    gx_r_align = assoc "align";
  }


(* ==== PointerType ==== *)

let read_pointertype a attrs childs =
  let assoc attr =
    Utils.assoc attr attrs
  in
  {
    gx_p_id    = assoc "id";
    gx_p_type  = assoc "type";
    gx_p_size  = assoc "size";
    gx_p_align = assoc "align";
  }
(*
  <PointerType id="_167" type="_150" size="32" align="32"/>
*)


let switch a = function
  | X (("FundamentalType", attrs), childs) ->
      FundamentalType (
        read_fundamentaltype a attrs childs)

  | X (("Enumeration", attrs), childs) ->
      Enumeration (
        read_enumeration a attrs childs)

  | X (("ArrayType", attrs), childs) ->
      ArrayType (
        read_arraytype a attrs childs)

  | X (("Function", attrs), childs) ->
      Function (
        read_function a attrs childs)

  | X (("Union", attrs), childs) ->
      Union (
        read_union a attrs childs)

  | X (("Struct", attrs), childs) ->
      Struct (
        read_struct a attrs childs)

  | X (("Field", attrs), childs) ->
      Field (
        read_field a attrs childs)

  | X (("Constructor", attrs), childs) ->
      Constructor (
        read_constructor a attrs childs)

  | X (("Destructor", attrs), childs) ->
      Destructor (
        read_destructor a attrs childs)

  | X (("Method", attrs), childs) ->
      Method (
        read_method a attrs childs)

  | X (("OperatorMethod", attrs), childs) ->
      OperatorMethod (
        read_operatormethod a attrs childs)

  | X (("ReferenceType", attrs), childs) ->
      ReferenceType (
        read_referencetype a attrs childs)

  | X (("Variable", attrs), childs) ->
      Variable (
        read_variable a attrs childs)

  | X (("Typedef", attrs), childs) ->
      Typedef (
        read_typedef a attrs childs)

  | X (("PointerType", attrs), childs) ->
      PointerType (
        read_pointertype a attrs childs)

  | X (("CvQualifiedType", attrs), childs) ->
      CvQualifiedType (
        read_cvqualifiedtype a attrs childs)

  | v ->
      TODO v


let gcc_xml a = function
  | X (("GCC_XML", _), cont) ->
      let gcc_xml_contents = list_map a (switch a) cont in
      (gcc_xml_contents)

  | _ ->
      failwith "wrong input"
