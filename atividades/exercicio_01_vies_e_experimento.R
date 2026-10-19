# =============================================================================
# EXERCÍCIO 1: Viés de seleção x experimento                      (~12 min)
# -----------------------------------------------------------------------------
# No programa Qualifica, quanto MAIS a motivação (não observada) influencia
# quem se inscreve, mais os participantes diferem dos demais. Um sorteio
# elimina esse problema? E quantas pessoas precisamos para detectar o efeito?
#
# COMO FAZER: rode linha a linha (Ctrl+Enter). Onde aparecer COMPLETE,
# substitua pelo código que falta. Depois responda às perguntas no final.
# =============================================================================

source("scripts/00_setup.R")

# ---- TAREFA 1: o viés da comparação ingênua e o do sorteio -------------------
forcas <- c(0, 0.5, 0.9, 1.5)       # 0 = a motivação NÃO influencia a inscrição
resultado <- data.frame(forca_motivacao = forcas, ingenua = NA, sorteio = NA)

for (i in seq_along(forcas)) {
  d <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = forcas[i])

  # (a) Comparação ingênua: participantes x não participantes
  media_part <- mean(d$renda_depois[d$participa == 1])
  media_nao  <- COMPLETE                      # <- média dos NÃO participantes
  resultado$ingenua[i] <- media_part - media_nao

  # (b) Experimento: o avaliador SORTEIA quem recebe o programa
  set.seed(123)
  d$trat <- sample(rep(0:1, length.out = nrow(d)))
  y <- ifelse(d$trat == 1, d$renda_depois_Y1, d$renda_depois_Y0)
  resultado$sorteio[i] <- mean(y[d$trat == 1]) - COMPLETE   # <- média do controle
}
print(round(resultado, 1))        # a verdade é 300

# ---- TAREFA 2: quantas pessoas precisamos? ----------------------------------
# Quantas pessoas POR GRUPO para detectar um efeito de R$ 100, com poder de 90%
# (nível de significância de 5%)? O desvio-padrão da renda é cerca de 430.
resp <- power.t.test(delta = COMPLETE, sd = 430, sig.level = 0.05, power = COMPLETE)
cat("Pessoas por grupo:", ceiling(resp$n), "\n")

# ---- PERGUNTAS (responda em comentários) -------------------------------------
# 1) Mesmo com forca_motivacao = 0 a comparação ingênua erra. Por quê?
#    R:
# 2) O que acontece com a estimativa do sorteio quando a força da motivação
#    aumenta? Por quê?
#    R:
# 3) Por que detectar R$ 100 exige muito mais gente do que detectar R$ 300?
#    R:
