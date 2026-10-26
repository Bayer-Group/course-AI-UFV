# Ensaio didático — rede de milho 2025

Prática introdutória. O agente limpa problemas de digitação e resume a qualidade dos dados. Não ajusta modelo misto e não analisa marcadores.

## Dados

- Croqui previsto: 20 linhagens (`DH25_0001` a `DH25_0020`), 2 blocos, 3 ambientes, DBC. Uma parcela por linhagem em cada bloco.
- Ambientes: `UDI_2025_V` (Uberlandia), `SLG_2025_V` (Sete Lagoas), `PGO_2025_V` (Ponta Grossa), safra verão 2025.
- Variável: `PROD`, kg/ha, corrigida a 13% de umidade. Intervalo em `docs/dicionario_de_dados.csv` e em `config/parametros.yaml`: 2000 a 20000.
- Padrão de identificador: `^DH[0-9]{2}_[0-9]{4}$`.
- `data/bruto/` é somente leitura. Não edite, não renomeie e não sobrescreva esses arquivos.
- `db/ensaio_bruto.duckdb` é a mesma carga bruta. Também não altere o banco.
- Decimal com ponto. `PROD` no bruto é texto: há célula vazia, `0` e `-`.

## O que escrever nesta prática

1. `R/01_diagnostico.R` — só lê o bruto e grava o relatório.
2. `R/02_curar.R` — grava `docs/registro_de_correcoes.csv`, `data/processado/parcelas_curadas.csv` e `output/tabelas/outliers_sinalizados.csv`.
3. `R/03_qualidade.R` — lê só a tabela curada e grava `output/tabelas/qualidade_por_ambiente.csv`.

Use R base. Caminhos relativos à pasta `projeto-analise`. Não use `setwd()` com caminho absoluto. Não instale pacotes.

## Regras científicas

- Código de ausente: célula vazia, `0` e `-` viram `NA`. Zero não é produtividade.
- Valor acima de 20000 que, dividido por 10, cai no intervalo: corrigir (dígito a mais) e registrar.
- Valor abaixo de 2000 que, multiplicado por 1000, cai no intervalo: corrigir (t/ha no lugar de kg/ha) e registrar.
- Qualquer outro valor fora do intervalo vira `NA`, com registro.
- Outlier estatístico dentro do intervalo permanece na tabela curada. Sinalize `|z| > 3` dentro do ambiente, calculado depois das correções, só com valores não ausentes. Não apague essa parcela.
- Duplicata é a mesma posição (`ensaio_id`, `linha`, `coluna`) mais de uma vez. Se o valor concordar, mantenha uma linha.
- Normalize o identificador (sem espaço nas pontas, maiúsculas, hífen vira `_`) antes de cruzar com `bruto_germoplasma.csv`.
- Toda alteração de valor ou de identificador entra em `docs/registro_de_correcoes.csv` com data, chave, campo, valor antigo, valor novo e motivo.

## Fora desta prática

Não abra `data/gabarito/`, `R/00_gerar_banco.R` nem `roteiro_aula_pratica.Rmd` até o pedido explícito de conferir o gabarito. Os pedidos da aula chegam colados no chat.

Não faça modelo misto, herdabilidade, BLUP nem QC de SNPs.
