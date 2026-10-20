# Funções compartilhadas pelas etapas 02 a 04.
# Premissa: os scripts rodam a partir da raiz do projeto vcu-milho-2025.

normalizar_id <- function(id) {
  gsub("[[:space:]-]+", "_", toupper(trimws(id)))
}

detectar_problemas <- function(x, par) {
  ids_ruins <- !grepl(par$ids$regex, x$germoplasma_nome)
  duplicada <- duplicated(x[, unlist(par$qc$chave_duplicata)])
  fora <- !is.na(x$PROD) & (x$PROD < par$qc$prod_min | x$PROD > par$qc$prod_max)

  rbind(
    data.frame(tipo = rep("id_fora_do_padrao", sum(ids_ruins)),
               parcela_id = x$parcela_id[ids_ruins],
               valor = x$germoplasma_nome[ids_ruins],
               regra = rep(par$ids$regex, sum(ids_ruins))),
    data.frame(tipo = rep("duplicata_posicao", sum(duplicada)),
               parcela_id = x$parcela_id[duplicada],
               valor = rep("", sum(duplicada)),
               regra = rep(paste(unlist(par$qc$chave_duplicata), collapse = "+"), sum(duplicada))),
    data.frame(tipo = rep("fora_do_intervalo", sum(fora)),
               parcela_id = x$parcela_id[fora],
               valor = as.character(x$PROD[fora]),
               regra = rep(sprintf("%s-%s kg/ha", par$qc$prod_min, par$qc$prod_max), sum(fora)))
  )
}

analise_individual <- function(d, r) {
  do.call(rbind, lapply(split(d, d$ambiente_id), function(a) {
    m <- lme4::lmer(PROD ~ factor(bloco) + (1 | genotipo), data = a)
    vc <- as.data.frame(lme4::VarCorr(m))
    s2g <- vc$vcov[vc$grp == "genotipo"]
    s2e <- vc$vcov[vc$grp == "Residual"]
    media <- mean(a$PROD, na.rm = TRUE)
    data.frame(ambiente_id = a$ambiente_id[1],
               media = media,
               cv = 100 * sqrt(s2e) / media,
               s2g = s2g, s2e = s2e,
               h2_medias = s2g / (s2g + s2e / r))
  }))
}

analise_conjunta <- function(d) {
  d$ambiente_bloco <- interaction(d$ambiente_id, d$bloco)
  m <- lme4::lmer(PROD ~ ambiente_id + (1 | ambiente_bloco) + (1 | genotipo) +
                    (1 | genotipo:ambiente_id), data = d)
  re <- lme4::ranef(m)$genotipo
  blups <- data.frame(genotipo = rownames(re), blup = re[, 1])
  blups <- blups[order(-blups$blup), ]
  blups$posicao_geral <- seq_len(nrow(blups))
  list(modelo = m,
       componentes = as.data.frame(lme4::VarCorr(m))[, c("grp", "vcov")],
       blups = blups)
}
