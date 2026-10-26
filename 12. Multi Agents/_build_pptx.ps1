$ErrorActionPreference = "Stop"
$outDir = $PSScriptRoot
$outFile = Join-Path $outDir "12_multi_agents.pptx"
$partsDir = Join-Path $outDir "_slides_parts"
$mergedPath = Join-Path $outDir "_slides.json"

$files = Get-ChildItem -LiteralPath $partsDir -Filter "*.json" | Sort-Object Name
if ($files.Count -eq 0) { throw "Nenhum JSON em _slides_parts" }

$all = @()
foreach ($f in $files) {
  $chunk = Get-Content -LiteralPath $f.FullName -Encoding UTF8 -Raw | ConvertFrom-Json
  foreach ($item in $chunk) { $all += $item }
}

$all | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $mergedPath -Encoding UTF8
Write-Output ("Merged {0} slides from {1} files" -f $all.Count, $files.Count)

if (Test-Path -LiteralPath $outFile) { Remove-Item -LiteralPath $outFile -Force }

$ppt = New-Object -ComObject PowerPoint.Application
$ppt.Visible = [Microsoft.Office.Core.MsoTriState]::msoTrue
$pres = $ppt.Presentations.Add()
$pres.PageSetup.SlideWidth = 1219.2
$pres.PageSetup.SlideHeight = 685.6
while ($pres.Slides.Count -gt 0) { $pres.Slides.Item(1).Delete() }

foreach ($s in $all) {
  $slide = $pres.Slides.Add($pres.Slides.Count + 1, 2)
  $titleShape = $slide.Shapes.Item(1)
  $bodyShape = $slide.Shapes.Item(2)
  $titleShape.TextFrame.TextRange.Text = [string]$s.title
  $titleShape.TextFrame.TextRange.Font.Size = 24
  $body = ([string]$s.body) -replace "`n", "`r"
  $bodyShape.TextFrame.TextRange.Text = $body
  $bodyShape.TextFrame.TextRange.Font.Size = 16
  $bodyShape.TextFrame.WordWrap = -1
  if ($s.notes) {
    $note = ([string]$s.notes) -replace "`n", "`r"
    $slide.NotesPage.Shapes.Placeholders.Item(2).TextFrame.TextRange.Text = $note
  }
}

$pres.SaveAs($outFile)
$pres.Close()
$ppt.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($pres) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ppt) | Out-Null
[GC]::Collect()
[GC]::WaitForPendingFinalizers()
Write-Output "Saved: $outFile ($($all.Count) slides)"
Get-Item -LiteralPath $outFile | Format-List FullName, Length, LastWriteTime
