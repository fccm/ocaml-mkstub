(** sambung - helps wrapping C with higher level language *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

(* main *)
let () =
  let a = Cmd_line.parse_argv Sys.argv in
  let xml_tree = XML_load.get_xml_tree a in
  let gccxml = Gccxml_cnt.gcc_xml a xml_tree in
  let c_repr = Parse_in.of_gccxml a gccxml in
  let str_repr = Str_repr.stringify a c_repr in
  let h_repr = Conv.conv a str_repr in
  Print_hr.print a h_repr
