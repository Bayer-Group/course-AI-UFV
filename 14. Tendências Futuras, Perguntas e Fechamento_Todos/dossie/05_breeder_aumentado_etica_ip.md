# O MELHORISTA AUMENTADO POR IA
### Agentes autônomos, governança, propriedade intelectual, soberania de dados e carreiras no melhoramento de plantas

**Material de aula — Curso "IA no Melhoramento de Plantas", UFV, nov/2026**
*Sessão 11, Bloco 5 — integra Sessões 05 (governança), 08 (alucinações), 09 (humano decide θ/ΔF) e 10 (DSS)*

> Pergunta-guia: **o agente acelera — quem assina?**
> Todas as afirmações foram verificadas em fontes primárias em out/2026. Itens incertos estão marcados **[VERIFICAR]**.

---

## 1. Agentes de IA na ciência e no melhoramento (2024–2026)

### 1.1 O que mudou: de "chatbot" para "agente"

A diferença operacional entre um LLM e um **agente** é a capacidade de (i) decompor tarefas, (ii) chamar ferramentas externas, (iii) observar resultados e (iv) iterar sem intervenção humana a cada passo. Os alunos já viveram isso com o Claude Code: regras de permissão, *deny-lists* sobre dados brutos, fluxo *plan-first*. Esses três controles — **permissão, escopo de dados, plano antes da ação** — são exatamente o que a literatura de governança de 2025–2026 está formalizando.

**Sistemas de referência verificados:**

| Sistema | Ano | Arquitetura | Evidência de resultado |
|---|---|---|---|
| **Co-Scientist** (Google) | 2025 (blog/arXiv) / 2026 (Nature) | Multiagente sobre Gemini 2.0: Supervisor + agentes Generation, Reflection, Ranking, Evolution, Proximity, Meta-review; torneios evolutivos e escalonamento de *test-time compute* | Reposicionamento de fármacos para LMA validado *in vitro*; alvos epigenéticos para fibrose hepática validados em organoides |
| **Robin** (FutureHouse) | mai/2025 | Orquestra agentes Crow, Falcon e Finch (literatura + análise de dados) em ciclo *lab-in-the-loop* | Identificou e validou ripasudil (inibidor de ROCK) para DMRI seca |
| **Kosmos** (Edison Scientific) | nov/2025 | Modelo de mundo estruturado; ~200 *rollouts*, ~1.500 artigos lidos e ~42.000 linhas de código por execução (até 12 h) | 79,4% das afirmações julgadas corretas; ~6 meses de trabalho por execução de 20 ciclos — **auto-reportado pela empresa [VERIFICAR]** |
| **AI Scientist-v2** (Sakana) | abr/2025 | Busca em árvore agêntica, pipeline end-to-end até o manuscrito | 1 de 3 manuscritos passou revisão em workshop do ICLR 2025 (notas 6/7/6, média 6,33), **retirado antes da publicação** por protocolo prévio. Os autores relatam citações imprecisas e rigor abaixo do padrão de conferência principal |
| **CRISPR-GPT** | jul/2025, *Nat. Biomed. Eng.* | User proxy + LLM planner + Task executor + Tool provider; 4 modalidades de edição; *benchmark* de 288 casos | Nocaute de 4 genes com Cas12a em A549 e ativação de 2 genes com dCas9 em melanoma |
| **BioDiscoveryAgent** | 2024–25 (ICLR 2025) | Agente *closed-loop* de perturbações genéticas, sem modelo treinado nem função de aquisição | +21% de perturbações relevantes e +46% em genes não essenciais vs. baselines de otimização bayesiana |
| **GeneGPT** | fev/2024, *Bioinformatics* | Codex gera URLs de E-utils/BLAST do NCBI; decodificação aumentada detecta e executa a chamada | Média 0,83 em 8 tarefas do GeneTuring (vs. 0,44 do Bing, 0,12 do ChatGPT) |

### 1.2 O que já existe especificamente em germoplasma

**Chat-RGIE** (Wei & Fan, *J. Big Data* 12:202, 2025) extrai dados de passaporte de germoplasma de arroz — nome da variedade, parentais, caracteres agronômicos, qualidade, produtividade, resistência — de forma *zero-shot*, com votação entre múltiplas respostas e um componente de calibração.

| Avaliação | Precisão | Revocação | Acurácia | Taxa de alucinação |
|---|---|---|---|---|
| Controlada | 0,9102 | 0,9941 | 0,9554 | 0,0015 |
| Dados reais | **0,6351** | 1,0 | 0,8225 | 0,005 |

A queda de ~0,91 para ~0,64 ao sair do ambiente controlado é a lição central: *benchmark* não é produção. Revocação 1,0 com precisão 0,64 significa que o sistema não perde informação, mas adiciona informação errada → **IA para varredura exaustiva, humano para filtrar**.

**Hamazaki & Tsuda** (bioRxiv, 2026 — **pré-print, não revisado por pares**) acoplaram LLMs a otimização bayesiana (OB) para seleção de genótipos em painel de arroz, em dois pontos: *warmstarting zero-shot* (o LLM propõe genótipos iniciais a partir de passaporte — cultivar, país de origem, subpopulação — opcionalmente com PCs de SNPs) e modelo substituto por *in-context learning*. Resultados:

- Número de sementes por panícula: *warmstart* reduziu o número de genótipos avaliados até chegar ao melhor.
- Teor de proteína: ganho pequeno.
- **Com dados genômicos, a OB com processo gaussiano segue sendo a melhor abordagem.**
- Sem dados genômicos, predições a partir de passaporte superaram estratégias aleatórias.

> **Leitura para a Sessão 09:** o LLM aqui não decide θ nem ΔF. Ele propõe o ponto de partida do espaço de busca. A função objetivo e o critério de ganho continuam sendo do melhorista. E o beneficiário natural é o banco de germoplasma com metadados ricos e poucos marcadores.

### 1.3 Evidência sobre produtividade e erro

- **METR (RCT, fev–jun/2025):** 16 desenvolvedores experientes, 246 tarefas reais em repositórios próprios, alocação aleatória com/sem IA (sobretudo Cursor Pro + Claude 3.5/3.7 Sonnet). Tarefas levaram **19% mais tempo com IA**. Antes, previam 24% de aceleração; depois, ainda acreditavam ter sido 20% mais rápidos. Especialistas em economia e ML previam 39% e 38% de redução. **Ressalva:** a METR declarou em fev/2026 que o resultado está desatualizado e publicou dados novos.
- **Citações fabricadas:**
  - GPT-3.5: 55% fabricadas; GPT-4: 18% fabricadas; 24% das referências reais do GPT-4 com erros substantivos (*Sci. Rep.*, 2023; 636 citações, 42 temas).
  - PNAS 2024: 5,40% de alucinação em 500 referências (GPT-4) vs. 36,00% (GPT-3.5).
  - GPT-4o (JMIR Mental Health, 2025): **19,9% fabricadas (35/176)**; **45,4% das reais com erros**; 64% dos DOIs de citações fabricadas eram válidos mas apontavam para artigos não relacionados; fabricação de 28–29% em transtornos pouco pesquisados vs. 6% em depressão maior.
  - **Extrapolação: quanto mais nichada a cultura ou o patossistema, maior o risco de fabricação.**
- **MCP e uso de ferramentas (OWASP MCP Top 10, 2025):** *tool poisoning*, *rug pull* (ferramenta muda depois de aprovada), *tool shadowing*, *confused deputy* (servidor executa com privilégios próprios), exfiltração por canais legítimos, escopos excessivos, *shadow MCP servers*, ausência de auditoria. Causa raiz: descrições de ferramentas são revisadas na conexão, mas **as respostas entram no contexto do LLM sem verificação equivalente**.

---

## 2. Governança: o mapa de frameworks

| Framework | Natureza | Escopo | Status (out/2026) | Relevância para melhoramento |
|---|---|---|---|---|
| **NIST AI RMF 1.0** | Voluntário, EUA | Govern / Map / Measure / Manage | Publicado jan/2023 | Vocabulário comum para SOPs internos |
| **NIST AI 600-1 (GenAI Profile)** | Perfil setorial cruzado | Riscos novos ou agravados por IA generativa | Publicado 26/jul/2024 (DOI 10.6028/NIST.AI.600-1) | Lista de riscos pronta para adaptar |
| **EU AI Act** | Vinculante, UE | 4 níveis de risco | Vigor 01/ago/2024. Proibições + letramento: 02/fev/2025. GPAI: 02/ago/2025. Maioria das regras e Art. 50: 02/ago/2026. **Alto risco Anexo III: 02/dez/2027. Anexo I (produtos): 02/ago/2028** (datas revistas pelo *AI Omnibus*, em vigor 27/jul/2026) | **Agricultura não é área do Anexo III.** Previsão de safra e otimização de irrigação em drones/robôs explicitamente *não* são componentes de segurança. Mas IA como componente de segurança em máquinas/veículos agrícolas (Reg. 167/2013, Reg. Máquinas) é alto risco — ex.: trator autônomo anticolisão, pulverização que não considera pessoas próximas |
| **ISO/IEC 42001:2023** | Norma certificável | Sistema de Gestão de IA (AIMS) | Publicada 18/dez/2023; cláusulas 4–10; Anexo A com 38 controles; certificação por 3ª parte (ciclo de 3 anos); ISO/IEC 42006:2025 regula certificadores | Caminho para empresas de sementes demonstrarem governança |
| **PL 2338/2023 (BR)** | Projeto de lei | Marco legal da IA | Aprovado no Senado; na Câmara: **"Aguardando Parecer do(a) Relator(a)"** na Comissão Especial, zero pareceres. Relator Aguinaldo Ribeiro (PP-PB) indicou votação após as eleições de out/2026. PL 6237/2025 (Executivo, cria o SIA) apensado em 2026 | **Brasil ainda sem marco legal de IA em vigor** |
| **LGPD (Lei 13.709/2018)** | Vinculante, BR | Dados pessoais | Art. 20: revisão de decisões unicamente automatizadas; §1º critérios e procedimentos (ressalvado segredo); §2º auditoria pela ANPD. ANPD publicou a **Nota Técnica 12/2025** (mai/2025), ainda sem regulamentação final do art. 20 | Dados de produtores, geolocalização de ensaios, imagens de campo com pessoas |
| **FAO — Responsible AI (Data Lab)** | Princípios | Sistemas agroalimentares | Ativo: supervisão proporcional à tarefa; respostas rastreáveis com fontes; validação; rotulagem de conteúdo gerado; **IA explica, modelos estatísticos estimam**; pesos abertos em infraestrutura própria | Modelo transponível para um programa de melhoramento |
| **CGIAR — AI Co-Scientist Framework** | Princípios institucionais | Pesquisa agrícola | 2025 | Ciência centrada no humano, rigor/reprodutibilidade, ética, bens públicos digitais, equidade |
| **FAIR / CARE** | Princípios de dados | FAIR: dados; CARE: governança indígena | FAIR (Wilkinson, 2016); CARE (GIDA/RDA, 2019; *Data Sci. J.*, 2020) | CARE = Benefício Coletivo, Autoridade de Controle, Responsabilidade, Ética. Lema: **"Be FAIR and CARE"** |

