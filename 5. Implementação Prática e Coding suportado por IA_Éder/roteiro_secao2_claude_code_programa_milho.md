> **ARQUIVADO.** Versão anterior da Seção 2 (AlphaSimR, DuckDB, GS). Não corresponde ao
> `secao2.pptx` atual: use `secao2.md`, `caderno.md` e a pasta `vcu-milho-2025/`.
> Parte deste conteúdo segue para a Seção 3 (`ciclo-gs-milho`).

# Seção 2 — Um ciclo completo de melhoramento de milho conduzido com Claude Code

**Curso:** Uso de Inteligência Artificial no Melhoramento de Plantas
**Carga horária:** 4 horas
**Pré-requisitos:** Seção 1 (Git, SQL, estrutura de projeto); R com `AlphaSimR`, `lme4`, `rrBLUP`, `duckdb`; Claude Code instalado e autenticado

> **Objetivo central da seção:** cada aluno conduz, **exclusivamente por meio do Claude Code**, um ciclo completo de melhoramento — simulação do programa, banco de dados, controle de qualidade, BLUPs, seleção genômica e escolha de novos cruzamentos — e verifica, com o "gabarito" genético da simulação, se cada etapa entregue pela IA está correta.
>
> **Mensagem que deve ficar:** o resultado do agente depende menos da "frase mágica" do prompt e muito mais de **contexto, organização dos dados e um projeto dividido em etapas verificáveis**.

---

## Por que usar dados simulados?

Em dados reais, nunca conhecemos o valor genético verdadeiro. No `AlphaSimR`, conhecemos. Isso transforma a aula em um **experimento controlado sobre a IA**: podemos medir se o BLUP, a herdabilidade e a acurácia genômica calculados pelo código que o Claude Code escreveu batem com a verdade da simulação.

```
AlphaSimR  →  valor genético verdadeiro (gv)  →  guardado como "gabarito"
           →  fenótipos + SNPs               →  entregues ao pipeline
Pipeline do Claude Code → BLUP / GEBV → comparados ao gabarito
```

---

## Cronograma

| Etapa | Tema | Conceito de Claude Code trabalhado | Tempo |
|---|---|---|---|
| 0 | Abertura: contexto vence prompt | Janela de contexto, `/context` | 15 min |
| 1 | Montagem do projeto | `CLAUDE.md`, `/init`, permissões, modo de planejamento | 30 min |
| 2 | Simulação do programa com AlphaSimR e carga no banco | Prompt estruturado, especificação antes do código | 45 min |
| — | Intervalo | | 10 min |
| 3 | Controle de qualidade dos dados | Subagente `qc-auditor` | 35 min |
| 4 | BLUPs da rede de ensaios | Validação contra o gabarito, hooks de teste | 30 min |
| 5 | Seleção genômica e predição de cruzamentos | Subagente revisor independente, skill do projeto | 45 min |
| 6 | Fechamento do ciclo e síntese | Reprodutibilidade de ponta a ponta | 30 min |
| | **Total** | | **240 min** |

---

# ETAPA 0 — Abertura: contexto vence prompt (15 min)

## Slide 0.1 — O experimento da abertura

O professor faz, ao vivo, duas sessões com o mesmo pedido:

**Sessão A — pasta vazia, pedido solto:**
> "Simule um programa de melhoramento de milho e calcule os BLUPs."

**Sessão B — projeto estruturado (preparado previamente):** mesma frase, mas dentro de um repositório com `CLAUDE.md`, `PLANO.md`, esquema do banco e dicionário de variáveis.

Discutir com a turma:
- Na sessão A, quantas decisões o agente tomou sozinho (número de linhas, h², delineamento, modelo)?
- Na sessão B, quais dessas decisões já estavam fixadas pelo contexto?
- Qual dos dois resultados você assinaria em uma dissertação?

## Slide 0.2 — Como o agente "enxerga" o projeto

```
Janela de contexto do Claude Code
├── Instruções do sistema
├── CLAUDE.md do projeto          ← você controla
├── Arquivos que ele leu          ← você organiza
├── Saídas de comandos executados
└── Histórico desta conversa      ← cresce e degrada com o tempo
```

- `/context` mostra quanto da janela já foi ocupado.
- Conversas longas acumulam ruído: tentativas erradas, saídas extensas, decisões abandonadas.
- **Regra da seção:** uma etapa = uma conversa limpa (`/clear`), com o estado passado adiante por **arquivos**, não pela memória da conversa.

## Slide 0.3 — Três pilares da seção

1. **Contexto persistente:** `CLAUDE.md`, dicionário de dados, esquema do banco.
2. **Organização dos dados:** banco relacional + arquivos de genótipos + gabarito separado.
3. **Projeto em etapas:** `PLANO.md` com etapas pequenas, cada uma com critério de aceitação numérico.

---

# ETAPA 1 — Montagem do projeto (30 min)

## Slide 1.1 — Estrutura do repositório

```
ciclo-gs-milho/
├── CLAUDE.md                  # contexto permanente para o agente
├── PLANO.md                   # etapas, critérios de aceitação, status
├── README.md
├── .claude/
│   ├── settings.json          # permissões e hooks do projeto
│   ├── agents/
│   │   ├── qc-auditor.md
│   │   └── revisor-genetica.md
│   └── skills/
│       └── novo-ciclo/SKILL.md
├── config/
│   └── parametros.yaml        # parâmetros da simulação (fonte única)
├── data/
│   ├── genotipos/             # matrizes de SNP (.rds / .parquet), não versionadas
│   ├── gabarito/              # valores genéticos verdadeiros — só para validação
│   └── dicionario.csv
├── db/
│   ├── schema.sql
│   └── programa_milho.duckdb  # não versionado
├── R/
│   ├── 01_simulacao.R
│   ├── 02_carga_banco.R
│   ├── 03_qc.R
│   ├── 04_blup_met.R
│   ├── 05_gs_treino.R
│   └── 06_predicao_cruzamentos.R
├── tests/
├── docs/
│   └── etapas/                # um relatório curto por etapa (passagem de contexto)
└── reports/
```

## Slide 1.2 — Gerando o ponto de partida

No terminal, dentro da pasta:

```bash
git init
claude
```

Dentro do Claude Code:

```
/init
```

O `/init` lê o projeto e propõe um `CLAUDE.md`. **Em pasta quase vazia, ele produz um arquivo genérico** — ótimo momento para mostrar que o contexto útil precisa vir do pesquisador.

## Slide 1.3 — O `CLAUDE.md` do projeto

```markdown
# Projeto: ciclo de seleção genômica em milho (dados simulados)

## Objetivo
Simular um programa de linhagens duplo-haploides (DH) de milho com AlphaSimR,
armazenar fenótipos e genótipos, e executar um ciclo completo:
QC → BLUP multiambiente → seleção genômica → escolha de cruzamentos → novo ciclo.

## Fonte única de parâmetros
Todos os parâmetros de simulação ficam em config/parametros.yaml.
Nunca escreva valores numéricos de simulação diretamente nos scripts.

## Organização dos dados
- Fenótipos, parcelas, ambientes, germoplasma e pedigree: db/programa_milho.duckdb
  (esquema em db/schema.sql; dicionário em data/dicionario.csv).
- Genótipos SNP: data/genotipos/ (matriz 0/1/2, linhas = germoplasma_id).
- data/gabarito/ contém valores genéticos verdadeiros. USE APENAS em tests/ e em
  scripts de validação. É proibido usar o gabarito em qualquer etapa de estimação.

## Convenções de código
- R, pipe nativo |>, um script por etapa em R/, numerados.
- Semente fixa lida de config/parametros.yaml.
- Toda função de estimação tem teste em tests/ com dado simulado de parâmetro conhecido.

## Regras científicas
- Modelo MET de referência (dados de parcela, nunca médias):
  y = ambiente + bloco(ambiente) + genotipo + genotipo:ambiente + erro,
  com genotipo e genotipo:ambiente aleatórios.
- Herdabilidade em base de médias de linhagem:
  H2 = s2g / (s2g + s2ge/e + s2e/(r*e)).
- Diferenciar sempre: acurácia = cor(GEBV, gv verdadeiro);
  capacidade preditiva = cor(GEBV, fenótipo corrigido).
- Validação cruzada sempre por família (não aleatória por indivíduo) e com semente registrada.
- Ao usar uma fórmula nova, cite a referência primária em comentário.

## Forma de trabalho
- Antes de implementar uma etapa do PLANO.md, apresente um plano e aguarde aprovação.
- Ao terminar uma etapa, escreva docs/etapas/NN_nome.md com: o que foi feito,
  decisões tomadas, números de validação e pendências.
- Não avance para a próxima etapa sem que os testes da etapa atual passem.
```

**Discussão:** cada linha do `CLAUDE.md` elimina uma decisão que o agente tomaria sozinho. A linha sobre o gabarito, por exemplo, impede um erro sutil e grave: "validar" o modelo usando a própria resposta.

## Slide 1.4 — O `PLANO.md`: o projeto em etapas verificáveis

```markdown
# Plano do ciclo

| Etapa | Entrega | Critério de aceitação | Status |
|---|---|---|---|
| 1 | Simulação e banco | Banco carregado; n de parcelas = esperado; H2 simulada ≈ alvo (±0,05) | ☐ |
| 2 | QC | Relatório lista 100% dos erros injetados; dados limpos salvos em view | ☐ |
| 3 | BLUP MET | cor(BLUP, gv) ≈ √H2 esperado; componentes de variância próximos dos simulados | ☐ |
| 4 | GS | Acurácia por CV por família reportada com DP entre folds | ☐ |
| 5 | Cruzamentos | Lista de 20 cruzamentos com média e variância preditas da progênie | ☐ |
| 6 | Novo ciclo | Ganho realizado (gv) comparado ao ganho predito | ☐ |
```

## Slide 1.5 — Permissões e segurança do agente

`.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(Rscript:*)",
      "Bash(git status)",
      "Bash(git diff:*)",
      "Read(**)"
    ],
    "deny": [
      "Edit(data/gabarito/**)",
      "Write(data/gabarito/**)",
      "Bash(rm:*)"
    ]
  }
}
```

- O agente pode rodar R e ler o projeto sem pedir permissão a cada vez.
- Ele **não pode** alterar o gabarito nem apagar arquivos.
- Commits continuam sob aprovação do aluno.

## Slide 1.6 — Modo de planejamento

- Ativado com **Shift+Tab** até aparecer o modo de plano.
- O agente lê e investiga, mas **não altera arquivos** até o plano ser aprovado.
- Regra da seção: toda etapa começa em modo de planejamento.

**Atividade (10 min):** cada aluno cria o repositório, adapta o `CLAUDE.md` e o `PLANO.md`, e faz o primeiro commit.

---

# ETAPA 2 — Simulação do programa e carga no banco (45 min)

## Slide 2.1 — Especificar antes de pedir código

O erro mais comum é pedir o código antes de definir o programa. Primeiro, o aluno preenche `config/parametros.yaml` (com ajuda do agente, se quiser):

```yaml
semente: 2026

genoma:
  n_cromossomos: 10
  seg_sites_por_cromossomo: 1000
  especie: MAIZE            # histórico demográfico de milho no MaCS
  n_fundadores: 100

carater:
  nome: PROD
  qtl_por_cromossomo: 100
  media: 8000               # kg/ha
  var_genetica: 250000      # (kg/ha)^2  → DP genético = 500 kg/ha
  n_ambientes: 6
  cor_genetica_entre_ambientes: 0.7   # gera interação G×E

chip:
  snp_por_cromossomo: 300   # 3.000 SNPs

programa:
  ciclos_historicos: 3
  cruzamentos_por_ciclo: 50
  dh_por_cruzamento: 10
  repeticoes: 2
  h2_parcela: 0.3

erros_injetados:
  parcelas_duplicadas: 5
  ids_com_grafia_divergente: 8
  valores_fora_do_intervalo: 10
  genitor_inexistente: 3
  linhagens_em_um_ambiente: 6
```

## Slide 2.2 — O prompt da etapa (modo de planejamento)

**Prompt fraco:**
> "Faz a simulação no AlphaSimR."

**Prompt estruturado:**

```
Etapa 1 do PLANO.md. Leia CLAUDE.md, PLANO.md, config/parametros.yaml e db/schema.sql.

Objetivo: escrever R/01_simulacao.R e R/02_carga_banco.R.

01_simulacao.R deve:
1. Criar fundadores com runMacs usando os parâmetros do YAML.
2. Definir um caráter aditivo com um valor genético por ambiente
   (multitraço com correlação genética entre ambientes conforme o YAML).
3. Simular os ciclos históricos: cruzamentos aleatórios → DH → avaliação.
4. Para cada linhagem DH avaliada, gerar fenótipos de PARCELA em DBC:
   y = média_amb + efeito_bloco + gv_amb + erro, com variância de erro
   calibrada para a h2 de parcela do YAML.
5. Salvar: pedigree, SNPs (data/genotipos/), gv verdadeiros (data/gabarito/).

02_carga_banco.R deve carregar tudo no DuckDB seguindo db/schema.sql
e, por último, injetar os erros definidos em erros_injetados,
registrando em data/gabarito/erros_injetados.csv o que foi alterado.

Restrições: nenhum valor numérico fixo no código; semente do YAML.
Critério de aceitação: ver linha 1 do PLANO.md.
Apresente o plano antes de escrever código.
```

**Elementos do prompt:** arquivos de contexto a ler, objetivo, passos, restrições, onde salvar e critério de aceitação.

## Slide 2.3 — O que revisar no plano do agente

Antes de aprovar, o aluno confere com a turma:
- A variância de erro foi calibrada corretamente? Para h² de parcela = 0,3: σ²ε = σ²g · (1 − h²)/h².
- O bloco foi tratado dentro de ambiente?
- Os SNPs e os QTLs estão separados? Um chip que contém os próprios QTLs superestima a acurácia genômica.
- O gabarito ficou fora do banco?

## Slide 2.4 — Gabarito do professor (esqueleto de referência)

> Referência para o professor comparar com o que o agente produzir. Validar localmente antes da aula.

```r
library(AlphaSimR)
par <- yaml::read_yaml("config/parametros.yaml")
set.seed(par$semente)

founderPop <- runMacs(nInd = par$genoma$n_fundadores,
                      nChr = par$genoma$n_cromossomos,
                      segSites = par$genoma$seg_sites_por_cromossomo,
                      inbred = TRUE, species = par$genoma$especie)

SP <- SimParam$new(founderPop)
e  <- par$carater$n_ambientes
R  <- matrix(par$carater$cor_genetica_entre_ambientes, e, e); diag(R) <- 1
SP$addTraitA(nQtlPerChr = par$carater$qtl_por_cromossomo,
             mean = rep(par$carater$media, e),
             var  = rep(par$carater$var_genetica, e),
             corA = R)
SP$addSnpChip(nSnpPerChr = par$chip$snp_por_cromossomo)   # SNPs distintos dos QTLs
SP$setTrackPed(TRUE)

pais <- newPop(founderPop)
historico <- list()
for (ciclo in seq_len(par$programa$ciclos_historicos)) {
  f1  <- randCross(pais, nCrosses = par$programa$cruzamentos_por_ciclo)
  dh  <- makeDH(f1, nDH = par$programa$dh_por_cruzamento)
  historico[[ciclo]] <- dh
  pais <- selectInd(dh, nInd = 50, use = "gv")  # substituído por BLUP na Etapa 6
}
# Fenótipos de parcela: gerados fora do AlphaSimR a partir de gv(dh) por ambiente,
# com efeitos de ambiente e bloco e erro calibrado para h2 de parcela.
```

Pontos para discutir: onde o agente pode errar (erro calibrado sobre variância fenotípica total em vez de genética; SNP chip incluindo QTLs; seleção dos pais usando `gv`, o que representa um "melhorista onisciente").

## Slide 2.5 — Checkpoint numérico da etapa

Pedir ao agente:

```
Escreva tests/test_simulacao.R que verifique:
- número de parcelas = linhagens × ambientes × repetições (antes da injeção de erros);
- variância de gv por ambiente ≈ var_genetica do YAML (tolerância de 20%);
- correlação média de gv entre ambientes ≈ 0,7;
- h2 de parcela empírica = var(gv)/var(y) dentro de ambiente ≈ 0,3.
Rode o teste e reporte os valores.
```

**Encerramento da etapa:** `docs/etapas/01_simulacao.md` + commit + `/clear`.

---

# INTERVALO (10 min)

---

# ETAPA 3 — Controle de qualidade com subagente (35 min)

## Slide 3.1 — O que é um subagente

- Um agente especializado, definido em `.claude/agents/`, com **instruções, ferramentas e contexto próprios**.
- Ele trabalha em uma janela de contexto separada e devolve só o resultado ao agente principal.
- Vantagens: foco, reuso entre projetos e **proteção do contexto principal** contra saídas longas.

## Slide 3.2 — Definição do `qc-auditor`

`.claude/agents/qc-auditor.md`:

```markdown
---
name: qc-auditor
description: Audita a qualidade dos dados fenotípicos e de pedigree no banco
  DuckDB antes de qualquer análise. Use antes de ajustar modelos.
tools: Read, Bash, Grep
---

Você é um auditor de dados de programas de melhoramento.

Tarefas, sempre por consultas SQL em db/programa_milho.duckdb:
1. Parcelas duplicadas (mesmo ensaio, linha e coluna).
2. Identificadores de germoplasma com grafia divergente (caixa, hífens, espaços).
3. Valores fora do intervalo biológico definido em data/dicionario.csv.
4. Genitores citados no pedigree e ausentes no cadastro.
5. Linhagens avaliadas em um único ambiente (conectividade).
6. Desbalanceamento de repetições por ambiente.

Regras:
- Nunca altere o banco. Apenas relate.
- Não leia data/gabarito/.
- Entregue: tabela com tipo de problema, n de casos, IDs afetados e a
  consulta SQL usada; e uma proposta de correção para cada tipo.
```

## Slide 3.3 — Invocação e correção

```
Use o subagente qc-auditor para auditar o banco.
Depois, com base no relatório, escreva R/03_qc.R que crie uma VIEW
parcelas_limpas aplicando as correções propostas. Não apague dados brutos.
```

**Discussão:** por que a correção é uma *view* e não um `DELETE`? Rastreabilidade: o dado original permanece auditável.

## Slide 3.4 — Checkpoint: o QC encontrou tudo?

Aqui o gabarito é útil pela primeira vez:

```
Compare o relatório do qc-auditor com data/gabarito/erros_injetados.csv
(permitido, pois é validação). Reporte sensibilidade por tipo de erro.
```

Resultado esperado para discussão: erros de valor e duplicata são detectados com facilidade; **grafia divergente** costuma escapar parcialmente. Isso mostra que o QC precisa de regras explícitas, e não só da "inteligência" do agente.

**Encerramento:** `docs/etapas/02_qc.md` + commit + `/clear`.

---

# ETAPA 4 — BLUPs da rede de ensaios (30 min)

## Slide 4.1 — Prompt da etapa

```
Etapa 3 do PLANO.md. Leia docs/etapas/01_simulacao.md e 02_qc.md.
Usando a VIEW parcelas_limpas, ajuste em R/04_blup_met.R o modelo MET
de referência do CLAUDE.md com lme4. Salve no banco uma tabela
blup_linhagem (germoplasma_id, blup, pev) e reporte componentes de
variância e H2 em base de médias. Plano primeiro.
```

## Slide 4.2 — Hook: testes automáticos a cada edição

`.claude/settings.json` (trecho):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "Rscript tests/run_all.R" }
        ]
      }
    ]
  }
}
```

- Toda vez que o agente edita um arquivo, a suíte de testes roda.
- Falhas voltam para o agente, que precisa corrigir antes de seguir.
- **Mensagem:** a verificação deixa de depender da lembrança do aluno.

## Slide 4.3 — Checkpoint contra o gabarito

| Quantidade | Valor simulado | Esperado do modelo |
|---|---|---|
| σ²g (parte comum entre ambientes) | 0,7 × 250.000 = 175.000 | próximo |
| σ²ge | (1 − 0,7) × 250.000 = 75.000 | próximo |
| H² em base de médias | calculada com e = 6, r = 2 | próxima |
| cor(BLUP, gv médio verdadeiro) | — | ≈ √H² |

**Ponto teórico para discutir:** com variância genética igual em todos os ambientes (250.000) e correlação genética de 0,7, o modelo G + G×E (*compound symmetry*) particiona essa variância em uma parte comum (σ²g) e uma parte específica de ambiente (σ²ge). Isso vale aqui porque a simulação é homogênea. Em redes reais, com variâncias e correlações heterogêneas, estruturas como FA (*factor analytic*) são mais adequadas — um bom gancho para pedir ao agente que compare os dois modelos.

**Encerramento:** `docs/etapas/03_blup.md` + commit + `/clear`.

---

# ETAPA 5 — Seleção genômica e predição de cruzamentos (45 min)

## Slide 5.1 — Prompt de treinamento do modelo

```
Etapa 4 do PLANO.md. Leia docs/etapas/03_blup.md.
Em R/05_gs_treino.R:
1. Use blup_linhagem como variável resposta (desregressão não necessária
   nesta aula; registre essa simplificação no relatório).
2. Ajuste GBLUP com rrBLUP::mixed.solve e K = rrBLUP::A.mat(M - 1).
3. Faça validação cruzada 5-fold POR FAMÍLIA (famílias = cruzamento de origem),
   com 10 repetições e semente registrada.
4. Reporte capacidade preditiva e, separadamente, acurácia contra o gabarito.
Plano primeiro.
```

## Slide 5.2 — Duas armadilhas que o agente costuma cometer

| Armadilha | Consequência | Como o contexto previne |
|---|---|---|
| CV aleatória por indivíduo | Irmãos DH no treino e no teste; acurácia inflada | Regra explícita no `CLAUDE.md` |
| Confundir capacidade preditiva com acurácia | Conclusão errada sobre o modelo | Definições no `CLAUDE.md` |
| Usar `gv` como resposta | Resultado irreal ("vazamento" do gabarito) | Permissão negada + regra |

## Slide 5.3 — Subagente revisor independente

`.claude/agents/revisor-genetica.md`:

```markdown
---
name: revisor-genetica
description: Revisa scripts de genética quantitativa quanto a erros de
  especificação de modelo, fórmulas e vazamento de dados. Use antes de
  aceitar qualquer resultado de BLUP ou seleção genômica.
tools: Read, Grep, Bash
---

Você é um revisor de genética quantitativa. Não escreveu o código revisado.

Verifique:
1. Estrutura do modelo misto versus o delineamento descrito no CLAUDE.md.
2. Fórmulas de herdabilidade, acurácia e PEV, com referência primária.
3. Vazamento: uso de data/gabarito/ fora de tests/; famílias divididas entre treino e teste.
4. Consistência da matriz de marcadores (codificação 0/1/2 vs -1/0/1; MAF; faltantes).

Entregue uma lista de problemas classificados como crítico, moderado ou menor,
com a linha do arquivo e a correção sugerida. Não altere arquivos.
```

**Por que um revisor separado?** O agente que escreveu o código tende a confirmar as próprias escolhas. Um contexto limpo, com instruções de revisor, reproduz a lógica da revisão por pares.

## Slide 5.4 — Predição de cruzamentos

```
Em R/06_predicao_cruzamentos.R, a partir das 30 melhores linhagens por GEBV:
1. Enumere todos os cruzamentos possíveis.
2. Para cada um, calcule a média esperada da progênie (média dos GEBV dos pais).
3. Estime a variância genética da progênie DH simulando 200 DH por cruzamento
   com os efeitos de marcadores estimados (RR-BLUP) e os haplótipos dos pais.
4. Calcule o critério de utilidade U = média + i · σ_progênie, com i para 10% selecionados.
5. Escolha 20 cruzamentos, com no máximo 3 cruzamentos por genitor.
Salve a tabela no banco e em reports/.
```

Discussão:
- Média alta nem sempre significa melhor cruzamento: a variância da progênie importa.
- O limite por genitor é uma forma simples de controlar a perda de diversidade (gancho para OCS em seção futura).

## Slide 5.5 — Transformando o fluxo em skill

`.claude/skills/novo-ciclo/SKILL.md`:

```markdown
---
name: novo-ciclo
description: Executa um novo ciclo de seleção a partir dos cruzamentos escolhidos,
  simulando DH, fenótipos e atualizando o banco. Use quando o usuário pedir
  para avançar um ciclo do programa.
---

