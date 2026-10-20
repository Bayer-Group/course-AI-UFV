# Seção 2 — Claude Code no VS Code: do primeiro contato a uma análise reproduzível

**Carga:** 4 h · **Prática:** `caderno.md` · **Instalação:** `guia_instalacao.md` (antes da aula) · **Dados:** `dados/vcu_milho_2025_campo.csv`

> **Fio condutor:** um ensaio de VCU de milho de 2025 (3 locais, 404 genótipos, 2.426 parcelas) chega do campo com erros de digitação. Ao longo da seção, a turma monta a pasta de análise, escreve o contexto, planeja, executa e revisa a análise com o Claude Code, conferindo cada etapa contra uma resposta conhecida.
>
> **Mensagem:** o agente acelera a análise; a pasta organizada, o plano revisado e a verificação independente é que a tornam correta e reproduzível.

| Bloco | Tema | Tempo |
|---|---|---|
| 0 | Do chat ao agente de código | 15 min |
| 1 | Ambiente: editores, instalação e primeiro acesso | 20 min |
| 2 | Configuração, permissões e segurança dos dados | 20 min |
| 3 | Pasta de projeto, `CLAUDE.md` e arquivos de contexto | 35 min |
| — | Intervalo | 10 min |
| 4 | Planejar antes de analisar | 25 min |
| 5 | Executar e verificar | 35 min |
| 6 | Gerenciar o contexto das sessões | 15 min |
| — | Intervalo | 10 min |
| 7 | Subagentes: orientando e orientador | 35 min |
| 8 | Skills e ferramentas | 15 min |
| 9 | Síntese: reprodutibilidade e uso responsável | 5 min |

⚙️ marca instruções específicas do Claude Code (comandos, atalhos, nomes de arquivos de configuração). Elas mudam com frequência: conferidas em outubro de 2026 em https://code.claude.com/docs.

---

## Bloco 0 — Do chat ao agente de código

### Slide 0.1 — O que muda em relação ao chat
| | Chat (claude.ai, ChatGPT) | Agente de código (Claude Code) |
|---|---|---|
| Onde trabalha | Na janela da conversa | Na **pasta do projeto**, no seu computador |
| O que vê | O que você cola | Os arquivos que ele mesmo abre e as saídas dos comandos |
| O que faz | Sugere código | **Escreve** arquivos, **roda** scripts, lê o erro e corrige |
| Quem executa | Você copia, cola e roda | O agente, com a sua permissão |
| O que fica | Uma conversa | Arquivos versionados no projeto |

> A pergunta deixa de ser "qual é o código?" e passa a ser "o que o agente precisa saber, o que ele pode fazer e como eu confiro o que ele fez?".

### Slide 0.2 — O ciclo de um agente

<div class="fluxo"><div><b>Pedido</b><span>prompt + contexto da pasta</span></div><div><b>Explora</b><span>lê arquivos, procura padrões</span></div><div><b>Planeja</b><span>decide os passos</span></div><div><b>Age</b><span>edita, roda comandos</span></div><div><b>Verifica</b><span>lê a saída, roda testes</span></div><div><b>Repete</b><span>até "parecer pronto"</span></div></div>

- O agente para quando o trabalho **parece** pronto. Se não houver uma verificação que ele possa rodar, quem verifica é você.
- Cada arquivo lido e cada saída de comando ocupam a **janela de contexto**, a memória de trabalho da sessão, que é limitada e se degrada quando enche.
- O mesmo pedido pode gerar códigos diferentes em sessões diferentes: a reprodutibilidade está no **código versionado**, não na conversa.

### Slide 0.3 — O exemplo desta seção
- Ensaio de VCU de milho, safra 2025: linhagens DH em **testcross**, 3 locais (UDI, SLG, PGO), blocos casualizados com 2 blocos.
- O arquivo veio do campo com **14 erros**: 5 identificadores fora do padrão, 2 parcelas duplicadas e 7 valores fora do intervalo (como 104.613 kg/ha).
- Os dados são simulados: sabemos o valor genético verdadeiro de cada linhagem e, portanto, se a análise está certa.

| Análise | CV em PGO | h² de médias em PGO | Acurácia dos BLUPs |
|---|---|---|---|
| Sem QC (o código roda sem erro) | 31,9% | 0,02 | 0,24 |
| Com QC e curadoria | 4,9% | 0,46 | 0,82 |

<p class="fonte">Acurácia = correlação entre BLUP e valor genético verdadeiro de testcross das 400 linhagens DH25. Sem QC, a linhagem DH25_0232 (parcela de 104.613 kg/ha) fica em 1º lugar; com QC, em 259º.</p>

---

## Bloco 1 — Ambiente: editores, instalação e primeiro acesso

### Slide 1.1 — Por que um editor, e não só o terminal
- O agente trabalha em arquivos; o editor mostra **o que mudou** (diff lado a lado), a árvore da pasta e o terminal no mesmo lugar.
- No VS Code, o Claude Code roda como **extensão** (painel gráfico) ou no **terminal integrado** (linha de comando). Os dois compartilham configurações e histórico.
- Você continua no controle: aprova edições, lê o diff, roda o script.

