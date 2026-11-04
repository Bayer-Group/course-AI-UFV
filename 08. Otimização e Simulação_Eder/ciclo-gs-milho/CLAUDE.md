# Projeto: ciclo de seleção genômica em milho (dados simulados)

## Objetivo
Programa de linhagens duplo-haploides (DH) do grupo heterótico A, avaliadas em
testcross com um testador do grupo B. Ciclo completo:
simulação → banco → QC → BLUP multiambiente → seleção genômica → cruzamentos → novo ciclo.

## Fonte única de parâmetros
Todos os parâmetros ficam em `config/parametros.yaml`. Nunca escreva valores
numéricos de simulação ou de análise diretamente nos scripts.

## Organização dos dados
- **Simulador** (`R/01_simulacao.R`, `R/02_carga_banco.R`, `R/07_novo_ciclo.R`):
  produz o banco e os genótipos. É o único código que escreve em `data/gabarito/`.
- **Banco** (`db/programa_milho.duckdb`, esquema em `db/schema.sql`):
  - camada bruta (`bruto_*`): dados como chegam do campo, com erros;
  - camada curada (`ambiente`, `ensaio`, `germoplasma`, `pedigree`, `parcela`,
    `observacao`, `amostra_genotipo`): populada apenas por `R/03_qc.R`;
  - visão de análise: `v_prod_parcela`.
- **Genótipos**: `data/genotipos/snps.rds` (matriz 0/2, linhas = germoplasma_id) e
  `data/genotipos/mapa_snps.csv` (mapa genético em Morgans).
- **Dicionário de variáveis**: `data/dicionario.csv` (inclui intervalos válidos).
- **Gabarito** (`data/gabarito/`): valores genéticos verdadeiros e erros injetados.
  PROIBIDO usar em qualquer etapa de estimação, seleção ou predição. Só pode ser lido
  por `R/validar_contra_gabarito.R`, por `tests/` e pelo simulador.

## Premissas da simulação (não altere sem registrar em docs/etapas/)
- O fenótipo é o do híbrido testcross (linhagem × testador), por parcela.
- Valor genético específico de local, constante entre anos; G×ano vai para o erro.
- SNPs e QTLs não se sobrepõem (`restrSegSites(overlap = FALSE)`).
- O AlphaSimR simula interferência de crossing-over (v = 2,6): fórmulas que usam
  frequência de recombinação devem usar a função de Kosambi (ver `R/06_cruzamentos.R`).
- Reprodutibilidade: `runMacs` não respeita `set.seed`, por isso a população
  fundadora é versionada em `data/fundadores/`; o AlphaSimR roda com
  `SP$nThreads <- 1L`, porque com mais threads `makeDH` deixa de ser reproduzível.

## Convenções de código
- R; um script por etapa em `R/`, numerados; funções comuns em `R/utils.R`.
- Conexão ao banco sempre por `conectar()` (DuckDB; SQLite como alternativa).
- Semente lida do YAML.
- Toda função de estimação tem teste em `tests/` com dado de parâmetro conhecido.

## Regras científicas
- Modelo MET de referência (dados de parcela, nunca médias):
  `PROD ~ ambiente + (1|bloco:ambiente) + (1|linhagem) + (1|linhagem:ambiente)`.
- Herdabilidade em base de médias: H2 = s2g / (s2g + s2ge/e + s2e/(r·e));
  para dados desbalanceados, reportar também a de Cullis et al. (2006).
- Acurácia = cor(predição, valor genético verdadeiro) — só em validação.
  Capacidade preditiva = cor(predição, BLUP ou fenótipo).
- Métricas de predição calculadas dentro de cada coorte (coorte confundida com ano).
- Toda consulta SQL que alimenta análise com sorteio (folds, sementes) usa `ORDER BY`.
- Validação cruzada principal por família; aleatória só como contraste.
- Fórmula nova exige referência primária em comentário e teste numérico.

## Forma de trabalho
- Comece cada etapa do `PLANO.md` em modo de planejamento e aguarde aprovação.
- Ao terminar uma etapa, escreva `docs/etapas/NN_nome.md` (o que foi feito, decisões,
  números de validação, pendências) e registre os prompts usados em `docs/prompts/`.
- Não avance sem que `Rscript tests/run_rapidos.R` e o teste da etapa passem.
