# VCU milho 2025

Análise do ensaio de VCU de milho da safra 2025: linhagens duplo-haploides (DH) do
grupo heterótico A avaliadas em testcross, em 3 ambientes (Uberlândia, Sete Lagoas e
Ponta Grossa), blocos casualizados com 2 blocos. Dados **simulados**.

## Pergunta
Qual o ranking das linhagens DH25 por valor de testcross para produtividade de grãos
(PROD, kg/ha) e qual a precisão de cada ensaio (CV e h² de médias)?

## Estrutura

| Pasta/arquivo | Conteúdo |
|---|---|
| `CLAUDE.md` | Contexto e regras para o agente |
| `PLANO.md` | Etapas da análise e critérios de aceitação |
| `config/parametros.yaml` | Intervalos, regex de IDs, caminhos |
| `data/bruto/` | Dado do campo (somente leitura) e `LEIA-ME.md` |
| `data/intermediario/`, `data/processado/` | Gerados pelos scripts (fora do Git) |
| `docs/` | Dicionário, registro de correções, decisões, checklists, relatórios de etapa e pareceres |
| `R/` | Scripts numerados, um por etapa |
| `tests/` | Testes de cada etapa |
| `output/` | Tabelas e figuras (geradas) |
| `.claude/` | Permissões, subagentes e skills do projeto |

## Como reproduzir

Requisitos: R ≥ 4.3 com `lme4` e `yaml`. Da raiz do projeto:

```bash
Rscript R/01_importar.R
Rscript R/02_qc.R
Rscript R/03_curar.R
Rscript R/04_analise.R
Rscript R/05_figuras_tabelas.R
```

Teste do clone limpo: clone a pasta em outro diretório, rode os scripts na ordem e
confira que os números-chave são os mesmos.
