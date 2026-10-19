# =============================================================================
# ATIVIDADE 4 — Diferença-em-Diferenças: calcule e teste o pressuposto  (~15 min)
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
evasao_com_antes <- 12;  evasao_com_depois <- 8
evasao_sem_antes <- 10;  evasao_sem_depois <- 9

mudanca_com <- evasao_com_depois - evasao_com_antes
mudanca_sem <- COMPLETE                       # <- mudança das escolas SEM programa
dd <- COMPLETE                                # <- diferença das duas mudanças
cat("DD =", dd, "pontos percentuais\n")

# ---- TAREFA 2: tendências paralelas ------------------------------------------
# Gere um painel em que os tratados já cresciam MAIS RÁPIDO (+R$ 20 por
# trimestre) e compare o DD com o efeito verdadeiro (R$ 300).
painel <- gerar_painel(extra_tendencia_trat = COMPLETE)

m <- function(t, p) mean(painel$renda[painel$tratado == t & painel$pos == p])
dd_painel <- COMPLETE                         # <- (m(1,1) - m(1,0)) - (m(0,1) - m(0,0))
cat("DD estimado:", round(dd_painel, 1), "| verdade: 300\n")

# Teste placebo: finja que o programa começou no trimestre 2, usando só os
# trimestres 1 a 3 (antes do programa real).
pre <- painel[painel$trimestre <= 3, ]
pre$pos_falso <- as.integer(pre$trimestre >= 2)
placebo <- coef(lm(renda ~ tratado * pos_falso, data = pre))["tratado:pos_falso"]
cat("DD placebo:", round(placebo, 1), "\n")

# ---- TAREFA 3 (desafio): efeito zero ------------------------------------------
# Gere um painel com efeito = 0 e tendências paralelas e estime o DD por
# regressão: o coeficiente de tratado:pos deve ficar perto de zero?
painel0 <- gerar_painel(efeito = COMPLETE)
summary(lm(renda ~ tratado * pos, data = painel0))$coefficients["tratado:pos", ]

# ---- PERGUNTAS ---------------------------------------------------------------
# 1) Na tarefa 1, qual seria a estimativa "ingênua" antes-depois só das escolas
#    com programa? E a comparação entre escolas COM e SEM programa só no "depois"?
#    Qual das duas está mais perto do DD?
#    R:
# 2) Na tarefa 2, o DD acertou? O teste placebo avisou do problema?
#    R:
# 3) Lei Maria da Penha (artigo, p. 11-12): o grupo de controle foram os
#    HOMENS. Cite um evento que poderia afetar mulheres e homens de forma
#    diferente e violar tendências paralelas.
#    R:
