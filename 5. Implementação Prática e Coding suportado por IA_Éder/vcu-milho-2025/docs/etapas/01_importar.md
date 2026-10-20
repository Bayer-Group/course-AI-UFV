# Etapa 01 — Importar

**Data:** 2026-10-20  
**Script:** `R/01_importar.R`  
**Teste:** `tests/01_test_importar.R`  
**Saída:** `data/intermediario/01_importado.rds`

## Comandos e saída

```
Rscript R/01_importar.R
```
```
Colunas: parcela_id, ensaio_id, ambiente_id, germoplasma_nome, bloco, linha, coluna, PROD, data_coleta
Total de parcelas: 2426

PGO_2025_V SLG_2025_V UDI_2025_V
       809        809        808
```

```
Rscript tests/01_test_importar.R
```
```
01: OK
```

## Números-chave

| Métrica | Valor |
|---|---|
| Total de parcelas | 2426 |
| PGO_2025_V | 809 |
| SLG_2025_V | 809 |
| UDI_2025_V | 808 |
| Colunas | 9 |

## Decisões

- nrow real = 2426; spec indicava 2425. Contagem direta do CSV prevalece (registrado em `docs/decisoes.md`).

## Pendências

- Verificar com o responsável pelo ensaio se UDI_2025_V ter 808 parcelas (vs. 809 nos outros dois) é esperado ou indica uma parcela perdida.
