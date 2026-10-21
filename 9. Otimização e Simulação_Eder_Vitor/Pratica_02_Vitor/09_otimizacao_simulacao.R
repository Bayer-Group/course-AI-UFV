# =============================================================================
#  ITEM 9 - OTIMIZACAO E SIMULACAO
#  Curso: IA no Melhoramento Genetico - UFV, novembro/2026
#
#  Tres blocos:
#    A) Simulacao de ciclos: o que acontece com ganho e diversidade ao longo
#       de 10 geracoes de selecao.
#    B) OCS (Optimum Contribution Selection): escolher contribuicoes de
#       parentais otimizando ganho sujeito a restricao de parentesco.
#       Implementado de duas formas - algoritmo genetico proprio em R base
#       e o pacote publico optiSel - para mostrar que dao o mesmo resultado.
#    C) Alocacao de recursos: quantos locais, quantas repeticoes, quantos
#       genotipos, dado um orcamento fixo de parcelas.
#
#  Todos os dados sao simulados: o simulador esta embutido neste arquivo.
#  Saida: figuras/*.png e resultados_09.rds (consumidos pelo .qmd).
# =============================================================================

t_inicio <- Sys.time()
set.seed(909)

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
R <- list()

# =============================================================================
#  BLOCO A - SIMULACAO DE CICLOS DE MELHORAMENTO
# -----------------------------------------------------------------------------
#  Um programa de melhoramento e um processo recorrente: avalia, seleciona,
#  cruza, repete. Simular o processo inteiro - e nao um ciclo isolado -
#  revela um comportamento que nenhuma analise de ciclo unico mostra:
#  o ganho desacelera porque a propria selecao consome a variabilidade.
# =============================================================================

MAPA  <- criar_mapa(n_snp = 1200, n_chr = 10)
CHRI  <- indices_cromossomo(MAPA)
N_FUND <- 80
H2     <- 0.30
N_POP  <- 400            # linhagens avaliadas por ciclo
N_CICLOS <- 10

