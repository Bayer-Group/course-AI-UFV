# Seção 3 — Estudando um artigo científico com Claude Code: da leitura à reprodução

**Curso:** Uso de Inteligência Artificial no Melhoramento de Plantas
**Carga horária:** 4 horas
**Pré-requisitos:** Seções 1 e 2 (Git, `CLAUDE.md`, subagentes, AlphaSimR)
**Artigo-guia:** um artigo recente de simulação de programas de melhoramento que desacopla o melhoramento populacional do desenvolvimento de produto (Gaynor, Hickey e colaboradores). Como referência de base desse conceito: Gaynor et al. (2017), *A two-part strategy for using genomic selection to develop inbred lines*, Crop Science.

> **Objetivo central da seção:** usar o Claude Code como **parceiro de estudo**, e não como substituto da leitura. O aluno deve sair capaz de (1) explicar o artigo com as próprias palavras, (2) responder e formular perguntas críticas sobre ele, (3) construir uma simulação mínima para entender o mecanismo e (4) ter um repositório que reproduz os resultados principais do artigo.
>
> **Mensagem que deve ficar:** a IA acelera a compreensão quando é obrigada a **citar onde está cada informação**, a **separar o que o artigo diz do que ela infere** e a **testar o entendimento com números**.

---

## Cronograma

| Etapa | Tema | Conceito de Claude Code trabalhado | Tempo |
|---|---|---|---|
| 0 | Abertura: estudar com a IA, não terceirizar a leitura | Riscos de resumo sem fonte | 15 min |
| 1 | Projeto de estudo | `CLAUDE.md` em "modo estudo", organização do material | 30 min |
| 2 | Leitura guiada em camadas | Extração estruturada com citação de página | 45 min |
| — | Intervalo | | 10 min |
| 3 | Perguntas, crítica e modo socrático | Subagente revisor cético; o agente pergunta ao aluno | 30 min |
| 4 | Simulação mínima para entender o mecanismo | Modelo de brinquedo + expectativa teórica | 45 min |
| 5 | Reprodução dos resultados do artigo | Parâmetros rastreáveis, replicação, registro de desvios | 45 min |
| 6 | Fechamento: relatório de reprodutibilidade | Síntese e checklist | 20 min |
| | **Total** | | **240 min** |

---

# ETAPA 0 — Estudar com a IA, não terceirizar a leitura (15 min)

## Slide 0.1 — Experimento de abertura

O professor pede, em uma sessão sem contexto:

> "Resuma o artigo sobre decoupled breeding do Gaynor e do Hickey."

Discutir com a turma:
- O agente leu o artigo ou respondeu com base no que "lembra" do tema?
- Os números citados estão no artigo? Em qual página?
- Ele confundiu este artigo com trabalhos anteriores dos mesmos autores (por exemplo, a estratégia em duas partes de 2017)?

**Ponto central:** sem o PDF no contexto, a resposta é uma reconstrução plausível, não uma leitura. Com autores prolíficos em um mesmo tema, a confusão entre artigos é especialmente provável.

## Slide 0.2 — Três modos de uso, três resultados

| Modo | Pedido típico | Resultado para o aluno |
|---|---|---|
| Terceirizar | "Resuma o artigo" | Sabe repetir frases; não sabe explicar |
| Consultar | "O que é o componente de melhoramento populacional?" | Entende pedaços isolados |
| Estudar | "Me faça perguntas até eu conseguir explicar a Figura 2" | Constrói o entendimento e detecta lacunas |

## Slide 0.3 — As regras do estudo nesta seção

1. Toda afirmação sobre o artigo vem com **seção, página, figura ou tabela**.
2. O agente separa explicitamente **"o artigo diz"** de **"eu infiro"**.
3. Quando a informação não estiver no artigo, a resposta é **"não consta"**, não uma estimativa.
4. Entendimento só é aceito quando **reproduz um número**.

---

# ETAPA 1 — Montagem do projeto de estudo (30 min)

## Slide 1.1 — Estrutura do repositório

