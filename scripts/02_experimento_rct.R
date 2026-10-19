# =============================================================================
# 02_experimento_rct.R
# -----------------------------------------------------------------------------
# TEMA: Experimento controlado aleatorizado (RCT) - o "padrão ouro"
#
# OBJETIVOS DE APRENDIZAGEM
#   1. Ver que a ALEATORIZAÇÃO cria grupos equivalentes (inclusive na
#      motivação, que o avaliador não mede!);
#   2. Estimar o efeito com uma simples diferença de médias (e regressão);
#   3. Entender por que RCT funciona "em média" (simulação de Monte Carlo);
#   4. Calcular o tamanho de amostra necessário (power analysis);
#   5. Ver o que dá errado no campo: NÃO-CUMPRIMENTO (compliance) e ATRITO.
# =============================================================================

source("scripts/00_setup.R")

# -----------------------------------------------------------------------------
# PASSO 1: Mundo simulado + ALEATORIZAÇÃO
# -----------------------------------------------------------------------------
dados <- gerar_populacao(n = 5000, efeito = 300)
n <- nrow(dados)

# Em vez de deixar as pessoas se autoselecionarem (coluna "participa"),
# o avaliador SORTEIA quem recebe o programa, como uma loteria.
set.seed(123)                                     # semente do sorteio
dados$tratamento <- sample(rep(0:1, length.out = n))  # metade 1 (tratamento), metade 0 (controle)
table(dados$tratamento)

# Resultado observado no experimento: quem foi sorteado recebe o efeito.
dados$renda_exp <- ifelse(dados$tratamento == 1,
                          dados$renda_depois_Y1,   # renda COM programa
                          dados$renda_depois_Y0)   # renda SEM programa

# -----------------------------------------------------------------------------
# PASSO 2: Checagem de BALANCEAMENTO: a aleatorização funcionou?
# -----------------------------------------------------------------------------
# Se a loteria foi limpa, tratamento e controle devem ter características
# parecidas ANTES do programa. Inclusive a motivação (que na vida real não
# conseguimos medir, mas a aleatorização equilibra "por mágica").
covariaveis <- c("idade", "mulher", "escolaridade", "renda_antes", "motivacao")

balanco <- data.frame(
  variavel   = covariaveis,
  media_trat = sapply(covariaveis, function(v) mean(dados[[v]][dados$tratamento == 1])),
  media_ctrl = sapply(covariaveis, function(v) mean(dados[[v]][dados$tratamento == 0])),
  smd        = sapply(covariaveis, function(v) smd(dados[[v]], dados$tratamento))
)
titulo("BALANCEAMENTO no experimento (|SMD| < 0,10 = bom)")
balanco[, -1] <- round(balanco[, -1], 3)     # arredonda para facilitar a leitura
print(balanco, row.names = FALSE)

# Compare com o mundo NÃO experimental (quem se autosselecionou):
balanco_obs <- data.frame(
  variavel = covariaveis,
  smd_autoselecao = sapply(covariaveis, function(v) smd(dados[[v]], dados$participa))
)
titulo("Para comparar: SMD quando as pessoas se autosselecionam")
balanco_obs$smd_autoselecao <- round(balanco_obs$smd_autoselecao, 3)
print(balanco_obs, row.names = FALSE)

# Gráfico: SMD com aleatorização x com autosseleção (um "love plot")
love <- rbind(
  data.frame(variavel = covariaveis, smd = balanco$smd,           grupo = "Aleatorização (RCT)"),
  data.frame(variavel = covariaveis, smd = balanco_obs$smd_autoselecao, grupo = "Autosseleção")
)
g_balanco <- ggplot(love, aes(smd, variavel, colour = grupo)) +
  geom_vline(xintercept = c(-0.1, 0.1), linetype = "dashed", colour = "grey60") +
  geom_vline(xintercept = 0, colour = "grey40") +
  geom_point(size = 4) +
  scale_colour_manual(values = c("Aleatorização (RCT)" = cor_laranja, "Autosseleção" = cor_indigo), name = NULL) +
  labs(title = "Aleatorizar equilibra os grupos - até no que não vemos",
       subtitle = "Diferença padronizada de médias (SMD) entre tratamento e controle",
       x = "SMD (0 = grupos idênticos)", y = NULL)
print(g_balanco)
salvar_fig(g_balanco, "02_balanco")

# -----------------------------------------------------------------------------
# PASSO 3: Estimar o impacto: diferença de médias
# -----------------------------------------------------------------------------
media_t <- mean(dados$renda_exp[dados$tratamento == 1])
media_c <- mean(dados$renda_exp[dados$tratamento == 0])
cat("\nImpacto = média(tratamento) - média(controle) =", round(media_t - media_c, 1), "\n")

# Teste t: a diferença é estatisticamente significativa? (intervalo de confiança)
teste <- t.test(renda_exp ~ tratamento, data = dados)
print(teste)

# A MESMA coisa em formato de regressão (a forma mais usada na prática):
#   renda = b0 + b1 * tratamento + erro      -> b1 é o impacto
modelo1 <- lm(renda_exp ~ tratamento, data = dados)
summary(modelo1)$coefficients

# Adicionar covariáveis NÃO é necessário para eliminar o viés (a loteria já
# fez isso), mas reduz o erro-padrão (estimativa mais precisa):
modelo2 <- lm(renda_exp ~ tratamento + escolaridade + idade + mulher + renda_antes,
              data = dados)
titulo("Efeito estimado: sem covariáveis x com covariáveis")
cat("Sem covariáveis:", round(coef(modelo1)["tratamento"], 1),
    "(EP =", round(summary(modelo1)$coefficients["tratamento", 2], 1), ")\n")
cat("Com covariáveis:", round(coef(modelo2)["tratamento"], 1),
    "(EP =", round(summary(modelo2)$coefficients["tratamento", 2], 1), ")\n")
cat("Verdade:        300\n")

# -----------------------------------------------------------------------------
# PASSO 4: Por que funciona? Simulação de Monte Carlo
# -----------------------------------------------------------------------------
# Repetimos "a pesquisa" 1.000 vezes: em cada uma, sorteamos 400 pessoas da
# população e estimamos o efeito de duas maneiras:
#   (A) NÃO experimental: participantes x não participantes (autosseleção)
#   (B) Experimental: nós sorteamos quem recebe o programa.
# Se um método é NÃO VIESADO, a média das estimativas fica em cima da verdade.
set.seed(2026)
n_rep <- 1000
est_naive <- numeric(n_rep)    # guardará as estimativas do método (A)
est_rct   <- numeric(n_rep)    # guardará as estimativas do método (B)

for (i in 1:n_rep) {
  amostra <- dados[sample(n, 400), ]                       # amostra de 400 pessoas

  # (A) autosseleção: usa a coluna "participa" (renda_depois já reflete isso)
  est_naive[i] <- mean(amostra$renda_depois[amostra$participa == 1]) -
                  mean(amostra$renda_depois[amostra$participa == 0])

  # (B) experimento: sorteio novo nesta amostra
  trat <- sample(rep(0:1, length.out = 400))
  y    <- ifelse(trat == 1, amostra$renda_depois_Y1, amostra$renda_depois_Y0)
  est_rct[i] <- mean(y[trat == 1]) - mean(y[trat == 0])
}

titulo("MONTE CARLO (1.000 repetições, verdade = 300)")
cat("Autosseleção: média =", round(mean(est_naive), 1), "| desvio-padrão =", round(sd(est_naive), 1), "\n")
cat("Experimento:  média =", round(mean(est_rct), 1),   "| desvio-padrão =", round(sd(est_rct), 1), "\n")

mc <- data.frame(
  estimativa = c(est_naive, est_rct),
  metodo = rep(c("Autosseleção (viesado)", "Experimento (não viesado)"), each = n_rep)
)
g_mc <- ggplot(mc, aes(estimativa, fill = metodo)) +
  geom_histogram(bins = 60, alpha = 0.75, position = "identity", colour = NA) +
  geom_vline(xintercept = 300, colour = cor_verde, linewidth = 1.3) +
  annotate("text", x = 300, y = Inf, label = "Verdade: R$ 300", vjust = 1.5,
           hjust = -0.05, colour = cor_verde, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("Autosseleção (viesado)" = cor_indigo,
                               "Experimento (não viesado)" = cor_laranja), name = NULL) +
  labs(title = "Mil avaliações, dois métodos",
       subtitle = "Aleatorizar centra as estimativas na verdade; autosseleção erra sempre para o mesmo lado",
       x = "Impacto estimado (R$/mês)", y = "Nº de avaliações")
print(g_mc)
salvar_fig(g_mc, "02_montecarlo")

# -----------------------------------------------------------------------------
# PASSO 5: Poder estatístico e tamanho de amostra (power analysis)
# -----------------------------------------------------------------------------
# Erro tipo I (falso positivo): dizer que o programa funciona quando não funciona.
# Erro tipo II (falso negativo): NÃO detectar um efeito que existe.
# "Poder" = 1 - prob. de erro tipo II. Convenção: buscar poder de 80%.
#
# Quantas pessoas por grupo precisamos para detectar um efeito de R$ 300?
dp <- sd(dados$renda_exp)                        # variabilidade da renda
cat("\nDesvio-padrão da renda:", round(dp), "\n")

poder_300 <- power.t.test(delta = 300, sd = dp, sig.level = 0.05, power = 0.80)
cat("Para detectar R$ 300 com 80% de poder: n por grupo =", ceiling(poder_300$n), "\n")

poder_100 <- power.t.test(delta = 100, sd = dp, sig.level = 0.05, power = 0.80)
cat("Para detectar R$ 100 com 80% de poder: n por grupo =", ceiling(poder_100$n), "\n")
# Efeitos pequenos exigem amostras MUITO maiores: o desenho da avaliação
# (e o orçamento!) precisa ser pensado ANTES da política (ex-ante).

# Curva de poder: probabilidade de detectar o efeito para cada tamanho de grupo
tam <- seq(10, 600, by = 10)
curva <- rbind(
  data.frame(n = tam, efeito = "Efeito = R$ 300",
             poder = sapply(tam, function(k) power.t.test(n = k, delta = 300, sd = dp)$power)),
  data.frame(n = tam, efeito = "Efeito = R$ 150",
             poder = sapply(tam, function(k) power.t.test(n = k, delta = 150, sd = dp)$power)),
  data.frame(n = tam, efeito = "Efeito = R$ 100",
             poder = sapply(tam, function(k) power.t.test(n = k, delta = 100, sd = dp)$power))
)
g_poder <- ggplot(curva, aes(n, poder, colour = efeito)) +
  geom_hline(yintercept = 0.8, linetype = "dashed", colour = "grey50") +
  geom_line(linewidth = 1.4) +
  scale_colour_manual(values = c(cor_laranja, cor_indigo, cor_cinza), name = NULL) +
  scale_y_continuous(labels = function(x) paste0(round(100 * x), "%")) +
  labs(title = "Poder estatístico e tamanho da amostra",
       subtitle = "Quanto maior a amostra, maior a chance de detectar o efeito (tracejado = 80% de poder)",
       x = "Pessoas por grupo (tratamento e controle)", y = "Poder")
print(g_poder)
salvar_fig(g_poder, "02_poder")

# -----------------------------------------------------------------------------
# PASSO 6: Problemas de campo (1): NÃO-CUMPRIMENTO (compliance)
# -----------------------------------------------------------------------------
# Na prática, nem todo mundo sorteado participa, e alguns do controle acabam
# acessando o programa. Distinguimos:
#   Z = sorteio (oferta do programa)   D = participação efetiva
set.seed(99)
Z <- dados$tratamento
# 70% dos sorteados aceitam; 5% do controle consegue entrar por outro canal.
D <- ifelse(Z == 1, rbinom(n, 1, 0.70), rbinom(n, 1, 0.05))
# Quem decide aceitar tende a ser mais motivado -> comparar por D reintroduz viés!
# (aqui, para simplificar, o resultado depende apenas de D)
y_comp <- ifelse(D == 1, dados$renda_depois_Y1, dados$renda_depois_Y0)

# (a) ITT (intention-to-treat): compara pelo SORTEIO original, não pelo que fizeram.
itt <- mean(y_comp[Z == 1]) - mean(y_comp[Z == 0])
# (b) Quanto o sorteio aumentou a participação?
dif_particip <- mean(D[Z == 1]) - mean(D[Z == 0])
# (c) Efeito sobre quem participou POR CAUSA do sorteio (estimador de Wald / CACE):
cace <- itt / dif_particip

titulo("NÃO-CUMPRIMENTO (compliance)")
cat("ITT (efeito da OFERTA do programa):     ", round(itt, 1), "\n")
cat("Aumento da participação pelo sorteio:   ", round(dif_particip, 2), "\n")
cat("Efeito sobre quem aderiu (ITT/aumento): ", round(cace, 1), "  (verdade: 300)\n")
cat("-> O ITT é MENOR que o efeito real: a política 'diluída' pelo não-cumprimento.\n")

# -----------------------------------------------------------------------------
# PASSO 7: Problemas de campo (2): ATRITO (attrition)
# -----------------------------------------------------------------------------
# Atrito: pessoas "saem" da pesquisa (mudaram de cidade, não responderam).
# Se saem de forma ALEATÓRIA, perdemos só poder. Se saem de forma
# SISTEMÁTICA, o viés volta! Ex.: no tratamento, quem NÃO melhorou some.
perdeu <- ifelse(dados$tratamento == 1 & dados$renda_exp < quantile(dados$renda_exp, 0.25),
                 rbinom(n, 1, 0.5), 0)         # metade dos "piores" tratados somem
rest <- dados[perdeu == 0, ]
est_atrito <- mean(rest$renda_exp[rest$tratamento == 1]) - mean(rest$renda_exp[rest$tratamento == 0])
titulo("ATRITO")
cat("Perda de observações:", sum(perdeu), "(", round(100 * mean(perdeu), 1), "% da amostra )\n")
cat("Efeito estimado com atrito seletivo:", round(est_atrito, 1), "(verdade: 300) -> VIÉS\n")

# -----------------------------------------------------------------------------
# PARA EXPLORAR (mude e rode de novo)
#   - Troque o 'efeito' e o tamanho da amostra do Monte Carlo (400): o
#     experimento continua não viesado? E mais ou menos preciso?
#   - Com 100 pessoas por grupo, conseguimos detectar um efeito de R$ 100? (poder)
#   - Reduza a adesão (0.70) para 0.40: o que acontece com o ITT?
# -----------------------------------------------------------------------------
