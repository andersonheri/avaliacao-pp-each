# =============================================================================
# 05_regressao_descontinua.R
# -----------------------------------------------------------------------------
# TEMA: Regressão Descontínua (RDD - Regression Discontinuity Design)
#       (Batista e Domingos, 2017, pp. 12-13; Figura 7)
#
# IDEIA: muitos programas têm uma REGRA DE ELEGIBILIDADE com ponto de corte
#        (cutoff). Ex.: recebe a transferência de renda quem tem renda per
#        capita ATÉ R$ 77. Quem está logo abaixo (R$ 76) e logo acima (R$ 78)
#        do corte é praticamente igual - mas só um deles recebe o programa.
#        Perto do corte, é como se houvesse um "sorteio natural".
#        O IMPACTO é o tamanho do "salto" (descontinuidade) no corte.
#
# PRÉ-REQUISITOS (artigo): (1) índice de elegibilidade CONTÍNUO;
#                          (2) valor de corte CLARAMENTE definido.
# LIMITAÇÕES: (1) efeito LOCAL (só vale perto do corte);
#             (2) precisa de MUITAS observações perto do corte.
#
# OBJETIVOS DE APRENDIZAGEM
#   1. Visualizar a descontinuidade (Figura 7);
#   2. Estimar o salto com regressão linear LOCAL;
#   3. Entender a escolha da JANELA (bandwidth): viés x variância;
#   4. Fazer testes de validade: balanceamento, placebo e manipulação.
# =============================================================================

source("scripts/00_setup.R")

# -----------------------------------------------------------------------------
# PASSO 1 — O mundo simulado: transferência de renda e frequência escolar
# -----------------------------------------------------------------------------
# Programa fictício inspirado no PTCR da Figura 7 e em Buddelmeyer e Skoufias
# (2004), citado no artigo. Elegível: renda per capita da família <= R$ 77.
# Resultado: % de dias de aula frequentados pelas crianças da família.
# EFEITO VERDADEIRO do programa: +6 pontos percentuais.
# (a função gerar_rdd() está em scripts/funcoes_dgp.R - vale a pena ler!)
d <- gerar_rdd()
corte <- 77
head(d)
cat("\nElegíveis:", sum(d$elegivel), "| Não elegíveis:", sum(d$elegivel == 0), "\n")

# -----------------------------------------------------------------------------
# PASSO 2 — Visualizar a descontinuidade
# -----------------------------------------------------------------------------
# Média da frequência em faixas de R$ 4 de renda ("binned means") + o corte.
d$faixa <- floor(d$renda / 4) * 4 + 2                       # centro de cada faixa
medias_faixa <- aggregate(freq ~ faixa + elegivel, data = d, FUN = mean)
medias_faixa$n <- aggregate(freq ~ faixa + elegivel, data = d, FUN = length)$freq
medias_faixa <- medias_faixa[medias_faixa$n >= 10, ]

g_rdd <- ggplot() +
  geom_point(data = d, aes(renda, freq, colour = factor(elegivel)), alpha = 0.12, size = 1.2) +
  geom_point(data = medias_faixa, aes(faixa, freq, colour = factor(elegivel)), size = 3.2) +
  geom_vline(xintercept = corte, linetype = "dashed", linewidth = 1) +
  annotate("text", x = corte + 1.5, y = 40, label = "Corte: R$ 77", hjust = 0, fontface = "bold") +
  scale_colour_manual(values = c("0" = cor_indigo, "1" = cor_laranja),
                      labels = c("Não elegível", "Elegível (recebe)"), name = NULL) +
  coord_cartesian(xlim = c(20, 150), ylim = c(35, 100)) +
  labs(title = "Descontinuidade no corte de elegibilidade",
       subtitle = "Pontos grandes = médias por faixa de renda; pontos claros = famílias",
       x = "Renda per capita da família (R$)", y = "Frequência escolar (%)")
print(g_rdd)
salvar_fig(g_rdd, "05_rdd_dispersao")

# -----------------------------------------------------------------------------
# PASSO 3 — Estimativas ingênuas (e por que erram)
# -----------------------------------------------------------------------------
naive <- mean(d$freq[d$elegivel == 1]) - mean(d$freq[d$elegivel == 0])
cat("\nElegíveis x não elegíveis (comparação simples):", round(naive, 1), "p.p. | verdade: +6\n")
# Subestima bastante: os elegíveis são mais POBRES, e pobreza reduz a frequência,
# então parte do ganho do programa é "engolida" pela diferença de renda entre os grupos.

