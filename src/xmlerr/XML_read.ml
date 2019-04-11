(** Read XML input into an XML tree *)

type attr = string * string
type tag = string * attr list

type tree = X of tag * tree list

type input = [ `IC of in_channel | `STR of string ]

let xml_tree _input =
  let _in =
    match _input with
    | `IC ic -> (Xmlerr.ic_input ic)
    | `STR s -> (Xmlerr.string_input s)
  in
  let xs = Xmlerr.parse _in in
  let xs = Xmlerr.strip_white xs in
  let rec aux _tag acc = function
  | [] ->
      (List.rev acc, [])

  | Xmlerr.Tag ("?xml", _) :: xs ->
      aux _tag acc xs

  | Xmlerr.Tag (tag_b, attrs) ::
    Xmlerr.ETag tag_e :: xs
    when tag_b = tag_e ->
      let x = X ((tag_b, attrs), []) in
      aux _tag (x::acc) xs

  | Xmlerr.Tag (tag_b, attrs) :: xs ->
      let childs, xs = aux tag_b [] xs in
      let x = X ((tag_b, attrs), childs) in
      aux _tag (x::acc) xs

  | Xmlerr.ETag etag :: xs ->
      if etag = _tag
      then (List.rev acc, xs)
      else failwith "Xmlerr.ETag"

  | Xmlerr.Data d :: _ -> failwith "Xmlerr.Data"
  | Xmlerr.Comm c :: _ -> failwith "Xmlerr.Comm"
  in
  aux "" [] xs

let xml_tree _input =
  match xml_tree _input with
  | [x], _ -> x
  | _ -> failwith "xml_tree"