### Slide 1.2 — Editores possíveis
| Editor | O que é | Para o curso |
|---|---|---|
| **VS Code** (Microsoft) | Editor gratuito; extensões do Visual Studio Marketplace | **Padrão da turma**: extensão oficial do Claude Code |
| **Positron** (Posit) | Derivado do VS Code para ciência de dados em R e Python; console, visualizador de dados e gráficos | Ótimo para quem vive no R; extensões vêm do Open VSX, onde a do Claude Code pode atrasar; o terminal sempre funciona |
| **Cursor** | Derivado do VS Code com agente de IA próprio; plano gratuito limitado e planos pagos | A extensão do Claude Code tem instalação oficial; cuidado para não usar dois agentes ao mesmo tempo |
| **Antigravity** (Google) | Editor "agent-first" derivado do VS Code, lançado em nov/2025, com modelos Gemini e outros | Tem agentes próprios; há relatos de falha da extensão do Claude Code; use o terminal |

<p class="fonte">Positron: positron.posit.co (extensões via Open VSX). Cursor e outros derivados: code.claude.com/docs/en/vs-code. Antigravity: anunciado em 18/11/2025.</p>

### Slide 1.3 — Instalação, na ordem (antes da aula) ⚙️
1. **VS Code**: code.visualstudio.com → instalador do seu sistema.
2. **R** (≥ 4.3), **Rtools** no Windows, e no VS Code a extensão **R** (`REditorSupport.r`) com `install.packages(c("languageserver", "httpgd"))`.
3. **Git** (no Windows, o Git for Windows, que também fornece o Git Bash usado pelo Claude Code).
4. **Claude Code (linha de comando)**, no terminal:
```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash
# Windows PowerShell
irm https://claude.ai/install.ps1 | iex
```
5. **Extensão Claude Code** no VS Code: `Ctrl+Shift+X` (`Cmd+Shift+X` no Mac) → "Claude Code" (publicada pela Anthropic) → Install.

<p class="fonte">Passo a passo por sistema operacional, alternativas (Homebrew, WinGet) e solução de problemas: guia_instalacao.md.</p>

### Slide 1.4 — Verificar e entrar ⚙️
```bash
claude --version     # imprime a versão: a instalação funcionou
claude doctor        # diagnóstico da instalação e das configurações
claude               # primeira execução: abre o navegador para login
```
- O Claude Code exige conta **Pro, Max, Team, Enterprise** ou **Console** (API). O plano gratuito do claude.ai não inclui o Claude Code.
- No VS Code: ícone ✻ (Spark) no canto superior direito do editor ou na barra lateral → **Sign in**.
- `/status` mostra versão, conta e modelo em uso; `/logout` troca de conta.
- A extensão **não** coloca `claude` no PATH: comandos de terminal (`claude mcp add`, `claude plugin install`) exigem a instalação do passo 4.

### Slide 1.5 — Um tour pelo painel ⚙️
| Elemento | Para que serve |
|---|---|
| Caixa de prompt | Pedido em linguagem natural; `@arquivo` anexa um arquivo; texto selecionado no editor vai junto |
| Indicador de modo (rodapé) | Modo de permissão: Manual, Edit automatically, Plan, Auto |
| `/` | Menu de comandos: modelo, memória, permissões, plugins, skills |
| Indicador de contexto | Quanto da janela de contexto já foi usada |
| Diff lado a lado | Mostra a edição proposta; aceitar, rejeitar ou corrigir |
| Botão de voltar (rewind) | Desfaz o código e/ou a conversa até um ponto anterior |

- Atalhos: `Ctrl+Esc` (`Cmd+Esc`) alterna o foco entre editor e Claude; `Alt+K` (`Option+K`) insere `@arquivo#linhas` da seleção.

---

## Bloco 2 — Configuração, permissões e segurança dos dados

### Slide 2.1 — Onde ficam as configurações ⚙️
| Escopo | Arquivo | Vale para | Vai para o Git? |
|---|---|---|---|
| Usuário | `~/.claude/settings.json` | Todos os seus projetos | Não |
| Projeto | `.claude/settings.json` | Todos que trabalham no projeto | **Sim** |
| Local | `.claude/settings.local.json` | Só você, neste projeto | Não |
| Organização | arquivo gerenciado pela TI | Todos da instituição | — |

- Precedência: organização > linha de comando > local > projeto > usuário.
- As mesmas pastas guardam `CLAUDE.md`, subagentes (`agents/`) e skills (`skills/`): no nível do usuário em `~/.claude/` e no nível do projeto em `.claude/`.
- Regra prática: o que o projeto **exige** vai no `.claude/settings.json` versionado; preferências pessoais, no nível do usuário.

### Slide 2.2 — Modos de permissão ⚙️
| Modo | O que roda sem perguntar | Quando usar |
|---|---|---|
| **Manual** (`default`) | Só leituras | Primeiro contato; dados sensíveis |
| **Edit automatically** (`acceptEdits`) | Leituras e edições de arquivos | Quando já está revisando o diff com atenção |
| **Plan** (`plan`) | Leituras; nenhuma edição | Explorar e planejar antes de mudar algo |
| **Auto** (`auto`) | Quase tudo; um classificador barra ações arriscadas | Tarefas longas, com Git e regras de negação já configurados |
| `bypassPermissions` | Tudo | Só em contêiner ou máquina virtual isolada; nunca no seu computador |

