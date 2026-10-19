# =============================================================================
# 06_exportar_dados.R  |  (OPCIONAL) Exporta os dados simulados para CSV
# -----------------------------------------------------------------------------
# Para quem quiser explorar os dados fora do R (Excel, Stata, Python, Jamovi...).
# Os arquivos são gravados na pasta dados/. Colunas marcadas como "só existem
# na simulação" NÃO existiriam em dados reais (são a "verdade" escondida).
# =============================================================================

source("scripts/00_setup.R")
dir.create("dados", showWarnings = FALSE)

# 1. Programa Qualifica (scripts 01, 02 e 03) - corte transversal
dados <- gerar_populacao(n = 5000, efeito = 300)
write.csv(dados, "dados/qualifica_populacao.csv", row.names = FALSE)

# 2. Painel de trabalhadores em 6 trimestres (script 04 - DiD)
write.csv(gerar_painel(), "dados/qualifica_painel_did.csv", row.names = FALSE)

# 3. Transferência de renda com corte de elegibilidade (script 05 - RDD)
write.csv(gerar_rdd(), "dados/transferencia_rdd.csv", row.names = FALSE)

cat("\nArquivos gravados em dados/:\n")
print(list.files("dados"))
cat("\nDicionário rápido:\n",
    "qualifica_populacao.csv : participa (0/1), renda_antes, renda_depois,\n",
    "                          motivacao / renda_depois_Y0 / renda_depois_Y1 (só existem na simulação)\n",
    "qualifica_painel_did.csv: id, trimestre, tratado, pos (1 = depois do programa), renda\n",
    "transferencia_rdd.csv   : renda (per capita), x = renda - 77, elegivel, freq (% frequência)\n")
