# limpeza.R
# Remove todos os arquivos gerados durante a execucao do roteiro_aula.Rmd
# para que a pasta estudo-artigo possa iniciar limpa para uma nova pratica.
#
# Uso: Rscript limpeza.R
#      source("limpeza.R")   # dentro de uma sessao R

cat("Limpando arquivos gerados pelo roteiro...\n")

# Arquivos gerados pelas etapas do roteiro
gerados <- c(
  # Etapa 2 - Leitura em camadas
  "notas/01_mapa_do_artigo.md",
  "notas/02_glossario.md",
  "config/parametros_artigo.yaml",

  # Etapa 3 - Perguntas
  "notas/03_perguntas.md",

  # Etapa 4 - Modelo minimo
  "R/00_calculos_teoricos.R",
  "R/10_modelo_minimo.R",

  # Fechamento
  "DESVIOS.md",
  "REPRODUTIBILIDADE.md",

  # Agentes criados durante sessao
  ".claude/agents/revisor-cetico.md",

  # Artefatos do Rmd
  "roteiro_aula.html",

  # Historico R e metadados de SO
  ".Rhistory",
  ".DS_Store",
  ".claude/.DS_Store"
)

# Pastas que podem conter figuras geradas
dirs_figuras <- c("Rplots.pdf")

removidos <- 0L
for (f in c(gerados, dirs_figuras)) {
  if (file.exists(f)) {
    file.remove(f)
    cat("  removido:", f, "\n")
    removidos <- removidos + 1L
  }
}

# Remover figuras PNG/PDF soltas na raiz (geradas pelo modelo minimo)
for (ext in c("*.png", "*.pdf")) {
  figs <- Sys.glob(ext)
  figs <- figs[!grepl("^artigo/", figs)]
  for (f in figs) {
    file.remove(f)
    cat("  removido:", f, "\n")
    removidos <- removidos + 1L
  }
}

# Garantir que os .gitkeep continuem existindo
for (d in c("notas", "R", "config", "artigo")) {
  gk <- file.path(d, ".gitkeep")
  if (!file.exists(gk)) {
    file.create(gk)
    cat("  restaurado:", gk, "\n")
  }
}

cat(sprintf("Pronto: %d arquivo(s) removido(s).\n", removidos))
cat("A pasta esta limpa para uma nova execucao do roteiro.\n")

