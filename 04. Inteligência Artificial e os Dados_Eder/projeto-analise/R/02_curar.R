bruto <- read.csv("data/bruto/bruto_parcelas.csv",
                   colClasses = "character")
bruto_md5 <- tools::md5sum("data/bruto/bruto_parcelas.csv")
hoje <- format(Sys.Date(), "%Y-%m-%d")

reg <- data.frame(
  data = character(), tabela = character(),
  chave = character(), campo = character(),
  valor_antigo = character(), valor_novo = character(),
  motivo = character(), stringsAsFactors = FALSE
)
novo_reg <- function(ch, campo, antigo, novo, motivo)
  data.frame(data = hoje, tabela = "bruto_parcelas",
    chave = ch, campo = campo,
    valor_antigo = antigo, valor_novo = novo,
    motivo = motivo, stringsAsFactors = FALSE)

d <- bruto

# --- 1. Normalizar germoplasma_nome ---
orig <- d$germoplasma_nome
norm <- gsub("-", "_", toupper(trimws(orig)))
m <- orig != norm
if (any(m))
  reg <- rbind(reg, novo_reg(
    d$parcela_id[m], "germoplasma_nome",
    orig[m], norm[m], "normalizacao_id"))
d$germoplasma_nome <- norm

# --- 2. Duplicata de posicao (valor concorda -> manter uma) ---
chave_pos <- paste(d$ensaio_id, d$linha, d$coluna, sep = "|")
remover <- logical(nrow(d))
for (i in which(duplicated(chave_pos))) {
  j <- which(chave_pos == chave_pos[i])[1]
  if (d$PROD[i] == d$PROD[j]) {
    reg <- rbind(reg, novo_reg(
      d$parcela_id[i], "linha_duplicada",
      "presente", "removida",
      "duplicata_posicao: valor concorda"))
    remover[i] <- TRUE
  }
}
d <- d[!remover, ]

# --- 3. Codigos de ausente -> NA ---
aus <- d$PROD %in% c("", "0", "-")
if (any(aus))
  reg <- rbind(reg, novo_reg(
    d$parcela_id[aus], "PROD",
    d$PROD[aus], "NA", "codigo_ausente"))

prod <- suppressWarnings(as.numeric(d$PROD))
prod[aus] <- NA

# --- 4. Intervalo [2000, 20000] ---
ok <- !aus & !is.na(prod)
acima <- ok & prod > 20000
abaixo <- ok & prod < 2000

corr10 <- acima & prod / 10 >= 2000 & prod / 10 <= 20000
if (any(corr10)) {
  reg <- rbind(reg, novo_reg(
    d$parcela_id[corr10], "PROD",
    d$PROD[corr10], as.character(prod[corr10] / 10),
    "digito_a_mais"))
  prod[corr10] <- prod[corr10] / 10
}
na_acima <- acima & !corr10
if (any(na_acima)) {
  reg <- rbind(reg, novo_reg(
    d$parcela_id[na_acima], "PROD",
    d$PROD[na_acima], "NA", "fora_intervalo"))
  prod[na_acima] <- NA
}

corr1k <- abaixo & prod * 1000 >= 2000 & prod * 1000 <= 20000
if (any(corr1k)) {
  reg <- rbind(reg, novo_reg(
    d$parcela_id[corr1k], "PROD",
    d$PROD[corr1k], as.character(prod[corr1k] * 1000),
    "unidade_t_ha"))
  prod[corr1k] <- prod[corr1k] * 1000
}
na_abaixo <- abaixo & !corr1k
if (any(na_abaixo)) {
  reg <- rbind(reg, novo_reg(
    d$parcela_id[na_abaixo], "PROD",
    d$PROD[na_abaixo], "NA", "fora_intervalo"))
  prod[na_abaixo] <- NA
}

d$PROD <- prod

# --- 5. Outliers |z| > 3 por ambiente ---
outliers <- data.frame(
  parcela_id = character(), ambiente_id = character(),
  PROD = numeric(), z = numeric(), stringsAsFactors = FALSE
)
for (amb in unique(d$ambiente_id)) {
  idx <- d$ambiente_id == amb & !is.na(d$PROD)
  v <- d$PROD[idx]
  zs <- (v - mean(v)) / sd(v)
  flag <- abs(zs) > 3
  if (any(flag))
    outliers <- rbind(outliers, data.frame(
      parcela_id = d$parcela_id[idx][flag],
      ambiente_id = amb,
      PROD = v[flag], z = round(zs[flag], 4),
      stringsAsFactors = FALSE))
}

# --- Gravar ---
dir.create("data/processado", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tabelas", recursive = TRUE, showWarnings = FALSE)
write.csv(reg, "docs/registro_de_correcoes.csv", row.names = FALSE)
write.csv(d, "data/processado/parcelas_curadas.csv", row.names = FALSE)
write.csv(outliers, "output/tabelas/outliers_sinalizados.csv",
          row.names = FALSE)

cat("Linhas curadas:", nrow(d), "\n")
cat("NA em PROD:", sum(is.na(d$PROD)), "\n")
cat("Outliers sinalizados:", nrow(outliers), "\n")
cat("bruto inalterado:",
    identical(unname(tools::md5sum("data/bruto/bruto_parcelas.csv")),
              unname(bruto_md5)), "\n")
