.PHONY: all cma cmxs clean_gen
all: cma

cma:
	sh test_gen_cma.sh
cmxs:
	sh test_gen_cmxs.sh

clean_gen:
	$(RM) generated*

include ../../../make/Makefile.clean
