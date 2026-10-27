# FIT 796 slide layout — referência completa

Fonte de verdade visual:  
`14. Tendências Futuras, Perguntas e Fechamento_Todos/Review/artifacts/AI_Plant_Breeding_Fechamento_2026_PT.pptx`  
Template de clonagem:  
`.../Review/artifacts/AI_Plant_Breeding_Future_2026.pptx`  
Build de exemplo:  
`.../Review/artifacts/_build_fechamento.ps1` + `_fechamento_spec.json`  
Build com `Add-CodeBox` + campo `code` no spec:  
`08. Otimização e Simulação_Eder/_build_otimizacao_fit796.ps1`  
Guia editorial (EN):  
`.../Review/artifacts/AI_Plant_Breeding_Future_2026_slide_guide.md`

Unidades: **pontos PowerPoint** no canvas **960 × 540** (16:9).  
COM `Color.RGB` = `R + G×256 + B×65536` (inteiros abaixo).

---

## Paleta

| Token | Hex | COM RGB | Uso |
| --- | --- | --- | --- |
| `green` | `#4A7C59` | `5864522` | Fundo capa/seção; barra e título de conteúdo; card 1 |
| `cream` | `#F5F3ED` | `15594485` | Fundo slides de conteúdo; faixa inferior da capa |
| `rust` | `#B7472A` | `2770871` | Statement: barra, título, ovais; card 4 |
| `amber` | `#F9A620` | `2139897` | Traço da seção; ovais de conteúdo; card 3 |
| `ink` | `#2E3A2F` | `3095086` | Corpo dos bullets; texto em cards claros |
| `lightGreen` | `#D8E4DA` | `14345432` | Subtítulo em fundo verde; card 2 |
| `muted` | `#6B6B6B` | `7039851` | Rodapé de refs; subtítulo de figura; linha de evidência na capa |
| `white` | `#FFFFFF` | `16777215` | Título capa/seção; texto em cards verde/ferrugem |
| `codeBg` | `#2E3A2F` | `3095086` | Fundo do code box (= `ink`); painel de código/árvore/path |
| `codeFg` | `#F5F3ED` | `15594485` | Texto mono no code box (= `cream`) |
| `codeMuted` | `#D8E4DA` | `14345432` | Comentários / prompt secundário no code box (= `lightGreen`) |
| `codeAccent` | `#F9A620` | `2139897` | Faixa vertical esquerda do code box (= `amber`) |

O *theme* OOXML do arquivo ainda lista Calibri + acentos Office padrão — **ignorar**. As cores reais estão nas formas, não no `clrScheme`.

---

## Tipografia

| Papel | Fonte | Peso | Tamanho típico | Cor |
| --- | --- | --- | --- | --- |
| Título capa | DejaVu Serif | Bold | 50 | white |
| Título seção / fechamento | DejaVu Serif | Bold | 44 | white |
| Título statement | DejaVu Serif | Bold | 40 | rust |
| Título conteúdo / figura / cards | DejaVu Serif | Bold | 32 | green |
| Subtítulo capa | DejaVu Sans | Regular | 19 | lightGreen |
| Meta capa (curso/data) | DejaVu Sans | Bold | 17 | green |
| Evidência capa | DejaVu Sans | Regular | 12 | muted |
| Subtítulo seção | DejaVu Sans | Regular | 22 | lightGreen |
| Subtítulo figura | DejaVu Sans | Regular | 16 | muted |
| Bullet statement (4) | DejaVu Sans | Regular | **20–21** (mín. fit **14**) | ink |
| Bullet conteúdo (4–5) | DejaVu Sans | Regular | **19–21** (mín. fit **14**) | ink |
| Rodapé refs | DejaVu Sans | Regular | 10 (mín. ~8) | muted |
| Header de card | DejaVu Serif | Bold | 16 | white ou ink |
| Itens de card | DejaVu Sans | Regular | 13 | white ou ink |
| Code box (corpo) | DejaVu Sans Mono (fallback Consolas) | Regular | 12–14 | codeFg |
| Code box (comentário) | mesma mono | Regular | 11–13 | codeMuted |

### Bullets — espaçamento interno (obrigatório em 4–5 itens)

| Propriedade COM | Valor | Motivo |
| --- | --- | --- |
| `ParagraphFormat.SpaceBefore` | `6` | caixa com ≥ 2 bullets: 6 pt antes de cada parágrafo |
| `ParagraphFormat.SpaceAfter` | `6` | idem, depois de cada parágrafo. Parágrafo único: `0` / `0` |
| `ParagraphFormat.SpaceWithin` | `0.90`–`0.95` | entrelinha mais fechada (letras maiores cabem) |
| `TextFrame.MarginTop` / `MarginBottom` | `2` | caixa mais “cheia” |
| `TextFrame.MarginLeft` / `MarginRight` | `7.2` | manter |

Caixa com um só parágrafo: zerar `SpaceBefore` e `SpaceAfter`. Caixa com ≥ 2 bullets (ou ≥ 2 parágrafos): **6 pt antes e 6 pt depois de cada parágrafo**. Não herdar o `SpaceAfter` do template inglês.

Fit automático (como no build):

- Título: enquanto `BoundHeight > 1.6 × Font.Size` e size > 24 → size − 1.
- Bullet: **começar em 20–21 pt**; enquanto overflow da caixa e size > **14** → size − 1; depois equalizar todos os bullets ao menor size do slide. **Piso duro: 14 pt** — nunca reduzir a explicação do bullet abaixo de 14; se ainda overflow, enxugar o texto ou mudar o tipo de slide.
- Code box: enquanto `BoundHeight > Height − 8` e size > 11 → size − 1.
- Refs: mínimo 8 pt.

```powershell
function Set-BulletTypography($sh, [double]$startSize = 20, [double]$minSize = 14) {
  $tf = $sh.TextFrame
  $tf.MarginTop = 2; $tf.MarginBottom = 2
  $tf.MarginLeft = 7.2; $tf.MarginRight = 7.2
  $tr = $tf.TextRange
  $tr.Font.Name = "DejaVu Sans"
  $tr.Font.Size = $startSize
  $tr.ParagraphFormat.SpaceBefore = 6
  $tr.ParagraphFormat.SpaceAfter = 6
  $tr.ParagraphFormat.SpaceWithin = 0.92
  while (($tr.BoundHeight -gt ($sh.Height + 2)) -and ($tr.Font.Size -gt $minSize)) {
    $tr.Font.Size = $tr.Font.Size - 1
  }
}

function Tighten-BulletStack($slide, [double]$factor = 0.90) {
  # So comprimir passo vertical se nenhum bullet estoura 2 linhas (evita overlap)
  $boxes = @($slide.Shapes | Where-Object {
    $_.HasTextFrame -eq -1 -and $_.Type -eq 17 -and [Math]::Abs($_.Left - 83) -lt 3 -and
    $_.TextFrame.TextRange.Text.Trim().Length -gt 0
  } | Sort-Object Top)
  $ovals = @($slide.Shapes | Where-Object { $_.Name -like "Oval*" } | Sort-Object Top)
  if ($boxes.Count -lt 4) { return }
  foreach ($bx in $boxes) {
    $tr = $bx.TextFrame.TextRange
    if ($tr.BoundHeight -gt (2.2 * $tr.Font.Size)) { return }  # multi-line denso: nao apertar stack
  }
  $base = $boxes[0].Top
  $ovalBase = if ($ovals.Count -gt 0) { $ovals[0].Top } else { $base }
  for ($i = 1; $i -lt $boxes.Count; $i++) {
    $boxes[$i].Top = $base + (($boxes[$i].Top - $base) * $factor)
    if ($i -lt $ovals.Count) {
      $ovals[$i].Top = $ovalBase + (($ovals[$i].Top - $ovalBase) * $factor)
    }
  }
}
```

---

## Tipos de slide — geometria

### 1. Capa (`cover`)

- `FollowMasterBackground = false`; fundo slide = `green`.
- Faixa creme: Rectangle `L=0 T=399.6 W=960 H=140.4`, fill `cream`.
- Título: TextBox `L=64.8 T=126 W=835.2 H≈132`, Serif 50 white bold.
- Subtítulo: `L=64.8 T=313.2 W=835.2 H=32`, Sans 19 lightGreen.
- Meta: `L=64.8 T=421.2 W=835.2 H≈28`, Sans 17 green bold.
- Evidência: `L=64.8 T=457.2 W=835.2 H≈36`, Sans 12 muted.

### 2. Seção (`section`) e fechamento

- Fundo `green`.
- Título: `L=79.2 T=187.2 W=806.4 H≈61`, Serif 44 white bold.
- Subtítulo (seção): `L=79.2 T=291.6 W=806.4 H≈36`, Sans 22 lightGreen.
- Traço: Rectangle `L=79.2 T=282.2 W=158.4 H=4`, fill `amber` (entre título e subtítulo).
- Fechamento: mesmo bloco de título + traço; subtítulo opcional (ex. só “Obrigado”).

### 3. Statement (`statement`) — destaque, acento ferrugem

- Fundo `cream`.
- Barra topo: `L=0 T=0 W=960 H=11.5`, fill `rust`.
- Título: `L=50.4 T=36 W=864 H≈56`, Serif **40** rust bold.
- **4** pares oval + textbox (passo vertical ≈ 83,5 pt):

| # | Oval Top | TextBox Top | TextBox |
| --- | --- | --- | --- |
| 1 | 152.6 | 140.4 | `L=82.8 W=813.6 H=58.8` |
| 2 | 236.2 | 223.9 | idem |
| 3 | 319.7 | 307.4 | idem |
| 4 | 403.2 | 391.0 | idem |

- Oval: `L=56.2 W=H≈12.2`, fill `rust`.
- Bullet: Sans **20–21** ink; `Set-BulletTypography` (SpaceWithin 0.92; margins T/B 2); WordWrap on; VerticalAnchor top; align left.
- Refs: `L=39.6 T=483.8 W=882 H≈19–32`, Sans 10 muted.

### 4. Bullets conteúdo — 4 itens (`bullets-4`)

- Fundo `cream`; barra topo `green` `H=11.5`.
- Título: `L=50.4 T≈30 W=864 H≈46`, Serif **32** green bold.
- Ovais fill `amber` (conteúdo) — no deck Fechamento, statement usa rust; conteúdo usa amber ou rust herdado do clone (manter a cor do slide-fonte).
- Geometria dos 4 bullets: mesma da tabela statement (Tops 126.7 / 198.7 / … em alguns clones 5-bullet; nos 4-bullet statement: 152.6…).
- Tipografia: `Set-BulletTypography $box 20 16`; equalizar sizes; opcional `Tighten-BulletStack $slide 0.90`.
- Preferir **clonar** o slide-fonte certo a recalcular Tops.

