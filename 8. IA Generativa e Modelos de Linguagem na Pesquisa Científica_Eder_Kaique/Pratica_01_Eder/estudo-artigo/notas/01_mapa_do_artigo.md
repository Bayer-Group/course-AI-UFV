# Mapa do Artigo — Meuwissen, Hayes & Goddard (2001)

**Referência:** Meuwissen T.H.E., Hayes B.J., Goddard M.E. (2001). Prediction of Total Genetic
Value Using Genome-Wide Dense Marker Maps. *Genetics* 157: 1819–1829.

---

## 1. Pergunta científica central

**[ARTIGO]** É possível estimar com precisão o valor genético total de indivíduos sem registro
fenotípico próprio, a partir de um mapa denso de marcadores genômicos, quando o número de
efeitos de haplótipos a estimar (~50.000) supera em muito o número de observações fenotípicas
disponíveis?
(Abstract, p. 1819; Introdução, p. 1820)

---

## 2. Problema técnico que motivou o artigo (graus de liberdade)

**[ARTIGO]** Com espaçamento de 1 cM em um genoma de 1.000 cM, cada segmento gera em média
~50 haplótipos distintos, totalizando ~50.000 efeitos a estimar. O conjunto de dados tem apenas
2.200 registros fenotípicos (gerações 1001 e 1002):

> "we cannot estimate all effects simultaneously by least squares, and some stepwise procedure
> for including the effects needs to be adopted."
> (Methods — Least-squares estimation, p. 1821)

**[ARTIGO]** Com o método por etapas (LS), apenas ~15,4 haplótipos foram detectados em média,
gerando ~872 equações. Isso resulta em apenas 2.200/872 ≈ **2,5 graus de liberdade por efeito
estimado**, o que causa grandes erros de amostragem e superestimação dos efeitos selecionados.
(Results, p. 1824)

**[ARTIGO]** O mesmo problema de falta de graus de liberdade surge ao tentar estimar os efeitos
alélicos de todos os ~50.000 genes do genoma bovino/suíno quando estes forem mapeados via chips
de DNA.
(Introdução, p. 1820)

**[INFERÊNCIA]** Esse déficit de graus de liberdade é o núcleo técnico que motiva a comparação
entre os métodos: apenas abordagens que impõem regularização (BLUP, BayesA, BayesB) contornam
o problema de forma adequada.

---

## 3. Os quatro métodos comparados (nomes exatos do artigo)

**[ARTIGO]** (Methods, pp. 1821–1823; Abstract, p. 1819)

| # | Nome exato no artigo | Sigla |
|---|----------------------|-------|
| 1 | Least squares | LS |
| 2 | Best linear unbiased prediction | BLUP |
| 3 | Bayesian estimation: method BayesA | BayesA |
| 4 | Bayesian estimation: method BayesB | BayesB |

**[ARTIGO]** Diferença fundamental entre BayesA e BayesB: BayesA usa distribuição *a priori*
qui-quadrado invertida para σ²_gi em **todos** os loci (probabilidade infinitesimal de
σ²_gi = 0). BayesB usa um *a priori* misto — probabilidade π de σ²_gi = 0 (locus não
segregante) e qui-quadrado invertida com probabilidade (1 − π) — refletindo o fato de que
a maioria dos segmentos não contém QTL segregando.
(Methods — BayesB, p. 1822)

---

## 4. Métrica principal de resultado e como ela é calculada

**[ARTIGO]** A métrica principal é a **correlação entre o valor genético verdadeiro (TBV) e o
valor genético estimado (EBV)**: r_TBV;EBV, chamada de "accuracy of selection" pelos autores.
(Tabela 2, p. 1824)

**Como é calculada** (Methods — Comparison of true and estimated breeding values, p. 1823):

1. Para cada animal da geração 1003 (n = 2.000, sem fenótipo próprio), calcula-se o EBV:

       û = μ·**1**₂₀₀₀ + **X**(1003) · **g**

   onde **X**(1003) é a matriz de incidência dos haplótipos de marcadores para a geração 1003
   e **g** é o vetor de efeitos estimados por LS, BLUP ou Bayes nas gerações 1001–1002.

2. O valor genético verdadeiro **u** é conhecido na simulação.

3. Calcula-se a correlação de Pearson entre û e **u**.

**[ARTIGO]** Métrica secundária também reportada: **regressão b_TBV;EBV** (TBV sobre EBV),
que deve ser igual a 1 para estimativas não-viesadas no sentido BLUP — E(u | û) = û.
(p. 1823)

**[ARTIGO]** Resultados (Tabela 2, p. 1824 — média de 5 réplicas, exceto BayesA com 1 réplica):

