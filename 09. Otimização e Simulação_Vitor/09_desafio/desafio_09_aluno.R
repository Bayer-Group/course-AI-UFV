# =============================================================================
#  DESAFIO - ITEM 9: ONDE GASTAR AS PARCELAS
#  Curso: IA no Melhoramento Genetico - UFV, novembro/2026
#  20 minutos, em duplas.
# =============================================================================
#
#  VOCE DIRIGE O PROGRAMA
#
#  Especie autogama, um carater quantitativo, selecao recorrente.
#  O programa avalia 600 linhagens por ciclo e dispoe de 3.600 parcelas
#  por ciclo. O numero de linhagens NAO muda: nao e uma das suas escolhas.
#
#     600 linhagens  x  L locais  x  R repeticoes  <=  3.600 parcelas
#
#  Voce escolhe TRES numeros:
#
#     L        quantos locais
#     R        quantas repeticoes por local
#     delta_f  quanta endogamia por ciclo o OCS pode acumular
#
#  O que voce sabe do seu programa:
#
#     - herdabilidade na parcela individual .................. 0,25
#     - fracao da variancia genetica que e genotipo x ambiente . 40%
#     - endogamia autorizada por ciclo ....................... no maximo 1%
#       (teto do desafio)
#     - horizonte ............................................ 5 ciclos
#
#  ATENCAO: neste desafio o teto e 1% por ciclo - NAO os 3% usados na aula.
#  delta_f acima de 1% e escolha invalida.
#
#  COMO SUA ESCOLHA E AVALIADA
#
#     ganho genetico da media da populacao no ciclo 5,
#     em desvios-padrao geneticos do ciclo 1
#
#  O QUE ENTREGAR
#
#     os tres numeros e UMA frase dizendo por que.
#
# =============================================================================


# -----------------------------------------------------------------------------
#  PREENCHA
# -----------------------------------------------------------------------------
L       <- NA    # locais
R       <- NA    # repeticoes por local
delta_f <- NA    # endogamia por ciclo (ex.: 0.005 = 0,5%)

JUSTIFICATIVA <- "

"


# -----------------------------------------------------------------------------
#  CONFERE SE A ESCOLHA E VALIDA  (rode esta parte, ou confira a mao)
# -----------------------------------------------------------------------------
N_GEN     <- 600
ORCAMENTO <- 3600
TETO_DF   <- 0.01

parcelas <- N_GEN * L * R

cat("\nlinhagens ...", N_GEN,
    "\nlocais ......", L,
    "\nrepeticoes ..", R,
    "\nparcelas ....", parcelas, "de", ORCAMENTO,
    "\ndelta_f .....", delta_f, "\n\n")

if (is.na(L) || is.na(R) || is.na(delta_f)) {
  cat("Preencha L, R e delta_f.\n")
} else if (parcelas > ORCAMENTO) {
  cat("INVALIDO: passa do orcamento em", parcelas - ORCAMENTO, "parcelas.\n")
} else if (delta_f > TETO_DF) {
  cat("INVALIDO: delta_f acima do teto de 1% por ciclo (teto do desafio).\n")
} else {
  cat("Escolha valida. Sobram", ORCAMENTO - parcelas, "parcelas.\n")
}
