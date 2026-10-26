# Sessão 12 — Esqueleto do deck

Gerado de `_slides.json` (mesma fonte de `12_multi_agents.pptx`) por `_build_md.ps1`. 22 slides. Cada slide traz os tópicos da tela e as notas do apresentador.

## Slide 1 — Multi Agents — revisão sob papéis

**Tópicos**

- FIT 796 · IA no melhoramento de plantas · UFV × Bayer × IDATA
- Demonstração ~60 min · Claude Code / Cursor agents
- Missão: mini-revisão sobre evolução da seleção genômica
- Não é paper real: o objetivo é a dinâmica multi-agente
- Prática em projeto-revisao-gs/ (abrir só essa pasta)

**Notas**

Abra dizendo que esta seção estende a sessão 05: lá havia orientando e orientador em código; aqui o mesmo padrão serve a uma revisão bibliográfica curta. Deixe claro em 20 segundos: não vamos entregar 4 páginas publicáveis. Vamos mostrar papéis, gate humano e loop de veredito. Avise que o deck tem notas de apresentador e que a prática vive em projeto-revisao-gs.

## Slide 2 — Roteiro da seção (~60 min)

**Tópicos**

- 0–12 min · Bloco 1 — O que é multi-agent
- 12–20 min · Blocos 2–3 — Arquitetura e loop
- 20–55 min · Bloco 4 + prática ao vivo
- 55–60 min · Fechamento e takeaways
- Se apertar: uma rodada completa; rodadas 2–3 em casa

**Notas**

Mostre o relógio. Na prática ao vivo o instrutor cola prompts do roteiro_aula.md. Se a turma for grande, faça a demo no projetor e peça que cada aluno acompanhe a decisão do gate (enviar ou não).

## Slide 3 — Objetivos de aprendizagem

**Tópicos**

- Distinguir um chat único de um sistema com papéis
- Descrever escritor → orientador → gate do aluno → 3 revisores
- Aplicar loop com veredito e limite de rodadas
- Registrar a decisão humana fora do agente (docs/decisoes.md)
- Criticar alucinação de citação com lista fechada

**Notas**

Leia os cinco objetivos sem aprofundar. O quarto é o mais importante pedagogicamente: multi-agent não remove a responsabilidade do aluno.

## Slide 4 — O que esta seção não é

**Tópicos**

- Não é lab de GBLUP (sessão 06)
- Não é estudo de paper com um só LLM (sessão 08)
- Não é CrewAI, LangGraph nem API Python
- Não exige PDF completo nem 4 páginas finais em aula
- É demonstração: esboço de 600–900 palavras + pareceres

**Notas**

Gerencie expectativa. Quem quiser framework Python, diga que o curso prioriza Claude Code com agents em markdown — alinhado às sessões 05, 08 e 09.

---

# Bloco 1 — O que é multi-agent (8 min)

## Slide 5 — Bloco 1 — O que é multi-agent (8 min)

**Tópicos**

- SEÇÃO 12 — BLOCO 1
- Um LLM vs vários agentes com missão e ferramentas distintas
- Contexto limpo: o revisor não 'lembra' de ter escrito o texto
- Âncora: sessão 05 (orientando / orientador)
- Aqui: revisão bibliográfica, não código R

**Notas**

Divider de bloco. Tempo: ~8 minutos. Conecte à sessão 05: lá o orientador lia com contexto limpo e devolvia bloqueantes. O mesmo padrão vale para texto científico.

## Slide 6 — 1.1 Um chat só: o que quebra

**Tópicos**

- O mesmo modelo escreve e 'revisa' sem adversário real
- Contexto misturado: elogia o próprio rascunho
- Difícil auditar quem decidiu o quê
- Alucinação de DOI parece consenso interno
- Bom para rascunho; fraco para governança

**Notas**

Pergunte à turma: já pediram ao mesmo chat 'revise o que você escreveu'? Quase sempre o modelo é generoso consigo. Multi-agent força separação de papéis e de arquivos de entrega.

## Slide 7 — 1.2 Multi-agent: ideia mínima

**Tópicos**

