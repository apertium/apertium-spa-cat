###############################################################################
## Makefile for Spanish--Catalan
###############################################################################

VERSION=1.2.1
LANG1=es
LANG2=ca
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)
BASENAME=apertium-$(PREFIX1)

VAR1=std
VAR2=val-
PREFVAR1=#dejar en blanco
PREFVAR2=val-
TARGETS_COMMON = $(PREFIX1).automorf.bin $(PREFIX1).autobil.bin $(PREFIX1).autogen.bin \
     $(PREFVAR1)$(PREFIX2).autogen.bin \
     $(PREFVAR2)$(PREFIX2).autogen.bin \
     $(PREFVAR1)$(PREFIX2).autopgen.bin \
     $(PREFVAR1)$(PREFIX1).autopgen.bin \
     $(PREFIX2).automorf.bin $(PREFIX2).autobil.bin \
     $(PREFVAR1)$(PREFIX1).t1x.bin \
     $(PREFVAR1)$(PREFIX2).t1x.bin \
     $(PREFVAR1)$(PREFIX1).t1x \
     $(PREFVAR1)$(PREFIX2).t1x \
     $(PREFVAR2)$(PREFIX1).automorf.bin \
     $(PREFVAR2)$(PREFIX1).autobil.bin \
     $(PREFVAR2)$(PREFIX1).autogen.bin \
     $(PREFVAR2)$(PREFIX1).autopgen.bin \
     $(PREFVAR2)$(PREFIX1).t1x \
     $(PREFVAR2)$(PREFIX2).t1x \
     $(PREFVAR2)$(PREFIX1).t1x.bin \
     $(PREFVAR2)$(PREFIX2).t1x.bin

# Use this goal for creating .deps, otherwise make -j2 will give problems:
.deps/.d:
	if [ ! -d .deps ]; then mkdir .deps; fi
	touch $@

# Prevent the .d file from being removed automatically:
.PRECIOUS: .deps/.d


###############################################################################
## Transducers, disambiguation rules, transfer
###############################################################################


.deps/commonbil.dix: $(BASENAME).$(PREFIX1).dix .deps/.d
	xsltproc --stringparam lang cat --stringparam side right filter.xsl $< | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/pgen-ca.dix: $(BASENAME).post-ca.dix .deps/.d
	xsltproc --stringparam alt cat alt.xsl $< >$@

.deps/pgen-ca_valencia.dix: $(BASENAME).post-ca.dix .deps/.d
	xsltproc --stringparam alt val alt.xsl $< >$@


.deps/$(PREFVAR1)$(LANG1).dix: $(BASENAME).$(LANG1).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang cat --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR2)$(LANG1).dix: $(BASENAME).$(LANG1).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang val --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR1)$(LANG2).dix: $(BASENAME).$(LANG2).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang cat --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR2)$(LANG2).dix: $(BASENAME).$(LANG2).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang val --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR1)$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang cat --stringparam side right filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR2)$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang val --stringparam side right filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

$(PREFVAR1)$(PREFIX1).automorf.bin: .deps/$(PREFVAR1)$(LANG1).dix $(BASENAME).$(LANG1).acx
	apertium-validate-acx $(BASENAME).$(LANG1).acx
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG1).acx

$(PREFVAR1)$(PREFIX1).autobil.bin: .deps/$(PREFVAR1)$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFVAR1)$(PREFIX1).autogen.bin: .deps/$(PREFVAR1)$(LANG2).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR1)$(PREFIX1).autopgen.bin: .deps/pgen-ca.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFVAR2)$(PREFIX1).autopgen.bin: .deps/pgen-ca_valencia.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@


$(PREFVAR1)$(PREFIX2).automorf.bin: .deps/$(PREFVAR1)$(LANG2).dix $(BASENAME).$(LANG2).acx
	apertium-validate-acx $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG2).acx

$(PREFVAR1)$(PREFIX2).autobil.bin: .deps/$(PREFVAR1)$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR1)$(PREFIX2).autogen.bin: .deps/$(PREFVAR1)$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR1)$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFVAR2)$(PREFIX1).automorf.bin: .deps/$(PREFVAR2)$(LANG1).dix $(BASENAME).$(LANG1).acx
	apertium-validate-acx $(BASENAME).$(LANG1).acx
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG1).acx

$(PREFVAR2)$(PREFIX1).autobil.bin: .deps/$(PREFVAR2)$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFVAR2)$(PREFIX1).autogen.bin: .deps/$(PREFVAR2)$(LANG2).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR2)$(PREFIX2).automorf.bin: .deps/$(PREFVAR2)$(LANG2).dix $(BASENAME).$(LANG2).acx
	apertium-validate-acx $(BASENAME).$(LANG2).acx
	apertium-validate-dictionary $<
	lt-comp lr $< $@ $(BASENAME).$(LANG2).acx

$(PREFVAR2)$(PREFIX2).autobil.bin: .deps/$(PREFVAR2)$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR2)$(PREFIX2).autogen.bin: .deps/$(PREFVAR2)$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFVAR1)$(PREFIX1).t1x.bin: $(PREFVAR1)$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX2).t1x.bin: $(PREFVAR1)$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR1)$(PREFIX1).t1x: $(BASENAME).$(PREFIX1).t1x
	xsltproc --stringparam alt cat alt.xsl $< >$@

$(PREFVAR1)$(PREFIX2).t1x: $(BASENAME).$(PREFIX2).t1x
	xsltproc --stringparam alt cat alt.xsl $< >$@

$(PREFVAR2)$(PREFIX1).t1x.bin: $(PREFVAR2)$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR2)$(PREFIX2).t1x.bin: $(PREFVAR2)$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFVAR2)$(PREFIX1).t1x: $(BASENAME).$(PREFIX1).t1x
	xsltproc --stringparam alt val alt.xsl $< >$@

$(PREFVAR2)$(PREFIX2).t1x: $(BASENAME).$(PREFIX2).t1x
	xsltproc --stringparam alt val alt.xsl $< >$@


###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).post-$(LANG1).dix $(BASENAME).post-$(LANG2).dix \
           $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG1).tsx \
           $(BASENAME).$(LANG2).tsx $(BASENAME).$(PREFIX1).t1x \
           $(BASENAME).$(PREFIX2).t1x $(PREFIX1).prob $(PREFIX2).prob \
           modes.xml translate-to-default-equivalent.xsl alt.xsl \
           $(PREFIX1)-latin1.prob $(PREFIX2)-latin1.prob \
           $(BASENAME).$(LANG1).acx $(BASENAME).$(LANG2).acx \
	   filter.xsl filter.sh

###############################################################################
## Installation
###############################################################################

apertium_es_cadir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_es_ca_DATA=$(TARGETS_COMMON) \
	$(PREFIX1).prob $(PREFIX2).prob $(PREFIX1)-latin1.prob $(PREFIX2)-latin1.prob


apertium_modesdir=$(prefix)/share/apertium/modes/

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode


install-data-local:
	mv modes modes.bak
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	rm -rf modes
	mv modes.bak modes
	test -d $(DESTDIR)$(apertium_modesdir) || mkdir $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX1).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX2).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR2)$(PREFIX1).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR2)$(PREFIX2).mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) es-ca_valencia.mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX1)-multi.mode $(DESTDIR)$(apertium_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX2)-multi.mode $(DESTDIR)$(apertium_modesdir)

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes
