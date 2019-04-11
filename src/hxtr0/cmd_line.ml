(** Parse command line arguments *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

(** input xml tree *)
type input_kind =
  | XML_in of string
  | H_in of string
  | No_in

(** command line parameters *)
type a = {
  in_file : input_kind;
  incdir : string;
  exclude : string list;
  only : string list;
  char_split : char;
  rem_prefix : string list;
  extern_cmd : string;
  failsafe : bool;
  tag_chars : Stmpl.cs;

  template_f : string;
  template_e : string;
  template_s : string;
  template_u : string;
  template_f_vars : string list;
  template_e_vars : string list;
  template_s_vars : string list;
  template_u_vars : string list;
}

let defaults = {
  in_file = No_in;
  incdir = "";
  exclude = [];
  only = [];
  char_split = ':';
  rem_prefix = [];
  extern_cmd = "";
  failsafe = false;
  tag_chars = Stmpl.tag_chars ();

  template_f = "";
  template_e = "";
  template_s = "";
  template_u = "";
  template_f_vars = [];
  template_e_vars = [];
  template_s_vars = [];
  template_u_vars = [];
}



let tpl_e a fn =
  let template_e = Utils.read_file fn in
  let template_e_vars = Stmpl.list_vars template_e in
  { a with template_e ; template_e_vars }

let tpl_f a fn =
  let template_f = Utils.read_file fn in
  let template_f_vars = Stmpl.list_vars template_f in
  { a with template_f ; template_f_vars }

let tpl_s a fn =
  let template_s = Utils.read_file fn in
  let template_s_vars = Stmpl.list_vars template_s in
  { a with template_s ; template_s_vars }

let tpl_u a fn =
  let template_u = Utils.read_file fn in
  let template_u_vars = Stmpl.list_vars template_u in
  { a with template_u ; template_u_vars }


let split_c cs =
  if String.length cs <> 1 then invalid_arg "split_char";
  cs.[0]

let splt = Utils.char_split


let long_options = [
  ("-ix",   "--in-xml");
  ("-ih",   "--in-h");
  ("-I",    "--inc");

  ("-tp-f", "--function-template");
  ("-tp-e", "--enum-template");
  ("-tp-s", "--struct-template");
  ("-tp-u", "--union-template");

  ("-tp-f", "-fun-tmpl");
  ("-tp-e", "-enum-tmpl");
  ("-tp-s", "-st-tmpl");
  ("-tp-u", "-union-tmpl");

  ("-vc",   "--var-chars");
  ("-rc",   "--rep-chars");

  ("-x",    "--exclude-from-file");
  ("-xs",   "--exclude");
  ("-ls",   "--only");

  ("-cs",   "--char-split");
  ("-cs",   "--char-spliter");
  ("-cs",   "--spliter-char");
  ("-cs",   "--split-c");

  ("-rp",   "--rem-prefix");
  ("-rp",   "--remove-prefix");

  ("-cmd",  "--command");
  ("-flt",  "--filter");

  ("-fs",   "--failsafe");
  ("-err",  "--err-fail");

  ("-copy", "--license");
  ("-copy", "--licensing");
  ("-copy", "--copying");
  ("-copy", "--copyright");

  ("-copy", "-license");
  ("-copy", "-licensing");
  ("-copy", "-copying");
  ("-copy", "-copyright");
]

let is_long_option op =
  List.exists (fun (short_op, long_op) -> op = long_op) long_options

let assoc_long_option op =
  fst (
    List.find (fun (short_op, long_op) -> op = long_op) long_options)

let read_long_options args =
  let rec aux acc = function
  | op :: arg :: args
    when is_long_option op ->
      let _op = assoc_long_option op in
      aux (arg :: _op :: acc) args
  | arg :: args -> aux (arg :: acc) args
  | [] -> List.rev acc
  in
  aux [] args


let var_chars a vc =
  let cs = a.tag_chars in
  { a with tag_chars = Stmpl.tag_chars ~cs ~var_chars:vc () }

let rep_chars a rc =
  let cs = a.tag_chars in
  { a with tag_chars = Stmpl.tag_chars ~cs ~rep_chars:rc () }


let parse_argv argv =
  let args = List.tl (Array.to_list argv) in
  let args = read_long_options args in
  let rem_pfx a pfx = { a with rem_prefix = pfx :: a.rem_prefix }
  and ex a ex_file = { a with exclude = Utils.read_lines ex_file @ a.exclude }
  and exs a ex_str = { a with exclude = (splt a.char_split ex_str) @ a.exclude }
  and only a nl_str = { a with only = (splt a.char_split nl_str) @ a.only }
  and spliter_char a cs = { a with char_split = split_c cs }
  in
  let rec aux a = function
  | "-ix" :: fn :: args -> aux { a with in_file = XML_in fn } args
  | "-ih" :: fn :: args -> aux { a with in_file = H_in fn } args
  | "-I" :: incdir :: args -> aux { a with incdir } args
  | "-tp-f" :: tp :: args -> aux (tpl_f a tp) args
  | "-tp-e" :: tp :: args -> aux (tpl_e a tp) args
  | "-tp-s" :: tp :: args -> aux (tpl_s a tp) args
  | "-tp-u" :: tp :: args -> aux (tpl_u a tp) args
  | "-vc" :: vc :: args -> aux (var_chars a vc) args
  | "-rc" :: rc :: args -> aux (rep_chars a rc) args
  | "-x" :: exclude :: args -> aux (ex a exclude) args
  | "-xs" :: exclude :: args -> aux (exs a exclude) args
  | "-ls" :: ls :: args -> aux (only a ls) args
  | "-cs" :: cs :: args -> aux (spliter_char a cs) args
  | "-rp" :: prefix :: args -> aux (rem_pfx a prefix) args
  | "-cmd" :: cmd :: args -> aux { a with extern_cmd = cmd } args
  | "-fs" :: args -> aux { a with failsafe = true } args
  | "-err" :: args -> aux { a with failsafe = false } args
  | "-copy" :: arg :: args -> print_endline Copying.s; exit 0
  | arg :: _ -> Printf.kprintf invalid_arg "Unknown arg: %s" arg
  | [] -> a
  in
  aux defaults args
