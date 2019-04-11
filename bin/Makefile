MAIN_DIR := ../src/main

.PHONY: all hxtr sambung
all: hxtr sambung

hxtr: $(MAIN_DIR)/hxtr.opt
	$(MAKE) -C $(MAIN_DIR) hxtr.opt
	cp $< ./$@

sambung: $(MAIN_DIR)/sambung.opt
	$(MAKE) -C $(MAIN_DIR) sambung.opt
	cp $< ./$@
