type blendMode =
  | BLENDMODE_NONE	(* [0] = 0 *)
  | BLENDMODE_BLEND	(* [1] = 1 *)
  | BLENDMODE_ADD	(* [2] = 2 *)
  | BLENDMODE_MOD	(* [3] = 4 *)


external myfunc :
  unit ->  unit
  = "ocaml_myfunc"

external myfunc_add :
  p1:int ->
  p2:int ->
  int
  = "ocaml_myfunc_add"

external myfunc_c :
  unit ->  int
  = "ocaml_myfunc_c"

external myfunc_ii :
  int ->
  int
  = "ocaml_myfunc_ii"

external myfunc_blend :
  blendMode ->
  int
  = "ocaml_myfunc_blend"

type st = {
  left   : float;
  top    : float;
  width  : float;
  height : float;
}
external myfunc_st: st -> float = "ocaml_myfunc_st"

external myfunc_wei: int -> int = "ocaml_myfunc_wei"

external myfunc_arr: int array -> int = "ocaml_myfunc_arr"
