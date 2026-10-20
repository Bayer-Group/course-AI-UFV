# Qualidade dos dados de um ensaio de milho

Pergunta da prática: depois de corrigir erros de digitação, com registro, qual é a completude, a média e o CV descritivo de PROD em cada ambiente?

Os dados são simulados (semente 2026) para uma aula de 45 minutos. Não são de um ensaio real.

## Como reproduzir o banco

Na pasta `projeto-analise`:

```text
"C:/Program Files/R/R-4.5.2/bin/Rscript.exe" R/00_gerar_banco.R
```

O croqui tem 120 parcelas (20 linhagens × 2 blocos × 3 ambientes). O arquivo bruto pode ter mais linhas por erro de digitação.

## O que não editar

`data/bruto/` e `db/ensaio_bruto.duckdb`. Correções só pelo script de curadoria, com linha em `docs/registro_de_correcoes.csv`.

## Roteiro

`roteiro_aula_pratica.Rmd`

Abra esta pasta como pasta do projeto no Cursor ou no Claude Code. A pasta da seção inteira mistura o pptx e outros roteiros, e o agente passa a usá-los como se fossem dados.
