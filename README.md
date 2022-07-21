# Felicitat

LaTeX manuscript template in French, based on the `classicthesis` package. 
Font: Alegreya by Juan Pablo del Peral.

Example output: [manuscript-min.pdf](./manuscript-min.pdf)


## How to

Compile with:
```
latexmk -pdf --shell-escape -recorder main.tex
```

`Makefile` generates multiple versions of the manuscript, including separate chapter files and a minimized PDF. Run `make` to generate all pdf outputs.


## Features

- Based on the [classicthesis](https://www.ctan.org/tex-archive/macros/latex/contrib/classicthesis/) style
- Thesis title page
- Glossary example
- Margin figures
- Underline thesis author in publication list
- FontAwesome icons (LaTeX [package](https://ctan.org/pkg/fontawesome5))
- Precompilation of TikZ figures to PDF files
- PGFPlot example with CSV file

## Dependencies

Ubuntu repository package list: `tex-common texlive-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-publishers texlive-fonts-extra texlive-science texlive-bibtex-extra biber ghostscript`.


## TODO

- Document dependencies
- Optimize compilation time
- Document commands to cleanup auxiliary files
- Clean various custom commands
- Add an extra A5-format compilation mode
- Add a textidote command
- Add SVG figure example
- \usepackage{import}