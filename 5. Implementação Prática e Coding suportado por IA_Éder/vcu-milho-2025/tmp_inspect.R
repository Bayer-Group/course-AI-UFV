library(yaml)
cfg <- yaml::read_yaml("config/parametros.yaml")
d <- readRDS("data/intermediario/01_importado.rds")
rows <- d[d$parcela_id %in% c("P_PGO_2025_V_0303","P_PGO_2025_V_0569"), c("parcela_id","germoplasma_nome")]
print(rows)
cat("nchar:", nchar(rows$germoplasma_nome), "\n")
cat("grepl regex:", grepl(cfg$ids$regex, rows$germoplasma_nome), "\n")
