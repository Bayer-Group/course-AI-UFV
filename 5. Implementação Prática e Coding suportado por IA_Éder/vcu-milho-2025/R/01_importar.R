# Entradas:   config/parametros.yaml, data/bruto/vcu_milho_2025_campo.csv
# Saídas:     data/intermediario/01_importado.rds
# Premissas:  CSV com 9 colunas conforme dicionário; arquivo bruto nunca alterado

library(yaml)

cfg <- yaml::read_yaml("config/parametros.yaml")

d <- read.csv(cfg$caminhos$bruto, stringsAsFactors = FALSE, na.strings = "")

stopifnot(ncol(d) == 9)

# Coerção de tipos
d$bloco   <- as.integer(d$bloco)
d$linha   <- as.integer(d$linha)
d$coluna  <- as.integer(d$coluna)
d$PROD    <- as.numeric(d$PROD)

cat("Colunas:", paste(names(d), collapse = ", "), "\n")
cat("Total de parcelas:", nrow(d), "\n")
print(table(d$ambiente_id))

dir.create(cfg$caminhos$intermediario, showWarnings = FALSE, recursive = TRUE)
saveRDS(d, file.path(cfg$caminhos$intermediario, "01_importado.rds"))
