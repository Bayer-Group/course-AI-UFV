#Requires -Version 5.1
# Rebuild FIT796 slides that lost tables / process flows / tree / columns / code comments.
# Reads structure from orig.pptx via COM (Unicode-safe) and restyles onto fit.pptx.
$ErrorActionPreference = 'Stop'
$work = $PSScriptRoot
$logPath = Join-Path $work 'rebuild_log.txt'
$pngDir = Join-Path $work '_preview_struct'
[IO.File]::WriteAllText($logPath, "")
function Log([string]$m) {
  $line = "$(Get-Date -Format 'HH:mm:ss') $m"
  Write-Output $line
  [IO.File]::AppendAllText($logPath, $line + "`r`n")
}

# Palette COM RGB
$green = 5864522
$cream = 15594485
$rust = 2770871
$amber = 2139897
$ink = 3095086
$lightGreen = 14345432
$muted = 7039851
$white = 16777215
$codeBg = 3095086
$codeFg = 15594485
$codeMuted = 14345432

function Invoke-ComRetry([scriptblock]$Action, [int]$MaxTries = 15) {
  for ($a = 1; $a -le $MaxTries; $a++) {
    try { return & $Action }
    catch {
      if ($_.Exception.Message -match '0x80010001|0x800706BA|rejected|RPC|unavailable|busy') {
        Start-Sleep -Milliseconds (300 * $a); continue
      }
      throw
    }
  }
  throw "COM failed after $MaxTries"
}

function Get-OrigTable($origSlide) {
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { [int]$sh.Type }) -eq 19) {
      $t = $sh.Table
      $rows = @()
      for ($r = 1; $r -le $t.Rows.Count; $r++) {
        $cols = @()
        for ($c = 1; $c -le $t.Columns.Count; $c++) {
          $cols += (Invoke-ComRetry { ($t.Cell($r, $c).Shape.TextFrame.TextRange.Text -replace "`r", ' ').Trim() })
        }
        $rows += , $cols
      }
      return @{
        Rows = $rows
        L = [double]$sh.Left; T = [double]$sh.Top
        W = [double]$sh.Width; H = [double]$sh.Height
      }
    }
  }
  return $null
}

function Get-OrigNotes($origSlide, [double]$belowTop) {
  $notes = @()
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -eq 'rodape' -or $name -like '*Placeholder*' -or $name -like 'Text *') { continue }
    if ((Invoke-ComRetry { [int]$sh.Type }) -eq 19) { continue }
    $top = Invoke-ComRetry { [double]$sh.Top }
    if ($top -lt $belowTop) { continue }
    if ($top -gt 490) { continue }
    $tx = Invoke-ComRetry { $sh.TextFrame.TextRange.Text }
    if (-not $tx -or -not $tx.Trim()) { continue }
    $notes += @{ Text = $tx.Trim(); Top = $top; Left = [double]$sh.Left; Width = [double]$sh.Width; Height = [double]$sh.Height }
  }
  return , $notes
}

function Get-OrigTitle($origSlide) {
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $top = Invoke-ComRetry { [double]$sh.Top }
    if ($top -gt 50) { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }) -replace "`r|`n", ' '
    $tx = ($tx -replace '\s+', ' ').Trim()
    # strip gear emoji noise for title cleanliness optional - keep as-is
    if ($tx) { return $tx }
  }
  return ''
}

function Get-OrigRefs($origSlide) {
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.Name }) -eq 'rodape') {
      return (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    }
  }
  return ''
}

function Clear-ContentArea($slide) {
  # Delete everything except top bar (H<=14, T<=2) - we rebuild title+refs
  $toDel = @()
  $n = Invoke-ComRetry { $slide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $slide.Shapes.Item($i) }
    $top = Invoke-ComRetry { [double]$sh.Top }
    $h = Invoke-ComRetry { [double]$sh.Height }
    $name = Invoke-ComRetry { $sh.Name }
    # keep thin green/rust bar at top
    if ($top -le 2 -and $h -le 14 -and ((Invoke-ComRetry { [int]$sh.Type }) -eq 1)) { continue }
    $toDel += $sh
  }
  foreach ($sh in $toDel) {
    try { Invoke-ComRetry { $sh.Delete() } | Out-Null } catch {}
  }
}

