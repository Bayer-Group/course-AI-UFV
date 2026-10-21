# 01_importar.R
# Entradas: data/bruto/vcu_milho_2025_campo.csv, config/parametros.yaml,
#           docs/dicionario_de_dados.csv
# Saídas:   data/intermediario/01_importado.rds
# Premissa: CSV com 9 colunas conforme dicionário; tipos conferidos na importação.

par <- yaml::read_yaml("config/parametros.yaml")

dic <- read.csv(par$caminhos$dicionario, stringsAsFactors = FALSE)
colunas_esperadas <- dic$variavel

d <- read.csv(par$caminhos$bruto, stringsAsFactors = FALSE, na.strings = "")

faltam <- setdiff(colunas_esperadas, names(d))
sobram <- setdiff(names(d), colunas_esperadas)
if (length(faltam) > 0) stop("Colunas faltando: ", paste(faltam, collapse = ", "))
if (length(sobram) > 0) warning("Colunas extras: ", paste(sobram, collapse = ", "))

cols_int <- dic$variavel[dic$tipo == "inteiro"]
for (col in cols_int) {
  if (!is.integer(d[[col]])) d[[col]] <- as.integer(d[[col]])
}

cols_real <- dic$variavel[dic$tipo == "real"]
for (col in cols_real) {
  if (!is.numeric(d[[col]])) stop(col, " nao eh numerico")
}

dir.create(par$caminhos$intermediario, showWarnings = FALSE, recursive = TRUE)
saveRDS(d, file.path(par$caminhos$intermediario, "01_importado.rds"))

cat("== 01_importar ==\n")
cat("Linhas:", nrow(d), "\n")
cat("Colunas:", ncol(d), "\n")
cat("Parcelas por ambiente:\n")
print(table(d$ambiente_id))
