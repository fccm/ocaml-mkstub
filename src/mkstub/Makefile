include ../../make/Makefile.ocaml

SEXPR_DIR := ../sexpr
SEXPR_INC := -I $(SEXPR_DIR)
SEXPR_PRM := $(SEXPR_INC) SExpr.cmxa

STMPL_DIR := ../stmpl
STMPL_INC := -I $(STMPL_DIR)
STMPL_PRM := $(STMPL_INC) stmpl.cmxa

HXTR_MOD := utils.ml copying.ml cmd_line.ml
HXTR_DIR := ../hxtr
HXTR_INC := -I $(HXTR_DIR)
HXTR_CMX := $(patsubst %.ml, $(HXTR_DIR)/%.cmx, $(HXTR_MOD))
HXTR_PRM := $(HXTR_INC) $(HXTR_CMX)

#vpath %.cmx $(HXTR_DIR)

.PHONY: all
all: mkstub.opt

#-include ../deps/depends.mk
-include depends.mk
#depends.mk:
#	$(OCAMLDEP) $(SEXPR_INC) *.ml *.mli > $@
depends.mk:
	$(OCAMLDEP) $(XMLM_INC) \
	  $(HXTR_INC) $(HXTR_DIR)/*.ml $(HXTR_DIR)/*.mli *.ml *.mli > $@

smls.cmx: smls.ml
	$(OCAMLOPT) -c $(SEXPR_INC) $<

CMX := \
  parse_instr.cmx \
  smls.cmx \
  conv.cmx \
  print.cmx \
  main.cmx \
  #End

mkstub.opt: $(CMX)
	$(OCAMLOPT) -g -o $@ $(SEXPR_PRM) $(STMPL_PRM) $(HXTR_PRM) $(CMX)

MLIS := \
  smls_t.mli \
  smls.mli \
  hrepr_t.mli \
  instructions_t.mli \
  parse_instr.mli \
  conv.mli \
  print.mli \
  #End

DEV_DOC_DIR := devel_doc_mkstub_api
.PHONY: devel_doc
devel_doc:
	mkdir -p $(DEV_DOC_DIR)
	$(OCAMLDOC) -d $(DEV_DOC_DIR) -html $(MLIS)

include ../../make/Makefile.clean
