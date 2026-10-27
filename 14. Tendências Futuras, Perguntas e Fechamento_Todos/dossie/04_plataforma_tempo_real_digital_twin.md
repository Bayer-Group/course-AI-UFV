# Bloco 4 — Plataformas de melhoramento, dados em tempo real, automação, enviromics, modelos de cultura e gêmeos digitais

**Material de aula — Pós-graduação "IA no Melhoramento Vegetal" (UFV, nov/2026)**
Pré-requisitos assumidos: QC em DuckDB (Sessão 04), modelos mistos VCU em `lme4`, GBLUP, OCS e AlphaSimR (Sessão 09).
Convenção: números verificados na fonte primária aparecem sem marcação; números incertos ou apenas de comunicação corporativa aparecem com **[VERIFICAR]**.

---

## Sumário executivo

Três correções em relação ao que circula sobre o tema, encontradas na verificação das fontes primárias, e que devem ser ditas em aula:

1. **O DT-FieldPheno não é um sistema de VANT.** É uma plataforma de fenotipagem **sobre trilhos** (rail-based), do Beijing Academy of Agriculture and Forestry Sciences. Os números de 27 dias e 50% de redução de inspeção manual estão corretos.
2. **Hassanpour et al. (2023) não usou otimização bayesiana**: usou regressão kernel. O algoritmo evolucionário veio no artigo seguinte (G3 jkae248). Quem usou otimização bayesiana de fato foi **Jannink et al.** (Crop Science), com BoTorch, e o artigo relata *dificuldades*, não sucesso irrestrito.
3. **A patente WO/2025/080804 é da Pioneer Hi-Bred International Inc. (Corteva)**, não da Bayer. Inventor: Andrew Paul Beatty. Ela reivindica explicitamente aprendizado por reforço sobre um MDP.

A tese central do bloco: **praticamente tudo que hoje se chama "gêmeo digital de programa de melhoramento" é, pela taxonomia de Kritzinger, um *digital model* ou um *digital shadow*.** O AlphaSimR usado na Sessão 09 é um modelo digital: não há fluxo automático de dados do programa físico para dentro dele, nem do modelo de volta para o campo. Isso não é defeito; é categoria. O erro é vender modelo como gêmeo.

---

## 1. Definições: modelo, sombra e gêmeo digital

### 1.1 A taxonomia de Kritzinger

Kritzinger et al. (2018) classificam representações virtuais pelo **nível de integração de dados**, não pela sofisticação do modelo:

| Nível | Físico → Virtual | Virtual → Físico | Analogia no melhoramento |
|---|---|---|---|
| **Digital Model (DM)** | manual | manual | AlphaSimR parametrizado à mão com h² e variâncias de um relatório |
| **Digital Shadow (DS)** | automático | manual | Breedbase/EBS recebendo dados do Field Book via BrAPI; dashboard de ganho genético |
| **Digital Twin (DT)** | automático | automático | nenhum caso público plenamente validado em melhoramento vegetal |

A revisão mostrou que, mesmo na manufatura, a literatura sobre DT pleno é escassa, enquanto DM e DS abundam. O mesmo padrão se repete, com atraso, na agricultura.

> **Ponto de aula.** No pipeline das Sessões 04 e 09, quando um valor fenotípico novo entra no banco, alguma coisa muda sozinha no modelo de decisão? Se a resposta é "não, alguém roda o script", é digital shadow (ou digital model).

### 1.2 Níveis de gêmeo em agricultura (Verdouw)

Verdouw et al. (2021), *Agricultural Systems* 189:103046, propõem seis tipos, organizados pelo ciclo de vida do objeto físico:

- **Imaginary**: o objeto ainda não existe (simular um esquema de melhoramento não implantado).
- **Monitoring**: estado atual, descritivo e diagnóstico, em tempo quase real.
- **Predictive**: projeção de estados futuros com dados correntes.
- **Prescriptive**: recomenda ações; **a decisão continua humana**.
- **Autonomous**: controla o objeto físico sem intervenção humana.
- **Recollection**: memória histórica de objetos que já não existem (crucial para rastrear germoplasma descartado).

Os tipos não são excludentes; um sistema pode combinar vários. A tipologia é pedagogicamente mais útil que a de Kritzinger porque separa *predictive* de *prescriptive*: a maior parte do valor em melhoramento está no prescritivo, que por definição mantém o humano no circuito.

Definição complementar recente: Ganapathysubramanian, Sarkar, Singh & Singh (2025), *Trends in Plant Science* 30(5):576–577, descrevem DTs como construtos matemáticos de alta fidelidade cujo estado virtual é revisado periodicamente com dados do análogo físico, em escalas de célula, órgão, planta, parcela e campo.

### 1.3 Simulação estocástica ≠ gêmeo operacional

| | Simulação estocástica | Gêmeo operacional |
|---|---|---|
| Pergunta | "Que arquitetura de programa é melhor?" | "O que faço com *este* lote, *nesta* semana?" |
| População | sintética, replicada centenas de vezes | a população real, uma realização só |
| Fonte de parâmetros | literatura, suposições | dados correntes do próprio programa |
| Métrica | ganho genético acumulado em 20–40 anos | acerto da decisão nesta safra |
| Ferramentas | AlphaSimR, MoBPS, ChromaX | EBS/Breedbase + modelos + regras |

**AlphaSimR** (Gaynor, Gorjanc & Hickey 2021, *G3* 11(2):jkaa017) simula ao nível de sequência de DNA, para diploides e autopoliploides, via scripting em R. **MoBPS** (Pook, Schlather & Simianer 2020, *G3* 10(6):1915–1918) usa armazenamento bit-wise via `miraculix` e traz OCG e ssGBLUP pré-implementados; tem interface web (MoBPSweb, *G3* 11(2):jkab023) em mobps.de, declaradamente voltada ao ensino.

**ChromaX** (Younis et al. 2024, *Bioinformatics*, DOI 10.1093/bioinformatics/btad691) reescreve a simulação em JAX/XLA. Tabela 1 do artigo, para 100.000 cruzamentos biparentais, 1.000 marcadores, 10 cromossomos:

| Ferramenta / hardware | Tempo (ms) |
|---|---|
| AlphaSimR, CPU (AMD EPYC 7742) | 14.821 ± 149 |
| AlphaSimR, Apple M1 | 8.825 ± 36 |
| ChromaX, CPU | 5.149 ± 94 |
| ChromaX, Apple M1 | 2.086 ± 22 |
| **ChromaX, GPU (Quadro RTX 6000)** | **29 ± 2** |

Em CPU, ChromaX é ~3× mais rápido; em GPU, cerca de **500×** no programa completo de Gaynor et al. Em GPU o tempo escala de forma sub-linear. A contrapartida (Tabela 3 do artigo) é **consumo de memória substancialmente maior**, atribuído ao desenho funcional e à vetorização. Ganho de 500× em tempo só vira ganho prático se a GPU tiver memória suficiente.

---

## 2. Simulação de programas como ferramenta de decisão

### 2.1 A estratégia em duas partes

Gaynor et al. (2017), *Crop Science*, DOI 10.2135/cropsci2016.09.0742, simularam 40 anos de programas inteiros sob **custo operacional anual aproximadamente igual**, a restrição que torna a comparação honesta. O programa se divide em (i) melhoria populacional por seleção genômica recorrente rápida e (ii) desenvolvimento de produto com desenho tradicional.

Resultados (programa 2Part+H):

| Comparação | Variância G×Y = 10 | Variância G×Y = 0 |
|---|---|---|
| vs. programa convencional | **2,36×** (IC95% 2,08–2,67) | **2,47×** (IC95% 2,36–2,59) |
| vs. melhor GS padrão (Head GS) | **1,31×** (IC95% 1,20–1,43) | **1,46×** (IC95% 1,36–1,57) |

O intervalo de confiança mais largo aparece no cenário com mais G×Y: mais interação ambiental, mais incerteza sobre o benefício. Para o Brasil tropical, use o número conservador.

Extensão com OCS (Gorjanc et al., bioRxiv 10.1101/227215): seleção de cruzamentos ótimos aumenta o ganho de longo prazo em programas de duas partes com 1 a 6 ciclos/ano, por reduzir perda de diversidade e queda de acurácia. A magnitude exata reportada no resumo ("78%…") **[VERIFICAR]** na versão publicada.

### 2.2 Ganho realizado (não simulado) com ciclo rápido

Zhang et al. (2017), *G3* 7(7):2315, DOI 10.1534/g3.117.043141. Milho tropical multiparental no CIMMYT: 18 linhagens elite, 1.000 famílias C0, **955.690 SNPs GBS**, dois ciclos por ano. Ganho **realizado** de C1 a C4: **0,225 t ha⁻¹ por ciclo = 0,100 t ha⁻¹ ano⁻¹** ao longo de 4,5 anos, com estreitamento apenas discreto da diversidade.

É o número a citar quando perguntarem "mas isso funciona fora do computador?".

### 2.3 Otimização do esquema: três abordagens, três veredictos

**(a) Regressão kernel**: Hassanpour et al. (2023), *G3* jkad217. Busca aleatória ampla, suavização por kernel, estreitamento iterativo da região promissora. Aplicado a bovinos de leite (ganho genético + diversidade sob orçamento). Limitação declarada: exige **mais de 100.000 simulações** e estreitamento manual por inspeção visual.

**(b) Algoritmo evolucionário**: Hassanpour et al. (2024), *G3* jkae248. Mantém o kernel para suavização local e usa AE para gerar novas parametrizações; suporta variáveis contínuas e de classe; orquestrado em Snakemake/SLURM. Resultado verificado: o cenário 1 atingiu resultado equivalente com **2.400 simulações contra >100.000**, redução de **mais de 40×**. Custo em nuvem calculado pelos autores: 0,55 centavo de euro por simulação; 40 iterações com 12.300 simulações = **€67,65**. Cada simulação: ~15 min em um núcleo, 5 GB de RAM.

> €67,65 é pedagogicamente poderoso: otimizar formalmente o desenho de um programa custa menos que um jantar. O gargalo nunca foi computacional; é organizacional.

**(c) Otimização bayesiana**: Jannink et al., *Crop Science*, DOI 10.1002/csc2.21124 (preprint agriRxiv 10.31220/agrirxiv.2023.00188). BoTorch sobre AlphaSimR para alocar orçamento entre o PIC (1 ou 2 ciclos/ano) e os três estágios do VDP de uma cultura clonal, com alvo de ganho no ano 6 ou 12. Achados que **contrariam o otimismo usual**:

- a superfície de resposta do ganho é **plana perto do ótimo**, e o ruído estocástico pode superar a inclinação;
- alocações bastante divergentes produzem ganho próximo do máximo: há folga no desenho;
- **não emergiram regras de bolso**; cada programa precisará rodar sua própria simulação acoplada a otimização;
- alocação ao último estágio do VDP foi pequena, porque aquele estágio pouco melhora a acurácia da predição genômica usada no PIC.