# -----------------------------------------------------------------------------
# Motor de simulacao de ciclos.
#  `estrategia` define QUEM e cruzado a cada geracao:
#    "truncamento"  - os n_sel melhores por GEBV (a pratica usual)
#    "aleatoria"    - controle: sem selecao, so deriva
#    "ocs"          - contribuicoes otimizadas (bloco B)
# -----------------------------------------------------------------------------
# `delta_f` = taxa de endogamia ALVO por ciclo. A restricao do OCS segue a
# recursao classica  f_t = f_{t-1} + dF * (1 - f_{t-1}), ou seja uma
# TRAJETORIA absoluta definida de antemao. Restringir em relacao ao piso do
# proprio ciclo nao funciona: o piso sobe junto com a endogamia, a restricao
# acompanha e deixa de restringir - erro que a primeira versao deste script
# cometeu e que so apareceu porque a figura mostrou o OCS perdendo MAIS
# diversidade que o truncamento.
simular_programa <- function(estrategia = "truncamento", n_ciclos = N_CICLOS,
                             n_sel = 40, delta_f = 0.015, semente = 1) {
  set.seed(semente)
  fund <- simular_fundadores(n_ind = N_FUND, mapa = MAPA)
  arq  <- criar_arquitetura(n_snp = nrow(MAPA), n_qtl = 150)

  # Geracao 0: cruzamentos aleatorios entre fundadores
  pop <- cruzar_dh(fund,
                   pai = sample.int(N_FUND, N_POP / 5, replace = TRUE),
                   mae = sample.int(N_FUND, N_POP / 5, replace = TRUE),
                   n_prog = 5, mapa = MAPA, chr_idx = CHRI)

  hist <- data.frame()
  f_alvo <- NA_real_          # trajetoria de endogamia permitida ao OCS
  for (ciclo in seq_len(n_ciclos)) {
    Z  <- dosagem(pop)
    g  <- valor_genetico(Z, arq)
    fe <- fenotipar(g, h2 = H2)
    G  <- matriz_G(Z, p = fund$p0)      # p0 fixo: endogamia na base original

    # Predicao: metade da populacao e fenotipada, o resto recebe GEBV
    idx_ts <- sample.int(nrow(Z), round(0.5 * nrow(Z)))
    fit <- gblup(fe$y[idx_ts], idx_ts, G, (1 - H2) / H2)
    gebv <- fit$gebv

    # Metricas do ciclo: o ganho e a diversidade, sempre juntos
    hist <- rbind(hist, data.frame(
      ciclo = ciclo,
      estrategia = estrategia,
      media_gen = mean(g),
      sd_gen = sd(g),
      coancestria = coancestria_media(G, seq_len(nrow(G))),
      het_esperada = mean(2 * (colMeans(Z) / 2) * (1 - colMeans(Z) / 2)),
      acuracia = cor(gebv, g)
    ))

    # Quem contribui para a proxima geracao
    if (estrategia == "aleatoria") {
      sel <- sample.int(nrow(Z), n_sel)
      pesos <- rep(1 / n_sel, n_sel)
    } else if (estrategia == "truncamento") {
      sel <- order(gebv, decreasing = TRUE)[seq_len(n_sel)]
      pesos <- rep(1 / n_sel, n_sel)
    } else {                              # OCS
      cand <- order(gebv, decreasing = TRUE)[seq_len(min(200, nrow(Z)))]
      f_atual <- coancestria_media(G, seq_len(nrow(G)))
      if (is.na(f_alvo)) f_alvo <- f_atual
      f_alvo <- f_alvo + delta_f * (1 - f_alvo)   # recursao de Wright
      # O piso do ciclo define apenas a VIABILIDADE: se o alvo da trajetoria
      # ja esta abaixo do minimo alcancavel, a restricao e inviavel e usamos
      # o piso (declarando a violacao), em vez de devolver solucao silenciosa.
      pc_ <- piso_coancestria(G[cand, cand], n_iter = 600)
      limite <- max(f_alvo, pc_$piso * 1.01)
      # n_max maior que no truncamento de proposito: espalhar a contribuicao
      # por mais parentais, com pesos desiguais, E o mecanismo do OCS.
      oc <- ocs_ga(gebv[cand], G[cand, cand], max_coancestria = limite,
                   n_max = 2 * n_sel, n_ger = 80, verbose = FALSE)
      sel   <- cand[oc$sel]
      pesos <- oc$pesos
    }

    # Cruzamentos proporcionais as contribuicoes
    n_cruz <- N_POP / 5
    pais <- sample(sel, n_cruz, replace = TRUE, prob = pesos)
    maes <- sample(sel, n_cruz, replace = TRUE, prob = pesos)
    pop <- cruzar_dh(pop, pai = pais, mae = maes, n_prog = 5,
                     mapa = MAPA, chr_idx = CHRI)
  }
  hist
}

# =============================================================================
#  BLOCO B - OCS: OPTIMUM CONTRIBUTION SELECTION
# -----------------------------------------------------------------------------
#  O problema: escolher o vetor de contribuicoes c (quanto cada candidato
#  contribui para a proxima geracao) que
#
#      maximiza   c' * gebv            (ganho esperado)
#      sujeito a  c' * A * c / 2 <= f  (parentesco medio limitado)
#                 sum(c) = 1, c >= 0
#
#  Sem a restricao, a solucao e trivial e ruim: todo peso no melhor
#  individuo. A restricao e o que transforma a selecao num problema de
#  otimizacao de verdade.
#
#  Implementacao 1: algoritmo genetico proprio, em R base. ~50 linhas.
#  A ideia do AG e a mesma da selecao natural: populacao de solucoes
#  candidatas, as melhores se reproduzem, mutacao introduz novidade.
# =============================================================================

