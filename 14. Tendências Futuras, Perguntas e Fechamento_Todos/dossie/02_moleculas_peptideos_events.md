# Bloco 2 — IA para Moléculas, Peptídeos, Proteínas, Traits e Events

*Dossiê de aula — Curso "IA no Melhoramento de Plantas" (UFV, nov/2026). Público: melhoristas/geneticistas. Parceiro do curso: Bayer Crop Science.*

> Convenção: números sem marca foram verificados em fonte primária (DOI/URL na seção 10). `[VERIFICAR]` indica valor volátil, de preprint, declaração corporativa não auditada, ou detalhe não confirmado em fonte primária.

---

## Resumo executivo

Seleção genômica e OCS (Sessões 06 e 09) otimizam **alelos que já existem** no germoplasma. Este bloco trata do caso em que o produto é uma **molécula, um peptídeo, uma proteína engenheirada ou um event transgênico** — a chamada *trait technology*. A tese central é um paradoxo econômico: a IA está reduzindo o atrito da **descoberta**, mas o tempo total até o mercado **aumentou**. Entre 2008–12 e 2017–22, o custo de um novo event GM caiu de US$ 136 mi para US$ 115 mi, enquanto o tempo subiu de 13,1 para 16,5 anos. Em defensivos, triam-se ~160.000 moléculas para achar um ingrediente ativo comercializável, a US$ 307 mi e ~11 anos. Entender **onde** no pipeline a IA realmente age — e onde não age — é pré-requisito para as decisões de portfólio da Sessão 10.

---

## 1. A economia da descoberta

### 1.1 Defensivos químicos (crop protection)

Fonte de referência: série "black box" da **AgbioInvestor** (antes Phillips McDougall) para a **CropLife International**, com dados de BASF, Bayer, Corteva, FMC e Syngenta.

- **Período 2020–2023**: custo médio de **US$ 307 milhões** por ingrediente ativo (i.a.) novo e **pouco mais de 11 anos** da primeira síntese à primeira venda. O estudo anterior (2014–2019) indicava US$ 301 mi e 12,3 anos.
- **Repartição (2020–2023)**: Desenvolvimento **US$ 138,5 mi (45,1%)**; Pesquisa **US$ 133,3 mi (43,4%)**; Registro **US$ 35,4 mi (11,5%)**.
- **Maior item isolado**: química de síntese e formulação, **US$ 75 mi** (+17,4% vs. período anterior). Ensaios de campo: **US$ 59 mi**. **Triagem biológica caiu para US$ 46 mi (15% do total)** — uma década atrás era o maior custo do processo.
- **Trajetória histórica**: US$ 152 mi (1995) → 184 mi (2000) → 256 mi (2005–08) → 286 mi (2010–14) → 301 mi (2014–19) → **307 mi (2020–23)**. O último salto é o menor em 30 anos de série (<2%).
- **Taxa de sucesso ~1 em 160.000**: a Bayer reporta que, para encontrar **um** i.a. comercializável, triam-se em média **~160.000 moléculas**. O número subiu de **52.500 (1995) para 159.574 (2014)**, dirigido por critérios de segurança mais estritos. No mesmo intervalo, o nº de substâncias lançadas/ano caiu de **4 (1995) para 1,5 (2014)**.

**Escassez de novos modos de ação (MoA) e resistência** são os dois gargalos biológicos. Duke et al. (2024) registram que as grandes empresas ainda triam **10.000 a 60.000 moléculas novas por ano** por programa de descoberta herbicida.

### 1.2 Events / traits GM

- **Phillips McDougall (event introduzido em 2008–2012)**: **US$ 136 mi** e **13,1 anos** da iniciação do projeto à comercialização. A fase de **ciência regulatória + registro** é a mais longa (**36,7% do tempo**, 25,8% do custo = US$ 35,1 mi). Descoberta US$ 31 mi; otimização de constructo US$ 28,3 mi. O nº de "unidades" triadas (genes, constructos ou events) para gerar **um** trait subiu de **1.638 (pré-2002) para 6.204 (2008–2012)**.
- **AgbioInvestor (event comercializado em 2017–2022)**: custo caiu 15,4% para **US$ 115 mi**, mas o tempo subiu para **16,5 anos** (~400,1 meses não-consecutivos). Repartição: descoberta **US$ 7,6 mi (6,6% do custo, 13,3% do tempo)**; **construção e teste do event US$ 64,2 mi (55,8% do custo, 35,6% do tempo)**; **regulatório US$ 43,2 mi (37,6% do custo, 51,1% do tempo)**. Ciência regulatória isolada: US$ 32,9 mi; introgressão/breeding/wide-area testing: US$ 29,0 mi.
- **Ponto crítico**: nenhum desses números inclui o tempo adicional para desenvolver e aprovar as **variedades com traits empilhados**, que são o produto comercial real na maioria das culturas.

### Tabela A — Pipeline, tempo, custo e onde a IA atua

**Defensivo químico (base AgbioInvestor 2020–23)**

| Etapa | Tempo / Custo típico | Onde a IA atua hoje |
|---|---|---|
| Identificação de alvo | dentro dos US$ 133,3 mi de pesquisa | ML identifica proteínas-"fechadura" exclusivas do alvo (CropKey) |
| Descoberta (hit → lead) | química US$ 75 mi; triagem biológica US$ 46 mi | Virtual screening de bilhões de moléculas; química generativa (Chemistry42); DEL + ML (Enko); fenotipagem de alto conteúdo + IA (Moa GALAXY) |
| Otimização de lead | parte dos US$ 133,3 mi | Predição ADMET/ecotox; seletividade a não-alvos; rota e custo de síntese |
| Desenvolvimento | US$ 138,5 mi (45,1%) | Modelagem de degradação no solo; formulação |
| Registro | US$ 35,4 mi (11,5%); ~11 anos no total | Organização de dossiê; predição toxicológica |

