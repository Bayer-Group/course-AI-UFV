# tests/03_test_curar.R

par <- yaml::read_yaml("config/parametros.yaml")

# --- Teste 1: dados reais curados ---
d <- readRDS(file.path(par$caminhos$processado, "03_curado.rds"))

stopifnot(nrow(d) == 2424)
stopifnot(all(table(d$ambiente_id) == 808))
stopifnot(length(unique(d$germoplasma_nome)) == 404)
stopifnot(all(grepl(par$ids$regex, d$germoplasma_nome)))
stopifnot(sum(is.na(d$PROD)) == 7)
prod_ok <- d$PROD[!is.na(d$PROD)]
stopifnot(all(prod_ok >= par$qc$prod_min & prod_ok <= par$qc$prod_max))

chave <- par$qc$chave_duplicata
dup_key <- do.call(paste, c(d[chave], sep = "|"))
stopifnot(!any(duplicated(dup_key)))

reg <- read.csv(par$caminhos$registro_correcoes, stringsAsFactors = FALSE)
stopifnot(nrow(reg) == 14)
stopifnot(sum(reg$tipo == "id_normalizado") == 5)
stopifnot(sum(reg$tipo == "duplicata_removida") == 2)
stopifnot(sum(reg$tipo == "prod_fora_intervalo") == 7)

# --- Teste 2: erros injetados ---
normalizar_id <- function(x) {
  x <- trimws(x)
  x <- toupper(x)
  gsub("[[:space:]-]+", "_", x)
}

fake <- data.frame(
  parcela_id       = paste0("P_T_", 1:6),
  ensaio_id        = rep("ENS_T", 6),
  ambiente_id      = rep("T_2025_V", 6),
  germoplasma_nome = c("DH25_0001", "dh25_0002", "DH25 0003",
                        "DH25_0004", "DH25_0005", "DH25_0006"),
  bloco  = c(1L, 1L, 1L, 1L, 1L, 1L),
  linha  = c(1L, 2L, 3L, 4L, 5L, 5L),
  coluna = c(1L, 1L, 1L, 1L, 1L, 1L),
  PROD   = c(8000, 9000, 10000, 500, 11000, 12000),
  data_coleta = rep("2026-03-15", 6),
  stringsAsFactors = FALSE
)

geno_novo <- normalizar_id(fake$germoplasma_nome)
mudou <- geno_novo != fake$germoplasma_nome
stopifnot(sum(mudou) == 2)
fake$germoplasma_nome <- geno_novo

dup_key2 <- do.call(paste, c(fake[chave], sep = "|"))
is_dup <- duplicated(dup_key2)
stopifnot(sum(is_dup) == 1)
fake <- fake[!is_dup, ]

fora <- !is.na(fake$PROD) & (fake$PROD < par$qc$prod_min | fake$PROD > par$qc$prod_max)
stopifnot(sum(fora) == 1)
fake$PROD[fora] <- NA

stopifnot(nrow(fake) == 5)
stopifnot(sum(is.na(fake$PROD)) == 1)
stopifnot(all(grepl(par$ids$regex, fake$germoplasma_nome)))

cat("03_test_curar: PASSED\n")
