---
description: "Revisão e curadoria de dados de ensaios de campo — diagnóstico, correção com registro, qualidade descritiva"
---

# Revisão de Dados de Ensaios

Skill para curadoria reprodutível de dados fenotípicos de ensaios de campo (milho, soja, etc.). Cobre do bruto ao resumo de qualidade, sem modelagem.

## Princípios

- **Bruto é sagrado.** Nunca editar `data/bruto/` nem o banco de origem. Confirmar integridade com hash (md5) antes e depois.
- **Toda correção tem registro.** Cada alteração de valor ou identificador gera uma linha em `registro_de_correcoes.csv` com: data (AAAA-MM-DD), tabela, chave, campo, valor_antigo, valor_novo, motivo.
- **Ausente explícito.** Célula vazia, `"0"` e `"-"` não são produtividade — viram `NA` com registro.
- **Corrigir antes de descartar.** Valor fora do intervalo que pode ser explicado por erro de digitação tem regra de correção antes de virar `NA`.

## Pipeline em 3 scripts

### 1. Diagnóstico (`R/01_diagnostico.R`)
Lê o bruto como texto. Classifica cada anomalia em tipos mutuamente exclusivos:
- `ausente_codigo` — PROD vazio, "0" ou "-"
- `fora_intervalo` — PROD numérico fora de [mínimo, máximo] do dicionário
- `id_fora_padrao` — identificador de germoplasma fora do regex esperado
- `duplicata_posicao` — mesma combinação ensaio × linha × coluna em mais de uma linha

Grava um CSV de casos (tipo, parcela_id, detalhe). Não altera dados.

### 2. Curadoria (`R/02_curar.R`)
Ordem obrigatória de operações:
1. **Normalizar identificadores** — `trimws()`, `toupper()`, hífen → underscore. Registrar cada alteração.
2. **Remover duplicatas de posição** — só quando o valor concorda. Registrar a linha removida.
3. **Códigos de ausente → NA** — registrar cada conversão.
4. **Intervalo do dicionário** — regras de correção com prioridade:
   - Valor > máximo e valor/10 dentro do intervalo → dividir por 10 (dígito a mais).
   - Valor < mínimo e valor×1000 dentro do intervalo → multiplicar por 1000 (unidade errada, ex: t/ha no lugar de kg/ha).
   - Qualquer outro fora do intervalo → `NA`.
5. **Outlier estatístico** — |z| > 3 dentro do ambiente, calculado com `sd()` só nos não-ausentes. **Sinalizar, nunca apagar.** O valor permanece na tabela curada.

Saídas: `registro_de_correcoes.csv`, `parcelas_curadas.csv`, `outliers_sinalizados.csv`.

### 3. Qualidade descritiva (`R/03_qualidade.R`)
Lê apenas a tabela curada. Calcula por ambiente:

| Métrica | Fórmula |
|---|---|
| n_parcelas | total de linhas |
| n_ausentes | `sum(is.na(PROD))` |
| n_validos | n_parcelas − n_ausentes |
| completude_pct | 100 × n_validos / n_parcelas |
| media, mediana | `mean(v)`, `median(v)` |
| dp | `sd(v)` |
| cv_pct | 100 × dp / media |
| minimo, maximo, amplitude | `min`, `max`, max − min |
| iqr | `IQR(v)` |
| n_outliers | contagem de |z| > 3 |
| assimetria | `mean(z^3)` (momento 3) |

Gráficos descritivos: boxplot com pontos por ambiente, barplot de completude.

## Regras de implementação

- R base apenas. Sem `setwd()` absoluto. Caminhos relativos à raiz do projeto.
- PROD no bruto é texto — ler com `colClasses = "character"`.
- Decimal com ponto.
- Arredondar métricas a 1 casa decimal (assimetria a 2).
- Criar diretórios de saída com `dir.create(..., recursive = TRUE, showWarnings = FALSE)`.
- Imprimir resumo no console ao final de cada script.

## O que esta skill NÃO cobre

- Modelo misto, BLUP, herdabilidade, CV experimental.
- QC de marcadores moleculares (SNPs).
- Imputação de valores ausentes.
- Qualquer edição no bruto ou no banco.
