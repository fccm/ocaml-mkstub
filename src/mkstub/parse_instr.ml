module G = Genlex

open Instructions_t

let input_line_opt ic =
  try Some (input_line ic)
  with End_of_file -> close_in ic; None

let read_lines fn =
  let ic = open_in fn in
  let rec aux acc =
    match input_line_opt ic with
    | Some s -> aux (s::acc)
    | None -> List.rev acc
  in
  aux []

let last s =
  if s = "" then None else
    let len = String.length s in
    Some s.[len - 1]

let strip_last s =
  let len = String.length s in
  String.sub s 0 (len - 1)

let should_join s =
  (last s) = Some '\\'

let join s1 s2 =
  (strip_last s1) ^ s2

let join_lines lines =
  let rec aux acc = function
    | s1 :: s2 :: tl
      when should_join s1 -> aux acc (join s1 s2 :: tl)
    | s :: tl -> aux (s :: acc) tl
    | [] -> List.rev acc
  in
  aux [] lines

let rem_empty_lines lines =
  let rec aux acc = function
    | "" :: tl -> aux acc tl
    | s :: tl -> aux (s :: acc) tl
    | [] -> List.rev acc
  in
  aux [] lines

let endl = "@$@$@"

let read_ins_file fn =
  let lines = read_lines fn in
  let lines = join_lines lines in
  let lines = rem_empty_lines lines in
  String.concat endl lines


let keywords = [":"; "="; "("; ","; ")"; ";"; endl]

let read_tokens s =
  let lexer = Genlex.make_lexer keywords in
  let token_stream = lexer (Stream.of_string s) in
  let rec aux acc =
    try
      let tok = Stream.next token_stream in
      aux (tok::acc)
    with Stream.Failure ->
      List.rev acc
  in
  aux []


let str_token = function
  | G.Kwd s    -> Printf.sprintf "Kwd    %s" s
  | G.Ident s  -> Printf.sprintf "Ident  %s" s
  | G.String s -> Printf.sprintf "String %s" s
  | G.Int d    -> Printf.sprintf "Int    %d" d
  | G.Float d  -> Printf.sprintf "Float  %g" d
  | G.Char c   -> Printf.sprintf "Char   %c" c


let reftags = ["ENUM"; "STRUCT"; "FUNC"; "PARAM"; "TYPE"; "TEST"]
let is_reftags s =
  List.mem s reftags


type strm = [
  | `REFTAG of string
  | `ELEM_NAME of string
  | `IS
  | `STR of string
  | `OPEN_PAREN
  | `CLOSE_PAREN
  | `ARG_SEP
  | `INS_SEP
  | `ENDLINE
  ]


let conv_tokens toks =
  let i2s = string_of_int in
  let f2s = string_of_float in
  let c2s = String.make 1 in
  let rec aux acc = function
  | G.Kwd s :: tl when s = endl -> aux (`ENDLINE :: acc) tl

  | G.Ident s :: tl
    when is_reftags s -> aux (`REFTAG s :: acc) tl

  | G.Kwd ":" :: G.Ident elm :: tl ->
      aux (`ELEM_NAME elm :: acc) tl

  | G.Kwd "=" :: tl -> aux (`IS :: acc) tl

  | G.Kwd "(" :: tl -> aux (`OPEN_PAREN  :: acc) tl
  | G.Kwd ")" :: tl -> aux (`CLOSE_PAREN :: acc) tl
  | G.Kwd "," :: tl -> aux (`ARG_SEP     :: acc) tl
  | G.Kwd ";" :: tl -> aux (`INS_SEP     :: acc) tl

  | G.String s :: tl -> aux (`STR s :: acc) tl
  | G.Int d    :: tl -> aux (`STR (i2s d) :: acc) tl
  | G.Float d  :: tl -> aux (`STR (f2s d) :: acc) tl
  | G.Char c   :: tl -> aux (`STR (c2s c) :: acc) tl

  | G.Ident s :: tl -> aux (`STR s :: acc) tl

  | G.Kwd _ :: tl -> assert false

  | [] -> List.rev acc
  in
  aux [] toks