**Event / trait GM (base AgbioInvestor 2017–22)**

| Etapa | Custo (% do total) | % do tempo | Onde a IA / otimização atua |
|---|---|---|---|
| Descoberta do gene/trait | US$ 7,6 mi (6,6%) | 13,3% | Design de proteínas (Bt, HPPD); binders desenhados por IA; DNA/protein LMs |
| Construção e seleção de event | US$ 64,2 mi (55,8%) | 35,6% | Predição de sítio de inserção, nº de cópias, estabilidade de expressão; priorização de events |
| Introgressão / wide-area testing | US$ 29,0 mi (dentro de 55,8%) | — | Look-ahead selection; MTI; minimização de *linkage drag* |
| Regulatório | US$ 43,2 mi (37,6%) | 51,1% | Caracterização molecular; bioinformática de dossiê |

---

## 2. Como a IA está sendo usada — exemplos industriais verificados

### 2.1 Bayer "CropKey"

A Bayer descreve publicamente um paradigma **fechadura-chave**: ML identifica proteínas-alvo exclusivas do organismo-praga ("locks") e **virtual screening + modelagem preditiva** desenham "keys" novas, checando *in silico* se a molécula **não se liga a proteínas de organismos não-alvo** e avaliando **degradabilidade no solo** e **rota/custo de síntese**. A biblioteca física de referência tem **2,6 milhões de compostos**; o virtual screening permite analisar ordens de grandeza a mais.

Resultados declarados pela empresa: **>30 alvos moleculares** em investigação, **>10 validados** como novos MoA em pesquisa inicial e **2 novos MoA já desenhados** — um fungicida de amplo espectro para frutas/hortaliças e um herbicida pós-emergente para *broadacre*. `[VERIFICAR]` — são declarações corporativas, sem publicação revisada por pares nem produto registrado até esta data.

### 2.2 Bayer–Ginkgo Bioworks

JV **Joyn Bio** (2017) → acordo de 2022 (Bayer desinveste o site de P&D de biológicos em West Sacramento e sua plataforma de descoberta) → **parceria estendida em 31/out/2025**. Foco em **biológicos**: fixação biológica de nitrogênio, sequestro de carbono e proteção biológica de próxima geração. É um track distinto do CropKey, que é químico/sintético.

### 2.3 Syngenta–Insilico Medicine

Anunciada em **03/fev/2021**. Transferência da plataforma de **química generativa Chemistry42** da farmacêutica para crop science, com foco em **controle de plantas daninhas**. Ao longo de **3 anos** a colaboração aplicou química generativa a **3 projetos de pesquisa**; em todos foram identificadas **novas áreas de lead**, com compostos propostos pela IA apresentando atividade **in vitro e in vivo**. Benchmark de origem: a Insilico desenhou uma molécula nova para um alvo conhecido em **46 dias** (2019).

### 2.4 Outras plataformas

- **Enko Chem** (fundada 2017). Plataforma **ENKOMPASS** = **DNA-encoded libraries (DEL) + machine learning + structure-based design**, capaz de triar **bilhões** de moléculas. **US$ 150 mi** levantados até 2023; parcerias com **Bayer, Syngenta e Nufarm**; biblioteca DEL internalizada da X-Chem (2022).
- **Moa Technology** (spin-out da Universidade de Oxford, 2017/18, a partir do grupo de Liam Dolan). Plataforma **GALAXY**: fenotipagem de alto conteúdo em **plantas miniaturizadas**, **25.000 compostos/mês**, com IA/ML comparando o fenótipo observado ao de herbicidas de MoA conhecido. **>750.000 compostos triados** e **>60 áreas de MoA novas** identificadas (algumas fontes da empresa citam >70 em três anos). Plataformas complementares: *Target* e *Select*.
- **Micropep Technologies**. Plataforma **Krisalix** (IA generativa + modelos preditivos + bioensaios + bioprodução) gera e tria **milhões de sequências** de micropeptídeos *in silico*. **MPD-01** (biofungicida, primeiro produto desenhado com IA, validado em 2021) teve eficácia de campo **igual ou superior** a padrões químicos comerciais em **mais de 25 ensaios** de validação nos dois hemisférios. A empresa afirma que micropeptídeos podem agir a **1/10–1/100** das doses de químicos convencionais e cita **~100× de redução de custo** via bioprodução vs. síntese química `[VERIFICAR]`. Série B de **US$ 40 mi** (com Corteva Catalyst e Sparkfood), **>US$ 60 mi** no total.
- **GreenLight Biosciences – Calantha**: bioinseticida de **dsRNA/RNAi aplicado** (foliar), i.a. **ledprona**, que silencia o gene *PSMB5* do besouro-da-batata-do-Colorado. **Registro EPA em 21/dez/2023**, primeira venda em 2024, dose de **4 g/acre**, degradação em ~3 dias. Mostra a extensão do conceito "molécula desenhada" para biológicos de RNA.
- **Provivi**: feromônios de mariposa para confusão sexual — outra rota de *trait technology* aplicada.

---

## 3. Peptídeos contra fitopatógenos e pragas

### 3.1 Peptídeos antimicrobianos (AMPs) descobertos por ML

