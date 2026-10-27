# Bloco 3 — IA + Edição de Genoma no Melhoramento Vegetal

*Dossiê de aula — Curso "IA no Melhoramento de Plantas" (UFV, nov/2026). Público: melhoristas/geneticistas que já dominam seleção genômica (Sessão 06) e otimização de cruzamentos/OCS (Sessão 09).*

> Convenção: números sem marca foram verificados em fonte primária (DOI/URL ao final). `[VERIFICAR]` indica valor volátil, de preprint, ou não confirmado em fonte primária atualizada.

---

## Resumo executivo

A edição de genoma deixou de ser uma ferramenta de "nocaute de gene único" e tornou-se um **espectro quantitativo**: de indels (SDN-1) a substituições precisas de bases e *prime editing* (SDN-2), inserção dirigida (SDN-3), edição de regiões *cis*-regulatórias e domesticação *de novo*. A IA entra em quatro frentes: (i) **desenho** (eficiência on-target, off-target, resultado de base/prime editing); (ii) **engenharia de novas enzimas** (modelos de linguagem de proteínas → OpenCRISPR-1); (iii) **descoberta do alelo a escrever** (gLMs, mutagênese *in silico*, fine-mapping); (iv) **agentes LLM** que orquestram o fluxo (CRISPR-GPT). A pergunta central para o melhorista não é "posso editar?", mas **"editar vale mais do que selecionar, para ESTE caráter, NESTE germoplasma, sob ESTE custo regulatório?"** — e a resposta depende da arquitetura genética, do tamanho de efeito, da existência de variante causal conhecida e do tempo. Simulações (PAGE) mostram ganhos de **1,08× a 4,12×** sobre GS pura, mas com inflação de endogamia; o acoplamento com DH e *speed breeding* muda a economia do programa.

---

## 1. Caixa de ferramentas de edição — o que cada uma habilita para o melhorista

