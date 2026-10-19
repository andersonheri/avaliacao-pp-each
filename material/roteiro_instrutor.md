# Roteiro do instrutor (minuto a minuto)

**Total:** 240 min = 210 min de aula e exercício + 30 min de intervalo. Slides: `slides/main.pdf` (tema Berlin, 80 páginas).
**Formato de cada técnica:** ideia, *características e exemplos em políticas públicas* e *passo a passo*: um slide por passo, com o **print do console do R** (comando em azul + output real) e a caixa **Como ler**, com o **corte da literatura** quando existe (ex.: |SMD| < 0,10, Austin 2009; p < 0,05; poder de 80%, Cohen 1988). Leia de cima para baixo: "o que eu faço, o que aparece, o que concluo". IV e controle sintético: só ideia, características, exemplos e gráficos (o passo a passo completo está nos scripts 06 e 07).
**Ritmo:** se atrasar, pule "Região comum e resultado" (PSM) e "Teste de manipulação" (RDD), e use os passo a passo como síntese.

## Antes de começar (13h30 às 14h00)

- [ ] Sala virtual aberta, chat visível, salas simultâneas habilitadas (opcional na plenária qualitativa).
- [ ] RStudio com `avaliacao-pp.Rproj` aberto; alternar entre slides e RStudio.
- [ ] Rodar uma vez `Rscript scripts/99_gerar_todas_figuras.R` para garantir pacotes e figuras.
- [ ] Enquete do slide "Para começar" pronta.
- [ ] Avisar que `gabaritos/` está no repositório e deve ser aberta só após cada exercício.

## Abertura (14:00 a 14:10, 10 min)

| Min | O que fazer |
|---|---|
| 0 a 2 | Boas-vindas, programa, o que vamos fazer |
| 2 a 4 | **Enquete**: "o programa aumentou a renda em R$ 587?" (guardar respostas) |
| 4 a 10 | Ciclo de políticas; tipos de avaliação; cadeia de resultados |

## Contrafactual (14:10 a 14:25, 15 min) · script 01

| Min | O que fazer |
|---|---|
| 0 a 5 | Problema fundamental (tabela com "?"); falsos contrafactuais |
| 5 a 11 | **Hora do R**: script 01 ao vivo (verdade = 300; ingênua = 587; antes-depois = 402) |
| 11 a 13 | **Revelar a enquete**: resposta (b) |
| 13 a 15 | Mapa das técnicas (as 5 técnicas quase-experimentais) |

## Experimento (14:25 a 14:50, 25 min) · script 02 · Exercício 1

| Min | O que fazer |
|---|---|
| 0 a 5 | Aleatorização; **características e exemplos**; balanço e Monte Carlo |
| 5 a 12 | **Passo a passo** (4 slides): balanço (SMD), `t.test` (atenção ao sinal negativo), regressão com covariáveis (ler só a linha `tratamento`), `power.t.test` |
| 12 a 23 | **Exercício 1** (10 min) |
| 23 a 25 | Correção rápida |

## Pareamento (14:50 a 15:10, 20 min) · script 03 (demonstração)

| Min | O que fazer |
|---|---|
| 0 a 6 | Ideia; maldição da dimensionalidade; **características e exemplos** |
| 6 a 18 | **Passo a passo** (4 slides): `glm` do escore, região comum (`tapply`), balanço antes/depois com SMD e razão de variâncias, ATT e robustez |
| 18 a 20 | Região comum e resultado (figuras); pressuposto |

O bootstrap (`B = 100`) leva uns 10 s. Para a demonstração, pode-se usar `B = 30`.

## Diferença-em-diferenças (15:10 a 15:35, 25 min) · script 04

| Min | O que fazer |
|---|---|
| 0 a 7 | Ideia, fórmula, exemplo numérico (80/125 e 90/120: DD = 15); **características e exemplos** (Maria da Penha, Card e Krueger); gráfico de tendências |
| 7 a 20 | **Passo a passo** (4 slides): quatro médias (`aggregate`), regressão com interação, `feols` com cluster, estudo de eventos (pré com p > 0,05) |
| 20 a 25 | Tendências não paralelas (R$ 420); pergunta sobre a Lei Maria da Penha |

## ☕ Intervalo (15:35 a 16:05, 30 min)

## Regressão descontínua (16:05 a 16:25, 20 min) · script 05 (demonstração)