ocs_ga <- function(gebv, G, max_coancestria, n_max = 40,
                   n_pop = 120, n_ger = 150, taxa_mut = 0.15,
                   verbose = TRUE) {
  n <- length(gebv)
  A <- G / 2
  gz <- as.numeric(scale(gebv))

  # Uma solucao e um vetor de pesos nao-negativos que soma 1.
  # Penalizamos violacao da restricao em vez de proibi-la: deixa o AG
  # transitar por regioes inviaveis e voltar, o que acelera a busca.
  aptidao <- function(c_) {
    ganho <- sum(c_ * gz)
    coanc <- as.numeric(crossprod(c_, A %*% c_))
    pen <- max(0, coanc - max_coancestria) * 500
    ganho - pen
  }

  nova_solucao <- function() {
    v <- numeric(n)
    k <- sample(seq_len(n), min(n_max, n))
    v[k] <- runif(length(k))
    v / sum(v)
  }

  pop <- replicate(n_pop, nova_solucao(), simplify = FALSE)
  melhor <- NULL
  traj <- numeric(n_ger)

  for (ger in seq_len(n_ger)) {
    apt <- vapply(pop, aptidao, numeric(1))
    ord <- order(apt, decreasing = TRUE)
    pop <- pop[ord]
    apt <- apt[ord]
    melhor <- pop[[1]]
    traj[ger] <- apt[1]

    # Elite passa intacta; o resto vem de recombinacao + mutacao
    n_elite <- max(2, round(0.2 * n_pop))
    filhos <- vector("list", n_pop - n_elite)
    for (i in seq_along(filhos)) {
      p1 <- pop[[sample.int(n_elite, 1)]]
      p2 <- pop[[sample.int(n_pop %/% 2, 1)]]
      msk <- runif(n) < 0.5
      f <- ifelse(msk, p1, p2)                    # recombinacao uniforme
      if (runif(1) < taxa_mut) {                  # mutacao: realoca peso
        j <- sample.int(n, max(1, round(0.1 * n)))
        f[j] <- pmax(0, f[j] + rnorm(length(j), 0, 0.05))
      }
      # Trunca para no maximo n_max contribuintes
      if (sum(f > 0) > n_max) {
        manter <- order(f, decreasing = TRUE)[seq_len(n_max)]
        f[-manter] <- 0
      }
      s <- sum(f)
      filhos[[i]] <- if (s > 0) f / s else nova_solucao()
    }
    pop <- c(pop[seq_len(n_elite)], filhos)
    if (verbose && ger %% 50 == 0) {
      cat(sprintf("  AG geracao %3d | aptidao %.4f\n", ger, apt[1]))
    }
  }

  ativos <- which(melhor > 1e-4)
  list(sel = ativos, pesos = melhor[ativos],
       ganho = sum(melhor * gz),
       coancestria = as.numeric(crossprod(melhor, A %*% melhor)),
       trajetoria = traj)
}

# -----------------------------------------------------------------------------
# PISO DE COANCESTRIA - viabilidade da restricao
#  Antes de pedir "parentesco menor que f", precisamos saber qual o MENOR
#  parentesco alcancavel com estes candidatos. Pedir abaixo do piso produz
#  um problema inviavel, e um otimizador mal diagnosticado devolve lixo
#  silenciosamente - como aconteceu na primeira versao deste script.
#  Minimizamos c'Ac por gradiente projetado no simplex.
# -----------------------------------------------------------------------------
piso_coancestria <- function(G, n_iter = 4000, passo = 0.02) {
  A <- G / 2
  n <- nrow(A)
  c_ <- rep(1 / n, n)
  for (i in seq_len(n_iter)) {
    gr <- 2 * as.numeric(A %*% c_)
    c_ <- c_ - passo * (gr - mean(gr))      # projeta no hiperplano sum=1
    c_[c_ < 0] <- 0                         # projeta no ortante positivo
    c_ <- c_ / sum(c_)
  }
  list(piso = as.numeric(crossprod(c_, A %*% c_)),
       n_ativos = sum(c_ > 1e-4), pesos = c_)
}