Tanaka & Iwata (2022), *Frontiers in Plant Science* 13:1050198, registram que a otimização bayesiana degrada em espaços de alta dimensão e com parâmetros categóricos.

### 2.4 Aprendizado por reforço e look-ahead

Moeinizade et al. (2019), *G3*, DOI 10.1534/g3.118.200842, definem a **look-ahead selection (LAS)**: o objetivo é o GEBV esperado do melhor descendente na geração terminal, incorporando frequências de recombinação e o prazo T−t. Dados: 369 linhagens endogâmicas de milho, 1.406.757 SNPs. Nas simulações, LAS superou os métodos publicados comparados (CGS, OHV, OPV).

Moeinizade et al. (2022), *Intelligent Systems with Applications*, DOI 10.1016/j.iswa.2022.200076, embrulham o LAS em um MDP com programa linear inteiro para conter o espaço de estados, aproximação da função valor e melhoria gulosa de política, para decidir **quanto orçamento gastar em cada geração**: gastar cedo, antes de perder diversidade, ou distribuir?

Cuidado terminológico: **não é multi-armed bandit**; é RL baseado em valor para alocação sequencial de recursos.

### 2.5 BPAT e Excellence in Breeding

O **Breeding Program Assessment Tool**, em uso desde 2015 e hoje na Fase III (University of Queensland), é o oposto metodológico de tudo acima: **avaliação estruturada por pares humanos**. Questionário (96 questões na versão de 2015), visita de especialistas, scorecard, relatório e plano de melhoria (template EiB com ações, responsáveis, custos e retorno). Avaliou 11 componentes nas rodadas do CGIAR.

O BPAT usa **métricas de processo preditivas do ganho genético**, comuns no setor privado e capturáveis no curto prazo: tamanho do programa (cruzamentos, parcelas, ensaios), **tempo de ciclo**, **qualidade da medição (CV% dos ensaios)**, qualidade da gestão de dados e desempenho contra testemunhas. Motivo: adoção de cultivares e bem-estar só são mensuráveis ~10 anos após o investimento. O manual EiB trata o próprio ganho genético (tendência genética por regressão do valor genético médio no ano/ciclo) como KPI de alto nível, condicionado à conectividade dos ensaios.

---

## 3. Modelos de cultura + genética: G×E×M e enviromics

### 3.1 CGM-WGP

A ideia: em vez de predizer produtividade diretamente dos marcadores, **predizer parâmetros fisiológicos** a partir dos marcadores e deixar o modelo de cultura integrá-los ao longo do tempo, com o clima real.

**Prova de conceito**: Technow, Messina, Cooper et al. (2016), *Crop Science*, DOI 10.2135/cropsci2015.08.0512. Acurácia positiva para produtividade de híbridos (amostra de duplo-haploides de um cruzamento) em dois ambientes de seca, incorporando variação genética para **cinco traits componentes** escolhidos *a priori*, via computação bayesiana aproximada (ABC).

**Escala empírica grande**: Messina et al. (2022), *Plant Physiology* (PMC8825268). Meio-dialelo de 9 endogâmicas elite → 35 famílias, **2.367 híbridos**, **17 locais no corn belt dos EUA + 6 ambientes de estresse manejado**, 2017–2019, evapotranspiração de **377 a 760 mm**, médias de família de 542 a 1.874 g m⁻².

| Cenário | CGM-WGP | WGP (BayesA) |
|---|---|---|
| Genótipos e ambientes **não testados** | **r = 0,43** | r = 0,27 |
| Ambientes testados, genótipos novos, com G×E | 0,61 → 0,58 | 0,62 → 0,42 |

Sob G×E, o CGM-WGP **mantém** a acurácia enquanto o WGP desaba. A explicação está nas correlações genéticas: rG entre irrigado e TPE = 0,68; rG entre déficit hídrico e TPE = **0,0003**. O algoritmo de seleção de traits identificou 4 de 12 traits candidatos conhecidos.

**Duas décadas**: Cooper et al. (2023), *Journal of Experimental Botany*, DOI 10.1093/jxb/erad231. Ganho sob seca subiu de **6,2 para 7,5 g m⁻² ano⁻¹**, aproximando-se dos **8,6 g m⁻² ano⁻¹** sob água suficiente. Diferencial de acurácia do CGM sobre abordagens correntes: **Δr = 0,11 sobre r = 0,38 (~30%)**, crescente com a complexidade do sistema trait-ambiente (medida por entropia de Shannon).

### 3.2 Modelos de cultura disponíveis

- **APSIM Next Generation**: Holzworth et al. (2018), *Environmental Modelling & Software* 103:43–51, DOI 10.1016/j.envsoft.2018.02.002 (APSIM original: Holzworth et al. 2014, EM&S 62:327–350).
- **DSSAT**: modelos dinâmicos para **mais de 45 culturas**, usado há mais de 30 anos em mais de 198 países (dssat.net).

### 3.3 Enviromics: o lado brasileiro

**Resende et al.**, *Theoretical and Applied Genetics*, DOI 10.1007/s00122-020-03684-z (online em 22/09/2020; volume 134 de 2021). Introduz o termo **enviromics** e a seleção assistida por envirótipos: assim como um genótipo é caracterizado por marcadores de DNA, um local é caracterizado por envirótipos em "marcadores enviromicos". Propõe o índice GIS-GEI para (1) casar locais com genótipos, (2) definir áreas de melhoramento com alta correlação genética e (3) escolher onde instalar ensaios.

**Costa-Neto, Galli, Carvalho, Crossa & Fritsche-Neto (2021)**, `EnvRtype`, *G3* 11(4):jkab040. Pipeline em R em três módulos: coleta remota (NASA POWER; `get_weather`, `extract_GIS`, `processWTH`), caracterização (`env_typing`, `W_matrix`) e kernels enviromicos (`get_kernel`, `kernel_model`) para GBLUP com normas de reação.

**Costa-Neto, Crossa & Fritsche-Neto (2021)**, *Frontiers in Plant Science* 12:717552. E-GP em dois conjuntos de milho tropical, duas montagens enviromicas, seis tamanhos de rede experimental. Ao predizer a resposta individual de genótipos ao longo dos METs, a mediana de r foi **0,17 para GBLUP** (45% dos genótipos mal preditos) contra **0,83 para E-GP** (até 60% muito bem preditos), com ganhos de até ~378%. Conclusão operacional: **a representatividade das combinações genótipo-ambiente importa mais que o tamanho do MET**, o que permite desenhar *in silico* quais combinações precisam ir a campo.

**Satellite-enabled enviromics** (Xu et al. 2024, *Molecular Plant*): agrega dados ópticos, térmicos, radar e LiDAR; aponta como gargalos métodos integrativos de coleta, modelos de IA, ciberinfraestrutura e compartilhamento de dados.

**Embrapa**: revisão institucional (Alice/Embrapa, doc 1169666) contabiliza 6 ICTs com fenotipagem em 2008 e 43 instituições em 2023, sendo 15 privadas. APIs públicas relevantes para envirotipagem: AgroAPI, ClimAPI e SATVeg (NDVI/EVI para a América do Sul).

Este é o "gêmeo digital de um ensaio" na prática: não um avatar 3D, mas um kernel que torna um ambiente ainda não observado predizível.

---

## 4. Tempo real e automação

### 4.1 DT-FieldPheno (verificado, com correção)

Liu et al. (2025), *Agriculture* 15(11):1217, DOI 10.3390/agriculture15111217, Beijing Academy of Agriculture and Forestry Sciences. **Plataforma sobre trilhos, não VANT.**

Arquitetura de laço fechado: conexão → computação → predição → decisão → execução. Modelo de risco meteorológico em dupla camada (AHP + avaliação fuzzy), combinando previsão e dados meteorológicos em tempo real para agendar a aquisição.

Resultados em 27 dias consecutivos em campo de milho:
- redução de **50%** na carga de inspeção manual;
- **2 tarefas de alto risco canceladas** por excesso de velocidade do vento e **2 otimizadas** por rajadas e chuva;
- alerta de transposição de trilho em **1,8 ± 0,2 s**; detecção de falha de comunicação com heartbeat de **5 s**.

É o exemplo público mais próximo de um **autonomous digital twin** (Verdouw) em fenotipagem, mas o gêmeo controla o *equipamento*, não a *decisão de melhoramento*.

### 4.2 Virtual Breeding Nursery

Tieben et al. (2024), ACM Symposium on Spatial User Interaction, DOI 10.1145/3677386.3688876, projeto **PORTAL** (DFKI + NPZ Innovation, 02/2021–04/2024). Robô autônomo com base móvel autossuficiente (solar e eólica), uplink 5G com pré-processamento. Captura imagens de alta resolução georreferenciadas, varreduras laser 3D e dados multiespectrais; o melhorista avalia os gêmeos 3D em VR, compara candidatos lado a lado entre locais e acompanha o desenvolvimento, com vistas em falsa cor UV/NIR/IR.

Na taxonomia de Verdouw é um **monitoring + recollection twin**: o valor principal é poder revisitar em dezembro a parcela de junho.

### 4.3 Edge AI e IoT

Projeto **FACT-AI / DSFAS** (Clemson, USDA-NIFA 1030625, 2020–2024): sensores estáticos e robôs terrestres (RGB, térmico, espectral, 3D); processamento, redução e analítica em tempo real **nas fogs** para transferir só o dado útil; detecção single-stage para contagem de flores de algodão e classificação de estresse hídrico. Modelo de dados em quatro camadas: usuário, experimento, parcela/campo, sensor. Observação: o projeto não se descreve como gêmeo digital.

Projeto DSFAS seguinte (Hershberger, Clemson, SC-2023-11724, com Rife, Mueller, Jannink e Selby): modelos de dados e **endpoints BrAPI para fenótipos de alta dimensão** (espectral, metabolômica, transcriptômica, proteômica, microbioma).

### 4.4 Automação de laboratório e rastreamento

- **Seed chipping** automatizado (Bayer): ver §5.
- **Rastreamento de amostras**: o EBS integra solicitação de análises fitossanitárias, genotípicas e de qualidade com status por provedor de serviço; o Breedbase rastreia material, ensaios e genótipos no mesmo banco.
- **Laboratórios autônomos (self-driving labs)** aplicados especificamente a melhoramento vegetal: não localizei caso publicado verificável nesta rodada **[VERIFICAR]**.

### 4.5 Padrões de dados: a camada sem glamour que decide tudo

| Padrão | O que é | Referência |
|---|---|---|
| **BrAPI** | API REST para germoplasma, ensaios, fenotipagem, genotipagem; compatível com MCPD, MIAPPE, GA4GH Variants, GeoJSON e Crop Ontology | brapi.org |
| **MIAPPE 1.1** | metadados mínimos de experimento de fenotipagem; passou de checklist a **modelo de dados formal**, cobrindo perenes | Papoutsoglou et al. 2020, *New Phytologist*, DOI 10.1111/nph.16544 |
| **Breedbase** | banco web open-source (Postgres/Chado; genótipos em JSONb no modelo VCF), GS e GWAS integrados; nasceu como Cassavabase | Morales et al. 2022, *G3* 12(7):jkac078 |
| **EBS** | sistema de gestão de dados preferencial do CGIAR (EiB + Breeding Resources), integrado a Field Book e QBMS via BrAPI | ebsproject.org |
| **Crop Ontology** | vocabulários de traits por cultura, referenciados por BrAPI e MIAPPE | cropontology.org |

**Sem BrAPI e MIAPPE não existe digital shadow, muito menos gêmeo.** A automação do fluxo físico→virtual *é* a fronteira de Kritzinger. MIAPPE cobre bem findability, interoperability e reusability; accessibility depende de implementações como BrAPI.

---

## 5. Exemplos da indústria

Todos os números abaixo vêm de **comunicação corporativa** (investidores, páginas de produto, imprensa setorial), não de publicações revisadas por pares.

### Corteva / Pioneer

| Métrica | Valor | Fonte |
|---|---|---|
| Marcadores genotipados por ano | **1 bilhão** | conferência com investidores (Wolfe Research, 2026) |
| Parcelas de produtividade por ano | **15 milhões** | idem |
| Imagens de drone no último ano | **80–100 milhões** | Geoff Graham, Seed World, 12/2025 |
| Coleta de imagens de drone desde | **2012** | idem |
| Ganho de acurácia no pipeline inicial | "4–5×" — métrica e comparador não especificados **[VERIFICAR]** | idem |
| Pontos de dados | **>10 bilhões** | Investor Day 2026 |
| Dados de sequência genômica | **>400 milhões de pontos; >5 Pb** | Investor Day 2026 |
| Cientistas de P&D / instalações | ~5.000 / >120; 50 acres de estufa | Corteva, "Does Bigger Really Mean Better?" |

**Patente WO/2025/080804**, "Digital Twin of End-to-End Crop Breeding Pipelines": requerente **Pioneer Hi-Bred International Inc.**, inventor Andrew Paul Beatty, PCT/US2024/050729, depositada em 10/10/2024, publicada em 17/04/2025. O escopo inclui genótipo, fenótipo, solo, ambiente, irrigação, fertilização e preparo do solo, plantas editadas e transgênicas, e gera **ações de melhoramento** (cruzamentos, testes de híbridos e variedades, seleção) até instruções a um dispositivo de plantio. O parágrafo [0014] especifica RL: maximização da recompensa total em um MDP no qual políticas de seleção executadas por agentes automatizados dentro do gêmeo são avaliadas e as que melhoram o ganho genético são recompensadas. É literalmente a §2.4 deste dossiê, patenteada.

### Bayer

- **Seed chipping automatizado**: gera **10–15 milhões de pontos de dados por semente**, permitindo triagem de DNA sem cultivo em campo (página DEKALB). Citação institucional: "One DNA chip can actually be as representative as an early stage field trial."
- **Marana, AZ**: ~7 acres de estufa automatizada, 3–4 ciclos de milho por ano.
- **Tempo de ciclo**: a página DEKALB afirma redução de "5 anos para 5 meses"; o CS Innovation Summit 2023 afirma "de 5–6 anos para ~4 meses". **[VERIFICAR]**: duas cifras corporativas discordantes; o que exatamente está sendo medido não é especificado.
- O material de 2023 lista "**Digital Field Testing Twin**" ("mix of simulated and actual field testing") como vantagem competitiva e a meta "**Doubling Genetic Gain by 2030**" **[VERIFICAR]**.
- **Preceon Smart Corn System**: híbridos de porte baixo (colmos de ~7 pés em média) + FieldView + suporte agronômico; descrito pela própria Bayer como em fase de teste.
- Patentes Monsanto Technology LLC relacionadas a pipeline: US 11,576,316 B2 (alocação de recursos entre origens no pipeline) e US 2025/0031630 (conversão de limiares entre estágios).

### Não verificados

Syngenta (digital breeding), **Inari** e **Benson Hill**: não localizei números primários auditáveis **[VERIFICAR]**. Não apresentar cifras dessas empresas.

---

## 6. Arquitetura em quatro camadas

```
┌─ CAMADA FÍSICA ─────────────────────────────────────────────┐
│ Nurseries, METs, estufas (Marana), laboratório de seed      │
│ chipping, robôs terrestres (PORTAL), trilhos (DT-FieldPheno)│
│ VANTs, estações meteorológicas, sensores de solo            │
└──────────────────────┬──────────────────────────────────────┘
                       │ ← corte DM/DS de Kritzinger (ingestão automática?)
┌─ CAMADA DE DADOS ────▼──────────────────────────────────────┐
│ Ingestão: BrAPI | Metadados: MIAPPE 1.1 | Ontologia: Crop   │
│ Ontology | Persistência: Breedbase/EBS | Edge/fog: reduzir  │
│ antes de transmitir (FACT-AI) | QC: o DuckDB da Sessão 04   │
└──────────────────────┬──────────────────────────────────────┘
┌─ CAMADA DE MODELOS ──▼──────────────────────────────────────┐
│ Genético: GBLUP, ssGBLUP, normas de reação                  │
│ Ambiental: EnvRtype, kernels enviromicos, NASA POWER        │
│ Fisiológico: APSIM/DSSAT, CGM-WGP                           │
│ De programa: AlphaSimR / MoBPS / ChromaX                    │
└──────────────────────┬──────────────────────────────────────┘
┌─ CAMADA DE DECISÃO ──▼──────────────────────────────────────┐
│ OCS (Sessão 09) | look-ahead selection | RL/MDP             │
│ Otimização de esquema: AE, kernel, BO                       │
│ Governança: BPAT, KPIs de processo | HUMANO NO CIRCUITO     │
└──────────────────────┬──────────────────────────────────────┘
                       │ ← corte DS/DT (atuação automática?)
                       ▼ plantio prescrito, cancelamento de coleta,
                         reagendamento de ensaio
```

