# Item 9 — Otimização e Simulação (parte do Vitor)

Curso **IA no Melhoramento Genético**, UFV, novembro de 2026.

Esta parte do item 9 tem três blocos:

- **A — simulação de ciclos:** o que acontece com ganho e diversidade ao longo
  de 10 gerações de seleção, comparando sem seleção, truncamento e OCS.
- **B — OCS (Optimum Contribution Selection):** escolher contribuições de
  parentais otimizando ganho sujeito a restrição de parentesco. Implementado de
  **duas** formas — um algoritmo genético próprio em R base e o pacote público
  `optiSel` — para mostrar que chegam ao mesmo resultado.
- **C — alocação de recursos:** quantos locais, quantas repetições, quantos
  genótipos, dado um orçamento fixo de parcelas.

Todos os dados são **simulados**, com semente fixa. Nenhum dado real de
programa de melhoramento é usado em nenhum ponto do material.

## Para assistir à aula

Abra `09_otimizacao_simulacao.html` no navegador. Não precisa de R, de internet
nem de instalar nada — as figuras e a matemática estão embutidas no arquivo.

## Para rodar o código

```r
source("09_otimizacao_simulacao.R")
```

O script é **autocontido**: o simulador (meiose, matriz G, GBLUP, RR-BLUP,
coancestria) está embutido no próprio arquivo, em R base. Não há `source()` de
outro arquivo nem dependência de nenhum pacote interno.

Saída: as figuras em `figuras/` e `resultados_09.rds` com os números que
aparecem nos slides. Tempo medido: cerca de 4 min em 4 núcleos — ali dentro
estão 10 ciclos × 3 estratégias × 3 repetições, o algoritmo genético do OCS, a
fronteira de Pareto e a grade de alocação de recursos.

## O desafio

`09_desafio/` tem o desafio de 20 min em duplas: repartir 2.400 parcelas por
ciclo entre locais, repetições e genótipos, sujeito a uma restrição de
coancestria — e comparar a própria escolha com a que a IA recomenda sem
conhecimento de domínio.

O **gabarito interativo não está no repositório** de propósito: ele é
projetado em aula depois que as duplas entregarem.

## Pacotes

O núcleo é **R base puro**, incluindo o algoritmo genético do OCS.

| Pacote | Para que | Se faltar |
|---|---|---|
| `ggplot2` | todas as figuras | o script para no topo, com instrução |
| `optiSel` | validação externa do OCS | a validação é pulada, o script segue |

```r
install.packages(c("ggplot2", "optiSel"),
                 repos = "https://packagemanager.posit.co/cran/2026-09-01")
```

### Uma armadilha de verdade

O `optiSel` foi **arquivado no CRAN**. Então

```r
install.packages("optiSel")     # do CRAN: não instala nada, e não dá erro
```

falha **em silêncio** — o problema só aparece depois, no `library(optiSel)`.
Por isso o repositório acima é um snapshot **datado** do Posit Package Manager,
congelado antes do arquivamento. Verificado em 2026-10-05, binários Windows
para R 4.3 a 4.6:

| Repositório | `optiSel` |
|---|---|
| `packagemanager.posit.co/cran/2026-09-01` | 2.1.0 |
| `packagemanager.posit.co/cran/latest` | ausente |
| `cran.r-project.org` | ausente |

Vale a lição geral: `install.packages()` nunca sinaliza falha. Conferir depois
de instalar não é paranoia, é o mínimo.

O `optiSel` é público, de Robin Wellmann (Universidade de Hohenheim), GPL-2 —
não é pacote interno.

## Para recompilar os slides

Opcional — o HTML já vem pronto. Precisa do
[Quarto CLI](https://quarto.org/docs/get-started/), embutido no RStudio recente:

```bash
quarto render 09_otimizacao_simulacao.qmd --to revealjs
```

Rode o `.R` antes: os slides leem os números do `.rds`.