- Alternar: `Shift+Tab` no terminal; indicador de modo no rodapé do painel no VS Code.
- Nas versões recentes, a sessão **começa em Auto**. Nesta seção, comece em **Manual** ou **Plan**: o objetivo é ver cada ação.

### Slide 2.3 — Regras de permissão: o que o projeto permite e proíbe ⚙️
`.claude/settings.json` da pasta de análise:
```json
{
  "permissions": {
    "allow": ["Bash(Rscript *)", "Bash(git status)", "Bash(git diff *)", "Bash(git log *)"],
    "ask":   ["Bash(git commit *)"],
    "deny":  ["Edit(/data/bruto/**)", "Bash(rm *)", "Bash(git push *)"]
  }
}
```
- Ordem de avaliação: **deny → ask → allow**. Uma regra de negação vale em **todos** os modos, inclusive no Auto.
- `/data/bruto/**` é relativo à pasta do projeto; `//caminho` é absoluto; `~/` é a pasta pessoal.
- `/permissions` (ou Customize → Permissions no VS Code) mostra as regras ativas e de onde vieram.

### Slide 2.4 — Limites das regras e camadas de proteção
- `Edit(...)` e `Read(...)` valem para as ferramentas de arquivo do agente e para comandos de shell que ele reconhece (`cat`, `sed`, redirecionamento `>`).
- **Não** valem para um script que abre arquivos por conta própria: um `Rscript` que grava em `data/bruto/` passa pela regra.
- Por isso, proteja em camadas:

<div class="camadas"><div class="c1"><b>Sistema operacional</b><span>data/bruto/ somente leitura (chmod -R a-w no Linux/macOS; atributo "Somente leitura" no Windows)</span></div><div class="seta">e</div><div class="c2"><b>Regras do agente</b><span>deny para Edit e comandos perigosos; ask para commit</span></div><div class="seta">e</div><div class="c3"><b>Git</b><span>qualquer alteração aparece no git status e pode ser desfeita</span></div></div>

<p class="fonte">Isolamento no nível do sistema para todos os processos: sandbox do Claude Code (/sandbox), disponível em macOS, Linux e WSL2.</p>

### Slide 2.5 — Segurança e governança dos dados
- Tudo o que o agente lê (arquivos, saídas de comandos) é enviado ao serviço do modelo para ser processado.
- Antes de abrir o agente em uma pasta com dados reais:
    1. Confira a política da instituição, os contratos e os termos de transferência de material (germoplasma, pedigree, marcadores de parceiros).
    2. Confira os termos de uso do **seu plano** (individual, institucional ou API).
    3. Minimize: subconjuntos, IDs codificados, sem dados pessoais.
    4. Bloqueie pastas sensíveis com `Read(...)` em `deny`.
    5. Nunca coloque senhas ou chaves em arquivos do projeto ou em prompts.
- Arquivos versionados de terceiros (um `.claude/settings.json`, um plugin) podem rodar comandos: leia antes de confiar.

<p class="fonte">Ver docs/governanca_dados.md do curso.</p>

### Slide 2.6 — Modelo, esforço e limites de uso ⚙️
- `/model` escolhe o modelo e o nível de esforço de raciocínio: mais esforço = respostas melhores em problemas difíceis, mais tempo e mais uso.
- Os planos têm **limites de uso** por período; `/usage` mostra o consumo. Sessões longas e arquivos grandes consomem mais.
- O que mais gasta: ler arquivos grandes inteiros, saídas extensas de comandos, conversas que nunca são limpas.
- Boa prática: tarefas focadas, `/clear` entre tarefas, resultados grandes gravados em arquivo e resumidos.

---

## Bloco 3 — Pasta de projeto, `CLAUDE.md` e arquivos de contexto

### Slide 3.1 — A pasta da análise (retomando a Seção 1)
```
2026-11_vcu-milho-2025/
├── CLAUDE.md                 contexto e regras para o agente
├── README.md  PLANO.md       pergunta, como reproduzir, etapas e critérios
├── config/parametros.yaml
├── data/bruto/               vcu_milho_2025_campo.csv (somente leitura) + LEIA-ME.md
├── data/intermediario/  data/processado/
├── docs/                     dicionário, registro de correções, decisões, etapas/
├── R/                        01_importar … 05_figuras_tabelas
├── output/  tests/
└── .claude/                  settings.json, agents/, skills/
```
- Ponto de partida: `modelos/projeto-analise/` do repositório do curso.
- Abra a **pasta** no VS Code (File → Open Folder): o Claude Code trabalha a partir dela.

### Slide 3.2 — Criar a pasta, passo a passo
```bash
cp -r curso-ia-melhoramento/modelos/projeto-analise ~/analises/2026-11_vcu-milho-2025
cd ~/analises/2026-11_vcu-milho-2025
cp <curso>/secoes/02_claude_code_vscode/dados/vcu_milho_2025_campo.csv data/bruto/
cp <curso>/secoes/02_claude_code_vscode/dados/dicionario_de_dados.csv docs/
chmod -R a-w data/bruto                     # somente leitura (Linux/macOS)
git init && git add . && git commit -m "Estrutura inicial e dados brutos"
code .                                       # abre a pasta no VS Code
```
- O commit inicial é o **ponto zero**: qualquer mudança do agente aparece no `git diff`.
- No Windows: botão direito em `data\bruto` → Propriedades → Somente leitura; os demais comandos rodam no Git Bash.

### Slide 3.3 — O que é o `CLAUDE.md`
- Arquivo de instruções que o Claude Code **lê no início de toda sessão**. É o "prompt permanente" do projeto.
- Hierarquia (todos são somados, não substituídos): ⚙️

| Arquivo | Escopo |
|---|---|
| `~/.claude/CLAUDE.md` | Suas preferências em todos os projetos |
| `./CLAUDE.md` ou `./.claude/CLAUDE.md` | O projeto; versionado no Git |
| `./CLAUDE.local.md` | Suas notas pessoais neste projeto; fora do Git |
| `subpasta/CLAUDE.md` | Carregado quando o agente trabalha naquela subpasta |

- `/init` gera um rascunho analisando a pasta. Numa análise que ainda não tem código, ele vê pouco: parta do modelo do curso e refine.
- `/memory` (Customize → Instructions no VS Code) abre os arquivos carregados.

### Slide 3.4 — Boas práticas para o `CLAUDE.md`
| ✅ Incluir | ❌ Deixar de fora |
|---|---|
| Pergunta da análise e para quem | O que o agente descobre lendo o código |
| Regras de dados: o que é somente leitura, como corrigir | Convenções que o R já impõe |
| Comandos para rodar e testar | Tutoriais e explicações longas |
| Decisões científicas: modelo de referência, como tratar ausentes e outliers | Informação que muda toda semana |
| Armadilhas não óbvias do projeto | Generalidades como "escreva código limpo" |

- **Curto**: menos de 200 linhas. Para cada linha: "se eu apagar, o agente erra?". Se não, apague.
- Arquivo longo demais faz o agente **ignorar** regras importantes.
- Trate como código: versione, revise quando o agente errar, pode e corte.

<p class="fonte">code.claude.com/docs/en/best-practices e /memory.</p>

### Slide 3.5 — Um `CLAUDE.md` de análise: cada linha elimina uma decisão
```markdown
## Pergunta
Ranking das linhagens DH25 por valor de testcross para PROD (kg/ha) nos 3 ambientes de 2025.

## Dados
- data/bruto/ é SOMENTE LEITURA. Correções só via docs/registro_de_correcoes.csv (R/03_curar.R).
- Dicionário em docs/dicionario_de_dados.csv: intervalos, unidades e padrão de IDs.

## Regras de análise
- Dados de parcela, nunca médias. Valor fora do intervalo vira NA com registro; não "corrija" sem evidência.
- Modelo conjunto: PROD ~ ambiente + (1|ambiente:bloco) + (1|genotipo) + (1|genotipo:ambiente).
- h² de médias por ambiente: s2g / (s2g + s2e/r).

## Forma de trabalho
- Plano antes de código. Cada script com cabeçalho e teste em tests/. Rode com Rscript.
- Ao fim de cada etapa, relatório em docs/etapas/ (skill /relatorio-etapa).
```

### Slide 3.6 — Arquivos de contexto: o que o agente precisa e quando
| Arquivo | Quando entra no contexto | Para quê |
|---|---|---|
| `CLAUDE.md` | Sempre, no início | Regras que valem em toda sessão |
| `README.md`, `PLANO.md` | Quando citado (`@PLANO.md`) ou lido | Pergunta, etapas e critérios de aceitação |
| `docs/dicionario_de_dados.csv` | Quando a tarefa envolve os dados | Unidades, intervalos, padrão de IDs |
| `docs/decisoes.md` | Antes de decidir algo de novo | Não refazer nem contradizer decisões |
| `docs/etapas/NN.md` | No início da etapa seguinte | Passar o estado entre sessões sem depender da conversa |
| Cabeçalhos dos scripts | Quando o script é lido | Entradas, saídas e premissas de cada etapa |
| Skills (`.claude/skills/`) | Só a descrição sempre; o conteúdo quando usado | Procedimentos que só valem às vezes |

> O `CLAUDE.md` diz **como** trabalhar; os demais arquivos dizem **o que** existe. A conversa é descartável; os arquivos ficam.

### Slide 3.7 — Por que contexto escrito vale mais que um prompt longo
- O prompt vale para uma conversa; o arquivo vale para todas as sessões, para todos os colegas e para você daqui a seis meses.
- Um arquivo é revisável e versionado: se o agente errou por falta de contexto, a correção fica registrada.
- Prompt com contexto mínimo e arquivos certos:
```
@PLANO.md Etapa 02. Siga o CLAUDE.md e o dicionário. Plano primeiro.
```
- Prompt longo, sem arquivos: o agente decide sozinho unidade, intervalos, modelo e onde gravar, e cada sessão decide diferente.

### Slide 3.8 — Primeira sessão: só leitura
No modo **Plan** ou **Manual**:
```
Leia CLAUDE.md, README.md, data/bruto/LEIA-ME.md e docs/dicionario_de_dados.csv.
Em até 10 linhas: o que você entendeu sobre os dados, o que é proibido fazer
e o que ainda está ambíguo. Não altere nenhum arquivo.
```
- Se a resposta errar a unidade, o delineamento ou a proibição do bruto, o problema está no contexto, não no agente.
- O que ficou ambíguo vai para o `CLAUDE.md` ou para o dicionário. Commit.

---

## Bloco 4 — Planejar antes de analisar

### Slide 4.1 — Explorar, planejar, executar, registrar

