# Entradas:   config/parametros.yaml, data/intermediario/01_importado.rds
# Saídas:     output/02_qc_relatorio.csv
# Premissas:  01_importado.rds existe; tipos já coercidos (PROD numeric, linha/coluna integer)

library(yaml)

cfg <- yaml::read_yaml("config/parametros.yaml")

# ---------- funções de detecção (exportadas para o teste) ----------

detectar_id_fora_padrao <- function(d, cfg) {
  # Checa o valor original: IDs que precisam de normalização também são flagados
  flag <- !grepl(cfg$ids$regex, d$germoplasma_nome) & !is.na(d$germoplasma_nome)
  if (!any(flag)) return(NULL)
  data.frame(
    tipo       = "id_fora_padrao",
    parcela_id = d$parcela_id[flag],
    variavel   = "germoplasma_nome",
    valor      = d$germoplasma_nome[flag],
    regra      = cfg$ids$regex,
    stringsAsFactors = FALSE
  )
}

detectar_duplicata_posicao <- function(d, cfg) {
  chave_cols <- cfg$qc$chave_duplicata          # [ensaio_id, linha, coluna]
  chave      <- do.call(paste, c(d[chave_cols], sep = ":"))
  flag       <- duplicated(chave)
  if (!any(flag)) return(NULL)
  data.frame(
    tipo       = "duplicata_posicao",
    parcela_id = d$parcela_id[flag],
    variavel   = paste(chave_cols, collapse = ":"),
    valor      = chave[flag],
    regra      = "chave unica por (ensaio_id, linha, coluna)",
    stringsAsFactors = FALSE
  )
}

detectar_prod_fora_intervalo <- function(d, cfg) {
  flag <- !is.na(d$PROD) & (d$PROD < cfg$qc$prod_min | d$PROD > cfg$qc$prod_max)
  if (!any(flag)) return(NULL)
  data.frame(
    tipo       = "prod_fora_intervalo",
    parcela_id = d$parcela_id[flag],
    variavel   = "PROD",
    valor      = as.character(d$PROD[flag]),
    regra      = paste0("PROD em [", cfg$qc$prod_min, ", ", cfg$qc$prod_max, "]"),
    stringsAsFactors = FALSE
  )
}

detectar_prod_ausente <- function(d, cfg) {
  flag <- is.na(d$PROD)
  if (!any(flag)) return(NULL)
  data.frame(
    tipo       = "prod_ausente",
    parcela_id = d$parcela_id[flag],
    variavel   = "PROD",
    valor      = NA_character_,
    regra      = "PROD nao pode ser NA",
    stringsAsFactors = FALSE
  )
}

# ---------- execução principal (só roda quando chamado diretamente) ----------

if (!exists("QC_SOURCE_ONLY") || !QC_SOURCE_ONLY) {
  d <- readRDS(file.path(cfg$caminhos$intermediario, "01_importado.rds"))

  partes <- list(
    detectar_id_fora_padrao(d, cfg),
    detectar_duplicata_posicao(d, cfg),
    detectar_prod_fora_intervalo(d, cfg),
    detectar_prod_ausente(d, cfg)
  )
  partes <- Filter(Negate(is.null), partes)

  if (length(partes) == 0) {
    relatorio <- data.frame(
      tipo = character(), parcela_id = character(), variavel = character(),
      valor = character(), regra = character(), stringsAsFactors = FALSE
    )
    cat("Nenhum problema encontrado.\n")
  } else {
    relatorio <- do.call(rbind, partes)
    cat("Problemas encontrados por tipo:\n")
    print(table(relatorio$tipo))
  }

  dir.create(cfg$caminhos$output, showWarnings = FALSE, recursive = TRUE)
  write.csv(relatorio,
            file.path(cfg$caminhos$output, "02_qc_relatorio.csv"),
            row.names = FALSE)
  cat("Salvo em", file.path(cfg$caminhos$output, "02_qc_relatorio.csv"), "\n")
}