A seta de retorno é o que praticamente ninguém fechou. O DT-FieldPheno a fecha para o *equipamento*; a patente da Pioneer a reivindica para a *decisão de cruzamento*.

---

## 7. Decisão: tempo real, lote sazonal e valor da informação

A equação do ganho genético estrutura tudo:

ΔG = i · r · σA / L

Araus et al. (2018), *Trends in Plant Science*, DOI 10.1016/j.tplants.2018.02.001, enquadram HTP aí: fenotipagem contribui via **i** (populações maiores pelo mesmo orçamento), via **r** (medição menos subjetiva) e pela identificação de nova variação. Número concreto: altura de planta em arroz a **45 parcelas/hora manualmente** contra **3.000 parcelas/hora** com phenomobile e sensor ultrassônico (fator ~67×).

### O que precisa de tempo real e o que não precisa

| Decisão | Latência útil | Por quê |
|---|---|---|
| Cancelar voo/coleta por vento | **minutos** | a janela fecha (DT-FieldPheno) |
| Irrigar ensaio de estresse manejado | **horas–dias** | o tratamento *é* o experimento; errar invalida o rG com o TPE |
| Detectar falha de estande / parcela perdida | **dias** | permite replantio ou exclusão correta no modelo |
| Avanço de geração / descarte | **sazonal** | precisa do ensaio completo |
| Escolha de cruzamentos (OCS) | **sazonal** | depende de GEBVs consolidados |
| Redesenho do esquema | **anual ou mais** | superfície plana (Jannink et al.) |

Regra: **tempo real tem valor onde a janela de ação é curta e a perda é irreversível.** No resto, é custo sem retorno.

### Valor da informação (VoI)

O achado de Jannink et al. (superfície plana perto do ótimo, ruído comparável à inclinação) é uma afirmação de VoI: **o valor marginal de refinar a alocação orçamentária perto do ótimo é baixo**. Compare com Costa-Neto et al. (0,17 → 0,83), onde o valor marginal da informação ambiental é alto. Investir onde o gradiente é íngreme.

Do lado dos custos, o modelo econômico de adoção de fenotipagem automatizada (*Euphytica*, DOI 10.1007/s10681-018-2226-z) inclui ganho esperado, custos variáveis e afundados, taxa de melhoria da tecnologia e **aversão do melhorista à tecnologia** como parâmetro. Araus et al. notam que custo de equipamento e treinamento pode ser a barreira dominante, especialmente em países de renda baixa e média, com transporte caro e salário relativo baixo: **o cálculo que favorece HTP nos EUA não se transfere automaticamente ao Brasil tropical**.

> Cifras de €/ha para voos de VANT (p. ex., €13,1/ha por voo vs. €180–240/ha de scouting) circulam em periódico de qualidade duvidosa **[VERIFICAR]**. Não usar em aula.

### Humano no circuito

- No tipo *prescriptive* de Verdouw, a decisão é humana por definição.
- A superfície plana de Jannink et al. dá folga para acomodar restrições práticas (mão de obra, infraestrutura, política institucional) sem perda relevante de ganho.
- Em RL (Moeinizade; patente Pioneer), a política aprendida precisa de auditoria: quem responde quando ela erra?

---

## 8. Limitações

1. **Descasamento de modelo.** O CGM-WGP funcionou porque cinco traits componentes foram escolhidos *a priori* com base em fisiologia. Um modelo calibrado no corn belt não descreve Viçosa.
2. **rG ≈ 0 é invisível para o GBLUP.** Com rG(déficit hídrico, TPE) = 0,0003, selecionar no ambiente errado gera progresso nulo no alvo, e o modelo não avisa.
3. **Superajuste ao simulador.** Otimizar contra AlphaSimR é otimizar contra as suposições informadas (arquitetura genética, mapa, variâncias). Hassanpour et al. relatam que resultados de BO variam com pequenas mudanças nos genótipos de entrada; Tanaka & Iwata alertam que resultados simulados podem não transferir se as suposições estiverem mal especificadas.
4. **Latência e qualidade.** Edge/fog (FACT-AI) embute decisão irreversível sobre o que nunca será armazenado.
5. **Custo de integração e interoperabilidade.** O EBS existe porque o CGIAR tinha muitos sistemas desconectados; Morales et al. afirmam que bancos de melhoramento são "complexos, difíceis e caros de implementar e manter".
6. **Garbage in, garbage out.** Geoff Graham (Corteva): "if you have error in your system, you're making bad decisions". Milhões de imagens não compensam um mapa de parcelas errado.
7. **Validação prospectiva ausente.** Revisões recentes (p. ex., *Front. Plant Sci.* 2026, 10.3389/fpls.2026.1929693) convergem: a maioria das aplicações foi avaliada em dados históricos, simulações ou pontos de decisão isolados, não em ciclos completos de melhoramento. Tratar benefícios como hipóteses até validação prospectiva contra o controle convencional.
8. **Dependência de fornecedor.** Gêmeos patenteados e plataformas proprietárias criam travamento; o contraponto são Breedbase, EBS, BrAPI e MIAPPE.
9. **Memória em GPU.** ChromaX troca tempo por memória; problemas grandes podem não caber.

---

## 9. Perguntas de discussão

1. Classifique, pela taxonomia de Kritzinger, o pipeline das Sessões 04 e 09. O que faltaria, exatamente, para subir um nível?
2. Gaynor et al. obtiveram 2,36× sob custo constante. Que suposição do artigo é mais frágil para um programa público brasileiro de feijão ou café?
3. ChromaX é ~500× mais rápido em GPU, mas usa muito mais memória. Em que regime isso é irrelevante? Em qual é fatal?
4. Jannink et al. não encontraram regras de bolso e a superfície é plana. Isso é argumento **a favor** ou **contra** investir em otimização de esquema?
5. rG(WD, TPE) = 0,0003. Como detectar isso no seu programa com os modelos de `lme4` da Sessão 02?
6. O E-GP levou a mediana de r de 0,17 para 0,83. Quanto atribuir ao kernel ambiental e quanto ao desenho otimizado do MET? Como separar?
7. A patente da Pioneer reivindica agentes de RL decidindo seleção. Qual a responsabilidade do melhorista quando a política erra?
8. O DT-FieldPheno reduziu inspeção manual em 50%. Que informação tácita se perde quando o melhorista deixa de caminhar nas parcelas?
9. Bayer afirma "5 anos → 5 meses"; outro documento diz "5–6 anos → ~4 meses". Como verificar qualquer uma das duas?
10. Desenhe um BPAT para um programa da UFV: quais métricas de processo (ciclo, CV%, gestão de dados) são as mais limitantes aqui?

**Ligações com o curso**
- **Sessão 03 (HTP)** → §4 e §7: conversão explícita de throughput em i e r.
- **Sessão 04 (dados)** → §4.5: BrAPI/MIAPPE são a versão institucional do QC feito em DuckDB.
- **Sessão 09 (simulação/OCS)** → §2: AlphaSimR é a camada de modelos; OCS e LAS são a camada de decisão.
- **Sessão 10 (decisão)** → §7: valor da informação, latência e humano no circuito.

---

## 10. Referências verificadas

**Gêmeos digitais**
- Kritzinger W., Karner M., Traar G., Henjes J., Sihn W. (2018). Digital Twin in manufacturing: a categorical literature review and classification. *IFAC-PapersOnLine* 51(11):1016–1022. DOI 10.1016/j.ifacol.2018.08.474
- Verdouw C., Tekinerdogan B., Beulens A., Wolfert S. (2021). Digital twins in smart farming. *Agricultural Systems* 189:103046. DOI 10.1016/j.agsy.2020.103046
- Ganapathysubramanian B., Sarkar S., Singh A., Singh A.K. (2025). Digital twins for the plant sciences. *Trends in Plant Science* 30(5):576–577. DOI 10.1016/j.tplants.2024.12.013
- Liu H. et al. (2025). Research on intelligent control technology for a rail-based high-throughput crop phenotypic platform based on digital twins. *Agriculture* 15(11):1217. DOI 10.3390/agriculture15111217
- Tieben C. et al. (2024). Virtual Breeding Nursery: towards a VR digital twin for plant breeding. ACM SUI. DOI 10.1145/3677386.3688876
- DFKI. Projeto PORTAL. https://www.dfki.de/en/web/research/projects-and-publications/project/portal
- (2024). Digital evolution and twin miracle of sugarcane breeding. *Field Crops Research*. DOI 10.1016/j.fcr.2024.109588
- Sarkar S. et al. Cyber-agricultural systems for crop breeding and sustainable production. https://par.nsf.gov/servlets/purl/10496373
- WO/2025/080804. Digital twin of end-to-end crop breeding pipelines. Pioneer Hi-Bred International Inc. https://patentscope.wipo.int/search/en/WO2025080804 ; https://patents.google.com/patent/WO2025080804A1/en

**Simulação e otimização**
- Gaynor R.C. et al. (2017). A two-part strategy for using genomic selection to develop inbred lines. *Crop Science*. DOI 10.2135/cropsci2016.09.0742
- Gorjanc G. et al. Optimal cross selection for long-term genetic gain in two-part programs with rapid recurrent genomic selection. bioRxiv. DOI 10.1101/227215
- Gaynor R.C., Gorjanc G., Hickey J.M. (2021). AlphaSimR. *G3* 11(2):jkaa017. DOI 10.1093/g3journal/jkaa017
- Bančič J., Greenspoon P., Gaynor R.C., Gorjanc G. (2025). Plant breeding simulations with AlphaSimR. *Crop Science* 65:e21312. DOI 10.1002/csc2.21312
- Pook T., Schlather M., Simianer H. (2020). MoBPS. *G3* 10(6):1915–1918. DOI 10.1534/g3.120.401193
- Pook T. et al. (2021). MoBPSweb. *G3* 11(2):jkab023. DOI 10.1093/g3journal/jkab023
- Younis O.G. et al. (2024). ChromaX: a fast and scalable breeding program simulator. *Bioinformatics*. DOI 10.1093/bioinformatics/btad691
- Zhang X. et al. (2017). Rapid cycling genomic selection in a multiparental tropical maize population. *G3* 7(7):2315. DOI 10.1534/g3.117.043141
- Hassanpour A., Geibel J., Simianer H., Pook T. (2023). Optimization of breeding program design through stochastic simulation with kernel regression. *G3*. DOI 10.1093/g3journal/jkad217
- Hassanpour A. et al. (2024). … with evolutionary algorithms. *G3*. DOI 10.1093/g3journal/jkae248
- Jannink J.-L. et al. Insight into a two-part plant breeding scheme through Bayesian optimization of budget allocations. *Crop Science*. DOI 10.1002/csc2.21124
- Tanaka R., Iwata H. (2022). Bayesian optimisation for breeding schemes. *Front. Plant Sci.* 13:1050198. DOI 10.3389/fpls.2022.1050198
- Moeinizade S., Hu G., Wang L., Schnable P.S. (2019). Optimizing selection and mating in genomic selection with a look-ahead approach. *G3*. DOI 10.1534/g3.118.200842
- Moeinizade S., Hu G., Wang L. (2022). A reinforcement learning approach to resource allocation in genomic selection. *Intelligent Systems with Applications*. DOI 10.1016/j.iswa.2022.200076

