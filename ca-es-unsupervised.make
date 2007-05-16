TAGGER_UNSUPERVISED_ITERATIONS=8
BASENAME=apertium-es-ca
LANG1=ca
LANG2=es
TAGGER=$(LANG1)-tagger-data
PREFIX=$(LANG1)-$(LANG2)

all: $(PREFIX).prob

$(PREFIX).prob: $(BASENAME).$(LANG1).tsx $(TAGGER)/$(LANG1).dic $(TAGGER)/$(LANG1).crp
	apertium-validate-tagger $(BASENAME).$(LANG1).tsx
	apertium-tagger -t $(TAGGER_UNSUPERVISED_ITERATIONS) \
                           $(TAGGER)/$(LANG1).dic \
                           $(TAGGER)/$(LANG1).crp \
                           $(BASENAME).$(LANG1).tsx \
                           $(PREFIX).prob;

$(TAGGER)/$(LANG1).dic: $(BASENAME).$(LANG1).dix $(PREFIX).automorf.bin
	@echo "Generating $@";
	@echo "This may take some time. Please, take a cup of coffee and come back later.";
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	apertium-validate-tagger $(BASENAME).$(LANG1).tsx
	lt-expand $(BASENAME).$(LANG1).dix | grep -v "__REGEXP__" | grep -v ":<:" |\
	awk 'BEGIN{FS=":>:|:"}{print $$1 ".";}' | apertium-destxt >$(LANG1).dic.expanded
	@echo "." >>$(LANG1).dic.expanded
	@echo "?" >>$(LANG1).dic.expanded
	@echo ";" >>$(LANG1).dic.expanded
	@echo ":" >>$(LANG1).dic.expanded
	@echo "!" >>$(LANG1).dic.expanded
	@echo "42" >>$(LANG1).dic.expanded
	@echo "," >>$(LANG1).dic.expanded
	@echo "(" >>$(LANG1).dic.expanded
	@echo "\\[" >>$(LANG1).dic.expanded
	@echo ")" >>$(LANG1).dic.expanded
	@echo "\\]" >>$(LANG1).dic.expanded
	@echo "¿" >>$(LANG1).dic.expanded
	@echo "¡" >>$(LANG1).dic.expanded
	lt-proc -a $(PREFIX).automorf.bin <$(LANG1).dic.expanded | \
	apertium-filter-ambiguity $(BASENAME).$(LANG1).tsx > $@
	rm $(LANG1).dic.expanded;

$(TAGGER)/$(LANG1).crp: $(PREFIX).automorf.bin $(TAGGER)/$(LANG1).crp.txt
	apertium-destxt < $(TAGGER)/$(LANG1).crp.txt | lt-proc $(PREFIX).automorf.bin > $(TAGGER)/$(LANG1).crp

clean:
	rm -f $(PREFIX).prob
