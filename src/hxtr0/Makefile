include ../../make/Makefile.ocaml

VERSION := $(shell date --iso)

# Which XML lib?

### include xmlm/Makefile
### XML_PRM := $(XMLM_PRM)

XMLERR_DIR := $(HOME)/xmlerr
XMLERR_INC := -I $(XMLERR_DIR)
XML_DIR := ../xmlerr/
XMLERR_PRM := $(XMLERR_INC) xmlerr.cmxa
XML_PRM := $(XMLERR_PRM) -I $(XML_DIR)


STMPL_DIR := ../stmpl
STMPL_INC := -I $(STMPL_DIR)
STMPL_PRM := $(STMPL_INC) stmpl.cmxa

.PHONY: all
all: hxtr.opt

-include depends.mk
depends.mk:
	$(OCAMLDEP) $(XMLM_INC) *.ml *.mli > $@

copying.ml: ../COPYING.txt
	> $@
	echo 'let s = "' >> $@
	cat $<           >> $@
	echo '"'         >> $@

gccxml_t.ml: gccxml_t.mli
	cat $< > $@

repr_t.ml: repr_t.mli
	cat $< > $@

stmpl.cmxa:
	$(MAKE) -C $(STMPL_DIR) $@

main.cmx: main.ml stmpl.cmxa
	$(OCAMLOPT) -c $(STMPL_INC) $<

print_parsed.cmx: print_parsed.ml stmpl.cmxa
	$(OCAMLOPT) -c $(STMPL_INC) $<

cmd_line.cmi: cmd_line.mli
	$(OCAMLC) -c $(STMPL_INC) $<
cmd_line.cmx: cmd_line.ml stmpl.cmxa
	$(OCAMLOPT) -c $(STMPL_INC) $<
cmd_line.cmo: cmd_line.ml stmpl.cma
	$(OCAMLC) -c $(STMPL_INC) $<

XML_load.cmi: XML_load.mli
	$(OCAMLC) -c -o $@ -I $(XML_DIR) $<
XML_load.cmx: XML_load.ml XML_load.cmi
	$(OCAMLOPT) -g -c -I $(XML_DIR) $<

gccxml_t.cmi: gccxml_t.mli
	$(OCAMLC) -c -o $@ -I $(XML_DIR) $<
gccxml_t.cmx: gccxml_t.ml gccxml_t.cmi
	$(OCAMLOPT) -g -c -I $(XML_DIR) $<

gccxml_cnt.cmi: gccxml_cnt.mli
	$(OCAMLC) -c -o $@ -I $(XML_DIR) $<
gccxml_cnt.cmx: gccxml_cnt.ml gccxml_cnt.cmi
	$(OCAMLOPT) -g -c -I $(XML_DIR) $<

#$(XML_DIR)/XML_read.cmxa:
#	$(MAKE) -C $(XML_DIR) $(basename $@)

# $(XML_DIR)/XML_read.cmxa \

hxtr.opt: \
  main.cmx \
  XML_load.cmx \
  utils.cmx \
  stmpl.cmxa \
  gccxml_t.cmx \
  gccxml_cnt.cmx \
  repr_t.cmx \
  parse_in.cmx \
  cmd_line.cmx \
  print_parsed.cmx \
  copying.cmx
	$(OCAMLOPT) \
	  $(STMPL_PRM) \
	  unix.cmxa \
	  utils.cmx \
	  $(XML_PRM) \
	  XML_read.cmxa \
	  XML_load.cmx \
	  copying.cmx \
	  gccxml_t.cmx \
	  gccxml_cnt.cmx \
	  repr_t.cmx \
	  parse_in.cmx \
	  cmd_line.cmx \
	  print_parsed.cmx \
	  main.cmx \
	  -o $@


MLIS := \
  utils.mli \
  cmd_line.mli \
  $(XML_DIR)/XML_read.mli \
  XML_load.mli \
  gccxml_t.mli \
  gccxml_cnt.mli \
  repr_t.mli \
  parse_in.mli \
  $(STMPL_DIR)/stmpl.mli \
  print_parsed.mli \
  #End

DEV_DOC_DIR := devel_doc_hxtr_api
.PHONY: devel_doc
devel_doc:
	mkdir -p $(DEV_DOC_DIR)
	$(OCAMLDOC) -d $(DEV_DOC_DIR) -html $(STMPL_INC) -I $(XML_DIR) $(MLIS)

include ../../make/Makefile.clean
