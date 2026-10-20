# Teste unitário da Etapa 02 — QC
# Injeta erros sintéticos e verifica que todas as 4 regras os detectam.

library(yaml)

cfg <- yaml::read_yaml("config/parametros.yaml")

# Carrega funções sem executar o bloco principal
QC_SOURCE_ONLY <- TRUE
source("R/02_qc.R")

# ---------- dados sintéticos (8 linhas) ----------
d_test <- data.frame(
  parcela_id      = paste0("P_TEST_", 1:8),
  ensaio_id       = c("ENS_UDI_2025_V", "ENS_UDI_2025_V", "ENS_UDI_2025_V",
                      "ENS_UDI_2025_V", "ENS_UDI_2025_V",
                      "ENS_UDI_2025_V", "ENS_UDI_2025_V", "ENS_UDI_2025_V"),
  ambiente_id     = rep("UDI_2025_V", 8),
  germoplasma_nome = c("DH25_0001", "DH25_0002", "DH25_0003",   # 3 linhas limpas
                       "dh25_0001",                              # ID fora do padrão
                       "DH25_0001",                              # duplicata posição (= linha 1)
                       "DH25_0004", "DH25_0005", "DH25_0006"),  # fora intervalo + ausente
  bloco           = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
  linha           = c(1L, 2L, 3L, 4L, 1L, 6L, 7L, 8L),         # linha 5 duplica (ensaio+linha+coluna) de linha 1
  coluna          = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L),
  PROD            = c(8000, 9000, 10000, 8500, 8000, 500, 25000, NA),
  data_coleta     = rep("2025-04-01", 8),
  stringsAsFactors = FALSE
)

# ---------- rodar detecções ----------
r_id   <- detectar_id_fora_padrao(d_test, cfg)
r_dup  <- detectar_duplicata_posicao(d_test, cfg)
r_fora <- detectar_prod_fora_intervalo(d_test, cfg)
r_na   <- detectar_prod_ausente(d_test, cfg)

partes <- Filter(Negate(is.null), list(r_id, r_dup, r_fora, r_na))
rel    <- do.call(rbind, partes)

# ---------- asserções ----------
stopifnot(sum(rel$tipo == "id_fora_padrao")      == 1)
stopifnot(sum(rel$tipo == "duplicata_posicao")   == 1)
stopifnot(sum(rel$tipo == "prod_fora_intervalo") == 2)
stopifnot(sum(rel$tipo == "prod_ausente")        == 1)

cat("02: OK\n")
