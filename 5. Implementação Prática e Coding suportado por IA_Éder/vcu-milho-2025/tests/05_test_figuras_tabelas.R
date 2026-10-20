# tests/05_test_figuras_tabelas.R
# Verifica existencia e integridade minima das saidas da Etapa 05.

library(yaml)
cfg <- yaml.load_file("config/parametros.yaml")
out <- cfg$caminhos$output

f_prec  <- file.path(out, "05_precisao_ambientes.csv")
f_rank  <- file.path(out, "05_ranking_dh25.csv")
f_png   <- file.path(out, "05_blups_dh25.png")

# 1. Arquivos existem
stopifnot("05_precisao_ambientes.csv existe" = file.exists(f_prec))
stopifnot("05_ranking_dh25.csv existe"       = file.exists(f_rank))
stopifnot("05_blups_dh25.png existe"         = file.exists(f_png))

# 2. Precisao: 3 linhas (um por ambiente) e colunas esperadas
prec <- read.csv(f_prec, stringsAsFactors = FALSE)
stopifnot("precisao tem 3 linhas"     = nrow(prec) == 3L)
stopifnot("col ambiente em precisao"  = "ambiente" %in% names(prec))
stopifnot("col media em precisao"     = "media"    %in% names(prec))
stopifnot("col CV em precisao"        = "CV"       %in% names(prec))
stopifnot("col h2 em precisao"        = "h2"       %in% names(prec))

# 3. Ranking: <= 20 linhas e so genotipos DH25_*
rank <- read.csv(f_rank, stringsAsFactors = FALSE)
prefixo <- cfg$ids$prefixo_ranking
stopifnot("ranking <= 20 linhas"      = nrow(rank) <= 20L)
stopifnot("so genotipos DH25_*"       = all(startsWith(rank$genotipo, prefixo)))

# 4. PNG com tamanho > 0
stopifnot("png > 0 bytes" = file.info(f_png)$size > 0)

cat("Todos os checks da Etapa 05 passaram.\n")
