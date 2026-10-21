# tests/05_test_figuras_tabelas.R

par <- yaml::read_yaml("config/parametros.yaml")
out <- par$caminhos$output

# Arquivos existem
stopifnot(file.exists(file.path(out, "05_tabela_precisao.csv")))
stopifnot(file.exists(file.path(out, "05_ranking_dh25.csv")))
stopifnot(file.exists(file.path(out, "05_blups.pdf")))

# Tabela de precisão
prec <- read.csv(file.path(out, "05_tabela_precisao.csv"), stringsAsFactors = FALSE)
stopifnot(nrow(prec) == 3)
stopifnot(all(c("ambiente", "media_prod", "cv_pct", "h2_medias") %in% names(prec)))
stopifnot(all(prec$h2_medias >= 0 & prec$h2_medias <= 1))
stopifnot(all(prec$cv_pct > 0))
stopifnot(all(prec$media_prod >= 2000 & prec$media_prod <= 20000))

# Ranking
rnk <- read.csv(file.path(out, "05_ranking_dh25.csv"), stringsAsFactors = FALSE)
stopifnot(nrow(rnk) == 400)
stopifnot(all(startsWith(rnk$germoplasma_nome, "DH25_")))
stopifnot(identical(rnk$ranking, 1:400))
stopifnot(all(is.finite(rnk$blup)))

# PDF não vazio
stopifnot(file.info(file.path(out, "05_blups.pdf"))$size > 0)

cat("05_test_figuras_tabelas: PASSED\n")