| Min | O que fazer |
|---|---|
| 0 a 5 | Ideia do corte (R$ 77 e R$ 78); **características e exemplos** |
| 5 a 18 | **Passo a passo** (3 slides): regressão local (ler `elegivel`), tabela de janelas, covariável e contagens perto do corte |
| 18 a 20 | Efeito local: não extrapolar |

## Variáveis instrumentais (16:25 a 16:37, 12 min) · script 06

| Min | O que fazer |
|---|---|
| 0 a 4 | Ideia: o esquema Z, D, Y e a motivação não observada |
| 4 a 7 | **Características e exemplos** (Oregon, Colômbia, loteria do alistamento) |
| 7 a 12 | **Gráficos**: primeiro estágio (38% → 75%) e resumo (ITT 107, IV 297, ingênua 525, exclusão violada 574). Indicar o script 06 para o passo a passo |

## Controle sintético (16:37 a 16:49, 12 min) · script 07

| Min | O que fazer |
|---|---|
| 0 a 3 | Ideia: uma unidade tratada; trajetórias |
| 3 a 6 | **Características e exemplos** (Califórnia, País Basco) |
| 6 a 12 | **Gráficos**: ajuste pré e lacuna (−4,6); placebos (p = 0,05). Indicar o script 07 para o passo a passo |

## Como escolher a técnica (16:49 a 16:55, 6 min)

Árvore de decisão e quadro lado a lado. Pergunta à turma: "qual técnica vocês usariam para uma política que conhecem?"

## Avaliação qualitativa e métodos mistos (16:55 a 17:50, 55 min)

| Min | O que fazer | Slides |
|---|---|---|
| 0 a 4 | **Gancho**: o que os números não mostram (3 quebra-cabeças do Qualifica) | 1 a 2 |
| 4 a 10 | Para que serve; em cada etapa da avaliação; desenho da pesquisa | 3 a 5 |
| 10 a 22 | Técnicas: visão geral; observação (Adato); entrevistas e roteiro; grupos focais; documentos, estudos de caso, *process tracing* | 6 a 10 |
| 22 a 28 | Da fala ao tema (trecho, código, categoria, tema); rigor e críticas | 11 a 12 |
| 28 a 36 | Métodos mistos: por que combinar; desenhos; exemplos (Patton, Chile, Índia) | 13 a 15 |
| 36 a 48 | **Passo a passo** de uma avaliação qualitativa (2 slides): pergunta, amostra, instrumentos, campo, codificação, temas, integração, devolutiva | 16 a 17 |
| 48 a 55 | **Plenária**: cada um pensa numa política que conhece (número, pergunta qualitativa, quem entrevistar) | 18 |

## Encerramento (17:50 a 18:00, 10 min)

| Min | O que fazer |
|---|---|
| 0 a 3 | Cinco perguntas antes de confiar em uma estimativa; o que levar |
| 3 a 6 | Leituras (inclui IV, controle sintético e a parte qualitativa) |
| 6 a 10 | Repositório, feedback, agradecimentos |

## Respostas esperadas

- **Enquete do início:** (b) o efeito é menor: R$ 300, não R$ 587 (viés de seleção de ~R$ 287).
- **Antes-depois:** erra por ~R$ 102 (tendência).
- **Experimento:** ~R$ 295 (EP 11); com covariáveis ~R$ 302 (EP 3,4).
- **Poder:** 34 por grupo para R$ 300; 291 para R$ 100 (poder de 80%); 390 para R$ 100 com poder de 90%.
- **PSM:** R$ 297 com renda antes no modelo; R$ 476 sem ela.
- **DiD:** R$ 300; com tendências não paralelas, R$ 420 (placebo +47).
- **RDD:** 6,2 p.p. (verdade 6); janela ±15.
- **IV:** ingênua 525; ITT 107; IV 297 (IC 229 a 366); com exclusão violada, 574.
- **Controle sintético:** efeito médio −4,6 (verdade −5); p de permutação 0,05.

## Se algo der errado

| Problema | Plano B |
|---|---|
| Participante sem R instalado | Compartilhar tela e acompanhar; ou Posit Cloud |
| Script lento | Reduzir `n_rep` (script 02) para 300 e `B` (script 03) para 30 |
| Gráfico não aparece | Aba *Plots*; ou abrir as imagens em `figuras/` |
| Atraso | Pular os exemplos reais e as figuras extras; manter os passo a passo |
