# =============================================================================
#  ITEM 6 - SELECAO GENOMICA COM SUPORTE DA IA
#  Curso: IA no Melhoramento Genetico - UFV, novembro/2026
#
#  Percurso: fenotipo -> marcador -> matriz G -> GBLUP -> GEBV -> acuracia
#            -> ganho genetico -> e, por fim, GBLUP vs machine learning.
#
#  Todos os dados sao simulados: o simulador esta embutido neste arquivo.
#  Saida: figuras/*.png e resultados_06.rds (consumidos pelo .qmd).
# =============================================================================

t_inicio <- Sys.time()
set.seed(2026)

# =============================================================================
#  SIMULADOR DIDATICO DA POPULACAO DE MELHORAMENTO  (embutido)
#
#  Especie modelo: autogama diploide, linhagens homozigotas (0/2).
#  Nenhum dado real e utilizado. Tudo abaixo e simulacao com semente fixa.
#  Depende apenas do R base (+ stats). Nenhum pacote interno.
#
#  Esta secao e embutida de proposito: o script e autocontido e roda sem
#  depender de nenhum outro arquivo do repositorio.
# =============================================================================

# -----------------------------------------------------------------------------
# 1. MAPA GENETICO
#    Posicoes dos marcadores, em Morgans, distribuidas em cromossomos.
#    O mapa e o que permite recombinacao: sem ele, nao existe meiose.
# -----------------------------------------------------------------------------
criar_mapa <- function(n_snp = 1500, n_chr = 10, tam_chr = 1.0) {
  por_chr <- rep(n_snp %/% n_chr, n_chr)
  por_chr[seq_len(n_snp %% n_chr)] <- por_chr[seq_len(n_snp %% n_chr)] + 1
  data.frame(
    snp = seq_len(n_snp),
    chr = rep(seq_len(n_chr), por_chr),
    pos = unlist(lapply(por_chr, function(k) sort(runif(k, 0, tam_chr)))),
    row.names = NULL
  )
}

# -----------------------------------------------------------------------------
# 2. FUNDADORES
#    Linhagens homozigotas. Guardamos os alelos como 0/1 por haplotipo;
#    como a linhagem e homozigota, os dois haplotipos sao identicos.
#    A frequencia alelica vem de uma Beta, o que gera o espectro de
#    frequencias tipico de uma populacao de melhoramento (muitos SNPs raros).
# -----------------------------------------------------------------------------
simular_fundadores <- function(n_ind = 120, mapa, freq_beta = c(0.6, 0.6)) {
  n_snp <- nrow(mapa)
  p <- rbeta(n_snp, freq_beta[1], freq_beta[2])
  p <- pmin(pmax(p, 0.03), 0.97)          # evita marcadores monomorficos
  hap <- matrix(rbinom(n_ind * n_snp, 1, rep(p, each = n_ind)),
                nrow = n_ind, ncol = n_snp)
  list(hap1 = hap, hap2 = hap, p0 = p)    # homozigoto: hap1 == hap2
}

# -----------------------------------------------------------------------------
# 3. MEIOSE
#    Um gameta e um mosaico dos dois haplotipos do individuo. O numero de
#    permutas (crossovers) por cromossomo e Poisson(tamanho em Morgans) e as
#    posicoes sao uniformes - o modelo de Haldane, sem interferencia.
# -----------------------------------------------------------------------------
gerar_gameta <- function(h1, h2, mapa, chr_idx) {
  origem <- integer(length(h1))
  for (cr in seq_along(chr_idx)) {
    idx <- chr_idx[[cr]]
    L   <- max(mapa$pos[idx])
    co  <- sort(runif(rpois(1, L), 0, L))             # pontos de permuta
    seg <- findInterval(mapa$pos[idx], co)            # segmento de cada SNP
    ini <- sample.int(2, 1)                           # haplotipo inicial
    origem[idx] <- ifelse(seg %% 2 == 0, ini, 3L - ini)
  }
  ifelse(origem == 1L, h1, h2)
}

# -----------------------------------------------------------------------------
# 4. CRUZAMENTO + DUPLO-HAPLOIDE
#    Cada cruzamento gera `n_prog` gametas; cada gameta e duplicado,
#    produzindo uma linhagem homozigota nova (atalho usual para autogamas).
#    Resultado: nova geracao, ja em forma de linhagem, pronta para avaliar.
# -----------------------------------------------------------------------------
cruzar_dh <- function(pop, pai, mae, n_prog, mapa, chr_idx) {
  n_cruz <- length(pai)
  n_snp  <- nrow(mapa)
  filhos <- matrix(0L, nrow = n_cruz * n_prog, ncol = n_snp)
  k <- 0L
  for (i in seq_len(n_cruz)) {
    # F1: um haplotipo de cada pai (os pais sao homozigotos)
    f1_h1 <- pop$hap1[pai[i], ]
    f1_h2 <- pop$hap1[mae[i], ]
    for (j in seq_len(n_prog)) {
      k <- k + 1L
      filhos[k, ] <- gerar_gameta(f1_h1, f1_h2, mapa, chr_idx)
    }
  }
  list(hap1 = filhos, hap2 = filhos,
       pai = rep(pai, each = n_prog), mae = rep(mae, each = n_prog))
}

# -----------------------------------------------------------------------------
# 5. GENOTIPO EM DOSAGEM
#    0, 1 ou 2 copias do alelo de referencia. E a matriz Z que entra nos
#    modelos. Para linhagens homozigotas assume apenas 0 e 2.
# -----------------------------------------------------------------------------
dosagem <- function(pop) pop$hap1 + pop$hap2

# -----------------------------------------------------------------------------
# 6. ARQUITETURA GENETICA
#    Sorteia quais marcadores sao QTL e com que efeito. A opcao `epistasia`
#    adiciona interacoes entre pares de QTL - usada no item 6 para mostrar
#    quando um modelo nao-linear tem (ou nao tem) o que capturar.
# -----------------------------------------------------------------------------
criar_arquitetura <- function(n_snp, n_qtl = 120, epistasia = 0, n_pares = 40) {
  qtl <- sort(sample.int(n_snp, n_qtl))
  pares <- NULL
  if (epistasia > 0) {
    pares <- cbind(sample(qtl, n_pares, replace = TRUE),
                   sample(qtl, n_pares, replace = TRUE))
    pares <- pares[pares[, 1] != pares[, 2], , drop = FALSE]
  }
  list(
    qtl        = qtl,
    efeito     = rnorm(n_qtl, 0, 1),
    pares      = pares,
    ef_par     = if (is.null(pares)) NULL else rnorm(nrow(pares), 0, 1),
    peso_epist = epistasia
  )
}

# -----------------------------------------------------------------------------
# 7. VALOR GENETICO VERDADEIRO
#    Em simulacao nos conhecemos a verdade - e exatamente isso que permite
#    medir acuracia. Em dados reais o valor genetico verdadeiro nunca e visto.
# -----------------------------------------------------------------------------
valor_genetico <- function(Z, arq) {
  a <- as.numeric(Z[, arq$qtl, drop = FALSE] %*% arq$efeito)
  if (arq$peso_epist > 0 && !is.null(arq$pares)) {
    inter <- (Z[, arq$pares[, 1], drop = FALSE] / 2) *
             (Z[, arq$pares[, 2], drop = FALSE] / 2)
    i <- as.numeric(inter %*% arq$ef_par)
    a <- (1 - arq$peso_epist) * scale(a)[, 1] + arq$peso_epist * scale(i)[, 1]
  }
  as.numeric(a)
}

# -----------------------------------------------------------------------------
# 8. FENOTIPAGEM
#    Converte valor genetico em observacao de campo. O residuo e calibrado
#    para entregar a herdabilidade pedida: Ve = Vg * (1 - h2) / h2.
#    `media` e `sd_alvo` apenas colocam o trait numa escala legivel.
# -----------------------------------------------------------------------------
fenotipar <- function(g, h2, media = 100, sd_alvo = 10, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  g_esc <- as.numeric(scale(g)) * sd_alvo
  ve    <- (sd_alvo^2) * (1 - h2) / h2
  list(y = media + g_esc + rnorm(length(g), 0, sqrt(ve)),
       g = g_esc, ve = ve, vg = sd_alvo^2)
}

# -----------------------------------------------------------------------------
# 9. FENOTIPAGEM MULTI-AMBIENTE
#    y_ijk = media + g_i + amb_j + (g x amb)_ij + residuo
#    Usada no item 9: e o que torna "quantos locais e quantas repeticoes"
#    uma pergunta com resposta numerica em vez de opiniao.
# -----------------------------------------------------------------------------
fenotipar_multi <- function(g, n_loc, n_rep, h2_parcela = 0.25,
                            prop_gxe = 0.40, media = 100, sd_alvo = 10) {
  n   <- length(g)
  gi  <- as.numeric(scale(g)) * sd_alvo
  vg  <- sd_alvo^2
  vge <- vg * prop_gxe / (1 - prop_gxe)
  ve  <- (vg + vge) * (1 - h2_parcela) / h2_parcela
  amb <- rnorm(n_loc, 0, sd_alvo * 1.5)
  ge  <- matrix(rnorm(n * n_loc, 0, sqrt(vge)), n, n_loc)
  df  <- expand.grid(ind = seq_len(n), loc = seq_len(n_loc), rep = seq_len(n_rep))
  df$y <- media + gi[df$ind] + amb[df$loc] +
          ge[cbind(df$ind, df$loc)] + rnorm(nrow(df), 0, sqrt(ve))
  list(dados = df, g = gi, vg = vg, vge = vge, ve = ve)
}

# -----------------------------------------------------------------------------
# 10. MATRIZ DE PARENTESCO GENOMICA  (VanRaden 2008, metodo 1)
#     G = Zc Zc' / (2 * soma p(1-p)), com Zc centrado nas frequencias.
#     E a peca que substitui o pedigree: parentesco medido, nao presumido.
#     O blend com a identidade garante inversa (G sozinha e singular).
# -----------------------------------------------------------------------------
matriz_G <- function(Z, p = NULL, blend = 0.02) {
  if (is.null(p)) p <- colMeans(Z) / 2
  p  <- pmin(pmax(p, 1e-6), 1 - 1e-6)
  Zc <- sweep(Z, 2, 2 * p, "-")
  k  <- 2 * sum(p * (1 - p))
  G  <- tcrossprod(Zc) / k
  (1 - blend) * G + blend * diag(nrow(G))
}

# -----------------------------------------------------------------------------
# 11. GBLUP pelas equacoes do modelo misto
#     y = 1*media + Z*g + e,  g ~ N(0, G * Vg)
#     [ 1'1   1'Z          ] [media]   [1'y]
#     [ Z'1   Z'Z + Gi*lam ] [  g  ] = [Z'y]      lam = Ve / Vg
#     `idx_obs` sao as linhas de G que tem fenotipo; as demais recebem
#     predicao via parentesco - e isso que chamamos de GEBV.
# -----------------------------------------------------------------------------
gblup <- function(y_obs, idx_obs, G, lambda) {
  n  <- nrow(G)
  Gi <- solve(G)
  Zm <- matrix(0, length(idx_obs), n)
  Zm[cbind(seq_along(idx_obs), idx_obs)] <- 1
  um <- matrix(1, length(idx_obs), 1)
  lhs <- rbind(
    cbind(crossprod(um),       crossprod(um, Zm)),
    cbind(crossprod(Zm, um),   crossprod(Zm) + Gi * lambda)
  )
  rhs <- rbind(crossprod(um, y_obs), crossprod(Zm, y_obs))
  sol <- solve(lhs, rhs)
  list(media = sol[1], gebv = as.numeric(sol[-1]))
}

# -----------------------------------------------------------------------------
# 12. RR-BLUP (visao do marcador)
#     a_hat = Z' (Z Z' + lam I)^-1 (y - media); GEBV = Z a_hat.
#     Matematicamente equivalente ao GBLUP - o item 6 demonstra isso
#     numericamente. Dois caminhos, um resultado.
# -----------------------------------------------------------------------------
rrblup <- function(y_obs, Z_obs, Z_todos, lambda) {
  mu <- mean(y_obs)
  K  <- tcrossprod(Z_obs) + diag(lambda, nrow(Z_obs))
  a  <- crossprod(Z_obs, solve(K, y_obs - mu))
  list(media = mu, efeitos = as.numeric(a),
       gebv = as.numeric(Z_todos %*% a))
}

# -----------------------------------------------------------------------------
# 13. COANCESTRIA MEDIA E ENDOGAMIA
#     f = c' A c / 2, com A = G/2 na escala de parentesco. Em OCS e o termo
#     que segura a perda de diversidade; sem ele a otimizacao escolhe
#     irmaos completos e queima a variabilidade em dois ciclos.
# -----------------------------------------------------------------------------
coancestria_media <- function(G, idx, pesos = NULL) {
  A <- G[idx, idx, drop = FALSE] / 2
  c_ <- if (is.null(pesos)) rep(1 / length(idx), length(idx)) else pesos / sum(pesos)
  as.numeric(crossprod(c_, A %*% c_))
}

# -----------------------------------------------------------------------------
# 14. UTILITARIOS
# -----------------------------------------------------------------------------
indices_cromossomo <- function(mapa) split(seq_len(nrow(mapa)), mapa$chr)

