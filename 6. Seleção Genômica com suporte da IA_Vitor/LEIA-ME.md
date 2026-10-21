# Item 6 — Seleção Genômica com suporte da IA

Curso **IA no Melhoramento Genético**, UFV, novembro de 2026.

Percurso da aula: fenótipo → marcador → matriz G → GBLUP → GEBV → acurácia →
ganho genético → e, por fim, GBLUP contra um modelo de machine learning.

Todos os dados são **simulados**, com semente fixa. Nenhum dado real de
programa de melhoramento é usado em nenhum ponto do material.

## Para assistir à aula

Abra `06_selecao_genomica.html` no navegador. Não precisa de R, de internet
nem de instalar nada — as figuras e a matemática estão embutidas no arquivo.

## Para rodar o código

```r
source("06_selecao_genomica.R")
```

O script é **autocontido**: o simulador (meiose, matriz G, GBLUP, RR-BLUP) está
embutido no próprio arquivo, em R base. Não há `source()` de outro arquivo nem
dependência de nenhum pacote interno.

Saída: as figuras em `figuras/` e `resultados_06.rds` com os números que
aparecem nos slides. Tempo medido: cerca de 32 s em 4 núcleos.

## O desafio

`../06_desafio/` tem o desafio de 20 min em duplas: auditar um pipeline de
GBLUP escrito por uma IA, que roda sem erro e reporta um número errado. A pasta
traz o enunciado e o script que a dupla recebe.

O **gabarito interativo não está no repositório** de propósito: ele é
projetado em aula depois que as duplas entregarem. Gabarito na mão do aluno
antes da hora anula o desafio.

## Pacotes

O núcleo é **R base puro**. Dois pacotes públicos complementam:

| Pacote | Para que | Se faltar |
|---|---|---|
| `ggplot2` | todas as figuras | o script para no topo, com instrução |
| `randomForest` | comparativo GBLUP vs machine learning | a comparação é pulada, o script segue |

```r
install.packages(c("ggplot2", "randomForest"),
                 repos = "https://packagemanager.posit.co/cran/2026-09-01")
```

O snapshot é **datado** de propósito: `install.packages()` nunca sinaliza
falha, então conferir depois de instalar não é paranoia, é o mínimo. O script
já faz isso por conta própria e para no topo se faltar o indispensável.

## Para recompilar os slides

Opcional — o HTML já vem pronto. Precisa do
[Quarto CLI](https://quarto.org/docs/get-started/), embutido no RStudio recente:

```bash
quarto render 06_selecao_genomica.qmd --to revealjs
```

Rode o `.R` antes: os slides leem os números do `.rds`.