**Regra prática:** o Brasil não está sem regras — está sem uma *lei específica de IA*. LGPD, Lei 13.123/2015, Lei 9.456/1997, contratos e política institucional já criam obrigações exigíveis.

---

## 3. Propriedade intelectual

### 3.1 Camadas de proteção sobre uma cultivar brasileira

| Objeto | Instrumento | Prazo / condição |
|---|---|---|
| Cultivar (DHE) | **Lei 9.456/1997**, SNPC/MAPA | **15 anos**; **18 anos** para videiras, fruteiras, florestais e ornamentais, incl. porta-enxertos (art. 11). Depois, domínio público |
| Convenção internacional | **UPOV Ata de 1978**, Decreto 3.109/1999 | Adesão em 23/abr/1999, vigente desde 23/mai/1999. **Não** é a Ata de 1991 |
| Evento transgênico, gene, método | Patente (LPI 9.279/1996) | 20 anos; plantas *per se* não são patenteáveis no Brasil |
| Germoplasma elite, pedigrees, dados de ensaio, modelos | **Segredo de negócio** | Enquanto houver medidas razoáveis de sigilo — a camada que a IA ameaça |
| Acesso a patrimônio genético | **Lei 13.123/2015 + Decreto 8.772/2016 (SisGen)** | Cadastro **prévio** a remessa, pedido de PI, comercialização de produto intermediário, divulgação de resultados ou notificação de produto acabado. Repartição monetária: **1% da receita líquida anual**, redutível a **0,1%** por acordo setorial (arts. 20–21) |

### 3.2 DSI: o Fundo de Cali e o TIRFAA

**CDB COP16 (Cali), Decisão 16/2, 01/nov/2024** — cria o **Fundo de Cali**:

| Parâmetro | Valor |
|---|---|
| Taxa indicativa | **1% do lucro OU 0,1% da receita** anual |
| Quem contribui | Entidades grandes que atendam **2 de 3** critérios (média trienal): ativos ≥ US$ 20 mi; vendas ≥ US$ 50 mi; lucro ≥ US$ 5 mi |
| Isenções | Academia e pesquisa pública que não se beneficiam comercialmente |
| Destinação | ≥ 50% para necessidades autodeterminadas de povos indígenas e comunidades locais |
| Escopo | DSI pública, não sujeita a termos mutuamente acordados restritivos e não coberta por outro instrumento de ABS |
| Definitivo | Taxas e limiares fixados na **COP17** |

**TIRFAA GB-11 (nov/2025):** não adotou o pacote completo de aprimoramento do Sistema Multilateral. A proposta de compromisso adiou taxas, limiares e emenda do Anexo I para a GB-12; criou grupo técnico sobre expansão do Anexo I e grupo consultivo *ad hoc* sobre DSI/GSD. Países em desenvolvimento da Ásia, ALC e Oriente Próximo registraram discordância com a arquitetura de pagamento. **Regime em construção ativa.**

### 3.3 Quem é inventor de um alelo projetado por IA?

| Jurisdição / área | Decisão | Conteúdo |
|---|---|---|
| Patente — Reino Unido | *Thaler v. Comptroller-General* [2023] UKSC 49 (20/dez/2023) | Unânime: inventor **deve ser pessoa natural**; DABUS não pode; propriedade da máquina não dá direito à patente |
| Patente — EUA | USPTO, *Inventorship Guidance for AI-Assisted Inventions* (13/fev/2024) | Invenções assistidas por IA não são categoricamente impatenteáveis; cada reivindicação exige humano com contribuição significativa pelos **fatores Pannu**: (1) contribuição significativa à concepção ou redução à prática; (2) não insignificante em qualidade; (3) mais do que explicar conceitos conhecidos/estado da técnica. Apenas formular prompt ou reconhecer o resultado geralmente não basta |
| Direito autoral — EUA | *Thaler v. Perlmutter*, D.C. Cir. (18/mar/2025) | Copyright Act exige autoria humana |
| Direito autoral — EUA | Copyright Office, *Copyright and AI, Part 2* (29/jan/2025) | Material puramente gerado por IA não é protegido; **prompts, por si sós, não dão controle suficiente** |
| Brasil — INPI | — | Não localizada orientação equivalente **[VERIFICAR]** |

> **Implicação:** o pipeline que gerou o candidato não é inventor. Quem definiu o objetivo biológico, restringiu o espaço de busca, selecionou com critério técnico e validou experimentalmente, sim — **se estiver documentado**. O caderno de laboratório agora inclui prompts, versão do modelo, *seeds*, candidatos descartados e logs de decisão.

---

## 4. Confidencialidade de dados com LLMs

### 4.1 O caso Samsung (2023)

A divisão de semicondutores liberou o ChatGPT em 11/mar/2023. Em menos de 20 dias, três incidentes: (1) código-fonte de programa de download de base de metrologia de equipamentos colado para correção; (2) código de identificação de rendimento/defeito colado para otimização; (3) transcrição de reunião colada para gerar ata. Medidas: limite de 1.024 bytes por prompt; aviso interno de que o dado, uma vez enviado, fica em servidor externo e não pode ser recuperado; a partir de 01/mai/2023, restrição temporária de IA generativa em dispositivos corporativos, com sanção até demissão.

**Tradução:** colar a matriz de BLUPs de linhagens elite com pedigrees num chat de consumidor equivale funcionalmente a publicar o programa de cruzamentos.

### 4.2 Consumidor vs. empresa vs. local

| Camada | Dado usado para treino? | Retenção | Uso recomendado |
|---|---|---|---|
| Chat de consumidor | Pode ser, conforme configuração do usuário | Longa | **Nunca** com dados do programa |
| API / Enterprise (OpenAI) | **Não por padrão**; treino só com *opt-in* | ZDR para endpoints elegíveis; alguns ainda guardam estado | Aceitável com DPA |
| API comercial (Anthropic) | Dado retido não usado para treino sem permissão expressa | ZDR por organização, mediante solicitação; nem todo recurso coberto | Aceitável com DPA |
| **Pesos abertos on-premise** | Não sai da infraestrutura | Controlada pela instituição | **Padrão-ouro para dado restrito** — "levar o modelo até o dado" (FAO) |

### 4.3 Alternativas técnicas

- **Aprendizado federado em agricultura:** revisão em *Comput. Electron. Agric.* 232 (2025) — criptografia homomórfica, MPC, privacidade diferencial; gargalos: heterogeneidade de dados, comunicação, capacidade computacional rural, confiança e propriedade dos dados.
- **Melhoramento:** **Fed-LSH** (*Front. Plant Sci.*, 2025) — busca de similaridade genômica multipartes sem compartilhar dados brutos; demonstrado em tomate (4 candidatos entre 10.000 fragmentos em < 0,5 s). **privateQTL** — mapeamento de eQTL federado via MPC.
- **Dados sintéticos, *clean rooms*, privacidade diferencial:** úteis para compartilhamento entre parceiros; nenhum exemplo verificado de uso em produção em programa de melhoramento brasileiro **[VERIFICAR]**.
- **Prompt injection e exfiltração:** um PDF ou página contaminada pode instruir o agente a codificar dados sensíveis numa consulta aparentemente inocente. Mitigações: *allowlist* de servidores MCP; saída estruturada validada por esquema; isolamento de ferramentas privilegiadas; **controle de acesso no servidor, não no system prompt**; confirmação humana fora do contexto do LLM para ações destrutivas; logs imutáveis.

---

## 5. Responsabilidade e prestação de contas

### 5.1 O viés de automação é mensurável

| Estudo | Achado |
|---|---|
| Goddard et al., *JAMIA* 2011 (74 estudos) | Conselho incorreto de DSS aumentou decisões erradas em **26%** (RR 1,26; IC95% 1,11–1,44) |
| Lyell & Coiera, *JAMIA* 2016 (40 estudos) | Viés em **81%** dos estudos (omissão) e **91%** (comissão); aparece mesmo em tarefa única quando a verificação é cognitivamente cara |
| *npj Digit. Med.* 2026 (meta-análise) | Acerto clínico muito maior com conselho certo vs. errado (**OR 10,19**; IC95% 7,43–13,98); **26,6%** das interpretações errôneas de ECG não corrigidas no mundo real. Supervisão humana deve ser avaliada como **capacidade de interceptação**, não presumida |

> **Isto é a Sessão 08 com números.** Se o output errado for plausível e a verificação for cara, ele será aceito — a menos que o processo force a verificação.

### 5.2 A crítica da caixa-preta nas NGTs

O relatório **"When Chatbots Breed New Plant Varieties"** é da **Save Our Seeds** (jan/2025); foi apresentado no workshop "AI & Genetic Engineering" da **Testbiotech** em 02/jul/2025 (daí a atribuição comum à Testbiotech). Riscos enumerados:

1. **Rebaixamento da barreira de competência** — edição genômica acessível a não especialistas.
2. **Caixa-preta** — falta de rastreabilidade e reprodutibilidade dificulta avaliação regulatória.
3. **Alucinações** — resultados plausíveis e errados, com frequência ainda indeterminada.
4. **Distorção de dados** — vieses de treino propagam-se; modelos **não têm compreensão causal**, o que limita antecipar efeitos colaterais.

No mesmo workshop foi apresentado o desenho do "blueprint genético de um milho inseticida NGT-1" com ferramenta de IA pública (ChatGPT 4o).

