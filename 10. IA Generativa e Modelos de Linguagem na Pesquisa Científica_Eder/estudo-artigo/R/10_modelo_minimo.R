# Simulacao reduzida de Meuwissen et al. (2001): LS vs RR-BLUP
# Referencia: Genetics 157:1819-1829, Table 2 (p. 1824)

# -- Parametros (versao reduzida) ---------------------------------------------
set.seed(2001)
n_ind     <- 200
n_train   <- 150
n_test    <- 50
n_markers <- 100
n_qtl     <- 5
h2        <- 0.5

# -- 1. Matriz de genotipos bialelicos (0/1/2), centralizada -----------------
X <- matrix(rbinom(n_ind * n_markers, size = 2, prob = 0.5), nrow = n_ind)
X <- scale(X, center = TRUE, scale = FALSE)

# -- 2. Efeitos verdadeiros: apenas n_qtl marcadores com efeito ---------------
qtl_idx <- sample(n_markers, n_qtl)
beta_true <- rep(0, n_markers)
beta_true[qtl_idx] <- rnorm(n_qtl)

# Normalizar para Vg = 1 (artigo: variancia genetica = 1, p. 1820)
g <- drop(X %*% beta_true)
beta_true <- beta_true / sd(g)
g <- drop(X %*% beta_true)

# -- 3. Fenotipos com h2 = 0.5 (Ve = Vg = 1) --------------------------------
e <- rnorm(n_ind, mean = 0, sd = 1)
y <- g + e

# -- 4. Particao treino / teste -----------------------------------------------
idx_train <- 1:n_train
idx_test  <- (n_train + 1):n_ind

X_train <- X[idx_train, ]
y_train <- y[idx_train]
X_test  <- X[idx_test, ]
g_test  <- g[idx_test]

# -- 5. Estimacao LS (solve + crossprod) --------------------------------------
XtX <- crossprod(X_train)
Xty <- crossprod(X_train, y_train)
beta_ls <- solve(XtX, Xty)
ebv_ls  <- drop(X_test %*% beta_ls)

# -- 6. Estimacao RR-BLUP (ridge) --------------------------------------------
# lambda = (sigma_e^2 / sigma_g_por_marcador^2) = ((1-h2)/h2) * n_markers
lambda    <- ((1 - h2) / h2) * n_markers
beta_blup <- solve(XtX + lambda * diag(n_markers), Xty)
ebv_blup  <- drop(X_test %*% beta_blup)

# -- 7. Acuracia (cor) e coeficiente b (regressao TBV ~ EBV) -----------------
r_ls   <- cor(g_test, ebv_ls)
r_blup <- cor(g_test, ebv_blup)
b_ls   <- coef(lm(g_test ~ ebv_ls))[2]
b_blup <- coef(lm(g_test ~ ebv_blup))[2]

# -- 8. Tabela comparativa com artigo (Table 2, p. 1824) ---------------------
cat("\n")
cat("=================================================================\n")
cat(" Meuwissen et al. (2001) - Simulacao reduzida vs. artigo\n")
cat("=================================================================\n")
cat(sprintf("  %-10s %8s %8s | %8s %8s\n",
            "Metodo", "r_sim", "r_art", "b_sim", "b_art"))
cat("-----------------------------------------------------------------\n")
cat(sprintf("  %-10s %8.3f %8.3f | %8.3f %8.3f\n",
            "LS",      r_ls,   0.318,   b_ls,   0.285))
cat(sprintf("  %-10s %8.3f %8.3f | %8.3f %8s\n",
            "RR-BLUP",  r_blup, 0.732,   b_blup, "0.896"))
cat("=================================================================\n")
cat(" r = cor(TBV, EBV);  b = regressao TBV ~ EBV\n")
cat(" Valores do artigo: Table 2, geracao 1003 (media de 5 replicatas)\n")
cat(" Nota: simulacao reduzida (200 ind, 100 marcadores) vs.\n")
cat("       artigo (2200 ind, ~50.000 haplotipos) -- valores diferem\n")
cat("       em magnitude, mas o ranking LS < BLUP deve se manter.\n")
cat("=================================================================\n")

# -- 9. Scatter plots: GEBV vs TBV -------------------------------------------
png("R/10_scatter_ls_blup.png", width = 900, height = 450, res = 120)
par(mfrow = c(1, 2), mar = c(4, 4, 2.5, 1))

xlim <- range(ebv_ls, ebv_blup)
ylim <- range(g_test)

plot(ebv_ls, g_test, pch = 16, cex = 0.8, col = "steelblue",
     xlab = "GEBV estimado", ylab = "Valor genetico verdadeiro",
     main = sprintf("LS  (r=%.2f, b=%.2f)", r_ls, b_ls),
     xlim = xlim, ylim = ylim)
abline(0, 1, col = "grey50", lty = 2, lwd = 1.5)
abline(lm(g_test ~ ebv_ls), col = "red", lwd = 2)
legend("topleft", legend = c("b observado", "b = 1 ideal"),
       col = c("red", "grey50"), lty = c(1, 2), lwd = c(2, 1.5),
       bty = "n", cex = 0.8)

plot(ebv_blup, g_test, pch = 16, cex = 0.8, col = "steelblue",
     xlab = "GEBV estimado", ylab = "Valor genetico verdadeiro",
     main = sprintf("RR-BLUP  (r=%.2f, b=%.2f)", r_blup, b_blup),
     xlim = xlim, ylim = ylim)
abline(0, 1, col = "grey50", lty = 2, lwd = 1.5)
abline(lm(g_test ~ ebv_blup), col = "red", lwd = 2)
legend("topleft", legend = c("b observado", "b = 1 ideal"),
       col = c("red", "grey50"), lty = c(1, 2), lwd = c(2, 1.5),
       bty = "n", cex = 0.8)

dev.off()
cat("\nGrafico salvo em: R/10_scatter_ls_blup.png\n")
