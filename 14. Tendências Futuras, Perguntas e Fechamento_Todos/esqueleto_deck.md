# Sessão 11 — Esqueleto do deck

Gerado de `_slides.json` (mesma fonte de `11_tendencias_futuras.pptx`) por `_build_md.ps1`. 83 slides. Cada slide traz os tópicos da tela e as notas do apresentador. DOIs e tabelas em `dossie/`.

## Slide 1 — Tendências futuras, perguntas e fechamento

**Tópicos**

- FIT 796 · IA no melhoramento de plantas · UFV × Bayer × IDATA
- 5 de novembro de 2026 · 13h30–17h00 · Instrutores: todos
- Sem lab novo: o horizonte 2024–2026, com número e fonte
- Cinco blocos: modelos, moléculas, edição, plataforma, governança
- O detalhe está nas notas do apresentador e na pasta dossie/

**Notas**

Abra dizendo o que esta tarde não é: não é outro exercício de DuckDB, VCU, GBLUP, prompt ou OCS. É o mapa do que vem depois do que eles praticaram, com casos verificados. Avise que cada slide tem nota de apresentador com a citação, e que o dossiê na pasta da sessão tem o texto longo e os DOIs. O critério da aula: número sem fonte não entra no slide; o que ainda está em aberto fica marcado como a verificar nas notas. Peça que guardem uma pergunta por bloco para o painel final. Fontes: README do curso FIT 796.

## Slide 2 — O arco dos três dias

**Tópicos**

- Dia 1: fundamentos, HTP, qualidade de dado, coding com agente
- Dia 2: seleção genômica, ML/DL, LLM em paper, OCS e simulação
- Dia 3: decisão de programa (manhã) e tendências (tarde)
- Filo: dado limpo → agente sob regra → predição honesta → otimização
- A decisão e a responsabilidade ficam com o melhorista

**Notas**

Recapitule em dois minutos o fio que a turma já viveu. Sessão 04 curou o ensaio antes de modelar. Sessão 05 pôs o agente sob deny-list e plano. Sessão 06 mostrou que acurácia sem validação honesta mente. Sessão 08 mostrou alucinação em paper. Sessão 09 mostrou que theta e delta F são decisão humana, não saída de solver. A tarde de hoje estende esse fio: os mesmos critérios de validação, governança e decisão humana valem para foundation model, event, edição e digital twin. Não reabra o conteúdo técnico das sessões anteriores. Fontes: README do repositório do curso.

## Slide 3 — O que esta sessão não repete

**Tópicos**

- 04–05: QC, DuckDB, VCU, Claude Code, governança de dado bruto
- 06: GBLUP, GEBV, validação por família, desafio de acurácia falsa
- 08: estudo de paper com LLM e engenharia de prompt
- 09: OCS, delta F, alocação de parcelas, AlphaSimR
- 10: DSS, ROI e avanço de linhagem — só como âncora, não como reprise

**Notas**

Se alguém esperar outro script, diga isso no primeiro minuto. A função deste slide é gerenciar expectativa. Cada bloco vai citar uma âncora dessas sessões em uma frase e seguir para o que elas não cobriram. O risco pedagógico da tarde é virar revisão. Se a discussão voltar para como rodar quadprog ou lme4, redirecione: qual a implicação para o programa daqui a cinco anos? Fontes: plano da Sessão 11.

## Slide 4 — Mapa: já visto, tendência

**Tópicos**

- 04–05 dado e VCU → plataforma em tempo real e governança em escala
- 06–07 GBLUP e ML → DNA e protein foundation models
- 08 LLM de texto → AgroNT, AlphaFold, design de proteína
- 09 OCS e AlphaSimR → digital twin operacional do programa
- 10 portfólio → events, stacking, edição e moléculas aplicadas
- Agente sob regra → quem assina quando o modelo erra

**Notas**

Leia a tabela como índice da tarde. Cada linha é um bloco. Não explique os termos ainda: AgroNT, twin e stacking serão definidos quando chegarem. O ponto é que nenhuma tendência é órfã do curso. Se o tempo apertar, este slide é o que permite pular um bloco sem perder o mapa. Fontes: plano da Sessão 11.

---

# Bloco 1 — Foundation models além do chatbot

## Slide 5 — Bloco 1 — Foundation models além do chatbot

**Tópicos**

- Apresentador: Kaique · duração ~30 min
- Âncoras: Sessão 02 (modelos/hardware), 07 (ML/DL), 08 (IA generativa e LLMs)
- Escopo: modelos de DNA/RNA, proteínas, visão para fenotipagem e agentes
- Pergunta-guia: modelos treinados em sequências e imagens já ajudam o melhorista?
- Fio condutor: sempre comparar com baseline simples (phyloP, SIFT, GBLUP)

**Notas**

Este bloco abre a sessão de tendências mostrando que os modelos de fundação vão muito além do chatbot. Na Sessão 02 vimos o que é um modelo, como ele é treinado e que hardware exige; na Sessão 07, como ML e DL entram no melhoramento; na Sessão 08, como LLMs apoiam a pesquisa. Agora aplicamos a mesma receita, pré-treino auto-supervisionado em grandes volumes de dados sem rótulo, a sequências de DNA, RNA e proteínas e a imagens de plantas. A pergunta-guia é prática: esses modelos já ajudam o melhorista a tomar decisões melhores, ou ainda são promessa? Vou responder com números verificados nos artigos originais e também com casos em que NÃO houve ganho, porque isso é tão importante quanto os sucessos. O roteiro tem quatro partes: primeiro, como funcionam os modelos de linguagem de DNA e como eles escoram variantes; segundo, os modelos específicos de plantas e o que eles entregam para a seleção genômica; terceiro, modelos de proteína, desenho de receptores de resistência e visão para fenotipagem; quarto, limitações e um roteiro para começar. Peço que acompanhem com olhar crítico, como fizemos na Sessão 06 com validação cruzada e vazamento: todo resultado será comparado com um baseline simples, como phyloP, SIFT ou o próprio GBLUP. No final, deixo três perguntas para discussão em grupo e uma lista curta de mensagens para levar para casa.
Fontes: dossiê dossie/01_foundation_models.md (referências completas com DOI).

## Slide 6 — Anatomia de um modelo de linguagem de DNA (gLM)

**Tópicos**

- Pré-treino auto-supervisionado em DNA bruto, sem rótulos → embeddings reutilizáveis
- Tokens: 1 nt (GPN, PlantCaduceus, Evo) vs 6-mer, vocabulário 4.105 (NT, AgroNT)
- Objetivos: masked LM ~15% (bidirecional) vs autorregressivo (gera sequências)
- Transformer O(n²): ~6 kb de contexto (Dalla-Torre et al., Nat Methods 2024)
- Hyena: 131 kb no Evo e 1 Mb no Evo 2 (Nguyen, Science 2024; Brixi, Nature 2026)
- Caduceus (Mamba): bidirecional e equivariante ao reverso-complemento (Zhai, PNAS 2025)
- Uso: probing (embeddings congelados + XGBoost) ou fine-tuning (IA3 no AgroNT)

**Notas**

Um modelo de linguagem de DNA aprende a gramática do genoma prevendo nucleotídeos escondidos, ou o próximo nucleotídeo, sem nenhum rótulo. Três escolhas de projeto definem o modelo. A primeira é a tokenização. Com um token por nucleotídeo, cada base é uma palavra e a resolução é máxima, o que é essencial para escorar SNPs; é o caso de GPN, PlantCaduceus e Evo. Com 6-mers, como no Nucleotide Transformer e no AgroNT, a sequência fica seis vezes mais curta e cabe mais contexto, mas o genoma é cortado em pedaços arbitrários. A segunda escolha é o objetivo: o masked LM esconde cerca de 15% dos tokens e usa o contexto dos dois lados, o que é ideal para avaliar variantes; o autorregressivo prevê o próximo token e permite gerar sequências novas. A terceira é a arquitetura. O Transformer tem custo quadrático no comprimento da sequência, o que limita o contexto a cerca de 6 kb. Hyena e Mamba escalam quase linearmente: o Evo chega a 131 kb e o Evo 2 a 1 Mb. O Caduceus, base do PlantCaduceus, é uma variante de Mamba bidirecional e equivariante ao reverso-complemento, ou seja, dá a mesma resposta para as duas fitas do DNA. Depois do pré-treino, o modelo é usado de duas formas: probing, que congela o modelo e treina um classificador leve sobre os embeddings, ou fine-tuning, que ajusta os pesos. É o mesmo raciocínio de transfer learning em visão que vimos na Sessão 07.
Fontes: Dalla-Torre et al., Nature Methods 2024; Nguyen et al., Science 2024; Brixi et al., Nature 2026; Zhai et al., PNAS 2025; Mendoza-Revilla et al., Communications Biology 2024.

## Slide 7 — Escore zero-shot de variantes: a razão de log-verossimilhança

**Tópicos**

- Escore = log P(alelo alt) − log P(alelo ref) no mesmo contexto genômico
- Mais negativo ⇒ sítio mais conservado ⇒ mutação provavelmente deletéria
- Zero-shot: nenhum dado rotulado; vale para qualquer espécie com genoma de referência
- GPN supera phyloP e phastCons em Arabidopsis (Benegas et al., PNAS 2023)
- AgroNT: LLR abaixo de GPN e phyloP (Mendoza-Revilla et al., Commun Biol 2024)
- Checagens: stop-gain/splice mais negativos, MAF menor, causais conhecidas
- Baseline obrigatório: phyloP, phastCons, SIFT

**Notas**

Este é o conceito mais útil para o melhorista. Para cada SNP, o modelo calcula a probabilidade do alelo de referência e do alelo alternativo no mesmo contexto, e a diferença dos logaritmos é o escore. Se o modelo espera fortemente a base de referência naquela posição, trocá-la é surpreendente, e o sítio provavelmente está sob restrição evolutiva. Valores mais negativos indicam mutações mais provavelmente deletérias. O ponto forte é ser zero-shot: não precisa de nenhum dado rotulado, então serve para culturas órfãs que têm apenas um genoma de referência. Como saber se funciona? Os artigos usam três checagens. Mutações stop-gain e de sítio de splice devem ter escores mais negativos que as intergênicas. As variantes que o modelo considera deletérias devem ter frequência alélica menor na população. E o escore deve recuperar mutações causais já conhecidas. O GPN superou phyloP e phastCons em Arabidopsis. Já o AgroNT, apesar de ter um bilhão de parâmetros, ficou abaixo de GPN e phyloP na priorização de variantes deletérias em Arabidopsis, superando apenas levemente o phastCons. A moral é que tamanho não garante desempenho e que o baseline de conservação é obrigatório. Quem acompanhou a Sessão 06 vai reconhecer o padrão: um método novo só vale se bater o método simples numa avaliação honesta, com os mesmos dados e sem vazamento entre treino e teste.
Fontes: Benegas, Batra & Song, PNAS 2023; Mendoza-Revilla et al., Communications Biology 2024; Zhai et al., PNAS 2025.

## Slide 8 — Panorama: modelos de DNA e RNA para plantas

**Tópicos**

- GPN (2023): CNN, Arabidopsis + 7 Brassicales; 1º gLM de plantas (PNAS 2023)
- AgroNT (2024): 1 B parâm., 48 espécies, ~6 kb; >10 M mutações em mandioca
- PlantCaduceus (2025): 20–225 M, 16 angiospermas, 512 bp (PlantCAD2: 8.192 bp)
- PDLLMs (2024): 14 espécies, 198 modelos, treináveis em uma RTX 4090 (Mol Plant)
- PlantRNA-FM (2024): 35 M, 1.124 espécies; F1 0,974 em Arabidopsis (Nat Mach Intell)
- Evo 2 (2026): 7 B/40 B, 1 Mb, ~9,3 T tokens de todos os domínios (Nature 2026)
- PlantGFM (2026): Hyena, 64 kb, 12 espécies; gera genes de novo (Adv Sci 2026)

**Notas**

Este slide é um mapa para consulta; não precisam decorar. O GPN, de 2023, foi o primeiro modelo de linguagem de DNA de plantas: uma rede convolucional treinada em Arabidopsis e sete parentes da ordem Brassicales. O número de parâmetros que aparece em revisões, cerca de 65 milhões, ainda está a verificar no artigo original. O AgroNT, da InstaDeep, levou a escala de Transformer às culturas: um bilhão de parâmetros, 48 espécies e um recurso valioso, a mutagênese in silico de mais de dez milhões de mutações em mandioca. O PlantCaduceus volta para modelos menores, de 20 a 225 milhões de parâmetros, com curadoria cuidadosa dos dados; vamos detalhá-lo no próximo slide. Os PDLLMs mostram que dá para treinar e usar modelos de plantas numa única placa de vídeo de consumidor, uma RTX 4090, o que importa para laboratórios brasileiros com orçamento limitado. O PlantRNA-FM trabalha com RNA e anota regiões gênicas com F1 de 0,974 em Arabidopsis, espécie que não estava no pré-treino. Entre os modelos universais, o Evo 2 é o gigante: 40 bilhões de parâmetros, contexto de um milhão de bases e treino em todos os domínios da vida, mas com custo computacional extremo. O PlantGFM, de 2026, gera genes novos de plantas, inclusive NLRs, com atividade transcricional confirmada em Nicotiana benthamiana. A tendência é menos tamanho bruto, mais curadoria e contexto maior.
Fontes: Benegas et al., PNAS 2023; Mendoza-Revilla et al., Commun Biol 2024; Zhai et al., PNAS 2025; Liu et al., Mol Plant 2024; Yu et al., Nat Mach Intell 2024; Brixi et al., Nature 2026; PlantGFM, Adv Sci 2026.

## Slide 9 — Estudo de caso: PlantCaduceus

**Tópicos**

- 16 angiospermas, ~160 milhões de anos; repetições sub-ponderadas (Zhai et al., PNAS 2025)
- Probing só em Arabidopsis → milho: 1,45× a 7,23× sobre o melhor gLM existente
- TIS em milho: 7,23× vs GPN; TTS: 3,75×; CNN+LSTM cai de 0,713 para ~0 (PRAUC)
- Deleteriedade: MAF média 3× menor que phyloP; competitivo com ESM em missense
- Restrição evolutiva em milho: AUC 0,829 e PR-AUC 0,797 com só 20 M de parâmetros
- Recupera W578R em sugary1 (milho doce); 15/19 causais EMS no top 1–10%

**Notas**

O PlantCaduceus, do grupo de Kuleshov e Buckler em Cornell, é o modelo mais relevante para melhoristas hoje. Foi treinado em 16 genomas de angiospermas que somam cerca de 160 milhões de anos de evolução, com sequências repetitivas sub-ponderadas para que o modelo não gaste capacidade aprendendo transposons. O experimento-chave é de transferência: o classificador é treinado apenas com rótulos de Arabidopsis, que é bem anotada, e testado em milho, que o modelo nunca viu no pré-treino. Para sítios de início de tradução, o PlantCaduceus foi 7,23 vezes melhor que o GPN em PRAUC, enquanto um CNN com LSTM supervisionado caiu de 0,713 para quase zero. Esse é o argumento central do transfer learning para espécies pouco estudadas. Na detecção de mutações deletérias, as variantes priorizadas têm frequência alélica média três vezes menor que as priorizadas pelo phyloP, e o desempenho em missense é comparável ao do modelo de proteína ESM. Para restrição evolutiva em milho, com o modelo ajustado em sorgo, a versão de 20 milhões de parâmetros chegou a AUC de 0,829. O caso mais didático é o milho doce: na região do sugary1, o GWAS não separa a variante causal por causa da alta LD, mas o escore zero-shot aponta a mutação W578R. A limitação é a janela de 512 pares de base, parcialmente resolvida no PlantCAD2, que aceita até 8.192.
Fontes: Zhai et al., PNAS 2025 (doi:10.1073/pnas.2421738122); repositório kuleshov-group/PlantCaduceus no GitHub.

## Slide 10 — gLMs na seleção genômica: o veredito honesto

**Tópicos**

- Yang et al. 2017: ponderar por carga deletéria (GERP) → >4,3% em produção de grão
- Heterose de produção de grão: ~1% de ganho; >350 mil sítios deletérios (PLoS Genet 2017)
- Ramstein & Buckler 2022: ponderar SNPs por PNC predita NÃO melhorou em híbridos
- Causa provável: LD extenso (r² > 0,1 em 100 kb) já captura as causais
- Ganho só ao priorizar o top 1%/0,1% mais restrito, e só em produção de grão
- Sem ganho para altura de planta e dias para florescimento (Genome Biol 2022)
- Leitura: prior funcional ajuda de forma condicional; validar sem vazamento (Sessão 06)

**Notas**

Este é o slide mais importante para não vender ilusão. A pergunta natural é: se o modelo identifica variantes deletérias, colocar essa informação no modelo de seleção genômica aumenta a acurácia? A resposta da literatura é: às vezes. Em 2017, Yang e colaboradores, com Buckler entre os autores, usaram escores de conservação GERP num dialelo parcial elite de milho e ponderaram blocos haplotípicos pela complementação de alelos deletérios. A acurácia para produção de grão subiu mais de 4,3%, e a de heterose cerca de 1%. Em 2022, Ramstein e Buckler repetiram a ideia com um preditor de restrição evolutiva muito melhor, e ponderar todos os SNPs não melhorou a predição em painéis híbridos. A explicação provável é o LD extenso: os SNPs do painel já carregam a informação das causais por ligação, então a reponderação não acrescenta nada. Houve ganho apenas para produção de grão, e apenas quando se priorizou o top 1% ou 0,1% dos SNPs mais restritos; para altura e florescimento, nada. Em gado leiteiro, priors funcionais no BayesRC ajudaram na maioria dos cenários, cerca de 66% segundo o resumo do estudo (número a verificar), mas a diferença em relação ao BayesR em geral não foi significativa. Conclusão: o ganho depende de população, caráter e densidade de marcadores, e só vale com validação cruzada sem vazamento, como discutimos na Sessão 06.
Fontes: Yang et al., PLoS Genetics 2017 (doi:10.1371/journal.pgen.1007019); Ramstein & Buckler, Genome Biology 2022 (doi:10.1186/s13059-022-02747-2); Xiang et al., Animal Production Science 2021 (doi:10.1071/an21061).

## Slide 11 — Modelos de proteína: da estrutura à função

**Tópicos**

- AlphaFold2: backbone mediano 0,96 Å RMSD95 no CASP14 (Jumper et al., Nature 2021)
- ESM-2 até 15 B; ESMFold sem MSA, >617 M estruturas (Lin et al., Science 2023)
- AlphaFold3: difusão; proteína + DNA/RNA + ligantes + íons (Abramson, Nature 2024)
- ESM3: 98 B, multimodal; proteína fluorescente a 58% de identidade (Science 2025)
- Boltz-1/Boltz-2: alternativas abertas no estilo do AlphaFold3
- No melhoramento: estrutura de NLRs, efetores e enzimas-alvo de herbicidas

**Notas**

Saindo do DNA para a proteína. O AlphaFold2, de 2021, mudou a biologia estrutural: no CASP14, a acurácia mediana de backbone foi de 0,96 ångström, enquanto o segundo melhor método ficou em 2,8. Para comparação, um átomo de carbono tem cerca de 1,4 ångström de largura. O ESM-2, da Meta, é um modelo de linguagem de proteínas com até 15 bilhões de parâmetros. O ESMFold usa as representações dele para prever a estrutura a partir de uma única sequência, sem alinhamento múltiplo, cerca de uma ordem de grandeza mais rápido que o AlphaFold2, e foi usado em mais de 617 milhões de proteínas metagenômicas. O AlphaFold3, de 2024, troca o módulo de estrutura por um modelo de difusão e prevê complexos inteiros: proteína com DNA, RNA, ligantes e íons. Para nós, isso abre a porta para estudar interações entre efetor e receptor ou entre enzima e herbicida. O ESM3, com 98 bilhões de parâmetros, trabalha com sequência, estrutura e função ao mesmo tempo, e gerou uma proteína fluorescente funcional com apenas 58% de identidade em relação às conhecidas. Boltz-1 e Boltz-2 são alternativas abertas no estilo do AlphaFold3, úteis quando a licença do AF3 é um problema; as citações exatas estão a verificar. Mas atenção: esses números vêm de proteínas bem representadas no PDB, e as de plantas estão sub-representadas, como mostra o próximo slide.
Fontes: Jumper et al., Nature 2021; Jumper et al., Proteins 2021; Lin et al., Science 2023; Abramson et al., Nature 2024; Hayes et al., Science 2025.

