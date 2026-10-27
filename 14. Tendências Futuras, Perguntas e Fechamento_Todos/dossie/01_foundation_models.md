# Bloco 1 — Foundation models além do chatbot: aplicações no melhoramento de plantas

*Dossiê de apoio — Sessão 11, curso "IA no Melhoramento de Plantas" (UFV, nov/2026)*
*Público: melhoristas e geneticistas que já viram GBLUP, RR-BLUP, random forest, OCS, AlphaSimR e LLMs via Claude Code.*

> **Nota metodológica:** os números foram conferidos nas fontes primárias (artigos em Nature, Science, PNAS e Cell, pré-prints no bioRxiv e cartões de modelo no Hugging Face). Onde não foi possível confirmar um número diretamente na fonte, ele está marcado com **[VERIFICAR]**.

**Âncoras no curso:** Sessão 02 (conceitos, modelos, hardware), Sessão 03 (fenotipagem de alto desempenho), Sessão 06 (seleção genômica, validação e vazamento), Sessão 07 (ML/DL) e Sessão 08 (IA generativa e LLMs).

---

## 1. Como funcionam os modelos de linguagem de DNA (gLMs)

Um *genomic language model* (gLM) é um modelo auto-supervisionado treinado em sequências de DNA brutas, sem rótulos. A ideia é a mesma de um LLM de texto: aprender a "gramática" estatística do genoma a partir de bilhões de nucleotídeos e gerar representações (*embeddings*) reutilizáveis.

- **Tokenização**: como a sequência vira "palavras".
  - *Nucleotídeo único* (resolução de 1 bp): GPN, PlantCaduceus, Evo e Evo 2. Dá a máxima resolução para efeito de variante; o contexto em bp é igual ao número de tokens.
  - *k-mer* (por exemplo, 6-mers): AgroNT e Nucleotide Transformer usam 6-mers não sobrepostos, o que gera 4.096 combinações mais tokens especiais (vocabulário de 4.105 no NT). A sequência fica comprimida 6×, mas o genoma é quebrado em segmentos arbitrários e a resolução de variantes de 1 bp piora.
  - *BPE (byte-pair encoding)*: comum em LLMs de texto e proteína, menos usado em DNA de plantas.
- **Objetivos de pré-treino**:
  - *Masked LM (MLM, estilo BERT)*: mascara cerca de 15% dos tokens e os prevê pelo contexto bidirecional (AgroNT, NT, GPN, PlantCaduceus). É o mais indicado para escorar variantes.
  - *Autorregressivo (próximo token, estilo GPT)*: prevê o próximo nucleotídeo e permite **gerar** sequências (Evo, Evo 2, PlantGFM).
- **Arquiteturas**:
  - *Transformer* (atenção, custo O(n²)): NT e AgroNT. Contexto limitado a cerca de 1.000 tokens, ou ~6 kb.
  - *Hyena / StripedHyena* (convoluções longas controladas pelos dados, escala quase linear): Evo (131 kb) e Evo 2 (1 Mb).
  - *State-space / Mamba / Caduceus*: o PlantCaduceus usa **Caduceus**, uma variante de Mamba feita para DNA, com **equivariância ao reverso-complemento (RC)** e contexto bidirecional. Isso importa porque o DNA é fita dupla.
- **Escore zero-shot de variantes (razão de log-verossimilhança, LLR)**: para cada variante, calcula-se a diferença de log-verossimilhança entre o alelo de referência e o alternativo no mesmo contexto. Quanto mais negativo o valor, mais conservado é o sítio e mais provável que a mutação seja deletéria. É o *zero-shot score* do GPN e do PlantCaduceus e o *LLR* do AgroNT. **Não exige dados de treino rotulados.**
- **Uso dos embeddings**:
  - *Probing / abordagem por features*: o modelo fica congelado e um classificador leve (regressão logística, XGBoost) é treinado sobre os embeddings. É barato e ajuda a diagnosticar a qualidade das representações.
  - *Fine-tuning*: ajusta todos os pesos ou parte deles para a tarefa. O AgroNT usa **IA3** (fine-tuning eficiente em parâmetros) com uma cabeça de classificação ou regressão.

---

## 2. Modelos específicos de plantas (com números)

- **GPN (Genomic Pre-trained Network)**: Benegas, Batra & Song, *PNAS* 2023. Arquitetura **convolucional** (cerca de 65 M de parâmetros segundo a tabela da revisão da Frontiers de 2025 **[VERIFICAR]**), pré-treinada em *Arabidopsis thaliana* e mais 7 espécies de Brassicales, sem alinhamento. Objetivo MLM. **Superou os escores de conservação phyloP e phastCons** na predição de efeito de variantes em Arabidopsis (validada com frequências do 1001 Genomes e com o catálogo de GWAS). Foi o **primeiro gLM de plantas**.
- **AgroNT (Agronomic Nucleotide Transformer)**: Mendoza-Revilla et al., *Communications Biology* 2024. Encoder Transformer de **1 bilhão de parâmetros** treinado em **48 espécies** de plantas, com predominância de culturas. Tokens 6-mer, entrada de ~6.000 bp, MLM a 15% e ~472,5 bilhões de tokens de treino em TPU v4. Fine-tuning com IA3. O trabalho propôs o **Plant Genomic Benchmark (PGB)**, com 8 tarefas.
  - AUROC de **0,94 a 0,98** em acessibilidade de cromatina (AUPRC de 0,51 a 0,67).
  - AUC de **0,88** na detecção de enhancers intergênicos em mandioca.
  - **Mutagênese in silico de mais de 10 milhões de mutações pontuais em mandioca** (*Manihot esculenta*, uma "orphan crop"), disponibilizada como recurso.
  - Resultado honesto: na priorização de variantes deletérias em Arabidopsis, **GPN e phyloP tiveram os maiores odds-ratios**. O LLR do AgroNT foi significativo, mas **não superou** phyloP nem GPN (superou levemente o phastCons).
- **PlantCaduceus / PlantCAD**: Zhai et al., *PNAS* 2025 (pré-print no bioRxiv em 2024). Caduceus/Mamba, **16 genomas de angiospermas** que cobrem ~160 milhões de anos de evolução, janela de **512 bp**, tokenização por nucleotídeo único e MLM, com *down-weighting* de sequências repetitivas. Série de modelos de **20 M a 225 M** de parâmetros.
  - Probing treinado só em Arabidopsis e transferido para milho (divergência de ~160 milhões de anos): **supera o melhor gLM existente em 1,45× a 7,23×**, sendo 7,23× no TIS e 3,75× no TTS em relação ao GPN.
  - Na transferência entre espécies, o PRAUC médio dos outros modelos caiu de 0,789 (Arabidopsis) para 0,237. O CNN+LSTM supervisionado caiu de 0,713 para quase zero no TIS em milho.
  - Deleteriedade: **3× melhor que o phyloP** (as mutações priorizadas têm MAF média três vezes menor) e competitivo com o pLM ESM para mutações missense.
  - Restrição evolutiva em milho (modelo ajustado em sorgo): AUC de **0,829** e PR-AUC de **0,797**, com apenas 20 M de parâmetros.
  - Recuperou a mutação causal W578R do loco *sugary1* (milho doce) em região de alta LD. Das 19 mutações causais de mutantes EMS de Arabidopsis, 15 ficaram no top 1% ou top 10% do escore.
  - O **PlantCAD2** amplia o contexto para **8.192 bp** (versões de 88 M, 311 M e 694 M de parâmetros).
