PROJECT='iuf-rulebook'

REPO='../rulebook-latex'
POOTLE='../pootle'

SRCDIR=$(REPO)'/src'
OUTDIR=$(REPO)'/out'
PODIR=$(REPO)'/po'
TRANSLATEDDIR=$(REPO)'/translated'

OLDCOMMIT='2012'
NEWCOMMIT='master'
DIFFNAME=$(PROJECT)-diff-$(OLDCOMMIT)-$(NEWCOMMIT)

PO4ACHARSETS=-M Utf-8 -L Utf-8
LATEXARGS= -output-directory=$(OUTDIR) -interaction=nonstopmode -file-line-error

all: master # translated


master:
	mkdir -p $(OUTDIR)
	TEXDIR=$(SRCDIR); \
	TEXINPUTS=$$TEXDIR: pdflatex $(LATEXARGS) -draftmode $$TEXDIR/$(PROJECT).tex 2>&1 | tee $(OUTDIR)/$(PROJECT).tex.log && \
	TEXINPUTS=$$TEXDIR: pdflatex $(LATEXARGS) $$TEXDIR/$(PROJECT).tex 2>&1 | tee $(OUTDIR)/$(PROJECT).tex.log; \

diff:
	mkdir -p $(OUTDIR)
	PATH="/usr/bin:$(PATH)"; \
	. /var/www/vhosts/unicycling.org/apps/rcs-latexdiff/venv/bin/activate; \
	rcs-latexdiff -vo $(SRCDIR)/$(DIFFNAME).tex --clean src/$(PROJECT).tex $(OLDCOMMIT) $(NEWCOMMIT)
	#latexdiff-vc --git --force --flatten -r $(OLDCOMMIT) -r $(NEWCOMMIT) src/iuf-rulebook.tex
	TEXDIR=$(SRCDIR); \
	TEXINPUTS=$$TEXDIR: pdflatex $(LATEXARGS) -draftmode $$TEXDIR/$(DIFFNAME).tex 2>&1 | tee $(OUTDIR)/$(DIFFNAME).tex.log && \
	TEXINPUTS=$$TEXDIR: pdflatex $(LATEXARGS) $$TEXDIR/$(DIFFNAME).tex 2>&1 | tee $(OUTDIR)/$(DIFFNAME).tex.log; \

translated: update-translation
	mkdir -p $(TRANSLATEDDIR)
	mkdir -p $(OUTDIR)
	for file in `find $(TRANSLATEDDIR)/*.tex`; do \
		TEXDIR=$(TRANSLATEDDIR); \
		TEXFILE=`basename $$file`; \
		#echo $$TEXDIR/$$TEXFILE: \
		TEXINPUTS=$$TEXDIR: pdflatex $(LATEXARGS) -draftmode $$TEXDIR/$$TEXFILE 2>&1 | tee $(OUTDIR)/$$TEXFILE.log && \
		TEXINPUTS=$$TEXDIR: pdflatex $(LATEXARGS) $$TEXDIR/$$TEXFILE 2>&1 | tee $(OUTDIR)/$$TEXFILE.log; \
	done

update-translation: translation-template
	tx pull -a
	TEXINPUTS=$(SRCDIR): po4a --variable repo=$(REPO) $(PO4ACHARSETS) po4a.cfg

translation-template: $(TRANSLATEDDIR) $(PODIR)
	TEXINPUTS=$(SRCDIR): po4a-gettextize -f latex -m $(SRCDIR)/$(PROJECT).tex $(PO4ACHARSETS) -p $(PODIR)/template.pot
	tx set --auto-local -t PO -r rulebook.master '$(PODIR)/<lang>.po' --source-lang en --source-file $(PODIR)/template.pot --execute
	tx push -s



$(OUTDIR):

$(TRANSLATEDDIR):

$(PODIR):
	mkdir -p $(PODIR)


clean:
	rm -rf $(OUTDIR)/*
	rm -rf $(TRANSLATEDDIR)