## Slide 12 — Alerta: o benchmark de 417 genes de milho

**Tópicos**

- 417 genes clássicos de milho; AF2, AF3, ESMFold, Boltz-1 e Boltz-2 (Haley et al., 2025)
- Sem domínios conservados: confiança 25–43% menor (bioRxiv 2025)
- Proteínas jovens, específicas de milho: confiança bem menor (filostratigrafia)
- Boltz-1 e ESMFold: mais geometria grave (átomos sobrepostos, ângulos improváveis)
- AlphaFold = mais confiável; ESMFold = mais rápido; Boltz = meio-termo
- Mensagem: o enovelamento NÃO está resolvido para proteínas de culturas

**Notas**

Este estudo é o contrapeso do slide anterior e foi feito por pesquisadores do USDA ligados ao MaizeGDB. Eles rodaram cinco preditores, AlphaFold2, AlphaFold3, ESMFold, Boltz-1 e Boltz-2, em 417 genes clássicos de milho, ou seja, genes com função e fenótipo bem conhecidos. O primeiro achado: proteínas sem domínios conservados de sequência ou de estrutura tiveram, em média, confiança de 25% a 43% menor que as que têm os dois tipos de domínio. O segundo: usando filostratigrafia, as proteínas jovens, específicas de milho, tiveram confiança bem menor que as proteínas conservadas entre angiospermas ou eucariotos. Isso preocupa porque genes específicos de linhagem podem estar por trás de características agronômicas únicas. O terceiro: Boltz-1 e ESMFold produziram mais estruturas com problemas graves de geometria, como átomos sobrepostos e ângulos de ligação improváveis, o que inviabiliza o uso posterior em docking ou em desenho de proteínas. Os autores também compararam predições com estruturas experimentais de Arabidopsis, milho, arroz, trigo e soja e encontraram incongruências. A recomendação prática é usar cada ferramenta no seu papel: AlphaFold para confiança, ESMFold para velocidade em proteoma inteiro e Boltz como meio-termo. E sempre olhar a confiança por resíduo antes de tirar conclusões. A frase dos autores resume bem: o enovelamento de proteínas não está resolvido para culturas agrícolas.
Fontes: Haley et al., bioRxiv 2025 (doi:10.1101/2025.07.05.663230).

## Slide 13 — Desenho de proteínas e resistência sob encomenda (Pikobodies)

**Tópicos**

- Fluxo: RFdiffusion (backbone) → ProteinMPNN (sequência) → AF2/ESMFold (checagem)
- ProteinMPNN: recuperação 52,4% vs 32,9% do Rosetta (Dauparas et al., Science 2022)
- RFdiffusion: binders e oligômeros validados em bancada (Watson et al., Nature 2023)
- Pikobodies: HMA do Pikm-1 trocado por nanobody + Pikm-2 (Kourelis et al., Science 2023)
- Resistência a PVX que expressa a proteína fluorescente-alvo: imunidade sob encomenda
- Riscos: autoatividade, alvo precisa estar no citosol, yield drag por NLR superativo

**Notas**

Até aqui falamos de predição; agora, de desenho. O fluxo padrão para desenhar proteínas novas tem três passos. O RFdiffusion, do laboratório de David Baker, gera um backbone novo a partir de ruído, como os modelos que geram imagens, e pode ser condicionado a se ligar a um alvo. O ProteinMPNN escreve uma sequência de aminoácidos que dobre naquele backbone; em backbones nativos, ele recupera 52,4% da sequência, contra 32,9% do Rosetta. Por fim, AlphaFold2 ou ESMFold conferem se a sequência realmente dobra na forma desejada. O caso mais interessante para quem trabalha com resistência é o dos Pikobodies, do grupo de Sophien Kamoun. O receptor de arroz Pikm-1 tem um domínio integrado, o HMA, que reconhece o efetor do fungo da brusone. Os autores trocaram esse domínio por nanobodies de camelídeo que se ligam a proteínas fluorescentes; junto com o Pikm-2, as plantas ficaram resistentes a vírus PVX que expressavam a proteína-alvo. Como é possível gerar nanobodies contra quase qualquer molécula, a ideia é imunidade sob encomenda contra efetores de patógenos. Os riscos são autoatividade do receptor, a necessidade de o alvo estar no citosol, ligação inespecífica e queda de produtividade por superativação do NLR. Exemplos de engenharia de Rubisco ou de tolerância a herbicidas com essas ferramentas ainda estão a verificar. O papel do melhorista começa a mudar de selecionar variação existente para projetar variação nova.
Fontes: Watson et al., Nature 2023; Dauparas et al., Science 2022; Kourelis et al., Science 2023 (doi:10.1126/science.abn4116).

## Slide 14 — Modelos de fundação de visão para fenotipagem (HTP)

**Tópicos**

- SAM: segmentação promptable zero-shot; SA-1B com 1 B máscaras em 11 M imagens (2023)
- DINOv2: ViT auto-supervisionado até 1 B; features sem fine-tuning (Oquab et al., 2023)
- PlantCLEF 2024: ViT-B/14 DINOv2 em ~1,4 M imagens de 7.806 espécies (Pl@ntNet)
- SCOLD: visão-linguagem p/ doença foliar, 186 mil pares imagem-legenda, 97 conceitos
- Receita HTP: backbone congelado + cabeça leve → contagem, área foliar, severidade
- Liga com Sessão 03 (HTP) e 07 (DL supervisionado): menos anotação manual

**Notas**

Os modelos de fundação também mudaram a visão computacional, o que conversa diretamente com a Sessão 03, de fenotipagem de alto desempenho. O SAM, da Meta, segmenta qualquer objeto a partir de um clique ou de uma caixa, sem treino específico; foi treinado com mais de um bilhão de máscaras em 11 milhões de imagens. Na prática, serve para separar folhas, panículas, espigas ou plantas do fundo sem desenhar máscaras à mão. O DINOv2 é um backbone auto-supervisionado que produz features de imagem úteis sem fine-tuning: basta um classificador linear por cima. O desafio PlantCLEF 2024 disponibilizou modelos DINOv2 já ajustados em cerca de 1,4 milhão de imagens de 7.806 espécies de plantas da flora do sudoeste europeu, um ponto de partida melhor que o ImageNet para tarefas botânicas. O SCOLD é um exemplo de modelo de visão e linguagem para doenças foliares, que permite classificar imagens a partir de descrições em texto, com poucos ou nenhum exemplo rotulado. A receita para HTP é a mesma do probing em DNA: backbone congelado e uma cabeça leve treinada com poucas imagens rotuladas. A ordem de grandeza que costuma ser citada, dezenas de imagens em vez de milhares, é ilustrativa e está a verificar para cada caráter e cultura. O ganho real é reduzir o gargalo de anotação manual que discutimos na Sessão 07.
Fontes: Kirillov et al., arXiv 2023 (SAM); Oquab et al., arXiv 2023 (DINOv2); Goëau et al., PlantCLEF 2024, Zenodo; Nguyen Quoc et al., arXiv 2025 (SCOLD).

## Slide 15 — Agentes LLM e modelos multimodais na genômica

**Tópicos**

- BioDiscoveryAgent (Claude 3.5 Sonnet): +21% vs otimização bayesiana em 6 datasets
- +46% na tarefa difícil de genes não-essenciais (Roohani et al., arXiv 2024)
- CRISPR-GPT: sistema, gRNA, entrega, protocolo e análise (Huang et al., bioRxiv 2024)
- Validação: knockout de 4 genes (Cas12a) e ativação de 2 genes (dCas9) em células humanas
- GeneGPT: LLM que consulta as APIs do NCBI (Jin et al., Bioinformatics 2024)
- G2P multimodal: Evo 2 e PlantGFM unem DNA, RNA e proteína; nada maduro em culturas
- Ponte com a Sessão 08: o padrão de agente do Claude Code, agora no laboratório

**Notas**

Na Sessão 08 usamos LLMs como assistentes de escrita e de código e vimos o Claude Code agindo como agente. O mesmo padrão está chegando ao laboratório. O BioDiscoveryAgent, de Stanford, usa o Claude 3.5 Sonnet com ferramentas de busca na literatura, execução de código e um segundo agente crítico para escolher quais genes perturbar em triagens genéticas. Em seis datasets, encontrou em média 21% mais genes relevantes que métodos de otimização bayesiana treinados para a tarefa, e 46% mais na tarefa mais difícil, de genes não-essenciais. Um dos datasets era inédito, o que reduz o risco de o modelo já ter visto as respostas no treino. O CRISPR-GPT, de Stanford e Princeton, guia o desenho de um experimento de edição de ponta a ponta: escolhe o sistema CRISPR, desenha os gRNAs, sugere o método de entrega, escreve protocolos e analisa os dados. Foi validado em linhagens celulares humanas, com knockout de quatro genes por Cas12a e ativação epigenética de dois genes por dCas9. O GeneGPT conecta um LLM às APIs do NCBI; as métricas dele estão a verificar. Sobre modelos multimodais de genótipo para fenótipo: Evo 2 e PlantGFM integram DNA, RNA e proteína, mas ainda não existe um modelo maduro que vá do genoma ao fenótipo de campo em culturas. Esses agentes também ainda não foram validados em plantas em escala.
Fontes: Roohani et al., arXiv 2024 (BioDiscoveryAgent); Huang et al., bioRxiv 2024 (CRISPR-GPT); Jin et al., Bioinformatics 2024 (GeneGPT).

## Slide 16 — Limitações que todo melhorista deve conhecer

**Tópicos**

- Dados: poucos genomas de plantas; poliploidia e TEs inflam a sequência repetitiva
- Custo: AgroNT em TPU v4; PlantRNA-FM >3 semanas em 4 A100 (Frontiers 2025)
- Vazamento: rótulos de benchmark e espécies do pré-treino contaminam o teste
- MPRA: gLMs zero-shot perdem para Enformer e Sei (Tang & Koo, 2024)
- Genoma humano: gLMs em geral não superam baselines não-gLM (Benegas et al., 2025)
- GPN-MSA em variantes codificantes raras: SLP 2,05 vs 7,48 do AlphaMissense
- Interpretabilidade: embeddings opacos; mutagênese in silico ajuda, mas não prova causa

**Notas**

Este é o slide do ceticismo saudável. Primeiro, os dados: temos poucos genomas de plantas de alta qualidade, e muitos são poliploides e cheios de elementos transponíveis. Sequências repetitivas são fáceis de prever, então o modelo pode parecer bom aprendendo transposons em vez de função; por isso GPN e PlantCaduceus sub-ponderam repetições. Segundo, o custo: o AgroNT foi treinado em TPU v4 e o PlantRNA-FM levou mais de três semanas em quatro A100. Usar modelos prontos é barato; treinar do zero não é. Terceiro, vazamento, como na Sessão 06: benchmarks de variantes humanas usam rótulos que às vezes foram definidos com ajuda dos próprios preditores, e a frequência alélica reflete deriva e hitchhiking, não só seleção. Quarto, os gLMs nem sempre ganham. Tang e Koo mostraram que modelos zero-shot, inclusive o Nucleotide Transformer de 2,5 bilhões de parâmetros, foram ruins para prever efeitos de variantes medidos em MPRA, perdendo para Enformer e Sei. A revisão de Benegas e colaboradores conclui que, no genoma humano, gLMs com embeddings congelados geralmente não superam baselines. Para variantes codificantes raras, o GPN-MSA não foi o melhor em nenhum gene. Em plantas o quadro é mais favorável porque há menos dados rotulados, mas a comparação com phyloP é obrigatória. Por fim, a interpretabilidade: embeddings são opacos e a atribuição causal continua difícil.
Fontes: Tang & Koo 2024 (PMC10925287); Benegas et al. 2025 (PMC11275703); GPN-MSA (PMC10592768); estudo de variantes codificantes raras (PMC12552115); Frontiers in Plant Science 2025 (doi:10.3389/fpls.2025.1611992).

## Slide 17 — Como começar amanhã + perguntas para discussão

**Tópicos**

- Hugging Face: AgroNT 1B, PlantCaduceus l20–l32, NT, ESM-2, DINOv2 do PlantCLEF
- Comece por probing: embeddings congelados + XGBoost; fine-tuning só se necessário
- Dados: referência + painel de SNPs com MAF + sítios funcionais rotulados (TIS/splice)
- Piloto: escore zero-shot → phyloP/SIFT → feature em GBLUP/BayesRC → CV sem vazamento
- Q1: em que população o LD não apaga o sinal de um prior vindo de um gLM?
- Q2: um gLM que não bate o phyloP ainda serve? Como testar sem vazamento?
- Q3: que riscos há em levar ao campo NLRs ou genes desenhados por IA?

**Notas**

Como um programa de melhoramento começa amanhã, sem gastar muito? Primeiro, não treine modelo do zero. Baixe modelos prontos do Hugging Face: AgroNT, PlantCaduceus nos tamanhos de 20 a 225 milhões de parâmetros, Nucleotide Transformer, ESM-2 para proteínas e o DINOv2 ajustado do PlantCLEF para imagens. Segundo, comece por probing: extraia embeddings com o modelo congelado e treine um XGBoost ou uma regressão por cima. Uma GPU de 16 a 40 gigabytes deve bastar para escore zero-shot e probing nos modelos menores, valor a verificar para cada modelo. Fine-tuning completo de um modelo de um bilhão de parâmetros exige cluster. Terceiro, os dados mínimos: o genoma de referência da cultura, um painel de SNPs com frequências alélicas para validar os escores e algumas centenas de sítios funcionais rotulados para o probing. O piloto que proponho tem quatro passos: calcular o escore zero-shot de todo o painel; comparar com phyloP, phastCons e SIFT; testar o escore como feature ou prior em GBLUP ou BayesRC, com validação cruzada sem vazamento; e, para resistência, rodar ESMFold ou AlphaFold nos NLRs candidatos. Agora, as perguntas para discussão em grupo. Em que população o LD não apaga o sinal: sequência completa, alelos raros, introgressão de germoplasma exótico? Um gLM que não bate o phyloP ainda serve? E quais riscos agronômicos e regulatórios existem em levar ao campo genes desenhados por IA?
Fontes: cartões de modelo no Hugging Face (InstaDeepAI, kuleshov-group, PlantNet, facebook/esm2); Ramstein & Buckler, Genome Biology 2022; Kourelis et al., Science 2023.

## Slide 18 — Bloco 1 — Take-home

**Tópicos**

- gLMs escoram variantes sem rótulos e transferem entre espécies (Zhai et al., PNAS 2025)
- Curadoria > tamanho: PlantCaduceus (≤225 M) manteve desempenho; AgroNT (1 B) caiu
- Seleção genômica: ganho condicional, >4,3% (Yang 2017) vs nenhum (Ramstein 2022)
- Proteínas: confiança cai 25–43% sem domínios conservados (Haley et al., 2025)
- Desenho (RFdiffusion, ProteinMPNN, Pikobodies): de selecionar para projetar
- Visão: SAM/DINOv2 reduzem anotação em HTP; agentes já desenham experimentos
- Regra de ouro: sempre contra baseline simples e com validação sem vazamento

**Notas**

Para fechar o bloco, cinco mensagens. Primeira: modelos de linguagem de DNA escoram variantes sem nenhum rótulo e, em plantas, transferem conhecimento entre espécies separadas por cerca de 160 milhões de anos, o que é valioso para culturas pouco estudadas. Segunda: tamanho não é tudo. O PlantCaduceus, com no máximo 225 milhões de parâmetros e dados bem curados, manteve o desempenho na transferência entre espécies, enquanto o AgroNT, de um bilhão, e os demais modelos caíram bastante. Terceira: na seleção genômica, o ganho é condicional. Houve mais de 4,3% de ganho em produção de grão em um estudo e nenhum ganho ao ponderar SNPs em outro. A diferença vem de LD, caráter e população, e só uma validação sem vazamento separa uma situação da outra. Quarta: os modelos de proteína são extraordinários para famílias conservadas, mas a confiança cai bastante para proteínas sem domínios e específicas de culturas. Ao mesmo tempo, ferramentas de desenho como RFdiffusion, ProteinMPNN e os Pikobodies mudam o papel do melhorista, de selecionar para projetar. Quinta: na visão, SAM e DINOv2 reduzem o custo de anotação em fenotipagem, e agentes como o BioDiscoveryAgent e o CRISPR-GPT começam a desenhar experimentos. A regra de ouro, que vale para todo o curso, é comparar sempre com um baseline simples e validar sem vazamento. No próximo bloco seguimos com as demais tendências.
Fontes: Zhai et al., PNAS 2025; Yang et al., PLoS Genetics 2017; Ramstein & Buckler, Genome Biology 2022; Haley et al., bioRxiv 2025; Kourelis et al., Science 2023.

---

# Bloco 2 — Moléculas, peptídeos, proteínas e events

## Slide 19 — Bloco 2 — Moléculas, peptídeos, proteínas e events

**Tópicos**

- Palestrante: Vinicius (+ convidado biotech) — duração ~35 min
- Âncora: Agenda FIT 796 — molecules, peptides, events, drugs, proteins
- GS/OCS otimizam alelos que já estão no germoplasma
- Trait technology cria o que ainda não está: molécula, proteína, event
- Pergunta-guia: se a IA acelera a descoberta, por que o trait demora mais?

**Notas**

Abertura do bloco. A turma passou dois dias otimizando o que já existe no germoplasma: GEBV, OCS, alocação de parcelas. Este bloco trata do outro pipeline da indústria de sementes e defensivos, a trait technology. Nele o produto é uma molécula aplicada, um peptídeo, uma proteína expressa na planta ou um event que entra no germoplasma elite por introgressão. A IA entra nos dois lados, mas de formas diferentes: no primeiro, como química e biologia generativas; no segundo, como otimização de pipeline (seleção de events, stacking, look-ahead). Lance a pergunta-guia e deixe-a sem resposta até o slide de economia: o custo de desenvolver um trait caiu, mas o tempo subiu. Isso indica onde a IA move a agulha e onde não move. Avise que o bloco termina com o paralelo com fármacos, para calibrar o que transfere da farma para o campo. Fontes: Agenda FIT 796; AgbioInvestor/CropLife 2022 e 2026.

## Slide 20 — A economia da descoberta: o paradoxo

**Tópicos**

- Defensivo novo: US$ 307 mi e ~11 anos (2020–23) (AgbioInvestor/CropLife 2026)
- Custo por i.a.: US$ 152 mi (1995) → 286 mi (2010–14) → 307 mi (2020–23)
- ~160.000 moléculas triadas por i.a. (52.500 em 1995) (Bayer)
- Trait GM: US$ 136 mi / 13,1 anos (2008–12) (Phillips McDougall 2011)
- Trait GM: US$ 115 mi / 16,5 anos (2017–22) (AgbioInvestor 2022)
- Custo do trait caiu 15%; o tempo subiu 3,4 anos

**Notas**

Este é o slide-âncora do bloco. Os números vêm das séries de estudos que a CropLife encomenda a AgbioInvestor (antes Phillips McDougall), com dados agregados de BASF, Bayer, Corteva, FMC e Syngenta. Para defensivos, o custo por ingrediente ativo dobrou em cerca de 25 anos, e a taxa de sucesso piorou: de 52.500 moléculas triadas por produto em 1995 para cerca de 160.000 hoje, principalmente por exigências de segurança mais estritas. O número de ingredientes ativos lançados por ano caiu de 4 para 1,5. Na repartição de 2020–23, desenvolvimento responde por 45,1%, pesquisa por 43,4% e registro por 11,5%. O paradoxo do trait é a mensagem principal: entre 2008–12 e 2017–22 o custo caiu de 136 para 115 milhões, mas o tempo cresceu de 13,1 para 16,5 anos. Eficiência de P&D não resolve o gargalo regulatório e de mercado. E nenhum desses números inclui o tempo para gerar variedades com traits empilhados, que é o produto comercial real. Fontes: AgbioInvestor/CropLife (2026, 2022); Phillips McDougall (2011); Bayer, Crop Protection Regulatory Process.

## Slide 21 — Onde a IA atua no pipeline

**Tópicos**

- Trait: descoberta US$ 7,6 mi (6,6%) → construção/teste do event US$ 64,2 mi (55,8%)
- Trait: regulatório US$ 43,2 mi (37,6%) — o tempo é dominado por ele
- Defensivo: química de síntese/formulação US$ 75 mi — maior item isolado
- IA de molécula: virtual screening, química generativa, ADMET/ecotox
- IA de decisão: seleção de event, sítio de inserção, agenda de stacking
- Regulatório e campo continuam humanos, lentos e caros