| Método | r_TBV;EBV ± EP  | b_TBV;EBV ± EP  |
|--------|-----------------|-----------------|
| LS     | 0,318 ± 0,018   | 0,285 ± 0,024   |
| BLUP   | 0,732 ± 0,030   | 0,896 ± 0,045   |
| BayesA | 0,798           | 0,827           |
| BayesB | 0,848 ± 0,012   | 0,946 ± 0,018   |

---

## 5. As quatro conclusões numeradas dos autores

Transcritas da seção **CONCLUSIONS** (p. 1828), com a evidência empírica que as sustenta.

---

### Conclusão 1

**[ARTIGO]**
> "By using a dense marker map covering all chromosomes, it is possible to accurately estimate
> the breeding value of animals that have no phenotypic record of their own and no progeny."
> (Conclusions, item 1, p. 1828)

**Sustentação:** **Tabela 2** (p. 1824) — BLUP (r = 0,732), BayesA (r = 0,798) e BayesB
(r = 0,848) foram obtidos para animais da geração 1003, que não tinham registro fenotípico
próprio nem progênie com fenótipos. Para comparação, um índice baseado em pedigree resultaria
em acurácia de ~0,4. (Discussion, p. 1824)

---

### Conclusão 2

**[ARTIGO]**
> "This requires the estimation of a large number of marker haplotype effects. Using least
> squares, all haplotype effects could not be estimated simultaneously. Even when only the
> largest effects were included, they were overestimated and the accuracy of predicting
> breeding value was low."
> (Conclusions, item 2, p. 1828)

**Sustentação:** **Tabela 2** — LS: r = 0,318 e b = 0,285 (EBV sistematicamente
superestimados). **Figura 1** (p. 1823) — o LS-likelihood oscilou muito com muitos falsos
positivos; o método detectou 18 QTL enquanto havia apenas 8 com σ²_gi > 2% da variância
genética total, e o número efetivo de d.f. por efeito estimado foi ~2,5. (Results, p. 1824)

---

### Conclusão 3

**[ARTIGO]**
> "Methods that assumed a prior distribution for the variance associated with each chromosome
> segment gave more accurate predictions of breeding values even when the prior was not correct."
> (Conclusions, item 3, p. 1828)

**Sustentação:** **Tabela 2** — BayesB (r = 0,848) e BayesA (r = 0,798) superaram BLUP
(r = 0,732). O *a priori* qui-quadrado invertido de BayesB não coincide exatamente com a
distribuição gamma simulada dos efeitos de QTL, mas a acurácia permaneceu alta. (Discussion,
p. 1827: "the effect of using an incorrect prior distribution of σ²_gi on the accuracy of
selection seems to be small.")

**[INFERÊNCIA]** O resultado valida a robustez bayesiana: permitir que a variância varie entre
loci é mais importante do que acertar a forma exata da distribuição *a priori*.

---

### Conclusão 4

**[ARTIGO]**
> "Selection on breeding values predicted from markers could substantially increase the rate of
> genetic gain in animals and plants especially if combined with reproductive techniques to
> shorten the generation interval."
> (Conclusions, item 4, p. 1828)

**Sustentação:** **Tabela 5** (p. 1827) — a acurácia de BayesB permanece alta por várias
gerações após a estimação dos efeitos (r = 0,848 na geração 1003, declinando para 0,718 na
geração 1008), sustentando a viabilidade de esquemas "velogenetics" com reestimação periódica.
**[ARTIGO]** A queda de ~5% por geração entre as gerações 1003–1005 é maior do que a esperada
pela taxa de recombinação com os marcadores mais próximos (0,5%), indicando que marcadores mais
distantes também contribuem para a predição. (Discussion, p. 1827)

---

## Notas de contexto

**[INFERÊNCIA]** Toda a comparação é feita em **dados simulados** (Tabela 1, p. 1821).
Os valores quantitativos de acurácia são válidos para as condições da simulação:
Ne = 100, h² = 0,5, espaçamento de 1 cM, 2.200 registros, 10 cromossomos de 100 cM.

**[ARTIGO]** Os marcadores simulados se assemelham a microssatélites multialélicos; os autores
argumentam que 3–5 SNPs bialélicos combinados em haplótipos de ~0,25 cM reproduzem o mesmo
número efetivo de alelos (~7) usado na simulação. (Discussion, p. 1825)

**[ARTIGO]** BayesA exigiu ~2 semanas de CPU (Pentium 500); BayesB exigiu ~1 dia, pois em cada
ciclo da cadeia MCMC muitos segmentos têm σ²_gi = 0 e não entram nas equações.
(Discussion, p. 1827)
