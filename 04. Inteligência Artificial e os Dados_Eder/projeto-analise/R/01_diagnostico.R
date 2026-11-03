bruto <- read.csv("data/bruto/bruto_parcelas.csv", colClasses = "character")

casos <- data.frame(tipo = character(), parcela_id = character(),
                    detalhe = character(), stringsAsFactors = FALSE)

# ausente_codigo: PROD vazio, "0" ou "-"
ausente <- bruto$PROD %in% c("", "0", "-")
if (any(ausente))
  casos <- rbind(casos, data.frame(
    tipo = "ausente_codigo",
    parcela_id = bruto$parcela_id[ausente],
    detalhe = sprintf("PROD='%s'", bruto$PROD[ausente]),
    stringsAsFactors = FALSE))

# fora_intervalo: numerico < 2000 ou > 20000 (exclui ausentes acima)
prod_num <- suppressWarnings(as.numeric(bruto$PROD))
valido <- !ausente & !is.na(prod_num)
fora <- valido & (prod_num < 2000 | prod_num > 20000)
if (any(fora))
  casos <- rbind(casos, data.frame(
    tipo = "fora_intervalo",
    parcela_id = bruto$parcela_id[fora],
    detalhe = sprintf("PROD=%s", bruto$PROD[fora]),
    stringsAsFactors = FALSE))

# id_fora_padrao
nome_trim <- trimws(bruto$germoplasma_nome)
fora_id <- !grepl("^DH[0-9]{2}_[0-9]{4}$", nome_trim)
if (any(fora_id))
  casos <- rbind(casos, data.frame(
    tipo = "id_fora_padrao",
    parcela_id = bruto$parcela_id[fora_id],
    detalhe = sprintf("germoplasma_nome='%s'", bruto$germoplasma_nome[fora_id]),
    stringsAsFactors = FALSE))

# duplicata_posicao
chave <- paste(bruto$ensaio_id, bruto$linha, bruto$coluna, sep = "|")
dup <- duplicated(chave) | duplicated(chave, fromLast = TRUE)
if (any(dup))
  casos <- rbind(casos, data.frame(
    tipo = "duplicata_posicao",
    parcela_id = bruto$parcela_id[dup],
    detalhe = sprintf("ensaio_id=%s linha=%s coluna=%s",
                      bruto$ensaio_id[dup], bruto$linha[dup], bruto$coluna[dup]),
    stringsAsFactors = FALSE))

dir.create("output/tabelas", recursive = TRUE, showWarnings = FALSE)
write.csv(casos, "output/tabelas/diagnostico_casos.csv", row.names = FALSE)

cat("Linhas no bruto:", nrow(bruto), "\n")
cat(sprintf("  %-20s %d\n", names(table(casos$tipo)), as.integer(table(casos$tipo))),
    sep = "")
