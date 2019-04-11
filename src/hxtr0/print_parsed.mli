(** Print parsed elements using templaces *)

val print :
  Cmd_line.a ->
    (Repr_t.id * string Repr_t.type_kind) list *
      string Repr_t.func list ->
        unit
