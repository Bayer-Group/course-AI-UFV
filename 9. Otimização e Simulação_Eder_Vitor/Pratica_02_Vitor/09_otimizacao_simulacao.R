# =============================================================================
#  ITEM 9 - OTIMIZACAO E SIMULACAO
#  Curso: IA no Melhoramento Genetico - UFV, novembro/2026
#
#  Tres perguntas, nesta ordem:
#    A) Como ganho e diversidade se movem ao longo de 5 ciclos de selecao.
#    B) OCS: maximizar ganho sujeito a um teto de endogamia por ciclo.
#    C) Alocacao: com o numero de genotipos FIXO e orcamento fixo de
#       parcelas, quantos locais e quantas repeticoes.
#
#  Script autocontido: o simulador esta embutido, em R base. Sem source().
#  Todos os dados sao simulados com semente fixa. Nenhum dado real.
#  Saida: figuras/*.png e resultados_09.rds (consumidos pelo .qmd).
# =============================================================================

t_inicio <- Sys.time()
set.seed(909)

# =============================================================================
#  PARAMETROS DO PROGRAMA
# -----------------------------------------------------------------------------
#  N_GEN e FIXO: o programa avalia sempre o mesmo numero de linhagens. Logo
#  a intensidade de selecao e CONSTANTE e sai da comparacao. O que varia e
#  so a qualidade da medicao - e e exatamente isso que o bloco C mede.
#
#  TETO_DF = 1% por ciclo. Nao e um numero arbitrario: cada cruzamento
#  tambem repoe cerca de 1% de variabilidade nova. Abaixo do teto a
#  endogamia e reposta; acima dele o programa consome o proprio capital.
# =============================================================================
N_GEN      <- 600      # linhagens avaliadas por ciclo (FIXO)
ORCAMENTO  <- 3600     # parcelas por ciclo  ->  L * R <= 6
N_CICLOS   <- 5
N_SEL      <- 60       # parentais recrutados por ciclo (10% de N_GEN)
N_POOL     <- 300      # candidatos oferecidos ao OCS (ver nota no motor)
TETO_DF    <- 0.01     # endogamia maxima por ciclo
H2_PARCELA <- 0.25     # herdabilidade na parcela individual
PROP_GXE   <- 0.40     # fracao da variancia genetica que e genotipo x ambiente

N_SNP  <- 800
N_FUND <- 60
N_QTL  <- 150

# =============================================================================
#  SIMULADOR  (embutido)
# -----------------------------------------------------------------------------
#  Especie modelo: autogama diploide, linhagens homozigotas (0/2).
#  Depende apenas do R base. So o que esta de fato em uso.
# =============================================================================

# Mapa genetico: posicoes em Morgans. Sem mapa nao existe recombinacao.
criar_mapa <- function(n_snp, n_chr = 10, tam_chr = 1.0) {
  por_chr <- rep(n_snp %/% n_chr, n_chr)
  por_chr[seq_len(n_snp %% n_chr)] <- por_chr[seq_len(n_snp %% n_chr)] + 1
  data.frame(snp = seq_len(n_snp), chr = rep(seq_len(n_chr), por_chr),
             pos = unlist(lapply(por_chr, function(k) sort(runif(k, 0, tam_chr)))),
             row.names = NULL)
}

indices_cromossomo <- function(mapa) split(seq_len(nrow(mapa)), mapa$chr)

# Fundadores homozigotos. Frequencia alelica de uma Beta: gera o espectro
# tipico de uma populacao de melhoramento (muitos marcadores raros).
simular_fundadores <- function(n_ind, mapa) {
  n_snp <- nrow(mapa)
  p <- pmin(pmax(rbeta(n_snp, 0.6, 0.6), 0.03), 0.97)
  hap <- matrix(rbinom(n_ind * n_snp, 1, rep(p, each = n_ind)), n_ind, n_snp)
  list(hap1 = hap, hap2 = hap, p0 = p)
}

# Meiose: numero de permutas por cromossomo e Poisson(tamanho em Morgans),
# posicoes uniformes - modelo de Haldane, sem interferencia.
gerar_gameta <- function(h1, h2, mapa, chr_idx) {
  origem <- integer(length(h1))
  for (cr in seq_along(chr_idx)) {
    idx <- chr_idx[[cr]]
    L   <- max(mapa$pos[idx])
    co  <- sort(runif(rpois(1, L), 0, L))
    seg <- findInterval(mapa$pos[idx], co)
    ini <- sample.int(2, 1)
    origem[idx] <- ifelse(seg %% 2 == 0, ini, 3L - ini)
  }
  ifelse(origem == 1L, h1, h2)
}

# Cruzamento + duplo-haploide: cada gameta e duplicado e vira linhagem nova.
cruzar_dh <- function(pop, pai, mae, n_prog, mapa, chr_idx) {
  n_snp  <- nrow(mapa)
  filhos <- matrix(0L, length(pai) * n_prog, n_snp)
  k <- 0L
  for (i in seq_along(pai)) {
    f1_h1 <- pop$hap1[pai[i], ]
    f1_h2 <- pop$hap1[mae[i], ]
    for (j in seq_len(n_prog)) {
      k <- k + 1L
      filhos[k, ] <- gerar_gameta(f1_h1, f1_h2, mapa, chr_idx)
    }
  }
  list(hap1 = filhos, hap2 = filhos, pai = rep(pai, each = n_prog))
}

dosagem <- function(pop) pop$hap1 + pop$hap2

criar_arquitetura <- function(n_snp, n_qtl) {
  qtl <- sort(sample.int(n_snp, n_qtl))
  list(qtl = qtl, efeito = rnorm(n_qtl, 0, 1))
}

# Em simulacao conhecemos a verdade - e so isso permite medir acuracia.
valor_genetico <- function(Z, arq) {
  as.numeric(Z[, arq$qtl, drop = FALSE] %*% arq$efeito)
}

# -----------------------------------------------------------------------------
#  FENOTIPAGEM MULTI-AMBIENTE  -  o coracao do bloco C
#   y_ijk = media + g_i + amb_j + (g x amb)_ij + residuo
#   A media de L locais x R repeticoes tem variancia de erro
#       Vge / L  +  Ve / (L * R)
#   Repeticao divide SO o residuo. Local divide o residuo E o GxE.
#   Dai sai tudo o que o bloco C conclui.
# -----------------------------------------------------------------------------
h2_da_media <- function(n_loc, n_rep, h2_parcela = H2_PARCELA,
                        prop_gxe = PROP_GXE) {
  vg  <- 1
  vge <- vg * prop_gxe / (1 - prop_gxe)
  ve  <- (vg + vge) * (1 - h2_parcela) / h2_parcela
  vg / (vg + vge / n_loc + ve / (n_loc * n_rep))
}

# Media fenotipica observada por linhagem, dado L e R.
fenotipar_media <- function(g, n_loc, n_rep, h2_parcela = H2_PARCELA,
                            prop_gxe = PROP_GXE) {
  n   <- length(g)
  gi  <- as.numeric(scale(g))
  vge <- prop_gxe / (1 - prop_gxe)
  ve  <- (1 + vge) * (1 - h2_parcela) / h2_parcela
  # Desvios padronizados primeiro, escala depois: com a mesma semente, dois
  # cenarios sorteiam os MESMOS z e diferem so pelo quanto o erro e dividido.
  z <- rnorm(n)
  erro <- z * sqrt(vge / n_loc + ve / (n_loc * n_rep))
  list(y = gi + erro, g = gi, h2 = h2_da_media(n_loc, n_rep, h2_parcela, prop_gxe))
}

# Matriz de parentesco genomica (VanRaden 2008, metodo 1). Substitui o
# pedigree: parentesco medido, nao presumido. O blend garante inversa.
matriz_G <- function(Z, p = NULL, blend = 0.02) {
  if (is.null(p)) p <- colMeans(Z) / 2
  p  <- pmin(pmax(p, 1e-6), 1 - 1e-6)
  Zc <- sweep(Z, 2, 2 * p, "-")
  G  <- tcrossprod(Zc) / (2 * sum(p * (1 - p)))
  (1 - blend) * G + blend * diag(nrow(G))
}

# GBLUP pelas equacoes do modelo misto. Aqui todas as linhagens tem
# fenotipo (media de L x R), entao a solucao e direta.
gblup_completo <- function(y, G, lambda) {
  n   <- nrow(G)
  lhs <- solve(G) * lambda + diag(n)
  mu  <- mean(y)
  as.numeric(solve(lhs, y - mu))
}

