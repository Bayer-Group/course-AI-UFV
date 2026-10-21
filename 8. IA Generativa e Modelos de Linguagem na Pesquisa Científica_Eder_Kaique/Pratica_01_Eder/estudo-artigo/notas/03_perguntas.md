# Registro de Perguntas — Exame sobre Meuwissen et al. (2001)

Formato: pergunta → resposta do candidato → avaliação com fonte no artigo.

---

## Diagnóstico final

| Tema | Domínio |
|------|---------|
| Princípio geral do déficit de d.f. | ✓ |
| Números exatos do artigo (50k efeitos, 2200 registros, 2,5 d.f.) | ✗ |
| Viés de seleção como mecanismo de superestimação no LS | ✗ |
| BLUP: suposição de variância uniforme | ✓ |
| BLUP: mecanismo de shrinkage como explicação do funcionamento | ✗ |
| BayesA vs. BayesB: diferença estrutural (spike em zero) | ✓ |
| Quantificação: π = 0,947 dos segmentos sem QTL | ◐ |
| Gibbs sampling: armadilha bidirecional em BayesB | ◐ |
| Solução Metropolis-Hastings em BayesB | ✗ |
| Declínio de acurácia: argumento quantitativo 0,5% vs 5% | ✗ |
| O que BayesB realmente estima (blocos IBD > 1 cM) | ✗ |

**Pontos prioritários para revisão:**
1. Os números concretos da simulação — devem sair de memória numa qualificação
2. Viés de seleção (winner's curse) como mecanismo do LS — não confundir com multicolinearidade
3. Shrinkage do BLUP — é o mecanismo que explica tanto o funcionamento quanto a limitação
4. O insight da Tabela 5: BayesB prediz blocos IBD, não segmentos de 1 cM

---

## P6 — Tabela 5 e declínio da acurácia

**Pergunta:** A queda de acurácia ao longo das gerações é "much larger than expected based
on the recombination rate between a QTL and its nearest markers." Por que? O que isso revela
sobre o que o BayesB está realmente estimando?

**Resposta do candidato:** "os marcadores nem sempre estão exatamente no gene que expressa
o fenótipo, então ao longo das gerações as recombinações podem afetar o equilíbrio e não
mais refletir o que foi estimado antes"

**Avaliação:** Parcial — conceito geral correto, insight central ausente.
A resposta descreve o mecanismo geral (recombinação desfaz LD) mas não explora a contradição
quantitativa que o artigo usa para fazer um ponto mais profundo. O QTL está a apenas 0,5 cM
dos marcadores mais próximos → taxa de recombinação esperada ≈ 0,5% por geração → queda
esperada ≈ 0,5%/geração. A queda observada é ~5%/geração. A discrepância ×10 revela que
BayesB não prediz segmentos individuais de 1 cM, mas blocos IBD maiores (~4 cM ou mais)
que se fragmentam mais rapidamente. (Discussion, p. 1827)

**Domínio:** mecanismo geral ✓ | argumento quantitativo (0,5% vs 5%) ✗ | insight sobre o que BayesB estima ✗

---

## P5 — Gibbs vs. Metropolis-Hastings em BayesB

**Pergunta:** Por que o Gibbs sampling não pode ser usado diretamente para amostrar
σ²_gi em BayesB, e qual solução o artigo adota?

**Resposta do candidato:** "com certa probabilidade a variância é zero, isso gera
não-continuidade no Gibbs sampling"

**Avaliação:** Parcial — direção certa, mecanismo incompleto.
A "não-continuidade" aponta para o problema real, mas o artigo descreve um mecanismo
mais específico: o Gibbs cria uma armadilha bidirecional. Se g_i ≠ 0, é impossível
amostrar σ²_gi = 0; se σ²_gi > 0, a probabilidade de amostrar g_i = 0 é infinitesimal.
A cadeia fica presa em um dos dois subespaços e não explora o espaço amostral completo.
A solução do artigo: amostrar σ²_gi e g_i **conjuntamente** — MH para σ²_gi (100 ciclos
por passo) seguido de Gibbs para g_i dado σ²_gi. (Methods — BayesB, pp. 1822–1823)

**Domínio:** problema identificado ◐ | mecanismo exato (armadilha bidirecional) ✗ | solução ✗

---

## P4 — BayesA vs. BayesB

**Pergunta:** Qual a diferença estrutural entre BayesA e BayesB na priori de σ²_gi,
e qual problema biológico essa diferença tenta capturar?

**Resposta do candidato:** "no BayesA a priori é única para cada marcador e cada marcador
tem efeito; no BayesB alguns marcadores têm variância zero com uma probabilidade, sendo
BayesB mais realístico"

**Avaliação:** Bom, mas impreciso em um ponto crítico.
A distinção BayesB (spike em zero + chi-q invertida) vs. BayesA (só chi-q invertida) está
correta, assim como a conclusão de maior realismo biológico. O ponto impreciso: em BayesA
a probabilidade de σ²_gi = 0 não é apenas pequena — é **infinitesimal** (o artigo usa esse
termo exato). Faltou o valor quantitativo: π = 0,947 dos segmentos sem QTL segregante,
derivado da biologia (Appendix, p. 1829).

**Domínio:** diferença estrutural ✓ | realismo biológico ✓ | precisão técnica (infinitesimal, π) ◐

---

## P3 — A solução do BLUP

**Pergunta:** O que o BLUP assume sobre as variâncias dos segmentos, por que é irrealista,
e por que funciona razoavelmente bem mesmo assim?

**Resposta do candidato:** "assume variância uniforme; é irrealista porque cada região pode
ou não estar influenciando o genótipo/fenótipo; funciona porque em média é verdadeiro"

**Avaliação:** Parcial.
A suposição de variância uniforme está correta. A razão da irrealidade está na direção certa
mas imprecisa — o artigo especifica: a maioria dos loci tem σ²_gi = 0 (QTL não segregante)
e poucos têm variância grande (BayesB Methods, p. 1822). "Em média é verdadeiro" toca no
argumento mas perde o mecanismo central: o BLUP regride todas as estimativas para zero
(*shrinkage*), especialmente haplótipos raros, evitando a superestimação do LS. O artigo
diz: "correct positioning of QTL is not essential to achieve this" (Discussion, p. 1825).

**Domínio:** suposição ✓ | razão irrealidade parcial ◐ | mecanismo de funcionamento ✗

---

## P2 — Mecanismo da superestimação no LS

**Pergunta:** Por que selecionar apenas os efeitos com maior log-likelihood leva à
superestimação? Qual o nome do fenômeno estatístico subjacente?

**Resposta do candidato:** "pela correlação entre os efeitos; o fenômeno é a multicolinearidade"

**Avaliação:** Incorreto para este artigo.
Multicolinearidade descreve instabilidade nas estimativas quando preditores são correlacionados,
mas o artigo não usa esse termo nem o cita como mecanismo. O mecanismo descrito é outro:
com ~2,5 d.f. por efeito, cada estimativa carrega grande erro de amostragem; ao selecionar
os maiores efeitos, seleciona-se preferencialmente os que foram inflados para cima por esse
erro — viés de seleção. Lande & Thompson (1990) já havia nomeado e proposto correção para
esse problema. (Introdução, p. 1820; Results, p. 1824)

**Domínio:** mecanismo correto ✗ | fenômeno estatístico correto ✗

---

## P1 — Graus de liberdade

**Pergunta:** Quantos efeitos precisam ser estimados, quantos registros fenotípicos estão
disponíveis, e qual é a consequência prática desse desequilíbrio para o método de mínimos
quadrados? (use os números exatos do artigo)

**Resposta do candidato:** "pelo método do mínimo quadrado precisamos sempre de mais
observações fenotípicas do que parâmetros a serem estimados"

**Avaliação:** Parcial.
O princípio geral está correto, mas a resposta não trouxe os números do artigo nem as
consequências práticas descritas. Faltou:
- ~50.000 efeitos de haplótipos vs. 2.200 registros (Abstract p. 1819; Methods p. 1821)
- Procedimento por etapas adotado como saída (Methods — LS, p. 1821)
- Consequência quantificada: ~2,5 d.f. por efeito estimado → erros de amostragem grandes
  e superestimação dos efeitos selecionados (Results, p. 1824)

**Domínio:** conceito geral ✓ | números do artigo ✗ | consequências práticas ✗