### 5.3 Quem responde quando uma recomendação de IA avança uma linhagem ruim?

Não há regra específica no Brasil. Na prática, a responsabilidade recai sobre quem decide e assina dentro da instituição; contratos com fornecedores raramente transferem risco de uso. Por isso a decisão precisa de **revisor humano nomeado, justificativa escrita independente do output e trilha reproduzível** (Sessões 09 e 10).

### 5.4 Instrumentos

- **Model Cards** (Mitchell et al., FAT\* 2019): uso pretendido, avaliação, desempenho por subgrupo, limitações. Em melhoramento, subgrupos = ambientes, grupos de maturação, classes de mercado, níveis de estresse.
- **Datasheets for Datasets** (Gebru et al., *CACM* 2021): motivação, composição, coleta, rotulagem, distribuição, manutenção e **usos não recomendados**.
- **Logs imutáveis** de invocação de ferramentas (OWASP MCP08).
- **Reprodutibilidade:** código versionado, *seed* fixa, versão do modelo e data.

---

## 6. Equidade e questões sociais

- **Concentração em sementes (ETC Group/GRAIN, atualização 2026, vendas 2024):** Bayer 20%, Corteva 17%, Syngenta 9%, BASF 4% → **top 4 = 50%** (US$ 28,2 bi de US$ 56 bi); top 10 = 63%. As mesmas quatro detêm 56% de agroquímicos. *Nota:* estimativas de ONGs; a edição anterior (vendas 2023) indicava 56% para o top 4. Citar sempre ano-base. O relatório alerta para a corrida por dados públicos e de ecossistemas para treinar modelos "GenBio" sem consulta, consentimento ou compensação.
- **Divisão de computação (World Bank, 2025):** países de alta renda têm **86% dos top-500 HPC e 97% da capacidade**; excluindo a China, países de baixa e média renda têm 3% dos sistemas e 1% da capacidade, com 65% da população. **Brasil hospeda 9** dos principais HPCs (polo regional, longe da fronteira). África Subsaariana: 0%. Estudo AIES 2024 classifica "Compute North", "Compute South" e "*compute deserts*".
- **Viés para culturas principais/temperadas:** USDA 2008–2019 destinou **3–4,5× mais verba** e 3–5× mais projetos às commodities principais do que a leguminosas e cereais menores (*Front. Sustain. Food Syst.*, 2021). Culturas órfãs frequentemente têm um único genoma de referência, sem genômica populacional (*Nat. Commun.*, 2024). Consequência: LLMs sabem mais sobre milho do que sobre feijão-caupi — e a fabricação cresce justamente nos tópicos sub-representados.
- **Contrapeso aberto:** **BrAPI** (especificação aberta desde 2014; v2 em *Database*, 2025), **Breedbase** (*G3*, 2022: mandioca, inhame, banana, batata-doce, trigo, arroz), **AlphaSimR** (simulação estocástica de programas em R).
- **Embrapa:** AgroAPI (Agrofit, Bioinsumos); **Embrapa I/O** já com **MCP Server e WebMCP** para agentes; **Brangus+IA** (Labegen/Embrapa Pecuária Sul) — chat sobre DEPs, percentis e acurácia para orientar acasalamentos.
- **Pequenos produtores:** o ganho do LLM sem genômica (Hamazaki & Tsuda) sugere oportunidade para coleções com poucos marcadores — hipótese, não evidência de impacto.

---

## 7. Competências e carreiras

**Demanda:** relatório USDA/Purdue 2025–2030 projeta **22.298 vagas anuais** em Ciência & Engenharia em alimentos/agricultura nos EUA, com crescimento em agronomia, melhoramento e sanidade vegetal, e prioridade dos empregadores em automação, robótica, IA e geoespacial. Projeções específicas para "plant breeder" (+6,7% em 2025–2035; ~1.400 vagas/ano; mediana US$ 78.850) vêm de agregador secundário do BLS **[VERIFICAR]**.

| Papel | Núcleo técnico | Onde quebra sem julgamento científico |
|---|---|---|
| Melhorista quantitativo | Modelos mistos, REML, BLUP/BLUE, G×E, teoria de seleção | Aceitar h² implausível que o modelo produziu |
| Cientista de dados de melhoramento | Pipelines, ontologias de caracteres, BrAPI, qualidade de dados | Juntar ensaios de ambientes incomparáveis |
| Engenheiro de ML em agro | Predição genômica, fenômica, MLOps | Vazamento treino/teste por estrutura familiar |
| Gestor de melhoramento digital | Arquitetura de dados, governança, integração DSS | Automatizar descarte sem *checkpoint* humano |
| Bioinformata / genômica | Montagem, variantes, pangenomas | Anotação funcional alucinada aceita como evidência |

**Quadro de competências:** ISCB Competency Framework v3 (*Bioinform. Adv.*, 2024) — 13 competências, de biociência a estatística, programação, gestão de dados e comunicação.

