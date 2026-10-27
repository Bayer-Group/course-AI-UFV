# The Next Decade of AI in Plant Breeding — slide guide

Closing lecture for the course *AI in Plant Breeding* · 40 slides · ~2 hours (≈120 min allocated below).

Evidence base: 73 references published between Oct 2023 and Oct 2026, each verified against its DOI (Crossref), arXiv/bioRxiv record, or official press release. Full table: `references_verified.csv` / `references_verified.json`.

Conventions used throughout: **[preprint]** = not peer reviewed; **[company]** / **[news]** = company-reported or press-reported, not peer reviewed. In the figures, open markers mark the same thing.


## Coverage note

Two planned theme blocks — (i) protein discovery/design and AI modelling of plant biochemistry, and (ii) AI applied to gene editing — could not be researched in this pass: the automated literature sweeps for those two topics were stopped by a content-safety filter. They are covered only through sources that came from the other searches (Evo-designed CRISPR systems, AI-generated phage genomes, CRISPR-GPT, DeepCBA promoter design), on slides 13–14, and slide 14 states this limitation to the audience. AlphaFold 3, protein language models and enzyme engineering are **not** covered and should be treated as the natural follow-up lecture.


## Suggested timing

| Block | Slides | Minutes |
|---|---|---|
| Opening and map | 1–4 | 14 |
| Part 1 — Reading genomes | 5–12 | 24 |
| Writing genomes | 13–14 | 6 |
| Part 3 — Predicting phenotypes | 15–20 | 20 |
| Part 4 — Seeing plants | 21–25 | 13 |
| Part 5 — Environment and growth | 26–29 | 13 |
| Part 6 — Agents | 30–36 | 23 |
| Synthesis, skills, discussion, close | 37–40 | 34 (incl. ~22 min open discussion) |


---


## Slide 1 — The Next Decade of AI in Plant Breeding

*Title slide* · suggested time: **1 min**

> From reading genomes to self-driving breeding programs · Course closing lecture


**Speaker notes**

Welcome to the closing session. For the whole course you have used AI as a tool — writing analysis code with Claude Code, reading papers with agents. Today we invert the question: not 'how do I use AI', but 'what will AI *be* in breeding over the next 5–10 years, and what should I learn now to be part of it'. Everything in this deck is from Oct 2023 to Oct 2026 and every claim carries a reference on the slide. 73 references, all checked against their DOI or official source. Ground rule for today: enthusiasm, but always with evidence.


## Slide 2 — Three years. One field, rebuilt.

*Statement slide* · suggested time: **4 min**


**On the slide**

- 2023: a DNA model learns plant gene structure with no labels — and beats conservation scores
- 2024: a genome model designs working CRISPR systems; a 1B-parameter model reads 48 crop genomes
- 2025: robots phenotype ~200,000 plots; AI forecasts reach 38 million farmers
- 2026: AI-written science passes peer review in Nature; AI-designed genomes build viable phages


**Speaker notes**

Open with scale, not with definitions. Each of these four lines is a verified result, not a projection. Ask the room: how many of these did you hear about when they happened? Usually very few hands. That is the point — the field is moving faster than the teaching material. Timing: 4 min. Tell them the deck is theirs afterwards, with every DOI, so they can go read the originals.


**References on this slide**

- Benegas G et al. (2023). DNA language models are powerful predictors of genome-wide variant effects. PNAS. https://doi.org/10.1073/pnas.2311219120
- Nguyen E et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. Science. https://doi.org/10.1126/science.ado9336
- Mendoza-Revilla J et al. (2024). A foundational large language model for edible plant genomes. Communications Biology. https://doi.org/10.1038/s42003-024-06465-2
- DeBruin J et al. (2025). Breaking the field phenotyping bottleneck in maize with autonomous robots. Communications Biology 8:467. https://doi.org/10.1038/s42003-025-07890-7
- Google Research & University of Chicago (2025). How AI is helping 38 million farmers with advance weather predictions. Google blog / UChicago Institute for Climate and Sustainable Growth. https://blog.google/innovation-and-ai/technology/research/indian-farmers-monsoon-prediction/
- Lu C et al. (2026). Towards end-to-end automation of AI research. Nature. https://doi.org/10.1038/s41586-026-10265-5
- King SH et al. (2026). Generative design of bacteriophages with genome language models. Science. https://doi.org/10.1126/science.aec2657


## Slide 3 — The whole pipeline is being rebuilt at once

*Figure slide* · suggested time: **4 min** · figure: `fig_pipeline.png`

> Six places where AI entered plant breeding — this is the map for the next two hours


**Speaker notes**

This is the map of the lecture. Left to right: genome → regulation → design → phenotype → environment → decision. The key message: these are not six separate AI projects, they are six interfaces of one loop, and they are converging. Point out that in 2020 only the 'decision' box (genomic prediction) had serious AI in breeding. Now every box does. Tell them we walk left to right, then come back and close the loop at the end.


**References on this slide**

- Zhai J et al. (2026). PlantCAD2: A DNA foundation model for interpreting genomes across flowering plants. Cell Genomics. https://doi.org/10.1016/j.xgen.2026.101329
- Yu H et al. (2024). An interpretable RNA foundation model for exploring functional RNA motifs in plants. Nature Machine Intelligence. https://doi.org/10.1038/s42256-024-00946-z
- Nguyen E et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. Science. https://doi.org/10.1126/science.ado9336
- Kirillov A et al. (2023). Segment Anything. Proc. IEEE/CVF ICCV 2023, pp. 3992-4003. https://doi.org/10.1109/iccv51070.2023.00371
- Lam R et al. (2023). Learning skillful medium-range global weather forecasting. Science 382:1416-1421. https://doi.org/10.1126/science.adi2336
- Morshedian A & Domaratzki M (2026). LSTM-attention-guided graph neural networks for integrated genotype–Environment modeling in maize yield prediction. PLOS Computational Biology 22:e1013729. https://doi.org/10.1371/journal.pcbi.1013729


## Slide 4 — 2023–2026: the milestones

*Figure slide* · suggested time: **5 min** · figure: `fig_timeline.png`

> Colour = domain · open marker = preprint or company announcement, not peer reviewed


**Speaker notes**

Let them read for 30 seconds in silence. Then make two observations. First, the density increases every year — 2026 is only 10 months old in this list. Second, note the open markers: a large part of the frontier is preprints and company announcements. That is a methodological warning we will return to at the end: exciting is not the same as validated. Ask: which of these would change your own project if it were true? Timing: 5 min.


**References on this slide**

- Benegas G et al. (2023). DNA language models are powerful predictors of genome-wide variant effects. PNAS. https://doi.org/10.1073/pnas.2311219120
- Kirillov A et al. (2023). Segment Anything. Proc. IEEE/CVF ICCV 2023, pp. 3992-4003. https://doi.org/10.1109/iccv51070.2023.00371
- Lam R et al. (2023). Learning skillful medium-range global weather forecasting. Science 382:1416-1421. https://doi.org/10.1126/science.adi2336
- Boiko DA et al. (2023). Autonomous chemical research with large language models. Nature. https://doi.org/10.1038/s41586-023-06792-0
- Mendoza-Revilla J et al. (2024). A foundational large language model for edible plant genomes. Communications Biology. https://doi.org/10.1038/s42003-024-06465-2
- Nguyen E et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. Science. https://doi.org/10.1126/science.ado9336
- Brixi G et al. (2025). Genome modeling and design across all domains of life with Evo 2. bioRxiv. https://doi.org/10.1101/2025.02.18.638918
- Zhai J et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. PNAS. https://doi.org/10.1073/pnas.2421738122
- DeBruin J et al. (2025). Breaking the field phenotyping bottleneck in maize with autonomous robots. Communications Biology 8:467. https://doi.org/10.1038/s42003-025-07890-7
- Capoot A (CNBC) (2025). Anthropic launches Claude Life Sciences to give researchers an AI efficiency boost. CNBC. https://www.cnbc.com/2025/10/20/anthropic-claude-life-sciences-research-ai.html
- Lu C et al. (2026). Towards end-to-end automation of AI research. Nature. https://doi.org/10.1038/s41586-026-10265-5
- Zhai J et al. (2026). PlantCAD2: A DNA foundation model for interpreting genomes across flowering plants. Cell Genomics. https://doi.org/10.1016/j.xgen.2026.101329


## Slide 5 — Part 1 — Reading genomes

*Section divider* · suggested time: **1 min**

> Foundation models that learn the language of plant DNA


**Speaker notes**

Section transition. We start with the layer closest to what breeders already do: the genome.


## Slide 6 — How a DNA language model learns

*Figure slide* · suggested time: **4 min** · figure: `fig_dnalm.png`

> Same trick as a text LLM: hide a token, predict it, repeat billions of times


**Speaker notes**

This is the conceptual core of the section, so spend time here. The training task is trivial: mask a base, predict it from context. No phenotype labels, no annotation — just genomes. The consequence is not trivial: to predict well the model has to internalise gene structure, splice sites, codon bias, motifs. Then the trick: give it a real variant from your germplasm. If the model is 'surprised' by the allele, that position is probably under constraint — a candidate deleterious mutation. The probabilities shown are illustrative, drawn to explain the mechanism, not measured. Ask the students where they have seen this before — it is exactly masked language modelling from NLP.


**References on this slide**

- Benegas G et al. (2023). DNA language models are powerful predictors of genome-wide variant effects. PNAS. https://doi.org/10.1073/pnas.2311219120
- Zhai J et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. PNAS. https://doi.org/10.1073/pnas.2421738122


## Slide 7 — The first plant DNA models: GPN and AgroNT

*Content slide* · suggested time: **3 min**


**On the slide**

- GPN, trained unsupervised on Arabidopsis plus seven Brassicales genomes, learned gene structure and motifs with no labels — and predicted variant effects better than phyloP and phastCons
- AgroNT: 1 billion parameters, genomes of 48 plant species, state of the art on regulatory annotation, promoter and terminator strength, tissue-specific expression
- AgroNT scored more than 10 million cassava mutations in silico and released the Plants Genomic Benchmark
- Both are open and downloadable — a student with a laptop and a Colab GPU can use them today


**Speaker notes**

GPN is the proof of principle (PNAS 2023): unsupervised learning on plant DNA beats decades-old comparative-genomics conservation scores at variant effect prediction. AgroNT is the crop-scale version. Emphasise the 10 million cassava mutations: an in-silico pre-screen of a mutation space no lab could assay. And emphasise 'open' — this is the practical hook. Invite them to try AgroNT on their own species as a course project.


**References on this slide**

- Benegas G et al. (2023). DNA language models are powerful predictors of genome-wide variant effects. PNAS. https://doi.org/10.1073/pnas.2311219120
- Mendoza-Revilla J et al. (2024). A foundational large language model for edible plant genomes. Communications Biology. https://doi.org/10.1038/s42003-024-06465-2


## Slide 8 — Train on Arabidopsis, predict in maize

*Content slide* · suggested time: **4 min**


**On the slide**

- PlantCaduceus was pre-trained on 16 angiosperm genomes, fine-tuned on Arabidopsis labels only, then applied to maize — 160 million years of divergence
- 1.45× better than the previous best DNA model for splice-donor prediction; 7.23× better for translation initiation
- Its predicted deleterious mutations had 3-fold lower minor allele frequencies than alignment-based calls — independent evidence it is right
- Applied result: scoring >1,900 wild and cultivated beet genomes traced a century-long decline in genetic load in US sugar beet


**Speaker notes**

This is the slide that should make a breeder sit up. The limiting factor in crop genomics is labelled data for *your* species. Cross-species transfer says: train where the annotation is (Arabidopsis), deploy where the money is (maize). The allele-frequency check is the part to stress methodologically — the model was validated against population genetics, not just against another benchmark. Then the sugar beet study shows the full arc: a language model reading a century of breeding history and pointing at mutations still to purge.


**References on this slide**

- Zhai J et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. PNAS. https://doi.org/10.1073/pnas.2421738122
- Long E et al. (2026). Evolutionary and Deep Learning Models Highlight Deleterious Mutations Behind the History of Sugar Beet Breeding. G3: Genes, Genomes, Genetics. https://doi.org/10.1093/g3journal/jkag264


## Slide 9 — Specialist beats giant

*Figure slide* · suggested time: **4 min** · figure: `fig_model_scale.png`

> PlantCAD2 (0.676B, 65 plant genomes) outperformed Evo 2 (7B, all domains of life) on 10 of 12 zero-shot tasks


**Speaker notes**

The most strategically important slide of Part 1. The general AI narrative is 'bigger is better'. In plants, the opposite held: a 676M-parameter plant specialist beat a 7B generalist on 10 of 12 zero-shot tasks, and beat 1B AgroNT on seven cross-species tasks. Longer context also mattered — maize accessible-chromatin AUPRC rose from 0.587 to 0.711. An independent test found Evo 2 does sense plant evolutionary constraint, but only modestly. Message for students: you do not need a frontier-lab budget to build something state of the art in plants. You need the right data. That is a thesis-sized opportunity.


**References on this slide**

- Zhai J et al. (2026). PlantCAD2: A DNA foundation model for interpreting genomes across flowering plants. Cell Genomics. https://doi.org/10.1016/j.xgen.2026.101329
- Brixi G et al. (2025). Genome modeling and design across all domains of life with Evo 2. bioRxiv. https://doi.org/10.1101/2025.02.18.638918
- Mantegazza O et al. (2026). Evo 2’s perception of single nucleotide substitutions in the genes of two plant model organisms. Open Research Europe. https://doi.org/10.12688/openreseurope.24244.1


## Slide 10 — Beyond DNA: RNA, expression and 3D chromatin

*Content slide* · suggested time: **3 min**


**On the slide**

- PlantRNA-FM, pre-trained on RNA sequence and structure from 1,124 plant species, raised genic-region annotation F1 from 0.639 to 0.974 — and the motifs it found were validated experimentally
- Interpretable CNNs predict expression from gene-flanking sequence with >80% accuracy in Arabidopsis, tomato, sorghum and maize, and explain expression differences across 14 tomato genomes
- DeepCBA adds 3D chromatin contacts: average PCC 0.929, which is 0.469 higher than using proximal sequence alone
- These models do not just predict — DeepCBA's promoter edits in ZmCLE7 and ZmVTE4 were tested in maize


**Speaker notes**

Three steps up the regulatory ladder. PlantRNA-FM: the F1 jump from 0.64 to 0.97 is a step change, and the lab validation of discovered motifs is what separates this from a benchmark exercise. Peleke: cis-regulatory code is learnable and transfers across species — and UTRs matter more than people assumed. DeepCBA: add 3D genome contacts and you capture distal regulation; crucially they went to the bench and edited the promoters the model nominated. That last bullet is the bridge to Part 2 — prediction becomes design.


**References on this slide**

- Yu H et al. (2024). An interpretable RNA foundation model for exploring functional RNA motifs in plants. Nature Machine Intelligence. https://doi.org/10.1038/s42256-024-00946-z
- Peleke FF et al. (2024). Deep learning the cis-regulatory code for gene expression in selected model plants. Nature Communications. https://doi.org/10.1038/s41467-024-47744-0
- Wang Z et al. (2024). DeepCBA: A deep learning framework for gene expression prediction in maize based on DNA sequences and chromatin interactions. Plant Communications. https://doi.org/10.1016/j.xplc.2024.100985


## Slide 11 — Single-cell foundation models for crops

*Content slide* · suggested time: **3 min**


**On the slide**

- scPlantLLM, pre-trained on millions of plant single-cell profiles, reached up to 0.91 zero-shot cell-type annotation accuracy in Arabidopsis and inferred gene regulatory networks
- scMaize integrates 385,675 maize cells from 20 projects and 7 tissues (preprint)
- 86.0% cell-type and 97.1% tissue classification accuracy, zero-shot generalisation across species, perturbation signals amplified ~3-fold
- Delivered with a no-code web platform — single-cell AI aimed at breeders, not only at bioinformaticians


**Speaker notes**

Cell-type annotation used to be weeks of manual marker curation. Zero-shot annotation at 0.91 removes that bottleneck. Flag honestly that scMaize is a preprint. The interesting breeding angle is the last bullet plus the perturbation amplification: if a model can predict how a cell type responds to a perturbation, you can start screening regulatory hypotheses in silico before you make a plant.


**References on this slide**

- Cao G et al. (2025). scPlantLLM: A Foundation Model for Exploring Single-cell Expression Atlases in Plants. Genomics, Proteomics & Bioinformatics. https://doi.org/10.1093/gpbjnl/qzaf024
- Cheng Q et al. (2026). scMaize: A Single-Cell Foundation Model and Integrated Atlas for Maize. bioRxiv. https://doi.org/10.64898/2026.08.01.742180


## Slide 12 — Next: pan-genome-scale models

*Content slide* · suggested time: **3 min**


**On the slide**

- OneGenome-Rice: 1.25B-parameter mixture-of-experts model over 422 cultivated and wild rice genomes, context up to 1 Mb, applied to introgression analysis and trait-locus identification (preprint)
- Foxtail millet: eight new assemblies plus a graph pan-genome; interpretable ML prioritised a 5,002-bp Copia insertion that SNP-only GWAS would never see
- Where the field is going: one model per crop complex, trained on its entire pan-genome, scoring every possible variant in advance
- GPN-MSA already pre-computed scores for ~9 billion possible human SNVs — the same blueprint fits a crop pan-genome


**Speaker notes**

Where Part 1 ends up. Two things to drive home. First, structural variants: our SNP-centric habits hide a large part of the causal variation, and pan-genome plus interpretable ML is how it comes back into view — a 5 kb transposon insertion controlling a trait. Second, the GPN-MSA precedent: 9 billion human variants scored in advance. Imagine an equivalent table for your crop, queryable before you design a cross. That resource does not exist yet for most crops. Someone in this room could build it.


**References on this slide**

- Qian B et al. (2026). OneGenome-Rice (OGR): A genomic foundation model for rice. bioRxiv. https://doi.org/10.64898/2026.04.21.719822
- Wang W et al. (2026). Integrating pan-genome analysis, GWAS, and interpretable machine learning to prioritize trait-associated structural variations in Setaria italica. Plant Communications. https://doi.org/10.1016/j.xplc.2025.101626
- Benegas G et al. (2025). A DNA language model based on multispecies alignment predicts the effects of genome-wide variants. Nature Biotechnology. https://doi.org/10.1038/s41587-024-02511-w


## Slide 13 — From reading DNA to writing it

*Content slide* · suggested time: **3 min**


**On the slide**

- Evo, trained on millions of prokaryotic and phage genomes, generated functional CRISPR-Cas and transposon systems — the first language model to design working molecular machines
- Evo 2 scaled this to 9.3 trillion bases across all domains of life, with a 1-million-token context and fully open weights and data (preprint)
- In 2026, genome language models generated complete bacteriophage genomes: 16 were viable, and a cocktail overcame resistant E. coli
- Direction of travel for plants: generated promoters, regulatory elements and enzyme variants, scored in silico and tested in planta


**Speaker notes**

This is the 'biology became writable' slide. Keep it honest: the generative successes so far are in microbial and viral systems, where the genomes are small and the assays are fast. Plants are harder — bigger genomes, slower cycles. But the DeepCBA promoter editing we just saw is the plant-side beachhead. Frame the open question for the students: what is the first plant sequence worth generating rather than selecting? Promoters for tissue-specific expression is the common answer.


**References on this slide**

- Nguyen E et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. Science. https://doi.org/10.1126/science.ado9336
- Brixi G et al. (2025). Genome modeling and design across all domains of life with Evo 2. bioRxiv. https://doi.org/10.1101/2025.02.18.638918
- King SH et al. (2026). Generative design of bacteriophages with genome language models. Science. https://doi.org/10.1126/science.aec2657


## Slide 14 — Designing regulation, and agents that design experiments

*Content slide* · suggested time: **3 min**


**On the slide**

- Expression models now propose edits: DeepCBA-guided promoter changes in two maize genes were taken to the bench
- CRISPR-GPT, an LLM agent, selects the editing system, designs guide RNAs, plans delivery, drafts protocols and analyses the results — demonstrated on four knockouts and two activations in human cells
- No plant-specific equivalent has been published yet. That is an opening, not a gap in the technology
- Coverage note: this lecture surveys AI-designed editors, enzyme design and plant biochemistry only through these verified sources


**Speaker notes**

Two honest points. First, agent-assisted editing design already exists, but it was demonstrated in mammalian cell lines; a plant version — handling transformation, regeneration, chimerism, ploidy — does not exist in the published literature we retrieved. Tell the students explicitly: that is a concrete, buildable project. Second, be transparent about the lecture's own scope: protein design and plant biochemistry are a large adjacent field (AlphaFold 3, protein language models, enzyme engineering) that this deck does not cover in depth. Point them to it as the obvious follow-up reading.


**References on this slide**

- Wang Z et al. (2024). DeepCBA: A deep learning framework for gene expression prediction in maize based on DNA sequences and chromatin interactions. Plant Communications. https://doi.org/10.1016/j.xplc.2024.100985
- Qu Y et al. (2025). CRISPR-GPT for agentic automation of gene-editing experiments. Nature Biomedical Engineering. https://doi.org/10.1038/s41551-025-01463-z


## Slide 15 — Part 3 — Predicting phenotypes

*Section divider* · suggested time: **1 min**

> Genomic selection, G×E and the honest scoreboard


**Speaker notes**

Transition into the area closest to classical breeding practice. Warn them this section contains the least hype and the most rigour.


## Slide 16 — Deep learning vs GBLUP: an honest draw

*Content slide* · suggested time: **3 min**


**On the slide**

- The largest tuned head-to-head comparison — 14 real plant-breeding datasets — found no consistent winner
- Deep learning was frequently ahead on smaller datasets, but only when hyperparameters were carefully tuned
- Translation: architecture matters less than data quality, tuning and evaluation design
- Reviews agree the real gain comes from multimodal fusion — genomes plus environment plus phenomics — at higher compute cost


**Speaker notes**

Deliberately the least exciting slide, and I keep it because credibility depends on it. If someone tells you deep learning has replaced GBLUP, they have not read this comparison. For a student this is good news: an unresolved question with public data is exactly where a thesis can make a real contribution. Also a practical lesson — most published DL-beats-GBLUP claims come from weakly tuned baselines. Ask the class how they would design a fair comparison.


**References on this slide**

- Montesinos-López A et al. (2025). Artificial intelligence meets genomic selection: comparing deep learning and GBLUP across diverse plant datasets. Frontiers in Genetics. https://doi.org/10.3389/fgene.2025.1568705
- Montesinos-López OA et al. (2024). A review of multimodal deep learning methods for genomic-enabled prediction in plant breeding. Genetics. https://doi.org/10.1093/genetics/iyae161


## Slide 17 — When deep learning does add something: interpretability

*Content slide* · suggested time: **3 min**


**On the slide**

- Cropformer combines a CNN with multiple self-attention layers, evaluated on more than 20 traits across maize, rice, wheat, foxtail millet and tomato
- Up to 7.5% higher prediction accuracy than the runner-up model
- Its attention weights flag trait-associated SNPs — prediction and gene discovery from one model
- This is the real argument for neural models in breeding: not accuracy alone, but what the model tells you about the biology


**Speaker notes**

7.5% is a real but modest gain; do not oversell it. The part that matters is attention as a discovery tool. A GBLUP model gives you a prediction; an attention model gives you a prediction plus a ranked list of regions it paid attention to. In breeding, a predictor that also nominates candidate loci is worth more than a marginally better predictor. Caveat for the honest version: attention is not causality, and students should treat flagged SNPs as hypotheses.


**References on this slide**

- Wang H et al. (2025). Cropformer: An interpretable deep learning framework for crop genomic prediction. Plant Communications. https://doi.org/10.1016/j.xplc.2024.101223


## Slide 18 — Open competitions: the fastest way in

*Content slide* · suggested time: **4 min**


**On the slide**

- Genomes to Fields ran the first public maize G×E prediction competition on nine years of data
- The winner combined an environment-focused ML model with a genetics model; top teams used quantitative genetics, deep learning, crop models and ensembles — no single strategy dominated
- The 2024 release: ~180,000 field plots, 5,205 hybrids, 272 year-location environments, 2,425 SNPs, plus soil, weather and environmental covariates
- Some competitors had no plant-genetics training at all — and still placed


**Speaker notes**

This is the most actionable slide in the whole lecture, so point at it. One of the largest public plant G×E datasets exists, it is downloadable, and a documented competition shows what the field's best attempts actually achieve. The last bullet is the motivational one: outsiders competed successfully, which means the barrier is skill and persistence, not institutional affiliation. Concrete suggestion to the class: download the G2F data this week, reproduce one baseline with your coding agent, and you are at the research frontier by the end of the month.


**References on this slide**

- Washburn JD et al. (2025). Global genotype by environment prediction competition reveals that diverse modeling strategies can deliver satisfactory maize yield estimates. Genetics. https://doi.org/10.1093/genetics/iyae195
- Chen Q et al. (2026). Genomes to fields 2024 maize genotype by environment prediction competition. BMC Research Notes. https://doi.org/10.1186/s13104-026-07629-5


## Slide 19 — Measuring the E, and explaining the interaction

*Content slide* · suggested time: **4 min**


**On the slide**

- EXGEP, an ensemble of explainable models, predicted maize yield from 70,693 records on 3,793 hybrids, beating Bayesian ridge regression by 17.37–42.35%
- SHAP values exposed which genetic and which environmental features drove each prediction — and how they interact
- Perspective papers now argue for synchronised phenomics–enviromics data collection: satellites, UAVs, ground vehicles, indoor facilities
- Public transcriptomes are an under-used input: models trained on 21,612 maize RNA-seq samples classified tissue, stage, cultivar and stress — though maize-trained models transferred poorly to rice


**Speaker notes**

The strongest gains in the last three years came from modelling the environment better, not the genome better. EXGEP is the example: large gains plus per-prediction explanations, which is what a breeder actually needs to act. The enviromics perspective is the programmatic version — treat the environment as something to be characterised as densely as the genome. The transcriptome result is both an opportunity and a caution: huge free training data, but transfer across species failed. That negative result is worth as much as the positive ones.


**References on this slide**

- Yu T et al. (2025). EXGEP: a framework for predicting genotype-by-environment interactions using ensembles of explainable machine-learning models. Briefings in Bioinformatics. https://doi.org/10.1093/bib/bbaf414
- Li H et al. (2026). Omics-driven plant breeding through phenomics-enviromics crosstalk. Nature Communications. https://doi.org/10.1038/s41467-026-73097-x
- Wu Z et al. (2024). Phenotype prediction in plants is improved by integrating large-scale transcriptomic datasets. NAR Genomics and Bioinformatics. https://doi.org/10.1093/nargab/lqae184


## Slide 20 — Closing the generalisation gap

*Figure slide* · suggested time: **5 min** · figure: `fig_gxe_gap.png`

> The real failure mode is a new year or a new site — and structure is what fixes it


**Speaker notes**

Walk the four rows. Row 1: a UAV yield model moved to a new year collapsed to R² = -2.9, worse than predicting the mean; fine-tuning on 20% of target data restored R² = 0.83. Row 2: a network with statistical-genetics structure built in reached 0.63 accuracy where BLUP gave 0.43 — a direct counter to the earlier 'draw'. Row 3: a graph network over SNPs and weather embeddings beat the G×E competition winner on unseen genotypes in unseen environments. Row 4: data assimilation plus ML cut wheat forecast error from 7.79% to 1.74%. The unifying lesson: generic deep learning underperforms; deep learning with the right structure wins. Flag that row 2 is a preprint.


**References on this slide**

- Kaushal S et al. (2026). UAV‐based deep transfer learning to improve grain yield prediction in winter wheat across temporal and spatial variability. The Plant Phenome Journal 9:e70085. https://doi.org/10.1002/ppj2.70085
- Potze A et al. (2025). Structured Multimodal Deep Learning improves Genomic Prediction in Future Environments. bioRxiv preprint. https://doi.org/10.1101/2025.09.05.674546
- Morshedian A & Domaratzki M (2026). LSTM-attention-guided graph neural networks for integrated genotype–Environment modeling in maize yield prediction. PLOS Computational Biology 22:e1013729. https://doi.org/10.1371/journal.pcbi.1013729
- Zhuang H et al. (2024). Integrating data assimilation, crop model, and machine learning for winter wheat yield forecasting in the North China Plain. Agricultural and Forest Meteorology 347:109909. https://doi.org/10.1016/j.agrformet.2024.109909


## Slide 21 — Part 4 — Seeing plants

*Section divider* · suggested time: **1 min**

> Phenotyping without labels


**Speaker notes**

Transition. From genotype side to the phenotype side — historically the bottleneck of every breeding program.


## Slide 22 — Segmentation without labels

*Content slide* · suggested time: **3 min**


**On the slide**

- The Segment Anything Model was trained on over 1 billion masks from 11 million images and segments objects it has never seen
- In plants: prompting with a single annotated Arabidopsis image segmented infected-plant time series at Dice 0.977, transferred to a second pathosystem at 0.966, and correlated r = -0.928 with a manual disease index
- SAM-CLIP pipelines on thermal field images reached 97.54% mIoU — and generated releasable annotations themselves
- The pipeline ran without a large GPU


**Speaker notes**

This changes the economics of phenotyping. The old workflow was: annotate hundreds of images, train a model, repeat for every new trait and species. The new workflow is: prompt a foundation model with one example. Dice 0.977 from a single labelled image is the number to quote. Second key point: these models now produce the training labels for the next dataset, so annotation cost compounds downward. Third: no large GPU needed — this is accessible to any lab in this room.


**References on this slide**

- Kirillov A et al. (2023). Segment Anything. Proc. IEEE/CVF ICCV 2023, pp. 3992-4003. https://doi.org/10.1109/iccv51070.2023.00371
- Maciá F et al. (2025). OneRosette to predict them all: single plant prompting on a visual foundation model to segment symptomatic Arabidopsis thaliana time series. Plant Methods 21:128. https://doi.org/10.1186/s13007-025-01432-2
- Lin Y et al. (2026). SAM-CLIP-Thermal: Leveraging large multimodal models for reliable and scalable annotation in thermal image segmentation for field plant phenotyping. Plant Phenomics 8:100264. https://doi.org/10.1016/j.plaphe.2026.100264


## Slide 23 — Plant-native vision foundation models arrive

*Content slide* · suggested time: **3 min**


**On the slide**

- Frozen general backbones (MAE, DINO, DINOv2) adapted with small LoRA adapters matched task-specific state of the art on leaf counting, instance segmentation and disease classification
- SPROUT: a diffusion transformer pretrained on 2.6 million unlabeled open-field crop images, with the largest gains on dense structural tasks (preprint)
- The honest caveat: generic models still trail fine-tuned specialists in some settings
- So the gain is mainly in annotation cost and flexibility — not necessarily in peak accuracy


**Speaker notes**

Two generations in one slide. First, adapting web-pretrained vision models to plants with a handful of trainable parameters. Second, pretraining on plants themselves — 2.6 million field images. Keep the third bullet: if you need maximum accuracy on one fixed task with plenty of labels, a specialist still wins. Foundation models buy you breadth, speed and cheap starts. For a breeding program running dozens of trait measurements, breadth is usually worth more than the last two accuracy points.


**References on this slide**

- Chen F et al. (2023). Adapting Vision Foundation Models for Plant Phenotyping. Proc. IEEE/CVF ICCV Workshops 2023, pp. 604-613. https://doi.org/10.1109/iccvw60793.2023.00067
- Xiang S et al. (2026). SPROUT: A Scalable Diffusion Foundation Model for Multi-Crop Plant Phenotyping. arXiv preprint. https://doi.org/10.48550/arxiv.2603.27519


## Slide 24 — 3D plants, in seconds

*Content slide* · suggested time: **3 min**


**On the slide**

- Depth Anything V2 plus a prompted SAM 2 module estimated plant height from a single RGB image: R² = 0.948, RMSE 12.23 cm across 350 plants, versus 22.62 cm for a conventional baseline
- Feed-forward 3D foundation models with Gaussian splatting cut smartphone-based reconstruction from 6.52 minutes to 1.58 seconds per plant — roughly 250-fold (preprint)
- Self-supervised point-cloud learning reached F1 89.80% for organ segmentation and matched supervised baselines with half the labels
- Roots too: RhizoNet segments root biomass across thousands of scans, built into self-driving lab loops


**Speaker notes**

Height from a phone photo at R² 0.948 is the headline — previously that meant LiDAR or a ruler and a field crew. The 250-fold reconstruction speed-up is what turns 3D phenotyping from an overnight batch job into something you do while walking the plot. Mention roots deliberately: the hidden half of the plant, historically unphenotypable at scale, now tractable and already wired into automated experiment loops. Flag the preprint.


**References on this slide**

- Wang Z et al. (2026). Depth4PH: a vision foundation model-based framework for plant height estimation in agricultural scenes. Artificial Intelligence in Agriculture. https://doi.org/10.1016/j.aiia.2026.08.006
- Jia H et al. (2026). The Turning Point of 3D Plant Phenotyping: 3D Foundation Models Enable Minute-to-Second Cross-Crop Reconstruction and Beyond. arXiv preprint. https://doi.org/10.48550/arxiv.2607.01753
- Xie K et al. (2025). Automated 3D Segmentation of Plant Organs via the Plant-MAE: A Self-Supervised Learning Framework. Plant Phenomics 7:100049. https://doi.org/10.1016/j.plaphe.2025.100049
- Sordo Z et al. (2024). RhizoNet segments plant roots to assess biomass and growth for enabling self-driving labs. Scientific Reports 14:12907. https://doi.org/10.1038/s41598-024-63497-8


## Slide 25 — The data that makes it work

*Figure slide* · suggested time: **3 min** · figure: `fig_data_scale.png`

> Orders of magnitude, 2021–2026


**Speaker notes**

Read this as a progression of what 'a lot of data' means. 275,187 labelled wheat heads from 12 countries was a landmark community benchmark that pulled computer-vision researchers into crop science. Autonomous under-canopy robots phenotyped nearly 200,000 plots across 142 fields over five years — at a scale no human crew could match, enough to dissect genotype × nitrogen interactions. Then the general-vision numbers dwarf both, which is exactly why transfer learning from them is so valuable to us. And the last bar is people, not pixels — we come back to it in two slides.


**References on this slide**

- David E et al. (2021). Global Wheat Head Detection 2021: An Improved Dataset for Benchmarking Wheat Head Detection Methods. Plant Phenomics 2021:9846158. https://doi.org/10.34133/2021/9846158
- DeBruin J et al. (2025). Breaking the field phenotyping bottleneck in maize with autonomous robots. Communications Biology 8:467. https://doi.org/10.1038/s42003-025-07890-7
- Xiang S et al. (2026). SPROUT: A Scalable Diffusion Foundation Model for Multi-Crop Plant Phenotyping. arXiv preprint. https://doi.org/10.48550/arxiv.2603.27519
- Kirillov A et al. (2023). Segment Anything. Proc. IEEE/CVF ICCV 2023, pp. 3992-4003. https://doi.org/10.1109/iccv51070.2023.00371
- Google Research & University of Chicago (2025). How AI is helping 38 million farmers with advance weather predictions. Google blog / UChicago Institute for Climate and Sustainable Growth. https://blog.google/innovation-and-ai/technology/research/indian-farmers-monsoon-prediction/


## Slide 26 — Part 5 — Environment and growth

*Section divider* · suggested time: **1 min**

> AI weather models, hybrid crop models and digital twins


**Speaker notes**

Transition. If G×E is the central problem of breeding, then modelling E well is half the solution.


## Slide 27 — AI weather models are now operational-grade

*Figure slide* · suggested time: **4 min** · figure: `fig_weather.png`

> Both results are head-to-head against the leading physical forecasting systems


**Speaker notes**

GraphCast beat the best operational deterministic system on 90% of 1,380 verification targets, producing a 10-day global forecast in under a minute — forecasts that previously needed supercomputer hours. GenCast, a diffusion ensemble, beat the ECMWF ensemble on 97.2% of 1,320 targets, including extremes, in 8 minutes. Aurora generalised the recipe to the whole Earth system. NeuralGCM showed hybrid differentiable physics plus learning can run stable decadal simulations — while its authors warn it does not extrapolate to substantially different future climates. For breeders the point is probabilistic: you get risk distributions over environments, not a single number.


**References on this slide**

- Lam R et al. (2023). Learning skillful medium-range global weather forecasting. Science 382:1416-1421. https://doi.org/10.1126/science.adi2336
- Price I et al. (2025). Probabilistic weather forecasting with machine learning. Nature 637:84-90 (online 4 Dec 2024). https://doi.org/10.1038/s41586-024-08252-9
- Bodnar C et al. (2025). A foundation model for the Earth system. Nature 641:1180-1187. https://doi.org/10.1038/s41586-025-09005-y
- Kochkov D et al. (2024). Neural general circulation models for weather and climate. Nature 632:1060-1066. https://doi.org/10.1038/s41586-024-07744-y


## Slide 28 — From a Nature paper to 38 million farmers — in about a year

*Statement slide* · suggested time: **4 min**


**On the slide**

- 2024: NeuralGCM publishes hybrid physics-plus-ML climate simulation
- 2025: a blend of NeuralGCM, ECMWF's AIFS and historical data predicted Indian monsoon onset up to a month ahead, including an unusual mid-season dry spell
- Forecasts were delivered by SMS to 38 million farmers with India's Ministry of Agriculture
- Model choice was made with decision-oriented benchmarks: does it improve a sowing decision, not just a global error score


**Speaker notes**

This is the deployment slide, and it is the answer to 'is any of this real'. Roughly twelve months from a methods paper to SMS messages in farmers' hands at the scale of a large country. Be precise about status: the 38 million figure is from a company announcement, and the benchmarking paper is a preprint. The idea worth stealing is the last bullet — evaluate a model on whether it changes a decision, not on RMSE. Apply that to your own breeding models: does the prediction change which lines you advance?


**References on this slide**

- Kochkov D et al. (2024). Neural general circulation models for weather and climate. Nature 632:1060-1066. https://doi.org/10.1038/s41586-024-07744-y
- Google Research & University of Chicago (2025). How AI is helping 38 million farmers with advance weather predictions. Google blog / UChicago Institute for Climate and Sustainable Growth. https://blog.google/innovation-and-ai/technology/research/indian-farmers-monsoon-prediction/
- Masiwal R et al. (2026). Decision-oriented benchmarking to transform AI weather forecast access: Application to the Indian monsoon. arXiv preprint. https://doi.org/10.48550/arxiv.2602.03767


## Slide 29 — Crop models learn to learn

*Content slide* · suggested time: **4 min**


**On the slide**

- Data assimilation plus stacked ML cut North China Plain winter-wheat forecast error from MAPE 7.79% to 1.74% (ACC 0.69 → 0.97)
- NeuralCrop applies the NeuralGCM recipe to crops: a differentiable global crop model, trained to emulate process-based physiology then fine-tuned on observations — better under drought, orders of magnitude faster (preprint)
- A mandarin digital twin over ~185,000 ha showed intra-orchard variation explains fruit quality far more than inter-orchard variation
- Generative models already produce realistic future plot images conditioned on cultivar, time and treatment
- Also arriving: AlphaEarth Foundations, annual global embedding layers for 2017–2024 — a free environmental covariate for multi-environment trials


**Speaker notes**

The convergence story. Process-based crop models encode physiology but fit data poorly; ML fits data but ignores physiology. Differentiable hybrids get both, and this is the single most likely architecture for the next generation of crop models. The digital twin result is a management lesson — variation within an orchard matters more than between orchards, which is the agricultural analogue of personalised medicine. The generative growth images hint at virtual field trials: screen genotypes across thousands of simulated environments before planting. And AlphaEarth is an immediately usable, free covariate layer — note it is a preprint.


**References on this slide**

- Zhuang H et al. (2024). Integrating data assimilation, crop model, and machine learning for winter wheat yield forecasting in the North China Plain. Agricultural and Forest Meteorology 347:109909. https://doi.org/10.1016/j.agrformet.2024.109909
- Lin Y et al. (2025). NeuralCrop: Combining physics and machine learning for improved crop yield projections. arXiv preprint. https://doi.org/10.48550/arxiv.2512.20177
- Kim S & Heo S (2024). An agricultural digital twin for mandarins demonstrates the potential for individualized agriculture. Nature Communications 15:1561. https://doi.org/10.1038/s41467-024-45725-x
- Drees L et al. (2024). Data-driven crop growth simulation on time-varying generated images using multi-conditional generative adversarial networks. Plant Methods 20:93. https://doi.org/10.1186/s13007-024-01205-3
- Brown CF et al. (2025). AlphaEarth Foundations: An embedding field model for accurate and efficient global mapping from sparse label data. arXiv / Google DeepMind. https://doi.org/10.48550/arxiv.2507.22291


## Slide 30 — Part 6 — Agents

*Section divider* · suggested time: **1 min**

> The tools you already use, pointed at research itself


**Speaker notes**

Transition, and the part that connects directly to what they did all semester.


## Slide 31 — From chatbot to co-scientist, in three years

*Content slide* · suggested time: **4 min**


**On the slide**

- Dec 2023: Coscientist, driven by GPT-4, designed and ran real experiments, including optimising palladium-catalysed cross-couplings
- 2025: Google's Co-Scientist evolved hypotheses in tournaments; quality kept rising with more test-time compute, and leukemia drug-repurposing candidates were validated in vitro (preprint)
- 2026: Robin, published in Nature, proposed and validated ripasudil for dry macular degeneration — then designed and analysed its own follow-up RNA-seq experiment
- Kosmos runs up to 12 hours per task, executing ~42,000 lines of code and reading 1,500 papers; collaborators judged one 20-cycle run equivalent to about 6 months of their own research (preprint)


**Speaker notes**

Three years from 'can it run a reaction' to a Nature paper where an agent closed the full loop: literature → hypothesis → validation → next experiment designed by itself. The Kosmos number is the one that lands with students — six months of analysis in one overnight run, with every claim traceable to code or a paper. Keep the preprint flags visible. Then ask the room the uncomfortable question: if an agent does the analysis, what is the researcher for? The answer we will build toward is the question, the judgement and the field.


**References on this slide**

- Boiko DA et al. (2023). Autonomous chemical research with large language models. Nature. https://doi.org/10.1038/s41586-023-06792-0
- Gottweis J et al. (2025). Accelerating scientific discovery with Co-Scientist (v1 title: Towards an AI co-scientist). arXiv. https://doi.org/10.48550/arxiv.2502.18864
- Ghareeb AE et al. (2026). A multi-agent system for automating scientific discovery. Nature. https://doi.org/10.1038/s41586-026-10652-y
- Mitchener L et al. (2025). Kosmos: An AI Scientist for Autonomous Discovery. arXiv. https://doi.org/10.48550/arxiv.2511.02824


## Slide 32 — Your coding agent is already a bioinformatician

*Content slide* · suggested time: **3 min**


**On the slide**

- AutoBA plans, runs and repairs end-to-end multi-omic analyses from minimal input — with local model options for data privacy
- Biomni built its own toolkit by mining tools, databases and protocols from tens of thousands of publications across 25 biomedical domains (preprint)
- CRISPR-GPT designs and analyses gene-editing experiments end to end
- Claude for Life Sciences launched in Oct 2025 with connectors to lab and literature platforms including Benchling, PubMed and 10x Genomics
- This is exactly what you did this semester — the research version of it is now the published state of the art


**Speaker notes**

Explicit callback to the course. What they practised — describe the analysis, let the agent write, run and fix the code — is the same pattern as AutoBA, which is a peer-reviewed method. Biomni is the interesting direction: an agent that assembles its own tools by reading the literature. There is no crop equivalent. 'Biomni for crops' is a genuinely fundable idea and I would like someone here to take it. Note the Anthropic launch is reported by a news outlet, not a paper.


**References on this slide**

- Zhou J et al. (2024). An AI Agent for Fully Automated Multi-Omic Analyses. Advanced Science. https://doi.org/10.1002/advs.202407094
- Huang K et al. (2025). Biomni: A General-Purpose Biomedical AI Agent. bioRxiv. https://doi.org/10.1101/2025.05.30.656746
- Qu Y et al. (2025). CRISPR-GPT for agentic automation of gene-editing experiments. Nature Biomedical Engineering. https://doi.org/10.1038/s41551-025-01463-z
- Capoot A (CNBC) (2025). Anthropic launches Claude Life Sciences to give researchers an AI efficiency boost. CNBC. https://www.cnbc.com/2025/10/20/anthropic-claude-life-sciences-research-ai.html


## Slide 33 — Plant-science LLMs have arrived

*Content slide* · suggested time: **3 min**


**On the slide**

- In 2024 reviewers described the plant community as having largely not adopted LLMs; a 2025 breeding review still called their use in breeding 'largely unexplored'
- PLLaMa extends LLaMa-2 with more than 1.5 million plant-science articles, with open checkpoints and a review panel that included plant breeders (preprint)
- PlantGPT: an 8B model with retrieval over 60,000+ abstracts, fine-tuned on 13,993 Arabidopsis phenotypes and 23,323 gene functions, beats general LLMs on gene-function questions
- PlantScience.ai maintains a self-updating, citation-grounded knowledge graph of the plant literature


**Speaker notes**

The gap between general AI and plant science is roughly two years — and it is closing fast. The PlantGPT result repeats the PlantCAD2 lesson at the language level: an 8B domain model with retrieval beats much larger general chatbots on specialist questions. Domain grounding beats scale. And PlantScience.ai addresses the problem the students felt all semester: general models invent citations, so a system that grounds every answer in a retrieved primary source is what research actually needs.


**References on this slide**

- Lam HYI et al. (2024). Large language models in plant biology. Trends in Plant Science. https://doi.org/10.1016/j.tplants.2024.04.013
- Yoosefzadeh-Najafabadi M (2025). From text to traits: exploring the role of large language models in plant breeding. Frontiers in Plant Science. https://doi.org/10.3389/fpls.2025.1583344
- Yang X et al. (2024). PLLaMa: An Open-source Large Language Model for Plant Science. arXiv. https://doi.org/10.48550/arxiv.2401.01600
- Zhang R et al. (2025). PlantGPT: An Arabidopsis-Based Intelligent Agent that Answers Questions about Plant Functional Genomics. Advanced Science. https://doi.org/10.1002/advs.202503926
- Yu H et al. (2026). PlantScience.ai: An LLM-powered virtual scientist for plant science. Molecular Plant. https://doi.org/10.1016/j.molp.2026.03.010


## Slide 34 — Can an LLM breed? The first real tests

*Content slide* · suggested time: **3 min**


**On the slide**

- SeedBench, built with domain experts around real seed-breeding tasks, evaluated 26 proprietary, open-source and fine-tuned LLMs — and found substantial gaps against expert performance
- In a rice germplasm panel, LLM priors built from passport data (name, origin, subpopulation) reduced how many genotypes had to be evaluated before the best one was found for seed number per panicle
- The gain was small for protein content, and Gaussian-process Bayesian optimisation stayed strongest when genomic data were available (preprint)
- Honest verdict: useful priors and useful assistants — not yet a breeder


**Speaker notes**

The balance slide for Part 6. SeedBench is the cold shower: 26 models, still far from expert breeders on real tasks. The rice study is the encouraging signal: an LLM's background knowledge about cultivar names and origins genuinely helped decide which genebank accessions to grow first — most valuable exactly where you have no genomic data, which describes most genebank material worldwide. Be explicit that the honest reading is 'assistant, not breeder', and that this is a question students can test themselves on their own program's data.


**References on this slide**

- Ying J et al. (2025). SeedBench: A Multi-task Benchmark for Evaluating Large Language Models in Seed Science. Proceedings of ACL 2025 (Long Papers). https://doi.org/10.18653/v1/2025.acl-long.1516
- Hamazaki K, Tsuda K (2026). Knowledge-guided Bayesian optimization using pre-trained LLMs speeds up the identification of superior genotypes from germplasm collection. bioRxiv. https://doi.org/10.64898/2026.06.28.735149
- Yoosefzadeh-Najafabadi M (2025). From text to traits: exploring the role of large language models in plant breeding. Frontiers in Plant Science. https://doi.org/10.3389/fpls.2025.1583344


## Slide 35 — Industry is already generative

*Content slide* · suggested time: **3 min**


**On the slide**

- Bayer announced its E.L.Y. GenAI pilot in March 2024, trained on years of internal data and thousands of field trials
- By August 2025 Bayer reported 60% faster responses to customer questions and up to four hours saved per employee per week — company-reported metrics, not peer-reviewed
- Autonomous robots already collect breeding data at scale: ~200,000 plots, 142 fields, five years
- The uncomfortable part: the most capable assistants run on proprietary trial data in commercial clouds, while public programs depend on open models
- Data sovereignty is becoming a breeding-strategy question, not an IT question


**Speaker notes**

Two messages. First, this is not a future scenario — decades of proprietary trial data have already been turned into assistants that agronomists use daily, with reported productivity gains. Treat those numbers as company-reported. Second, and more important for a public university audience: capability is following data ownership. If public breeding programs do not organise, label and pool their own data, the gap will widen regardless of model access. Ask the class where their program's data actually lives, and who could train on it.


**References on this slide**

- Bayer AG (2024). Bayer pilots unique generative AI tool for agriculture. PR Newswire (Bayer press release). https://www.prnewswire.com/news-releases/bayer-pilots-unique-generative-ai-tool-for-agriculture-302088589.html
- AgTech Breakthrough / Bayer (2025). Bayer's E.L.Y. Wins 'AI-based AgTech Solution of the Year' in 2025 AgTech Breakthrough Awards Program. GlobeNewswire. https://www.globenewswire.com/news-release/2025/08/21/3137102/0/en/Bayer-s-E-L-Y-Wins-AI-based-AgTech-Solution-of-the-Year-In-2025-AgTech-Breakthrough-Awards-Program.html
- DeBruin J et al. (2025). Breaking the field phenotyping bottleneck in maize with autonomous robots. Communications Biology 8:467. https://doi.org/10.1038/s42003-025-07890-7
- Guo LY et al. (2026). Toward autonomous science with agentic artificial intelligence. Cell. https://doi.org/10.1016/j.cell.2026.08.052


## Slide 36 — Trust, but verify

*Figure slide* · suggested time: **4 min** · figure: `fig_trust.png`

> The capability curve and the verification curve are not the same curve


**Speaker notes**

The rigour slide, and the reason every slide today carries references. Across 636 citations in ChatGPT-written reviews, 55% of GPT-3.5 citations were fabricated and 18% of GPT-4 citations were — plus 43% and 24% of the real ones carried substantive errors. An independent audit found 42% of the AI Scientist's experiments failed due to coding errors, and that its novelty checks misclassified established ideas as new. On the other side, Kosmos reports 79.4% of statements judged accurate by independent scientists — impressive, and still one statement in five to check. A 2026 Cell perspective names hallucination, bias, irreproducibility and dual use as inseparable from the benefits. Practical rule for this course: every DOI gets resolved, every number traced to the source, every pipeline reviewed line by line.


**References on this slide**

- Walters WH, Wilder EI (2023). Fabrication and errors in the bibliographic citations generated by ChatGPT. Scientific Reports. https://doi.org/10.1038/s41598-023-41032-5
- Beel J et al. (2025). Evaluating Sakana's AI Scientist: Bold Claims, Mixed Results, and a Promising Future?. arXiv. https://doi.org/10.48550/arxiv.2502.14297
- Mitchener L et al. (2025). Kosmos: An AI Scientist for Autonomous Discovery. arXiv. https://doi.org/10.48550/arxiv.2511.02824
- Guo LY et al. (2026). Toward autonomous science with agentic artificial intelligence. Cell. https://doi.org/10.1016/j.cell.2026.08.052


## Slide 37 — The self-driving breeding program

*Figure slide* · suggested time: **5 min** · figure: `fig_loop.png`

> Each arrow now has a working AI component — the loop is the thesis


**Speaker notes**

Synthesis slide — the payoff for the whole lecture. Walk the loop and name the evidence at each arrow: DNA models score variants and candidate crosses; editing and speed breeding make the material; robots and vision models measure it at ~200,000 plots per program; weather and crop models plus G×E predictors place it in environments; an agent proposes the next cycle. Every single one of those components exists today in a published form. What does not exist is a verified end-to-end closure in a real breeding program — nobody in our reference base demonstrates that. Say that plainly: this is the single biggest open problem in the field, and it is the reason to stay in it. Note that the breeder sits in the centre — setting goals, checking evidence — not outside the loop.


**References on this slide**

- Zhai J et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. PNAS. https://doi.org/10.1073/pnas.2421738122
- Nguyen E et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. Science. https://doi.org/10.1126/science.ado9336
- DeBruin J et al. (2025). Breaking the field phenotyping bottleneck in maize with autonomous robots. Communications Biology 8:467. https://doi.org/10.1038/s42003-025-07890-7
- Morshedian A & Domaratzki M (2026). LSTM-attention-guided graph neural networks for integrated genotype–Environment modeling in maize yield prediction. PLOS Computational Biology 22:e1013729. https://doi.org/10.1371/journal.pcbi.1013729
- Ghareeb AE et al. (2026). A multi-agent system for automating scientific discovery. Nature. https://doi.org/10.1038/s41586-026-10652-y
- Sordo Z et al. (2024). RhizoNet segments plant roots to assess biomass and growth for enabling self-driving labs. Scientific Reports 14:12907. https://doi.org/10.1038/s41598-024-63497-8


## Slide 38 — What to learn next — concretely

*Content slide* · suggested time: **4 min**


**On the slide**

- Keep the quantitative genetics. Every model that beat a baseline here did so by encoding structure a breeder already understands
- Learn to fine-tune, not to pretrain: LoRA adapters, frozen backbones, transfer learning — that is where the published wins came from
- Get fluent with open models and open data: AgroNT, PlantCaduceus, PLLaMa on HuggingFace; G2F and GWHD for data
- Treat agents as collaborators that must be audited: resolve every DOI, review every line, benchmark against a tuned baseline
- Pick a bottleneck in your own program and attack it with these tools for one semester


**Speaker notes**

The practical takeaway slide; give them time to photograph it. Stress bullet one hardest — the students' comparative advantage over a computer scientist is that they understand G×E, heritability, population structure and selection. The papers where deep learning won were the ones that built that knowledge into the model. Bullet two is the realistic engineering path: nobody here will pretrain a foundation model, and nobody needs to. Bullet five is the ask: one bottleneck, one semester.


**References on this slide**

- Montesinos-López A et al. (2025). Artificial intelligence meets genomic selection: comparing deep learning and GBLUP across diverse plant datasets. Frontiers in Genetics. https://doi.org/10.3389/fgene.2025.1568705
- Potze A et al. (2025). Structured Multimodal Deep Learning improves Genomic Prediction in Future Environments. bioRxiv preprint. https://doi.org/10.1101/2025.09.05.674546
- Zhai J et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. PNAS. https://doi.org/10.1073/pnas.2421738122
- Chen F et al. (2023). Adapting Vision Foundation Models for Plant Phenotyping. Proc. IEEE/CVF ICCV Workshops 2023, pp. 604-613. https://doi.org/10.1109/iccvw60793.2023.00067
- Washburn JD et al. (2025). Global genotype by environment prediction competition reveals that diverse modeling strategies can deliver satisfactory maize yield estimates. Genetics. https://doi.org/10.1093/genetics/iyae195
- Walters WH, Wilder EI (2023). Fabrication and errors in the bibliographic citations generated by ChatGPT. Scientific Reports. https://doi.org/10.1038/s41598-023-41032-5


## Slide 39 — Open questions — let's argue about these

*Content slide* · suggested time: **22 min**


**On the slide**

- If a foundation model can score every variant in your pan-genome, what is the role of the QTL study?
- Where should a public breeding program spend the next R$1 million: more field plots, better phenotyping robots, or model development?
- Nobody has shown a foundation-model embedding improving field-level G×E prediction end to end. Why not — data, structure or evaluation?
- If an agent writes the analysis and drafts the paper, what exactly is the scientist's contribution?
- Who should own the model trained on a public breeding program's data?


**Speaker notes**

Discussion slide — plan 20–25 minutes here. Do not answer these; let them fight. Useful facilitation: split into pairs for 5 minutes on question 2, then take positions. For question 3, point out it is a genuine open gap in the literature we surveyed, not a rhetorical question — no paper in the reference base closes it. For question 5, connect back to the Bayer slide. If the room is quiet, start with question 4; it always gets a reaction.


**References on this slide**

