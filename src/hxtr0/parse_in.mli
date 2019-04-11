type id = Gccxml_t.id

val of_gccxml :
  Cmd_line.a ->
  Gccxml_t.t list ->
    (Gccxml_t.id * string Repr_t.type_kind) list *
      string Repr_t.func list