- **PDLLMs**: Liu et al., *Molecular Plant* 2024. Conjunto de **DNA LLMs portáteis** (variantes Mamba, BERT, GPT, Gemma e NT) pré-treinados em **22 genomas de referência de 14 espécies**, com **198 modelos** ajustados para **9 tarefas**. Têm de 89 a 152 M de parâmetros e são **treináveis em uma única RTX 4090**. O *Plant DNAMamba* liderou 5 das 9 tarefas.
- **PlantRNA-FM**: Yu et al., *Nature Machine Intelligence* 2024. Modelo de **RNA** de 35 M de parâmetros, treinado com ~25 milhões de sequências de **1.124 espécies** de plantas. Alcançou F1 de **0,974** (Arabidopsis) e **0,958** (arroz) na anotação de regiões gênicas, superando o segundo melhor modelo em 0,339 e 0,293. Em eficiência de tradução, o F1 foi de 0,735 e 0,737.
- **Evo**: Nguyen et al., *Science* 2024. **7 B** de parâmetros, arquitetura StripedHyena, contexto de **131 kb** com tokenização por byte (1 bp), treinado em 2,7 milhões de genomas de procariotos e fagos (~300 bilhões de nucleotídeos). Gerou sistemas CRISPR-Cas e transposons com validação experimental.
- **Evo 2**: Brixi et al., *Nature* 2026 (Arc Institute). Versões de **7 B e 40 B** de parâmetros, **StripedHyena 2**, contexto de **1 milhão de pb** e o dataset **OpenGenome2**, com ~9,3 trilhões de tokens (mais de 8,8 trilhões de nucleotídeos) de todos os domínios da vida. Prediz efeitos de variantes (por exemplo, em BRCA1) **sem fine-tuning**. A análise de interpretabilidade mostrou que o modelo representa fronteiras éxon-íntron e sítios de ligação de fatores de transcrição. É totalmente aberto.
- **Nucleotide Transformer**: Dalla-Torre et al., *Nature Methods* 2024. Até **2,5 B** de parâmetros. A versão multiespécie foi treinada em **850 genomas**, e outras versões usaram 3.202 genomas humanos. Usa 6-mers, vocabulário de 4.105 e entradas de ~6 kb (1.000 tokens), com benchmark de 18 tarefas. É a base conceitual do AgroNT.
- **Outros modelos universais relevantes para plantas**:
  - **GENERator**: 1,2 B de parâmetros e 386 bilhões de nucleotídeos de eucariotos; desenho de sequências codificantes e de elementos regulatórios.
  - **PlantGFM**: *Advanced Science* 2026. Operador Hyena, contexto de 64 kb, 10,84 bilhões de nucleotídeos de 12 espécies. Gerou genes candidatos *de novo*, inclusive NLRs; os 7 candidatos testados mostraram atividade transcricional em *N. benthamiana*.

---

## 3. Uso no melhoramento: priorização de variantes e predição genômica

- **Carga deletéria, purga e alelos raros**: os gLMs escoram deleteriedade sem rótulos e enriquecem variantes raras (de baixa MAF). As mutações priorizadas pelo PlantCaduceus têm MAF média **3× menor** que as priorizadas pelo phyloP. Isso é útil para identificar e **purgar carga deletéria** e para estudar heterose.
- **Integração à predição genômica**: os resultados são mistos, o que é importante para a Sessão 06.
  - **Yang et al. (PLoS Genetics 2017; grupo de Ross-Ibarra, com Buckler entre os coautores)**: em um dialelo parcial elite de milho, blocos haplotípicos foram ponderados pela complementação de alelos deletérios (identificados por conservação GERP). A acurácia de predição para produção de grão **subiu mais de 4,3%** e a de heterose, ~1%. As linhagens tinham mais de 350.000 sítios putativamente deletérios, em geral raros.
  - **Ramstein & Buckler (Genome Biology 2022, modelo de PNC predita)**: anotações de estrutura genômica e features de proteína (UniRep) elevaram a acurácia na predição de restrição evolutiva de 72% para mais de 80%. **Porém, ponderar SNPs pela PNC predita NÃO melhorou a predição genômica** em painéis híbridos, provavelmente por causa do **LD extenso** (r² médio acima de 0,1 em 100 kb). Houve ganho apenas para produção de grão, e só ao **priorizar** os SNPs mais restritos (top 1% e 0,1%). Para altura de planta e dias até o florescimento, não houve ganho.
  - **Analogia com gado leiteiro (priors funcionais, BayesRC)**: em Xiang et al. (2021), juntar conjuntos de variantes funcionais aos SNPs HD melhorou a acurácia na maioria dos cenários (cerca de 66%, segundo o resumo do pré-print **[VERIFICAR]**). Os ganhos foram maiores em raças não-Holstein e em caracteres de saúde e comportamento, e a diferença entre BayesRC e BayesR, em geral, **não foi significativa**. A mensagem é que priors funcionais ajudam, mas de forma **condicional e modesta**, e o LD muitas vezes apaga o sinal.
- **Variantes regulatórias e desenho de promotores**: a mutagênese in silico (AgroNT em mandioca; Evo 2 guiando padrões de acessibilidade de cromatina) mapeia o efeito de milhões de mutações regulatórias, o que ajuda na **edição de promotores** e na escolha de alvos.
- **Escolha de alvos de edição**: escores zero-shot apontam sítios causais em regiões de alta LD (por exemplo, *Su1* em milho), orientando o uso de CRISPR.

---

## 4. Modelos de proteína