function Ensure-TopBar($slide, [int]$fill = 5864522) {
  $has = $false
  $n = Invoke-ComRetry { $slide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $slide.Shapes.Item($i) }
    if ((Invoke-ComRetry { [double]$sh.Top }) -le 2 -and (Invoke-ComRetry { [double]$sh.Height }) -le 14) { $has = $true; break }
  }
  if (-not $has) {
    $bar = Invoke-ComRetry { $slide.Shapes.AddShape(1, 0, 0, 960, 11.5) }
    $bar.Fill.Solid(); $bar.Fill.ForeColor.RGB = $fill
    $bar.Line.Visible = 0; $bar.Name = 'TopBar'
  }
}

function Add-Title($slide, [string]$text) {
  $tb = Invoke-ComRetry { $slide.Shapes.AddTextbox(1, 50.4, 28, 864, 50) }
  $tb.Name = 'FitTitle'
  $tr = $tb.TextFrame.TextRange
  $tr.Text = $text
  $tr.Font.Name = 'DejaVu Serif'
  $tr.Font.Bold = $true
  $tr.Font.Size = 28
  $tr.Font.Color.RGB = $green
  $tb.TextFrame.WordWrap = -1
  while (($tr.BoundHeight -gt 52) -and ($tr.Font.Size -gt 20)) { $tr.Font.Size = $tr.Font.Size - 1 }
  return $tb
}

function Add-Refs($slide, [string]$text) {
  if (-not $text) { return $null }
  $tb = Invoke-ComRetry { $slide.Shapes.AddTextbox(1, 50.4, 484, 720, 22) }
  $tb.Name = 'FitRefs'
  $tr = $tb.TextFrame.TextRange
  $tr.Text = $text
  $tr.Font.Name = 'DejaVu Sans'
  $tr.Font.Size = 10
  $tr.Font.Color.RGB = $muted
  return $tb
}

function Add-Fit796Table($slide, [object[]]$cells, [double]$left, [double]$top, [double]$w, [double]$h, [int[]]$monoCols) {
  $nR = $cells.Count; $nC = $cells[0].Count
  $tblShape = Invoke-ComRetry { $slide.Shapes.AddTable($nR, $nC, $left, $top, $w, $h) }
  $tbl = $tblShape.Table
  $tblShape.Name = 'Fit796Table'
  for ($r = 1; $r -le $nR; $r++) {
    for ($c = 1; $c -le $nC; $c++) {
      $cell = $tbl.Cell($r, $c)
      $tr = $cell.Shape.TextFrame.TextRange
      $tr.Text = [string]$cells[$r - 1][$c - 1]
      $isMono = $monoCols -contains $c
      $tr.Font.Name = if ($isMono) { 'DejaVu Sans Mono' } else { 'DejaVu Sans' }
      try { if ($isMono -and $tr.Font.Name -ne 'DejaVu Sans Mono') { $tr.Font.Name = 'Consolas' } } catch {}
      $tr.Font.Size = if ($r -eq 1) { 15 } else { 14 }  # piso 14 pt
      $tr.ParagraphFormat.SpaceBefore = 0
      $tr.ParagraphFormat.SpaceAfter = 0
      $cell.Shape.TextFrame.MarginLeft = 5
      $cell.Shape.TextFrame.MarginRight = 4
      $cell.Shape.TextFrame.MarginTop = 2
      $cell.Shape.TextFrame.MarginBottom = 2
      $cell.Shape.Fill.Solid()
      if ($r -eq 1) {
        $cell.Shape.Fill.ForeColor.RGB = $green
        $tr.Font.Bold = $true
        $tr.Font.Color.RGB = $white
      } else {
        $cell.Shape.Fill.ForeColor.RGB = if ($r % 2 -eq 0) { $cream } else { $lightGreen }
        $tr.Font.Color.RGB = $ink
        if ($isMono) { $tr.Font.Color.RGB = $green }
      }
      try { $cell.Borders.Item(1).Visible = $false } catch {}
    }
  }
  # shrink font if needed (guard COM cast quirks)
  # piso duro 14 pt (skill FIT796) — nunca abaixo
  $minSize = 14.0
  for ($pass = 0; $pass -lt 4; $pass++) {
    $overflow = $false
    for ($r = 1; $r -le $nR; $r++) {
      for ($c = 1; $c -le $nC; $c++) {
        try {
          $tr = $tbl.Cell($r, $c).Shape.TextFrame.TextRange
          $ch = [double]$tbl.Cell($r, $c).Shape.Height
          $bh = [double]$tr.BoundHeight
          $sz = [double]$tr.Font.Size
          if (($bh -gt ($ch + 2)) -and ($sz -gt $minSize)) { $overflow = $true }
        } catch { }
      }
    }
    if (-not $overflow) { break }
    for ($r = 1; $r -le $nR; $r++) {
      for ($c = 1; $c -le $nC; $c++) {
        try {
          $tr = $tbl.Cell($r, $c).Shape.TextFrame.TextRange
          $sz = [double]$tr.Font.Size
          if ($sz -gt $minSize) { $tr.Font.Size = [float]($sz - 1) }
        } catch { }
      }
    }
  }
  return $tblShape
}

