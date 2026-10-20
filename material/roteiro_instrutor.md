# Roteiro do instrutor (minuto a minuto)

**Total:** 240 min = 210 min de aula + 30 min de intervalo, divididos em **100 min de técnicas quantitativas** (14:00 a 15:40) e **100 min de avaliação qualitativa e métodos mistos** (16:10 a 17:50). Slides: `slides/main.pdf` (tema Berlin, 86 páginas). Não há exercícios: os scripts são demonstrações.
**Formato de cada técnica quantitativa:** ideia, *características e exemplos em políticas públicas* e *passo a passo*: um slide por passo, com o **print do console do R** (comando em azul + output essencial) e, no mesmo slide, a caixa **Como ler** (onde olhar e o corte da literatura, ex.: |SMD| < 0,10, Austin 2009). O PSM tem também os gráficos da região comum, do *love plot* e do resumo.
**Ritmo:** se atrasar, pule "Teste de manipulação" (RDD), "Resultado e robustez" (PSM) e os slides "Outras técnicas (3) a (5)".

## Antes de começar (13h30 às 14h00)

- [ ] Sala virtual aberta, chat visível.
- [ ] RStudio com `avaliacao-pp.Rproj` aberto; alternar entre slides e RStudio.
- [ ] Rodar uma vez `Rscript scripts/99_gerar_todas_figuras.R` para garantir pacotes e figuras.
- [ ] Enquete do slide "Para começar" pronta.

## Abertura e tipos de avaliação (14:00 a 14:20, 20 min)

| Min | O que fazer |
|---|---|
| 0 a 3 | Boas-vindas, sumário executivo, o que vamos fazer |
| 3 a 5 | **Enquete**: "o programa aumentou a renda em R$ 587?" (guardar respostas) |
| 5 a 9 | Avaliação no ciclo de políticas públicas |
| 9 a 18 | **Tipos de avaliação**: pela pergunta (diagnóstico, processo, resultados, impacto, eficiência), pelo momento (ex-ante, monitoramento, ex-post), por função e por quem avalia, monitoramento × avaliação |
| 18 a 20 | Cadeia de resultados (teoria do programa) |

## Contrafactual (14:20 a 14:30, 10 min) · script 01

| Min | O que fazer |
|---|---|
| 0 a 3 | Problema fundamental (tabela com "?"); contrafactual ideal |
| 3 a 6 | Falsos contrafactuais e **revelar a enquete** (b): 587 e 402 contra a verdade, 300 |
| 6 a 8 | Viés de seleção; **características de um bom contrafactual** |
| 8 a 10 | Mapa das técnicas |

## Experimento e experimentos naturais (14:30 a 14:45, 15 min) · script 02

| Min | O que fazer |
|---|---|
| 0 a 4 | Aleatorização; **características e exemplos**; balanço (figura) |
| 4 a 8 | **Passo a passo** (2 slides): balanço (SMD) e efeito com IC |
| 8 a 15 | **Experimentos naturais**: o que são, tipos e a técnica de cada um, exemplos em políticas (loteria do alistamento, Oregon, auditorias da CGU, Maimônides) e cuidados |

## Pareamento (14:45 a 15:00, 15 min) · script 03

| Min | O que fazer |
|---|---|
| 0 a 4 | Ideia; maldição da dimensionalidade; **características e exemplos** |
| 4 a 13 | **Passo a passo** (3 slides + gráficos): escore e sobreposição (região comum), balanço (SMD; *love plot*), ATT e IC |
| 13 a 15 | Resultado e robustez; pressuposto |

O bootstrap (`B = 100`) leva uns 10 s. Para a demonstração, pode-se usar `B = 30`.

## Diferença-em-diferenças (15:00 a 15:15, 15 min) · script 04

| Min | O que fazer |
|---|---|
| 0 a 5 | Ideia, fórmula, exemplo numérico (DD = 15); **características e exemplos** (Maria da Penha, Card e Krueger, Saúde da Família); tendências |
| 5 a 13 | **Passo a passo** (3 slides): quatro médias, efeito com erro-padrão agrupado, pré-tendências |
| 13 a 15 | Tendências não paralelas (R$ 420) |

## Regressão descontínua (15:15 a 15:30, 15 min) · script 05