- **ESM-2 / ESMFold**: Lin et al., *Science* 2023. Modelo de linguagem de proteínas (pLM) com até **15 B** de parâmetros. O ESMFold prediz a estrutura 3D **a partir de uma única sequência**, sem MSA, e é cerca de uma ordem de grandeza mais rápido que o AlphaFold2. Foi usado para predizer mais de **617 milhões** de proteínas metagenômicas.
- **AlphaFold2**: Jumper et al., *Nature* 2021. Acurácia mediana de backbone de **0,96 Å RMSD95** no CASP14, contra 2,8 Å do segundo melhor método. O GDT_TS mediano por domínio foi de **92,4** (artigo companheiro em *Proteins*, 2021).
- **AlphaFold3**: Abramson et al., *Nature* 2024. Arquitetura **de difusão** sobre coordenadas atômicas que prediz complexos de proteína, DNA/RNA, ligantes e íons em um único framework. Supera ferramentas especializadas de docking e de ácidos nucleicos.
- **RFdiffusion**: Watson et al., *Nature* 2023. Modelo de difusão (RoseTTAFold ajustado) para **desenhar backbones novos**, incluindo binders e oligômeros simétricos.
- **ProteinMPNN**: Dauparas et al., *Science* 2022. Desenha a sequência para um backbone dado. A recuperação de sequência em backbones nativos foi de **52,4%, contra 32,9% do Rosetta**, e o método resgatou designs que tinham falhado. O pipeline padrão é RFdiffusion → ProteinMPNN → validação com AF2, ESMFold ou Boltz.
- **ESM3**: Hayes et al., *Science* 2025. **98 B** de parâmetros e multimodal (sequência, estrutura e função). Gerou uma proteína fluorescente funcional com **58% de identidade** em relação às proteínas fluorescentes conhecidas.
- **Boltz-1 / Boltz-2**: reproduções abertas no estilo do AlphaFold3 (Wohlwend et al. 2024; Passaro et al. 2025 **[VERIFICAR citações exatas]**).
- **Benchmark em plantas (milho)**: Haley et al., bioRxiv 2025. Compararam AF2, AF3, ESMFold, Boltz-1 e Boltz-2 em **417 genes "clássicos" de milho**.
  - Proteínas **sem domínios conservados de sequência ou de estrutura tiveram confiança 25% a 43% menor** do que as que têm ambos.
  - Proteínas espécie-específicas, ou "jovens", foram preditas com confiança muito menor.
  - Boltz-1 e ESMFold tiveram **mais problemas graves de geometria** (átomos sobrepostos, ângulos de ligação improváveis).
  - Conclusão dos autores: o enovelamento de proteínas **não está "resolvido"** para culturas agrícolas. O AlphaFold dá as predições mais confiáveis, o ESMFold é o mais rápido e o Boltz é um meio-termo.
- **Aplicações em resistência e em enzimas**:
  - **Pikobodies** (Kourelis et al., *Science* 2023): o domínio HMA do NLR de arroz Pikm-1 foi substituído por **nanobodies** de camelídeos e combinado com Pikm-2. As fusões conferiram resistência a vírus PVX que expressavam a proteína fluorescente correspondente. É uma prova de conceito de **imunidade feita sob encomenda**.
  - Limitações dos Pikobodies: autoatividade do nanobody, necessidade de o alvo estar no citosol, ligação inespecífica e possível *yield drag* por superativação do NLR.
  - A engenharia de enzimas (Rubisco, tolerância a herbicidas) é uma aplicação emergente de RFdiffusion e ProteinMPNN **[VERIFICAR exemplos publicados em plantas]**.

---

## 5. Modelos de fundação de visão e fenômica

- **SAM (Segment Anything)**: Kirillov et al., 2023. Segmentação *promptable* zero-shot, treinada no dataset **SA-1B, com mais de 1 bilhão de máscaras em 11 milhões de imagens**. Útil para segmentar órgãos, folhas e panículas sem rótulos.
- **DINOv2**: Oquab et al., 2023. Backbone ViT auto-supervisionado de até **1 B** de parâmetros, destilado em modelos menores. Gera features de uso geral, **sem fine-tuning**, para classificação, segmentação e estimativa de profundidade.
- **PlantCLEF 2024**: modelos **ViT-Base/patch-14 DINOv2** pré-treinados em ~**1,4 milhão de imagens de 7.806 espécies** do Pl@ntNet. Servem de base para extrair traços em fenotipagem de alto rendimento (HTP) com poucos rótulos, via probing linear sobre os embeddings.
- **SCOLD** (2025): modelo de visão e linguagem para doenças foliares, com mais de **186.000 pares imagem-legenda em 97 conceitos**, para classificação zero-shot e few-shot.
- **Uso em HTP**: congelar DINOv2 ou SAM e treinar só uma cabeça leve permite extrair contagem de órgãos, área foliar, severidade de doença e estande com **dezenas de imagens rotuladas, e não milhares** **[VERIFICAR: ordem de grandeza ilustrativa, não medida em um estudo específico]**. Isso complementa os métodos supervisionados das Sessões 03 e 07.

