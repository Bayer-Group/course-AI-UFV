# Dados brutos do ensaio (somente leitura)

| Arquivo | Origem | Recebido em | Observações |
|---|---|---|---|
| `vcu_milho_2025_campo.csv` | Camada bruta do projeto `ciclo-gs-milho` (dados **simulados**), safra 2025 | 2026-03-15 | 2.426 linhas, 3 ambientes, 9 colunas |
| `docs/dicionario_de_dados.csv` | Dicionário de variáveis do ensaio | — | Unidades, intervalos válidos e padrão de identificadores |

## O ensaio

- Linhagens duplo-haploides (DH) do grupo heterótico A, avaliadas em **testcross** com
  um testador do grupo B: o fenótipo é o do híbrido.
- 400 linhagens da coorte 2025 (`DH25_*`) e 4 testemunhas da coorte 2024 (`DH24_*`).
- 3 ambientes (Uberlândia, Sete Lagoas e Ponta Grossa), blocos casualizados com 2 blocos.
- Variável: produtividade de grãos (`PROD`, kg/ha).

## Atenção

O arquivo é o que **chegou do campo**: contém erros de digitação, como em qualquer
ensaio real. Ele fica em `data/bruto/` e **nunca** é editado; correções vão para
`docs/registro_de_correcoes.csv`.
Encontrar e tratar esses erros é parte do exercício.
