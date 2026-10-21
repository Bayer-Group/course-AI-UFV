# Relatório de reprodutibilidade

Meuwissen, Hayes & Goddard (2001) — *Genetics* 157:1819–1829

---

## 1. Pergunta científica central

> É possível predizer o valor genético total de um indivíduo usando apenas
> marcadores genômicos densos, sem mapeamento prévio de QTLs?

[ARTIGO] "The goal of this study was to predict the total genetic value of
individuals by using genome-wide dense marker maps" (Abstract, p. 1819).
A hipótese operacional é que, com densidade suficiente, todo QTL fica em
desequilíbrio de ligação com pelo menos um marcador — tornando o mapeamento
dispensável (Introdução, p. 1820).

---

## 2. O que o modelo mínimo reproduz e o que simplifica

### Reproduz

- A estrutura do problema: matriz de genótipos **X** (n × p), vetor de
  fenótipos **y**, e conjunto de teste sem fenótipo.
- Os dois estimadores comparados: LS (sem restrição) e RR-BLUP (com penalidade
  ridge), usando as mesmas fórmulas do artigo.
- O λ do RR-BLUP derivado de h² (Métodos, p. 1822):
  `λ = σ²_e / σ²_β = ((1−h²)/h²) × n_markers`.
- As métricas de avaliação: acurácia `r = cor(gv_true, gebv)` e coeficiente
  de regressão `b` da Tabela 2 (p. 1824).
- O **padrão qualitativo** esperado: LS inflado (b << 1, r baixo) vs
  RR-BLUP encolhido (b ≈ 1, r maior).

### Simplifica

- **Escala**: 100 marcadores e 200 indivíduos vs ~50.000 haplótipos e 2.200
  fenótipos.
- **Estrutura populacional**: genótipos simulados diretamente (sem burn-in de
  1.000 gerações com Ne = 100); marcadores são independentes entre si.
- **Métodos Bayesianos**: BayesA e BayesB não implementados — apenas LS e
  RR-BLUP.
- **Replicação**: uma única semente; o artigo apresenta médias consolidadas.

---

## 3. Critérios de comparação

Definidos antes da execução:

| Critério | Tolerância | Referência |
|---|---|---|
| Acurácia RR-BLUP | dentro de ±15% de r = 0.732 → intervalo [0.622, 0.842] | Tabela 2, geração 1003 |
| Ordenação dos métodos | r(LS) < r(RR-BLUP) obrigatório | Tabela 2, todas as gerações |
| Coeficiente b (LS) | b < 0.8 (EBVs inflados) | Tabela 2, b = 0.285 |
| Coeficiente b (RR-BLUP) | b > 0.8 (encolhimento adequado) | Tabela 2 |

> O critério de ordenação é inegociável: se LS ≥ RR-BLUP, há erro no código
> ou nas premissas, não apenas imprecisão de escala.

---

## 4. Desvios registrados

Resumo de `DESVIOS.md`:

| Item | Artigo | Modelo mínimo | Impacto |
|---|---|---|---|
| Marcadores | ~50.000 haplótipos | 100 marcadores | Acurácia absoluta menor; cobertura de QTLs muito reduzida |
| Fenótipos de treino | 2.200 | 150 | Variância dos estimadores maior; IC das acurácias mais largo |
| Estrutura populacional | 1.000 ger. burn-in, Ne = 100 | Genótipos independentes | Sem LD real; marcadores não "propagam" informação entre si |
| Replicações | Não informado (resultados consolidados) | 1 réplica (semente 2001) | Sem IC; comparação qualitativa apenas |
| BayesA / BayesB | Implementados (Gibbs + MH, 10.000 ciclos) | Não implementados | Teto de acurácia da Tabela 2 não atingível |
| Fase de ligação | Assumida conhecida | N/A (marcadores independentes) | Subestima benefício do LD marcador-QTL |

---

## 5. O que o modelo mínimo ensinou sobre o mecanismo

1. **O problema dos graus de liberdade é palpável**: com p > n, `solve(crossprod(X_tr))` falha
   ou se torna instável — é preciso adicionar λI para o sistema ter solução única.
   Isso traduz em código o argumento central do Abstract (p. 1819).

2. **O encolhimento muda o b, não apenas o r**: LS produz GEBVs com variância
   inflada (b << 1), o que tornaria a seleção ineficiente mesmo se a correlação
   parecesse razoável. RR-BLUP reduz a variância dos estimadores e aproxima b de 1.

3. **λ tem interpretação biológica direta**: `λ = σ²_e / σ²_β` é a razão entre
   variância do ambiente e variância por marcador — derivada diretamente de h² e
   do número de marcadores, sem hiperparâmetro livre.

4. **A escala importa para os valores absolutos, não para o padrão**: mesmo com
   100× menos marcadores e 15× menos dados, a ordenação LS < RR-BLUP se mantém,
   confirmando que o mecanismo (penalidade ridge) é robusto à escala.

---

## 6. Como executar do zero

```bash
# No terminal, dentro do diretório estudo-artigo:
Rscript R/10_modelo_minimo.R
```

```r
# Ou dentro de uma sessão R:
source("R/10_modelo_minimo.R")
```

Tempo esperado: < 5 segundos. Saída: tabela comparativa impressa no console
e figura com dois scatter plots (LS vs RR-BLUP).
