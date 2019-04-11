let () =
  let fn = Sys.argv.(1) in
  let xs = Xmlerr.parse_file fn in
  let xs = Xmlerr.strip_white xs in
  Xmlerr.print_code xs
