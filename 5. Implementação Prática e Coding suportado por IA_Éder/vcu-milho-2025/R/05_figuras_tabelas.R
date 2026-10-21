# 05_figuras_tabelas.R
# Entradas: output/04_individual.csv, output/04_conjunta_blups.csv, config/parametros.yaml
# Saídas:   output/05_tabela_precisao.csv, output/05_ranking_dh25.csv, output/05_blups.pdf
# Premissa: etapas 01–04 já rodaram.

par <- yaml::read_yaml("config/parametros.yaml")
dir.create(par$caminhos$output, showWarnings = FALSE, recursive = TRUE)

ind  <- read.csv(file.path(par$caminhos$output, "04_individual.csv"), stringsAsFactors = FALSE)
blups <- read.csv(file.path(par$caminhos$output, "04_conjunta_blups.csv"), stringsAsFactors = FALSE)

# 1. Tabela de precisão por ambiente
precisao <- ind[, c("ambiente", "media_prod", "cv_pct", "h2_medias")]
precisao$media_prod <- round(precisao$media_prod, 1)
precisao$cv_pct     <- round(precisao$cv_pct, 2)
precisao$h2_medias  <- round(precisao$h2_medias, 4)
write.csv(precisao, file.path(par$caminhos$output, "05_tabela_precisao.csv"), row.names = FALSE)

# 2. Ranking completo DH25
write.csv(blups, file.path(par$caminhos$output, "05_ranking_dh25.csv"), row.names = FALSE)

# 3. Gráfico de BLUPs (ordenados)
pdf(file.path(par$caminhos$output, "05_blups.pdf"), width = 10, height = 6)
blups_ord <- blups[order(blups$ranking), ]
cols <- ifelse(blups_ord$ranking <= 20, "steelblue", "grey70")
plot(blups_ord$ranking, blups_ord$blup,
     type = "n", xlab = "Ranking", ylab = "BLUP (kg/ha)",
     main = "BLUPs das linhagens DH25 — análise conjunta")
points(blups_ord$ranking, blups_ord$blup, pch = 16, cex = 0.6, col = cols)
abline(h = mean(blups_ord$blup), lty = 2, col = "red")
legend("topright", legend = c("Top 20", "Demais", "Média"),
       col = c("steelblue", "grey70", "red"), pch = c(16, 16, NA),
       lty = c(NA, NA, 2), cex = 0.8)
dev.off()

cat("== 05_figuras_tabelas ==\n")
cat("Tabela de precisao:", nrow(precisao), "ambientes\n")
cat("Ranking DH25:", nrow(blups), "genotipos\n")
cat("Grafico: output/05_blups.pdf\n")
cat("\nPrecisao por ambiente:\n")
print(precisao)
cat("\nTop 10 ranking:\n")
print(head(blups, 10))
