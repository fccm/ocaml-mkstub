(* Load XML from the input *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

open Cmd_line

let input_gccxml a h_file =
  let inc = if a.incdir = "" then "" else Printf.sprintf "-I%s" a.incdir in
  let cmd = Printf.sprintf "gccxml %s %s -fxml=/dev/stdout" inc h_file in
  let s = Utils.command cmd "input_gccxml" in
  (s)

let pipe_stdin_gccxml a =
  let p = Utils.input_ic stdin in
  let inc = if a.incdir = "" then "" else Printf.sprintf "-I%s" a.incdir in
  let cmd = Printf.sprintf "gccxml %s - -fxml=/dev/stdout" inc in
  let s = Utils.command_pipe cmd p "pipe_gccxml" in
  (s)

let get_xml_tree a =
  let noclose = fun () -> () in
  let close_ic ic = fun () -> close_in ic in
  let src, close_src =
    match a.in_file with
    | XML_in "-" -> (`IC stdin), noclose
    | XML_in xml_file -> let ic = open_in xml_file in (`IC ic), close_ic ic
    | H_in "-" -> let s = pipe_stdin_gccxml a in (`STR s), noclose
    | H_in h_file -> let s = input_gccxml a h_file in (`STR s), noclose
    | No_in -> failwith "no input"
  in
  let xt = XML_read.xml_tree src in
  close_src ();
  (xt)
