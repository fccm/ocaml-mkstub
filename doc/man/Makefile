
%.1.txt: %.1
	man ./$< | col -b > $@

%.1.dvi: %.1
	man2dvi ./$< > $@

%.1.pdf: %.1.dvi
	dvipdf $< $@

%.1.xhtml: %.1
	groff -T xhtml ./$< > $@
# <link rel="stylesheet" type="text/css" href="./man2html.css" />

%.1.html: %.1
	man2html $< > $@
# Add:
# <LINK REL="stylesheet" TYPE="text/css" HREF="./man2html.css">
