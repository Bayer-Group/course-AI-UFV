---
name: fit796-slide-layout
description: >-
  Aplica o layout visual padrão dos decks FIT 796 (UFV × Bayer × IDATA): widescreen
  16:9, paleta terra (verde/creme/ferrugem/âmbar), fontes DejaVu Serif/Sans, tipos
  capa/seção/bullets/figura/statement/cards/codebox/table/process/columns. Use ao
  criar, regenerar, clonar ou estilizar PowerPoint (.pptx) do curso; quando o slide
  original tiver tabela, fluxo com caixas/setas, duas colunas, código, árvore de
  pastas ou paths; ou quando o usuário citar o deck AI_Plant_Breeding_Fechamento_2026_PT,
  o layout FIT 796, ou “mesmo estilo dos slides”. Nunca achatar tabela/fluxo/colunas
  em bullets nem suprimir comentários ou linhas de conteúdo.
---

# FIT 796 — layout de slides

Padrão extraído do deck canônico
`14. Tendências Futuras, Perguntas e Fechamento_Todos/Review/artifacts/AI_Plant_Breeding_Fechamento_2026_PT.pptx`
(clonado do template inglês `AI_Plant_Breeding_Future_2026.pptx` via `_build_fechamento.ps1`).

Detalhes de geometria, tokens COM e checklists: [reference.md](reference.md).

## Método obrigatório (reproduzir o padrão)

**Não redesenhar do zero** se o template existir. O estilo (cores, fontes, barras, ovais, rodapé) vive nas formas dos slides-fonte.

1. Abrir o deck template com PowerPoint COM (Windows).
2. Para cada slide novo: `Duplicate()` de um slide-fonte do tipo certo → mover para o fim → trocar textos → ajustar `Font.Size` se houver overflow.
3. Apagar os slides originais só depois de terminar; salvar com outro nome.
4. Referência de implementação: `Review/artifacts/_build_fechamento.ps1` + `_fechamento_spec.json`.

Slide-fonte tipico no template inglês (índices 1-based do Future_2026; confirmar se o arquivo mudar):

| Tipo | src típico | Quando usar |
| --- | --- | --- |
| Capa | 1 | Título da sessão |
| Statement / destaque (4 bullets, acento ferrugem, título 40 pt) | 2 | Abertura impactante, fechamento “sua vez” |
| Figura + subtítulo | 3 | Diagrama / imagem |
| Seção | 5 | Divisor de parte |
| Bullets conteúdo (4) | 9 / 12 / … | Conteúdo padrão |
| Bullets conteúdo (5) | slides com 5 ovais | Listas mais densas |
| Code box (código / pasta) | clonar figura ou bullets + `Add-CodeBox` | Comandos, JSON/YAML, árvore de pastas, paths |
| Tabela | clonar figura/bullets + `Add-Fit796Table` | Comparações, roteiros, comandos × efeito |
| Processo (caixas + setas) | clonar figura + `Add-ProcessFlow` | Ciclos encadeados (N etapas + setas) |
| Duas colunas | clonar figura + `Add-TwoColumn` | Contraste lado a lado (plano × comentário, etc.) |

Se o template não estiver disponível, construir com as medidas de [reference.md](reference.md) — mesmas fontes, cores e geometria.

## Preservar estrutura do original (obrigatório)

Ao restilizar um deck existente, **detectar a estrutura do slide-fonte** e mapear para o tipo FIT 796 correspondente. Melhorar cores/tipografia/organização — **nunca** achatar nem omitir conteúdo.

