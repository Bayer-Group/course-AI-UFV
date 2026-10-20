# Desvios entre nossa reprodução e o artigo

Meuwissen, Hayes & Goddard (2001) — Genetics 157:1819–1829

| Item | Artigo | Nossa reprodução | Motivo | Impacto esperado |
|------|--------|-----------------|--------|-----------------|
| n_marcadores | ~50.000 haplótipos | 100 marcadores | escala da aula | acurácia absoluta menor; padrão relativo deve ser preservado |
| n_fenotipicos | 2.200 (ger. 1001 + 1002) | 150 (treino) | escala da aula | IC das acurácias mais largo |
| estrutura populacional | 1000 gerações burn-in, Ne=100 | genótipos simulados diretamente | simplificação | sem estrutura de LD real; haplótipos não refletem deriva |
| n_repeticoes | não informado no artigo | 1 réplica (semente 2001) | tempo de aula | sem IC; comparação qualitativa apenas |
| métodos BayesA/BayesB | Gibbs + MH, 10.000 ciclos | não implementado | complexidade | apenas LS vs RR-BLUP comparados |
| fase de ligação | assumida conhecida | N/A (marcadores independentes) | simplificação | subestima LD entre marcadores e QTL |
