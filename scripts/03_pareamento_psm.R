# =============================================================================
# 03_pareamento_psm.R
# -----------------------------------------------------------------------------
# TEMA: Pareamento (matching) e Propensity Score Matching (PSM)
#
# SITUAÇÃO: o programa JÁ aconteceu, as pessoas se autosselecionaram e não
#           houve sorteio. Só temos dados observacionais.
#
# IDEIA: para cada participante, achar um(a) não participante PARECIDO(A) nas
#        características observáveis. A diferença entre eles, depois do
#        programa, seria o efeito. Funciona se, depois de "igualar" o que
#        observamos, só o programa distingue os grupos.
#
# OBJETIVOS DE APRENDIZAGEM
#   1. A "maldição da dimensionalidade" do pareamento exato (Figura 4);
#   2. Estimar o propensity score e checar a REGIÃO COMUM (Figura 5);
#   3. Parear por vizinho mais próximo "na unha" (sem caixa-preta);
#   4. Avaliar o BALANCEAMENTO antes e depois do pareamento;
#   5. Entender o pressuposto crítico: sem confundidores NÃO observados.
# =============================================================================

source("scripts/00_setup.R")

dados <- gerar_populacao(n = 5000, efeito = 300)
att_verdadeiro <- 300          # sabemos porque simulamos: efeito constante

# -----------------------------------------------------------------------------
# PASSO 1: Ponto de partida: a comparação ingênua (viesada)
# -----------------------------------------------------------------------------
naive <- mean(dados$renda_depois[dados$participa == 1]) -
         mean(dados$renda_depois[dados$participa == 0])
cat("Estimativa ingênua (participantes x não participantes):", round(naive, 1), "\n")

# -----------------------------------------------------------------------------
# PASSO 2: Pareamento EXATO e a "maldição da dimensionalidade"
# -----------------------------------------------------------------------------
# Pareamento exato: achar controles com EXATAMENTE as mesmas características.
# Quantos participantes têm um "gêmeo" exato entre os não participantes
# quando aumentamos o número de variáveis?
dados$renda_antes_100 <- round(dados$renda_antes / 100) * 100   # renda arredondada em centenas
dados$renda_antes_10  <- round(dados$renda_antes / 10)  * 10    # renda arredondada em dezenas

tem_gemeo <- function(vars) {
  # cria uma "chave" juntando os valores das variáveis, ex.: "1|12|35"
  chave <- do.call(paste, c(dados[vars], sep = "|"))
  chaves_ctrl <- unique(chave[dados$participa == 0])
  mean(chave[dados$participa == 1] %in% chaves_ctrl)   # % de tratados com gêmeo
}

