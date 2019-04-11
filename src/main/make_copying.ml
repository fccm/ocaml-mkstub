let () =
  let s = Utils.read_file Sys.argv.(1) in
  Printf.printf "let s =\n%S" s