function Add-NoteBox($slide, [string]$text, [double]$left, [double]$top, [double]$w, [double]$h) {
  $tb = Invoke-ComRetry { $slide.Shapes.AddTextbox(1, $left, $top, $w, $h) }
  $tb.Name = 'FitNote'
  $tf = $tb.TextFrame
  $tf.WordWrap = -1
  $tf.MarginLeft = 2; $tf.MarginRight = 2; $tf.MarginTop = 2; $tf.MarginBottom = 2
  $tr = $tf.TextRange
  $tr.Text = $text
  $tr.Font.Name = 'DejaVu Sans'
  $tr.Font.Size = 13
  $tr.Font.Color.RGB = $ink
  $tr.ParagraphFormat.SpaceBefore = 0
  $tr.ParagraphFormat.SpaceAfter = 4
  $tr.ParagraphFormat.SpaceWithin = 0.92
  while (($tr.BoundHeight -gt ($h + 2)) -and ($tr.Font.Size -gt 10)) { $tr.Font.Size = $tr.Font.Size - 1 }
  return $tb
}

function Add-CodeBox($slide, [double]$left, [double]$top, [double]$w, [double]$h, [string[]]$lines, [double]$fontSize = 12) {
  $panel = Invoke-ComRetry { $slide.Shapes.AddShape(5, $left, $top, $w, $h) }
  $panel.Adjustments.Item(1) = 0.04
  $panel.Fill.Solid(); $panel.Fill.ForeColor.RGB = $codeBg
  $panel.Line.Visible = 0; $panel.Shadow.Visible = 0
  $panel.Name = 'CodeBox'
  $bar = Invoke-ComRetry { $slide.Shapes.AddShape(1, $left, $top, 6, $h) }
  $bar.Fill.Solid(); $bar.Fill.ForeColor.RGB = $amber
  $bar.Line.Visible = 0; $bar.Name = 'CodeBoxAccent'
  $tf = $panel.TextFrame
  $tf.MarginLeft = 16; $tf.MarginRight = 12; $tf.MarginTop = 10; $tf.MarginBottom = 10
  $tf.WordWrap = -1; $tf.VerticalAnchor = 1
  $tf.TextRange.Text = ($lines -join "`r")
  $tf.TextRange.Font.Name = 'DejaVu Sans Mono'
  try { if ($tf.TextRange.Font.Name -ne 'DejaVu Sans Mono') { $tf.TextRange.Font.Name = 'Consolas' } } catch { $tf.TextRange.Font.Name = 'Consolas' }
  $tf.TextRange.Font.Size = $fontSize
  $tf.TextRange.Font.Color.RGB = $codeFg
  $tf.TextRange.ParagraphFormat.SpaceAfter = 2
  $tf.TextRange.ParagraphFormat.SpaceBefore = 0
  $tf.TextRange.ParagraphFormat.SpaceWithin = 0.95
  # mute comment paragraphs
  $pc = $tf.TextRange.Paragraphs().Count
  for ($p = 1; $p -le $pc; $p++) {
    $pg = $tf.TextRange.Paragraphs($p)
    $pt = $pg.Text
    if ($pt -match '^\s*#' -or $pt -match '\s#\s') {
      # color whole line muted if starts with #; else leave (hard to split in COM)
      if ($pt -match '^\s*#') { $pg.Font.Color.RGB = $codeMuted }
    }
  }
  while (($tf.TextRange.BoundHeight -gt ($h - 8)) -and ($tf.TextRange.Font.Size -gt 9)) {
    $tf.TextRange.Font.Size = $tf.TextRange.Font.Size - 1
  }
  return $panel
}

