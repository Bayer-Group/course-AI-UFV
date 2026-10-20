# Testa outputs de R/04_analise.R
# Falha (stop) se qualquer check quebrar.

library(yaml)
cfg <- yaml::read_yaml("config/parametros.yaml")
outd <- cfg$caminhos$output

# ── Arquivos existem com colunas esperadas ────────────────────────────────────
ind_path   <- file.path(outd, "04_individual.csv")
blups_path <- file.path(outd, "04_conjunta_blups.csv")

stopifnot("04_individual.csv não existe"      = file.exists(ind_path))
stopifnot("04_conjunta_blups.csv não existe"  = file.exists(blups_path))

ind   <- read.csv(ind_path,   stringsAsFactors = FALSE)
blups <- read.csv(blups_path, stringsAsFactors = FALSE)

stopifnot("colunas ind"   = all(c("ambiente","media","CV","h2") %in% names(ind)))
stopifnot("colunas blups" = all(c("genotipo","blup","rank")     %in% names(blups)))

# ── h² dentro de [0, 1] ───────────────────────────────────────────────────────
stopifnot("h2 >= 0" = all(ind$h2 >= 0))
stopifnot("h2 <= 1" = all(ind$h2 <= 1))

# ── Variâncias ≥ 0 ────────────────────────────────────────────────────────────
stopifnot("s2g >= 0" = all(ind$s2g >= 0))
stopifnot("s2e >= 0" = all(ind$s2e >= 0))

# ── BLUPs contém apenas DH25_* ───────────────────────────────────────────────
prefixo <- cfg$ids$prefixo_ranking
stopifnot("BLUPs só DH25_*" = all(startsWith(blups$genotipo, prefixo)))

# ── Rank é sequência sem repetição ───────────────────────────────────────────
stopifnot("rank sequencial" = identical(sort(blups$rank), seq_len(nrow(blups))))

# ── Três ambientes no individual ─────────────────────────────────────────────
stopifnot("3 ambientes" = nrow(ind) == 3L)

cat("Todos os checks passaram.\n")
cat(sprintf("  Ambientes: %s\n", paste(ind$ambiente, collapse=", ")))
cat(sprintf("  h2: %s\n", paste(round(ind$h2, 3), collapse=", ")))
cat(sprintf("  CV: %s\n", paste(round(ind$CV, 1), collapse=", ")))
cat(sprintf("  n BLUPs DH25: %d\n", nrow(blups)))
