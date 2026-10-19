# Técnicas de Avaliação de Políticas Públicas — Workshop com simulações em R

Minicurso do **Seminário Discente 2026**, Programa de Pós-Graduação em Gestão de Políticas Públicas (PPGGP) — EACH/USP.
**20 de outubro de 2026 · 14h às 18h · online** (4 horas, com intervalo de 30 min).

Público: pós-graduandos e graduandos em Gestão de Políticas Públicas e Ciência Política.
Texto-base: BATISTA, Mariana; DOMINGOS, Amanda (2017). *Mais que boas intenções: técnicas quantitativas e qualitativas na avaliação de impacto de políticas públicas.* Revista Brasileira de Ciências Sociais, 32(94), e329414. [doi:10.17666/329414/2017](https://doi.org/10.17666/329414/2017)

## A ideia

Na vida real nunca sabemos o verdadeiro efeito de uma política. Aqui **escrevemos a verdade** (o programa fictício *Qualifica* aumenta a renda em R$ 300/mês) e testamos se cada técnica consegue recuperá-la:

| Técnica | Como constrói o contrafactual | Script | Atividade |
|---|---|---|---|
| Problema do contrafactual e viés de seleção | — | `01_contrafactual_vies_selecao.R` | `atividade_01` |
| Experimento controlado (RCT) | sorteio | `02_experimento_rct.R` | `atividade_02` |
| Pareamento / Propensity Score (PSM) | "gêmeos" nas características observadas | `03_pareamento_psm.R` | `atividade_03` |
| Diferença-em-diferenças (DiD) | tendência do grupo de controle | `04_diferenca_em_diferenca.R` | `atividade_04` |
| Regressão descontínua (RDD) | corte de elegibilidade | `05_regressao_descontinua.R` | `atividade_05` |
| Técnicas qualitativas e métodos mistos | — | — (discussão em grupos) | `atividade_06` (.md) |

## Programa (14h–18h)

| Horário | Bloco | Atividade |
|---|---|---|
| 14:00–14:15 | Abertura: por que avaliar, tipos de avaliação, cadeia de resultados | enquete |
| 14:15–14:35 | O problema do contrafactual (script 01) | Atividade 1 |
| 14:35–15:05 | Experimento controlado (script 02) | Atividade 2 |
| 15:05–15:40 | Pareamento e propensity score (script 03) | Atividade 3 |
| 15:40–16:10 | **Intervalo** | |
| 16:10–16:40 | Diferença-em-diferenças (script 04) | Atividade 4 |
| 16:40–17:05 | Regressão descontínua (script 05) | Atividade 5 |
| 17:05–17:50 | Técnicas qualitativas e métodos mistos | Atividade 6 (grupos) |
| 17:50–18:00 | Síntese, escolha da técnica, encerramento | feedback |

O roteiro minuto a minuto está em [`material/roteiro_instrutor.md`](material/roteiro_instrutor.md).

## Como usar (participantes)

1. Instale o **R** e o **RStudio** (veja [`material/preparacao_participantes.md`](material/preparacao_participantes.md)).
2. Baixe este repositório (**Code → Download ZIP**) e descompacte.
3. Abra o arquivo **`avaliacao-pp.Rproj`** no RStudio (isso define a pasta raiz certa).
4. Abra `scripts/00_setup.R` e rode (instala o único pacote obrigatório, `ggplot2`).
5. Abra o script do bloco (ex.: `scripts/02_experimento_rct.R`) e rode **linha a linha** com `Ctrl+Enter` (`Cmd+Enter` no Mac). Cada passo está comentado.
6. Nas atividades (`atividades/`), troque cada `COMPLETE` pelo código que falta e responda às perguntas em comentários.

Pacotes **opcionais** (deixam a análise mais "profissional", mas nada depende deles): `MatchIt`, `rdrobust`, `fixest`.

## Estrutura do repositório

```
.
├── avaliacao-pp.Rproj          # abra este arquivo no RStudio
├── scripts/
│   ├── 00_setup.R              # pacotes, cores, funções de apoio
│   ├── funcoes_dgp.R           # O "MUNDO SIMULADO": onde a verdade é escrita (comentado)
│   ├── funcoes_metodos.R       # psm_att() e rdd_local(), usadas nas atividades
│   ├── 01_...R a 05_...R       # um script por técnica, passo a passo
│   ├── 06_exportar_dados.R     # (opcional) exporta os dados simulados para CSV
│   └── 99_gerar_todas_figuras.R# (instrutor) regenera as figuras dos slides
├── atividades/                 # exercícios (R com lacunas + atividade 6 em .md)
├── gabaritos/                  # soluções comentadas (liberar após cada atividade)
├── slides/                     # Beamer/LaTeX: main.tex + um arquivo por bloco; main.pdf pronto
├── figuras/                    # gráficos dos slides (gerados pelos scripts)
├── dados/                      # CSVs simulados (após rodar 06_exportar_dados.R)
└── material/                   # roteiro do instrutor, preparação dos participantes
```

## Recompilar os slides

Requer LaTeX com `beamer`, `tikz`/`pgf`, `listings` (MiKTeX, TeX Live ou TinyTeX).

```bash
# a partir da pasta slides/
bash build.sh            # Linux/macOS/Git Bash
powershell -ExecutionPolicy Bypass -File build.ps1   # Windows
```

Para regenerar as figuras antes: `Rscript scripts/99_gerar_todas_figuras.R` (na pasta raiz).

## Reprodutibilidade

- Todos os scripts usam **sementes fixas**: todos os participantes veem os mesmos números.
- Testado com R 4.6.1. Os scripts funcionam só com `ggplot2` instalado; levam poucos segundos (o bootstrap do script 03 demora ~10 s).
- Os dados são **100% simulados**. Os exemplos de políticas reais (PSDP/Quênia, Seguro Popular, Trabajar, Bolsa Família, Progresa, Lei Maria da Penha, Adato etc.) são citados a partir do artigo-base, com os resultados que ele reporta.

## Licença e citação

Código e materiais sob licença MIT (ver `LICENSE`). Ao reutilizar, cite o artigo-base e este repositório:

> Henrique, A. (2026). *Técnicas de Avaliação de Políticas Públicas: workshop com simulações em R.* Seminário Discente PPGGP EACH/USP.

Contato: andersonheri@gmail.com