```
estudo-decoupled-breeding/
├── CLAUDE.md                 # regras de estudo e de reprodução
├── PLANO.md                  # etapas e critérios de aceitação
├── artigo/
│   ├── artigo.pdf            # não versionado se a licença não permitir
│   ├── suplementar.pdf
│   ├── artigo.txt            # texto extraído, para busca rápida
│   └── referencias/          # artigos-chave citados (ex.: Gaynor et al. 2017)
├── notas/
│   ├── 01_mapa_do_artigo.md
│   ├── 02_glossario.md
│   ├── 03_perguntas.md
│   └── 04_critica.md
├── config/
│   └── parametros_artigo.yaml  # cada parâmetro com página de origem
├── R/
│   ├── 10_modelo_minimo.R
│   ├── 20_convencional.R
│   ├── 21_desacoplado.R
│   └── 30_figuras.R
├── resultados/
├── DESVIOS.md                # diferenças entre nossa reprodução e o artigo
└── REPRODUTIBILIDADE.md      # relatório final
```

## Slide 1.2 — Preparando o material

```bash
mkdir -p artigo notas config R resultados
# copiar o PDF e o material suplementar para artigo/
pdftotext -layout artigo/artigo.pdf artigo/artigo.txt
git init
claude
```

- O Claude Code lê PDFs diretamente, inclusive figuras e tabelas, página a página.
- O `.txt` extraído permite buscas rápidas (`grep`) sem recarregar o PDF inteiro no contexto.
- **Atenção à licença:** artigos sob acesso fechado não devem ir para um repositório público. Nesse caso, inclua `artigo/*.pdf` no `.gitignore`.

## Slide 1.3 — O `CLAUDE.md` em "modo estudo"

```markdown
# Projeto: estudo e reprodução de um artigo de simulação de melhoramento

## Material
- Artigo em artigo/artigo.pdf; texto extraído em artigo/artigo.txt.
- Material suplementar em artigo/suplementar.pdf.
- Artigos citados relevantes em artigo/referencias/.

## Regras de estudo (obrigatórias)
- Toda afirmação sobre o artigo deve indicar a origem: (Seção X, p. Y),
  (Fig. N), (Tab. N) ou (Supl., p. Y).
- Separe sempre, com rótulos explícitos:
  [ARTIGO] o que o texto afirma;
  [INFERÊNCIA] o que você deduz a partir dele;
  [CONHECIMENTO GERAL] o que vem de fora do artigo.
- Se algo não está no artigo, responda "NÃO CONSTA NO ARTIGO" e diga onde procurou.
- Não confunda este artigo com trabalhos anteriores dos mesmos autores.
  Se usar outro artigo, cite-o explicitamente.
- Não reproduza trechos longos do artigo; explique com suas palavras.

## Regras de reprodução
- Todo parâmetro de simulação vem de config/parametros_artigo.yaml,
  e cada entrada do YAML tem o campo "fonte" com a página do artigo.
- Parâmetro não informado no artigo: marcar como "suposto", justificar
  e registrar em DESVIOS.md.
- Semente fixa e número de repetições igual ao do artigo (ou justificar a redução).
- Resultados comparados ao artigo com tolerância declarada.

## Forma de trabalho
- Uma etapa do PLANO.md por conversa; ao final, salvar notas em notas/ e fazer /clear.
- Antes de escrever código, apresentar um plano no modo de planejamento.
```

**Discussão:** os rótulos `[ARTIGO]`, `[INFERÊNCIA]` e `[CONHECIMENTO GERAL]` são a principal defesa contra a alucinação plausível. Eles transformam uma resposta fluente em uma resposta auditável.

## Slide 1.4 — O `PLANO.md`

```markdown
| Etapa | Entrega | Critério de aceitação | Status |
|---|---|---|---|
| 1 | Mapa do artigo e glossário | Toda afirmação com página; aluno explica o esquema sem consultar | ☐ |
| 2 | Parâmetros extraídos | YAML completo; cada campo com fonte ou "suposto" | ☐ |
| 3 | Perguntas e crítica | 10 perguntas respondidas com fonte; 3 limitações identificadas | ☐ |
| 4 | Modelo mínimo | Razão de ganho simulada coerente com a equação do melhorista | ☐ |
| 5 | Reprodução | Figura principal reproduzida dentro da tolerância declarada | ☐ |
| 6 | Relatório | REPRODUTIBILIDADE.md e DESVIOS.md completos | ☐ |
```

---

# ETAPA 2 — Leitura guiada em camadas (45 min)

## Slide 2.1 — Por que ler em camadas?

Um único pedido de "resuma o artigo" produz um texto uniforme, sem hierarquia. A leitura em camadas imita a forma como um pesquisador experiente lê: primeiro a estrutura, depois o método, depois os números.

