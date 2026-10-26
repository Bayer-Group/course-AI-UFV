## run_rapidos.R — Roda todos os testes rápidos do projeto
## Chamado pelo hook pós-edição em .claude/settings.json

cat("═══ Testes rápidos ═══════════════════════════════\n")

testes <- list.files("tests", pattern = "^test_.*\\.R$", full.names = TRUE)
if (length(testes) == 0L) {
  cat("Nenhum teste encontrado em tests/\n")
  quit(status = 0)
}

falhas <- 0L
for (f in testes) {
  cat("\n→", basename(f), "\n")
  ok <- tryCatch({ source(f, local = new.env(parent = globalenv())); TRUE },
                  error = function(e) { cat("  ERRO:", conditionMessage(e), "\n"); FALSE })
  if (!ok) falhas <- falhas + 1L
}

cat("\n═══ Resultado:", length(testes) - falhas, "/", length(testes), "passaram ═══\n")
if (falhas > 0L) quit(status = 1)