<div class="fluxo"><div><b>Explorar</b><span>modo Plan: ler, perguntar</span></div><div><b>Planejar</b><span>plano escrito, revisado por você</span></div><div><b>Executar</b><span>uma etapa por vez</span></div><div><b>Verificar</b><span>teste e evidência</span></div><div><b>Registrar</b><span>relatório da etapa e commit</span></div></div>

- O plano separa **o que fazer** de **como fazer**: é muito mais barato corrigir um plano do que um código.
- Pule o plano só quando a mudança cabe em uma frase (renomear uma variável, corrigir um rótulo).

### Slide 4.2 — Modo de planejamento ⚙️
- **VS Code**: indicador de modo → **Plan**, ou digite `/plan` seguido da tarefa.
- **Terminal**: `Shift+Tab` até aparecer `plan mode on`, ou `claude --permission-mode plan`.
- No modo Plan o agente lê, pesquisa e pergunta, mas **não edita**.
- No VS Code, o plano abre como documento Markdown: você pode comentar trechos antes de aprovar. No terminal, `Ctrl+G` abre o plano no editor.
- Aprovar o plano libera a execução; rejeitar com comentários gera uma nova versão.

### Slide 4.3 — Pedir um plano bom
```
/plan @PLANO.md Etapas 01 a 03 (importar, QC, curar).
Siga o CLAUDE.md e docs/dicionario_de_dados.csv. Para cada etapa diga:
arquivos lidos e gravados; regras de QC; o que vira NA e o que é corrigido;
como vamos testar (incluindo um teste com erros injetados); e o que está ambíguo.
```
- Peça explicitamente **como verificar** e **o que está em aberto**.
- Para análises novas e mal definidas: peça que o agente **entreviste você** antes de escrever o plano ("faça perguntas até cobrir modelo, dados, casos especiais e critérios; depois escreva o plano").

### Slide 4.4 — Como avaliar se o plano está bom
| Pergunta | Sinal de plano fraco |
|---|---|
| Responde à pergunta do README e diz o que fica fora? | Escopo aberto, "e outras análises" |
| Nomeia arquivos lidos e gravados? | "Vou processar os dados" |
| Explicita as decisões científicas? | "Vou ajustar o modelo adequado" |
| Bate com `CLAUDE.md`, dicionário e decisões? | Contradiz uma regra escrita |
| Diz como saber que está certo **antes** de rodar? | Nenhum teste, nenhum número esperado |
| Passos pequenos e verificáveis? | Uma etapa que faz tudo |
| Lista premissas e perguntas em aberto? | Decide em silêncio |
| Usa funções que existem e parâmetros do YAML? | Pacote inventado, número fixo no código |

<p class="fonte">Checklist completo: exemplos/docs/checklist_plano.md.</p>

### Slide 4.5 — Exemplo: corrigir um plano antes de aprovar
**Trecho do plano proposto:**
> "Remover outliers acima de 3 desvios-padrão e converter valores abaixo de 100 de t/ha para kg/ha."

<<>>

**Comentário do pesquisador:**
- Outlier estatístico não é erro (Seção 1): sinalize, não remova.
- 9,01 "em t/ha" vira 9.010, mas o valor verdadeiro era 9.012,1: a conversão é um palpite. Regra do `CLAUDE.md`: valor fora do intervalo vira NA, com registro.
- Antes de aprovar: o plano diz quantos casos espera encontrar?

> Revisar o plano é onde o conhecimento de melhoramento entra. O agente não sabe o que o seu programa considera erro.

---

## Bloco 5 — Executar e verificar

### Slide 5.1 — Executar uma etapa por vez
- Aprovado o plano, peça **uma etapa**: "Execute a Etapa 01 do plano. Rode o teste e mostre a saída."
- No modo Manual, cada edição aparece como **diff lado a lado**: aceite, rejeite ou edite antes de aceitar.
- Quando o agente sair do rumo: `Esc` interrompe e permite redirecionar; não espere ele terminar.
- Corrigiu duas vezes e o erro persiste? `/clear` e um prompt melhor, que já inclua o que você aprendeu.

### Slide 5.2 — Git e checkpoints: como desfazer ⚙️
| Ferramenta | Desfaz | Limite |
|---|---|---|
| **Rewind** (botão ao passar o mouse sobre uma mensagem; `Esc Esc` ou `/rewind` no terminal) | Código e/ou conversa até aquele ponto | Só edições feitas pelas ferramentas do agente; não desfaz o que um script gravou |
| **Git** (`git diff`, `git restore`, `git revert`) | Qualquer mudança em arquivos versionados | Precisa de commits frequentes |

- Commit ao fim de **cada etapa verificada**: o histórico vira o caderno de laboratório da análise.
- "Desfaça o que você fez" também funciona, mas o Git é a garantia.

### Slide 5.3 — A pergunta central: o agente fez o que foi pedido?
- O agente diz "pronto" quando o código roda. **Rodar não é estar certo.**
- No exemplo: sem QC, o script roda sem erro e entrega h² = 0,02 em PGO e SLG.
- Peça **evidência**, não afirmação: o comando executado, a saída, o teste que passou.
- Verifique contra algo que você sabe:
    - erros injetados que o QC tem de achar;
    - contagens que você confere de forma independente;
    - um caso calculado à mão ou um dado simulado com resposta conhecida.

### Slide 5.4 — Checklist de verificação
| Verificação | Como |
|---|---|
| O que mudou? Algo além do pedido? | `git status`, `git diff` |
| O plano foi cumprido item a item? | Releia a etapa no `PLANO.md` |
| Há evidência? | Comando + saída do teste |
| O teste tem resposta conhecida? | Erros injetados, dado simulado |
| Os números-chave batem? | Conferência independente |
| É geneticamente plausível? | 0 ≤ h² ≤ 1, CV do caráter, variâncias positivas, unidades |
| Roda do zero? | Apague o que é gerado e rode na ordem |
| Você explica cada linha e cada número? | Se não, não está pronto |

<p class="fonte">exemplos/docs/checklist_verificacao.md.</p>

### Slide 5.5 — Resultado de referência das etapas 01 a 03
| Verificação do QC | Casos | Tratamento |
|---|---|---|
| ID fora do padrão (`dh25_0266`, `DH25-0287`, `DH25 0138`, ` DH25_0279`…) | 5 | Normalizar (maiúsculas, sem espaços, `_`) e registrar |
| Duplicata por posição (ensaio, linha, coluna) | 2 | Manter uma ocorrência |
| Fora do intervalo 2.000–20.000 kg/ha (104.613; 92.241; 86.200; 9,01; 8,87…) | 7 | NA com registro |
| **Total encontrado / injetado** | **14 / 14** | |

- Depois da curadoria: 2.424 parcelas, 7 valores ausentes, 404 genótipos, todos os IDs no padrão.
- O número de genótipos é uma verificação barata: sem normalizar, o modelo vê **409** "genótipos".

### Slide 5.6 — Resultado de referência da Etapa 04 (análise individual)
| Ambiente | Média (kg/ha) | CV (%) | h² de médias | CV sem QC | h² sem QC |
|---|---|---|---|---|---|
| PGO 2025 | 10.381 | 4,9 | 0,46 | 31,9 | 0,02 |
| SLG 2025 | 9.205 | 5,4 | 0,51 | 43,4 | 0,01 |
| UDI 2025 | 12.152 | 5,2 | 0,42 | 5,2 | 0,43 |

- Modelo por ambiente: `PROD ~ bloco + (1|genotipo)`; h² = s2g / (s2g + s2e/2).
- UDI não tinha valor fora do intervalo: por isso quase não muda.
- Uma única parcela de 104.613 kg/ha destrói a herdabilidade do ensaio inteiro.

---

## Bloco 6 — Gerenciar o contexto das sessões

### Slide 6.1 — A janela de contexto é o recurso mais escasso
- Tudo entra nela: instruções, `CLAUDE.md`, cada arquivo lido, cada saída de comando, cada mensagem.
- Quando enche, o desempenho cai: o agente "esquece" instruções do início e erra mais.
- O Claude Code **compacta** automaticamente (resume a conversa) perto do limite, mas o resumo perde detalhes.
- `/context` mostra o que está ocupando a janela; no VS Code, o indicador fica na caixa de prompt. ⚙️

### Slide 6.2 — Comandos para gerenciar o contexto ⚙️
| Comando | Efeito | Quando |
|---|---|---|
| `/clear` | Começa uma conversa nova (o `CLAUDE.md` é relido) | Entre tarefas ou etapas diferentes |
| `/compact <foco>` | Resume a conversa preservando o foco indicado | Etapa longa que precisa continuar |
| `/rewind` → resumir a partir daqui | Condensa só parte da conversa | Uma tentativa longa que deu errado |
| `/btw <pergunta>` | Pergunta paralela que não entra no histórico | Tirar uma dúvida rápida |
| `/rename`, `claude --resume` | Nomear e retomar sessões | Trabalho em vários dias |

### Slide 6.3 — Estratégia para uma análise em várias sessões
- **Uma etapa por conversa.** No fim da etapa: relatório em `docs/etapas/NN.md` → commit → `/clear`.
- A próxima sessão começa pelos arquivos, não pela memória: `@docs/etapas/03.md @PLANO.md Etapa 04.`
- Investigações amplas ("onde está o problema?") vão para um **subagente**: ele lê muitos arquivos no contexto dele e devolve só o resumo.
- Não cole saídas enormes: peça que o resultado vá para um arquivo e que o agente resuma.
- Falhas típicas: a sessão "pia de cozinha" (muitos assuntos misturados), correções repetidas que poluem o contexto, exploração sem escopo.

---

## Bloco 7 — Subagentes: orientando e orientador

### Slide 7.1 — O que é um subagente
- Um assistente especializado, com **contexto próprio**, instruções próprias, ferramentas limitadas e, se quiser, outro modelo.
- O agente principal delega uma tarefa; o subagente trabalha isolado e devolve **só o resultado**.
- Para que serve:
    - proteger o contexto principal (exploração e leitura volumosa);
    - impor limites (um revisor sem permissão de editar);
    - reutilizar uma função (o mesmo revisor em todos os projetos);
    - revisar com **contexto limpo**, sem o viés de quem escreveu.
- Já vêm prontos: **Explore** (busca somente leitura), **Plan** (pesquisa no modo de plano) e um de uso geral.

### Slide 7.2 — Criar um subagente ⚙️
- É um arquivo Markdown com cabeçalho YAML em `.claude/agents/` (projeto) ou `~/.claude/agents/` (todos os projetos).
- Duas formas: escrever o arquivo, ou pedir: "Crie um subagente em .claude/agents/orientador.md que revise etapas da análise sem editar arquivos".
```markdown
---
name: orientador
description: Revisa criticamente, com contexto limpo, uma etapa implementada
  contra o PLANO.md, o CLAUDE.md e o dicionário. Use depois de cada etapa.
tools: Read, Grep, Glob, Bash
model: inherit
---
Você é o orientador de uma dissertação em genética quantitativa...
```
- Campos principais: `name` e `description` (obrigatórios), `tools`, `disallowedTools`, `model`, `permissionMode`.
- Chamar: em linguagem natural ("use o subagente orientador para…") ou com `@` no prompt.

### Slide 7.3 — Boas práticas para subagentes
- **Uma função por agente**, descrita na `description`: é ela que o agente principal lê para decidir quando delegar.
- **Ferramentas mínimas**: o revisor não precisa de `Edit` nem de `Write`.
- **Entrega definida**: diga exatamente o que devolver (arquivos alterados, comandos e saídas, números-chave, pendências).
- **Contexto explícito**: o subagente não vê a conversa; diga quais arquivos ler.
- **Proibido inventar problema**: um revisor instruído a achar falhas sempre acha alguma. Peça para separar **bloqueantes** de **sugestões** e para dizer "sem bloqueantes" quando for o caso.
- **Versione** os agentes do projeto em `.claude/agents/`: fazem parte do método.

### Slide 7.4 — A metáfora: orientando, orientador e banca

<div class="fluxo"><div><b>Você</b><span>coordena e decide; aprova o plano</span></div><div><b>Orientando</b><span>implementa a etapa; relata com evidência</span></div><div><b>Orientador</b><span>revisa com contexto limpo; parecer</span></div><div><b>Orientando</b><span>responde às pendências bloqueantes</span></div><div><b>Banca: você</b><span>confere números e aceita (ou não)</span></div></div>

- O agente principal faz o papel da secretaria do programa: passa a tarefa, guarda o parecer em arquivo, devolve ao orientando.
- Os subagentes não conversam entre si diretamente: a comunicação passa pelo agente principal e pelos **arquivos** (`docs/revisoes/`).

### Slide 7.5 — O prompt que orquestra
```
Etapa 04 do PLANO.md (análise individual e conjunta).
1. Use o subagente orientando para implementar a etapa.
2. Use o subagente orientador para revisá-la. Salve o parecer em
   docs/revisoes/04_parecer_r1.md.
3. Se houver pendências BLOQUEANTES, devolva o parecer ao orientando e
   repita a revisão. No máximo 2 rodadas.
4. Ao final, mostre: parecer final, git diff --stat e os números-chave.
Não faça commit.
```
- Limite de rodadas: sem ele, os dois podem ficar "polindo" indefinidamente.
- O parecer em arquivo é auditável e vai para o Git junto com o código.

### Slide 7.6 — Limites do arranjo orientando–orientador
- Os dois são o **mesmo modelo**: compartilham pontos cegos. Contexto limpo reduz o viés de confirmação, mas não substitui conhecimento de domínio.
- O orientador só cobra o que está escrito (plano, `CLAUDE.md`, dicionário): regra que não está escrita não é cobrada.
- Revisões sucessivas tendem a **complicar** o código; aceite apenas o que afeta correção ou o plano.
- A palavra final é da banca: **você** confere os números-chave contra a referência.
- Equipes de agentes que conversam diretamente entre si existem (*agent teams*), mas são experimentais e consomem muito mais uso. ⚙️

<p class="fonte">code.claude.com/docs/en/sub-agents e /agent-teams (desativado por padrão).</p>

### Slide 7.7 — Resultado de referência da análise conjunta
| Quantidade | Com QC | Sem QC |
|---|---|---|
| Genótipos no modelo | 404 | 409 |
| Acurácia (BLUP × valor verdadeiro, 400 DH25) | **0,82** | 0,24 |
| Posição de DH25_0232 no ranking (verdadeira: 138ª) | 259ª | **1ª** |

- Modelo: `PROD ~ ambiente + (1|ambiente:bloco) + (1|genotipo) + (1|genotipo:ambiente)`, dados de parcela.
- O orientador que só lê o código não vê esse problema; o que **roda e confere números** vê.

---

## Bloco 8 — Skills e ferramentas

### Slide 8.1 — Skills: procedimentos que o agente carrega quando precisa ⚙️
- Uma skill é uma pasta com `SKILL.md`: descrição + instruções (+ scripts e modelos, se quiser).
- Só a **descrição** fica sempre no contexto; o conteúdo entra quando a skill é usada. Ideal para procedimentos que valem às vezes.
- Onde ficam: `.claude/skills/<nome>/SKILL.md` (projeto) ou `~/.claude/skills/` (todos os projetos).
- Chamar: `/nome-da-skill [argumentos]`, ou o agente usa sozinho quando o pedido combina com a descrição.
- Já vêm com o Claude Code, por exemplo: `/code-review` (revisão do diff em contexto limpo) e `/batch`.
- Skills seguem um padrão aberto (Agent Skills, agentskills.io).

