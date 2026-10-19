# =============================================================================
# EXERCÍCIO 2: Diferença-em-diferenças e o pressuposto de tendências paralelas  (~10 min)
# -----------------------------------------------------------------------------
# Onde aparecer COMPLETE, escreva o código que falta.
# =============================================================================

source("scripts/00_setup.R")

# ---- TAREFA 1: DD "na calculadora" -------------------------------------------
# Um programa de bolsa-permanência escolar foi adotado em algumas escolas.
# Taxa de evasão (%) nas escolas COM e SEM o programa, antes e depois:
#                 Antes   Depois
#   Com programa   12       8
#   Sem programa   10       9
mudanca_com <- 8 - 12
mudanca_sem <- COMPLETE                       # <- mudança das escolas SEM programa
dd <- COMPLETE                                # <- diferença das duas mudanças
cat("DD =", dd, "pontos percentuais\n")

# ---- TAREFA 2: quando as tendências NÃO são paralelas -------------------------
# Gere um painel em que os tratados já cresciam MAIS RÁPIDO (+R$ 20 por
# trimestre, com ou sem programa) e compare o DD com o efeito verdadeiro (R$ 300).
painel <- gerar_painel(extra_tendencia_trat = COMPLETE)

m <- function(t, p) mean(painel$renda[painel$tratado == t & painel$pos == p])
dd_painel <- COMPLETE                         # <- (m(1,1) - m(1,0)) - (m(0,1) - m(0,0))
cat("DD estimado:", round(dd_painel, 1), "| verdade: 300\n")

# Teste placebo: finja que o programa começou no trimestre 2, usando só os
# trimestres 1 a 3 (antes do programa real). O DD placebo deveria ser ~0.
pre <- painel[painel$trimestre <= 3, ]
pre$pos_falso <- as.integer(pre$trimestre >= 2)
placebo <- coef(lm(renda ~ tratado * pos_falso, data = pre))["tratado:pos_falso"]
cat("DD placebo:", round(placebo, 1), "\n")

# ---- PERGUNTAS ---------------------------------------------------------------
# 1) Na tarefa 1, o antes-depois só das escolas com programa daria -4. O DD
#    deu um valor diferente. Por quê?
#    R:
# 2) Na tarefa 2, o DD acertou os R$ 300? O placebo avisou do problema?
#    R:
# 3) Lei Maria da Penha: o grupo de controle foram os HOMENS. Cite um evento
#    que poderia afetar mulheres e homens de forma diferente e violar as
#    tendências paralelas.
#    R:
