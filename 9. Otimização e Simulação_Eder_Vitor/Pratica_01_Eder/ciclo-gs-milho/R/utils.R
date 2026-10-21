## Funções auxiliares compartilhadas por todos os scripts do projeto.

## Pastas geradas (ignoradas pelo Git): criadas aqui para que um clone novo funcione.
for (pasta in c("data/genotipos", "data/gabarito", "reports", "db"))
  dir.create(pasta, showWarnings = FALSE, recursive = TRUE)
rm(pasta)

ler_parametros <- function(arquivo = "config/parametros.yaml") {
  yaml::read_yaml(arquivo, fileEncoding = "UTF-8")
}

## Tabela de ambientes a partir do YAML
tabela_ambientes <- function(par) {
  do.call(rbind, lapply(par$ambientes, as.data.frame))
}

## Conexão com o banco. Usa DuckDB quando disponível; caso contrário, SQLite
## (mesmo SQL, arquivo com extensão .sqlite). Ver docs de instalação.
conectar <- function(par = ler_parametros()) {
  arq <- par$banco$arquivo
  if (requireNamespace("duckdb", quietly = TRUE)) {
    suppressMessages(DBI::dbConnect(duckdb::duckdb(), dbdir = arq))
  } else {
    con <- DBI::dbConnect(RSQLite::SQLite(), sub("\\.duckdb$", ".sqlite", arq))
    DBI::dbExecute(con, "PRAGMA foreign_keys = ON")
    con
  }
}

desconectar <- function(con) {
  if (inherits(con, "duckdb_connection")) DBI::dbDisconnect(con, shutdown = TRUE)
  else DBI::dbDisconnect(con)
}

## Executa um arquivo .sql com vários comandos separados por ';'
executar_sql <- function(con, arquivo) {
  txt <- paste(readLines(arquivo, warn = FALSE), collapse = "\n")
  txt <- gsub("--[^\n]*", "", txt)
  cmds <- trimws(strsplit(txt, ";")[[1]])
  for (cmd in cmds[nchar(cmds) > 0]) DBI::dbExecute(con, cmd)
  invisible(TRUE)
}

## Remove tabelas e visões existentes para reconstruir o banco do zero
limpar_banco <- function(con) {
  for (v in c("v_prod_parcela")) {
    try(DBI::dbExecute(con, paste("DROP VIEW IF EXISTS", v)), silent = TRUE)
  }
  ordem <- c("observacao", "parcela", "amostra_genotipo", "pedigree", "germoplasma",
             "ensaio", "ambiente", "variavel", "bruto_parcelas", "bruto_germoplasma",
             "blup_linhagem", "componentes_variancia", "gebv", "efeitos_marcadores",
             "cruzamentos_planejados")
  for (t in ordem) DBI::dbExecute(con, paste("DROP TABLE IF EXISTS", t))
}

## Normalização de identificadores de germoplasma: maiúsculas, sem espaços
## nas bordas, hífen e espaço internos convertidos em sublinhado.
normalizar_id <- function(x) toupper(gsub("[- ]+", "_", trimws(x)))

## Família = par de genitores (ordem irrelevante)
familia_de <- function(mae, pai) ifelse(is.na(mae) | is.na(pai), NA,
                                        paste(pmin(mae, pai), pmax(mae, pai), sep = "x"))

## Matriz de parentesco genômico de VanRaden (2008), método 1.
## M: indivíduos × marcadores, codificação 0/1/2.
matriz_G <- function(M) {
  p <- colMeans(M) / 2
  Z <- sweep(M, 2, 2 * p)
  tcrossprod(Z) / (2 * sum(p * (1 - p)))
}

msg <- function(...) cat(format(Sys.time(), "[%H:%M:%S]"), ..., "\n")
