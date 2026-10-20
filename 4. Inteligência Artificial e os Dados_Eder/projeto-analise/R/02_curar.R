bruto <- read.csv("data/bruto/bruto_parcelas.csv",
                  colClasses = c(PROD = "character"),
                  stringsAsFactors = FALSE)

hoje <- format(Sys.Date(), "%Y-%m-%d")
registro <- data.frame(
  data = character(), tabela = character(), chave = character(),
  campo = character(), valor_antigo = character(), valor_novo = character(),
  motivo = character(), stringsAsFactors = FALSE
)

add_reg <- function(chave, campo, antigo, novo, motivo) {
  registro <<- rbind(registro, data.frame(
    data = hoje, tabela = "parcelas", chave = chave, campo = campo,
    valor_antigo = as.character(antigo), valor_novo = as.character(novo),
    motivo = motivo, stringsAsFactors = FALSE
  ))
}

d <- bruto

# 1) Normalizar ID: trim, maiúsculas, hífen -> _
id_novo <- toupper(trimws(gsub("-", "_", d$germoplasma_nome)))
idx <- which(id_novo != d$germoplasma_nome)
for (i in idx)
  add_reg(d$parcela_id[i], "germoplasma_nome", d$germoplasma_nome[i],
          id_novo[i], "normalizacao_identificador")
d$germoplasma_nome <- id_novo

# 2) Duplicata de posição: manter uma linha se PROD concordar
chave_pos <- paste(d$ensaio_id, d$linha, d$coluna, sep = "|")
dup_idx <- which(duplicated(chave_pos) | duplicated(chave_pos, fromLast = TRUE))
if (length(dup_idx)) {
  grupos <- split(dup_idx, chave_pos[dup_idx])
  drop <- integer()
  for (g in grupos) {
    if (length(unique(d$PROD[g])) == 1L) {
      # mantém a primeira; remove as demais
      for (i in g[-1]) {
        add_reg(d$parcela_id[i], "parcela_id", d$parcela_id[i], "",
                "duplicata_posicao_concordante")
        drop <- c(drop, i)
      }
    }
  }
  if (length(drop)) d <- d[-drop, , drop = FALSE]
}

# 3) Ausentes: vazio, "0", "-" -> NA
prod_txt <- d$PROD
idx_na <- which(prod_txt == "" | prod_txt == "0" | prod_txt == "-")
for (i in idx_na)
  add_reg(d$parcela_id[i], "PROD", prod_txt[i], "NA", "codigo_ausente")
prod_num <- suppressWarnings(as.numeric(prod_txt))
prod_num[idx_na] <- NA_real_

# 4) Intervalo do dicionário [2000, 20000]
for (i in which(!is.na(prod_num))) {
  v <- prod_num[i]
  if (v >= 2000 && v <= 20000) next
  if (v > 20000 && (v / 10) >= 2000 && (v / 10) <= 20000) {
    novo <- v / 10
    add_reg(d$parcela_id[i], "PROD", v, novo, "digito_a_mais_dividir_por_10")
    prod_num[i] <- novo
  } else if (v < 2000 && (v * 1000) >= 2000 && (v * 1000) <= 20000) {
    novo <- v * 1000
    add_reg(d$parcela_id[i], "PROD", v, novo, "unidade_t_ha_para_kg_ha")
    prod_num[i] <- novo
  } else {
    add_reg(d$parcela_id[i], "PROD", v, "NA", "fora_intervalo_sem_correcao")
    prod_num[i] <- NA_real_
  }
}
d$PROD <- prod_num

# 5) Outliers |z| > 3 dentro do ambiente (só não ausentes)
outliers <- data.frame(
  parcela_id = character(), ambiente_id = character(),
  PROD = numeric(), z = numeric(), stringsAsFactors = FALSE
)
for (amb in unique(d$ambiente_id)) {
  idx <- which(d$ambiente_id == amb & !is.na(d$PROD))
  if (length(idx) < 2L) next
  m <- mean(d$PROD[idx])
  s <- sd(d$PROD[idx])
  if (is.na(s) || s == 0) next
  z <- (d$PROD[idx] - m) / s
  keep <- which(abs(z) > 3)
  if (length(keep))
    outliers <- rbind(outliers, data.frame(
      parcela_id = d$parcela_id[idx[keep]],
      ambiente_id = amb,
      PROD = d$PROD[idx[keep]],
      z = z[keep],
      stringsAsFactors = FALSE
    ))
}

dir.create("data/processado", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tabelas", recursive = TRUE, showWarnings = FALSE)
dir.create("docs", recursive = TRUE, showWarnings = FALSE)

write.csv(registro, "docs/registro_de_correcoes.csv", row.names = FALSE)
write.csv(d, "data/processado/parcelas_curadas.csv", row.names = FALSE)
write.csv(outliers, "output/tabelas/outliers_sinalizados.csv", row.names = FALSE)

cat("Linhas curadas:", nrow(d), "\n")
cat("NA em PROD:", sum(is.na(d$PROD)), "\n")
cat("Outliers sinalizados:", nrow(outliers), "\n")
cat("Registro de correcoes:", nrow(registro), "linhas\n")
