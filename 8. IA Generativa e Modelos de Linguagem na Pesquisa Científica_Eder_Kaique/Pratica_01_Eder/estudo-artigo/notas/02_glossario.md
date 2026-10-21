# Glossário Técnico — Meuwissen, Hayes & Goddard (2001)

Organizado por ordem de aparição no artigo.
Rótulos: **[ARTIGO]** = o que o texto afirma; **[CONHECIMENTO GERAL]** = definição usual na
literatura; **⚠ DIFERENÇA** = quando há divergência ou nuance relevante.

---

## 1. Marker haplotype (haplótipo de marcador)

**[ARTIGO]** Combinação dos alelos dos marcadores que flanqueiam cada segmento de 1 cM.
Exemplo: se os marcadores flanqueadores têm alelos 2 e 3, o haplótipo é denominado "2_3".
O artigo usa haplótipos em vez de marcadores individuais porque segmentos cromossômicos com
o mesmo haplótipo raro provavelmente são idênticos por descendência (IBD) e carregam o mesmo
alelo de QTL. Cada segmento de 1 cM gera em média ~50 haplótipos distintos.
(Introdução, p. 1819; Methods, p. 1821)

**[CONHECIMENTO GERAL]** Sequência de alelos em loci ligados no mesmo cromossomo, transmitida
em bloco. O conceito de haplótipo de marcador para inferir IBD é central em mapeamento de
desequilíbrio de ligação (LD mapping).

---

## 2. QTL (Quantitative Trait Locus / locus de característica quantitativa)

**[ARTIGO]** Localizado no meio de cada centimorgan; pode tornar-se polimórfico por mutação
(taxa μ = 2,5 × 10⁻⁵ por locus por geração). Se polimórfico e com efeitos alélicos diferentes,
contribui para a variância genética do caráter. Efeitos assumidos **aditivos** (dominância = 0).
Distribuição dos efeitos mutacionais: Gamma(1,66; 0,4), com sinal ±0,5.
(Methods — Simulated data, pp. 1820–1821; Tabela 1, p. 1821)

**[CONHECIMENTO GERAL]** Região genômica cuja variação alélica está associada à variação em
um caráter quantitativo. Pode ter efeitos aditivos, dominantes e epistáticos (Lynch & Walsh 1998).

**⚠ DIFERENÇA** O artigo simplifica: dominância é explicitamente ignorada (definida como 0 na
simulação). Os autores justificam que efeitos aditivos ("average effects" de Falconer & Mackay
1996) são suficientes para predição de valores genéticos. (Discussion, p. 1826)

---

## 3. Linkage disequilibrium — LD (desequilíbrio de ligação)

**[ARTIGO]** Correlação entre alelos de marcadores e alelos de QTL que surge devido ao tamanho
finito da população (Ne = 100). Com marcadores suficientemente próximos do QTL, o LD persiste
entre famílias e permite seleção sem estabelecer a fase de ligação em cada família.
O artigo cita que LD é função de Ne·c (Sved 1971; Goddard 1991): para Ne = 100, espaçamento
de 2 cM (Ne·c = 2) ainda preserva LD suficiente para predição adequada.
(Introdução, p. 1819; Discussion, p. 1826; Tabela 4, p. 1825)

**[CONHECIMENTO GERAL]** Associação não-aleatória entre alelos em dois ou mais loci dentro de
uma população. Medido por D' ou r². Ocorre por deriva genética, seleção, mutação ou migração.
Decai com o tempo em função da recombinação.

---

## 4. IBD — Identity by Descent (identidade por descendência)

**[ARTIGO]** Dois segmentos cromossômicos são IBD quando descendem do mesmo ancestral sem
recombinação intermediária. O argumento central do artigo é que haplótipos de marcadores raros
e idênticos indicam IBD e, portanto, o mesmo alelo de QTL.
(Introdução, p. 1819)

**[CONHECIMENTO GERAL]** Dois alelos são IBD quando são cópias de um único alelo ancestral
comum. Conceito fundamental em genética quantitativa para calcular coeficientes de parentesco
(numerator relationship matrix, **A**).

---

## 5. BLUP — Best Linear Unbiased Prediction

**[ARTIGO]** Método de estimação de efeitos alélicos de haplótipos que assume variância igual
para todos os 1.000 segmentos de 1 cM: E(σ²_gi) = 0,001 (variância genética total / número
de segmentos). Implementado via equações de modelo misto (Henderson 1984). Acurácia obtida:
r_TBV;EBV = 0,732. O principal problema é que QTL grandes são excessivamente regredidos para
zero (*shrinkage* uniforme).
(Methods — BLUP estimation, p. 1822; Discussion, p. 1826)

