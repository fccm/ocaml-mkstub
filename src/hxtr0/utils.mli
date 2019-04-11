(** Just some utils functions *)

(** {5 I/O} *)

val read_lines : string -> string list
val read_file : string -> string

val input_ic : in_channel -> string
val output_oc : out_channel -> string -> unit

(** {5 Pipes} *)

val command : string -> string -> string
val command_pipe : string -> string -> string -> string

(** {5 Strings} *)

val char_split : char -> string -> string list

val str_extract : string -> string -> char -> string list
(** example: {[
  let s = "Hello gccxml(export) World gccxml(import) Nada" in
  (str_extract s "gccxml(" ')')
]}
  returns: [["export"; "import"]]
*)

val strip : ?chars:string -> string -> string
val starts_with : string -> string -> bool
val rem_prefix : string -> string -> string

val underscore : string -> string
val is_alpha_num : string -> bool

val join_multiline : string list -> string list
(** [["alpha"; "beta \\"; "gamma"; "delta"]]
    becomes
    [["alpha"; "beta gamma"; "delta"]] *)

(** {5 Lists} *)

val lst_map : ('a -> 'b) -> 'a list -> 'b list
(** tail-rec [List.map] *)

val lst_map_failsafe : ('a -> 'b) -> 'a list -> 'b list
(** if the application of an element of the list raises an exception,
    its result is not accumulated in the returned list (so then length
    of the returned list may be smaller than the input one) *)

val assoc : 'a -> ('a * 'b) list -> 'b
(** same then [List.assoc] *)

val assoc_opt : 'a -> ('a * 'b) list -> 'b option
(** same than [List.assoc] but returns an [option] instead of raising a
    [Not_found] exception. *)

val assoc_default : 'a -> ('a * 'b) list -> 'b -> 'b
(** same than [List.assoc] but returns a default value instead of raising a
    [Not_found] exception. *)

val assoc_default_warn : 'a -> ('a * 'b) list -> 'b -> string -> 'b
(** same than [List.assoc] but returns a default value instead of raising a
    [Not_found] exception.

    In case this is the default value that is returned, prints a warning.
*)

(** {5 Debug} *)

val warning : string -> unit
(** prints a warning *)
