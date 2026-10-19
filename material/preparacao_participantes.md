# Preparação dos participantes (enviar antes do workshop)

**Tempo estimado: 15 minutos.** Faça isso **antes** de 20/10; no dia, usaremos o tempo para aprender, não para instalar.

## 1. Instalar o R e o RStudio

1. **R** (linguagem): <https://cran.r-project.org/> → escolha seu sistema operacional → instale a versão mais recente.
2. **RStudio Desktop** (editor): <https://posit.co/download/rstudio-desktop/> → instale **depois** do R.

> Sem conseguir instalar? Use o **Posit Cloud** (<https://posit.cloud/>, gratuito, conta necessária) e envie a pasta do curso como um projeto. Avise o instrutor com antecedência.

## 2. Baixar o material

1. Acesse o repositório do curso no GitHub (link enviado por e-mail e no chat).
2. Clique em **Code → Download ZIP** e descompacte em uma pasta fácil (ex.: `Documentos/avaliacao-pp`).

## 3. Testar

1. No RStudio: **File → Open Project…** e escolha `avaliacao-pp.Rproj`.
2. Abra `scripts/00_setup.R`, selecione tudo (`Ctrl+A`) e rode (`Ctrl+Enter`).
3. Se aparecer a mensagem `Setup carregado. Pacotes opcionais disponíveis -> ...`, **está tudo certo**.
4. Se o R pedir para instalar o `ggplot2`, aceite (precisa de internet, ~1 min).

## Problemas comuns

| Sintoma | Solução |
|---|---|
| `não foi possível abrir o arquivo 'scripts/00_setup.R'` | Você não abriu o projeto. Use **File → Open Project → avaliacao-pp.Rproj**. |
| Erro ao instalar o `ggplot2` | Tente `install.packages("ggplot2", type = "binary")` ou atualize o R. |
| Acentos "quebrados" no Windows | **Tools → Global Options → Code → Saving → Default text encoding → UTF-8**. |
| O gráfico não aparece | Aba **Plots** (canto inferior direito do RStudio). Aumente a janela. |

## Durante o workshop

- Tenha **dois monitores/janelas** se possível: um para os slides (Zoom/Meet), outro para o RStudio.
- Rodem os scripts **linha a linha** (`Ctrl+Enter`); leiam os comentários — são o roteiro.
- Atividades: troquem cada `COMPLETE` pelo código que falta. Não há "certo e errado" para os comentários finais: queremos discussão.