acuracia <- function(pred, verdade) cor(pred, verdade)

# Intensidade de selecao: media da normal padrao truncada acima de 1-p.
# Entra na equacao do criador para traduzir pressao de selecao em ganho.
intensidade_selecao <- function(prop) {
  z <- qnorm(1 - prop)
  dnorm(z) / prop
}

# Ganho esperado por ciclo: dG = i * r * sd_A / L   (equacao do criador)
ganho_esperado <- function(prop, r, sd_a, anos_ciclo) {
  intensidade_selecao(prop) * r * sd_a / anos_ciclo
}

# Paleta neutra (material sai da empresa; nada de identidade corporativa)
cores_curso <- c(azul = "#2C6E9B", laranja = "#D08C3C", verde = "#4E8E6B",
                 vinho = "#9B4A5A", cinza = "#6E7375", roxo = "#6D5B8E")

# ----------------------------- fim do simulador ------------------------------

# =============================================================================
#  CHECAGEM DE PACOTES  (embutido)
#
#  Serve para o script parar no TOPO, com instrucao de conserto, em vez de
#  morrer paginas adiante num library() cru: install.packages() nunca
#  sinaliza falha, e um pacote faltando passa calado se ninguem conferir.
# =============================================================================

# Para o script, dizendo o que fazer. Use quando o pacote e indispensavel.
exigir <- function(...) {
  pkgs <- c(...)
  falta <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(falta)) {
    stop("Pacote(s) faltando: ", paste(falta, collapse = ", "),
         "
  Instale com:  install.packages(c(\"",
         paste(falta, collapse = "\", \""),
         "\"), repos = \"https://packagemanager.posit.co/cran/2026-09-01\")",
         call. = FALSE)
  }
  invisible(TRUE)
}

# Avisa e devolve FALSE. Use quando o bloco e dispensavel: o script segue
# sem ele e so aquela comparacao fica de fora.
tem <- function(pkg, para_que = "") {
  ok <- requireNamespace(pkg, quietly = TRUE)
  if (!ok) {
    cat(sprintf("\n  AVISO: pacote '%s' ausente%s.\n", pkg,
                if (nzchar(para_que)) paste0(" - pulando ", para_que) else ""))
    cat(sprintf("  Para habilitar: install.packages(\"%s\",
                 repos = \"%s\")

",
                pkg, "https://packagemanager.posit.co/cran/2026-09-01"))
  }
  ok
}

exigir("ggplot2")
suppressMessages(library(ggplot2))

dir.create("figuras", showWarnings = FALSE)
TEMA <- theme_minimal(base_size = 13) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(colour = "grey35"))
png_salvar <- function(p, arq, w = 9, h = 5.2) {
  ggsave(file.path("figuras", arq), p, width = w, height = h, dpi = 150)
}
R <- list()   # acumula resultados para os slides

# =============================================================================
# PARTE 1 - A POPULACAO
# -----------------------------------------------------------------------------
# Antes de qualquer modelo: de onde vem o dado. Montamos uma populacao de
# linhagens de uma especie autogama, genotipadas e fenotipadas.
# =============================================================================
N_IND <- 600
N_SNP <- 1500
H2    <- 0.35          # herdabilidade de um trait de produtividade: baixa

mapa <- criar_mapa(n_snp = N_SNP, n_chr = 10)
chr_idx <- indices_cromossomo(mapa)

fund <- simular_fundadores(n_ind = 100, mapa = mapa)
# Uma geracao de cruzamentos entre os fundadores cria a estrutura de
# parentesco que a selecao genomica explora (irmaos, meio-irmaos, nao-parentes).
n_cruz <- 100
pop <- cruzar_dh(fund,
                 pai = sample.int(100, n_cruz, replace = TRUE),
                 mae = sample.int(100, n_cruz, replace = TRUE),
                 n_prog = N_IND / n_cruz, mapa = mapa, chr_idx = chr_idx)

Z <- dosagem(pop)
# Descarta marcadores que perderam polimorfismo (MAF < 0,05): passo de QC que
# em dado real responde por boa parte do tempo de analise.
maf <- pmin(colMeans(Z) / 2, 1 - colMeans(Z) / 2)
Z <- Z[, maf >= 0.05, drop = FALSE]
mapa_qc <- mapa[maf >= 0.05, ]

arq <- criar_arquitetura(n_snp = ncol(Z), n_qtl = 120)
g_verd <- valor_genetico(Z, arq)
fen <- fenotipar(g_verd, h2 = H2)
y <- fen$y
g_verd_esc <- fen$g

