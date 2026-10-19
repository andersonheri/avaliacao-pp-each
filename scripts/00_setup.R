# =============================================================================
# 00_setup.R  |  Configuração comum a todos os scripts do workshop
# -----------------------------------------------------------------------------
# Workshop: Técnicas de Avaliação de Políticas Públicas (EACH/USP, 2026)
# Base: Batista e Domingos (2017), "Mais que boas intenções", RBCS 32(94).
#
# O QUE ESTE ARQUIVO FAZ
#   1. Verifica/instala os pacotes necessários;
#   2. Define as cores e o tema dos gráficos;
#   3. Carrega o "mundo simulado" (funcoes_dgp.R);
#   4. Cria pequenas funções de apoio (salvar figuras, balanço de covariáveis).
#
# COMO USAR
#   Você NÃO precisa rodar este arquivo sozinho: cada script começa com
#       source("scripts/00_setup.R")
#   Basta abrir o projeto "avaliacao-pp.Rproj" no RStudio (assim o R sabe
#   qual é a pasta raiz) e rodar o script desejado, linha a linha (Ctrl+Enter).
# =============================================================================

# ---- 1. Pacotes --------------------------------------------------------------
# Obrigatório: só o ggplot2 (gráficos). Todo o resto é R "puro" (base R),
# de propósito: assim vocês enxergam a lógica de cada técnica, sem "caixa-preta".
# Opcionais: se estiverem instalados, alguns scripts mostram a versão
# "profissional" (MatchIt para pareamento, rdrobust para RDD, fixest para DiD).

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  message("Instalando o pacote ggplot2 (só na primeira vez)...")
  install.packages("ggplot2")
}
library(ggplot2)

# Função auxiliar: TRUE se um pacote opcional está disponível neste computador
tem_pacote <- function(nome) requireNamespace(nome, quietly = TRUE)

# ---- 2. Identidade visual ----------------------------------------------------
# Cores inspiradas no cartaz do Seminário Discente 2026 (laranja + azul-índigo)
cor_laranja <- "#F26B21"   # usaremos para o GRUPO DE TRATAMENTO / efeito
cor_indigo  <- "#4A55A2"   # usaremos para o GRUPO DE CONTROLE / comparação
cor_cinza   <- "#8E93B0"   # elementos de apoio
cor_verde   <- "#2E8B57"   # usaremos para "verdade" (efeito real simulado)

# Tema padrão dos gráficos: limpo, letras grandes (bom para projetar online)
tema_curso <- function(tamanho = 14) {
  theme_minimal(base_size = tamanho) +
    theme(
      plot.title       = element_text(face = "bold", colour = cor_indigo),
      plot.subtitle    = element_text(colour = "grey30"),
      legend.position  = "bottom",
      panel.grid.minor = element_blank(),
      plot.caption     = element_text(colour = "grey40", size = tamanho - 4)
    )
}
theme_set(tema_curso())

# ---- 3. O "mundo simulado" ---------------------------------------------------
# Todas as funções que GERAM os dados estão em um arquivo à parte, bem
# comentado. Vale a pena lê-lo: é nele que "escondemos" a verdade que as
# técnicas tentarão recuperar.
source("scripts/funcoes_dgp.R")

# Versões prontas dos estimadores (pareamento e RDD local), usadas nas atividades.
source("scripts/funcoes_metodos.R")

# ---- 4. Funções de apoio -----------------------------------------------------

# 4a. Salvar figuras (usado pelo instrutor para montar os slides).
#     Só salva se a variável de ambiente SALVAR_FIGURAS estiver igual a "1".
#     Para os participantes, nada é salvo (a figura só aparece no painel Plots).
SALVAR_FIGURAS <- identical(Sys.getenv("SALVAR_FIGURAS"), "1")
salvar_fig <- function(grafico, nome, largura = 9, altura = 5.2) {
  if (SALVAR_FIGURAS) {
    dir.create("figuras", showWarnings = FALSE)
    ggsave(file.path("figuras", paste0(nome, ".png")), grafico,
           width = largura, height = altura, dpi = 200, bg = "white")
  }
  invisible(grafico)
}

# 4b. Imprimir um título de seção no Console (organiza a saída)
titulo <- function(texto) {
  cat("\n", strrep("=", 70), "\n  ", texto, "\n", strrep("=", 70), "\n", sep = "")
}

# 4c. Diferença Padronizada de Médias (SMD): mede o DESBALANCEAMENTO entre
#     tratamento e controle em uma covariável. Regra prática: |SMD| < 0,10
#     indica grupos bem balanceados; |SMD| > 0,25 é preocupante.
#     SMD = (média_tratados - média_controles) / desvio_padrão_combinado
smd <- function(x, tratamento, pesos = NULL) {
  if (is.null(pesos)) pesos <- rep(1, length(x))
  m1 <- weighted.mean(x[tratamento == 1], pesos[tratamento == 1])
  m0 <- weighted.mean(x[tratamento == 0], pesos[tratamento == 0])
  dp <- sqrt((var(x[tratamento == 1]) + var(x[tratamento == 0])) / 2)
  (m1 - m0) / dp
}

# 4d. Formatar números em reais, estilo brasileiro (ex.: R$ 1.234,50)
reais <- function(x) paste0("R$ ", formatC(x, format = "f", digits = 0,
                                           big.mark = ".", decimal.mark = ","))

message("Setup carregado. Pacotes opcionais disponíveis -> ",
        "MatchIt: ", tem_pacote("MatchIt"), " | rdrobust: ", tem_pacote("rdrobust"),
        " | fixest: ", tem_pacote("fixest"))
