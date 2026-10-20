d <- read.csv("data/processado/parcelas_curadas.csv", stringsAsFactors = FALSE)

ambientes <- sort(unique(d$ambiente_id))
qualidade <- do.call(rbind, lapply(ambientes, function(amb) {
  x <- d$PROD[d$ambiente_id == amb]
  n_parcelas <- length(x)
  n_ausentes <- sum(is.na(x))
  n_validos <- n_parcelas - n_ausentes
  media <- mean(x, na.rm = TRUE)
  dp <- sd(x, na.rm = TRUE)
  cv_pct <- 100 * dp / media
  data.frame(
    ambiente_id = amb,
    n_parcelas = n_parcelas,
    n_ausentes = n_ausentes,
    n_validos = n_validos,
    media = round(media, 1),
    dp = round(dp, 1),
    cv_pct = round(cv_pct, 1),
    stringsAsFactors = FALSE
  )
}))

dir.create("output/tabelas", recursive = TRUE, showWarnings = FALSE)
dir.create("output/figuras", recursive = TRUE, showWarnings = FALSE)
write.csv(qualidade, "output/tabelas/qualidade_por_ambiente.csv", row.names = FALSE)
print(qualidade)

# Graficos descritivos (R base)
png("output/figuras/prod_boxplot_ambiente.png", width = 900, height = 600, res = 120)
boxplot(PROD ~ ambiente_id, data = d, las = 1,
        xlab = "Ambiente", ylab = "PROD (kg/ha)",
        main = "Produtividade por ambiente")
dev.off()

png("output/figuras/media_cv_ambiente.png", width = 900, height = 600, res = 120)
op <- par(mfrow = c(1, 2), mar = c(7, 4, 3, 1))
barplot(qualidade$media, names.arg = qualidade$ambiente_id, las = 2,
        ylab = "Media (kg/ha)", main = "Media de PROD")
barplot(qualidade$cv_pct, names.arg = qualidade$ambiente_id, las = 2,
        ylab = "CV (%)", main = "CV descritivo")
par(op)
dev.off()

png("output/figuras/prod_hist_ambiente.png", width = 900, height = 700, res = 120)
op <- par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))
for (amb in ambientes) {
  hist(d$PROD[d$ambiente_id == amb], breaks = 10, col = "gray80", border = "gray40",
       main = amb, xlab = "PROD (kg/ha)", ylab = "Frequencia")
}
barplot(qualidade$n_ausentes, names.arg = qualidade$ambiente_id, las = 2,
        ylab = "N ausentes", main = "Ausentes em PROD")
par(op)
dev.off()

cat("Figuras em output/figuras/\n")