**[CONHECIMENTO GERAL]** Procedimento de Henderson (1984) para predição de efeitos aleatórios
em modelos lineares mistos. Minimiza o erro quadrático médio de predição sob normalidade.
Amplamente usado em melhoramento animal como base do índice de seleção via matriz de
parentesco **A** (BLUP animal).

**⚠ DIFERENÇA** No artigo, o BLUP é aplicado a efeitos de **haplótipos de marcadores** (não
a valores genéticos de animais via **A**), assumindo que cada segmento de 1 cM tem igual
variância *a priori*. Isso é chamado às vezes de "RR-BLUP" (ridge regression BLUP) na
literatura posterior de seleção genômica — mas o artigo não usa essa denominação.

---

## 6. Least Squares — LS (mínimos quadrados)

**[ARTIGO]** Método de estimação que ajusta efeitos de haplótipos em etapas: (a) regressão
simples de segmento por segmento; (b) identificação de picos de log-verossimilhança com
critério equivalente a LOD ≥ 6; (c) estimação simultânea dos efeitos nos picos detectados.
Resultado: acurácia r = 0,318, com b_TBV;EBV = 0,285 (EBV sistematicamente superestimados).
(Methods — Least-squares estimation, pp. 1821–1822; Tabela 2, p. 1824)

**[CONHECIMENTO GERAL]** Estimação por minimização da soma de quadrados dos resíduos. Sem
regularização, é instável quando o número de parâmetros excede o número de observações
(problema p >> n).

**⚠ DIFERENÇA** O artigo usa LOD 6 (equivalente a 14 unidades de log-likelihood natural)
em vez do LOD 3 convencional em mapeamento de QTL, porque LOD 3 gerava muitos efeitos para
estimação simultânea. (Methods, p. 1821)

---

## 7. BayesA

**[ARTIGO]** Método bayesiano onde a variância de cada segmento, σ²_gi, segue *a priori* uma
distribuição qui-quadrado invertida escalonada χ⁻²(ν = 4,012; S = 0,0020), com média 0,001
e variância 1,675 × 10⁻⁴. A variância pode ser diferente em cada locus, mas a probabilidade
de σ²_gi = 0 é infinitesimal. Implementado via Gibbs sampling (10.000 ciclos, 1.000 de
burn-in). Custo computacional: ~2 semanas em Pentium 500.
(Methods — BayesA, p. 1822; Appendix, p. 1829)

**[CONHECIMENTO GERAL]** Denominação introduzida neste próprio artigo. Na literatura posterior
de seleção genômica (Habier et al. 2011 e outros), BayesA refere-se especificamente a este
modelo com *a priori* t-distribuição (ou qui-quadrado invertida) sem massa de probabilidade
em zero.

---

## 8. BayesB

**[ARTIGO]** Extensão de BayesA com *a priori* mista: σ²_gi = 0 com probabilidade π = 0,947
(segmento sem QTL segregante) e σ²_gi ~ χ⁻²(ν = 4,234; S = 0,0429) com probabilidade
(1 − π) = 0,053. A probabilidade π é derivada da proporção esperada de loci não segregantes
sob equilíbrio mutação-deriva. Implementado via algoritmo Metropolis-Hastings para amostrar
σ²_gi (não-conjugado) + Gibbs para gi. Custo: ~1 dia em Pentium 500.
Melhor acurácia: r = 0,848, b = 0,946.
(Methods — BayesB, pp. 1822–1823; Appendix, p. 1829)

**[CONHECIMENTO GERAL]** Na literatura posterior, BayesB é frequentemente reimplementado com
o hiperparâmetro π estimado a partir dos dados (em vez de fixado) e com variações nos
algoritmos MCMC. O conceito de "spike-and-slab" *a priori* que BayesB introduz tornou-se
família de métodos (BayesC, BayesCπ, BayesR etc.).

---

## 9. TBV — True Breeding Value (valor genético verdadeiro)

**[ARTIGO]** Valor genético verdadeiro do animal, conhecido na simulação. Usado para calcular
a acurácia das predições (r_TBV;EBV) e a regressão b_TBV;EBV.
(Methods — Comparison, p. 1823)

**[CONHECIMENTO GERAL]** Valor genético aditivo real de um indivíduo, definido como duas vezes
o desvio da média da progênie infinita em relação à média populacional (Falconer & Mackay 1996).
Na prática, nunca observado — apenas estimado.

**⚠ DIFERENÇA** No artigo, "TBV" é a soma dos efeitos genéticos aditivos **simulados**, não
o valor genético aditivo no sentido populacional clássico. Como os efeitos de QTL são aditivos
por definição na simulação, a distinção é irrelevante neste contexto, mas vale notar.