### 5. Bullets conteúdo — 5 itens (`bullets-5`)

- Barra `green`; título Serif 32 green.
- Cinco pares; passo vertical ≈ 72 pt (pode comprimir com `Tighten-BulletStack` ~0.88–0.92):

| # | Oval Top | TextBox Top | TextBox H |
| --- | --- | --- | --- |
| 1 | 126.7 | 115.2 | 52.6 |
| 2 | 198.7 | 187.2 | 52.6 |
| 3 | 270.7 | 259.2 | 52.6 |
| 4 | 342.7 | 331.2 | 52.6 |
| 5 | 414.7 | 403.2 | 52.6 |

- Oval ≈ `L=56.2 W=H=11.5`, fill accent do template.
- Bullet Sans **19–21** ink (`Set-BulletTypography $box 20 16`); refs iguais.
- Com 5 bullets, preferir fonte ≥ 18 após o fit; se ainda overflow, enxugar o texto antes de baixar de 16.

Detecção no COM: textboxes de bullet ≈ `Left ≈ 83` (±3); ovais `Name like Oval*`.

### 6. Figura (`figure`)

- Barra `green`; título Serif 32 green `T≈28.8`.
- Subtítulo: `L=50.4 T=77.8 W=864 H≈27`, Sans 16 muted.
- Picture: Top ≈ 116.6; largura/altura variam (centralizar visualmente). Exemplos do Fechamento:

| Variante | Left | Width | Height |
| --- | --- | --- | --- |
| Larga | 44.4 | 871.2 | 290–334 |
| Média | 92–144 | 670–775 | 358.6 |
| Estreita | 298.3 | 363.4 | 358.6 |

- Refs no mesmo rodapé `T=483.8`.

### 7. Cards / mapa (`cards`)

Usado no Fechamento (slide “quatro anéis”); construído com `AddShape(5, …)` rounded rect:

- Área: `L=44 T=124`, card `W=207 H=350`, gap `G=14` → 4 colunas.
- Corner adjust ≈ `0.06`; sem linha; sem sombra.
- Fills na ordem: `green`, `lightGreen`, `amber`, `rust`.
- Texto FG: white, ink, ink, white.
- Margens TextFrame: L12 R10 T14 B10; header Serif 16 bold SpaceAfter 12; itens Sans 13 SpaceAfter 5.

Função de referência no build: `Add-Card` em `_build_fechamento.ps1`.

### 8. Code box — código / pasta (`codebox`)

Usar quando o material de origem traz **comando**, **snippet**, **árvore de diretórios** ou **caminho de arquivo**. Não existe slide-fonte dedicado no Future_2026: clonar **figura** (src típico 3) ou **bullets**, limpar a área útil e desenhar o painel com `Add-CodeBox`.

**Composição típica**

| Variante | Uso | Área do painel (pt) |
| --- | --- | --- |
| `code-full` | Só título + code box (instalação, `CLAUDE.md`, prompt longo) | `L=50.4 T=100 W=859 H=360` |
| `code-full` + subtítulo | Título + TextBox 3 + painel | `L=50.4 T≈122 W=859 H≈338` |
| `code-after-bullets` | 1–2 bullets curtos + code box abaixo | `L=50.4 T=220 W=859 H=240` |
| `code-compact` | Path ou 2–4 linhas sob subtítulo | `L=50.4 T=120 W=859 H=120` |
| `code-compact` + subtítulo | Idem, com folga sob TextBox 3 | `L=50.4 T≈128 W=859 H≈140–150` |

**Anti-overlap (obrigatório)**

O subtítulo de figura (`TextBox 3`, Top ≈ 78, Height ≈ 36 → fundo ≈ 114) e o rodapé de refs (Top ≈ 484) delimitam a faixa útil. Não usar `T=100` / `H=360` quando houver subtítulo — o painel corta o texto.

| Zona | Regra (pt) | Alvo observado no deck Otimização |
| --- | --- | --- |
| Acima | `code.Top ≥ bottom(título\|subtítulo) + gap` | gap **10** mín.; típico **16–24** |
| Abaixo | `code.Bottom ≤ refs.Top − gap` | gap **10** mín.; típico **20–24** |
| Altura | `H = min(H_desejada, bottomMax − Top)` | se `H < 80`, avisar / enxugar `lines` |

Fluxo no build:

1. `Get-CodeBoxRect $variant $hasSubtitle` — geometria inicial (com subtítulo já deslocada).
2. `Resolve-CodeBoxLayout $slide $rect 10` — mede shapes reais de texto (Top < 90 = título/subtítulo; Top > 450 = refs) e corrige `T`/`H`.
3. `Add-CodeBox …` com o retângulo resolvido.
4. QA COM: para cada `CodeBox`, nenhum textbox (exceto `CodeBox*`) com intervalos verticais intersectando; reportar `gapAbove` / `gapBelow`.

Implementação de referência: `08. Otimização e Simulação_Eder/_build_otimizacao_fit796.ps1` (`Resolve-CodeBoxLayout`, `Get-CodeBoxRect`).