| Estudo | Abordagem | Resultado-chave |
|---|---|---|
| **AGRAMP** (Shao et al., *Front. Microbiol.*, 07/03/2024) | n-gramas sobre alfabetos reduzidos de aminoácidos (3 e 9 letras) + Random Forest; validação cruzada 5-fold | Acurácia **0,72–0,91**; **~7%** de 685.924 peptídeos do genoma de citros previstos como prováveis AMPs; subconjunto **validado experimentalmente** contra *Spiroplasma citri* (citrus stubborn). Servidor público (USDA-ARS + George Mason) |
| **Su et al.** (*Chem. Biol. Technol. Agric.*, 09/03/2025) | **6.706 genomas de *Bacillus*** (RefSeq) → 56.548.776 polipeptídeos de 10–100 aa → ensemble de **BERT, Mamba, CNN-LSTM e CNN-Attention** (interseção dos 4 modelos) | **4.993.389 candidatos a AMP**; **2 validados** (cAMP_1 e cAMP_2) por dinâmica molecular e ensaio, com atividade contra *E. coli*, *S. aureus*, bactérias do tabaco e fungos como *Fusarium oxysporum* e *Phytophthora nicotianae* |
| **Ran et al.** (*J. Agric. Food Chem.*, 2025, 73(28):17471–17482) | Banco de AMPs *de novo* + 6 descritores físico-químicos; 4 modelos, **XGBoost** melhor (**R² = 0,77; RMSE = 1,8**) | Peptídeo **TP** com supressão quase completa de ***Fusarium graminearum*** (giberela) a **13,33 μM**; dinâmica molecular indica interação eletrostática → inserção hidrofóbica → ligação à **miosina** |

Leitura pedagógica: nos três casos a IA **não inventa** o peptídeo do zero — ela **prioriza candidatos** dentro de espaços de milhões a dezenas de milhões de sequências, cortando o custo experimental. E nos três casos há **validação molhada**, que é o critério para citar o trabalho em aula.

### 3.2 Peptídeos inseticidas comerciais

**Vestaron Spear** — i.a. **GS-omega/kappa-Hxtx-Hv1a**, peptídeo derivado de **veneno de aranha** (funnel-web australiana do gênero *Hadronyche*; a espécie exata implícita na sigla "Hv" é *H. versuta* `[VERIFICAR]`).

- **Primeiro registro EPA: 03/fev/2014**. EPA Reg. **88847-6** (VST-006340 LC), **2,0% de i.a.**, nomes alternativos SPEAR-T, SPEAR-LEP, SPEAR-RC etc.
- **IRAC Grupo 32**; inibidor do sistema nervoso central do inseto (atua sobre canais iônicos).
- **Ação de contato, sem atividade sistêmica** → exige cobertura foliar excelente e gota fina; não atua sobre ovos. **Intervalo pré-colheita: 0 dias**.
- Alvos de bula: pulgões, ácaros (*broad* e rajado), tripes, moscas-brancas, psilídeos, *Drosophila suzukii* e lepidópteros em sublabel com Bt.
- Perfil toxicológico favorável (sem toxicidade reportada a peixes, aves ou mamíferos) — base do apelo regulatório.

**Outros players**: SOLASTA Bio (neuropeptídeos de inseto, com foco em seletividade) — números de eficácia e patentes `[VERIFICAR]` antes de citar em slide.

### 3.3 Desafios transversais dos peptídeos

1. **Estabilidade**: proteólise no filoplano, degradação por UV, pH da calda.
2. **Entrega e formulação**: ação de contato, penetração de dossel, adjuvantes (surfactante não-iônico ou organossilicone na bula do Spear).
3. **Custo de produção (COGS)**: síntese química é cara para moléculas de 10–100 aa; bioprodução (fermentação) é a rota para viabilidade por hectare.
4. **Regulatório**: nos EUA, aprovação como **biopesticida** (Divisão de Biopesticidas da EPA) ou **PIP**, quando expresso na planta. No Brasil, a rota depende de ser produto aplicado (MAPA/IBAMA/ANVISA) ou expresso em planta (CTNBio).

---

## 4. Proteínas e traits: engenharia assistida por ML

### 4.1 Toxinas Bt (Cry / Vip)

- **Evolução dirigida contínua (PACE)** — Badran et al., *Nature* (2016). Variantes de **Cry1Ac** foram evoluídas, ao longo de **>500 gerações** de mutação/seleção/replicação, para ligar um receptor caderina (**TnCAD**) de *Trichoplusia ni* **não reconhecido** pelo tipo selvagem. Resultado: afinidade **Kd = 11–41 nM**, lise de células que expressam TnCAD e letalidade **até 335× maior** contra populações de *T. ni* **resistentes a Cry1Ac**. É a prova de conceito de que se pode **vencer resistência redesenhando a ligação ao receptor**.
- **ML / AlphaFold3 + evolução dirigida**: revisões de 2026 (*Toxins*) descrevem a predição de interações toxina–receptor para priorizar variantes de alta afinidade em bibliotecas grandes, com claim de redução de até 80% nos ciclos experimentais `[VERIFICAR]` — a magnitude vem de literatura secundária, não do estudo original.
- **MULTI-evolve** (Arc Institute): framework de ML treinado em **~200 variantes** focadas em pares de mutações que aumentam função, para prever combinações multi-mutação benéficas. Relevante porque proteínas agrícolas raramente têm datasets grandes.
- **Vip3Ca**: engenharia **racional** (sítios de clivagem por protease entre domínios I e II + afinidade por BBMV) elevou a atividade inseticida em **1,52–1,96×** na ligação e **até 12,3×** na toxicidade (contra *Ostrinia furnacalis*). Sem ML no estudo — serve para mostrar que engenharia estrutural clássica já entrega ganhos grandes.