**Três hábitos para manter o julgamento científico:**
1. **Prever antes de perguntar** — escrever sinal, magnitude e incerteza esperados antes de rodar o agente. Discordância = investigação, não ajuste do palpite.
2. **Verificar o caro, não o fácil** — alocar tempo de verificação proporcional ao custo da decisão.
3. **Manter um caderno adversarial** — registrar onde a IA erra no seu domínio; em meses vira um mapa de confiabilidade próprio.

---

## 8. Regras de engajamento — checklist operacional

**Antes de usar (desenho)**
- [ ] Classifiquei o dado: **público** / **interno** / **restrito** (germoplasma elite, pedigrees, BLUPs não publicados, dados de produtores).
- [ ] Dado restrito só em modelo de pesos abertos *on-premise* ou API com DPA + ZDR. **Nunca** em chat de consumidor.
- [ ] Acesso a patrimônio genético nacional → cadastro no **SisGen antes** de divulgar resultados ou pedir PI.
- [ ] Origem do material verificada: SMTA (TIRFAA) ou CPI/ARB (Lei 13.123/2015).

**Configuração do agente**
- [ ] *Deny-list* sobre diretórios de dados brutos.
- [ ] *Allowlist* de servidores MCP aprovados.
- [ ] Modo *plan-first*: plano aprovado por humano antes da execução.
- [ ] Ferramentas privilegiadas isoladas de contexto que recebe conteúdo externo.
- [ ] Confirmação humana fora do contexto do LLM para ações irreversíveis.
- [ ] Log imutável de toda invocação de ferramenta.

**Durante o uso**
- [ ] Toda referência verificada no DOI/base primária (taxa-base de fabricação em tópicos nichados ~20–29%).
- [ ] Nenhum número entra em relatório sem reprodução por código versionado com *seed* fixa.
- [ ] A IA **explica**; o modelo estatístico **estima** — nada de BLUP, h² ou acurácia "narrados" pelo LLM.
- [ ] Prompt, versão do modelo, data e parâmetros registrados junto ao resultado.

**Antes de decidir**
- [ ] θ, ΔF, descarte ou avanço de geração com **revisor humano nomeado** e justificativa escrita independente da IA.
- [ ] Model card do preditor e datasheet do conjunto de treino atualizados.
- [ ] Ambiente-alvo representado nos dados de treino.

**Depois**
- [ ] Contribuição humana documentada para sustentar inventoria (**fatores Pannu**) e titularidade.
- [ ] Erros da IA registrados no caderno adversarial.
- [ ] Revisão trimestral: acertos, erros e mudanças regulatórias.

---

## 9. Dilemas para discussão

**Dilema 1 — A linhagem condenada (Sessões 09 + 10).** O DSS com camada de LLM recomenda descartar 40% das linhagens do estágio 2, incluindo uma que o melhorista sênior defende por resistência observada em campo não capturada no modelo. Vocês descartam. Dois anos depois surge uma raça nova do patógeno e a linhagem descartada era a única fonte de resistência. **Quem responde?** Fornecedor, melhorista que aprovou, diretor que exigiu corte de custo? O que no fluxo **forçaria** a interceptação?

**Dilema 2 — O prompt que virou patente (IP).** Um pós-doc usa um agente para propor 50 edições num promotor; uma funciona. O pedido nos EUA lista o pós-doc como único inventor. Descobre-se que o prompt foi genérico e a seleção entre os 50 foi feita por script automático. **Os fatores Pannu estão satisfeitos?** O que deveria ter sido documentado, e quando?

**Dilema 3 — O copiar-colar da safra (confidencialidade).** Uma estagiária cola a tabela de BLUPs de 1.800 linhagens elite, com pedigrees, num chat de consumidor para fazer um gráfico. Ela não conhecia a política. **O que é recuperável?** Que controle teria impedido: treinamento, bloqueio técnico ou assistente interno aprovado?

**Dilema 4 — O agente envenenado (MCP, Sessão 05).** O programa conecta um servidor MCP comunitário de bases de patógenos. Semanas depois, o mantenedor altera a descrição de uma ferramenta (*rug pull*); consultas passam a carregar blocos codificados com dados de ensaios. Cada chamada era válida conforme o contrato. **Que controle teria detectado? Qual teria prevenido?**

**Dilema 5 — O alelo e o fundo (DSI + soberania).** Sequências públicas de uma espécie silvestre brasileira, depositadas há 15 anos, treinam um modelo que projeta um alelo sintético de tolerância à seca, usado numa cultivar com receita de R$ 300 mi/ano. **Devido ao SisGen, ao Fundo de Cali, a ambos, a nenhum?** Use os critérios reais (Lei 13.123: cadastro prévio, 1% da receita líquida redutível a 0,1%; Cali: 1% do lucro ou 0,1% da receita, entidades grandes, exclusões de escopo). **E se o trabalho for de um laboratório público da UFV, sem exploração comercial?**

---

## Referências verificadas