# -----------------------------------------------------------------------------
# Demonstracao do OCS num unico conjunto de candidatos
# -----------------------------------------------------------------------------
cat("\n== BLOCO B: OCS ==\n")
set.seed(31)
fund_b <- simular_fundadores(n_ind = 60, mapa = MAPA)
pop_b <- cruzar_dh(fund_b,
                   pai = sample.int(60, 40, replace = TRUE),
                   mae = sample.int(60, 40, replace = TRUE),
                   n_prog = 5, mapa = MAPA, chr_idx = CHRI)
Zb <- dosagem(pop_b)
arq_b <- criar_arquitetura(nrow(MAPA), n_qtl = 150)
gb <- valor_genetico(Zb, arq_b)
feb <- fenotipar(gb, h2 = H2)
Gb <- matriz_G(Zb, p = fund_b$p0)
fit_b <- gblup(feb$y, seq_len(nrow(Zb)), Gb, (1 - H2) / H2)
gebv_b <- fit_b$gebv
cand <- order(gebv_b, decreasing = TRUE)[1:120]

# FIGURA 1 - por que a restricao e necessaria:
# truncamento puro concentra a selecao em poucas familias.
fam_b <- pop_b$pai
sel_trunc <- order(gebv_b, decreasing = TRUE)[1:40]
df_fam <- rbind(
  data.frame(estrategia = "Truncamento (40 melhores)",
             familia = fam_b[sel_trunc]),
  data.frame(estrategia = "Populacao inteira", familia = fam_b)
)
tab_fam <- aggregate(list(n = rep(1, nrow(df_fam))),
                     by = list(estrategia = df_fam$estrategia,
                               familia = df_fam$familia), FUN = length)
R$familias_truncamento <- c(
  distintas_sel = length(unique(fam_b[sel_trunc])),
  distintas_pop = length(unique(fam_b)),
  max_por_familia = max(table(fam_b[sel_trunc]))
)
cat(sprintf("Truncamento: %d familias representadas nos 40 selecionados (de %d na populacao)\n",
            R$familias_truncamento["distintas_sel"],
            R$familias_truncamento["distintas_pop"]))

p_fam <- ggplot(tab_fam, aes(factor(familia), n, fill = estrategia)) +
  geom_col(position = "identity", alpha = 0.75, width = 0.9) +
  scale_fill_manual(values = unname(cores_curso[c("cinza", "vinho")])) +
  labs(title = "Selecao por truncamento concentra em poucas familias",
       subtitle = sprintf("Os 40 melhores por GEBV vem de apenas %d dos %d cruzamentos",
                          R$familias_truncamento["distintas_sel"],
                          R$familias_truncamento["distintas_pop"]),
       x = "Cruzamento de origem", y = "Linhagens", fill = NULL) +
  TEMA + theme(axis.text.x = element_blank(), legend.position = "top")
png_salvar(p_fam, "01_concentracao_familias.png")

# -----------------------------------------------------------------------------
# FRONTEIRA DE PARETO
#  Varremos a restricao de parentesco. Cada ponto e uma solucao otima para
#  um nivel de restricao. A curva mostra o PRECO do ganho em diversidade -
#  e nao existe um unico ponto "certo": a escolha e do programa.
# -----------------------------------------------------------------------------
# Primeiro a viabilidade: qual o menor parentesco possivel com estes candidatos?
pc <- piso_coancestria(Gb[cand, cand])
unif <- coancestria_media(Gb[cand, cand], seq_along(cand))
R$piso <- c(piso = pc$piso, n_ativos = pc$n_ativos, uniforme = unif)
cat(sprintf("Piso de coancestria: %.4f (com %d contribuintes) | uniforme: %.4f\n",
            pc$piso, pc$n_ativos, unif))

cat("Construindo fronteira de Pareto...\n")
# A grade de restricoes nasce DO PISO MEDIDO, nao de numeros redondos
# escolhidos a mao: fora do intervalo viavel a solucao nao existe.
restricoes <- round(pc$piso * c(1.02, 1.10, 1.25, 1.5, 1.8, 2.2, 2.8, 3.5, 4.5), 5)
pareto <- do.call(rbind, lapply(restricoes, function(f) {
  oc <- ocs_ga(gebv_b[cand], Gb[cand, cand], max_coancestria = f,
               n_max = 40, n_ger = 150, verbose = FALSE)
  data.frame(restricao = f, ganho = oc$ganho, coancestria = oc$coancestria,
             n_contribuintes = length(oc$sel),
             viavel = oc$coancestria <= f * 1.05)
}))
# Referencia: truncamento puro (sem restricao de parentesco)
A_cand <- Gb[cand, cand] / 2
c_trunc <- rep(0, length(cand)); c_trunc[1:40] <- 1 / 40
gz_cand <- as.numeric(scale(gebv_b[cand]))
ref_trunc <- data.frame(
  ganho = sum(c_trunc * gz_cand),
  coancestria = as.numeric(crossprod(c_trunc, A_cand %*% c_trunc)))
R$pareto <- pareto
R$ref_truncamento <- ref_trunc
print(pareto)

p_par <- ggplot(pareto[pareto$viavel, ], aes(coancestria, ganho)) +
  geom_vline(xintercept = pc$piso, linetype = "dashed",
             colour = cores_curso["cinza"]) +
  annotate("text", x = pc$piso, y = max(pareto$ganho), hjust = -0.05,
           label = "piso: nenhuma solucao\nexiste a esquerda",
           size = 3.5, colour = cores_curso["cinza"], lineheight = 0.95) +
  geom_line(colour = cores_curso["azul"], linewidth = 1) +
  geom_point(aes(size = n_contribuintes), colour = cores_curso["azul"]) +
  geom_point(data = pareto[!pareto$viavel, ], aes(coancestria, ganho),
             colour = cores_curso["laranja"], size = 3.4, shape = 4,
             stroke = 1.2) +
  geom_point(data = ref_trunc, aes(coancestria, ganho),
             colour = cores_curso["vinho"], size = 4, shape = 17) +
  annotate("text", x = ref_trunc$coancestria, y = ref_trunc$ganho,
           label = "truncamento puro  ", hjust = 1, vjust = 0.2,
           colour = cores_curso["vinho"], size = 4) +
  scale_size_continuous(range = c(2, 6), name = "Parentais\ncontribuindo") +
  labs(title = "Fronteira de Pareto: ganho tem preco em diversidade",
       subtitle = "Azul: solucoes otimas viaveis. Laranja (x): restricao abaixo do piso, solucao viola o limite",
       x = "Coancestria media da proxima geracao",
       y = "Ganho esperado (desvios-padrao geneticos)") + TEMA
png_salvar(p_par, "02_fronteira_pareto.png")

# FIGURA 3 - convergencia do AG: o algoritmo trabalhando
oc_demo <- ocs_ga(gebv_b[cand], Gb[cand, cand], max_coancestria = 0.02,
                  n_max = 40, n_ger = 150, verbose = FALSE)
df_conv <- data.frame(geracao = seq_along(oc_demo$trajetoria),
                      aptidao = oc_demo$trajetoria)
p_conv <- ggplot(df_conv, aes(geracao, aptidao)) +
  geom_line(colour = cores_curso["verde"], linewidth = 0.9) +
  labs(title = "Como um algoritmo genetico encontra a solucao",
       subtitle = "Populacao de 120 solucoes candidatas; elite de 20% sobrevive a cada geracao",
       x = "Geracao do algoritmo", y = "Aptidao da melhor solucao") + TEMA
png_salvar(p_conv, "03_convergencia_ag.png", h = 4.6)

