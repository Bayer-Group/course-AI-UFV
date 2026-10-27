# LLMs, AI agents and industry in plant breeding: state of the art and outlook (Oct 2023 – Oct 2026)

## State of the art

Between late 2023 and 2026 the scientific AI agent moved from a demonstration to a published research method. [Boiko 2023](https://doi.org/10.1038/s41586-023-06792-0) showed that a GPT-4-driven system (Coscientist) could plan and run real laboratory experiments. By 2026 two closed-loop systems had appeared in *Nature*. Robin found ripasudil as a candidate treatment for dry macular degeneration, then designed its own follow-up RNA-seq experiment ([Ghareeb 2026](https://doi.org/10.1038/s41586-026-10652-y)). The AI Scientist produced a manuscript that passed first-round peer review at a machine-learning workshop with a 70% acceptance rate ([Lu 2026](https://doi.org/10.1038/s41586-026-10265-5)). Google's Co-Scientist reports that hypothesis quality keeps rising as test-time compute increases, and that its leukemia drug-repurposing candidates were validated in vitro ([Gottweis 2025](https://doi.org/10.48550/arXiv.2502.18864), preprint). Kosmos operates at the largest reported scale: 12-hour runs, about 42,000 lines of code and 1,500 papers per run, with 79.4% of statements judged accurate ([Mitchener 2025](https://doi.org/10.48550/arXiv.2511.02824), preprint).

These systems are generalists, and the same pattern is reaching specific domains. Biomni assembled its toolset by mining protocols from publications in 25 biomedical domains ([Huang 2025](https://doi.org/10.1101/2025.05.30.656746), preprint). CRISPR-GPT designs and analyses gene-editing experiments end to end ([Qu 2025](https://doi.org/10.1038/s41551-025-01463-z)). AutoBA writes, runs and repairs multi-omic pipelines, which is the same workflow students now run with coding agents ([Zhou 2024](https://doi.org/10.1002/advs.202407094)).

Plant science is roughly two years behind but catching up. In 2024 reviewers described the plant community as having largely not adopted LLMs ([Lam 2024](https://doi.org/10.1016/j.tplants.2024.04.013)), and in 2025 a breeding-focused review called their use in breeding "unexplored" ([Yoosefzadeh-Najafabadi 2025](https://doi.org/10.3389/fpls.2025.1583344)). Domain systems have appeared since then. PLLaMa was trained on 1.5 million plant-science articles ([Yang 2024](https://doi.org/10.48550/arXiv.2401.01600), preprint). PlantGPT, a fine-tuned 8B model with retrieval over 60,000 abstracts, outperforms general LLMs on Arabidopsis gene-function questions ([Zhang 2025](https://doi.org/10.1002/advs.202503926)). PlantScience.ai keeps a self-updating, citation-grounded knowledge graph of the plant literature ([Yu 2026](https://doi.org/10.1016/j.molp.2026.03.010)). On the sequence side, AgroNT scored more than 10 million cassava mutations in silico ([Mendoza-Revilla 2024](https://doi.org/10.1038/s42003-024-06465-2)).

The first breeding-decision results are encouraging but modest. In a rice germplasm panel, LLM priors built from passport data reduced the number of genotypes evaluated before the best one was found for seed number per panicle. The gain for protein content was small, and Gaussian-process Bayesian optimisation remained the strongest method when genomic data were available ([Hamazaki 2026](https://doi.org/10.64898/2026.06.28.735149), preprint). SeedBench tested 26 LLMs on breeding tasks and found substantial gaps relative to expert performance ([Ying 2025](https://doi.org/10.18653/v1/2025.acl-long.1516)).

## Industry and AI labs

The large AI labs launched science products during this period. Anthropic launched Claude for Life Sciences on 20 October 2025, with connectors to Benchling, PubMed and 10x Genomics ([CNBC 2025](https://www.cnbc.com/2025/10/20/anthropic-claude-life-sciences-research-ai.html)). OpenAI-affiliated authors documented GPT-5 contributing research steps across six fields, including four new mathematical results ([Bubeck 2025](https://doi.org/10.48550/arXiv.2511.16072), preprint). Google DeepMind released AlphaEarth Foundations with annual global embedding layers for 2017–2024 ([Brown 2025](https://doi.org/10.48550/arXiv.2507.22291), preprint), which could serve as a free environmental covariate for G×E models. In agbiotech, Bayer announced its E.L.Y. GenAI pilot on 14 March 2024 ([Bayer 2024](https://www.prnewswire.com/news-releases/bayer-pilots-unique-generative-ai-tool-for-agriculture-302088589.html)). By August 2025 it reported 60% faster responses and up to four hours saved per employee per week; these are company-reported metrics, not peer-reviewed ([Bayer 2025](https://www.globenewswire.com/news-release/2025/08/21/3137102/0/en/Bayer-s-E-L-Y-Wins-AI-based-AgTech-Solution-of-the-Year-In-2025-AgTech-Breakthrough-Awards-Program.html)). Closing the loop in breeding also requires physical data collection. Autonomous robots have already phenotyped nearly 200,000 maize plots across 142 fields over five years ([DeBruin 2025](https://doi.org/10.1038/s42003-025-07890-7)).

## Risks

The evidence on risk is concrete. GPT-3.5 fabricated 55% of the citations it generated and GPT-4 fabricated 18% ([Walters 2023](https://doi.org/10.1038/s41598-023-41032-5)). An independent audit of the AI Scientist found that 42% of its experiments failed because of coding errors ([Beel 2025](https://doi.org/10.48550/arXiv.2502.14297), preprint). A 2026 *Cell* perspective names hallucination, bias, irreproducibility and dual use as problems that cannot be separated from the benefits ([Guo 2026](https://doi.org/10.1016/j.cell.2026.08.052)). For breeding there is an additional data-sovereignty question. The most capable industry assistants run on proprietary trial data inside commercial clouds (Bayer 2024), while public programmes depend on open models such as PLLaMa and on locally deployable agents such as AutoBA.

## Outlook

The trend lines suggest three changes. Agents will move from answering questions to running analysis loops over breeding data. Grounded, domain-specific small models will compete with frontier models on specialist questions. The limiting factor will be verified closed loops that combine robots, embeddings and genebanks, not model intelligence alone.

## Proposed slides

### 1. From chatbot to co-scientist (2023→2026)
- Coscientist ran real experiments with GPT-4 (Dec 2023).
- Robin and the AI Scientist appeared in *Nature* in 2026, covering the full research loop from idea to paper.
- Kosmos: 12 h runs, 1,500 papers and 42,000 lines of code per run, 79.4% of statements accurate.
- Refs: Boiko2023, Ghareeb2026, Lu2026, Mitchener2025, Gottweis2025

### 2. Your coding agent is a bioinformatician
- AutoBA plans, runs and repairs multi-omic pipelines.
- Biomni learned its tools from publications in 25 domains.
- CRISPR-GPT designs and analyses gene-editing experiments end to end.
- Refs: Zhou2024, Huang2025, Qu2025, Anthropic2025

### 3. Plant-science LLMs have arrived
- PLLaMa: trained on 1.5 M plant papers; open weights.
- PlantGPT: an 8B model with retrieval beats general LLMs on Arabidopsis gene questions.
- PlantScience.ai: a self-updating, citation-grounded virtual scientist.
- Refs: Yang2024, Zhang2025, Yu2026, Lam2024

### 4. Can an LLM breed? Benchmarks and first trials
- SeedBench: 26 LLMs tested; substantial gaps relative to experts.
- LLM priors reduced the number of rice genotypes evaluated for seed number per panicle; small gain for protein content.
- Gaussian-process Bayesian optimisation remained best when genomic data were available.
- Refs: Ying2025, Hamazaki2026, YoosefzadehNajafabadi2025

### 5. Industry goes generative
- Bayer E.L.Y. pilot announced 14 Mar 2024; company-reported 60% faster answers and up to 4 h/week saved.
- AlphaEarth: annual global embeddings for 2017–2024.
- Claude for Life Sciences launched 20 Oct 2025; GPT-5 science case studies published Nov 2025.
- Refs: Bayer2024, Bayer2025, Brown2025, Anthropic2025, Bubeck2025

### 6. Toward the self-driving breeding program
- Robots phenotyped about 200,000 maize plots across 142 fields over 5 years.
- AgroNT scores more than 10 M mutations in silico.
- Agents could connect these data sources into a hypothesis → trial → analysis loop.
- Refs: DeBruin2025, MendozaRevilla2024, Ghareeb2026

### 7. Trust but verify
- Fabricated citations: 55% (GPT-3.5) and 18% (GPT-4).
- 42% of AI Scientist experiments failed because of coding errors.
- Hallucination, irreproducibility, dual use and data sovereignty remain open problems.
- Refs: Walters2023, Beel2025, Guo2026

## Infographic idea: "The agent scorecard"

The infographic is a two-panel figure.

The left panel is a dated timeline of milestones:

- Coscientist, 2023-12-20
- Bayer E.L.Y. pilot, 2024-03-14
- Co-Scientist, 2025-02-26
- CRISPR-GPT, 2025-07-30
- AlphaEarth, 2025-07-29
- Claude for Life Sciences, 2025-10-20
- Kosmos, 2025-11-04
- AI Scientist in *Nature*, 2026-03-25
- Robin in *Nature*, 2026-05-19

The right panel is a "trust bar chart" that uses only reported percentages:

- citations fabricated: 55% (GPT-3.5) and 18% (GPT-4)
- real citations with errors: 43% and 24%
- AI Scientist experiments failed: 42%
- Kosmos statements accurate: 79.4%
- workshop acceptance rate for the accepted AI paper: 70%
- Bayer response-time gain: 60% (company-reported)

Together the panels show that capability is rising quickly while verification is still required.
