BDIR="../../.."

$BDIR/bin/hxtr_ocaml \
  --failsafe \
  -ih /usr/include/stdlib.h \
  --only atoi

ocamlopt -shared -o gen.cmxs \
  -I $BDIR/src/include/ \
  generated.ml generated_stub.c


ocamlnat gen.cmxs test_gen.ml
