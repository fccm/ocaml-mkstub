cmd_line.cmo : utils.cmi copying.cmo cmd_line.cmi
cmd_line.cmx : utils.cmx copying.cmx cmd_line.cmi
conv.cmo : utils.cmi s_repr_t.cmi instructions_t.cmi h_repr_t.cmi conv.cmi
conv.cmx : utils.cmx s_repr_t.cmx instructions_t.cmx h_repr_t.cmi conv.cmi
copying.cmo :
copying.cmx :
gccxml_cnt.cmo : utils.cmi gccxml_t.cmi cmd_line.cmi gccxml_cnt.cmi
gccxml_cnt.cmx : utils.cmx gccxml_t.cmx cmd_line.cmx gccxml_cnt.cmi
gccxml_t.cmo : gccxml_t.cmi
gccxml_t.cmx : gccxml_t.cmi
hxtr.cmo : XML_load.cmi str_repr.cmi print_parsed.cmi parse_in.cmi \
    gccxml_cnt.cmi cmd_line.cmi
hxtr.cmx : XML_load.cmx str_repr.cmx print_parsed.cmx parse_in.cmx \
    gccxml_cnt.cmx cmd_line.cmx
instr_apply.cmo :
instr_apply.cmx :
instructions_t.cmo : instructions_t.cmi
instructions_t.cmx : instructions_t.cmi
make_copying.cmo : utils.cmi
make_copying.cmx : utils.cmx
parse_in.cmo : utils.cmi repr_t.cmi gccxml_t.cmi cmd_line.cmi parse_in.cmi
parse_in.cmx : utils.cmx repr_t.cmx gccxml_t.cmx cmd_line.cmx parse_in.cmi
parse_in.old.cmo : utils.cmi repr_t.cmi cmd_line.cmi
parse_in.old.cmx : utils.cmx repr_t.cmx cmd_line.cmx
parse_instr.cmo : instructions_t.cmi parse_instr.cmi
parse_instr.cmx : instructions_t.cmx parse_instr.cmi
print_hr.cmo : h_repr_t.cmi cmd_line.cmi print_hr.cmi
print_hr.cmx : h_repr_t.cmi cmd_line.cmx print_hr.cmi
print_parsed.cmo : utils.cmi s_repr_t.cmi cmd_line.cmi print_parsed.cmi
print_parsed.cmx : utils.cmx s_repr_t.cmx cmd_line.cmx print_parsed.cmi
repr_t.cmo : repr_t.cmi
repr_t.cmx : repr_t.cmi
sambung.cmo : XML_load.cmi str_repr.cmi print_hr.cmi parse_in.cmi \
    gccxml_cnt.cmi conv.cmi cmd_line.cmi
sambung.cmx : XML_load.cmx str_repr.cmx print_hr.cmx parse_in.cmx \
    gccxml_cnt.cmx conv.cmx cmd_line.cmx
s_repr_t.cmo : s_repr_t.cmi
s_repr_t.cmx : s_repr_t.cmi
str_repr.cmo : utils.cmi s_repr_t.cmi repr_t.cmi cmd_line.cmi str_repr.cmi
str_repr.cmx : utils.cmx s_repr_t.cmx repr_t.cmx cmd_line.cmx str_repr.cmi
utils.cmo : utils.cmi
utils.cmx : utils.cmi
XML_load.cmo : utils.cmi cmd_line.cmi XML_load.cmi
XML_load.cmx : utils.cmx cmd_line.cmx XML_load.cmi
cmd_line.cmi :
conv.cmi : s_repr_t.cmi h_repr_t.cmi cmd_line.cmi
gccxml_cnt.cmi : gccxml_t.cmi cmd_line.cmi
gccxml_t.cmi :
h_repr_t.cmi :
instructions_t.cmi :
parse_in.cmi : repr_t.cmi gccxml_t.cmi cmd_line.cmi
parse_instr.cmi : instructions_t.cmi
print_hr.cmi : h_repr_t.cmi cmd_line.cmi
print_parsed.cmi : s_repr_t.cmi cmd_line.cmi
repr_t.cmi :
s_repr_t.cmi :
str_repr.cmi : s_repr_t.cmi repr_t.cmi
utils.cmi :
XML_load.cmi : cmd_line.cmi
