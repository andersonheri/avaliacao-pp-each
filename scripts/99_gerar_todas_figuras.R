# =============================================================================
# 99_gerar_todas_figuras.R  |  (INSTRUTOR) Regera as figuras usadas nos slides
# -----------------------------------------------------------------------------
# Roda os scripts 01 a 05 salvando os gráficos em figuras/*.png.
# Depois, recompile os slides (slides/build.ps1 ou slides/build.sh).
# Uso:  Rscript scripts/99_gerar_todas_figuras.R   (a partir da pasta raiz)
# =============================================================================

Sys.setenv(SALVAR_FIGURAS = "1")      # liga o salvamento das figuras (ver 00_setup.R)

scripts <- c("01_contrafactual_vies_selecao.R", "02_experimento_rct.R",
             "03_pareamento_psm.R", "04_diferenca_em_diferenca.R",
             "05_regressao_descontinua.R")

for (s in scripts) {
  cat("\n>>> Rodando", s, "\n")
  source(file.path("scripts", s), echo = FALSE)
}
cat("\nFiguras salvas em figuras/:\n")
print(list.files("figuras"))