**Notas**

Use este slide como esqueleto mental do bloco. No trait GM, mais da metade do custo está em construir e testar events, exatamente onde ML de seleção de event e otimização de introgressão podem agir. Descoberta é só 6,6% do custo: mesmo que a IA reduza essa fase pela metade, o impacto no custo total é pequeno. No defensivo, o maior item é química de síntese e formulação (US$ 75 mi), alvo direto de química generativa e predição de rota de síntese; ensaios de campo somam US$ 59 mi e não são comprimidos por IA. Peça à turma que guarde a distinção entre IA de molécula (gerar e priorizar candidatos) e IA de decisão (otimizar o pipeline de events e breeding, ponte com a Sessão 09). A consequência para a Sessão 10: o valor da IA em um portfólio está em reduzir atrito, candidatos que falham tarde, e não só em acelerar a fase inicial. Fontes: AgbioInvestor (2022) Time and Cost to Develop a Trait; AgbioInvestor/CropLife (2026).

## Slide 22 — Bayer CropKey: o paradigma fechadura-chave

**Tópicos**

- ML identifica proteínas-alvo exclusivas da praga (fechaduras)
- Virtual screening desenha moléculas (chaves); biblioteca física de 2,6 mi
- Checa in silico ligação a não-alvos, degradação no solo e rota de síntese
- Mais de 30 alvos em estudo; mais de 10 validados como novos MoA (Bayer)
- 2 novos MoA desenhados: fungicida (hortifruti) e herbicida pós-emergente
- Ataca a escassez de modos de ação e a resistência

**Notas**

Estudo de caso corporativo central, do parceiro do curso. A metáfora precisa ser explicada com rigor: a fechadura é uma proteína-alvo que o ML confirma existir no organismo-praga e não em organismos não-alvo; isso dá seletividade e segurança desde o desenho. A chave é a molécula desenhada por virtual screening. O diferencial em relação à triagem clássica é otimizar vários parâmetros ao mesmo tempo, antes de sintetizar: eficácia, seletividade, degradabilidade no solo e custo de síntese. Os números (mais de 30 alvos, mais de 10 MoA validados, 2 MoA desenhados) são declarações públicas da Bayer e devem ser apresentados como resultados de pesquisa inicial, não como produtos registrados. Conecte ao slide de economia: com 1 em 160.000 moléculas chegando ao mercado, qualquer filtro in silico que elimine candidatos ruins cedo tem valor alto. Pergunta para a turma: por que a escassez de novos modos de ação é um problema tão grave quanto o custo? Resistência de plantas daninhas, fungos e insetos cresce mais rápido que o lançamento de novos MoA. Fontes: Bayer, CropKey (bayer.com/en/agriculture/cropkey).

## Slide 23 — Ecossistema de startups: o playbook da farma no campo

**Tópicos**

- Syngenta–Insilico (2021): Chemistry42 em herbicidas; 3 projetos com atividade
- Enko Chem: DNA-encoded libraries + ML; bilhões de moléculas; US$ 150 mi
- Moa Technology: 25 mil compostos/mês; mais de 750 mil triados; mais de 60 MoA
- Micropep: Krisalix gera milhões de micropeptídeos; MPD-01 em campo
- Parceiros recorrentes: Bayer, Syngenta, Corteva, Nufarm
- Padrão: big ag compra acesso a plataformas, não só moléculas

**Notas**

Mostre que não é iniciativa isolada de uma empresa. A Syngenta levou a plataforma de química generativa da Insilico, criada para fármacos, para controle de plantas daninhas; em três projetos a IA apontou novas áreas químicas com atividade in vitro e in vivo. Enko Chem combina bibliotecas codificadas por DNA, bilhões de moléculas triadas em pool, com ML e design estrutural, e tem Bayer, Syngenta e Nufarm como parceiras. Moa Technology, spin-out de Oxford, faz fenotipagem de alto conteúdo em plantas miniaturizadas e usa IA de imagem para comparar fenótipos com herbicidas conhecidos. Micropep gera micropeptídeos com IA generativa; seu MPD-01 teve eficácia de campo igual ou superior a padrões químicos em mais de 25 ensaios, segundo a empresa. Pergunta de discussão: por que uma multinacional prefere parceria com startup a construir internamente? Possíveis respostas: velocidade, acesso a talento de ML, opcionalidade de portfólio. Fontes: Syngenta media release (2021); Enko (PR Newswire); Moa Technology; Micropep.

## Slide 24 — Peptídeos antimicrobianos priorizados por ML

**Tópicos**

- AGRAMP (2024): Random Forest, acurácia 0,72–0,91; validado em Spiroplasma citri
- ~7% de 685.924 peptídeos do genoma de citros previstos como AMP
- Su et al. (2025): 6.706 genomas de Bacillus → 4,99 mi candidatos
- Ensemble BERT/Mamba/CNN; 2 AMPs validados contra Fusarium e Phytophthora
- Ran et al. (JAFC 2025): XGBoost (R² 0,77); peptídeo TP vs F. graminearum a 13,3 μM
- A IA prioriza; a validação molhada é o critério para acreditar

**Notas**

Três estudos revisados por pares, todos com validação experimental. AGRAMP, USDA-ARS e George Mason, usa n-gramas de alfabetos reduzidos de aminoácidos e Random Forest; aplicou o modelo ao genoma de citros e testou um subconjunto contra Spiroplasma citri, agente do citrus stubborn. Su e colaboradores varreram 6.706 genomas de Bacillus no RefSeq, 56 milhões de polipeptídeos de 10 a 100 aminoácidos, e ficaram com a interseção de quatro arquiteturas (BERT, Mamba, CNN-LSTM, CNN-Attention): quase 5 milhões de candidatos, dos quais dois foram validados por dinâmica molecular e ensaio contra bactérias e fungos agrícolas, incluindo Fusarium oxysporum e Phytophthora nicotianae. Ran e colaboradores, no Journal of Agricultural and Food Chemistry de 2025, usaram XGBoost e acharam o peptídeo TP, com supressão quase completa de Fusarium graminearum a 13,33 micromolar; a dinâmica molecular sugere ligação à miosina. A leitura pedagógica: a IA não inventa o peptídeo do zero, ela prioriza candidatos num espaço de milhões de sequências. Sem validação molhada, o número não entra em aula. Fontes: Shao et al. 2024, DOI 10.3389/fmicb.2024.1304044; Su et al. 2025, DOI 10.1186/s40538-025-00751-9; Ran et al. 2025, DOI 10.1021/acs.jafc.5c03429.

## Slide 25 — Peptídeo inseticida no mercado: Vestaron Spear

**Tópicos**

- Ingrediente: GS-omega/kappa-Hxtx-Hv1a, peptídeo de veneno de aranha
- Primeiro registro EPA: 3 fev 2014; IRAC Grupo 32; inibe o SNC do inseto
- Ação de contato, sem sistêmico; intervalo pré-colheita de 0 dias
- Alvos de bula: pulgão, ácaro, tripes, mosca-branca, Drosophila suzukii
- Gargalos: estabilidade (UV, protease), cobertura foliar, custo de produção
- No Brasil a rota muda: aplicado (MAPA) vs expresso na planta (CTNBio)

**Notas**

Spear é o caso comercial consolidado de peptídeo inseticida, com bula pública. O ingrediente ativo é um peptídeo derivado de veneno de aranha funnel-web australiana, registrado pela EPA em fevereiro de 2014, registro 88847-6, 2% de ingrediente ativo, grupo IRAC 32. Atua em canais iônicos do sistema nervoso do inseto, só por contato, sem ação sistêmica e sem efeito sobre ovos: exige cobertura foliar excelente. O perfil toxicológico é favorável a peixes, aves e mamíferos, e o intervalo pré-colheita é zero. Isso é o que torna o peptídeo atraente regulatoriamente. Os gargalos agronômicos são os que a IA de design tenta atacar e ainda não resolve sozinha: proteólise no filoplano, degradação por UV, formulação e custo de síntese de uma cadeia de dezenas de aminoácidos. Bioprodução por fermentação é a rota para viabilidade por hectare. A espécie exata da aranha (Hadronyche versuta) fica como nota a verificar se alguém perguntar. Fontes: EPA Chemical Search, registro 88847-6.

## Slide 26 — Proteínas Bt: vencer resistência redesenhando o receptor

**Tópicos**

- PACE (Badran et al., Nature 2016): Cry1Ac evoluída por mais de 500 gerações
- Liga receptor TnCAD que o tipo selvagem não reconhece (Kd 11–41 nM)
- Letalidade até 335 vezes maior contra Trichoplusia ni resistente a Cry1Ac
- ML/AlphaFold prioriza variantes; datasets agrícolas são pequenos (~200)
- Vip3Ca: engenharia racional, sem ML, elevou toxicidade até 12,3 vezes
- Durabilidade exige vários modos de ação, não uma toxina só

**Notas**

O trabalho de PACE é evolução dirigida contínua, não machine learning, e por isso é o marco certo para calibrar o que a IA promete depois. Badran e colaboradores evoluíram Cry1Ac para ligar uma caderina de Trichoplusia ni que o tipo selvagem não reconhece, com afinidade nanomolar e letalidade até 335 vezes maior contra populações resistentes. A prova é biológica: dá para vencer resistência redesenhando a ligação ao receptor. O ML entra na etapa seguinte, priorizando quais variantes testar quando a biblioteca é grande e o dado experimental é escasso. Cite MULTI-evolve, do Arc Institute, treinado em cerca de 200 variantes, como exemplo de modelo que funciona com pouco dado. Vip3Ca mostra que engenharia racional clássica, sítios de clivagem e afinidade de membrana, já entrega até 12,3 vezes de toxicidade sem ML. A magnitude de redução de 80% nos ciclos experimentais, citada em revisões, fica só nas notas como a verificar. Feche com manejo: uma toxina redesenhada continua sujeita a resistência; o valor está no plano de múltiplos modos de ação. Fontes: Badran et al. 2016, Nature (PMC4865400).

## Slide 27 — RNAi e enzimas: o trait como molécula desenhada

**Tópicos**

- SmartStax PRO (MON 87411): dsRNA DvSnf7 + Cry3Bb1 + CP4 EPSPS
- EPA do PIP em jun/2017; China jan/2021; lançamento nos EUA em 2022
- 3 modos de ação contra Diabrotica; 6 no total com os traits de parte aérea
- FG72: uma troca (W336) na HPPD de Pseudomonas dá tolerância a isoxaflutol
- Calantha (GreenLight): dsRNA foliar ledprona, EPA dez/2023, 4 g/acre
- Especificidade de sequência é o que torna o desenho computacional natural

**Notas**

Dois exemplos em que o produto comercial é literalmente uma sequência desenhada. No SmartStax PRO, o event MON 87411 expressa um dsRNA que silencia Snf7, gene de sobrevivência da larva de Diabrotica, mais Cry3Bb1 e tolerância a glifosato. A especificidade é de sequência: a planta, humanos e outros insetos não têm o alvo. Cronologia útil para a Sessão 10: registro EPA em junho de 2017, aprovação de importação da China em janeiro de 2021, lançamento nos EUA em 2022. São três modos de ação contra rootworm e seis no produto completo, estratégia explícita de manejo de resistência. FG72 é o caso de engenharia de proteína mais limpo: uma única troca de aminoácido, W336, na HPPD de Pseudomonas fluorescens torna a enzima insensível ao isoxaflutol. Calantha leva o RNAi para fora da planta: dsRNA aplicado na folha da batata, registrado pela EPA em dezembro de 2023, dose de 4 gramas por acre. Pergunta: o que muda para o melhorista quando o trait é uma sequência curta e específica, e não um transgene de proteína grande? Fontes: EPA (MON 87411; Calantha); CFIA DD2012-91 (FG72).

## Slide 28 — Pikobodies: imunidade programável

**Tópicos**

- NLR de arroz Pikm-1/Pikm-2; domínio HMA trocado por nanobody (Science 2023)
- O nanobody reconhece uma proteína; o NLR dispara a morte celular
- Resistência a PVX que expressa a proteína-alvo, comparável ao gene Rx
- Prova de conceito com alvo artificial (proteína fluorescente), não produto
- Próximo passo de IA: AlphaFold 3 e RFdiffusion desenham o domínio de ligação
- Durabilidade continua aberta: o patógeno também evolui

**Notas**

Slide conceitual. Kourelis e colaboradores, na Science de 2023, pegaram o par de NLR de arroz que reconhece efetores do fungo da brusone e trocaram o domínio integrado HMA por nanobodies de camelídeo, que podem ser levantados contra quase qualquer molécula. A fusão dispara imunidade quando a proteína-alvo está presente e conferiu resistência a um vírus de planta que expressa essa proteína, com desempenho comparável ao gene R nativo Rx em Nicotiana benthamiana. É prova de conceito com alvo artificial, proteína fluorescente, não um produto de campo. O gancho de IA é direto e deve ser dito com essa ressalva: AlphaFold 3 e o pipeline RFdiffusion mais ProteinMPNN podem desenhar o domínio de reconhecimento sob medida. A pergunta que a turma deve levar é de durabilidade. Um receptor programável contra um efetor de hoje vira vulnerável assim que o patógeno muda o efetor. Qual é o análogo do refúgio nesse desenho? Fontes: Kourelis et al. 2023, Science, DOI 10.1126/science.abn4116.

## Slide 29 — Event não é gene: seleção e caracterização

**Tópicos**

- Event = uma inserção: locus, arranjo, cópias e expressão definidos
- O mesmo cassete em outro locus é outro event, outro dossiê, outro IP
- Gates: sítio neutro, cópia única, sem backbone, expressão estável, herança
- 6.204 unidades triadas por trait (2008–12), contra 1.638 antes de 2002
- FG72: HPPD de 38,4 μg/g na folha V4 a 5,8 μg/g na raiz (dossiê CFIA)
- ML prioriza quais events passam no gate molecular

**Notas**

Defina event com precisão, porque a turma mistura trait, gene e event. Um event é o produto de uma inserção específica. Ter o gene não é ter o event: outro locus significa outro identificador OECD, outro dossiê e outro valor de propriedade intelectual. A seleção de event olha sítio de inserção, número de cópias, integridade do inserto, ausência de backbone, estabilidade de expressão entre gerações e ambientes, e herança mendeliana. O número de unidades triadas por trait entregue subiu de 1.638 antes de 2002 para 6.204 em 2008–2012: virou um problema de dados em escala, que é onde a classificação por ML cabe. Use o dossiê do FG72 para mostrar o nível de detalhe exigido: a proteína HPPD medida em microgramas por grama, folha V4 38,4, V6 35,8, V8 27,2, caule 16,6, raiz 5,81. O ML não substitui essa caracterização; ele decide quais events merecem o ensaio caro. Fontes: Phillips McDougall (2011); CFIA DD2012-91.

## Slide 30 — Stacking é otimização de pipeline

**Tópicos**

- MTI (Peng et al. 2014): 15 events num híbrido de milho, 8 na fêmea e 7 no macho
- Meta: 96,7% do recorrente; menos de 8 cM de doador; ~1 cM de linkage drag
- 5 retrocruzamentos: população 600 (BC1–BC3) e 400 (BC4–BC5)
- Look-ahead (Moeinizade 2019): GEBV do melhor descendente no prazo T
- Designed diversity (Trends Plant Sci. 2026): sucesso × elite × tempo × custo
- É o mesmo tipo de problema da OCS da Sessão 09, com event e prazo

**Notas**

Ponte explícita com a Sessão 09. Peng e colaboradores simularam a conversão de um híbrido de milho para 15 events transgênicos, oito no parental fêmea e sete no macho. A meta é recuperar pelo menos 96,66% do genoma do recorrente, no máximo 120 cM de germoplasma do doador num genoma de 1.788 cM, com menos de 8 cM por conversão e cerca de 1 cM de linkage drag na janela de 20 cM ao redor do event. A solução simulada usa cinco gerações de retrocruzamento assistido, populações de 600 e depois 400, intensidade de seleção 0,01. A Parte III mostra que cinco versões de cada parental e 25 híbridos testados dão mais de 95% de chance de recuperar o desempenho do híbrido original, dentro de 3%. Look-ahead selection, de Moeinizade e colaboradores em 2019, formaliza a função-objetivo como o GEBV esperado do melhor descendente no prazo T, ajustando seleção, acasalamento e alocação. Designed diversity, Trends in Plant Science de 2026, junta isso a pan-genoma, speed breeding e edição. A frase para a turma: vocês já formularam esse problema na Sessão 09; aqui as variáveis incluem events e prazo regulatório. Fontes: Peng et al. 2014, DOI 10.1007/s11032-013-9936-7; Moeinizade et al. 2019, DOI 10.1534/g3.118.200842; Yadav et al. 2026, DOI 10.1016/j.tplants.2026.04.003.

## Slide 31 — Brasil, e o que a farma não transfere

**Tópicos**

- CTNBio, 2024: 134 events de cultivo (65 milho, 25 algodão, 24 soja, 1 feijão)
- Intacta 2 Xtend: 4 events; cultivo no Brasil 2018, lançamento jun/2021
- Três anos entre aprovação local e lançamento: China 2020, UE 2021
- Farma: rentosertib (IA) fase 2a, FVC +98 mL vs −20 mL placebo (Nat Med 2025)
- Transfere: química generativa e design de proteína
- Não transfere: eficácia de campo, custo por hectare, abelhas, dossiê

**Notas**

Feche o bloco com dois aterrissamentos. Brasil: o relatório USDA FAS de 2025, citando a CTNBio, conta 134 events aprovados para cultivo em 2024, sendo 65 de milho, 25 de algodão, 24 de soja, 10 de eucalipto, 7 de cana, 2 de trigo HB4 e 1 de feijão da Embrapa, o primeiro GM integralmente público. A base ISAAA lista 155, mas inclui importação e alimentação: não misture os denominadores. Intacta 2 Xtend é um stack de quatro events; o cultivo foi aprovado no Brasil em 2018 e o lançamento comercial só ocorreu em junho de 2021, depois da China em junho de 2020 e da União Europeia em janeiro de 2021. Três anos de capital parado por aprovação de mercado importador, e isso nem entra nos 16,5 anos do estudo AgbioInvestor. Na farma, rentosertib é o caso mais maduro de molécula de IA em clínica: fase 2a, capacidade vital forçada de mais 98,4 mL contra menos 20,3 mL no placebo. Isomorphic, dona do AlphaFold 3 junto com a DeepMind, captou 600 milhões de dólares em 2025 e até meados daquele ano ainda não tinha ensaio em humanos. O que transfere é a química generativa. O que não transfere é eficácia de campo, custo por hectare, seletividade a abelhas e o relógio regulatório. Fontes: USDA FAS BR2025-0043; Nature Medicine 2025, DOI 10.1038/s41591-025-03743-2.

## Slide 32 — Bloco 2 — Take-home

**Tópicos**

- A IA comprime descoberta; o relógio do trait é regulatório e de campo
- Peptídeo e proteína: priorização por ML só vale com ensaio molhado
- Event é unidade de IP, dossiê e logística — não é ter o gene
- Stacking é o mesmo problema da OCS, com prazo e linkage drag
- GS otimiza o alelo que existe; design amplia o menu do que pode entrar
- Pergunta: o próximo ganho de sanidade é genética ou molécula aplicada?

**Notas**

Recapitule as cinco frases e devolva a pergunta-guia. Se a IA cortasse a descoberta pela metade, o tempo total do trait ainda seria dominado pelos 16,5 anos, dos quais o regulatório é a maior fração. O investimento racional, portanto, é em reduzir atrito tardio e em otimizar a conversão e o stacking, não só em gerar mais candidatos. Peça uma resposta rápida da sala à última pergunta, genética da planta ou molécula aplicada, e use-a como gancho para o bloco de edição: a edição é uma terceira via, escrever o alelo sem necessariamente criar um event transgênico clássico. Indique o dossiê 02 para quem quiser os DOIs. Fontes: dossiê/02_moleculas_peptideos_events.md.

---

# Bloco 3 — IA + edição gênica

## Slide 33 — Bloco 3 — IA + edição gênica

**Tópicos**

- Palestrante: Rodrigo — duração ~30 min
- Pergunta-guia: quando editar supera selecionar?
- Edição = espectro quantitativo, não só nocaute
- IA em 4 frentes: desenho, enzimas, alvos, agentes
- Ganho PAGE sobre GS: 1,08×–4,12× (Jenko 2015)
- Fio: arquitetura, efeito, variante causal, custo