**Agentes e IA científica**
1. Gottweis J. et al. *Towards an AI co-scientist.* arXiv:2502.18864 (2025). https://arxiv.org/abs/2502.18864
2. *Accelerating scientific discovery with Co-Scientist.* **Nature** (2026). https://www.nature.com/articles/s41586-026-10644-y
3. Ghareeb A.E. et al. *Robin: a multi-agent system for automating scientific discovery.* arXiv:2505.13400 (2025). https://arxiv.org/abs/2505.13400
4. Mitchener L. et al. *Kosmos: An AI Scientist for Autonomous Discovery.* arXiv:2511.02824 (2025). https://arxiv.org/abs/2511.02824
5. Yamada Y. et al. *The AI Scientist-v2.* arXiv:2504.08066 (2025). DOI 10.48550/arXiv.2504.08066 · Sakana: https://sakana.ai/ai-scientist-first-publication/
6. Qu Y. et al. *CRISPR-GPT for agentic automation of gene-editing experiments.* **Nat. Biomed. Eng.** (2025). DOI 10.1038/s41551-025-01463-z
7. Roohani Y. et al. *BioDiscoveryAgent.* ICLR 2025; arXiv:2405.17631. DOI 10.48550/arXiv.2405.17631
8. Jin Q., Yang Y., Chen Q., Lu Z. *GeneGPT.* **Bioinformatics** 40(2):btae075 (2024). DOI 10.1093/bioinformatics/btae075
9. Wei Y., Fan J. *Chat-rgie.* **J. Big Data** 12(1):202 (2025). DOI 10.1186/s40537-025-01236-0
10. Hamazaki K., Tsuda K. *Knowledge-guided Bayesian optimization using pre-trained LLMs speeds up the identification of superior genotypes from germplasm collection.* **bioRxiv** (2026), pré-print. DOI 10.64898/2026.06.28.735149 · Código: https://github.com/KosukeHamazaki/RLLMBO · Dados: DOI 10.5281/zenodo.20824616

**Produtividade, alucinação, viés**
11. Becker J. et al. *Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity.* arXiv:2507.09089. https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/ · Atualização: https://metr.org/blog/2026-02-24-uplift-update/
12. Walters W.H., Wilder E.I. *Fabrication and errors in the bibliographic citations generated by ChatGPT.* **Sci. Rep.** 13 (2023). DOI 10.1038/s41598-023-41032-5
13. *ChatGPT as Research Scientist.* **PNAS** (2024). DOI 10.1073/pnas.2404328121
14. *Influence of Topic Familiarity and Prompt Specificity on Citation Fabrication in Mental Health Research Using LLMs.* **JMIR Mental Health** 12:e80371 (2025). https://mental.jmir.org/2025/1/e80371
15. Goddard K., Roudsari A., Wyatt J.C. *Automation bias: a systematic review of frequency, effect mediators, and mitigators.* **JAMIA** (2011). DOI 10.1136/amiajnl-2011-000089
16. Lyell D., Coiera E. *Automation bias and verification complexity: a systematic review.* **JAMIA** (2016). https://pmc.ncbi.nlm.nih.gov/articles/PMC7651899/
17. *Human oversight of erroneous clinical AI and decision support: a systematic review and meta-analysis.* **npj Digit. Med.** (2026). https://www.nature.com/articles/s41746-026-03408-5

**Governança**
18. NIST. *AI RMF 1.0* (2023). https://www.nist.gov/itl/ai-risk-management-framework · *Generative AI Profile* (AI 600-1, jul/2024). DOI 10.6028/NIST.AI.600-1
19. Comissão Europeia. *Timeline for the Implementation of the EU AI Act.* https://ai-act-service-desk.ec.europa.eu/en/ai-act/timeline/timeline-implementation-eu-ai-act · *AI Omnibus enters into force.* https://digital-strategy.ec.europa.eu/en/news/ai-omnibus-enters-force
20. AI Act Service Desk. *High-risk AI in regulated products.* https://ai-act-service-desk.ec.europa.eu/en/high-risk-ai-regulated-products
21. *The EU AI Act and the Food System.* **Eur. J. Risk Regul.** (2025). https://www.cambridge.org/core/journals/european-journal-of-risk-regulation/article/eu-ai-act-and-the-food-system-how-the-european-union-ai-act-applies-to-agrifood/FAB3D22D58A7303173EB023C28ED8931
22. ISO/IEC 42001:2023. https://www.iso.org/standard/42001
23. Câmara dos Deputados. PL 2338/2023 — ficha de tramitação. https://www.camara.leg.br/proposicoesWeb/fichadetramitacao/?idProposicao=2487262
24. Lei 13.709/2018 (LGPD). https://www.gov.br/anpd/pt-br/centrais-de-conteudo/legislacao/lei-no-13-709-de-14-de-agosto-de-2018 · ANPD, Nota Técnica 12/2025/CON1/CGN/ANPD
25. FAO Data Lab. *Responsible AI.* https://www.fao.org/datalab/ai-and-innovation/responsible-ai/en
26. CGIAR. *Accelerating food-land-water systems research in CGIAR through responsible AI integration* (2025). https://hdl.handle.net/10568/180926
27. Carroll S.R. et al. *The CARE Principles for Indigenous Data Governance.* **Data Sci. J.** 19:43 (2020). DOI 10.5334/dsj-2020-043

