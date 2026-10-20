# Etapa 03: curadoria com registro
# Entradas: data/intermediario/01_importado.rds, config/parametros.yaml
# Saídas:   data/processado/03_curado.rds, docs/registro_de_correcoes.csv
# Premissas: IDs normalizados antes da checagem de duplicatas; duplicatas são
#            idênticas (mantém a primeira); PROD fora do intervalo vira NA

source("R/funcoes.R")
par <- yaml::read_yaml("config/parametros.yaml")
x <- readRDS(file.path(par$caminhos$intermediario, "01_importado.rds"))
hoje <- as.character(Sys.Date())

registro <- function(parcela_id, variavel, de, para, tipo, regra) {
  if (length(parcela_id) == 0) return(NULL)
  data.frame(parcela_id, variavel, valor_original = de, valor_corrigido = para,
             tipo, regra, data = hoje, responsavel = "R/03_curar.R")
}

novo_id <- normalizar_id(x$germoplasma_nome)
mudou <- novo_id != x$germoplasma_nome
r_id <- registro(x$parcela_id[mudou], "germoplasma_nome", x$germoplasma_nome[mudou],
                 novo_id[mudou], "id_normalizado", "maiusculas, sem espacos, separador _")
x$genotipo <- novo_id

dup <- duplicated(x[, unlist(par$qc$chave_duplicata)])
r_dup <- registro(x$parcela_id[dup], "linha_inteira", "duplicada", "removida",
                  "duplicata_posicao", "mantida a primeira ocorrencia")
x <- x[!dup, ]

fora <- !is.na(x$PROD) & (x$PROD < par$qc$prod_min | x$PROD > par$qc$prod_max)
r_fora <- registro(x$parcela_id[fora], "PROD", as.character(x$PROD[fora]), "NA",
                   "fora_do_intervalo", sprintf("%s-%s kg/ha", par$qc$prod_min, par$qc$prod_max))
x$PROD[fora] <- NA

stopifnot(all(grepl(par$ids$regex, x$genotipo)),
          !any(duplicated(x[, unlist(par$qc$chave_duplicata)])))

write.csv(rbind(r_id, r_dup, r_fora), par$caminhos$registro_correcoes, row.names = FALSE)
dir.create(par$caminhos$processado, showWarnings = FALSE, recursive = TRUE)
saveRDS(x, file.path(par$caminhos$processado, "03_curado.rds"))

cat("Parcelas:", nrow(x), "| PROD ausente:", sum(is.na(x$PROD)),
    "| Genotipos:", length(unique(x$genotipo)), "\n")
