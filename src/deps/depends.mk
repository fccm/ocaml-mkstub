../hxtr/cmd_line.cmo: ../hxtr/utils.cmi ../stmpl/stmpl.cmi \
    ../hxtr/copying.cmo ../hxtr/cmd_line.cmi
../hxtr/cmd_line.cmx: ../hxtr/utils.cmx ../stmpl/stmpl.cmx \
    ../hxtr/copying.cmx ../hxtr/cmd_line.cmi
../hxtr/copying.cmo:
../hxtr/copying.cmx:
../hxtr/gccxml_cnt.cmo: ../hxtr/XML_read.cmi ../hxtr/utils.cmi \
    ../hxtr/gccxml_t.cmi ../hxtr/cmd_line.cmi ../hxtr/gccxml_cnt.cmi
../hxtr/gccxml_cnt.cmx: ../hxtr/XML_read.cmx ../hxtr/utils.cmx \
    ../hxtr/gccxml_t.cmx ../hxtr/cmd_line.cmx ../hxtr/gccxml_cnt.cmi
../hxtr/gccxml_t.cmo: ../hxtr/XML_read.cmi ../hxtr/gccxml_t.cmi
../hxtr/gccxml_t.cmx: ../hxtr/XML_read.cmx ../hxtr/gccxml_t.cmi
../hxtr/main.cmo: ../hxtr/XML_load.cmi ../hxtr/print_parsed.cmi \
    ../hxtr/parse_in.cmi ../hxtr/gccxml_cnt.cmi ../hxtr/cmd_line.cmi
../hxtr/main.cmx: ../hxtr/XML_load.cmx ../hxtr/print_parsed.cmx \
    ../hxtr/parse_in.cmx ../hxtr/gccxml_cnt.cmx ../hxtr/cmd_line.cmx
../hxtr/parse_in.cmo: ../hxtr/utils.cmi ../hxtr/repr_t.cmi \
    ../hxtr/gccxml_t.cmi ../hxtr/cmd_line.cmi ../hxtr/parse_in.cmi
../hxtr/parse_in.cmx: ../hxtr/utils.cmx ../hxtr/repr_t.cmx \
    ../hxtr/gccxml_t.cmx ../hxtr/cmd_line.cmx ../hxtr/parse_in.cmi
../hxtr/parse_in.old.cmo: ../hxtr/XML_read.cmi ../hxtr/utils.cmi \
    ../hxtr/repr_t.cmi ../hxtr/cmd_line.cmi
../hxtr/parse_in.old.cmx: ../hxtr/XML_read.cmx ../hxtr/utils.cmx \
    ../hxtr/repr_t.cmx ../hxtr/cmd_line.cmx
../hxtr/print_parsed.cmo: ../hxtr/utils.cmi ../stmpl/stmpl.cmi \
    ../hxtr/repr_t.cmi ../hxtr/cmd_line.cmi ../hxtr/print_parsed.cmi
../hxtr/print_parsed.cmx: ../hxtr/utils.cmx ../stmpl/stmpl.cmx \
    ../hxtr/repr_t.cmx ../hxtr/cmd_line.cmx ../hxtr/print_parsed.cmi
../hxtr/repr_t.cmo: ../hxtr/repr_t.cmi
../hxtr/repr_t.cmx: ../hxtr/repr_t.cmi
../hxtr/utils.cmo: ../hxtr/utils.cmi
../hxtr/utils.cmx: ../hxtr/utils.cmi
../hxtr/XML_load.cmo: ../hxtr/XML_read.cmi ../hxtr/utils.cmi \
    ../hxtr/cmd_line.cmi ../hxtr/XML_load.cmi
../hxtr/XML_load.cmx: ../hxtr/XML_read.cmx ../hxtr/utils.cmx \
    ../hxtr/cmd_line.cmx ../hxtr/XML_load.cmi
../hxtr/XML_read.cmo: /usr/lib/ocaml/xmlm/xmlm.cmi ../hxtr/utils.cmi \
    ../hxtr/XML_read.cmi
