# =============================================================================
# GABARITO: EXERCÍCIO 2 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")

mudanca_com <- 8 - 12
mudanca_sem <- 9 - 10                                  # -1   <- resposta
dd <- mudanca_com - mudanca_sem                        # -3   <- resposta
cat("DD =", dd, "pontos percentuais\n")

painel <- gerar_painel(extra_tendencia_trat = 20)                                 # <- resposta
m <- function(t, p) mean(painel$renda[painel$tratado == t & painel$pos == p])
dd_painel <- (m(1, 1) - m(1, 0)) - (m(0, 1) - m(0, 0))                             # <- resposta
cat("DD estimado:", round(dd_painel, 1), "| verdade: 300\n")                      # ~360

pre <- painel[painel$trimestre <= 3, ]
pre$pos_falso <- as.integer(pre$trimestre >= 2)
placebo <- coef(lm(renda ~ tratado * pos_falso, data = pre))["tratado:pos_falso"]
cat("DD placebo:", round(placebo, 1), "\n")                                       # ~17

# RESPOSTAS ESPERADAS
# 1) O antes-depois (-4) atribui ao programa a tendência de queda que já
#    ocorreria (as escolas sem programa também melhoraram: -1). O DD desconta
#    essa tendência: -3.
# 2) Não: com +20/trimestre de tendência extra, o DD sai ~R$ 360 (viés de ~R$ 60).
#    O placebo dá ~+17: longe de zero é um sinal de alerta (indício, não prova).
# 3) Ex.: crise econômica com efeitos distintos por sexo; mudança na notificação
#    de crimes; política de armas; migração diferenciada por gênero.