function Format-TreeLinesFromText([string]$raw) {
  $lines = @($raw -split "`r`n|`n|`r" | ForEach-Object { $_.TrimEnd() } | Where-Object { $_.Length -gt 0 })
  $pad = 30
  $out = @()
  foreach ($ln in $lines) {
    # split path and note: 2+ spaces after path-ish token
    # Split on 2+ spaces between path column and comment column
    if ($ln -match '^(\S.*?)  +(\S.*)$') {
      $path = $Matches[1].TrimEnd()
      $note = $Matches[2].Trim()
      if ($path.Length -ge $pad) { $out += ($path + '  ' + $note) }
      else { $out += ($path.PadRight($pad) + $note) }
    } else {
      $out += $ln
    }
  }
  return , $out
}

function Add-ProcessFlow($slide, [hashtable[]]$steps, [double]$left, [double]$top, [double]$totalW, [double]$boxH) {
  $fills = @($green, $lightGreen, $amber, $rust, $green, $lightGreen)
  $fgs = @($white, $ink, $ink, $white, $white, $ink)
  $n = $steps.Count
  $gap = 10; $arrowW = 12
  $boxW = ($totalW - ($n - 1) * ($gap + $arrowW)) / $n
  $x = $left
  for ($i = 0; $i -lt $n; $i++) {
    $fi = $fills[$i % $fills.Count]; $fg = $fgs[$i % $fgs.Count]
    $box = Invoke-ComRetry { $slide.Shapes.AddShape(5, $x, $top, $boxW, $boxH) }
    $box.Adjustments.Item(1) = 0.08
    $box.Fill.Solid(); $box.Fill.ForeColor.RGB = $fi
    $box.Line.Visible = 0; $box.Name = "ProcessBox$i"
    $tf = $box.TextFrame
    $tf.MarginLeft = 5; $tf.MarginRight = 5; $tf.MarginTop = 5; $tf.MarginBottom = 3
    $tf.WordWrap = -1
    $title = [string]$steps[$i].title
    $sub = [string]$steps[$i].sub
    $tf.TextRange.Text = if ($sub) { "$title`r$sub" } else { $title }
    $tf.TextRange.Font.Name = 'DejaVu Sans'
    $tf.TextRange.Font.Size = 10
    $tf.TextRange.Font.Color.RGB = $fg
    $tf.TextRange.ParagraphFormat.SpaceBefore = 0
    $tf.TextRange.ParagraphFormat.SpaceAfter = 2
    try {
      $tf.TextRange.Paragraphs(1).Font.Bold = $true
      $tf.TextRange.Paragraphs(1).Font.Size = 12
    } catch {}
    $x += $boxW
    if ($i -lt $n - 1) {
      $arr = Invoke-ComRetry { $slide.Shapes.AddShape(33, $x + 1, ($top + $boxH / 2 - 6), $arrowW, 12) }
      $arr.Fill.Solid(); $arr.Fill.ForeColor.RGB = $amber
      $arr.Line.Visible = 0; $arr.Name = "ProcessArrow$i"
      $x += $gap + $arrowW
    }
  }
}

function Get-ProcessSteps($origSlide) {
  # Collect narrow texto-* labels (process boxes), pick densest horizontal band
  $cands = @()
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -notlike 'texto-*') { continue }
    $w = Invoke-ComRetry { [double]$sh.Width }
    if ($w -gt 250) { continue }
    $top = Invoke-ComRetry { [double]$sh.Top }
    if ($top -gt 450) { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    if (-not $tx) { continue }
    $parts = @($tx -split "`r`n|`n|`r" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    $title = $parts[0]
    $sub = if ($parts.Count -gt 1) { ($parts[1..($parts.Count - 1)] -join ' ') } else { '' }
    # First line may be "Pedido prompt..." without break — split on first short word row
    if (-not $sub -and $title.Length -gt 18) {
      $words = $title -split '\s+'
      if ($words.Count -ge 2) {
        $title = $words[0]
        $sub = ($words[1..($words.Count - 1)] -join ' ')
      }
    }
    $cands += @{ title = $title; sub = $sub; Left = [double]$sh.Left; Top = $top; Band = [int]([Math]::Round($top / 30.0) * 30) }
  }
  if ($cands.Count -eq 0) { return , @() }
  $bestBand = ($cands | Group-Object { $_.Band } | Sort-Object Count -Descending | Select-Object -First 1).Name
  $bandInt = [int]$bestBand
  return , @($cands | Where-Object { $_.Band -eq $bandInt } | Sort-Object { $_.Left })
}

