---
name: novo-ciclo
description: Avança um ciclo do programa de melhoramento simulado: executa os cruzamentos planejados, fenotipa a nova coorte e refaz QC, BLUP, seleção genômica e plano de cruzamentos. Use quando o usuário pedir para avançar ou fechar um ciclo.
disable-model-invocation: true
allowed-tools: Bash(Rscript *)
---

Execute, nesta ordem, parando na primeira falha:

1. `Rscript R/07_novo_ciclo.R` — realiza os cruzamentos e fenotipa a nova coorte.
2. `Rscript R/03_qc.R`
3. `Rscript R/04_blup_met.R`
4. `Rscript R/05_gs.R`
5. `Rscript R/06_cruzamentos.R`
6. `Rscript R/validar_contra_gabarito.R todas`

Depois, escreva `docs/etapas/ciclo_NN.md` com: ganho realizado dos cruzamentos
planejados e dos controles (`reports/novo_ciclo_resumo.csv`), componentes de variância,
acurácia da seleção genômica e o novo plano de cruzamentos. Destaque qualquer critério
de validação que tenha falhado.
