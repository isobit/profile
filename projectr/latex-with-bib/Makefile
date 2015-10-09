PDFC=pdflatex -shell-escape -interaction=nonstopmode -file-line-error
TEXC=latex
BIBC=bibtex

all: report.pdf

report.pdf: report.tex report.bbl report.blg
	$(PDFC) report.tex

report.aux: report.tex
	$(TEXC) report.tex

report.bbl report.blg: report.bib report.aux
	$(BIBC) report

watch: report.pdf
	ls *.bib *.tex | entr make

clean:
	rm report.aux report.bbl report.bib.blg report.blg report.dvi report.log report.pdf
