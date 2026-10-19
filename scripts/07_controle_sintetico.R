# =============================================================================
# 07_controle_sintetico.R
# -----------------------------------------------------------------------------
# TEMA: Controle Sintético
#
# SITUAÇÃO: UM estado (o "Estado T") adotou em 2010 um programa estadual de
#   prevenção à violência (fictício). Não existe UM estado igual a ele para
#   servir de controle. A ideia: construir um "Estado T sintético" como uma
#   MÉDIA PONDERADA de estados que não adotaram o programa, com pesos escolhidos
#   para reproduzir a trajetória do Estado T ANTES de 2010.
#
#        efeito em cada ano depois de 2010 = Estado T - Estado T sintético
#
# PASSOS DESTE SCRIPT
#   1. Olhar as trajetórias (há um controle óbvio?)
#   2. Encontrar os pesos dos doadores (pré-2010)
#   3. Checar o AJUSTE no período pré-política
#   4. Medir a diferença (lacuna) depois da política
#   5. Inferência por PLACEBOS: aplicar o método a cada doador
# =============================================================================

source("scripts/00_setup.R")

dados   <- gerar_sc()        # Estado T + 19 doadores, 1995-2019; efeito verdadeiro = -5
ano_pol <- 2010
head(dados)

# Matriz com uma coluna por estado e uma linha por ano (facilita as contas)
anos <- sort(unique(dados$ano))
Y <- sapply(split(dados$taxa, dados$estado), identity)       # linhas = anos
rownames(Y) <- anos
Y <- Y[, c("Estado T", setdiff(colnames(Y), "Estado T"))]    # Estado T na 1a coluna
pre  <- anos < ano_pol
post <- anos >= ano_pol

# -----------------------------------------------------------------------------
# PASSO 1: Olhar as trajetórias
# -----------------------------------------------------------------------------
g_tr <- ggplot(dados, aes(ano, taxa, group = estado)) +
  geom_line(data = dados[dados$tratado == 0, ], colour = "grey70", linewidth = 0.6) +
  geom_line(data = dados[dados$tratado == 1, ], colour = cor_laranja, linewidth = 1.6) +
  geom_vline(xintercept = ano_pol - 0.5, linetype = "dashed") +
  labs(title = "Estado T (laranja) e 19 doadores (cinza)",
       x = NULL, y = "Homicídios por 100 mil")
print(g_tr)
salvar_fig(g_tr, "07_sc_trajetorias")

# -----------------------------------------------------------------------------
# PASSO 2: Encontrar os pesos dos doadores
# -----------------------------------------------------------------------------
# Procuramos pesos w (>= 0, somando 1) que minimizem a distância entre o Estado T
# e a combinação ponderada dos doadores NO PERÍODO PRÉ-POLÍTICA.
# Truque para impor "pesos >= 0 e soma 1" sem pacote: w = softmax(theta).
sc_pesos <- function(y_tratado_pre, Y_doadores_pre) {
  J <- ncol(Y_doadores_pre)
  perda <- function(theta) {
    w <- exp(theta) / sum(exp(theta))
    sum((y_tratado_pre - Y_doadores_pre %*% w)^2)
  }
  melhor <- NULL
  set.seed(1)
  for (s in 1:5) {                                  # vários pontos de partida
    o <- optim(rnorm(J), perda, method = "BFGS", control = list(maxit = 2000))
    if (is.null(melhor) || o$value < melhor$value) melhor <- o
  }
  w <- exp(melhor$par) / sum(exp(melhor$par))
  names(w) <- colnames(Y_doadores_pre)
  w
}

w <- sc_pesos(Y[pre, 1], Y[pre, -1])
titulo("PASSO 2: pesos dos doadores (os 5 maiores)")
print(round(sort(w, decreasing = TRUE)[1:5], 3))
cat("Soma dos pesos:", round(sum(w), 3), "\n")

# -----------------------------------------------------------------------------
# PASSO 3: Checar o ajuste ANTES da política
# -----------------------------------------------------------------------------
sintetico <- as.vector(Y[, -1] %*% w)
rmspe_pre <- sqrt(mean((Y[pre, 1] - sintetico[pre])^2))        # erro médio de ajuste (pré)
titulo("PASSO 3: ajuste pré-política")
cat("Erro de ajuste pré (RMSPE):", round(rmspe_pre, 2), "homicídios por 100 mil\n")
cat("Se o ajuste pré for ruim, o controle sintético NÃO é confiável.\n")

