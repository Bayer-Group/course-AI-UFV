# Parecer R1 — Etapa 04 (Análise individual e conjunta)

## Conformidade (itens OK)

1. Modelo individual: `PROD ~ factor(bloco) + (1|germoplasma_nome)` por ambiente — confere com CLAUDE.md.
2. Modelo conjunto: `PROD ~ ambiente_id + (1|ambiente_id:bloco) + (1|germoplasma_nome) + (1|germoplasma_nome:ambiente_id)` — confere.
3. h² = s2g / (s2g + s2e/r), r = `par$delineamento$n_blocos` (2) — confere.
4. CV = 100 × sqrt(s2e) / média — confere.
5. Ranking só DH25_ (400 genótipos); DH24_ no modelo mas fora do ranking — confere.
6. Dados de parcela, sem agregação prévia — confere.
7. Parâmetros lidos de config/parametros.yaml, nenhum hardcoded — confere.
8. Sem singularidade nem warnings de convergência do lme4.
9. Saídas: `output/04_individual.csv` (3 linhas), `output/04_conjunta_blups.csv` (400 linhas).
10. Testes: 11 PASS, 0 FAIL.

## Pendências BLOQUEANTES

Nenhuma.

## Pendências NÃO-BLOQUEANTES (sugestões)

1. **BLUP referenciado ao intercepto vs. média geral.** O script usa `fixef(fit)[1]` (=média PGO). Usar média marginal dos 3 ambientes seria mais interpretável. O ranking não muda.
2. **Teste de plausibilidade das médias.** Adicionar checagem de que médias estão no intervalo do dicionário.
3. **Teste dos componentes de variância da conjunta.** Verificar que todos ≥ 0.
4. **docs/decisoes.md ainda não existe** (pendência herdada da etapa 03).

## Números conferidos

### Individual

| Ambiente | Média (kg/ha) | CV% | s²g | s²e | h² médias |
|---|---|---|---|---|---|
| PGO_2025_V | 10.381 | 4,88 | 110.605 | 256.784 | 0,4628 |
| SLG_2025_V | 9.205 | 5,42 | 129.229 | 248.949 | 0,5094 |
| UDI_2025_V | 12.152 | 5,20 | 145.467 | 398.804 | 0,4218 |

### Conjunta — componentes de variância

| Termo | Variância |
|---|---|
| genótipo | 84.647 |
| genótipo:ambiente | 43.696 |
| ambiente:bloco | 35.147 |
| Residual | 301.720 |

### Top 10 ranking DH25

| # | Genótipo | BLUP (kg/ha) |
|---|---|---|
| 1 | DH25_0030 | 11.023 |
| 2 | DH25_0046 | 11.012 |
| 3 | DH25_0165 | 11.004 |
| 4 | DH25_0259 | 10.925 |
| 5 | DH25_0074 | 10.918 |
| 6 | DH25_0369 | 10.890 |
| 7 | DH25_0009 | 10.855 |
| 8 | DH25_0281 | 10.821 |
| 9 | DH25_0229 | 10.803 |
| 10 | DH25_0073 | 10.783 |

## Veredicto

**APROVADO.** Todos os critérios de aceitação do PLANO.md cumpridos, regras do CLAUDE.md respeitadas, números geneticamente plausíveis.