### 4.2 Enzimas de tolerância a herbicida (HPPD / PPO)

- **FG72** (Bayer CropScience + M.S. Technologies, soja, OECD MST-FGØ72-2): expressa **hppdPfW336** de *Pseudomonas fluorescens* — uma **única troca de aminoácido (W336)** torna a enzima insensível à forma ativa (dicetonitrila) do **isoxaflutol** — somada a **2mepsps** (glifosato). Produto: **LibertyLink GT27** (FG72 × A5547-127). Caso didático perfeito de **engenharia de proteína dirigida por estrutura**.
- **SYHT0H2** (Syngenta + Bayer, soja): **avhppd-03** de aveia (*Avena sativa*), cuja HPPD tem baixa afinidade por mesotriona e isoxaflutol, + **pat** (glufosinato).
- **PPO (Grupo 14)**: ao contrário do HPPD, a soja comercial é em geral **sensível** a inibidores de PPO; não há trait amplamente comercializado de tolerância a PPO análogo ao de HPPD `[VERIFICAR]` para status de pipeline atual.

### 4.3 Traits de RNAi

**SmartStax PRO / event MON 87411** combina **DvSnf7 dsRNA** (repetição invertida que silencia o gene *Snf7* da larva de *Diabrotica virgifera virgifera*) + **Cry3Bb1** + **CP4 EPSPS**. Cronologia: APHIS concede *nonregulated status*; FDA sem objeções em out/2014; **registro EPA do PIP em jun/2017**; aprovação final de importação da China em **jan/2021**; **lançamento comercial nos EUA em 2022**. Entrega **3 MoA para corn rootworm** (2 Bt + 1 RNAi) e **6 MoA no total** com os traits acima do solo — estratégia explícita de manejo de resistência.

### 4.4 Engenharia de receptores imunes (NLR) — "Pikobodies"

Kourelis, Marchal, Posbeyikian, Harant & Kamoun, *Science* (2023). O par NLR de arroz **Pikm-1/Pikm-2** teve o **domínio integrado HMA** do Pik-1 (que normalmente detecta efetores AVR-Pik de *Magnaporthe oryzae*) **substituído por nanobodies (VHH) de camelídeos** que ligam proteínas fluorescentes. As fusões **disparam resposta imune** na presença da FP correspondente e **conferem resistência** a vírus de planta que a expressam (PVX:EGFP, com desempenho comparável ao gene R nativo *Rx* em linhas estáveis de *N. benthamiana*).

Como nanobodies podem ser levantados contra praticamente qualquer molécula, o trabalho é prova de conceito de **resistência "sob medida"** contra patógenos que entregam efetores dentro da célula hospedeira. O gancho de IA é direto: **predição de estrutura e design de binders** (AlphaFold 3, RFdiffusion/ProteinMPNN) para desenhar o domínio de reconhecimento. Ressalva: é prova de conceito com alvo artificial (FP), **não** um produto, e a questão da **durabilidade** (escape do patógeno) permanece aberta.

---

## 5. Events: definição, seleção e integração

### 5.1 O que é um event

Um **event transgênico** é o produto único de **uma** inserção do transgene em um genoma: locus específico, arranjo, número de cópias e padrão de expressão definidos. De um mesmo constructo nascem **muitos events**, dos quais pouquíssimos avançam. Ter o gene **não** é ter o event: o mesmo cassete em outro locus é outro event, com outro dossiê regulatório, outro identificador OECD e outro valor de propriedade intelectual.

### 5.2 Seleção de event — critérios de caracterização molecular

- **Sítio de inserção**: preferencialmente região neutra, sem interromper gene endógeno; caracterizado por sequenciamento das junções flanqueadoras.
- **Número de cópias**: idealmente cópia única.
- **Integridade do inserto**: ausência de *backbone* do vetor e de sequências não intencionais.
- **Estabilidade de expressão**: entre gerações, tecidos e ambientes. Os dossiês trazem níveis de proteína por tecido e estágio — p.ex. FG72 reporta HPPDW336 em **38,4 µg/g (folha V4)**, 35,8 (V6), 27,2 (V8), 16,6 (caule V4), 5,81 (raiz V4) em peso seco.
- **Herança mendeliana** do locus.
- **Escala**: como visto na §1.2, triam-se **6.204 unidades** (genes/constructos/events) por trait entregue (2008–2012), contra 1.638 antes de 2002.

**Onde o ML entra**: predição de sítio de inserção e de expressão a partir da sequência genômica; classificação/priorização de events (quais passam no gate molecular); detecção automatizada de rearranjos nas junções.

### 5.3 Stacking e Multiple Trait Integration (MTI)

Referência: **Peng et al., *Molecular Breeding* (2014)**, Parte I (online ago/2013). MTI é um processo de **quatro etapas**: (1) introgressão de event único, (2) piramidação de events, (3) fixação do trait, (4) *version testing*.

O estudo simula a conversão de um híbrido-alvo de milho para **15 events transgênicos** — **8 no parental fêmea e 7 no macho**, em *streams* paralelos. Parâmetros verificados:

| Parâmetro | Valor |
|---|---|
| Genoma de referência | 1.788 cM |
| Recuperação mínima do parental recorrente (RP) | **96,66%** (≤120 cM de germoplasma NRP no híbrido convertido) |
| Meta por conversão de event único | **<8 cM** de NRP no genoma inteiro |
| Meta de *linkage drag* | **~1 cM** na janela de 20 cM flanqueando o event |
| Gerações de retrocruzamento assistido | **5** (BC1–BC5) |
| Tamanho de população | **600** em BC1–BC3 (seleção para o event + mínimo drag); **400** em BC4–BC5 (recuperação do RP) |
| Intensidade de seleção | **0,01** em todas as gerações |
| Efeito da similaridade genética do doador | <8 cM atingível em **BC5** sem similaridade, **BC4** com 30%, **BC3** com 86% |