function Get-ProcessProse($origSlide) {
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $top = Invoke-ComRetry { [double]$sh.Top }
    $w = Invoke-ComRetry { [double]$sh.Width }
    if ($top -lt 150 -or $top -gt 450) { continue }
    if ($w -lt 400) { continue }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -eq 'rodape') { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    if ($tx) { return $tx }
  }
  return ''
}

function Rebuild-TableSlide($fitSlide, $origSlide, [int[]]$monoCols, [double]$tableH) {
  $title = Get-OrigTitle $origSlide
  $refs = Get-OrigRefs $origSlide
  $tbl = Get-OrigTable $origSlide
  if (-not $tbl) { Log "  NO TABLE"; return }
  $notes = Get-OrigNotes $origSlide ($tbl.T + $tbl.H - 5)
  Clear-ContentArea $fitSlide
  Ensure-TopBar $fitSlide $green
  Add-Title $fitSlide $title | Out-Null
  $top = 82.0
  $availBottom = 470.0
  if ($notes.Count -gt 0) {
    $noteH = [Math]::Min(110.0, ($notes | ForEach-Object { $_.Height } | Measure-Object -Sum).Sum + 8)
    $availBottom = 470.0 - $noteH - 8
  }
  $h = if ($tableH -gt 0) { [Math]::Min($tableH, $availBottom - $top) } else { $availBottom - $top }
  Add-Fit796Table $fitSlide $tbl.Rows 50.4 $top 859 $h $monoCols | Out-Null
  $noteTop = $top + $h + 8
  foreach ($nt in $notes) {
    $remaining = 478 - $noteTop
    if ($remaining -lt 20) { break }
    Add-NoteBox $fitSlide $nt.Text 50.4 $noteTop 859 ([Math]::Min($nt.Height + 10, $remaining)) | Out-Null
    $noteTop += [Math]::Min($nt.Height + 14, $remaining)
  }
  Add-Refs $fitSlide $refs | Out-Null
  Log ("  table {0}x{1} notes={2}" -f $tbl.Rows.Count, $tbl.Rows[0].Count, $notes.Count)
}

function Rebuild-ProcessSlide($fitSlide, $origSlide) {
  $title = Get-OrigTitle $origSlide
  $refs = Get-OrigRefs $origSlide
  $steps = Get-ProcessSteps $origSlide
  $prose = Get-ProcessProse $origSlide
  Clear-ContentArea $fitSlide
  Ensure-TopBar $fitSlide $green
  Add-Title $fitSlide $title | Out-Null
  Add-ProcessFlow $fitSlide $steps 50.4 88 859 70
  if ($prose) {
    Add-NoteBox $fitSlide $prose 50.4 172 859 290 | Out-Null
  }
  Add-Refs $fitSlide $refs | Out-Null
  Log ("  process steps={0}" -f $steps.Count)
}

function Rebuild-TreeSlide($fitSlide, $origSlide) {
  $title = Get-OrigTitle $origSlide
  $refs = Get-OrigRefs $origSlide
  # find tree text and bullets
  $treeRaw = ''
  $bullets = ''
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -eq 'rodape' -or $name -like 'Text *' -or $name -like '*Placeholder*') { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    if ($tx -match [regex]::Escape([char]0x251C) -or $tx -match [regex]::Escape([char]0x2514) -or $tx -match 'vcu-milho') { $treeRaw = $tx }
    elseif ($tx -and (Invoke-ComRetry { [double]$sh.Top }) -gt 250) { $bullets = $tx }
  }
  $lines = Format-TreeLinesFromText $treeRaw
  Clear-ContentArea $fitSlide
  Ensure-TopBar $fitSlide $green
  Add-Title $fitSlide $title | Out-Null
  Add-CodeBox $fitSlide 50.4 86 859 300 $lines 11 | Out-Null
  if ($bullets) {
    Add-NoteBox $fitSlide $bullets 50.4 398 859 75 | Out-Null
  }
  Add-Refs $fitSlide $refs | Out-Null
  Log ("  tree lines={0}" -f $lines.Count)
}

