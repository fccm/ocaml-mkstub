conv.cmo: smls_t.cmi instructions_t.cmi hrepr_t.cmi conv.cmi
conv.cmx: smls_t.cmi instructions_t.cmi hrepr_t.cmi conv.cmi
instructions.cmo: instructions_t.cmi
instructions.cmx: instructions_t.cmi
main.cmo: smls.cmi print.cmi conv.cmi
main.cmx: smls.cmx print.cmx conv.cmx
parse_instr.cmo: instructions_t.cmi parse_instr.cmi
parse_instr.cmx: instructions_t.cmi parse_instr.cmi
print.cmo: hrepr_t.cmi print.cmi
print.cmx: hrepr_t.cmi print.cmi
smls.cmo: smls_t.cmi ../sexpr/SExpr.cmi smls.cmi
smls.cmx: smls_t.cmi ../sexpr/SExpr.cmx smls.cmi
conv.cmi: smls_t.cmi hrepr_t.cmi
hrepr_t.cmi:
instructions_t.cmi:
parse_instr.cmi: instructions_t.cmi
print.cmi: hrepr_t.cmi
smls.cmi: smls_t.cmi
smls_t.cmi:
