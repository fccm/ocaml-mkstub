(** Reads the contents of the gccxml produced files *)

val gcc_xml :
  Cmd_line.a ->
  XML_read.tree ->
  Gccxml_t.t list
