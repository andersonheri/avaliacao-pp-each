# =============================================================================
# ATIVIDADE 2 — Planejando um experimento: poder e não-cumprimento   (~15 min)
# -----------------------------------------------------------------------------
# Contexto: o município vai testar o Qualifica com um SORTEIO. Antes de
# começar, a equipe precisa saber (a) quantas pessoas recrutar e (b) o que
# esperar se muita gente sorteada não aderir.
#
# Onde aparecer COMPLETE, escreva o código que falta.
# =============================================================================

source("scripts/00_setup.R")
dp <- 430          # desvio-padrão da renda (estimado no script 02)

# ---- TAREFA 1: tamanho de amostra (power.t.test) ------------------------------
# Quantas pessoas POR GRUPO para detectar um efeito de R$ 100 com poder de 90%
# (e significância de 5%)?
resp1 <- power.t.test(delta = COMPLETE, sd = dp, sig.level = 0.05, power = COMPLETE)
cat("Pessoas por grupo:", ceiling(resp1$n), "\n")

# ---- TAREFA 2: poder por SIMULAÇÃO ------------------------------------------
# Simule 500 experimentos pequenos (100 pessoas por grupo, efeito verdadeiro de
# R$ 150) e conte em quantos o teste t detecta o efeito (p < 0,05).
set.seed(42)
rejeita <- replicate(500, {
  controle    <- rnorm(100, mean = 2000, sd = dp)
  tratamento  <- rnorm(100, mean = 2000 + COMPLETE, sd = dp)   # <- some o efeito
  t.test(tratamento, controle)$p.value < 0.05
})
cat("Poder estimado por simulação:", mean(rejeita), "\n")
# Compare com a resposta teórica:
cat("Poder teórico:", round(power.t.test(n = 100, delta = 150, sd = dp)$power, 3), "\n")

# ---- TAREFA 3: não-cumprimento (compliance) -----------------------------------
# Rode e depois TROQUE a taxa de adesão de 0.70 para 0.40.
dados <- gerar_populacao(n = 5000, efeito = 300)
set.seed(99)
Z <- sample(rep(0:1, length.out = nrow(dados)))                  # sorteio
adesao <- 0.70                                                   # <- troque para 0.40
D <- ifelse(Z == 1, rbinom(nrow(dados), 1, adesao), rbinom(nrow(dados), 1, 0.05))
y <- ifelse(D == 1, dados$renda_depois_Y1, dados$renda_depois_Y0)

itt  <- mean(y[Z == 1]) - mean(y[Z == 0])                         # efeito do SORTEIO
aumento_adesao <- COMPLETE        # <- mean(D[Z == 1]) - mean(D[Z == 0])
cace <- itt / aumento_adesao                                      # efeito sobre quem aderiu
cat("ITT:", round(itt), "| aumento da adesão:", round(aumento_adesao, 2),
    "| efeito sobre quem aderiu:", round(cace), "\n")

# ---- PERGUNTAS ---------------------------------------------------------------
# 1) Por que detectar R$ 100 exige MUITO mais gente do que detectar R$ 300?
#    R:
# 2) O que acontece com o ITT quando a adesão cai para 40%? E com o efeito
#    sobre quem aderiu? Qual dos dois o gestor deve usar para decidir expandir
#    a política para toda a população?
#    R:
# 3) Cite um possível problema ÉTICO ou prático em sortear quem recebe uma
#    política (artigo, p. 7-8). Como a implementação em fases (phased-in)
#    ajuda?
#    R:
