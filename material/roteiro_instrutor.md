# Roteiro do instrutor (minuto a minuto)

**Total:** 240 min = 210 min de aula e exercícios + 30 min de intervalo. Slides: `slides/main.pdf` (tema Berlin, 66 páginas).
**Ritmo:** as técnicas quase-experimentais são só apresentadas (a profundidade fica nas leituras). Se o tempo apertar, corte os slides de exemplos e deixe mais tempo para o bloco qualitativo.

## Antes de começar (13h30 às 14h00)

- [ ] Sala virtual aberta, chat visível, salas simultâneas habilitadas (Exercício 3).
- [ ] RStudio com `avaliacao-pp.Rproj` aberto; alternar entre slides e RStudio.
- [ ] Rodar uma vez `Rscript scripts/99_gerar_todas_figuras.R` para garantir pacotes e figuras.
- [ ] Enquete do slide "Para começar" pronta.
- [ ] Avisar que `gabaritos/` está no repositório e deve ser aberta só após cada exercício.

## Abertura (14:00 a 14:15, 15 min)

| Min | O que fazer |
|---|---|
| 0 a 3 | Boas-vindas, programa, o que vamos fazer |
| 3 a 6 | **Enquete**: "o programa aumentou a renda em R$ 587?" (guardar respostas) |
| 6 a 15 | Ciclo de políticas; tipos de avaliação (processo, resultados, impacto); cadeia de resultados |

## Contrafactual (14:15 a 14:35, 20 min) · script 01

| Min | O que fazer |
|---|---|
| 0 a 6 | Problema fundamental (tabela com "?"); contrafactual; dois falsos contrafactuais |
| 6 a 14 | **Hora do R**: script 01 ao vivo (verdade = 300; ingênua = 587; antes-depois = 402) |
| 14 a 17 | **Revelar a enquete**: resposta (b) |
| 17 a 20 | Mapa das técnicas |

## Experimento (14:35 a 15:05, 30 min) · script 02 · Exercício 1

| Min | O que fazer |
|---|---|
| 0 a 6 | Aleatorização; balanço; Monte Carlo (rodar o laço do script) |
| 6 a 10 | Exemplos reais, problemas de campo, poder |
| 10 a 14 | **Hora do R**: sorteio, diferença de médias, `power.t.test` |
| 14 a 27 | **Exercício 1** (12 min) |
| 27 a 30 | Correção rápida e discussão |

## Pareamento (15:05 a 15:25, 20 min) · script 03 (apenas demonstração)

| Min | O que fazer |
|---|---|
| 0 a 8 | Ideia do pareamento; maldição da dimensionalidade; PSM em 3 passos |
| 8 a 18 | **Hora do R**: escore, região comum, pareamento "na unha", resumo (PSM acerta quando o essencial é observável) |
| 18 a 20 | Pressuposto: sem confundidores não observados |

O bootstrap (`B = 100`) leva uns 10 s. Para a demonstração, pode-se usar `B = 30`.

## Diferença-em-diferenças (15:25 a 15:55, 30 min) · script 04 · Exercício 2

| Min | O que fazer |
|---|---|
| 0 a 6 | Ideia, fórmula, exemplo numérico (80/125 e 90/120: DD = 15) |
| 6 a 14 | **Hora do R**: painel, DD na mão e por regressão, tendências paralelas e não paralelas (placebo) |
| 14 a 17 | Caso real: Lei Maria da Penha |
| 17 a 28 | **Exercício 2** (10 min) |
| 28 a 30 | Correção |

## ☕ Intervalo (15:55 a 16:25, 30 min)

## Regressão descontínua (16:25 a 16:45, 20 min) · script 05 (apenas demonstração)

| Min | O que fazer |
|---|---|
| 0 a 6 | Ideia do corte (R$ 77 e R$ 78); pré-requisitos e limites |
| 6 a 16 | **Hora do R**: dispersão, regressão local, janela, testes de validade |
| 16 a 20 | Manipulação, RDD fuzzy; efeito local |

## Outras técnicas e como escolher (16:45 a 16:55, 10 min)

| Min | O que fazer |
|---|---|
| 0 a 4 | Variáveis instrumentais e controle sintético (só a ideia; indicar leituras) |
| 4 a 10 | Árvore de decisão e quadro lado a lado |

## Avaliação qualitativa e métodos mistos (16:55 a 17:50, 55 min) · Exercício 3

| Min | O que fazer | Slides |
|---|---|---|
| 0 a 4 | **Gancho**: o que os números não mostram (3 quebra-cabeças do Qualifica) | 1 a 2 |
| 4 a 9 | Para que serve; em cada etapa da avaliação | 3 a 4 |
| 9 a 13 | Desenho da pesquisa qualitativa; visão geral das técnicas | 5 a 6 |
| 13 a 20 | Observação (Adato); entrevistas e roteiro; grupos focais | 7 a 9 |
| 20 a 24 | Documentos, estudos de caso e *process tracing*; análise (trecho, código, categoria, tema) | 10 a 11 |
| 24 a 27 | Rigor e críticas | 12 |
| 27 a 30 | Métodos mistos: por que combinar; desenhos; exemplos | 13 a 15 |
| 30 a 50 | **Exercício 3** em salas simultâneas (20 min): codificar os 8 trechos | 16 a 18 |
| 50 a 55 | Plenária: temas, divergências entre grupos, quem mais entrevistar | |

**Perguntas para a plenária:** os grupos chegaram aos mesmos temas? Onde divergiram? O que as entrevistas *não* podem dizer? Como voltam ao desenho quantitativo?
O gabarito comentado do Exercício 3 (`gabaritos/gabarito_03_codificacao.md`) é um exemplo, não uma resposta única.

## Encerramento (17:50 a 18:00, 10 min)

| Min | O que fazer |
|---|---|
| 0 a 3 | Cinco perguntas antes de confiar em uma estimativa; o que levar |
| 3 a 6 | Leituras (inclui IV e controle sintético, e a parte qualitativa) |
| 6 a 10 | Repositório, feedback, agradecimentos |

## Respostas esperadas

- **Enquete do início:** (b) o efeito é menor: R$ 300, não R$ 587 (viés de seleção de ~R$ 287).
- **Antes-depois:** erra por ~R$ 102 (tendência).
- **Experimento:** ~R$ 295 (EP 11); com covariáveis ~R$ 302 (EP 3,4).
- **Poder:** 34 por grupo para R$ 300; 291 para R$ 100 (poder de 80%); 390 para R$ 100 com poder de 90%.
- **PSM:** R$ 297 com renda antes no modelo; R$ 476 sem ela.
- **DiD:** R$ 300; com tendências não paralelas, R$ 420 (placebo +47).
- **RDD:** 6,2 p.p. (verdade 6); janela ±15.

## Se algo der errado

| Problema | Plano B |
|---|---|
| Participante sem R instalado | Compartilhar tela e acompanhar; ou Posit Cloud |
| Script lento | Reduzir `n_rep` (script 02) para 300 e `B` (script 03) para 30 |
| Gráfico não aparece | Aba *Plots*; ou abrir as imagens em `figuras/` |
| Atraso | Pular "Experimentos reais" e "Região comum e resultado"; ampliar o tempo do bloco qualitativo |
