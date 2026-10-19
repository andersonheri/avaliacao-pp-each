# =============================================================================
# funcoes_dgp.R  |  O "mundo simulado" do workshop (DGP = Data Generating Process)
# -----------------------------------------------------------------------------
# POR QUE SIMULAR?
#   Na vida real, nunca sabemos o verdadeiro efeito de uma política: só vemos
#   o que aconteceu (e não o que TERIA acontecido). Em uma simulação NÓS
#   escrevemos a "verdade" (o efeito é de R$ 300) e então testamos se cada
#   técnica consegue recuperá-la. É um laboratório para avaliar os avaliadores.
#
# A HISTÓRIA (inspirada no exemplo de Batista e Domingos, 2017, p. 5)
#   O programa "Qualifica" oferece TREINAMENTO PROFISSIONAL a trabalhadores.
#   Queremos saber: quanto o treinamento aumentou a RENDA mensal dos
#   participantes? (A "verdade" simulada: + R$ 300 por mês.)
#
# ARMADILHA CENTRAL (viés de seleção)
#   Quem se inscreve no programa NÃO é um grupo aleatório: tende a ser mais
#   escolarizado e MAIS MOTIVADO. Motivação aumenta a renda de qualquer modo,
#   mas o avaliador NÃO a observa. Resultado: comparar participantes e
#   não-participantes mistura o efeito do programa com o efeito da motivação.
# =============================================================================

gerar_populacao <- function(n = 5000,          # número de trabalhadores
                            efeito = 300,      # efeito VERDADEIRO do programa (R$/mês)
                            forca_motivacao = 0.9,  # quanto a motivação influencia a adesão
                            tendencia = 100,   # crescimento de renda que ocorreria SEM o programa
                            semente = 2026) {  # semente: garante que todos vejam os mesmos dados

  set.seed(semente)

  # --- Características observáveis (o avaliador consegue medir) ---------------
  idade        <- round(runif(n, 18, 60))                        # 18 a 60 anos
  mulher       <- rbinom(n, 1, 0.5)                              # 1 = mulher
  escolaridade <- pmin(pmax(round(rnorm(n, 10, 3)), 4), 18)      # anos de estudo (4 a 18)

  # --- Característica NÃO observável (o avaliador NÃO consegue medir) ---------
  motivacao <- rnorm(n)        # média 0, desvio 1: "garra", iniciativa, rede de contatos...

  # --- Renda ANTES do programa (linha de base, "baseline") --------------------
  # Depende de escolaridade, idade (efeito em U invertido), sexo e MOTIVAÇÃO.
  renda_antes <- 800 + 90 * escolaridade + 12 * idade - 0.12 * idade^2 -
                 100 * mulher + 220 * motivacao + rnorm(n, 0, 150)

  # --- Quem entra no programa? (autosseleção) ---------------------------------
  # Probabilidade de participar sobe com escolaridade e MOTIVAÇÃO.
  # plogis() transforma qualquer número em probabilidade (entre 0 e 1).
  p_participar <- plogis(-0.9 + 0.20 * (escolaridade - 10) +
                           forca_motivacao * motivacao - 0.02 * (idade - 35))
  participa <- rbinom(n, 1, p_participar)

  # --- Resultados POTENCIAIS depois do programa -------------------------------
  # Y0 = renda depois SE NÃO participasse   |   Y1 = renda depois SE participasse
  # Na realidade só observamos UM dos dois para cada pessoa: esse é o
  # "problema fundamental da inferência causal". Aqui, como é simulação,
  # guardamos os dois e podemos "espiar" a verdade.
  ruido_depois <- rnorm(n, 0, 120)
  renda_depois_Y0 <- renda_antes + tendencia + ruido_depois   # sem programa
  renda_depois_Y1 <- renda_depois_Y0 + efeito                 # com programa

  # --- O que o avaliador REALMENTE observa ------------------------------------
  renda_depois <- ifelse(participa == 1, renda_depois_Y1, renda_depois_Y0)

  data.frame(
    id = seq_len(n),
    idade, mulher, escolaridade,
    motivacao,                       # (em dados reais, esta coluna NÃO existiria!)
    participa, p_verdadeira = p_participar,
    renda_antes, renda_depois,
    renda_depois_Y0, renda_depois_Y1 # (idem: só existem porque é simulação)
  )
}


