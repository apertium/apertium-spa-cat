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
     $(PREFVAR1)$(PREFIX1).autopgen.bin $(PREFVAR2)$(PREFIX1).autopgen.bin \
     $(PREFIX2).automorf.bin $(PREFIX2).autobil.bin \
     $(PREFIX2).autogen.bin $(PREFIX2).autopgen.bin modes \
     $(PREFIX1).lextormono.bin $(PREFIX2).lextormono.bin \
     $(PREFIX1).lextorbil.bin $(PREFIX2).lextorbil.bin \
     $(BASENAME).$(LANG1)-lextor.dix $(BASENAME).$(LANG2)-lextor.dix \
     $(BASENAME).$(PREFIX1)-lextor.dix $(BASENAME).$(PREFIX2)-lextor.dix

TARGETS = $(TARGETS_COMMON) $(PREFVAR1)$(PREFIX1).t1x.bin \
          $(PREFVAR2)$(PREFIX1).t1x.bin $(PREFVAR1)$(PREFIX2).t1x.bin \
          $(PREFVAR2)$(PREFIX2).t1x.bin \
          $(PREFVAR1)$(PREFIX1).t1x $(PREFVAR1)$(PREFIX2).t1x \
          $(PREFVAR2)$(PREFIX1).t1x $(PREFVAR2)$(PREFIX2).t1x

.deps/commonbil.dix: $(BASENAME).$(PREFIX1).dix
	xsltproc --stringparam lang cat --stringparam side right filter.xsl $< | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/pgen-ca.dix: $(BASENAME).post-ca.dix
	xsltproc --stringparam alt cat alt.xsl $< >$@ 

.deps/pgen-ca_valencia.dix: $(BASENAME).post-ca.dix
	xsltproc --stringparam alt val alt.xsl $< >$@ 

$(BASENAME).$(LANG1)-lextor.dix: .deps/commonbil.dix
	apertium-validate-dictionary .deps/commonbil.dix
	apertium-gen-lextormono rl .deps/commonbil.dix $@

$(BASENAME).$(LANG2)-lextor.dix: .deps/commonbil.dix
	apertium-validate-dictionary .deps/commonbil.dix
	apertium-gen-lextormono lr .deps/commonbil.dix $@

$(BASENAME).$(PREFIX1)-lextor.dix: .deps/commonbil.dix
	apertium-validate-dictionary .deps/commonbil.dix
	apertium-gen-lextorbil rl .deps/commonbil.dix $@

$(BASENAME).$(PREFIX2)-lextor.dix: .deps/commonbil.dix
	apertium-validate-dictionary .deps/commonbil.dix
	apertium-gen-lextorbil lr .deps/commonbil.dix $@

$(PREFIX1).lextormono.bin: $(BASENAME).$(LANG1)-lextor.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).lextormono.bin: $(BASENAME).$(LANG2)-lextor.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX1).lextorbil.bin: $(BASENAME).$(PREFIX1)-lextor.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).lextorbil.bin: $(BASENAME).$(PREFIX2)-lextor.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@


.deps/$(PREFVAR1)$(LANG1).dix: $(BASENAME).$(LANG1).dix
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang cat --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR2)$(LANG1).dix: $(BASENAME).$(LANG1).dix
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang val --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR1)$(LANG2).dix: $(BASENAME).$(LANG2).dix
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang cat --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR2)$(LANG2).dix: $(BASENAME).$(LANG2).dix
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang val --stringparam side left filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR1)$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix
	xsltproc translate-to-default-equivalent.xsl $< | xsltproc --stringparam lang cat --stringparam side right filter.xsl - | xsltproc --stringparam alt std alt.xsl - | gawk '{gsub("&","&amp;"); print;}'  >$@

.deps/$(PREFVAR2)$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix
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

EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).post-$(LANG1).dix $(BASENAME).post-$(LANG2).dix \
           $(BASENAME).$(LANG2).dix $(BASENAME).$(LANG1).tsx \
           $(BASENAME).$(LANG2).tsx $(BASENAME).$(PREFIX1).t1x \
           $(BASENAME).$(PREFIX2).t1x $(PREFIX1).prob $(PREFIX2).prob \
           modes.xml translate-to-default-equivalent.xsl alt.xsl \
           $(PREFIX1)-latin1.prob $(PREFIX2)-latin1.prob \
           $(BASENAME).$(LANG1).acx $(BASENAME).$(LANG2).acx \
	   filter.xsl filter.sh .deps
           
