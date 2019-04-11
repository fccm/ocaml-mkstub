(** Just some utils functions *)
(* Copyright (C) 2012 Florent Monnier <monnier.florent(_)gmail.com>
   Code provided along the MIT license:
   See the file COPYING.txt or this URL:
   https://secure.wikimedia.org/wikipedia/en/wiki/MIT_License
   This software is provided "AS-IS", without warranty of any kind.
*)

(* Strings *)

let str_sub s ofs len =
  let res = String.create len in
  String.unsafe_blit s ofs res 0 len;
  res

let rec rindex_from s i c =
  if i < 0 then -1 else
  if String.unsafe_get s i = c
  then i
  else rindex_from s (i - 1) c

let rec char_split_rec ((c, s) as cs) i acc =
  match rindex_from s i c with
  | -1 ->
      if (i+1) = 0 then acc
      else str_sub s 0 (i+1) :: acc
  | j ->
      char_split_rec cs (j-1) (
        if (i-j) = 0
        then acc
        else (str_sub s (j+1) (i-j) :: acc)
      )

let char_split c s =
  if s = "" then [] else
  char_split_rec (c, s) (String.length s - 1) []

let str_index_from_opt s i c =
  try Some (String.index_from s i c)
  with Not_found -> None

let index_all s c =
  let rec aux i acc =
    match str_index_from_opt s i c with
    | Some pos -> aux (pos+1) (pos::acc)
    | None -> List.rev acc
  in
  aux 0 []

let str_match_all s pat =
  let pat_len = String.length pat in
  let ps = index_all s pat.[0] in
  List.filter (fun p ->
    try pat = (String.sub s p pat_len)
    with _ -> false
  ) ps

let str_extract s pat c =
  let pat_len = String.length pat in
  let ps = str_match_all s pat in
  List.fold_right (fun p acc ->
    let i = p + pat_len in
    match str_index_from_opt s i c with
    | Some j -> (String.sub s i (j - i)) :: acc
    | None -> acc
  ) ps []

let strip ?(chars=" \t\r\n") s =
  let p = ref 0 in
  let len = String.length s in
  while !p < len
  && String.contains chars (String.unsafe_get s !p) do
    incr p;
  done;
  let p = !p in
  let l = ref (len - 1) in
  while !l >= p
  && String.contains chars (String.unsafe_get s !l) do
    decr l;
  done;
  String.sub s p (!l - p + 1)

let starts_with b s =
  let l1 = String.length s
  and l2 = String.length b in
  l1 >= l2 && (String.sub s 0 l2) = b

let rem_prefix s prefix =
  let p_len = String.length prefix in
  let s_len = String.length s in
  if p_len >= s_len then s else
  if starts_with prefix s
  then String.sub s p_len (s_len - p_len)
  else s

let underscore s =
  let r = String.copy s in
  for i = 0 to String.length r - 1 do
    if r.[i] = ' ' then r.[i] <- '_'
  done;
  (r)

let is_alpha_num_char = function
  | 'a'..'z' | 'A'..'Z' | '0'..'9' | '_' -> true
  | _ -> false

let is_alpha_num s =
  try
    String.iter (fun c ->
      if not (is_alpha_num_char c) then raise Exit
    ) s;
    true
  with Exit ->
    false

let should_join s =
  let len = String.length s in
  len <> 0 && s.[len-1] = '\\'

let strip_last_char s =
  let len = String.length s in
  String.sub s 0 (len-1)

let join s1 s2 =
  (strip_last_char s1) ^ s2

let join_multiline ls =
  let rec aux acc = function
  | s1 :: s2 :: tl
    when should_join s1 ->
      let sj = join s1 s2 in
      aux acc (sj::tl)
  | s :: tl ->
      aux (s::acc) tl
  | [] ->
      List.rev acc
  in
  aux [] ls

(* I/O *)

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

let read_file fn =
  let ic = open_in fn in
  let n = in_channel_length ic in
  let s = String.create n in
  really_input ic s 0 n;
  close_in ic;
  (s)

let read_file_join fn =
  let lines = read_lines fn in
  let lines = join_multiline lines in
  String.concat "" (List.map (fun line -> line ^ "\n") lines)

let input_ic ic =
  let b = Buffer.create 60 in
  try while Buffer.add_char b (input_char ic); true do () done; assert false
  with End_of_file ->
    (Buffer.contents b)

let output_oc oc s =
  output_string oc s;
  flush oc

(* Pipes *)

let command cmd err_msg =
  let ic = Unix.open_process_in cmd in
  let r = input_ic ic in
  let st = Unix.close_process_in ic in
  if st <> Unix.WEXITED 0 then failwith err_msg;
  (r)

let command_pipe cmd p err_msg =
  let ic, oc = Unix.open_process cmd in
  output_oc oc p;
  close_out oc;
  let r = input_ic ic in
  let st = Unix.close_process (ic, oc) in
  if st <> Unix.WEXITED 0 then failwith err_msg;
  (r)

(* Debug *)

let warning msg =
  Printf.eprintf "# Warning: %s\n%!" msg

(* Lists *)

(* List Map *)

let list_map f lst =
  let rec aux acc = function
  | x :: xs -> aux (f x :: acc) xs
  | [] -> List.rev acc
  in
  aux [] lst

let list_map_opt f lst =
  let rec aux acc = function
  | [] -> List.rev acc
  | x :: xs ->
      match f x with
      | Some v -> aux (v :: acc) xs
      | None -> aux acc xs
  in
  aux [] lst

let fun_failsafe f x =
  try Some (f x)
  with _ ->
    warning "Item discarded from list map";
    None

let list_map_failsafe f lst =
  list_map_opt (fun_failsafe f) lst

(* List Assoc *)

let assoc x lst =
  let rec aux = function
  | (a,b)::tl -> if compare a x = 0 then b else aux tl
  | [] -> raise Not_found
  in aux lst

let assoc_err x lst err =
  let rec aux = function
  | (a,b)::tl -> if compare a x = 0 then b else aux tl
  | [] -> failwith err
  in aux lst

let assoc_opt x lst =
  let rec aux = function
  | (a,b)::tl -> if compare a x = 0 then Some b else aux tl
  | [] -> None
  in aux lst

let assoc_default x lst default =
  let rec aux = function
  | (a,b)::tl -> if compare a x = 0 then b else aux tl
  | [] -> default
  in aux lst

let assoc_default_warn x lst default msg =
  let rec aux = function
  | (a,b)::tl -> if compare a x = 0 then b else aux tl
  | [] -> warning msg; default
  in aux lst
