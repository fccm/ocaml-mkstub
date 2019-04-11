open Stmpl

let tmpl = "
{(List_name)}:
{<List_repeat<{
  ** {(Something)}
{<SubList_repeat<{    ++ {(Foo)}
}>SubList_repeat>}
  {(SubList_repeat:len)}
}>List_repeat>}

{(List_repeat:len)}
"

let replace =
  [
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
            ]
          );
        ];
        [ VAR ("Something", "baz");
          LIST ("SubList_repeat",
            [
              [ VAR ("Foo", "C this 1") ];
              [ VAR ("Foo", "C this 2") ];
              [ VAR ("Foo", "C this 3") ];
              [ VAR ("Foo", "C this 4") ];
            ]
          );
        ];
      ]
    );
  ]

let () =
  print_endline tmpl;
  print tmpl (add_len replace)