A Parte III (PubMed 26491398) mostra que, com **5 versões** de cada conversão parental e teste de **25 versões de híbrido**, obtém-se **>95% de sucesso** em recuperar desempenho equivalente ao híbrido não convertido (dentro de 3%), desde que o NRP residual seja ≤180 cM; com ≤120 cM, bastam 4 versões de um dos parentais (20 híbridos testados).

### 5.4 Otimização e ML aplicados ao pipeline

- **Look-ahead selection (LAS)** — Moeinizade, Hu, Wang & Schnable, *G3* (20/05/2019). Define a função-objetivo como o **GEBV esperado do melhor descendente na geração terminal T** (prazo definido pelo usuário), otimizando simultaneamente **seleção de parentais, pares de acasalamento e alocação de progênie** sob recursos limitados, via algoritmo heurístico de simulação-otimização. Em dados empíricos de milho endogâmico, supera GS convencional, OHV e OPV, equilibrando **ganho de curto prazo × diversidade de longo prazo**. É o único dos métodos comparados que **ajusta a decisão em função do prazo**.
- **"Designed diversity"** — Yadav, Hickey, McNeil, Dodds & Hayes, *Trends in Plant Science* (online **21–22/abr/2026**). Reenquadra a introgressão de traits como **problema de otimização multi-objetivo com restrição**, equilibrando **probabilidade de sucesso × recuperação do genoma elite × tempo × recursos**. Ferramentas: *predicted/expected cross value*, *look-ahead selection*, pan-genomas, introgressiômica, *speed breeding*, duplo-haploides, edição gênica e engenharia de recombinação. A conclusão dos autores é relevante para a Sessão 09: as peças existem; falta integrá-las em ferramentas de decisão utilizáveis pelo melhorista, com biologia realista (incerteza de efeitos, G×E, dependência de fundo genético).

---

## 6. Contexto Brasil

- **CTNBio** (Comissão Técnica Nacional de Biossegurança, MCTI) autoriza pesquisa e uso comercial de OGMs, com base em avaliação de risco zoofitossanitário, à saúde humana e ao ambiente.
- **Dados de 2024** (relatório USDA FAS *Brazil Biotechnology Annual* BR2025-0043, citando a CTNBio): **134 events** de plantas aprovados para cultivo comercial — **65 milho, 25 algodão, 24 soja, 10 eucalipto, 7 cana-de-açúcar, 2 trigo (HB4), 1 feijão** (resistente a vírus, da **Embrapa** — primeiro GM desenvolvido integralmente por instituição pública). Contagem jornalística independente de jul/2024 reporta 131 liberações, com distribuição quase idêntica — a diferença é de data de corte.
- A base **ISAAA** lista **155 events** aprovados no Brasil, mas inclui aprovações de importação/alimentação além de cultivo — **não** é o mesmo denominador. Use sempre a fonte explicitando o critério.
- Primeiro event aprovado: **soja Roundup Ready (GTS-40-3-2), 1998**. Requerentes com mais aprovações: Monsanto (38), DowDuPont (22), Syngenta (19) `[VERIFICAR]` (contagem de jul/2024, fonte jornalística).

**Produtos Bayer no Brasil (casos de aula)**

| Produto | Composição | Marcos |
|---|---|---|
| **Intacta RR2 PRO** | MON 87701 × MON 89788 (Cry1Ac + CP4 EPSPS) | Aprovado pela CTNBio em **2010** (parecer 2542/10; revisão 7245/2020) |
| **Intacta 2 Xtend** | MON 87751 × MON 87708 × MON 87701 × MON 89788 — stack de **4 events** (Cry1A.105/Cry2Ab2, DMO/dicamba, Cry1Ac, CP4 EPSPS) | Cultivo aprovado no **Brasil em 2018**; China **jun/2020**; UE **jan/2021** (após parecer EFSA de set/2019); **lançamento comercial em 10/jun/2021**, safra 2021/22 |

Lição de portfólio: entre a aprovação de cultivo no Brasil (2018) e o lançamento comercial (2021) há **três anos** consumidos quase inteiramente por **aprovações de mercados importadores**. Para a Sessão 10, isso é custo de capital parado — e não aparece nos 16,5 anos do estudo AgbioInvestor, que mede só até "o ponto de comercialização" de um event isolado.

---

## 7. Paralelo com a descoberta de fármacos

| Caso | Status verificado |
|---|---|
| **AlphaFold 3** | Lançado em **mai/2024** por Google DeepMind + Isomorphic Labs; prevê estrutura e interações de proteínas, DNA, RNA e ligantes |
| **Isomorphic Labs** | Fundada em 2021; **US$ 600 mi** captados em **abr/2025** (liderados por Thrive Capital); colaborações com **Novartis e Eli Lilly** (2024); programas internos em oncologia e imunologia. **Até meados de 2025 ainda não havia iniciado ensaios em humanos** |
| **Insilico Medicine — rentosertib (ISM001-055)** | Inibidor de **TNIK** (alvo *first-in-class* descoberto por IA generativa) para **fibrose pulmonar idiopática**. Fase 2a GENESIS-IPF: **71 pacientes, 22 sítios na China**, 12 semanas, braços 30 mg QD / 30 mg BID / 60 mg QD / placebo. Endpoint primário (segurança) atingido; **FVC +98,4 mL** (IC 95% 10,9–185,9) no braço 60 mg/dia vs. **−20,3 mL** no placebo. *Nature Medicine* 2025; NCT05938920 |
| **Recursion** | Plataforma de fenômica + ML (Recursion OS); já com programas clínicos: **REC-4881** (MEK1/2) em Fase 2 para polipose adenomatosa familiar, **REC-1245** (RBM39) em Fase 1, **REC-617** (CDK7), **REC-3565** (MALT1) |

