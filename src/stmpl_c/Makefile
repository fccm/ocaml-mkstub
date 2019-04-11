include ../../make/Makefile.ocaml

DOCDIR := stmpl-api

.PHONY: all
all:  stmpl.cma  stmpl.cmxa


.PHONY: test
test: stmpl.cmi stmpl.cmo
	$(OCAML) stmpl.cmo stmpl_test.ml

.PHONY: test_opt
test_opt: stmpl.cmxa
	$(OCAMLOPT) stmpl.cmxa stmpl_test.ml -o tmp.opt

.PHONY: doc
doc:
	mkdir -p $(DOCDIR)
	$(OCAMLDOC) -html -d $(DOCDIR) stmpl.mli

include ../../make/Makefile.clean
