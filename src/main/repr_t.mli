(** Representation of the contents of a C header file *)

type id = string

(** argument of a function *)
type 'a arg = {
  arg_type : 'a;            (** the type of the argument *)
  arg_name : string;        (** name of the argument *)
  arg_annot : string;       (** annotation for the argument *)
}

(** a function *)
type 'a func = {
  f_name : string;          (** name of the function *)
  f_ret : 'a;               (** the type of the return *)
  f_annot : string;         (** annotation for the function *)
  f_args : 'a arg list;     (** arguments *)
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
  ar_type : id;
  ar_size : string;
  ar_align : string;
}

(** field of a structure *)
type st_field = {
  fld_name : string;        (** the type of the field *)
  fld_type : id;            (** name of the field *)
  fld_annot : string;       (** annotation for the field *)
}

(** constructor *)
type 'a st_constructor = {
  c_name : string;
  c_args : 'a arg list;
}

(** destructor *)
type st_destructor = {
  d_name : string;
}

(** method *)
type 'a st_method = {
  m_name : string;
  m_returns : id;
  m_args : 'a arg list;
}

(** operator-method *)
type 'a st_operatormethod = {
  o_name : string;
  o_returns : id;
  (*
  o_artificial : string;
  o_throw : string;
  o_context : string;
  o_access : string;
  o_inline : string;
  *)
  o_args : 'a arg list;
}

type 'a st_member =
  | Field of st_field
  | Constructor of 'a st_constructor
  | Destructor of st_destructor
  | Method of 'a st_method
  | OperatorMethod of 'a st_operatormethod
  | Mbr of string


(** structure *)
type 'a c_struct = {
  st_name : string;                 (** structure *)
  st_members : 'a st_member list;   (** members of the structure *)
}

(** union *)
type 'a union = {
  u_name : string;
  u_members : 'a st_member list;    (** members of the structure *)
}

(** typedef *)
type typedef = {
  td_name : string;
  td_type : id option;
}

(** variable *)
type variable = {
  var_name : string;
  var_type : id;
}


(** qualification of a type *)
type qual = Const | Volatile | Restrict

type cvQual = {
  cv_qual : qual;
  cv_type : id;
}

type 'a type_kind =
  | FundT of string         (** fundamental type (like int, float, etc) *)
  | Enum of enum
  | ArrayType of array_t
  | Struct of 'a c_struct
  | Typedef of typedef
  | Union of 'a union
  | Class of string         (** TODO *)
  | CvQual of cvQual
  | Ptr of id
  | Variable of variable
  | Ellipsis                (** [...] like in [printf(const char *fmt, ...)] *)
  | TODO of string          (** stuff not handled yet *)
