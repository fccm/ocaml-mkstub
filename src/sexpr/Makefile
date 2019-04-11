include ../../make/Makefile.ocaml

all: cma cmxa
byte cma: SExpr.cma
opt cmxa: SExpr.cmxa
cmxs: SExpr.cmxs

SExpr.cmi: SExpr.mli
	$(OCAMLC) -c $<

SExpr.cmo: SExpr.ml SExpr.cmi
	$(OCAMLC) -c $<

SExpr.cmx: SExpr.ml SExpr.cmi
	$(OCAMLOPT) -c $<

SExpr.cma: SExpr.cmo
	$(OCAMLC) -a -o $@ $<

SExpr.cmxa: SExpr.cmx
	$(OCAMLOPT) -a -o $@ $<

SExpr.cmxs: SExpr.ml
	$(OCAMLOPT) -shared $< -o $@

.PHONY: all opt byte cma cmxa cmxs

include ../../make/Makefile.clean
