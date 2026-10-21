par <- yaml::read_yaml("config/parametros.yaml")
d   <- readRDS(file.path(par$caminhos$processado, "03_curado.rds"))
cat("Dim:", dim(d), "\n")
cat("NAs in PROD:", sum(is.na(d$PROD)), "\n")
cat("Ambientes:", sort(unique(d$ambiente_id)), "\n")
cat("Genotipos unicos:", length(unique(d$germoplasma_nome)), "\n")
cat("DH25:", sum(startsWith(unique(d$germoplasma_nome), "DH25_")), "\n")
cat("DH24:", sum(startsWith(unique(d$germoplasma_nome), "DH24_")), "\n")
cat("Blocos:", sort(unique(d$bloco)), "\n")

# Verify BLUP calculation in detail
library(lme4)
fit_conj <- lmer(PROD ~ ambiente_id +
                   (1 | ambiente_id:bloco) +
                   (1 | germoplasma_nome) +
                   (1 | germoplasma_nome:ambiente_id),
                 data = d, na.action = na.omit)

cat("\nFixed effects:\n")
print(fixef(fit_conj))

cat("\nIntercept used for BLUP:", fixef(fit_conj)[1], "\n")

# Check: is the intercept the mean of one ambiente or the overall?
cat("\nNote: the intercept corresponds to the reference level of ambiente_id.\n")
cat("Reference level:", levels(factor(d$ambiente_id))[1], "\n")

# The BLUP should ideally use the overall mean, not just the reference level
# Let's compare
re_geno <- ranef(fit_conj)$germoplasma_nome
cat("\nRange of genotype random effects:", range(re_geno[,1]), "\n")

# Overall mean approach
overall_mean <- mean(d$PROD, na.rm = TRUE)
cat("Overall mean of PROD:", overall_mean, "\n")

# Fixed effect average (across all ambiente levels)
fe <- fixef(fit_conj)
amb_effects <- fe[grep("ambiente_id", names(fe))]
intercept <- fe[1]
all_amb_means <- c(intercept, intercept + amb_effects)
avg_fixed <- mean(all_amb_means)
cat("Average of fixed effects across ambientes:", avg_fixed, "\n")
cat("Intercept only:", intercept, "\n")

# The BLUP as computed in script: intercept + re
# This gives BLUP referenced to PGO (alphabetically first)
# A more correct approach for overall ranking: average across ambientes + re
cat("\nDH25_0030 BLUP using intercept:", round(intercept + re_geno["DH25_0030",1], 2), "\n")
cat("DH25_0030 BLUP using avg fixed:", round(avg_fixed + re_geno["DH25_0030",1], 2), "\n")

# Check h2 independently for PGO
sub_pgo <- d[d$ambiente_id == "PGO_2025_V",]
fit_pgo <- lmer(PROD ~ factor(bloco) + (1|germoplasma_nome), data = sub_pgo, na.action = na.omit)
vc_pgo <- as.data.frame(VarCorr(fit_pgo))
s2g_pgo <- vc_pgo$vcov[vc_pgo$grp == "germoplasma_nome"]
s2e_pgo <- vc_pgo$vcov[vc_pgo$grp == "Residual"]
r <- par$delineamento$n_blocos
h2_pgo <- s2g_pgo / (s2g_pgo + s2e_pgo/r)
cat("\nPGO h2 verification:", h2_pgo, "\n")
cat("PGO CV verification:", 100*sqrt(s2e_pgo)/mean(sub_pgo$PROD, na.rm=TRUE), "\n")

# Check if any convergence/singularity warnings
cat("\nSingularity check (individual PGO):", isSingular(fit_pgo), "\n")
cat("Singularity check (conjunta):", isSingular(fit_conj), "\n")
