(** Just the contents of the gccxml produced files *)

type id = string

(** GccXml Tag [Argument] *)
type gx_argument = {
  gx_a_name : string;
  gx_a_type : string;
  gx_a_attributes : string;
}

type gx_arg =
  | Arg of gx_argument
  | Ellipsis

(** GccXml Tag [Function] *)
type gx_func = {
  gx_f_id : id;
  gx_f_name : string;
  gx_f_returns : string;
  gx_f_attributes : string;
  gx_f_args : gx_arg list;
}

(** GccXml Tag [EnumValue] *)
type gx_enumvalue = {
  gx_ev_name : string;
  gx_ev_init : string;
}

(** GccXml Tag [Enumeration] *)
type gx_enumeration = {
  gx_e_id : id;
  gx_e_name : string;
  gx_e_context : string;
  gx_e_size : string;
  gx_e_align : string;
  gx_e_values : gx_enumvalue list;
}
(*
  <Enumeration id="_100" name="e_first" context="_1"
   location="f1:1" file="f1" line="1" artificial="1" size="32" align="32">
    <EnumValue name="ALPHA" init="0"/>
    <EnumValue name="BETA" init="1"/>
    <EnumValue name="GAMMA" init="2"/>
  </Enumeration>
*)

(** GccXml Tag [FundamentalType] *)
type gx_fundamentaltype = {
  gx_ft_id : id;
  gx_ft_name : string;
  gx_ft_size : string;
  gx_ft_align : string;
}
(*
  <FundamentalType id="_740" name="bool" size="8" align="8"/>
*)

(** GccXml Tag [ArrayType] *)
type gx_arraytype = {
  gx_ar_id : id;
  gx_ar_min : string;
  gx_ar_max : string;
  gx_ar_type : id;
  gx_ar_size : string;
  gx_ar_align : string;
}

(** GccXml Tag [Struct] *)
type gx_struct = {
  gx_s_id : id;
  gx_s_name : string;
  gx_s_context : string;
  gx_s_access : string;
  gx_s_artificial : string;
  gx_s_size : string;
  gx_s_align : string;
  gx_s_members : id list;
  gx_s_bases : string list;
}

(** GccXml Tag [Field] *)
type gx_field = {
  gx_fld_id : id;
  gx_fld_name : string;
  gx_fld_type : string;
  gx_fld_access : string;  (* example: "public" *)
  gx_fld_offset : string;
  gx_fld_context : string;
  gx_fld_attributes : string;
}

(** GccXml Tag [Method] *)
type gx_method = {
  gx_m_id : id;
  gx_m_name : string;
  gx_m_returns : id;
  gx_m_context : string;
  gx_m_access : string;
  gx_m_inline : string;
  gx_m_args : gx_arg list;
}

(** GccXml Tag [OperatorMethod] *)
type gx_operatormethod = {
  gx_o_id : id;
  gx_o_name : string;
  gx_o_returns : id;
  (*
  gx_o_artificial : string;
  gx_o_throw : string;
  gx_o_context : string;
  gx_o_access : string;
  gx_o_inline : string;
  *)
  gx_o_args : gx_arg list;
}

(** GccXml Tag [Constructor] *)
type gx_constructor = {
  gx_c_id : id;
  gx_c_name : string;
  gx_c_args : gx_arg list;
}

(** GccXml Tag [Destructor] *)
type gx_destructor = {
  gx_d_id : id;
  gx_d_name : string;
}

(** GccXml Tag [Union] *)
type gx_union = {
  gx_u_id : id;
  gx_u_name : string option;
  gx_u_context : string;
  gx_u_size : string;
  gx_u_align : string;
  gx_u_members : id list;
  gx_u_bases : string;
}

(** GccXml Tag [CvQualifiedType] *)
type gx_cvqualifiedtype = {
  gx_cv_id : id;
  gx_cv_type : id;
  gx_cv_qual : string list;
  (*
    ("const", "1")
    ("volatile", "1")
    ("restrict", "1")
  *)
}

(** GccXml Tag [Typedef] *)
type gx_typedef = {
  gx_td_id : id;
  gx_td_name : string;
  gx_td_type : id;
  gx_td_context : string;
}

(** GccXml Tag [Variable] *)
type gx_variable = {
  gx_v_id : id;
  gx_v_name : string;
  gx_v_type : id;
  gx_v_context : string;
}

(** GccXml Tag [ReferenceType] *)
type gx_referencetype = {
  gx_r_id : id;
  gx_r_type : string;
  gx_r_size : string;
  gx_r_align : string;
}

(** GccXml Tag [PointerType] *)
type gx_pointertype = {
  gx_p_id : id;
  gx_p_type : id;
  gx_p_size : string;
  gx_p_align : string;
}

(** Elements that can be found in the gccxml produced files *)
type t =
  | FundamentalType of gx_fundamentaltype
  | Enumeration of gx_enumeration
  | ArrayType of gx_arraytype
  | Function of gx_func
  | Struct of gx_struct
  | Field of gx_field
  | Constructor of gx_constructor
  | Destructor of gx_destructor
  | Method of gx_method
  | OperatorMethod of gx_operatormethod
  | Union of gx_union
  | Variable of gx_variable
  | CvQualifiedType of gx_cvqualifiedtype
  | Typedef of gx_typedef
  | PointerType of gx_pointertype
  | ReferenceType of gx_referencetype
  | TODO of XML_read.tree
