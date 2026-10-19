# =============================================================================
# ATIVIDADE 1 — O viés de seleção cresce com a "autosseleção"?   (~10 min)
# -----------------------------------------------------------------------------
# Contexto: no programa Qualifica, quanto MAIS a motivação (não observada)
# influencia quem se inscreve, mais os participantes diferem dos demais.
#
# COMO FAZER: rode linha a linha (Ctrl+Enter). Onde aparecer COMPLETE,
# substitua pelo código que falta. Depois responda às perguntas no final.
# =============================================================================

source("scripts/00_setup.R")

# ---- TAREFA 1: viés da comparação ingênua para diferentes forças de seleção ---
forcas <- c(0, 0.5, 0.9, 1.5)        # 0 = motivação NÃO influencia a inscrição
resultado <- data.frame(forca_motivacao = forcas, estimativa = NA, vies = NA)

for (i in seq_along(forcas)) {
  d <- gerar_populacao(n = 5000, efeito = 300, forca_motivacao = forcas[i])

  # Comparação ingênua: renda média dos participantes MENOS dos não participantes
  media_part <- mean(d$renda_depois[d$participa == 1])
  media_nao  <- COMPLETE                      # <- média dos NÃO participantes

  resultado$estimativa[i] <- media_part - media_nao
  resultado$vies[i]       <- resultado$estimativa[i] - 300    # verdade = 300
}
print(round(resultado, 1))

# ---- TAREFA 2: o "antes e depois" some se não houver tendência? --------------
# Gere uma população SEM tendência de crescimento (tendencia = 0) e calcule a
# variação média de renda dos participantes (depois - antes).
d0 <- gerar_populacao(n = 5000, efeito = 300, tendencia = COMPLETE)
part <- d0[d0$participa == 1, ]
antes_depois <- COMPLETE                      # <- mean(depois) - mean(antes) dos participantes
cat("Antes x depois sem tendência:", round(antes_depois, 1), "\n")

# ---- PERGUNTAS (responda em comentários) -------------------------------------
# 1) Quando forca_motivacao = 0, o viés da comparação ingênua desaparece por
#    completo? Se não, que outra característica ainda gera viés?
#    R:
# 2) Por que o antes-depois acerta (ou quase) quando a tendência é zero?
#    Isso é realista? Que fatores externos mudam a renda ao longo do tempo?
#    R:
# 3) Se você fosse gestor(a) e só tivesse a comparação ingênua, que decisão
#    tomaria sobre o programa? Ela estaria correta?
#    R:
