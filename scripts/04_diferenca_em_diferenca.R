# =============================================================================
# 04_diferenca_em_diferenca.R
# -----------------------------------------------------------------------------
# TEMA: Diferença-em-Diferenças (DiD / DD)
#
# IDEIA: comparar a MUDANÇA (depois - antes) do grupo tratado com a MUDANÇA do
#        grupo de controle. A segunda mudança é o "contrafactual" da tendência:
#        o que teria acontecido ao tratado sem a política.
#
#            DD = (Y_trat,depois - Y_trat,antes) - (Y_ctrl,depois - Y_ctrl,antes)
#
# VANTAGEM: elimina diferenças FIXAS entre os grupos, mesmo não observadas
#           (ex.: um grupo é estruturalmente mais pobre).
# PRESSUPOSTO CRÍTICO: TENDÊNCIAS PARALELAS - sem a política, os dois grupos
#           teriam evoluído de forma paralela.
#
# OBJETIVOS DE APRENDIZAGEM
#   1. Reproduzir à mão um exemplo clássico (DD = 15);
#   2. Ver por que os dois "falsos contrafactuais" erram e o DD acerta;
#   3. Estimar o DD por regressão (coeficiente da interação);
#   4. Checar tendências paralelas (estudo de eventos e placebo);
#   5. Ver o que acontece quando o pressuposto é VIOLADO.
# =============================================================================

source("scripts/00_setup.R")

# -----------------------------------------------------------------------------
# PARTE A: um exemplo clássico, "na calculadora"
# -----------------------------------------------------------------------------
# Renda de participantes e não participantes, antes e depois da intervenção
# (adaptado de Khandker, Koolwal e Samad, 2010):
renda_part_antes   <- 80
renda_part_depois  <- 125
renda_nao_antes    <- 90
renda_nao_depois   <- 120

# Falso contrafactual 1: ANTES x DEPOIS (só participantes)
antes_depois <- renda_part_depois - renda_part_antes
# Falso contrafactual 2: PARTICIPANTES x NÃO PARTICIPANTES (só depois)
part_vs_nao  <- renda_part_depois - renda_nao_depois
# Diferença-em-diferenças
mudanca_part <- renda_part_depois - renda_part_antes     # 45
mudanca_nao  <- renda_nao_depois  - renda_nao_antes      # 30  <- a "tendência"
dd           <- mudanca_part - mudanca_nao               # 15

titulo("PARTE A: exemplo clássico (Khandker, Koolwal e Samad, 2010)")
cat("Antes x depois:            ", antes_depois, " (superestima)\n")
cat("Participantes x não part.: ", part_vs_nao,  " (subestima)\n")
cat("Diferença-em-diferenças:   ", dd, "\n")

fig6 <- data.frame(
  momento = factor(rep(c("Antes", "Depois"), 2), levels = c("Antes", "Depois")),
  grupo   = rep(c("Participantes", "Não participantes"), each = 2),
  renda   = c(renda_part_antes, renda_part_depois, renda_nao_antes, renda_nao_depois)
)
# Contrafactual do tratado: parte do nível inicial dele e segue a MUDANÇA do controle
contra <- data.frame(momento = factor(c("Antes", "Depois"), levels = c("Antes", "Depois")),
                     renda = c(renda_part_antes, renda_part_antes + mudanca_nao))
g_fig6 <- ggplot(fig6, aes(momento, renda, colour = grupo, group = grupo)) +
  geom_line(linewidth = 1.5) + geom_point(size = 4) +
  geom_line(data = contra, aes(momento, renda, group = 1), inherit.aes = FALSE,
            colour = cor_laranja, linetype = "dashed", linewidth = 1.2) +
  annotate("segment", x = 2.05, xend = 2.05, y = renda_part_antes + mudanca_nao, yend = renda_part_depois,
           colour = cor_verde, linewidth = 1.3, arrow = arrow(ends = "both", length = unit(0.12, "in"))) +
  annotate("text", x = 2.1, y = (renda_part_antes + mudanca_nao + renda_part_depois) / 2,
           label = paste0("DD = ", dd), colour = cor_verde, hjust = 0, fontface = "bold", size = 5.5) +
  scale_colour_manual(values = c("Participantes" = cor_laranja, "Não participantes" = cor_indigo), name = NULL) +
  scale_x_discrete(expand = expansion(add = c(0.3, 0.7))) +
  labs(title = "Diferença-em-diferenças: um exemplo clássico",
       subtitle = "Tracejado = contrafactual dos participantes (segue a tendência dos não participantes)",
       x = NULL, y = "Renda")