maldicao <- data.frame(
  n_variaveis = 1:5,
  variaveis = c("mulher", "+ escolaridade", "+ idade", "+ renda
(R$ 100)", "renda mais
precisa (R$ 10)"),
  pct_com_gemeo = c(
    tem_gemeo("mulher"),
    tem_gemeo(c("mulher", "escolaridade")),
    tem_gemeo(c("mulher", "escolaridade", "idade")),
    tem_gemeo(c("mulher", "escolaridade", "idade", "renda_antes_100")),
    tem_gemeo(c("mulher", "escolaridade", "idade", "renda_antes_10")))
)
maldicao$pct_com_gemeo <- round(100 * maldicao$pct_com_gemeo, 1)
titulo("MALDIÇÃO DA DIMENSIONALIDADE: % de participantes com par EXATO")
print(maldicao, row.names = FALSE)

g_maldicao <- ggplot(maldicao, aes(factor(n_variaveis), pct_com_gemeo)) +
  geom_col(fill = cor_laranja, width = 0.65) +
  geom_text(aes(label = paste0(pct_com_gemeo, "%")), vjust = -0.5, fontface = "bold") +
  scale_x_discrete(labels = maldicao$variaveis) +
  coord_cartesian(ylim = c(0, 110)) +
  labs(title = "Maldição da dimensionalidade no pareamento exato",
       subtitle = "Cada nova variável derruba a chance de achar um 'gêmeo' exato",
       x = NULL, y = "% de participantes com par exato")
print(g_maldicao)
salvar_fig(g_maldicao, "03_maldicao")

# SOLUÇÃO (Rosenbaum e Rubin, 1983): resumir TODAS as características em UM
# número - a probabilidade de participar (propensity score) - e parear por ele.

# -----------------------------------------------------------------------------
# PASSO 3: Estimar o propensity score (regressão logística)
# -----------------------------------------------------------------------------
# Modelamos P(participa = 1 | características). Usamos só o que o avaliador
# consegue observar: escolaridade, idade, sexo e a renda ANTES do programa.
modelo_ps <- glm(participa ~ escolaridade + idade + mulher + renda_antes,
                 data = dados, family = binomial)
summary(modelo_ps)$coefficients

dados$ps  <- predict(modelo_ps, type = "response")   # probabilidade prevista (0 a 1)
dados$lps <- qlogis(dados$ps)                         # mesma info, em escala logit (melhor p/ parear)

# -----------------------------------------------------------------------------
# PASSO 4: REGIÃO COMUM (suporte comum)
# -----------------------------------------------------------------------------
# Só dá para comparar quem tem "semelhantes" do outro grupo.
limite_inf <- max(min(dados$ps[dados$participa == 1]), min(dados$ps[dados$participa == 0]))
limite_sup <- min(max(dados$ps[dados$participa == 1]), max(dados$ps[dados$participa == 0]))
cat("\nRegião comum do propensity score: de", round(limite_inf, 3), "a", round(limite_sup, 3), "\n")

g_overlap <- ggplot(dados, aes(ps, fill = factor(participa, labels = c("Controle (não participa)", "Tratamento (participa)")))) +
  geom_density(alpha = 0.55, colour = NA) +
  annotate("rect", xmin = limite_inf, xmax = limite_sup, ymin = -Inf, ymax = Inf,
           alpha = 0.08, fill = cor_verde) +
  scale_fill_manual(values = c(cor_indigo, cor_laranja), name = NULL) +
  labs(title = "Propensity score e região comum",
       subtitle = "A faixa verde indica onde há controles comparáveis aos tratados",
       x = "Propensity score (probabilidade de participar)", y = "Densidade")
print(g_overlap)
salvar_fig(g_overlap, "03_regiao_comum")

# -----------------------------------------------------------------------------
# PASSO 5: Parear "na unha": vizinho mais próximo com caliper
# -----------------------------------------------------------------------------
# Para cada participante: achamos o NÃO participante com propensity score mais
# próximo. O "caliper" descarta pares muito distantes (evita mau pareamento).
# Aqui o pareamento é COM reposição (um controle pode servir a vários tratados).
tratados  <- which(dados$participa == 1)     # posições (linhas) dos tratados
controles <- which(dados$participa == 0)     # posições dos controles
caliper   <- 0.2 * sd(dados$lps)             # regra prática: 0,2 desvio-padrão do logit

par_controle <- rep(NA_integer_, length(tratados))   # guardará o controle de cada tratado
for (k in seq_along(tratados)) {
  distancia <- abs(dados$lps[controles] - dados$lps[tratados[k]])  # distância a TODOS os controles
  melhor    <- which.min(distancia)                                  # o mais próximo
  if (distancia[melhor] <= caliper) par_controle[k] <- controles[melhor]  # só aceita se dentro do caliper
}

pareados <- !is.na(par_controle)
cat("Tratados:", length(tratados), "| pareados:", sum(pareados),
    "| descartados (sem par):", sum(!pareados), "\n")

# Efeito sobre os tratados (ATT): média das diferenças dentro dos pares
dif_pares <- dados$renda_depois[tratados[pareados]] - dados$renda_depois[par_controle[pareados]]
att_psm <- mean(dif_pares)
cat("ATT estimado por PSM:", round(att_psm, 1), "| verdade:", att_verdadeiro, "\n")

# -----------------------------------------------------------------------------
# PASSO 6: BALANCEAMENTO: o pareamento "igualou" os grupos?
# -----------------------------------------------------------------------------
# Peso de cada controle = quantas vezes foi usado como par.
peso <- rep(0, nrow(dados))
peso[tratados[pareados]] <- 1
contagem <- table(par_controle[pareados])
peso[as.integer(names(contagem))] <- as.numeric(contagem)
amostra_pareada <- peso > 0           # linhas que entram na amostra pareada

vars_bal <- c("escolaridade", "idade", "mulher", "renda_antes", "motivacao")
balanco_psm <- data.frame(
  variavel = vars_bal,
  antes  = sapply(vars_bal, function(v) smd(dados[[v]], dados$participa)),
  depois = sapply(vars_bal, function(v)
    smd(dados[[v]][amostra_pareada], dados$participa[amostra_pareada], peso[amostra_pareada]))
)
titulo("BALANCEAMENTO (SMD): antes x depois do pareamento")
balanco_psm[, 2:3] <- round(balanco_psm[, 2:3], 3)
print(balanco_psm, row.names = FALSE)
cat("Atenção: 'motivacao' NÃO entrou no modelo (não é observada na vida real),\n",
    "mas ficou melhor balanceada porque a renda_antes carrega parte dela.\n")

love <- rbind(
  data.frame(variavel = vars_bal, smd = balanco_psm$antes,  momento = "Antes do pareamento"),
  data.frame(variavel = vars_bal, smd = balanco_psm$depois, momento = "Depois do pareamento")
)
love$momento <- factor(love$momento, levels = c("Antes do pareamento", "Depois do pareamento"))
g_love <- ggplot(love, aes(smd, variavel, colour = momento)) +
  geom_vline(xintercept = c(-0.1, 0.1), linetype = "dashed", colour = "grey60") +
  geom_vline(xintercept = 0, colour = "grey40") +
  geom_point(size = 4) +
  scale_colour_manual(values = c(cor_indigo, cor_laranja), name = NULL) +
  labs(title = "Balanceamento das covariáveis (love plot)",
       subtitle = "Pontos dentro das linhas tracejadas (|SMD| < 0,10) indicam grupos comparáveis",
       x = "Diferença padronizada de médias (SMD)", y = NULL)
print(g_love)
salvar_fig(g_love, "03_love_plot")

# -----------------------------------------------------------------------------
# PASSO 7: Empacotar numa FUNÇÃO e calcular incerteza (bootstrap)
# -----------------------------------------------------------------------------
# Repetimos os passos 3 e 5 dentro de uma função, para poder (a) trocar as
# variáveis do modelo e (b) reamostrar os dados (bootstrap) para obter o
# erro-padrão do estimador.
psm_att <- function(df, formula_ps, caliper_dp = 0.2) {
  m   <- glm(formula_ps, data = df, family = binomial)       # propensity score
  lps <- qlogis(predict(m, type = "response"))
  tr  <- which(df$participa == 1)
  ct  <- which(df$participa == 0)
  cal <- caliper_dp * sd(lps)
  par <- rep(NA_integer_, length(tr))
  for (k in seq_along(tr)) {
    d <- abs(lps[ct] - lps[tr[k]])
    j <- which.min(d)
    if (d[j] <= cal) par[k] <- ct[j]
  }
  ok <- !is.na(par)
  mean(df$renda_depois[tr[ok]] - df$renda_depois[par[ok]])
}

f_completa <- participa ~ escolaridade + idade + mulher + renda_antes
f_sem_baseline <- participa ~ escolaridade + idade + mulher     # SEM a renda antes

att_a <- psm_att(dados, f_completa)
att_b <- psm_att(dados, f_sem_baseline)

# Bootstrap: reamostrar as linhas COM reposição 100 vezes e refazer tudo.
set.seed(1)
B <- 100        # aumente para 500 se quiser (demora mais)
boot_a <- replicate(B, psm_att(dados[sample(nrow(dados), replace = TRUE), ], f_completa))
cat("\nPSM (modelo completo): ATT =", round(att_a, 1),
    "| erro-padrão bootstrap =", round(sd(boot_a), 1), "\n")
cat("IC 95% aproximado: [", round(att_a - 1.96 * sd(boot_a)), ",",
    round(att_a + 1.96 * sd(boot_a)), "]\n")

# -----------------------------------------------------------------------------
# PASSO 8: O PRESSUPOSTO CRÍTICO: confundidores NÃO observados
# -----------------------------------------------------------------------------
# O PSM só "iguala" o que está no modelo. Se algo que afeta a renda e a
# participação NÃO é observado (aqui, a motivação), o viés permanece.
# Teste 1: tirar a renda_antes (que era um "proxy" da motivação).
# Teste 2: mundo em que a motivação NÃO afeta a participação (forca_motivacao = 0):
#          então tudo que importa é observável e o PSM deve acertar.
dados_sem_vies <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = 0)
att_c <- psm_att(dados_sem_vies, f_sem_baseline)

