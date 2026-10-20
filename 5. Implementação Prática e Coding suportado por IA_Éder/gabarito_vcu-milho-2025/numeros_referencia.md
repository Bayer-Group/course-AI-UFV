# Gabarito da Seção 2: VCU milho 2025

**Só para o professor.** Não copie esta pasta para dentro de `vcu-milho-2025/`: o agente
leria os números de referência e a verificação perderia o sentido.

## Como rodar

Da pasta da seção (R ≥ 4.3 com `lme4` e `yaml`):

```bash
Rscript gabarito_vcu-milho-2025/analise_referencia.R
```

O script copia `vcu-milho-2025/` para uma pasta temporária, coloca lá os scripts de
`R/` e `tests/` deste gabarito, roda o teste e as etapas 01 a 05 e imprime as tabelas
abaixo, com e sem QC. O projeto dos alunos não é alterado.

Para a acurácia, coloque em `gabarito_vcu-milho-2025/valores_verdadeiros.csv` as
colunas `germoplasma_nome, gv_testcross` exportadas do `ciclo-gs-milho` (safra 2025).

## Etapas 01 a 03 (slide 5.5)

| Verificação | Casos |
|---|---|
| Linhas no bruto | 2.426 (PGO 809, SLG 809, UDI 808) |
| IDs fora do padrão | 5 (`DH25 0138`, `dh25_0266`, `DH25-0287`, ` DH25_0279`, `dh25_0066`) |
| Duplicatas por posição | 2 (`P_PGO_2025_V_0231`, `P_SLG_2025_V_0359`; linhas idênticas) |
| Fora de 2.000–20.000 kg/ha | 7 (PGO_0113 = 104.613; SLG_0079 = 86.200; SLG_0272 = 92.241; SLG_0141 = 8,87; SLG_0497 = 9,24; SLG_0538 = 9,01; SLG_0722 = 9,21) |
| Total encontrado / injetado | 14 / 14 |
| Após a curadoria | 2.424 parcelas; 7 PROD ausentes; 404 genótipos (409 sem normalizar) |

## Etapa 04, análise individual (slide 5.6)

| Ambiente | Média (kg/ha) | CV (%) | h² de médias | CV sem QC | h² sem QC |
|---|---|---|---|---|---|
| PGO 2025 | 10.381 | 4,9 | 0,46 | 31,9 | 0,02 |
| SLG 2025 | 9.205 | 5,4 | 0,51 | 43,4 | 0,01 |
| UDI 2025 | 12.152 | 5,2 | 0,42 | 5,2 | 0,43 |

## Etapa 04, análise conjunta (slide 7.7)

| Quantidade | Com QC | Sem QC |
|---|---|---|
| Genótipos no modelo | 404 | 409 |
| Acurácia (BLUP × valor verdadeiro, 400 DH25) | 0,82 | 0,24 |
| Posição de DH25_0232 (verdadeira: 138ª) | 259ª | 1ª |

## Pontos de discussão
- 9,01 "em t/ha" × 1.000 = 9.010, mas o valor verdadeiro era 9.012,1 (P_SLG_2025_V_0538):
  a conversão é um palpite.
- UDI não tem valor fora do intervalo, por isso quase não muda sem QC.
- O ID ` DH25_0279` tem um espaço no início: invisível no editor e na planilha.
