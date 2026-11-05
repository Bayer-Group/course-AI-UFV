# Reprodutibilidade: modelo minimo de Meuwissen et al. (2001)

## 1. Pergunta cientifica central

E possivel estimar com acuracia o valor genetico total de individuos sem
registros fenotipicos proprios, usando apenas marcadores moleculares densos?
(Abstract, p. 1819)

## 2. O que o modelo minimo reproduz e o que ele simplifica

**Reproduz:**
- O ranking de acuracia LS < RR-BLUP (analogo ao LS < BLUP do artigo).
- O vies sistematico de LS: coeficiente b << 1, mostrando superestimacao dos
  valores extremos (winner's curse).
- O efeito do shrinkage: RR-BLUP controla a variancia dos EBV sem precisar
  selecionar QTL por limiar de significancia.

**Simplifica (ver DESVIOS.md para lista completa):**
- 200 individuos e 100 marcadores bialelicos vs. 2.200 individuos e ~50.000
  haplotipos multialelicos.
- Sem estrutura populacional nem desequilibrio de ligacao historico — no artigo,
  marcadores capturam QTL via LD de 1.000 geracoes de deriva; aqui, a
  associacao e direta.
- Sem metodos bayesianos (BayesA, BayesB) — apenas LS e RR-BLUP.
- Efeitos de QTL normais em vez de gamma(1.66, 0.4).

## 3. Criterios de comparacao

| Criterio                          | Artigo (Table 2, p. 1824) | Modelo minimo | Status  |
|-----------------------------------|---------------------------|---------------|---------|
| r(LS)                             | 0.318                     | 0.578         | Fora*   |
| r(RR-BLUP) dentro de ±15% de 0.732| 0.622 -- 0.842           | 0.658         | **OK**  |
| b(LS) << 1                       | 0.285                     | 0.295         | **OK**  |
| Ranking LS < BLUP                 | 0.318 < 0.732             | 0.578 < 0.658 | **OK**  |

\* r(LS) e mais alto no modelo minimo porque n_train (150) > n_markers (100),
eliminando o problema de graus de liberdade que e central no artigo. No artigo,
p >> n (~50.000 >> 2.200) e a causa principal do fracasso de LS.

## 4. Desvios registrados (resumo)

Os 9 desvios entre o modelo minimo e o artigo estao documentados em
[DESVIOS.md](DESVIOS.md). O desvio mais critico e a ausencia de LD historico:
sem ele, o modelo minimo e um exercicio de shrinkage em regressao, nao uma
reproducao do mecanismo de selecao genomica (onde marcadores capturam QTL
indiretamente via LD populacional).

## 5. O que o modelo minimo ensinou sobre o mecanismo

1. **Shrinkage e suficiente para superar LS.** Mesmo sem estrutura populacional
   complexa, RR-BLUP (uma unica penalizacao lambda) produz EBV mais acurados
   e menos viesados que LS. Isso confirma a conclusao 3 do artigo (p. 1829):
   metodos com priori superam LS mesmo quando a priori nao e exata.

2. **b revela o que r esconde.** LS pode ter r razoavel (0.578) mas b = 0.295
   mostra que os EBV sao inflados — selecionar pelo melhor EBV entregaria
   apenas ~30% do ganho predito. O grafico scatter torna isso visivel: a nuvem
   de pontos de LS se espalha muito mais no eixo x que no eixo y.

3. **O problema de graus de liberdade e qualitativo, nao apenas quantitativo.**
   Com p < n (modelo minimo), LS ainda funciona mal por superestimacao, mas
   funciona. Com p >> n (artigo), LS colapsa completamente (r = 0.318). A
   transicao nao e gradual — e a diferenca entre um modelo sobredeterminado e
   um subdeterminado.

## 6. Como executar do zero

```bash
cd estudo-artigo

# Rodar simulacao, imprimir tabela e gerar grafico
Rscript R/10_modelo_minimo.R

# Verificar grafico gerado
open R/10_scatter_ls_blup.png    # macOS
# start R/10_scatter_ls_blup.png  # Windows
```

Requisitos: R >= 4.0 (base R apenas, sem pacotes externos).
Saida: tabela no terminal + `R/10_scatter_ls_blup.png`.
