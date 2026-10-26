$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

$dirs = @(
  (Join-Path $root "docs\rascunhos"),
  (Join-Path $root "docs\pareceres_orientador"),
  (Join-Path $root "docs\pareceres_revisores")
)

foreach ($d in $dirs) {
  Get-ChildItem -LiteralPath $d -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ne ".gitkeep" } |
    Remove-Item -Force
}

$decisoes = Join-Path $root "docs\decisoes.md"
$content = @"
# Decisões do aluno (gate)

Registre aqui, em ordem cronológica, se o rascunho da rodada N vai ao painel de revisores.

Formato sugerido:

``````
## Rodada N — AAAA-MM-DD
- Decisão: ENVIAR | REESCREVER
- Motivo (1–3 frases):
- Bloqueantes do orientador tratados? sim/não/parcial
``````

---

*(Nenhuma decisão ainda — a aula começa na rodada 1.)*
"@
# Use a proper markdown code fence in the reset file
$content = $content -replace '``````', '```'
Set-Content -LiteralPath $decisoes -Value $content -Encoding UTF8

Write-Output "Limpeza concluída: rascunhos, pareceres e decisoes.md resetados."
