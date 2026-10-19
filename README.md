# Técnicas de Avaliação de Políticas Públicas: minicurso com simulações em R

Minicurso do **Seminário Discente 2026**, Programa de Pós-Graduação em Gestão de Políticas Públicas (PPGGP), EACH/USP.
**20 de outubro de 2026, 14h às 18h, online** (4 horas, com intervalo de 30 min).

Público: pós-graduandos e graduandos em Gestão de Políticas Públicas e Ciência Política.
Leitura-base: BATISTA, Mariana; DOMINGOS, Amanda (2017). *Mais que boas intenções: técnicas quantitativas e qualitativas na avaliação de impacto de políticas públicas.* Revista Brasileira de Ciências Sociais, 32(94). [doi:10.17666/329414/2017](https://doi.org/10.17666/329414/2017)

**Instrutor:** Anderson Henrique, cientista político, doutor pela UFPE (2025), pós-doutorando no CEM/USP (FAPESP/CEPid), pesquisador do INCT-QualiGov e pesquisador convidado no IPEA. Contato: andersonheri@gmail.com

## A ideia

Na vida real nunca sabemos o verdadeiro efeito de uma política. Aqui **escrevemos a verdade** (o programa fictício *Qualifica* aumenta a renda em R$ 300/mês) e testamos se cada técnica consegue recuperá-la. Os **scripts** são demonstrações comentadas passo a passo, para os alunos entenderem e se basearem. Os **exercícios** são poucos e curtos (três).

| Bloco | Script (demonstração) | Exercício |
|---|---|---|
| Problema do contrafactual e viés de seleção | `01_contrafactual_vies_selecao.R` | |
| Experimento controlado (RCT) | `02_experimento_rct.R` | **Exercício 1** (R) |
| Pareamento / propensity score (PSM) | `03_pareamento_psm.R` | |
| Diferença-em-diferenças (DiD) | `04_diferenca_em_diferenca.R` | **Exercício 2** (R) |
| Regressão descontínua (RDD) | `05_regressao_descontinua.R` | |
| Outras técnicas (IV, controle sintético) e como escolher | (apenas slides e leituras) | |
| Avaliação qualitativa e métodos mistos | (slides) | **Exercício 3** (grupos, sem R) |

## Programa (14h às 18h)

| Horário | Bloco |
|---|---|
| 14:00 a 14:15 | Abertura: por que avaliar? |
| 14:15 a 14:35 | O problema do contrafactual |
| 14:35 a 15:05 | Experimento controlado + **Exercício 1** |
| 15:05 a 15:25 | Pareamento (PSM) |
| 15:25 a 15:55 | Diferença-em-diferenças + **Exercício 2** |
| 15:55 a 16:25 | **Intervalo** |
| 16:25 a 16:45 | Regressão descontínua |
| 16:45 a 16:55 | Outras técnicas e como escolher |
| 16:55 a 17:50 | Avaliação qualitativa e métodos mistos + **Exercício 3** |
| 17:50 a 18:00 | Encerramento |

O roteiro minuto a minuto está em [`material/roteiro_instrutor.md`](material/roteiro_instrutor.md).

## Como usar (participantes)

1. Instale o **R** e o **RStudio** (veja [`material/preparacao_participantes.md`](material/preparacao_participantes.md)).
2. Baixe este repositório (**Code, Download ZIP**) e descompacte.
3. Abra o arquivo **`avaliacao-pp.Rproj`** no RStudio (isso define a pasta raiz certa).
4. Abra `scripts/00_setup.R` e rode (instala o único pacote obrigatório, `ggplot2`).
5. Abra o script do bloco (ex.: `scripts/02_experimento_rct.R`) e rode **linha a linha** com `Ctrl+Enter`. Cada passo está comentado; no fim há uma seção "PARA EXPLORAR".
6. Nos exercícios (`atividades/`), troque cada `COMPLETE` pelo código que falta e responda às perguntas em comentários.

Pacotes **opcionais**: `MatchIt`, `rdrobust`, `fixest` (nada depende deles).

## Estrutura do repositório

```
.
├── avaliacao-pp.Rproj          # abra este arquivo no RStudio
├── scripts/
│   ├── 00_setup.R              # pacotes, cores, funções de apoio
│   ├── funcoes_dgp.R           # O "MUNDO SIMULADO": onde a verdade é escrita (comentado)
│   ├── 01_...R a 05_...R       # um script por técnica, passo a passo
│   ├── 06_exportar_dados.R     # (opcional) exporta os dados simulados para CSV
│   └── 99_gerar_todas_figuras.R# (instrutor) regenera as figuras dos slides
├── atividades/                 # exercício 1 e 2 (R com lacunas) e exercício 3 (.md)
├── gabaritos/                  # soluções comentadas (liberar após cada exercício)
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

Código e materiais sob licença MIT (ver `LICENSE`). Ao reutilizar, cite este repositório:

> Henrique, A. (2026). *Técnicas de Avaliação de Políticas Públicas: minicurso com simulações em R.* Seminário Discente PPGGP EACH/USP.
