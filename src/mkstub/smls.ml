open SExpr
open Smls_t

let _ = [
  Expr
   [Atom "struct"; Atom "floatRect";
    Expr [Atom "field"; Atom "float"; Atom "left"; Expr []];
    Expr [Atom "field"; Atom "float"; Atom "top"; Expr []];
    Expr [Atom "field"; Atom "float"; Atom "width"; Expr []];
    Expr [Atom "field"; Atom "float"; Atom "height"; Expr [Atom "ignore"]]];

  Expr
   [Atom "enum"; Atom "blendMode";
    Expr [Atom "e_val"; Atom "BLENDMODE_NONE"; Atom "0"];
    Expr [Atom "e_val"; Atom "BLENDMODE_BLEND"; Atom "1"];
    Expr [Atom "e_val"; Atom "BLENDMODE_ADD"; Atom "2"];
    Expr [Atom "e_val"; Atom "BLENDMODE_MOD"; Atom "4"]];

  Expr
   [Atom "fun"; Atom "myfunc_arr"; Atom "int"; Expr [];
    Expr [Atom "param"; Atom "int"; Atom "n"; Expr [Atom "len"]];
    Expr [Atom "param"; Atom "PTR_int"; Atom "arr"; Expr [Atom "len_p0"]]];
  Expr
   [Atom "fun"; Atom "myfunc_wei"; Atom "void"; Expr [Atom "export"];
    Expr [Atom "param"; Atom "int"; Atom "p"; Expr [Atom "in"]];
    Expr [Atom "param"; Atom "PTR_int"; Atom "ret"; Expr [Atom "out"]]];
  Expr
   [Atom "fun"; Atom "myfunc_add"; Atom "int"; Expr [];
    Expr [Atom "param"; Atom "int"; Atom "p1"; Expr []];
    Expr [Atom "param"; Atom "int"; Atom "p2"; Expr []]];
]

let map_annot = function
  | Atom ann -> ann
  | _ -> invalid_arg "map_annot"

let map_param = function
  Expr [Atom "param"; Atom param_type; Atom param_name; Expr param_annots] ->
    let param_annots = List.map map_annot param_annots in
    { param_type; param_name; param_annots }
  | _ ->
      invalid_arg "map_param"

let map_func = function
  Expr (
    Atom "fun" ::
    Atom fun_name ::
    Atom fun_ret ::
    Expr fun_annots ::
    fun_params) ->
      let fun_annots = List.map map_annot fun_annots in
      let fun_params = List.map map_param fun_params in
      { fun_name; fun_ret; fun_annots; fun_params }
  | _ ->
      invalid_arg "map_func"

let is_func = function
  | Expr (Atom "fun" :: _) -> true
  | _ -> false

let in_func_repr fn =
  let se = parse_file fn in
  let funcs = List.filter is_func se in
  List.map map_func funcs
