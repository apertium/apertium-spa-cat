###############################################################################
## Makefile for Spanish--Catalan
###############################################################################

VERSION=2.1.0
LANG1=spa
LANG2=cat

VAR1=#leave empty
VAR2=_valencia_gva
VAR3=_valencia_uni

LANG2C=$(LANG2)$(VAR1)
LANG2V=$(LANG2)$(VAR2)
LANG2U=$(LANG2)$(VAR3)

PREFIX1=$(LANG1)-$(LANG2)
PREFIX1C=$(LANG1)-$(LANG2C)
PREFIX1V=$(LANG1)-$(LANG2V)
PREFIX1U=$(LANG1)-$(LANG2U)

PREFIX2=$(LANG2)-$(LANG1)
PREFIX2C=$(LANG2C)-$(LANG1)
PREFIX2V=$(LANG2V)-$(LANG1)
PREFIX2U=$(LANG2U)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON =			\
	$(PREFIX1).automorf.bin 	\
	$(LANG1).lrx.bin		\
	$(PREFIX1).rlx.bin	\
	$(PREFIX2).rlx.bin	\
	$(PREFIX1).prob		 	\
	$(PREFIX1C).autobil.bin 	\
	$(PREFIX1V).autobil.bin 	\
	$(PREFIX1U).autobil.bin 	\
	$(PREFIX1).autolex.bin  \
	$(PREFIX1C).autogen.bin 	\
	$(PREFIX1V).autogen.bin 	\
	$(PREFIX1U).autogen.bin 	\
	$(PREFIX1C).autopgen.bin 	\
	$(PREFIX1V).autopgen.bin 	\
	$(PREFIX1U).autopgen.bin 	\
	$(PREFIX2).automorf.bin		\
	$(PREFIX2).prob			\
	$(PREFIX2).autobil.bin		\
	$(PREFIX2).autogen.bin 		\
	$(PREFIX2).autopgen.bin 	\
	$(PREFIX1C).t1x.bin 		\
	$(PREFIX1V).t1x.bin 		\
	$(PREFIX1U).t1x.bin 		\
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

$(PREFIX1U).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin $(PREFIX1V).autobil.bin
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

$(PREFIX1U).autogen.bin: $(AP_SRC2)/$(LANG2U).autogen.bin
	cp $< $@

$(PREFIX1C).autopgen.bin: $(AP_SRC2)/$(LANG2C).autopgen.bin
	cp $< $@

$(PREFIX1V).autopgen.bin: $(AP_SRC2)/$(LANG2V).autopgen.bin
	cp $< $@

$(PREFIX1U).autopgen.bin: $(AP_SRC2)/$(LANG2U).autopgen.bin
	cp $< $@


###############################################################################
## Disambiguation models
###############################################################################

$(PREFIX1).prob: $(AP_SRC1)/$(LANG1).prob
	cp $< $@
	
$(PREFIX1).rlx.bin: $(AP_SRC1)/apertium-$(LANG1).$(LANG1).rlx
	cg-comp $< $@

$(LANG1).lrx.bin: $(AP_SRC1)/$(LANG1).lrx.bin
	cp $< $@

$(PREFIX2).prob: $(AP_SRC2)/$(LANG2).prob
	cp $< $@
	
$(PREFIX2).rlx.bin: $(AP_SRC2)/apertium-$(LANG2).$(LANG2).rlx
	cg-comp $< $@


###############################################################################
## Bilingual dictionaries
###############################################################################

.deps/$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix .deps/.d
	xsltproc translate-to-default-equivalent.xsl $< > $@

.deps/$(PREFIX1).cat.dix: .deps/$(PREFIX1).dix
	python genvrdix.py cat $< >$@

.deps/$(PREFIX1).val_gva.dix: .deps/$(PREFIX1).dix
	python genvrdix.py val_gva $< >$@

.deps/$(PREFIX1).val_uni.dix: .deps/$(PREFIX1).dix
	python genvrdix.py val_uni $< >$@
	
$(PREFIX1C).autobil.bin: .deps/$(PREFIX1).cat.dix
	apertium-validate-dictionary $<
	lt-comp --var-right=cat lr $< $@

$(PREFIX1V).autobil.bin: .deps/$(PREFIX1).val_gva.dix
	apertium-validate-dictionary $<
	lt-comp --var-right=val_gva lr $< $@

$(PREFIX1U).autobil.bin: .deps/$(PREFIX1).val_uni.dix
	apertium-validate-dictionary $<
	lt-comp --var-right=val_uni lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

# $(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
# 	lrx-comp $< $@


###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1C).t1x.bin: $(PREFIX1C).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1V).t1x.bin: $(PREFIX1V).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1U).t1x.bin: $(PREFIX1U).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

.deps/$(BASENAME).$(PREFIX1).cat.t1x: $(BASENAME).$(PREFIX1).t1x
	python gent1x.py cat $< >$@

.deps/$(BASENAME).$(PREFIX1).val_gva.t1x: $(BASENAME).$(PREFIX1).t1x
	python gent1x.py val_gva $< >$@

.deps/$(BASENAME).$(PREFIX1).val_uni.t1x: $(BASENAME).$(PREFIX1).t1x
	python gent1x.py val_uni $< >$@

$(PREFIX1C).t1x: .deps/$(BASENAME).$(PREFIX1).cat.t1x
	xsltproc --stringparam alt cat alt.xsl $< >$@

$(PREFIX1V).t1x: .deps/$(BASENAME).$(PREFIX1).val_gva.t1x
	xsltproc --stringparam alt val_gva alt.xsl $< >$@

$(PREFIX1U).t1x: .deps/$(BASENAME).$(PREFIX1).val_uni.t1x
	xsltproc --stringparam alt val_uni alt.xsl $< >$@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=								\
		$(BASENAME).$(PREFIX1).lrx      \
		$(BASENAME).$(PREFIX2).lrx      \
		$(BASENAME).$(PREFIX1).dix 		\
		$(BASENAME).$(PREFIX1).dix 		\
		$(BASENAME).$(PREFIX1).t1x 		\
		$(BASENAME).$(PREFIX1C).t1x 	\
		$(BASENAME).$(PREFIX1V).t1x 	\
		$(BASENAME).$(PREFIX1U).t1x 	\
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
	$(PREFIX1U).t1x					\
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
