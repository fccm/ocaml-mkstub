open Stmpl

let tmpl = "
{(List_name)}:
{<List_repeat:before<{
  (BEFORE(\
{<List_repeat<{
  ** {(Something)}\
}>List_repeat>}
  )AFTER)
}>List_repeat:after>}
"

let () =
  print tmpl [
    VAR ("List_name", "dummy list");
    LIST ("List_repeat",
      [
        [ VAR ("Something", "foo") ];
        [ VAR ("Something", "bar") ];
        [ VAR ("Something", "baz") ];
      ]
    );
  ]
