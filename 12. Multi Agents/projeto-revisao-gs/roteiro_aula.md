# Roteiro da aula — Multi Agents (~60 min)

Abrir a pasta `projeto-revisao-gs` como projeto. Slides da seção 12 nos primeiros ~20 min; depois **um único prompt** abaixo.

## Cronograma

| Min | Ação |
| --- | --- |
| 0–12 | Slides: o que é multi-agent (bloco 1) |
| 12–20 | Slides: arquitetura, loop, missão (blocos 2–4) |
| 20–50 | Colar o prompt único; acompanhar escritor → orientador → gate → painel |
| 50–55 | Ler veredito consolidado (≥ 2/3) |
| 55–60 | Takeaways; limpeza opcional |

Se o tempo apertar: **uma** rodada completa basta. Rodadas 2–3 = repetir o mesmo prompt trocando `N = 1` por `N = 2` (ou `3`).

---

## Prompt único (colar no chat)

Invoque os subagentes `.claude/agents/` conforme as etapas. O fluxo inteiro está neste prompt; a única interrupção humana é o **gate** (passo 3).

```text
Orquestre a rodada N = 2 da mini-revisão multi-agente neste projeto.
Leia antes: CLAUDE.md, MISSAO.md, PLANO.md, referencias/README.md.

Execute em ordem, sem pular etapas:

### 1) Escritor
Invoque o agente `escritor`.
- Produza docs/rascunhos/rodada_N.md (600–900 palavras, quatro seções da MISSAO).
- Cite só referencias/README.md com rótulo [LISTA]. Não invente DOI/ano/título.
- Ao terminar: caminho, contagem de palavras e referências usadas.

### 2) Orientador
Invoque o agente `orientador` com contexto limpo (não reescreva o rascunho).
- Revise docs/rascunhos/rodada_N.md contra MISSAO.md e CLAUDE.md.
- Grave docs/pareceres_orientador/rodada_N.md
  (Bloqueantes / Sugestões / Recomendação: "Pode considerar envio" ou "Reescrever antes do painel").

### 3) GATE DO ALUNO — PARE AQUI
Mostre um resumo de 5 linhas do parecer do orientador.
Pergunte e espere minha resposta explícita, sem inventar:
  ENVIAR  ou  REESCREVER
Não chame revisores até eu responder.

Se eu disser REESCREVER:
- volte ao passo 1 na mesma rodada N, tratando só os bloqueantes;
- repita 2 e 3.

Se eu disser ENVIAR:
- acrescente em docs/decisoes.md:

## Rodada N 
- Decisão: ENVIAR
- Motivo: (use 1 frase do que eu disser, ou "aluno autorizou envio ao painel")
- Bloqueantes do orientador tratados? (sim/não/parcial conforme o parecer)

### 4) Painel de revisores (só após ENVIAR)
Invoque, em sequência ou em paralelo, os três agentes:
- `revisor-gq`       → docs/pareceres_revisores/rodada_N_gq.md
- `revisor-melhoramento` → docs/pareceres_revisores/rodada_N_melhoramento.md
- `revisor-molecular` → docs/pareceres_revisores/rodada_N_molecular.md
Cada um: confirmar ENVIAR em docs/decisoes.md; Veredito APROVADO ou REPROVADO + bloqueantes.
Não editem o rascunho.

### 5) Consolidação
Ao final, reporte uma tabela:
| Revisor | Veredito |
| gq | … |
| melhoramento | … |
| molecular | … |
- Comitê: APROVADO se ≥ 2 de 3 APROVADO; senão REPROVADO.
- Se REPROVADO e N < 3: diga que na próxima rodada basta colar de novo este prompt com N = N+1.
- Se N = 3 e ainda REPROVADO: declare "versão final com ressalvas" e liste os bloqueantes restantes em docs/decisoes.md.

Regras duras em todas as etapas: não inventar citação; não abrir a pasta pai nem o PPTX; não fazer commit.
```

---

## Como conduzir na sala

1. Cole o prompt uma vez (com `N = 1`).
2. Deixe correr os passos 1–2.
3. No gate, a turma (ou o instrutor) responde só `ENVIAR` ou `REESCREVER`.
4. Se `ENVIAR`, o mesmo fio completa o painel e a consolidação.
5. Rodada 2 ou 3: cole o **mesmo** prompt trocando `N = 1` por `N = 2` ou `N = 3`.

---

## Encerramento (1 min)

Perguntas rápidas à turma:

1. O que o orientador pegou que um único chat costuma perdoar?
2. Por que o gate do aluno importa?
3. Que lente cada revisor trouxe de diferente?

Limpeza da demo:

```powershell
.\limpeza.ps1
```