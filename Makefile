MASTER  = Thesis
ABST  = AbstractSep
VERSION = v1.0
NAME    = Name
SURNAME = Surname

all: clean abstract
	@pdflatex ${MASTER}.tex
	#@test -f ${MASTER}-blx.bib && ( bibtex ${MASTER}; pdflatex ${MASTER}.tex ) || echo "No Bibtex"
	@bibtex ${MASTER}; pdflatex ${MASTER}.tex 
	@pdflatex -synctex=1 ${MASTER}.tex

abstract: clean
	@pdflatex -jobname=Abstract_${NAME}_${SURNAME} ${ABST}.tex

publish: all
	@ps2pdf14 -dPDFSETTINGS=/prepress ${MASTER}.pdf
	@mv ${MASTER}.pdf.pdf ${MASTER}.pdf

clean:
	@rm -rf *run.xml *-blx.bib *.aux *.bbl *.blg *.brf *.log *.lof *.lot *.lol *.out *.tcp *.toc *.tps *.bak *.backup *.pdfsync *.synctex.gz *.*~
	@for i in run.xml -blx.bib aux bbl blg brf log lof lot lol out tcp toc tps bak backup pdfsync synctex.gz; do find . -name *.$$i -exec rm -f {} + ; done
	@find . -name *.*~ -exec rm -f {} +

cleanall: clean
	@rm *.pdf

test: clean
	@pdflatex -interaction=nonstopmode -halt-on-error ${MASTER}.tex
	@test -f ${MASTER}-blx.bib && ( bibtex ${MASTER}; pdflatex ${MASTER}.tex ) || echo "No Bibtex" 
	@pdflatex ${MASTER}.tex

bz2: clean
	@echo 'creating package including Docs'
	@cd .. && tar --exclude-vcs -cf ${MASTER}-${NAME}_${SURNAME}-${VERSION}-`date +%Y%m%d`.tar `basename $(CURDIR)`
	@bzip2 ../${MASTER}-${NAME}_${SURNAME}-${VERSION}-`date +%Y%m%d`.tar

bz2-small: clean
	@echo 'creating package excluding Docs'
	@tar --exclude-vcs --exclude=Docs -cf ../${MASTER}-${NAME}_${SURNAME}-${VERSION}-`date +%Y%m%d`_small.tar .
	@bzip2 ../${MASTER}-${NAME}_${SURNAME}-${VERSION}-`date +%Y%m%d`_small.tar