```
Camada 1: mapa do artigo  →  qual problema, qual proposta, qual evidência
Camada 2: glossário        →  termos e definições operacionais
Camada 3: método           →  esquemas de melhoramento, parâmetros, cenários
Camada 4: resultados       →  figura por figura, tabela por tabela
```

## Slide 2.2 — Camada 1: mapa do artigo

```
Leia artigo/artigo.pdf por completo. Seguindo as regras do CLAUDE.md,
escreva notas/01_mapa_do_artigo.md com:
1. A pergunta científica, em uma frase.
2. A hipótese ou proposta dos autores.
3. Os cenários comparados (nomes exatamente como no artigo).
4. As principais métricas de resultado.
5. As conclusões centrais, cada uma com a figura ou tabela que a sustenta.
Use os rótulos [ARTIGO] e [INFERÊNCIA] e indique as páginas.
```

**O que o aluno faz em seguida:** abre o PDF nas páginas citadas e confere pelo menos três afirmações. Essa verificação por amostragem é parte obrigatória da atividade.

## Slide 2.3 — Camada 2: glossário operacional

```
Crie notas/02_glossario.md com os termos técnicos do artigo.
Para cada termo: definição dada pelo artigo (com página), definição usual
na literatura [CONHECIMENTO GERAL] e, quando houver diferença, destaque-a.
```

Termos que devem aparecer no caso do artigo-guia:
- melhoramento populacional (*population improvement*) e desenvolvimento de produto (*product development*);
- intervalo de geração (*L*) e ciclo de reciclagem de genitores;
- acurácia de seleção, intensidade de seleção, variância genética;
- duplo-haploides, ensaios de rendimento preliminares e avançados;
- custo por ciclo e equivalência de orçamento entre cenários.

**Discussão:** "ciclo" pode significar ciclo de seleção, ano de programa ou geração. O glossário obriga o aluno a fixar o sentido usado pelos autores antes de interpretar resultados.

## Slide 2.4 — Camada 3: extração estruturada dos parâmetros

```
Extraia para config/parametros_artigo.yaml TODOS os parâmetros de simulação
do artigo e do material suplementar. Para cada parâmetro:
  valor, unidade, fonte (página/tabela), e status: "informado" ou "suposto".
Se o valor não estiver no artigo, deixe status "suposto", valor null
e uma nota explicando o que falta.
```

Exemplo do formato esperado:

```yaml
genoma:
  n_cromossomos:
    valor: 10
    fonte: "Métodos, p. 4"
    status: informado
  seg_sites_por_cromossomo:
    valor: null
    fonte: null
    status: suposto
    nota: "Artigo informa número de QTLs, mas não de sítios segregantes"

programa_convencional:
  anos_ate_reciclagem:
    valor: 4
    fonte: "Fig. 1"
    status: informado

programa_desacoplado:
  ciclos_melhoramento_populacional_por_ano:
    valor: 2
    fonte: "Métodos, p. 5"
    status: informado

simulacao:
  n_repeticoes:
    valor: null
    fonte: null
    status: suposto
```

> Os valores acima ilustram o formato. Os valores reais devem ser extraídos do artigo pelo aluno com o agente e conferidos na página indicada.

**Ponto crítico:** esta é a etapa em que mais aparecem parâmetros "inventados". Um YAML com fonte em cada linha torna a invenção visível.

## Slide 2.5 — Camada 4: figura por figura

```
Para a Figura 2 do artigo:
1. Descreva eixos, unidades, cenários e o que cada curva representa.
2. Qual é a principal mensagem da figura, segundo o texto (com página)?
3. Que número eu deveria conseguir reproduzir a partir desta figura?
Não interprete além do que o artigo afirma sem usar o rótulo [INFERÊNCIA].
```

O Claude Code consegue ler a figura diretamente do PDF. Isso permite ao aluno perguntar sobre detalhes visuais, como a escala do eixo, a presença de intervalos de confiança ou a sobreposição entre cenários.

**Encerramento:** commit das notas + `/clear`.

---

# INTERVALO (10 min)

---

# ETAPA 3 — Perguntas, crítica e modo socrático (30 min)

## Slide 3.1 — O aluno pergunta