| Se o original tem… | Tipo FIT 796 | Anti-padrão |
| --- | --- | --- |
| `Shape.Type = 19` (Table) | **table** — `Add-Fit796Table` com todas as células | Virar bullets com `\|` ou texto truncado |
| Retângulos + setas (`seta-*` / AutoShape seta) em sequência | **process** — caixas + setas + prosa abaixo | Virar 4 cards ou bullets sem setas |
| Duas regiões de texto lado a lado (Left ~45 e ~494) | **columns** — manter 2 colunas | Fundir numa lista única |
| Várias caixas rotuladas (mapa / camadas) | **process** ou **cards** conforme o original | Uma lista de bullets |
| Código / árvore / path (mono, `#` comentários, `├──`) | **codebox** — manter **comentários e todas as linhas** | Tirar `# …` ou enxugar a árvore |
| Árvore de pastas | **codebox** `lang: tree` — preferir **2 colunas** (path \| nota) dentro do painel ink; `WordWrap` off na coluna path; ou `Format-TreeLines` + mono | Espaços irregulares / wrap / fundir path+nota |

**Regra de ouro — não suprimir conteúdo:** cada célula, bullet, comentário de código (`# …`), linha da árvore, caixa do fluxo e nota de rodapé do original deve reaparecer no slide FIT 796 (legível; pode reduzir fonte, não cortar texto com reticências por falta de slot).

### Restilizar ≠ reescrever (obrigatório)

O trabalho é **estilo e formatação**, nunca conteúdo. Ao restilizar um deck existente:

1. **Texto verbatim:** ler o texto direto do PPTX original (shape a shape) — **não** usar spec parafraseada/resumida. Mesmas palavras, mesma ordem, mesmo número de parágrafos.
2. **Mapeamento 1:1:** slide *n* do original → slide *n* do FIT 796 (sem fundir, dividir, pular ou acrescentar slides).
3. **Cada elemento do original tem destino FIT 796:**

| Elemento no original | Destino FIT 796 |
| --- | --- |
| Caixa de texto com ≥ 2 parágrafos (prosa sob fluxo/tabela, lista) | **bullets formatados** (marcador âmbar, Sans ≥ 14 pt), 1 bullet por parágrafo |
| Parágrafo único | texto corrido Sans ≥ 14 pt |
| Linha curta (1 parágrafo, H ≤ 32) seguida de outro bloco | **cabeçalho/lead** (Sans bold verde) — ex.: cabeçalho de coluna “O que a IA precisa para acertar” |
| Retângulo com texto Calibri (destaque/citação) | **callout**: caixa `lightGreen` + barra `rust` à esquerda, texto bold ≥ 14 |
| Retângulo com texto mono/sem fonte (código, SQL, CSV, JSON, árvore) | **code box** com **todas** as linhas e comentários |
| Tabela nativa | **tabela** FIT 796 (todas as células, ≥ 14 pt) — inclusive quando divide o slide com código (código **e** tabela) |
| Retângulos + `seta-*` | **process**: caixas (título bold + subtítulos) + setas âmbar; **rótulo de seta** (texto entre duas caixas) desenhado **sobre a seta** |
| ≥ 4 retângulos com cabeçalho + itens (modelo relacional) | **grade de caixas** (mesma linha/coluna do original), cabeçalho mono bold + itens |
| Duas regiões (Left < 470 e Left > 470) | **columns**: cada coluna mantém cabeçalho + bullets + callout próprios |
| Texto no rodapé com citação (autor/ano/doi) | rodapé de refs; nota **sem** citação no rodapé original → corpo do slide (≥ 14) |
| `rodape` de navegação (ex. “SEÇÃO 1 · BLOCO 2”) | rodapé de refs (conteúdo) / subtítulo da seção |
| Notas do apresentador | copiar para as notas do slide FIT 796 |

4. **QA de paridade obrigatório:** para cada slide, extrair as palavras (≥ 3 letras) do original (título, textos, células, rodapé) e verificar que **todas** aparecem no slide FIT 796. Relatório com `missingWords = 0` antes de entregar; qualquer palavra faltando é bug do build, não “simplificação”.
5. **Ajuste por fonte, não por corte:** se não couber, descer o nível tipográfico (texto 20 → 14, tabela 17 → 14, código 15 → 11) e redistribuir a área; nunca remover parágrafo, célula, linha ou rótulo.