let split_enld toks =
  let rec aux acc this = function
    | `ENDLINE :: tl -> aux ((List.rev this)::acc) [] tl
    | v :: tl -> aux acc (v::this) tl
    | [] ->
        if this = [] then List.rev acc
        else List.rev ((List.rev this)::acc)
  in
  aux [] [] toks


let split_ins toks =
  let rec aux acc this = function
    | `INS_SEP :: tl -> aux ((List.rev this)::acc) [] tl
    | v :: tl -> aux acc (v::this) tl
    | [] ->
        if this = [] then List.rev acc
        else List.rev ((List.rev this)::acc)
  in
  aux [] [] toks


let join_str toks =
  let rec aux acc = function
  | `STR s1 :: `STR s2 :: tl ->
      let s = s1 ^ " " ^ s2 in
      aux acc (`STR s :: tl)
  | `STR s :: tl -> aux (`STR s :: acc) tl
  | v :: tl -> aux (v :: acc) tl
  | [] -> List.rev acc
  in
  aux [] toks


let read_params toks =
  let rec aux acc = function
  | `STR s :: `ARG_SEP :: tl -> aux (s::acc) tl
  | `STR s :: `CLOSE_PAREN :: [] -> List.rev (s::acc)
  | `CLOSE_PAREN :: [] -> List.rev acc
  | _ -> invalid_arg "read_params"
  in
  aux [] (join_str toks)


let read_op = function
  | `STR s :: [] -> (s, [])
  | `STR s ::
    `OPEN_PAREN :: tl -> (s, read_params tl)
  | _ -> invalid_arg "read_op"


let read_ins = function
  | `REFTAG reftag ::
    `ELEM_NAME parent_elem_name ::
    `ELEM_NAME elem_name ::
    `IS :: tl ->
      let ins = split_ins tl in
      let ops = List.map read_op ins in
      (reftag, [parent_elem_name; elem_name], ops)
  | `REFTAG reftag ::
    `ELEM_NAME elem_name ::
    `IS :: tl ->
      let ins = split_ins tl in
      let ops = List.map read_op ins in
      (reftag, [elem_name], ops)
  | _ ->
      invalid_arg "read_ins"


let str_ops (op, params) =
  let params = String.concat " , " params in
  Printf.sprintf " %s [ %s ]" op params

let print_ins (reftag, elem, ops) =
  let elem = String.concat " / " elem in
  let ops = List.map str_ops ops in
  let ops = String.concat " ; " ops in
  Printf.printf "%s @ %s # %s\n" reftag elem ops


let conv_target = function
  | "ENUM", [elem_name] ->
      ENUM_name (elem_name)
  | "ENUM", [parent_elem_name; elem_name] ->
      ENUM_val (parent_elem_name, elem_name)

  | "STRUCT", [elem_name] ->
      STRUCT_name (elem_name)
  | "STRUCT", [parent_elem_name; elem_name] ->
      STRUCT_field (parent_elem_name, elem_name)

  | "FUNC", [elem_name] ->
      FUNC (elem_name)
  | "PARAM", [parent_elem_name; elem_name] ->
      PARAM (parent_elem_name, elem_name)

  | "TYPE", [elem_name] ->
      TYPE (elem_name)

  | "TEST", [elem_name] ->
      TEST (elem_name, "")
  | "TEST", [parent_elem_name; elem_name] ->
      TEST (parent_elem_name, elem_name)

  | _ -> invalid_arg "conv_target"


let to_ins (reftag, elem, ops) =
  (conv_target (reftag, elem), ops)


let load_ins fn =
  let s = read_ins_file fn in
  let toks = read_tokens s in
  (* DEBUG
  List.iter print_endline (List.map str_token toks);
  *)
  let toks = conv_tokens toks in
  let toks = split_enld toks in
  let ins = List.map read_ins toks in
  (* DEBUG
  List.iter print_ins ins;
  *)
  (List.map to_ins ins)

(*
let () =
  let ins = load_ins Sys.argv.(1) in
  ignore ins
*)