1. Leia a tabela de cruzamentos escolhidos no banco.
2. Execute a simulação do ciclo em AlphaSimR com os parâmetros de config/parametros.yaml.
3. Carregue as novas linhagens e fenótipos no banco (sem injeção de erros).
4. Rode R/03_qc.R, R/04_blup_met.R e R/05_gs_treino.R na ordem.
5. Escreva docs/etapas/NN_ciclo.md com ganho predito e ganho realizado.
```

Depois, basta digitar `/novo-ciclo`. **Mensagem:** um fluxo validado vira procedimento reutilizável.

**Encerramento:** `docs/etapas/04_gs.md` + commit + `/clear`.

---

# ETAPA 6 — Fechamento do ciclo e síntese (30 min)

## Slide 6.1 — Fechando o ciclo

```
/novo-ciclo
```

Depois:

```
Compare, usando o gabarito (permitido nesta etapa de validação):
- ganho predito: média dos U ou das médias previstas dos cruzamentos escolhidos;
- ganho realizado: média de gv das novas DH − média de gv do ciclo anterior;
- mesma comparação para 20 cruzamentos aleatórios (controle).
Apresente em uma tabela e em um gráfico.
```

## Slide 6.2 — O que a turma deve observar

| Cenário | Ganho realizado esperado |
|---|---|
| Cruzamentos aleatórios | Próximo de zero |
| Seleção por média dos pais (GEBV) | Positivo |
| Seleção pelo critério de utilidade | Positivo, com possível vantagem quando a variância da progênie difere muito entre cruzamentos |

> Conclusões comparativas exigem várias repetições da simulação. Uma única realização ilustra o fluxo, mas não prova superioridade de método. Uma boa tarefa é pedir ao agente que repita o ciclo 50 vezes com sementes diferentes.

## Slide 6.3 — Retrospectiva: onde o agente errou?

Cada aluno preenche e apresenta rapidamente:

| Etapa | Erro cometido pelo agente | Como foi detectado | Qual contexto teria evitado |
|---|---|---|---|
| Simulação | | | |
| QC | | | |
| BLUP | | | |
| GS | | | |

## Slide 6.4 — Síntese da seção

```
Contexto persistente      →  CLAUDE.md, dicionário, esquema, PLANO.md
Organização dos dados     →  banco relacional + genótipos + gabarito isolado
Etapas verificáveis       →  modo de plano, critérios numéricos, testes, hooks
Agentes especializados    →  qc-auditor, revisor-genetica
Procedimentos reutilizáveis → skill /novo-ciclo
```

> O Claude Code executou todas as etapas, mas a qualidade do resultado foi determinada pelas escolhas do pesquisador: o que colocar no contexto, como organizar os dados e como dividir o trabalho.

## Slide 6.5 — Tarefa para a próxima seção

1. Repetir o ciclo por 5 gerações com `/novo-ciclo`.
2. Registrar ganho genético e variância genética ao longo dos ciclos.
3. Pedir ao `revisor-genetica` uma revisão final do repositório.
4. Entregar o link do repositório com todos os `docs/etapas/`.

---

# Notas para o professor

## Preparação antes da aula
- Testar o fluxo completo no mesmo ambiente dos alunos (versões de R, `AlphaSimR`, `rrBLUP`, `duckdb`, `lme4`).
- Deixar pronto um repositório-base com `CLAUDE.md`, `PLANO.md`, `schema.sql` e `dicionario.csv`, para quem atrasar na Etapa 1.
- Ter o banco já gerado como plano B, caso a simulação demore em máquinas mais lentas.
- Conferir a sintaxe atual de `settings.json`, hooks, subagentes e skills na documentação do Claude Code (docs.claude.com), pois esses recursos evoluem.

## Tamanho da simulação
Os parâmetros do YAML (3 ciclos × 500 DH × 6 ambientes × 2 repetições ≈ 18 mil parcelas; 3.000 SNPs) rodam em poucos minutos em um notebook comum. Para turmas com máquinas limitadas, reduzir para 30 cruzamentos por ciclo.

## Pontos em que o professor deve intervir
- Se o agente usar `gv` para selecionar os pais históricos, discutir que isso cria um programa irreal, com seleção sem erro.
- Se o agente "otimizar" a CV e escolher divisão aleatória, retomar a regra do `CLAUDE.md`.
- Se o agente sugerir pacotes ou funções inexistentes, mostrar a falha ao executar e a correção pela documentação.

## Referências
- Gaynor, R. C.; Gorjanc, G.; Hickey, J. M. (2021). AlphaSimR: an R package for breeding program simulations. *G3*, 11(2), jkaa017.
- Endelman, J. B. (2011). Ridge regression and other kernels for genomic selection with R package rrBLUP. *The Plant Genome*, 4(3), 250–255.
- VanRaden, P. M. (2008). Efficient methods to compute genomic predictions. *Journal of Dairy Science*, 91(11), 4414–4423.
- Schnell, F. W.; Utz, H. F. (1975). F1-Leistung und Elternwahl in der Züchtung von Selbstbefruchtern. *Bericht über die Arbeitstagung der Vereinigung Österreichischer Pflanzenzüchter*, 243–248. (critério de utilidade)
- Piepho, H.-P. et al. (2008). BLUP for phenotypic selection in plant breeding and variety testing. *Euphytica*, 161, 209–228.
- Documentação do Claude Code: docs.claude.com (CLAUDE.md, subagentes, skills, hooks, permissões).
