# =============================================================================
# funcoes_metodos.R  |  Versões "prontas para usar" dos estimadores
# -----------------------------------------------------------------------------
# Nos scripts 03 e 05 construímos o pareamento e a regressão local PASSO A PASSO.
# Aqui estão as mesmas ideias empacotadas em funções, para vocês as reutilizarem
# nas ATIVIDADES sem repetir dezenas de linhas. (Carregado por 00_setup.R.)
# =============================================================================

# -----------------------------------------------------------------------------
# psm_att(): Propensity Score Matching - vizinho mais próximo, com reposição
#   df         : data.frame com as colunas 'participa' (0/1) e 'renda_depois'
#   formula_ps : fórmula do propensity score, ex.: participa ~ idade + escolaridade
#   caliper_dp : caliper em desvios-padrão do logit do PS (menor = pares mais próximos)
# Devolve uma lista: att (efeito), n_tratados, n_pareados
# -----------------------------------------------------------------------------
psm_att <- function(df, formula_ps, caliper_dp = 0.2) {
  m   <- glm(formula_ps, data = df, family = binomial)      # 1) estima o propensity score
  lps <- qlogis(predict(m, type = "response"))              #    (em escala logit)
  tr  <- which(df$participa == 1)                           # 2) posições dos tratados
  ct  <- which(df$participa == 0)                           #    e dos controles
  cal <- caliper_dp * sd(lps)                               # 3) tamanho do caliper
  par <- rep(NA_integer_, length(tr))
  for (k in seq_along(tr)) {                                # 4) para cada tratado...
    d <- abs(lps[ct] - lps[tr[k]])                          #    distância a todos os controles
    j <- which.min(d)                                       #    o mais próximo
    if (d[j] <= cal) par[k] <- ct[j]                        #    só vale se estiver dentro do caliper
  }
  ok <- !is.na(par)
  list(att = mean(df$renda_depois[tr[ok]] - df$renda_depois[par[ok]]),   # 5) média das diferenças nos pares
       n_tratados = length(tr), n_pareados = sum(ok))
}

# -----------------------------------------------------------------------------
# rdd_local(): regressão descontínua LOCAL (retas diferentes dos dois lados do corte)
#   dados      : data.frame com 'x' (variável de corte centrada), 'elegivel' e o resultado
#   h          : janela (± h em torno do corte)
#   y          : nome da coluna do resultado (padrão: "freq")
#   triangular : TRUE dá mais peso a quem está mais perto do corte
# -----------------------------------------------------------------------------
rdd_local <- function(dados, h, y = "freq", triangular = FALSE) {
  janela <- dados[abs(dados$x) <= h, ]
  pesos  <- if (triangular) 1 - abs(janela$x) / h else rep(1, nrow(janela))
  janela$y_ <- janela[[y]]
  m   <- lm(y_ ~ elegivel * x, data = janela, weights = pesos)
  tab <- summary(m)$coefficients
  data.frame(h = h, efeito = tab["elegivel", 1], ep = tab["elegivel", 2], n = nrow(janela))
}