R$pop <- list(n_ind = nrow(Z), n_snp_bruto = N_SNP, n_snp_qc = ncol(Z),
              n_qtl = length(arq$qtl), h2 = H2, n_cruz = n_cruz,
              removidos_maf = N_SNP - ncol(Z))
cat(sprintf("Populacao: %d linhagens, %d SNPs apos QC (%d removidos por MAF), h2 = %.2f\n",
            nrow(Z), ncol(Z), R$pop$removidos_maf, H2))

# FIGURA 1 - o problema central: o fenotipo so revela parte do genotipo.
df1 <- data.frame(g = g_verd_esc, y = y)
p1 <- ggplot(df1, aes(g, y)) +
  geom_point(alpha = 0.45, colour = cores_curso["azul"], size = 1.8) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              colour = cores_curso["vinho"], linewidth = 0.9) +
  labs(title = "O fenotipo nao e o valor genetico",
       subtitle = sprintf("h2 = %.2f: a correlacao entre os dois e %.2f, ou seja a raiz de h2",
                          H2, cor(g_verd_esc, y)),
       x = "Valor genetico verdadeiro (conhecido so na simulacao)",
       y = "Fenotipo observado") + TEMA
png_salvar(p1, "01_fenotipo_vs_genetico.png")
R$cor_fen_gen <- cor(g_verd_esc, y)

# FIGURA 2 - estrutura de parentesco capturada pelos marcadores
G <- matriz_G(Z)
fora <- G[upper.tri(G)]
df2 <- data.frame(parentesco = fora)
p2 <- ggplot(df2, aes(parentesco)) +
  geom_histogram(bins = 70, fill = cores_curso["azul"], colour = "white",
                 linewidth = 0.15) +
  geom_vline(xintercept = c(0, 0.5), linetype = "dashed",
             colour = cores_curso["vinho"]) +
  annotate("text", x = 0.5, y = Inf, label = " irmaos completos", hjust = 0,
           vjust = 2, size = 3.6, colour = cores_curso["vinho"]) +
  annotate("text", x = 0, y = Inf, label = "nao parentes ", hjust = 1,
           vjust = 2, size = 3.6, colour = cores_curso["vinho"]) +
  labs(title = "A matriz G mede o parentesco em vez de presumi-lo",
       subtitle = "Distribuicao dos elementos fora da diagonal de G (VanRaden 2008)",
       x = "Parentesco genomico entre pares de linhagens", y = "Numero de pares") +
  TEMA
png_salvar(p2, "02_parentesco_G.png")
R$G_resumo <- c(diag_media = mean(diag(G)), fora_media = mean(fora),
                fora_max = max(fora))

# =============================================================================
# PARTE 2 - DO FENOTIPO AO GEBV
# -----------------------------------------------------------------------------
# Divisao treinamento/validacao. O ponto que o aluno precisa levar: a
# validacao NAO entra no ajuste. Seu fenotipo existe apenas para conferir
# a predicao depois.
# =============================================================================
PROP_TS <- 0.70
idx_ts <- sort(sample.int(nrow(Z), round(PROP_TS * nrow(Z))))
idx_vs <- setdiff(seq_len(nrow(Z)), idx_ts)

lambda <- (1 - H2) / H2          # Ve/Vg quando o fenotipo e uma media por linha
fit_g <- gblup(y[idx_ts], idx_ts, G, lambda)
gebv  <- fit_g$gebv

acc_vs <- acuracia(gebv[idx_vs], g_verd_esc[idx_vs])
acc_ts <- acuracia(gebv[idx_ts], g_verd_esc[idx_ts])
R$acc <- c(treinamento = acc_ts, validacao = acc_vs,
           n_ts = length(idx_ts), n_vs = length(idx_vs))
cat(sprintf("GBLUP - acuracia no treinamento %.3f | na validacao %.3f\n", acc_ts, acc_vs))

# FIGURA 3 - a figura que define selecao genomica
df3 <- data.frame(gebv = gebv, g = g_verd_esc,
                  conj = ifelse(seq_len(nrow(Z)) %in% idx_ts,
                                "Treinamento (tem fenotipo)",
                                "Validacao (predito sem fenotipo)"))
