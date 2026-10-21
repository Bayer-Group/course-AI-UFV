# =============================================================================
#  PIPELINE DE SELECAO GENOMICA - versao "pronta para publicar"
#  Analista: assistente de IA
#  Pedido do melhorista: "estime GEBV e me diga a acuracia do modelo"
#
#  >>> ESTE SCRIPT RODA SEM ERRO E PRODUZ UM NUMERO BONITO. <<<
#  >>> O numero esta errado. Sua tarefa e descobrir por que.  <<<
#
#  Dado: simulado - o simulador esta embutido neste arquivo. O valor
#  genetico verdadeiro existe no objeto `g_verdadeiro` - em dado real
#  voce NAO teria isso.
#  Regra do desafio: voce NAO pode usar `g_verdadeiro` para corrigir o
#  pipeline. Ele serve apenas para, no fim, conferir quem estava certo.
# =============================================================================

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

# -----------------------------------------------------------------------------
# 1. POPULACAO: 600 linhagens de uma autogama, 1500 marcadores, h2 = 0,35
# -----------------------------------------------------------------------------
N_IND <- 600
N_SNP <- 1500
H2    <- 0.35

mapa    <- criar_mapa(n_snp = N_SNP, n_chr = 10)
chr_idx <- indices_cromossomo(mapa)
fund    <- simular_fundadores(n_ind = 100, mapa = mapa)
pop     <- cruzar_dh(fund,
                     pai = sample.int(100, 100, replace = TRUE),
                     mae = sample.int(100, 100, replace = TRUE),
                     n_prog = N_IND / 100, mapa = mapa, chr_idx = chr_idx)

Z <- dosagem(pop)
maf <- pmin(colMeans(Z) / 2, 1 - colMeans(Z) / 2)
Z <- Z[, maf >= 0.05, drop = FALSE]

arq          <- criar_arquitetura(n_snp = ncol(Z), n_qtl = 120)
g_verdadeiro <- valor_genetico(Z, arq)
fen          <- fenotipar(g_verdadeiro, h2 = H2)
y            <- fen$y
g_escala     <- fen$g

cat(sprintf("Populacao: %d linhagens, %d marcadores apos QC\n", nrow(Z), ncol(Z)))

# -----------------------------------------------------------------------------
# 2. PRE-SELECAO DE MARCADORES
#    "1200 marcadores e muito para 600 linhagens, entao mantemos os 300 mais
#     associados ao trait - isso reduz ruido e melhora a predicao."
# -----------------------------------------------------------------------------
assoc <- abs(cor(Z, y))
top300 <- order(assoc, decreasing = TRUE)[1:300]
Z_sel <- Z[, top300]

cat(sprintf("Pre-selecao: %d marcadores mantidos\n", ncol(Z_sel)))

# -----------------------------------------------------------------------------
# 3. PADRONIZACAO DO FENOTIPO
#    "deixa o trait em media 0 e desvio 1, o que estabiliza o ajuste."
# -----------------------------------------------------------------------------
y_pad <- as.numeric(scale(y))

# -----------------------------------------------------------------------------
# 4. MATRIZ DE PARENTESCO GENOMICO
# -----------------------------------------------------------------------------
G <- matriz_G(Z_sel)

cat(sprintf("Matriz G: %d x %d, diagonal media %.3f\n",
            nrow(G), ncol(G), mean(diag(G))))

# -----------------------------------------------------------------------------
# 5. TREINAMENTO E VALIDACAO
#    "usamos 30%% para treinar - uma amostra menor e suficiente e deixa mais
#     material para validar, o que torna a validacao mais confiavel."
# -----------------------------------------------------------------------------
PROP_TREINO <- 0.30
idx_treino <- sort(sample.int(nrow(Z), round(PROP_TREINO * nrow(Z))))
idx_valida <- setdiff(seq_len(nrow(Z)), idx_treino)

lambda <- (1 - H2) / H2
ajuste <- gblup(y_pad[idx_treino], idx_treino, G, lambda)
gebv   <- ajuste$gebv

# -----------------------------------------------------------------------------
# 6. ACURACIA DO MODELO
#    "correlacao entre GEBV e o fenotipo observado."
# -----------------------------------------------------------------------------
acuracia_modelo <- cor(gebv[idx_treino], y_pad[idx_treino])

cat("\n=========================================\n")
cat(sprintf(" ACURACIA DO MODELO: %.3f\n", acuracia_modelo))
cat("=========================================\n")
cat("\nConclusao do relatorio: a acuracia de predicao e alta, o modelo\n")
cat("esta validado e pode ser usado para selecionar a proxima geracao.\n")

# -----------------------------------------------------------------------------
# 7. GABARITO OCULTO - so rode esta parte DEPOIS de dar seu diagnostico.
#    `g_verdadeiro` nao existe em dado real; aqui ele revela a verdade.
# -----------------------------------------------------------------------------
# cat(sprintf("\nAcuracia de verdade (validacao, contra o valor genetico): %.3f\n",
#             cor(gebv[idx_valida], g_escala[idx_valida])))