- Cada agente = perfil + missão + tools + formato de entrega
- Arquivos em .claude/agents/ (como na sessão 05)
- Artefactos em docs/: rascunhos e pareceres separados
- O humano orquestra: quem chama, quando, e se avança
- Não precisa de framework novo no curso

**Notas**

Mostre mentalmente a pasta .claude/agents/. Enfatize: multi-agent aqui é organização de trabalho, não magia. O custo é mais prompts e mais leitura; o ganho é rastreabilidade.

## Slide 8 — 1.3 Âncora sessão 05

**Tópicos**

- orientando.md implementava uma etapa do PLANO.md
- orientador.md lia com contexto limpo e listava bloqueantes
- Entrega em docs/etapas/ e docs/revisoes/
- Mesma filo: plano → agente sob regra → parecer → humano
- Sessão 12 troca código R por texto de revisão

**Notas**

Se a turma fez a sessão 05, use 30 segundos. Se não, diga só: já praticamos dois agentes em análise de VCU; agora cinco agentes em texto.

---

# Bloco 2 — Papéis e arquitetura (5 min)

## Slide 9 — Bloco 2 — Papéis e arquitetura (5 min)

**Tópicos**

- SEÇÃO 12 — BLOCO 2
- Cinco agentes + o aluno no gate
- Escritor redige; orientador não edita o texto
- Três revisores finais com lentes distintas
- Decisão de envio ao painel: só o aluno

**Notas**

Divider. Desenhe no ar ou no quadro o fluxo aluno → escritor → orientador → gate → três revisores.

## Slide 10 — 2.1 Os cinco agentes

**Tópicos**

- escritor — PhD em melhoramento; redige o esboço
- orientador — professor sênior; parecer Bloqueantes/Sugestões
- revisor-gq — genética quantitativa
- revisor-melhoramento — métodos de melhoramento
- revisor-molecular — genética molecular / germoplasma

**Notas**

Os três revisores cobrem ângulos complementares: modelo e acurácia; desenho de programa; marcadores e conservação. Não peça profundidade de monografia — peçam veredito curto.

## Slide 11 — 2.2 O aluno é o escritor

**Tópicos**

- Você dirige o agente escritor (prompts + missão)
- Lê o parecer do orientador
- Decide: reescrever OU enviar ao painel
- Anota a decisão em docs/decisoes.md
- Sem o seu 'sim', os três revisores não entram

**Notas**

Este é o slide de governança. Multi-agent sem gate humano vira automação opaca. Na aula, o instrutor pode narrar a decisão em voz alta na primeira rodada.

## Slide 12 — 2.3 Diagrama do fluxo

**Tópicos**

- Aluno + /escritor → docs/rascunhos/rodada_N.md
- /orientador → docs/pareceres_orientador/rodada_N.md
- Gate do aluno (sim/não) → docs/decisoes.md
- Se sim: /revisor-gq + /revisor-melhoramento + /revisor-molecular
- Vereditos → docs/pareceres_revisores/

**Notas**

Leia como checklist operacional. Na prática, os nomes de arquivo importam: rodada_1, rodada_2, rodada_3.

---

# Bloco 3 — Dinâmica e loop (5 min)

## Slide 13 — Bloco 3 — Dinâmica e loop (5 min)

**Tópicos**

- SEÇÃO 12 — BLOCO 3
- Até 3 rodadas por sessão didática
- Veredito do painel: maioria (≥ 2 de 3 APROVADO)
- Se reprovado e N < 3: volta ao escritor
- Se N = 3: encerra com versão final com ressalvas

**Notas**

Divider. Deixe a regra de maioria explícita para evitar discussão procedural no meio da prática.

## Slide 14 — 3.1 Regra de veredito

**Tópicos**

- Cada revisor: APROVADO ou REPROVADO + bloqueantes
- Comitê aprova se ≥ 2 de 3 APROVADO
- Bloqueante = erro factual, citação inventada, lacuna grave
- Sugestão ≠ bloqueante (não impede sozinha)
- Consolide os três pareceres antes da próxima rodada

**Notas**

Se os três discordarem em 1–1–1, conta como não aprovado (precisa ≥2). Na demo, o instrutor pode forçar um REPROVADO didático na rodada 1.

