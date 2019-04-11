(** Print parsed elements using templaces *)

val print :
  Cmd_line.a ->
  S_repr_t.type_kind list * S_repr_t.s_fun list ->
  unit
