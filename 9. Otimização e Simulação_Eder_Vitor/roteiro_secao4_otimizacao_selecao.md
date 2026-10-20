# Seção 4 — Otimização da seleção e tomada de decisão com Claude Code

**Curso:** Uso de Inteligência Artificial no Melhoramento de Plantas
**Carga horária:** 2 horas
**Pré-requisitos:** Seção 2 (banco com GEBVs e matriz G; AlphaSimR); noções de coancestria e ΔF
**Material de apoio:** `referencia_ocs.R` (gabarito do professor, testado)

> **Objetivo central da seção:** tratar a seleção de genitores como um **problema de otimização explícito**, que equilibra ganho genético e manutenção de variância genética, e usar o Claude Code para formular, implementar, validar e tornar reproduzível o otimizador.
>
> **Mensagem que deve ficar:** a IA escreve o otimizador rapidamente, mas a confiança no resultado vem de três verificações: **restrições satisfeitas**, **comparação com o ótimo exato** e **desempenho de longo prazo na simulação**. A escolha do equilíbrio entre ganho e diversidade continua sendo decisão do melhorista.

---

## Cronograma

| Bloco | Tema | Conceito de Claude Code trabalhado | Tempo |
|---|---|---|---|
| 1 | O problema: ganho versus diversidade | — | 15 min |
| 2 | Métodos: QP, programação linear e evolução diferencial | — | 20 min |
| 3 | Construção do otimizador com Claude Code | Formulação antes do código, gabarito exato, testes, subagente revisor | 45 min |
| 4 | Fechando o ciclo no AlphaSimR | Experimento com repetições | 25 min |
| 5 | Discussão: decisão, escala e reprodutibilidade | Estudo de caso | 15 min |
| | **Total** | | **120 min** |

---

# BLOCO 1 — O problema: ganho versus diversidade (15 min)

## Slide 1.1 — O dilema do truncamento

- Selecionar os melhores por GEBV maximiza o ganho no próximo ciclo.
- Os melhores tendem a ser aparentados: GEBVs de irmãos são correlacionados.
- Consequência: aumento rápido da coancestria, perda de variância genética e redução do ganho futuro.

> Pergunta para a turma: em um programa com seleção genômica e ciclos curtos, quantos ciclos até a variância genética cair pela metade?

## Slide 1.2 — Coancestria e taxa de endogamia

Coancestria média do grupo selecionado, com vetor de contribuições **c**:

$$\bar{C} = \frac{1}{2}\,\mathbf{c}^\top \mathbf{G}\,\mathbf{c}$$

Coancestria-alvo para uma taxa de endogamia desejada ΔF:

$$C_{t+1} = C_t + \Delta F\,(1 - C_t)$$

Relação com o tamanho efetivo: ΔF ≈ 1/(2Nₑ). Valores de referência frequentemente usados em programas: ΔF entre 0,5% e 1% por geração.

## Slide 1.3 — Seleção por contribuição ótima (OCS)

Formulação de Meuwissen (1997), para espécie monoica:

$$\max_{\mathbf{c}}\ \mathbf{c}^\top \hat{\mathbf{g}} \quad \text{sujeito a} \quad \tfrac{1}{2}\mathbf{c}^\top\mathbf{G}\mathbf{c} \le \theta,\quad \mathbf{1}^\top\mathbf{c} = 1,\quad \mathbf{c} \ge 0$$

- **ĝ**: GEBVs dos candidatos.
- **G**: matriz de parentesco genômico.
- **θ**: coancestria máxima permitida, derivada do ΔF.

## Slide 1.4 — A fronteira ganho × coancestria

```
Ganho
  ▲                          ● truncamento
  │                    ●
  │              ●
  │         ●           ← cada ponto: solução ótima para um θ
  │     ●
  │  ●
  └───────────────────────────► Coancestria
   mínima coancestria
```

**Mensagem:** o otimizador não escolhe θ. Ele mostra o custo de cada escolha. **A decisão sobre o ponto da fronteira é do melhorista**, conforme o horizonte do programa e a base genética disponível.

---

# BLOCO 2 — Métodos de otimização em linguagem direta (20 min)

## Slide 2.1 — Três ferramentas, três tipos de problema

| Método | Tipo de problema | Garante o ótimo? | Uso no melhoramento |
|---|---|---|---|
| Programação quadrática (QP) | Contínuo, convexo | Sim | OCS com contribuições contínuas |
| Programação linear inteira (PLI) | Decisões discretas com objetivo e restrições lineares | Sim, dentro da formulação | Alocação de cruzamentos, restrições de campo e de uso de genitores |
| Evolução diferencial (DE) | Discreto, não convexo, função "caixa-preta" | Não | Escolher n indivíduos com contribuições iguais; objetivos complexos |

## Slide 2.2 — OCS contínua como QP

Em vez da restrição quadrática, usa-se a forma penalizada, que é convexa:

$$\max_{\mathbf{c}}\ \mathbf{c}^\top \hat{\mathbf{g}} - \lambda\,\tfrac{1}{2}\mathbf{c}^\top\mathbf{G}\mathbf{c}$$

- Para cada λ, a solução é o ótimo global.
- Uma busca por bisseção em λ encontra a solução que atinge exatamente θ.
- Pacotes: `quadprog`, `CVXR`; para uso aplicado em programas, `optiSel`.

**Esta solução é o gabarito** contra o qual qualquer heurística será julgada.

## Slide 2.3 — Onde entra a programação linear

A restrição de coancestria é quadrática, então a PL pura não resolve a OCS. Mas a PL inteira é muito útil **depois** que os genitores foram escolhidos:

- variável binária para cada cruzamento possível;
- objetivo linear: média esperada da progênie menos uma penalização pela coancestria entre os pais (constante por cruzamento);
- restrições lineares: número total de cruzamentos, uso máximo por genitor, capacidade de campo, sincronia de florescimento.

**Mensagem:** a coancestria de um par é um número conhecido. Isso torna o problema de alocação linear.

## Slide 2.4 — Evolução diferencial em um slide

```
1. População inicial de soluções aleatórias
2. Para cada solução x:
     mutante  = a + F · (b − c)          (a, b, c: outras soluções)
     tentativa = recombinação(x, mutante, CR)
     se f(tentativa) ≥ f(x): substitui x
3. Repetir até convergir
```

- Restrições tratadas por **penalização** na função objetivo.
- Versão discreta ("escolher k indivíduos") por **chaves aleatórias**: os k maiores valores do vetor contínuo definem os selecionados.
- Parâmetros sensíveis: tamanho da população (NP), F, CR e número de iterações.

**Ponto crítico:** a evolução diferencial sempre devolve *uma* resposta. Sem comparação com o ótimo, não há como saber se ela é boa.

---

# BLOCO 3 — Construção do otimizador com Claude Code (45 min)

## Slide 3.1 — Estrutura do projeto

```
ocs-milho/
├── CLAUDE.md
├── PLANO.md
├── config/
│   └── ocs.yaml                 # θ, ΔF, k, n_cruzamentos, uso_max, sementes
├── docs/
│   └── formulacao.md            # matemática do problema (escrita antes do código)
├── R/
│   ├── 01_dados.R               # GEBVs e G do banco da Seção 2
│   ├── 02_ocs_exata.R           # QP (gabarito)
│   ├── 03_ocs_de.R              # evolução diferencial (contínua e discreta)
│   ├── 04_alocacao_pli.R        # alocação de cruzamentos
│   └── 05_fronteira.R           # fronteira ganho × coancestria
├── tests/
│   └── test_ocs.R
└── .claude/agents/
    └── revisor-otimizacao.md
```

## Slide 3.2 — O `CLAUDE.md` da seção

```markdown
# Projeto: otimização da seleção de genitores em milho

## Formulação oficial (não altere sem aprovação)
- OCS de Meuwissen (1997): max c'g sujeito a c'Gc/2 <= theta, sum(c) = 1, c >= 0.
- theta deriva de Delta F: C_{t+1} = C_t + DeltaF (1 - C_t).
- G: VanRaden (2008), método 1, com pequeno termo na diagonal para garantir
  matriz definida positiva (registrar o valor).

## Regras de validação
- Nenhuma heurística (DE ou outra) é aceita sem comparação com a solução exata
  por QP na mesma instância.
- Todo resultado deve reportar: ganho, coancestria, n de contribuintes,
  violação de restrição e razão em relação ao ótimo exato.
- Resultados de DE: mínimo de 10 execuções com sementes distintas;
  reportar média e desvio-padrão.

## Reprodutibilidade
- Parâmetros apenas em config/ocs.yaml; sementes registradas.
- Registrar versões dos pacotes de otimização (sessionInfo) em cada relatório.

## Forma de trabalho
- Antes de qualquer código, escrever ou atualizar docs/formulacao.md.
- Modo de planejamento no início de cada etapa.
```

## Slide 3.3 — Passo 1: formulação antes do código

```
Leia CLAUDE.md. Escreva docs/formulacao.md com:
1. Variáveis de decisão, função objetivo e restrições da OCS contínua,
   da versão discreta (k selecionados com contribuições iguais) e da
   alocação de cruzamentos.
2. Para cada uma, o tipo de problema (QP convexo, PLI, combinatório)
   e o método adequado, com justificativa.
3. Como theta é obtido a partir de Delta F.
4. Referências primárias.
Não escreva código ainda.
```

**O que o aluno verifica:** a forma quadrática tem o fator 1/2? A soma das contribuições é 1 (espécie monoica) e não 1/2 por sexo, como em animais? A versão discreta está corretamente classificada como combinatória?

## Slide 3.4 — Passo 2: o gabarito exato

```
Implemente R/02_ocs_exata.R com quadprog:
- função ocs_lambda(lambda) resolvendo a forma penalizada;
- função ocs_exata(theta) com bisseção em lambda até atingir theta;
- teste em tests/test_ocs.R: sum(c) = 1, c >= 0, coancestria <= theta.
Use uma instância de 100 a 200 candidatos do banco da Seção 2.
```

Trecho de referência (do `referencia_ocs.R`):

```r
ocs_lambda <- function(lambda) {
  D <- lambda * G                       # solve.QP minimiza 1/2 c'Dc - d'c
  A <- cbind(rep(1, n), diag(n))        # sum(c) = 1 e c >= 0
  sol <- solve.QP(Dmat = D, dvec = gebv, Amat = A,
                  bvec = c(1, rep(0, n)), meq = 1)$solution
  sol <- pmax(sol, 0); sol / sum(sol)
}

ocs_exata <- function(theta, lo = 1e-4, hi = 1e6) {
  for (k in 1:80) {
    mid <- sqrt(lo * hi)
    if (coanc(ocs_lambda(mid)) > theta) lo <- mid else hi <- mid
  }
  ocs_lambda(hi)
}
```

## Slide 3.5 — Passo 3: evolução diferencial contra o gabarito

```
Implemente R/03_ocs_de.R com DEoptim:
(a) versão contínua: pesos w >= 0 normalizados para c = w/sum(w),
    penalização da violação de theta;
(b) versão discreta: k selecionados com contribuições iguais, por chaves aleatórias.
Compare (a) com a solução exata: razão de ganho, coancestria e tempo.
Rode 10 sementes. Registre os parâmetros NP, F, CR e itermax.
```

**Resultado obtido na preparação desta aula** (200 candidatos, 2.000 SNPs, 20 famílias; θ fixado a 30% do caminho entre a mínima coancestria e a do truncamento):

| Método | Ganho | Coancestria | Nº de contribuintes |
|---|---|---|---|
| Truncamento (top 20) | 3,13 | 0,099 | 20 |
| OCS exata (QP) | 2,70 | 0,030 | 41 |
| OCS por DE (contínua) | 2,40 | 0,030 | 77 |
| DE discreta (k = 20) | 2,12 | 0,028 | 20 |

Pontos para discussão:
- A OCS exata abriu mão de cerca de 14% do ganho imediato para reduzir a coancestria a menos de um terço da do truncamento.
- A evolução diferencial contínua respeitou a restrição, mas chegou a **cerca de 89% do ótimo** e levou vários minutos, enquanto o QP resolve em frações de segundo. Ela também espalhou contribuições por muito mais indivíduos, o que tem custo operacional.
- **Sem o gabarito, a solução da evolução diferencial pareceria perfeitamente razoável.** Esse é o argumento central da seção.

> Esses números são de uma única instância e uma semente. Servem de ilustração; na aula, a turma deve repetir com várias sementes.

## Slide 3.6 — Passo 4: alocação de cruzamentos por PL inteira

```
Implemente R/04_alocacao_pli.R com lpSolve:
- candidatos: os k selecionados pela versão discreta;
- variável binária por par; objetivo: média dos GEBVs dos pais menos
  lambda_c vezes a coancestria do par;
- restrições: n_cruzamentos exatos e no máximo uso_max por genitor (do YAML).
Teste: número de cruzamentos e uso por genitor respeitados.
```

Trecho de referência:

```r
pares <- t(combn(sel, 2))
valor <- (gebv[pares[, 1]] + gebv[pares[, 2]]) / 2
f_par <- G[pares] / 2
obj   <- valor - lambda_c * f_par
A_uso <- t(sapply(sel, \(i) as.numeric(pares[, 1] == i | pares[, 2] == i)))
lp_res <- lp("max", obj,
             const.mat = rbind(rep(1, nrow(pares)), A_uso),
             const.dir = c("=", rep("<=", length(sel))),
             const.rhs = c(n_cruz, rep(max_uso, length(sel))),
             all.bin = TRUE)
```

## Slide 3.7 — Passo 5: subagente revisor de otimização

`.claude/agents/revisor-otimizacao.md`:

```markdown
---
name: revisor-otimizacao
description: Verifica se as soluções de otimização respeitam a formulação
  oficial e as restrições. Use antes de aceitar qualquer resultado de OCS
  ou de alocação de cruzamentos.
tools: Read, Bash, Grep
---

Você não escreveu o código revisado. Verifique:
1. Se o código implementa exatamente docs/formulacao.md (fatores, sinais, soma das contribuições).
2. Se todas as restrições são satisfeitas numericamente nas soluções salvas.
3. Se heurísticas foram comparadas ao ótimo exato na mesma instância.
4. Se sementes, parâmetros do otimizador e versões de pacotes foram registrados.
Entregue problemas classificados como crítico, moderado ou menor. Não altere arquivos.
```

## Slide 3.8 — Passo 6: a fronteira

```
Em R/05_fronteira.R, trace a fronteira ganho × coancestria com a OCS exata
para 15 valores de theta entre a mínima coancestria e a do truncamento.
Sobreponha os pontos da DE contínua e discreta. Salve a figura em reports/.
```

**O que a figura deve mostrar:** os pontos da evolução diferencial abaixo da fronteira exata. A distância vertical é a perda causada pela heurística.

---

# BLOCO 4 — Fechando o ciclo no AlphaSimR (25 min)

## Slide 4.1 — Prompt do experimento

```
Usando o simulador da Seção 2, compare ao longo de 10 ciclos:
(1) truncamento por GEBV; (2) OCS com Delta F = 1%; (3) OCS com Delta F = 3%.
Mesmo número de cruzamentos e de progênies em todos os cenários.
Métricas por ciclo: média de gv, variância genética e coancestria realizada.
20 repetições por cenário. Reporte média e intervalo de confiança.
Compare o Delta F realizado com o planejado.
```

## Slide 4.2 — O que a turma deve observar

| Horizonte | Resultado esperado |
|---|---|
| Primeiros ciclos | Truncamento com maior ganho |
| Longo prazo | OCS mantém mais variância genética e tende a sustentar o ganho |
| ΔF realizado | Próximo do planejado na OCS; alto no truncamento |

> O cruzamento das curvas depende do tamanho da população, da acurácia e do horizonte. Com poucas repetições, a ordem entre cenários pode não aparecer com clareza. Isso também é lição: conclusão comparativa exige replicação.

---

# BLOCO 5 — Decisão, escala e reprodutibilidade (15 min)

## Slide 5.1 — A decisão é do melhorista

- θ ou ΔF reflete o horizonte do programa, o tamanho da base genética e a disponibilidade de germoplasma externo.
- Programas com introdução frequente de germoplasma podem tolerar ΔF maior.
- O otimizador torna o custo de cada escolha explícito; não elimina a escolha.

## Slide 5.2 — Escala: quando o método depende do tamanho do problema

Estudo de caso: evolução diferencial para OCS com dezenas de milhares de candidatos (pacote `rcppdepar`, em C++ via Rcpp).

| Aspecto | O que se aprendeu |
|---|---|
| Gargalo | O acesso à matriz G na função objetivo domina o tempo de execução |
| Memória | Quantização da matriz e armazenamento via matriz de marcadores reduzem o uso de memória |
| Maior ganho de desempenho | Avaliação incremental da função objetivo (atualizar só o que mudou) |
| Alternativa | Solvers convexos são mais adequados em teoria, mas esbarram em memória nessa escala |

**Mensagem:** para 200 candidatos, o QP é imbatível. Para 50 mil, a engenharia do código e a escolha do método passam a ser o problema central. O Claude Code ajuda muito nessa engenharia (perfilamento, porte para C++, testes de equivalência numérica com a versão em R), desde que exista a versão de referência para comparar.

## Slide 5.3 — Checklist de reprodutibilidade de um otimizador

- [ ] Formulação escrita em `docs/formulacao.md`, com referência primária.
- [ ] Parâmetros do problema e do otimizador em YAML.
- [ ] Sementes registradas; múltiplas execuções para heurísticas.
- [ ] Solução exata em instância pequena como gabarito.
- [ ] Testes automáticos de satisfação de restrições.
- [ ] Versões de pacotes registradas.
- [ ] Validação de longo prazo por simulação com repetições.

## Slide 5.4 — Síntese

```
Formular       →  a matemática antes do código (docs/formulacao.md)
Resolver exato →  QP em instância pequena: o gabarito
Heurística     →  evolução diferencial, sempre comparada ao gabarito
Decisões discretas →  PL inteira para alocação de cruzamentos
Validar no tempo  →  AlphaSimR com repetições
Decidir        →  o melhorista escolhe o ponto da fronteira
```

---

# Notas para o professor

## Tempo de execução
Na preparação, com 200 candidatos, a evolução diferencial contínua (NP = 2.000; 3.000 iterações) levou cerca de 7 minutos em um único núcleo. Para a aula:
- usar 100 candidatos;
- reduzir as iterações para 500–1.000;
- mostrar o resultado completo já calculado.

A própria lentidão é material didático: o QP resolve o mesmo problema quase instantaneamente.

## Pontos em que o professor deve intervir
- Se o agente usar soma das contribuições igual a 1/2 por sexo, como em animais.
- Se o agente apresentar a solução da evolução diferencial sem comparação com o QP.
- Se o agente tentar resolver a OCS com PL pura, ignorando a restrição quadrática.
- Se a matriz G não for definida positiva e o solver falhar: discutir a adição de um termo pequeno na diagonal e registrar seu valor.

## Referências
- Meuwissen, T. H. E. (1997). Maximizing the response of selection with a predefined rate of inbreeding. *Journal of Animal Science*, 75(4), 934–940.
- Woolliams, J. A.; Berg, P.; Dagnachew, B. S.; Meuwissen, T. H. E. (2015). Genetic contributions and their optimization. *Journal of Animal Breeding and Genetics*, 132(2), 89–99.
- Storn, R.; Price, K. (1997). Differential evolution — a simple and efficient heuristic for global optimization over continuous spaces. *Journal of Global Optimization*, 11, 341–359.
- VanRaden, P. M. (2008). Efficient methods to compute genomic predictions. *Journal of Dairy Science*, 91(11), 4414–4423.
- Wellmann, R. (2019). Optimum contribution selection for animal breeding and conservation: the R package optiSel. *BMC Bioinformatics*, 20, 25.
- Mullen, K. M. et al. (2011). DEoptim: an R package for global optimization by differential evolution. *Journal of Statistical Software*, 40(6).