---

## 6. Modelos multimodais (G2P) e agentes LLM para genômica (breve)

- **Esforços multimodais e G2P**: o Evo 2 (DNA, RNA e proteína) e o PlantGFM (DNA → RNA → proteína em plantas) apontam para modelos que unificam as ômicas. Ainda não existe um modelo de fundação maduro de genótipo para fenótipo em culturas.
- **Agentes LLM**:
  - **BioDiscoveryAgent** (Roohani et al., 2024): com Claude 3.5 Sonnet, teve **melhora média de 21%** sobre otimização bayesiana no desenho de perturbações genéticas em seis datasets, e de **46%** na tarefa mais difícil, com genes não-essenciais.
  - **CRISPR-GPT** (Huang et al., 2024): agente para desenhar experimentos de edição (escolha do sistema CRISPR, gRNA, entrega e protocolos). Foi validado com knockouts por Cas12a em quatro genes e ativação epigenética por dCas9 em dois genes, em linhagens celulares humanas.
  - **GeneGPT** (Jin et al., 2024): LLM que chama as APIs web do NCBI para responder perguntas de genômica **[VERIFICAR métricas]**.

---

## 7. Limitações (seção crítica para melhoristas)

- **Viés de dados**: há poucos genomas de plantas de alta qualidade. A **poliploidia** e os genomas **ricos em elementos transponíveis (TEs)** inflam a fração de sequências repetitivas, fáceis de prever e pouco informativas. GPN e PlantCaduceus reduzem esse efeito com *down-weighting* e *down-sampling* das repetições.
- **Custo computacional**:
  - O AgroNT foi treinado em TPU v4, e o PlantRNA-FM levou mais de três semanas em 4 GPUs A100.
  - O Evo 2 40B exige recursos extremos.
  - Em contrapartida, os PDLLMs e o PlantCaduceus de 20 M rodam em GPU de consumidor.
- **Vazamento na avaliação (ligação com a Sessão 06)**:
  - Rótulos clínicos usados em benchmarks podem ter sido definidos com ajuda dos próprios preditores (critérios ACMG PP3 e BA1).
  - A frequência alélica reflete também deriva, taxa de mutação e *hitchhiking*, e não só restrição funcional.
  - Sobreposição entre as espécies usadas no pré-treino e no teste infla os resultados.
- **gLMs nem sempre superam a conservação simples**:
  - Tang & Koo (2024): gLMs zero-shot (NT de 2,5B, GPN, HyenaDNA) tiveram **desempenho ruim** na predição quantitativa de efeito de variantes em dados de MPRA, perdendo para modelos supervisionados (Enformer, Sei).
  - A revisão de Benegas et al. (2025) relata que, no genoma humano, os gLMs **geralmente não superaram baselines que não são gLMs**, ao menos com embeddings congelados.
  - O GPN-MSA supera CADD e phyloP em alguns benchmarks. Já para **variantes codificantes raras, não foi o melhor em nenhum gene**: SLP médio de 2,05, contra 7,48 do AlphaMissense.
  - Em plantas o quadro é **mais favorável**: com menos dados rotulados, o transfer learning agrega mais valor. Mesmo assim, a comparação com phyloP e phastCons deve sempre fazer parte da avaliação.
- **Interpretabilidade**: embeddings são caixas-pretas. Análises de atenção e mutagênese in silico ajudam, mas atribuir causalidade continua difícil.

---

## 8. Como um programa de melhoramento pode começar

1. **Baixe modelos prontos do Hugging Face**:
   - `InstaDeepAI/agro-nucleotide-transformer-1b` (AgroNT).
   - Modelos PlantCaduceus/PlantCAD (`PlantCaduceus_l20` a `l32`, PlantCAD2). O l20 roda em uma única GPU.
   - `InstaDeepAI/nucleotide-transformer-*` (Nucleotide Transformer).
   - `PlantNet/vit_base_patch14_reg4_dinov2_lvd142m.pc24_all` (fenômica).
   - ESM-2 via `facebook/esm2_*`.
