# Roteiro do instrutor — minuto a minuto

**Total:** 240 min = 210 min de aula/atividades + 30 min de intervalo. Slides: `slides/main.pdf` (86 páginas; os "slides de seção" e a capa não contam na numeração).
**Dica de ritmo:** o bloco que mais costuma estourar é o PSM. Se atrasar, corte os slides "Pressupostos e críticas" e "PSM: dois exemplos" (estão no artigo) e fale deles em 1 min.

## Antes de começar (13h30–14h00)

- [ ] Sala virtual aberta, gravação (se autorizada), chat visível; salas simultâneas (*breakout rooms*) habilitadas para a Atividade 6.
- [ ] RStudio com `avaliacao-pp.Rproj` aberto, tela compartilhada em modo "janela" (RStudio) alternando com os slides.
- [ ] Rode **todos** os scripts uma vez antes (`Rscript scripts/99_gerar_todas_figuras.R`) para garantir pacotes e figuras.
- [ ] Enquete do slide 4 pronta (chat ou enquete da plataforma).
- [ ] Gabaritos **fechados** (não compartilhar a pasta `gabaritos/` até depois de cada atividade; se o repositório é público, avise que os gabaritos estão lá e peça que só os abram após as atividades).

## Bloco 0 — Abertura (14:00–14:15, 15 min)

| Min | O que fazer | Slides |
|---|---|---|
| 0–3 | Boas-vindas, programa, objetivos, como vamos trabalhar | Capa → "Como vamos trabalhar" |
| 3–6 | **Enquete**: "o programa aumentou a renda em R$ 587?" Colher respostas no chat (não revelar) | "Para começar" |
| 6–10 | Por que avaliar; ciclo; tipos de avaliação; processo × resultado × impacto | 5–8 |
| 10–15 | Cadeia de resultados; pergunta causal → contrafactual | 9–10 |

**Pergunta para a turma:** "Se a renda dos participantes subiu, o programa funcionou?"

## Bloco 1 — Contrafactual (14:15–14:35, 20 min) · Script 01 · Atividade 1

| Min | O que fazer |
|---|---|
| 0–5 | Problema fundamental (tabela "?"), contrafactual, falsos contrafactuais 1 e 2 |
| 5–9 | **Hora do R:** rodar `01_...R` ao vivo. Passo 2 (a verdade = 300), Passo 3 (587), Passo 4 (402). Mostrar os gráficos. **Revelar a enquete** |
| 9–10 | Mapa das técnicas (o que vem pela frente) |
| 10–18 | **Atividade 1** (6–8 min, individual) + 1 min de discussão |
| 18–20 | Correção rápida (mostrar `gabarito_01`) |

**Armadilha frequente:** participantes acham que o viés vem só da motivação. A tarefa 1 mostra que mesmo com `forca_motivacao = 0` sobra viés (escolaridade, idade).

## Bloco 2 — Experimento (14:35–15:05, 30 min) · Script 02 · Atividade 2

| Min | O que fazer |
|---|---|
| 0–8 | Aleatorização, diagrama, balanceamento (love plot) |
| 8–14 | **Hora do R** (script 02): sorteio, balanço, diferença de médias, regressão; Monte Carlo (esperar o *loop*, ~3 s) |
| 14–19 | Exemplos (Quênia, Seguro Popular), implementação em fases, problemas de campo |
| 19–21 | Poder estatístico (34 vs 291 por grupo) |
| 21–29 | **Atividade 2** (10 min) |
| 29–30 | Fecho: ITT × efeito sobre aderentes |

**Pergunta para a turma:** "Se vocês fossem gestores, aceitariam sortear quem recebe o programa? Em que condições?"

## Bloco 3 — Pareamento / PSM (15:05–15:40, 35 min) · Script 03 · Atividade 3

| Min | O que fazer |
|---|---|
| 0–5 | Quando não dá para sortear; ideia do pareamento; maldição da dimensionalidade (rodar só o Passo 2 do script) |
| 5–15 | PSM em 3 passos; **Hora do R**: logit, região comum, pareamento "na unha" (explicar o laço `for`), balanceamento |
| 15–20 | Resultado (comparação de especificações), pressupostos, críticas (King e Nielsen) |
| 20–22 | Exemplos: Trabajar e Bolsa Família |
| 22–33 | **Atividade 3** (10–12 min) |
| 33–35 | Recapitular: "PSM só iguala o que está no modelo" |