# -----------------------------------------------------------------------------
# VALIDACAO CONTRA O optiSel (pacote publico, Wellmann 2019)
#  Regra importante: implementacao propria exige validacao externa. Se o
#  AG e o solver do pacote divergem muito, o errado e quase sempre o meu.
# -----------------------------------------------------------------------------
cat("\nValidacao contra optiSel...\n")
R$optisel <- tryCatch({
  suppressMessages(library(optiSel))
  # Sem coluna Sex o optiSel ignora sexo (avisa e segue) - e o que queremos
  # numa autogama, onde qualquer linhagem pode ser pai ou mae.
  ph <- data.frame(Indiv = as.character(cand),
                   gebv = gebv_b[cand],
                   stringsAsFactors = FALSE)
  Akin <- Gb[cand, cand] / 2
  dimnames(Akin) <- list(ph$Indiv, ph$Indiv)
  alvo <- round(pc$piso * 2.2, 5)      # ponto viavel, no meio da fronteira
  cs <- candes(phen = ph, kin = Akin, quiet = TRUE)
  con <- list(ub.kin = alvo)
  sol <- opticont("max.gebv", cs, con = con, trace = FALSE, quiet = TRUE)
  c_os <- sol$parent$oc
  ganho_os <- sum(c_os * as.numeric(scale(gebv_b[cand])))
  coanc_os <- as.numeric(crossprod(c_os, Akin %*% c_os))
  oc_ga <- ocs_ga(gebv_b[cand], Gb[cand, cand], max_coancestria = alvo,
                  n_max = 40, n_ger = 250, verbose = FALSE)
  cat(sprintf("  optiSel : ganho %.4f | coancestria %.4f | %d contribuintes\n",
              ganho_os, coanc_os, sum(c_os > 1e-4)))
  cat(sprintf("  AG R base: ganho %.4f | coancestria %.4f | %d contribuintes\n",
              oc_ga$ganho, oc_ga$coancestria, length(oc_ga$sel)))
  list(ok = TRUE, alvo = alvo,
       optisel = c(ganho = ganho_os, coancestria = coanc_os,
                   n = sum(c_os > 1e-4)),
       ga = c(ganho = oc_ga$ganho, coancestria = oc_ga$coancestria,
              n = length(oc_ga$sel)),
       versao = as.character(packageVersion("optiSel")))
}, error = function(e) {
  cat("  optiSel indisponivel:", conditionMessage(e), "\n")
  list(ok = FALSE, erro = conditionMessage(e))
})

# =============================================================================
#  BLOCO A (execucao) - comparar estrategias ao longo dos ciclos
# =============================================================================
cat("\n== BLOCO A: ciclos ==\n")
hist_all <- do.call(rbind, lapply(
  c("aleatoria", "truncamento", "ocs"),
  function(e) {
    cat("  estrategia:", e, "\n")
    do.call(rbind, lapply(1:3, function(s) {
      h <- simular_programa(estrategia = e, semente = 100 + s)
      h$rep <- s
      h
    }))
  }))

rotulos <- c(aleatoria = "Sem selecao (controle)",
             truncamento = "Truncamento (40 melhores)",
             ocs = "OCS (parentesco limitado)")
hist_all$estrategia_rot <- factor(rotulos[hist_all$estrategia],
                                  levels = unname(rotulos))

res_ciclo <- aggregate(cbind(media_gen, sd_gen, coancestria, het_esperada, acuracia) ~
                         ciclo + estrategia_rot, data = hist_all, FUN = mean)
R$ciclos <- res_ciclo

p_ganho <- ggplot(res_ciclo, aes(ciclo, media_gen, colour = estrategia_rot)) +
  geom_line(linewidth = 1) + geom_point(size = 2) +
  scale_colour_manual(values = unname(cores_curso[c("cinza", "vinho", "azul")])) +
  scale_x_continuous(breaks = 1:10) +
  labs(title = "Ganho acumulado ao longo de 10 ciclos",
       subtitle = "Media de 3 repeticoes da simulacao por estrategia",
       x = "Ciclo de selecao", y = "Media genetica da populacao",
       colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p_ganho, "04_ganho_ciclos.png")

p_div <- ggplot(res_ciclo, aes(ciclo, sd_gen, colour = estrategia_rot)) +
  geom_line(linewidth = 1) + geom_point(size = 2) +
  scale_colour_manual(values = unname(cores_curso[c("cinza", "vinho", "azul")])) +
  scale_x_continuous(breaks = 1:10) +
  labs(title = "O combustivel acaba: variabilidade genetica por ciclo",
       subtitle = "Cada ciclo de selecao consome parte da variancia que gera o proximo ganho",
       x = "Ciclo de selecao", y = "Desvio-padrao genetico",
       colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p_div, "05_diversidade_ciclos.png")