# Regressão GLOBAL (usa todos os dados) com uma reta em cada lado do corte:
reg_global <- lm(freq ~ elegivel * x, data = d)
cat("Regressão global linear:                    ", round(coef(reg_global)["elegivel"], 1), "p.p.\n")
# Se a relação é CURVA, uma reta em todos os dados erra o salto no corte.
reg_quad <- lm(freq ~ elegivel * (x + I(x^2)), data = d)
cat("Regressão global quadrática:                ", round(coef(reg_quad)["elegivel"], 1), "p.p.\n")

# -----------------------------------------------------------------------------
# PASSO 4 — Regressão LOCAL: só usamos quem está perto do corte (janela h)
# -----------------------------------------------------------------------------
# Para uma janela de largura h (em R$), usamos apenas famílias com |renda - 77| <= h
# e ajustamos retas diferentes dos dois lados. O coeficiente de 'elegivel' é o
# SALTO no corte = efeito do programa para quem está no corte.
rdd_local <- function(dados, h, triangular = FALSE) {
  janela <- dados[abs(dados$x) <= h, ]
  pesos  <- if (triangular) 1 - abs(janela$x) / h else rep(1, nrow(janela))   # mais peso a quem está perto
  m <- lm(freq ~ elegivel * x, data = janela, weights = pesos)
  tab <- summary(m)$coefficients
  data.frame(h = h, efeito = tab["elegivel", 1], ep = tab["elegivel", 2], n = nrow(janela))
}

principal <- rdd_local(d, h = 15)
titulo("RDD local (janela de ±R$ 15)")
cat("Efeito estimado:", round(principal$efeito, 2), "p.p. (EP =", round(principal$ep, 2),
    ") com", principal$n, "famílias | verdade: 6\n")

# Gráfico: retas locais de cada lado dentro da janela
janela15 <- d[abs(d$x) <= 15, ]
g_local <- ggplot(janela15, aes(renda, freq, colour = factor(elegivel))) +
  geom_point(alpha = 0.35, size = 1.6) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 1.6) +
  geom_vline(xintercept = corte, linetype = "dashed") +
  scale_colour_manual(values = c("0" = cor_indigo, "1" = cor_laranja),
                      labels = c("Não elegível", "Elegível (recebe)"), name = NULL) +
  labs(title = "RDD: retas locais de cada lado do corte",
       subtitle = paste0("O salto vertical no corte é o impacto: ", round(principal$efeito, 1), " p.p."),
       x = "Renda per capita (R$)", y = "Frequência escolar (%)")
print(g_local)
salvar_fig(g_local, "05_rdd_local")

# -----------------------------------------------------------------------------
# PASSO 5 — Sensibilidade à janela (bandwidth): o dilema viés x variância
# -----------------------------------------------------------------------------
# Janela ESTREITA: observações mais comparáveis (menos viés), mas poucas (mais ruído).
# Janela LARGA: mais observações (menos ruído), mas menos comparáveis (mais viés).
# Boa prática: mostrar que o resultado NÃO depende muito da janela escolhida.
janelas <- c(3, 5, 8, 12, 15, 20, 30, 40)
sens <- do.call(rbind, lapply(janelas, function(h) rdd_local(d, h)))
sens$li <- sens$efeito - 1.96 * sens$ep
sens$ls <- sens$efeito + 1.96 * sens$ep
titulo("Sensibilidade à janela")
print(round(sens, 2), row.names = FALSE)

g_sens <- ggplot(sens, aes(factor(h), efeito)) +
  geom_hline(yintercept = 6, colour = cor_verde, linewidth = 1.2) +
  geom_pointrange(aes(ymin = li, ymax = ls), colour = cor_laranja, linewidth = 0.9, size = 0.8) +
  labs(title = "Sensibilidade do efeito à janela (bandwidth)",
       subtitle = "Linha verde = verdade (6 p.p.). Janelas estreitas: intervalos largos; janelas largas: viés.",
       x = "Janela: ± R$ em torno do corte", y = "Efeito estimado (p.p.)")
print(g_sens)
salvar_fig(g_sens, "05_rdd_janelas")

