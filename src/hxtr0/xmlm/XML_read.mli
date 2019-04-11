(** Read XML input into an XML tree *)

type attr = string * string
type tag = string * attr list

type tree = X of tag * tree list

type input = [ `IC of in_channel | `STR of string ]

val xml_tree : input -> tree
