# =============================================================================
# 01_contrafactual_vies_selecao.R
# -----------------------------------------------------------------------------
# TEMA: Por que "comparar quem participou com quem não participou" engana?
#
# OBJETIVOS DE APRENDIZAGEM
#   1. Entender o CONTRAFACTUAL: "o que teria acontecido sem a política?"
#   2. Ver, com números, os dois "falsos contrafactuais" (Gertler et al., 2011):
#        (a) comparar participantes x não participantes  -> viés de seleção
#        (b) comparar antes x depois                      -> tendência no tempo
#   3. Calcular a "verdade" (impossível na vida real, mas possível na simulação).
#
# COMO RODAR: abra avaliacao-pp.Rproj e rode linha a linha (Ctrl+Enter).
# =============================================================================

source("scripts/00_setup.R")

# -----------------------------------------------------------------------------
# PASSO 1: Gerar o mundo simulado
# -----------------------------------------------------------------------------
# 5.000 trabalhadores. O programa "Qualifica" tem efeito VERDADEIRO de R$ 300.
dados <- gerar_populacao(n = 5000, efeito = 300)

# Espie os dados: cada linha é um trabalhador.
head(dados[, c("id", "idade", "escolaridade", "participa",
               "renda_antes", "renda_depois")])

# Quantos participaram?
table(dados$participa)                 # contagem
round(prop.table(table(dados$participa)), 2)  # proporção

# -----------------------------------------------------------------------------
# PASSO 2: A "visão de Deus": o EFEITO VERDADEIRO
# -----------------------------------------------------------------------------
# Só na simulação conhecemos Y1 (renda COM programa) e Y0 (renda SEM programa)
# de TODO MUNDO. O efeito individual é Y1 - Y0; a média dele é o ATE.
efeito_verdadeiro <- mean(dados$renda_depois_Y1 - dados$renda_depois_Y0)

# Efeito médio SOBRE QUEM PARTICIPOU (ATT): é o que a maioria das avaliações
# quer saber -> "o programa funcionou para quem o recebeu?"
att_verdadeiro <- with(dados[dados$participa == 1, ],
                       mean(renda_depois_Y1 - renda_depois_Y0))

titulo("A VERDADE (que o avaliador real nunca vê)")
cat("Efeito verdadeiro (ATE):", round(efeito_verdadeiro, 1), "reais/mês\n")
cat("Efeito sobre participantes (ATT):", round(att_verdadeiro, 1), "reais/mês\n")

# -----------------------------------------------------------------------------
# PASSO 3: FALSO CONTRAFACTUAL nº 1: participantes x não participantes
# -----------------------------------------------------------------------------
# Compara a renda DEPOIS entre quem participou e quem não participou.
renda_part  <- mean(dados$renda_depois[dados$participa == 1])
renda_nao   <- mean(dados$renda_depois[dados$participa == 0])
estimativa_ingenua <- renda_part - renda_nao

titulo("FALSO CONTRAFACTUAL 1: participantes x não participantes")
cat("Renda média dos participantes:    ", reais(renda_part), "\n")
cat("Renda média dos NÃO participantes:", reais(renda_nao), "\n")
cat("Diferença (estimativa ingênua):   ", round(estimativa_ingenua, 1), "\n")
cat("Verdade:                          ", round(att_verdadeiro, 1), "\n")
cat("VIÉS DE SELEÇÃO:                  ", round(estimativa_ingenua - att_verdadeiro, 1), "\n")

# POR QUE ERROU? Porque os grupos já eram diferentes ANTES do programa.
# Olhe a renda na linha de base (antes de qualquer treinamento):
titulo("Os grupos já eram diferentes ANTES do programa")
cat("Renda ANTES - participantes:    ",
    round(mean(dados$renda_antes[dados$participa == 1])), "\n")
cat("Renda ANTES - não participantes:",
    round(mean(dados$renda_antes[dados$participa == 0])), "\n")
cat("Motivação média - participantes:    ",
    round(mean(dados$motivacao[dados$participa == 1]), 2), "\n")
cat("Motivação média - não participantes:",
    round(mean(dados$motivacao[dados$participa == 0]), 2), "\n")

# -----------------------------------------------------------------------------
# PASSO 4: FALSO CONTRAFACTUAL nº 2: antes x depois (só participantes)
# -----------------------------------------------------------------------------
# Compara a renda dos MESMOS participantes antes e depois do programa.
antes_depois <- with(dados[dados$participa == 1, ],
                     mean(renda_depois) - mean(renda_antes))

