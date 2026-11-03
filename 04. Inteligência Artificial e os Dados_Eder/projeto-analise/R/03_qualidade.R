cur <- read.csv("data/processado/parcelas_curadas.csv")

ambientes <- sort(unique(cur$ambiente_id))
qual <- do.call(rbind, lapply(ambientes, function(a) {
  s <- cur$PROD[cur$ambiente_id == a]
  v <- s[!is.na(s)]
  z <- (v - mean(v)) / sd(v)
  data.frame(
    ambiente_id    = a,
    n_parcelas     = length(s),
    n_ausentes     = sum(is.na(s)),
    n_validos      = length(v),
    completude_pct = round(100 * length(v) / length(s), 1),
    media          = round(mean(v), 1),
    mediana        = round(median(v), 1),
    dp             = round(sd(v), 1),
    cv_pct         = round(100 * sd(v) / mean(v), 1),
    minimo         = round(min(v), 1),
    maximo         = round(max(v), 1),
    amplitude      = round(diff(range(v)), 1),
    iqr            = round(IQR(v), 1),
    n_outliers     = sum(abs(z) > 3),
    assimetria     = round(mean(z^3), 2),
    stringsAsFactors = FALSE)
}))

dir.create("output/tabelas", recursive = TRUE, showWarnings = FALSE)
write.csv(qual, "output/tabelas/qualidade_por_ambiente.csv",
          row.names = FALSE)
print(qual, row.names = FALSE)

# --- Graficos descritivos ---
dir.create("output/figuras", recursive = TRUE, showWarnings = FALSE)
cores <- c(PGO_2025_V = "#E69F00", SLG_2025_V = "#56B4E9",
           UDI_2025_V = "#009E73")

# 1. Boxplot + pontos de PROD por ambiente
png("output/figuras/boxplot_prod_por_ambiente.png",
    width = 700, height = 480, res = 120)
par(mar = c(4, 5, 2, 1))
boxplot(PROD ~ ambiente_id, data = cur, col = cores[ambientes],
        ylab = "PROD (kg/ha)", xlab = "", las = 1,
        main = "Produtividade por ambiente")
stripchart(PROD ~ ambiente_id, data = cur, vertical = TRUE,
           method = "jitter", pch = 16, cex = 0.6,
           col = "#00000060", add = TRUE)
dev.off()

# 2. Barplot de completude
png("output/figuras/completude_por_ambiente.png",
    width = 700, height = 420, res = 120)
par(mar = c(4, 5, 2, 1))
mat <- rbind(qual$n_validos, qual$n_ausentes)
bp <- barplot(mat, names.arg = qual$ambiente_id,
        col = c("#56B4E9", "#D55E00"), las = 1,
        ylab = "Parcelas", main = "Completude por ambiente")
legend("topright", legend = c("Validos", "Ausentes"),
       fill = c("#56B4E9", "#D55E00"), bty = "n")
text(bp, qual$n_validos / 2, labels = qual$n_validos, cex = 0.8)
dev.off()

cat("\nGraficos em output/figuras/\n")
