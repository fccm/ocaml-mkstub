open Stmpl

let tmpl = "
{(List_name)}:
{<List_repeat<{
  ** {(Something)}
{<SubList_repeat<{    ++ {(Foo)}
}>SubList_repeat>}
}>List_repeat>}
"

let () =
  print_endline tmpl;
  print tmpl [
    VAR ("List_name", "dummy list");
    LIST ("List_repeat",
      [
        [ VAR ("Something", "foo");
          LIST ("SubList_repeat",
            [
              [ VAR ("Foo", "A this 1") ];
              [ VAR ("Foo", "A this 2") ];
              [ VAR ("Foo", "A this 3") ];
            ]
          );
        ];
        [ VAR ("Something", "bar");
          LIST ("SubList_repeat",
            [
              [ VAR ("Foo", "B this 1") ];
              [ VAR ("Foo", "B this 2") ];
              [ VAR ("Foo", "B this 3") ];
            ]
          );
        ];
        [ VAR ("Something", "baz");
          LIST ("SubList_repeat",
            [
              [ VAR ("Foo", "C this 1") ];
              [ VAR ("Foo", "C this 2") ];
              [ VAR ("Foo", "C this 3") ];
            ]
          );
        ];
      ]
    );
  ]
