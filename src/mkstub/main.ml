
let () =
  let smls = Smls.in_func_repr "try1.ss" in
  let hrepr = List.map Conv.conv smls in
  List.iter Print.print_f hrepr
