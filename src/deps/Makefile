include ../../make/Makefile.ocaml

XMLM_DIR := +xmlm
XMLM_INC := -I $(XMLM_DIR)

STMPL_DIR := ../stmpl
STMPL_INC := -I $(STMPL_DIR)

SEXPR_DIR := ../sexpr
SEXPR_INC := -I $(SEXPR_DIR)

HXTR_DIR := ../hxtr
HXTR_INC := -I $(HXTR_DIR)

-include depends.mk
depends.mk:
	$(OCAMLDEP) $(XMLM_INC) $(STMPL_INC) $(SEXPR_INC) $(HXTR_INC) ../*/*.ml ../*/*.mli > $@
