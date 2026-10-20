# Etapa 01: importar o dado bruto
# Entradas: data/bruto/vcu_milho_2025_campo.csv, docs/dicionario_de_dados.csv
# Saídas:   data/intermediario/01_importado.rds
# Premissas: o bruto não é alterado; colunas na ordem do dicionário

par <- yaml::read_yaml("config/parametros.yaml")
x <- read.csv(par$caminhos$bruto, stringsAsFactors = FALSE)
dic <- read.csv(par$caminhos$dicionario, stringsAsFactors = FALSE)

stopifnot(identical(names(x), dic$variavel))
x$bloco <- as.integer(x$bloco)
x$linha <- as.integer(x$linha)
x$coluna <- as.integer(x$coluna)
x$PROD <- as.numeric(x$PROD)
x$data_coleta <- as.Date(x$data_coleta)

cat("Linhas:", nrow(x), "\n")
print(table(x$ambiente_id))

dir.create(par$caminhos$intermediario, showWarnings = FALSE, recursive = TRUE)
saveRDS(x, file.path(par$caminhos$intermediario, "01_importado.rds"))