**Notas**

Slide de abertura do bloco. Posicione a edição de genoma como extensão — não substituição — do arcabouço quantitativo que a turma já domina de seleção genômica (Sessão 06) e OCS (Sessão 09). A seleção genômica move a média deslocando frequências alélicas por recombinação e seleção; a edição escreve o alelo diretamente, saltando a espera recombinacional. Mas isso só é vantagem quando há causalidade conhecida e efeito relevante. Apresente as quatro frentes de IA (desenho de guias/editores, engenharia de enzimas, descoberta de alvos, agentes LLM) para ancorar os próximos 12 slides. Use os números do PAGE (1,08× a 4,12× sobre GS pura) como gancho quantitativo, prometendo rigor, mas antecipe o custo de endogamia que conecta de volta ao OCS. Deixe claro o critério de verificação: toda afirmação numérica no corpo tem fonte primária; números voláteis ou de preprint ficam só nas notas, marcados 'a verificar'. A pergunta-guia (quando editar supera selecionar?) deve ser repetida no fechamento. Convide a turma a, durante a aula, pensar no próprio caráter-alvo. Fontes: Jenko et al. 2015 (GSE, 10.1186/s12711-015-0135-3); Sessões 06 e 09 do curso.

## Slide 34 — Caixa de ferramentas: nucleases, base, prime

**Tópicos**

- Cas9 (PAM NGG, corte rombo) vs Cas12a (PAM-T, multiplex nativo)
- SDN-1 (indel/KO): via regulatória mais limpa, sem transgene
- SDN-2/3: substituição e inserção dirigida (gargalo em planta)
- CBE (C→T) e ABE (A→G): transições sem quebra
- Prime editing: as 12 trocas + indels curtos, sem doador
- Escolha = traço × precisão × eficiência × regulação

**Notas**

Percorra o espectro do menos ao mais preciso, correlacionando cada ferramenta a um uso de melhoramento. SDN-1 cobre a maioria dos alelos de domesticação (perda de função) e é a rota regulatória mais favorável porque o produto final não contém DNA exógeno. Editores de base recriam SNPs favoráveis conhecidos sem recombinação — ideal quando a variante causal é um ponto, mas atenção aos bystander edits na janela de atividade. Prime editing é o canivete suíço (todas as transições/transversões e pequenos indels, sem quebra nem molde doador), porém a eficiência em plantas ainda é inferior à das nucleases. Destaque o Cas12a pelo multiplex nativo: processa seu próprio array de crRNA, o que importa para poliploides e para editar vários QTN de uma vez. Conclua com a heurística de escolha: defina primeiro a edição biológica desejada (nocaute? troca de base? inserção?), depois escolha a ferramenta com melhor eficiência comprovada naquela espécie, e só então verifique o enquadramento regulatório. Isso evita o erro comum de escolher a tecnologia da moda antes de definir o problema. Fontes: revisões de base/prime editing; Anzalone/Komor (editores); documentação de Cas12a; Seção 1 do dossiê.

## Slide 35 — Edição cis-regulatória e variação quantitativa

**Tópicos**

- Rodríguez-Leal 2017 (Cell): 8 gRNAs no promotor SlCLV3 (~2 kb)
- Gera série alélica contínua de lóculos, fruto e arquitetura
- Fenótipo NÃO previsível por mudança transcricional
- 'Dial' quantitativo de rendimento vs liga/desliga do KO
- Aplica a genes de desenvolvimento (fruto, inflorescência)
- Implicação: fenotipar o espectro; IA prioriza, não dispensa campo

**Notas**

Este é o slide conceitualmente mais importante para melhoristas quantitativos. A ideia revolucionária de 2017 foi gerar variação quantitativa nova sob demanda, editando regiões regulatórias em vez de esperar mutações raras em QTL. Mostre que isso cria um gradiente de alelos — um reostato para traços de rendimento — em contraste com o nocaute binário. O achado contraintuitivo (a magnitude da mudança transcricional não prediz o efeito fenotípico) é um alerta metodológico central: não se pode substituir a fenotipagem por predição molecular. Conecte adiante com a Seção de descoberta de alvos: é exatamente aqui que os modelos de linguagem genômica e a mutagênese in silico entram, prometendo estreitar a série alélica antes da bancada, mas ainda exigindo validação de campo. Peça à turma que relacione isso com seus próprios caracteres poligênicos: quais teriam QTL regulatórios editáveis para ajuste fino? Termine amarrando ao conceito de arquitetura genética que decidirá, no slide de decisão, editar versus selecionar. Reforce que o poder dessa abordagem está no ajuste quantitativo fino, impossível com introgressão de alelos naturais discretos. Fontes: Rodríguez-Leal et al. 2017 (Cell 171:470, 10.1016/j.cell.2017.08.030).

## Slide 36 — Domesticação de novo + HI-Edit

**Tópicos**

- Zsögön 2018: 6 loci em S. pimpinellifolium → +3× fruto, +10× nº, +500% licopeno
- Li 2018: SP/SP5G/CLV3/WUS/GGP1, mantém resistência e tolerância a sal
- Yu 2021 (Cell): arroz alotetraploide O. alta domesticado de novo
- HI-Edit (Kelliher 2019): edita elite via indutor de haploide
- Progênie haploide editada sem maquinaria → entra direto em DH
- Eficiência HI-Edit em milho ~3–4%

**Notas**

A domesticação de novo inverte a lógica clássica: em vez de introgredir traços de produtividade em germoplasma elite (perdendo diversidade), parte-se de um selvagem robusto e instalam-se os alelos de domesticação. Destaque os números de Zsögön (3×, 10×, 500%) como prova de que poucos loci de grande efeito capturam boa parte do fenótipo domesticado, porque muitas mudanças de domesticação são monogênicas. Li et al. reforçam que resistência a doença e tolerância a sal do parental são preservadas — o grande atrativo frente à introgressão. Yu 2021 estende a prova para poliploide e cereal, sinalizando viabilidade além de dicotiledôneas modelo. HI-Edit resolve o problema prático de como editar a elite que não se transforma: a edição viaja no pólen indutor e é eliminada, entregando um haploide editado que entra direto no pipeline de duplo-haploide, colapsando ciclos e sinergizando com speed breeding. Ressalte a eficiência modesta (cerca de 3 a 4 por cento) como gargalo atual, conectando ao próximo slide sobre regeneração. Fontes: Zsögön et al. 2018 (nbt.4272); Li et al. 2018 (nbt.4273); Yu et al. 2021 (Cell, 10.1016/j.cell.2021.01.013); Kelliher et al. 2019 (nbt, s41587-019-0038-x).

## Slide 37 — Gargalo real: entrega e regeneração

**Tópicos**

- O limite costuma ser transformar/regenerar, não a enzima
- BBM/WUS2: altas frequências em milho antes recalcitrante
- GRF4–GIF1 (Debernardi 2020): trigo 65,1% vs 8,3% (7,8×)
- Sem citocinina exógena; plantas férteis; 30 editadas no gene Q
- Reguladores morfogênicos ampliam genótipos editáveis
- Quando falha, HI-Edit contorna a transformação estável

**Notas**

Melhoristas frequentemente subestimam que o rendimento de um programa de edição é dominado pela etapa de cultura de tecidos. Explique que reguladores morfogênicos (fatores de desenvolvimento) reprogramam células para regenerar, destravando genótipos elite antes intratáveis — o que importa porque editar um genótipo-modelo e depois introgredir anularia a vantagem da edição. Os números de GRF4-GIF1 (regeneração 7,8 vezes maior, dispensa de citocinina permitindo seleção sem marcador) são concretos e memoráveis. Mencione o trade-off: expressão persistente de BBM/WUS2 pode causar defeitos de desenvolvimento, por isso se usam estratégias de excisão ou expressão transitória. Para poliploides e culturas órfãs, essa é a fronteira que define se a edição é sequer possível. Conecte com o slide anterior: quando a regeneração ainda falha, HI-Edit contorna a transformação estável. Encerre enquadrando regeneração como área onde ganhos de engenharia têm alto retorno para o programa, às vezes maior do que otimizar a própria nuclease. Combinações de BBM/WUS com GRF-GIF em trigo relatam eficiências ainda maiores, mas o dado vem de resumo de congresso e deve ser tratado como preliminar (a verificar). Fontes: Debernardi et al. 2020 (nbt, s41587-020-0703-0); literatura de BBM/WUS2.

## Slide 38 — IA para desenhar a edição

**Tópicos**

- On-target: CRISPRon R≈0,80 > DeepHF/DeepSpCas9 ~0,73–0,74 > Azimuth 0,56
- Plantas: Gong 2025 (bioRxiv) — ML correlaciona com indels in planta
- Off-target: CFD (AUC 0,91) > MIT (0,87) + sequenciamento dirigido
- Base/prime: BE-Hive R≈0,9 (genótipo); PRIDICT R=0,85/0,78
- PRIDICT escore >70 vs <70: 12× in vitro / 10× in vivo
- Escore = prior relativo p/ ranquear guias, não garantia de %

**Notas**

Organize por tarefa: escolher guia eficiente, evitar off-target, prever resultado de base/prime. Enfatize a ressalva de transferência: a maioria dos modelos nasceu em células humanas, com cromatina diferente, então o preprint de 2025 em plantas é a evidência mais relevante — e mostra que, apesar da origem, vários modelos ranqueiam bem guias in planta. O ponto crítico a martelar: esses escores são comparativos (ordem de teste), não absolutos; entrega, genótipo e estado de cromatina não são entradas do modelo. Para base e prime editing, os altos coeficientes do BE-Hive e do PRIDICT mostram que prever o produto da edição é hoje bastante confiável, útil para evitar bystander e escolher pegRNAs eficientes. O exemplo do PRIDICT (pegRNAs acima de 70 editam de 10 a 12 vezes mais) é prático e memorável. Conclua com a prática recomendada: usar IA para reduzir o espaço de guias e pegRNAs, validar off-targets por sequenciamento dirigido, e nunca pular a confirmação experimental. Isso prepara o slide seguinte (engenharia de enzimas) e o de riscos (caixa-preta). O dado do benchmark em plantas é de preprint não revisado (a verificar). Fontes: Xiang et al. 2021 CRISPRon (s41467-021-23576-0); Gong 2025 (bioRxiv 10.1101/2025.10.15.679654); Doench 2016 (CFD); Arbab 2020 (BE-Hive); Mathis 2023 (PRIDICT, s41587-022-01613-7).

## Slide 39 — OpenCRISPR-1 + CRISPR-GPT

**Tópicos**

- OpenCRISPR-1 (Profluent; Nature 2025): pLM em >1M óperons CRISPR
- 4,8× a diversidade natural de famílias Cas
- On-target 56,4% vs 47,1% (SpCas9); 95% menos off-target
- ~400 mutações distante do SpCas9; compatível com base editing
- CRISPR-GPT (Nat. Biomed. Eng. 2025): agente LLM, 288 casos
- Validado em bancada: KO Cas12a e ativação dCas9

**Notas**

Mostre a mudança de paradigma: até aqui a IA otimizava o uso de enzimas naturais; agora gera proteínas funcionais inexistentes na natureza. OpenCRISPR-1 é a prova — centenas de mutações distante do SpCas9, com off-target drasticamente menor, o que tem apelo regulatório óbvio (menos efeitos não-intencionais). Discuta a implicação para propriedade intelectual: enzimas desenhadas de novo podem contornar o emaranhado de patentes do Cas9, tema do slide de IP. CRISPR-GPT representa a outra ponta: agentes que democratizam o desenho de experimentos, decompondo tarefas e integrando ferramentas, validados em bancada real com nocaute por Cas12a e ativação epigenética por dCas9. Para a turma, o duplo recado é oportunidade e cautela: poder de desenho sem precedentes, mas crescente dependência de modelos opacos. Antecipe a tensão regulatória — um editor cuja sequência e cujo alvo foram ambos sugeridos por IA desafia a rastreabilidade do racional que a CTNBio e outros reguladores exigem. Note que a validação desses editores desenhados por IA foi feita em células humanas; a eficácia em plantas ainda é incipiente e deve ser tratada como promissora, porém não comprovada (a verificar). Fontes: Ruffolo, Nayfach, Gallagher, Bhatnagar et al. 2025 (Nature, 10.1038/s41586-025-09298-z); Qu et al. 2025 (Nat Biomed Eng, s41551-025-01463-z).

## Slide 40 — Descoberta do alvo: qual alelo escrever

**Tópicos**

- gLMs de plantas: AgroNT (48 spp.), PlantCaduceus (16 spp.)
- AgroNT: mutagênese in silico de saturação em mandioca (>10M mutações)
- PlantCaduceus: splice +1,45×, TIS +7,23×; deletérias com MAF 3× menor
- Fine-mapping + pan-genoma/SV + efeito de variante → lista editável
- PhytoExpr: desenho racional e de novo de sequências cis-regulatórias
- Limite: epistasia, pleiotropia e GxE exigem fenotipagem

**Notas**

Este é o elo que muitos cursos ignoram: a edição só é poderosa se soubermos o alvo causal. Explique o pipeline: GWAS e fine-mapping entregam candidatos estatísticos; pan-genomas e variantes estruturais revelam alelos ausentes do genoma de referência; os modelos de linguagem genômica pontuam o efeito funcional em modo zero-shot, filtrando o que vale editar. Os números do PlantCaduceus (transferência para milho a 160 milhões de anos de divergência) são impressionantes e mostram que a conservação evolutiva aprendida generaliza entre espécies, útil para culturas sem dados próprios. A mutagênese in silico de saturação do AgroNT em mandioca (mais de 10 milhões de mutações) é o exemplo mais tangível de desenhar a série alélica de promotor por computador, conectando ao slide de edição cis-regulatória e ao achado de que transcrição não prediz fenótipo. Seja honesto sobre limites: epistasia, pleiotropia e GxE não são bem capturados, então a fenotipagem permanece obrigatória. Conecte ao slide de decisão: a existência de variante causal conhecida é um critério-chave para escolher editar em vez de selecionar. Ressalve que a validação funcional desses modelos ainda é restrita a poucas culturas (a verificar). Fontes: Mendoza-Revilla et al. 2024 AgroNT (s42003-024-06465-2); PlantCaduceus 2025 (PNAS 10.1073/pnas.2421738122); PhytoExpr (PNAS 10.1073/pnas.2319811121).

## Slide 41 — Integração com GS: PAGE (Jenko 2015)

**Tópicos**

- Simulação: 10.000 QTN, 20 gerações; GS+PAGE 1,08×–4,12× vs GS pura
- 1 QTN/touro, todos 25: 1,08× | 20 QTN/touro, todos 25: 2,00×
- Top 5 touros, 500 edições/ger: 4,12× | espalhado (25): 2,00×
- Geração 20 absoluta: GS 10,07 vs GS+PAGE 20,09 unidades
- Ganho marginal decai; maior nos primeiros ciclos
- Concentrar edições → mais resposta E mais endogamia → OCS

**Notas**

Traga o rigor quantitativo que a turma espera. Explique PAGE (promotion of alleles by genome editing): editar alelos favoráveis de QTN nos melhores reprodutores, por cima da seleção genômica. Os números mostram que concentrar recursos de edição nos indivíduos de maior mérito genético maximiza resposta (4,12 vezes editando 500 QTN por geração nos 5 melhores touros) mas é também o que mais infla parentesco — exatamente o trade-off que o OCS da Sessão 09 gerencia. Contraste com espalhar as mesmas 500 edições por todos os 25 touros, que rende apenas 2,00 vezes. Use os valores absolutos da geração 20 (10,07 contra 20,09) para tornar concreto o dobro de resposta. Destaque o decaimento marginal: como os QTN de maior efeito se fixam primeiro, cada edição adicional rende menos; isso responde a pergunta quantas edições valem a pena — poucas de grande efeito, não centenas de pequeno efeito. Ressalve que esses resultados são de gado; para plantas os princípios valem, mas simulações GS mais edição especificamente vegetais ainda são escassas, um bom tema de pesquisa para a turma (a verificar). Feche com a síntese estratégica: editar grande efeito, GS no fundo poligênico, OCS para endogamia. Fontes: Jenko et al. 2015 (GSE 47:55, 10.1186/s12711-015-0135-3); Johnsson et al. 2019 RAGE (s12711-019-0456-8).

## Slide 42 — Produtos reais no mercado

**Tópicos**

- Tomate alto-GABA (Sanatech, Japão): 4–5× GABA, 1ª comida CRISPR, 15/09/2021
- Óleo soja Calyno (Calyxt, TALEN): ~80% oleico, 1ª editada nos EUA, fev/2019
- Mostarda Conscious Greens (Pairwise): 1ª comida CRISPR nos EUA, mai/2023
- Milho ceroso (Corteva, deleção Wx-1): não-regulado USDA
- Bayer–Pairwise: milho 30–40% mais baixo; parceria 5 anos (29/08/2023)
- Banana não-escurecedora (Tropic): APHIS 14/11/2023

**Notas**

Use esta tabela para aterrissar a teoria em produtos concretos que a turma pode encontrar ou já consumiu. Ordene cronologicamente para mostrar a maturação do campo: o óleo Calyno (2019, via TALEN, não CRISPR) foi a primeira comida editada vendida nos EUA; o tomate alto-GABA da Sanatech (2021) foi a primeira comida CRISPR vendida no mundo; a mostarda da Pairwise (2023) a primeira comida CRISPR dos EUA. Destaque a colaboração Bayer-Pairwise como exemplo de pipeline comercial de grande escala: a parceria inicial, encerrada em junho de 2023, transferiu 27 traços aos programas da Bayer, incluindo milho com cerca de 20 por cento mais fileiras de grãos, e a nova fase foca milho de baixa estatura (30 a 40 por cento menor) para o sistema Preceon. Mencione o lado brasileiro: a Embrapa teve soja com lectina silenciada (cultivar BRS 537) aprovada como não-OGM pela CTNBio em setembro de 2022, e a GDM teve soja tolerante à seca aprovada em maio de 2022. Conecte ao próximo slide: o que torna esses lançamentos viáveis é a classificação regulatória. Fontes: Sanatech (sanatech-seed.com); Calyxt/BusinessWire 2019; Pairwise/Bayer 2023 (bayer.com); APHIS 2023; pareceres CTNBio/Embrapa.

## Slide 43 — Regulação e cronograma do programa

**Tópicos**

- Brasil RN16/2018 (CTNBio): caso a caso; não-OGM se sem transgene
- Até ago/2022: 32 produtos aprovados como não-OGM no Brasil
- Argentina Res. 173/2015: 1º marco do mundo, prazo 60 dias (CONABIA)
- EUA SECURE rule vacatada em 02/12/2024 → incerteza aumentou
- UE: Reg. 2026/1388, NGT1 vs NGT2, aplicável só a partir de 2028
- China (MARA, 24/01/2022) segue modelo caso a caso sem genes exógenos

**Notas**

Enquadre a regulação como variável econômica de primeira ordem, não como nota de rodapé. Em Brasil e Argentina, um produto SDN-1 sem transgene residual pode ser declarado não-OGM em meses, colapsando anos e milhões de custo frente ao caminho OGM — isso muda o cálculo de editar versus selecionar do próximo slide. A RN16 brasileira exige, no dossiê, a descrição e avaliação de off-targets, o que conecta ao slide seguinte. Destaque a reviravolta nos EUA: a vacatur de dezembro de 2024 (caso National Family Farm Coalition contra Vilsack) restaurou o regime pré-2020 de forma prospectiva — determinações e permissões anteriores continuam válidas — reintroduzindo incerteza justamente onde havia previsibilidade, importante para quem planeja lançamentos. A UE só destrava produtos a partir de 2028, e mesmo assim com a divisão NGT1 (equivalente a convencional) e NGT2 (regime tipo-OGM), com herbicida-tolerância e inseticida excluídos da categoria leve. A mensagem para a turma: a geografia regulatória deve orientar onde desenvolver e lançar primeiro. A contagem brasileira de produtos é volátil; o total atual deve ser confirmado na tabela TIMP da CTNBio (a verificar). Fontes: CTNBio RN16/2018; Argentina Res. 173/2015; govinfo (vacatur SECURE, FR 2025-06-16); Reg. (UE) 2026/1388; MARA China 2022.

## Slide 44 — Off-targets e propriedade intelectual

**Tópicos**