- Benegas G et al. (2025). A DNA language model based on multispecies alignment predicts the effects of genome-wide variants. Nature Biotechnology. https://doi.org/10.1038/s41587-024-02511-w
- Li H et al. (2026). Omics-driven plant breeding through phenomics-enviromics crosstalk. Nature Communications. https://doi.org/10.1038/s41467-026-73097-x
- Morshedian A & Domaratzki M (2026). LSTM-attention-guided graph neural networks for integrated genotype–Environment modeling in maize yield prediction. PLOS Computational Biology 22:e1013729. https://doi.org/10.1371/journal.pcbi.1013729
- Lu C et al. (2026). Towards end-to-end automation of AI research. Nature. https://doi.org/10.1038/s41586-026-10265-5
- AgTech Breakthrough / Bayer (2025). Bayer's E.L.Y. Wins 'AI-based AgTech Solution of the Year' in 2025 AgTech Breakthrough Awards Program. GlobeNewswire. https://www.globenewswire.com/news-release/2025/08/21/3137102/0/en/Bayer-s-E-L-Y-Wins-AI-based-AgTech-Solution-of-the-Year-In-2025-AgTech-Breakthrough-Awards-Program.html


## Slide 40 — Your move

*Statement slide* · suggested time: **3 min**


**On the slide**

- Every result in this lecture was produced by someone who decided to try something that did not exist yet
- The data are public. The models are open. The gaps are documented — and several of them are plant-shaped
- A plant specialist with 676 million parameters beat a 7-billion-parameter generalist. Domain knowledge is the advantage, and you have it
- 73 references, all verified, in the file with this deck. Go read five of them this week


**Speaker notes**

Close on agency, not on technology. The strongest argument available: the plant specialist beating the generalist means the thing that makes them competitive is exactly what they spent years learning — the biology. Hand them the reference file and the markdown notes, name the two or three projects mentioned during the lecture (Biomni for crops, a plant CRISPR design agent, a pan-genome variant score table, the G2F reproduction), and open the floor. End on time.


**References on this slide**

- Zhai J et al. (2026). PlantCAD2: A DNA foundation model for interpreting genomes across flowering plants. Cell Genomics. https://doi.org/10.1016/j.xgen.2026.101329
- Washburn JD et al. (2025). Global genotype by environment prediction competition reveals that diverse modeling strategies can deliver satisfactory maize yield estimates. Genetics. https://doi.org/10.1093/genetics/iyae195
- Mendoza-Revilla J et al. (2024). A foundational large language model for edible plant genomes. Communications Biology. https://doi.org/10.1038/s42003-024-06465-2
- Li H et al. (2026). Omics-driven plant breeding through phenomics-enviromics crosstalk. Nature Communications. https://doi.org/10.1038/s41467-026-73097-x


---

## Full reference list (73 verified sources)

