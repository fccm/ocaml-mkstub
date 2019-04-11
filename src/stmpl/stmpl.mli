(** Minimalist string template *)
(* Released under MIT license *)

type assoc = string * string
type param =
  | VAR of assoc
  | LIST of (string * param list list)

type cs

val tag_chars :
  ?cs:cs ->
  ?var_chars:string ->
  ?rep_chars:string ->
  unit ->
  cs

val str :
  ?cs:cs ->
  string ->
  param list -> string

val print :
  ?cs:cs ->
  string ->
  param list -> unit

(**
  A simple example:
{[
let () =
  let tmpl = "Hello {(Name)}, how are you?\n" in
  print tmpl [
    VAR ("Name", "John");
  ]
]}

  output:
  {["Hello John, how are you?"]}


  Second example, how to produce lists:
{[
let () =
  let tmpl = "
  {(List_name)}:\
  {<List_repeat<{
  ==> {(Something)}\
  }>List_repeat>}
" in
  print tmpl [
    VAR ("List_name", "dummy list");
    LIST ("List_repeat",
      [
        [ VAR ("Something", "foo") ];
        [ VAR ("Something", "bar") ];
        [ VAR ("Something", "baz") ];
        [ VAR ("Something", "qux") ];
      ]
    );
  ]
]}

  output: {["
  dummy list:
  ==> foo
  ==> bar
  ==> baz
  ==> qux
"]}


  Another example, joining items with a string:
{[
let () =
  let tmpl = "\
  {<Items_list:JOIN<{  {(Item)}  }>Items_list>}
" in
  print tmpl [
    LIST ("Items_list",
      [
        [ VAR ("Item", "foo") ];
        [ VAR ("Item", "bar") ];
        [ VAR ("Item", "baz") ];
        [ VAR ("Item", "qux") ];
      ]
    );
  ]
]}

  output: {[
"  foo  JOIN  bar  JOIN  baz  JOIN  qux  "
]}


  We can also provide an alternative element in case the list is empty:
{[
let () =
  let tmpl = "\
  {<Items_list:JOIN:EMPTY<{  {(Item)}  }>Items_list>}
" in
  print tmpl [
    LIST ("Items_list", []);
  ]
]}

  output: {["EMPTY"]}


  By default var tags are identified like [{(Tag)}]
  but if you would prefer to have [@[Tag]@]
  then use the parameter [~var_chars:"@[]@"].

  To customise repeat tags, use [~rep_chars]
  (its default is ["{<:<{}>>}"]).

  With [~rep_chars:"[@$[@]@]@"] the template will be:
{[
  [@Repeat$Join$Empty[@
  ]@Repeat]@
]}
*)

(** {3 Tags Extractions} *)

val list_vars :
  ?cs:cs ->
  string ->
  string list
(** tells which vars are available in a template *)

val list_repeats :
  ?cs:cs ->
  string ->
  string list
(** tells which repeat tags are available in a template *)

val list_tags :
  ?cs:cs ->
  string ->
  string list
(** tells which tags (vars and repeat) are available in a template *)


(** {3 Iterators on the associations of parameters} *)

val params_iter_assoc :
  (assoc -> unit) ->
  param list -> unit
(** iter the assocs from both the vars and the repeat lists *)

val params_map_assoc :
  (assoc -> assoc) ->
  param list ->
  param list
(** map the assocs from both the vars and the repeat lists *)

val params_fold_assoc :
  (assoc -> assoc list) ->
  param list ->
  param list
(** simili-fold the assocs from both the vars and the repeat lists

    If the returned list is empty the input assoc is removed.
    If several assocs are returned they are all added.
*)

(** {3 Debug} *)

val print_params :
  ?oc:out_channel ->
  param list -> unit
(** just a debug function *)

val add_len :
  ?cs:cs ->
  param list ->
  param list
(** adds [len] tags for lists *)