**Modelos de cultura e enviromics**
- Technow F., Messina C.D., Totir L.R., Cooper M. (2016). Use of crop growth models with whole-genome prediction. *Crop Science*. DOI 10.2135/cropsci2015.08.0512
- Messina C.D. et al. (2022). Can we harness digital technologies and physiology to hasten genetic gain in US maize breeding? *Plant Physiology*. https://pmc.ncbi.nlm.nih.gov/articles/PMC8825268/
- Cooper M. et al. (2023). Two decades of harnessing standing genetic variation for physiological traits to improve drought tolerance in maize. *J. Exp. Bot.* DOI 10.1093/jxb/erad231
- Holzworth D. et al. (2018). APSIM Next Generation. *Env. Modelling & Software* 103:43–51. DOI 10.1016/j.envsoft.2018.02.002
- Holzworth D.P. et al. (2014). APSIM – evolution towards a new generation. *Env. Modelling & Software* 62:327–350. DOI 10.1016/j.envsoft.2014.07.009
- DSSAT. https://dssat.net/
- Resende R.T. et al. (2021). Enviromics in breeding: applications and perspectives on envirotypic-assisted selection. *Theor. Appl. Genet.* DOI 10.1007/s00122-020-03684-z
- Costa-Neto G., Galli G., Carvalho H.F., Crossa J., Fritsche-Neto R. (2021). EnvRtype. *G3* 11(4):jkab040. DOI 10.1093/g3journal/jkab040
- Costa-Neto G., Crossa J., Fritsche-Neto R. (2021). Enviromic assembly increases accuracy and reduces costs of the genomic prediction for yield plasticity in maize. *Front. Plant Sci.* 12:717552. DOI 10.3389/fpls.2021.717552
- Xu Y. et al. (2024). Satellite-enabled enviromics to enhance crop improvement. *Molecular Plant*. https://www.cell.com/molecular-plant/fulltext/S1674-2052(24)00118-7
- Embrapa (Alice, doc 1169666). Fenotipagem de plantas de alto rendimento… http://alice.cnptia.embrapa.br/alice/handle/doc/1169666

**Dados, fenotipagem e avaliação**
- Papoutsoglou E.A. et al. (2020). Enabling reusability of plant phenomic datasets with MIAPPE 1.1. *New Phytologist*. DOI 10.1111/nph.16544
- Morales N. et al. (2022). Breedbase: a digital ecosystem for modern plant breeding. *G3* 12(7):jkac078. DOI 10.1093/g3journal/jkac078
- BrAPI. https://brapi.org/ · EBS. https://ebsproject.org/ · QBMS (CRAN). https://cran.r-project.org/web/packages/QBMS/
- Araus J.L., Kefauver S.C., Zaman-Allah M., Olsen M.S., Cairns J.E. (2018). Translating high-throughput phenotyping into genetic gain. *Trends in Plant Science*. DOI 10.1016/j.tplants.2018.02.001
- The adoption of automated phenotyping by plant breeders (2018). *Euphytica*. DOI 10.1007/s10681-018-2226-z
- USDA-NIFA 1030625 (FACT-AI, Clemson). https://portal.nifa.usda.gov/web/crisprojectpages/1030625
- Hershberger Lab, DSFAS SC-2023-11724. https://hershlab.org/2024/09/01/DSFAS-HDP.html
- BPAT (UQ). https://agriculture-food-sustainability.uq.edu.au/research/research-centres-and-groups/breeding-program-assessment-tool
- EiB. Genetic gain as a high-level KPI. https://excellenceinbreeding.org/sites/default/files/manual/EiB-M2_Breeding%20process%20assessment-Genetic%20Gain_04-05-20_0.pdf

**Indústria (comunicação corporativa)**
- Corteva, transcrição Wolfe Research 2026. https://stockanalysis.com/stocks/ctva/transcripts/690078-wolfe-research-3rd-annual-materials-of-the-future-conference-2026/
- Seed World (12/2025). https://www.seedworld.com/us/2025/12/04/in-the-race-to-reinvent-seed-the-future-is-within-reach/
- Corteva Investor Day 2026. https://investors.corteva.com/static-files/32d22616-ba39-4474-ba6f-67797e32e319
- Corteva. Does bigger really mean better? (2025)
- Bayer DEKALB. https://www.cropscience.bayer.us/brands/dekalb/why-dekalb
- Bayer. Designer Seeds, CS Innovation Summit 2023. https://www.bayer.com/sites/default/files/2023-06/Designer%20Seeds_CS%20Innovation%20Summit%202023.pdf
- Bayer. Building the corn hybrid of the future. https://www.bayer.com/en/us/building-the-corn-hybrid-of-the-future
- Bayer. Preceon Smart Corn System. https://www.cropscience.bayer.us/traits/corn/preceon-smart-corn-system