# -----------------------------------------------------------------------------
# PASSO 6 — Testes de VALIDADE do desenho
# -----------------------------------------------------------------------------
# (a) COVARIÁVEL pré-tratamento não deve "pular" no corte (balanceamento local).
#     Usamos a idade da mãe como "resultado": o salto deve ser ~0.
d$freq_original <- d$freq
d$freq <- d$idade_mae
teste_cov <- rdd_local(d, h = 15)
d$freq <- d$freq_original
cat("\n(a) Salto na idade da mãe no corte (esperado ~0):", round(teste_cov$efeito, 2),
    "(EP =", round(teste_cov$ep, 2), ")\n")

# (b) PLACEBO: cortes FALSOS onde não há política. Usamos só dados de um lado
#     do corte verdadeiro, para não contaminar. O salto deve ser ~0.
placebo <- function(corte_falso) {
  lado <- if (corte_falso < corte) d[d$x < 0, ] else d[d$x >= 0, ]
  lado$x <- lado$renda - corte_falso
  lado$elegivel <- as.integer(lado$renda <= corte_falso)
  rdd_local(lado, h = 15)$efeito
}
cat("(b) Efeito em cortes falsos (esperado ~0): R$ 55 ->", round(placebo(55), 2),
    "| R$ 65 ->", round(placebo(65), 2),
    "| R$ 105 ->", round(placebo(105), 2), "\n")
# (para o corte 105 usamos só quem está acima de 77, onde ninguém é elegível)

# (c) MANIPULAÇÃO da variável de corte: as famílias conseguem "ajustar" a renda
#     declarada para entrar no programa? Se sim, haverá um "acúmulo" logo
#     abaixo do corte e o RDD perde a validade.
d_manip <- gerar_rdd(manipulacao = TRUE)
densidade <- rbind(data.frame(renda = d$renda, cenario = "Sem manipulação (válido)"),
                   data.frame(renda = d_manip$renda, cenario = "Com manipulação (inválido)"))
g_manip <- ggplot(densidade[densidade$renda > 50 & densidade$renda < 110, ], aes(renda)) +
  geom_histogram(binwidth = 2, fill = cor_cinza, colour = "white") +
  geom_vline(xintercept = corte, linetype = "dashed", colour = cor_laranja, linewidth = 1.1) +
  facet_wrap(~cenario) +
  labs(title = "Teste de manipulação: a densidade 'salta' no corte?",
       subtitle = "À direita, famílias deslocaram a renda declarada para logo abaixo de R$ 77",
       x = "Renda per capita (R$)", y = "Nº de famílias")
print(g_manip)
salvar_fig(g_manip, "05_rdd_manipulacao", largura = 10)

# -----------------------------------------------------------------------------
# PASSO 7 — RDD "fuzzy" (aderência imperfeita) - apenas a ideia
# -----------------------------------------------------------------------------
# Se nem todos os elegíveis recebem (ou alguns inelegíveis recebem), o corte não
# determina totalmente o tratamento. Estimamos (salto no resultado) / (salto na
# participação) = efeito sobre quem "obedece" ao corte. Exemplo rápido:
d_f <- gerar_rdd(n = 20000, aderencia = 0.8, semente = 11)   # base maior: 80% dos elegíveis recebem
j <- d_f[abs(d_f$x) <= 15, ]
salto_resultado <- coef(lm(freq   ~ elegivel * x, data = j))["elegivel"]   # salto na frequência
salto_particip  <- coef(lm(recebe ~ elegivel * x, data = j))["elegivel"]   # salto na participação
cat("
Fuzzy RDD: salto no resultado =", round(salto_resultado, 2),
    "| salto na participação =", round(salto_particip, 2),
    "| efeito = razão =", round(salto_resultado / salto_particip, 2), "(verdade: 6)
")

# -----------------------------------------------------------------------------
# PASSO 8 (OPCIONAL) — A versão "profissional": pacote rdrobust
# -----------------------------------------------------------------------------
# rdrobust escolhe a janela ótima automaticamente e calcula erros-padrão robustos.
if (tem_pacote("rdrobust")) {
  library(rdrobust)
  resultado <- rdrobust(y = d$freq, x = d$renda, c = corte)
  summary(resultado)
} else {
  message("rdrobust não instalado (install.packages('rdrobust')). Tudo bem: a regressão local acima faz o essencial.")
}

# -----------------------------------------------------------------------------
# RESUMO PARA DISCUSSÃO
#   - Por que o RDD é "quase um experimento" perto do corte?
#   - A que população o resultado se aplica? (Efeito LOCAL: famílias com renda
#     ~R$ 77. Vale para quem ganha R$ 30? Não necessariamente.)
#   - Em que situações reais as pessoas poderiam manipular o corte?
# -----------------------------------------------------------------------------
