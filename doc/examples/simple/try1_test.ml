module M = Try1

let repeat n f v =
  for i = 1 to n do f v done

let u lbl r f = (lbl, r, f)
let ut us =
  let n =
    List.fold_left (fun n (lbl, r, f) ->
      try
        let _r = f () in
        if _r = r then n else
          begin
            Printf.printf
            "# Test '%s' failed, found '%d' instead of '%d'\n%!" lbl _r r;
            (n+1)
          end
      with _ ->
        Printf.printf
          "# Test '%s' failed, exception raised\n%!" lbl;
        (n+1)
    ) 0 us
  in
  Printf.printf "# %d tests failed\n%!" n

let b = M.BLENDMODE_MOD
let st = { M.
  left   = 1.2;
  top    = 1.4;
  width  = 0.6;
  height = 0.801;
}

let () =
  ut [
  u "myfunc_c"     12 (fun () -> repeat 12 M.myfunc (); M.myfunc_c ());
  u "myfunc_ii"    43 (fun () -> M.myfunc_ii 40);
  u "myfunc_blend"  8 (fun () -> M.myfunc_blend b);
  u "myfunc_add"    5 (fun () -> M.myfunc_add ~p1:2 ~p2:3);
  u "myfunc_st"     4 (fun () -> truncate (M.myfunc_st st));
  u "myfunc_wei"   12 (fun () -> M.myfunc_wei 6);
  u "myfunc_arr"   10 (fun () -> M.myfunc_arr [| 1; 2; 3; 4 |]);
  ]
