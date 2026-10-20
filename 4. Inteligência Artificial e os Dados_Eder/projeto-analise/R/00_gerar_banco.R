# Gera o banco da aula prática (camada bruta, com erros conhecidos).
# Rodar na pasta projeto-analise, antes da aula:
#   "C:/Program Files/R/R-4.5.2/bin/Rscript.exe" R/00_gerar_banco.R
#
# O croqui limpo tem 20 linhagens DH, 2 blocos e 3 ambientes (120 parcelas).
# Em seguida o script injeta erros de digitação. A lista fica em
# data/gabarito/ e não deve ser aberta pelos alunos até o fechamento.

if (!file.exists("CLAUDE.md")) {
  stop("Rode este script na pasta projeto-analise (não encontrei CLAUDE.md).")
}

set.seed(2026)

dir.create("data/bruto", recursive = TRUE, showWarnings = FALSE)
dir.create("data/gabarito", recursive = TRUE, showWarnings = FALSE)
dir.create("db", showWarnings = FALSE)

locais <- data.frame(
  ambiente_id = c("UDI_2025_V", "SLG_2025_V", "PGO_2025_V"),
  local = c("Uberlandia", "Sete Lagoas", "Ponta Grossa"),
  sigla = c("UDI", "SLG", "PGO"),
  ano = 2025L,
  safra = "verao",
  latitude = c(-18.92, -19.47, -25.09),
  longitude = c(-48.28, -44.25, -50.16),
  media = c(12152, 9205, 10381),
  stringsAsFactors = FALSE
)

genotipos <- sprintf("DH25_%04d", seq_len(20))
efeito_g <- stats::setNames(rnorm(length(genotipos), 0, 400), genotipos)
sd_erro <- 0.065 * locais$media

