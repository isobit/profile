PDFC=pdflatex -shell-escape -interaction=nonstopmode -file-line-error
TEXC=latex
BIBC=bibtex

all: report.pdf

report.pdf: report.tex
	$(PDFC) report.tex

watch: report.pdf
	ls *.tex | entr make

clean:
	@rm report.aux report.dvi report.log report.pdf
