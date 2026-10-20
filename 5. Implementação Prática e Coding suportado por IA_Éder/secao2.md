# Seção 2 — Notas do professor (4 h): Claude Code no VS Code

## Estrutura
| Bloco | Tema | Tempo | Prática |
|---|---|---|---|
| 0 | Do chat ao agente de código | 15 min | — |
| 1 | Ambiente: editores, instalação e primeiro acesso | 20 min | Prática 0 (5 min) |
| 2 | Configuração, permissões e segurança dos dados | 20 min | Prática 2 (5 min) |
| 3 | Pasta de projeto, `CLAUDE.md` e arquivos de contexto | 35 min | Prática 1 (15 min) |
| — | Intervalo | 10 min | |
| 4 | Planejar antes de analisar | 25 min | Prática 3 (15 min) |
| 5 | Executar e verificar | 35 min | Prática 4 (25 min) |
| 6 | Gerenciar o contexto das sessões | 15 min | — |
| — | Intervalo | 10 min | |
| 7 | Subagentes: orientando e orientador | 35 min | Prática 5 (25 min) |
| 8 | Skills e ferramentas | 15 min | Prática 6 (10 min) |
| 9 | Síntese | 5 min | — |

A Prática 2 (configurações) acontece depois da Prática 1 (pasta), embora o Bloco 2 venha
antes: no Bloco 2 só se mostra; a pasta com `.claude/settings.json` só existe após a
Prática 1. Se a turma estiver rápida, faça a Prática 2 logo após a Prática 1.

**Se atrasar, corte nesta ordem:** Slide 1.5 (tour, mostrado ao vivo), Slide 2.6
(modelo e limites), Slide 3.7, Slide 8.5 (MCP, vira demonstração de 2 min), Prática 6.
**Não corte** o Bloco 5 nem a Prática 5: são a mensagem da seção.

## Pré-requisitos (uma semana antes)
- Confirmar com a coordenação a forma de acesso (`docs/logistica.md`). O plano gratuito
  do claude.ai não inclui o Claude Code. Sem acesso para todos: duplas.
- Enviar `guia_instalacao.md` e marcar a sessão de suporte de 1 h. Pedir que tragam
  print do `Rscript setup/verificar_instalacao.R` e do `/status`.
- Computadores institucionais costumam bloquear instaladores: avisar com antecedência.
- Conferir ⚙️ na documentação (code.claude.com/docs): comandos de instalação, rótulos
  dos modos de permissão, `/plan`, atalhos do VS Code, `/plugins`, campos de subagente.
  Conferido em 17/10/2026 (Claude Code 2.1.2xx).

## Pontos de atenção técnicos (conferidos na documentação em out/2026)
- **Modo inicial Auto.** Nas versões recentes, sessões novas começam em Auto. Para o
  primeiro contato, peça Manual/Plan pelo indicador. A extensão do VS Code **não** lê o
  `defaultMode` do `.claude/settings.json` do projeto para escolher o modo inicial; as
  regras `allow/ask/deny` do projeto, sim.
- **`Edit(...)` em `deny` não protege contra scripts.** A regra vale para as ferramentas
  de arquivo e para comandos reconhecidos (`cat`, `sed`, `>`), não para um `Rscript` que
  grava arquivos. Daí o `chmod -R a-w data/bruto` (ou atributo somente leitura no Windows).
  Sandbox (`/sandbox`) só em macOS, Linux e WSL2.
- **Não existe regra `Write(...)`** para caminhos: use `Edit(...)`. Uma regra
  `Write(caminho)` é aceita mas nunca consultada (o Claude Code avisa na inicialização).
- **Caminhos nas regras:** `/data/bruto/**` é relativo à pasta das configurações
  (raiz do projeto); `./` é relativo ao diretório atual; `//` é absoluto.
- **`/agents`** não abre mais um assistente de criação: orienta a pedir ao Claude ou a
  editar `.claude/agents/`. Por isso o Slide 7.2 mostra as duas formas.