- Tang 2018 (arroz, WGS): só 1 de 12 sgRNAs com off-target previsto
- Cultura de tecidos: ~102–148 SNVs e ~32–83 indels/planta (somaclonal)
- Off-target de CRISPR bem-desenhado « variação somaclonal
- Exceção: ABE8e ~500 mutações A→G independentes de gRNA/planta
- IP: CVC (Cas9 genérico) + Broad (eucariotos) → licença dupla
- Corteva+Broad: licença conjunta não-exclusiva p/ agro desde 2017

**Notas**

Comece desarmando o medo exagerado de off-target: a evidência por sequenciamento de genoma completo em arroz mostra que a variação somaclonal da própria cultura de tecidos (cerca de 102 a 148 SNVs e 32 a 83 indels por planta) supera largamente os off-targets de um CRISPR bem desenhado, dos quais apenas 1 de 12 guias produziu edição fora do alvo e nenhum off-target genuíno apareceu na geração T1. Esse é um argumento central em dossiês regulatórios e no debate público. Mas seja rigoroso: editores de base hiperativos como o ABE8e geram cerca de 500 mutações independentes de guia por planta, logo a escolha da ferramenta muda o perfil de risco e a necessidade de sequenciamento completo. Em poliploides como o trigo hexaploide, a necessidade de editar múltiplos homeólogos aumenta a complexidade, mas a redundância tampona nocautes. No tema de IP, explique o emaranhado: aplicação agrícola de Cas9 geralmente exige licença do grupo CVC (Berkeley/Viena, Cas9 genérico) e do Broad (uso em eucariotos). A Corteva consolidou o maior portfólio agrícola e oferece, junto com o Broad, licença conjunta não-exclusiva desde 2017, com pesquisa acadêmica isenta. Enzimas desenhadas por IA e alternativas como Cas12 podem reduzir a dependência. Fontes: Tang et al. 2018 (Genome Biol 19:84); preprint ABE8e arroz 2022; Biotechnology Law Report 2022; Corteva Open Innovation.

## Slide 45 — Quadro de decisão: editar vs selecionar

**Tópicos**

- Favorece editar: mono/oligogênico, efeito grande, variante causal conhecida
- Favorece editar: alelo ausente na elite (evita linkage drag; introgressão ~7 anos)
- Favorece selecionar: poligênico, efeitos pequenos, variante desconhecida
- Regra: editar grande efeito + GS no fundo + OCS p/ endogamia
- Custo regulatório e tempo entram tanto quanto a biologia
- Nº de alvos: 1–~20 edições (multiplex) viável vs centenas de locos

**Notas**

Este é o slide de síntese prática — o que a turma leva para casa. Caminhe pelos critérios com um exemplo concreto por linha. Enfatize que a decisão não é ideológica (editar não é intrinsecamente melhor), mas condicional à arquitetura genética e ao contexto do programa. Para traços altamente poligênicos de pequeno efeito, a seleção genômica continua imbatível porque move centenas de locos simultaneamente; a edição brilha em alelos de grande efeito com causalidade conhecida, sobretudo quando ausentes do pool elite e caros de introgredir — lembre que a introgressão clássica custa cerca de 7 anos e arrasta linkage drag. Reforce a estratégia híbrida recomendada: editar o grande efeito, deixar a seleção genômica cuidar do poligênico, e usar OCS (Sessão 09) para conter a endogamia que o PAGE infla, fechando o ciclo iniciado no slide de integração. Lembre que custo regulatório e tempo são eixos tão decisivos quanto o efeito biológico: um ganho genético real pode não valer o custo de um produto classificado como OGM ou NGT2 na UE. Encerre lançando as perguntas de discussão e convidando a turma a aplicar o quadro ao próprio caráter-alvo. Fontes: síntese do dossiê (Seção 8); Jenko et al. 2015; Sessões 06 e 09 do curso.

## Slide 46 — Bloco 3 — Take-home

**Tópicos**

- Edição = reostato quantitativo, não só nocaute (Rodríguez-Leal 2017)
- IA desenha guias, editores (OpenCRISPR-1) e descobre alvos (gLMs)
- PAGE: 1,08×–4,12× sobre GS, mas infla endogamia → use OCS
- Gargalo é regeneração (GRF4–GIF1 7,8×) e entrega, não a enzima
- Regulação define a economia: Brasil/Argentina rápidos, UE só 2028
- Decida por arquitetura, efeito, variante causal, custo e tempo

**Notas**

Feche recapitulando a pergunta-guia: quando editar supera selecionar? A resposta é condicional, não absoluta. Reafirme os cinco pilares que a turma deve levar: primeiro, a edição é um reostato quantitativo (a edição cis-regulatória gera séries alélicas contínuas, cujo fenótipo não é previsível só pela transcrição). Segundo, a IA agora atravessa todo o fluxo — desenho de guias e pegRNAs, engenharia de enzimas inéditas como o OpenCRISPR-1, descoberta de alvos com modelos de linguagem genômica, e orquestração por agentes LLM. Terceiro, a integração com seleção genômica (PAGE) entrega de 1,08 a 4,12 vezes mais resposta, mas concentra ganho e endogamia, exigindo controle via OCS. Quarto, o gargalo real de muitos programas é a regeneração e a entrega, não a enzima — reguladores morfogênicos e HI-Edit são as alavancas. Quinto, a regulação define a economia: SDN-1 sem transgene é rápido no Brasil e na Argentina, incerto nos EUA após a vacatur, e só liberado na UE a partir de 2028. Termine reforçando o quadro de decisão (arquitetura, tamanho de efeito, variante causal, custo regulatório, tempo) e convide às perguntas de discussão e à conexão com os blocos de GS e OCS. Fontes: dossiê completo do Bloco 3 e referências das Sessões 06 e 09.

## Slide 47 — Intervalo

**Tópicos**

- 15h15–15h30
- Na volta: plataforma e tempo real (Éder e Vitor)
- Depois: breeder aumentado, ética e IP (todos)
- Fechamento: síntese, checklist e painel

**Notas**

Pausa entre edição e plataforma. Se o bloco 3 estourar o horário, corte as notas longas e mantenha o quadro de decisão editar versus selecionar. Fontes: agenda da sessão.

---

# Bloco 4 — Plataforma, tempo real e digital twin

## Slide 48 — Bloco 4 — Plataforma, tempo real e digital twin

**Tópicos**

- Palestrantes: Éder + Vitor · duração ~30 min
- Âncoras: Sessão 03 (HTP), 04 (dados), 09 (simulação/OCS), 10 (decisão)
- Do AlphaSimR ao gêmeo operacional: o que muda quando os dados fluem sozinhos
- Quatro camadas: física → dados → modelos → decisão (e a seta de volta)
- Evidência: simulação, CGM-WGP, enviromics, fenotipagem autônoma, indústria
- Pergunta-guia: o pipeline que vocês montaram é modelo, sombra ou gêmeo digital?

**Notas**

Este bloco fecha o arco técnico do curso juntando quatro sessões anteriores. Na Sessão 03 vocês viram fenotipagem de alto rendimento; na 04, QC e organização de dados em DuckDB; na 09, simulação estocástica com AlphaSimR e seleção de cruzamentos ótimos; na 10, a lógica de decisão. A pergunta que atravessa os próximos 30 minutos é simples e incômoda: aquilo que vocês construíram é um modelo digital, uma sombra digital ou um gêmeo digital? A resposta honesta, para quase todos os programas públicos e boa parte dos privados, é modelo ou sombra. Isso não é um demérito. O problema é quando um fornecedor, um edital ou um artigo chama de gêmeo algo que não fecha o laço entre o mundo físico e o virtual. Vamos percorrer primeiro as definições formais, depois a simulação de programas como ferramenta de desenho, em seguida modelos de cultura e enviromics, com forte contribuição brasileira, depois automação e padrões de dados, e por fim o que a indústria realmente publica, inclusive uma patente de 2025 que descreve literalmente um gêmeo de pipeline com aprendizado por reforço. Fechamos com valor da informação e limites. Éder conduz a parte de definições, simulação e modelos; Vitor conduz automação, dados, indústria e decisão. Peçam à turma que anote, ao longo do bloco, em que camada o próprio projeto deles está mais fraco. Fontes: Kritzinger et al. 2018 (IFAC-PapersOnLine); Verdouw et al. 2021 (Agricultural Systems); dossiê 04 deste curso.

## Slide 49 — Modelo, sombra e gêmeo digital — e seis níveis

**Tópicos**

- Digital Model: físico ↔ virtual atualizados à mão (Kritzinger 2018)
- Digital Shadow: físico → virtual automático; virtual → físico manual
- Digital Twin: fluxo automático nos dois sentidos — raro até na manufatura
- Critério é integração de dados, não sofisticação do modelo
- Verdouw 2021: imaginary, monitoring, predictive, prescriptive, autonomous, recollection
- Prescriptive: sistema recomenda, humano decide · Recollection: memória do descarte
- O AlphaSimR da Sessão 09 é um digital model (e tudo bem)

**Notas**

Kritzinger e colegas resolveram a confusão terminológica de forma brutalmente simples: não perguntaram o que o modelo faz, perguntaram como os dados fluem. Um modelo de elementos finitos extremamente sofisticado que depende de um engenheiro para atualizar parâmetros é um digital model. Uma planilha trivial alimentada automaticamente por sensores é um digital shadow. Só quando o virtual também atua sobre o físico sem intervenção manual temos um digital twin, e a revisão deles mostrou que, mesmo na manufatura, essa literatura é escassa. Verdouw e colegas complementam com seis tipos ao longo do ciclo de vida do objeto. O imaginário simula o que não existe, como um esquema de melhoramento ainda não implantado. O de monitoramento descreve e diagnostica o estado atual. O preditivo projeta estados futuros com dados correntes. O prescritivo recomenda ações, mas Verdouw é explícito: a decisão continua humana. O autônomo controla sem humano. O de recordação guarda a memória de objetos que deixaram de existir, e em melhoramento isso é central, porque descartamos milhares de linhagens por ano e esse histórico é o que permite re-treinar modelos depois. Os tipos não são excludentes. Façam a pergunta à turma: quando um fenótipo novo entra no banco de vocês, alguma coisa muda sozinha no modelo de decisão? Se alguém precisa rodar um script, é sombra ou modelo. Fontes: Kritzinger et al. 2018, IFAC-PapersOnLine 51(11):1016–1022, DOI 10.1016/j.ifacol.2018.08.474; Verdouw et al. 2021, Agricultural Systems 189:103046; Ganapathysubramanian et al. 2025, Trends in Plant Science 30(5).

## Slide 50 — Simulação estocástica ≠ gêmeo operacional

**Tópicos**

- Simulação: «que arquitetura de programa é melhor?» — horizonte de 20–40 anos
- Gêmeo: «o que faço com este lote nesta semana?» — horizonte de dias
- Simulação: população sintética, centenas de réplicas; gêmeo: uma realização real
- Desenho: AlphaSimR (G3 2021), MoBPS (G3 2020), ChromaX (Bioinformatics 2024)
- Operação: EBS / Breedbase + modelos + regras de decisão
- Erro caro: usar simulador de desenho como sistema operacional, e vice-versa

**Notas**

Esta distinção organiza o resto do bloco. A simulação estocástica é uma ferramenta de desenho: vocês a usam a cada poucos anos, quando decidem adotar a estratégia em duas partes, quantos estágios terá o ensaio de valor de cultivo, quanto do orçamento vai para genotipagem. Ela trabalha com populações sintéticas, replicadas centenas de vezes, porque o objetivo é estimar a distribuição do ganho genético sob uma arquitetura, não prever o que vai acontecer com a família 4017. O gêmeo operacional é uma ferramenta de operação: roda continuamente, usa a única realização real do programa, e responde a eventos com horizonte de dias ou semanas. São infraestruturas diferentes, equipes diferentes e ciclos de validação diferentes. AlphaSimR simula até o nível de sequência de DNA, para diploides e autopoliploides, via scripts em R. MoBPS, da equipe de Göttingen, usa armazenamento bit-wise e já traz contribuições genéticas ótimas e ssGBLUP, com uma interface web pensada para ensino. ChromaX reescreveu a simulação em JAX para rodar em GPU. Um erro comum e caro é tentar transformar o simulador em sistema operacional: ele não tem os dados do seu programa, tem suposições sobre programas em geral. O inverso também falha: um painel operacional não responde perguntas de arquitetura, porque só observa a configuração já escolhida. O que vocês fizeram na Sessão 09 foi desenho, e isso foi apropriado. Fontes: Gaynor, Gorjanc & Hickey 2021, G3 11(2):jkaa017; Pook et al. 2020, G3 10(6):1915–1918; Younis et al. 2024, Bioinformatics, DOI 10.1093/bioinformatics/btad691.

## Slide 51 — Estratégia em duas partes: ganho com custo constante

**Tópicos**

- 40 anos simulados com custo operacional anual ≈ igual (Gaynor et al. 2017)
- 2,36× o convencional com G×Y = 10 (IC95% 2,08–2,67); 2,47× com G×Y = 0
- 1,31× (G×Y = 10) a 1,46× (G×Y = 0) vs. melhor GS padrão
- Mais G×Y → intervalo mais largo: usar o número conservador no Brasil tropical
- Ganho realizado no CIMMYT: 0,225 t/ha/ciclo = 0,100 t/ha/ano (Zhang 2017)
- 18 linhagens elite, 955.690 SNPs GBS, 2 ciclos/ano, 4,5 anos

**Notas**

Dois pontos técnicos costumam se perder quando esse artigo é citado. O primeiro é a restrição de custo: todos os programas simulados foram limitados a custos operacionais anuais aproximadamente iguais. Sem isso o resultado seria trivial, porque gastar mais produz mais ganho. O que Gaynor e colegas mostraram é que, com o mesmo dinheiro, reorganizar o programa em um componente de melhoria populacional por seleção genômica recorrente rápida e um componente de desenvolvimento de produto com desenho tradicional gera mais que o dobro do ganho do programa convencional e cerca de um terço a mais que a melhor implementação padrão de seleção genômica. O segundo ponto é a incerteza: o intervalo de confiança mais largo, de 2,08 a 2,67, aparece justamente no cenário com mais variância genótipo por ano. Mais interação ambiental, mais incerteza sobre o benefício. O Brasil tropical tem muito G×E, então o número a comunicar é o conservador. Para ancorar na realidade, tragam o resultado do CIMMYT: em milho tropical multiparental, com 18 linhagens elite, mil famílias e quase um milhão de SNPs, dois ciclos por ano produziram ganho realizado em campo de 0,225 t/ha por ciclo, ou 0,100 t/ha por ano em 4,5 anos, com estreitamento apenas discreto da diversidade. Uma extensão com seleção de cruzamentos ótimos, de Gorjanc e colegas, mostra ganho de longo prazo maior, mas a magnitude exata está a verificar na versão publicada. Fontes: Gaynor et al. 2017, Crop Science, DOI 10.2135/cropsci2016.09.0742; Zhang et al. 2017, G3 7(7):2315, DOI 10.1534/g3.117.043141; Gorjanc et al., bioRxiv 10.1101/227215.

## Slide 52 — Simulação rápida e otimização do esquema

**Tópicos**

- ChromaX GPU: 100 mil cruzamentos em 29 ms vs 14.821 ms no AlphaSimR CPU
- ~3× em CPU, ~500× em GPU; custo: memória bem maior (Younis 2024)
- Kernel (Hassanpour 2023, G3): >100.000 simulações e estreitamento manual
- Evolucionário (Hassanpour 2024, G3): 2.400 simulações, redução >40×
- Custo em nuvem: €67,65 para 12.300 simulações em 40 iterações
- Bayesiana (Jannink, Crop Sci): superfície plana perto do ótimo; ruído > inclinação
- Sem regras de bolso: cada programa precisa simular o seu

**Notas**

Comecem pela velocidade, porque ela muda o que é viável. ChromaX, escrito em JAX, simulou cem mil cruzamentos biparentais em 29 milissegundos numa GPU comum, contra quase quinze segundos do AlphaSimR em CPU de cluster. No programa completo de Gaynor, o ganho foi de cerca de quinhentas vezes. Os autores são honestos sobre o preço: o consumo de memória é bem maior, por causa do desenho funcional e da vetorização. Se a população cabe na memória da GPU, vocês ganham duas ordens de grandeza; se não cabe, não ganham nada. Agora a otimização do esquema, com uma correção importante: Hassanpour e colegas, em 2023, usaram regressão kernel, não otimização bayesiana. O método exigiu mais de cem mil simulações e estreitamento manual. No artigo seguinte, um algoritmo evolucionário chegou a resultado equivalente com 2.400 simulações, mais de quarenta vezes menos, e os autores calcularam o custo em nuvem: 67 euros e 65 centavos. Otimizar formalmente um programa custa menos que um jantar; o gargalo é organizacional. Quem usou otimização bayesiana foi Jannink e colegas, com BoTorch sobre AlphaSimR, e o achado é incômodo: a superfície de resposta é plana perto do ótimo, o ruído pode superar a inclinação, alocações bem diferentes rendem quase o máximo e nenhuma regra simples emergiu. Leitura pessimista: não vale otimizar. Leitura que preferimos: há folga para acomodar restrições práticas sem perder ganho. Fontes: Younis et al. 2024, Bioinformatics; Hassanpour et al. 2023, G3 jkad217; Hassanpour et al. 2024, G3 jkae248; Jannink et al., Crop Science, DOI 10.1002/csc2.21124; Tanaka & Iwata 2022, Front. Plant Sci. 13:1050198.

## Slide 53 — Look-ahead e aprendizado por reforço

**Tópicos**

- LAS: GEBV esperado do melhor descendente na geração terminal T
- Inclui frequências de recombinação e prazo restante T − t (Moeinizade 2019, G3)
- Caso de estudo: 369 linhagens de milho, 1.406.757 SNPs
- RL (Moeinizade 2022, ISWA): MDP + aproximação da função valor + política gulosa
- Decide quanto orçamento gastar em cada geração — cedo ou distribuído?
- Não é bandit: é RL baseado em valor para alocação sequencial
- Ponte com OCS (Sessão 09): diversidade via horizonte, não via restrição

**Notas**

A seleção look-ahead é conceitualmente elegante e vale desacelerar aqui. Métodos como o valor haploide ótimo e o valor de progênie ótimo perguntam qual seria o melhor descendente possível, assumindo tempo e recursos ilimitados. A seleção genômica convencional pergunta qual é o melhor pai agora, ignorando o futuro. O LAS introduz o prazo como parâmetro do próprio objetivo: maximiza o valor genético esperado do melhor descendente na geração final, levando em conta a incerteza da recombinação. O melhor cruzamento quando faltam dez gerações é diferente do melhor cruzamento quando falta uma. O estudo de caso usou 369 linhagens de milho com mais de 1,4 milhão de SNPs, e o LAS superou os métodos comparados nas simulações. Isso dialoga diretamente com o OCS da Sessão 09: ambos equilibram ganho e diversidade, mas o OCS faz isso por restrição de parentesco e o LAS pelo horizonte temporal. A camada de aprendizado por reforço, de 2022, resolve outro problema: o LAS escolhe cruzamentos, mas não decide o orçamento. Gastar cedo, antes que a diversidade se deteriore, ou distribuir ao longo das gerações? Os autores formulam isso como processo de decisão de Markov, usam um programa linear inteiro para conter o espaço de estados, aproximam a função valor e melhoram a política de forma gulosa. Se alguém chamar isso de bandit, corrijam: é RL baseado em valor. Guardem esta lâmina, porque ela volta quando falarmos da patente da Pioneer. Fontes: Moeinizade et al. 2019, G3, DOI 10.1534/g3.118.200842; Moeinizade et al. 2022, Intelligent Systems with Applications, DOI 10.1016/j.iswa.2022.200076.

## Slide 54 — CGM-WGP: fisiologia dentro da predição

**Tópicos**

- Marcadores → parâmetros fisiológicos → modelo de cultura integra no tempo
- Messina 2022: 2.367 híbridos, 17 locais + 6 estresses manejados, 2017–2019
- G e E não testados: r = 0,43 (CGM-WGP) vs 0,27 (BayesA)
- Sob G×E: CGM-WGP 0,61 → 0,58; WGP 0,62 → 0,42
- rG(irrigado, TPE) = 0,68; rG(déficit hídrico, TPE) = 0,0003
- Seca: ganho de 6,2 → 7,5 g m⁻² ano⁻¹ vs 8,6 com água (Cooper 2023)
- Prova de conceito 2016: 5 traits componentes escolhidos a priori

**Notas**

