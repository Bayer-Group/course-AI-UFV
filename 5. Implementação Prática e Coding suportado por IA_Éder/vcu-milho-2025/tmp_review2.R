library(lme4)
par <- yaml::read_yaml("config/parametros.yaml")
d   <- readRDS(file.path(par$caminhos$processado, "03_curado.rds"))

fit_conj <- lmer(PROD ~ ambiente_id +
                   (1 | ambiente_id:bloco) +
                   (1 | germoplasma_nome) +
                   (1 | germoplasma_nome:ambiente_id),
                 data = d, na.action = na.omit)

intercept <- fixef(fit_conj)[1]
fe <- fixef(fit_conj)
avg_fe <- mean(c(fe[1], fe[1] + fe[-1]))

re_geno <- ranef(fit_conj)$germoplasma_nome

# BLUPs with intercept (current code)
blups_intercept <- data.frame(
  geno = rownames(re_geno),
  blup_intercept = intercept + re_geno[,1]
)
blups_intercept <- blups_intercept[startsWith(blups_intercept$geno, "DH25_"),]
blups_intercept <- blups_intercept[order(-blups_intercept$blup_intercept),]
blups_intercept$rank_intercept <- 1:nrow(blups_intercept)

# BLUPs with average fixed (correct)
blups_avg <- data.frame(
  geno = rownames(re_geno),
  blup_avg = avg_fe + re_geno[,1]
)
blups_avg <- blups_avg[startsWith(blups_avg$geno, "DH25_"),]
blups_avg <- blups_avg[order(-blups_avg$blup_avg),]
blups_avg$rank_avg <- 1:nrow(blups_avg)

# Merge and check rankings
m <- merge(blups_intercept, blups_avg, by = "geno")
cat("Rankings identical?", all(m$rank_intercept == m$rank_avg), "\n")
cat("Offset (avg - intercept):", round(avg_fe - intercept, 2), "\n")
cat("This is a constant shift; rankings unchanged.\n")