- **Subagentes podem criar subagentes** (até 3 níveis por padrão). O arranjo orientando–
  orientador funciona pelo agente principal; *agent teams* (conversa direta entre
  agentes) é experimental e desligado por padrão (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`).
- **A extensão não coloca `claude` no PATH.** Quem só instalou a extensão não consegue
  rodar `claude mcp add` nem `claude plugin install` no terminal.
- **Positron:** extensão do Claude Code via Open VSX, às vezes defasada; o terminal
  integrado sempre funciona. **Antigravity:** há relatos de falha da extensão; usar o
  terminal.
- `/plan <tarefa>` no VS Code exige Claude Code 2.1.280 ou mais recente.

## Números citados nos slides
Script: `gabarito_vcu-milho-2025/analise_referencia.R` (rodar da pasta da seção; detalhes
em `gabarito_vcu-milho-2025/numeros_referencia.md`). A acurácia exige
`valores_verdadeiros.csv` exportado do `ciclo-gs-milho`.

| Slide | Número | Origem |
|---|---|---|
| 0.3, 5.5 | 2.426 linhas; 14 erros (5 IDs, 2 duplicatas, 7 fora do intervalo) | `erros_injetados.csv`, safra 2025 |
| 5.5 | 2.424 parcelas; 7 ausentes; 404 genótipos (409 sem normalizar) | script |
| 0.3, 5.6 | CV 4,9 / 5,4 / 5,2%; h² 0,46 / 0,51 / 0,42 (com QC) | script; iguais aos da Seção 1 (Slide 3.6) |
| 0.3, 5.6 | Sem QC: CV 31,9 / 43,4 / 5,2%; h² 0,016 / 0,015 / 0,43 | script |
| 0.3, 7.7 | Acurácia 0,82 com QC; 0,24 sem QC (400 DH25 × `gv_testcross`) | script |
| 0.3, 7.7 | DH25_0232: 1ª sem QC; 259ª com QC; 138ª no valor verdadeiro | script |
| 4.5 | 9,01 → 9.010 por conversão; verdadeiro 9.012,1 | `erros_injetados.csv` (P_SLG_2025_V_0538) |

O arquivo `vcu-milho-2025/data/bruto/vcu_milho_2025_campo.csv` é a tabela `bruto_parcelas` do
`ciclo-gs-milho` (safra 2025), ordenada por `parcela_id` (md5
`df0d877d00fc9880a8571712de313fbc`). É a mesma safra usada nos exemplos da Seção 1.

## Pontos de discussão que costumam render
- **"O código rodou, então está certo."** Mostre o Slide 0.3: sem QC, tudo roda e a
  acurácia cai de 0,82 para 0,24. A pior linhagem vira a campeã.
- **Conversão de unidade "óbvia".** Muitos alunos aprovam o plano que multiplica 9,01 por
  1.000. O valor verdadeiro era 9.012,1: a conversão é um palpite. Vale como regra de
  projeto (registrada) ou NA; nunca decisão silenciosa do agente.
- **Ordem do QC.** Normalizar IDs antes de checar duplicatas e conectividade (Seção 1).
- **O orientador que acha problema em tudo.** Mostre o trecho da descrição que separa
  bloqueantes de sugestões; peça que comparem dois pareceres.
- **Mesmo modelo nos dois papéis.** Pergunte o que um orientador humano veria que o
  subagente não vê (conhecimento do programa, do local, do histórico do ensaio).

## Pontos de intervenção
- Aluno em modo Auto desde o início: volte para Manual; o objetivo é ver cada ação.
- Agente que tenta editar `data/bruto/`: ótimo momento para mostrar a negação e o
  `chmod`. Se um script tiver gravado lá, `git status` mostra e `git restore` desfaz.
- Sessão com várias correções seguidas: `/clear` e um prompt melhor (Slide 5.1).
- Contexto cheio na Prática 5: rodar `/context`; o orientando deve devolver resumo, não
  o código inteiro.
- Aluno que cola a saída inteira do modelo no chat: peça que grave em arquivo.

## Análise crítica dos tópicos
Ver `planejamento/analise_secao2_claude_code.md`.