**Propriedade intelectual e ABS**
28. Lei 9.456/1997. http://www.planalto.gov.br/ccivil_03/leis/l9456.htm · Decreto 3.109/1999. https://www.planalto.gov.br/ccivil_03/decreto/d3109.htm
29. Lei 13.123/2015. https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2015/lei/l13123.htm · Decreto 8.772/2016. https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2016/decreto/d8772.htm
30. CBD. Decisão 16/2, COP16 (01/nov/2024). https://www.cbd.int/doc/decisions/cop-16/cop-16-dec-02-en.pdf · *Guide to the Cali Fund.* https://www.cbd.int/califund/guides/guide%20to%20the%20cali%20fund%20english.pdf
31. IISD/ENB. *ITPGRFA GB-11 Summary Report*, 24–29/nov/2025. https://enb.iisd.org/plant-genetic-resources-food-agriculture-itpgrfa-gb11-summary
32. *Thaler v. Comptroller-General* [2023] UKSC 49. https://caselaw.nationalarchives.gov.uk/uksc/2023/49
33. USPTO. *Inventorship Guidance for AI-Assisted Inventions*, Federal Register (13/fev/2024). https://www.federalregister.gov/documents/2024/02/13/2024-02623/inventorship-guidance-for-ai-assisted-inventions
34. *Thaler v. Perlmutter*, No. 23-5233 (D.C. Cir., 18/mar/2025). https://media.cadc.uscourts.gov/opinions/docs/2025/03/23-5233.pdf · U.S. Copyright Office, *Copyright and AI, Part 2* (29/jan/2025). https://copyright.gov/ai/

**Confidencialidade, segurança, equidade, ferramentas**
35. The Register / TechCrunch / Korea Herald sobre o caso Samsung (abr–mai/2023). https://techcrunch.com/2023/05/02/samsung-bans-use-of-generative-ai-tools-like-chatgpt-after-april-internal-data-leak/
36. OpenAI. *Business data privacy.* https://openai.com/business-data/ · Anthropic. *API and data retention.* https://platform.claude.com/docs/en/manage-claude/api-and-data-retention
37. OWASP. *MCP Top 10 (2025).* https://owasp.org/projects/mcp-top-10 · *MCP Security Cheat Sheet.* https://cheatsheetseries.owasp.org/cheatsheets/MCP_Security_Cheat_Sheet.html
38. Dembani R. et al. *Agricultural data privacy and federated learning.* **Comput. Electron. Agric.** 232 (2025). DOI 10.1016/j.compag.2025.110048
39. Liu J. et al. *A framework for privacy-preserving similarity search of massive multi-party genomic data.* **Front. Plant Sci.** (2025). DOI 10.3389/fpls.2025.1684243
40. Mitchell M. et al. *Model Cards for Model Reporting.* FAT\* 2019. DOI 10.1145/3287560.3287596
41. Gebru T. et al. *Datasheets for Datasets.* **CACM** 64(12) (2021). DOI 10.1145/3458723
42. Save Our Seeds. *When Chatbots Breed New Plant Varieties* (2025). https://www.saveourseeds.org/wp-content/uploads/EN-with-summary_-online.pdf · Testbiotech workshop (02/jul/2025). https://www.testbiotech.org/en/events/july-2nd-2025-workshop-artificial-intelligence-genetic-engineering/
43. ETC Group / GRAIN. *Top 10 Agribusiness Giants — 2026 Update.* https://grain.org/en/article/7406
44. World Bank. *Digital Progress and Trends Report 2025: Strengthening AI Foundations.* https://www.worldbank.org/en/publication/dptr2025-ai-foundations/report · Lehdonvirta V. et al. *Compute North vs. Compute South.* AIES 2024. DOI 10.1609/aies.v7i1.31683
45. *Closing Research Investment Gaps for a Global Food Transformation.* **Front. Sustain. Food Syst.** (2021). DOI 10.3389/fsufs.2021.794594 · *The role of pangenomics in orphan crop improvement.* **Nat. Commun.** (2024). DOI 10.1038/s41467-024-55260-4
46. *BrAPI v2.* **Database** (2025). DOI 10.1093/database/baaf048 · Morales N. et al. *Breedbase.* **G3** 12(7):jkac078 (2022). DOI 10.1093/g3journal/jkac078
47. Embrapa. Brangus+IA: https://www.embrapa.br/busca-de-noticias/-/noticia/147920174/ · Embrapa I/O: https://www.embrapa.io/
48. USDA/Purdue. *Employment Opportunities 2025–2030 — Science & Engineering.* https://www.purdue.edu/usda/employment/2025-2030-report/science-engineering/
49. ISCB Competency Framework v3. **Bioinform. Adv.** 4(1):vbae166 (2024). DOI 10.1093/bioadv/vbae166

---

## Itens marcados [VERIFICAR] antes do uso em sala

- **Projeções BLS para "plant breeder"** (+6,7%, ~1.400 vagas/ano, mediana US$ 78.850): agregador secundário; confirmar em bls.gov/ooh.
- **Métricas do Kosmos** (79,4% de acurácia; ~6 meses por execução): auto-reportadas pela empresa.
- **Concentração em sementes:** estimativas de ONGs; 56% (base 2023) → 50% (base 2024). Citar ano-base.
- **Posição do INPI** sobre invenções assistidas por IA: não localizada.
- **Dados sintéticos/clean rooms em programas brasileiros:** sem exemplo verificado.
- **Hamazaki & Tsuda (2026):** pré-print, rotular como tal.
