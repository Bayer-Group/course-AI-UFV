# Etapa 02: controle de qualidade (só relata, não corrige)
# Entradas: data/intermediario/01_importado.rds, config/parametros.yaml
# Saídas:   output/02_qc_relatorio.csv
# Premissas: duplicata por (ensaio_id, linha, coluna); intervalo de PROD do YAML

source("R/funcoes.R")
par <- yaml::read_yaml("config/parametros.yaml")
x <- readRDS(file.path(par$caminhos$intermediario, "01_importado.rds"))

qc <- detectar_problemas(x, par)
print(table(qc$tipo))
cat("Total:", nrow(qc), "\n")

dir.create(par$caminhos$output, showWarnings = FALSE, recursive = TRUE)
write.csv(qc, file.path(par$caminhos$output, "02_qc_relatorio.csv"), row.names = FALSE)
