GCCXML := gccxml
HXTR_YAML := ../../../bin/hxtr_yaml

libyaml.ya: libyaml.xml
	$(HXTR_YAML) -x ./exclude.ex -ix $< > $@

%.xml: %.h
	$(GCCXML) $< -fxml=$@
