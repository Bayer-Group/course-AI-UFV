# Teste com erros injetados: o QC precisa achar todos.
# Rodar a partir da raiz do projeto: Rscript tests/test_qc.R

source("R/funcoes.R")
par <- yaml::read_yaml("config/parametros.yaml")

limpo <- data.frame(
  parcela_id = sprintf("P_T_%02d", 1:6),
  ensaio_id = "ENS_T",
  ambiente_id = "T",
  germoplasma_nome = sprintf("DH25_%04d", 1:6),
  bloco = 1L, linha = 1L, coluna = 1:6,
  PROD = 10000
)
stopifnot(nrow(detectar_problemas(limpo, par)) == 0)

sujo <- limpo
sujo$germoplasma_nome[1:4] <- c("dh25_0001", "DH25-0002", "DH25 0003", " DH25_0004")
sujo$PROD[5:6] <- c(104613, 9.01)
sujo <- rbind(sujo, sujo[2, ])

qc <- detectar_problemas(sujo, par)
stopifnot(sum(qc$tipo == "id_fora_do_padrao") == 5,
          sum(qc$tipo == "duplicata_posicao") == 1,
          sum(qc$tipo == "fora_do_intervalo") == 2)

stopifnot(identical(normalizar_id(sujo$germoplasma_nome[1:4]), sprintf("DH25_%04d", 1:4)))

cat("test_qc.R: OK\n")
