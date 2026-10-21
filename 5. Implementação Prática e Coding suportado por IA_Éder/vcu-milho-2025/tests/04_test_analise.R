# tests/04_test_analise.R
# Verifica saidas da etapa 04

par <- yaml::read_yaml("config/parametros.yaml")
out <- par$caminhos$output
pass <- 0; fail <- 0

chk <- function(desc, expr) {
  ok <- tryCatch(expr, error = function(e) FALSE)
  if (isTRUE(ok)) { cat("PASS:", desc, "\n"); pass <<- pass + 1 }
  else            { cat("FAIL:", desc, "\n"); fail <<- fail + 1 }
}

# --- individual ---
f_ind <- file.path(out, "04_individual.csv")
chk("04_individual.csv existe", file.exists(f_ind))

ind <- read.csv(f_ind, stringsAsFactors = FALSE)
chk("3 linhas (ambientes)", nrow(ind) == 3)
chk("h2 entre 0 e 1",      all(ind$h2_medias >= 0 & ind$h2_medias <= 1))
chk("var_genotipo >= 0",    all(ind$var_genotipo >= 0))
chk("var_residual >= 0",    all(ind$var_residual >= 0))
chk("CV > 0",               all(ind$cv_pct > 0))

# --- conjunta ---
f_blup <- file.path(out, "04_conjunta_blups.csv")
chk("04_conjunta_blups.csv existe", file.exists(f_blup))

bl <- read.csv(f_blup, stringsAsFactors = FALSE)
chk("so DH25 (nenhum DH24)", !any(startsWith(bl$germoplasma_nome, "DH24_")))
chk("ranking 1:N sem lacunas", identical(bl$ranking, seq_len(nrow(bl))))
chk("BLUPs numericos sem NA",  all(is.finite(bl$blup)))
chk("400 genotipos DH25",      nrow(bl) == 400)

cat("\n", pass, "PASS,", fail, "FAIL\n")
if (fail > 0) stop("Testes falharam")
