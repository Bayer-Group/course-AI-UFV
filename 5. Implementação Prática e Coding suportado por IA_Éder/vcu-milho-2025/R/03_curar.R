# Entradas:   config/parametros.yaml, data/intermediario/01_importado.rds,
#             docs/registro_de_correcoes.csv
# Saídas:     data/processado/03_curado.rds,
#             docs/registro_de_correcoes.csv (acrescenta linhas)
# Premissas:  01_importado.rds existe; tipos já coercidos (PROD numeric,
#             linha/coluna integer)

library(yaml)

cfg <- yaml::read_yaml("config/parametros.yaml")

d <- readRDS(file.path(cfg$caminhos$intermediario, "01_importado.rds"))

# acumula linhas novas para o registro
novas_correcoes <- list()

# ── 1. Normalizar germoplasma_nome ────────────────────────────────────────────
nome_norm <- toupper(trimws(d$germoplasma_nome))
flag_norm <- nome_norm != d$germoplasma_nome & !is.na(d$germoplasma_nome)

if (any(flag_norm)) {
  novas_correcoes[["norm"]] <- data.frame(
    parcela_id     = d$parcela_id[flag_norm],
    variavel       = "germoplasma_nome",
    valor_original = d$germoplasma_nome[flag_norm],
    valor_corrigido= nome_norm[flag_norm],
    tipo           = "normalizacao_id",
    regra          = "toupper+trimws",
    data           = format(Sys.Date(), "%Y-%m-%d"),
    responsavel    = "03_curar.R",
    stringsAsFactors = FALSE
  )
}
d$germoplasma_nome <- nome_norm

# ── 1b. Registrar IDs com erro estrutural que toupper+trimws não resolve ──────
flag_invalido <- !grepl(cfg$ids$regex, d$germoplasma_nome) & !is.na(d$germoplasma_nome)
if (any(flag_invalido)) {
  novas_correcoes[["id_invalido"]] <- data.frame(
    parcela_id     = d$parcela_id[flag_invalido],
    variavel       = "germoplasma_nome",
    valor_original = d$germoplasma_nome[flag_invalido],
    valor_corrigido= NA_character_,
    tipo           = "id_fora_padrao_pendente",
    regra          = cfg$ids$regex,
    data           = format(Sys.Date(), "%Y-%m-%d"),
    responsavel    = "03_curar.R",
    stringsAsFactors = FALSE
  )
}

# ── 2. Remover duplicatas de posição ─────────────────────────────────────────
chave_cols <- cfg$qc$chave_duplicata          # [ensaio_id, linha, coluna]
d <- d[order(d$parcela_id), ]                 # ordena lexicograficamente
chave <- do.call(paste, c(d[chave_cols], sep = ":"))
flag_dup <- duplicated(chave)

if (any(flag_dup)) {
  novas_correcoes[["dup"]] <- data.frame(
    parcela_id     = d$parcela_id[flag_dup],
    variavel       = paste(chave_cols, collapse = ":"),
    valor_original = d$parcela_id[flag_dup],
    valor_corrigido= NA_character_,
    tipo           = "duplicata_posicao",
    regra          = "chave unica por (ensaio_id, linha, coluna)",
    data           = format(Sys.Date(), "%Y-%m-%d"),
    responsavel    = "03_curar.R",
    stringsAsFactors = FALSE
  )
}
d <- d[!flag_dup, ]

# ── 3. PROD fora do intervalo → NA ───────────────────────────────────────────
flag_prod <- !is.na(d$PROD) &
             (d$PROD < cfg$qc$prod_min | d$PROD > cfg$qc$prod_max)

if (any(flag_prod)) {
  novas_correcoes[["prod"]] <- data.frame(
    parcela_id     = d$parcela_id[flag_prod],
    variavel       = "PROD",
    valor_original = as.character(d$PROD[flag_prod]),
    valor_corrigido= NA_character_,
    tipo           = "prod_fora_intervalo",
    regra          = paste0("PROD em [", cfg$qc$prod_min, ", ", cfg$qc$prod_max, "]"),
    data           = format(Sys.Date(), "%Y-%m-%d"),
    responsavel    = "03_curar.R",
    stringsAsFactors = FALSE
  )
  d$PROD[flag_prod] <- NA
}

# ── Gravar registro_de_correcoes.csv (ler + rbind + write) ───────────────────
reg_path <- cfg$caminhos$registro_correcoes
reg_existente <- read.csv(reg_path, stringsAsFactors = FALSE)

if (length(novas_correcoes) > 0) {
  novas <- do.call(rbind, novas_correcoes)
  reg_final <- unique(rbind(reg_existente, novas))
} else {
  reg_final <- reg_existente
}
write.csv(reg_final, reg_path, row.names = FALSE)

# ── Gravar curado ─────────────────────────────────────────────────────────────
dir.create(cfg$caminhos$processado, showWarnings = FALSE, recursive = TRUE)
saveRDS(d, file.path(cfg$caminhos$processado, "03_curado.rds"))

# ── Sumário ───────────────────────────────────────────────────────────────────
prefixo_dh25 <- cfg$ids$prefixo_ranking      # "DH25_"
prefixo_dh24 <- cfg$ids$prefixo_testemunha   # "DH24_"

n_pendentes <- sum(!grepl(cfg$ids$regex, d$germoplasma_nome) & !is.na(d$germoplasma_nome))

cat("Total de parcelas:", nrow(d), "\n")
cat("PROD ausente (NA):", sum(is.na(d$PROD)), "\n")
cat("Genótipos DH25:", length(unique(d$germoplasma_nome[
  grepl(paste0("^", prefixo_dh25), d$germoplasma_nome)])), "\n")
cat("Genótipos DH24:", length(unique(d$germoplasma_nome[
  grepl(paste0("^", prefixo_dh24), d$germoplasma_nome)])), "\n")
cat("IDs fora do padrão (pendentes confirmação):", n_pendentes, "\n")