**Atenção:** o bootstrap (`B = 100`) leva uns 10 s. Para a demonstração, pode-se rodar com `B = 30`.
**Intervalo logo após** — avisar que voltamos às 16h10.

## ☕ Intervalo (15:40–16:10, 30 min)

## Bloco 4 — Diferença-em-diferenças (16:10–16:40, 30 min) · Script 04 · Atividade 4

| Min | O que fazer |
|---|---|
| 0–2 | Reconectar: "e se tivermos dados ao longo do tempo?" |
| 2–9 | Ideia; **tabela da Figura 6 do artigo** (calcular juntos: 45 − 30 = 15); falsos contrafactuais (45 × 5 × 15) |
| 9–17 | **Hora do R** (script 04): Parte A (calculadora), Parte B (painel, regressão com interação) |
| 17–21 | Estudo de eventos, placebo, tendências não paralelas (R$ 420) |
| 21–22 | Lei Maria da Penha |
| 22–30 | **Atividade 4** (10 min) |

**Pergunta para a turma:** "Que choque poderia afetar mulheres e homens de forma diferente?"

## Bloco 5 — Regressão descontínua (16:40–17:05, 25 min) · Script 05 · Atividade 5

| Min | O que fazer |
|---|---|
| 0–5 | Ideia do corte, exemplo R$ 77/R$ 78, pré-requisitos, limitações |
| 5–12 | **Hora do R** (script 05): dispersão, regressão local, sensibilidade à janela |
| 12–15 | Testes de validade (covariável, placebo, manipulação); fuzzy; Progresa |
| 15–23 | **Atividade 5** (8 min) |
| 23–25 | Fecho: efeito local; validade externa |

## Bloco 6 — Qualitativo e métodos mistos (17:05–17:50, 45 min) · Atividade 6

| Min | O que fazer | Slides |
|---|---|---|
| 0–3 | Transição: "até aqui, *quanto*; agora, *como e por quê*" | "Quantificar × compreender" |
| 3–8 | 4 razões para o qualitativo; observação/etnografia (Adato) | 2 slides |
| 8–15 | Entrevistas (Patton: 77% satisfeitos) e grupos focais (Hunter e Sugiyama) | 2 slides |
| 15–18 | Críticas e cuidados | 1 slide |
| 18–25 | Métodos mistos: ganhos; coordenado × integrado; exemplos (Chile, Uruguai, Índia) | 3 slides |
| 25–40 | **Atividade 6** em salas simultâneas (15 min) — enviar o `.md` no chat | Cenário Qualifica |
| 40–45 | Plenária: 2–3 grupos apresentam; discutir os riscos (reflexividade, amostra, viés do entrevistador) | |

## Encerramento (17:50–18:00, 10 min)

| Min | O que fazer |
|---|---|
| 0–4 | Tabela comparativa e árvore de decisão: "qual técnica usar?" |
| 4–6 | As 5 perguntas antes de confiar em uma estimativa; mensagem final do artigo |
| 6–8 | Leituras, repositório, tarefa para casa |
| 8–10 | Feedback (chat/e-mail), agradecimentos |

## Respostas esperadas às enquetes e perguntas

- **Enquete do início:** (b) o efeito é menor — são R$ 300, não R$ 587; viés de seleção de ~R$ 287.
- **Antes-depois:** erra por ~R$ 102 (tendência).
- **Poder:** n = 34/grupo para R$ 300; 291/grupo para R$ 100; 390/grupo para R$ 100 com poder de 90%.
- **PSM:** R$ 297 com renda antes no modelo; R$ 476 sem ela (viés de motivação omitida).
- **DiD:** R$ 300; tendências não paralelas → R$ 420 (placebo +47).
- **RDD:** 6,2 p.p. (verdade 6); janela ±15; reta global linear subestima (4,7).

## Se algo der errado

| Problema | Plano B |
|---|---|
| Participante sem R instalado | Compartilhar tela e acompanhar; ou Posit Cloud |
| Script lento | Reduzir `n_rep` (script 02) para 300 e `B` (script 03) para 30 |
| Gráfico não aparece | Aba *Plots*; ou abrir as imagens em `figuras/` |
| Atraso no cronograma | Cortar: slides de exemplos (Quênia/Seguro Popular; Trabajar/Bolsa Família), "Limites do experimento"; encurtar Atividade 5 para 5 min |