# Coancestria media: f = c' A c, com A = G/2. Em OCS e o termo que segura
# a perda de diversidade.
coancestria_media <- function(G, idx, pesos = NULL) {
  A  <- G[idx, idx, drop = FALSE] / 2
  c_ <- if (is.null(pesos)) rep(1 / length(idx), length(idx)) else pesos / sum(pesos)
  as.numeric(crossprod(c_, A %*% c_))
}

# =============================================================================
#  OCS - OPTIMUM CONTRIBUTION SELECTION
# -----------------------------------------------------------------------------
#      maximiza   c' gebv            (ganho esperado)
#      sujeito a  c' A c <= f        (parentesco medio limitado)
#                 sum(c) = 1, c >= 0
#
#  Sem a restricao a solucao e trivial e ruim: todo o peso no melhor
#  individuo. A restricao e o que transforma selecao em otimizacao.
#  Algoritmo genetico proprio, em R base: populacao de solucoes, as
#  melhores se reproduzem, mutacao introduz novidade.
# =============================================================================
ocs_ga <- function(gebv, G, max_coancestria, n_max = 60,
                   n_pop = 80, n_ger = 60, taxa_mut = 0.15) {
  n  <- length(gebv)
  A  <- G / 2
  gz <- as.numeric(scale(gebv))

  # Violacao e penalizada, nao proibida: deixa o AG atravessar regiao
  # inviavel e voltar, o que acelera a busca.
  aptidao <- function(c_) {
    sum(c_ * gz) - max(0, as.numeric(crossprod(c_, A %*% c_)) - max_coancestria) * 500
  }
  nova <- function() {
    v <- numeric(n); k <- sample(seq_len(n), min(n_max, n))
    v[k] <- runif(length(k)); v / sum(v)
  }

  pop <- replicate(n_pop, nova(), simplify = FALSE)
  traj <- numeric(n_ger); melhor <- NULL
  n_elite <- max(2, round(0.2 * n_pop))

  for (ger in seq_len(n_ger)) {
    apt <- vapply(pop, aptidao, numeric(1))
    ord <- order(apt, decreasing = TRUE)
    pop <- pop[ord]; melhor <- pop[[1]]; traj[ger] <- apt[ord[1]]
    filhos <- vector("list", n_pop - n_elite)
    for (i in seq_along(filhos)) {
      p1 <- pop[[sample.int(n_elite, 1)]]
      p2 <- pop[[sample.int(n_pop %/% 2, 1)]]
      f  <- ifelse(runif(n) < 0.5, p1, p2)
      if (runif(1) < taxa_mut) {
        j <- sample.int(n, max(1, round(0.1 * n)))
        f[j] <- pmax(0, f[j] + rnorm(length(j), 0, 0.05))
      }
      if (sum(f > 0) > n_max) f[-order(f, decreasing = TRUE)[seq_len(n_max)]] <- 0
      s <- sum(f); filhos[[i]] <- if (s > 0) f / s else nova()
    }
    pop <- c(pop[seq_len(n_elite)], filhos)
  }
  ativos <- which(melhor > 1e-4)
  list(sel = ativos, pesos = melhor[ativos],
       ganho = sum(melhor * gz),
       coancestria = as.numeric(crossprod(melhor, A %*% melhor)),
       trajetoria = traj)
}

# Menor parentesco alcancavel com estes candidatos. Pedir abaixo do piso
# e pedir o impossivel - e um otimizador mal diagnosticado devolve lixo
# em silencio. Gradiente projetado no simplex.
piso_coancestria <- function(G, n_iter = 1500, passo = 0.02) {
  A <- G / 2; n <- nrow(A); c_ <- rep(1 / n, n)
  for (i in seq_len(n_iter)) {
    gr <- 2 * as.numeric(A %*% c_)
    c_ <- c_ - passo * (gr - mean(gr))
    c_[c_ < 0] <- 0; c_ <- c_ / sum(c_)
  }
  list(piso = as.numeric(crossprod(c_, A %*% c_)), n_ativos = sum(c_ > 1e-4))
}

