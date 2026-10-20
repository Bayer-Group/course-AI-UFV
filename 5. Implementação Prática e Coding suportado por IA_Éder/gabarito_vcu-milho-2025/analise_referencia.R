# Reproduz os números de referência dos slides 0.3, 5.5, 5.6 e 7.7.
# Uso (a partir da pasta da seção):
#   Rscript gabarito_vcu-milho-2025/analise_referencia.R [caminho/para/vcu-milho-2025]
# Copia o projeto para uma pasta temporária (o projeto dos alunos não é alterado),
# roda o teste e as etapas 01 a 05 e compara com e sem QC.
# Acurácia: só é calculada se existir gabarito_vcu-milho-2025/valores_verdadeiros.csv
# (colunas germoplasma_nome, gv_testcross; vem do ciclo-gs-milho).

args <- commandArgs(trailingOnly = TRUE)
arg_arquivo <- grep("^--file=", commandArgs(), value = TRUE)
gabarito <- normalizePath(dirname(sub("^--file=", "", arg_arquivo)))
projeto <- normalizePath(if (length(args)) args[1] else file.path(gabarito, "..", "vcu-milho-2025"))

trabalho <- file.path(tempdir(), "vcu-milho-2025")
unlink(trabalho, recursive = TRUE)
dir.create(trabalho)
file.copy(list.files(projeto, full.names = TRUE, all.files = TRUE, no.. = TRUE),
          trabalho, recursive = TRUE, copy.mode = FALSE)
file.copy(list.files(file.path(gabarito, "R"), full.names = TRUE), file.path(trabalho, "R"),
          overwrite = TRUE)
file.copy(list.files(file.path(gabarito, "tests"), full.names = TRUE),
          file.path(trabalho, "tests"), overwrite = TRUE)

setwd(trabalho)
for (s in c("tests/test_qc.R", sprintf("R/%s", c("01_importar.R", "02_qc.R", "03_curar.R",
                                                 "04_analise.R", "05_figuras_tabelas.R")))) {
  cat("\n=====", s, "=====\n")
  source(s, local = new.env())
}

source("R/funcoes.R")
par <- yaml::read_yaml("config/parametros.yaml")
r <- par$delineamento$n_blocos
com_qc <- readRDS("data/processado/03_curado.rds")
sem_qc <- readRDS("data/intermediario/01_importado.rds")
sem_qc$genotipo <- sem_qc$germoplasma_nome

resumo <- function(d) {
  ind <- analise_individual(d, r)
  cj <- analise_conjunta(d)
  dh25 <- cj$blups[startsWith(cj$blups$genotipo, par$ids$prefixo_ranking), ]
  dh25$posicao <- seq_len(nrow(dh25))
  list(ind = ind, n_genotipos = nrow(cj$blups), dh25 = dh25)
}
res <- list(com_qc = resumo(com_qc), sem_qc = resumo(sem_qc))

cat("\n===== Análise individual (slide 5.6) =====\n")
tab <- merge(res$com_qc$ind[, c("ambiente_id", "media", "cv", "h2_medias")],
             res$sem_qc$ind[, c("ambiente_id", "cv", "h2_medias")],
             by = "ambiente_id", suffixes = c("", "_sem_qc"))
print(transform(tab, media = round(media), cv = round(cv, 1), h2_medias = round(h2_medias, 2),
                cv_sem_qc = round(cv_sem_qc, 1), h2_medias_sem_qc = round(h2_medias_sem_qc, 3)))

cat("\n===== Análise conjunta (slide 7.7) =====\n")
pos <- function(x) x$dh25$posicao[x$dh25$genotipo == "DH25_0232"]
cat("Genotipos no modelo: com QC", res$com_qc$n_genotipos, "| sem QC", res$sem_qc$n_genotipos, "\n")
cat("Posicao de DH25_0232: com QC", pos(res$com_qc), "| sem QC", pos(res$sem_qc), "\n")

arquivo_gv <- file.path(gabarito, "valores_verdadeiros.csv")
if (file.exists(arquivo_gv)) {
  gv <- read.csv(arquivo_gv)
  acur <- function(x) {
    m <- merge(x$dh25, gv, by.x = "genotipo", by.y = "germoplasma_nome")
    round(cor(m$blup, m$gv_testcross), 2)
  }
  cat("Acuracia: com QC", acur(res$com_qc), "| sem QC", acur(res$sem_qc), "\n")
  posicao_real <- rank(-gv$gv_testcross[startsWith(gv$germoplasma_nome, par$ids$prefixo_ranking)])
  names(posicao_real) <- gv$germoplasma_nome[startsWith(gv$germoplasma_nome, par$ids$prefixo_ranking)]
  cat("Posicao verdadeira de DH25_0232:", posicao_real[["DH25_0232"]], "\n")
} else {
  cat("Acuracia: valores_verdadeiros.csv ausente, nao calculada.\n")
}
cat("\nSaidas em:", trabalho, "\n")