# A figura decisiva: ganho e diversidade no mesmo plano, trajetoria temporal
p_traj <- ggplot(res_ciclo, aes(coancestria, media_gen, colour = estrategia_rot)) +
  geom_path(linewidth = 1, arrow = arrow(length = unit(0.14, "cm"),
                                         type = "closed")) +
  geom_point(size = 2) +
  scale_colour_manual(values = unname(cores_curso[c("cinza", "vinho", "azul")])) +
  labs(title = "A trajetoria de um programa no plano ganho x parentesco",
       subtitle = "Cada seta e um ciclo; a direita do grafico e perda de diversidade",
       x = "Coancestria media da populacao", y = "Media genetica",
       colour = NULL) +
  TEMA + theme(legend.position = "top")
png_salvar(p_traj, "06_trajetoria_programa.png")

ult <- res_ciclo[res_ciclo$ciclo == max(res_ciclo$ciclo), ]
R$resumo_ciclo10 <- ult
cat("\nCiclo 10:\n"); print(ult[, c("estrategia_rot", "media_gen", "sd_gen", "coancestria")])

# =============================================================================
#  BLOCO C - ALOCACAO DE RECURSOS
# -----------------------------------------------------------------------------
#  O orcamento de um programa nao e medido em dinheiro no dia a dia, e em
#  PARCELAS. Dado um numero fixo de parcelas, existem tres usos competindo:
#    - mais genotipos  -> mais intensidade de selecao (i maior)
#    - mais locais     -> melhor estimativa frente ao GxE
#    - mais repeticoes -> menos erro experimental dentro do local
#  A pergunta "quantos locais e repeticoes?" so tem resposta quando o
#  orcamento e fixo, porque e ai que uma escolha custa a outra.
# =============================================================================
cat("\n== BLOCO C: alocacao de recursos ==\n")
ORCAMENTO <- 2400          # parcelas totais disponiveis
PROP_SEL  <- 0.10          # 10% avancam

set.seed(55)
fund_c <- simular_fundadores(n_ind = 80, mapa = MAPA)
arq_c  <- criar_arquitetura(nrow(MAPA), n_qtl = 150)

# Herdabilidade de media ajustada: h2_m = Vg / (Vg + Vge/L + Ve/(L*r))
# E esta formula que faz locais e repeticoes terem efeitos DIFERENTES:
# repeticao ataca apenas Ve, local ataca Ve e tambem o GxE.
h2_media <- function(vg, vge, ve, n_loc, n_rep) {
  vg / (vg + vge / n_loc + ve / (n_loc * n_rep))
}

grade <- expand.grid(n_loc = c(1, 2, 3, 4, 6, 8), n_rep = c(1, 2, 3))
grade <- grade[grade$n_loc * grade$n_rep <= 12, ]
grade$n_gen <- floor(ORCAMENTO / (grade$n_loc * grade$n_rep))
grade <- grade[grade$n_gen >= 60, ]