# =============================================================================
#  GRAFICOS
# =============================================================================
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop('Pacote ggplot2 faltando. Instale com:\n',
       '  install.packages("ggplot2", repos = "https://packagemanager.posit.co/cran/2026-09-01")',
       call. = FALSE)
}
suppressMessages(library(ggplot2))

dir.create("figuras", showWarnings = FALSE)
TEMA <- theme_minimal(base_size = 13) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(colour = "grey35"))
png_salvar <- function(p, arq, w = 9, h = 5.2) {
  ggsave(file.path("figuras", arq), p, width = w, height = h, dpi = 150)
}
COR <- c(azul = "#2C6E9B", laranja = "#D08C3C", verde = "#4E8E6B",
         vinho = "#9B4A5A", cinza = "#6E7375")

R <- list(parametros = list(n_gen = N_GEN, orcamento = ORCAMENTO,
                           n_ciclos = N_CICLOS, n_sel = N_SEL,
                           teto_df = TETO_DF, h2_parcela = H2_PARCELA,
                           prop_gxe = PROP_GXE, n_pool = N_POOL,
                           lr_max = ORCAMENTO / N_GEN))

# =============================================================================
#  MOTOR DE CICLOS
# -----------------------------------------------------------------------------
#  Um programa e recorrente: avalia, seleciona, cruza, repete. Simular o
#  processo inteiro - e nao um ciclo isolado - mostra o que nenhuma analise
#  de ciclo unico mostra: o ganho desacelera porque a selecao consome a
#  propria variabilidade que a alimenta.
#
#  A restricao do OCS segue a recursao de Wright  f_t = f_{t-1} + dF(1-f_{t-1}),
#  uma trajetoria ABSOLUTA. Restringir contra o piso do proprio ciclo nao
#  restringe nada: o piso sobe junto e a restricao acompanha.
# =============================================================================
simular <- function(estrategia, n_loc = 6, n_rep = 1, delta_f = TETO_DF,
                    n_ciclos = N_CICLOS, semente = 1) {
  set.seed(semente)
  mapa <- criar_mapa(N_SNP); chri <- indices_cromossomo(mapa)
  fund <- simular_fundadores(N_FUND, mapa)
  arq  <- criar_arquitetura(N_SNP, N_QTL)
  n_cruz <- N_GEN / 10
  pop <- cruzar_dh(fund, pai = sample.int(N_FUND, n_cruz, replace = TRUE),
                   mae = sample.int(N_FUND, n_cruz, replace = TRUE),
                   n_prog = 10, mapa = mapa, chr_idx = chri)

  hist <- data.frame(); f_alvo <- NA_real_; sd0 <- NA_real_; manda <- character()
  for (ciclo in seq_len(n_ciclos)) {
    Z <- dosagem(pop)
    g <- valor_genetico(Z, arq)
    if (is.na(sd0)) sd0 <- sd(g)
    G <- matriz_G(Z, p = fund$p0)       # p0 fixo: endogamia na base original

    # Numeros aleatorios comuns: a semente do ciclo nao depende de L, de R
    # nem de delta_f. Dois cenarios com a mesma semente sorteiam os MESMOS
    # desvios - muda so a escala do erro. Assim a diferenca entre eles e a
    # decisao de alocacao, nao o sorteio. Sem isto, o ruido entre cenarios
    # vizinhos e maior que o efeito e a comparacao nao conclui nada.
    set.seed(semente * 1000L + ciclo)
    fe <- fenotipar_media(g, n_loc, n_rep)
    gebv <- gblup_completo(fe$y, G, (1 - fe$h2) / fe$h2)

    hist <- rbind(hist, data.frame(
      ciclo = ciclo, estrategia = estrategia,
      media_gen = (mean(g) - 0) / sd0,
      sd_gen = sd(g) / sd0,
      coancestria = coancestria_media(G, seq_len(nrow(G))),
      acuracia = cor(gebv, g), h2_media = fe$h2))

    if (estrategia == "sem selecao") {
      sel <- sample.int(nrow(Z), N_SEL); pesos <- rep(1, N_SEL)
    } else if (estrategia == "truncamento") {
      sel <- order(gebv, decreasing = TRUE)[seq_len(N_SEL)]; pesos <- rep(1, N_SEL)
    } else {
      # Pool de candidatos amplo DE PROPOSITO. Com pool estreito o menor
      # parentesco alcancavel (o piso) fica ACIMA do alvo dos tetos baixos:
      # a restricao que manda passa a ser o piso, nao o teto escolhido, e
      # tetos diferentes devolvem exatamente o mesmo resultado. Medido neste
      # dado: pool 150 -> piso 0,0298; pool 300 -> piso 0,0195.
      cand <- order(gebv, decreasing = TRUE)[seq_len(min(N_POOL, nrow(Z)))]
      f_at <- coancestria_media(G, seq_len(nrow(G)))
      if (is.na(f_alvo)) f_alvo <- f_at
      f_alvo <- f_alvo + delta_f * (1 - f_alvo)
      pc <- piso_coancestria(G[cand, cand], n_iter = 400)
      # Qual restricao de fato manda neste ciclo: o teto pedido ou o piso?
      manda <- c(manda, if (f_alvo >= pc$piso * 1.01) "teto" else "piso")
      oc <- ocs_ga(gebv[cand], G[cand, cand],
                   max_coancestria = max(f_alvo, pc$piso * 1.01))
      sel <- cand[oc$sel]; pesos <- oc$pesos
    }
    pop <- cruzar_dh(pop, pai = sample(sel, n_cruz, TRUE, pesos),
                     mae = sample(sel, n_cruz, TRUE, pesos),
                     n_prog = 10, mapa = mapa, chr_idx = chri)
  }
  # Ganho = quanto a media andou do ciclo 1 ao ultimo, em desvios geneticos
  attr(hist, "ganho") <- hist$media_gen[n_ciclos] - hist$media_gen[1]
  attr(hist, "restricao_ativa") <- manda
  hist
}

