# Etapa 05: figuras e tabelas
# Entradas: output/04_individual.csv, output/04_conjunta_blups.csv
# Saídas:   output/05_precisao_ambientes.csv, output/05_ranking_dh25.csv,
#           output/05_blups_dh25.png
# Premissas: tudo regenerável a partir das etapas anteriores

par <- yaml::read_yaml("config/parametros.yaml")
out <- par$caminhos$output
ind <- read.csv(file.path(out, "04_individual.csv"))
blups <- read.csv(file.path(out, "04_conjunta_blups.csv"))

precisao <- data.frame(ambiente = ind$ambiente_id,
                       media_kg_ha = round(ind$media),
                       cv_pct = round(ind$cv, 1),
                       h2_medias = round(ind$h2_medias, 2))
write.csv(precisao, file.path(out, "05_precisao_ambientes.csv"), row.names = FALSE)
write.csv(blups[, c("posicao", "genotipo", "blup")],
          file.path(out, "05_ranking_dh25.csv"), row.names = FALSE)

png(file.path(out, "05_blups_dh25.png"), width = 900, height = 600)
plot(blups$posicao, blups$blup, pch = 19, cex = 0.6,
     xlab = "Posição no ranking (DH25)", ylab = "BLUP de PROD (kg/ha)",
     main = "BLUPs de testcross das linhagens DH25")
abline(h = 0, lty = 2)
dev.off()
