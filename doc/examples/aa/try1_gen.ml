type blendMode =
  | BLENDMODE_NONE	(* [0] = 0 *)
  | BLENDMODE_BLEND	(* [1] = 1 *)
  | BLENDMODE_ADD	(* [2] = 2 *)
  | BLENDMODE_MOD	(* [3] = 4 *)


external {(Fun_name_cmd)} :
  unit ->  {(Fun_res_type_cmd)}
  = "ocaml_myfunc"

external {(Fun_name_cmd)} :
  {(Param_name_cmd)}int ->
  {(Param_name_cmd)}int ->
  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_add"

external {(Fun_name_cmd)} :
  unit ->  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_c"

external {(Fun_name_cmd)} :
  {(Param_name_cmd)}int ->
  {(Param_name_cmd)}PTR_int ->
  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_wei"

external {(Fun_name_cmd)} :
  {(Param_name_cmd)}int ->
  {(Param_name_cmd)}PTR_int ->
  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_arr"

external {(Fun_name_cmd)} :
  {(Param_name_cmd)}int ->
  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_ii"

external {(Fun_name_cmd)} :
  {(Param_name_cmd)}floatRect ->
  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_st"

external {(Fun_name_cmd)} :
  {(Param_name_cmd)}blendMode ->
  {(Fun_res_type_cmd)}
  = "ocaml_myfunc_blend"

