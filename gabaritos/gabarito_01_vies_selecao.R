# =============================================================================
# GABARITO — ATIVIDADE 1 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")

forcas <- c(0, 0.5, 0.9, 1.5)
resultado <- data.frame(forca_motivacao = forcas, estimativa = NA, vies = NA)

for (i in seq_along(forcas)) {
  d <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = forcas[i])
  media_part <- mean(d$renda_depois[d$participa == 1])
  media_nao  <- mean(d$renda_depois[d$participa == 0])          # <- resposta
  resultado$estimativa[i] <- media_part - media_nao
  resultado$vies[i]       <- resultado$estimativa[i] - 300
}
print(round(resultado, 1))

d0 <- gerar_populacao(n = 5000, efeito = 300, tendencia = 0)    # <- resposta
part <- d0[d0$participa == 1, ]
antes_depois <- mean(part$renda_depois) - mean(part$renda_antes) # <- resposta
cat("Antes x depois sem tendência:", round(antes_depois, 1), "\n")

# RESPOSTAS ESPERADAS
# 1) Não. Mesmo com forca_motivacao = 0 resta viés (~ +R$ 150), pois a
#    escolaridade (observável) e a idade também afetam inscrição E renda. O viés
#    cresce quase linearmente com a força da seleção na motivação.
# 2) Sem tendência, o antes-depois recupera ~R$ 300 (a mudança só vem do
#    programa). Não é realista: inflação, ciclo econômico, envelhecimento etc.
#    mudam a renda de todos com o tempo.
# 3) A comparação ingênua sugere ~R$ 590 de ganho; o gestor superestimaria quase
#    2x o impacto (decisões de ampliar/manter o programa com base em número inflado).
