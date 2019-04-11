(* hxtr - C header extractor
   Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
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
  let high_level_repr = Parse_in.of_gccxml a gccxml in
  Print_parsed.print a high_level_repr

(* vim: fdm=marker
 *)