# =============================================================================
# MUNDO 2 (script 04): PAINEL de trabalhadores em 6 trimestres - Diferença-em-Diferenças
# -----------------------------------------------------------------------------
# - 1.000 trabalhadores observados em 6 trimestres; 400 vivem na região onde o
#   programa foi implementado (tratados); o programa começa no trimestre 4;
# - os tratados são estruturalmente MAIS POBRES (efeito fixo do grupo): se
#   comparássemos níveis, erraríamos feio. O DD "cancela" essa diferença fixa.
# - extra_tendencia_trat > 0 VIOLA o pressuposto de tendências paralelas.
# =============================================================================
gerar_painel <- function(efeito = 300, tendencia = 80, extra_tendencia_trat = 0,
                         n = 1000, semente = 77) {
  set.seed(semente)
  unidades <- data.frame(
    id = 1:n,
    tratado = c(rep(1, 400), rep(0, n - 400))
  )
  # efeito fixo da unidade (características que não mudam e não observamos):
  unidades$alfa <- rnorm(n, 2000, 350) - 300 * unidades$tratado   # tratados ~R$300 mais pobres
  painel <- merge(unidades, data.frame(trimestre = 1:6))
  painel <- painel[order(painel$id, painel$trimestre), ]
  painel$pos <- as.integer(painel$trimestre >= 4)                # 1 = período pós-política
  # renda = efeito fixo + tendência comum + (tendência extra dos tratados, se houver)
  #         + EFEITO DA POLÍTICA (só tratados, só depois) + ruído
  painel$renda <- painel$alfa +
    tendencia * painel$trimestre +
    extra_tendencia_trat * painel$tratado * painel$trimestre +
    efeito * painel$tratado * painel$pos +
    rnorm(nrow(painel), 0, 150)
  painel
}


# =============================================================================
# MUNDO 3 (script 05): Transferência de renda com corte de elegibilidade - RDD
# -----------------------------------------------------------------------------
# Programa fictício inspirado no PTCR da Figura 7 do artigo e em Buddelmeyer e
# Skoufias (2004). Elegível: renda per capita da família <= R$ 77.
# Resultado: % de dias de aula frequentados pelas crianças da família.
# EFEITO VERDADEIRO: +6 pontos percentuais.
# =============================================================================
gerar_rdd <- function(n = 4000, efeito = 6, corte = 77, semente = 5, manipulacao = FALSE,
                      aderencia = 1) {   # aderencia < 1 => RDD "fuzzy" (nem todo elegível recebe)
  set.seed(semente)
  renda <- pmax(rnorm(n, 90, 35), 10)                 # renda per capita (R$), contínua
  idade_mae <- round(rnorm(n, 34, 7))                 # covariável (não deve "pular" no corte)

  if (manipulacao) {
    # Quem está pouco acima do corte "arruma" a renda declarada para ficar elegível
    acima_perto <- which(renda > corte & renda <= corte + 10)
    mudam <- acima_perto[rbinom(length(acima_perto), 1, 0.5) == 1]
    renda[mudam] <- corte - runif(length(mudam), 0, 1)
  }

  elegivel <- as.integer(renda <= corte)              # regra DETERMINÍSTICA (RDD "sharp")
  x <- renda - corte                                   # variável de corte CENTRADA em zero
  recebe <- elegivel * rbinom(n, 1, aderencia)        # quem de fato recebe (= elegivel se aderencia = 1)

  # frequência: cresce com a renda (famílias mais ricas têm mais frequência),
  # com leve curvatura, + efeito do programa para elegíveis + ruído
  freq <- 68 + 0.10 * x - 0.002 * x^2 + efeito * recebe + rnorm(n, 0, 8)
  freq <- pmin(pmax(freq, 0), 100)                    # limita entre 0 e 100

  data.frame(renda, x, elegivel, recebe, freq, idade_mae)
}
