# Glossario tecnico: Meuwissen, Hayes & Goddard (2001)

---

### QTL (Quantitative Trait Locus / Loci)

**[ARTIGO]** Locus no genoma onde uma mutacao pode ocorrer e, se polimorfico
e com efeitos alelicos diferentes, contribui para a variancia genetica da
caracteristica. Na simulacao, ha um QTL no meio de cada centimorgan,
totalizando 1.000 QTL potenciais (p. 1820, Table 1).

**[CONHECIMENTO GERAL]** Regiao do genoma associada a variacao em uma
caracteristica quantitativa. O termo e estatistico --- refere-se a uma posicao
no mapa, nao necessariamente a um gene isolado.

---

### SNP (Single Nucleotide Polymorphism)

**[ARTIGO]** Mencionado como o tipo de marcador que a tecnologia de DNA chips
tornara viavel em larga escala. Os autores notam que SNPs sao bialelicos e
com taxa de mutacao mais baixa que os marcadores simulados; 3-5 SNPs ligados
podem ser agrupados em haplotipos multialelicos equivalentes (p. 1819, 1825).

**[CONHECIMENTO GERAL]** Variacao de um unico nucleotideo em uma posicao do
genoma, com frequencia do alelo menor >= 1% na populacao. E o tipo de marcador
mais abundante e o padrao em chips de genotipagem modernos.

---

### Haplotype (haplotipo)

**[ARTIGO]** Combinacao dos alelos dos marcadores que flanqueiam cada segmento
de 1 cM. Exemplo: se os alelos flanqueadores sao 2 e 3, o haplotipo e "2_3".
A simulacao gerou em media ~50 haplotipos distintos por segmento, totalizando
~50.000 efeitos a estimar (p. 1821).

**[CONHECIMENTO GERAL]** Conjunto de alelos em loci proximos de um mesmo
cromossomo, herdados em bloco. Na genomica moderna o termo se aplica tambem a
blocos de SNPs em desequilibrio de ligacao.

---

### Linkage Disequilibrium (LD / desequilibrio de ligacao)

**[ARTIGO]** Devido ao tamanho efetivo finito (Ne = 100), os haplotipos de
marcadores estao em LD com os QTL situados entre eles. E o mecanismo que
permite que marcadores capturem efeitos de QTL sem necessidade de estabelecer
fase de ligacao por familia (p. 1819). A relacao LD ~ f(Ne * c) e discutida
com base em Sved (1971): Ne * c < 2 e necessario para acuracia proxima do
maximo (p. 1826).

**[CONHECIMENTO GERAL]** Associacao nao-aleatoria entre alelos em loci
diferentes. Em populacoes finitas, LD surge por deriva, fundacao e selecao, e
decai com a distancia genetica e o numero de geracoes de recombinacao.

---

### Effective Population Size (Ne / tamanho efetivo populacional)

**[ARTIGO]** Fixado em Ne = 100 durante as 1.000 geracoes de equilibrio
mutacao-deriva. Determina o nivel de LD e a heterozigosidade esperada dos QTL:
E(H) = 4Ne*mu / (4Ne*mu + 1) = 0.0099 (p. 1820, Table 1, Appendix p. 1828).

**[CONHECIMENTO GERAL]** Numero de individuos em uma populacao ideal de
Wright-Fisher que produziria a mesma taxa de deriva genetica observada na
populacao real. Populacoes reais tem Ne muito menor que o censo.

---

### Centimorgan (cM)

**[ARTIGO]** Unidade de distancia genetica usada para definir os segmentos
cromossomicos. O genoma simulado tem 1.000 cM (10 cromossomos x 100 cM),
com marcadores a cada 1 cM (p. 1820).

**[CONHECIMENTO GERAL]** Unidade de distancia de mapa correspondente a 1% de
probabilidade de recombinacao por meiose. 1 Morgan = 100 cM.

---

### IBD (Identical by Descent / identico por descendencia)

**[ARTIGO]** Segmentos cromossomicos que carregam o mesmo haplotipo raro de
marcadores provavelmente sao IBD e portanto portam o mesmo alelo de QTL
(p. 1819).

**[CONHECIMENTO GERAL]** Dois segmentos sao IBD se derivam de um mesmo
ancestral comum sem mutacao intermediaria. Distingue-se de IBS (identical by
state), onde a sequencia e igual mas a origem pode ser independente.

---

### Breeding Value (valor genetico / TBV / EBV)

**[ARTIGO]** TBV = true breeding value, o valor genetico aditivo verdadeiro do
individuo na simulacao. EBV = estimated breeding value, predito a partir dos
marcadores. A acuracia e medida pela correlacao r(TBV, EBV) e pelo coeficiente
de regressao b(TBV.EBV) (Table 2, p. 1824; Methods p. 1823).

**[CONHECIMENTO GERAL]** Valor genetico aditivo de um individuo: o dobro do
desvio esperado da media da progenie em relacao a media da populacao (Falconer
& Mackay 1996). Em melhoramento, EBV e a base para decisoes de selecao.

---