# =============================================================================
#  BLOCO A - CINCO CICLOS, TRES ESTRATEGIAS
# =============================================================================
cat("\n== BLOCO A: ciclos ==\n")
ESTRAT <- c("sem selecao", "truncamento", "ocs")
ciclos <- do.call(rbind, lapply(ESTRAT, function(e) {
  cat("  ", e, "\n")
  do.call(rbind, lapply(1:4, function(s) {
    h <- simular(e, semente = 100 + s); h$rep <- s; h
  }))
}))
cic <- aggregate(cbind(media_gen, sd_gen, coancestria, acuracia) ~ ciclo + estrategia,
                 ciclos, mean)
cic$rotulo <- factor(cic$estrategia, levels = ESTRAT,
                     labels = c("Sem selecao (controle)",
                                "Truncamento (60 melhores)",
                                sprintf("OCS (teto %.0f%%/ciclo)", 100 * TETO_DF)))
R$ciclos <- cic
print(cic[cic$ciclo == N_CICLOS, c("rotulo", "media_gen", "sd_gen", "coancestria")])

p1 <- ggplot(cic, aes(ciclo, media_gen, colour = rotulo)) +
  geom_line(linewidth = 1.1) + geom_point(size = 2.4) +
  scale_colour_manual(values = unname(COR[c("cinza", "vinho", "azul")])) +
  scale_x_continuous(breaks = 1:N_CICLOS) +
  labs(title = "Ganho genetico ao longo de 5 ciclos",
       subtitle = "Media da populacao, em desvios-padrao geneticos do ciclo 1",
       x = "Ciclo", y = "Media genetica", colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p1, "01_ganho_ciclos.png")

p2 <- ggplot(cic, aes(ciclo, sd_gen, colour = rotulo)) +
  geom_line(linewidth = 1.1) + geom_point(size = 2.4) +
  scale_colour_manual(values = unname(COR[c("cinza", "vinho", "azul")])) +
  scale_x_continuous(breaks = 1:N_CICLOS) +
  labs(title = "A variabilidade que alimenta o ganho",
       subtitle = "Desvio-padrao genetico da populacao, relativo ao ciclo 1",
       x = "Ciclo", y = "Desvio-padrao genetico", colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p2, "02_diversidade_ciclos.png")

