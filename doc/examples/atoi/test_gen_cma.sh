BDIR="../../.."

$BDIR/bin/hxtr_ocaml \
  --failsafe \
  -ih /usr/include/stdlib.h \
  --only atoi

ocamlc -c generated.ml 
ocamlc -c -I "$BDIR"/src/include/ generated_stub.c 
ocamlmklib -o gen generated.cmo
ocamlmklib -o gen generated_stub.o

ocaml -I . gen.cma test_gen.ml
