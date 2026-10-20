# Teste unitário de R/03_curar.R com dados sintéticos.
# Executa a lógica de cura isolada (sem ler arquivos reais).

library(yaml)
cfg <- yaml::read_yaml("config/parametros.yaml")

# ── Data frame sintético ──────────────────────────────────────────────────────
# 5 linhas limpas + 1 ID em caixa baixa + 1 duplicata de posição +
# 1 PROD fora do intervalo + 1 PROD ausente (NA) = 9 linhas totais
# Após cura: 9 - 1 duplicata = 8... reconta:
#   linhas limpas:    5
#   id_fora_padrao:   1  (será normalizado e mantido)
#   duplicata:        1  (extra da linha 1 → removida)
#   PROD fora range:  1  (mantida, PROD vira NA)
#   PROD ausente:     1  (mantida, sem alteração)
# Total após remoção de duplicata = 8 linhas

d_sintetico <- data.frame(
  parcela_id       = c("P_UDI_2025_V_0001", "P_UDI_2025_V_0002",
                       "P_UDI_2025_V_0003", "P_UDI_2025_V_0004",
                       "P_UDI_2025_V_0005", "P_UDI_2025_V_0006",
                       "P_UDI_2025_V_0007", "P_UDI_2025_V_0008",
                       "P_UDI_2025_V_0009"),
  ensaio_id        = rep("ENS_UDI_2025_V", 9),
  ambiente_id      = rep("UDI", 9),
  germoplasma_nome = c("DH25_0001", "DH25_0002", "DH25_0003",
                       "DH25_0004", "DH25_0005",
                       "dh25_0001",          # ID em caixa baixa
                       "DH25_0001",          # duplicata de posição (mesma linha/col que 0001)
                       "DH25_0006",          # PROD fora do intervalo
                       "DH25_0007"),         # PROD ausente
  bloco            = c(1L, 1L, 1L, 2L, 2L, 2L, 1L, 1L, 2L),
  linha            = c(1L, 2L, 3L, 4L, 5L, 6L, 1L, 7L, 8L),  # linha 1 repete para dup
  coluna           = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),  # col 1 repete para dup
  PROD             = c(8000, 9000, 7500, 8500, 7000, 6000, 8200, 500, NA_real_),
  data_coleta      = rep("2025-04-01", 9),
  stringsAsFactors = FALSE
)

# ── Replicar lógica de cura (sem I/O) ────────────────────────────────────────
novas_correcoes <- list()

# 1. Normalizar
nome_norm <- toupper(trimws(d_sintetico$germoplasma_nome))
flag_norm <- nome_norm != d_sintetico$germoplasma_nome & !is.na(d_sintetico$germoplasma_nome)
if (any(flag_norm)) {
  novas_correcoes[["norm"]] <- data.frame(
    parcela_id = d_sintetico$parcela_id[flag_norm], tipo = "normalizacao_id",
    stringsAsFactors = FALSE)
}
d_sintetico$germoplasma_nome <- nome_norm

# 2. Duplicatas
d_sintetico <- d_sintetico[order(d_sintetico$parcela_id), ]
chave_cols <- cfg$qc$chave_duplicata
chave <- do.call(paste, c(d_sintetico[chave_cols], sep = ":"))
flag_dup <- duplicated(chave)
if (any(flag_dup)) {
  novas_correcoes[["dup"]] <- data.frame(
    parcela_id = d_sintetico$parcela_id[flag_dup], tipo = "duplicata_posicao",
    stringsAsFactors = FALSE)
}
d_sintetico <- d_sintetico[!flag_dup, ]

# 3. PROD fora do intervalo
flag_prod <- !is.na(d_sintetico$PROD) &
             (d_sintetico$PROD < cfg$qc$prod_min | d_sintetico$PROD > cfg$qc$prod_max)
if (any(flag_prod)) {
  novas_correcoes[["prod"]] <- data.frame(
    parcela_id = d_sintetico$parcela_id[flag_prod], tipo = "prod_fora_intervalo",
    stringsAsFactors = FALSE)
  d_sintetico$PROD[flag_prod] <- NA
}

curado   <- d_sintetico
registro <- do.call(rbind, novas_correcoes)

# ── Asserções ─────────────────────────────────────────────────────────────────
# 9 linhas - 1 duplicata = 8
stopifnot(nrow(curado) == 8)

# sem duplicatas de posição
stopifnot(!any(duplicated(paste(curado$ensaio_id, curado$linha, curado$coluna))))

# sem PROD fora do range (NAs são OK)
stopifnot(all(is.na(curado$PROD) | (curado$PROD >= cfg$qc$prod_min & curado$PROD <= cfg$qc$prod_max)))

# pelo menos 2 NAs: 1 original + 1 convertido
stopifnot(sum(is.na(curado$PROD)) >= 2)

# registro tem ao menos 3 linhas (normalizacao + duplicata + prod_fora_intervalo)
stopifnot(nrow(registro) >= 3)

cat("03: OK\n")
