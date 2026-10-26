## 03_ocs_de.R — OCS por Evolução Diferencial (heurística) vs. gabarito QP
## Storn & Price (1997); DEoptim — Mullen et al. (2011)

suppressPackageStartupMessages(library(DEoptim))

coanc <- function(c, G) as.numeric(crossprod(c, G %*% c)) / 2

ocs_de_continua <- function(gebv, G, theta, NP = 200, itermax = 500, sementes = 10) {
  n   <- length(gebv)
  obj <- function(w) {
    c <- w / sum(w)
    -sum(c * gebv) + 1e6 * max(0, coanc(c, G) - theta)^2
  }
  r <- vapply(seq_len(sementes), function(s) {
    set.seed(s)
    res <- DEoptim(obj, lower = rep(1e-6, n), upper = rep(1, n),
                   control = DEoptim.control(NP = NP, itermax = itermax, trace = FALSE))
    w <- res$optim$bestmem; c <- w / sum(w)
    c(ganho = sum(c * gebv), coanc = coanc(c, G))
  }, numeric(2))
  list(ganho_medio = mean(r["ganho", ]), coanc_media = mean(r["coanc", ]))
}

ocs_de_discreta <- function(gebv, G, theta, k = 20, NP = 200, itermax = 500, sementes = 10) {
  n   <- length(gebv)
  sel <- function(w) { c <- rep(0, n); c[order(w, decreasing = TRUE)[seq_len(k)]] <- 1 / k; c }
  obj <- function(w) {
    c <- sel(w)
    -sum(c * gebv) + 1e6 * max(0, coanc(c, G) - theta)^2
  }
  ids1 <- NULL
  r <- vapply(seq_len(sementes), function(s) {
    set.seed(s)
    res <- DEoptim(obj, lower = rep(1e-6, n), upper = rep(1, n),
                   control = DEoptim.control(NP = NP, itermax = itermax, trace = FALSE))
    c <- sel(res$optim$bestmem)
    if (s == 1L) ids1 <<- which(c > 0)
    c(ganho = sum(c * gebv), coanc = coanc(c, G))
  }, numeric(2))
  list(ganho_medio = mean(r["ganho", ]), coanc_media = mean(r["coanc", ]),
       ids_selecionados = ids1)
}

## ── Demonstração ao fazer source() ──────────────────────────────────────────
if (!exists("gebv_vec")) source("R/00_simula_completo.R")
if (!exists("ocs_exata")) source("R/02_ocs_exata.R")

set.seed(par$semente)
idx  <- sample(n, min(100L, n))
g100 <- gebv_vec[idx]; G100 <- G[idx, idx]

# theta para os 100 candidatos (mesma lógica de 00_simula_completo.R)
k_t     <- min(20L, length(g100))
ct      <- rep(0, length(g100)); ct[order(g100, decreasing = TRUE)[seq_len(k_t)]] <- 1 / k_t
cu      <- rep(1 / length(g100), length(g100))
th100   <- coanc(cu, G100) + 0.30 * (coanc(ct, G100) - coanc(cu, G100))

c_ex <- ocs_exata(g100, G100, th100)
ref  <- sum(c_ex * g100)

t0 <- proc.time()
rc <- ocs_de_continua(g100, G100, th100)
tc <- (proc.time() - t0)[["elapsed"]]

t0 <- proc.time()
rd <- ocs_de_discreta(g100, G100, th100)
td <- (proc.time() - t0)[["elapsed"]]

cat(sprintf("Gabarito (QP)     — ganho: %.2f | coancestria: %.4f\n",
            ref, coanc(c_ex, G100)))
cat(sprintf("DE contínua       — ganho: %.2f | razão vs QP: %.3f | tempo: %.0fs\n",
            rc$ganho_medio, rc$ganho_medio / ref, tc))
cat(sprintf("DE discreta k=20  — ganho: %.2f | razão vs QP: %.3f | tempo: %.0fs\n",
            rd$ganho_medio, rd$ganho_medio / ref, td))