**O que transfere de farma para agro:** química generativa e exploração de espaço químico; virtual screening em escala; DEL + ML; predição de estrutura e design de proteínas/binders; otimização multiparâmetro (eficácia × seletividade × ADMET).

**O que NÃO transfere trivialmente:**

1. **Eficácia de campo** — o "paciente" é uma população de plantas em ambiente aberto, com G×E, pressão de praga variável e janela de aplicação. Nenhum modelo *in silico* substitui ensaio multilocal.
2. **Custo por hectare** — um defensivo precisa custar ordens de grandeza menos por grama que um fármaco; isso restringe severamente o espaço químico viável (rota de síntese e COGS entram no *design*, como no CropKey).
3. **Seletividade a não-alvos** — abelhas e polinizadores, organismos de solo, peixes, aves, inimigos naturais. O dossiê exige ~150 ensaios de efeito adverso.
4. **Persistência e degradação ambiental** — requisito regulatório que não tem análogo na farma.
5. **Tempo regulatório multinacional** — o gargalo real dos events (37,6% do custo, 51,1% do tempo), agravado pela necessidade de aprovação em mercados importadores.

---

## 8. Limitações, riscos e perguntas de discussão

**Limitações e riscos**

- Dados de treino proprietários e escassos, sobretudo em **ecotoxicologia** e em **espécies não-modelo**.
- Risco de os modelos otimizarem **potência** e subestimarem **seletividade e destino ambiental** — o que só aparece caro e tarde, no desenvolvimento.
- **Validação de campo é insubstituível**: eficácia de bancada ≠ eficácia agronômica.
- **Resistência evolui contra qualquer MoA**; o valor de um trait novo depende do plano de manejo (refúgio, rotação, múltiplos MoA como em SmartStax PRO).
- **Assimetria regulatória entre jurisdições** é o gargalo dominante do pipeline GM — e nenhuma IA a resolve.
- **Concentração**: plataformas de IA + DEL + dados exigem capital e escala, o que reforça a posição de poucos players.
- **Auditabilidade**: modelos caixa-preta no desenho de moléculas/proteínas criam passivo perante regulador e sociedade (mesmo argumento do Bloco 3 sobre NGT).

**Perguntas para a turma**

1. Se a IA corta o tempo de **descoberta** pela metade, por que o tempo total de um event GM **aumentou** de 13,1 para 16,5 anos? Onde investir, então?
2. Para peptídeos e micropeptídeos, qual restrição pesa mais no go/no-go: eficácia, estabilidade ou **custo de bioprodução**?
3. "Resistência sob medida" (Pikobodies) vs. **durabilidade**: como evitar que o patógeno escape em poucas safras? Qual seria o análogo do "refúgio" aqui?
4. Como validar *in silico* a **ausência de toxicidade a abelhas** antes de qualquer ensaio — e você assinaria embaixo desse resultado?
5. No portfólio da sua cultura: o próximo ganho em sanidade vem de **genética da planta** (event/edição) ou de **molécula aplicada** (química/biológico)? O que muda na decisão?

**Ganchos explícitos com o curso**

- **Sessão 09 (otimização)**: LAS, MTI de Peng et al. (2014) e "designed diversity" (2026) são exatamente o mesmo tipo de problema que vocês formularam em OCS — função-objetivo, restrições, orçamento de parcelas — só que com *events* e prazo como variáveis.
- **Sessão 10 (portfólio e ROI)**: com US$ 307 mi / 1-em-160.000 (defensivo) ou US$ 115 mi / 16,5 anos (event), como precificar o valor da IA? A resposta honesta é: ela atua sobre **atrito e custo de descoberta**, não sobre o relógio regulatório.

---

## 9. Take-home

1. **Molécula/peptídeo**: discovery acelerado por ML é real e documentado; o gargalo migrou para entrega, estabilidade, COGS e dossiê.
2. **Event** é unidade de **IP + regulatório + logística de conversão** — não é "ter o gene".
3. **Stacking é problema de otimização de pipeline**, não só de biologia (Peng 2014; LAS 2019; designed diversity 2026).
4. **O tempo é o ativo escasso**: custo do event caiu 15%, tempo subiu 26%.
5. **GS otimiza o alelo que existe; design molecular e events ampliam o menu** do que pode entrar no germoplasma elite.

---

## 10. Referências verificadas (DOI / URL)

**Economia do pipeline**