**Nucleases (SDN-1/2/3).** Cas9 (PAM NGG, corte rombo) e Cas12a/Cpf1 (PAM rico em T, corte coeso, processa seu próprio array de crRNA → **multiplex** mais simples). O reparo por NHEJ gera indels/*knockouts* (**SDN-1**); com molde doador obtém-se substituições (**SDN-2**) ou inserções dirigidas (**SDN-3**, ainda o gargalo de eficiência em plantas). Para o melhorista: SDN-1 é a via regulatória mais limpa (sem DNA exógeno no produto final) e cobre a maioria dos alelos de domesticação, que são de perda de função.

**Editores de base (CBE/ABE).** Instalam transições sem quebra de dupla fita: CBE (C→T) e ABE (A→G). Úteis para recriar SNPs favoráveis conhecidos (p.ex., tolerância a herbicida, alelos de qualidade) sem recombinação. Cuidado com *bystander edits* (edição de bases vizinhas na janela de atividade).

**Prime editing.** "Busca-e-substitui" via pegRNA + transcriptase reversa fusionada a nCas9: faz todas as 12 transições/transversões e pequenos indels sem quebra nem doador. Eficiência em plantas ainda menor que nucleases, mas é a ferramenta mais versátil para "escrever o alelo exato".

**Edição *cis*-regulatória e variação quantitativa.** Marco: **Rodríguez-Leal et al. (2017, Cell)** usaram 8 gRNAs cobrindo ~2 kb do promotor de *SlCLV3* em tomate, gerando uma **série alélica contínua** de número de lóculos/tamanho de fruto e arquitetura. Achado central para melhoristas: **a mudança transcricional foi mau preditor do efeito fenotípico** — ou seja, editar promotor gera um *espectro* de alelos que precisa ser fenotipado, não calculado. Isso abre a possibilidade de "dial" quantitativo (ajuste fino de dose) em vez do liga/desliga do nocaute.

**Domesticação *de novo*.** Dois trabalhos paralelos em 2018: **Zsögön et al. (nbt.4272)** editaram 6 loci (*SP, OVATE, FW2.2, FAS, MULTIFLORA/lc, CycB*) em *Solanum pimpinellifolium* selvagem → **+3× tamanho de fruto, +10× número de frutos, +500% licopeno** vs. tomate cereja cultivado. **Li et al. (nbt.4273)** editaram *SP, SP5G, SlCLV3, SlWUS* e o uORF de *SlGGP1* (vitamina C) em acessos tolerantes a estresse, **mantendo resistência a mancha bacteriana e tolerância a sal**. Extensão para poliploide: **Yu et al. (2021, Cell)** domesticaram *de novo* o arroz alotetraploide selvagem *Oryza alta* (PPR1), editando homólogos de qSH1, An-1, etc. — primeiro cereal/poliploide domesticado *de novo*.

**HI-Edit / edição via indução de haploides.** **Kelliher et al. (2019, nbt, s41587-019-0038-x)**: a linhagem indutora de haploides carrega a maquinaria CRISPR; ao polinizar a elite, induz a edição e depois é eliminada → progênie haploide editada **sem DNA do indutor nem da maquinaria**, pronta para DH. Permite editar germoplasma elite recalcitrante à transformação. Eficiência de edição em milho reportada em **~3–4%** (HI-Edit/IMGE); trabalhos recentes reportam taxas de edição de alvo de **0,38–1,46%** com HIR de **8,55–20,89%** por linhagem.

**Gargalo de entrega e regeneração.** O limite real em muitas culturas não é a enzima, é **transformar e regenerar**. Reguladores morfogênicos resolvem isso: **BBM/WUS2** (milho e outros monocotiledôneas) e a quimera **GRF4–GIF1** (**Debernardi et al. 2020, s41587-020-0703-0**): regeneração de trigo **65,1% vs. 8,3%** do controle (**7,8×**), sem citocinina exógena, plantas férteis, e 30 plantas de trigo editadas no gene *Q*. Combinações BBM/WUS + GRF-GIF atingem até **55,4%** de eficiência de transformação em trigo `[VERIFICAR — dado de pôster IWC 2024]`.

---

## 2. IA/ML para a própria edição

**Eficiência on-target de gRNA.** Modelos treinados em dados de células humanas: Rule Set 2/3 (Broad, LightGBM), **DeepSpCas9** (CNN, 12.832 alvos), **DeepHF**, **CRISPRon** (**s41467-021-23576-0**, 23.902 gRNAs). Em testes independentes, CRISPRon atingiu Spearman R ≈ 0,80 vs. **DeepSpCas9 0,73, DeepHF 0,74, Azimuth 0,56**. Para Cas12a: **DeepCpf1** (CNN).

**Transferência para plantas (ponto crítico).** Esses modelos foram treinados em contexto de célula animal/cromatina humana. **Gong et al. (2025, bioRxiv 10.1101/2025.10.15.679654)** avaliaram **>20 ferramentas** contra dados reais de edição *in planta* e encontraram que **várias ferramentas de ML correlacionam significativamente com a frequência de indels em plantas** (gRNAs do quartil superior editam muito mais que os do inferior), com bons escores no CRISPOR. Mensagem de aula: há transferência útil para ranquear guias, **mas o escore é um prior relativo, não uma garantia de %** — a edição depende de entrega, cromatina e genótipo, nenhum deles entrada do modelo. `[VERIFICAR — preprint não revisado por pares]`.

**Off-target.** **CFD score** (Doench 2016): penalidades de mismatch posição- e substituição-específicas; **AUC 0,91 vs. 0,87 do MIT score**. **CRISPR-Net** (LRCN, deep learning), Elevation, CRISOT. Em plantas, a predição *in silico* + validação por sequenciamento dirigido é a prática recomendada.

**Resultado de base/prime editing.** **BE-Hive** (Arbab et al. 2020, Cell; 38.538 alvos, 11 CBE/ABE): prediz genótipo (**R≈0,9**) e eficiência (**R≈0,7**), incluindo *bystander*. **PRIDICT** (Mathis et al. 2023, s41587-022-01613-7; 92.423 pegRNAs / 13.349 mutações): Spearman **R=0,85** (edição pretendida) e **0,78** (não pretendida); pegRNAs com escore >70 vs <70 → **12× in vitro / 10× in vivo** mais edição. **DeepPrime** (PE2/PE4, non-NGG, edições ≤3 bp) e **PRIDICT2.0** (≤15 bp).

**Engenharia de novas enzimas com modelos de linguagem de proteínas.** **OpenCRISPR-1** (Profluent, abr/2024; publicado em **Nature 2025, s41586-025-09298-z**): pLM treinado em **>1 milhão de óperons CRISPR**, gerando **4,8×** a diversidade natural; a variante nomeada edita no on-target **56,4% vs. 47,1%** do SpCas9 com **95% menos** off-target (0,32% vs. 6,1%), estando a **~400 mutações** do SpCas9 e compatível com base editing. É o primeiro editor desenhado *de novo* por IA funcional em células humanas — prova de conceito direta para "desenhar a enzima" além de "desenhar o guia".

**Agentes LLM.** **CRISPR-GPT** (Qu et al., **Nature Biomedical Engineering 2025, s41551-025-01463-z**): sistema multiagente que decompõe a tarefa (escolha de sistema, desenho de gRNA, método de entrega, protocolo, análise); avaliado em **288 casos** (Gene-editing bench) e validado em bancada (nocaute Cas12a em adenocarcinoma de pulmão; ativação epigenética dCas9 em melanoma). Relevância: baixa a barreira de expertise — e levanta a questão de *caixa-preta* (Seção 7).

---

## 3. IA para DESCOBERTA DE ALVOS (o problema "qual alelo escrever")

O gargalo real não é cortar — é **saber onde e o quê**. Pilha de IA:

- **gLMs (modelos de linguagem genômica) de plantas.** **AgroNT** (Mendoza-Revilla et al. 2024, s42003-024-06465-2): transformer treinado em **48 espécies** (foco em culturas), prediz anotação regulatória, força de promotor/terminador, expressão tecido-específica e prioriza variantes funcionais; fez **mutagênese *in silico* de saturação em mandioca (>10 milhões de mutações)**, entregando um mapa de impacto regulatório — exatamente o insumo para desenhar alelos de promotor. **PlantCaduceus** (2025, PNAS 10.1073/pnas.2421738122): 16 angiospermas, transfere para milho (160 Myr de divergência) superando o melhor gLM anterior em **1,45×** (splice donor) e **7,23×** (TIS); variantes previstas deletérias têm MAF **3× menor**. **PhytoExpr** (PNAS 10.1073/pnas.2319811121): modela 0,6 milhão de genes para desenho racional e *de novo* de sequências *cis*-regulatórias.
- **Fine-mapping + efeito de variante.** GWAS/QTL fine-mapping, TWAS, eQTL e **pan-genomas/variantes estruturais** definem o conjunto de variantes candidatas; o gLM pontua o efeito funcional (*zero-shot*), reduzindo a lista para alvos editáveis com causalidade plausível.
- **Mutagênese *in silico* de saturação** para **desenhar a série alélica de promotor antes da bancada** — transformando o achado empírico de Rodríguez-Leal (transcrição não prediz fenótipo) num problema tratável por modelo, embora ainda com validação de campo obrigatória.

Limite honesto: gLMs capturam conservação/regulação, mas **efeito epistático, pleiotropia e GxE** continuam exigindo fenotipagem. `[VERIFICAR — a maioria desses modelos tem validação funcional em poucas culturas]`.

---

## 4. Integrando edição com seleção genômica (resultados quantitativos)

**PAGE — Jenko et al. (2015, GSE, s12711-015-0135-3).** Simulação de caráter com **10.000 QTN**, 20 gerações. GS+PAGE superou GS pura em **1,08–4,12×** na resposta cumulativa. Dados-chave para a aula:

| Estratégia de edição | Resposta cumulativa (×GS pura, geração 20) |
|---|---|
| 1 QTN/touro, todos os 25 | 1,08× |
| 20 QTN/touro, todos os 25 | 2,00× |
| 500 edições/geração nos **Top 5** touros | **4,12×** |
| 500 edições/geração espalhadas (todos 25) | 2,00× |

Em números absolutos: na geração 20, GS pura = 10,07 unidades; GS+PAGE = 20,09 (editando 20 QTN em todos os touros). **Lições:** (1) concentrar edições nos melhores indivíduos maximiza resposta **mas infla endogamia** → conectar com OCS/controle de parentesco (Sessão 09); (2) o ganho marginal por edição decai (QTN de maior efeito se esgotam); (3) o efeito é maior nas primeiras gerações.

**Comparação com seleção assistida por QTN** (simulação 2018, sky404.276): GS+edição superou GS pura em **26–53%** nas gerações 5–10. **RAGE — Johnsson/Jenko et al. (2019, GSE, s12711-019-0456-8)**: trata de *remoção* de carga deletéria — edição multiplex de 5 variantes/touro supera a seleção contra portadores; a estratégia ótima depende da dominância (co-dominante → priorizar baixa frequência; recessivo → frequência intermediária). *Obs.: esses marcos são em gado; os princípios transferem para plantas, mas simulações GS+edição especificamente vegetais ainda são escassas* `[VERIFICAR]`.

**Quantas edições valem a pena?** Para arquitetura altamente poligênica, editar poucos QTN move pouco a média (1,08×); o ganho exige **multiplex** e QTN de efeito médio-grande. **Editar em elite vs. em doadores:** editar na elite evita *linkage drag* e arrasto de recombinação (vantagem sobre introgressão, que leva ~7 anos); editar em doadores faz sentido quando a variante causal só existe lá. **Acoplamento com DH + *speed breeding***: HI-Edit entrega o alelo já em contexto haploide/DH, colapsando ciclos — a sinergia certa é *editar o alelo de grande efeito + GS para o fundo poligênico*.

---

## 5. Produtos reais (verificados)

| Produto | Empresa / país | Ferramenta | Traço | Status |
|---|---|---|---|---|
| Tomate alto-GABA "Sicilian Rouge" | Sanatech Seed, Japão | CRISPR-Cas9 (GAD) | **4–5× GABA** | 1ª comida CRISPR vendida no mundo, **15/09/2021** |
| Óleo de soja alto-oleico "Calyno" | Calyxt, EUA | **TALEN** | ~80% ácido oleico, 0 g trans | 1ª comida editada vendida nos EUA, **fev/2019** |
| Mostarda "Conscious Greens" | Pairwise, EUA | CRISPR | menos amargor/pungência | 1ª comida CRISPR nos EUA, **mai/2023** |
| Milho ceroso (waxy) | Corteva, EUA | CRISPR (deleção *Wx-1*) | alto amilopectina | não-regulado USDA; FDA premarket **08/09/2025** |
| Banana não-escurecedora | Tropic, Reino Unido | CRISPR | anti-escurecimento | USDA APHIS **14/11/2023**; Filipinas abr/2023 |
| Milho de baixa estatura (Preceon) | **Bayer–Pairwise** | CRISPR (Fulcrum, REDRAW, SHARC) | **30–40% mais baixo** | nova parceria 5 anos **29/08/2023** |
| Soja arquitetura/rendimento | Inari, EUA | edição | +número/tamanho de semente | FDA premarket dez/2025 |

Notas: a parceria inicial Bayer–Pairwise (encerrada jun/2023) gerou **27 traços** transferidos aos programas da Bayer, incluindo fenótipo de milho com **+20% de fileiras de grãos**. **Embrapa/Brasil**: soja com *LE1* (lectina) silenciado por CRISPR (cultivar BRS 537) **aprovada como não-OGM pela CTNBio em set/2022**; soja tolerante à seca (*RACK1*, GDM) aprovada em mai/2022; projeto de bovino β-lactoglobulina (leite hipoalergênico) concluído, sem indicação de aprovação comercial `[VERIFICAR]`.

---

## 6. Regulação (implicações para o cronograma do programa)

- **Brasil — RN 16/2018 (CTNBio)**: consulta **caso a caso** (TIMP); se não houver DNA/RNA recombinante no produto final, é **não-OGM**. Até **ago/2022: 32 produtos** aprovados como não-OGM (11 leveduras, 6 plantas: 3 cana, 2 soja, 1 milho, + animais). Total atual `[VERIFICAR — tabela TIMP atualizada em 25/04/2026]`. Exige descrição de off-targets no dossiê.
- **Argentina — Resolução 173/2015**: **primeiro marco do mundo** para NBTs; CONABIA avalia se houve "nova combinação de material genético", prazo de **60 dias**; atualizada em 2019 (animais/microrganismos). Virou modelo para Chile, Colômbia, Paraguai, Uruguai, Brasil.
- **EUA — SECURE rule (7 CFR 340, mai/2020)**: isentava plantas que poderiam surgir por melhoramento convencional ("at least 99 new GE plants exempted"). **Vacatada em 02/12/2024** (*Nat'l Family Farm Coalition v. Vilsack*, N.D. Cal.) por violação da APA (falha em usar a autoridade de "noxious weed" e em fundamentar as isenções). Vacatur **prospectiva** (determinações/permissões anteriores continuam válidas); regime pré-2020 restaurado; emenda técnica do CFR efetiva **16/06/2025**. **Implicação: incerteza regulatória nos EUA aumentou.**
- **UE — NGT**: **Regulamento (UE) 2026/1388** adotado — acordo provisório **03/12/2025**, aprovação do Parlamento **17/06/2026**, em vigor **16/07/2026**, **aplicável a partir de 17/07/2028**. Cria **NGT1** (equivalente a convencional, verificação leve, sem rótulo exceto sementes) e **NGT2** (regime tipo-OGM). Herbicida-tolerância e inseticida ficam **excluídos** da categoria 1. Até 2028, vale o regime OGM atual.
- **China — MARA, 24/01/2022**: primeiras diretrizes; via de aprovação baseada em risco para plantas editadas **sem genes exógenos**, com exigência de dados moleculares (edição-alvo, resíduo de vetor, off-target).

**Para o melhorista:** a janela regulatória define a economia. SDN-1 sem transgene residual é a rota mais rápida/barata em Brasil, Argentina, EUA (pré-2020) e China; a UE só destrava para produtos a partir de 2028. **O custo regulatório é hoje a variável decisória tão importante quanto a biologia.**

---

## 7. Riscos e limites

- **Pleiotropia & GxE**: alelo de promotor pode mover vários traços; a série alélica precisa de campo.
- **Poliploidia (trigo 6x)**: é preciso editar homeólogos múltiplos simultaneamente → multiplex e mais chance de efeitos parciais; vantagem: redundância tampona nocautes.
- **Off-targets em plantas (evidência por WGS)**: **Tang et al. 2018 (rice)** — a cultura de tecidos gera **~102–148 SNVs e ~32–83 indels por planta** (variação somaclonal), enquanto só **1 de 12 sgRNAs** de Cas9 causou off-target previsto, e **nenhum off-target *bona fide*** em T1. Ou seja, **off-target de CRISPR bem-desenhado é pequeno perto da variação somaclonal** — argumento regulatório forte. **Exceção:** **ABE8e** produziu **~500 mutações A→G independentes de gRNA por planta** → editores de base muito ativos precisam de WGS.
- **IP**: **CVC** (Berkeley/Viena) detém Cas9 genérico; **Broad**, uso em eucariotos; aplicação agrícola de Cas9 tipicamente exige **licença de CVC + outro grupo**. **Corteva** tem exclusividade CVC para *major row crops* + não-exclusiva Broad, e **oferece licença conjunta não-exclusiva com o Broad desde 2017** (pesquisa acadêmica isenta). **Bayer**: não-exclusiva Broad + ERS + colaboração Pairwise. Alternativas (Cas12) contornam parte do emaranhado.
- **Aceitação pública** e **"caixa-preta" da IA**: quando o alelo é *desenhado por um modelo* (gLM/enzima gerada por pLM), a explicabilidade e a confiança regulatória/consumidor tornam-se questão central — reguladores pedem rastreabilidade do *racional* do edit.

---

## 8. Quadro de decisão — quando editar supera selecionar

| Fator | Favorece **EDIÇÃO** | Favorece **SELEÇÃO (GS/convencional)** |
|---|---|---|
| Arquitetura do caráter | Mono/oligogênica ou poucos QTN de grande efeito | Altamente poligênica, muitos QTN de pequeno efeito |
| Tamanho de efeito do alelo | Médio-grande, aditivo | Pequeno, muito epistático/GxE |
| Variante causal | **Conhecida** (SNP/indel/promotor) | Desconhecida; só sinal estatístico |
| Alelo presente no pool elite | Ausente (ou só em selvagem/doador) | Já segregando na elite |
| *Linkage drag* / introgressão | Severo (introgressão custaria ~7 anos) | Ausente |
| Custo & via regulatória | SDN-1 sem transgene, país permissivo | Produto cairia como OGM/NGT2 |
| Tempo até ganho | Urgente; acelerar por HI-Edit/DH | Horizonte longo aceitável |
| Nº de alvos | 1–~20 edições (multiplex) viável | Centenas de locos |

**Regra prática:** *editar o(s) alelo(s) de grande efeito com causalidade conhecida + GS para o fundo poligênico* — e usar OCS (Sessão 09) para conter a endogamia que o PAGE inflaciona.

---

## Perguntas de discussão

1. Dado o resultado de Rodríguez-Leal (transcrição ≠ fenótipo), quanto você confiaria num gLM para *pré-selecionar* alelos de promotor antes do campo?
2. No seu programa, 10 edições concentradas nos 2 melhores genitores (PAGE agressivo) ou 2 edições em 10 genitores? Justifique via resposta × ΔF (ligue à Sessão 09/OCS).
3. Se o alelo favorável só existe em parente selvagem, **editar na elite** ou **introgredir + GS**? Compare custo/tempo/regulação.
4. Um editor desenhado por IA (OpenCRISPR-1) com menor off-target — mas "caixa-preta" — seria aceitável no dossiê da CTNBio? E para o consumidor?
5. Como a assimetria regulatória (Brasil/Argentina rápido vs. UE só em 2028) deveria reconfigurar onde você lança primeiro?

---

## Referências (verificadas, com DOI/URL)

1. Rodríguez-Leal et al. (2017) *Cell* 171:470. https://doi.org/10.1016/j.cell.2017.08.030
2. Zsögön et al. (2018) *Nat Biotechnol* 36:1211. https://doi.org/10.1038/nbt.4272
3. Li et al. (2018) *Nat Biotechnol* 36:1160. https://doi.org/10.1038/nbt.4273
4. Yu et al. (2021) *Cell* 184:1156. https://doi.org/10.1016/j.cell.2021.01.013
5. Kelliher et al. (2019, HI-Edit) *Nat Biotechnol* 37:287. https://doi.org/10.1038/s41587-019-0038-x
6. Debernardi et al. (2020, GRF-GIF) *Nat Biotechnol* 38:1274. https://doi.org/10.1038/s41587-020-0703-0
7. Xiang et al. (2021, CRISPRon) *Nat Commun* 12:3238. https://doi.org/10.1038/s41467-021-23576-0
8. Gong (2025, benchmark em plantas, preprint) *bioRxiv*. https://doi.org/10.1101/2025.10.15.679654
9. Doench et al. (2016, Rule Set 2/CFD; via CRISPOR) https://pmc.ncbi.nlm.nih.gov/articles/PMC4934014/
10. Arbab et al. (2020, BE-Hive) *Cell*. https://pmc.ncbi.nlm.nih.gov/articles/PMC7384975/
11. Mathis et al. (2023, PRIDICT) *Nat Biotechnol* 41:1151. https://doi.org/10.1038/s41587-022-01613-7
12. Mathis et al. (2024, PRIDICT2.0) *Nat Biotechnol*. https://doi.org/10.1038/s41587-024-02268-2
13. Ruffolo, Nayfach, Gallagher, Bhatnagar et al. (2025, OpenCRISPR-1) *Nature* 645. https://doi.org/10.1038/s41586-025-09298-z
14. Qu et al. (2025, CRISPR-GPT) *Nat Biomed Eng*. https://doi.org/10.1038/s41551-025-01463-z
15. Mendoza-Revilla et al. (2024, AgroNT) *Commun Biol* 7:835. https://doi.org/10.1038/s42003-024-06465-2
16. (PlantCaduceus, 2025) *PNAS*. https://doi.org/10.1073/pnas.2421738122
17. (PhytoExpr) *PNAS*. https://doi.org/10.1073/pnas.2319811121
18. Jenko et al. (2015, PAGE) *Genet Sel Evol* 47:55. https://doi.org/10.1186/s12711-015-0135-3
19. Johnsson et al. (2019, RAGE) *Genet Sel Evol* 51:14. https://doi.org/10.1186/s12711-019-0456-8
20. Tang et al. (2018, off-target WGS arroz) *Genome Biol* 19:84. https://pubmed.ncbi.nlm.nih.gov/29973285/
21. (ABE8e off-target arroz, preprint) https://doi.org/10.1101/2022.02.09.479813
22. CTNBio RN16/2018 e pareceres Embrapa/GDM: https://croplifebrasil.org/edicao-genetica-e-os-organismos-nao-ogms/ ; https://ctnbio.mcti.gov.br/
23. Argentina Res. 173/2015: https://www.argentina.gob.ar/normativa/nacional/resoluci%C3%B3n-173-2015-246978/texto ; https://doi.org/10.1080/21645698.2015.1114698
24. USA — *Nat'l Family Farm Coal. v. Vilsack* (vacatur SECURE, 02/12/2024) e emenda CFR: https://www.govinfo.gov/content/pkg/FR-2025-06-16/html/2025-10797.htm
25. UE — Regulamento (UE) 2026/1388: https://eur-lex.europa.eu/eli/reg/2026/1388/oj/eng ; https://www.consilium.europa.eu/en/press/press-releases/2025/12/04/
26. China — MARA (2022): https://apps.fas.usda.gov/newgainapi/ (MARA Issues First Ever Gene-Editing Guidelines)
27. Produtos: Sanatech GABA tomato https://sanatech-seed.com/en/20210915-2/ ; Calyxt Calyno https://www.businesswire.com/news/home/20190226006176/en/ ; Pairwise/Bayer https://www.bayer.com/media/en-us/gene-editing-pairwise-and-bayer-start-new-five-year-multi-million-dollar-collaboration-to-further-advance-short-stature-corn/ ; Tropic banana / APHIS https://www.aphis.usda.gov/news/program-update/aphis-finds-12-different-plants-submitted-review-are-not-subject-its ; FDA premarket list https://www.hfpappexternal.fda.gov/scripts/fdcc/index.cfm?set=GenomeEditedPlants
28. IP: Biotechnology Law Report (2022) https://doi.org/10.1089/blr.2022.29275.cmh ; Corteva/Broad https://www.openinnovation.corteva.com/what-we-offer/crispr-cas-growing-more-sustainably.html

*Itens marcados `[VERIFICAR]` no texto: contagem atual de produtos não-OGM na CTNBio; eficiência combinada BBM/WUS+GRF-GIF em trigo (pôster); validação em plantas de OpenCRISPR-1/gLMs; escassez de simulações GS+edição especificamente vegetais.*