function Rebuild-CodeBulletsSlide($fitSlide, $origSlide) {
  # slide 11 style: code block + all prose bullets
  $title = Get-OrigTitle $origSlide
  $refs = Get-OrigRefs $origSlide
  $codeRaw = ''
  $prose = ''
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -eq 'rodape' -or $name -like 'Text *' -or $name -like '*Placeholder*') { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    $top = Invoke-ComRetry { [double]$sh.Top }
    if ($tx -match 'claude --version|claude doctor' -or $tx -match '(?m)^\s*claude\b') { $codeRaw = $tx }
    elseif ($tx -and $top -gt 140) { $prose = $tx }
  }
  $codeLines = @($codeRaw -split "`r`n|`n|`r" | ForEach-Object { $_.TrimEnd() } | Where-Object { $_.Length -gt 0 })
  Clear-ContentArea $fitSlide
  Ensure-TopBar $fitSlide $green
  Add-Title $fitSlide $title | Out-Null
  Add-CodeBox $fitSlide 50.4 86 859 110 $codeLines 13 | Out-Null
  if ($prose) {
    Add-NoteBox $fitSlide $prose 50.4 210 859 260 | Out-Null
  }
  Add-Refs $fitSlide $refs | Out-Null
  Log ("  code+prose lines={0}" -f $codeLines.Count)
}

function Rebuild-TwoColumnSlide($fitSlide, $origSlide) {
  $title = Get-OrigTitle $origSlide
  $refs = Get-OrigRefs $origSlide
  $leftTitle = ''; $leftBody = ''; $rightTitle = ''; $rightBody = ''; $footer = ''
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -eq 'rodape' -or $name -like 'Text *' -or $name -like '*Placeholder*') { continue }
    if ((Invoke-ComRetry { [int]$sh.Type }) -eq 1 -and (Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    if (-not $tx) { continue }
    $left = Invoke-ComRetry { [double]$sh.Left }
    $top = Invoke-ComRetry { [double]$sh.Top }
    if ($top -gt 340 -and $left -gt 400) { $footer = $tx; continue }
    if ($left -lt 250) {
      if ($top -lt 110) { $leftTitle = $tx }
      elseif (-not $leftBody) { $leftBody = $tx }
      else { $leftBody = $leftBody + "`r`n" + $tx }
    } else {
      if ($top -lt 110) { $rightTitle = $tx }
      elseif (-not $rightBody) { $rightBody = $tx }
      else { $rightBody = $rightBody + "`r`n" + $tx }
    }
  }
  Clear-ContentArea $fitSlide
  Ensure-TopBar $fitSlide $green
  Add-Title $fitSlide $title | Out-Null
  # left panel
  $lb = Invoke-ComRetry { $fitSlide.Shapes.AddShape(5, 50.4, 90, 420, 250) }
  $lb.Adjustments.Item(1) = 0.06
  $lb.Fill.Solid(); $lb.Fill.ForeColor.RGB = $lightGreen
  $lb.Line.ForeColor.RGB = $green; $lb.Line.Weight = 1.25
  $lb.Name = 'ColLeft'
  $tf = $lb.TextFrame
  $tf.MarginLeft = 12; $tf.MarginRight = 10; $tf.MarginTop = 10; $tf.MarginBottom = 8
  $tf.TextRange.Text = "$leftTitle`r`r$leftBody"
  $tf.TextRange.Font.Name = 'DejaVu Sans'; $tf.TextRange.Font.Size = 13; $tf.TextRange.Font.Color.RGB = $ink
  try { $tf.TextRange.Paragraphs(1).Font.Name = 'DejaVu Serif'; $tf.TextRange.Paragraphs(1).Font.Bold = $true; $tf.TextRange.Paragraphs(1).Font.Size = 15; $tf.TextRange.Paragraphs(1).Font.Color.RGB = $green } catch {}
  # right panel
  $rb = Invoke-ComRetry { $fitSlide.Shapes.AddShape(5, 490, 90, 420, 250) }
  $rb.Adjustments.Item(1) = 0.06
  $rb.Fill.Solid(); $rb.Fill.ForeColor.RGB = $cream
  $rb.Line.ForeColor.RGB = $amber; $rb.Line.Weight = 1.25
  $rb.Name = 'ColRight'
  $tf2 = $rb.TextFrame
  $tf2.MarginLeft = 12; $tf2.MarginRight = 10; $tf2.MarginTop = 10; $tf2.MarginBottom = 8
  $tf2.TextRange.Text = "$rightTitle`r`r$rightBody"
  $tf2.TextRange.Font.Name = 'DejaVu Sans'; $tf2.TextRange.Font.Size = 13; $tf2.TextRange.Font.Color.RGB = $ink
  try { $tf2.TextRange.Paragraphs(1).Font.Name = 'DejaVu Serif'; $tf2.TextRange.Paragraphs(1).Font.Bold = $true; $tf2.TextRange.Paragraphs(1).Font.Size = 15; $tf2.TextRange.Paragraphs(1).Font.Color.RGB = $rust } catch {}
  if ($footer) {
    Add-NoteBox $fitSlide $footer 50.4 355 859 110 | Out-Null
  }
  Add-Refs $fitSlide $refs | Out-Null
  Log '  two-column'
}

