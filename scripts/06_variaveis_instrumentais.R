# =============================================================================
# 06_variaveis_instrumentais.R
# -----------------------------------------------------------------------------
# TEMA: Variáveis Instrumentais (IV, de "instrumental variables")
#
# SITUAÇÃO: a participação é ENDÓGENA: quem participa é diferente de quem não
#   participa, por motivos que não observamos (a motivação). Mas existe algo que
#   EMPURRA a participação e que não tem relação com a motivação: o SORTEIO DE
#   VAGAS do Qualifica (limitadas). Esse sorteio é o INSTRUMENTO (Z).
#
#        Z (oferta da vaga)  ->  D (participa)  ->  Y (renda)
#                                   ^                 ^
#                                   |_ motivação (U) __|   (não observada)
#
# O QUE O IV FAZ: usa só a parte da participação que é "movida" pelo sorteio
#   (limpa de motivação) para estimar o efeito sobre a renda.
#
# PASSOS DESTE SCRIPT
#   1. A comparação ingênua erra (viés de seleção)
#   2. O instrumento é "como aleatório"? (balanceamento por oferta)
#   3. Primeiro estágio: a oferta aumenta a participação? (relevância)
#   4. Forma reduzida: a oferta aumenta a renda? (efeito da OFERTA, o ITT)
#   5. Efeito IV = forma reduzida / primeiro estágio (estimador de Wald) e 2SLS
#   6. Incerteza (bootstrap)
#   7. Quando o IV falha: instrumento fraco e violação da exclusão
#   8. Interpretação: o efeito vale para QUEM? (LATE, compliers)
# =============================================================================

source("scripts/00_setup.R")

dados <- gerar_iv()       # 5.000 trabalhadores; efeito verdadeiro da participação = 300
head(dados)

# -----------------------------------------------------------------------------
# PASSO 1: a comparação ingênua (e a regressão com controles) erram
# -----------------------------------------------------------------------------
ingenua <- mean(dados$renda[dados$participa == 1]) - mean(dados$renda[dados$participa == 0])
ols     <- coef(lm(renda ~ participa + escolaridade, data = dados))["participa"]
titulo("PASSO 1: sem instrumento (verdade = 300)")
cat("Comparação ingênua:        ", round(ingenua, 1), "\n")
cat("Regressão com escolaridade:", round(ols, 1), "(a motivação não observada continua contaminando)\n")

# -----------------------------------------------------------------------------
# PASSO 2: o instrumento é "como aleatório"?
# -----------------------------------------------------------------------------
# A oferta foi SORTEADA. Logo, quem recebeu e quem não recebeu a oferta devem ser
# parecidos em tudo, inclusive no que não observamos.
titulo("PASSO 2: balanceamento por oferta (|SMD| < 0,10 = bom)")
cat("Escolaridade:", round(smd(dados$escolaridade, dados$oferta), 3), "\n")
cat("Motivação:   ", round(smd(dados$motivacao,    dados$oferta), 3), "(não observada na vida real)\n")

# -----------------------------------------------------------------------------
# PASSO 3: PRIMEIRO ESTÁGIO (relevância): a oferta move a participação?
# -----------------------------------------------------------------------------
part_sem_oferta <- mean(dados$participa[dados$oferta == 0])
part_com_oferta <- mean(dados$participa[dados$oferta == 1])
primeiro_estagio <- part_com_oferta - part_sem_oferta

m1 <- lm(participa ~ oferta, data = dados)
F_estat <- summary(m1)$coefficients["oferta", "t value"]^2     # com um instrumento, F = t^2

titulo("PASSO 3: primeiro estágio")
cat("Participam SEM a oferta:", round(100 * part_sem_oferta), "%\n")
cat("Participam COM a oferta:", round(100 * part_com_oferta), "%\n")
cat("Primeiro estágio (efeito da oferta na participação):", round(primeiro_estagio, 3), "\n")
cat("Estatística F do primeiro estágio:", round(F_estat, 1), " (regra prática: F > 10)\n")