---

## 10. EBV — Estimated Breeding Value (valor genético estimado)

**[ARTIGO]** Calculado como û = μ·**1**₂₀₀₀ + **X**(1003)·**g**, onde **g** é o vetor de
efeitos de haplótipos estimados nas gerações 1001–1002 e **X**(1003) é a matriz de incidência
dos haplótipos da geração 1003. Novos haplótipos (por recombinação ou mutação) têm efeito
assumido igual a zero.
(Methods — Comparison, p. 1823)

**[CONHECIMENTO GERAL]** Predição do valor genético de um indivíduo a partir de dados
fenotípicos e de parentesco, obtida por BLUP ou métodos equivalentes. Expresso em unidades
da característica, centrado na média da população.

---

## 11. Accuracy of selection (acurácia de seleção)

**[ARTIGO]** Correlação r_TBV;EBV entre o TBV e o EBV dos animais da geração 1003.
Representa a precisão com que o EBV prediz o TBV quando a seleção é baseada em marcadores.
(Tabela 2, p. 1824; Discussion, p. 1824)

**[CONHECIMENTO GERAL]** Em teoria da seleção, a acurácia (r_AI) é a correlação entre o índice
de seleção e o valor genético verdadeiro. Determina o ganho genético via ΔG = i·r_AI·σ_A/L
(Falconer & Mackay 1996).

---

## 12. Ne — Effective population size (tamanho efetivo da população)

**[ARTIGO]** Parâmetro central da simulação: Ne = 100 durante 1.000 gerações para gerar
equilíbrio mutação-deriva. Determina o nível de LD: linkage disequilibria são função de
Ne·c (Sved 1971; Goddard 1991). Para Ne = 100, espaçamento de 2 cM (Ne·c = 2) é suficiente
para manter LD adequado para predição.
(Methods — Simulated data, p. 1820; Discussion, p. 1826; Tabela 4, p. 1825)

**[CONHECIMENTO GERAL]** Tamanho da população ideal (panmítica, sem seleção, sem migração)
que produziria a mesma taxa de deriva genética ou endogamia que a população real. Em bovinos
de leite, Ne histórico estimado em 100–200.

---

## 13. Mutation-drift balance (equilíbrio mutação-deriva)

**[ARTIGO]** Estado de equilíbrio entre novos alelos introduzidos por mutação e alelos perdidos
por deriva genética. Obtido após 1.000 gerações com Ne = 100. A heterozigosidade esperada
do QTL é E(H) = 4Ne·μ / (4Ne·μ + 1) = 0,0099.
(Methods — Simulated data, p. 1820; Appendix, p. 1829)

**[CONHECIMENTO GERAL]** Em populações de tamanho finito, a variância genética alcança um
platô quando a perda por deriva é compensada pelo input mutacional. Base teórica: Lynch &
Walsh (1998, cap. 12).

---

## 14. Gamma distribution (distribuição gamma para efeitos de QTL)

**[ARTIGO]** Distribuição dos efeitos aditivos mutacionais dos QTL. Parâmetros: escala = 1,66;
forma (shape) β = 0,4. O parâmetro de forma foi estimado por Hayes & Goddard (2000) a partir
de experimentos publicados de detecção de QTL em animais. Como a gamma produz apenas valores
positivos, o sinal do efeito é amostrado com probabilidade 0,5 de ser positivo ou negativo.
(Methods — Simulated data, p. 1820; Tabela 1, p. 1821)

**[CONHECIMENTO GERAL]** Distribuição contínua com suporte em (0, ∞), parametrizada por
escala e forma. Shape < 1 produz distribuição "L-shaped" — muitos efeitos pequenos e poucos
grandes — consistente com observações empíricas de QTL.

---

## 15. Prior distribution / scaled inverted chi-square
## (distribuição *a priori* / qui-quadrado invertida escalonada)

**[ARTIGO]** χ⁻²(ν, S) usada como *a priori* para σ²_gi. É uma escolha conjugada conveniente:
quando combinada com a verossimilhança dos dados (normal), a distribuição *a posteriori* é
também uma qui-quadrado invertida, facilitando o Gibbs sampling.
Post(σ²_gi | gi) = χ⁻²(ν + ni, S + gi′gi), onde ni é o número de efeitos de haplótipos no
segmento i.
(Methods — BayesA, p. 1822)

**[CONHECIMENTO GERAL]** A distribuição qui-quadrado invertida escalonada é a conjugada da
variância em modelos normais (Gelman et al., *Bayesian Data Analysis*). Parâmetro ν controla
a "força" do *a priori*; S controla a escala (média ≈ S/(ν − 2) para ν > 2).

