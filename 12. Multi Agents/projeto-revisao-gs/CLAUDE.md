# Mini-revisão multi-agente — evolução da seleção genômica

Demonstração didática (sessão 12). Não é paper para submissão.

## Missão

Esboço curto (600–900 palavras na aula; estrutura mental de ≤ 4 páginas) sobre a **evolução da seleção genômica**, conforme `MISSAO.md`. Use só a lista em `referencias/README.md` para citações nominais.

## Papéis

- **Aluno = escritor**: dirige o agente `escritor`, lê o orientador e **só o aluno** autoriza envio ao painel (registrar em `docs/decisoes.md`).
- **orientador**: lê com contexto limpo; **não edita** o rascunho; entrega Bloqueantes / Sugestões.
- **revisor-gq**, **revisor-melhoramento**, **revisor-molecular**: só entram depois do `sim` do aluno; cada um devolve veredito `APROVADO` ou `REPROVADO`.

## Pastas

- `docs/rascunhos/` — texto do escritor (`rodada_1.md`, …)
- `docs/pareceres_orientador/` — pareceres pré-painel
- `docs/pareceres_revisores/` — vereditos do painel (`rodada_N_gq.md`, etc.)
- `docs/decisoes.md` — gate humano (enviar / reescrever) com data e rodada
- `referencias/` — lista fechada; não inventar fontes fora dela

## Regras científicas e de citação

- Proibido inventar DOI, ano, volume, páginas ou título.
- Citação da lista → rotular `[LISTA]`.
- Generalização sem item da lista → `[CONHECIMENTO GERAL]`.
- Conclusão deduzida do texto → `[INFERÊNCIA]`.
- Citação inventada ou DOI falso = **bloqueante** para orientador e revisores.

## Veredito do painel

- Cada revisor: `APROVADO` ou `REPROVADO` + bloqueantes (se houver).
- Comitê aprova se ≥ 2 de 3 `APROVADO`.
- Máximo 3 rodadas. Se a 3ª não passar: encerrar como “versão final com ressalvas”.

## Forma de trabalho

- Uma rodada por vez. Não pule o orientador.
- Não chame os três revisores sem linha de autorização em `docs/decisoes.md`.
- Não faça commit sem pedido explícito.
- Não abra nem use o PPTX da pasta pai como fonte da missão.
