# Técnicas de Avaliação de Políticas Públicas: minicurso com simulações em R

Minicurso do **Seminário Discente 2026**, Programa de Pós-Graduação em Gestão de Políticas Públicas (PPGGP), EACH/USP.
**20 de outubro de 2026, 14h às 18h, online** (4 horas, com intervalo de 30 min).

Público: pós-graduandos e graduandos em Gestão de Políticas Públicas e Ciência Política.
Leitura-base: BATISTA, Mariana; DOMINGOS, Amanda (2017). *Mais que boas intenções: técnicas quantitativas e qualitativas na avaliação de impacto de políticas públicas.* Revista Brasileira de Ciências Sociais, 32(94). [doi:10.17666/329414/2017](https://doi.org/10.17666/329414/2017)

**Instrutor:** Prof. Dr. Anderson Henrique, Pós-Doutorando no CEM/USP/CEPix, pesquisador do INCT-QualiGov e pesquisador convidado no IPEA, Doutor em Ciência Política (UFPE). Contato: andersonheri@gmail.com

## A ideia

Na vida real nunca sabemos o verdadeiro efeito de uma política. Aqui **escrevemos a verdade** (o programa fictício *Qualifica* aumenta a renda em R$ 300/mês) e testamos se cada técnica consegue recuperá-la. Para cada técnica, os slides trazem as **características**, **exemplos em políticas públicas** e um **passo a passo** com o 'print' do console do R e como lê-lo, com os cortes da literatura (RCT, PSM, DiD e RDD; IV e controle sintético têm o passo a passo completo nos scripts), com números dos scripts. Os **scripts** são demonstrações comentadas, para os alunos entenderem e se basearem. 

| Bloco | Script (demonstração) |
|---|---|
| Problema do contrafactual e viés de seleção | `01_contrafactual_vies_selecao.R` |
| Experimento controlado (RCT) | `02_experimento_rct.R` |
| Pareamento / propensity score (PSM) | `03_pareamento_psm.R` |
| Diferença-em-diferenças (DiD) | `04_diferenca_em_diferenca.R` |
| Regressão descontínua (RDD) | `05_regressao_descontinua.R` |
| Variáveis instrumentais (IV) | `06_variaveis_instrumentais.R` |
| Controle sintético | `07_controle_sintetico.R` |
| Avaliação qualitativa e métodos mistos | (slides, com passo a passo) |

## Programa (14h às 18h)

| Horário | Bloco |
|---|---|
| 14:00 a 14:10 | Abertura: por que avaliar? |
| 14:10 a 14:25 | O problema do contrafactual |
| 14:25 a 14:50 | Experimento controlado |
| 14:50 a 15:10 | Pareamento (PSM) |
| 15:10 a 15:35 | Diferença-em-diferenças |
| 15:35 a 16:05 | **Intervalo** |
| 16:05 a 16:25 | Regressão descontínua |
| 16:25 a 16:37 | Variáveis instrumentais |
| 16:37 a 16:49 | Controle sintético |
| 16:49 a 16:55 | Como escolher a técnica |
| 16:55 a 17:50 | Avaliação qualitativa e métodos mistos |
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

## Licença e citação

Código e materiais sob licença MIT (ver `LICENSE`). O logo do CEM (`slides/img/logo_cem.png`) pertence à instituição e é usado apenas nos slides do instrutor. Ao reutilizar, cite este repositório:

> Henrique, A. (2026). *Técnicas de Avaliação de Políticas Públicas: minicurso com simulações em R.* Seminário Discente PPGGP EACH/USP.