2. **Comece por probing, não por fine-tuning**: extraia embeddings congelados e treine XGBoost ou regressão. É barato e reprodutível.
3. **Computação**: escore zero-shot e probing rodam em **1 GPU** de 16 a 40 GB **[VERIFICAR para cada modelo]**. Fine-tuning completo de modelos de 1 B exige um cluster de A100. Prefira modelos de 20 a 150 M de parâmetros (PlantCaduceus, PDLLMs).
4. **Dataset mínimo**: genoma de referência da cultura, painel de SNPs com frequências (para validar os escores pela MAF) e algumas centenas de sítios funcionais rotulados (TIS, splice) para o probing.
5. **Piloto sugerido**:
   - (a) Calcular o escore zero-shot de deleteriedade para todo o painel.
   - (b) Comparar com phyloP, phastCons e SIFT como baseline obrigatório.
   - (c) Testar o escore como feature ou prior em GBLUP ou BayesRC, com **validação cruzada sem vazamento** (Sessão 06).
   - (d) Para resistência, rodar ESMFold ou AF2 nos NLRs candidatos e avaliar engenharia no estilo dos Pikobodies.

### Perguntas para discussão

1. Ponderar SNPs por restrição evolutiva **não** melhorou a predição em painéis híbridos de milho (Ramstein & Buckler 2022), por causa do LD. Em que populações ou esquemas de melhoramento um escore de gLM teria mais chance de aumentar a acurácia (sequência completa, alelos raros, introgressão de germoplasma exótico)?
2. Um gLM zero-shot que **não supera o phyloP** ainda é útil? Em quais tarefas o transfer learning do gLM vence a conservação clássica, e como desenhar um benchmark sem vazamento para decidir?
3. Pikobodies e PlantGFM abrem caminho para "imunidade sob encomenda" e genes *de novo*. Quais são os riscos agronômicos (*yield drag*, durabilidade) e regulatórios de levar ao campo sequências geradas por IA?

---

## Tabela comparativa de modelos

| Modelo | Ano | Organização | Parâmetros | Espécies/dados | Contexto | Resultado-chave | Link |
|---|---|---|---|---|---|---|---|
| GPN | 2023 | UC Berkeley (Song lab) | ~65 M [VERIFICAR] | Arabidopsis + 7 Brassicales | 512 bp [VERIFICAR] | Supera phyloP e phastCons em Arabidopsis | https://doi.org/10.1073/pnas.2311219120 |
| AgroNT | 2024 | InstaDeep | 1 B | 48 espécies de plantas | ~6 kb (6-mer) | AUROC de cromatina 0,94–0,98; ISM de >10 M de mutações em mandioca | https://doi.org/10.1038/s42003-024-06465-2 |
| PlantCaduceus | 2025 | Cornell (Kuleshov/Buckler) | 20–225 M | 16 angiospermas (~160 milhões de anos) | 512 bp (8.192 no PlantCAD2) | 3× melhor que phyloP; TIS em milho 7,23× vs. GPN | https://doi.org/10.1073/pnas.2421738122 |
| PDLLMs | 2024 | Liu et al. | 89–152 M | 22 genomas de 14 espécies | varia | 198 modelos ajustados; roda em RTX 4090 | https://www.cell.com/molecular-plant/fulltext/S1674-2052(24)00390-3 |
| PlantRNA-FM | 2024 | Yu et al. (Ding lab) | 35 M | 1.124 espécies (RNA) | — | F1 de 0,974 em Arabidopsis (anotação gênica) | https://doi.org/10.1038/s42256-024-00946-z |
| Nucleotide Transformer | 2024 | InstaDeep | até 2,5 B | 850 genomas + 3.202 genomas humanos | ~6 kb | Benchmark de 18 tarefas; base do AgroNT | https://doi.org/10.1038/s41592-024-02523-z |
| Evo | 2024 | Arc Institute / Stanford | 7 B | 2,7 M genomas de procariotos e fagos | 131 kb | Geração de CRISPR-Cas validada experimentalmente | https://doi.org/10.1126/science.ado9336 |
| Evo 2 | 2026 | Arc Institute | 7 B / 40 B | Todos os domínios da vida (~9,3 T tokens) | 1 Mb | Efeito de variantes em BRCA1 sem fine-tuning | https://doi.org/10.1038/s41586-026-10176-5 |
| PlantGFM | 2026 | — | [VERIFICAR] | 12 espécies (10,84 bilhões de nt) | 64 kb | Genes *de novo* com atividade transcricional em *N. benthamiana* | Advanced Science 2026 [VERIFICAR DOI] |
| ESM-2 / ESMFold | 2023 | Meta AI | até 15 B | Proteínas (UniRef) | — | >617 M de estruturas metagenômicas; sem MSA | https://doi.org/10.1126/science.ade2574 |
| AlphaFold2 | 2021 | DeepMind | — | PDB + MSA | — | 0,96 Å RMSD95; GDT_TS mediano de 92,4 (CASP14) | https://doi.org/10.1038/s41586-021-03819-2 |
| AlphaFold3 | 2024 | DeepMind / Isomorphic | — | PDB (difusão) | — | Complexos de proteína, ligantes e ácidos nucleicos | https://doi.org/10.1038/s41586-024-07487-w |
| RFdiffusion | 2023 | Baker Lab (UW) | — | PDB | — | Desenho de binders e oligômeros simétricos | https://doi.org/10.1038/s41586-023-06415-8 |
| ProteinMPNN | 2022 | Baker Lab (UW) | — | Backbones do PDB | — | Recuperação de 52,4% vs. 32,9% do Rosetta | https://doi.org/10.1126/science.add2187 |
| ESM3 | 2025 | EvolutionaryScale | 98 B | Sequência, estrutura e função | — | Proteína fluorescente com 58% de identidade | https://doi.org/10.1126/science.ads0018 |
| DINOv2 | 2023 | Meta AI | até 1 B | LVD-142M (142 M de imagens) | — | Features de visão sem fine-tuning | https://arxiv.org/abs/2304.07193 |
| SAM | 2023 | Meta AI | — | SA-1B (1 B de máscaras, 11 M de imagens) | — | Segmentação zero-shot | https://arxiv.org/abs/2304.02643 |

