# Exame oral — Meuwissen, Hayes & Goddard (2001)

Examinador simulado: qualificacao em genetica quantitativa.
Regras: uma pergunta por vez, dificuldade crescente, avaliacao com pagina do artigo.

---

## Pergunta 1 (graus de liberdade)

**Pergunta:** Na simulacao deste artigo, quantos efeitos de haplotipos precisam
ser estimados e quantos registros fenotipicos estao disponiveis? Explique por
que isso impede o uso direto de minimos quadrados.

**Resposta do aluno:** ~50.000 marcadores, 2.200 observacoes. Como n < p, LS nao
consegue estimar.

**Avaliacao:** Parcialmente correta.
- [OK] 2.200 registros fenotipicos (p. 1821: "200 and 2000... animals").
- [OK] ~50.000 efeitos a estimar (p. 1821).
- [OK] Raciocinio correto: n < p impede estimacao simultanea por LS.
- [CORRIGIR] Precisao terminologica: nao sao 50.000 *marcadores*. Sao 1.010
  loci de marcadores (p. 1821: "1010 = 10 x 101 marker loci"). Os ~50.000 sao
  efeitos de *haplotipos* — cada segmento de 1 cM tem em media ~50 haplotipos
  distintos, e e o efeito de cada haplotipo que precisa ser estimado (p. 1821).
  A distincao importa: o numero de parametros depende da diversidade alelica,
  nao apenas do numero de loci.
- **Nota: 7/10** — ideia central correta, faltou precisao no que sao os parametros.

---

## Pergunta 2 (consequencia pratica do problema de LS)

**Pergunta:** Para contornar a falta de graus de liberdade, os autores usaram
um procedimento stepwise em LS. Mesmo assim, a acuracia foi baixa (r = 0.318)
e a regressao b foi apenas 0.285. O que significa, na pratica, um b muito
abaixo de 1? Se voce selecionasse o melhor animal pelo EBV de LS, o que
esperaria do valor genetico real dele?

**Resposta do aluno:** Se fizer selecao baseado no EBV, temos pouca chance de
refletir o real valor genetico.

**Avaliacao:** Correta na direcao, mas vaga — nao explorou o significado
especifico de b < 1.
- [OK] Entendeu que a selecao por LS seria ineficiente.
- [FALTOU] O artigo e preciso sobre o que b < 1 significa (p. 1824): "the EBV
  would need to be regressed back to their mean to become an unbiased predictor
  of the TBV; i.e., the estimated breeding values are too variable." Os EBV de
  LS sao *inflados* — a dispersao dos EBV e maior que a dos TBV.
- [FALTOU] A consequencia pratica: b = 0.285 significa que E(TBV | EBV) = 0.285
  x EBV. Se voce seleciona um animal com EBV = +2, seu TBV esperado e apenas
  ~0.57, nao 2. O ganho genetico realizado seria muito menor que o predito.
  Isso e *superestimacao sistematica* dos animais extremos, nao apenas
  imprecisao aleatoria (que seria capturada por r baixo).
- [FALTOU] A causa: LS seleciona efeitos por limiar de significancia, o que
  captura preferencialmente efeitos superestimados por acaso — o fenomeno de
  "winner's curse" ou vies de selecao (p. 1820: "selection of loci with the
  largest effects results in the selection of overpredicted effects").
- **Nota: 4/10** — captou a direcao mas nao o mecanismo nem a interpretacao
  quantitativa de b.

---

## Pergunta 3 (BLUP vs. Bayes)

**Pergunta:** O BLUP assume variancia igual para todos os segmentos
cromossomicos (sigma^2_gi = V_g / n). Por que, mesmo com essa premissa
claramente errada, o BLUP ainda atinge acuracia de 0.732 — muito superior ao
LS? E o que BayesB faz de diferente no tratamento das variancias que lhe
permite ir de 0.732 para 0.848?

**Resposta do aluno:** BLUP regressa os valores sobre a media, a estimativa deve
ser melhor que LS. BayesB por assumir priori diferente para os marcadores,
captura melhor a relacao entre marcador e valor estimado.

**Avaliacao:** Direcao correta em ambos os pontos, mas superficial nos
mecanismos.

Sobre BLUP vs. LS:
- [OK] BLUP encolhe (shrinkage) estimativas em direcao a zero — correto.
- [FALTOU] *Por que* isso ajuda: o artigo explica (Discussion, p. 1826) que
  BLUP "regresses estimates back toward zero, especially if there are few
  individuals carrying a particular haplotype". Isso controla a superestimacao
  que arruina o LS. Alem disso, BLUP ajusta *todos* os 1.000 segmentos
  simultaneamente — nao precisa selecionar QTL por limiar. Os QTL pequenos
  contribuem coletivamente, mesmo sem serem detectados individualmente
  (Discussion, p. 1825: "a correct positioning of QTL is not essential").

Sobre BayesB vs. BLUP:
- [OK] Mencionou a priori diferente.
- [FALTOU] Qual e essa priori e por que ela importa. O problema do BLUP e que
  o encolhimento e uniforme: QTL grandes sao *excessivamente* regredidos em
  direcao a zero (p. 1826: "the really big QTL will be too heavily regressed
  back to zero"). BayesB resolve isso com uma priori mista: prob p = 0.947 de
  sigma^2_gi = 0 e prob (1-p) de sigma^2_gi ~ chi^-2 invertida (p. 1822-1823).
  Isso permite que a maioria dos segmentos seja zerada (sem QTL), enquanto os
  poucos QTL grandes escapam do encolhimento excessivo. O artigo confirma
  (p. 1825): "BayesA and especially BayesB did identify the positions of the
  largest QTL, which probably contributed to its increased accuracy over BLUP."
- **Nota: 5/10** — entendeu que shrinkage e priori sao os conceitos-chave, mas
  nao articulou os mecanismos nem o problema especifico do BLUP com QTL grandes.

---

## Pergunta 4 (priori e robustez)

**Pergunta:** Os efeitos de QTL foram simulados com uma distribuicao gamma,
mas as prioris de BayesA e BayesB usam a chi-quadrado invertida. Mesmo com
essa discrepancia, BayesB atinge r = 0.848. Segundo o artigo, por que a
forma exata da priori tem pouca influencia no resultado? Que duas propriedades
a priori *precisa* ter para funcionar bem?

**Resposta do aluno:** Nao soube responder.

**Avaliacao:** O artigo responde diretamente na p. 1827 (Discussion):

> "The results of Table 2 indicate that (a) we need a proper prior distribution
> to avoid the overestimation problems of LS; and (b) the prior distribution
> should allow for small (or no) QTL effects with a high probability and for
> large QTL effects with a low probability, and the exact shape of the
> distribution seems of lesser importance."

As duas propriedades essenciais da priori sao:
1. Alta probabilidade de efeitos pequenos ou nulos.
2. Baixa probabilidade de efeitos grandes (mas nao zero).

A forma exata (gamma vs. chi-quadrado invertida) importa pouco porque ambas
compartilham essas duas propriedades — muita massa perto de zero, cauda longa.
O artigo reforça (p. 1827): "the inverted chi-square prior of BayesB did not
perfectly agree with the gamma distribution of the QTL effects", mas mesmo
assim BayesB superou os outros metodos.

Adicionalmente (p. 1827): as diferencas entre BLUP, BayesA e BayesB sao
"relatively small", o que indica que ate a priori mais simples (BLUP, variancia
igual) ja captura a maior parte do sinal.

- **Nota: 0/10** — ponto critico nao dominado. Revisar Discussion p. 1827.

---

## Pergunta 5 (decaimento da acuracia entre geracoes)

**Pergunta:** A Table 5 (p. 1827) mostra que a acuracia de BayesB cai de 0.848
na geracao 1003 para 0.718 na geracao 1008 — uma queda de ~5% por geracao.
Os autores afirmam que essa queda e *muito maior* do que se esperaria pela
taxa de recombinacao entre um QTL e seu marcador mais proximo (0.5%).
O que explica essa queda ser tao grande? E por que isso importa para
esquemas de selecao genomica com intervalos de geracao curtos?

**Resposta do aluno:** A quebra do equilibrio de ligacao entre marcador e QTL.

**Avaliacao:** Correta na essencia, mas nao explica por que a queda e *maior
que o esperado* — que era o ponto central da pergunta.

- [OK] Recombinacao quebra LD entre marcadores e QTL ao longo das geracoes.
- [FALTOU] O ponto-chave do artigo (p. 1827): se a queda fosse apenas pela
  recombinacao entre um QTL e seu marcador mais proximo (0.5 cM), seria de
  apenas ~0.5% por geracao — mas a queda observada e ~5%, dez vezes maior.
  O artigo explica: "more distant markers also contributed to the high accuracy
  of prediction of TBV. Or, putting it a different way, BayesB does not
  accurately predict the genetic value of individual 1-cM chromosome segments;
  instead it accurately predicts the total genetic value of larger chromosome
  segments (of, say, 4 cM or more), and therefore its accuracy reduces markedly
  as the large chromosome segments break up due to several generations of
  recombination." Ou seja, a predicao depende de *blocos grandes* (~4+ cM), e
  esses blocos se desfazem muito mais rapido que segmentos de 1 cM.
- [FALTOU] Implicacao para velogenetics (p. 1827): o decaimento de ~5%/geracao
  determina com que frequencia os efeitos de haplotipos precisam ser
  reestimados. Mesmo assim, r = 0.718 na geracao 1008 (6 geracoes depois) ainda
  e suficiente para viabilizar esquemas com intervalos de 6 meses (p. 1828).
- **Nota: 4/10** — conceito geral correto, mas nao distinguiu entre LD local
  (0.5%) e LD de segmentos grandes (~5%), que e a explicacao do artigo.

---

## Pergunta 6 (desequilibrio de ligacao e Ne)

**Pergunta:** A Table 4 (p. 1825) mostra o efeito de variar o espacamento dos
marcadores (1, 2 e 4 cM) sobre a acuracia. Os autores interpretam esses
resultados em termos do produto Ne*c (Discussion, p. 1826) e concluem que
Ne*c < 2 e necessario para acuracia proxima do maximo. Explique o que o
produto Ne*c representa biologicamente e por que ele e mais informativo do que
a distancia entre marcadores sozinha.

**Resposta do aluno:** Nao soube responder.

**Avaliacao:** O artigo explica na Discussion (p. 1826), citando Sved (1971):

> "Because linkage disequilibria are a function of Ne*c (Sved 1971; Goddard
> 1991), Table 4 may more generally be interpreted as investigating the effect
> of Ne*c on accuracy of prediction of TBV; i.e., the term 'marker distance'
> could be replaced by Ne*c, where c denotes distance between markers (in
> morgans)."

Ne*c representa o nivel esperado de desequilibrio de ligacao (LD) entre
marcadores e QTL. Biologicamente:
- Ne captura a historia demografica: populacoes pequenas mantem blocos de LD
  maiores (menos recombinacao efetiva ao longo da historia).
- c e a distancia genetica entre marcadores (em morgans).
- O produto Ne*c integra os dois: mesma distancia fisica em populacoes com Ne
  diferentes produz LD diferentes. Por isso, dizer "marcadores a cada 2 cM" so
  tem significado quando se conhece o Ne.

Resultado pratico (p. 1826): Ne*c < 2 (= 100 x 0.02) e necessario para
acuracia proxima do maximo. Uma populacao com Ne = 1000 precisaria de
marcadores a cada 0.2 cM para atingir o mesmo LD.

- **Nota: 0/10** — segundo conceito critico nao dominado. Revisar Discussion
  p. 1826 e a relacao entre LD e Ne*c (Sved 1971).

---

## Pergunta 7 (visao integrada)

**Pergunta:** O artigo menciona que um indice de selecao baseado em pedigree
daria acuracia de ~0.4 para animais sem registro proprio (p. 1824). BayesB
atinge 0.848. Considerando que esses animais nao tem fenotipo nem progenie,
explique de onde vem essa acuracia tao alta — que fonte de informacao os
marcadores estao capturando que o pedigree nao captura?

**Resposta do aluno:** *(teste encerrado a pedido do aluno)*

**Avaliacao:** *(nao avaliada)*

---

# AVALIACAO FINAL

## Resumo das notas

| Pergunta | Tema                          | Nota  |
|----------|-------------------------------|-------|
| 1        | Graus de liberdade            | 7/10  |
| 2        | Significado de b < 1          | 4/10  |
| 3        | BLUP vs. BayesB               | 5/10  |
| 4        | Robustez da priori            | 0/10  |
| 5        | Decaimento da acuracia        | 4/10  |
| 6        | Ne*c e LD                     | 0/10  |
| 7        | Marcadores vs. pedigree       | --    |
| **Media**|                               |**3.3/10**|

## Pontos dominados

1. **Dimensao do problema p >> n.** Entende que ~50.000 efeitos vs. 2.200
   registros impede LS convencional (faltou precisao terminologica: haplotipos
   vs. marcadores).

2. **Direcao geral dos metodos.** Sabe que BLUP usa shrinkage e que BayesB
   usa uma priori diferente, resultando em maior acuracia.

## Pontos NAO dominados (prioridade de revisao)

### Prioridade alta — conceitos que sustentam todo o artigo

1. **Significado quantitativo de b(TBV.EBV).** Nao basta saber que b < 1 e
   ruim. Precisa saber interpretar: b = 0.285 significa que o TBV esperado e
   apenas 28.5% do EBV. E superestimacao sistematica dos extremos (winner's
   curse), nao apenas imprecisao. Revisar: p. 1820 (causa) e p. 1824
   (resultado).

2. **Propriedades essenciais da priori.** O artigo lista duas (p. 1827):
   (a) alta probabilidade de efeitos nulos/pequenos, (b) baixa probabilidade
   de efeitos grandes. A forma exata (gamma vs. chi-quadrado invertida) importa
   pouco. Sem isso, nao se entende por que BayesB e robusto.

3. **Produto Ne*c como determinante do LD.** A distancia entre marcadores so
   tem significado quando multiplicada pelo Ne (Sved 1971). Ne*c < 2 e o
   limiar para acuracia proxima do maximo (p. 1826). Sem esse conceito, nao se
   generaliza os resultados do artigo para outras populacoes.

### Prioridade media — mecanismos especificos

4. **Mecanismo do shrinkage no BLUP vs. BayesB.** BLUP encolhe *todos* os
   efeitos uniformemente — bom para QTL pequenos, mas excessivo para QTL
   grandes (p. 1826). BayesB usa priori mista (spike-and-slab): zera a maioria
   dos segmentos mas preserva QTL grandes. Revisar: p. 1822-1823 (modelo) e
   p. 1825-1826 (discussao).

5. **Por que o decaimento da acuracia e ~5%/geracao e nao ~0.5%.** BayesB
   prediz o valor de blocos grandes (~4+ cM), nao de segmentos individuais de
   1 cM. Blocos grandes se desfazem mais rapido por recombinacao (p. 1827).
   Isso determina a frequencia de reestimacao em esquemas de velogenetics.

### Prioridade menor — nao perguntada, mas relevante

6. **Informacao dos marcadores vs. pedigree (Pergunta 7, nao respondida).**
   O pedigree captura apenas a *expectativa* de compartilhamento genetico entre
   parentes (50% pai-filho, 25% meio-irmaos). Os marcadores revelam o
   compartilhamento *realizado* — quais segmentos cromossomicos especificos
   cada animal herdou. Isso explica a diferenca entre acuracia 0.4 (pedigree)
   e 0.848 (BayesB). Referencia: Introduction p. 1819 e Discussion p. 1824.

## Recomendacao de estudo

Releia concentrando-se em tres paginas:
- **p. 1824** (Results, Table 2): interpretacao de r e b para cada metodo.
- **p. 1826** (Discussion): Ne*c, limitacoes do BLUP, papel do shrinkage.
- **p. 1827** (Discussion): robustez da priori e decaimento entre geracoes.
