## 06_experimento_ocs.R — Comparação longitudinal de estratégias de seleção
## Truncamento vs OCS (ΔF=1% e ΔF=3%) ao longo de 5 ciclos, 10 repetições.
## Usa valores genéticos verdadeiros como proxy de GEBVs (simplificação do experimento).

source("R/utils.R")
suppressPackageStartupMessages({
  library(AlphaSimR)
  library(quadprog)
})
par <- ler_parametros()

coanc <- function(c, G) as.numeric(crossprod(c, G %*% c)) / 2

ocs_lambda <- function(gebv, G, lambda, eps = 1e-6) {
  n   <- length(gebv)
  D   <- lambda * G + diag(eps, n)
  sol <- quadprog::solve.QP(D, gebv,
           cbind(rep(1, n), diag(n)), c(1, rep(0, n)), meq = 1)$solution
  sol <- pmax(sol, 0); sol / sum(sol)
}

ocs_exata <- function(gebv, G, theta, lo = 1e-4, hi = 1e6) {
  for (k in seq_len(80)) {
    mid <- sqrt(lo * hi)
    if (coanc(ocs_lambda(gebv, G, mid), G) > theta) lo <- mid else hi <- mid
  }
  ocs_lambda(gebv, G, hi)
}

## ── Parâmetros do experimento ────────────────────────────────────────────────
N_REP    <- 10L
N_CICLOS <- 5L
N_CRUZ   <- par$cruzamentos$n_cruzamentos          # 20
N_DH     <- par$novo_ciclo$dh_por_cruzamento       # 10
N_TOP    <- 20L                                    # genitores no truncamento

## ── Carrega estado inicial ────────────────────────────────────────────────────
est      <- readRDS("data/gabarito/estado_simulacao.rds")
SP       <- est$SP; SP$nThreads <- 1L
testador <- est$testador
pops     <- est[grep("^coorte", names(est))]
pop0     <- pops[[length(pops)]]   # coorte mais recente como ponto de partida

## ── Função: um ciclo de seleção ───────────────────────────────────────────────
um_ciclo <- function(pop, strategy) {
  ## Métricas da população atual
  tc_gv  <- rowMeans(gv(hybridCross(pop, testador, crossPlan = "testcross")))
  M_cur  <- pullSnpGeno(pop)
  M_var  <- M_cur[, apply(M_cur, 2, var) > 0, drop = FALSE]
  G_cur  <- matriz_G(M_var)
  n_cur  <- nrow(G_cur)
  gebv   <- setNames(tc_gv, pop@id)[rownames(G_cur)]

  metricas <- data.frame(
    media_gv   = mean(tc_gv),
    var_gen    = var(tc_gv),
    coanc_real = coanc(rep(1 / n_cur, n_cur), G_cur)
  )

  ## Seleção de genitores
  if (strategy == "truncamento") {
    sel_idx <- order(gebv, decreasing = TRUE)[seq_len(min(N_TOP, n_cur))]
  } else {
    delta_f <- if (strategy == "ocs_1") 0.01 else 0.03
    C_t   <- coanc(rep(1 / n_cur, n_cur), G_cur)
    th    <- C_t + delta_f * (1 - C_t)
    # Garante viabilidade: theta <= coancestria do truncamento top-20
    ct    <- rep(0, n_cur)
    ct[order(gebv, decreasing = TRUE)[seq_len(min(N_TOP, n_cur))]] <- 1 / min(N_TOP, n_cur)
    th    <- min(th, coanc(ct, G_cur) * 0.999)
    c_opt <- ocs_exata(gebv, G_cur, th)
    sel_idx <- which(c_opt > 1 / (2 * n_cur))
  }

  ## Cruzamentos aleatórios entre os genitores selecionados
  pop_idx <- seq_len(pop@nInd)[pop@id %in% rownames(G_cur)[sel_idx]]
  pairs   <- matrix(sample(pop_idx, 2 * N_CRUZ, replace = TRUE), ncol = 2)
  pairs   <- pairs[pairs[, 1] != pairs[, 2], , drop = FALSE]
  pairs   <- pairs[seq_len(min(N_CRUZ, nrow(pairs))), , drop = FALSE]

  nova_pop <- makeDH(makeCross(pop, pairs), nDH = N_DH)
  list(metricas = metricas, pop = nova_pop)
}

