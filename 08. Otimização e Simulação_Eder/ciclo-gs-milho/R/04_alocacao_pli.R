## 04_alocacao_pli.R — Alocação de cruzamentos por Programação Linear Inteira
## Dado um conjunto de genitores selecionados (OCS discreta), escolhe quais
## pares cruzar maximizando: media_gebv_pais - lambda_c * coancestria_par.
## Mesmo solver do 06_cruzamentos.R (lpSolve), critério diferente (sem variância).

source("R/utils.R")
suppressPackageStartupMessages(library(lpSolve))

## ids   : índices inteiros (nas linhas de gebv/G) dos genitores selecionados
## gebv  : vetor nomeado de GEBVs (todos os candidatos)
## G     : matriz de parentesco genomico (n x n)
## n_cruz: número de cruzamentos a alocar
## uso_max: uso máximo por genitor
## lambda_c: peso da coancestria no objetivo (padrão 1.0)
alocar_cruzamentos <- function(ids, gebv, G, n_cruz, uso_max, lambda_c = 1.0) {
  g_sel <- gebv[ids]
  G_sel <- G[ids, ids]
  pares <- t(combn(seq_along(ids), 2))
  media   <- (g_sel[pares[, 1]] + g_sel[pares[, 2]]) / 2
  coanc_p <- (G_sel[pares] + G_sel[pares[, c(2, 1), drop = FALSE]]) / 4
  # coancestria do par = (G_ii + G_ij + G_ji + G_jj) / 4 — média esperada da progênie
  coanc_p <- mapply(function(i, j) (G_sel[i, i] + G_sel[i, j] + G_sel[j, i] + G_sel[j, j]) / 4,
                    pares[, 1], pares[, 2])
  objetivo <- media - lambda_c * coanc_p

  A_uso <- t(sapply(seq_along(ids), function(k)
    as.numeric(pares[, 1] == k | pares[, 2] == k)))

  lp_res <- lp("max", objetivo,
               const.mat = rbind(rep(1, nrow(pares)), A_uso),
               const.dir = c("=", rep("<=", nrow(A_uso))),
               const.rhs = c(n_cruz, rep(uso_max, nrow(A_uso))),
               all.bin = TRUE)
  stopifnot(lp_res$status == 0)

  plano <- data.frame(
    genitor1  = names(g_sel)[pares[, 1]],
    genitor2  = names(g_sel)[pares[, 2]],
    media     = media,
    coancestria = coanc_p,
    objetivo  = objetivo,
    stringsAsFactors = FALSE
  )[lp_res$solution == 1, ]
  plano
}

## ── Demonstração ao fazer source() ──────────────────────────────────────────
if (!exists("gebv_vec")) source("R/00_simula_completo.R")
if (!exists("rd"))       source("R/03_ocs_de.R")

plano <- alocar_cruzamentos(
  ids      = rd$ids_selecionados,
  gebv     = gebv_vec,
  G        = G,
  n_cruz   = par$cruzamentos$n_cruzamentos,
  uso_max  = par$cruzamentos$uso_max_por_genitor,
  lambda_c = 1.0
)

write.csv(plano, "reports/alocacao_cruzamentos.csv", row.names = FALSE)

cat("Cruzamentos alocados:", nrow(plano), "\n")
cat("Uso máximo observado:", max(table(c(plano$genitor1, plano$genitor2))), "\n")
print(head(plano[order(-plano$objetivo), ], 5), row.names = FALSE)