Implementação de referência (genérica, detecta estrutura e mantém texto verbatim): `04. Inteligência Artificial e os Dados_Eder/_build_dados_fit796_v2.ps1` — ver [reference.md §12](reference.md#12-restyle-11-verbatim).

Detalhe COM e helpers: [reference.md](reference.md#9-tabela--table), [§10 processo](reference.md#10-processo-caixas--setas--process), [§11 colunas](reference.md#11-duas-colunas--columns), [§ árvore](reference.md#árvore-de-pastas-lang-tree).

## Canvas e tipografia

| Item | Valor |
| --- | --- |
| Tamanho | **960 × 540 pt** (16:9; EMU 12192000 × 6858000) |
| Título / display | **DejaVu Serif**, bold |
| Corpo / subtítulo / refs | **DejaVu Sans** |
| Fundo conteúdo | `#F5F3ED` (creme) |
| Fundo capa / seção | `#4A7C59` (verde) |

Paleta completa e inteiros RGB do COM: [reference.md](reference.md#paleta).

## Tipos de slide (resumo)

1. **Capa** — fundo verde; título branco Serif ~50 pt; subtítulo `#D8E4DA` Sans 19; faixa creme inferior com meta (curso/data) verde bold 17 + linha de evidência cinza 12.
2. **Seção** — fundo verde; título branco Serif 44; subtítulo `#D8E4DA` Sans 22; traço âmbar `#F9A620` 158×4 pt sob o título.
3. **Statement** — creme; barra superior ferrugem `#B7472A` 11,5 pt; título Serif **40** ferrugem; **4** bullets (oval + caixa); refs no rodapé.
4. **Bullets (conteúdo)** — creme; barra verde; título Serif **32** verde; 4 ou 5 bullets (**fonte ~19–21 pt**, entrelinha apertada); refs.
5. **Figura** — creme; barra verde; título 32 + subtítulo Sans 16 `#6B6B6B`; imagem na área útil; refs.
6. **Cards** — como figura, sem picture: 4 rounded rects na paleta (verde / verde-claro / âmbar / ferrugem).
7. **Code box** — painel escuro (`ink`) com texto mono claro para **código, comando ou árvore de pastas**; nunca como bullet comum; **preservar comentários**. Detalhe: [reference.md](reference.md#8-code-box-códigopasta--codebox).
8. **Tabela** — creme; barra verde; título 32; tabela nativa PPT com cabeçalho `green`/`white`, corpo `cream`/`ink`, 1ª coluna mono se for comando/path; **células ≥ 14 pt** (cabeçalho e corpo); notas sob a tabela; refs. Nunca achatar em bullets.
9. **Processo** — creme; barra verde; título 32; N caixas (rounded) + setas âmbar na ordem do original; prosa/bullets abaixo; refs.
10. **Duas colunas** — creme; barra verde; título 32; painéis esquerdo/direito (ou texto + caixa); refs.
11. **Fechamento** — como seção; título curto (ex. “Obrigado”); traço âmbar; subtítulo opcional.

## Code box — quando e como

Se o slide **original** mostra pasta de trabalho, árvore de arquivos, comando de shell, snippet (R/JSON/YAML/Markdown) ou path (`~/…`, `.claude/`, `data/bruto/`), **não** converter isso em bullet de conteúdo.

1. Clonar slide **figura** (área livre) ou **bullets** (manter 0–2 bullets curtos acima).
2. Remover picture / ovais sobrantes na área do painel.
3. Desenhar o painel com `Add-CodeBox` (reference): fundo `ink` `#2E3A2F`, texto `cream`/`lightGreen`, faixa esquerda `amber`, fonte **DejaVu Sans Mono** (fallback Consolas).
4. Spec: campo `code` (`lang` + `lines` ou string multilinha). Variantes: `shell` | `tree` | `json` | `r` | `path`.
5. **Anti-overlap obrigatório** antes de `Add-CodeBox`: ajustar Top/Height com `Resolve-CodeBoxLayout` (reference) para não invadir título/subtítulo nem o rodapé de refs.

Detecção automática (heurística de build): fonte Courier/Consolas/mono no original; linhas com `├──`/`└──`; blocos `{…}` / `curl` / `irm` / `install.packages`; paths com `/` ou `\` e extensão (`.md`, `.R`, `.json`, `.yaml`, `.csv`).

### Code box — overlap com texto

O painel **não** pode cruzar título, subtítulo, bullets nem refs. Folgas mínimas (pt):

| Zona | Regra |
| --- | --- |
| Acima | `code.Top ≥ bottom(título\|subtítulo) + 10` (alvo ~16–24) |
| Abaixo | `code.Top + Height ≤ refs.Top − 10` (refs ≈ Top 484; alvo gap ~20–24) |
| Com subtítulo (TextBox 3) | preferir `code-full` em `T≈122 H≈338` (não `T=100`) |
| `code-compact` + subtítulo | `T≈128 H≈140–150` |

No build: `Get-CodeBoxRect` → `Resolve-CodeBoxLayout $slide $rect 10` → `Add-CodeBox`. QA: varrer shapes `CodeBox` e textboxes; **0 overlaps** verticais. Implementação de referência: `08. Otimização…/_build_otimizacao_fit796.ps1`.

## Bullets — tipografia e espaçamento

Em slides com **vários** bullets (4–5), priorizar legibilidade compacta:

| Item | Valor |
| --- | --- |
| Tamanho alvo (conteúdo) | **19–21 pt** (não começar em 17) |
| Tamanho alvo (statement) | **20–21 pt** |
| Mínimo no fit | **14 pt** (conteúdo e statement) — **nunca** abaixo de 14 |
| `SpaceBefore` / `SpaceAfter` | **6 pt / 6 pt** em cada parágrafo quando a caixa tem **≥ 2 bullets** (ou ≥ 2 parágrafos). Parágrafo único: **0** |
| Entrelinha (`SpaceWithin`) | **0.90–0.95** (mais apertada que o padrão Office) |
| Margens TextFrame T/B | **~2 pt** (L/R ~7 pt) |

Depois de preencher o texto: equalizar o `Font.Size` de todos os bullets do slide ao menor que ainda cabe (**nunca < 14 pt**). `Tighten-BulletStack` só se **todos** os bullets tiverem ≤ 2 linhas após o fit (senão há sobreposição). O ganho principal vem de fonte maior + `SpaceWithin` 0.92, não de esmagar o passo vertical. Detalhe: [reference.md](reference.md#tipografia).

**Piso de legibilidade (14 pt):** aplica-se a **bullets** (conteúdo/statement) **e a todas as células de tabela** (cabeçalho e corpo). Se o fit pediria menos, manter 14 e enxugar o texto, aumentar a altura da tabela ou reduzir margens — **nunca** encolher a fonte abaixo de 14.

**Caixa com vários bullets:** `SpaceBefore = 6` e `SpaceAfter = 6` em **cada** parágrafo. Vale para a lista de bullets, o checklist e o callout com mais de um parágrafo. O espaçamento é por parágrafo (cada bullet), não por linha de quebra automática.

## Destaque inline — preservar a formatação do original

O texto verbatim inclui os **runs** do original (fonte, negrito, itálico). Não achatar tudo no estilo do corpo.

| Run no original | No slide FIT 796 |
| --- | --- |
| Fonte mono (Courier, Consolas, Mono) no meio da prosa — comando SQL (`PRIMARY KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, `REFERENCES`, `ORDER BY`) ou nome de arquivo/pasta (`CLAUDE.md`, `modelos/projeto-analise/`, `data/bruto/`, `.claude/settings.json`) | **mono + bold + ferrugem** (`rust`), mesmo tamanho do corpo |
| Negrito na fonte do corpo | **bold + verde** (`green`) |
| Itálico | itálico mantido |
| Célula de tabela inteira em fonte mono | mono + bold + ferrugem |
| Número de seção no título (`2.3`) em Courier | continua no título serif; **não** vira token |

O code box (bloco inteiro de código) não recebe esse tratamento: lá o mono é o estilo do painel, e o comentário continua em `lightGreen`. Só o trecho mono **dentro de prosa, título, callout ou célula** vira destaque.

## Regras de conteúdo (mesmo deck)

- Uma ideia por slide; título preferencialmente **uma linha** (reduzir até ~24 pt se precisar).
- Bullets: fonte maior + entrelinha menor (tabela acima); equalizar o tamanho entre bullets do mesmo slide; **mínimo absoluto 14 pt**.
- Código / árvore / path → **code box**, não bullet; **manter comentários `#`/`//` e todas as linhas**; caber no painel (mín. ~11 pt mono).
- Tabela / fluxo / duas colunas do original → mesmos tipos FIT 796; **não** converter em bullets.
- **Toda afirmação factual** leva fonte no rodapé (Sans 10, `#6B6B6B`, Top ≈ 484).
- Tags no rodapé/notas: `[preprint]`, `[empresa]`, `[notícia]` (PT) — equivalentes EN: `[company]`, `[news]`.
- Notas do apresentador: fala + bloco `REFERÊNCIAS (verificadas):` com DOI/URL quando houver.
- Não inventar número sem fonte; incerteza vai nas notas, não no slide.
- **Não truncar** células/bullets/código para “caber no tipo bullets-4/5”; escolher outro tipo ou reduzir fonte.

## Workflow ao criar / restilizar um deck

```
- [ ] Escolher template .pptx canônico
- [ ] Spec: tipo = bullets|statement|figure|cards|codebox|table|process|columns|section|cover
- [ ] Se restilizar: classificar cada slide-fonte (Table? setas+rets? 2 colunas? mono/árvore?)
- [ ] Marcar código/pasta → codebox; tabelas → table; fluxos → process; lado a lado → columns
- [ ] Clonar slide-fonte; helpers Add-Fit796Table / Add-ProcessFlow / Add-TwoColumn / Add-CodeBox
- [ ] Texto lido do PPTX original (verbatim), slide n → slide n
- [ ] Verificar paridade de conteúdo vs original (células, linhas, comentários, caixas, rótulos de seta, callouts) — `missingWords = 0`
- [ ] Fit tipográfico; code box: Resolve-CodeBoxLayout; 0 overlaps
- [ ] Árvore: Format-TreeLines (coluna de comentários alinhada)
- [ ] Export PNG 1280×720 e revisar (tabelas/fluxos/árvores legíveis)
- [ ] Manter DejaVu (Serif/Sans/Sans Mono) instalado na máquina que gera o PPTX
```

## Anti-padrões

- Calibri/Arial/Inter como fonte principal do deck
- Tema roxo/índigo ou fundo branco puro
- Cards no hero/capa; mais de ~5 bullets **quando o original não era lista**
- Achatar **tabela** em bullets (com ou sem `|`)
- Achatar **fluxo caixas+setas** em 4 cards ou bullets
- Fundir **duas colunas** numa coluna só
- Suprimir comentários de código, linhas da árvore, células ou notas para “simplificar”
- Reescrever/parafrasear/resumir o texto do original ao restilizar (usar spec própria em vez do texto do PPTX)
- Achatar negrito, itálico ou fonte mono inline (comando SQL, nome de arquivo ou pasta) para o mesmo estilo do corpo
- Caixa com vários bullets sem 6 pt antes e 6 pt depois de cada parágrafo
- Prosa sob fluxo/tabela sem formatação de bullet; cabeçalho de coluna, callout ou rótulo de seta omitidos
- Slide com código + tabela entregue só com o código (ou só a tabela)
- Entregar sem relatório de paridade (`missingWords = 0`)
- Código ou árvore de pastas como bullet de conteúdo (usar code box)
- Code box colado no subtítulo ou invadindo o rodapé de refs (sem `Resolve-CodeBoxLayout`)
- Terminal preto/neon ou syntax highlight multicolor fora da paleta terra
- Construir layout “parecido” sem clonar o template quando o arquivo existe
- Remover a barra superior ou o rodapé de referências nos slides de conteúdo