## ── Experimento principal ─────────────────────────────────────────────────────
estrategias <- c("truncamento", "ocs_1", "ocs_3")
resultados  <- vector("list", N_REP * length(estrategias) * N_CICLOS)
k <- 0L

for (rep_id in seq_len(N_REP)) {
  for (strat in estrategias) {
    pop <- pop0   # reset à coorte inicial em cada rep × estratégia
    set.seed(par$semente + rep_id)
    for (ciclo in seq_len(N_CICLOS)) {
      res    <- um_ciclo(pop, strat)
      k      <- k + 1L
      resultados[[k]] <- cbind(data.frame(rep = rep_id, estrategia = strat,
                                          ciclo = ciclo), res$metricas)
      pop <- res$pop
    }
    cat(sprintf("rep %2d | %s — ciclo 5 | media_gv = %.0f\n",
                rep_id, strat, resultados[[k]]$media_gv))
  }
}

tab <- do.call(rbind, resultados)
write.csv(tab, "reports/experimento_ocs.csv", row.names = FALSE)

## ── Figura comparativa ────────────────────────────────────────────────────────
resumo <- aggregate(cbind(media_gv, var_gen, coanc_real) ~ estrategia + ciclo,
                    data = tab, FUN = mean)

cores  <- c(truncamento = "#d7191c", ocs_1 = "#2c7bb6", ocs_3 = "#1a9641")
labels <- c(truncamento = "Truncamento top-20",
            ocs_1 = "OCS ΔF = 1%",
            ocs_3 = "OCS ΔF = 3%")

png("reports/experimento_ocs.png", width = 1200, height = 450, res = 120)
par_graf <- par(mfrow = c(1, 3), mar = c(4, 4, 2, 1))

## Painel 1 — Ganho acumulado
plot(NA, xlim = c(1, N_CICLOS), ylim = range(resumo$media_gv),
     xlab = "Ciclo", ylab = "Média de gv_testcross (kg/ha)",
     main = "Ganho genético médio")
for (s in estrategias) {
  d <- resumo[resumo$estrategia == s, ]
  lines(d$ciclo, d$media_gv, col = cores[s], lwd = 2)
  points(d$ciclo, d$media_gv, col = cores[s], pch = 16)
}
legend("topleft", legend = labels[estrategias], col = cores[estrategias],
       lwd = 2, pch = 16, bty = "n", cex = 0.8)

## Painel 2 — Variância genética
plot(NA, xlim = c(1, N_CICLOS), ylim = range(resumo$var_gen),
     xlab = "Ciclo", ylab = "Variância de gv_testcross",
     main = "Variância genética")
for (s in estrategias)
  lines(resumo$ciclo[resumo$estrategia == s], resumo$var_gen[resumo$estrategia == s],
        col = cores[s], lwd = 2)

## Painel 3 — Coancestria realizada
plot(NA, xlim = c(1, N_CICLOS), ylim = range(resumo$coanc_real),
     xlab = "Ciclo", ylab = "Coancestria de grupo",
     main = "Coancestria realizada")
for (s in estrategias)
  lines(resumo$ciclo[resumo$estrategia == s], resumo$coanc_real[resumo$estrategia == s],
        col = cores[s], lwd = 2)

par(par_graf)
dev.off()
cat("Figura salva em reports/experimento_ocs.png\n")
print(resumo[order(resumo$ciclo, resumo$estrategia), ], row.names = FALSE)
