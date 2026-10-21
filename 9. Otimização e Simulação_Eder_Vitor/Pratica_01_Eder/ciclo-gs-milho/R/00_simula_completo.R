## 00_simula_completo.R — Executa o ciclo completo de simulação até os GEBVs
## e monta os objetos prontos para a aula de otimização.
##
## Etapas encadeadas:
##   01_simulacao   → genótipos, fenótipos, gabarito
##   02_carga_banco → banco DuckDB com dados brutos (erros injetados)
##   03_qc          → camada curada
##   04_blup_met    → BLUPs das linhagens
##   05_gs          → GEBVs e efeitos de marcadores
##
## Saídas no ambiente R (prontas para os scripts de otimização):
##   gebv_vec  — vetor nomeado de GEBVs (coorte mais recente)
##   G         — matriz de parentesco genômico de VanRaden (2008)
##   n         — número de candidatos
##   par       — lista de parâmetros do YAML
##   theta     — coancestria-alvo (30% do caminho entre mínima e truncamento)

source("R/utils.R")
par <- ler_parametros()

## ---------------------------------------------------------------------------
## 1. Verifica se os dados do pipeline já foram preparados
## ---------------------------------------------------------------------------
arquivos_necessarios <- c(
  "data/gabarito/estado_simulacao.rds",
  "data/genotipos/snps.rds",
  "reports/gs_resumo.csv"
)
faltando <- arquivos_necessarios[!file.exists(arquivos_necessarios)]
if (length(faltando) > 0)
  stop("Dados do pipeline não encontrados:\n",
       paste(" •", faltando, collapse = "\n"), "\n",
       "Solicite ao instrutor os dados pré-preparados da aula.", call. = FALSE)

## ---------------------------------------------------------------------------
## 2. Monta objetos para a otimização
## ---------------------------------------------------------------------------
suppressPackageStartupMessages(library(DBI))

con     <- conectar(par)
gebv_df <- dbGetQuery(con, "
  SELECT g.germoplasma_id, g.gebv, m.coorte
  FROM gebv g JOIN germoplasma m USING (germoplasma_id)
  ORDER BY g.germoplasma_id")
desconectar(con)

cand     <- gebv_df[gebv_df$coorte == max(gebv_df$coorte), ]
M_cand   <- readRDS("data/genotipos/snps.rds")[cand$germoplasma_id, ]
M_cand   <- M_cand[, apply(M_cand, 2, var) > 0]
G        <- matriz_G(M_cand)
gebv_vec <- setNames(cand$gebv, cand$germoplasma_id)[rownames(G)]
n        <- length(gebv_vec)

# Coancestria do truncamento: top-20 com contribuições iguais (1/k)
k       <- min(20L, n)
top_idx <- order(gebv_vec, decreasing = TRUE)[seq_len(k)]
c_trunc <- rep(0, n); c_trunc[top_idx] <- 1 / k
C_trunc <- as.numeric(crossprod(c_trunc, G %*% c_trunc)) / 2
# C_min: contribuições uniformes (1/n) — menor coancestria de grupo atingível
c_unif  <- rep(1 / n, n)
C_min   <- as.numeric(crossprod(c_unif, G %*% c_unif)) / 2
theta   <- C_min + 0.30 * (C_trunc - C_min)

msg(sprintf("Pronto: %d candidatos | G %dx%d | C_min=%.4f | C_trunc=%.4f | theta=%.4f",
            n, n, n, C_min, C_trunc, theta))
