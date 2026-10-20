# Checklist: o agente fez o que foi pedido?

| ☐ | Verificação | Como |
|---|---|---|
| ☐ | O que mudou? Algo além do pedido? | `git status`, `git diff` |
| ☐ | O plano foi cumprido item a item? | Releia a etapa no `PLANO.md` |
| ☐ | Há evidência? | Comando + saída do teste |
| ☐ | O teste tem resposta conhecida? | Erros injetados, dado simulado |
| ☐ | Os números-chave batem? | Conferência independente (abaixo) |
| ☐ | É geneticamente plausível? | 0 ≤ h² ≤ 1, CV do caráter, variâncias ≥ 0, unidades |
| ☐ | Roda do zero? | Apague o que é gerado e rode na ordem |
| ☐ | Você explica cada linha e cada número? | Se não, não está pronto |

## Conferência independente (console do R, fora do agente)

```r
x <- read.csv("data/bruto/vcu_milho_2025_campo.csv")
nrow(x); table(x$ambiente_id)
sum(!grepl("^DH[0-9]{2}_[0-9]{4}$", x$germoplasma_nome))
sum(duplicated(x[, c("ensaio_id", "linha", "coluna")]))
sum(x$PROD < 2000 | x$PROD > 20000, na.rm = TRUE)
length(unique(x$germoplasma_nome))
```
