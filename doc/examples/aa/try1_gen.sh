HXTR="../hxtr/hxtr.opt"
TP="../share/templates/ocaml"

> try1_gen.ml
$HXTR -ix try1.xml -tp-e $TP/ocaml_ml_enum.tp >> try1_gen.ml
$HXTR -ix try1.xml -tp-f $TP/ocaml_ml_func.tp >> try1_gen.ml
echo " ## Written: 'try1_gen.ml'"

> try1_stub_gen.c
$HXTR -ix try1.xml -tp-e $TP/ocaml_c_stub_enum.tp >> try1_stub_gen.c
$HXTR -ix try1.xml -tp-f $TP/ocaml_c_stub_func.tp >> try1_stub_gen.c
echo " ## Written: 'try1_stub_gen.c'"
