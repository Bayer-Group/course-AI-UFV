# tests/02_test_qc.R
# Testa as regras de QC com dados injetados E confere o relatório real.

par <- yaml::read_yaml("config/parametros.yaml")

normalizar_id <- function(x) {
  x <- trimws(x)
  x <- toupper(x)
  gsub("[[:space:]-]+", "_", x)
}

# --- Teste 1: erros injetados ---
fake <- data.frame(
  parcela_id   = paste0("P_FAKE_", 1:8),
  ensaio_id    = rep("ENS_FAKE", 8),
  ambiente_id  = rep("FAKE_2025_V", 8),
  germoplasma_nome = c("DH25_0001", "dh25_0002", "DH25 0003",
                        "DH25_0004", "DH25_0005", "DH25_0006",
                        "DH25_0007", "DH25_0008"),
  bloco  = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
  linha  = c(1L, 2L, 3L, 4L, 5L, 5L, 6L, 7L),
  coluna = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
  PROD   = c(8000, 9000, 10000, 500, 99999, 11000, 7000, 12000),
  data_coleta = rep("2026-03-15", 8),
  stringsAsFactors = FALSE
)
# Erros esperados:
#   id_regex: "dh25_0002" (minúscula), "DH25 0003" (espaço) = 2
#   duplicata: linhas 5+6 mesma posição (ensaio,5,1) = 1
#   prod_fora: 500 (abaixo), 99999 (acima) = 2

regex_id <- par$ids$regex
n_id <- sum(!grepl(regex_id, fake$germoplasma_nome))
stopifnot(n_id == 2)

fake$geno_norm <- normalizar_id(fake$germoplasma_nome)
chave <- par$qc$chave_duplicata
dup_key <- do.call(paste, c(fake[chave], sep = "|"))
n_dup <- sum(duplicated(dup_key))
stopifnot(n_dup == 1)

n_fora <- sum(!is.na(fake$PROD) &
              (fake$PROD < par$qc$prod_min | fake$PROD > par$qc$prod_max))
stopifnot(n_fora == 2)

# Sem falsos positivos nos limpos
limpo <- fake[c(1, 7, 8), ]
stopifnot(all(grepl(regex_id, limpo$germoplasma_nome)))
stopifnot(all(limpo$PROD >= par$qc$prod_min & limpo$PROD <= par$qc$prod_max))

# --- Teste 2: relatório real ---
rel <- read.csv(file.path(par$caminhos$output, "02_qc_relatorio.csv"),
                stringsAsFactors = FALSE)
stopifnot(sum(rel$tipo == "id_regex")  == 5)
stopifnot(sum(rel$tipo == "duplicata") == 2)
stopifnot(sum(rel$tipo == "prod_fora") == 7)
stopifnot(nrow(rel) == 14)

cat("02_test_qc: PASSED\n")
