(** Parse command line arguments *)

(** input from hxtr *)
type input_kind =
  | SMLS_in of string
  | No_in

(** command line parameters *)
type a = {
  in_file : input_kind;
  exclude : string list;
  only : string list;
  char_split : char;
  rem_prefix : string list;
  extern_cmd : string;
  failsafe : bool;
  tag_chars : Stmpl.cs;

  template_f : string;
  template_e : string;
  template_s : string;
  template_u : string;
  template_f_vars : string list;
  template_e_vars : string list;
  template_s_vars : string list;
  template_u_vars : string list;
}

val parse_argv : string array -> a
