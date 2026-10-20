library(yaml)

cfg <- yaml::read_yaml("config/parametros.yaml")
rds_path <- file.path(cfg$caminhos$intermediario, "01_importado.rds")

stopifnot(file.exists(rds_path))

d <- readRDS(rds_path)

stopifnot(ncol(d) == 9)
stopifnot(nrow(d) == 2426)
stopifnot(is.numeric(d$PROD))
stopifnot(is.integer(d$bloco))
stopifnot(is.integer(d$linha))
stopifnot(is.integer(d$coluna))
stopifnot(is.character(d$parcela_id))

ambientes_esperados <- c("PGO_2025_V", "SLG_2025_V", "UDI_2025_V")
stopifnot(all(ambientes_esperados %in% unique(d$ambiente_id)))

cat("01: OK\n")