Boas perguntas para o artigo-guia:
- Por que desacoplar o melhoramento populacional do desenvolvimento de produto aumenta o ganho por ano? Qual termo da equação do melhorista é mais afetado?
- Como os autores garantiram que os cenários tivessem o mesmo custo?
- O que acontece com a variância genética ao longo dos ciclos em cada cenário?
- Qual é o papel da acurácia da predição genômica no ganho do programa desacoplado?
- Que premissas da simulação favorecem o esquema proposto?

Regra: toda resposta vem com fonte ou com "NÃO CONSTA NO ARTIGO".

## Slide 3.2 — O agente pergunta (modo socrático)

```
Aja como examinador de qualificação. Faça-me uma pergunta por vez sobre o
artigo, começando pelo conceito central e aumentando a dificuldade.
Espere minha resposta, avalie-a com base no artigo (com página) e só então
passe para a próxima. Ao final, liste os pontos que eu ainda não domino.
Registre as perguntas e a avaliação em notas/03_perguntas.md.
```

**Por que isso funciona:** explicar é a forma mais rápida de descobrir o que ainda não se entendeu. O agente deixa de ser fonte de respostas e passa a ser um instrumento de diagnóstico do aprendizado.

## Slide 3.3 — Subagente revisor cético

`.claude/agents/revisor-cetico.md`:

```markdown
---
name: revisor-cetico
description: Faz a revisão crítica de um artigo científico como um revisor
  de periódico. Use depois que o mapa do artigo estiver pronto.
tools: Read, Grep
---

Você é um revisor exigente de genética quantitativa e simulação de
programas de melhoramento. Leia artigo/artigo.pdf e notas/01_mapa_do_artigo.md.

Avalie:
1. Premissas da simulação que podem favorecer um cenário (ex.: arquitetura
   genética, ausência de G×E, custos, acurácia assumida).
2. Se as comparações entre cenários são justas (orçamento, horizonte de tempo).
3. Se as conclusões extrapolam o que as figuras mostram.
4. O que seria necessário para aplicar o resultado a um programa real de milho tropical.

Toda crítica deve apontar a página ou figura em questão.
Escreva em notas/04_critica.md. Não altere outros arquivos.
```

**Discussão:** usar um revisor em contexto separado evita que o mesmo agente que construiu o entendimento do artigo apenas o confirme.

**Encerramento:** commit + `/clear`.

---

# ETAPA 4 — Simulação mínima para entender o mecanismo (45 min)

## Slide 4.1 — Por que começar com um modelo mínimo?

Reproduzir o artigo em escala completa leva tempo e mistura muitos detalhes. O modelo mínimo isola o mecanismo central:

> Separar a reciclagem rápida de genitores (melhoramento populacional) da avaliação de produtos (desenvolvimento de produto) reduz o intervalo de geração e, portanto, aumenta o ganho por ano, desde que a acurácia da predição genômica seja suficiente.

## Slide 4.2 — A expectativa teórica antes do código

Equação do melhorista, por unidade de tempo:

$$\Delta G_{ano} = \frac{i \cdot r \cdot \sigma_A}{L}$$

Pedir ao agente, **antes de qualquer simulação**:

```
Com base na equação do melhorista e nos parâmetros de
config/parametros_artigo.yaml, calcule a razão esperada de ganho por ano
entre o programa desacoplado e o convencional, explicitando i, r e L de cada
um. Indique quais valores vieram do artigo e quais foram supostos.
```

Exemplo do raciocínio esperado (valores ilustrativos):

| Termo | Convencional | Desacoplado |
|---|---|---|
| *i* (intensidade) | seleção entre linhagens em ensaios | seleção entre muitos indivíduos genotipados |
| *r* (acurácia) | alta (fenótipo em vários ambientes) | menor (predição genômica) |
| *L* (anos por ciclo) | vários anos | fração de ano |

**Discussão:** a expectativa teórica é o "gabarito" do modelo mínimo. Se a simulação divergir muito dela, há um erro no código ou uma premissa não compreendida.

## Slide 4.3 — Prompt do modelo mínimo

```
Escreva R/10_modelo_minimo.R com AlphaSimR, em escala reduzida
(ex.: 3 cromossomos, 50 QTLs por cromossomo, 20 anos de programa):
1. Cenário convencional: genitores reciclados a partir das linhagens
   avaliadas em ensaios, com o intervalo de reciclagem do YAML.
2. Cenário desacoplado: melhoramento populacional com seleção genômica
   e reciclagem no número de ciclos por ano do YAML; a cada ano, parte
   da população melhorada alimenta o desenvolvimento de produto.
3. Mesmo número aproximado de indivíduos fenotipados por ano nos dois cenários.
4. Métricas por ano: média de gv e variância genética da população de genitores.
5. 20 repetições com sementes registradas.
Compare a razão de ganho simulada com a razão teórica do passo anterior.
Plano primeiro.
```

