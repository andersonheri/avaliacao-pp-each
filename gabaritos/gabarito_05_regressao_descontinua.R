# =============================================================================
# GABARITO — ATIVIDADE 5 (uso do instrutor)
# =============================================================================

source("scripts/00_setup.R")

d <- gerar_rdd()
for (h in c(5, 15, 40)) {
  r <- rdd_local(d, h = h)                                  # <- resposta
  cat("Janela ±", h, "| efeito:", round(r$efeito, 2), "| EP:", round(r$ep, 2),
      "| n:", r$n, "\n")
}

d70 <- gerar_rdd(corte = 70)                                # <- resposta
r70 <- rdd_local(d70, h = 15)
cat("Corte R$ 70 -> efeito:", round(r70$efeito, 2), "\n")

d_manip <- gerar_rdd(manipulacao = TRUE)                    # <- resposta
r_manip <- rdd_local(d_manip, h = 15)
cat("Efeito sem manipulação:", round(rdd_local(d, 15)$efeito, 2),
    "| com manipulação:", round(r_manip$efeito, 2), "| verdade: 6\n")
cat("Famílias em [72,77]:", sum(d_manip$renda > 72 & d_manip$renda <= 77),
    "| em (77,82]:", sum(d_manip$renda > 77 & d_manip$renda <= 82), "\n")

r_tri <- rdd_local(d, h = 15, triangular = TRUE)            # <- resposta
cat("Janela ±15 triangular:", round(r_tri$efeito, 2), "\n")

# RESPOSTAS ESPERADAS
# 1) Janela estreita: EP grande (poucas famílias); janela larga: EP pequeno,
#    mas risco de viés se a relação não é linear. Janelas intermediárias (~10-20)
#    e mostrar sensibilidade; ferramentas automáticas (rdrobust) escolhem h ótimo.
# 2) (Com manipulação o efeito sobe de ~6,2 para ~7,0: o viés aparece, e o
#    teste de densidade o denuncia.) O "buraco" acima do corte e o excesso abaixo indicam que famílias
#    manipularam a renda declarada: quem está logo abaixo não é mais comparável
#    a quem está logo acima (não é "como aleatório"), violando o pressuposto.
# 3) Não. O RDD identifica o efeito LOCAL no corte; famílias muito mais pobres
#    podem responder de forma diferente (validade externa limitada).