# =============================================================================
#  BLOCO B - OCS E O TETO DE 1% POR CICLO
# -----------------------------------------------------------------------------
#  Mais endogamia sempre rende mais ganho: a restricao e o que custa. Logo
#  a pergunta nao e "quanto ganho quero" - e "quanto posso gastar sem
#  descapitalizar". O cruzamento repoe cerca de 1% por ciclo; e esse o teto.
# =============================================================================
cat("\n== BLOCO B: OCS ==\n")
DFS <- c(0.0025, 0.005, 0.0075, 0.010, 0.015, 0.020)
SEM_DF <- 71:76        # as mesmas replicas pareadas para todo delta_f
pareto <- do.call(rbind, lapply(DFS, function(df) {
  rr <- lapply(SEM_DF, function(s) simular("ocs", delta_f = df, semente = s))
  g  <- vapply(rr, function(h) attr(h, "ganho"), numeric(1))
  # fracao dos ciclos em que o TETO mandou (e nao o piso do pool)
  pt <- mean(unlist(lapply(rr, function(h) attr(h, "restricao_ativa") == "teto")))
  data.frame(delta_f = df, ganho = mean(g), erro_padrao = sd(g) / sqrt(length(g)),
             sd_final = mean(vapply(rr, function(h) h$sd_gen[N_CICLOS], numeric(1))),
             coancestria = mean(vapply(rr, function(h) h$coancestria[N_CICLOS], numeric(1))),
             teto_manda = pt, dentro_teto = df <= TETO_DF)
}))
R$pareto <- pareto
print(pareto)

p3 <- ggplot(pareto, aes(100 * delta_f, ganho)) +
  geom_vline(xintercept = 100 * TETO_DF, linetype = "dashed",
             colour = COR["vinho"], linewidth = 0.9) +
  annotate("text", x = 100 * TETO_DF, y = min(pareto$ganho),
           label = "  teto: 1% por ciclo\n  e o que o cruzamento repoe",
           hjust = 0, vjust = 0, size = 3.8, colour = COR["vinho"],
           lineheight = 0.95) +
  geom_line(colour = COR["azul"], linewidth = 1) +
  geom_point(aes(shape = dentro_teto), size = 3.6, colour = COR["azul"]) +
  scale_shape_manual(values = c(`TRUE` = 16, `FALSE` = 4), guide = "none") +
  labs(title = "Ganho cresce com a endogamia autorizada - e esse e o problema",
       subtitle = "Cada ponto: 5 ciclos de OCS com um teto diferente. X = acima do teto sustentavel",
       x = "Endogamia autorizada por ciclo (%)",
       y = "Ganho em 5 ciclos (desvios geneticos)") + TEMA
png_salvar(p3, "03_teto_endogamia.png")

# =============================================================================
#  BLOCO C - ALOCACAO: QUANTOS LOCAIS, QUANTAS REPETICOES
# -----------------------------------------------------------------------------
#  N_GEN e fixo, logo a intensidade de selecao e constante e nao entra na
#  comparacao. Com orcamento de ORCAMENTO parcelas,  L * R <= ORCAMENTO/N_GEN.
#
#  O resultado nao depende de calibracao - esta na algebra:
#      h2_media = Vg / (Vg + Vge/L + Ve/(L*R))
#  Repeticao divide so Ve. Local divide Ve E Vge. Para o MESMO produto
#  L*R, mais locais sempre entrega h2 maior. Logo mais locais, menos
#  repeticoes - e a repeticao so paga quando L ja esgotou o orcamento.
# =============================================================================
cat("\n== BLOCO C: alocacao ==\n")
LR_MAX <- ORCAMENTO / N_GEN

# Grade analitica: todas as combinacoes que cabem no orcamento
grade <- expand.grid(n_loc = 1:LR_MAX, n_rep = 1:LR_MAX)
grade <- grade[grade$n_loc * grade$n_rep <= LR_MAX, ]
grade$parcelas <- N_GEN * grade$n_loc * grade$n_rep
grade$h2_media <- mapply(h2_da_media, grade$n_loc, grade$n_rep)
grade$acuracia_teorica <- sqrt(grade$h2_media)
grade <- grade[order(-grade$h2_media), ]
R$grade <- grade
cat("Grade analitica (topo 6):\n"); print(head(grade, 6), row.names = FALSE)

