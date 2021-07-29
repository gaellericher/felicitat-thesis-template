# Felicitat

LaTeX manuscript template in French, based on the `classicthesis` package. Font: Alegreya.


## How to

Compile with:
```
latexmk -pdf --shell-escape -recorder main.tex
```

`Makefile` generates multiple version of the manuscript, including separate chapter files and minimized PDF.
Run `make` to generate all pdf outputs.

Example output: [manuscript-min.pdf](./manuscript-min.pdf)


## Dependencies

* `classicthesis.sty`
* ...


Ubuntu repository package list: `tex-common texlive-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-publishers texlive-fonts-extra texlive-science texlive-bibtex-extra biber ghostscript`.
