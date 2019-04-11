include ../../make/Makefile.ocaml

#XMLERR_DIR := $(HOME)/xmlerr
XMLERR_DIR := ../../../xmlerr
XMLERR_INC := -I $(XMLERR_DIR)

.PHONY: all
all: XML_read.cmxa

XML_read.cmi: XML_read.mli
	$(OCAMLC) -c $<

XML_read.cmo: XML_read.ml XML_read.cmi
	$(OCAMLC) -c $(XMLERR_INC) $<

XML_read.cmx: XML_read.ml XML_read.cmi
	$(OCAMLOPT) -c $(XMLERR_INC) $<

include ../../make/Makefile.clean
