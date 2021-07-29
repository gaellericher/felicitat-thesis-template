TEX_C		:=latexmk -pdf -silent --shell-escape -recorder
SVG_C		:=@inkscape --without-gui --export-area-drawing -D -z
GRAPHIC_DIR	:=figures
TIKZ_EXT_DIR:=$(GRAPHIC_DIR)/cache


SVG_SRC		:=$(wildcard $(GRAPHIC_DIR)/*/*.svg)
MAIN_SRC  	:=main.tex
TEX_SRC		:=$(wildcard chapters/*.tex front-back-matter/*.tex main.tex figures/*/*.tex)

SVG_PDF		:=$(SVG_SRC:%.svg=%.pdf)
SVG_TEX		:=$(SVG_SRC:%.svg=%.pdf_tex)
TEX_OBJ		:=$(TEX_SRC:%.tex=%.aux)
CHAP_TEX	:=$(wildcard chapters/*.tex)

DOC_PDF		:=manuscript.pdf
CHAP_PDF	:=$(CHAP_TEX:chapters/%.tex=%_.pdf) 

THIRDPARTY	:=$(wildcard figures/thirdparty/*)
PLACEHOLDERS:=$(THIRDPARTY:figures/thirdparty/%=figures/placeholders/%) 


#-------------------------------------------------------------------
# Variables for different versions
#-------------------------------------------------------------------
PRINT		:=\newif\ifprint\printtrue
NOTPRINT	:=\newif\ifprint\printfalse

.SILENT: svg allchapters $(basename $(DOC_PDF))-min.pdf

.PHONY: deepclean clean svg cleantikz cleansvg allchapters validatebib validatefont placeholders

all:  $(basename $(DOC_PDF))-min.pdf $(basename $(DOC_PDF))-print-min.pdf allchapters

# Command to prepare svg figures (pre-compilation) 
# Generate .pdf and .pdf_tex for each .svg in place
$(SVG_PDF) : %.pdf : %.svg $(SVG_SRC) 
	$(SVG_C) --export-pdf=$(<:.svg=.pdf) --export-latex --file="$<"

svg: $(SVG_PDF) $(SVG_TEX)

# Create placeholder for all thirdparty images
#figures/placeholders/%: figures/thirdparty/%
#	convert $< -fill gray -colorize 100% $@

#placeholders: $(PLACEHOLDERS) 


#-------------------------------------------------------------------
# Command to compile full manuscript (archive version)
#-------------------------------------------------------------------
# Create folder for tikzexternalize
$(TIKZ_EXT_DIR):
	@mkdir -p $(TIKZ_EXT_DIR)

$(DOC_PDF): $(TEX_SRC) $(TIKZ_EXT_DIR) svg 
	$(TEX_C) -usepretex='$(NOTPRINT)$(NOTDIFFUSION)' -jobname=$(basename $@) $(MAIN_SRC)

# Version without colored links and citation
$(basename $(DOC_PDF))-print.pdf: $(TEX_SRC) $(TIKZ_EXT_DIR) svg 
	$(TEX_C) -jobname=$(basename $@) -usepretex='$(PRINT)$(NOTDIFFUSION)'  $(MAIN_SRC)

$(basename $(DOC_PDF))-print-min.pdf: $(basename $(DOC_PDF))-print.pdf
	gs -sDEVICE=pdfwrite \
	 -dCompatibilityLevel=1.7 \
	 -dPDFSETTINGS=/printer -dNOPAUSE \
	 -dQUIET \
	 -dNOSAFER \
	 -dBATCH \
	 -dAutoFilterColorImages=false \
	 -dAutoFilterGrayImages=false \
	 -dColorImageFilter=/FlateEncode \
	 -dGrayImageFilter=/FlateEncode \
	 -sOutputFile=$@ \
	  $<


$(basename $(DOC_PDF))-min.pdf: $(DOC_PDF)
	gs -sDEVICE=pdfwrite \
	 -dCompatibilityLevel=1.7 \
	 -dPDFSETTINGS=/printer -dNOPAUSE \
	 -dQUIET \
	 -dNOSAFER \
	 -dBATCH \
	 -dAutoFilterColorImages=false \
	 -dAutoFilterGrayImages=false \
	 -dColorImageFilter=/FlateEncode \
	 -dGrayImageFilter=/FlateEncode \
	 -sOutputFile=$@ \
	  $<

#-------------------------------------------------------------------
# Commands to compile separate chapters (archive version)
#-------------------------------------------------------------------

allchapters: $(CHAP_PDF) 

# Generate a chapter .pdf at root for each .tex chaper in 'chapters' folder
Chapter%_.pdf: chapters/Chapter%.tex $(TEX_SRC) $(DOC_PDF)
	echo "\includeonly{$(basename $<)}\input{main}" > tmp.tex
	$(TEX_C)   -usepretex='$(NOTPRINT)$(NOTDIFFUSION)' -jobname=$(basename $@) tmp.tex
	@rm -f tmp.*

#-------------------------------------------------------------------
# Cleanup commands
#-------------------------------------------------------------------
cleantikz:
	@rm -rf $(TIKZ_EXT_DIR)

cleansvg: 
	@rm -f $(SVG_SRC:svg=pdf_tex) $(SVG_SRC:svg=pdf)

clean: 
	@rm -f $(TEX_OBJ) $(basename $(DOC_PDF))*  tmp.* Chapter*

deepclean: clean cleansvg cleantikz

#-------------------------------------------------------------------
# Source cleanup commands
#-------------------------------------------------------------------

# Validate bibtex and print only references used in document
validatebib: $(DOC_PDF)
	biber --tool --validate-datamodel references/references.bib 

# Validate font use for correct printing
validatefont: $(DOC_PDF)
	pdffonts @< | grep "Type 3"