**Formas (de trás para frente)**

1. Rounded rect painel: `AddShape(5, L, T, W, H)`, `Adjustments(1)=0.04`, fill `codeBg`, sem linha, sem sombra. `Name = "CodeBox"`.
2. Faixa accent: Rectangle `L, T, 6, H`, fill `codeAccent`, sem linha. `Name = "CodeBoxAccent"`.
3. Texto: no TextFrame do painel (ou TextBox sobreposto `L+18`).

**Texto**

- Fonte: `DejaVu Sans Mono` se instalada; senão `Consolas`.
- Cor padrão `codeFg`; linhas que começam com `#` ou `//` → `codeMuted` (opcional, por parágrafo).
- `WordWrap = on`; `MarginLeft≈18`, `MarginRight≈14`, `MarginTop/Bottom≈12`.
- Quebras: `` `r `` entre linhas (PowerPoint COM).
- Não usar syntax highlight multicolor; no máximo dois tons (`codeFg` / `codeMuted`).

**Detecção a partir do PPTX original**

| Sinal | Ação |
| --- | --- |
| Shape com fonte Courier / Consolas / mono | extrair para `code.lines` |
| Texto com `├──` `└──` `│` ou indentação de árvore | `lang: "tree"` |
| Linhas `curl` / `irm` / `claude ` / `Rscript` / `install.packages` | `lang: "shell"` ou `"r"` |
| Bloco `{ … "permissions"` / YAML `---` | `lang: "json"` / `"yaml"` |
| Path isolado (`data/bruto/`, `.claude/settings.json`) | `lang: "path"`; pode ser `code-compact` |

**Helper COM (`Add-CodeBox`)**

```powershell
function Add-CodeBox(
  $slide,
  [double]$left, [double]$top, [double]$w, [double]$h,
  [string[]]$lines,
  [int]$bg = 3095086,      # codeBg / ink
  [int]$fg = 15594485,     # codeFg / cream
  [int]$accent = 2139897,  # amber
  [double]$fontSize = 13
) {
  $panel = $slide.Shapes.AddShape(5, $left, $top, $w, $h)  # rounded rect
  $panel.Adjustments.Item(1) = 0.04
  $panel.Fill.Solid(); $panel.Fill.ForeColor.RGB = $bg; $panel.Fill.Transparency = 0
  $panel.Line.Visible = 0; $panel.Shadow.Visible = 0
  $panel.Name = "CodeBox"

  $bar = $slide.Shapes.AddShape(1, $left, $top, 6, $h)     # rectangle
  $bar.Fill.Solid(); $bar.Fill.ForeColor.RGB = $accent
  $bar.Line.Visible = 0; $bar.Name = "CodeBoxAccent"

  $tf = $panel.TextFrame
  $tf.MarginLeft = 18; $tf.MarginRight = 14; $tf.MarginTop = 12; $tf.MarginBottom = 12
  $tf.WordWrap = -1; $tf.VerticalAnchor = 1
  $tf.TextRange.Text = ($lines -join "`r")
  $tf.TextRange.Font.Name = "DejaVu Sans Mono"
  try { if ($tf.TextRange.Font.Name -ne "DejaVu Sans Mono") { $tf.TextRange.Font.Name = "Consolas" } } catch { $tf.TextRange.Font.Name = "Consolas" }
  $tf.TextRange.Font.Size = $fontSize
  $tf.TextRange.Font.Color.RGB = $fg
  $tf.TextRange.ParagraphFormat.SpaceAfter = 3
  $tf.TextRange.ParagraphFormat.Alignment = 1
  while (($tf.TextRange.BoundHeight -gt ($h - 8)) -and ($tf.TextRange.Font.Size -gt 11)) {
    $tf.TextRange.Font.Size = $tf.TextRange.Font.Size - 1
  }
  return $panel
}
```

No build, após clonar o slide-fonte figura:

```powershell
foreach ($sh in @($slide.Shapes | Where-Object { $_.Type -eq 13 })) { $sh.Delete() }  # pictures
$hasSubtitle = $e.set -and ($e.set.PSObject.Properties.Name -contains "TextBox 3")
$rect = Get-CodeBoxRect $variant $hasSubtitle
$rect = Resolve-CodeBoxLayout $slide $rect 10   # anti-overlap título/subtítulo/refs
Add-CodeBox $slide $rect.L $rect.T $rect.W $rect.H $e.code.lines
```

```powershell
function Resolve-CodeBoxLayout($slide, $rect, [double]$gap = 10) {
  $topMin = 100.0; $bottomMax = 472.0
  foreach ($sh in $slide.Shapes) {
    if ($sh.Name -like "CodeBox*") { continue }
    if ($sh.HasTextFrame -ne -1 -or $sh.TextFrame.HasText -ne -1) { continue }
    $t = [double]$sh.Top; $b = $t + [double]$sh.Height
    if ($sh.TextFrame.TextRange.Text.Trim().Length -eq 0) { continue }
    if ($t -lt 90 -and ($b + $gap) -gt $topMin) { $topMin = $b + $gap }
    if ($t -gt 450 -and ($t - $gap) -lt $bottomMax) { $bottomMax = $t - $gap }
  }
  $T = [Math]::Max([double]$rect.T, $topMin)
  $H = [Math]::Min([double]$rect.H, [Math]::Max(80, $bottomMax - $T))
  return @{ L = [double]$rect.L; T = $T; W = [double]$rect.W; H = $H }
}
```

### Árvore de pastas (`lang: tree`)

Árvore de projeto (ex. `vcu-milho-2025/`) **não** é bullet. Usar code box com:

1. Caracteres box-drawing (`├──` `└──` `│`).
2. **Coluna de comentários alinhada** — pad da parte esquerda até largura fixa (ex. 28–34 chars) e depois o comentário.
3. Comentários em `codeMuted` quando possível (parágrafos que não são só path).
4. Preservar **todas** as linhas do original (não fundir pastas nem omitir `data/intermediario/`).

```powershell
function Format-TreeLines([object[]]$rows, [int]$pad = 32) {
  # $rows: @{ path = "├── CLAUDE.md"; note = "contexto e regras…" }  (note opcional)
  $out = @()
  foreach ($r in $rows) {
    $p = [string]$r.path
    $n = [string]$r.note
    if ([string]::IsNullOrWhiteSpace($n)) { $out += $p; continue }
    if ($p.Length -ge $pad) { $out += ($p + "  " + $n) }
    else { $out += ($p.PadRight($pad) + $n) }
  }
  return $out
}
```

No code box de árvore: `TextFrame.WordWrap = 0` (desligado) — wrap quebra a coluna de comentários. Preferir `Consolas` / `DejaVu Sans Mono` 11–13 pt; se ainda apertar, reduzir size, não ativar wrap.

**Recomendado para árvores com notas:** painel `CodeBox` + tabela 2 colunas sem bordas (fill `codeBg`), col1 path mono `codeFg`, col2 nota mono `codeMuted`. Evita desalinhamento por largura variável de `├──`/`└──` em `PadRight`.

---

### 9. Tabela (`table`)

Quando o original tem `Shape.Type = 19`, o slide FIT 796 **deve** manter uma tabela nativa (não bullets com `|`).

**Composição**

- Fundo `cream`; barra topo `green`; título Serif 32 green.
- Tabela: `Shapes.AddTable(rows, cols, L, T, W, H)` na área útil sob o título.
- Área típica: `L=50.4 T≈88 W=859 H` até ~24 pt acima das notas/refs.
- Notas / bullets sob a tabela (Sans 14–16 ink); refs `T≈484`.

**Estilo das células**

| Região | Fill | Texto | Fonte |
| --- | --- | --- | --- |
| Cabeçalho (linha 1) | `green` | `white` bold | DejaVu Sans **15–16** (mín. **14**) |
| Corpo (linhas pares) | `cream` | `ink` | Sans **14–15** (mín. **14**) |
| Corpo (linhas ímpares) | `lightGreen` (suave) ou cream | `ink` | Sans **14–15** (mín. **14**) |
| Coluna comando/path/código | — | `ink` ou green | **DejaVu Sans Mono** **14** |

- Sem bordas pesadas: linha preferencialmente `muted` fina ou só fill zebrado.
- **Todas as células** do original; se não couber, aumentar `H` da tabela / reduzir margens das células — **piso duro 14 pt**, nunca cortar com `…` nem baixar de 14.
- Spec: `"table": { "headers": [...], "rows": [[...], ...], "monoCols": [1] }`.

```powershell
function Add-Fit796Table(
  $slide, [string[][]]$cells,
  [double]$left = 50.4, [double]$top = 88, [double]$w = 859, [double]$h = 300,
  [int[]]$monoCols = @(),
  [int]$green = 5864522, [int]$cream = 15594485, [int]$ink = 3095086,
  [int]$lightGreen = 14345432, [int]$white = 16777215
) {
  $nR = $cells.Count; $nC = $cells[0].Count
  $tblShape = $slide.Shapes.AddTable($nR, $nC, $left, $top, $w, $h)
  $tbl = $tblShape.Table
  $tblShape.Name = "Fit796Table"
  for ($r = 1; $r -le $nR; $r++) {
    for ($c = 1; $c -le $nC; $c++) {
      $cell = $tbl.Cell($r, $c)
      $tr = $cell.Shape.TextFrame.TextRange
      $tr.Text = [string]$cells[$r-1][$c-1]
      $tr.Font.Name = if ($monoCols -contains $c) { "DejaVu Sans Mono" } else { "DejaVu Sans" }
      $tr.Font.Size = if ($r -eq 1) { 15 } else { 14 }   # piso 14 pt
      $tr.ParagraphFormat.SpaceBefore = 0
      $tr.ParagraphFormat.SpaceAfter = 0
      $tr.ParagraphFormat.SpaceWithin = 0.92
      $cell.Shape.TextFrame.MarginLeft = 6; $cell.Shape.TextFrame.MarginRight = 4
      $cell.Shape.TextFrame.MarginTop = 3; $cell.Shape.TextFrame.MarginBottom = 3
      if ($r -eq 1) {
        $cell.Shape.Fill.Solid(); $cell.Shape.Fill.ForeColor.RGB = $green
        $tr.Font.Bold = $true; $tr.Font.Color.RGB = $white
      } else {
        $cell.Shape.Fill.Solid()
        $cell.Shape.Fill.ForeColor.RGB = if ($r % 2 -eq 0) { $cream } else { $lightGreen }
        $tr.Font.Color.RGB = $ink
      }
    }
  }
  # Fit: pode reduzir até 14 — nunca abaixo
  $minSize = 14.0
  for ($pass = 0; $pass -lt 4; $pass++) {
    $overflow = $false
    for ($r = 1; $r -le $nR; $r++) {
      for ($c = 1; $c -le $nC; $c++) {
        try {
          $tr = $tbl.Cell($r, $c).Shape.TextFrame.TextRange
          if (([double]$tr.BoundHeight -gt ([double]$tbl.Cell($r, $c).Shape.Height + 2)) -and ([double]$tr.Font.Size -gt $minSize)) {
            $overflow = $true
          }
        } catch {}
      }
    }
    if (-not $overflow) { break }
    for ($r = 1; $r -le $nR; $r++) {
      for ($c = 1; $c -le $nC; $c++) {
        try {
          $tr = $tbl.Cell($r, $c).Shape.TextFrame.TextRange
          if ([double]$tr.Font.Size -gt $minSize) { $tr.Font.Size = [float]([double]$tr.Font.Size - 1) }
        } catch {}
      }
    }
  }
  return $tblShape
}
```

---

### 10. Processo (caixas + setas) (`process`)

Quando o original tem retângulos em sequência com setas (`seta-*` ou AutoShape seta), **não** converter em bullets nem em 4 cards soltos.

**Composição**

- Título Serif 32 green; barra `green`.
- N caixas `AddShape(5, …)` (rounded) na mesma ordem; largura ≈ `(860 − (N−1)×gapArrow) / N`.
- Entre caixas: seta direita `AddShape(33, …)` ou chevron, fill `amber`, ~14×14 pt.
- Texto da caixa: título bold (Serif/Sans 12–14) + subtítulo Sans 10–11; FG white no `green`/`rust`, ink nos claros.
- Fills cíclicos da paleta: `green`, `lightGreen`, `amber`, `rust` (repetir se N>4).
- Prosa / bullets **abaixo** da faixa de processo (preservar todos os pontos do original).
- Refs no rodapé.

```powershell
function Add-ProcessFlow(
  $slide, [hashtable[]]$steps,
  [double]$left = 50.4, [double]$top = 88, [double]$totalW = 859, [double]$boxH = 72,
  [int[]]$fills = @(5864522, 14345432, 2139897, 2770871),
  [int[]]$fgs   = @(16777215, 3095086, 3095086, 16777215),
  [int]$amber = 2139897
) {
  $n = $steps.Count; $gap = 14; $arrowW = 14
  $boxW = ($totalW - ($n - 1) * ($gap + $arrowW)) / $n
  $x = $left
  for ($i = 0; $i -lt $n; $i++) {
    $fi = $fills[$i % $fills.Count]; $fg = $fgs[$i % $fgs.Count]
    $box = $slide.Shapes.AddShape(5, $x, $top, $boxW, $boxH)
    $box.Adjustments.Item(1) = 0.08
    $box.Fill.Solid(); $box.Fill.ForeColor.RGB = $fi
    $box.Line.Visible = 0; $box.Name = "ProcessBox$i"
    $tf = $box.TextFrame
    $tf.MarginLeft = 6; $tf.MarginRight = 6; $tf.MarginTop = 6; $tf.MarginBottom = 4
    $title = [string]$steps[$i].title
    $sub = [string]$steps[$i].sub
    $tf.TextRange.Text = if ($sub) { "$title`r$sub" } else { $title }
    $tf.TextRange.Font.Name = "DejaVu Sans"
    $tf.TextRange.Font.Size = 11
    $tf.TextRange.Font.Color.RGB = $fg
    $tf.TextRange.Paragraphs(1).Font.Bold = $true
    $tf.TextRange.Paragraphs(1).Font.Size = 13
    $x += $boxW
    if ($i -lt $n - 1) {
      $arr = $slide.Shapes.AddShape(33, $x + 2, $top + $boxH/2 - 7, $arrowW, 14)  # right arrow
      $arr.Fill.Solid(); $arr.Fill.ForeColor.RGB = $amber
      $arr.Line.Visible = 0; $arr.Name = "ProcessArrow$i"
      $x += $gap + $arrowW
    }
  }
}
```

---

### 11. Duas colunas (`columns`)

Quando o original tem dois blocos de conteúdo lado a lado (Left ≈ 45 e ≈ 494, ou labels “esquerda/direita”), manter **duas colunas**.

**Composição**

- Título + barra green.
- Coluna E: `L≈50 W≈410`; Coluna D: `L≈500 W≈410`.
- Cada coluna: opcional header Sans/Serif bold + corpo; ou rounded rect fill `lightGreen` / `cream` com borda `green`/`amber`.
- Não fundir os textos numa lista única de bullets.

```powershell
function Add-TwoColumn(
  $slide,
  [string]$leftTitle, [string]$leftBody,
  [string]$rightTitle, [string]$rightBody,
  [double]$top = 100, [double]$h = 320,
  [int]$green = 5864522, [int]$cream = 15594485, [int]$ink = 3095086, [int]$lg = 14345432
) {
  foreach ($side in @(
    @{ L = 50.4; title = $leftTitle; body = $leftBody; fill = $lg },
    @{ L = 500.0; title = $rightTitle; body = $rightBody; fill = $cream }
  )) {
    $box = $slide.Shapes.AddShape(5, $side.L, $top, 410, $h)
    $box.Adjustments.Item(1) = 0.06
    $box.Fill.Solid(); $box.Fill.ForeColor.RGB = $side.fill
    $box.Line.ForeColor.RGB = $green; $box.Line.Weight = 1.25
    $tf = $box.TextFrame
    $tf.MarginLeft = 14; $tf.MarginRight = 12; $tf.MarginTop = 12; $tf.MarginBottom = 10
    $tf.TextRange.Text = "$($side.title)`r`r$($side.body)"
    $tf.TextRange.Font.Name = "DejaVu Sans"
    $tf.TextRange.Font.Size = 14
    $tf.TextRange.Font.Color.RGB = $ink
    $tf.TextRange.Paragraphs(1).Font.Name = "DejaVu Serif"
    $tf.TextRange.Paragraphs(1).Font.Bold = $true
    $tf.TextRange.Paragraphs(1).Font.Size = 16
    $tf.TextRange.Paragraphs(1).Font.Color.RGB = $green
  }
}
```

---

## Classificação automática (restilizar deck)

Ordem de decisão ao ler o slide original:

1. `Type=19` → `table` (+ notas de textboxes abaixo da tabela).
2. ≥2 setas e ≥3 retângulos alinhados → `process`.
3. Dois blocos de texto com Left distintos (~45 vs ~494) e Width ~420 → `columns`.
4. Mono / `├──` / `claude ` / `{` JSON → `codebox` (preservar comentários).
5. Fundo verde + título grande central → `section` / `cover`.
6. Caso contrário → `bullets` / `statement` / `figure` / `cards` conforme densidade.

**Paridade de conteúdo (QA):** contar células, steps, linhas de código e bullets do original vs FIT; diferença > 0 = falha.

---

## Mapa de tipos no deck Fechamento PT (34 slides)

| Slides | Tipo |
| --- | --- |
| 1 | cover |
| 2, 4, 20, 33 | statement (rust) |
| 3 | cards |
| 5, 7, 8, 19, 27, 30 | figure |
| 6, 10, 18, 22, 26, 34 | section / close |
| 9, 11–12, 14–17, 23–24 | bullets-4 |
| 13, 21, 25, 28–29, 31–32 | bullets-5 |

---

## Spec JSON (padrão do build)

Cada entrada em `_fechamento_spec.json`:

```json
{
  "src": 2,
  "title": "Título do slide",
  "bullets": ["…", "…"],
  "set": { "TextBox 3": "Subtítulo nomeado" },
  "refs": "Autor Ano Journal · DOI curto",
  "notes": "Fala do apresentador…\n\nREFERÊNCIAS:\n…",
  "keepRefNotes": true,
  "diagram": "coverage",
  "cards": [{ "header": "…", "items": ["…"] }],
  "code": {
    "lang": "shell",
    "variant": "code-full",
    "lines": [
      "# Windows PowerShell",
      "irm https://claude.ai/install.ps1 | iex",
      "claude --version"
    ]
  },
  "table": {
    "monoCols": [1],
    "headers": ["Comando", "Efeito", "Quando"],
    "rows": [["/clear", "…", "…"]]
  },
  "process": {
    "steps": [
      { "title": "Pedido", "sub": "prompt + contexto da pasta" }
    ],
    "bullets": ["…"]
  },
  "columns": {
    "left": { "title": "…", "body": "…" },
    "right": { "title": "…", "body": "…" }
  }
}
```

- `src`: índice 1-based do slide a duplicar no template (para codebox/table/process, preferir figura / src 3).
- `title`: textbox com `Top < 60` (maior font).
- `bullets`: um string por oval/caixa; count deve bater com o template; em `code-after-bullets` usar só 1–2.
- `set`: grava pelo **Name** da forma (`TextBox 2`, etc.) — usar na capa/seção.
- `refs`: textbox com `Top > 470`.
- `diagram: "coverage"`: remove pictures e desenha os 4 cards.
- `code`: se presente, remove pictures na área útil e chama `Add-CodeBox`.
  - `lang`: `shell` | `tree` | `json` | `yaml` | `r` | `path` | `text` (só documentação; não muda a cor).
  - `variant`: `code-full` | `code-after-bullets` | `code-compact` (escolhe geometria da tabela acima).
  - `lines`: array de strings (uma linha visual cada); alternativa aceitável: uma string com `\n`.
  - **Não remover** linhas de comentário `#` / `//` do original.
- `table` / `process` / `columns`: mutuamente exclusivos com achatar em `bullets`; ver §§9–11.

---

## PowerShell COM — esqueleto mínimo

```powershell
$ppt = New-Object -ComObject PowerPoint.Application
$pres = $ppt.Presentations.Open($templatePath, -1, 0, 0)
$slide = $pres.Slides.Item($src).Duplicate().Item(1)
$slide.MoveTo($pres.Slides.Count)
# editar TextFrame.TextRange.Text nas formas
$pres.SaveAs($outPath)
# export preview:
# $slide.Export("$previewDir\s01.png", "PNG", 1280, 720)
$pres.Close(); $ppt.Quit()
```

Converter hex → COM: `R + (G * 256) + (B * 65536)`.

---

## Checklist de QA visual

- [ ] 960×540; sem master genérico “Title Slide” Office
- [ ] DejaVu Serif nos títulos; DejaVu Sans no resto; mono no code box / coluna de comando
- [ ] Statement = ferrugem; conteúdo/figura = verde na barra/título
- [ ] Seção = fundo verde + traço âmbar
- [ ] Código / árvore / path em code box (fundo ink + faixa âmbar), não em bullet; comentários preservados
- [ ] Árvore: coluna de notas alinhada (`Format-TreeLines`)
- [ ] Tabelas originais → tabela FIT 796 (não bullets com `|`); todas as células
- [ ] Fluxos caixas+setas → process com setas; prosa abaixo intacta
- [ ] Duas colunas originais → duas colunas FIT 796
- [ ] Paridade de conteúdo vs original (sem reticências por falta de slot)
- [ ] Code box sem overlap com título/subtítulo/bullets/refs (gap ≥ 10 pt; Resolve-CodeBoxLayout)
- [ ] Rodapé de refs presente em todo slide de conteúdo
- [ ] Título sem quebra indesejada; bullets e code box sem overflow
- [ ] Preview PNG 1280×720 revisado slide a slide


## 12. Restyle 1:1 verbatim

Usar quando o pedido é "formatar/restilizar o deck X no layout FIT 796". Referência: `04. Inteligência Artificial e os Dados_Eder/_build_dados_fit796_v2.ps1`.

**Leitura do original (por slide):** `Text 0` = título; `rodape` = navegação; `Shape.HasTable` = tabela (todas as células); `seta-*` = setas; `ret-*` sem texto = contêiner; `texto-*` = textos (texto, fonte, L/T/W/H); notas do apresentador.

**Classificação:**

| Condição | Tipo |
| --- | --- |
| slide 1 | capa (template 1): título, subtítulo, meta, "Fio condutor" na faixa creme (Sans 14) |
| título com Top > 150 e texto `BLOCO n` | seção (template 6): título + `BLOCO n · duração · rodape` |
| existe `seta-*` | process: rets ordenados por Left → caixas; texto entre duas caixas → rótulo da seta |
| ≥ 4 rets com ≥ 2 textos dentro | grade de caixas (linha/coluna pelo Top/Left do original) |
| caso geral | fluxo de elementos (abaixo) em 1 ou 2 colunas |

**Elementos do fluxo:** texto dentro de ret → `callout` (fonte Calibri) ou `code` (outra fonte); texto com Top ≥ 470 e citação (`(2018)`, `et al.`, `doi:`) → refs; tabela → `table`; demais → `text` (≥ 2 parágrafos = bullets; 1 = texto corrido; 1 linha H ≤ 32 seguida de outro bloco = `lead`). Ordenar por Top, Left. Colunas: Left > 470 → direita (x 491, w 418); Left ≤ 470 e W < 500 → esquerda (x 50, w 418); W ≥ 500 → largura total (x 50, w 859).

**Níveis tipográficos (tenta do maior para o menor até `bottom ≤ 472`):**

| Nível | Texto/bullets/callout | Tabela | Código (mono) |
| --- | --- | --- | --- |
| −2 | 20 | 17 | 15 |
| 0 | 18 | 15 | 13 |
| 4 | **14 (piso)** | **14 (piso)** | 11 (piso) |

Código: começa no tamanho do nível e reduz 0,5 até a linha mais longa caber sem quebra (`WordWrap` off, `BoundWidth`); só ativa wrap abaixo de 11 pt. Comentários `--`/`#` e notas da árvore (após ≥ 3 espaços) em `lightGreen`; `##` (Markdown) em `amber` bold.

**Processo:** caixas rounded na paleta cíclica (green/lightGreen/amber/rust), título bold + subtítulos (≥ 14; título pode descer a 12 só se a palavra não couber na caixa), alturas equalizadas, seta âmbar (AutoShape 33) centrada. Com rótulos: gap 118 pt, rótulo Sans bold verde 14 centrado acima da seta.

**Bullets:** `ParagraphFormat.Bullet` (char 8226, cor `amber`, `UseTextColor = 0`), `Ruler.Levels(1)`: FirstMargin 0 / LeftMargin 20; com ≥ 2 parágrafos, `SpaceBefore = 6` e `SpaceAfter = 6` em cada um; `SpaceWithin` 0.92; checklists (`☐`) sem marcador extra.

**Destaque inline:** ler `TextRange.Runs()`. Run mono (Courier/Consolas) no meio da prosa, do título, do callout ou célula inteira → fonte mono, bold, cor `rust` (comandos SQL e nomes de arquivo/pasta). Run bold da fonte do corpo → bold + `green`. Run itálico → itálico. Número de seção no título (`2.3`) não vira token. Code box não usa esta regra (o painel já é mono; comentário segue `lightGreen`).

**Altura:** depois de preencher, `AutoSize = 0` e `Height = TextRange.BoundHeight + margens` (mais previsível que AutoSize com WordWrap off). Próximo elemento: `Top = bottom anterior + 12`.

**QA de paridade:** `Get-Words` (regex `[\p{L}\p{N}_]{3,}`, minúsculas) do original vs. slide novo (textos + células); log por slide e `missingWords` total — tem de ser **0**. Salvar o .ps1 em **UTF-8 com BOM** (PowerShell 5.1 lê sem BOM como ANSI → `·` vira `Â·`).