- **Benegas2023GPN** — Benegas G et al. (2023). DNA language models are powerful predictors of genome-wide variant effects. PNAS. https://doi.org/10.1073/pnas.2311219120
- **Benegas2025GPNMSA** — Benegas G et al. (2025). A DNA language model based on multispecies alignment predicts the effects of genome-wide variants. Nature Biotechnology. https://doi.org/10.1038/s41587-024-02511-w
- **Brixi2025Evo2** — Brixi G et al. (2025). Genome modeling and design across all domains of life with Evo 2. bioRxiv. https://doi.org/10.1101/2025.02.18.638918 *[preprint]*
- **Cao2025scPlantLLM** — Cao G et al. (2025). scPlantLLM: A Foundation Model for Exploring Single-cell Expression Atlases in Plants. Genomics, Proteomics & Bioinformatics. https://doi.org/10.1093/gpbjnl/qzaf024
- **Chen2026G2F** — Chen Q et al. (2026). Genomes to fields 2024 maize genotype by environment prediction competition. BMC Research Notes. https://doi.org/10.1186/s13104-026-07629-5
- **Cheng2026scMaize** — Cheng Q et al. (2026). scMaize: A Single-Cell Foundation Model and Integrated Atlas for Maize. bioRxiv. https://doi.org/10.64898/2026.08.01.742180 *[preprint]*
- **King2026Phage** — King SH et al. (2026). Generative design of bacteriophages with genome language models. Science. https://doi.org/10.1126/science.aec2657
- **Li2026PE** — Li H et al. (2026). Omics-driven plant breeding through phenomics-enviromics crosstalk. Nature Communications. https://doi.org/10.1038/s41467-026-73097-x *[review]*
- **Long2026SugarBeet** — Long E et al. (2026). Evolutionary and Deep Learning Models Highlight Deleterious Mutations Behind the History of Sugar Beet Breeding. G3: Genes, Genomes, Genetics. https://doi.org/10.1093/g3journal/jkag264
- **Mantegazza2026** — Mantegazza O et al. (2026). Evo 2’s perception of single nucleotide substitutions in the genes of two plant model organisms. Open Research Europe. https://doi.org/10.12688/openreseurope.24244.1
- **MendozaRevilla2024AgroNT** — Mendoza-Revilla J et al. (2024). A foundational large language model for edible plant genomes. Communications Biology. https://doi.org/10.1038/s42003-024-06465-2
- **MontesinosLopez2024** — Montesinos-López OA et al. (2024). A review of multimodal deep learning methods for genomic-enabled prediction in plant breeding. Genetics. https://doi.org/10.1093/genetics/iyae161 *[review]*
- **MontesinosLopez2025** — Montesinos-López A et al. (2025). Artificial intelligence meets genomic selection: comparing deep learning and GBLUP across diverse plant datasets. Frontiers in Genetics. https://doi.org/10.3389/fgene.2025.1568705
- **Nguyen2024Evo** — Nguyen E et al. (2024). Sequence modeling and design from molecular to genome scale with Evo. Science. https://doi.org/10.1126/science.ado9336
- **Peleke2024** — Peleke FF et al. (2024). Deep learning the cis-regulatory code for gene expression in selected model plants. Nature Communications. https://doi.org/10.1038/s41467-024-47744-0
- **Qian2026OGR** — Qian B et al. (2026). OneGenome-Rice (OGR): A genomic foundation model for rice. bioRxiv. https://doi.org/10.64898/2026.04.21.719822 *[preprint]*
- **Wang2024DeepCBA** — Wang Z et al. (2024). DeepCBA: A deep learning framework for gene expression prediction in maize based on DNA sequences and chromatin interactions. Plant Communications. https://doi.org/10.1016/j.xplc.2024.100985
- **Wang2025Cropformer** — Wang H et al. (2025). Cropformer: An interpretable deep learning framework for crop genomic prediction. Plant Communications. https://doi.org/10.1016/j.xplc.2024.101223
- **Wang2026Setaria** — Wang W et al. (2026). Integrating pan-genome analysis, GWAS, and interpretable machine learning to prioritize trait-associated structural variations in Setaria italica. Plant Communications. https://doi.org/10.1016/j.xplc.2025.101626
- **Washburn2025** — Washburn JD et al. (2025). Global genotype by environment prediction competition reveals that diverse modeling strategies can deliver satisfactory maize yield estimates. Genetics. https://doi.org/10.1093/genetics/iyae195
- **Wu2024** — Wu Z et al. (2024). Phenotype prediction in plants is improved by integrating large-scale transcriptomic datasets. NAR Genomics and Bioinformatics. https://doi.org/10.1093/nargab/lqae184
- **Yu2024PlantRNAFM** — Yu H et al. (2024). An interpretable RNA foundation model for exploring functional RNA motifs in plants. Nature Machine Intelligence. https://doi.org/10.1038/s42256-024-00946-z
- **Yu2025EXGEP** — Yu T et al. (2025). EXGEP: a framework for predicting genotype-by-environment interactions using ensembles of explainable machine-learning models. Briefings in Bioinformatics. https://doi.org/10.1093/bib/bbaf414
- **Zhai2025PlantCaduceus** — Zhai J et al. (2025). Cross-species modeling of plant genomes at single-nucleotide resolution using a pretrained DNA language model. PNAS. https://doi.org/10.1073/pnas.2421738122
- **Zhai2026PlantCAD2** — Zhai J et al. (2026). PlantCAD2: A DNA foundation model for interpreting genomes across flowering plants. Cell Genomics. https://doi.org/10.1016/j.xgen.2026.101329
- **Anthropic2025** — Capoot A (CNBC) (2025). Anthropic launches Claude Life Sciences to give researchers an AI efficiency boost. CNBC. https://www.cnbc.com/2025/10/20/anthropic-claude-life-sciences-research-ai.html *[news report]*
- **Bayer2024** — Bayer AG (2024). Bayer pilots unique generative AI tool for agriculture. PR Newswire (Bayer press release). https://www.prnewswire.com/news-releases/bayer-pilots-unique-generative-ai-tool-for-agriculture-302088589.html *[company announcement]*
- **Bayer2025** — AgTech Breakthrough / Bayer (2025). Bayer's E.L.Y. Wins 'AI-based AgTech Solution of the Year' in 2025 AgTech Breakthrough Awards Program. GlobeNewswire. https://www.globenewswire.com/news-release/2025/08/21/3137102/0/en/Bayer-s-E-L-Y-Wins-AI-based-AgTech-Solution-of-the-Year-In-2025-AgTech-Breakthrough-Awards-Program.html *[company announcement]*
- **Beel2025** — Beel J et al. (2025). Evaluating Sakana's AI Scientist: Bold Claims, Mixed Results, and a Promising Future?. arXiv. https://doi.org/10.48550/arxiv.2502.14297 *[preprint]*
- **Boiko2023** — Boiko DA et al. (2023). Autonomous chemical research with large language models. Nature. https://doi.org/10.1038/s41586-023-06792-0
- **Brown2025** — Brown CF et al. (2025). AlphaEarth Foundations: An embedding field model for accurate and efficient global mapping from sparse label data. arXiv / Google DeepMind. https://doi.org/10.48550/arxiv.2507.22291 *[preprint]*
- **Bubeck2025** — Bubeck S et al. (2025). Early science acceleration experiments with GPT-5. arXiv. https://doi.org/10.48550/arxiv.2511.16072 *[preprint]*
- **Ghareeb2026** — Ghareeb AE et al. (2026). A multi-agent system for automating scientific discovery. Nature. https://doi.org/10.1038/s41586-026-10652-y
- **Gottweis2025** — Gottweis J et al. (2025). Accelerating scientific discovery with Co-Scientist (v1 title: Towards an AI co-scientist). arXiv. https://doi.org/10.48550/arxiv.2502.18864 *[preprint]*
- **Guo2026** — Guo LY et al. (2026). Toward autonomous science with agentic artificial intelligence. Cell. https://doi.org/10.1016/j.cell.2026.08.052 *[review]*
- **Hamazaki2026** — Hamazaki K, Tsuda K (2026). Knowledge-guided Bayesian optimization using pre-trained LLMs speeds up the identification of superior genotypes from germplasm collection. bioRxiv. https://doi.org/10.64898/2026.06.28.735149 *[preprint]*
- **Huang2025** — Huang K et al. (2025). Biomni: A General-Purpose Biomedical AI Agent. bioRxiv. https://doi.org/10.1101/2025.05.30.656746 *[preprint]*
- **Lam2024** — Lam HYI et al. (2024). Large language models in plant biology. Trends in Plant Science. https://doi.org/10.1016/j.tplants.2024.04.013 *[review]*
- **Lu2026** — Lu C et al. (2026). Towards end-to-end automation of AI research. Nature. https://doi.org/10.1038/s41586-026-10265-5
- **Mitchener2025** — Mitchener L et al. (2025). Kosmos: An AI Scientist for Autonomous Discovery. arXiv. https://doi.org/10.48550/arxiv.2511.02824 *[preprint]*
- **Qu2025** — Qu Y et al. (2025). CRISPR-GPT for agentic automation of gene-editing experiments. Nature Biomedical Engineering. https://doi.org/10.1038/s41551-025-01463-z
- **Walters2023** — Walters WH, Wilder EI (2023). Fabrication and errors in the bibliographic citations generated by ChatGPT. Scientific Reports. https://doi.org/10.1038/s41598-023-41032-5
- **Yang2024** — Yang X et al. (2024). PLLaMa: An Open-source Large Language Model for Plant Science. arXiv. https://doi.org/10.48550/arxiv.2401.01600 *[preprint]*
- **Ying2025** — Ying J et al. (2025). SeedBench: A Multi-task Benchmark for Evaluating Large Language Models in Seed Science. Proceedings of ACL 2025 (Long Papers). https://doi.org/10.18653/v1/2025.acl-long.1516
- **YoosefzadehNajafabadi2025** — Yoosefzadeh-Najafabadi M (2025). From text to traits: exploring the role of large language models in plant breeding. Frontiers in Plant Science. https://doi.org/10.3389/fpls.2025.1583344 *[review]*
- **Yu2026** — Yu H et al. (2026). PlantScience.ai: An LLM-powered virtual scientist for plant science. Molecular Plant. https://doi.org/10.1016/j.molp.2026.03.010
- **Zhang2025** — Zhang R et al. (2025). PlantGPT: An Arabidopsis-Based Intelligent Agent that Answers Questions about Plant Functional Genomics. Advanced Science. https://doi.org/10.1002/advs.202503926
- **Zhou2024** — Zhou J et al. (2024). An AI Agent for Fully Automated Multi-Omic Analyses. Advanced Science. https://doi.org/10.1002/advs.202407094
- **AvilesToledo2024** — Aviles Toledo C et al. (2024). Integrating multi-modal remote sensing, deep learning, and attention mechanisms for yield prediction in plant breeding experiments. Frontiers in Plant Science 15:1408047. https://doi.org/10.3389/fpls.2024.1408047
- **Bodnar2025** — Bodnar C et al. (2025). A foundation model for the Earth system. Nature 641:1180-1187. https://doi.org/10.1038/s41586-025-09005-y
- **Chen2023** — Chen F et al. (2023). Adapting Vision Foundation Models for Plant Phenotyping. Proc. IEEE/CVF ICCV Workshops 2023, pp. 604-613. https://doi.org/10.1109/iccvw60793.2023.00067
- **David2021** — David E et al. (2021). Global Wheat Head Detection 2021: An Improved Dataset for Benchmarking Wheat Head Detection Methods. Plant Phenomics 2021:9846158. https://doi.org/10.34133/2021/9846158
- **DeBruin2025** — DeBruin J et al. (2025). Breaking the field phenotyping bottleneck in maize with autonomous robots. Communications Biology 8:467. https://doi.org/10.1038/s42003-025-07890-7
- **Drees2024** — Drees L et al. (2024). Data-driven crop growth simulation on time-varying generated images using multi-conditional generative adversarial networks. Plant Methods 20:93. https://doi.org/10.1186/s13007-024-01205-3
- **Google2025** — Google Research & University of Chicago (2025). How AI is helping 38 million farmers with advance weather predictions. Google blog / UChicago Institute for Climate and Sustainable Growth. https://blog.google/innovation-and-ai/technology/research/indian-farmers-monsoon-prediction/ *[company announcement]*
- **Jia2026** — Jia H et al. (2026). The Turning Point of 3D Plant Phenotyping: 3D Foundation Models Enable Minute-to-Second Cross-Crop Reconstruction and Beyond. arXiv preprint. https://doi.org/10.48550/arxiv.2607.01753 *[preprint]*
- **Kaushal2026** — Kaushal S et al. (2026). UAV‐based deep transfer learning to improve grain yield prediction in winter wheat across temporal and spatial variability. The Plant Phenome Journal 9:e70085. https://doi.org/10.1002/ppj2.70085
- **Kim2024** — Kim S & Heo S (2024). An agricultural digital twin for mandarins demonstrates the potential for individualized agriculture. Nature Communications 15:1561. https://doi.org/10.1038/s41467-024-45725-x
- **Kirillov2023** — Kirillov A et al. (2023). Segment Anything. Proc. IEEE/CVF ICCV 2023, pp. 3992-4003. https://doi.org/10.1109/iccv51070.2023.00371
- **Kochkov2024** — Kochkov D et al. (2024). Neural general circulation models for weather and climate. Nature 632:1060-1066. https://doi.org/10.1038/s41586-024-07744-y
- **Lam2023** — Lam R et al. (2023). Learning skillful medium-range global weather forecasting. Science 382:1416-1421. https://doi.org/10.1126/science.adi2336
- **Lin2025** — Lin Y et al. (2025). NeuralCrop: Combining physics and machine learning for improved crop yield projections. arXiv preprint. https://doi.org/10.48550/arxiv.2512.20177 *[preprint]*
- **Lin2026** — Lin Y et al. (2026). SAM-CLIP-Thermal: Leveraging large multimodal models for reliable and scalable annotation in thermal image segmentation for field plant phenotyping. Plant Phenomics 8:100264. https://doi.org/10.1016/j.plaphe.2026.100264
- **Macia2025** — Maciá F et al. (2025). OneRosette to predict them all: single plant prompting on a visual foundation model to segment symptomatic Arabidopsis thaliana time series. Plant Methods 21:128. https://doi.org/10.1186/s13007-025-01432-2
- **Masiwal2026** — Masiwal R et al. (2026). Decision-oriented benchmarking to transform AI weather forecast access: Application to the Indian monsoon. arXiv preprint. https://doi.org/10.48550/arxiv.2602.03767 *[preprint]*
- **Morshedian2026** — Morshedian A & Domaratzki M (2026). LSTM-attention-guided graph neural networks for integrated genotype–Environment modeling in maize yield prediction. PLOS Computational Biology 22:e1013729. https://doi.org/10.1371/journal.pcbi.1013729
- **Potze2025** — Potze A et al. (2025). Structured Multimodal Deep Learning improves Genomic Prediction in Future Environments. bioRxiv preprint. https://doi.org/10.1101/2025.09.05.674546 *[preprint]*
- **Price2025** — Price I et al. (2025). Probabilistic weather forecasting with machine learning. Nature 637:84-90 (online 4 Dec 2024). https://doi.org/10.1038/s41586-024-08252-9
- **Sordo2024** — Sordo Z et al. (2024). RhizoNet segments plant roots to assess biomass and growth for enabling self-driving labs. Scientific Reports 14:12907. https://doi.org/10.1038/s41598-024-63497-8
- **Wang2026** — Wang Z et al. (2026). Depth4PH: a vision foundation model-based framework for plant height estimation in agricultural scenes. Artificial Intelligence in Agriculture. https://doi.org/10.1016/j.aiia.2026.08.006
- **Xiang2026** — Xiang S et al. (2026). SPROUT: A Scalable Diffusion Foundation Model for Multi-Crop Plant Phenotyping. arXiv preprint. https://doi.org/10.48550/arxiv.2603.27519 *[preprint]*
- **Xie2025** — Xie K et al. (2025). Automated 3D Segmentation of Plant Organs via the Plant-MAE: A Self-Supervised Learning Framework. Plant Phenomics 7:100049. https://doi.org/10.1016/j.plaphe.2025.100049
- **Zhuang2024** — Zhuang H et al. (2024). Integrating data assimilation, crop model, and machine learning for winter wheat yield forecasting in the North China Plain. Agricultural and Forest Meteorology 347:109909. https://doi.org/10.1016/j.agrformet.2024.109909