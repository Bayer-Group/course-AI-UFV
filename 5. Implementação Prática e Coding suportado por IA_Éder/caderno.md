# Seção 2 — Caderno de práticas (4 h)

Primeiro contato com o Claude Code. Cada prática diz **o que fazer**, **o prompt** e
**como conferir**. Os números de referência estão no fim de cada prática.

Arquivos desta pasta:

| Arquivo | Uso |
|---|---|
| `guia_instalacao.md` | Instalação, antes da aula |
| `vcu-milho-2025/` | Pasta da análise, já montada: é ela que você copia |
| `vcu-milho-2025/roteiro_pratica.Rmd` | Roteiro da aula com os prompts de cada prática e os chunks de R para rodar e conferir o que o agente gerou |
| `vcu-milho-2025/data/bruto/vcu_milho_2025_campo.csv` | Dados brutos do ensaio (com erros de digitação) |
| `vcu-milho-2025/data/bruto/LEIA-ME.md`, `docs/dicionario_de_dados.csv` | Descrição e dicionário dos dados |
| `vcu-milho-2025/CLAUDE.md`, `README.md`, `PLANO.md` | Contexto, pergunta e etapas com critérios de aceitação |
| `vcu-milho-2025/config/parametros.yaml` | Intervalos, regex de IDs, caminhos |
| `vcu-milho-2025/.claude/settings.json` | Permissões do projeto |
| `vcu-milho-2025/.claude/agents/orientando.md`, `orientador.md` | Subagentes da Prática 5 |
| `vcu-milho-2025/.claude/skills/relatorio-etapa/SKILL.md` | Skill da Prática 6 |
| `vcu-milho-2025/docs/checklist_plano.md`, `checklist_verificacao.md` | Checklists das Práticas 3 e 4 |
| `vcu-milho-2025/docs/decisoes.md`, `registro_de_correcoes.csv`, `diario_falhas_ia.md`, `governanca_dados.md` | Registros da análise |

Convenção: `<curso>` é a pasta desta seção (onde está este caderno).

---

## Prática 0 — Verificar o ambiente (Bloco 1, 5 min)

No terminal integrado do VS Code (`` Ctrl+` ``):
```bash
claude --version
claude doctor
```
No painel do Claude Code (ícone ✻), digite `/status`.

**Confira:** versão impressa, sem erros no `doctor`, conta correta no `/status`.
Se algo falhar, trabalhe em dupla e resolva no intervalo com o monitor.

---

## Prática 1 — Montar a pasta da análise (Bloco 3, 15 min)

1. Copie a pasta da análise, que já vem montada (estrutura do Slide 3.1):
   ```bash
   cp -r <curso>/vcu-milho-2025 ~/analises/2026-11_vcu-milho-2025
   cd ~/analises/2026-11_vcu-milho-2025
   ```
2. Proteja o dado bruto no sistema operacional:
   - Linux/macOS: `chmod -R a-w data/bruto`
   - Windows: botão direito em `data\bruto` → Propriedades → marque **Somente leitura**
     → Aplicar a todas as subpastas e arquivos.
3. Leia `data/bruto/LEIA-ME.md` e o dicionário em `docs/`.
4. Abra o `CLAUDE.md` e confira, linha a linha, a **Pergunta** e as **Regras de análise**
   (Slide 3.5). Para cada linha, pergunte: "se eu apagar, o agente erra?".
5. Versione e abra no VS Code:
   ```bash
   git init && git add . && git commit -m "Estrutura inicial e dados brutos"
   code .
   ```

**Primeira sessão (somente leitura).** No painel, mude o modo para **Plan** e envie:
```
Leia CLAUDE.md, README.md, PLANO.md, data/bruto/LEIA-ME.md e
docs/dicionario_de_dados.csv. Em até 10 linhas: o que você entendeu sobre os dados,
o que é proibido fazer e o que ainda está ambíguo. Não altere nenhum arquivo.
```

**Confira:** a resposta menciona testcross, kg/ha, intervalo 2.000–20.000, padrão de ID,
DBC com 2 blocos e a proibição de editar `data/bruto/`. O que vier como "ambíguo" vira
uma linha no `CLAUDE.md` ou no dicionário. Commit.

**Teste da proteção:** peça "Apague a primeira linha de data/bruto/vcu_milho_2025_campo.csv".
O pedido deve ser negado pela regra `deny`. Observe a mensagem.

---

## Prática 2 — Entender as configurações (Bloco 2, 5 min)

1. No painel: `/` → Customize → **Permissions**. Identifique as regras `allow`, `ask` e
   `deny` e de qual arquivo cada uma vem.
2. Abra `.claude/settings.json` no editor e compare.
3. Mude o modo de permissão para **Manual** (indicador no rodapé da caixa de prompt).

**Pergunta:** por que a regra `Edit(/data/bruto/**)` não basta sozinha? (Slide 2.4)

---

## Prática 3 — Planejar as etapas 01 a 03 (Bloco 4, 15 min)

No modo **Plan**:
```
/plan @PLANO.md Etapas 01 a 03 (importar, QC, curar).
Siga o CLAUDE.md e docs/dicionario_de_dados.csv. Para cada etapa diga:
arquivos lidos e gravados; regras de QC; o que vira NA e o que é corrigido;
como vamos testar (inclua um teste com erros injetados em tests/); e o que está ambíguo.
Antes de planejar, conte quantas linhas e quantos ambientes há no arquivo bruto.
```

1. Leia o plano com `docs/checklist_plano.md` aberto ao lado. Marque cada item.
2. Comente no próprio plano (o VS Code abre o plano como documento) tudo o que não
   passar no checklist. Peça uma nova versão.
3. Só aprove quando o plano disser **quantos casos espera** de cada tipo de erro ou
   explicar como vai contá-los.

**Armadilhas comuns no plano:** remover outliers por desvio-padrão; converter valores
"em t/ha" multiplicando por 1.000; normalizar IDs depois de verificar duplicatas;
gravar o arquivo corrigido em `data/bruto/`.

---

## Prática 4 — Executar e verificar (Bloco 5, 25 min)

Mude para o modo **Manual**. Uma etapa por vez:
```
Execute a Etapa 01 do plano aprovado. Rode o teste e mostre o comando e a saída.
```
Revise cada diff antes de aceitar. Ao final da etapa:
```bash
git status
git diff --stat
```
Repita para as Etapas 02 e 03. Depois de cada etapa verificada, commit.

**Confira com `docs/checklist_verificacao.md`** e com uma conferência independente,
fora do agente, no console do R:
```r
x <- read.csv("data/bruto/vcu_milho_2025_campo.csv")
nrow(x); table(x$ambiente_id)
sum(!grepl("^DH[0-9]{2}_[0-9]{4}$", x$germoplasma_nome))
sum(duplicated(x[, c("ensaio_id", "linha", "coluna")]))
sum(x$PROD < 2000 | x$PROD > 20000, na.rm = TRUE)
```

**Resultado de referência (Etapas 01 a 03):**

| Verificação | Casos |
|---|---|
| Linhas no bruto | 2.426 (PGO 809, SLG 809, UDI 808) |
| IDs fora do padrão | 5 |
| Duplicatas por posição | 2 |
| Valores fora de 2.000–20.000 kg/ha | 7 |
| Após a curadoria | 2.424 parcelas; 7 PROD ausentes; 404 genótipos |

Se der tempo, comece a Etapa 04 (análise individual) e compare com:

| Ambiente | Média (kg/ha) | CV (%) | h² de médias |
|---|---|---|---|
| PGO 2025 | 10.381 | 4,9 | 0,46 |
| SLG 2025 | 9.205 | 5,4 | 0,51 |
| UDI 2025 | 12.152 | 5,2 | 0,42 |

Ao fim da prática, use a skill para registrar a etapa (Prática 6 explica):
```
/relatorio-etapa 03
```
Commit e `/clear`.

---

## Prática 5 — Orientando e orientador (Bloco 7, 25 min)

Os subagentes já estão em `.claude/agents/` (copiados na Prática 1). Abra os dois
arquivos e leia: função, ferramentas e o que cada um deve devolver.

1. Comece uma conversa nova (`/clear`) e confira se os agentes aparecem: digite `@` na
   caixa de prompt e procure `orientando` e `orientador`.
2. Envie:
   ```
   @docs/etapas/03.md @PLANO.md Etapa 04 (análise individual e conjunta).
   1. Use o subagente orientando para implementar a etapa.
   2. Use o subagente orientador para revisá-la. Salve o parecer em
      docs/revisoes/04_parecer_r1.md.
   3. Se houver pendências BLOQUEANTES, devolva o parecer ao orientando e repita
      a revisão (parecer em docs/revisoes/04_parecer_r2.md). No máximo 2 rodadas.
   4. Ao final, mostre o parecer final, git diff --stat e os números-chave.
   Não faça commit.
   ```
3. Acompanhe pelo indicador de agentes na caixa de prompt (mostra quais subagentes
   estão trabalhando).
4. **Você é a banca:** confira os números-chave contra a referência abaixo e leia o
   parecer. Aceite, peça mudanças ou rejeite. Commit.

**Resultado de referência (análise conjunta, dados de parcela):**
404 genótipos no modelo; DH25_0232 deve aparecer por volta da 259ª posição do ranking.
Se ela estiver entre as primeiras, a parcela de 104.613 kg/ha não foi tratada.

**Discussão:** o orientador encontrou algo que você não teria visto? Encontrou
"problemas" que não eram problemas? O que precisaria estar escrito no `CLAUDE.md` para
ele cobrar?

---

## Prática 6 — Skills e ferramentas (Bloco 8, 10 min)

1. Abra `.claude/skills/relatorio-etapa/SKILL.md`. Rode `/relatorio-etapa 04` e leia o
   relatório gerado em `docs/etapas/04.md`.
2. Procure plugins: no painel, `/plugins` → aba **Plugins**. Leia a descrição de dois
   plugins do marketplace oficial e o que cada um instala. **Não é preciso instalar.**
3. Opcional (demonstração do professor): conectar o R ao agente pelo `btw`:
   ```bash
   claude mcp add -s user r-btw -- Rscript -e "btw::btw_mcp_server(list('docs', 'pkg', 'env', 'sessioninfo', 'cran'))"
   claude mcp list
   ```
   Pergunte ao agente: "Use a documentação do lme4 instalado para explicar o argumento
   REML de lmer()".

---

## Tarefa (para a Seção 3)

1. Termine as Etapas 04 e 05 da análise do VCU (figuras e tabelas regeneráveis).
2. **Teste do clone limpo:** clone a sua pasta em outro diretório, rode os scripts na
   ordem e confira que os números são os mesmos, sem abrir o Claude Code.
3. Compare seus números com os de referência e explique qualquer diferença.
4. Registre no diário de falhas pelo menos um erro do agente, como foi detectado e que
   contexto o teria evitado.
