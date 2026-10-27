# Roteiro — Sessão 11 (versão aprofundada)

O deck `11_tendencias_futuras.pptx` tem 83 slides. O argumento, os números e as fontes estão nas **notas do apresentador**. O texto longo, com tabelas e DOI, está em `dossie/`.

Não leia as notas na íntegra. Use-as quando alguém pedir o número ou a ressalva.

## Ordem

| Bloco | Slides (aprox.) | Dossiê | Não cortar |
| --- | --- | --- | --- |
| Abertura | 1–4 | — | O mapa já visto → tendência |
| 1. Foundation models | 5–18 | [dossie/01_foundation_models.md](dossie/01_foundation_models.md) | PlantCaduceus; o veredito honesto (Yang 2017 ganha, Ramstein & Buckler 2022 não) |
| 2. Moléculas, peptídeos, events | 19–32 | [dossie/02_moleculas_peptideos_events.md](dossie/02_moleculas_peptideos_events.md) | O paradoxo US$ 115 mi / 16,5 anos; MTI de Peng |
| 3. IA + edição | 33–46 | [dossie/03_ia_edicao_genica.md](dossie/03_ia_edicao_genica.md) | PAGE (1,08×–4,12×) e o quadro editar vs selecionar |
| Intervalo | 47 | — | — |
| 4. Plataforma e twin | 48–62 | [dossie/04_plataforma_tempo_real_digital_twin.md](dossie/04_plataforma_tempo_real_digital_twin.md) | Kritzinger (modelo ≠ twin); rG ≈ 0 no CGM-WGP; enviromics |
| 5. Ética, IP, agentes | 63–78 | [dossie/05_breeder_aumentado_etica_ip.md](dossie/05_breeder_aumentado_etica_ip.md) | Chat-RGIE 0,91 → 0,64; SisGen antes de publicar; dilemas |
| Fechamento | 79–83 | [roteiro_qa.md](roteiro_qa.md) | As seis perguntas do checklist |

A numeração acima é a ordem de montagem. Confira o título no modo apresentador se um bloco tiver sido editado.

## Se o tempo apertar

Corte slides do meio de cada bloco. Mantenha, em cada um, a capa, o slide marcado acima e o take-home.

Números marcados “a verificar” nas notas não vão para o quadro. Exemplos: tempo de ciclo citado em material institucional da Bayer; contagem atualizada de produtos não-OGM na CTNBio; espécie exata da aranha do peptídeo Spear.

## Regenerar o deck

Edite o JSON do bloco em `_slides_parts/` e rode `_build_pptx.ps1`. O script junta os JSON em ordem de nome e grava notas no PPTX.
