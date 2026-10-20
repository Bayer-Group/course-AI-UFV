# Entradas:   config/parametros.yaml, data/processado/03_curado.rds
# Saídas:     output/04_individual.csv  (ambiente, media, CV, h2)
#             output/04_conjunta_blups.csv (genotipo, blup, rank)
# Premissas:  03_curado.rds existe; PROD em kg/ha; bloco como inteiro 1–n_blocos;
#             germoplasma_nome normalizado; lme4 instalado.

library(yaml)
library(lme4)

cfg  <- yaml::read_yaml("config/parametros.yaml")
d    <- readRDS(file.path(cfg$caminhos$processado, "03_curado.rds"))
r    <- cfg$delineamento$n_blocos          # número de blocos (do yaml)
outd <- cfg$caminhos$output

dir.create(outd, showWarnings = FALSE, recursive = TRUE)

# Garante fatores
d$germoplasma_nome <- as.factor(d$germoplasma_nome)
d$bloco            <- as.factor(d$bloco)
d$ambiente_id      <- as.factor(d$ambiente_id)

# ── Análise individual por ambiente ──────────────────────────────────────────
ambientes <- levels(d$ambiente_id)

ind_res <- lapply(ambientes, function(amb) {
  sub  <- d[d$ambiente_id == amb & !is.na(d$PROD), ]
  fit  <- lmer(PROD ~ bloco + (1 | germoplasma_nome), data = sub, REML = TRUE)
  vc   <- as.data.frame(VarCorr(fit))
  s2g  <- vc$vcov[vc$grp == "germoplasma_nome"]
  s2e  <- vc$vcov[vc$grp == "Residual"]
  h2   <- s2g / (s2g + s2e / r)
  med  <- mean(sub$PROD, na.rm = TRUE)
  cv   <- sqrt(s2e) / med * 100
  cat(sprintf("\n[%s]  media=%.1f  CV=%.1f%%  h2=%.3f  s2g=%.1f  s2e=%.1f\n",
              amb, med, cv, h2, s2g, s2e))
  data.frame(ambiente = amb, media = round(med, 1), CV = round(cv, 2),
             h2 = round(h2, 4), s2g = round(s2g, 1), s2e = round(s2e, 1),
             stringsAsFactors = FALSE)
})

ind_df <- do.call(rbind, ind_res)
write.csv(ind_df, file.path(outd, "04_individual.csv"), row.names = FALSE)

# ── Análise conjunta ──────────────────────────────────────────────────────────
d_conj <- d[!is.na(d$PROD), ]

fit_conj <- lmer(
  PROD ~ ambiente_id + (1 | ambiente_id:bloco) + (1 | germoplasma_nome) +
         (1 | germoplasma_nome:ambiente_id),
  data = d_conj, REML = TRUE
)

cat("\n[Conjunta] componentes de variância:\n")
print(VarCorr(fit_conj))

# BLUPs de genotipo (efeito principal)
blups_all <- ranef(fit_conj)$germoplasma_nome
blups_all$genotipo <- rownames(blups_all)
names(blups_all)[1] <- "blup"

# Ranking apenas DH25_*
prefixo <- cfg$ids$prefixo_ranking
blups25 <- blups_all[startsWith(blups_all$genotipo, prefixo), ]
blups25 <- blups25[order(-blups25$blup), ]
blups25$rank <- seq_len(nrow(blups25))
rownames(blups25) <- NULL

cat(sprintf("\nBLUPs extraídos: %d DH25_* genótipos ranqueados\n", nrow(blups25)))
cat(sprintf("Top-3: %s (%.1f), %s (%.1f), %s (%.1f)\n",
    blups25$genotipo[1], blups25$blup[1],
    blups25$genotipo[2], blups25$blup[2],
    blups25$genotipo[3], blups25$blup[3]))

write.csv(blups25[, c("genotipo", "blup", "rank")],
          file.path(outd, "04_conjunta_blups.csv"), row.names = FALSE)

cat("\nSaídas gravadas em", outd, "\n")
