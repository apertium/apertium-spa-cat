###############################################################################
## Makefile for Spanish--Catalan
###############################################################################

VERSION=1.9.0
LANG1=spa
LANG2=cat

VAR1=#leave empty
VAR2=_valencia

LANG2C=$(LANG2)$(VAR1)
LANG2V=$(LANG2)$(VAR2)

PREFIX1=$(LANG1)-$(LANG2)
PREFIX1C=$(LANG1)-$(LANG2C)
PREFIX1V=$(LANG1)-$(LANG2V)

PREFIX2=$(LANG2)-$(LANG1)
PREFIX2C=$(LANG2C)-$(LANG1)
PREFIX2V=$(LANG2V)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON =				\
	$(PREFIX1).automorf.bin 	\
	$(PREFIX1).prob			 	\
	$(PREFIX1C).autobil.bin 	\
	$(PREFIX1V).autobil.bin 	\
	$(PREFIX1C).autogen.bin 	\
	$(PREFIX1V).autogen.bin 	\
	$(PREFIX1C).autopgen.bin 	\
	$(PREFIX1V).autopgen.bin 	\
	$(PREFIX2).automorf.bin		\
	$(PREFIX2).prob				\
	$(PREFIX2).autobil.bin		\
	$(PREFIX2).autogen.bin 	\
	$(PREFIX2).autopgen.bin 	\
	$(PREFIX1C).t1x.bin \
	$(PREFIX1V).t1x.bin \
	$(PREFIX2).t1x.bin
	

# This include defines goals for install-modes, .deps/.d, autobil.prefixes and .mode files:
@ap_include@


###############################################################################
## Monolingual transducers
###############################################################################

# -------------------
# Spanish analysis:
# -------------------

$(PREFIX1C).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin $(PREFIX1C).autobil.bin
	lt-trim $^ $@

$(PREFIX1V).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin $(PREFIX1V).autobil.bin
	lt-trim $^ $@

# -------------------
# Spanish generation:
# ---------------------

$(PREFIX2).autogen.bin: $(AP_SRC1)/$(LANG1).autogen.bin
	cp $< $@

$(PREFIX2).autopgen.bin: $(AP_SRC1)/$(LANG1).autopgen.bin
	cp $< $@
	
# -------------------
# Catalan analysis:
# -------------------

$(PREFIX2).automorf.bin: $(AP_SRC2)/$(LANG2).automorf.bin $(PREFIX2).autobil.bin
	lt-trim $^ $@

# -------------------
# Catalan generation:
# ---------------------

$(PREFIX1C).autogen.bin: $(AP_SRC2)/$(LANG2C).autogen.bin
	cp $< $@

$(PREFIX1V).autogen.bin: $(AP_SRC2)/$(LANG2V).autogen.bin
	cp $< $@

$(PREFIX1C).autopgen.bin: $(AP_SRC2)/$(LANG2C).autopgen.bin
	cp $< $@

$(PREFIX1V).autopgen.bin: $(AP_SRC2)/$(LANG2V).autopgen.bin
	cp $< $@


###############################################################################
## Disambiguation models
###############################################################################

$(PREFIX1).prob: $(AP_SRC1)/$(LANG1).prob
	cp $< $@

$(PREFIX2).prob: $(AP_SRC2)/$(LANG2).prob
	cp $< $@


###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1C).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp --var-right=cat lr $< $@

$(PREFIX1V).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp --var-right=val lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@


###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1C).t1x.bin: $(PREFIX1C).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1V).t1x.bin: $(PREFIX1V).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1C).t1x: $(BASENAME).$(PREFIX1).t1x
	xsltproc --stringparam alt cat alt.xsl $< >$@

$(PREFIX1V).t1x: $(BASENAME).$(PREFIX1).t1x
	xsltproc --stringparam alt val alt.xsl $< >$@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=								\
		$(BASENAME).$(PREFIX1).dix 		\
		$(BASENAME).$(PREFIX1).t1x 		\
		$(BASENAME).$(PREFIX1C).t1x 	\
		$(BASENAME).$(PREFIX1V).t1x 	\
		$(BASENAME).$(PREFIX2).t1x 		\
		$(BASENAME).$(LANG1).acx 		\
		$(BASENAME).$(LANG2).acx 		\
		modes.xml 						\
		alt.xsl


###############################################################################
## Installation
###############################################################################

apertium_spa_catdir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_spa_cat_DATA=				\
	$(TARGETS_COMMON)				\
	$(BASENAME).$(PREFIX1).t1x		\
	$(PREFIX1C).t1x					\
	$(PREFIX1V).t1x					\
	$(BASENAME).$(PREFIX1).t1x		\
	$(BASENAME).$(PREFIX2).t1x		

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local: install-modes


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes
