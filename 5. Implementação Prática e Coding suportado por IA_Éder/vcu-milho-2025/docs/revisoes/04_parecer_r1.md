# Parecer de revisão — Etapa 04 (r1)

**Data:** 2026-10-20  
**Revisor:** orientador (Claude Code)  
**Artefatos revisados:**
- `R/04_analise.R`
- `tests/04_test_analise.R`
- `output/04_individual.csv`
- `output/04_conjunta_blups.csv`

---

## Bloqueantes

Sem bloqueantes.

Todos os critérios de aceitação do PLANO.md foram satisfeitos (verificados abaixo).

---

## Sugestões

**S1 — Teste hardcoda `3L` para número de ambientes (`tests/04_test_analise.R`, linha 37)**

```r
stopifnot("3 ambientes" = nrow(ind) == 3L)
```

O número de ambientes não está em `config/parametros.yaml`. O CLAUDE.md determina que parâmetros de ensaio venham do yaml. O `n_blocos` já está lá; o `n_ambientes` também poderia estar, tornando o teste consistente com a regra geral. Impacto: nenhum nos resultados atuais.

**S2 — `r` fixo do yaml não reflete desequilíbrio real por parcelas ausentes**

A fórmula `h² = s2g / (s2g + s2e / r)` usa `r = cfg$delineamento$n_blocos = 2` (correto conforme CLAUDE.md). Com 7 parcelas com PROD=NA distribuídas pelos ambientes, alguns genótipos têm `r < 2` efetivo. A fórmula simplificada pressupõe desenho balanceado. Para o conjunto de dados atual a diferença é irrelevante (7 NAs em 2424 obs), mas vale registrar em `docs/decisoes.md`.

**S3 — CV calculado com `sqrt(s2e)` em vez de RMSE do modelo**

`cv <- sqrt(s2e) / med * 100` usa o desvio padrão residual do REML, que é o estimador correto para o CV experimental. Nenhum problema; apenas confirmar que é intencional e não, por exemplo, o DP das observações brutas.

**S4 — Top-3 no `cat` falha se `nrow(blups25) < 3`**

```r
blups25$genotipo[1], blups25$blup[1],
blups25$genotipo[2], blups25$blup[2],
blups25$genotipo[3], blups25$blup[3]
```

Com 400 DH25 não há risco prático, mas um `if (nrow(blups25) >= 3)` protegeria execuções exploratórias com subconjuntos.

**S5 — Arquivos `output/04_*_run1.csv` deixados pelo processo de idempotência**

Durante a revisão foram gerados `output/04_individual_run1.csv` e `output/04_conjunta_blups_run1.csv` como cópias temporárias. Esses arquivos não fazem parte do script e devem ser removidos antes do commit.

---

## Números conferidos

Comandos executados da raiz do projeto:

```
Rscript R/04_analise.R
Rscript tests/04_test_analise.R
```

### Análise individual

| Ambiente   | Média (kg/ha) | CV (%) | h²     | s2g       | s2e       |
|------------|--------------|--------|--------|-----------|-----------|
| PGO_2025_V | 10 381.1     | 4.89   | 0.4603 | 109 827.2 | 257 578.5 |
| SLG_2025_V |  9 204.7     | 5.42   | 0.5094 | 129 229.3 | 248 948.7 |
| UDI_2025_V | 12 151.6     | 5.20   | 0.4218 | 145 466.7 | 398 803.5 |

Todos os h² em [0, 1]; todas as variâncias >= 0. CVs de 4.9–5.4% são típicos de ensaios de milho conduzidos com boa precisão (referência: 10–15% aceitável; < 8% excelente).

### Análise conjunta — componentes de variância

| Efeito                         | Desvio padrão |
|-------------------------------|--------------|
| germoplasma_nome:ambiente_id  | 208.95       |
| germoplasma_nome              | 290.53       |
| ambiente_id:bloco             | 187.31       |
| Residual                      | 549.52       |

Todos os componentes >= 0. Hierarquia s2g > s2gxa confirma que a variância genética principal supera a interação G×A — plausível para um conjunto de testcrosses de largo espectro.

### BLUPs

- 400 genótipos DH25_* ranqueados (todos com prefixo correto).
- Top-3: DH25_0030 (+641 kg/ha), DH25_0046 (+630), DH25_0165 (+622).
- IDs pendentes `DH25 0138` e `DH25-0287` ausentes do ranking (correto).

### Idempotência

Dois runs consecutivos produziram outputs bit-a-bit idênticos (`diff` sem diferenças).

---

## Verificação item a item do PLANO.md (Etapa 04)

| Critério | Status | Evidência |
|---|---|---|
| Modelo individual `PROD ~ bloco + (1|genotipo)` por ambiente | OK | `R/04_analise.R` linha 27 |
| h² = s2g / (s2g + s2e/r), r do yaml | OK | linha 31; yaml `n_blocos: 2`; dados têm blocos 1,2 |
| Modelo conjunto correto | OK | linhas 47–50 |
| BLUPs do efeito principal `germoplasma_nome` | OK | linha 57 |
| Ranking só DH25_*; DH24_* no modelo | OK | `prefixo_ranking` do yaml; DH24 em `d_conj` |
| Zero valores hardcoded no script | OK | r, prefixo, caminhos todos do yaml |
| Colunas esperadas nas saídas | OK | `04_individual.csv`: ambiente,media,CV,h2,s2g,s2e; `04_conjunta_blups.csv`: genotipo,blup,rank |
| Teste verifica h² in [0,1], variâncias >= 0, BLUPs só DH25_* | OK | `tests/04_test_analise.R` linhas 22–31 |
| Idempotência | OK | dois runs, diff vazio |
| Valores geneticamente plausíveis | OK | h² entre 0.42–0.51; CVs 4.9–5.4% |

---

**Pendências BLOQUEANTES: 0**  
**Sugestões: 5**
