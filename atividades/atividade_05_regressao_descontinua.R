# =============================================================================
# ATIVIDADE 5 — Regressão Descontínua: janela, corte e manipulação   (~15 min)
# -----------------------------------------------------------------------------
# Onde aparecer COMPLETE, escreva o código que falta. Efeito verdadeiro = 6 p.p.
# Você usará rdd_local() (scripts/funcoes_metodos.R).
# =============================================================================

source("scripts/00_setup.R")

# ---- TAREFA 1: escolha da janela ---------------------------------------------
d <- gerar_rdd()                      # corte em R$ 77
for (h in c(5, 15, 40)) {
  r <- rdd_local(d, h = COMPLETE)     # <- use a janela do laço (h)
  cat("Janela ±", h, "| efeito:", round(r$efeito, 2), "| EP:", round(r$ep, 2),
      "| n:", r$n, "\n")
}

# ---- TAREFA 2: dados com um corte diferente ---------------------------------
# O município endurece a regra: agora o corte é R$ 70. Gere novos dados e
# estime o efeito (lembre: 'x' é centrada no corte, e gerar_rdd já cuida disso).
d70 <- gerar_rdd(corte = COMPLETE)
r70 <- rdd_local(d70, h = 15)
cat("Corte R$ 70 -> efeito:", round(r70$efeito, 2), "\n")

# ---- TAREFA 3: manipulação do corte -------------------------------------------
# Gere dados em que as famílias "arrumaram" a renda declarada, estime o efeito e
# compare com o resultado sem manipulação.
d_manip <- gerar_rdd(manipulacao = COMPLETE)      # <- TRUE
r_manip <- rdd_local(d_manip, h = 15)
cat("Efeito sem manipulação:", round(rdd_local(d, 15)$efeito, 2),
    "| com manipulação:", round(r_manip$efeito, 2), "| verdade: 6\n")

# Quantas famílias há logo abaixo do corte (entre R$ 72 e 77) x logo acima (77 a 82)?
cat("Famílias em [72,77]:", sum(d_manip$renda > 72 & d_manip$renda <= 77),
    "| em (77,82]:", sum(d_manip$renda > 77 & d_manip$renda <= 82), "\n")

# ---- TAREFA 4 (desafio): peso triangular -------------------------------------
# Repita a tarefa 1 usando triangular = TRUE e compare as estimativas.
r_tri <- rdd_local(d, h = 15, triangular = COMPLETE)
cat("Janela ±15 triangular:", round(r_tri$efeito, 2), "\n")

# ---- PERGUNTAS ---------------------------------------------------------------
# 1) Como o erro-padrão e o número de famílias mudam com a janela? Qual você
#    escolheria e por quê?
#    R:
# 2) Na tarefa 3, o que o acúmulo de famílias logo abaixo do corte indica?
#    Por que isso compromete a validade do RDD?
#    R:
# 3) O efeito estimado vale para uma família com renda per capita de R$ 30?
#    Por quê? (artigo, p. 12: estimativas locais)
#    R:
