# Sessão 12 — Multi Agents

**FIT 796** · Demonstração de múltiplos subagentes  
**Formato:** slides + prática ao vivo (~60 min)  
**Stack:** Claude Code / Cursor agents (mesmo padrão da sessão 05)

Demonstração pedagógica: o aluno atua como **escritor** de uma mini-revisão sobre a evolução da seleção genômica, com um agente **orientador** e um painel de **três revisores** especialistas. O intuito é mostrar a dinâmica de multi-agentes — não produzir um paper real.

## Objetivos

Ao final da sessão, o aluno deve ser capaz de:

1. Distinguir um único chat de LLM de um sistema com papéis e contexto limpo.
2. Descrever o fluxo escritor → orientador → gate do aluno → painel de revisores.
3. Aplicar um loop de revisão com veredito e limite de rodadas.
4. Registrar decisões humanas (enviar ou não ao painel) fora do agente.

## O que esta sessão não é

| Já coberto | Sessão |
| --- | --- |
| Claude Code, plano, orientando/orientador em código | 05 |
| GBLUP, GEBV, validação | 06 |
| Estudo de paper com LLM | 08 |
| CrewAI / LangGraph / APIs Python | — (fora do escopo) |

## Agenda (~60 min)

| Min | Bloco | Conteúdo |
| --- | --- | --- |
| 0–12 | Conceito | O que é multi-agent; âncora sessão 05 |
| 12–20 | Arquitetura e loop | Papéis, gate do aluno, veredito 2/3 |
| 20–55 | Prática | Uma rodada completa em `projeto-revisao-gs` |
| 55–60 | Fechamento | Takeaways; rodadas 2–3 como extra |

## Materiais nesta pasta

| Arquivo / pasta | Uso |
| --- | --- |
| [12_multi_agents.pptx](12_multi_agents.pptx) | Deck da sessão (gerar com `_build_pptx.ps1`) |
| [roteiro_slides.md](roteiro_slides.md) | Índice dos blocos e o que não cortar |
| `_slides_parts/` + `_build_pptx.ps1` | Fonte dos slides e rebuild |
| [projeto-revisao-gs/](projeto-revisao-gs) | Prática: abrir **só esta pasta** como projeto |

## Aviso importante

Abra `projeto-revisao-gs` como pasta do projeto no Cursor ou no Claude Code. A pasta da seção inteira mistura o PPTX e outros roteiros, e o agente passa a usá-los como se fossem dados da missão.