# Regressão com controles (alternativa comum): lm com covariáveis
reg <- coef(lm(renda_depois ~ participa + escolaridade + idade + mulher + renda_antes,
               data = dados))["participa"]

resumo <- data.frame(
  Metodo = c("Verdade",
             "Comparação ingênua",
             "Regressão com controles",
             "PSM com renda antes",
             "PSM sem renda antes
(motivação omitida)",
             "PSM sem renda antes,
motivação irrelevante"),
  Estimativa = round(c(att_verdadeiro, naive, reg, att_a, att_b, att_c), 1)
)
resumo$Erro <- round(resumo$Estimativa - att_verdadeiro, 1)
titulo("RESUMO: quão perto da verdade (R$ 300) cada método chegou?")
print(resumo, row.names = FALSE)

g_resumo <- ggplot(resumo, aes(Estimativa, reorder(Metodo, Estimativa))) +
  geom_vline(xintercept = att_verdadeiro, colour = cor_verde, linewidth = 1.3) +
  geom_point(size = 4.5, colour = cor_laranja) +
  geom_text(aes(label = round(Estimativa)), nudge_x = 18, hjust = 0, size = 4.6) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.15))) +
  labs(title = "PSM funciona... quando o que importa é observável",
       subtitle = "Linha verde = verdade (R$ 300)", x = "Impacto estimado (R$/mês)", y = NULL)
