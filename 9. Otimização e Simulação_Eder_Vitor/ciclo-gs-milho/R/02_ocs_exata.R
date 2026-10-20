## 02_ocs_exata.R — Seleção por Contribuição Ótima (OCS) via Programação Quadrática.
## Gabarito exato: base de comparação para qualquer heurística.
## Formulação: docs/formulacao_ocs.md | Referência: Meuwissen (1997)

suppressPackageStartupMessages(library(quadprog))

coanc <- function(c, G) as.numeric(crossprod(c, G %*% c)) / 2

# Resolve a forma penalizada: max c'g - lambda * c'Gc/2
# solve.QP minimiza 1/2 x'Dx - d'x, logo Dmat = lambda*G e dvec = gebv
# ponytail: ridge fixo 1e-6; aumentar se G tiver autovalores muito pequenos
ocs_lambda <- function(gebv, G, lambda, eps = 1e-6) {
  n   <- length(gebv)
  D   <- lambda * G + diag(eps, n)   # garante definida positiva
  sol <- quadprog::solve.QP(
    Dmat = D,
    dvec = gebv,
    Amat = cbind(rep(1, n), diag(n)),   # sum(c)=1 e c>=0
    bvec = c(1, rep(0, n)),
    meq  = 1
  )$solution
  sol <- pmax(sol, 0); sol / sum(sol)
}

# Bisseção em lambda para atingir exatamente coancestria = theta
ocs_exata <- function(gebv, G, theta, lo = 1e-4, hi = 1e6) {
  for (k in seq_len(80)) {
    mid <- sqrt(lo * hi)
    if (coanc(ocs_lambda(gebv, G, mid), G) > theta) lo <- mid else hi <- mid
  }
  ocs_lambda(gebv, G, hi)
}

## Teste automático (roda ao fazer source())
if (!exists("gebv_vec")) source("R/00_simula_completo.R")
c_test <- ocs_exata(gebv_vec, G, theta)
stopifnot(abs(sum(c_test) - 1) < 1e-6, all(c_test >= -1e-8),
          coanc(c_test, G) <= theta + 1e-6)

cat(sprintf(
  "OCS exata — ganho: %.0f kg/ha | coancestria: %.4f | contribuintes: %d\n",
  sum(c_test * gebv_vec), coanc(c_test, G), sum(c_test > 1e-4)
))
