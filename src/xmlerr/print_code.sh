cd `dirname $0`
/usr/bin/ocaml \
  -I $HOME/xmlerr xmlerr.cma \
  print_code.ml $*