| Min | O que fazer |
|---|---|
| 0 a 5 | Ideia do corte (R$ 77 e R$ 78); **características e exemplos**; figura do salto |
| 5 a 13 | **Passo a passo** (3 slides): salto, janelas, covariável e contagens perto do corte |
| 13 a 15 | Teste de manipulação; efeito local: não extrapolar |

## Outras técnicas e escolha (15:30 a 15:40, 10 min) · scripts 06 e 07 (extras)

| Min | O que fazer |
|---|---|
| 0 a 5 | **Outras técnicas** (5 slides): IV, controle sintético, DiD escalonado, ponderação pelo escore, e a lista de técnicas para conhecer. Para cada uma: ideia, quando usar, exemplo em política pública, cuidado |
| 5 a 10 | **Como escolher**: árvore de decisão e quadro lado a lado |

## ☕ Intervalo (15:40 a 16:10, 30 min)

## Avaliação qualitativa e métodos mistos (16:10 a 17:50, 100 min)

| Min | O que fazer | Tema |
|---|---|---|
| 0 a 8 | **Gancho**: o que os números não mostram; quanti × quali; para que serve | Por quê |
| 8 a 18 | O qualitativo em cada etapa; desenho da pesquisa; visão geral das técnicas | Desenho |
| 18 a 42 | Observação (Adato); entrevistas e roteiro; grupos focais (Hunter e Sugiyama); documentos, estudos de caso e *process tracing* | Coleta |
| 42 a 50 | **Ética**: TCLE, anonimato, LGPD, Resolução CNS 510/2016, relação de poder | Ética |
| 50 a 70 | Da fala ao tema; **codificação na prática**; análise temática em seis fases; análise de conteúdo e software | Análise |
| 70 a 78 | Rigor e críticas; critérios de qualidade (Lincoln e Guba) | Rigor |
| 78 a 92 | **Métodos mistos**: por que combinar; desenhos; quadro conjunto (*joint display*); exemplos (Patton, Chile, Índia) | Mistos |
| 92 a 100 | **Passo a passo** de uma avaliação qualitativa (2 slides) e como relatar a avaliação | Prática |

## Encerramento (17:50 a 18:00, 10 min)

| Min | O que fazer |
|---|---|
| 0 a 3 | Cinco perguntas antes de confiar em uma estimativa; o que levar |
| 3 a 6 | Leituras (3 slides) |
| 6 a 10 | Repositório, contato, agradecimentos |

## Respostas esperadas

- **Enquete do início:** (b) o efeito é menor: R$ 300, não R$ 587 (viés de seleção de ~R$ 287).
- **Antes-depois:** erra por ~R$ 102 (tendência).
- **Experimento:** R$ 295, IC 273 a 318 (verdade 300). Com covariáveis, ~R$ 302 (EP 3,4); no script 02, também o poder (34 por grupo para R$ 300; 291 para R$ 100).
- **PSM:** R$ 297 com renda antes no modelo (IC 282 a 314); R$ 476 sem ela. A motivação (não observada) fica com SMD 0,30.
- **DiD:** R$ 300; EP 19,9 (ingênuo) e 7,8 (agrupado por pessoa); com tendências não paralelas, R$ 420 (placebo +47).
- **RDD (com `rdrobust`):** 6,75 p.p. (EP 0,93; IC robusto 5,0 a 9,2; janela ótima 16,8; verdade 6). Janelas 5, 15 e 40: 7,2, 6,9 e 5,8. Sem salto na idade da mãe (p = 0,85) e teste de densidade p = 0,97. A regressão local "na mão" (script, passos didáticos) dá 6,18 na janela ±15. Lembrar: `x = -d$x`, porque os elegíveis estão abaixo do corte.
- **IV (script 06):** ingênua 525; ITT 107; IV 297 (IC 229 a 366); com exclusão violada, 574.
- **Controle sintético (script 07):** efeito médio −4,6 (verdade −5); p de permutação 0,05.

## Se algo der errado

| Problema | Plano B |
|---|---|
| Participante sem R instalado | Compartilhar tela e acompanhar; ou Posit Cloud |
| Script lento | Reduzir `n_rep` (script 02) para 300 e `B` (script 03) para 30 |
| Gráfico não aparece | Aba *Plots*; ou abrir as imagens em `figuras/` |
| Atraso | Pular os exemplos reais e as figuras extras; manter os passo a passo e a parte qualitativa |