print(g_resumo)
salvar_fig(g_resumo, "03_resumo", largura = 6, altura = 3.6)

# -----------------------------------------------------------------------------
# PASSO 9 (OPCIONAL): A versão "profissional": pacote MatchIt
# -----------------------------------------------------------------------------
# Se o MatchIt estiver instalado (install.packages("MatchIt")), ele faz tudo
# acima em poucas linhas, com diagnósticos prontos.
if (tem_pacote("MatchIt")) {
  library(MatchIt)
  m_out <- matchit(participa ~ escolaridade + idade + mulher + renda_antes,
                   data = dados, method = "nearest", distance = "glm",
                   link = "logit", caliper = 0.2, replace = TRUE)
  print(summary(m_out)$nn)
  dados_match <- match.data(m_out)
  att_matchit <- coef(lm(renda_depois ~ participa, data = dados_match, weights = weights))["participa"]
  cat("ATT via MatchIt:", round(att_matchit, 1), "\n")
} else {
  message("MatchIt não instalado: tudo bem! O pareamento 'na unha' acima faz o mesmo.")
}

# -----------------------------------------------------------------------------
# DISCUSSÃO: CRÍTICAS AO PSM
#   King e Nielsen (2016): parear pelo propensity score pode AUMENTAR o
#   desbalanceamento; alternativas: Coarsened Exact Matching (CEM).
#   Sempre: (1) mostre o balanceamento; (2) discuta o que NÃO foi observado.
# -----------------------------------------------------------------------------
#
# PARA EXPLORAR (mude e rode de novo)
#   - Troque o caliper (0.2) por 0.01 e por 1: quantos tratados ficam sem par?
#   - Retire 'idade' ou 'escolaridade' do modelo do propensity score.
#   - Aumente 'forca_motivacao' em gerar_populacao(): o viés do PSM sem a renda antes cresce?
# -----------------------------------------------------------------------------
