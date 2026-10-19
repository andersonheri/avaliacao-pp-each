#!/usr/bin/env bash
# Compila os slides (duas passadas, necessárias para os diagramas TikZ).
# Requer uma distribuição LaTeX com beamer, tikz, pgf e listings (TeX Live, MiKTeX ou TinyTeX).
# Uso (a partir de slides/):  bash build.sh
set -e
cd "$(dirname "$0")"
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
echo "OK: slides/main.pdf"
