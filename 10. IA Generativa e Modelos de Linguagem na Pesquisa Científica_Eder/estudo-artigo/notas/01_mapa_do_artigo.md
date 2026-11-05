# Mapa do artigo: Meuwissen, Hayes & Goddard (2001)

## 1. Pergunta cientifica central

**[ARTIGO]** E possivel estimar com acuracia o valor genetico total de individuos
sem registros fenotipicos proprios ou de progenie, usando apenas marcadores
moleculares densos cobrindo todo o genoma? (Abstract, p. 1819)

## 2. Problema tecnico: graus de liberdade

**[ARTIGO]** Um mapa denso de marcadores define um numero muito grande de
segmentos cromossomicos cujos efeitos precisam ser estimados --- neste caso,
~50.000 efeitos de haplotipos --- a partir de apenas 2.200 registros fenotipicos.
Nao ha graus de liberdade suficientes para ajustar todos os efeitos
simultaneamente por minimos quadrados (Introduction, p. 1819-1820; tambem
Lande & Thompson 1990, citado na p. 1820).

**[INFERENCIA]** Esse e um problema classico de "p >> n": mais parametros que
observacoes. Os autores enquadram a questao como uma limitacao de graus de
liberdade, que e a forma como a genetica quantitativa descreve o mesmo fenomeno.

## 3. Os quatro metodos comparados (nomes exatos)

Os nomes usados no artigo sao (Methods, p. 1821-1823; Table 2, p. 1824):

1. **Least squares (LS)** --- regressao stepwise com deteccao de QTL por
   picos de verossimilhanca (LOD >= 6) e ajuste simultaneo apenas dos QTL
   selecionados (p. 1821).
2. **BLUP** (Best Linear Unbiased Prediction) --- equacoes de modelos mistos
   com variancia igual para todos os 1.000 segmentos de 1 cM,
   Var(g_i) = V_g/n (p. 1822).
3. **BayesA** --- metodo bayesiano com priori chi-quadrado invertida escalada
   para a variancia de cada segmento, permitindo que as variancias difiram
   entre loci (p. 1822).
4. **BayesB** --- metodo bayesiano que acrescenta ao BayesA uma probabilidade
   p (~0.947) de que o segmento tenha variancia zero, usando um passo
   Metropolis-Hastings para amostrar conjuntamente variancia e efeito
   (p. 1822-1823).

## 4. Metrica principal de resultado

**[ARTIGO]** A metrica principal e a **correlacao entre o valor genetico verdadeiro
(TBV) e o valor genetico estimado (EBV)** nos animais da geracao 1003, denotada
r(TBV, EBV). Essa correlacao equivale a acuracia de selecao (Table 2, p. 1824;
Methods, p. 1823).

Calculo: os EBV da geracao 1003 sao obtidos por
`EBV = mu * 1_2000 + X_(1003) * g_hat`, onde X_(1003) e a matriz de
incidencia dos haplotipos na geracao 1003 e g_hat e o vetor de efeitos de
haplotipos estimados nos metodos (p. 1823). Como na simulacao os TBV sao
conhecidos, a correlacao de Pearson entre TBV e EBV e calculada diretamente.

**[ARTIGO]** Uma metrica complementar e a regressao de TBV sobre EBV
(b_TBV.EBV), que deve ser 1 se as estimativas forem nao-viesadas no sentido
BLUP (Table 2, p. 1824).

## 5. Conclusoes dos autores

As quatro conclusoes estao na secao "Conclusions" (p. 1828-1829):

### Conclusao 1
**[ARTIGO]** Usando um mapa denso de marcadores cobrindo todos os cromossomos,
e possivel estimar com acuracia o valor genetico de animais sem registro
fenotipico proprio e sem progenie.

- **Evidencia:** Table 2 (p. 1824) --- BayesB atinge r(TBV,EBV) = 0.848 na
  geracao 1003, comparavel a um teste de progenie. Para referencia, um indice
  de selecao baseado em pedigree daria acuracia de ~0.4 (Discussion, p. 1824).

### Conclusao 2
**[ARTIGO]** A estimacao requer ajustar muitos efeitos de haplotipos. Por
minimos quadrados, nao e possivel estima-los simultaneamente; mesmo incluindo
apenas os maiores efeitos, eles sao superestimados e a acuracia e baixa.

- **Evidencia:** Table 2 (p. 1824) --- LS atinge apenas r = 0.318 e
  b_TBV.EBV = 0.285 (regressao muito abaixo de 1, indicando superestimacao).
  Figure 1 (p. 1823) --- a verossimilhanca de LS flutua muito mais que a
  probabilidade posterior de BayesB, gerando falsos positivos.

### Conclusao 3
**[ARTIGO]** Metodos que assumem uma distribuicao a priori para a variancia de
cada segmento cromossomico produzem predicoes mais acuradas, mesmo quando a
priori nao e exata.

- **Evidencia:** Table 2 (p. 1824) --- BayesA (r = 0.798) e BayesB
  (r = 0.848) superam BLUP (r = 0.732), que por sua vez supera LS (r = 0.318).
  A priori chi-quadrado invertida de BayesB nao corresponde exatamente a
  distribuicao gamma dos efeitos de QTL simulados, mas a acuracia ainda e alta
  (Discussion, p. 1827).

### Conclusao 4
**[ARTIGO]** A selecao baseada em valores geneticos preditos por marcadores pode
aumentar substancialmente o ganho genetico em animais e plantas, especialmente
se combinada com tecnicas reprodutivas que encurtem o intervalo de geracao.

- **Evidencia:** Table 5 (p. 1827) --- a acuracia de BayesB decai de 0.848 na
  geracao 1003 para 0.718 na geracao 1008 (~5% por geracao), o que sustenta a
  viabilidade de esquemas de "velogenetics" com intervalos de geracao de 6 meses
  ou menos (Discussion, p. 1827-1828).
