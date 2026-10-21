# 04_analise.R
# Entradas: data/processado/03_curado.rds, config/parametros.yaml
# Saidas:   output/04_individual.csv, output/04_conjunta_blups.csv
# Premissas: bloco fixo, genotipo aleatorio; h2 = s2g/(s2g+s2e/r);
#            ranking so DH25; testemunhas DH24 entram no modelo.

library(lme4)

par <- yaml::read_yaml("config/parametros.yaml")
d   <- readRDS(file.path(par$caminhos$processado, "03_curado.rds"))

r <- par$delineamento$n_blocos

# ---------- Analise individual (por ambiente) ----------
ambientes <- sort(unique(d$ambiente_id))

indiv <- do.call(rbind, lapply(ambientes, function(amb) {
  sub <- d[d$ambiente_id == amb, ]
  fit <- lmer(PROD ~ factor(bloco) + (1 | germoplasma_nome),
              data = sub, na.action = na.omit)
  vc   <- as.data.frame(VarCorr(fit))
  s2g  <- vc$vcov[vc$grp == "germoplasma_nome"]
  s2e  <- vc$vcov[vc$grp == "Residual"]
  mu   <- mean(sub$PROD, na.rm = TRUE)
  h2   <- s2g / (s2g + s2e / r)
  cv   <- 100 * sqrt(s2e) / mu
  data.frame(ambiente = amb, media_prod = round(mu, 2),
             cv_pct = round(cv, 2), var_genotipo = round(s2g, 4),
             var_residual = round(s2e, 4), h2_medias = round(h2, 4),
             stringsAsFactors = FALSE)
}))

stopifnot(all(indiv$h2_medias >= 0 & indiv$h2_medias <= 1))
stopifnot(all(indiv$var_genotipo >= 0))
stopifnot(all(indiv$var_residual >= 0))

dir.create(par$caminhos$output, showWarnings = FALSE, recursive = TRUE)
write.csv(indiv, file.path(par$caminhos$output, "04_individual.csv"),
          row.names = FALSE)

cat("== 04 Analise individual ==\n")
print(indiv)

# ---------- Analise conjunta ----------
fit_conj <- lmer(PROD ~ ambiente_id +
                   (1 | ambiente_id:bloco) +
                   (1 | germoplasma_nome) +
                   (1 | germoplasma_nome:ambiente_id),
                 data = d, na.action = na.omit)

cat("\n== 04 Componentes de variancia (conjunta) ==\n")
print(VarCorr(fit_conj), comp = "Variance")

# BLUPs: intercepto + efeito aleatorio do genotipo
intercept <- fixef(fit_conj)[1]
re_geno   <- ranef(fit_conj)$germoplasma_nome
blups     <- data.frame(
  germoplasma_nome = rownames(re_geno),
  blup = round(intercept + re_geno[, 1], 2),
  stringsAsFactors = FALSE
)

# Filtrar so DH25
pref <- par$ids$prefixo_ranking
blups <- blups[startsWith(blups$germoplasma_nome, pref), ]
blups <- blups[order(-blups$blup), ]
blups$ranking <- seq_len(nrow(blups))
rownames(blups) <- NULL

write.csv(blups, file.path(par$caminhos$output, "04_conjunta_blups.csv"),
          row.names = FALSE)

cat("\n== 04 Top 10 DH25 ==\n")
print(head(blups, 10))
cat("\nTotal DH25 no ranking:", nrow(blups), "\n")
