# Compila os slides no Windows (duas passadas, necessárias para os diagramas TikZ).
# Requer uma distribuição LaTeX com beamer, tikz, pgf e listings (MiKTeX ou TeX Live).
# Uso (a partir de slides/):  powershell -ExecutionPolicy Bypass -File build.ps1
Set-Location $PSScriptRoot
pdflatex -interaction=nonstopmode -halt-on-error main.tex
pdflatex -interaction=nonstopmode -halt-on-error main.tex
Write-Host "OK: slides/main.pdf"