p3 <- ggplot(df3, aes(gebv, g, colour = conj)) +
  geom_point(alpha = 0.6, size = 1.9) +
  geom_abline(slope = 1, intercept = 0, linetype = "dotted", colour = "grey40") +
  scale_colour_manual(values = unname(cores_curso[c("cinza", "laranja")])) +
  labs(title = "GEBV prediz o valor genetico de quem nunca foi fenotipado",
       subtitle = sprintf("Acuracia: %.2f no treinamento, %.2f na validacao",
                          acc_ts, acc_vs),
       x = "GEBV (predicao do modelo)", y = "Valor genetico verdadeiro",
       colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p3, "03_gebv_vs_verdadeiro.png")

# -----------------------------------------------------------------------------
# GBLUP e RR-BLUP sao o mesmo modelo
# Dois caminhos algebricos, um resultado. Mostrar isso evita a confusao de
# tratar "modelo de marcador" e "modelo de parentesco" como alternativas.
# -----------------------------------------------------------------------------
p_frq  <- colMeans(Z) / 2
Zc     <- sweep(Z, 2, 2 * p_frq, "-")
k_van  <- 2 * sum(p_frq * (1 - p_frq))
fit_rr <- rrblup(y[idx_ts], Zc[idx_ts, ], Zc, lambda * k_van)
R$equiv_gblup_rrblup <- cor(fit_rr$gebv, gebv)
cat(sprintf("Correlacao GBLUP vs RR-BLUP: %.4f (sao o mesmo modelo)\n",
            R$equiv_gblup_rrblup))

# FIGURA 4 - efeitos estimados por marcador x efeito verdadeiro do QTL
ef <- data.frame(snp = seq_len(ncol(Z)), chr = mapa_qc$chr,
                 efeito = abs(fit_rr$efeitos), eh_qtl = FALSE)
ef$eh_qtl[arq$qtl] <- TRUE
p4 <- ggplot(ef, aes(snp, efeito)) +
  geom_point(aes(colour = eh_qtl, size = eh_qtl), alpha = 0.7) +
  scale_colour_manual(values = c(`FALSE` = "grey75",
                                 `TRUE` = unname(cores_curso["vinho"])),
                      labels = c("Marcador neutro", "QTL verdadeiro")) +
  scale_size_manual(values = c(`FALSE` = 1, `TRUE` = 2.3), guide = "none") +
  labs(title = "Selecao genomica nao precisa achar o gene",
       subtitle = "Os efeitos se espalham por marcadores em LD com os QTL; a soma e que prediz",
       x = "Marcador (ordenado pelo mapa)", y = "|Efeito estimado|",
       colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p4, "04_efeitos_marcadores.png")

# =============================================================================
# PARTE 3 - O QUE GOVERNA A ACURACIA
# -----------------------------------------------------------------------------
# Duas alavancas que o melhorista controla: tamanho da populacao de
# treinamento e herdabilidade (que depende do esforco de fenotipagem).
# Rodamos a grade de verdade em vez de citar a formula.
# =============================================================================
grade_ts <- c(50, 100, 150, 200, 300, 400, 500)
res_ts <- do.call(rbind, lapply(grade_ts, function(n) {
  ac <- replicate(10, {
    its <- sample(idx_ts, min(n, length(idx_ts)))
    f <- gblup(y[its], its, G, lambda)
    acuracia(f$gebv[idx_vs], g_verd_esc[idx_vs])
  })
  data.frame(n_ts = n, acc = mean(ac), sd = sd(ac))
}))
R$curva_ts <- res_ts

p5 <- ggplot(res_ts, aes(n_ts, acc)) +
  geom_ribbon(aes(ymin = acc - sd, ymax = acc + sd), fill = cores_curso["azul"],
              alpha = 0.15) +
  geom_line(colour = cores_curso["azul"], linewidth = 1) +
  geom_point(colour = cores_curso["azul"], size = 2.6) +
  labs(title = "A acuracia tem retorno decrescente no tamanho do treinamento",
       subtitle = "Media de 10 reamostragens por ponto; mesma populacao de validacao",
       x = "Linhagens na populacao de treinamento",
       y = "Acuracia na validacao") + TEMA
png_salvar(p5, "05_curva_treinamento.png")

grade_h2 <- c(0.10, 0.20, 0.30, 0.40, 0.60, 0.80)
res_h2 <- do.call(rbind, lapply(grade_h2, function(h) {
  fh <- fenotipar(g_verd, h2 = h, seed = 100 + round(h * 100))
  lam <- (1 - h) / h
  f <- gblup(fh$y[idx_ts], idx_ts, G, lam)
  data.frame(h2 = h, acc = acuracia(f$gebv[idx_vs], fh$g[idx_vs]))
}))
R$curva_h2 <- res_h2

