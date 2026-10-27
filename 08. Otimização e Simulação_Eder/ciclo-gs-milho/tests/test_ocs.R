## test_ocs.R — Verifica restrições da OCS exata e identidade c'Gc/2 para DH
## Referenciado no slide 6 da apresentação.

source("R/00_simula_completo.R")
source("R/02_ocs_exata.R")

cat("── test_ocs.R ──────────────────────────────────────\n")
erros <- 0L

## 1. Restrições básicas da solução QP
c_sol <- ocs_exata(gebv_vec, G, theta)

if (abs(sum(c_sol) - 1) > 1e-6) {
  cat("FALHA: sum(c) =", sum(c_sol), "(esperado 1)\n"); erros <- erros + 1L
}
if (any(c_sol < -1e-8)) {
  cat("FALHA: contribuições negativas encontradas\n"); erros <- erros + 1L
}
coanc_sol <- as.numeric(crossprod(c_sol, G %*% c_sol)) / 2
if (coanc_sol > theta + 1e-6) {
  cat("FALHA: coancestria", coanc_sol, "> theta", theta, "\n"); erros <- erros + 1L
}

## 2. diag(G) ~ 2 para linhagens DH (homozigotas completas)
dg <- diag(G)
if (mean(dg) < 1.5 || mean(dg) > 2.5) {
  cat("FALHA: mean(diag(G)) =", mean(dg), "(esperado ~2 para DH)\n"); erros <- erros + 1L
}

## 3. c'Gc/2 com contribuições uniformes ≈ média dos off-diagonais / 2
c_unif <- rep(1 / n, n)
coanc_unif <- as.numeric(crossprod(c_unif, G %*% c_unif)) / 2
coanc_media <- mean(G[lower.tri(G)]) / 2
if (abs(coanc_unif - coanc_media) > 0.05) {
  cat("FALHA: c'Gc/2 uniforme diverge da média off-diagonal\n"); erros <- erros + 1L
}

if (erros == 0L) {
  cat("OK: todas as verificações passaram\n")
} else {
  stop(erros, " verificação(ões) falharam", call. = FALSE)
}