aval <- do.call(rbind, lapply(seq_len(nrow(grade)), function(k) {
  nl <- grade$n_loc[k]; nr <- grade$n_rep[k]; ng <- grade$n_gen[k]
  acc <- numeric(4); gan <- numeric(4)
  for (s in 1:4) {
    set.seed(1000 + k * 10 + s)
    pop_c <- cruzar_dh(fund_c,
                       pai = sample.int(80, ng / 5, replace = TRUE),
                       mae = sample.int(80, ng / 5, replace = TRUE),
                       n_prog = 5, mapa = MAPA, chr_idx = CHRI)
    Zc_ <- dosagem(pop_c)
    gc_ <- valor_genetico(Zc_, arq_c)
    fm <- fenotipar_multi(gc_, n_loc = nl, n_rep = nr, h2_parcela = 0.25)
    # Media por genotipo: o que o melhorista efetivamente usa para decidir
    mg <- tapply(fm$dados$y, fm$dados$ind, mean)
    h2m <- h2_media(fm$vg, fm$vge, fm$ve, nl, nr)
    Gc <- matriz_G(Zc_, p = fund_c$p0)
    fit_c <- gblup(as.numeric(mg), seq_len(nrow(Zc_)), Gc, (1 - h2m) / h2m)
    acc[s] <- cor(fit_c$gebv, fm$g)
    # Ganho realizado: media genetica verdadeira dos selecionados
    sel <- order(fit_c$gebv, decreasing = TRUE)[seq_len(round(PROP_SEL * ng))]
    gan[s] <- mean(fm$g[sel]) / sd(fm$g)
  }
  data.frame(n_loc = nl, n_rep = nr, n_gen = ng,
             parcelas = nl * nr * ng,
             h2_media = h2_media(1, 1 * 0.4 / 0.6, (1 + 0.4 / 0.6) * 3, nl, nr),
             acuracia = mean(acc), ganho = mean(gan), ganho_sd = sd(gan))
}))
aval <- aval[order(-aval$ganho), ]
R$alocacao <- aval
print(head(aval, 10))

melhor <- aval[1, ]
pior <- aval[nrow(aval), ]
R$alocacao_extremos <- list(melhor = melhor, pior = pior)
cat(sprintf("\nMelhor: %d locais x %d rep x %d genotipos -> ganho %.3f\n",
            melhor$n_loc, melhor$n_rep, melhor$n_gen, melhor$ganho))
cat(sprintf("Pior  : %d locais x %d rep x %d genotipos -> ganho %.3f (%.0f%% menor)\n",
            pior$n_loc, pior$n_rep, pior$n_gen, pior$ganho,
            100 * (1 - pior$ganho / melhor$ganho)))

aval$rotulo <- sprintf("%dL x %dR\n%d gen", aval$n_loc, aval$n_rep, aval$n_gen)
p_aloc <- ggplot(aval, aes(reorder(rotulo, ganho), ganho, fill = factor(n_loc))) +
  geom_col(width = 0.72) +
  geom_errorbar(aes(ymin = ganho - ganho_sd, ymax = ganho + ganho_sd),
                width = 0.25, colour = "grey30", linewidth = 0.35) +
  coord_flip() +
  scale_fill_brewer(palette = "Blues", name = "Locais") +
  labs(title = sprintf("Mesmo orcamento de %d parcelas, ganhos diferentes", ORCAMENTO),
       subtitle = "Media de 4 repeticoes; 10% selecionados por GEBV",
       x = NULL, y = "Ganho realizado (desvios-padrao geneticos)") +
  TEMA
png_salvar(p_aloc, "07_alocacao_recursos.png", h = 6.0)

# Decomposicao: por que locais valem mais que repeticoes quando ha GxE
p_h2 <- ggplot(aval, aes(n_loc, h2_media, colour = factor(n_rep))) +
  geom_line(linewidth = 1) + geom_point(size = 2.4) +
  scale_colour_manual(values = unname(cores_curso[c("azul", "laranja", "verde")]),
                      name = "Repeticoes") +
  labs(title = "Local e repeticao nao sao intercambiaveis",
       subtitle = "h2 da media = Vg / (Vg + Vge/L + Ve/(L*r)): o GxE so e atacado por LOCAL",
       x = "Numero de locais", y = "Herdabilidade da media ajustada") + TEMA
png_salvar(p_h2, "08_h2_media_loc_rep.png", h = 5.0)

# =============================================================================
#  ENCERRAMENTO
# =============================================================================
R$parametros <- list(n_snp = nrow(MAPA), n_fund = N_FUND, h2 = H2,
                     n_pop = N_POP, n_ciclos = N_CICLOS,
                     orcamento = ORCAMENTO, prop_sel = PROP_SEL)
R$tempo_s <- as.numeric(difftime(Sys.time(), t_inicio, units = "secs"))
saveRDS(R, "resultados_09.rds")
cat(sprintf("\nConcluido em %.1f s (%.1f min). Figuras em figuras/\n",
            R$tempo_s, R$tempo_s / 60))
