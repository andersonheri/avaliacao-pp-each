# =============================================================================
# GABARITO — ATIVIDADE 2 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")
dp <- 430

resp1 <- power.t.test(delta = 100, sd = dp, sig.level = 0.05, power = 0.90)   # <- respostas
cat("Pessoas por grupo:", ceiling(resp1$n), "\n")     # ~389

set.seed(42)
rejeita <- replicate(500, {
  controle    <- rnorm(100, mean = 2000, sd = dp)
  tratamento  <- rnorm(100, mean = 2000 + 150, sd = dp)                        # <- resposta
  t.test(tratamento, controle)$p.value < 0.05
})
cat("Poder estimado por simulação:", mean(rejeita), "\n")                       # ~0,70
cat("Poder teórico:", round(power.t.test(n = 100, delta = 150, sd = dp)$power, 3), "\n")

dados <- gerar_populacao(n = 5000, efeito = 300)
set.seed(99)
Z <- sample(rep(0:1, length.out = nrow(dados)))
adesao <- 0.40
D <- ifelse(Z == 1, rbinom(nrow(dados), 1, adesao), rbinom(nrow(dados), 1, 0.05))
y <- ifelse(D == 1, dados$renda_depois_Y1, dados$renda_depois_Y0)
itt  <- mean(y[Z == 1]) - mean(y[Z == 0])
aumento_adesao <- mean(D[Z == 1]) - mean(D[Z == 0])                             # <- resposta
cace <- itt / aumento_adesao
cat("ITT:", round(itt), "| aumento da adesão:", round(aumento_adesao, 2),
    "| efeito sobre quem aderiu:", round(cace), "\n")

# RESPOSTAS ESPERADAS
# 1) O poder depende do efeito RELATIVO à variabilidade (delta/sd). Efeito 3x menor
#    exige ~9x mais gente (o n cai com o QUADRADO de delta/sd).
# 2) O ITT cai (~R$ 100 com 40% de adesão) porque a oferta atinge menos gente; o
#    efeito sobre quem aderiu continua ~R$ 300. Para expandir a política, o ITT
#    informa o efeito da OFERTA no mundo real (com a adesão que se espera); o
#    efeito sobre aderentes diz o que o programa faz para quem de fato o usa.
# 3) Ética: negar benefício a elegíveis; prática: contaminação entre grupos.
#    Phased-in: todos recebem, em ordem sorteada; controle = quem ainda espera.
