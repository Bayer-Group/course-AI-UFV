bruto <- read.csv("data/bruto/bruto_parcelas.csv",
                  colClasses = c(PROD = "character"),
                  stringsAsFactors = FALSE)

prod <- bruto$PROD
tipos <- c("ausente_codigo", "fora_intervalo", "id_fora_padrao", "duplicata_posicao")
casos <- data.frame(tipo = character(), parcela_id = character(),
                    detalhe = character(), stringsAsFactors = FALSE)

# ausente_codigo: vazio, "0", "-"
idx <- which(prod == "" | prod == "0" | prod == "-")
if (length(idx))
  casos <- rbind(casos, data.frame(
    tipo = "ausente_codigo",
    parcela_id = bruto$parcela_id[idx],
    detalhe = paste0("PROD='", prod[idx], "'"),
    stringsAsFactors = FALSE
  ))

# fora_intervalo: numérico < 2000 ou > 20000 (não vazio, 0, "-")
prod_num <- suppressWarnings(as.numeric(prod))
idx <- which(!is.na(prod_num) & !(prod %in% c("", "0", "-")) &
               (prod_num < 2000 | prod_num > 20000))
if (length(idx))
  casos <- rbind(casos, data.frame(
    tipo = "fora_intervalo",
    parcela_id = bruto$parcela_id[idx],
    detalhe = paste0("PROD=", prod[idx]),
    stringsAsFactors = FALSE
  ))

# id_fora_padrao: germoplasma_nome bruto não casa com o padrão
idx <- which(!grepl("^DH[0-9]{2}_[0-9]{4}$", bruto$germoplasma_nome))
if (length(idx))
  casos <- rbind(casos, data.frame(
    tipo = "id_fora_padrao",
    parcela_id = bruto$parcela_id[idx],
    detalhe = paste0("germoplasma_nome='", bruto$germoplasma_nome[idx], "'"),
    stringsAsFactors = FALSE
  ))

# duplicata_posicao: mesma (ensaio_id, linha, coluna) em mais de uma linha
chave <- paste(bruto$ensaio_id, bruto$linha, bruto$coluna, sep = "|")
idx <- which(duplicated(chave) | duplicated(chave, fromLast = TRUE))
if (length(idx))
  casos <- rbind(casos, data.frame(
    tipo = "duplicata_posicao",
    parcela_id = bruto$parcela_id[idx],
    detalhe = paste0("chave=", chave[idx]),
    stringsAsFactors = FALSE
  ))

cat("Linhas no bruto:", nrow(bruto), "\n")
cat("Contagem por tipo:\n")
contagem <- setNames(integer(length(tipos)), tipos)
tab <- table(factor(casos$tipo, levels = tipos))
contagem[names(tab)] <- as.integer(tab)
print(contagem)

dir.create("output/tabelas", recursive = TRUE, showWarnings = FALSE)
write.csv(casos, "output/tabelas/diagnostico_casos.csv", row.names = FALSE)
cat("Gravado: output/tabelas/diagnostico_casos.csv\n")
