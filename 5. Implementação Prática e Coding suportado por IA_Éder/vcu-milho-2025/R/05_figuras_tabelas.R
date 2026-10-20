# R/05_figuras_tabelas.R
#
# Entradas:
#   output/04_individual.csv      — ambiente, media, CV, h2, s2g, s2e
#   output/04_conjunta_blups.csv  — genotipo, blup, rank
#   config/parametros.yaml        — caminhos, ids, delineamento
#
# Saidas:
#   output/05_precisao_ambientes.csv  — tabela de precisao por ambiente (ordenada por h2 desc)
#   output/05_ranking_dh25.csv        — top-20 DH25 (rank, genotipo, blup)
#   output/05_blups_dh25.png          — grafico de barras horizontais BLUPs top-20
#
# Premissas:
#   - 04_individual.csv tem exatamente as colunas: ambiente, media, CV, h2
#   - 04_conjunta_blups.csv tem colunas: genotipo, blup, rank; genótipos DH25_* já filtrados
#   - Parâmetros de caminho e prefixo lidos do yaml; zero hardcode

library(yaml)

cfg <- yaml.load_file("config/parametros.yaml")

out_dir  <- cfg$caminhos$output
ind_path <- file.path(out_dir, "04_individual.csv")
blp_path <- file.path(out_dir, "04_conjunta_blups.csv")

ind  <- read.csv(ind_path,  stringsAsFactors = FALSE)
blup <- read.csv(blp_path, stringsAsFactors = FALSE)

# --- 1. Tabela de precisao por ambiente (h2 decrescente) ---
precisao <- ind[order(-ind$h2), c("ambiente", "media", "CV", "h2")]
write.csv(precisao,
          file.path(out_dir, "05_precisao_ambientes.csv"),
          row.names = FALSE)
cat("05_precisao_ambientes.csv gravado:", nrow(precisao), "linhas\n")

# --- 2. Ranking top-20 DH25 ---
prefixo <- cfg$ids$prefixo_ranking                    # "DH25_"
blup25  <- blup[startsWith(blup$genotipo, prefixo), ]
blup25  <- blup25[order(blup25$rank), ]
top20   <- head(blup25[, c("rank", "genotipo", "blup")], 20)
write.csv(top20,
          file.path(out_dir, "05_ranking_dh25.csv"),
          row.names = FALSE)
cat("05_ranking_dh25.csv gravado:", nrow(top20), "linhas\n")

# --- 3. Grafico de barras horizontais (base graphics) ---
png_path <- file.path(out_dir, "05_blups_dh25.png")
png(png_path, width = 800, height = 600)

# Ordena crescente para barplot (ultima barra no topo = maior BLUP)
top20_ord <- top20[order(top20$blup), ]

par(mar = c(5, 8, 3, 2))
bp <- barplot(
  top20_ord$blup,
  names.arg  = top20_ord$genotipo,
  horiz      = TRUE,
  las        = 1,
  xlab       = "BLUP (kg/ha)",
  main       = "Top-20 DH25: BLUPs do modelo conjunto",
  col        = ifelse(top20_ord$blup >= 0, "steelblue", "tomato"),
  border     = NA,
  cex.names  = 0.75
)
abline(v = 0, lty = 2, col = "black")

dev.off()
cat("05_blups_dh25.png gravado\n")
