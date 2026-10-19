# =============================================================================
# GABARITO — ATIVIDADE 4 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")

evasao_com_antes <- 12;  evasao_com_depois <- 8
evasao_sem_antes <- 10;  evasao_sem_depois <- 9
mudanca_com <- evasao_com_depois - evasao_com_antes     # -4
mudanca_sem <- evasao_sem_depois - evasao_sem_antes     # -1   <- resposta
dd <- mudanca_com - mudanca_sem                         # -3   <- resposta
cat("DD =", dd, "pontos percentuais\n")
# Antes-depois só das escolas com programa: -4 (superestima a queda).
# Comparação só no depois: 8 - 9 = -1 (subestima). O DD = -3 fica no meio.

painel <- gerar_painel(extra_tendencia_trat = 20)                              # <- resposta
m <- function(t, p) mean(painel$renda[painel$tratado == t & painel$pos == p])
dd_painel <- (m(1, 1) - m(1, 0)) - (m(0, 1) - m(0, 0))                          # <- resposta
cat("DD estimado:", round(dd_painel, 1), "| verdade: 300\n")

pre <- painel[painel$trimestre <= 3, ]
pre$pos_falso <- as.integer(pre$trimestre >= 2)
placebo <- coef(lm(renda ~ tratado * pos_falso, data = pre))["tratado:pos_falso"]
cat("DD placebo:", round(placebo, 1), "\n")

painel0 <- gerar_painel(efeito = 0)                                             # <- resposta
print(summary(lm(renda ~ tratado * pos, data = painel0))$coefficients["tratado:pos", ])

# RESPOSTAS ESPERADAS
# 1) Antes-depois: -4; só depois: -1; DD: -3.
# 2) Com +20/trimestre de tendência extra, o DD sai ~R$ 360 (viés ~ +60): a
#    tendência extra é atribuída ao programa. O placebo dá ~+17, fora do zero
#    (sinal de alerta). Em dados reais, o placebo é um indício, não prova.
# 3) Ex.: crise econômica com efeitos distintos por sexo, mudança na
#    notificação de crimes, política de armas, migração por gênero etc.