croqui <- do.call(rbind, lapply(seq_len(nrow(locais)), function(i) {
  amb <- locais[i, ]
  efeito_b <- rnorm(2, 0, 120)
  blocos <- lapply(1:2, function(b) {
    ordem <- sample(genotipos)
    k <- seq_along(ordem)
    data.frame(
      ambiente_id = amb$ambiente_id,
      germoplasma_nome = ordem,
      bloco = b,
      linha = (b - 1L) * 4L + ceiling(k / 5),
      coluna = (k - 1L) %% 5L + 1L,
      PROD = amb$media + efeito_g[ordem] + efeito_b[b] +
        rnorm(length(ordem), 0, sd_erro[i]),
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, blocos)
  out$ensaio_id <- paste0("ENS_", amb$ambiente_id)
  out$parcela_id <- sprintf("P_%s_%04d", amb$sigla, seq_len(nrow(out)))
  out$data_coleta <- "2026-03-15"
  out
}))
croqui$PROD <- round(croqui$PROD, 1)
rownames(croqui) <- NULL

# Residuos naturais ficam abaixo de |z| = 2,5. Assim, no fechamento, os unicos
# |z| > 3 sao os dois outliers plantados de proposito.
for (amb in locais$ambiente_id) {
  idx <- which(croqui$ambiente_id == amb)
  repeat {
    z <- as.numeric(scale(croqui$PROD[idx]))
    if (max(abs(z)) < 2.5) break
    j <- idx[which.max(abs(z))]
    m <- mean(croqui$PROD[idx])
    croqui$PROD[j] <- round(m + 0.75 * (croqui$PROD[j] - m), 1)
  }
}

prod_limpo <- croqui$PROD
gab <- list()
anotar <- function(i, tipo, campo, novo, acao, limpo) {
  gab <<- c(gab, list(data.frame(
    tipo = tipo,
    parcela_id = croqui$parcela_id[i],
    ambiente_id = croqui$ambiente_id[i],
    campo = campo,
    valor_limpo = limpo,
    valor_injetado = novo,
    acao_esperada = acao,
    stringsAsFactors = FALSE
  )))
}

linha_de <- function(amb, geno, bloco) {
  i <- which(croqui$ambiente_id == amb &
               croqui$germoplasma_nome == geno &
               croqui$bloco == bloco)
  if (length(i) != 1L) stop("Parcela nao unica: ", amb, " ", geno, " bloco ", bloco)
  i
}

plantar_outlier <- function(amb, geno, bloco, sinal) {
  i <- linha_de(amb, geno, bloco)
  outros <- croqui$PROD[croqui$ambiente_id == amb & seq_len(nrow(croqui)) != i]
  novo <- round(mean(outros) + sinal * 5 * stats::sd(outros), 1)
  if (novo < 2500 || novo > 19000) {
    stop("Outlier plantado saiu do intervalo plausivel: ", novo)
  }
  croqui$PROD[i] <<- novo
  anotar(i, "outlier_plausivel", "PROD", novo,
         "sinalizar |z| > 3 e manter o valor", prod_limpo[i])
}

plantar_outlier("PGO_2025_V", "DH25_0001", 1L, 1)
plantar_outlier("UDI_2025_V", "DH25_0020", 2L, -1)

i <- linha_de("UDI_2025_V", "DH25_0010", 1L)
croqui$PROD[i] <- round(prod_limpo[i] * 10, 1)
anotar(i, "digito_extra", "PROD", croqui$PROD[i],
       "dividir por 10 e registrar; o resultado cai no intervalo", prod_limpo[i])

i <- linha_de("SLG_2025_V", "DH25_0014", 2L)
croqui$PROD[i] <- round(prod_limpo[i] / 1000, 3)
anotar(i, "unidade_t_ha", "PROD", croqui$PROD[i],
       "multiplicar por 1000 e registrar; o resultado cai no intervalo", prod_limpo[i])

prod_txt <- sprintf("%.1f", croqui$PROD)
prod_txt[linha_de("SLG_2025_V", "DH25_0014", 2L)] <-
  sprintf("%.3f", croqui$PROD[linha_de("SLG_2025_V", "DH25_0014", 2L)])

virar_ausente <- function(amb, geno, bloco, codigo, tipo, acao) {
  i <- linha_de(amb, geno, bloco)
  prod_txt[i] <<- codigo
  anotar(i, tipo, "PROD", if (codigo == "") "vazio" else codigo, acao, prod_limpo[i])
}
virar_ausente("UDI_2025_V", "DH25_0003", 1L, "", "ausente",
              "permanece NA; nao inventar valor")
virar_ausente("SLG_2025_V", "DH25_0011", 2L, "", "ausente",
              "permanece NA; nao inventar valor")
virar_ausente("PGO_2025_V", "DH25_0015", 1L, "", "ausente",
              "permanece NA; nao inventar valor")
virar_ausente("UDI_2025_V", "DH25_0005", 2L, "0", "ausente_codificado",
              "converter 0 para NA e registrar")
virar_ausente("SLG_2025_V", "DH25_0009", 1L, "0", "ausente_codificado",
              "converter 0 para NA e registrar")
virar_ausente("PGO_2025_V", "DH25_0013", 2L, "-", "ausente_codificado",
              "converter - para NA e registrar")

trocar_id <- function(amb, geno, bloco, novo) {
  i <- linha_de(amb, geno, bloco)
  limpo <- croqui$germoplasma_nome[i]
  croqui$germoplasma_nome[i] <<- novo
  anotar(i, "grafia_id", "germoplasma_nome", novo,
         "normalizar para o padrao DH25_NNNN", limpo)
}
trocar_id("SLG_2025_V", "DH25_0006", 1L, "dh25_0006")
trocar_id("PGO_2025_V", "DH25_0016", 2L, " DH25_0016")

croqui$PROD <- prod_txt
i <- linha_de("UDI_2025_V", "DH25_0008", 2L)
copia <- croqui[i, ]
copia$parcela_id <- paste0(croqui$parcela_id[i], "_DUP")
anotar(i, "duplicata", "linha_coluna", copia$parcela_id,
       "manter uma parcela nesta posicao e registrar a copia",
       paste(croqui$ensaio_id[i], croqui$linha[i], croqui$coluna[i], sep = "|"))

bruto <- rbind(croqui, copia)
bruto <- bruto[, c("parcela_id", "ensaio_id", "ambiente_id", "germoplasma_nome",
                   "bloco", "linha", "coluna", "PROD", "data_coleta")]

gab <- do.call(rbind, gab)
rownames(gab) <- NULL

stopifnot(nrow(bruto) == 121L)
stopifnot(sum(gab$tipo == "ausente") == 3L)
stopifnot(sum(gab$tipo == "ausente_codificado") == 3L)
stopifnot(any(grepl("^ ", bruto$germoplasma_nome)))
stopifnot(any(bruto$PROD == "-"), any(bruto$PROD == "0"), any(bruto$PROD == ""))

# Conferencia interna: a curadoria descrita no roteiro recupera o croqui
# e deixa exatamente os dois outliers com |z| > 3.
norm_id <- function(x) chartr("-", "_", toupper(trimws(x)))
cur <- bruto
cur$germoplasma_nome <- norm_id(cur$germoplasma_nome)
chave <- paste(cur$ensaio_id, cur$linha, cur$coluna, sep = "|")
cur <- cur[!duplicated(chave), ]
num <- suppressWarnings(as.numeric(cur$PROD))
codigo_ausente <- cur$PROD %in% c("", "0", "-")
num[codigo_ausente] <- NA_real_
alto <- !is.na(num) & num > 20000 & num / 10 >= 2000 & num / 10 <= 20000
baixo <- !is.na(num) & num < 2000 & num * 1000 >= 2000 & num * 1000 <= 20000
num[alto] <- num[alto] / 10
num[baixo] <- num[baixo] * 1000
num[!is.na(num) & (num < 2000 | num > 20000)] <- NA_real_
cur$PROD <- round(num, 1)

z <- rep(NA_real_, nrow(cur))
for (amb in unique(cur$ambiente_id)) {
  idx <- which(cur$ambiente_id == amb & !is.na(cur$PROD))
  z[idx] <- as.numeric(scale(cur$PROD[idx]))
}
flag <- cur$parcela_id[which(abs(z) > 3)]
plantados <- gab$parcela_id[gab$tipo == "outlier_plausivel"]
if (!setequal(flag, plantados)) {
  stop("Outliers sinalizados diferem dos plantados: ",
       paste(setdiff(union(flag, plantados), intersect(flag, plantados)), collapse = ", "))
}

qualidade <- do.call(rbind, lapply(split(cur, cur$ambiente_id), function(a) {
  ok <- a$PROD[!is.na(a$PROD)]
  data.frame(
    ambiente_id = a$ambiente_id[1],
    n_parcelas = nrow(a),
    n_ausentes = sum(is.na(a$PROD)),
    n_validos = length(ok),
    media = round(mean(ok), 1),
    dp = round(stats::sd(ok), 1),
    cv_pct = round(100 * stats::sd(ok) / mean(ok), 1),
    stringsAsFactors = FALSE
  )
}))
rownames(qualidade) <- NULL

germ <- data.frame(
  germoplasma_id = genotipos,
  grupo = "A",
  origem = "DH",
  stringsAsFactors = FALSE
)
ensaios <- data.frame(
  ensaio_id = paste0("ENS_", locais$ambiente_id),
  ambiente_id = locais$ambiente_id,
  delineamento = "DBC",
  n_rep = 2L,
  stringsAsFactors = FALSE
)
variavel <- data.frame(
  variavel_id = 1L,
  codigo = "PROD",
  descricao = "Produtividade de graos corrigida a 13% de umidade",
  unidade = "kg/ha",
  minimo = 2000,
  maximo = 20000,
  stringsAsFactors = FALSE
)
ambiente <- locais[, c("ambiente_id", "local", "ano", "safra", "latitude", "longitude")]

gravar <- function(x, caminho) {
  utils::write.csv(x, caminho, row.names = FALSE, fileEncoding = "UTF-8", na = "")
}
gravar(bruto, "data/bruto/bruto_parcelas.csv")
gravar(germ, "data/bruto/bruto_germoplasma.csv")
gravar(ambiente, "data/bruto/ambientes.csv")
gravar(ensaios, "data/bruto/ensaios.csv")
gravar(variavel, "data/bruto/variavel.csv")
gravar(gab, "data/gabarito/erros_injetados.csv")
gravar(qualidade, "data/gabarito/qualidade_esperada.csv")

if (requireNamespace("DBI", quietly = TRUE) && requireNamespace("duckdb", quietly = TRUE)) {
  arq <- "db/ensaio_bruto.duckdb"
  unlink(c(arq, paste0(arq, ".wal")))
  con <- DBI::dbConnect(duckdb::duckdb(), dbdir = arq)
  DBI::dbWriteTable(con, "bruto_parcelas", bruto, overwrite = TRUE)
  DBI::dbWriteTable(con, "bruto_germoplasma", germ, overwrite = TRUE)
  DBI::dbWriteTable(con, "ambiente", ambiente, overwrite = TRUE)
  DBI::dbWriteTable(con, "ensaio", ensaios, overwrite = TRUE)
  DBI::dbWriteTable(con, "variavel", variavel, overwrite = TRUE)
  DBI::dbDisconnect(con, shutdown = TRUE)
  message("Banco DuckDB: ", arq)
} else {
  message("Pacotes DBI/duckdb ausentes: CSV gerado, banco DuckDB nao.")
}

message(sprintf("Bruto: %d linhas | erros injetados: %d", nrow(bruto), nrow(gab)))
print(gab[, c("tipo", "parcela_id", "valor_injetado", "acao_esperada")], row.names = FALSE)
print(qualidade, row.names = FALSE)
