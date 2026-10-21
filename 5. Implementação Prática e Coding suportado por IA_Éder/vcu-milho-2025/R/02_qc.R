# 02_qc.R
# Entradas: data/intermediario/01_importado.rds, config/parametros.yaml
# Saídas:   output/02_qc_relatorio.csv
# Premissa: só relata problemas, não corrige nada.

par <- yaml::read_yaml("config/parametros.yaml")
d <- readRDS(file.path(par$caminhos$intermediario, "01_importado.rds"))

normalizar_id <- function(x) {
  x <- trimws(x)
  x <- toupper(x)
  gsub("[[:space:]-]+", "_", x)
}

relatorio <- data.frame(
  tipo = character(), parcela_id = character(),
  campo = character(), valor = character(), regra = character(),
  stringsAsFactors = FALSE
)

regex_id <- par$ids$regex
ruim <- !grepl(regex_id, d$germoplasma_nome)
if (any(ruim)) {
  relatorio <- rbind(relatorio, data.frame(
    tipo = "id_regex", parcela_id = d$parcela_id[ruim],
    campo = "germoplasma_nome", valor = d$germoplasma_nome[ruim],
    regra = regex_id, stringsAsFactors = FALSE
  ))
}

d$geno_norm <- normalizar_id(d$germoplasma_nome)
chave <- par$qc$chave_duplicata
dup_key <- do.call(paste, c(d[chave], sep = "|"))
is_dup <- duplicated(dup_key)
if (any(is_dup)) {
  relatorio <- rbind(relatorio, data.frame(
    tipo = "duplicata", parcela_id = d$parcela_id[is_dup],
    campo = paste(chave, collapse = ","),
    valor = dup_key[is_dup],
    regra = "posicao_duplicada", stringsAsFactors = FALSE
  ))
}

fora <- !is.na(d$PROD) & (d$PROD < par$qc$prod_min | d$PROD > par$qc$prod_max)
if (any(fora)) {
  relatorio <- rbind(relatorio, data.frame(
    tipo = "prod_fora", parcela_id = d$parcela_id[fora],
    campo = "PROD", valor = as.character(d$PROD[fora]),
    regra = paste0("[", par$qc$prod_min, ",", par$qc$prod_max, "]"),
    stringsAsFactors = FALSE
  ))
}

dir.create(par$caminhos$output, showWarnings = FALSE, recursive = TRUE)
write.csv(relatorio, file.path(par$caminhos$output, "02_qc_relatorio.csv"), row.names = FALSE)

cat("== 02_qc ==\n")
cat("Problemas por tipo:\n")
print(table(relatorio$tipo))
cat("Total:", nrow(relatorio), "\n")
