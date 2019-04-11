(** Minimalist string template *)

type assoc = string * string
type lst_arg = assoc list
type param =
  | VAR of assoc
  | LIST of (string * lst_arg list)

val str :
  ?var_chars:string ->
  ?rep_chars:string ->
  string ->
  param list -> string

val print :
  ?var_chars:string ->
  ?rep_chars:string ->
  string ->
  param list -> unit

(**
    A simple example:
{[
let () =
  let tmpl = "Hello {(Name)}, how are you?\n" in
  print tmpl [
    ("Name", "John");
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
        [ ("Something", "foo") ];
        [ ("Something", "bar") ];
        [ ("Something", "baz") ];
        [ ("Something", "qux") ];
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
        [ ("Item", "foo") ];
        [ ("Item", "bar") ];
        [ ("Item", "baz") ];
        [ ("Item", "qux") ];
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


  By default tags are identified like [{(Tag)}]
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

(** {3 Extractions} *)

val list_vars :
  ?var_chars:string ->
  string ->
  string list
(** tells which vars are available in a template *)

val list_repeats :
  ?rep_chars:string ->
  string ->
  string list
(** tells which repeat tags are available in a template *)

val list_tags :
  ?var_chars:string ->
  ?rep_chars:string ->
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
