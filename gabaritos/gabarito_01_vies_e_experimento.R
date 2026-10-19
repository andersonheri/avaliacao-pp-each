# =============================================================================
# GABARITO: EXERCÍCIO 1 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")

forcas <- c(0, 0.5, 0.9, 1.5)
resultado <- data.frame(forca_motivacao = forcas, ingenua = NA, sorteio = NA)

for (i in seq_along(forcas)) {
  d <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = forcas[i])
  media_part <- mean(d$renda_depois[d$participa == 1])
  media_nao  <- mean(d$renda_depois[d$participa == 0])                     # <- resposta
  resultado$ingenua[i] <- media_part - media_nao

  set.seed(123)
  d$trat <- sample(rep(0:1, length.out = nrow(d)))
  y <- ifelse(d$trat == 1, d$renda_depois_Y1, d$renda_depois_Y0)
  resultado$sorteio[i] <- mean(y[d$trat == 1]) - mean(y[d$trat == 0])      # <- resposta
}
print(round(resultado, 1))

resp <- power.t.test(delta = 100, sd = 430, sig.level = 0.05, power = 0.90) # <- respostas
cat("Pessoas por grupo:", ceiling(resp$n), "\n")                            # ~390

# RESPOSTAS ESPERADAS
# 1) Mesmo sem a motivação, escolaridade e idade (observáveis) afetam inscrição
#    E renda: o viés é de ~R$ 150. Com motivação forte chega a mais de R$ 320.
# 2) Nada: o sorteio recupera ~R$ 295 (próximo de 300) em qualquer cenário, porque a
#    aleatorização equilibra TODAS as características, inclusive as não observadas.
# 3) O poder depende do efeito relativo à variabilidade (delta/sd). Um efeito
#    3x menor exige ~9x mais gente (o n cai com o QUADRADO de delta/sd).