g_pe <- ggplot(data.frame(oferta = c("Sem oferta de vaga", "Com oferta de vaga"),
                          pct = c(part_sem_oferta, part_com_oferta)),
               aes(oferta, pct)) +
  geom_col(fill = cor_laranja, width = 0.55) +
  geom_text(aes(label = paste0(round(100 * pct), "%")), vjust = -0.5, fontface = "bold", size = 5) +
  scale_y_continuous(labels = function(x) paste0(100 * x, "%"), limits = c(0, 1)) +
  labs(title = "Primeiro estágio: a oferta aumenta a participação",
       x = NULL, y = "Participaram do curso")
print(g_pe)
salvar_fig(g_pe, "06_iv_primeiro_estagio", largura = 4.6, altura = 3.2)

# -----------------------------------------------------------------------------
# PASSO 4: FORMA REDUZIDA: a oferta muda a renda? (é o efeito da OFERTA, o ITT)
# -----------------------------------------------------------------------------
forma_reduzida <- coef(lm(renda ~ oferta, data = dados))["oferta"]
titulo("PASSO 4: forma reduzida (ITT)")
cat("Quem recebeu a oferta ganha em média", round(forma_reduzida, 1), "a mais.\n")
cat("Mas nem todos que receberam a oferta participaram: o efeito da PARTICIPAÇÃO é maior.\n")

# -----------------------------------------------------------------------------
# PASSO 5: efeito IV = forma reduzida / primeiro estágio (estimador de Wald)
# -----------------------------------------------------------------------------
# Lógica: a oferta aumentou a renda em 'forma_reduzida' e aumentou a participação
# em 'primeiro_estagio' (uma fração). Se a oferta só afeta a renda via participação,
# cada ponto de participação "induzida" vale forma_reduzida / primeiro_estagio.
iv_wald <- forma_reduzida / primeiro_estagio

# Mesma coisa em dois estágios (2SLS): 1) prever a participação com a oferta;
# 2) regredir a renda na participação PREVISTA.
dados$participa_prevista <- fitted(lm(participa ~ oferta, data = dados))
iv_2sls <- coef(lm(renda ~ participa_prevista, data = dados))["participa_prevista"]

titulo("PASSO 5: estimativa IV")
cat("Wald (forma reduzida / primeiro estágio):", round(iv_wald, 1), "\n")
cat("2SLS manual:                             ", round(iv_2sls, 1), "\n")
cat("Verdade: 300 | Ingênua:", round(ingenua, 1), "| ITT:", round(forma_reduzida, 1), "\n")
cat("(O erro-padrão do 2SLS manual NÃO é válido: use bootstrap ou um pacote, ver passos 6 e 7.)\n")

# -----------------------------------------------------------------------------
# PASSO 6: incerteza por bootstrap (reamostrar e refazer o Wald)
# -----------------------------------------------------------------------------
wald_iv <- function(df) {
  fs <- mean(df$participa[df$oferta == 1]) - mean(df$participa[df$oferta == 0])
  rf <- mean(df$renda[df$oferta == 1])     - mean(df$renda[df$oferta == 0])
  rf / fs
}
set.seed(1)
boot <- replicate(300, wald_iv(dados[sample(nrow(dados), replace = TRUE), ]))
ic <- quantile(boot, c(0.025, 0.975))
cat("\nIV (Wald) =", round(iv_wald, 1), "| IC 95% bootstrap: [", round(ic[1]), ",", round(ic[2]), "]\n")

# Versão "profissional" (opcional), com pacote:
if (tem_pacote("fixest")) {
  library(fixest)
  m_iv <- feols(renda ~ 1 | participa ~ oferta, data = dados)    # 2SLS com erro-padrão correto
  print(coeftable(m_iv))
}

