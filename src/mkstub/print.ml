open Hrepr_t
open Stmpl

let print_f a f =
  let replace = [
    VAR ("Func_name", f.f_name);
    VAR ("Fun_return_type", f.f_return_type);
  ] in
  Stmpl.print template replace
;;