# As combinacoes que gastam o orcamento INTEIRO: mesmo custo, 4 escolhas
fronteira <- grade[grade$n_loc * grade$n_rep == LR_MAX, ]
R$fronteira <- fronteira
cat("\nMesmo custo (L x R = ", LR_MAX, "), escolhas diferentes:\n", sep = "")
print(fronteira[, c("n_loc", "n_rep", "h2_media")], row.names = FALSE)

# Confirmacao por simulacao: as 4 celulas de mesmo custo, 5 ciclos.
# SEMENTES comuns as quatro celulas: cada semente e uma replica pareada.
cat("\nSimulando as combinacoes de mesmo custo...\n")
SEMENTES <- 301:320
aloc <- do.call(rbind, lapply(seq_len(nrow(fronteira)), function(i) {
  L <- fronteira$n_loc[i]; Rp <- fronteira$n_rep[i]
  rr <- lapply(SEMENTES, function(s)
    simular("truncamento", n_loc = L, n_rep = Rp, semente = s))
  g  <- vapply(rr, function(h) attr(h, "ganho"), numeric(1))
  ac <- vapply(rr, function(h) mean(h$acuracia), numeric(1))
  data.frame(n_loc = L, n_rep = Rp, h2_media = fronteira$h2_media[i],
             acuracia = mean(ac), ganho = mean(g),
             erro_padrao = sd(g) / sqrt(length(g)),
             semente = SEMENTES, ganho_i = g)
}))
# Teste pareado contra a melhor celula da algebra: mesma semente, duas escolhas
ref <- fronteira[which.max(fronteira$h2_media), ]
base_g <- aloc$ganho_i[aloc$n_loc == ref$n_loc & aloc$n_rep == ref$n_rep]
alo <- unique(aloc[, c("n_loc", "n_rep", "h2_media", "acuracia", "ganho", "erro_padrao")])
alo$dif_pareada <- vapply(seq_len(nrow(alo)), function(i) {
  gi <- aloc$ganho_i[aloc$n_loc == alo$n_loc[i] & aloc$n_rep == alo$n_rep[i]]
  mean(gi - base_g)
}, numeric(1))
alo$p_pareado <- vapply(seq_len(nrow(alo)), function(i) {
  gi <- aloc$ganho_i[aloc$n_loc == alo$n_loc[i] & aloc$n_rep == alo$n_rep[i]]
  d <- gi - base_g
  if (sd(d) < 1e-12) NA_real_ else t.test(d)$p.value
}, numeric(1))
aloc <- alo[order(-alo$ganho), ]
R$alocacao <- aloc
R$alocacao_replicas <- SEMENTES
print(aloc, row.names = FALSE)
R$melhor <- aloc[1, ]; R$pior <- aloc[nrow(aloc), ]
cat(sprintf("\nMelhor: %d locais x %d rep -> ganho %.3f | Pior: %d x %d -> %.3f (%.0f%% menos)\n",
            R$melhor$n_loc, R$melhor$n_rep, R$melhor$ganho,
            R$pior$n_loc, R$pior$n_rep, R$pior$ganho,
            100 * (1 - R$pior$ganho / R$melhor$ganho)))

# FIGURA: a algebra, antes de qualquer simulacao
curva <- expand.grid(n_loc = 1:12, n_rep = 1:3)
curva$h2 <- mapply(h2_da_media, curva$n_loc, curva$n_rep)
curva$rep_rot <- factor(curva$n_rep,
                        labels = c("1 repeticao", "2 repeticoes", "3 repeticoes"))
p4 <- ggplot(curva, aes(n_loc, h2, colour = rep_rot)) +
  geom_line(linewidth = 1.1) + geom_point(size = 2) +
  scale_colour_manual(values = unname(COR[c("azul", "laranja", "verde")])) +
  scale_x_continuous(breaks = seq(2, 12, 2)) +
  labs(title = "Local e repeticao nao sao intercambiaveis",
       subtitle = paste("Repeticao divide so o erro residual;",
                        "local divide o erro e tambem a interacao genotipo x ambiente"),
       x = "Numero de locais", y = "Herdabilidade da media",
       colour = NULL) + TEMA + theme(legend.position = "top")
png_salvar(p4, "04_h2_loc_rep.png")