# -----------------------------------------------------------------------------
# PASSO 7: quando o IV FALHA
# -----------------------------------------------------------------------------
# (a) INSTRUMENTO FRACO: a oferta quase não muda a participação.
fraco  <- gerar_iv(forca_instrumento = 0.12)
fs_f   <- mean(fraco$participa[fraco$oferta == 1]) - mean(fraco$participa[fraco$oferta == 0])
F_f    <- summary(lm(participa ~ oferta, data = fraco))$coefficients["oferta", "t value"]^2
boot_f <- replicate(300, wald_iv(fraco[sample(nrow(fraco), replace = TRUE), ]))

# (b) VIOLAÇÃO DA EXCLUSÃO: a oferta afeta a renda por OUTRO caminho (+R$ 100).
viola  <- gerar_iv(efeito_direto_oferta = 100)

titulo("PASSO 7: quando o IV falha")
cat("(a) Instrumento fraco: primeiro estágio =", round(fs_f, 3), "| F =", round(F_f, 1),
    "| IV =", round(wald_iv(fraco), 0), "| IC 95%: [", round(quantile(boot_f, 0.025)), ",",
    round(quantile(boot_f, 0.975)), "]\n")
cat("    -> intervalo enorme: o IV é muito impreciso.\n")
cat("(b) Exclusão violada: IV =", round(wald_iv(viola), 1), "(verdade 300)\n")
cat("    -> viés = efeito direto da oferta / primeiro estágio = 100 /",
    round(primeiro_estagio, 2), "=", round(100 / primeiro_estagio), "\n")

# Gráfico-resumo
res <- data.frame(
  metodo = c("Verdade", "Comparação ingênua", "Efeito da oferta (ITT)", "IV (efeito da participação)",
             "IV com exclusão violada"),
  efeito = c(300, ingenua, forma_reduzida, iv_wald, wald_iv(viola))
)
res$metodo <- factor(res$metodo, levels = rev(res$metodo))
g_res <- ggplot(res, aes(efeito, metodo)) +
  geom_vline(xintercept = 300, colour = cor_verde, linewidth = 1.2) +
  geom_point(size = 4.5, colour = cor_laranja) +
  geom_text(aes(label = round(efeito)), nudge_x = 25, hjust = 0, size = 4.2) +
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.2))) +
  labs(title = "IV recupera o efeito (se o instrumento é válido)",
       x = "Efeito estimado (R$/mês)", y = NULL)
print(g_res)
salvar_fig(g_res, "06_iv_resumo", largura = 6, altura = 3.2)

# -----------------------------------------------------------------------------
# PASSO 8: INTERPRETAÇÃO: o efeito IV vale para QUEM?
# -----------------------------------------------------------------------------
# O IV estima o efeito para quem participa SÓ SE for sorteado (os "compliers").
#   - Sempre participam (independente da oferta):       ~ part_sem_oferta
#   - Participam só se receberem a oferta (compliers):   ~ primeiro_estagio
#   - Nunca participam:                                  ~ 1 - part_com_oferta
titulo("PASSO 8: quem são os 'compliers'?")
cat("Sempre participam:", round(100 * part_sem_oferta), "%\n")
cat("Compliers (participam só com a oferta):", round(100 * primeiro_estagio), "%\n")
cat("Nunca participam:", round(100 * (1 - part_com_oferta)), "%\n")
cat("O IV responde: 'qual o efeito para os compliers?' (efeito LOCAL, o LATE).\n")

# -----------------------------------------------------------------------------
# PARA EXPLORAR (mude e rode de novo)
#   - gerar_iv(forca_instrumento = 0.5): o primeiro estágio enfraquece? O IC aumenta?
#   - gerar_iv(efeito_direto_oferta = 50): quanto vira o viés?
#   - Compare o IV com o ITT do script 02: a razão é a mesma ideia (compliance).
# -----------------------------------------------------------------------------