print(g_fig6)
salvar_fig(g_fig6, "04_figura6")

# -----------------------------------------------------------------------------
# PARTE B: Simulação em PAINEL: o mesmo mundo do "Qualifica", agora com
#           acompanhamento ao longo de 6 trimestres
# -----------------------------------------------------------------------------
# - 1.000 trabalhadores observados em 6 trimestres;
# - 400 vivem na região onde o programa foi implementado (tratados);
# - o programa começa no trimestre 4;
# - os tratados são estruturalmente MAIS POBRES (efeito fixo do grupo): se
#   comparássemos níveis, erraríamos feio. O DD "cancela" essa diferença fixa.
# (a função gerar_painel() está em scripts/funcoes_dgp.R - vale a pena ler!)
painel <- gerar_painel()          # tendências paralelas VALEM
head(painel)

# Médias por grupo e trimestre
medias <- aggregate(renda ~ trimestre + tratado, data = painel, FUN = mean)
medias$grupo <- ifelse(medias$tratado == 1, "Tratados (região do programa)", "Controle")

# Gráfico de tendências: antes do trimestre 4 as linhas devem ser PARALELAS
g_tend <- ggplot(medias, aes(trimestre, renda, colour = grupo)) +
  geom_vline(xintercept = 3.5, linetype = "dashed", colour = "grey50") +
  annotate("text", x = 3.55, y = min(medias$renda), label = "Início do programa",
           hjust = 0, colour = "grey30", size = 4.5) +
  geom_line(linewidth = 1.5) + geom_point(size = 3.5) +
  scale_colour_manual(values = c("Tratados (região do programa)" = cor_laranja, "Controle" = cor_indigo), name = NULL) +
  scale_x_continuous(breaks = 1:6) +
  labs(title = "Tendências paralelas antes da política",
       subtitle = "Os tratados partem de um nível menor, mas evoluem em paralelo até o programa",
       x = "Trimestre", y = "Renda média (R$)")
print(g_tend)
salvar_fig(g_tend, "04_tendencias")

# --- B1. DD "na mão": quatro médias --------------------------------------------
m <- function(trat, pos) mean(painel$renda[painel$tratado == trat & painel$pos == pos])
dd_mao <- (m(1, 1) - m(1, 0)) - (m(0, 1) - m(0, 0))

titulo("PARTE B: estimativas do impacto (verdade = R$ 300)")
cat("1) Antes x depois (só tratados):      ", round(m(1, 1) - m(1, 0), 1), "\n")
cat("2) Tratados x controle (só depois):   ", round(m(1, 1) - m(0, 1), 1), "\n")
cat("3) Diferença-em-diferenças (na mão):  ", round(dd_mao, 1), "\n")

# --- B2. DD por REGRESSÃO ---------------------------------------------------------
# renda = b0 + b1*tratado + b2*pos + b3*(tratado x pos) + erro
#   b1: diferença fixa de nível entre os grupos
#   b2: tendência comum (efeito do tempo)
#   b3: INTERAÇÃO = o efeito da política (o DD!)
reg_dd <- lm(renda ~ tratado * pos, data = painel)
print(round(summary(reg_dd)$coefficients, 2))
cat("-> O coeficiente 'tratado:pos' é o DD:", round(coef(reg_dd)["tratado:pos"], 1), "\n")

# Em dados reais, os erros de uma mesma unidade se repetem no tempo. Por isso,
# usa-se erro-padrão AGRUPADO (cluster) por unidade. Com o pacote fixest:
if (tem_pacote("fixest")) {
  library(fixest)
  reg_fe <- feols(renda ~ tratado:pos | id + trimestre, data = painel, cluster = ~id)
  print(reg_fe)    # efeitos fixos de unidade e de tempo + erro-padrão por cluster
}

# -----------------------------------------------------------------------------
# PARTE C: Testando o pressuposto: ESTUDO DE EVENTOS e PLACEBO
# -----------------------------------------------------------------------------
# Estimamos o efeito em CADA trimestre em relação ao trimestre 3 (o último
# antes da política). Se as tendências são paralelas, os coeficientes ANTES do
# programa devem ficar perto de zero.
painel$trim_f <- relevel(factor(painel$trimestre), ref = "3")
reg_ev <- lm(renda ~ tratado * trim_f, data = painel)
coefs <- summary(reg_ev)$coefficients
interacoes <- coefs[grep("^tratado:trim_f", rownames(coefs)), ]
es <- data.frame(
  trimestre = as.integer(sub("tratado:trim_f", "", rownames(interacoes))),
  efeito = interacoes[, 1], ep = interacoes[, 2]
)
es <- rbind(es, data.frame(trimestre = 3, efeito = 0, ep = 0))   # referência
es <- es[order(es$trimestre), ]
es$li <- es$efeito - 1.96 * es$ep
es$ls <- es$efeito + 1.96 * es$ep

