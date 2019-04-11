#BASE="$1"
BASE="try1"

echo \
ocamlopt -o tmp.opt \
  ${BASE}_c.c \
  ${BASE}_stub_m.c \
  ${BASE}.ml \
  ${BASE}_test.ml
