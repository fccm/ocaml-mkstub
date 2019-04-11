(** Representation of the contents of a C header file *)
(** Same types than in [Repr_t] but with id's converted to
    plain strings. *)

(** argument of a function *)
type arg = {
  arg_type : string;        (** the type of the argument *)
  arg_name : string;        (** name of the argument *)
  arg_annots : string list; (** annotation for the argument *)
}

(** a function *)
type s_fun = {
  fun_name : string;        (** name of the function *)
  fun_ret : string;         (** the type of the return *)
  fun_annots : string list; (** annotation for the function *)
  fun_args : arg list;      (** arguments *)
}

(** value of an enum *)
type enum_val = {
  ev_name : string;
  ev_init : string;
}
(* XXX: the current gccxml doesn't seem to allow annotations for enum values *)

(** enumeration *)
type enum = {
  e_name : string;          (** enum name *)
  e_values : enum_val list; (** the values of the enum *)
}
(* XXX: the current gccxml dosn't seem to allow annotations for enums *)

(** array type *)
type array_t = {
  ar_min : string;
  ar_max : string;
  ar_type : string;
  ar_size : string;
  ar_align : string;
}

(** field of a structure *)
type st_field = {
  fld_name : string;        (** the type of the field *)
  fld_type : string;        (** name of the field *)
  fld_annots : string list; (** annotation for the field *)
}

(** constructor *)
type st_constructor = {
  c_name : string;
  c_args : arg list;
}

(** destructor *)
type st_destructor = {
  d_name : string;
}

(** method *)
type st_method = {
  m_name : string;
  m_returns : string;
  m_args : arg list;
}

(** operator-method *)
type st_operatormethod = {
  o_name : string;
  o_returns : string;
  (*
  o_artificial : string;
  o_throw : string;
  o_context : string;
  o_access : string;
  o_inline : string;
  *)
  o_args : arg list;
}

type st_member =
  | Field of st_field
  | Constructor of st_constructor
  | Destructor of st_destructor
  | Method of st_method
  | OperatorMethod of st_operatormethod


(** structure *)
type c_struct = {
  st_name : string;             (** structure *)
  st_members : st_member list;  (** members of the structure *)
}

(** union *)
type union = {
  u_name : string;
  u_members : st_member list;   (** members of the structure *)
}

(** typedef *)
type typedef = {
  td_name : string;
  td_type : string;
}

(** variable *)
type variable = {
  var_name : string;
  var_type : string;
}


(** qualification of a type *)
type qual = Const | Volatile | Restrict

type cvQual = {
  cv_qual : qual;
  cv_type : string;
}

type type_kind =
  | FundT of string         (** fundamental type (like int, float, etc) *)
  | Enum of enum
  | ArrayType of array_t
  | Struct of c_struct
  | Typedef of typedef
  | Union of union
  | Class of string         (** TODO *)
  | CvQual of cvQual
  | Ptr of string
  | Variable of variable
  | Ellipsis                (** [...] like in [printf(const char *fmt, ...)] *)
  | TODO of string          (** stuff not handled yet *)
