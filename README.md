# Técnicas de Avaliação de Políticas Públicas: minicurso com simulações em R

Minicurso do **Seminário Discente 2026**, Programa de Pós-Graduação em Gestão de Políticas Públicas (PPGGP), EACH/USP.
**20 de outubro de 2026, 14h às 18h, online** (4 horas, com intervalo de 30 min).

Público: pós-graduandos e graduandos em Gestão de Políticas Públicas e Ciência Política.
Leitura-base: BATISTA, Mariana; DOMINGOS, Amanda (2017). *Mais que boas intenções: técnicas quantitativas e qualitativas na avaliação de impacto de políticas públicas.* Revista Brasileira de Ciências Sociais, 32(94). [doi:10.17666/329414/2017](https://doi.org/10.17666/329414/2017)

**Instrutor:** Prof. Dr. Anderson Henrique, Pós-Doutorando no CEM/USP/CEPix, pesquisador do INCT-QualiGov e pesquisador convidado no IPEA, Doutor em Ciência Política (UFPE). Contato: andersonheri@gmail.com

## A ideia

Na vida real nunca sabemos o verdadeiro efeito de uma política. Aqui **escrevemos a verdade** (o programa fictício *Qualifica* aumenta a renda em R$ 300/mês) e testamos se cada técnica consegue recuperá-la. Para cada técnica, os slides trazem as **características**, **exemplos em políticas públicas** e um **passo a passo** com o 'print' do console do R, com os cortes da literatura (experimento, PSM, DiD e RDD), com números dos scripts. Metade do curso é quantitativa e metade é **avaliação qualitativa e métodos mistos**. Os **scripts** são demonstrações comentadas, para os alunos entenderem e se basearem. 

| Bloco | Script (demonstração) |
|---|---|
| Problema do contrafactual e viés de seleção | `01_contrafactual_vies_selecao.R` |
| Experimento controlado (e natural) | `02_experimento_rct.R` |
| Pareamento / propensity score (PSM) | `03_pareamento_psm.R` |
| Diferença-em-diferenças (DiD) | `04_diferenca_em_diferenca.R` |
| Regressão descontínua (RDD) | `05_regressao_descontinua.R` |
| Outras técnicas: variáveis instrumentais (extra) | `06_variaveis_instrumentais.R` |
| Outras técnicas: controle sintético (extra) | `07_controle_sintetico.R` |
| Avaliação qualitativa e métodos mistos | (slides, com passo a passo) |

## Programa (14h às 18h)

| Horário | Bloco |
|---|---|
| 14:00 a 14:20 | Abertura e tipos de avaliação |
| 14:20 a 14:30 | O problema do contrafactual |
| 14:30 a 14:45 | Experimento e experimentos naturais |
| 14:45 a 15:00 | Pareamento (PSM) |
| 15:00 a 15:15 | Diferença-em-diferenças |
| 15:15 a 15:30 | Regressão descontínua |
| 15:30 a 15:40 | Outras técnicas importantes e como escolher |
| 15:40 a 16:10 | **Intervalo** |
| 16:10 a 17:50 | Avaliação qualitativa e métodos mistos |
| 17:50 a 18:00 | Encerramento |

O roteiro minuto a minuto está em [`material/roteiro_instrutor.md`](material/roteiro_instrutor.md).

## Como usar (participantes)

1. Instale o **R** e o **RStudio** (veja [`material/preparacao_participantes.md`](material/preparacao_participantes.md)).
2. Baixe este repositório (**Code, Download ZIP**) e descompacte.
3. Abra o arquivo **`avaliacao-pp.Rproj`** no RStudio (isso define a pasta raiz certa).
4. Abra `scripts/00_setup.R` e rode (instala o único pacote obrigatório, `ggplot2`).
5. Abra o script do bloco (ex.: `scripts/02_experimento_rct.R`) e rode **linha a linha** com `Ctrl+Enter`. Cada passo está comentado; no fim há uma seção "PARA EXPLORAR".

Pacotes **opcionais**: `MatchIt`, `rdrobust`, `fixest` (nada depende deles).

## Estrutura do repositório

```
.
├── avaliacao-pp.Rproj          # abra este arquivo no RStudio
├── scripts/
│   ├── 00_setup.R              # pacotes, cores, funções de apoio
│   ├── funcoes_dgp.R           # O "MUNDO SIMULADO": onde a verdade é escrita (comentado)
│   ├── 01_...R a 07_...R       # um script por técnica, passo a passo
│   ├── 08_exportar_dados.R     # (opcional) exporta os dados simulados para CSV
│   └── 99_gerar_todas_figuras.R# (instrutor) regenera as figuras dos slides
├── slides/                     # Beamer (tema Berlin): main.tex + um arquivo por bloco; main.pdf pronto
├── figuras/                    # gráficos dos slides (gerados pelos scripts)
├── dados/                      # CSVs simulados
└── material/                   # roteiro do instrutor, preparação dos participantes
```

## Recompilar os slides

Requer LaTeX com `beamer` e `tikz` (MiKTeX, TeX Live ou TinyTeX).

```bash
# a partir da pasta slides/
bash build.sh            # Linux/macOS/Git Bash
powershell -ExecutionPolicy Bypass -File build.ps1   # Windows
```

Para regenerar as figuras antes: `Rscript scripts/99_gerar_todas_figuras.R` (na pasta raiz).

## Reprodutibilidade

- Todos os scripts usam **sementes fixas**: todos veem os mesmos números.
- Testado com R 4.6.1. Funciona só com `ggplot2` instalado e roda em segundos (o bootstrap do script 03 leva ~10 s).
- Os dados são **100% simulados**. Os exemplos de políticas reais citados nos slides vêm da literatura indicada nas leituras finais.

## Declaração de uso de inteligência artificial

Este material foi elaborado com o apoio de uma ferramenta de inteligência artificial generativa (Claude, da Anthropic). A IA ajudou na construção dos **scripts em R e das simulações**, dos **exemplos** usados nos slides, das **imagens** dos slides (gráficos gerados pelos scripts) e na **checagem de gramática e de redação**. O conteúdo, as escolhas didáticas e a revisão final são do autor, que se responsabiliza pelo material. Recomenda-se conferir as referências citadas antes de reutilizá-las.

## Licença e citação

Código e materiais sob licença MIT (ver `LICENSE`). O logo do CEM (`slides/img/logo_cem.png`) pertence à instituição e é usado apenas nos slides do instrutor. Ao reutilizar, cite este repositório:

> Henrique, A. (2026). *Técnicas de Avaliação de Políticas Públicas: minicurso com simulações em R.* Seminário Discente PPGGP EACH/USP.