1. AgbioInvestor / CropLife International (2026). *The Cost of New Agrochemical Product Discovery, Development and Registration* (período 2020–23). <https://agbioinvestor.com/croplife-new-agrochemical-product-study-2026/> · PDF: <https://croplife.org/wp-content/uploads/2026/05/AgbioInvestor-The-Cost-of-New-Agrochemical-Product-Discovery-Development-and-Registration.pdf>
2. Phillips McDougall / CropLife International (2024). *Time and Cost of New Agrochemical Product Discovery, Development and Registration* (2014–19). <https://croplife.org/wp-content/uploads/2024/02/Time-and-Cost-To-Market-CP-2024.pdf>
3. Bayer. *Crop Protection Regulatory Process* (160.000 moléculas; 159.574 em 2014 vs 52.500 em 1995). <https://www.bayer.com/en/agriculture/article/bringing-crop-protection-products-market>
4. Phillips McDougall (2011). *The cost and time involved in the discovery, development and authorisation of a new plant biotechnology derived trait* (US$ 136 mi; 13,1 anos; 6.204 unidades). <https://croplife.org/wp-content/uploads/2014/04/Getting-a-Biotech-Crop-to-Market-Phillips-McDougall-Study.pdf>
5. AgbioInvestor (2022). *Time and Cost to Develop a New GM Trait* (US$ 115 mi; 16,5 anos). <https://croplife.org/wp-content/uploads/2022/05/AgbioInvestor-Trait-RD-Branded-Report-Final-20220512.pdf>
6. Duke, S. O. et al. (2024). *New Approaches to Herbicide and Bioherbicide Discovery*. <https://www.moa-technology.com/wp-content/uploads/2024/10/Duke-et-al-2024-New-Approaches-to-Herbicide-and-Bioherbicide-Discovery.pdf>

**IA em descoberta de defensivos**

7. Bayer. *CropKey — Setting new Benchmarks in Efficient, Safe, Sustainable Crop Protection*. <https://www.bayer.com/en/agriculture/cropkey>
8. Bayer / Ginkgo Bioworks (2022, 2025). <https://www.bayer.com/media/en-us/bayer-and-ginkgo-bioworks-close-deal-creating-agricultural-biologicals-powerhouse/> · extensão de 31/10/2025: <https://www.prnewswire.com/news-releases/ginkgo-bioworks-and-bayer-extend-multi-year-strategic-partnership-to-accelerate-next-generation-biological-solutions-for-agriculture-302600177.html>
9. Syngenta Crop Protection & Insilico Medicine (03/02/2021). <https://www.syngenta.com/media/media-releases/2021/syngenta-crop-protection-and-insilico-medicine-harness-artificial>
10. Baker, C. et al. *Generative Chemistry for Weed Control: A Collaboration Between Syngenta and Insilico Medicine* (abstract, 3 projetos). <https://dmccb24.scg.ch/component/phocadownload/category/1-lecture-abstracts?download=9>
11. Enko Chem — ENKOMPASS e Série C (US$ 150 mi). <https://www.prnewswire.com/news-releases/enko-completes-its-80m-series-c-to-progress-sustainable-crop-solutions-for-world-food-security-301734324.html>
12. Moa Technology — plataforma GALAXY. <https://www.moa-technology.com/scientific-approach/>
13. Micropep — plataforma Krisalix e pipeline. <https://micro-pep.com/technology/> · Série B de US$ 40 mi: <https://micro-pep.com/micropep-media/micropep-closes-series-b-round-at-40m/>
14. GreenLight Biosciences — Calantha (ledprona), registro EPA 21/12/2023. <https://www.epa.gov/pesticides/epa-registers-novel-pesticide-technology-potato-crops> · bula: <https://www3.epa.gov/pesticides/chem_search/ppls/094614-00002-20231221.pdf>

**Peptídeos**

15. Shao, J., Zhao, Y., Wei, W. & Vaisman, I. I. (2024). *AGRAMP: machine learning models for predicting antimicrobial peptides against phytopathogenic bacteria*. **Front. Microbiol.** DOI [10.3389/fmicb.2024.1304044](https://doi.org/10.3389/fmicb.2024.1304044) · servidor: <http://omics.gmu.edu/agramp/>
16. Su, H., Gu, M., Qu, Z. et al. (2025). *Discovery of antimicrobial peptides from Bacillus genomes against phytopathogens with deep learning models*. **Chem. Biol. Technol. Agric.** DOI [10.1186/s40538-025-00751-9](https://doi.org/10.1186/s40538-025-00751-9)
17. Ran, Y., Li, S., Wang, Y., Liang, J.-H., Jiang, W. & Yu, M. (2025). *AI-Accelerated Identification of Novel Antimicrobial Peptides for Inhibiting Fusarium graminearum*. **J. Agric. Food Chem.** 73(28):17471–17482. DOI [10.1021/acs.jafc.5c03429](https://doi.org/10.1021/acs.jafc.5c03429)
18. US EPA — *GS-omega/kappa-Hxtx-Hv1a*, primeiro registro 03/02/2014. <https://ordspub.epa.gov/ords/pesticides/f?p=CHEMICALSEARCH:3:::::1,3,31,7,12,25:P3_XCHEMICAL_ID:25018>
19. US EPA — bula VST-006340 LC / SPEAR (EPA Reg. 88847-6). <https://www3.epa.gov/pesticides/chem_search/ppls/088847-00006-20210304.pdf>

**Proteínas, Bt, RNAi e traits**

20. Badran, A. H. et al. (2016). *Continuous evolution of Bacillus thuringiensis toxins overcomes insect resistance*. **Nature**. <https://pmc.ncbi.nlm.nih.gov/articles/PMC4865400/>
21. *Improved insecticidal activity of Vip3Ca protein through enhanced processing and receptor affinity* (2025). **Pest Manag. Sci.** DOI [10.1002/ps.70555](https://doi.org/10.1002/ps.70555)
22. *Field-Evolved Resistance to Bt Cry Toxins in Lepidopteran Pests* (2026). **Toxins** 18(2):60. <https://www.mdpi.com/2072-6651/18/2/60>
23. US EPA — *EPA Registers Innovative Tool to Control Corn Rootworm* (SmartStax PRO, jun/2017). <https://www.epa.gov/pesticide-registration/epa-registers-innovative-tool-control-corn-rootworm>
24. USDA APHIS — *NEPA Decision and FONSI, MON 87411 Maize* (DvSnf7 + Cry3Bb1 + CP4 EPSPS). <https://direct.aphis.usda.gov/sites/default/files/13_29001p_fonsi.pdf>
25. Bayer (21/01/2021). *Third Generation Corn Rootworm Trait Gains Final Approval; SmartStax PRO to Launch in US in 2022*. <https://www.bayer.com/en/us/smartstaxr-pro-technology-launch>
26. CFIA — *Decision Document DD2012-91: soybean event FG72* (hppdPfW336; expressão em µg/g). <https://inspection.canada.ca/en/plant-varieties/plants-novel-traits/approved-under-review/decision-documents/dd-2012-91>
27. CFIA — *Decision Document DD2014-103: soybean event SYHT0H2* (avhppd-03 + pat). <https://inspection.canada.ca/en/plant-varieties/plants-novel-traits/approved-under-review/decision-documents/dd-2014-103>
28. Kourelis, J., Marchal, C., Posbeyikian, A., Harant, A. & Kamoun, S. (2023). *NLR immune receptor–nanobody fusions confer plant disease resistance*. **Science**. DOI [10.1126/science.abn4116](https://doi.org/10.1126/science.abn4116)

**Events, MTI e otimização**

29. Peng, T. et al. (2014). *Optimized breeding strategies for multiple trait integration: I. Minimizing linkage drag in single event introgression*. **Mol. Breeding**. DOI [10.1007/s11032-013-9936-7](https://doi.org/10.1007/s11032-013-9936-7)
30. *Optimized breeding strategies for multiple trait integration: III. Parameters for success in version testing*. **Mol. Breeding**. <https://pubmed.ncbi.nlm.nih.gov/26491398/>
31. Moeinizade, S., Hu, G., Wang, L. & Schnable, P. S. (2019). *Optimizing Selection and Mating in Genomic Selection with a Look-Ahead Approach: An Operations Research Framework*. **G3** DOI [10.1534/g3.118.200842](https://doi.org/10.1534/g3.118.200842)
32. Yadav, S., Hickey, L. T., McNeil, M., Dodds, P. N. & Hayes, B. J. (2026). *Designed diversity: from marker-assisted backcrossing to computationally optimised polygenic introgression*. **Trends Plant Sci.** DOI [10.1016/j.tplants.2026.04.003](https://doi.org/10.1016/j.tplants.2026.04.003)

**Brasil**

33. USDA FAS (2025). *Brazil: Biotechnology and Other New Production Technologies Annual*, relatório BR2025-0043 (134 events CTNBio, 2024).
34. CTNBio / MCTI. *Resumo Geral de Plantas Geneticamente Modificadas aprovadas para Comercialização* (tabela oficial, inclui Intacta RR2 PRO e Intacta2 Xtend).
35. ISAAA. *GM Crop Events approved in Brazil* (155 events, critério inclui importação). <https://www.isaaa.org/gmapprovaldatabase/approvedeventsin/default.asp?CountryID=BR>
36. AgroPages (jun/2021). *Intacta 2 Xtend soybean launched in Brazil* (lançamento 10/06/2021). <https://news.agropages.com/News/NewsDetail---39432.htm>
37. Bayer / Agrolink (22/01/2021). *Soja Intacta 2 Xtend é aprovada pela União Europeia*. <https://www.agrolink.com.br/noticias/soja-intacta-2-xtend-e-aprovada-pela-uniao-europeia_445218.html>

**Paralelo com fármacos**

38. Zhavoronkov, A. et al. (2025). *A generative AI-discovered TNIK inhibitor for idiopathic pulmonary fibrosis: a randomized phase 2a trial*. **Nature Medicine**. DOI [10.1038/s41591-025-03743-2](https://doi.org/10.1038/s41591-025-03743-2) · NCT05938920
39. Isomorphic Labs (abr/2025). *US$ 600 million funding to further develop its next-generation AI drug design engine*. <https://www.prnewswire.com/news-releases/isomorphic-labs-announces-600-million-funding-to-further-develop-its-next-generation-ai-drug-design-engine-and-advance-therapeutic-programs-into-the-clinic-302415534.html>
40. Recursion Pharmaceuticals. *Pipeline* (REC-4881 Fase 2; REC-1245 Fase 1). <https://www.recursion.com/pipeline>

---

## Anexo — itens a verificar antes da aula

| Item | Status |
|---|---|
| Espécie exata da aranha de origem do Hv1a (*Hadronyche versuta*) | `[VERIFICAR]` — inferido da nomenclatura do peptídeo |
| "Redução de até 80% nos ciclos experimentais" em evolução de Bt guiada por AlphaFold3 | `[VERIFICAR]` — vem de revisão secundária (Toxins 2026), não do estudo primário |
| Claims da Bayer sobre CropKey (>30 alvos, >10 MoA, 2 MoA desenhados) | `[VERIFICAR]` — declaração corporativa, sem peer review |
| "~100× de redução de custo" da bioprodução de micropeptídeos (Micropep) | `[VERIFICAR]` — declaração do CTO em release |
| Eficácia (≥85%) e nº de patentes da SOLASTA Bio | `[VERIFICAR]` — não confirmado em fonte primária |
| Status de pipeline de traits de tolerância a PPO | `[VERIFICAR]` |
| Contagem de aprovações por requerente na CTNBio (Monsanto 38, etc.) | `[VERIFICAR]` — fonte jornalística, jul/2024 |
| Números de página de Peng et al. 2014 (citar por DOI) | `[VERIFICAR]` |