p6 <- ggplot(res_h2, aes(h2, acc)) +
  geom_line(colour = cores_curso["verde"], linewidth = 1) +
  geom_point(colour = cores_curso["verde"], size = 2.6) +
  scale_x_continuous(labels = function(x) sprintf("%.2f", x)) +
  labs(title = "Herdabilidade e a outra alavanca",
       subtitle = "Fenotipar melhor aumenta a acuracia sem trocar o modelo",
       x = "Herdabilidade do trait", y = "Acuracia na validacao") + TEMA
png_salvar(p6, "06_curva_h2.png")

# -----------------------------------------------------------------------------
# Parentesco entre treinamento e validacao
# O numero que mais engana em selecao genomica: validacao cruzada aleatoria
# da acuracia otimista porque mistura irmaos. Separar por familia e o
# teste honesto para predizer material novo.
# -----------------------------------------------------------------------------
fam <- pop$pai
fam_un <- unique(fam)
fam_vs <- sample(fam_un, round(0.3 * length(fam_un)))
idx_vs_fam <- which(fam %in% fam_vs)
idx_ts_fam <- setdiff(seq_len(nrow(Z)), idx_vs_fam)
f_fam <- gblup(y[idx_ts_fam], idx_ts_fam, G, lambda)
acc_fam <- acuracia(f_fam$gebv[idx_vs_fam], g_verd_esc[idx_vs_fam])
R$acc_por_familia <- c(aleatoria = acc_vs, por_familia = acc_fam)
cat(sprintf("Validacao aleatoria %.3f | validacao separando familias %.3f\n",
            acc_vs, acc_fam))

df7 <- data.frame(
  esquema = factor(c("Aleatoria\n(mistura irmaos)", "Por familia\n(familias inteiras fora)"),
                   levels = c("Aleatoria\n(mistura irmaos)", "Por familia\n(familias inteiras fora)")),
  acc = c(acc_vs, acc_fam))
p7 <- ggplot(df7, aes(esquema, acc, fill = esquema)) +
  geom_col(width = 0.55, show.legend = FALSE) +
  geom_text(aes(label = sprintf("%.2f", acc)), vjust = -0.5, size = 4.6) +
  scale_fill_manual(values = unname(cores_curso[c("cinza", "vinho")])) +
  coord_cartesian(ylim = c(0, max(df7$acc) * 1.2)) +
  labs(title = "Como validar muda a acuracia que voce reporta",
       subtitle = "Mesma populacao, mesmo modelo: a diferenca e so o esquema de validacao",
       x = NULL, y = "Acuracia na validacao") + TEMA
png_salvar(p7, "07_validacao_esquema.png", h = 5.0)

# =============================================================================
# PARTE 4 - DA ACURACIA AO GANHO GENETICO
# -----------------------------------------------------------------------------
# A equacao do criador: dG = i * r * sd_A / L.
# O argumento economico da selecao genomica raramente esta no r, e quase
# sempre no L: predizer sem fenotipar encurta o ciclo.
# =============================================================================
cenarios <- data.frame(
  cenario = c("Selecao fenotipica", "Selecao genomica"),
  r = c(sqrt(H2), acc_vs),
  L = c(4, 2),
  prop = c(0.10, 0.10)
)
cenarios$ganho <- with(cenarios, mapply(ganho_esperado, prop, r, 10, L))
cenarios$rotulo <- sprintf("r = %.2f\nciclo = %d anos", cenarios$r, cenarios$L)
R$ganho_cenarios <- cenarios
cat(sprintf("Ganho/ano - fenotipica %.2f | genomica %.2f (%.0f%% a mais)\n",
            cenarios$ganho[1], cenarios$ganho[2],
            100 * (cenarios$ganho[2] / cenarios$ganho[1] - 1)))

p8 <- ggplot(cenarios, aes(cenario, ganho, fill = cenario)) +
  geom_col(width = 0.55, show.legend = FALSE) +
  geom_text(aes(label = rotulo), vjust = -0.3, size = 4, lineheight = 0.95) +
  scale_fill_manual(values = unname(cores_curso[c("cinza", "azul")])) +
  coord_cartesian(ylim = c(0, max(cenarios$ganho) * 1.35)) +
  labs(title = "O ganho da selecao genomica vem do tempo, nao so da acuracia",
       subtitle = "Equacao do criador: dG = i x r x sd_A / L, com 10% selecionados",
       x = NULL, y = "Ganho genetico por ano (unidades do trait)") + TEMA
png_salvar(p8, "08_ganho_genetico.png", h = 5.4)

