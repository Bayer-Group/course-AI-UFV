## 05_fronteira.R — Fronteira ganho × coancestria: QP exato vs. DE heurística
## Para cada theta, mostra o custo de diversidade em ganho genético.

if (!exists("gebv_vec"))        source("R/00_simula_completo.R")
if (!exists("ocs_exata"))       source("R/02_ocs_exata.R")
if (!exists("ocs_de_continua")) source("R/03_ocs_de.R")

coanc <- function(c, G) as.numeric(crossprod(c, G %*% c)) / 2

## ── Mesmo subconjunto de 100 candidatos dos passos anteriores ────────────────
set.seed(par$semente)
idx  <- sample(n, min(100L, n))
g100 <- gebv_vec[idx]; G100 <- G[idx, idx]
n100 <- length(g100)

k_t    <- min(20L, n100)
ct     <- rep(0, n100); ct[order(g100, decreasing = TRUE)[seq_len(k_t)]] <- 1 / k_t
cu     <- rep(1 / n100, n100)
C_trunc100 <- coanc(ct, G100)
C_min100   <- coanc(cu, G100)

## 15 thetas entre C_min e C_trunc (evita extremos inviáveis)
thetas <- seq(C_min100 + 0.01 * (C_trunc100 - C_min100),
              C_trunc100,
              length.out = 15)

## ── Fronteira exata (QP) ─────────────────────────────────────────────────────
front_qp <- lapply(thetas, function(th) {
  c_opt <- ocs_exata(g100, G100, th)
  list(ganho = sum(c_opt * g100), coanc = coanc(c_opt, G100),
       n_contrib = sum(c_opt > 1e-4))
})
ganho_qp  <- sapply(front_qp, `[[`, "ganho")
coanc_qp  <- sapply(front_qp, `[[`, "coanc")

## ── Pontos DE (configuração leve para velocidade em sala) ────────────────────
# ponytail: sementes=3, itermax=200 — suficiente para ilustrar; aumentar fora da aula
de_pts <- lapply(thetas, function(th) {
  rc <- ocs_de_continua(g100, G100, th, NP = 100, itermax = 200, sementes = 3)
  rd <- ocs_de_discreta(g100, G100, th, NP = 100, itermax = 200, sementes = 3)
  c(ganho_cont = rc$ganho_medio, coanc_cont = rc$coanc_media,
    ganho_disc = rd$ganho_medio, coanc_disc = rd$coanc_media)
})
ganho_cont <- sapply(de_pts, `[[`, "ganho_cont")
ganho_disc <- sapply(de_pts, `[[`, "ganho_disc")

## ── Figura ───────────────────────────────────────────────────────────────────
dir.create("reports", showWarnings = FALSE)
png("reports/fronteira_ganho_coancestria.png", width = 900, height = 600, res = 120)

ylim <- range(c(ganho_qp, ganho_cont, ganho_disc))
plot(thetas, ganho_qp, type = "l", lwd = 2, col = "#2c7bb6",
     xlab = expression(theta ~ "(coancestria-alvo)"),
     ylab = "Ganho genético esperado (kg/ha)",
     main = "Fronteira ganho × coancestria",
     ylim = ylim + c(-0.02, 0.02) * diff(ylim))

points(thetas, ganho_cont, pch = 17, col = "#d7191c", cex = 1.2)
points(thetas, ganho_disc, pch = 15, col = "#1a9641", cex = 1.2)

legend("bottomright",
       legend = c("OCS exata (QP)", "DE contínua", "DE discreta k=20"),
       col    = c("#2c7bb6", "#d7191c", "#1a9641"),
       lty    = c(1, NA, NA), pch = c(NA, 17, 15), lwd = 2,
       bty = "n")

# Marca o theta escolhido no roteiro
abline(v = theta, lty = 2, col = "grey50")
text(theta, ylim[1] + 0.05 * diff(ylim), expression(theta["aula"]),
     adj = -0.1, col = "grey40", cex = 0.8)

dev.off()
cat("Figura salva em reports/fronteira_ganho_coancestria.png\n")

## Resumo tabular
tab <- data.frame(theta = round(thetas, 4),
                  ganho_qp = round(ganho_qp, 1),
                  ganho_cont = round(ganho_cont, 1),
                  ganho_disc = round(ganho_disc, 1),
                  razao_cont = round(ganho_cont / ganho_qp, 3),
                  razao_disc = round(ganho_disc / ganho_qp, 3))
write.csv(tab, "reports/fronteira_resumo.csv", row.names = FALSE)
print(tab, row.names = FALSE)