### Slide 8.2 — Transformar um procedimento validado em skill
```markdown
---
name: relatorio-etapa
description: Escreve o relatório de passagem de uma etapa concluída em
  docs/etapas/. Use ao final de cada etapa, antes de /clear.
disable-model-invocation: true
---
Escreva docs/etapas/$ARGUMENTS.md com: o que foi feito; como reproduzir;
números-chave; decisões; pendências. Até 40 linhas. Não faça o commit.
```
- Uso: `/relatorio-etapa 03`.
- `disable-model-invocation: true`: só roda quando **você** chama.
- Primeiro faça o procedimento à mão e valide; depois transforme em skill.

### Slide 8.3 — Procurar e instalar skills (plugins) ⚙️
- Skills de terceiros chegam em **plugins** (pacotes com skills, subagentes, hooks e servidores MCP), distribuídos em **marketplaces**.
- O marketplace oficial da Anthropic (`claude-plugins-official`) vem configurado.

| Onde | Como |
|---|---|
| VS Code | `/plugins` → aba Plugins → buscar → Install → escolher o escopo |
| Terminal | `/plugin` → aba Discover; ou `/plugin install <nome>@claude-plugins-official` |
| Outro marketplace | `/plugin marketplace add <dono>/<repositório>` |

- Escopos: só você (usuário), todos do projeto (projeto, versionado) ou só você neste projeto (local).
- Antes de instalar, leia o que o plugin adiciona: plugins podem rodar comandos e conectar serviços. Prefira fontes conhecidas.
- Cada plugin ocupa contexto: desative o que não usa.

### Slide 8.4 — Dar ferramentas ao agente
| Ferramenta | O que dá ao agente | Exemplo |
|---|---|---|
| **Comandos de terminal** | Usar programas já instalados | `Rscript`, `git`, `duckdb`, `quarto`; "use `ferramenta --help` para aprender" |
| **Servidores MCP** | Acesso padronizado a serviços e dados | Documentação dos pacotes R instalados; banco de dados; GitHub |
| **Hooks** | Ações automáticas e **garantidas** em pontos do fluxo | Rodar os testes a cada edição (Seção 3) |
| **Permissões** | O que pode rodar sem perguntar | `Bash(Rscript *)` em `allow` |

- Instruções no `CLAUDE.md` são **conselhos**; hooks e permissões são **garantias**.

### Slide 8.5 — MCP na prática: o agente consultando o seu R ⚙️
```bash
# no R: install.packages("btw")
claude mcp add -s user r-btw -- \
  Rscript -e "btw::btw_mcp_server(list('docs','pkg','env','sessioninfo','cran'))"
```
- O pacote `btw` (Posit) expõe ao agente a **documentação dos pacotes na versão instalada**, o ambiente e o `sessionInfo()`: menos funções inventadas, menos argumentos de outra versão.
- `claude mcp list` lista os servidores; `/mcp` mostra o estado na sessão.
- Escopos: `local` (padrão, só você neste projeto), `project` (arquivo `.mcp.json` versionado), `user` (todos os seus projetos).
- Servidores de terceiros podem trazer conteúdo malicioso para o contexto: conecte só o que você conhece.

<p class="fonte">posit-dev.github.io/btw/reference/mcp.html; code.claude.com/docs/en/mcp.</p>

---

## Bloco 9 — Síntese: reprodutibilidade e uso responsável

### Slide 9.1 — O que tornou a análise reproduzível
```
Pasta organizada        dado bruto somente leitura; scripts numerados; resultados regeneráveis
Contexto escrito        CLAUDE.md curto; dicionário; PLANO.md com critérios
Plano revisado          modo Plan + checklist; decisões científicas explícitas
Verificação             testes com resposta conhecida; números-chave; git diff
Revisão independente    orientador com contexto limpo; a banca é você
Registro                relatórios de etapa; decisões; commits por etapa
```
> Teste final: outra pessoa clona a pasta, roda os scripts na ordem e obtém os mesmos números, sem abrir o Claude Code.

### Slide 9.2 — Uso responsável na pós-graduação
- Você é autor e responsável por **cada linha de código e cada número**: precisa conseguir explicá-los.
- Declare o uso de IA conforme as normas do programa e do periódico.
- Registre as falhas do agente no **diário de falhas da IA** (modelo em `docs/`): é material de aprendizado e de avaliação.
- O agente acelera o trabalho; a pergunta científica, o delineamento e o julgamento continuam sendo seus.

### Slide 9.3 — Tarefa e próxima seção
1. Conclua as etapas 04 e 05 da análise do VCU e faça o teste do clone limpo.
2. Compare os seus números com os de referência (Slides 5.5, 5.6 e 7.7) e explique qualquer diferença.
3. Registre no diário de falhas pelo menos um erro do agente e o contexto que o teria evitado.
4. **Seção 3:** o mesmo método aplicado a um ciclo completo de seleção genômica (`ciclo-gs-milho`).

### Slide 9.4 — Referências e documentação
- Documentação do Claude Code: https://code.claude.com/docs (instalação, VS Code, memória, permissões, subagentes, skills, plugins, MCP, boas práticas).
- Wilson, G. et al. (2017). Good enough practices in scientific computing. *PLOS Computational Biology*, 13(6), e1005510.
- Positron: https://positron.posit.co · VS Code e R: https://code.visualstudio.com/docs/languages/r
- Pacote `btw`: https://posit-dev.github.io/btw · Padrão Agent Skills: https://agentskills.io
