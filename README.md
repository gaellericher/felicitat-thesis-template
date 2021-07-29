# Felicitat

LaTeX manuscript template in French, based on the `classicthesis` package.


## How to

Compile with:
```
latexmk -pdf --shell-escape -recorder main.tex
```

`Makefile` generates multiple version of the manuscript, including separate chapter files and minimized PDF.
Run `make` to generate all versions.



## Dependencies

tex-common
texlive-base
texlive-latex-recommended
texlive-latex-extra
texlive-fonts-recommended
texlive-publishers
texlive-fonts-extra
texlive-science
texlive-bibtex-extra
biber
