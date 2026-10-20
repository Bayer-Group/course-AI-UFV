# Plano da análise

Cada etapa: um script em `R/`, um teste em `tests/`, um relatório em `docs/etapas/NN.md`
e um commit. Não comece uma etapa sem a anterior verificada.

| Etapa | Script | Entrega | Critério de aceitação | Status |
|---|---|---|---|---|
| 01 | `R/01_importar.R` | `data/intermediario/01_importado.rds` | Número de linhas e de parcelas por ambiente reportados e conferidos fora do agente; tipos conforme o dicionário | ☐ |
| 02 | `R/02_qc.R` | `output/02_qc_relatorio.csv` (tipo, parcela_id, valor, regra) | Conta, por tipo, IDs fora do padrão, duplicatas por posição e valores fora do intervalo; teste com erros injetados em `tests/` acha 100% deles | ☐ |
| 03 | `R/03_curar.R` | `docs/registro_de_correcoes.csv`, `data/processado/03_curado.rds` | Toda alteração está no registro; IDs no padrão; sem duplicatas; nenhum valor fora do intervalo; número final de parcelas, de ausentes e de genótipos reportado | ☐ |
| 04 | `R/04_analise.R` | `output/04_individual.csv`, `output/04_conjunta_blups.csv` | Por ambiente: média, CV, h² de médias; conjunta: componentes de variância e ranking das DH25; valores geneticamente plausíveis (0 ≤ h² ≤ 1, variâncias ≥ 0) | ☐ |
| 05 | `R/05_figuras_tabelas.R` | `output/` (tabelas e figuras) | Regeneráveis do zero, rodando os scripts na ordem | ☐ |

## Detalhes por etapa

### 01 Importar
- Ler `data/bruto/vcu_milho_2025_campo.csv` sem alterar o arquivo.
- Conferir colunas e tipos contra `docs/dicionario_de_dados.csv`.

### 02 QC (só relata, não corrige)
- IDs fora do padrão do dicionário (regex em `config/parametros.yaml`).
- Duplicatas por (ensaio_id, linha, coluna), depois de normalizar IDs.
- PROD fora do intervalo do dicionário.
- O plano deve dizer quantos casos de cada tipo espera e como os contou.

### 03 Curar
- Normalizar IDs; manter uma ocorrência por posição duplicada; PROD fora do intervalo vira NA.
- Cada alteração vira uma linha em `docs/registro_de_correcoes.csv`.

### 04 Análise individual e conjunta
- Modelos e fórmula de h² conforme o `CLAUDE.md`.
- Ranking só das DH25; testemunhas DH24 entram no modelo.

### 05 Figuras e tabelas
- Tabela de precisão por ambiente; ranking das DH25; gráfico de BLUPs.