A ideia do CGM-WGP é deslocar o que se prediz. Em vez de ir dos marcadores direto à produtividade, prediz-se parâmetros fisiológicos a partir dos marcadores e deixa-se o modelo de cultura integrar esses parâmetros ao longo do ciclo, com o clima real de cada ambiente. O estudo de Messina e colegas é o maior caso empírico: meio-dialelo de nove endogâmicas elite, 35 famílias, 2.367 híbridos, 17 locais no corn belt e seis ambientes de estresse manejado, com evapotranspiração entre 377 e 760 mm. Para genótipos e ambientes não testados, a correlação foi 0,43 contra 0,27 do BayesA. Mas o número que precisa ficar é outro: a correlação genética entre os ambientes de déficit hídrico e a população-alvo de ambientes foi 0,0003, praticamente zero. Selecionar ali não produzia progresso no alvo, e nenhum GBLUP convencional sinalizaria isso. Observem também a assimetria: com ambientes testados, as duas abordagens predizem genótipos novos de forma parecida; sob G×E, o CGM-WGP mantém a acurácia enquanto o WGP cai de 0,62 para 0,42. A revisão de duas décadas de Cooper mostra o ganho sob seca subindo de 6,2 para 7,5 gramas por metro quadrado por ano, perto dos 8,6 sob água suficiente, com diferencial de acurácia de cerca de 30%. Advertência final: a prova de conceito de 2016 funcionou porque fisiologistas escolheram cinco traits a priori. Não há atalho automático; um modelo do corn belt não descreve Viçosa. Fontes: Technow et al. 2016, Crop Science, DOI 10.2135/cropsci2015.08.0512; Messina et al. 2022, Plant Physiology, PMC8825268; Cooper et al. 2023, J. Exp. Bot., DOI 10.1093/jxb/erad231.

## Slide 55 — Enviromics: a contribuição brasileira

**Tópicos**

- Resende et al. (TAG 2021): local descrito por envirótipos, como genótipo por SNPs
- EnvRtype (Costa-Neto 2021, G3): NASA POWER → W_matrix → kernels enviromicos
- E-GP (Front Plant Sci 2021): mediana r 0,17 (GBLUP) → 0,83 por genótipo
- GBLUP: 45% dos genótipos mal preditos; E-GP: até 60% muito bem preditos
- Representatividade G×E importa mais que o tamanho do MET
- Desenhar in silico quais combinações G×E precisam ir a campo
- Gêmeo de ensaio = kernel que torna predizível um ambiente não testado

**Notas**

Esta é a lâmina com mais orgulho local, e com razão: Resende, Costa-Neto, Fritsche-Neto, Crossa e colaboradores definiram boa parte deste campo a partir do Brasil. Resende e colegas cunharam o termo enviromics com uma analogia que se sustenta tecnicamente: assim como um genótipo é descrito por marcadores de DNA, um local é descrito por envirótipos em marcadores ambientais, e isso permite casar genótipos com locais, delimitar regiões de melhoramento com alta correlação genética e escolher onde instalar ensaios. O EnvRtype transforma isso em pipeline em R: baixa clima do NASA POWER, calcula variáveis ecofisiológicas, monta a matriz de covariáveis e gera kernels para GBLUP com normas de reação. No estudo de montagem enviromica, ao predizer a resposta individual de cada genótipo ao longo dos ensaios multiambientes, a mediana da correlação foi 0,17 com GBLUP e 0,83 com E-GP. Um salto desse tamanho merece ceticismo, então expliquem o cenário: é exatamente onde o GBLUP é mais fraco, em ambientes ainda não observados. O achado operacional mais valioso é outro: a representatividade das combinações genótipo-ambiente importa mais que o número de ambientes. Um programa com orçamento limitado pode escolher melhor em vez de instalar mais. Esse é o gêmeo digital de um ensaio na prática: não um avatar 3D, mas um kernel. A Embrapa disponibiliza APIs como ClimAPI e SATVeg que alimentam esse tipo de pipeline. Fontes: Resende et al. 2021, Theor. Appl. Genet., DOI 10.1007/s00122-020-03684-z; Costa-Neto et al. 2021, G3 11(4):jkab040; Costa-Neto, Crossa & Fritsche-Neto 2021, Front. Plant Sci. 12:717552; Xu et al. 2024, Molecular Plant.

## Slide 56 — DT-FieldPheno e o viveiro virtual

**Tópicos**

- Plataforma sobre trilhos em milho — não é VANT (Liu et al. 2025, Agriculture)
- Laço fechado: conexão → computação → predição → decisão → execução
- Risco meteorológico: AHP + lógica fuzzy com previsão e dados em tempo real
- 27 dias contínuos: −50% de inspeção manual
- 2 tarefas canceladas por vento, 2 otimizadas por rajada/chuva
- Alerta de trilho em 1,8 ± 0,2 s; heartbeat de comunicação de 5 s
- Viveiro VR (PORTAL, ACM SUI 2024): robô + laser 3D + multiespectral em VR

**Notas**

Façam a correção logo no início, porque a descrição como sistema de drone circula e está errada. O DT-FieldPheno é uma plataforma de fenotipagem sobre trilhos, da Academia de Ciências Agrícolas e Florestais de Pequim. A arquitetura é de laço fechado: o gêmeo sincroniza o equipamento físico com sua contraparte virtual, avalia o risco meteorológico combinando previsão e medições em tempo real com análise hierárquica e lógica fuzzy, e decide se a coleta deve acontecer. Em 27 dias seguidos num campo de milho, reduziu pela metade a inspeção manual, cancelou duas tarefas de alto risco por vento acima do limiar dos sensores e reprogramou outras duas por rajadas e chuva. Alertas de desvio de trilho saíram em menos de dois segundos. É o exemplo público mais próximo de um gêmeo autônomo no sentido de Verdouw. Mas delimitem o escopo: o gêmeo controla o equipamento de fenotipagem, não a decisão de melhoramento. Ninguém deixou um algoritmo decidir quais linhagens avançam, e a distância entre cancelar um voo e descartar uma família é enorme. Os 50% também se referem à inspeção do equipamento, não ao trabalho do melhorista. O viveiro virtual do projeto PORTAL, do DFKI com a NPZ, mostra o outro lado: um robô autônomo captura imagens, varreduras laser e dados multiespectrais, e o melhorista avalia gêmeos 3D em realidade virtual, comparando candidatos entre locais e datas. É um gêmeo de monitoramento e recordação. Fontes: Liu et al. 2025, Agriculture 15(11):1217, DOI 10.3390/agriculture15111217; Tieben et al. 2024, ACM SUI, DOI 10.1145/3677386.3688876; DFKI, projeto PORTAL.

## Slide 57 — Padrões de dados: a camada que decide tudo

**Tópicos**

- BrAPI: API REST compatível com MCPD, MIAPPE, GA4GH, GeoJSON, Crop Ontology
- MIAPPE 1.1 (New Phytol 2020): de checklist a modelo de dados formal
- Breedbase (G3 2022): Postgres/Chado; genótipos em JSONb no modelo VCF
- EBS (CGIAR/EiB): integra Field Book e QBMS via BrAPI
- FACT-AI Clemson (USDA-NIFA): edge/fog reduz dados antes de transmitir
- Sem fluxo automático físico → virtual, não existe digital shadow
- Sessão 04: o QC em DuckDB é a versão local deste papel

**Notas**

Esta é a lâmina que os alunos acham chata e que determina se o resto funciona. Voltem à definição de Kritzinger: a fronteira entre modelo digital e sombra digital é exatamente a automação do fluxo do físico para o virtual. BrAPI e MIAPPE não são burocracia; são o mecanismo que faz um sistema subir de categoria. BrAPI é uma especificação aberta de serviços web para germoplasma, ensaios, fenotipagem e genotipagem, compatível com os principais padrões comunitários e com a Crop Ontology. MIAPPE 1.1 deixou de ser uma lista de verificação e virou um modelo de dados formal, com campos obrigatórios e cobertura de culturas perenes. Breedbase, que nasceu como Cassavabase, guarda fenótipos relacionais e genótipos em formato compacto dentro do mesmo PostgreSQL, preservando integridade referencial. O EBS é o sistema preferencial do CGIAR e conversa com o Field Book e com o pacote QBMS por BrAPI. Conectem com a Sessão 04: o QC que vocês fizeram em DuckDB cumpre a mesma função, mas o banco institucional impõe ontologias consistentes e preserva proveniência. Um minuto sobre edge computing: o projeto FACT-AI, de Clemson, processa nos nós de borda e transfere apenas o dado útil, ou seja, alguém decidiu em tempo de projeto o que nunca seria armazenado. Essa escolha é irreversível e raramente discutida. E não romantizem: os autores do Breedbase admitem que bancos de melhoramento são complexos, difíceis e caros de manter. Fontes: brapi.org; Papoutsoglou et al. 2020, New Phytologist, DOI 10.1111/nph.16544; Morales et al. 2022, G3 12(7):jkac078; ebsproject.org; USDA-NIFA 1030625; Hershberger Lab DSFAS SC-2023-11724.

## Slide 58 — Arquitetura em quatro camadas

**Tópicos**

- FÍSICA: nurseries, METs, estufas, seed chipping, robôs, trilhos, VANTs, estações
- ↓ corte DM/DS: a ingestão é automática ou é planilha?
- DADOS: BrAPI · MIAPPE · Crop Ontology · Breedbase/EBS · edge/fog · QC
- MODELOS: GBLUP/normas de reação · EnvRtype · APSIM/DSSAT · CGM-WGP · AlphaSimR
- DECISÃO: OCS · LAS · RL/MDP · otimização de esquema · BPAT · humano no circuito
- ↑ corte DS/DT: plantio prescrito, cancelamento de coleta, reagendamento
- Hoje a seta de volta fecha para equipamento (DT-FieldPheno), não para seleção

**Notas**

Esta lâmina amarra tudo numa arquitetura que vocês podem usar para diagnosticar qualquer programa. A camada física reúne tudo que existe no mundo: viveiros, ensaios multiambientes, estufas de ciclo rápido, laboratório de amostragem de sementes, robôs terrestres, plataformas sobre trilhos, drones, estações meteorológicas. Entre a física e os dados está o primeiro corte de Kritzinger: se a ingestão depende de alguém digitar ou importar planilhas, vocês têm um modelo digital. A camada de dados é onde vivem BrAPI, MIAPPE, Crop Ontology, Breedbase ou EBS, o processamento na borda e o controle de qualidade. A camada de modelos tem quatro famílias: genéticos, como GBLUP e normas de reação; ambientais, como os kernels do EnvRtype; fisiológicos, como APSIM, DSSAT e CGM-WGP, que tem mais de 45 culturas no DSSAT; e de programa, como AlphaSimR, MoBPS e ChromaX. A camada de decisão traz OCS, seleção look-ahead, aprendizado por reforço, otimização de esquema e, como governança, o BPAT do CGIAR, que avalia programas com métricas de processo como tempo de ciclo e CV dos ensaios. A seta de volta, do virtual para o físico, é o segundo corte: só com ela há gêmeo. Hoje ela está fechada para equipamentos, como no DT-FieldPheno, e reivindicada em patente para decisões de cruzamento, mas não demonstrada publicamente para seleção. Peçam que cada grupo marque em que camada o próprio projeto está mais fraco. Fontes: Kritzinger et al. 2018; Verdouw et al. 2021; Holzworth et al. 2018, EM&S 103:43–51; dssat.net; BPAT, University of Queensland; dossiê 04, seção 6.

## Slide 59 — O que a indústria publica — e a patente da Pioneer

**Tópicos**

- Corteva: 1 bilhão de marcadores e 15 milhões de parcelas/ano (fala a investidores)
- Corteva: 80–100 mi imagens de drone no último ano; drones desde 2012 (Seed World)
- Corteva: >10 bi pontos de dados; >5 Pb de sequência genômica (Investor Day 2026)
- Bayer: seed chipping = 10–15 mi pontos de dados por semente (DEKALB)
- Bayer Marana/AZ: ~7 acres de estufa, 3–4 ciclos de milho/ano
- WO/2025/080804: Pioneer Hi-Bred (Corteva), depositada em 10/10/2024
- Patente reivindica RL sobre MDP que recompensa ganho genético no gêmeo

**Notas**

Tratem esta lâmina como exercício de leitura crítica, não como celebração. Todos os números vêm de comunicação corporativa: chamadas com investidores, páginas de produto e imprensa setorial, sem revisão por pares. Alguns são concretos e auditáveis em princípio, como quinze milhões de parcelas por ano. Outros são vagos por construção: a Corteva afirma ganho de quatro a cinco vezes na acurácia do pipeline inicial, mas sem métrica nem comparador, então fica a verificar e fora da lâmina. A Bayer é um bom caso pedagógico: a página do DEKALB fala em reduzir o tempo de melhoramento de cinco anos para cinco meses, e a apresentação do Innovation Summit de 2023 fala em cinco a seis anos para cerca de quatro meses, com meta de dobrar o ganho genético até 2030. São afirmações corporativas, discordantes entre si e a verificar; se a própria empresa publica dois números, o que exatamente está sendo medido? O mesmo material cita um gêmeo digital de testes de campo, misturando ensaios simulados e reais. Para Syngenta, Inari e Benson Hill não encontramos números primários auditáveis. Agora a patente, com uma correção: ela é da Pioneer Hi-Bred, isto é, da Corteva, não da Bayer. Ela descreve um gêmeo de pipeline de ponta a ponta que recebe genótipo, fenótipo, solo e ambiente, inclusive plantas editadas e transgênicas, e gera ações até o plantio. O parágrafo 14 especifica agentes que executam políticas de seleção dentro do gêmeo, avaliados num MDP que recompensa ganho genético. É a lâmina de aprendizado por reforço, patenteada. Fontes: transcrição Corteva/Wolfe Research 2026; Seed World 12/2025; Corteva Investor Day 2026; Bayer DEKALB; Bayer CS Innovation Summit 2023; WO/2025/080804 (WIPO, Google Patents).

## Slide 60 — Tempo real ou lote sazonal: valor da informação

**Tópicos**

- ΔG = i · r · σA / L: toda tecnologia entra por um desses termos
- Altura em arroz: 45 parcelas/h manual vs 3.000/h com phenomobile (Araus 2018)
- Minutos: cancelar coleta por vento · horas–dias: irrigar estresse manejado
- Dias: falha de estande · sazonal: avanço, descarte e escolha de cruzamentos
- Tempo real vale onde a janela é curta e a perda é irreversível
- VoI baixo: refinar orçamento perto do ótimo (superfície plana, Jannink)
- VoI alto: informação ambiental, r 0,17 → 0,83 (Costa-Neto 2021)

**Notas**

Esta é a lâmina de decisão, que conversa com a Sessão 10. Comecem pela equação do ganho genético: qualquer tecnologia só gera valor se aumentar a intensidade de seleção, a acurácia ou a variância aditiva explorada, ou se encurtar o ciclo. Araus e colegas dão um número concreto para fenotipagem: medir altura de arroz à mão rende 45 parcelas por hora; com um veículo de fenotipagem com sensor ultrassônico, três mil. Esse ganho de throughput vira intensidade de seleção, porque o mesmo orçamento cobre populações maiores. Agora a pergunta de latência. Tempo real só tem valor onde a janela de ação é curta e a perda é irreversível. Se o vento passou do limiar, perdeu-se aquele dia de coleta. Se a irrigação de um ensaio de estresse manejado falhou, compromete-se a correlação genética com o ambiente-alvo e a safra inteira. Falha de estande pede reação em dias. Já avanço, descarte e escolha de cruzamentos precisam do ensaio completo, e decidir antes não traz ganho. O contraste final é o ponto central: investir onde o gradiente é íngreme. Refinar a alocação de orçamento perto do ótimo rende pouco, como mostraram Jannink e colegas; acrescentar informação ambiental pode quadruplicar a correlação. Lembrem também que custo de equipamento e treinamento costuma ser a barreira dominante, e que o cálculo dos EUA não se transfere automaticamente ao Brasil. Cifras de custo por hectare de voos de drone que circulam por aí vêm de fonte duvidosa e ficam a verificar. Fontes: Araus et al. 2018, Trends in Plant Science, DOI 10.1016/j.tplants.2018.02.001; Jannink et al., Crop Science, DOI 10.1002/csc2.21124; Costa-Neto et al. 2021, Front. Plant Sci. 12:717552; Euphytica, DOI 10.1007/s10681-018-2226-z.

## Slide 61 — Limites: o que ainda não sabemos

**Tópicos**

- Modelo calibrado no corn belt não descreve Viçosa: recalibrar é custo real
- rG ≈ 0 entre ambiente de seleção e TPE é invisível para o GBLUP
- Otimizar contra AlphaSimR = otimizar contra as próprias suposições
- Edge computing embute decisão irreversível do que nunca será armazenado
- Integração é cara: Breedbase e EBS existem por isso (Morales 2022)
- Garbage in, garbage out: milhões de imagens não corrigem mapa de parcelas errado
- Validação prospectiva em ciclos completos: praticamente ausente

**Notas**

Fechem com honestidade epistêmica, porque é o que distingue uma aula de pós-graduação de um webinar de fornecedor. O item mais importante é o último: revisões recentes convergem na constatação de que a maior parte das aplicações de inteligência artificial e gêmeos digitais em melhoramento foi avaliada com dados históricos, simulações ou pontos de decisão isolados, não em ciclos completos comparados prospectivamente contra o melhoramento convencional. Isso não quer dizer que não funcione; quer dizer que ainda é hipótese. O ponto sobre superajuste ao simulador merece ênfase para esta turma, que acabou de usar AlphaSimR: ao otimizar um esquema contra um simulador, vocês otimizam contra a arquitetura genética, o mapa e as variâncias que vocês mesmos informaram, e há relatos de que resultados de otimização bayesiana mudam com pequenas alterações nos genótipos de entrada. A correlação genética quase nula entre seca manejada e ambiente-alvo, do estudo de Messina, é o exemplo perfeito de erro silencioso. Sobre dados, a frase de Geoff Graham, da Corteva, resume: se há erro no sistema, as decisões são ruins. Integração tem custo alto e contínuo, e plataformas proprietárias criam dependência de fornecedor; o contraponto aberto são Breedbase, EBS, BrAPI e MIAPPE. Por fim, a pergunta ética: quando uma política de aprendizado por reforço erra uma decisão de seleção, quem responde? Deixem a turma discutir antes da lâmina final. Fontes: Front. Plant Sci. 2026, DOI 10.3389/fpls.2026.1929693; Messina et al. 2022, Plant Physiology; Hassanpour et al. 2024, G3 jkae248; Tanaka & Iwata 2022; Morales et al. 2022, G3; Seed World 12/2025.

## Slide 62 — Bloco 4 — Take-home

**Tópicos**

- Classifique antes de comprar: modelo, sombra ou gêmeo (Kritzinger 2018)
- Simulação desenha o programa; gêmeo opera o programa — ferramentas distintas
- Custo constante: duas partes rendeu 2,36–2,47× o convencional (Gaynor 2017)
- Otimizar o esquema custou €67,65 em nuvem; o gargalo é organizacional
- Fisiologia e ambiente ganham onde G×E domina: r 0,43 vs 0,27; 0,17 → 0,83
- BrAPI + MIAPPE transformam planilha em digital shadow
- Tempo real só onde a janela é curta; humano no circuito na seleção

**Notas**

Usem esta lâmina para devolver a pergunta-guia à turma. Primeiro, classifiquem antes de comprar ou de escrever um projeto: perguntem como os dados fluem, não quão sofisticado é o modelo. Segundo, separem desenho de operação. Simuladores como AlphaSimR, MoBPS e ChromaX respondem perguntas de arquitetura, como a estratégia em duas partes, que com o mesmo orçamento rendeu mais que o dobro do programa convencional. Sistemas operacionais respondem perguntas da semana. Terceiro, otimizar formalmente um esquema já é barato: o algoritmo evolucionário de Hassanpour custou menos de setenta euros em nuvem. Se ninguém faz, o motivo é organizacional. Quarto, onde a interação genótipo por ambiente domina, fisiologia e informação ambiental fazem diferença grande, como mostram o CGM-WGP e o trabalho brasileiro de enviromics. Quinto, a infraestrutura de dados é o que permite subir de categoria: BrAPI, MIAPPE e um banco como Breedbase ou EBS transformam planilhas em uma sombra digital. Sexto, tempo real só se justifica onde a janela de ação é curta e a perda irreversível, e as decisões de seleção continuam humanas, mesmo quando patentes já descrevem agentes automatizados. Como tarefa, peçam que cada grupo desenhe as quatro camadas do próprio projeto, marque os dois cortes de Kritzinger e proponha uma única intervenção que mova o projeto um nível acima. Isso conecta diretamente com a discussão final do curso. Fontes: Kritzinger et al. 2018; Gaynor et al. 2017; Hassanpour et al. 2024, G3 jkae248; Messina et al. 2022; Costa-Neto et al. 2021; Papoutsoglou et al. 2020; Liu et al. 2025; WO/2025/080804.