apertium_es_cadir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_es_modesdir=$(prefix)/share/apertium/modes/

$(PREFIX1).mode: modes.xml 
	apertium-gen-modes modes.xml
	cp *.mode modes/

$(PREFIX2).mode: modes.xml 
	apertium-gen-modes modes.xml
	cp *.mode modes/

$(PREFVAR2)$(PREFIX1).mode: modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

modes: modes.xml
	apertium-gen-modes modes.xml
           
apertium_es_ca_DATA=$(PREFVAR1)$(PREFIX1).automorf.bin $(PREFVAR1)$(PREFIX2).automorf.bin \
	$(PREFVAR1)$(PREFIX1).autobil.bin $(PREFVAR1)$(PREFIX2).autobil.bin \
	$(PREFVAR1)$(PREFIX1).autogen.bin $(PREFVAR1)$(PREFIX2).autogen.bin \
	$(PREFVAR2)$(PREFIX1).automorf.bin $(PREFVAR2)$(PREFIX2).automorf.bin \
	$(PREFVAR2)$(PREFIX1).autobil.bin $(PREFVAR2)$(PREFIX2).autobil.bin \
	$(PREFVAR2)$(PREFIX1).autogen.bin $(PREFVAR2)$(PREFIX2).autogen.bin \
	$(PREFVAR1)$(PREFIX1).autopgen.bin $(PREFVAR2)$(PREFIX1).autopgen.bin \
        $(PREFIX2).autopgen.bin \
	$(PREFVAR1)$(PREFIX1).lextorbil.bin $(PREFVAR1)$(PREFIX2).lextorbil.bin \
	$(PREFVAR1)$(PREFIX1).lextormono.bin $(PREFVAR1)$(PREFIX2).lextormono.bin \
	$(PREFIX1).prob $(PREFIX2).prob \
	$(PREFVAR1)$(PREFIX1).t1x $(PREFVAR1)$(PREFIX2).t1x \
	$(PREFVAR1)$(PREFIX1).t1x.bin $(PREFVAR1)$(PREFIX2).t1x.bin \
	$(PREFVAR2)$(PREFIX1).t1x $(PREFVAR2)$(PREFIX2).t1x \
	$(PREFVAR2)$(PREFIX1).t1x.bin $(PREFVAR2)$(PREFIX2).t1x.bin \
	$(PREFVAR1)$(PREFIX1).mode $(PREFVAR1)$(PREFIX2).mode \
	$(PREFVAR2)$(PREFIX1).mode $(PREFVAR2)$(PREFIX2).mode \
	$(PREFVAR1)$(PREFIX1)-multi.mode $(PREFVAR1)$(PREFIX2)-multi.mode \
	$(BASENAME).$(LANG1)-lextor.dix $(BASENAME).$(LANG2)-lextor.dix \
	$(BASENAME).$(PREFIX1)-lextor.dix $(BASENAME).$(PREFIX2)-lextor.dix

install-data-local:
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	cp *.mode modes/
	test -d $(DESTDIR)$(apertium_es_modesdir) || mkdir $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX1).mode $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX2).mode $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) $(PREFVAR2)$(PREFIX1).mode $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) $(PREFVAR2)$(PREFIX2).mode $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) es-ca_valencia.mode $(DESTDIR)$(apertium_es_modesdir)	
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX1)-multi.mode $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) $(PREFVAR1)$(PREFIX2)-multi.mode $(DESTDIR)$(apertium_es_modesdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_es_cadir)

CLEANFILES = -rf $(TARGETS) modes $(PREFVAR2)$(PREFIX1).automorf.bin $(PREFVAR2)$(PREFIX1).autobil.bin \
		$(PREFVAR2)$(PREFIX2).automorf.bin $(PREFVAR2)$(PREFIX2).autobil.bin \
		$(PREFVAR2)$(PREFIX2).autogen.bin $(PREFVAR2)$(PREFIX1).autogen.bin \
		.dep/ca.dix .dep/commonbil.dix .dep/es-ca.dix .dep/es.dix .dep/pgen-ca.dix \
		.dep/pgen-ca_valencia.dix .dep/val-ca.dix .dep/val-es-ca.dix .dep/val-es.dix 

