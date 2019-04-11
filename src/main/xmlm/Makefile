include ../../../make/Makefile.ocaml

.PHONY: all
all: XML_read.cmxa

XMLM_DIR := +xmlm
XMLM_INC := -I $(XMLM_DIR)
XMLM_PRM := $(XMLM_INC) xmlm.cmxa

XML_read.cmi: XML_read.mli
	$(OCAMLC) -c $(XMLM_INC) $<
XML_read.cmo: XML_read.ml XML_read.cmi
	$(OCAMLC) -c $(XMLM_INC) $<
XML_read.cmx: XML_read.ml XML_read.cmi
	$(OCAMLOPT) -c $(XMLM_INC) $<

include ../../../make/Makefile.clean
