# =============================================================================
# ATIVIDADE 3 — Pareamento: o que muda com o caliper e com as covariáveis?  (~20 min)
# -----------------------------------------------------------------------------
# Contexto: o município já implementou o Qualifica (sem sorteio) e a equipe
# quer estimar o impacto por pareamento (PSM). Você usará a função psm_att()
# (veja scripts/funcoes_metodos.R), que faz o pareamento por vizinho mais
# próximo e devolve o efeito estimado (ATT).
#
# Onde aparecer COMPLETE, escreva o código que falta. Verdade = R$ 300.
# =============================================================================

source("scripts/00_setup.R")
dados <- gerar_populacao(n = 5000, efeito = 300)

# ---- TAREFA 1: o tamanho do caliper ------------------------------------------
# Caliper pequeno = pares mais parecidos, mas mais tratados SEM par (descartados).
# Complete a fórmula do propensity score com: escolaridade, idade, mulher e renda_antes.
f_completa <- participa ~ COMPLETE

calipers <- c(0.01, 0.05, 0.2, 1)
res1 <- data.frame(caliper = calipers, att = NA, pareados = NA, tratados = NA)
for (i in seq_along(calipers)) {
  r <- psm_att(dados, f_completa, caliper_dp = calipers[i])
  res1$att[i]      <- r$att
  res1$pareados[i] <- r$n_pareados
  res1$tratados[i] <- r$n_tratados
}
print(res1, digits = 4)

# ---- TAREFA 2: quais covariáveis incluir? -------------------------------------
# Compare três especificações do propensity score:
f_sem_baseline <- participa ~ escolaridade + idade + mulher           # sem renda_antes
f_so_renda     <- COMPLETE                                            # <- só renda_antes
res2 <- data.frame(
  especificacao = c("Completa", "Sem renda antes", "Só renda antes"),
  att = c(psm_att(dados, f_completa)$att,
          psm_att(dados, f_sem_baseline)$att,
          psm_att(dados, f_so_renda)$att)
)
res2$erro <- res2$att - 300
print(round(res2[, 2:3], 1))
print(res2$especificacao)

# ---- TAREFA 3: quando o PSM falha? -------------------------------------------
# Compare o erro do PSM (sem renda antes) quando a motivação (não observada)
# influencia pouco ou muito a inscrição.
forcas <- c(0, 0.9, 1.5)
erro_psm <- sapply(forcas, function(f) {
  d <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = f)
  psm_att(d, COMPLETE)$att - 300           # <- use a fórmula SEM renda_antes
})
print(data.frame(forca_motivacao = forcas, erro = round(erro_psm, 1)))

# ---- PERGUNTAS ---------------------------------------------------------------
# 1) O que acontece com o número de pareados quando o caliper é muito pequeno?
#    E com o efeito estimado? (Dica: pense em "tratados sem par" e em quem sobra.)
#    R:
# 2) Por que incluir a renda ANTES do programa melhora tanto a estimativa?
#    Quando ela não existe (ex.: dados de uma única coleta), o que o avaliador pode fazer?
#    R:
# 3) Na tarefa 3, o erro cresce com forca_motivacao. Que pressuposto do PSM
#    (artigo, p. 9) isso ilustra? Dê um exemplo de variável "motivação" no
#    mundo real que o avaliador não consegue medir.
#    R:
