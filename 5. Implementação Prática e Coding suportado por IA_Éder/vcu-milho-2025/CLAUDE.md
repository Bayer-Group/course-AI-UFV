# VCU milho 2025: ranking de linhagens DH25 (testcross)

## Pergunta
Ranking das linhagens DH25 por valor de testcross para PROD (kg/ha) nos três
ambientes de 2025 (UDI, SLG, PGO), com a precisão de cada ensaio (CV e h² de médias).

## Dados
- data/bruto/ é SOMENTE LEITURA. Nunca edite, mova ou sobrescreva arquivos ali.
- Correções só via docs/registro_de_correcoes.csv, aplicadas por R/03_curar.R.
- Dicionário em docs/dicionario_de_dados.csv: unidades, intervalos válidos e padrão de IDs.
- Parâmetros (intervalos, regex, caminhos, número de blocos) em config/parametros.yaml.
  Não escreva esses valores diretamente nos scripts.
- Saídas intermediárias em data/intermediario/, dados curados em data/processado/,
  tabelas e figuras em output/.

## Regras de análise
- Dados de parcela, nunca médias.
- Normalize os IDs (maiúsculas, sem espaços, separador `_`) ANTES de checar
  duplicatas e contar genótipos.
- Duplicata = mesma (ensaio_id, linha, coluna). Mantenha uma ocorrência e registre.
- Valor fora do intervalo do dicionário vira NA, com registro em
  docs/registro_de_correcoes.csv. Não converta unidades sem evidência.
- Outlier estatístico não é erro: sinalize, não remova.
- Análise individual: PROD ~ bloco + (1|genotipo), por ambiente.
- Modelo conjunto: PROD ~ ambiente + (1|ambiente:bloco) + (1|genotipo) + (1|genotipo:ambiente).
- h² de médias por ambiente: s2g / (s2g + s2e/r), r = número de blocos.
- Testemunhas DH24_* entram no modelo; o ranking final é só das DH25_*.

## Forma de trabalho
- Plano antes de código. Uma etapa do PLANO.md por vez.
- Cada script em R/ com cabeçalho (entradas, saídas, premissas) e teste em tests/.
- Rode com `Rscript`, da raiz do projeto. Pacotes: base R, lme4, yaml.
- Ao relatar, mostre o comando executado e a saída; não apenas "pronto".
- Ao fim de cada etapa, relatório em docs/etapas/ (skill /relatorio-etapa).
- Decisões novas vão para docs/decisoes.md antes de virar código.
- Não faça commit sem pedido explícito.
