# Checklist: o plano está bom?

Marque cada item antes de aprovar. Um item sem marca vira comentário no plano.

| ☐ | Pergunta | Sinal de plano fraco |
|---|---|---|
| ☐ | Responde à pergunta do README e diz o que fica fora? | Escopo aberto, "e outras análises" |
| ☐ | Nomeia arquivos lidos e gravados? | "Vou processar os dados" |
| ☐ | Explicita as decisões científicas? | "Vou ajustar o modelo adequado" |
| ☐ | Bate com `CLAUDE.md`, dicionário e `docs/decisoes.md`? | Contradiz uma regra escrita |
| ☐ | Diz como saber que está certo **antes** de rodar? | Nenhum teste, nenhum número esperado |
| ☐ | Passos pequenos e verificáveis? | Uma etapa que faz tudo |
| ☐ | Lista premissas e perguntas em aberto? | Decide em silêncio |
| ☐ | Usa funções que existem e parâmetros do YAML? | Pacote inventado, número fixo no código |

## Armadilhas comuns neste projeto
- Remover outliers por desvio-padrão (outlier não é erro).
- Converter valores "em t/ha" multiplicando por 1.000 (é palpite).
- Normalizar IDs **depois** de verificar duplicatas.
- Gravar o arquivo corrigido em `data/bruto/`.
- Analisar médias por genótipo em vez de dados de parcela.
