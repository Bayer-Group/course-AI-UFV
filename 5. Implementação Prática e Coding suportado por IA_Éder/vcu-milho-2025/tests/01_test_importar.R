# tests/01_test_importar.R
stopifnot(file.exists("data/intermediario/01_importado.rds"))

d <- readRDS("data/intermediario/01_importado.rds")

stopifnot(nrow(d) == 2426)
stopifnot(ncol(d) == 9)
stopifnot(setequal(unique(d$ambiente_id), c("PGO_2025_V", "SLG_2025_V", "UDI_2025_V")))
stopifnot(is.integer(d$bloco), is.integer(d$linha), is.integer(d$coluna))
stopifnot(is.numeric(d$PROD))
stopifnot(is.character(d$germoplasma_nome))

cat("01_test_importar: PASSED\n")
