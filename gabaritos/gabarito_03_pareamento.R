# =============================================================================
# GABARITO — ATIVIDADE 3 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")
dados <- gerar_populacao(n = 5000, efeito = 300)

f_completa <- participa ~ escolaridade + idade + mulher + renda_antes        # <- resposta

calipers <- c(0.01, 0.05, 0.2, 1)
res1 <- data.frame(caliper = calipers, att = NA, pareados = NA, tratados = NA)
for (i in seq_along(calipers)) {
  r <- psm_att(dados, f_completa, caliper_dp = calipers[i])
  res1$att[i]      <- r$att
  res1$pareados[i] <- r$n_pareados
  res1$tratados[i] <- r$n_tratados
}
print(res1, digits = 4)

f_sem_baseline <- participa ~ escolaridade + idade + mulher
f_so_renda     <- participa ~ renda_antes                                    # <- resposta
res2 <- data.frame(
  especificacao = c("Completa", "Sem renda antes", "Só renda antes"),
  att = c(psm_att(dados, f_completa)$att,
          psm_att(dados, f_sem_baseline)$att,
          psm_att(dados, f_so_renda)$att)
)
res2$erro <- res2$att - 300
print(res2)

forcas <- c(0, 0.9, 1.5)
erro_psm <- sapply(forcas, function(f) {
  d <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = f)
  psm_att(d, f_sem_baseline)$att - 300                                        # <- resposta
})
print(data.frame(forca_motivacao = forcas, erro = round(erro_psm, 1)))

# RESPOSTAS ESPERADAS (ver saída; números variam pouco com a semente)
# 1) Caliper pequeno descarta tratados sem par (com 0,01: ~1.576 de 1.631 pareados),
#    reduzindo a amostra e mudando a população avaliada (só os "pareáveis").
#    Aqui o ATT quase não muda porque a sobreposição é boa; em bases com pouca
#    região comum, o caliper pode mudar muito o resultado. Caliper grande aceita pares ruins.
# 2) A renda antes é um proxy poderoso das características NÃO observadas
#    (motivação, redes, habilidades) que também afetam a renda depois. Sem ela,
#    pode-se usar outros resultados pré-programa, histórico de emprego,
#    ou migrar para DiD (que exige dois períodos).
# 3) Pressuposto: ausência de confundidores NÃO observados / seleção apenas em
#    observáveis (ignorabilidade). Ex.: motivação, habilidade socioemocional,
#    rede de contatos, saúde mental.