---

## Referências

1. Mendoza-Revilla J, Trop E, Gonzalez L, et al. (2024). A foundational large language model for edible plant genomes. *Communications Biology* 7:835. https://doi.org/10.1038/s42003-024-06465-2
2. Zhai J, Gokaslan A, Schiff Y, et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. *PNAS* 122:e2421738122. https://doi.org/10.1073/pnas.2421738122 (pré-print: https://doi.org/10.1101/2024.06.04.596709) [VERIFICAR lista de autores]
3. Benegas G, Batra SS, Song YS (2023). DNA language models are powerful predictors of genome-wide variant effects. *PNAS* 120(44):e2311219120. https://doi.org/10.1073/pnas.2311219120
4. Dalla-Torre H, Gonzalez L, Mendoza-Revilla J, et al. (2024). Nucleotide Transformer: building and evaluating robust foundation models for human genomics. *Nature Methods*. https://doi.org/10.1038/s41592-024-02523-z
5. Nguyen E, Poli M, Durrant MG, et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. *Science* 386(6723):eado9336. https://doi.org/10.1126/science.ado9336
6. Brixi G, et al. (2026). Genome modelling and design across all domains of life with Evo 2. *Nature*. https://doi.org/10.1038/s41586-026-10176-5 [VERIFICAR primeiro autor e paginação]
7. Liu G, et al. (2024). PDLLMs: A group of tailored DNA large language models for analyzing plant genomes. *Molecular Plant*. https://www.cell.com/molecular-plant/fulltext/S1674-2052(24)00390-3 [VERIFICAR autores e DOI]
8. Yu H, Yang H, Sun W, Yan Z, et al. (2024). An interpretable RNA foundation model for exploring functional RNA motifs in plants. *Nature Machine Intelligence*. https://doi.org/10.1038/s42256-024-00946-z
9. PlantGFM: A Genomic Foundation Model for Discovery and Creation of Plant Genes (2026). *Advanced Science*. [VERIFICAR autores e DOI]
10. Lin Z, Akin H, Rao R, et al. (2023). Evolutionary-scale prediction of atomic-level protein structure with a language model. *Science* 379:1123–1130. https://doi.org/10.1126/science.ade2574
11. Jumper J, Evans R, Pritzel A, et al. (2021). Highly accurate protein structure prediction with AlphaFold. *Nature* 596:583–589. https://doi.org/10.1038/s41586-021-03819-2
12. Jumper J, Evans R, Pritzel A, et al. (2021). Applying and improving AlphaFold at CASP14. *Proteins* 89(12):1711–1721. https://doi.org/10.1002/prot.26257
13. Abramson J, Adler J, Dunger J, et al. (2024). Accurate structure prediction of biomolecular interactions with AlphaFold 3. *Nature* 630:493–500. https://doi.org/10.1038/s41586-024-07487-w
14. Watson JL, Juergens D, Bennett NR, et al. (2023). De novo design of protein structure and function with RFdiffusion. *Nature* 620:1089–1100. https://doi.org/10.1038/s41586-023-06415-8
15. Dauparas J, Anishchenko I, Bennett N, et al. (2022). Robust deep learning–based protein sequence design using ProteinMPNN. *Science* 378:49–56. https://doi.org/10.1126/science.add2187
16. Hayes T, Rao R, Akin H, et al. (2025). Simulating 500 million years of evolution with a language model. *Science*. https://doi.org/10.1126/science.ads0018
17. Haley O, Tibbs-Cortes L, Hayford RK, et al. (2025). Why do some predicted protein structures fold poorly? Benchmarking AlphaFold, ESMFold, and Boltz in maize. *bioRxiv*. https://doi.org/10.1101/2025.07.05.663230
18. Kourelis J, Marchal C, Posbeyikian A, Harant A, Kamoun S (2023). NLR immune receptor–nanobody fusions confer plant disease resistance. *Science* 379:934–939. https://doi.org/10.1126/science.abn4116
19. Yang J, Mezmouk S, Baumgarten A, et al. (2017). Incomplete dominance of deleterious alleles contributes substantially to trait variation and heterosis in maize. *PLoS Genetics* 13(9):e1007019. https://doi.org/10.1371/journal.pgen.1007019
20. Ramstein GP, Buckler ES (2022). Prediction of evolutionary constraint by genomic annotations improves functional prioritization of genomic variants in maize. *Genome Biology* 23:183. https://doi.org/10.1186/s13059-022-02747-2
21. MacLeod IM, Bowman PJ, Vander Jagt CJ, et al. (2016). Exploiting biological priors and sequence variants enhances QTL discovery and genomic prediction of complex traits. *BMC Genomics* 17:144. https://pmc.ncbi.nlm.nih.gov/articles/PMC4769584/
22. Xiang R, MacLeod IM, Daetwyler HD, et al. (2021). Bayesian genome-wide analysis of cattle traits using variants with functional and evolutionary significance. *Animal Production Science*. https://doi.org/10.1071/an21061
23. Tang Z, Somia N, Yu Y, Koo PK (2024). Evaluating the representational power of pre-trained DNA language models for regulatory genomics. https://pmc.ncbi.nlm.nih.gov/articles/PMC10925287/ [VERIFICAR versão publicada]
24. Benegas G, Ye C, Albors C, Li JC, Song YS (2025). Genomic language models: opportunities and challenges. https://pmc.ncbi.nlm.nih.gov/articles/PMC11275703/ [VERIFICAR periódico]
25. Benegas G, Albors C, Aw AJ, et al. GPN-MSA: an alignment-based DNA language model for genome-wide variant effect prediction. https://pmc.ncbi.nlm.nih.gov/articles/PMC10592768/ [VERIFICAR versão publicada]
26. Assessment of ability of a DNA language model to predict pathogenicity of rare coding variants (2025). https://pmc.ncbi.nlm.nih.gov/articles/PMC12552115/ [VERIFICAR autores]
27. Roohani Y, Vora J, Huang Q, et al. (2024). BioDiscoveryAgent: An AI agent for designing genetic perturbation experiments. *arXiv*. https://doi.org/10.48550/arXiv.2405.17631
28. Huang K, Qu Y, Cousins H, et al. (2024). CRISPR-GPT: An LLM agent for automated design of gene-editing experiments. *bioRxiv*. https://doi.org/10.1101/2024.04.25.591003 (arXiv:2404.18021)
29. Jin Q, et al. (2024). GeneGPT: augmenting large language models with domain tools for improved access to biomedical information. *Bioinformatics*. [VERIFICAR DOI]
30. Oquab M, Darcet T, Moutakanni T, et al. (2023). DINOv2: Learning robust visual features without supervision. *arXiv*. https://arxiv.org/abs/2304.07193
31. Kirillov A, Mintun E, Ravi N, et al. (2023). Segment Anything. *arXiv*. https://arxiv.org/abs/2304.02643
32. Goëau H, et al. (2024). PlantCLEF 2024 pretrained models (ViT-Base/14 DINOv2). Zenodo. https://doi.org/10.5281/zenodo.10848263
33. Nguyen Quoc K, Le Thi Thu L, Quach L-D (2025). A vision-language foundation model for leaf disease identification (SCOLD). *arXiv*. https://arxiv.org/abs/2505.07019
34. Foundation models in plant molecular biology: advances, challenges, and future directions (2025). *Frontiers in Plant Science*. https://doi.org/10.3389/fpls.2025.1611992
