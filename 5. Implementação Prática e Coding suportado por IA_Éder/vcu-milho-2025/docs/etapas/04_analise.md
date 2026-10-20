# Etapa 04 — Análise individual e conjunta de PROD

## O que foi feito

1. **Análise individual** por ambiente: `PROD ~ bloco + (1|genotipo)` via lme4/REML.
   Extraídos s2g, s2e e h² de médias = s2g / (s2g + s2e/r), r = 2 (do yaml).
2. **Análise conjunta**: `PROD ~ ambiente + (1|ambiente:bloco) + (1|genotipo) + (1|genotipo:ambiente)`.
3. BLUPs do efeito principal `germoplasma_nome` extraídos; ranking filtrado para DH25_*.

## Como reproduzir

```bash
Rscript R/04_analise.R
Rscript tests/04_test_analise.R
```

## Números-chave

| Ambiente    | Média (kg/ha) | CV (%) | h² médias |
|-------------|--------------|--------|-----------|
| PGO_2025_V  | 10 381       | 4.9    | 0.460     |
| SLG_2025_V  |  9 205       | 5.4    | 0.509     |
| UDI_2025_V  | 12 152       | 5.2    | 0.422     |

Componentes conjunta: s2g = 290.5², s2gxa = 209.0², s2bloco = 187.3², s2e = 549.5²

BLUPs ranqueados: 400 DH25_* genótipos.
Top-3: DH25_0030 (+641 kg/ha), DH25_0046 (+630), DH25_0165 (+622).

## Decisões

- BLUPs extraídos do efeito principal `germoplasma_nome` (não da interação), pois o
  objetivo é o valor médio de testcross.
- IDs pendentes `DH25 0138` e `DH25-0287` entram no modelo com nome não-padrão e
  ficam fora do ranking (não começam com `DH25_`); aguardam confirmação manual.

## Pendências

- Confirmar nomes corretos de `DH25 0138` e `DH25-0287` com o responsável pelo ensaio
  (ver Etapa 03). Se corrigidos, reexecutar a partir de `03_curar.R`.
