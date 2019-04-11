(** Read XML *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

open Xmlm

type attr = string * string
type tag = string * attr list

type _tree = E of tag * _tree list | D of string

type tree = X of tag * tree list

type input = [ `IC of in_channel | `STR of string ]


let conv_attr = function
  | ((ns, attr_name), attr_val) -> (attr_name, attr_val)

let conv_tag = function
  | ((ns, tag_name), attrs) -> (tag_name, List.map conv_attr attrs)

let in_tree i = 
  let el tag childs = E (conv_tag tag, childs)  in
  let data d = D d in
  Xmlm.input_doc_tree ~el ~data i

let rec no_pcdata = function
  | E (tag, childs) -> X (tag, Utils.lst_map no_pcdata childs)
  | D "" -> failwith "no_pcdata"
  | D _ -> failwith "no_pcdata"

let xml_tree src =
  let map_src = function
    | `IC ic -> (`Channel ic)
    | `STR s -> (`String (0,s))
  in
  let xi = Xmlm.make_input ~strip:true (map_src src) in
  let _, xt = in_tree xi in
  no_pcdata (xt)