---

## 16. Gibbs sampling

**[ARTIGO]** Algoritmo MCMC usado em BayesA para amostrar iterativamente efeitos de haplótipos
gi e variâncias σ²_gi de suas distribuições *a posteriori* condicionais. Rodado por 10.000
ciclos com 1.000 de burn-in.
(Methods — BayesA, p. 1822)

**[CONHECIMENTO GERAL]** Caso especial de Metropolis-Hastings onde cada variável é amostrada
de sua distribuição condicional completa. Converge para a distribuição *a posteriori* conjunta
quando as condicionais são conhecidas (Gilks et al. 1996).

---

## 17. Metropolis-Hastings algorithm

**[ARTIGO]** Usado em BayesB para amostrar σ²_gi, pois a distribuição *a posteriori*
p(σ²_gi | y*) não tem forma fechada conhecida (ao contrário de BayesA). A distribuição
*a priori* p(σ²_gi) é usada como distribuição "driver" (independent sampler). Roda 100
ciclos por cada passo da cadeia principal.
(Methods — BayesB, p. 1823)

**[CONHECIMENTO GERAL]** Algoritmo MCMC de propósito geral: propõe um novo valor de um parâmetro
e aceita com probabilidade Min[p(proposta)/p(atual), 1]. Não exige forma fechada da
*a posteriori* (Gilks et al. 1996).

---

## 18. Iteration on the data (iteração sobre os dados)

**[ARTIGO]** Técnica computacional (Schaeffer & Kennedy 1986) usada porque a matriz de
informação X′X com 50.000 efeitos não cabe na memória RAM. Após atualizar a solução de um
efeito, os lados direitos de todos os outros efeitos são ajustados. Custo computacional cresce
aproximadamente com o quadrado do número de efeitos.
(Discussion, p. 1827)

**[CONHECIMENTO GERAL]** Método iterativo para resolver sistemas de equações de modelo misto
de grande porte, equivalente ao algoritmo de Gauss-Seidel aplicado a equações de Henderson.

---

## 19. SNP — Single Nucleotide Polymorphism

**[ARTIGO]** O artigo projeta que haverá milhões de SNPs disponíveis via chips de DNA
(Halushka et al. 1999). Embora bialélicos (baixa informatividade individual), 3–5 SNPs
ligados em ~0,25 cM podem ser combinados em haplótipos com ~2³ = 8 alelos distintos,
aproximando os ~7 alelos por marcador usados na simulação.
(Introdução, p. 1819; Discussion, p. 1825)

**[CONHECIMENTO GERAL]** Variação de um único nucleotídeo entre indivíduos de uma espécie.
Marcador mais abundante e barato de genotipagem; base dos chips de alta densidade (50K, 770K)
que viabilizaram a seleção genômica na prática, a partir de 2007–2008.

---

## 20. Velogenetics

**[ARTIGO]** Esquema reprodutivo de George & Massey (1991) e Haley & Visscher (1998) citado
como aplicação das predições genômicas: coleta de oócitos de bezerras *in utero*, fertilização
*in vitro*, seleção pelo genótipo de marcadores e implantação em receptoras, com intervalo de
geração de 6 meses ou menos. O artigo mostra que a acurácia de BayesB permanece em 0,718
mesmo 6 gerações após a estimação dos efeitos (Tabela 5, p. 1827), viabilizando o esquema.
(Discussion, p. 1827)

**[CONHECIMENTO GERAL]** Conceito de encurtamento extremo do intervalo de gerações combinado
com seleção assistida por marcadores. Permaneceu teórico; na prática, a seleção genômica
convencional (com EBVs genômicos, sem velogenetics) tornou-se padrão na indústria leiteira.

---

## 21. b_TBV;EBV — Regressão do TBV sobre o EBV

**[ARTIGO]** Coeficiente de regressão linear do TBV (y) sobre o EBV (x). Deve ser igual a 1
para estimativas não-viesadas no sentido BLUP — E(u | û) = û — o que implica que o animal
com maior û tem TBV esperado igual a û. LS obteve b = 0,285 (EBVs inflados); BayesB obteve
b = 0,946, próximo ao ideal.
(Methods — Comparison, p. 1823; Tabela 2, p. 1824)

**[CONHECIMENTO GERAL]** Em teoria de seleção, b_TBV;EBV < 1 indica que o índice de seleção
superestima o valor genético de animais de mérito aparente alto — "regressão para a média"
é necessária para predicações não-viesadas. b > 1 indica subestimação.