---

# Bloco 5 — Breeder aumentado: agentes, governança, ética e IP

## Slide 63 — Bloco 5 — Breeder aumentado: agentes, governança, ética e IP

**Tópicos**

- Palestrantes: Todos · duração ~25 min
- Âncoras: Sessão 05 (governança), 08 (alucinações), 09 (humano decide θ/ΔF), 10 (DSS)
- Pergunta-guia: o agente acelera — quem assina?
- Roteiro: agentes → evidência de erro → governança → IP/DSI → dados → responsabilidade
- Fecho: regras de engajamento, 5 dilemas para o painel e take-home

**Notas**

Este bloco fecha o curso conectando tudo o que os alunos praticaram com as perguntas que vão enfrentar na carreira. Abram lembrando o que eles já fizeram: configuraram agentes com regras de permissão, criaram deny-lists sobre dados brutos, trabalharam em modo plan-first e aprenderam, na Sessão 08, que o modelo inventa referências com naturalidade. Esses três controles — permissão, escopo de dados e plano antes da ação — são exatamente o que normas como a ISO/IEC 42001 e o OWASP MCP Top 10 estão formalizando agora. Ou seja, eles já praticaram governança sem chamar de governança. A pergunta-guia é deliberadamente provocativa: o agente acelera, mas quem assina? Ela atravessa os quatro eixos do bloco. Em ciência, quem assina o resultado que o agente produziu. Em governança, quem responde quando a recomendação falha. Em propriedade intelectual, quem é inventor de um alelo que um modelo propôs. Em dados, quem responde pelo vazamento quando alguém cola uma tabela num chat. O roteiro segue do entusiasmo para a cautela e termina em prática: começamos com o que os agentes já fazem de verdade, passamos pela evidência dura de erro e de viés, mapeamos o quadro regulatório e de IP, e fechamos com um checklist operacional, cinco dilemas para o painel e três hábitos. Todos os números deste bloco foram verificados em fontes primárias em outubro de 2026; o que não pôde ser verificado aparece apenas nas notas, marcado como a verificar. Fontes: dossie/05_breeder_aumentado_etica_ip.md; OWASP MCP Top 10 (2025); ISO/IEC 42001:2023.

## Slide 64 — De assistente a agente: o que já funciona

**Tópicos**

- Co-Scientist (Gemini 2.0): Supervisor + 6 agentes; validado in vitro em LMA [Nature 2026]
- Robin: ripasudil para DMRI seca, validado em ciclo lab-in-the-loop [FutureHouse 2025]
- CRISPR-GPT: nocaute de 4 genes (Cas12a, A549); 288 casos de teste [Nat Biomed Eng 2025]
- BioDiscoveryAgent: +21% acertos; +46% em genes não essenciais vs. OB [ICLR 2025]
- GeneGPT: 0,83 no GeneTuring vs. 0,12 do ChatGPT, chamando APIs do NCBI [Bioinf 2024]
- Padrão comum: o LLM orquestra ferramentas — quem calcula é o código

**Notas**

Peçam que a turma defina agente com as próprias palavras antes de mostrar o slide. A diferença em relação a um chatbot não é de inteligência, é de autonomia operacional: decompor a tarefa, chamar ferramentas, observar o resultado e iterar. E autonomia é exatamente o que cria superfície de risco. Os sistemas listados não são apenas demonstrações: Robin produziu um candidato terapêutico validado experimentalmente, CRISPR-GPT gerou edições reais verificadas por sequenciamento, e BioDiscoveryAgent superou baselines de otimização bayesiana treinados especificamente para a tarefa. Isso desarma o argumento cético de que tudo é hype. Ao mesmo tempo, notem que o Co-Scientist saiu em blog e arXiv em fevereiro de 2025 e só foi publicado na Nature em 2026; a distância entre anúncio e revisão por pares é, em si, uma lição de leitura crítica. Existe ainda o Kosmos, da Edison Scientific, que alega cerca de 79 por cento de afirmações corretas e o equivalente a seis meses de trabalho por execução — números a verificar, porque são auto-reportados pela empresa e por avaliadores recrutados por ela. A mensagem central está no último bullet: em todos os casos que funcionam, o LLM não produz o número. GeneGPT gera uma URL e executa a chamada; CRISPR-GPT delega o desenho de sgRNA a ferramentas especializadas. É o mesmo princípio que a FAO adotou: a IA explica, o modelo estatístico estima. Peçam que identifiquem, no próprio trabalho, um número que hoje vem do texto e deveria vir de código. Fontes: Gottweis et al. 2025 / Nature 2026; Ghareeb et al. 2025; Qu et al. 2025 (DOI 10.1038/s41551-025-01463-z); Roohani et al. ICLR 2025; Jin et al. 2024 (DOI 10.1093/bioinformatics/btae075).

## Slide 65 — Germoplasma: Chat-RGIE e o colapso fora do benchmark

**Tópicos**

- Extração zero-shot de passaporte de arroz: parentais, agronômicos, resistências [JBD 2025]
- Votação entre múltiplas respostas + calibração para conter alucinação
- Benchmark controlado: precisão 0,9102 · revocação 0,9941 · acurácia 0,9554
- Dados reais: precisão 0,6351 · revocação 1,0 · acurácia 0,8225
- Taxa de alucinação medida: 0,0015 (controle) e 0,005 (real)
- Lição: IA para varredura exaustiva, humano para filtrar — benchmark não é produção

**Notas**

Este é o slide mais importante da primeira metade do bloco, porque toca diretamente no objeto de trabalho dos alunos: dados de passaporte de germoplasma. Chat-RGIE extrai, sem exemplos rotulados, informações como nome da variedade, parentais, caracteres agronômicos, qualidade, produtividade e resistência a partir de registros e resumos de artigos. Para conter alucinações, usa várias respostas do modelo, votação e um componente de calibração. No ambiente controlado, a precisão é de 0,91. Em dados reais, cai para 0,64 — cerca de 28 pontos percentuais a menos. E os autores publicaram isso abertamente, o que merece crédito. Perguntem à turma o que significa operacionalmente: em mil campos extraídos, algo como 360 estariam errados. Para um banco de passaporte que alimenta decisões de pré-melhoramento, isso é inaceitável sem revisão humana. Agora observem a revocação de 1,0: o sistema não perde informação, ele adiciona informação errada. Isso define o desenho correto do fluxo, que é o inverso do instinto da maioria: usar a IA para a varredura exaustiva, onde ela é excelente, e o humano para filtrar, onde ela falha. Conectem com a Sessão 08: alucinação não é um bug que some na próxima versão, é uma propriedade estatística que se gerencia com desenho de processo. Os autores ainda relatam um achado curioso: sob prompts mais pressionantes, o modelo viola mais as restrições quando não há resposta possível. Fontes: Wei & Fan, J. Big Data 12:202 (2025), DOI 10.1186/s40537-025-01236-0.

## Slide 66 — LLM + otimização bayesiana para germoplasma (2026)

**Tópicos**

- Hamazaki & Tsuda, bioRxiv 2026 — pré-print, sem revisão por pares
- LLM em 2 pontos da OB: warmstart zero-shot e substituto por in-context learning
- Entrada: passaporte (cultivar, país, subpopulação) ± PCs de SNPs; painel de arroz
- Sementes/panícula: menos genótipos avaliados até o melhor; proteína: ganho pequeno
- Com genômica, OB com processo gaussiano segue vencendo
- Ganho do LLM: fase inicial e coleções sem marcadores — o LLM não define θ nem ΔF

**Notas**

Usem este slide para ensinar leitura crítica de pré-print. Primeiro, marquem claramente que não passou por revisão por pares. Segundo, elogiem os autores por reportarem o resultado desfavorável à narrativa: quando há dados genômicos, a otimização bayesiana clássica com processo gaussiano continua sendo a melhor abordagem. Eles poderiam ter escondido isso e não esconderam. O desenho é elegante: o LLM entra em dois pontos do ciclo. No warmstart zero-shot, ele escolhe os genótipos iniciais a partir de informação textual de passaporte, como nome da cultivar, país de origem e subpopulação, opcionalmente com escores de componentes principais de SNPs. No modelo substituto, ele prevê o fenótipo de genótipos não testados por aprendizado em contexto. Para número de sementes por panícula, o warmstart reduziu o número de genótipos avaliados até chegar ao melhor; para teor de proteína, o ganho foi pequeno. Um caráter, um resultado — generalizar a partir de dois caracteres numa espécie seria exatamente o erro que estamos ensinando a evitar. A implicação mais interessante para o Brasil é contraintuitiva: se o ganho do LLM aparece onde falta genômica, o beneficiário natural não é quem genotipa tudo, é o banco de germoplasma com metadados ricos e poucos marcadores. E conectem com a Sessão 09: o LLM propõe o ponto de partida do espaço de busca, mas a função objetivo, θ e ΔF continuam sendo decisão do melhorista. Fontes: Hamazaki & Tsuda, bioRxiv (2026), DOI 10.64898/2026.06.28.735149; código github.com/KosukeHamazaki/RLLMBO.

## Slide 67 — Evidência dura: produtividade e alucinação

**Tópicos**

- METR RCT: 16 devs, 246 tarefas; previam −24%, sentiram −20%, mediram +19% de tempo
- METR (fev/2026): resultado de início de 2025 declarado desatualizado
- Citações fabricadas: GPT-3.5 55% · GPT-4 18%; 24% das reais com erro [Sci Rep 2023]
- GPT-4o: 19,9% fabricadas (35/176); 45,4% das reais com erros [JMIR MH 2025]
- Tópico pouco visível: 28–29% fabricadas vs. 6% em tópico popular [JMIR MH 2025]
- DOIs de citações falsas: 64% válidos, mas apontando para artigo não relacionado

**Notas**

Apresentem os três números da METR na ordem — previsão, percepção, realidade — e façam uma pausa antes do terceiro. Quase todos na sala vão apostar em aceleração; esse erro coletivo é mais pedagógico que o número. Sejam escrupulosos com as limitações: 16 participantes, repositórios maduros e familiares, ferramentas do início de 2025, e a própria METR declarou em fevereiro de 2026 que o resultado está desatualizado. Não usem isso para dizer que IA não ajuda. Usem para fixar algo mais robusto: a autopercepção de ganho não é evidência de ganho. Os participantes experimentaram a lentidão e ainda relataram aceleração. Se quiserem saber se a IA acelera o programa, meçam ciclos por ano, acurácia e retrabalho. Na parte de citações, as taxas variam entre estudos, e essa variação é informativa: depende de modelo, prompt e domínio. O achado que mais importa é o gradiente por familiaridade do tema: 6 por cento de fabricação em depressão maior contra 28 a 29 por cento em transtornos pouco estudados. Traduzam para o melhoramento: a literatura se concentra em milho, trigo, arroz e soja em ambientes temperados. Quem trabalha com culturas e patossistemas de nicho enfrenta taxas piores que as dos benchmarks. O detalhe dos DOIs é perverso: 64 por cento dos DOIs das citações falsas funcionavam, mas levavam a outro artigo. O teste do link funciona falha; o único teste válido é abrir e ler. Fontes: METR, arXiv:2507.09089 e atualização fev/2026; Walters & Wilder, Sci Rep 2023 (DOI 10.1038/s41598-023-41032-5); JMIR Mental Health 12:e80371 (2025).

## Slide 68 — Mapa de governança: o que vale, onde e desde quando

**Tópicos**

- NIST AI RMF 1.0 (jan/2023) + GenAI Profile AI 600-1 (jul/2024): voluntários
- EU AI Act: GPAI ago/2025 · maioria das regras 02/ago/2026 [AI Act Service Desk]
- Alto risco: Anexo III 02/dez/2027 · Anexo I 02/ago/2028 (AI Omnibus, jul/2026)
- Agricultura fora do Anexo III; pulverização que ignora pessoas = componente de segurança
- ISO/IEC 42001:2023: AIMS certificável, 38 controles no Anexo A
- Brasil: PL 2338/2023 aguardando parecer na Câmara (out/2026); vale a LGPD art. 20
- FAO: a IA explica, o modelo estatístico estima; CARE complementa FAIR

**Notas**

Este slide combate duas distorções comuns. A primeira é a ideia de que a União Europeia proibiu IA na agricultura. É falsa e verificável: a orientação oficial do AI Act Service Desk cita drones e robôs agrícolas usados para previsão de produtividade ou otimização de irrigação como exemplos de sistemas que não são componentes de segurança. A segunda distorção é concluir que nada se aplica. Também falso: o mesmo documento cita um sistema que direciona pulverização sem considerar a presença de pessoas próximas como componente de segurança, e portanto alto risco quando integrado a máquinas ou veículos agrícolas regulados. A fronteira não é o setor, é a função: a falha pode ferir alguém? As datas do EU AI Act mudaram com o AI Omnibus, em vigor desde 27 de julho de 2026; as regras de alto risco ficaram para dezembro de 2027 e agosto de 2028. Sobre o Brasil, sejam precisos: a ficha de tramitação da Câmara mostra o PL 2338/2023 aguardando parecer do relator na Comissão Especial, sem parecer protocolado, e o relator indicou votação só depois das eleições de outubro de 2026. Mas vácuo legislativo não é vácuo normativo: a LGPD, com o direito de revisão de decisões automatizadas do artigo 20, a Lei 13.123, a Lei de Cultivares e os contratos já criam deveres exigíveis. Fechem com a FAO, que oferece o princípio mais transponível para um programa de melhoramento: separar quem explica de quem estima. Fontes: NIST AI 600-1 (DOI 10.6028/NIST.AI.600-1); AI Act Service Desk, timeline e high-risk in regulated products; ISO/IEC 42001:2023; Câmara, ficha PL 2338/2023; FAO Data Lab; Carroll et al. 2020.

## Slide 69 — Propriedade intelectual: as camadas sobre uma cultivar

**Tópicos**

- Lei 9.456/1997: proteção de 15 anos; 18 para videiras, fruteiras, florestais, ornamentais
- UPOV Ata 1978 via Decreto 3.109/1999 — o Brasil não aderiu à Ata de 1991
- Patentes (LPI 9.279/1996) para eventos, genes e métodos; planta per se não
- Segredo de negócio: germoplasma elite, pedigrees, BLUPs — a camada que a IA ameaça
- Lei 13.123/2015: cadastro SisGen antes de remessa, PI, venda ou divulgação de resultados
- Repartição monetária: 1% da receita líquida, redutível a 0,1% por acordo setorial

**Notas**

Organizem a discussão em torno de uma pergunta: que camada de proteção a IA realmente ameaça? Proteção de cultivares e patentes são relativamente robustas, porque são registros públicos com escopo definido. A camada vulnerável é o segredo de negócio: germoplasma elite, pedigrees, dados de ensaio, BLUPs e modelos de predição. O segredo depende de medidas razoáveis de sigilo, e colar esses dados num serviço externo pode ser lido como abandono dessas medidas. Não é preciso haver vazamento público; a perda de controle já enfraquece a posição jurídica. Enfatizem o Decreto 8.772/2016: o cadastro no SisGen deve preceder a remessa, o pedido de qualquer direito de propriedade intelectual, a comercialização de produto intermediário e a divulgação de resultados, inclusive parciais, em meios científicos. Estudantes de pós-graduação frequentemente descobrem isso depois do resumo em congresso. Vale perguntar diretamente quem na sala tem material em bancada cujo acesso ainda não foi cadastrado. Sobre a UPOV, o fato de o Brasil estar na Ata de 1978 e não na de 1991 é tecnicamente relevante: preserva mais espaço para o uso próprio pelo agricultor e para a isenção do melhorista. Há pressão recorrente por adesão à Ata de 1991, mas não antecipem desfecho. A repartição monetária da Lei 13.123 é de 1 por cento da receita líquida anual, com possibilidade de redução para 0,1 por cento por acordo setorial — números que voltarão no dilema do alelo. Fontes: Lei 9.456/1997 art. 11; Decreto 3.109/1999; Lei 13.123/2015 arts. 16, 20 e 21; Decreto 8.772/2016 art. 20.

## Slide 70 — DSI: Fundo de Cali e Sistema Multilateral

**Tópicos**

- CDB COP16, Decisão 16/2 (nov/2024): cria o Fundo de Cali para DSI
- Taxa indicativa: 1% do lucro ou 0,1% da receita anual
- Entidade grande = 2 de 3: ativos ≥ US$ 20 mi · vendas ≥ US$ 50 mi · lucro ≥ US$ 5 mi
- Pesquisa pública e academia sem benefício comercial: isentas
- ≥ 50% do fundo para povos indígenas e comunidades locais; taxas finais na COP17
- TIRFAA GB-11 (nov/2025): pacote do Sistema Multilateral adiado à GB-12; DSI em grupo ad hoc

**Notas**

Comecem explicando por que DSI é a questão que define a próxima década do melhoramento. O Protocolo de Nagoya foi pensado para material físico cruzando fronteiras. Hoje, o valor atravessa a fronteira como arquivo de sequência, e nenhum frasco se move. E modelos de IA treinados em sequências públicas tornam essa questão ainda mais aguda. O Fundo de Cali, criado pela Decisão 16/2 na COP16 da Convenção sobre Diversidade Biológica, é a primeira tentativa multilateral de endereçar isso. Sejam precisos com os números, porque são frequentemente mal citados. A taxa é indicativa, não obrigatória. O critério de entidade grande é atender dois de três limiares, em média dos últimos três anos, e não todos os três. A pesquisa pública e acadêmica que usa DSI sem se beneficiar comercialmente está isenta, o que responde à pergunta que a turma fará sobre a própria UFV. Pelo menos metade do fundo deve apoiar necessidades autodeterminadas de povos indígenas e comunidades locais. E taxas e limiares definitivos serão fixados na COP17. O contraponto sóbrio vem do Tratado Internacional sobre Recursos Fitogenéticos: na GB-11, em novembro de 2025, não houve consenso sobre o pacote completo. Taxas, limiares e a expansão do Anexo I ficaram para a GB-12, e DSI foi para um grupo consultivo ad hoc. Países em desenvolvimento da Ásia, América Latina e Oriente Próximo registraram discordância com a arquitetura de pagamento. A mensagem: é um regime em disputa ativa, e esta geração vai participar das decisões. Fontes: CBD, Decisão 16/2 e Guide to the Cali Fund; IISD/ENB, ITPGRFA GB-11 Summary (nov/2025).

## Slide 71 — Quem inventa um alelo projetado por IA?

**Tópicos**

- UKSC 49/2023 (Thaler/DABUS): inventor deve ser pessoa natural — decisão unânime
- USPTO (fev/2024): IA-assistida é patenteável se humano contribui em cada reivindicação
- Fatores Pannu: concepção significativa · qualidade não trivial · mais que estado da técnica
- Só formular prompt ou reconhecer bom resultado: em geral insuficiente [USPTO 2024]
- Copyright EUA: autoria humana obrigatória (Thaler v. Perlmutter, D.C. Cir., mar/2025)
- Copyright Office (jan/2025): prompts, por si sós, não dão controle suficiente
- Caderno de lab agora inclui prompt, versão do modelo, seed e candidatos descartados

**Notas**

As decisões contam uma história coerente e, bem lida, tranquilizadora. A máquina não é inventora nem autora; isso está firme no Reino Unido e nos Estados Unidos, em patentes e em direito autoral. Na decisão unânime da Suprema Corte britânica, a propriedade da máquina DABUS também não deu a Thaler direito à patente. O que está em jogo, portanto, não é se a invenção assistida por IA é patenteável — a orientação do USPTO diz claramente que não é categoricamente impatenteável — mas se você consegue provar a sua própria contribuição. Leiam os três fatores Pannu em voz alta, porque o terceiro é o que mais derruba candidaturas: fazer mais do que explicar conceitos conhecidos ou o estado da técnica. E a exigência é por reivindicação: cada uma precisa de pelo menos um humano com contribuição significativa. Se o LLM fez o trabalho criativo e você fez apenas a curadoria, qual foi sua contribuição à concepção? A resposta pode ser excelente: definir o objetivo biológico, restringir o espaço de busca com conhecimento de fisiologia, escolher entre candidatos com critério técnico, desenhar a validação. Mas só vale se estiver registrado no momento, não reconstruído depois. Daí a consequência prática do último bullet: o caderno de laboratório ganhou campos novos. No Brasil, não localizamos orientação equivalente do INPI, ponto a verificar antes de qualquer afirmação. Fontes: Thaler v Comptroller-General [2023] UKSC 49; USPTO, Inventorship Guidance for AI-Assisted Inventions (13/fev/2024); Thaler v. Perlmutter, D.C. Cir. (18/mar/2025); U.S. Copyright Office, Copyright and AI Part 2 (jan/2025).

