# 03_curar.R
# Entradas: data/intermediario/01_importado.rds, config/parametros.yaml
# Saídas:   data/processado/03_curado.rds, docs/registro_de_correcoes.csv
# Premissa: normaliza IDs, remove duplicatas de posição, PROD fora → NA.

par <- yaml::read_yaml("config/parametros.yaml")
d <- readRDS(file.path(par$caminhos$intermediario, "01_importado.rds"))

reg <- data.frame(
  parcela_id = character(), campo = character(),
  valor_original = character(), valor_novo = character(),
  tipo = character(), regra = character(),
  stringsAsFactors = FALSE
)

normalizar_id <- function(x) {
  x <- trimws(x)
  x <- toupper(x)
  gsub("[[:space:]-]+", "_", x)
}

# 1. Normalizar IDs
geno_novo <- normalizar_id(d$germoplasma_nome)
mudou <- geno_novo != d$germoplasma_nome
if (any(mudou)) {
  reg <- rbind(reg, data.frame(
    parcela_id = d$parcela_id[mudou],
    campo = "germoplasma_nome",
    valor_original = d$germoplasma_nome[mudou],
    valor_novo = geno_novo[mudou],
    tipo = "id_normalizado",
    regra = "toupper+trimws+gsub",
    stringsAsFactors = FALSE
  ))
  d$germoplasma_nome <- geno_novo
}

# 2. Remover duplicatas de posição (mantém primeira ocorrência)
chave <- par$qc$chave_duplicata
dup_key <- do.call(paste, c(d[chave], sep = "|"))
is_dup <- duplicated(dup_key)
if (any(is_dup)) {
  reg <- rbind(reg, data.frame(
    parcela_id = d$parcela_id[is_dup],
    campo = paste(chave, collapse = ","),
    valor_original = dup_key[is_dup],
    valor_novo = NA_character_,
    tipo = "duplicata_removida",
    regra = "duplicated_primeira_ocorrencia",
    stringsAsFactors = FALSE
  ))
  d <- d[!is_dup, ]
}

# 3. PROD fora do intervalo → NA
fora <- !is.na(d$PROD) & (d$PROD < par$qc$prod_min | d$PROD > par$qc$prod_max)
if (any(fora)) {
  reg <- rbind(reg, data.frame(
    parcela_id = d$parcela_id[fora],
    campo = "PROD",
    valor_original = as.character(d$PROD[fora]),
    valor_novo = "NA",
    tipo = "prod_fora_intervalo",
    regra = paste0("[", par$qc$prod_min, ",", par$qc$prod_max, "]"),
    stringsAsFactors = FALSE
  ))
  d$PROD[fora] <- NA
}

dir.create(par$caminhos$processado, showWarnings = FALSE, recursive = TRUE)
saveRDS(d, file.path(par$caminhos$processado, "03_curado.rds"))
write.csv(reg, par$caminhos$registro_correcoes, row.names = FALSE)

cat("== 03_curar ==\n")
cat("Linhas finais:", nrow(d), "\n")
cat("Parcelas por ambiente:\n")
print(table(d$ambiente_id))
cat("Genotipos unicos:", length(unique(d$germoplasma_nome)), "\n")
cat("PROD NA:", sum(is.na(d$PROD)), "\n")
cat("Correcoes registradas:", nrow(reg), "\n")
cat("Por tipo:\n")
print(table(reg$tipo))
