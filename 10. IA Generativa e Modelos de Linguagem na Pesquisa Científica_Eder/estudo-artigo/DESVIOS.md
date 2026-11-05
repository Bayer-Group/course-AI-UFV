# Desvios entre o modelo minimo e Meuwissen et al. (2001)

| Parametro             | Artigo                  | Modelo minimo      | Impacto esperado                       |
|-----------------------|-------------------------|--------------------|----------------------------------------|
| N individuos          | 2200 (200+2000)         | 200 (150+50)       | Menos dados → mais erro amostral       |
| N efeitos estimados   | ~50.000 haplotipos      | 100 marcadores     | Problema p>>n eliminado; LS viavel     |
| Tipo de marcador      | Haplotipos multialelicos| SNP bialelico 0/1/2| Menos informacao por locus             |
| N QTL                 | ~50 segregando (de 1000)| 5 (de 100)         | Mesma proporcao (~5%)                  |
| Distribuicao efeitos  | Gamma(1.66, 0.4)        | Normal              | Cauda menos pesada; QTL grandes raros  |
| Estrutura populacional| 1000 gen. drift, Ne=100 | Sem estrutura/LD    | Sem LD historico; marcadores independ. |
| Metodo bayesiano      | BayesA, BayesB (MCMC)   | Nao implementado   | Comparacao limitada a LS vs. RR-BLUP   |
| Fases de ligacao      | Haplotipos com fase     | Genotipos sem fase  | Informacao de fase ausente             |
| Replicatas            | 5 (LS, BLUP, BayesB)   | 1 (seed fixa)      | Sem erro-padrao entre replicatas       |

## Desvio mais critico

A ausencia de estrutura populacional e LD historico muda a natureza do
problema: no artigo, marcadores capturam QTL via LD populacional; no modelo
minimo, a associacao depende apenas do efeito direto dos marcadores que sao
QTL. Isso torna a simulacao um exercicio didatico de shrinkage, nao uma
reproducao do mecanismo de selecao genomica.
