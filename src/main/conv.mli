(** Convert from [S_repr_t] to [H_repr_t] *)

val conv :
  Cmd_line.a ->
  S_repr_t.type_kind list * S_repr_t.s_fun list ->
  H_repr_t.func list
