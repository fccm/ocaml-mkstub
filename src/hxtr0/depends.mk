cmd_line.cmo : utils.cmi copying.cmo cmd_line.cmi
cmd_line.cmx : utils.cmx copying.cmx cmd_line.cmi
copying.cmo :
copying.cmx :
gccxml_cnt.cmo : utils.cmi gccxml_t.cmi cmd_line.cmi gccxml_cnt.cmi
gccxml_cnt.cmx : utils.cmx gccxml_t.cmx cmd_line.cmx gccxml_cnt.cmi
gccxml_t.cmo : gccxml_t.cmi
gccxml_t.cmx : gccxml_t.cmi
main.cmo : XML_load.cmi print_parsed.cmi parse_in.cmi gccxml_cnt.cmi \
    cmd_line.cmi
main.cmx : XML_load.cmx print_parsed.cmx parse_in.cmx gccxml_cnt.cmx \
    cmd_line.cmx
parse_in.cmo : utils.cmi repr_t.cmi gccxml_t.cmi cmd_line.cmi parse_in.cmi
parse_in.cmx : utils.cmx repr_t.cmx gccxml_t.cmx cmd_line.cmx parse_in.cmi
parse_in.old.cmo : utils.cmi repr_t.cmi cmd_line.cmi
parse_in.old.cmx : utils.cmx repr_t.cmx cmd_line.cmx
print_parsed.cmo : utils.cmi repr_t.cmi cmd_line.cmi print_parsed.cmi
print_parsed.cmx : utils.cmx repr_t.cmx cmd_line.cmx print_parsed.cmi
repr_t.cmo : repr_t.cmi
repr_t.cmx : repr_t.cmi
utils.cmo : utils.cmi
utils.cmx : utils.cmi
XML_load.cmo : utils.cmi cmd_line.cmi XML_load.cmi
XML_load.cmx : utils.cmx cmd_line.cmx XML_load.cmi
cmd_line.cmi :
gccxml_cnt.cmi : gccxml_t.cmi cmd_line.cmi
gccxml_t.cmi :
parse_in.cmi : repr_t.cmi gccxml_t.cmi cmd_line.cmi
print_parsed.cmi : repr_t.cmi cmd_line.cmi
repr_t.cmi :
utils.cmi :
XML_load.cmi : cmd_line.cmi
