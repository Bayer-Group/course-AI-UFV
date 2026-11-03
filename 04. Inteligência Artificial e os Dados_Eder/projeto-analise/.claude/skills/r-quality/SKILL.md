---
name: r-quality
description: "Análise de performance e qualidade de código R base para scripts de curadoria de dados de ensaio"
---

# R Quality — Performance e Qualidade de Código

Revisão especializada para scripts R base deste projeto. Sem pacotes externos, sem modelos mistos — foco em scripts sequenciais que leem CSV, transformam e gravam CSV.

## Checklist de revisão

### 1. Crescimento de objetos em loop

O anti-pattern mais comum neste projeto: `rbind()` dentro de `for`/`if`.

```r
# RUIM — realoca a cada iteração, O(n²)
for (i in seq_len(n)) {
  resultado <- rbind(resultado, data.frame(...))
}

# BOM — pré-aloca lista, rbind uma vez
partes <- vector("list", n)
for (i in seq_len(n)) {
  partes[[i]] <- data.frame(...)
}
resultado <- do.call(rbind, partes)
```

Quando o número de `rbind` é pequeno e fixo (< 10 chamadas fora de loop), é aceitável — o custo é constante.

### 2. Vetorização antes de loop

- `which(x == y)[1]` dentro de loop → considerar `match(x, y)` fora do loop.
- `paste()` já é vetorizado — não precisa de `sapply`.
- `grepl()`, `gsub()`, `trimws()`, `toupper()` são vetorizados — nunca aplicar com `*apply` por linha.
- Comparações booleanas (`&`, `|`, `!`) e subconjunto por máscara lógica (`x[mask]`) são sempre preferíveis a `for` + `if`.

### 3. Leitura e escrita de dados

- `read.csv()` com `colClasses` explícito quando o tipo importa (PROD como texto no bruto).
- `write.csv(..., row.names = FALSE)` sempre — `row.names = TRUE` é lixo no CSV.
- `dir.create(..., recursive = TRUE, showWarnings = FALSE)` antes de gravar.
- Nunca `setwd()` com caminho absoluto. Caminhos relativos à raiz do projeto.

### 4. Coerção e NA

- `suppressWarnings(as.numeric(x))` é aceitável para conversão de texto com valores inválidos — mas verificar que os NA resultantes são tratados explicitamente logo em seguida.
- Nunca comparar NA com `==`. Usar `is.na()`.
- `x %in% c("", "0", "-")` é correto para detectar códigos de ausente em texto. `x == ""` falha com NA.

### 5. Integridade de dados

- Arquivo bruto lido uma vez, jamais escrito. Conferir com `tools::md5sum()` no início e no fim.
- Toda alteração de valor registrada em CSV de auditoria (data, chave, campo, antigo, novo, motivo).
- Após filtrar linhas, conferir `nrow()` contra o esperado (ex: 120 = 20 linhagens × 2 blocos × 3 ambientes).

### 6. Estatísticas descritivas

- `sd()` do R usa n−1 (amostral) — correto para este contexto.
- z-score: `(x - mean(x)) / sd(x)` — calcular só com valores não-NA.
- CV descritivo: `100 * sd(x) / mean(x)` — não confundir com CV experimental (que requer modelo).
- Arredondamento: `round()` com `digits` explícito. Nunca truncar com `floor`/`trunc` para métricas.

### 7. Gráficos (R base)

- `png()` antes, `dev.off()` depois — sem exceção.
- `par(mar = ...)` para controlar margens.
- Cores: vetor nomeado pelos níveis do fator, aplicado consistentemente.
- `stripchart(..., add = TRUE)` sobre `boxplot()` para mostrar pontos individuais com n pequeno.

### 8. Estilo e legibilidade

- `snake_case` para variáveis e funções.
- `<-` para atribuição.
- Seções separadas com `# --- Titulo ---`.
- Helpers curtos (ex: `novo_reg()`) para evitar repetição, mas sem abstrações além do necessário.
- `stringsAsFactors = FALSE` em todo `data.frame()` — R < 4.0 compatibilidade implícita.
- `cat()` para saída no console, `print()` para data.frames.

## Severidade

| Nível | Critério |
|---|---|
| CRÍTICO | Resultado errado (NA ignorado, coerção silenciosa, bruto modificado) |
| ALTO | Performance O(n²) em dados que podem crescer, ou perda de registro de correção |
| MÉDIO | Código funcional mas frágil (caminho absoluto, `row.names = TRUE`, falta de `dir.create`) |
| BAIXO | Estilo (indentação, nomes, comentário desnecessário) |

## Formato de saída

Para cada achado:

```
### [SEVERIDADE] Categoria — Descrição curta
- **Arquivo:** `R/0X_script.R`, linha N
- **Problema:** O que está errado e por quê.
- **Correção:** Código concreto ou refatoração.
```

Finalizar com contagem por severidade.