## Slide 15 — 3.2 Por que limitar a 3 rodadas

**Tópicos**

- Aula de 60 min: uma rodada completa já ensina o padrão
- Loop infinito esconde o custo de orquestração
- Na pesquisa real: prazo e escopo também limitam
- Rodadas 2–3 = homework opcional
- Ao parar: declare 'versão final com ressalvas'

**Notas**

Evite a tentação de 'só mais uma rodada' no projetor. O fechamento didático importa mais que o texto perfeito.

## Slide 16 — 3.3 Artefactos que importam

**Tópicos**

- docs/rascunhos/rodada_N.md — texto do escritor
- docs/pareceres_orientador/rodada_N.md — gate pré-painel
- docs/decisoes.md — sim/não do aluno com data
- docs/pareceres_revisores/rodada_N_*.md — três vereditos
- Sem esses arquivos, a demo não é auditável

**Notas**

Mostre a árvore docs/ no explorador se possível. Auditoria é o argumento a favor de multi-agent neste curso.

---

# Bloco 4 — Missão e regras (4 min)

## Slide 17 — Bloco 4 — Missão e regras (4 min)

**Tópicos**

- SEÇÃO 12 — BLOCO 4
- Tema: evolução da seleção genômica
- Estrutura de ≤ 4 páginas; na aula: 600–900 palavras
- Só referências da lista fechada em referencias/
- Rótulos: [LISTA] [INFERÊNCIA] [CONHECIMENTO GERAL]

**Notas**

Divider curto antes da prática. Abra MISSAO.md e referencias/README.md na tela se der tempo.

## Slide 18 — 4.1 Arco do texto (quatro partes)

**Tópicos**

- 1 Antecedentes: MAS e limite de poucos marcadores
- 2 Marco: Meuwissen, Hayes & Goddard (2001) e GBLUP
- 3 Ampliação: Bayes*, G×E, multi-ômicas (alto nível)
- 4 Limites: validação, viés, diversidade
- Não precisa de equações na demo

**Notas**

Âncora à sessão 06 (GBLUP) e 08 (paper 2001). Peça narrativa histórica + cautela, não tutorial de implementação.

## Slide 19 — 4.2 Anti-alucinação (regras duras)

**Tópicos**

- Proibido inventar DOI, ano ou título
- Citar só o que está em referencias/README.md → [LISTA]
- Se generalizar sem item da lista → [CONHECIMENTO GERAL]
- Se deduzir a partir do texto → [INFERÊNCIA]
- Orientador e revisores tratam citação inventada como bloqueante

**Notas**

Repita a sessão 08: alucinação de citação é o erro que o painel deve pegar. Se o escritor inventar, o gate do aluno deve barrar o envio.

## Slide 20 — 4.3 Abrir a prática

**Tópicos**

- No Cursor/Claude Code: File → Open Folder
- Escolha 12. Multi Agents/projeto-revisao-gs
- Não abra a pasta da seção inteira
- Siga roteiro_aula.md (prompts copy-paste)
- Comece pela rodada 1 com /escritor

**Notas**

Transição para a prática. Confirme que a pasta aberta é projeto-revisao-gs. Depois disso, saia do modo slides e use o roteiro.

## Slide 21 — Takeaways

**Tópicos**

- Multi-agent = papéis + entregas + contexto limpo
- O aluno no gate é parte do sistema, não ruído
- Veredito e limite de rodadas evitam loop infinito
- Lista fechada e rótulos reduzem citação inventada
- Mesma filo da sessão 05, agora em texto científico

**Notas**

Feche em um minuto. Se sobrar tempo, pergunte: onde mais no programa de melhoramento um painel de agentes faria sentido (QC, OCS, decisão de avanço)?

## Slide 22 — O que fazer depois

**Tópicos**

- Completar rodadas 2–3 em casa (opcional)
- Comparar um único chat vs esta pasta docs/
- Relacionar com sessão 11 (agentes sob regra e responsabilidade)
- Não publicar o esboço como revisão formal
- Rebuild do deck: _build_pptx.ps1

**Notas**

Agradeça. Lembre que o material é demonstração didática. Encaminhe dúvidas de instalação Claude Code ao guia da sessão 05.