titulo("FALSO CONTRAFACTUAL 2: antes x depois")
cat("Variação de renda dos participantes:", round(antes_depois, 1), "\n")
cat("Verdade:                            ", round(att_verdadeiro, 1), "\n")
cat("Erro (tendência da economia):       ", round(antes_depois - att_verdadeiro, 1), "\n")
# A renda de TODOS cresceu R$ 100 no período (a "tendência" do DGP): inflação,
# crescimento econômico... O antes-depois atribui esse crescimento ao programa.

# -----------------------------------------------------------------------------
# PASSO 5: VISUALIZAR: o gráfico do contrafactual
# -----------------------------------------------------------------------------
# Médias dos participantes: antes, depois COM programa (observado) e
# depois SEM programa (contrafactual - só existe na simulação!).
part <- dados[dados$participa == 1, ]
fig_cf <- data.frame(
  momento = factor(c("Antes", "Depois", "Antes", "Depois"),
                   levels = c("Antes", "Depois")),
  serie   = c("Observado (com programa)", "Observado (com programa)",
              "Contrafactual (sem programa)", "Contrafactual (sem programa)"),
  renda   = c(mean(part$renda_antes), mean(part$renda_depois),
              mean(part$renda_antes), mean(part$renda_depois_Y0))
)

g_cf <- ggplot(fig_cf, aes(momento, renda, group = serie, colour = serie,
                           linetype = serie)) +
  geom_line(linewidth = 1.4) + geom_point(size = 3.5) +
  annotate("segment", x = 2.04, xend = 2.04,
           y = mean(part$renda_depois_Y0), yend = mean(part$renda_depois),
           colour = cor_verde, linewidth = 1.2,
           arrow = arrow(ends = "both", length = unit(0.12, "inches"))) +
  annotate("text", x = 2.07, y = (mean(part$renda_depois_Y0) + mean(part$renda_depois)) / 2,
           label = "Impacto", colour = cor_verde, hjust = 0, fontface = "bold", size = 5) +
  scale_colour_manual(values = c("Observado (com programa)" = cor_laranja,
                                 "Contrafactual (sem programa)" = cor_indigo), name = NULL) +
  scale_linetype_manual(values = c("Observado (com programa)" = "solid",
                                   "Contrafactual (sem programa)" = "dashed"), name = NULL) +
  scale_x_discrete(expand = expansion(add = c(0.3, 0.6))) +
  labs(title = "Identificação do impacto: o contrafactual",
       subtitle = "Só na simulação conseguimos ver a linha tracejada",
       x = NULL, y = "Renda média (R$)")
print(g_cf)
salvar_fig(g_cf, "01_contrafactual")

# Gráfico 2: os dois grupos NÃO eram comparáveis na linha de base
g_sel <- ggplot(dados, aes(renda_antes, fill = factor(participa, labels = c("Não participa", "Participa")))) +
  geom_density(alpha = 0.55, colour = NA) +
  scale_fill_manual(values = c(cor_indigo, cor_laranja), name = NULL) +
  labs(title = "Viés de seleção: os grupos já diferiam ANTES do programa",
       subtitle = "Distribuição da renda na linha de base (antes do treinamento)",
       x = "Renda antes do programa (R$)", y = "Densidade")
print(g_sel)
salvar_fig(g_sel, "01_vies_selecao")

# -----------------------------------------------------------------------------
# PASSO 6: Resumo para discussão
# -----------------------------------------------------------------------------
resumo <- data.frame(
  Metodo = c("Verdade (ATT)", "Participantes x Não participantes", "Antes x Depois"),
  Estimativa = round(c(att_verdadeiro, estimativa_ingenua, antes_depois), 1)
)
resumo$Erro <- round(resumo$Estimativa - att_verdadeiro, 1)
titulo("RESUMO")
print(resumo, row.names = FALSE)

# -----------------------------------------------------------------------------
# PARA DISCUTIR EM GRUPO (2 minutos)
#   - Qual dos dois "falsos contrafactuais" errou mais? Por quê?
#   - Se o gestor do programa só tivesse esses números, o que ele concluiria?
#   - O que o avaliador precisaria para construir um contrafactual válido?
# -----------------------------------------------------------------------------
#
