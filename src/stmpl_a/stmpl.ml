(* Stmpl - a simple string template system
   Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided under the MIT license:
   http://en.wikipedia.org/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

type assoc = string * string
type lst_arg = assoc list
type param =
  | VAR of assoc
  | LIST of (string * lst_arg list)

let print_assoc oc lbl (a, b) = Printf.fprintf oc "  %s (%s, %s)\n" lbl a b
let print_var oc var = print_assoc oc "VAR" var
let print_list oc (lst, args) =
  Printf.fprintf oc "  LIST (%s,\n" lst;
  List.iter (fun arg ->
    Printf.fprintf oc "  [\n";
    List.iter (print_assoc oc "  ") arg;
    Printf.fprintf oc "  ];\n";
  ) args;
  Printf.fprintf oc "  )\n";
;;
let print_param oc = function
  | VAR var -> print_var oc var
  | LIST lst -> print_list oc lst
;;

let print_params ?(oc = stdout) ps =
  List.iter (print_param oc) ps

let print_vars vs =
  List.iter (print_var stdout) vs

let print_lists lsts =
  List.iter (print_list stdout) lsts

let to_var vs =
  List.map (fun v -> VAR v) vs


let seq_var var_chars s =
  let len = String.length s in
  let b = Buffer.create len in
  let _ = "{()}" in  (* default *)
  let v_open = var_chars.[0], var_chars.[1] in
  let v_close = var_chars.[2], var_chars.[3] in
  let rec aux i j m acc =
    if j >= len then begin
      if i < len then
        Buffer.add_char b s.[i];
      let s = Buffer.contents b in
      List.rev (
        match m with
        | `extern -> (`STR s) :: acc
        | `var -> (`VAR s) :: acc
        )
      end
    else
    let tag =
      let sij = (s.[i], s.[j]) in
      if sij = v_open then `V_open else
      if sij = v_close then `V_close else
      `c s.[i]
    in
    match tag, m with
    (* Parse simple vars: *)
    | `V_open, `extern ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`STR s) :: acc in
        aux (j+1) (j+2) `var acc

    | `V_close, `var ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`VAR s) :: acc in
        aux (j+1) (j+2) `extern acc

    | `V_open, _
    | `V_close, _ ->
        invalid_arg "seq_var"

    | `c c, m ->
        Buffer.add_char b c;
        aux j (j+1) m acc
  in
  aux 0 1 `extern []



let seq_rep rep_chars s =
  let len = String.length s in
  let b = Buffer.create len in

  (* default *)
  (*      "012345678" *)
  let _ = "{<:<{}>>}" in

  let rb_open = rep_chars.[0], rep_chars.[1] in (* {< *)
  let rb_close = rep_chars.[3], rep_chars.[4] in (* <{ *)
  let re_open = rep_chars.[5], rep_chars.[6] in (* }> *)
  let re_close = rep_chars.[7], rep_chars.[8] in (* >} *)
  let r_param = rep_chars.[2] in (* : *)

  let rec aux i j m acc =
    if j >= len then begin
      if i < len then
        Buffer.add_char b s.[i];
      let s = Buffer.contents b in
      List.rev (
        match m with
        | `extern -> (`STR s) :: acc
        | `repeat_begin -> (`REP_S s) :: acc
        | `repeat_end -> (`REP_E s) :: acc
        | `repeat_join -> (`REP_J s) :: acc
        | `repeat_empty -> (`REP_M s) :: acc
        )
      end
    else
    let tag =
      let si = s.[i] in
      let sj = s.[j] in
      let sij = (si, sj) in
      if sij = rb_open  then `RB_open  else
      if sij = rb_close then `RB_close else
      if sij = re_open  then `RE_open  else
      if sij = re_close then `RE_close else
      if si = r_param then `R_param else
      `c s.[i]
    in
    match tag, m with
    (* Parse repeat: *)
    (* {<Tag<{ *)
    | `RB_open, `extern ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`STR s) :: acc in
        aux (j+1) (j+2) `repeat_begin acc

    | `RB_close, `repeat_begin ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_M "") :: (`REP_J "") :: (`REP_S s) :: acc in
        aux (j+1) (j+2) `extern acc

    (* {<Tag:join<{ *)
    | `RB_close, `repeat_join ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_M "") :: (`REP_J s) :: acc in
        aux (j+1) (j+2) `extern acc

    (* {<Tag:join:empty<{ *)
    | `RB_close, `repeat_empty ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_M s) :: acc in
        aux (j+1) (j+2) `extern acc

    | `RB_open, _
    | `RB_close, _ ->
        invalid_arg "seq_rep"

    (* }>Tag>} *)
    | `RE_open, `extern ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`STR s) :: acc in
        aux (j+1) (j+2) `repeat_end acc

    | `RE_close, `repeat_end ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_E s) :: acc in
        aux (j+1) (j+2) `extern acc

    | `RE_open, _
    | `RE_close, _ ->
        invalid_arg "seq_rep"

    (* {<Tag:join<{ *)
    | `R_param, `repeat_begin ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_S s) :: acc in
        aux j (j+1) `repeat_join acc

    (* {<Tag:join:empty<{ *)
    | `R_param, `repeat_join ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_J s) :: acc in
        aux j (j+1) `repeat_empty acc

    | `R_param, `repeat_end
    | `R_param, `repeat_empty ->
        invalid_arg "seq_rep"

    | `R_param, `extern ->
        Buffer.add_char b r_param;
        aux j (j+1) m acc

    | `c c, m ->
        Buffer.add_char b c;
        aux j (j+1) m acc
  in
  aux 0 1 `extern []



let replace_vars var_chars vs ts =
  let v_open = Printf.sprintf "%c%c" var_chars.[0] var_chars.[1] in
  let v_close = Printf.sprintf "%c%c" var_chars.[2] var_chars.[3] in
  List.map (function
  | `STR s -> s
  | `VAR s -> try List.assoc s vs with Not_found -> v_open ^ s ^ v_close
  ) ts


let print_token = function
  | `STR s   -> (Printf.printf "# STR:%s:\n" s)
  | `REP_S s -> (Printf.printf "# REP_S:%s:\n" s)
  | `REP_E s -> (Printf.printf "# REP_E:%s:\n" s)
  | `REP_J s -> (Printf.printf "# REP_J:%s:\n" s)
  | `REP_M s -> (Printf.printf "# REP_M:%s:\n" s)


let rec make_repeat ls acc = function [] -> acc
  | `REP_S rep_s ::
    `REP_J rep_j ::
    `REP_M rep_m ::
    `STR s ::
    `REP_E rep_e :: tl
    when rep_s = rep_e ->
      (* DEBUG
      print_lists ls;
      Printf.printf "'%s'\n%!" rep_s;
      *)
      let rep_args = List.assoc rep_s ls in
      let rep_args, _, _ = List.fold_left (fun (acc, i, j) arg ->
        let it = ("i", string_of_int i) in
        let jt = ("j", string_of_int j) in
        ((it::jt::arg)::acc, i+1, j+1)) ([], 0, 1) rep_args in
      let rep_args = List.rev rep_args in
      let e =
        if rep_args = [] then rep_m else
        let rrls = List.map (fun rep_arg -> str s (to_var rep_arg)) rep_args in
        String.concat rep_j rrls
      in
      make_repeat ls (e::acc) tl
  
  | `STR s :: tl -> make_repeat ls (s::acc) tl
  | `REP_S s :: tl -> make_repeat ls (Printf.sprintf "(REP_S(%s)REP_S)" s ::acc) tl
  | `REP_E s :: tl -> make_repeat ls (Printf.sprintf "(REP_E(%s)REP_E)" s ::acc) tl
  | `REP_J s :: tl -> make_repeat ls (Printf.sprintf "(REP_J(%s)REP_J)" s ::acc) tl
  | `REP_M s :: tl -> make_repeat ls (Printf.sprintf "(REP_M(%s)REP_M)" s ::acc) tl


and str
    ?(var_chars = "{()}")
    ?(rep_chars = "{<:<{}>>}")
    tmpl ps =
  if String.length var_chars <> 4 then invalid_arg "var_chars";
  if String.length rep_chars <> 9 then invalid_arg "rep_chars";

  let open_var = var_chars.[0], var_chars.[1] in
  let open_rep = rep_chars.[0], rep_chars.[1] in
  if open_var = open_rep then invalid_arg "var_chars and rep_chars: same open";

  let get_var = (fun p acc -> match p with VAR v -> v::acc | LIST _ -> acc) in
  let get_lst = (fun l acc -> match l with LIST l -> l::acc | VAR _ -> acc) in
  let vs = List.fold_right get_var ps [] in
  let ls = List.fold_right get_lst ps [] in
  (*
  print_params ps;  (* DEBUG *)
  *)

  let r = tmpl in
  let r =
    String.concat "" (replace_vars var_chars vs (seq_var var_chars r))
  in

  let rr = make_repeat ls [] (seq_rep rep_chars r) in
  let rrr =
    (String.concat "" (List.rev rr))
  in

  (rrr)


let print ?var_chars ?rep_chars tmpl ps =
  print_string (str tmpl ?var_chars ?rep_chars ps)


let get_vars ts =
  List.fold_left (fun acc -> function
  | `STR _ -> acc
  | `VAR v -> v::acc
  ) [] ts

let get_repeats ts =
  List.fold_left (fun acc -> function
  | `REP_S v | `REP_E v -> v::acc | _ -> acc
  ) [] ts

let list_vars
    ?(var_chars = "{()}")
    tmpl =
  get_vars (seq_var var_chars tmpl)

let list_repeats
    ?(rep_chars = "{<:<{}>>}")
    tmpl =
  get_repeats (seq_rep rep_chars tmpl)

let list_tags ?var_chars ?rep_chars tmpl =
  (list_vars ?var_chars tmpl)
  @
  (list_repeats ?rep_chars tmpl)


(* Iterators on the parameters *)

let params_iter_assoc f ps =
  List.iter (function
  | VAR v -> f v
  | LIST (_, lst_args) ->
      List.iter (fun lst_arg ->
        List.iter (fun v -> f v) lst_arg
      ) lst_args
  ) ps


let params_map_assoc f ps =
  List.map (function
  | VAR v -> VAR (f v)
  | LIST (lst_name, lst_args) ->
      LIST (lst_name,
        List.map (fun lst_arg ->
          List.map (fun v -> f v) lst_arg
        ) lst_args
      )
  ) ps


let params_fold_assoc f ps =
  List.fold_left (fun acc -> function
  | VAR v ->
      let vs = f v in
      let vs = List.map (fun v -> VAR v) vs in
      vs @ acc
  | LIST (lst_name, lst_args) ->
      (LIST (lst_name,
        List.map (fun lst_arg ->
          List.fold_left (fun acc v ->
            let vs = f v in
            vs @ acc
          ) [] lst_arg
        ) lst_args
      )) :: acc
  ) [] ps
