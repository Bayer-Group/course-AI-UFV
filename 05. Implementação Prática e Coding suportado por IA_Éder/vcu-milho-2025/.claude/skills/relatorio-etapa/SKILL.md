---
name: relatorio-etapa
description: Escreve o relatório de passagem de uma etapa concluída em
  docs/etapas/. Use ao final de cada etapa, antes de /clear.
disable-model-invocation: true
---

Escreva docs/etapas/$ARGUMENTS.md com: o que foi feito; como reproduzir; números-chave;
decisões; pendências. Até 40 linhas. Não faça o commit.

Formato:

```markdown
# Etapa $ARGUMENTS

## O que foi feito
## Como reproduzir
(comandos Rscript, na ordem)
## Números-chave
## Decisões (com link para docs/decisoes.md)
## Pendências
```

Use só números que você viu na saída de um comando nesta sessão; se não viu, rode o
script ou o teste antes de escrever.