## Slide 72 — Confidencialidade: Samsung e as três camadas

**Tópicos**

- Samsung liberou ChatGPT em 11/mar/2023; 3 vazamentos em menos de 20 dias
- Código de metrologia, código de rendimento/defeito e transcrição de reunião colados
- Resposta: limite de 1.024 bytes/prompt; proibição temporária em 01/mai/2023
- Consumidor: nunca com dados do programa
- API/Enterprise: sem treino por padrão; ZDR sob contrato, cobertura parcial [OpenAI/Anthropic]
- Pesos abertos on-premise: padrão-ouro — levar o modelo até o dado [FAO Data Lab]
- Federado: Fed-LSH acha similaridade genômica em tomate sem expor dados [Front Plant Sci 2025]

**Notas**

O detalhe que torna o caso Samsung universal é que nenhum dos três funcionários agiu de má-fé. Um queria corrigir um erro de código, outro queria otimizar um programa, o terceiro queria uma ata de reunião. São as três coisas que qualquer pessoa nesta sala faria numa terça-feira. O aviso interno da empresa merece ser lembrado: uma vez enviado, o dado fica em servidor externo e não pode ser recuperado. Por isso a resposta mais eficaz não é apenas treinar as pessoas, é remover o atalho. A Samsung passou a desenvolver ferramentas internas; se existe um assistente aprovado que resolve o problema, ninguém recorre ao proibido. Traduzam para o melhoramento: colar uma matriz de BLUPs de linhagens elite com pedigrees num chat de consumidor equivale a publicar o programa de cruzamentos. Sobre as três camadas, sejam precisos. OpenAI e Anthropic declaram que não treinam com dados de API ou planos empresariais por padrão e oferecem retenção zero sob contrato, mas a cobertura não é universal: alguns endpoints e recursos ficam de fora, e a retenção zero precisa ser solicitada por organização. Leiam a documentação específica antes de confiar. A abordagem da FAO é a mais segura e replicável numa instituição pública brasileira: modelos de pesos abertos rodando em infraestrutura própria aprovada. E há alternativas técnicas reais em melhoramento: Fed-LSH faz busca de similaridade genômica entre instituições sem compartilhar dados brutos. Fontes: TechCrunch e Korea Herald (mai/2023); OpenAI Business Data; Anthropic API and data retention; FAO Data Lab Responsible AI; Liu et al., Front Plant Sci 2025 (DOI 10.3389/fpls.2025.1684243).

## Slide 73 — Agentes com ferramentas: a superfície de ataque

**Tópicos**

- OWASP MCP Top 10 (2025): tool poisoning, rug pull, shadowing, confused deputy
- Ferramenta revisada uma vez na conexão; respostas entram no contexto sem checagem
- Exfiltração por canal legítimo: o log mostra chamadas válidas conforme o contrato
- Allowlist de servidores MCP + saída estruturada validada por esquema
- Controle de acesso no servidor, nunca só no system prompt
- Ação irreversível: confirmação humana fora do contexto do LLM + log imutável
- Vocês já praticaram: deny-list em dados brutos e fluxo plan-first

**Notas**

Este é o slide de segurança, e vale conectá-lo explicitamente ao que a turma já praticou com o Claude Code. Quando configuraram deny-lists sobre dados brutos e exigiram plano antes da execução, estavam implementando controles que a OWASP só formalizou em 2025. Reforcem isso: eles têm a intuição correta e agora ganham o vocabulário. O Model Context Protocol tornou trivial conectar um agente a bancos de dados, APIs e arquivos — a Embrapa I/O, por exemplo, já expõe servidor MCP. Essa conveniência tem um custo. A causa raiz dos ataques é uma lacuna de confiança: a descrição da ferramenta é revisada uma vez, na conexão, mas as respostas da ferramenta entram direto no contexto do modelo, sem verificação equivalente. O item mais importante do slide é o quinto: não confiem no system prompt para restringir acesso. Escrever não leia arquivos fora de tal pasta é uma instrução em linguagem natural, e instruções em linguagem natural podem ser sobrescritas por outras que chegam via conteúdo externo — um PDF, uma página web, a resposta de uma ferramenta. A restrição tem que estar na camada de execução, onde o modelo não alcança. O rug pull merece um minuto extra porque é o mais contraintuitivo: você aprovou uma ferramenta legítima e ela mudou depois. Isso derruba a ideia de que revisar na conexão basta. Perguntem o que, no programa deles, um agente comprometido poderia exfiltrar sem que ninguém notasse, e em quanto tempo alguém notaria. Fontes: OWASP MCP Top 10 (2025); OWASP MCP Security Cheat Sheet; Microsoft for Developers, indirect prompt injection in MCP.

## Slide 74 — Viés de automação e a crítica da caixa-preta

**Tópicos**

- DSS com conselho errado: +26% de decisões erradas (RR 1,26; IC 1,11–1,44) [JAMIA 2011]
- Viés em 81% dos estudos (omissão) e 91% (comissão) [JAMIA 2016]
- O viés cresce quando verificar é caro — mesmo em tarefa única [JAMIA 2016]
- Meta-análise: OR 10,19 conselho certo vs. errado; 26,6% dos erros não corrigidos [npj 2026]
- Supervisão humana = capacidade de interceptação, não garantia [npj Digit Med 2026]
- Save Our Seeds (2025): caixa-preta, alucinação e ausência de causalidade em NGTs
- Contramedidas: model cards, datasheets, logs e trilhas de auditoria reproduzíveis

**Notas**

Este slide é o antídoto contra a frase confortável de que tudo bem, tem humano no circuito. Tem — e o humano falha de forma mensurável e previsível. A revisão de 2011 mostra que conselho errado de um sistema de apoio à decisão aumentou decisões erradas em 26 por cento frente a quem decidiu sem o sistema. A revisão de 2016 traz o achado mais acionável: o viés aparece quando a verificação é cognitivamente cara, mesmo em tarefa única, não apenas em multitarefa. Em melhoramento, verificar se um BLUP faz sentido exige reconstruir o modelo, checar a estrutura dos dados e pensar em interação genótipo por ambiente. É caro. Estamos exatamente na zona de risco. A meta-análise de 2026 fecha o argumento: supervisão humana deve ser avaliada como capacidade de interceptar erro, não presumida como garantia. A implicação de desenho, que conecta com a Sessão 10, é baratear a verificação: mostrar incerteza, expor os dados que sustentam a recomendação, sinalizar quando o caso está fora da distribuição de treino. Sobre o relatório When Chatbots Breed New Plant Varieties, corrijam a atribuição comum: é da Save Our Seeds, de janeiro de 2025, apresentado em workshop da Testbiotech em julho de 2025. O argumento mais forte não é a alucinação, é a causalidade: modelos identificam padrões, não mecanismos, e por isso não antecipam efeitos colaterais de intervenções genéticas extensas. É uma crítica científica séria e merece ser tratada assim. Fontes: Goddard et al., JAMIA 2011 (DOI 10.1136/amiajnl-2011-000089); Lyell & Coiera, JAMIA 2016; npj Digit Med 2026; Save Our Seeds 2025; Mitchell et al. 2019; Gebru et al. 2021.

## Slide 75 — Equidade e carreiras: quem fica de fora, quem entra

**Tópicos**

- Top 4 em sementes: 50% do mercado global; top 10: 63% (vendas 2024) [ETC/GRAIN 2026]
- Países de alta renda: 86% dos top-500 HPC e 97% da capacidade [World Bank 2025]
- Brasil hospeda 9 dos top-500 HPC: polo regional, longe da fronteira [World Bank 2025]
- Commodities principais: 3–4,5× mais verba que culturas menores, USDA 2008–19 [FSFS 2021]
- Contrapeso aberto: BrAPI, Breedbase, AlphaSimR; Embrapa I/O já expõe MCP/WebMCP
- EUA: 22.298 vagas/ano em C&E agro, com prioridade para IA e automação [USDA/Purdue]

**Notas**

Costurem equidade e carreira, porque são a mesma questão vista de dois ângulos. A concentração descreve um sistema em que a IA tende a amplificar vantagens existentes: metade do mercado comercial de sementes em quatro empresas, quase toda a capacidade de supercomputação em países ricos, e financiamento de pesquisa várias vezes maior para as commodities principais. Sobre o número de sementes, citem sempre o ano-base: as estimativas são de ONGs e a edição anterior, com vendas de 2023, indicava 56 por cento para o top 4. O mesmo relatório alerta para a corrida por dados públicos e de ecossistemas para treinar modelos, sem consulta ou compensação — o que conecta com os princípios CARE. O viés de financiamento tem consequência direta para LLMs: eles sabem muito sobre milho e pouco sobre feijão-caupi ou mandioca, e a fabricação cresce justamente onde a literatura é escassa. Mas há contrapesos reais. BrAPI, Breedbase e AlphaSimR são abertos e usados em mandioca, inhame, banana e batata-doce. A Embrapa já expõe MCP e WebMCP, então conectar agentes a dados agrícolas brasileiros é questão de configuração. Sobre carreira, a demanda é real; projeções específicas para melhoristas, como crescimento de cerca de 7 por cento até 2035 e mediana salarial próxima de 79 mil dólares, vêm de agregador secundário e estão a verificar no BLS. O perfil raro é quem domina genética quantitativa e opera agentes com disciplina. Fontes: ETC Group/GRAIN, Top 10 Agribusiness Giants 2026; World Bank, Digital Progress and Trends Report 2025; Front Sustain Food Syst 2021 (DOI 10.3389/fsufs.2021.794594); Breedbase G3 2022; USDA/Purdue 2025–2030.

## Slide 76 — Regras de engajamento

**Tópicos**

- Classifique o dado: público · interno · restrito (elite, pedigrees, BLUPs, produtores)
- Restrito só em pesos abertos on-premise ou API com DPA + ZDR — nunca chat de consumidor
- SisGen antes de divulgar; confira SMTA/TIRFAA e CPI/ARB da Lei 13.123/2015
- Deny-list em dados brutos, allowlist de MCP, plan-first, log imutável de ferramentas
- Toda referência checada no DOI; todo número reproduzido por código com seed fixa
- θ, ΔF, descarte e avanço: revisor nomeado e justificativa escrita independente da IA
- Documente prompt, modelo, data e escolhas humanas — sustenta inventoria (Pannu)

**Notas**

Este é o checklist condensado; a versão completa, organizada em antes de usar, configuração do agente, durante o uso, antes de decidir e depois, está no dossiê. Apresentem cada linha como resposta a um risco que já discutimos, para que não pareça burocracia solta. A classificação em três níveis responde ao caso Samsung: sem saber o que é restrito, ninguém sabe o que não colar. A regra de onde o dado restrito pode rodar responde às três camadas de confidencialidade e ao princípio da FAO de levar o modelo até o dado. O SisGen responde à armadilha da divulgação antes do cadastro, que pega estudantes de pós no primeiro congresso. Deny-list, allowlist, plan-first e log imutável respondem ao OWASP MCP Top 10 — e são exatamente o que a turma já configurou no curso. A checagem de DOI responde às taxas de fabricação de citações da Sessão 08, que pioram em temas de nicho. A exigência de reproduzir todo número por código com seed fixa implementa a separação entre explicar e estimar. O revisor nomeado com justificativa escrita independente responde ao viés de automação e ancora a Sessão 09: θ e ΔF são decisões humanas assinadas. E a documentação de prompt, modelo, data e escolhas humanas responde aos fatores Pannu: é o rastro que sustenta inventoria e titularidade. Sugiram que cada grupo de pesquisa adapte esta lista em uma página e a revise a cada trimestre, junto com o caderno adversarial. Fontes: dossie/05_breeder_aumentado_etica_ip.md, seção 8; OWASP MCP Top 10; Decreto 8.772/2016; USPTO 2024; FAO Data Lab.

## Slide 77 — Dilemas para o painel

**Tópicos**

- 1. Linhagem descartada pelo DSS era a única resistente: quem responde? (S09/S10)
- 2. Prompt genérico + triagem automática viraram patente: Pannu satisfeito? (IP)
- 3. Estagiária cola 1.800 BLUPs elite em chat de consumidor: o que é recuperável?
- 4. Servidor MCP muda após aprovação e exfiltra ensaios: que controle detectaria? (S05)
- 5. Alelo treinado em DSI de silvestre brasileira: SisGen, Fundo de Cali, ambos?

**Notas**

Usem os dilemas para abrir o painel com todos os palestrantes; escolham dois ou três conforme o tempo. No primeiro, o DSS recomenda descartar 40 por cento das linhagens do estágio 2, incluindo uma que o melhorista sênior defendia por resistência vista em campo; dois anos depois surge uma raça nova e aquela era a única fonte de resistência. A pergunta não é só quem responde, mas o que no fluxo teria forçado a interceptação — conectem com o viés de automação e com a Sessão 10. No segundo, um pós-doc usa um agente para propor 50 edições num promotor, uma funciona, o prompt foi genérico e a seleção foi feita por script. Os fatores Pannu estão satisfeitos? O que deveria ter sido registrado, e quando? No terceiro, uma estagiária cola a tabela de BLUPs de 1.800 linhagens elite com pedigrees num chat de consumidor para fazer um gráfico. O dano já ocorreu; o que é recuperável, e que controle teria impedido — treinamento, bloqueio técnico ou assistente interno aprovado? No quarto, um servidor MCP comunitário muda a descrição de uma ferramenta depois de aprovado e passa a carregar blocos codificados com dados de ensaios; cada chamada era válida conforme o contrato. Que controle detectaria e qual preveniria? No quinto, sequências públicas de uma espécie silvestre brasileira treinam um modelo que projeta um alelo usado numa cultivar comercial. Há obrigação pelo SisGen, pelo Fundo de Cali, por ambos ou por nenhum? E se fosse um laboratório público sem exploração comercial? Fontes: dossie/05_breeder_aumentado_etica_ip.md, seção 9; Lei 13.123/2015; CBD Decisão 16/2; USPTO 2024; OWASP MCP Top 10.

## Slide 78 — Bloco 5 — Take-home

**Tópicos**

- Agentes já descobrem e validam — mas benchmark não é produção (0,91 → 0,64) [JBD 2025]
- Percepção de ganho não é ganho: METR mediu +19% de tempo sob sensação de aceleração
- Brasil sem lei de IA, mas não sem regras: LGPD, Leis 13.123 e 9.456, contratos
- A máquina não inventa nem é autora: seu rastro documentado é o seu título
- Hábito 1 — preveja antes de perguntar: sinal, magnitude e incerteza por escrito
- Hábito 2 — verifique o caro, não o fácil · Hábito 3 — mantenha um caderno adversarial
- O agente acelera; quem assina é você

**Notas**

Fechem retomando a pergunta-guia e respondendo-a explicitamente: o agente acelera, e quem assina é você. As quatro primeiras linhas condensam o bloco. Agentes já produzem descobertas validadas, mas a queda de precisão de 0,91 para 0,64 no Chat-RGIE lembra que benchmark não é produção. A percepção de ganho não substitui medição, como mostrou a METR, ainda que com ferramentas já superadas. O Brasil ainda não tem lei específica de IA, mas a LGPD, a Lei de Acesso ao Patrimônio Genético, a Lei de Cultivares e os contratos já criam deveres exigíveis hoje. E a máquina não é inventora nem autora: o que sustenta a titularidade é o rastro documentado da contribuição humana. Os três hábitos são a parte mais durável do bloco, porque não dependem de qual modelo estará em uso no ano que vem. Prever antes de perguntar obriga o melhorista a ter uma hipótese própria; quando a IA discorda, isso vira investigação, não ajuste silencioso do palpite. Verificar o caro, não o fácil, aplica diretamente a evidência sobre viés de automação: o erro passa exatamente onde verificar dá trabalho, então o tempo de verificação deve ser proporcional ao custo da decisão. Manter um caderno adversarial, registrando onde a IA errou na sua cultura e no seu patossistema, constrói em poucos meses um mapa de confiabilidade que nenhum benchmark publicado oferece. Encerrem convidando para o painel de perguntas. Fontes: Wei & Fan 2025; METR 2025/2026; Lei 13.709/2018; Lei 13.123/2015; Lei 9.456/1997; USPTO 2024; Lyell & Coiera 2016.

## Slide 79 — Síntese dos três dias

**Tópicos**

- Sem dado limpo e governado, não há modelo útil
- Agente acelera; regra científica e permissão limitam
- Predição sem validação fora da amostra engana, em GBLUP e em gLM
- Otimização sem diversidade, prazo e custo quebra o programa
- Event, edição e molécula ampliam o menu; não substituem a seleção
- A assinatura do avanço continua humana

**Notas**

Leia as seis frases devagar. Cada uma aponta para uma sessão: dado (04), agente (05), validação (06 e bloco 1), otimização (09 e blocos 2 e 4), menu novo (blocos 2 e 3), responsabilidade (bloco 5). Não acrescente uma sétima. Se sobrar um minuto, peça que cada aluno escolha a frase que mais muda o trabalho dele na segunda-feira. Fontes: síntese da Sessão 11.

## Slide 80 — O que perguntar no próximo estágio ou emprego

**Tópicos**

- Qual é a unidade de decisão: parcela, linhagem, híbrido ou event?
- Como validam: por ano, por família, por ambiente não testado?
- Onde roda o modelo, e o que é proibido colar num chat?
- Quem é dono do dossiê de event ou de edição, e qual o calendário?
- O simulador é pedagógico ou está acoplado à operação?
- Quem assina o go/no-go quando o score é alto e o CV é ruim?

**Notas**

Este slide é mais útil que uma lista de papers. Leia as seis perguntas como checklist de entrevista e de diagnóstico de programa. A última é a que separa breeder aumentado de automação: score alto com ensaio ruim é exatamente o caso em que o viés de automação passa. Ligue à Sessão 06, acurácia otimista, e ao bloco 5, interceptação de erro. Fontes: blocos 1 a 5.

## Slide 81 — Próximos passos

**Tópicos**

- Dossiês desta pasta: cinco textos com tabela, número e DOI
- leitura_rapida.md: uma leitura por bloco, não o dossiê inteiro
- Borém e Bhering (2026), Inteligência Artificial no Agro, Editora UFV
- Revisitar 04–09 com o mapa desta tarde, não para repetir o lab
- Caminhos: pesquisa, indústria de sementes, data science no agro

**Notas**

Não peça que leiam os cinco dossiês. Peça um: o do bloco que mais encostou no projeto de cada um. A leitura rápida é o caminho de 40 minutos. O livro do programa é a referência de prateleira. Reforce que o repositório do curso continua sendo o lugar para praticar dado, código, GS e OCS; esta sessão não substitui isso. Fontes: README da sessão; Borém e Bhering 2026.

## Slide 82 — Perguntas e painel

**Tópicos**

- Uma pergunta da plateia antes de o instrutor fechar
- Se a sala estiver quieta: roteiro_qa.md, dez perguntas-guia
- Regra: implicação para o programa, não tutorial de ferramenta
- Cinco dilemas do bloco 5 cabem aqui se o tempo permitir

**Notas**

Abra o microfone. Se ninguém falar em 20 segundos, use a pergunta 1 do roteiro: o que quebra primeiro, o foundation model desatualizado ou o caderno de campo sujo? Mantenha cada troca em dois a quatro minutos. Se a resposta virar tutorial de AlphaFold ou de CRISPR, redirecione para a decisão do programa. Reserve cinco minutos finais para agradecimento. Fontes: roteiro_qa.md.

## Slide 83 — Encerramento

**Tópicos**

- Obrigado pela intensidade dos três dias
- UFV · Bayer · Instituto IDATA
- FIT 796 — AI in Plant Breeding
- borem@ufv.br · gen@ufv.br
- +55 31 3612-2354 · +55 31 3612-2355

**Notas**

Agradecimento curto. Não reabra conteúdo. Lembre os contatos do README do curso e que o material fica no repositório. Fontes: README do curso.