## Slide 4.4 — Perguntas para explorar com o modelo mínimo

O modelo mínimo roda em poucos minutos. Isso permite experimentos rápidos, cada um com uma pergunta clara:

| Experimento | Pergunta | O que observar |
|---|---|---|
| Reduzir a acurácia genômica | A vantagem do desacoplado depende de *r*? | Ponto em que os cenários se igualam |
| Mais ciclos por ano | O ganho cresce indefinidamente? | Perda de variância genética |
| Tamanho menor da população de melhoramento | Qual o custo em diversidade? | Queda de σ²g e do ganho a longo prazo |

**Mensagem:** a simulação passa a ser uma ferramenta de raciocínio. Cada experimento testa uma frase do artigo.

## Slide 4.5 — Checkpoint

- A razão de ganho simulada é coerente com a razão teórica? Se não, por quê?
- A variância genética cai mais rápido no cenário desacoplado? Isso está de acordo com o que o artigo relata (com página)?
- O aluno consegue explicar o resultado sem olhar o código?

**Encerramento:** `notas/05_modelo_minimo.md` + commit + `/clear`.

---

# ETAPA 5 — Reprodução dos resultados do artigo (45 min)

## Slide 5.1 — Reproduzir não é copiar o resultado

| Conceito | Significado |
|---|---|
| Repetibilidade | Mesmo código, mesmos dados → mesmo resultado |
| Reprodutibilidade | Código independente, mesmas especificações → resultado compatível |
| Replicabilidade | Novo estudo, nova amostra → mesma conclusão |

Nesta etapa, buscamos **reprodutibilidade**: um código escrito a partir do texto do artigo que gere resultados compatíveis com os publicados.

## Slide 5.2 — Prompt da reprodução

```
Etapa 5 do PLANO.md. Leia CLAUDE.md, config/parametros_artigo.yaml,
notas/01_mapa_do_artigo.md e notas/05_modelo_minimo.md.

Escreva R/20_convencional.R e R/21_desacoplado.R reproduzindo os cenários
do artigo em escala completa, e R/30_figuras.R reproduzindo a Figura 2.
Regras:
- Todos os parâmetros vêm do YAML; nenhum valor fixo no código.
- Parâmetros "supostos" devem ser listados em DESVIOS.md com justificativa.
- Número de repetições do artigo; se for inviável, reduza, justifique e
  registre a consequência (largura do intervalo de confiança).
- Salve resultados brutos por repetição em resultados/ (formato longo).
Plano primeiro.
```

## Slide 5.3 — Critério de comparação com o artigo

Declarar a tolerância **antes** de ver o resultado:

```markdown
## Critérios de reprodução (definidos antes da execução)
- Ganho genético médio ao final do horizonte: diferença relativa ≤ 10%
  em relação ao valor lido na Figura 2.
- Ordenação dos cenários: idêntica à do artigo.
- Tendência da variância genética: mesma direção e forma qualitativa.
```

**Discussão:** definir o critério depois de ver o resultado convida à racionalização. É o mesmo princípio de pré-registro de hipóteses.

## Slide 5.4 — Registro de desvios

`DESVIOS.md`:

```markdown
| Item | Artigo | Nossa reprodução | Motivo | Impacto esperado |
|---|---|---|---|---|
| Sítios segregantes por cromossomo | não informado | 1.000 | valor usual em exemplos do AlphaSimR | baixo |
| Número de repetições | (valor do artigo) | 20 | tempo de aula | IC mais largo |
| Modelo de predição genômica | (conforme artigo) | RR-BLUP | disponibilidade no AlphaSimR | a verificar |
```

## Slide 5.5 — Comparação com o código dos autores (último passo)

Somente **depois** de concluir a reprodução independente:
- verificar se os autores disponibilizaram código (material suplementar, GitHub);
- como referência adicional, o repositório de exemplos de simulação de plantas com AlphaSimR (Bancic et al.) contém implementações de esquemas de melhoramento, inclusive a estratégia em duas partes;
- pedir ao agente uma comparação estruturada:

```
Compare nossos scripts em R/ com o código em artigo/codigo_autores/.
Liste diferenças de premissas, parâmetros e ordem das operações,
e indique quais explicam as diferenças entre nossos resultados e os do artigo.
```

**Por que por último?** Ler o código dos autores primeiro transforma a reprodução em cópia. Fazer depois transforma a comparação em aprendizado: cada diferença revela uma decisão de modelagem que o texto não deixou explícita.

**Encerramento:** commit + `/clear`.

---

# ETAPA 6 — Fechamento: relatório de reprodutibilidade (20 min)

## Slide 6.1 — O relatório final

```
Escreva REPRODUTIBILIDADE.md com:
1. Pergunta e conclusão central do artigo (com páginas).
2. O que foi reproduzido, com a figura original ao lado da nossa.
3. Critérios de comparação e se foram atendidos.
4. Desvios e seu impacto (resumo de DESVIOS.md).
5. O que o modelo mínimo ensinou sobre o mecanismo.
6. Limitações do artigo segundo notas/04_critica.md.
7. Como executar tudo do zero (comandos e tempo aproximado).
```

## Slide 6.2 — Checklist do aluno

- [ ] Consigo explicar o artigo em 3 minutos, sem consultar notas.
- [ ] Toda afirmação das minhas notas tem página, figura ou tabela.
- [ ] Conferi manualmente pelo menos 5 afirmações do agente no PDF.
- [ ] Sei quais parâmetros do artigo foram informados e quais foram supostos.
- [ ] Meu modelo mínimo concorda com a equação do melhorista, ou sei explicar por que não.
- [ ] Reproduzi a figura principal dentro de uma tolerância declarada previamente.
- [ ] Identifiquei ao menos três limitações do artigo.

## Slide 6.3 — Síntese da seção

```
Contexto controlado      →  PDF e suplementar na pasta; regras de citação no CLAUDE.md
Leitura em camadas       →  mapa, glossário, parâmetros, figuras
Perguntas nos dois sentidos → aluno pergunta; agente examina
Crítica independente     →  subagente revisor cético
Entendimento testável    →  modelo mínimo + equação do melhorista
Reprodução rastreável    →  YAML com fontes, DESVIOS.md, critérios pré-definidos
```

> A IA não leu o artigo por você. Ela organizou a leitura, testou o seu entendimento e ajudou a transformar o texto em código verificável.

## Slide 6.4 — Tarefa para a próxima seção

Escolher um artigo da própria área de pesquisa e aplicar o mesmo fluxo até a Etapa 4 (modelo mínimo). Entregar o repositório com as notas e o `PLANO.md` atualizado.

---

# Notas para o professor

## Preparação
- Confirmar a referência completa do artigo-guia (título, periódico, ano) e se há material suplementar e código disponíveis.
- Verificar a licença do artigo antes de distribuí-lo à turma.
- Rodar previamente o modelo mínimo e medir o tempo de execução nas máquinas da turma.
- Preparar uma versão já extraída de `parametros_artigo.yaml` para conferência (o gabarito do professor).
- Ter um PDF de outro artigo dos mesmos autores para demonstrar, na abertura, o risco de confusão entre trabalhos.

## Onde o professor deve intervir
- Quando o agente atribuir ao artigo um resultado de outro trabalho dos mesmos autores.
- Quando parâmetros aparecerem no YAML sem fonte.
- Quando a turma aceitar a primeira resposta sem conferir a página citada.
- Quando o modelo mínimo divergir da expectativa teórica e a turma quiser "ajustar" o código até coincidir, em vez de entender a divergência.

## Referências
- Gaynor, R. C. et al. (2017). A two-part strategy for using genomic selection to develop inbred lines. *Crop Science*, 57(5), 2372–2386.
- Gaynor, R. C.; Gorjanc, G.; Hickey, J. M. (2021). AlphaSimR: an R package for breeding program simulations. *G3*, 11(2), jkaa017.
- Cobb, J. N. et al. (2019). Enhancing the rate of genetic gain in public-sector plant breeding programs: lessons from the breeder's equation. *Theoretical and Applied Genetics*, 132, 627–645.
- Bancic, J. et al. (2023). Plant breeding simulations with AlphaSimR. *bioRxiv* (repositório de exemplos: github.com/HighlanderLab/jbancic_alphasimr_plants).
- Artigo-guia da seção: inserir a referência completa após confirmação.
