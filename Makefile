.PHONY: all
all:
	$(MAKE) -C src/main $@
%::
	$(MAKE) -C src/main $@

.PHONY: excludes
excludes:
	$(MAKE) -C share/exclude all

.PHONY: exclude_clean
exclude_clean:
	$(MAKE) -C share/exclude clean

.PHONY: main_clean
main_clean:
	$(MAKE) -C src/main clean

.PHONY: mkstub_clean
mkstub_clean:
	$(MAKE) -C src/mkstub clean

.PHONY: stmpl_clean
stmpl_clean:
	$(MAKE) -C src/stmpl clean

.PHONY: sexpr_clean
sexpr_clean:
	$(MAKE) -C src/sexpr clean

.PHONY: xmlerr_clean
xmlerr_clean:
	$(MAKE) -C src/xmlerr clean

.PHONY: clean_all
clean_all: main_clean mkstub_clean exclude_clean \
  stmpl_clean sexpr_clean xmlerr_clean

include ./make/Makefile.config
include ./make/Makefile.install