# =============================================================================
# PARTE 5 - GBLUP CONTRA MACHINE LEARNING
# -----------------------------------------------------------------------------
# Comparativo honesto, no MESMO dado. Dois regimes:
#   (a) arquitetura puramente aditiva  -> o modelo linear e o correto
#   (b) arquitetura com epistasia forte -> ha interacao para o ML capturar
# A licao nao e "ML e melhor" nem "ML e pior": e que o ganho do ML depende
# da arquitetura, e arquitetura e uma hipotese biologica, nao uma escolha
# de software. Detalhamento de ML/DL fica no item 7.
# =============================================================================
# randomForest e dispensavel: sem ele o script segue e so esta comparacao
# fica de fora. Todo o resto do item 6 e R base.
TEM_RF <- tem("randomForest", "a comparacao GBLUP vs machine learning")
if (TEM_RF) suppressMessages(library(randomForest))

comparar <- function(y_, g_, rotulo) {
  lam <- (1 - H2) / H2
  f_lin <- gblup(y_[idx_ts], idx_ts, G, lam)
  acc_lin <- acuracia(f_lin$gebv[idx_vs], g_[idx_vs])
  # RF nao lida bem com p >> n, entao preselecionamos marcadores. A
  # preselecao usa SO o treinamento deste cenario - usar o fenotipo da
  # validacao aqui seria vazamento de informacao, o erro mais comum
  # quando se compara modelo linear com ML.
  acc_rf <- NA_real_
  if (TEM_RF) {
    f_rr <- rrblup(y_[idx_ts], Zc[idx_ts, ], Zc, lam * k_van)
    top  <- order(abs(f_rr$efeitos), decreasing = TRUE)[1:300]
    rf <- randomForest(x = Z[idx_ts, top], y = y_[idx_ts], ntree = 500)
    acc_rf <- acuracia(predict(rf, Z[idx_vs, top]), g_[idx_vs])
  }
  data.frame(arquitetura = rotulo,
             GBLUP = acc_lin, `Random forest` = acc_rf,
             check.names = FALSE)
}

cmp_a <- comparar(y, g_verd_esc, "Aditiva")
# Cenario extremo de proposito: valor genetico 100% epistatico, concentrado
# em poucos pares de QTL. E o unico regime em que o modelo linear perde de
# forma visivel - e mesmo assim precisa de muitos dados para o ML aproveitar.
arq_e  <- criar_arquitetura(ncol(Z), n_qtl = 40, epistasia = 1.0, n_pares = 12)
g_e    <- valor_genetico(Z, arq_e)
fen_e  <- fenotipar(g_e, h2 = H2, seed = 77)
cmp_b  <- comparar(fen_e$y, fen_e$g, "Epistatica (extremo)")

cmp <- rbind(cmp_a, cmp_b)
R$comparativo_ml <- cmp
print(cmp)

if (!TEM_RF) {
  cat("  (coluna Random forest ausente - figura 09 nao sera gerada)\n")
}
if (TEM_RF) {
df9 <- data.frame(
  arquitetura = rep(cmp$arquitetura, 2),
  modelo = rep(c("GBLUP", "Random forest"), each = nrow(cmp)),
  acc = c(cmp$GBLUP, cmp$`Random forest`))
p9 <- ggplot(df9, aes(arquitetura, acc, fill = modelo)) +
  geom_col(position = position_dodge(0.65), width = 0.6) +
  geom_text(aes(label = sprintf("%.2f", acc)),
            position = position_dodge(0.65), vjust = -0.4, size = 4) +
  scale_fill_manual(values = unname(cores_curso[c("azul", "laranja")])) +
  coord_cartesian(ylim = c(0, max(df9$acc) * 1.25)) +
  labs(title = "Machine learning ganha quando ha nao-aditividade para capturar",
       subtitle = "Mesma populacao, mesmos marcadores, mesma h2: muda so a arquitetura genetica",
       x = "Arquitetura genetica simulada", y = "Acuracia na validacao",
       fill = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p9, "09_gblup_vs_ml.png", h = 5.4)
}

# =============================================================================
# ENCERRAMENTO
# =============================================================================
R$tempo_s <- as.numeric(difftime(Sys.time(), t_inicio, units = "secs"))
R$sessao <- c(R = R.version.string, data = format(Sys.time(), "%Y-%m-%d %H:%M"))
saveRDS(R, "resultados_06.rds")
cat(sprintf("\nConcluido em %.1f s. Figuras em figuras/, resultados em resultados_06.rds\n",
            R$tempo_s))
