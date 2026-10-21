## limpeza.R — zera a pasta antes da aula prática
## Rode da raiz do projeto: Rscript limpeza.R

arquivos <- c(
  # dados intermediários e processados
  "data/intermediario/01_importado.rds",
  "data/processado/03_curado.rds",

  # output
  "output/02_qc_relatorio.csv",
  "output/04_individual.csv",
  "output/04_individual_run1.csv",
  "output/04_conjunta_blups.csv",
  "output/04_conjunta_blups_run1.csv",
  "output/05_precisao_ambientes.csv",
  "output/05_ranking_dh25.csv",
  "output/05_blups_dh25.png",

  # registro de correções (gerado pela etapa 03)
  "docs/registro_de_correcoes.csv",

  # relatórios de etapa
  "docs/etapas/01_importar.md",
  "docs/etapas/02_qc.md",
  "docs/etapas/03.md",
  "docs/etapas/04.md",
  "docs/etapas/04_analise.md",

  # pareceres do orientador
  "docs/revisoes/04_parecer_r1.md",
  "docs/revisoes/04_parecer_r2.md",

  # decisões
  "docs/decisoes.md",

  # scripts gerados pelo agente
  "R/01_importar.R",
  "R/02_qc.R",
  "R/03_curar.R",
  "R/04_analise.R",
  "R/05_figuras_tabelas.R",
  "R/funcoes.R",

  # testes gerados pelo agente
  "tests/01_test_importar.R",
  "tests/02_test_qc.R",
  "tests/03_test_curar.R",
  "tests/04_test_analise.R",
  "tests/05_test_figuras_tabelas.R",

  # knit output e temporários
  "roteiro_pratica.html",
  "tmp_inspect.R"
)

removidos <- 0L
for (f in arquivos) {
  if (file.exists(f)) {
    file.remove(f)
    cat("x", f, "\n")
    removidos <- removidos + 1L
  }
}
cat(sprintf("\nLimpeza concluída: %d arquivo(s) removido(s).\n", removidos))