ajuste <- data.frame(ano = rep(anos, 2), taxa = c(Y[, 1], sintetico),
                     serie = rep(c("Estado T", "Estado T sintético"), each = length(anos)))
g_aj <- ggplot(ajuste, aes(ano, taxa, colour = serie, linetype = serie)) +
  geom_line(linewidth = 1.4) +
  geom_vline(xintercept = ano_pol - 0.5, linetype = "dashed", colour = "grey40") +
  scale_colour_manual(values = c("Estado T" = cor_laranja, "Estado T sintético" = cor_indigo), name = NULL) +
  scale_linetype_manual(values = c("Estado T" = "solid", "Estado T sintético" = "dashed"), name = NULL) +
  labs(title = "Estado T e seu controle sintético", x = NULL, y = "Homicídios por 100 mil")
print(g_aj)
salvar_fig(g_aj, "07_sc_ajuste")

# -----------------------------------------------------------------------------
# PASSO 4: A lacuna depois da política
# -----------------------------------------------------------------------------
lacuna <- Y[, 1] - sintetico
efeito_medio <- mean(lacuna[post])
titulo("PASSO 4: efeito estimado")
cat("Efeito médio 2010-2019:", round(efeito_medio, 2), "homicídios por 100 mil (verdade: -5)\n")
cat("Lacuna em 2019:", round(lacuna[length(lacuna)], 2), "\n")

# -----------------------------------------------------------------------------
# PASSO 5: Inferência por PLACEBOS (em espaço)
# -----------------------------------------------------------------------------
# Pergunta: essa lacuna é grande para um "efeito real" ou é do tamanho das que
# apareceriam por acaso? Aplicamos o MESMO método a cada doador (como se ele fosse
# o tratado, usando os outros doadores). Se o Estado T for o que mais se destaca,
# é improvável que seja acaso.
razao_rmspe <- function(i) {            # i = coluna do Y a tratar como "tratada"
  doadores <- setdiff(2:ncol(Y), i)     # nunca usa o Estado T verdadeiro como doador
  wi <- sc_pesos(Y[pre, i], Y[pre, doadores])
  sint <- as.vector(Y[, doadores] %*% wi)
  lac <- Y[, i] - sint
  c(razao = sqrt(mean(lac[post]^2)) / sqrt(mean(lac[pre]^2)), lacuna = lac)
}
# Estado T: usa todos os 19 doadores
lac_T <- lacuna
razao_T <- sqrt(mean(lac_T[post]^2)) / sqrt(mean(lac_T[pre]^2))
res_plac <- sapply(2:ncol(Y), razao_rmspe)             # (1 + n_anos) x 19
razoes <- c(razao_T, res_plac[1, ])
p_valor <- mean(razoes >= razao_T)

titulo("PASSO 5: placebos")
cat("Razão RMSPE pós/pré do Estado T:", round(razao_T, 1), "\n")
cat("Maior razão entre os 19 placebos:", round(max(res_plac[1, ]), 1), "\n")
cat("P-valor de permutação:", round(p_valor, 3), "(", sum(razoes >= razao_T), "de", length(razoes), "unidades)\n")

plac <- data.frame(ano = rep(anos, ncol(res_plac)), lacuna = as.vector(res_plac[-1, ]),
                   estado = rep(colnames(Y)[-1], each = length(anos)))
g_pl <- ggplot() +
  geom_line(data = plac, aes(ano, lacuna, group = estado), colour = "grey75") +
  geom_line(data = data.frame(ano = anos, lacuna = lacuna), aes(ano, lacuna),
            colour = cor_laranja, linewidth = 1.6) +
  geom_hline(yintercept = 0) +
  geom_vline(xintercept = ano_pol - 0.5, linetype = "dashed") +
  coord_cartesian(ylim = c(-12, 8)) +
  labs(title = "Lacuna do Estado T (laranja) x placebos (cinza)",
       x = NULL, y = "Estado - sintético")
print(g_pl)
salvar_fig(g_pl, "07_sc_placebos")

# -----------------------------------------------------------------------------
# PARA EXPLORAR (mude e rode de novo)
#   - gerar_sc(efeito = 0): a lacuna fica no meio dos placebos? Qual o p-valor?
#   - Tire os doadores com maior peso do 'Y' e refaça: o efeito muda muito?
#   - gerar_sc(n_doadores = 8): com poucos doadores, o ajuste pré piora?
# -----------------------------------------------------------------------------
