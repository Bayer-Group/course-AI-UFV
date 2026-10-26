# Apaga tudo que é gerado durante a aula prática.
# Rode antes de cada turma: source("reset_pratica.R")

setwd(dirname(sys.frame(1)$ofile))

gerados <- c(
  # scripts gerados pelo agente
  "R/01_diagnostico.R",
  "R/02_curar.R",
  "R/03_qualidade.R",

  # outputs do 01_diagnostico
  "output/tabelas/diagnostico_casos.csv",

  # outputs do 02_curar
  "data/processado/parcelas_curadas.csv",
  "docs/registro_de_correcoes.csv",
  "output/tabelas/outliers_sinalizados.csv",

  # outputs do 03_qualidade
  "output/tabelas/qualidade_por_ambiente.csv",
  "output/figuras/media_cv_ambiente.png",
  "output/figuras/prod_boxplot_ambiente.png",
  "output/figuras/prod_hist_ambiente.png",

  # artefatos de sessão R
  ".RData",
  ".Rhistory"
)

existem <- gerados[file.exists(gerados)]
if (length(existem) > 0) {
  file.remove(existem)
  cat(sprintf("removido: %s\n", existem), sep = "")
}

cat(sprintf("\n%d arquivo(s) removido(s). Repositório pronto para a prática.\n",
            length(existem)))