# FIGURA: mesmo custo, resultados diferentes
fr <- fronteira
fr$rot <- sprintf("%d loc x %d rep", fr$n_loc, fr$n_rep)
fr$rot <- factor(fr$rot, levels = fr$rot[order(fr$h2_media)])
p5 <- ggplot(fr, aes(rot, h2_media)) +
  geom_col(fill = COR["azul"], width = 0.65) +
  geom_text(aes(label = sprintf("%.3f", h2_media)), vjust = -0.5, size = 4.4) +
  ylim(0, max(fr$h2_media) * 1.18) +
  labs(title = sprintf("Quatro formas de gastar as mesmas %s parcelas",
                       format(ORCAMENTO, big.mark = ".")),
       subtitle = sprintf("%s genotipos fixos; L x R = %d em todas as barras",
                          format(N_GEN, big.mark = "."), LR_MAX),
       x = NULL, y = "Herdabilidade da media") + TEMA
png_salvar(p5, "05_mesmo_custo.png", h = 4.8)

saveRDS(R, "resultados_09.rds")

# -----------------------------------------------------------------------------
#  Numeros do gabarito do instrutor, em JSON. Nenhum numero do gabarito e
#  digitado a mao: todos saem daqui. JSON escrito em R base, sem jsonlite.
# -----------------------------------------------------------------------------
j_num <- function(x, d = 6) formatC(x, format = "f", digits = d)
j_obj <- function(...) paste0("{", paste(c(...), collapse = ","), "}")
j_f <- function(k, v) paste0('"', k, '":', j_num(v))
j_i <- function(k, v) paste0('"', k, '":', as.integer(v))
j_b <- function(k, v) paste0('"', k, '":', if (isTRUE(v)) "true" else "false")

lin_aloc <- vapply(seq_len(nrow(aloc)), function(i) j_obj(
  j_i("n_loc", aloc$n_loc[i]), j_i("n_rep", aloc$n_rep[i]),
  j_f("h2_media", aloc$h2_media[i]), j_f("acuracia", aloc$acuracia[i]),
  j_f("ganho", aloc$ganho[i]), j_f("erro_padrao", aloc$erro_padrao[i]),
  j_f("dif_pareada", aloc$dif_pareada[i]),
  paste0('"p_pareado":', if (is.na(aloc$p_pareado[i])) "null"
                         else j_num(aloc$p_pareado[i]))), character(1))

lin_par <- vapply(seq_len(nrow(pareto)), function(i) j_obj(
  j_f("delta_f", pareto$delta_f[i]), j_f("ganho", pareto$ganho[i]),
  j_f("erro_padrao", pareto$erro_padrao[i]), j_f("sd_final", pareto$sd_final[i]),
  j_f("coancestria", pareto$coancestria[i]),
  j_f("teto_manda", pareto$teto_manda[i]),
  j_b("dentro_teto", pareto$dentro_teto[i])), character(1))

writeLines(j_obj(
  j_i("n_gen", N_GEN), j_i("orcamento", ORCAMENTO), j_i("n_ciclos", N_CICLOS),
  j_i("n_sel", N_SEL), j_i("lr_max", LR_MAX), j_f("teto_df", TETO_DF),
  j_f("h2_parcela", H2_PARCELA), j_f("prop_gxe", PROP_GXE),
  j_i("n_replicas", length(SEMENTES)),
  paste0('"melhor":', j_obj(j_i("n_loc", R$melhor$n_loc),
                            j_i("n_rep", R$melhor$n_rep),
                            j_f("ganho", R$melhor$ganho),
                            j_f("h2_media", R$melhor$h2_media),
                            j_f("acuracia", R$melhor$acuracia))),
  paste0('"pior":', j_obj(j_i("n_loc", R$pior$n_loc),
                          j_i("n_rep", R$pior$n_rep),
                          j_f("ganho", R$pior$ganho))),
  j_f("perda_pct", 100 * (1 - R$pior$ganho / R$melhor$ganho)),
  paste0('"alocacao":[', paste(lin_aloc, collapse = ","), "]"),
  paste0('"pareto":[', paste(lin_par, collapse = ","), "]")
), "gab09_numeros.json")

cat(sprintf("\nConcluido em %.1f s. Figuras em figuras/, resultados em resultados_09.rds\n",
            as.numeric(difftime(Sys.time(), t_inicio, units = "secs"))))
