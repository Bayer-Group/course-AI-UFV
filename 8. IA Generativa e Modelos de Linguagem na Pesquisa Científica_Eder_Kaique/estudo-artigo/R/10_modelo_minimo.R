set.seed(2001)

n_ind     <- 200
n_train   <- 150
n_test    <- 50
n_markers <- 100
n_qtl     <- 5
h2        <- 0.5

# 1. Genótipos bialélicos centralizados
freq <- runif(n_markers, 0.1, 0.9)
X    <- sapply(freq, function(p) rbinom(n_ind, 2, p))
X    <- scale(X, center = TRUE, scale = FALSE)

# 2. Efeitos verdadeiros: só n_qtl marcadores têm efeito; normalizar Vg = 1
qtl_idx              <- sample(n_markers, n_qtl)
beta_true            <- numeric(n_markers)
beta_true[qtl_idx]   <- rnorm(n_qtl, 0, 1)
gv_true              <- as.numeric(X %*% beta_true)
beta_true            <- beta_true / sd(gv_true)
gv_true              <- as.numeric(X %*% beta_true)

# 3. Fenótipos com h2 = 0.5
sigma_e <- sqrt(var(gv_true) * (1 - h2) / h2)
y       <- gv_true + rnorm(n_ind, 0, sigma_e)

# 4. Particionar treino / teste
X_tr  <- X[1:n_train, ];        y_tr  <- y[1:n_train]
X_te  <- X[(n_train+1):n_ind, ]; gv_te <- gv_true[(n_train+1):n_ind]

# 5. LS
beta_ls  <- solve(crossprod(X_tr), crossprod(X_tr, y_tr))
gebv_ls  <- as.numeric(X_te %*% beta_ls)

# 6. RR-BLUP  (lambda = sigma2_e / sigma2_beta; com Vg=1 e n_markers QTLs independentes)
lambda   <- ((1 - h2) / h2) * n_markers
beta_rr  <- solve(crossprod(X_tr) + diag(lambda, n_markers), crossprod(X_tr, y_tr))
gebv_rr  <- as.numeric(X_te %*% beta_rr)

# 7. Acurácia e coeficiente de regressão
acc <- c(cor(gv_te, gebv_ls), cor(gv_te, gebv_rr))
b   <- c(coef(lm(gv_te ~ gebv_ls))[2], coef(lm(gv_te ~ gebv_rr))[2])

# 8. Tabela comparativa com valores do artigo (Tabela 2, geração 1003)
resultados <- data.frame(
  Metodo      = c("LS",    "RR-BLUP"),
  r_modelo    = round(acc, 3),
  b_modelo    = round(b,   3),
  r_artigo    = c(0.318,  0.732),
  b_artigo    = c(0.285,  NA)
)
print(resultados, row.names = FALSE)

# Figura: GEBV estimado vs valor genético verdadeiro
par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))

for (i in seq_along(list(gebv_ls, gebv_rr))) {
  gebv   <- list(gebv_ls, gebv_rr)[[i]]
  metodo <- c("LS", "RR-BLUP")[i]
  r_val  <- acc[i]
  b_val  <- b[i]

  plot(gebv, gv_te,
       xlab = "GEBV estimado", ylab = "Valor genético verdadeiro",
       main = sprintf("%s\nr = %.2f  |  b = %.2f", metodo, r_val, b_val),
       pch  = 19, col = adjustcolor("steelblue", 0.5))
  abline(lm(gv_te ~ gebv), col = "red",    lwd = 2)
  abline(0, 1,              col = "gray40", lty = 2)
}