../hxtr/XML_read.cmx: /usr/lib/ocaml/xmlm/xmlm.cmi ../hxtr/utils.cmx \
    ../hxtr/XML_read.cmi
../include/ocaml_t_gen.cmo:
../include/ocaml_t_gen.cmx:
../mkstub/conv.cmo: ../mkstub/conv.cmi
../mkstub/conv.cmx: ../mkstub/conv.cmi
../mkstub/main.cmo:
../mkstub/main.cmx:
../mkstub/parse_instr.cmo: ../mkstub/parse_instr.cmi
../mkstub/parse_instr.cmx: ../mkstub/parse_instr.cmi
../mkstub/print.cmo: ../hxtr/utils.cmi ../stmpl/stmpl.cmi \
    ../hxtr/cmd_line.cmi ../mkstub/print.cmi
../mkstub/print.cmx: ../hxtr/utils.cmx ../stmpl/stmpl.cmx \
    ../hxtr/cmd_line.cmx ../mkstub/print.cmi
../mkstub/smls.cmo: ../sexpr/SExpr.cmi ../mkstub/smls.cmi
../mkstub/smls.cmx: ../sexpr/SExpr.cmx ../mkstub/smls.cmi
../sexpr/SExpr.cmo: ../sexpr/SExpr.cmi
../sexpr/SExpr.cmx: ../sexpr/SExpr.cmi
../stmpl_a/stmpl.cmo: ../stmpl_a/stmpl.cmi
../stmpl_a/stmpl.cmx: ../stmpl_a/stmpl.cmi
../stmpl_a/stmpl_test.cmo: ../stmpl/stmpl.cmi
../stmpl_a/stmpl_test.cmx: ../stmpl/stmpl.cmx
../stmpl_b/stmpl.cmo: ../stmpl_b/stmpl.cmi
../stmpl_b/stmpl.cmx: ../stmpl_b/stmpl.cmi
../stmpl_b/stmpl_test.cmo: ../stmpl/stmpl.cmi
../stmpl_b/stmpl_test.cmx: ../stmpl/stmpl.cmx
../stmpl_b/stmpl_test_rec.cmo: ../stmpl/stmpl.cmi
../stmpl_b/stmpl_test_rec.cmx: ../stmpl/stmpl.cmx
../stmpl/stmpl.cmo: ../stmpl/stmpl.cmi
../stmpl/stmpl.cmx: ../stmpl/stmpl.cmi
../stmpl/stmpl_test.cmo: ../stmpl/stmpl.cmi
../stmpl/stmpl_test.cmx: ../stmpl/stmpl.cmx
../stmpl/test_stmpl_rec.cmo: ../stmpl/stmpl.cmi
../stmpl/test_stmpl_rec.cmx: ../stmpl/stmpl.cmx
../hxtr/cmd_line.cmi: ../stmpl/stmpl.cmi
../hxtr/gccxml_cnt.cmi: ../hxtr/XML_read.cmi ../hxtr/gccxml_t.cmi \
    ../hxtr/cmd_line.cmi
../hxtr/gccxml_t.cmi: ../hxtr/XML_read.cmi
../hxtr/parse_in.cmi: ../hxtr/repr_t.cmi ../hxtr/gccxml_t.cmi \
    ../hxtr/cmd_line.cmi
../hxtr/print_parsed.cmi: ../hxtr/repr_t.cmi ../hxtr/cmd_line.cmi
../hxtr/repr_t.cmi:
../hxtr/utils.cmi:
../hxtr/XML_load.cmi: ../hxtr/XML_read.cmi ../hxtr/cmd_line.cmi
../hxtr/XML_read.cmi:
../mkstub/conv.cmi:
../mkstub/hrepr_t.cmi:
../mkstub/instructions_t.cmi:
../mkstub/parse_instr.cmi:
../mkstub/print.cmi:
../mkstub/smls.cmi:
../mkstub/smls_t.cmi:
../sexpr/SExpr.cmi:
../stmpl_a/stmpl.cmi:
../stmpl_b/stmpl.cmi:
../stmpl/stmpl.cmi:
