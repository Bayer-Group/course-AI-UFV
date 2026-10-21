# Desafio da aula 9 — Gaste o orçamento melhor que a IA

**Tempo: 20 minutos. Em duplas. Sem avaliação — o resultado fica com vocês.**

## A situação

Você dirige um programa de melhoramento de uma autógama. Tem **2.400 parcelas
por ciclo** e mais nada: sem dinheiro extra, sem área extra. Esse orçamento
precisa ser repartido entre três usos que competem entre si:

| Decisão | O que ela compra | O que ela custa |
|---|---|---|
| mais **locais** (L) | estimativa melhor frente ao GxE | genótipos |
| mais **repetições** (R) | menos erro experimental dentro do local | genótipos |
| mais **genótipos** | intensidade de seleção maior | locais e repetições |

A conta é dura: `n_genótipos = 2.400 / (L × R)`. Seis locais com duas
repetições deixam **200** genótipos. Um local sem repetição deixa **2.400**.

Há uma quarta decisão, que não custa parcela nenhuma: **quanta endogamia por
ciclo** você autoriza o OCS a acumular (`delta_f`). Pressionar mais rende mais
ganho agora e menos variabilidade depois.

## A tarefa

Escolha **L, R e `delta_f`**. Sua escolha roda por **5 ciclos** de seleção e é
avaliada por:

> **ganho genético acumulado no ciclo 5**, em desvios-padrão genéticos,
> **sujeito a coancestria final ≤ 0,12**

Quem violar a restrição está desclassificado, independentemente do ganho. Essa
é a parte que separa otimização de "apertar o acelerador".

### Como usar a IA

1. **Primeiro, pergunte sem contexto.** Peça a recomendação ao ChatGPT ou
   Gemini com o mínimo:

   > Tenho 2.400 parcelas por ciclo em um programa de melhoramento de soja.
   > Quantos locais, quantas repetições e quantos genótipos devo usar?

   Anote a resposta. Guarde-a.

2. **Agora informe o que você sabe e pergunte de novo.** O que a IA não tinha:
   - a herdabilidade na parcela é 0,25
   - 40% da variância genética é interação genótipo × ambiente
   - a restrição é coancestria ≤ 0,12 no ciclo 5
   - herdabilidade da média é `Vg / (Vg + Vge/L + Ve/(L·R))`
   - o orçamento é por ciclo e os três usos competem pela mesma parcela

3. **Compare as duas respostas.** A diferença entre elas é o valor do seu
   conhecimento de domínio — e é esse o ponto da aula.

4. **Entregue uma linha:** `L = __, R = __, delta_f = ____`.

## O ranking

Todas as combinações viáveis estão pré-calculadas. Quando as duplas
entregarem, abrimos o gabarito e o ranking sai na hora.

## O que normalmente acontece

O primeiro palpite — com ou sem IA — costuma ser "muitos locais e repetições,
porque dado bom é dado replicado". O gabarito mostra o preço: com 6 locais × 2
repetições a herdabilidade da média chega a **0,65** e a acurácia do GEBV a
**0,86** — os melhores números de medição da grade inteira — e o ganho cai para
**+2,42** desvios, contra **+3,87** de um local sem repetição, porque sobraram
200 genótipos para selecionar em vez de 2.400. A célula que mede melhor é a
**20ª** entre as 30 viáveis.

Medir bem não é o objetivo. Ganhar é.

## Depois

Fechado o prazo, o gabarito é projetado em aula. Movendo L, R e `delta_f` ele
mostra, para cada combinação: genótipos disponíveis, herdabilidade da média,
acurácia, ganho no ciclo 5, coancestria final e se viola ou não a restrição.
Dá para percorrer a grade inteira — inclusive o que a sua dupla não escolheu —
e ver a fronteira onde ganho e diversidade se enfrentam.
