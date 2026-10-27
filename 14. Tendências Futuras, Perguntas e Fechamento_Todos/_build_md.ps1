$ErrorActionPreference = "Stop"
$dir = $PSScriptRoot
$slides = Get-Content -LiteralPath (Join-Path $dir "_slides.json") -Encoding UTF8 -Raw | ConvertFrom-Json
$out = Join-Path $dir "esqueleto_deck.md"

$dash = [char]0x2014
$bullet = [char]0x2022
$topicos = "T" + [char]0x00F3 + "picos"
$sessao = "Sess" + [char]0x00E3 + "o"

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# $sessao 11 $dash Esqueleto do deck")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("Gerado de ``_slides.json`` (mesma fonte de ``11_tendencias_futuras.pptx``) por ``_build_md.ps1``. $($slides.Count) slides. Cada slide traz os t" + [char]0x00F3 + "picos da tela e as notas do apresentador. DOIs e tabelas em ``dossie/``.")
[void]$sb.AppendLine("")

$i = 0
foreach ($s in $slides) {
  $i++
  $title = [string]$s.title
  if ($title -match '^Bloco \d' -and $title -notmatch 'Take-home') {
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("# $title")
    [void]$sb.AppendLine("")
  }
  [void]$sb.AppendLine("## Slide $i $dash $title")
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine("**$topicos**")
  [void]$sb.AppendLine("")
  foreach ($line in ([string]$s.body) -split "`n") {
    $t = $line.Trim().TrimStart($bullet).Trim()
    if ($t) { [void]$sb.AppendLine("- $t") }
  }
  [void]$sb.AppendLine("")
  if ($s.notes) {
    [void]$sb.AppendLine("**Notas**")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine(([string]$s.notes).Trim())
    [void]$sb.AppendLine("")
  }
}

[System.IO.File]::WriteAllText($out, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
Write-Output "Saved: $out ($i slides)"
