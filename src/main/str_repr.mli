(** *)

val stringify :
  'a ->
  (Repr_t.id * 'b Repr_t.type_kind) list * Repr_t.id Repr_t.func list ->
  S_repr_t.type_kind list * S_repr_t.s_fun list
