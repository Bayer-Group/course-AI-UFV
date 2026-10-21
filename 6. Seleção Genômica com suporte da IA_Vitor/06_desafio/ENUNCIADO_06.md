# Desafio da aula 6 — Audite o GBLUP que a IA escreveu

**Tempo: 20 minutos. Em duplas. Sem avaliação — o resultado fica com vocês.**

## A situação

Um melhorista pediu a um assistente de IA: *"estime GEBV para estas 600
linhagens e me diga a acurácia do modelo."*

A IA entregou o script `desafio_06_script_aluno.R`. Ele **roda sem erro** e
imprime:

```
=========================================
 ACURACIA DO MODELO: 0.837
=========================================

Conclusao do relatorio: a acuracia de predicao e alta, o modelo
esta validado e pode ser usado para selecionar a proxima geracao.
```

A acurácia real do modelo, no material que ele vai de fato predizer, é
**0,612** — e cai para **0,447** quando o mesmo pipeline é medido num lote de
linhagens que não participou de nenhuma etapa. O script não tem nenhum bug de
programação: todas as contas estão certas. O número está errado de outra forma.

## A tarefa

1. **Leia o script** (são 5 minutos — ele é curto e tem comentários).
2. **Cole-o no ChatGPT ou Gemini** e pergunte o que está errado. Sugestão de
   prompt mínimo — *não* dê a resposta de bandeja:

   > Este script de R estima valores genéticos genômicos e reporta a acurácia
   > do modelo. Revise-o criticamente. A acurácia reportada é confiável?

3. **Decida o que aceitar.** A IA vai listar vários problemas. Para cada
   crítica, responda:
   - isso muda o número **reportado**?
   - isso muda a predição que o programa **realmente recebe**?
   - ou isso não muda nada?
4. **Escreva seu veredito** em 3 linhas: quais críticas da IA são válidas,
   quais são invenção, e o que ela deixou passar.

## A regra que não pode ser quebrada

O script tem um objeto `g_verdadeiro` — o valor genético verdadeiro de cada
linhagem. **Isso só existe porque o dado é simulado.** Num programa real você
nunca o tem.

Você **não pode** usar `g_verdadeiro` para diagnosticar o problema. Ele serve
apenas para, no final, conferir quem estava certo (seção 7 do script, que está
comentada).

## O que vale ponto na discussão

Não é achar os quatro itens suspeitos. É conseguir **separá-los por natureza**:

- algum deles infla o relatório sem mudar nada no modelo?
- algum deles piora o que o programa recebe, mas mantém o relatório honesto?
- algum deles não faz diferença nenhuma?

As três respostas são "sim". Descobrir qual é qual é o desafio.

## Depois

Fechado o prazo, o gabarito é projetado em aula. Ele é interativo: dá para
**ligar e desligar cada item suspeito** e ver os dois números se mexerem — o
que o script reporta e o que o modelo entrega num lote de 150 linhagens nunca
usadas. Os 16 cenários possíveis estão todos pré-calculados, inclusive os que
a sua dupla não escolheu.

Ele serve para conferir o seu veredito, não para substituí-lo — por isso só
abre depois que as duplas entregarem.