### BLUP (Best Linear Unbiased Prediction)

**[ARTIGO]** Usado aqui para estimar efeitos de haplotipos assumindo variancia
igual para todos os segmentos: Var(g_i) = V_g/n = 0.001. Requer apenas uma
variancia a estimar. Resolvido pelas equacoes de modelos mistos de Henderson
(1984) (p. 1820, 1822).

**[CONHECIMENTO GERAL]** Metodo de Henderson (1984) para predizer efeitos
aleatorios em modelos mistos, minimizando o erro quadratico medio da predicao.
Na avaliacao genetica classica, os efeitos aleatorios sao os valores geneticos
dos animais, nao efeitos de marcadores.

**Diferenca:** No uso classico, BLUP prediz valores geneticos de animais via
parentesco (matriz A). Aqui, BLUP prediz efeitos de segmentos cromossomicos,
tratando cada haplotipo como efeito aleatorio com variancia comum.

---

### Accuracy of Selection (acuracia de selecao)

**[ARTIGO]** Correlacao r(TBV, EBV). Para LS = 0.318, BLUP = 0.732,
BayesA = 0.798, BayesB = 0.848. Um indice de selecao baseado em pedigree
daria ~0.4 (Table 2, p. 1824).

**[CONHECIMENTO GERAL]** Correlacao entre o valor genetico verdadeiro e o
critério de selecao. Quanto maior, maior a resposta a selecao (R = i * r * sigma_A).

---

### Prior Distribution (distribuicao a priori)

**[ARTIGO]** BayesA usa uma chi-quadrado invertida escalada x^-2(4.012, 0.0020)
como priori para sigma^2_gi, com media 0.001 e variancia 1.675e-4 (p. 1822,
Appendix p. 1829). BayesB acrescenta uma massa de probabilidade p = 0.947
em sigma^2_gi = 0, com x^-2(4.234, 0.0429) para sigma^2_gi > 0 (p. 1822-1823,
Appendix p. 1829).

**[CONHECIMENTO GERAL]** Distribuicao que expressa a crenca sobre um parametro
antes de observar os dados. Na inferencia bayesiana, e atualizada pela
verossimilhanca para gerar a distribuicao a posteriori.

---

### Posterior Distribution (distribuicao a posteriori)

**[ARTIGO]** A posteriori de sigma^2_gi dado g_i e tambem chi-quadrado invertida
escalada: x^-2(nu + n_i, S + g_i'g_i), combinando informacao da priori e dos
dados (p. 1822).

**[CONHECIMENTO GERAL]** Distribuicao de um parametro apos incorporar a
evidencia dos dados, proporcional a priori x verossimilhanca (teorema de Bayes).

---

### Gibbs Sampling (amostragem de Gibbs)

**[ARTIGO]** Algoritmo MCMC usado em BayesA e na parte dos efeitos de BayesB.
Cada efeito g_ij e amostrado da sua distribuicao condicional completa
(normal), e cada sigma^2_gi da posteriori chi-quadrado invertida. Rodado por
10.000 ciclos, descartando os primeiros 1.000 como burn-in (p. 1822).

**[CONHECIMENTO GERAL]** Algoritmo MCMC que amostra cada variavel da sua
distribuicao condicional completa, mantendo as demais fixas. Converge para a
distribuicao conjunta a posteriori.

---

### Metropolis-Hastings

**[ARTIGO]** Usado em BayesB especificamente para amostrar sigma^2_gi a partir
de p(sigma^2_gi | y*), que nao tem forma fechada conhecida. A priori p(sigma^2_gi)
serve como distribuicao propositora (independence sampler). Rodado por 100
ciclos internos a cada ciclo do Gibbs (p. 1822-1823).

**[CONHECIMENTO GERAL]** Algoritmo MCMC genérico que propoe um novo valor a
partir de uma distribuicao propositora e aceita/rejeita com probabilidade
baseada na razao de verossimilhancas. O Gibbs sampler e um caso especial.

---

### Burn-in

**[ARTIGO]** Os primeiros 1.000 ciclos dos 10.000 do MCMC foram descartados,
determinados por inspecao grafica (p. 1822).

**[CONHECIMENTO GERAL]** Periodo inicial de um MCMC em que a cadeia ainda nao
convergiu para a distribuicao estacionaria. Amostras desse periodo sao
descartadas.

---

### LOD Score

**[ARTIGO]** O metodo LS usa o equivalente a LOD >= 6 (14 unidades de
log-verossimilhanca em log natural) para declarar um pico de QTL. Os autores
notam que o convencional LOD = 3 gerava efeitos demais para estimacao
simultanea (p. 1821).

**[CONHECIMENTO GERAL]** Logaritmo (base 10) da razao de verossimilhancas
entre ligacao e nao-ligacao. LOD >= 3 e o limiar classico em mapeamento de
ligacao (equivale a ~14 unidades em ln).

**Diferenca:** Os autores usam LOD >= 6 (muito mais restritivo que o padrao 3),
justificado pela necessidade de reduzir o numero de efeitos ajustados
simultaneamente.

---

### Gamma Distribution (distribuicao gama)

**[ARTIGO]** Usada para simular os efeitos mutacionais dos QTL, com parametro
de forma beta = 0.4 e escala 1.66, baseada na revisao de Hayes & Goddard
(2001). O sinal do efeito e sorteado com probabilidade 0.5 (p. 1820, Table 1).

**[CONHECIMENTO GERAL]** Distribuicao continua em [0, infinito) com parametros
de forma (alpha ou beta) e escala. Forma < 1 gera uma distribuicao em L com
muitos valores pequenos e poucos grandes --- compativel com a expectativa de
muitos QTL de efeito pequeno.

---

### Scaled Inverted Chi-Square Distribution (chi-quadrado invertida escalada)

**[ARTIGO]** Usada como priori para as variancias dos segmentos em BayesA e
BayesB. Escolha conveniente porque a posteriori tambem e chi-quadrado invertida
escalada (distribuicao conjugada). Parametros derivados no Appendix: BayesA
x^-2(4.012, 0.0020), BayesB x^-2(4.234, 0.0429) (p. 1822, Appendix p. 1829).

**[CONHECIMENTO GERAL]** Se X ~ chi^2(nu), entao 1/X segue uma chi-quadrado
invertida. A versao escalada inclui um parametro S. E a priori conjugada para
a variancia de uma normal com media conhecida, por isso e padrao em modelos
bayesianos de variancias.

---

### Heritability (herdabilidade)

**[ARTIGO]** Fixada em h^2 = 0.5 na simulacao (variancia genetica = 1,
variancia ambiental = 1). Os autores notam que com menor herdabilidade, o
numero de registros precisa ser proporcionalmente maior para manter a acuracia
(Discussion, p. 1826).

**[CONHECIMENTO GERAL]** Proporcao da variancia fenotipica devida a diferencas
geneticas aditivas: h^2 = V_A / V_P. Determina a resposta a selecao no
sentido estrito.

---

### Mutation-Drift Balance (equilibrio mutacao-deriva)

**[ARTIGO]** A populacao foi simulada por 1.000 geracoes com Ne = 100 para
atingir equilibrio entre novas mutacoes e perda por deriva. A variancia
mutacional adicionada por geracao e sigma^2_m = 5e-3 (p. 1820, Appendix
p. 1828).

**[CONHECIMENTO GERAL]** Estado estacionario em que a variancia genetica
introduzida por mutacao e equilibrada pela perda por deriva genetica. O nivel
de variancia de equilibrio depende de Ne e da taxa de mutacao.

---

### Velogenetics

**[ARTIGO]** Esquema proposto por Georges & Massey (1991) onde oocitos sao
colhidos de bezerras in utero, maturados in vitro, fertilizados e selecionados
por genotipos de marcadores, resultando em intervalos de geracao de 6 meses ou
menos. A acuracia de BayesB na geracao 1008 (r = 0.718, Table 5) sustenta a
viabilidade desses esquemas (p. 1827).

**[CONHECIMENTO GERAL]** Termo cunhado para a combinacao de tecnologias
reprodutivas avancadas com selecao assistida por marcadores para reduzir
drasticamente o intervalo de geracao. Precursor conceitual da selecao genomica
com tecnologias reprodutivas modernas (OPU/PIV, JIVET).

---

### REML (Restricted/Residual Maximum Likelihood)

**[ARTIGO]** Mencionado como alternativa para estimar a variancia genetica
total dentro de cada replicata, em vez de usar a variancia esperada. Tambem
cogitado para estimar variancias individuais dos segmentos, mas rejeitado como
computacionalmente tao custoso quanto BayesB (p. 1826).

**[CONHECIMENTO GERAL]** Metodo de estimacao de componentes de variancia que
corrige o vies de ML ao contabilizar a perda de graus de liberdade na estimacao
dos efeitos fixos (Patterson & Thompson 1971).

---

### Selection Index (indice de selecao)

**[ARTIGO]** Usado como referencia: um indice baseado em pedigree daria
acuracia de ~0.4 para animais sem registro proprio (p. 1824). Os resultados
dos metodos bayesianos superam amplamente esse valor.

**[CONHECIMENTO GERAL]** Combinacao linear otima de fontes de informacao
(registros do individuo, parentes, progenie) para predizer o valor genetico,
ponderada pelas covariancias geneticas e fenotipicas (Hazel 1943).

---

### Iteration on Data (iteracao sobre os dados)

**[ARTIGO]** Tecnica de Schaeffer & Kennedy (1986) usada para resolver os
modelos sem armazenar a matriz X'X inteira na memoria, necessaria porque os
~50.000 efeitos tornavam X'X grande demais. O tempo computacional cresce
aproximadamente de forma quadratica com o numero de efeitos (p. 1827).

**[CONHECIMENTO GERAL]** Metodo iterativo onde, a cada passo, os dados sao
relidos para atualizar as solucoes das equacoes de modelos mistos, eliminando
a necessidade de montar e inverter matrizes de coeficientes explicitamente.
