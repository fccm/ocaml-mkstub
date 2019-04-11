(** Just some utility functions *)

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
(** [starts_with b s] checks if [s] starts with [b] *)

val rem_prefix : string -> string -> string
(** [rem_prefix s prefix] removes [prefix] from the beginning of [s] *)

val underscore : string -> string
(** [underscore s] replaces all spaces by underscores in [s] *)

val is_alpha_num : string -> bool
(** [is_alpha_num s] checks if all characters of [s] belong to:
    ['a'..'z' | 'A'..'Z' | '0'..'9' | '_']
*)

val join_multiline : string list -> string list
(** [["alpha"; "beta \\"; "gamma"; "delta"]]
    becomes
    [["alpha"; "beta gamma"; "delta"]] *)

(** {5 I/O} *)

val read_lines : string -> string list
val read_file : string -> string

val read_file_join : string -> string
(** same than [read_file] but uses [join_multiline] *)

val input_ic : in_channel -> string
val output_oc : out_channel -> string -> unit

(** {5 Pipes} *)

val command : string -> string -> string
val command_pipe : string -> string -> string -> string

(** {5 Lists} *)

(** {6 List Map} *)

val list_map : ('a -> 'b) -> 'a list -> 'b list
(** tail-rec [List.map] *)

val list_map_failsafe : ('a -> 'b) -> 'a list -> 'b list
(** if the application of an element of the list raises an exception,
    its result is not accumulated in the returned list (so then length
    of the returned list may be smaller than the input one) *)

val list_map_opt : ('a -> 'b option) -> 'a list -> 'b list
(** same than [List.map] but discards elements when [None] is returned *)

(** {6 List Assoc} *)

val assoc : 'a -> ('a * 'b) list -> 'b
(** same then [List.assoc] *)

val assoc_err : 'a -> ('a * 'b) list -> string -> 'b
(** same then [List.assoc] but with a custom error message *)

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