g_es <- ggplot(es, aes(trimestre, efeito)) +
  geom_hline(yintercept = 0, colour = "grey40") +
  geom_vline(xintercept = 3.5, linetype = "dashed", colour = "grey50") +
  geom_pointrange(aes(ymin = li, ymax = ls), colour = cor_laranja, linewidth = 0.9, size = 0.8) +
  scale_x_continuous(breaks = 1:6) +
  labs(title = "Estudo de eventos: efeito por trimestre (ref. = trimestre 3)",
       subtitle = "Antes do programa: zero (tendências paralelas). Depois: ~R$ 300",
       x = "Trimestre", y = "Efeito estimado (R$)")
print(g_es)
salvar_fig(g_es, "04_estudo_eventos")

# Teste placebo: finge que o programa começou no trimestre 2, USANDO SÓ os
# dados de antes do programa real. Se o DD "placebo" der ~0, bom sinal.
pre <- painel[painel$trimestre <= 3, ]
pre$pos_falso <- as.integer(pre$trimestre >= 2)
placebo <- coef(lm(renda ~ tratado * pos_falso, data = pre))["tratado:pos_falso"]
cat("\nDD placebo (deve ser ~0):", round(placebo, 1), "\n")

# -----------------------------------------------------------------------------
# PARTE D: Quando as tendências NÃO são paralelas
# -----------------------------------------------------------------------------
# Imagine que os tratados já vinham crescendo mais rápido (+R$ 40 extra por
# trimestre), com ou sem política. O DD atribuirá esse crescimento extra ao programa.
painel_ruim <- gerar_painel(extra_tendencia_trat = 40)
mr <- function(trat, pos) mean(painel_ruim$renda[painel_ruim$tratado == trat & painel_ruim$pos == pos])
dd_ruim <- (mr(1, 1) - mr(1, 0)) - (mr(0, 1) - mr(0, 0))

titulo("PARTE D: tendências NÃO paralelas")
cat("DD com tendências paralelas:     ", round(dd_mao, 1), "\n")
cat("DD com tendências NÃO paralelas: ", round(dd_ruim, 1), "  (verdade = 300) -> VIÉS\n")

medias_ruim <- aggregate(renda ~ trimestre + tratado, data = painel_ruim, FUN = mean)
medias_ruim$grupo <- ifelse(medias_ruim$tratado == 1, "Tratados", "Controle")
g_ruim <- ggplot(medias_ruim, aes(trimestre, renda, colour = grupo)) +
  geom_vline(xintercept = 3.5, linetype = "dashed", colour = "grey50") +
  geom_line(linewidth = 1.5) + geom_point(size = 3.5) +
  scale_colour_manual(values = c("Tratados" = cor_laranja, "Controle" = cor_indigo), name = NULL) +
  scale_x_continuous(breaks = 1:6) +
  labs(title = "Alerta: tendências que já divergiam ANTES da política",
       subtitle = "O DD vai confundir o crescimento mais rápido dos tratados com efeito do programa",
       x = "Trimestre", y = "Renda média (R$)")
print(g_ruim)
salvar_fig(g_ruim, "04_nao_paralelas")

# Diagnóstico: o placebo denuncia o problema
pre_r <- painel_ruim[painel_ruim$trimestre <= 3, ]
pre_r$pos_falso <- as.integer(pre_r$trimestre >= 2)
placebo_ruim <- coef(lm(renda ~ tratado * pos_falso, data = pre_r))["tratado:pos_falso"]
cat("DD placebo no cenário ruim:", round(placebo_ruim, 1), "(longe de zero = alerta!)\n")

# -----------------------------------------------------------------------------
# DISCUSSÃO: O exemplo da Lei Maria da Penha (Cerqueira et al., 2015)
#   Tratamento: mulheres | Controle: homens (sujeitos às mesmas causas gerais
#   de violência, mas NÃO beneficiários da lei). Resultado: taxa de homicídios.
#   Pergunta: o que seriam "tendências paralelas" nesse caso? Que choques
#   (ex.: crise econômica, armas) poderiam afetar mulheres e homens de forma
#   diferente e violar o pressuposto?
# -----------------------------------------------------------------------------
#