function Rebuild-BulletsFromOrig($fitSlide, $origSlide) {
  # Preserve all paragraphs as note block (for slides that were prose, e.g. 8)
  $title = Get-OrigTitle $origSlide
  $refs = Get-OrigRefs $origSlide
  $body = ''
  $n = Invoke-ComRetry { $origSlide.Shapes.Count }
  for ($i = 1; $i -le $n; $i++) {
    $sh = Invoke-ComRetry { $origSlide.Shapes.Item($i) }
    if ((Invoke-ComRetry { $sh.HasTextFrame }) -ne -1) { continue }
    $name = Invoke-ComRetry { $sh.Name }
    if ($name -eq 'rodape' -or $name -like 'Text *' -or $name -like '*Placeholder*') { continue }
    $top = Invoke-ComRetry { [double]$sh.Top }
    if ($top -lt 70 -or $top -gt 480) { continue }
    $tx = (Invoke-ComRetry { $sh.TextFrame.TextRange.Text }).Trim()
    if ($tx) { $body = if ($body) { $body + "`r`n`r`n" + $tx } else { $tx } }
  }
  Clear-ContentArea $fitSlide
  Ensure-TopBar $fitSlide $green
  Add-Title $fitSlide $title | Out-Null
  # split into visual bullets with ovals
  $paras = @($body -split "`r`n|`n|`r" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  $tops = @(100, 180, 260, 340, 400)
  for ($i = 0; $i -lt [Math]::Min($paras.Count, 5); $i++) {
    $ov = Invoke-ComRetry { $fitSlide.Shapes.AddShape(9, 56.2, ($tops[$i] + 8), 11.5, 11.5) }
    $ov.Fill.Solid(); $ov.Fill.ForeColor.RGB = $amber; $ov.Line.Visible = 0; $ov.Name = "Oval$i"
    Add-NoteBox $fitSlide $paras[$i] 82.8 $tops[$i] 820 70 | Out-Null
  }
  Add-Refs $fitSlide $refs | Out-Null
  Log ("  bullets paras={0}" -f $paras.Count)
}

# ---- main ----
Get-Process POWERPNT -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

$repo = 'C:\Users\goljz\OneDrive - Bayer\Share_Files\Curso_AI_UFV_2026'
$f05 = Get-ChildItem $repo -Directory | Where-Object { $_.Name -match '^05' } | Select-Object -First 1
$destFit = [IO.Directory]::GetFiles($f05.FullName, '*FIT796*.pptx') | Select-Object -First 1
$destOrig = [IO.Directory]::GetFiles($f05.FullName, '*.pptx') | Where-Object { $_ -notmatch 'FIT796' } | Select-Object -First 1

$localFit = Join-Path $work 'deck_work.pptx'
$localOrig = Join-Path $work 'orig.pptx'
Copy-Item -LiteralPath $destFit -Destination $localFit -Force
Copy-Item -LiteralPath $destOrig -Destination $localOrig -Force
Log "fit=$localFit"
Log "orig=$localOrig"

$ppt = New-Object -ComObject PowerPoint.Application
$orig = $ppt.Presentations.Open($localOrig, $true, $false, $true)
$fit = $ppt.Presentations.Open($localFit, $false, $false, $true)
Log ("opened orig={0} fit={1}" -f $orig.Slides.Count, $fit.Slides.Count)

$partial = $env:FIT796_PARTIAL -eq '1'

if (-not $partial) {
  $tableJobs = @(
    @{ i = 2; mono = @(); h = 340 }
    @{ i = 4; mono = @(); h = 160 }
    @{ i = 6; mono = @(); h = 90 }
    @{ i = 9; mono = @(); h = 280 }
    @{ i = 12; mono = @(); h = 220 }
    @{ i = 14; mono = @(2); h = 150 }
    @{ i = 15; mono = @(1); h = 230 }
    @{ i = 23; mono = @(); h = 220 }
    @{ i = 24; mono = @(); h = 220 }
    @{ i = 26; mono = @(); h = 200 }
    @{ i = 33; mono = @(); h = 220 }
    @{ i = 37; mono = @(); h = 200 }
    @{ i = 39; mono = @(); h = 220 }
    @{ i = 40; mono = @(); h = 200 }
    @{ i = 41; mono = @(); h = 200 }
    @{ i = 44; mono = @(1); h = 280 }
    @{ i = 53; mono = @(); h = 200 }
    @{ i = 57; mono = @(); h = 200 }
    @{ i = 58; mono = @(); h = 200 }
  )
  foreach ($job in $tableJobs) {
    $idx = $job.i
    Log "TABLE $idx"
    try {
      Rebuild-TableSlide $fit.Slides.Item($idx) $orig.Slides.Item($idx) $job.mono $job.h
    } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
  }
} else {
  Log 'PARTIAL: table 9 + process + verify'
  try {
    Rebuild-TableSlide $fit.Slides.Item(9) $orig.Slides.Item(9) @() 280
  } catch { Log ("  TABLE9 ERR {0}" -f $_.Exception.Message) }
}

foreach ($idx in @(5, 17, 30, 50)) {
  Log "PROCESS $idx"
  try {
    Rebuild-ProcessSlide $fit.Slides.Item($idx) $orig.Slides.Item($idx)
  } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
}

if (-not $partial) {
  Log 'TREE 21'
  try { Rebuild-TreeSlide $fit.Slides.Item(21) $orig.Slides.Item(21) } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
  Log 'CODE 11'
  try { Rebuild-CodeBulletsSlide $fit.Slides.Item(11) $orig.Slides.Item(11) } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
  Log 'COLUMNS 34'
  try { Rebuild-TwoColumnSlide $fit.Slides.Item(34) $orig.Slides.Item(34) } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
  Log 'BULLETS 8'
  try { Rebuild-BulletsFromOrig $fit.Slides.Item(8) $orig.Slides.Item(8) } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
}

foreach ($idx in @(7, 13)) {
  Log ("SECTION check {0}" -f $idx)
  try {
    $fs = $fit.Slides.Item($idx)
    $hasText = $false
    $n = $fs.Shapes.Count
    for ($i = 1; $i -le $n; $i++) {
      $sh = $fs.Shapes.Item($i)
      if ($sh.HasTextFrame -eq -1 -and $sh.TextFrame.TextRange.Text.Trim().Length -gt 10) { $hasText = $true; break }
    }
    if ($hasText) { Log '  section ok' } else { Log '  section missing text' }
  } catch { Log ("  ERR {0}" -f $_.Exception.Message) }
}

if (Test-Path $pngDir) { Remove-Item $pngDir -Recurse -Force }
New-Item -ItemType Directory -Path $pngDir | Out-Null
$qa = @(2, 5, 8, 11, 12, 14, 15, 21, 34, 44)
foreach ($i in $qa) {
  try {
    $fit.Slides.Item($i).Export((Join-Path $pngDir ("s{0:D2}.png" -f $i)), 'PNG', 1280, 720)
    Log "PNG $i"
  } catch { Log "PNG ERR $i $($_.Exception.Message)" }
}

$fit.Save()
$fit.Close()
$orig.Close()
$ppt.Quit()
[GC]::Collect()
Start-Sleep -Seconds 2

Copy-Item -LiteralPath $localFit -Destination $destFit -Force
Copy-Item -LiteralPath $localFit -Destination (Join-Path $work 'Claude_Code_VSCode_FIT796.pptx') -Force
Log ("saved to {0}" -f $destFit)
Log 'DONE'
