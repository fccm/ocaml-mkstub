(* Stmpl - a simple string template system
   Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided under the MIT license:
   http://en.wikipedia.org/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

type assoc = string * string
type param =
  | VAR of assoc
  | LIST of (string * param list list)

type cs = {
  var_chars : string;
  rep_chars : string;
}

let print_assoc oc lbl (a, b) = Printf.fprintf oc "  %s (%s, %s)\n" lbl a b
let print_var oc var = print_assoc oc "VAR" var

let rec print_list oc (lst, args) =
  Printf.fprintf oc "  LIST (%s,\n" lst;
  List.iter (fun arg ->
    Printf.fprintf oc "  [\n";
      List.iter (print_param oc) arg;
    Printf.fprintf oc "  ];\n";
  ) args;
  Printf.fprintf oc "  )\n"

and print_param oc = function
  | VAR var -> print_var oc var
  | LIST lst -> print_list oc lst
;;

let print_params ?(oc = stdout) ps =
  List.iter (print_param oc) ps

let print_vars vs =
  List.iter (print_var stdout) vs

let print_lists lsts =
  List.iter (print_list stdout) lsts


let default_tag_chars = {
  var_chars = "{()}";
  rep_chars = "{<:<{}>>}";
}

let tag_chars
    ?(cs = default_tag_chars)
    ?var_chars
    ?rep_chars
    () =
  let var_chars =
    match var_chars with Some vc -> vc | None -> cs.var_chars
  in
  let rep_chars =
    match rep_chars with Some rc -> rc | None -> cs.rep_chars
  in
  { var_chars ; rep_chars }


let mkcs (var_chars, rep_chars) =
  { var_chars ; rep_chars }


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

  let rb_open  = rep_chars.[0], rep_chars.[1] in (* {< *)
  let rb_close = rep_chars.[3], rep_chars.[4] in (* <{ *)
  let re_open  = rep_chars.[5], rep_chars.[6] in (* }> *)
  let re_close = rep_chars.[7], rep_chars.[8] in (* >} *)
  let r_param = rep_chars.[2] in (* : *)

  let make_repeat_end_tag s =
    Printf.sprintf "%c%c%s%c%c"
      rep_chars.[5] rep_chars.[6] (* }> *)
      s
      rep_chars.[7] rep_chars.[8] (* >} *)
  in

  let str_m = function
    | `extern s         -> "`extern" ^ s
    | `repeat_inside s  -> "`repeat_inside " ^ s
    | `repeat_begin     -> "`repeat_begin "
    | `repeat_end s     -> "`repeat_end " ^ s
    | `repeat_join s    -> "`repeat_join " ^ s
    | `repeat_empty s   -> "`repeat_empty " ^ s
    | `repeat_after_1 s -> "`repeat_after_1 " ^ s
    | `repeat_after_2 s -> "`repeat_after_2 " ^ s
  in
  let str_tag = function
    | `RB_open  -> "`RB_open"
    | `RB_close -> "`RB_close"
    | `RE_open  -> "`RE_open"
    | `RE_close -> "`RE_close"
    | `R_param  -> "`R_param"
    | `c c -> Printf.sprintf "`c %c" c
  in
  let rec aux i j m acc =
    if j >= len then begin
      if i < len then
        Buffer.add_char b s.[i];
      let s = Buffer.contents b in
      List.rev (
        match m with
        | `extern _ -> (`STR s) :: acc
        | _ -> invalid_arg "seq_rep"
        (* DEBUG
        | `repeat_inside _ -> (`STR s) :: acc
        | `repeat_begin -> (`REP_S s) :: acc
        | `repeat_end _ -> (`REP_E s) :: acc
        | `repeat_join _ -> (`REP_J s) :: acc
        | `repeat_empty _ -> (`REP_M s) :: acc
        | `repeat_after _ -> (`REP_A s) :: acc
        *)
        )
      end
    else
    let si = s.[i] in
    let sj = s.[j] in
    let tag =
      let sij = (si, sj) in
      if sij = rb_open  then `RB_open  else
      if sij = rb_close then `RB_close else
      if sij = re_open  then `RE_open  else
      if sij = re_close then `RE_close else
      if si = r_param then `R_param else
      `c si
    in
    match tag, m with
    (* Parse repeat: *)
    (* {<Tag<{ *)
    | `RB_open, `extern _ ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`STR s) :: acc in
        aux (j+1) (j+2) `repeat_begin acc

    | `RB_close, `repeat_begin ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_M "") :: (`REP_J "") :: (`REP_S s) :: acc in
        aux (j+1) (j+2) (`repeat_inside s) acc

    (* {<Tag:join<{ *)
    (* {<Tag:before<{ *)
    | `RB_close, `repeat_join ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        if s <> "before" then
          let acc = (`REP_M "") :: (`REP_J s) :: acc in
          aux (j+1) (j+2) (`repeat_inside ot) acc
        else
          let acc = (`REP_B s) :: acc in
          aux (j+1) (j+2) (`extern ot) acc

    (* {<Tag:join:empty<{ *)
    | `RB_close, `repeat_empty ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_M s) :: acc in
        aux (j+1) (j+2) (`repeat_inside ot) acc

    (* Ignore other repeat tags inside one *)
    | `RB_open, `repeat_inside _
    | `RB_close, `repeat_inside _ ->
        Buffer.add_char b si;
        aux j (j+1) m acc

    | `RB_open, _
    | `RB_close, _ ->
        Printf.eprintf " @>  %s %s\n%!" (str_tag tag) (str_m m);
        invalid_arg "seq_rep"

    (* }>Tag>} *)
    | `RE_open, `repeat_inside ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`STR s) :: acc in
        aux (j+1) (j+2) (`repeat_end ot) acc

    | `RE_close, `repeat_end ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        if s = ot then
          let acc = (`REP_E s) :: acc in
          aux (j+1) (j+2) (`extern ot) acc
        else
          let re_tag = make_repeat_end_tag s in
          let acc = (`STR re_tag) :: acc in
          aux (j+1) (j+2) (`repeat_inside ot) acc

    (* }>Tag:after>} *)
    | `RE_open, `extern ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`STR s) :: acc in
        aux (j+1) (j+2) (`repeat_after_1 ot) acc

    | `R_param, `repeat_after_1 ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        if s = ot then
          aux j (j+1) (`repeat_after_2 ot) acc
        else
          invalid_arg "seq_rep"

    | `RE_close, `repeat_after_2 ot ->
        let s = Buffer.contents b in
        Buffer.clear b;
        if s = "after" then
          let acc = (`REP_A ot) :: acc in
          aux (j+1) (j+2) (`extern "") acc
        else
          invalid_arg "seq_rep"

    (* XXX *)
    (*
    | `RE_close, `extern ot ->
        Buffer.add_char b si;
        aux j (j+1) m acc
    *)

    | `RE_open, _
    | `RE_close, _ ->
        Printf.eprintf " @>  | %s, %s\n%!" (str_tag tag) (str_m m);
        invalid_arg "seq_rep"

    (* {<Tag:join<{ *)
    | `R_param, `repeat_begin ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_S s) :: acc in
        aux j (j+1) (`repeat_join s) acc

    (* {<Tag:join:empty<{ *)
    | `R_param, (`repeat_join ot) ->
        let s = Buffer.contents b in
        Buffer.clear b;
        let acc = (`REP_J s) :: acc in
        aux j (j+1) (`repeat_empty ot) acc

    | `R_param, `repeat_end _
    | `R_param, `repeat_empty _ ->
        Printf.eprintf " @>  %s %s\n%!" (str_tag tag) (str_m m);
        invalid_arg "seq_rep"

    | `R_param, `extern _
    | `R_param, `repeat_inside _ ->
        Buffer.add_char b r_param;
        aux j (j+1) m acc

    | `c c, m ->
        Buffer.add_char b c;
        aux j (j+1) m acc

    | _, _ ->
        Printf.eprintf " @>  %s %s\n%!" (str_tag tag) (str_m m);
        invalid_arg "seq_rep"
  in
  aux 0 1 (`extern "") []


let join_str tags =
  let rec aux acc = function
  | `STR s1 :: `STR s2 :: tl ->
      aux acc (`STR (s1 ^ s2) :: tl)
  | tag :: tl ->
      aux (tag :: acc) tl
  | [] ->
      List.rev acc
  in
  aux [] tags

let seq_rep rep_chars s =
  join_str (seq_rep rep_chars s)

let str_of_2c c1 c2 =
  Printf.sprintf "%c%c" c1 c2

let replace_vars var_chars vs ts =
  let v_open = str_of_2c var_chars.[0] var_chars.[1] in
  let v_close = str_of_2c var_chars.[2] var_chars.[3] in
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

  | `REP_B s -> (Printf.printf "# REP_B:%s:\n" s)
  | `REP_A s -> (Printf.printf "# REP_A:%s:\n" s)


let debug_rep_tag lbl s =
  Printf.sprintf "(%s(%s)%s)\n" lbl s lbl


let add_iter_var rep_args =
  let rep_args, _, _ =
    List.fold_left (fun (acc, i, j) arg ->
      let it = VAR ("i", string_of_int i) in
      let jt = VAR ("j", string_of_int j) in
      ((it::jt::arg)::acc, i+1, j+1)
    ) ([], 0, 1) rep_args
  in
  (List.rev rep_args)


let put_list_back (_, rc) rep_s rep_j rep_m s =
  let rb_open  = str_of_2c rc.[0] rc.[1] in (* {< *)
  let rb_close = str_of_2c rc.[3] rc.[4] in (* <{ *)
  let re_open  = str_of_2c rc.[5] rc.[6] in (* }> *)
  let re_close = str_of_2c rc.[7] rc.[8] in (* >} *)
  let r_param = rc.[2] in (* : *)
  Printf.sprintf "\
    %s%s\
      %c%s%c%s\
    %s\
      %s\
    %s%s%s\
  "
    rb_open  rep_s
      r_param  rep_j  r_param  rep_m
    rb_close
      s
    re_open  rep_s  re_close


type str_t = ?cs:cs -> string -> param list -> string


let proc_repeat (str : str_t) cs ls rep_s rep_j rep_m before after s =
  let lst = List.find (function LIST (l, _) -> l = rep_s | _ -> false) ls in
  let rep_args = match lst with LIST (_, ps) -> ps | _ -> raise Not_found in
  let rep_args = add_iter_var rep_args in
  let e =
    if rep_args = [] then rep_m else
    let rs = List.map (fun rep_arg -> str ~cs:(mkcs cs) s rep_arg) rep_args in
    before ^ (String.concat rep_j rs) ^ after
  in
  (e)

let proc_repeat str cs ls rep_s rep_j rep_m before after s =
  try proc_repeat str cs ls rep_s rep_j rep_m before after s
  with Not_found -> put_list_back cs rep_s rep_j rep_m s


let rec make_repeat str cs ls acc = function [] -> acc
  | `REP_S rep_b ::  (* with before, with after *)
    `REP_B "before" ::
    `STR before ::
    `REP_S rep_s ::
    `REP_J rep_j ::
    `REP_M rep_m ::
    `STR s ::
    `REP_E rep_e ::
    `STR after ::
    `REP_A rep_a :: tl
    when rep_s = rep_e && rep_s = rep_b && rep_s = rep_a ->
      let e = proc_repeat str cs ls rep_s rep_j rep_m before after s in
      make_repeat str cs ls (e::acc) tl

  | `REP_S rep_b ::  (* with before, no after *)
    `REP_B "before" ::
    `STR before ::
    `REP_S rep_s ::
    `REP_J rep_j ::
    `REP_M rep_m ::
    `STR s ::
    `REP_E rep_e :: tl
    when rep_s = rep_e && rep_s = rep_b ->
      let e = proc_repeat str cs ls rep_s rep_j rep_m before "" s in
      make_repeat str cs ls (e::acc) tl

  | `REP_S rep_s ::  (* no before, with after *)
    `REP_J rep_j ::
    `REP_M rep_m ::
    `STR s ::
    `REP_E rep_e ::
    `STR after ::
    `REP_A rep_a :: tl
    when rep_s = rep_e && rep_s = rep_a ->
      let e = proc_repeat str cs ls rep_s rep_j rep_m "" after s in
      make_repeat str cs ls (e::acc) tl

  | `REP_S rep_s ::  (* no before, no after *)
    `REP_J rep_j ::
    `REP_M rep_m ::
    `STR s ::
    `REP_E rep_e :: tl
    when rep_s = rep_e ->
      (* DEBUG
      print_lists ls;
      *)
      let e = proc_repeat str cs ls rep_s rep_j rep_m "" "" s in
      make_repeat str cs ls (e::acc) tl

  | `STR s :: tl -> make_repeat str cs ls (s::acc) tl

  (* DEBUG *)
  | `REP_S s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_S" s :: acc) tl
  | `REP_J s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_J" s :: acc) tl
  | `REP_M s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_M" s :: acc) tl
  | `REP_E s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_E" s :: acc) tl

  | `REP_B s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_B" s :: acc) tl
  | `REP_A s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_A" s :: acc) tl


(* DEBUG
let rec make_repeat str cs ls acc = function [] -> acc
  | `STR s :: tl -> make_repeat str cs ls (debug_rep_tag "STR" s :: acc) tl

  | `REP_S s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_S" s :: acc) tl
  | `REP_J s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_J" s :: acc) tl
  | `REP_M s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_M" s :: acc) tl
  | `REP_E s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_E" s :: acc) tl

  | `REP_B s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_B" s :: acc) tl
  | `REP_A s :: tl -> make_repeat str cs ls (debug_rep_tag "REP_A" s :: acc) tl
*)


let rec str
    ?(cs = default_tag_chars)
    tmpl ps =

  let var_chars = cs.var_chars in
  let rep_chars = cs.rep_chars in

  if String.length var_chars <> 4 then invalid_arg "var_chars";
  if String.length rep_chars <> 9 then invalid_arg "rep_chars";

  let open_var = var_chars.[0], var_chars.[1] in
  let open_rep = rep_chars.[0], rep_chars.[1] in
  if open_var = open_rep then invalid_arg "var_chars and rep_chars: same open";

  let get_var = (fun p acc -> match p with VAR v -> v::acc | LIST _ -> acc) in
  let get_lst = (fun l acc -> match l with LIST _ -> l::acc | VAR _ -> acc) in
  let vs = List.fold_right get_var ps [] in
  let ls = List.fold_right get_lst ps [] in
  (*
  print_params ps;  (* DEBUG *)
  *)

  let r = tmpl in
  let r =
    String.concat "" (replace_vars var_chars vs (seq_var var_chars r))
  in

  let res =
    make_repeat str (var_chars, rep_chars) ls [] (seq_rep rep_chars r)
  in
  let res = String.concat "" (List.rev res) in

  (res : string)


let print ?cs tmpl ps =
  print_string (str ?cs tmpl ps)


(* Tags Extractions *)

module SSet = Set.Make(String)

let get_vars ts =
  List.fold_left (fun set -> function
  | `VAR v -> SSet.add v set
  | `STR _ -> set
  ) SSet.empty ts

let get_repeats ts =
  List.fold_left (fun set -> function
  | `REP_S v | `REP_E v -> SSet.add v set
  | _ -> set
  ) SSet.empty ts

let list_vars
    ?(cs = default_tag_chars)
    tmpl =
  SSet.elements (
    get_vars (seq_var cs.var_chars tmpl)
  )

let list_repeats
    ?(cs = default_tag_chars)
    tmpl =
  SSet.elements (
    get_repeats (seq_rep cs.rep_chars tmpl)
  )

let list_tags ?(cs = default_tag_chars) tmpl =
  (list_vars ~cs tmpl)
  @
  (list_repeats ~cs tmpl)


(* *)

let get_list_len ps =
  let rec aux acc = function
    | [] -> (List.rev acc)
    | VAR _ :: ps -> aux acc ps
    | LIST (lst_name, lst_args) :: ps ->
        let len = List.length lst_args in
        let this = (lst_name, len) in
        let acc =
          List.fold_left (fun acc ps ->
            aux acc ps
          ) (this::acc) lst_args
        in
        aux acc ps
  in
  aux [] ps

let add_len ?(cs = default_tag_chars) ps =
  let vs = get_list_len ps in
  let sep = String.make 1 cs.rep_chars.[2] in
  let ls = List.map (fun (lst_name, len) ->
    VAR (lst_name ^ sep ^ "len", string_of_int len)
  ) vs in
  ls @ ps

(* *)

(* Iterators on the parameters *)

let rec params_iter_assoc f ps =
  List.iter (function
  | VAR v -> f v
  | LIST (_, lst_args) ->
      List.iter (fun lst_arg ->
        params_iter_assoc f lst_arg
      ) lst_args
  ) ps


let rec params_map_assoc f ps =
  List.map (function
  | VAR v -> VAR (f v)
  | LIST (lst_name, lst_args) ->
      LIST (lst_name,
        List.map (params_map_assoc f) lst_args
      )
  ) ps


let rec params_fold_assoc f ps =
  List.fold_left (fun acc -> function
  | VAR v ->
      let vs = f v in
      let vs = List.map (fun v -> VAR v) vs in
      vs @ acc
  | LIST (lst_name, lst_args) ->
      (LIST (lst_name,
        List.map (params_fold_assoc f) lst_args
      )) :: acc
  ) [] (List.rev ps)
